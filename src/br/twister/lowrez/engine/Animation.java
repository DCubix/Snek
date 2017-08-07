package br.twister.lowrez.engine;

public class Animation {

	private int cols, rows;
	private float speed, time;
	private int frame;
	private int[] frames;
	private boolean loop, automatic, updated;
	private Rect lastFrame;
	
	public Animation(int cols, int rows, float speed, int[] frames) {
		this.cols = cols;
		this.rows = rows;
		this.speed = speed;
		this.frame = 0;
		this.frames = frames;
		this.loop = true;
		this.time = 0;
		this.automatic = true;
		this.lastFrame = new Rect(0, 0, 1.0f / cols, 1.0f / rows);
	}
	
	protected Rect nextFrame(float dt) {
		float w = 1.0f / cols;
		float h = 1.0f / rows;

		if (lastFrame == null) {
			lastFrame = new Rect(0, 0, w, h);
		}
		
		if (automatic) {
			if (updated) {
				updated = false;
				return lastFrame;
			}
			time += dt;
			if (time >= speed) {
				time = 0;
				
				int findex = frames == null ? frame : frames[frame];
				lastFrame.x = (findex % cols) * w; 
				lastFrame.y = (int)(findex / cols) * h; 
				lastFrame.w = w;
				lastFrame.h = h;
				
				int fcount = frames == null ? cols * rows : frames.length;
				if (frame++ >= fcount-1) {
					if (loop) {
						frame = 0;
					} else {
						frame = fcount-1;
					}
			
				}
			}
			updated = true;
		}
		return lastFrame;
	}

	public Rect getLastFrame() {
		return lastFrame;
	}
	
	public float getSpeed() {
		return speed;
	}

	public void setSpeed(float speed) {
		this.speed = speed;
	}

	public int[] getFrames() {
		return frames;
	}

	public void setFrames(int[] frames) {
		this.frames = frames;
	}

	public boolean isLoop() {
		return loop;
	}

	public void setLoop(boolean loop) {
		this.loop = loop;
	}

	public int getFrame() {
		return frame;
	}

	public void setFrame(int frame) {
		this.frame = frame;
		float w = 1.0f / cols;
		float h = 1.0f / rows;
		
		if (lastFrame == null) {
			lastFrame = new Rect(0, 0, w, h);
		}
		
		int findex = frames == null ? frame : frames[frame];
		lastFrame.x = (findex % cols) * w; 
		lastFrame.y = (int)(findex / cols) * h; 
		lastFrame.w = w;
		lastFrame.h = h;
	}

	public boolean isAutomatic() {
		return automatic;
	}

	public void setAutomatic(boolean automatic) {
		this.automatic = automatic;
	}
	
}
