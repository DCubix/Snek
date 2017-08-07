package br.twister.lowrez.engine;

public class RGB {

	private static RGB blend_ret = new RGB(0, 0, 0);
	private static RGB mul_ret = new RGB(0, 0, 0);
	private static RGB unpack_ret = new RGB(0, 0, 0);
	public int r, g, b;
	
	public RGB(int r, int g, int b) {
		this.r = r;
		this.g = g;
		this.b = b;
	}
	
	public void set(int rgb) {
		this.r = (rgb & 0xFF0000) >> 16;
		this.g = (rgb & 0x00FF00) >> 8;
		this.b = (rgb & 0x0000FF);
	}
	
	public void set(int r, int g, int b) {
		this.r = r;
		this.g = g;
		this.b = b;
	}

	public static RGB blend(RGB a, RGB b, float fac) {
		blend_ret.set(
			(int)((a.r * (1.0f - fac)) + (b.r * fac)),
			(int)((a.g * (1.0f - fac)) + (b.g * fac)),
			(int)((a.b * (1.0f - fac)) + (b.b * fac))
		);
		return blend_ret;
	}
	
	public static RGB mul(RGB a, RGB b) {
		mul_ret.set(
			(int)((a.r/255.0f * b.r/255.0f) * 255.0f),
			(int)((a.g/255.0f * b.g/255.0f) * 255.0f),
			(int)((a.b/255.0f * b.b/255.0f) * 255.0f)
		);
		return mul_ret;
	}
	
	public static RGB unpack(int rgb) {
		unpack_ret.set(
			(rgb & 0xFF0000) >> 16,
			(rgb & 0x00FF00) >> 8,
			(rgb & 0x0000FF)
		);
		return unpack_ret;
	}
	
	public static int pack(RGB rgb) {
		return (rgb.r & 0xFF) << 16 |
				(rgb.g & 0xFF) << 8 |
				(rgb.b & 0xFF);
	}
	
}
