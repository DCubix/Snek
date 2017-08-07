package br.twister.lowrez.engine;

public class Point {

	public float x, y;
	
	public Point() {
		this(0, 0);
	}
	
	public Point(float x, float y) {
		this.x = x;
		this.y = y;
	}
	
	public float distanceTo(Point b) {
		float dx = b.x - x;
		float dy = b.y - y;
		return (float) Math.sqrt(dx * dx + dy * dy);
	}
	
	public float angleTo(Point b) {
		float dx = b.x - x;
		float dy = b.y - y;
		return (float) Math.atan2(dy, dx);
	}
	
	public Point directionTo(Point b) {
		Point d = this.sub(b);
		float len = (float) Math.sqrt(d.x * d.x + d.y * d.y);
		d.x /= len;
		d.y /= len;
		return d;
	}
	
	public float dot(Point b) {
		return x * b.x + y * b.y;
	}
	
	public float cross(Point b) {
		return x * b.y - y * b.x;
	}
	
	public Point normalized() {
		float len = (float) Math.sqrt(x * x + y * y);
		return new Point(x / len, y / len);
	}
	
	public Point sub(Point b) {
		return new Point(x - b.x, y - b.y);
	}
	
}
