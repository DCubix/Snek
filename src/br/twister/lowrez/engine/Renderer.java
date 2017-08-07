package br.twister.lowrez.engine;

public class Renderer {

	private Bitmap buffer;
	private Point drawOffset;
	
	public Renderer(Display display) {
		this.buffer = display.getBuffer();
		this.drawOffset = new Point();
	}
	
	public void clearFac(RGB color, float fac) {
		for (int y = 0; y < buffer.getHeight(); y++) {
			for (int x = 0; x < buffer.getWidth(); x++) {
				if (fac < 1.0f) {
					RGB b = buffer.get(x, y);
					buffer.set(x, y, RGB.blend(b, color, fac));
				} else {
					buffer.set(x, y, color);
				}
			}
		}
	}

	public void clear(RGB color) {
		clearFac(color, 1.0f);
	}
	
	public void clearRectFac(RGB color, float fac, int rx, int ry, int rw, int rh) {
		for (int y = ry; y < ry+rh; y++) {
			for (int x = rx; x < rx+rw; x++) {
				int _x = x, _y = y;
				if (_x < 0) {
					_x = 0;
				} else if (_x >= buffer.getWidth()) {
					_x = buffer.getWidth()-1;
				}
				if (_y < 0) {
					_y = 0;
				} else if (_y >= buffer.getHeight()) {
					_y = buffer.getHeight()-1;
				}
				if (fac < 1.0f) {
					RGB b = buffer.get(_x, _y);
					buffer.set(_x, _y, RGB.blend(b, color, fac));
				} else {
					buffer.set(_x, _y, color);
				}
			}
		}
	}
	
	public void clearRect(RGB color, int rx, int ry, int rw, int rh) {
		clearRectFac(color, 1.0f, rx, ry, rw, rh);
	}
	
	public void drawLine(int x0, int y0, int x1, int y1, RGB color) {
		boolean steep = false;

		if (Math.abs(x0 - x1) < Math.abs(y0 - y1)) {
			int tmp = x0; x0 = y0; y0 = tmp;
				tmp = x1; x1 = y1; y1 = tmp;
			steep = true;
		}
		if (x0 > x1) {
			int tmp = x0; x0 = x1; x1 = tmp;
				tmp = y0; y0 = y1; y1 = tmp;
		}

		int dx = x1 - x0;
		int dy = y1 - y0;
		int derror2 = Math.abs(dy) * 2;
		int error2 = 0;
		int y = y0;
		for (int x = x0; x <= x1; x++) {
			if (steep) {
				buffer.set(y, x, color);
			} else {
				buffer.set(x, y, color);
			}
			error2 += derror2;
			if (error2 > dx) {
				y += y1 > y0 ? 1 : -1;
				error2 -= dx * 2;
			}
		}
	}
	
	public void drawSprite(
			Bitmap spr,
			int srcX, int srcY, int srcW, int srcH,
			int dstX, int dstY, int dstW, int dstH,
			RGB tint
	) {
		if (dstW <= 0 || dstH <= 0) { return; }
		int x_ratio = (int)((srcW << 16) / dstW) + 1;
		int y_ratio = (int)((srcH << 16) / dstH) + 1;
		int x2, y2;
		
		dstX -= drawOffset.x;
		dstY -= drawOffset.y;

		int sw = Engine.getDisplay().getBuffer().getWidth();
		int sh = Engine.getDisplay().getBuffer().getHeight();
		
		if (!Collisions.rect(dstX, dstY, dstW, dstH, 0, 0, sw, sh)) {
			return;
		}
		
		for (int y = 0; y < dstH; y++) {
			for (int x = 0; x < dstW; x++) {
				x2 = ((x * x_ratio) >> 16) + srcX;
				y2 = ((y * y_ratio) >> 16) + srcY;
				if (x2 < 0) {
					x2 = x2 + spr.getWidth();
				} else if (x2 >= spr.getWidth()) {
					x2 = x2 - spr.getWidth();
				}
				if (y2 < 0) {
					y2 = y2 + spr.getHeight();
				} else if (y2 >= spr.getHeight()) {
					y2 = y2 - spr.getHeight();
				}

				RGB col = spr.get(x2, y2);
				if (col.r == spr.getTransparencyKey().r &&
					col.g == spr.getTransparencyKey().g &&
					col.b == spr.getTransparencyKey().b) {
					continue;
				}
				if (tint != null) {
					buffer.set(x + dstX, y + dstY, RGB.mul(col, tint));
				} else {
					buffer.set(x + dstX, y + dstY, col);
				}
			}
		}
	}
	
