package br.twister.lowrez.engine;

public class FPSCounter {

	private static final int MAX_SAMPLES = 30;
	
	private float timeStep;
	private float[] fpsSamples = new float[MAX_SAMPLES];
	private int frames;
	
	public FPSCounter(float timeStep) {
		this.timeStep = timeStep;
		this.frames = 0;
	}
	
	public void tick(double delta) {
		fpsSamples[frames % MAX_SAMPLES] = 1.0f / (float) Math.max(delta, timeStep);
		frames++;
	}
	
	public float getFps() {
		float fps = 0;
		for (int i = 0; i < MAX_SAMPLES; i++) {
			fps += fpsSamples[i];
		}
		fps /= MAX_SAMPLES;
		return Math.round(fps * 100f) / 100f;
	}
	
}
