package br.twister.lowrez.engine;

import java.awt.Canvas;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.image.BufferStrategy;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.JFrame;

public class Display extends Canvas {

	private static final long serialVersionUID = 1L;

	private Bitmap backBuffer;
	
	private BufferStrategy bufferStrategy;
	private Graphics graphics;
	
	private JFrame frame;
	private boolean closed;
	
	private String title;
	
	public Display(int width, int height, int buffwidth, int buffheight, String title) {
		Dimension s = new Dimension(width, height);
		setSize(s);
		setPreferredSize(s);
		closed = false;
		
		frame = new JFrame();
		frame.add(this);
		frame.pack();
		
		frame.setResizable(false);
		frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		frame.setTitle(title);
		frame.setLocationRelativeTo(null);
		frame.setBackground(Color.BLACK);
		this.setBackground(Color.BLACK);
		
		frame.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				closed = true;
				e.getWindow().dispose();
			}
		});
		
		backBuffer = new Bitmap(buffwidth, buffheight);
		
		createBufferStrategy(1);
		bufferStrategy = getBufferStrategy();
		graphics = bufferStrategy.getDrawGraphics();
	}
	
	public void setIcon(String fileName) {
		try {
			frame.setIconImage(ImageIO.read(FileUtils.getFile(fileName)));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void show() {
		frame.setVisible(true);
		this.requestFocus();
	}
	
	public void swapBuffers() {
		graphics.drawImage(backBuffer.getBuffer(), 0, 0, getWidth(), getHeight(), null);
		bufferStrategy.show();
	}

	public Bitmap getBuffer() {
		return backBuffer;
	}

	public void close() {
		closed = true;
	}
	
	public boolean isClosed() {
		return closed;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
		frame.setTitle(title);
	}

	@Override
	public void setVisible(boolean b) {
		frame.setVisible(b);
	}
	
}