	public void drawSpriteRect(Bitmap spr, int dstX, int dstY, int dstW, int dstH, RGB color) {
		drawSprite(spr, 0, 0, spr.getWidth(), spr.getHeight(), dstX, dstY, dstW, dstH, color);
	}
	
	public void drawSpriteSimple(Bitmap spr, int x, int y, RGB color) {
		drawSprite(spr, 0, 0, spr.getWidth(), spr.getHeight(), x, y, spr.getWidth(), spr.getHeight(), color);
	}
	
	public int drawChar(Bitmap spr, String c, String charMap, int x, int y, int charSpacing, RGB color) {
		if (c.length() > 1) { return 0; }
		
		int charCount = charMap.length();
		int charWidth = spr.getWidth() / charCount;
		int charHeight = spr.getHeight();
		int cx = x;
		int mc = charMap.indexOf(c);
		if (mc != -1) {
			int sx = (mc % charMap.length()) * charWidth;
			int sy = (int)(mc / charMap.length()) * charHeight;
			drawSprite(spr, sx, sy, charWidth, charHeight,
					(int)(cx + drawOffset.x), (int)(y + drawOffset.y), charWidth, charHeight, color);
		}
		cx += charWidth + charSpacing;
		return cx;
	}
	
	public Point drawText(Bitmap spr, String text, String charMap, int x, int y, int charSpacing, RGB color) {
		int charCount = charMap.length();
		int charWidth = spr.getWidth() / charCount;
		int charHeight = spr.getHeight();
		int cx = x, cy = y;

		for (int i = 0; i < text.length(); i++) {
			char c = text.charAt(i);
			int mc = charMap.indexOf(c);
			if (mc != -1) {
				int sx = (mc % charMap.length()) * charWidth;
				int sy = (int)(mc / charMap.length()) * charHeight;
				drawSprite(spr, sx, sy, charWidth, charHeight, (int)(cx + drawOffset.x), (int)(cy + drawOffset.y), charWidth, charHeight, color);
			}
			cx += charWidth + charSpacing;
		}
		cy += charHeight;
		return new Point(x, cy);
	}
	
	public int getTextWidth(Bitmap spr, String text, String charMap, int charSpacing) {
		int charCount = charMap.length();
		int charWidth = spr.getWidth() / charCount;
		int w = 0;
		for (int i = 0; i < text.length(); i++) {
			w += charWidth + charSpacing;
		}
		return w;
	}
	
	public void drawTile(Bitmap spr, int index, int cellx, int celly, int tilesX, int tilesY) {
		int tileWidth = spr.getWidth() / tilesX;
		int tileHeight = spr.getHeight() / tilesY;
		int tileX = cellx * tileWidth;
		int tileY = celly * tileHeight;
		
		int srcx = (index % tilesX) * tileWidth;
		int srcy = (index / tilesX) * tileHeight;
		
		drawSprite(spr, srcx, srcy, tileWidth, tileHeight, tileX, tileY, tileWidth, tileHeight, null);
	}
	
	public void drawAnimation(Bitmap spr, Animation ani, int x, int y, RGB color) {
		Rect frame = ani.nextFrame((float) Engine.getTimeStep());
		int srcX = (int) (spr.getWidth() * frame.x);
		int srcY = (int) (spr.getHeight() * frame.y);
		int srcW = (int) (spr.getWidth() * frame.w);
		int srcH = (int) (spr.getHeight() * frame.h);
		drawSprite(spr, srcX, srcY, srcW, srcH, x, y, srcW, srcH, color);
	}

	public Point getDrawOffset() {
		return drawOffset;
	}

	public void setDrawOffset(Point drawOffset) {
		this.drawOffset = drawOffset;
	}
	
}
