package br.twister.lowrez.engine;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferInt;
import java.io.IOException;

import javax.imageio.ImageIO;

public class Bitmap {

	private BufferedImage buff;
	private int width, height;
	private int[] pixels;
	private RGB transparencyKey;
	
	public Bitmap(int width, int height) {
		this.width = width;
		this.height = height;
		this.transparencyKey = new RGB(255, 0, 255);
		this.buff = ImageUtil.createCompatibleImage(width, height, BufferedImage.TYPE_INT_RGB);
		pixels = ((DataBufferInt) buff.getRaster().getDataBuffer()).getData();
	}
	
	public Bitmap(String fileName) {
		try {
			this.buff = ImageUtil.toCompatibleImage(ImageIO.read(FileUtils.getFile(fileName)));
			this.width = this.buff.getWidth();
			this.height = this.buff.getHeight();
			this.transparencyKey = new RGB(255, 0, 255);
			pixels = ((DataBufferInt) buff.getRaster().getDataBuffer()).getData();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public Bitmap(BufferedImage image) {
		this.buff = ImageUtil.toCompatibleImage(image);
		this.width = this.buff.getWidth();
		this.height = this.buff.getHeight();
		this.transparencyKey = new RGB(255, 0, 255);
		pixels = ((DataBufferInt) buff.getRaster().getDataBuffer()).getData();
	}
	
	private static RGB get_col = new RGB(0, 0, 0);
	public RGB get(int x, int y) {
		if (x < 0 || x >= width || y < 0 || y >= height) {
			return null;
		}
		int index = (x + y * width);
		get_col.set(pixels[index]);
		return get_col;
	}
	
	public void set(int x, int y, RGB color) {
		if (x < 0 || x >= width || y < 0 || y >= height) {
			return;
		}
		int index = (x + y * width);
		pixels[index] = RGB.pack(color);
	}

	public BufferedImage getBuffer() {
		return buff;
	}

	public int getWidth() {
		return width;
	}

	public int getHeight() {
		return height;
	}

	public RGB getTransparencyKey() {
		return transparencyKey;
	}

	public void setTransparencyKey(RGB transparencyKey) {
		this.transparencyKey = transparencyKey;
	}
	
	public void unload() {
		buff.flush();
		pixels = null;
		buff = null;
	}
	
}