package br.twister.lowrez.engine;

public class Timing {

	private static double start;
	
	public static double getTime() {
		return (System.nanoTime() / 1000000000.0);
	}
	
	public static void start() {
		start = getTime();
	}
	
	public static double stop() {
		return getTime() - start;
	}
}
