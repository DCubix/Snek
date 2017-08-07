package br.twister.lowrez.engine;

import java.util.Iterator;
import java.util.PriorityQueue;

import kuusisto.tinysound.TinySound;

public class Engine {

	private static Input input;
	private static Display display;
	private static Renderer renderer;
	private static FPSCounter fpsCounter;
	
	private static GameState state, nextState;
	private static boolean changingStates;
	
	private static double timeStep, timeScale;

	private static PriorityQueue<WaitEvent> waitEvents;
	
	private static StartupState startupState;
	
	public static void start(EngineConfig config) {
		Engine.display = new Display(
			config.windowWidth,
			config.windowHeight,
			config.bufferWidth,
			config.bufferHeight,
			config.windowTitle
		);
		Engine.input = new Input(Engine.display);
		Engine.renderer = new Renderer(Engine.display);
		
		Engine.startupState = config.startupState;

		Engine.timeStep = 1.0f / config.frameCap;
		Engine.timeScale = 1.0f;
		Engine.fpsCounter = new FPSCounter((float) timeStep);
		Engine.waitEvents = new PriorityQueue<>();
		
		mainloop();
	}
	
	private static void mainloop() {
		double lastTime = Timing.getTime();
		double accum = 0.0;
		
		TinySound.init();
		
		if (startupState != null) {
			startupState.onPreLoad();
		}
				
		display.show();
		
		boolean canRender = false;
		while (!display.isClosed()) {
			canRender = false;
			double currentTime = Timing.getTime();
			double delta = currentTime - lastTime;
			lastTime = currentTime;
			accum += delta;
			
			while (accum >= timeStep) {
				accum -= timeStep;
				canRender = true;
				if (changingStates) {
					if (nextState != null) {
						if (state != null) {
							state.onEnd();
						}
						renderer.clear(new RGB(0, 0, 0));
						state = nextState;
						if (state != null) {
							state.onStart();
						}
					}
					changingStates = false;
				}
				if (state != null) {
					state.onUpdate((float) (timeStep * timeScale));
				}
				for (Iterator<WaitEvent> it = waitEvents.iterator(); it.hasNext(); ) {
					WaitEvent e = it.next();
					e.time -= timeStep;
					if (e.time <= 0.0f) {
						e.routine.call();
						it.remove();
					}
				}
				input.update();
			}
			
			if (canRender) {
				if (state != null && !changingStates) {
					state.onRender(renderer);
				}
				display.swapBuffers();
				fpsCounter.tick(delta);
			}
		}
		if (state != null) {
			state.onEnd();
		}
		if (startupState != null) {
			startupState.onUnLoad();
		}
		
		Scripting.freeGlobals();
		TinySound.shutdown();
		display.setVisible(false);
		System.exit(0);
	}
	
	public static void wait(float time, IRoutine routine) {
		WaitEvent e = new WaitEvent();
		e.routine = routine;
		e.time = time;
		waitEvents.add(e);
	}
	
	public static void setState(GameState state) {
		Engine.nextState = state;
		Engine.changingStates = true;
	}

	public static Display getDisplay() {
		return display;
	}
	
	public static Input getInput() {
		return input;
	}

	public static Renderer getRenderer() {
		return renderer;
	}

	public static double getTimeScale() {
		return timeScale;
	}

	protected static double getTimeStep() {
		return timeStep;
	}
	
	public static FPSCounter getFPSCounter() {
		return fpsCounter;
	}

	public static void setTimeScale(double timeScale) {
		if (timeScale >= 0.001f && timeScale <= 1.0f) {
			Engine.timeScale = timeScale;
		}
	}

}
