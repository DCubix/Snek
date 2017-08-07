package br.twister.lowrez.engine;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;

public class Input implements KeyListener, MouseListener, MouseMotionListener {
		
	private boolean[] keysDown = new boolean[1024];
	private boolean[] keysPressed = new boolean[1024];
	private boolean[] keysReleased = new boolean[1024];
	
	private boolean[] mouseButtonsDown = new boolean[8];
	private boolean[] mouseButtonsPressed = new boolean[8];
	private boolean[] mouseButtonsReleased = new boolean[8];
	
	private Point mousePosition;
	
	private byte typedChar;
	
	public Input(Display display) {
		display.addKeyListener(this);
		display.addMouseListener(this);
		display.addMouseMotionListener(this);
		this.mousePosition = new Point();
		this.typedChar = 0;
	}
	
	public byte getTypedChar() {
		byte tmp = typedChar;
		typedChar = 0;
		return tmp;
	}
	
	public boolean keyDown(int key) {
		return keysDown[key];
	}
	
	public boolean keyPressed(int key) {
		return keysPressed[key];
	}
	
	public boolean keyReleased(int key) {
		return keysReleased[key];
	}
	
	public boolean mouseButtonDown(int button) {
		return mouseButtonsDown[button];
	}
	
	public boolean mouseButtonPressed(int button) {
		return mouseButtonsPressed[button];
	}
	
	public boolean mouseButtonReleased(int button) {
		return mouseButtonsReleased[button];
	}
	
	public Point getMousePosition() {
		return mousePosition;
	}

	protected void update() {
		for (int i = 0; i < 1024; i++) {
			keysPressed[i] = false;
			keysReleased[i] = false;
		}
		for (int i = 0; i < 8; i++) {
			mouseButtonsPressed[i] = false;
			mouseButtonsReleased[i] = false;
		}
	}
	
	@Override
	public void mouseDragged(MouseEvent e) {
		mouseMoved(e);
	}

	@Override
	public void mouseMoved(MouseEvent e) {
		int rx = Engine.getDisplay().getWidth() / Engine.getDisplay().getBuffer().getWidth();
		int ry = Engine.getDisplay().getHeight() / Engine.getDisplay().getBuffer().getHeight();
		mousePosition.x = e.getX() / rx;
		mousePosition.y = e.getY() / ry;
	}

	@Override
	public void mouseClicked(MouseEvent e) {
		
	}

	@Override
	public void mousePressed(MouseEvent e) {
		mouseButtonsDown[e.getButton()] = true;
		mouseButtonsPressed[e.getButton()] = true;
	}

	@Override
	public void mouseReleased(MouseEvent e) {
		mouseButtonsDown[e.getButton()] = false;
		mouseButtonsReleased[e.getButton()] = true;
	}

	@Override
	public void mouseEntered(MouseEvent e) {
		
	}

	@Override
	public void mouseExited(MouseEvent e) {
		
	}

	@Override
	public void keyTyped(KeyEvent e) {
		typedChar = (byte) (0xFF & e.getKeyChar());
	}

	@Override
	public void keyPressed(KeyEvent e) {
		keysDown[e.getKeyCode()] = true;
		keysPressed[e.getKeyCode()] = true;
	}

	@Override
	public void keyReleased(KeyEvent e) {
		keysDown[e.getKeyCode()] = false;
		keysReleased[e.getKeyCode()] = true;
	}

}
