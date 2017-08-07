package br.twister.lowrez.engine;

public class Collisions {

	private static boolean overlaps(int point1, int length1, int point2, int length2) {
	    double highestStartPoint = Math.max(point1, point2);
	    double lowestEndPoint = Math.min(point1 + length1, point2 + length2);

	    return highestStartPoint < lowestEndPoint;
	}
	
	public static boolean rect(
			int x0, int y0, int w0, int h0,
			int x1, int y1, int w1, int h1
	)
	{
		return overlaps(x0, w0, x1, w1) && overlaps(y0, h1, y1, h1);
	}
	
}
