package br.twister.lowrez.engine;

import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaFunction;
import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.OneArgFunction;
import org.luaj.vm2.lib.ThreeArgFunction;
import org.luaj.vm2.lib.TwoArgFunction;
import org.luaj.vm2.lib.ZeroArgFunction;
import org.luaj.vm2.lib.jse.CoerceJavaToLua;
import org.luaj.vm2.lib.jse.JsePlatform;

import kuusisto.tinysound.Music;
import kuusisto.tinysound.Sound;
import kuusisto.tinysound.TinySound;

public class Scripting {

	public static Globals globals;
	static {
		if (globals == null)
			globals = JsePlatform.standardGlobals();
	}
	
	public static LuaValue loadScript(String fileName) {
		// Load Script
		StringBuilder src = new StringBuilder("");
		String file = fileName.substring(fileName.lastIndexOf('/')+1, fileName.lastIndexOf('.'));
		
		src.append(file)
			.append("={}\n")
			.append(FileUtils.fileToString(fileName))
			.append("\nreturn ").append(file);

		return globals.load(src.toString(), file, globals);
	}
	
	public static void registerTypes() {
		// Custom require impl: import
		if (globals.get("import").isnil()) {
			OneArgFunction importfun = new OneArgFunction() {
				@Override
				public LuaValue call(LuaValue arg) {
					String fileName = arg.toString();
					String src = FileUtils.fileToString(fileName);
					String file = fileName.substring(fileName.lastIndexOf('/')+1, fileName.lastIndexOf('.'));
					LuaValue val = globals.load(src, file, globals);
					return val.call();
				}
			};
			globals.set("import", importfun);
		}
		
		// Bitmap
		OneArgFunction Bitmap_new = new OneArgFunction() {
			@Override
			public LuaValue call(LuaValue arg) {
				return CoerceJavaToLua.coerce(new Bitmap(arg.toString()));
			}
		};
		if (globals.get("Bitmap").isnil()) {
			globals.set("Bitmap", Bitmap_new);
		}
		
		// RGB
		ThreeArgFunction RGB_new = new ThreeArgFunction() {
			@Override
			public LuaValue call(LuaValue arg1, LuaValue arg2, LuaValue arg3) {
				return CoerceJavaToLua.coerce(new RGB(arg1.toint(), arg2.toint(), arg3.toint()));
			}
		};
		if (globals.get("RGB").isnil()) {
			globals.set("RGB", RGB_new);
		}
		
		// Point
		TwoArgFunction Point_new = new TwoArgFunction() {
			@Override
			public LuaValue call(LuaValue arg1, LuaValue arg2) {
				return CoerceJavaToLua.coerce(new Point(arg1.toint(), arg2.toint()));
			}
		};
		if (globals.get("Point").isnil()) {
			globals.set("Point", Point_new);
		}
		
		// Animation
		FourArgFunction Animation_new = new FourArgFunction() {
			@Override
			public LuaValue call(LuaValue arg1, LuaValue arg2, LuaValue arg3, LuaValue arg4) {
				int[] arr = null;
				if (arg4 != NIL) {
					LuaTable ag4 = (LuaTable) arg4;
					arr = new int[ag4.length()];
					for (int i = 0; i < arr.length; i++) {
						if (ag4.get(i+1).isint()) {
							arr[i] = ag4.get(i+1).toint();
						} else {
							throw new RuntimeException("Frames should be an array of INT");
						}
					}
				}
				return CoerceJavaToLua.coerce(
					new Animation(arg1.toint(), arg2.toint(), arg3.tofloat(), arr)
				);
			}
		};
		if (globals.get("Animation").isnil()) {
			globals.set("Animation", Animation_new);
		}
		
		// Audio
		if (globals.get("Audio").isnil()) {
			LuaTable audio = new LuaTable();
			OneArgFunction new_Music = new OneArgFunction() {
				@Override
				public LuaValue call(LuaValue arg) {
					Music mus = TinySound.loadMusic(FileUtils.getFileR(arg.toString()), true);
					return CoerceJavaToLua.coerce(mus);
				}
			};
			OneArgFunction new_Sound = new OneArgFunction() {
				@Override
				public LuaValue call(LuaValue arg) {
					Sound snd = TinySound.loadSound(FileUtils.getFileR(arg.toString()));
					return CoerceJavaToLua.coerce(snd);
				}
			};
			audio.set("loadMusic", new_Music);
			audio.set("loadSound", new_Sound);
			globals.set("Audio", audio);
		}
		
		// Keys Enum
		if (globals.get("Keys").isnil()) {
			LuaTable keys_enum = new LuaTable();
			for (Keys k : Keys.values()) {
				String name = k.toString();
				keys_enum.set(name, k.value);
			}
			globals.set("Keys", keys_enum);
		}
		
		// Engine
		if (globals.get("Engine").isnil()) {
			LuaTable engine = new LuaTable();
			ZeroArgFunction get_timeScale = new ZeroArgFunction() {
				@Override
				public LuaValue call() {
					return LuaValue.valueOf(Engine.getTimeScale());
				}
			};
			OneArgFunction set_timeScale = new OneArgFunction() {
				@Override
				public LuaValue call(LuaValue arg) {
					Engine.setTimeScale(arg.tofloat());
					return NIL;
				}
			};
			ZeroArgFunction get_Display = new ZeroArgFunction() {
				@Override
				public LuaValue call() {
					return CoerceJavaToLua.coerce(Engine.getDisplay());
				}
			};
			OneArgFunction set_State = new OneArgFunction() {
				@Override
				public LuaValue call(LuaValue arg) {
					ScriptedState state = new ScriptedState(arg.toString());
					Engine.setState(state);
					return NIL;
				}
			};
			TwoArgFunction wait = new TwoArgFunction() {
				@Override
				public LuaValue call(LuaValue arg1, LuaValue arg2) {
					if (arg2.isfunction()) {
						LuaFunction function = (LuaFunction) arg2;
						float time = arg1.tofloat();
						IRoutine routine = new IRoutine() {
							@Override
							public void call() {
								function.call();
							}
						};
						Engine.wait(time, routine);
					}
					return NIL;
				}
			};
			ZeroArgFunction get_ScreenWidth = new ZeroArgFunction() {
				@Override
				public LuaValue call() {
					return LuaValue.valueOf(Engine.getDisplay().getBuffer().getWidth());
				}
			};
			ZeroArgFunction get_ScreenHeight = new ZeroArgFunction() {
				@Override
				public LuaValue call() {
					return LuaValue.valueOf(Engine.getDisplay().getBuffer().getHeight());
				}
			};
			ZeroArgFunction get_fps = new ZeroArgFunction() {
				@Override
				public LuaValue call() {
					return LuaValue.valueOf(Engine.getFPSCounter().getFps());
				}
			};
			
			engine.set("getTimeScale", get_timeScale);
			engine.set("setTimeScale", set_timeScale);
			engine.set("getDisplay", get_Display);
			engine.set("getScreenWidth", get_ScreenWidth);
			engine.set("getScreenHeight", get_ScreenHeight);
			engine.set("setState", set_State);
			engine.set("getFps", get_fps);
			engine.set("wait", wait);

			globals.set("Engine", engine);
		}
		
		// Collisions
		if (globals.get("Collisions").isnil()) {
			LuaTable collisions = new LuaTable();
			EightArgFunction rect = new EightArgFunction() {
				@Override
				public LuaValue call(LuaValue arg1, LuaValue arg2, LuaValue arg3, LuaValue arg4,
						LuaValue arg5, LuaValue arg6, LuaValue arg7, LuaValue arg8) {
					return LuaValue.valueOf(Collisions.rect(
									arg1.toint(), arg2.toint(),	arg3.toint(), arg4.toint(),
									arg5.toint(), arg6.toint(), arg7.toint(), arg8.toint()
							)
					);
				}
			};
			collisions.set("rect", rect);
			globals.set("Collisions", collisions);
		}
		
		// Globals
		if (globals.get("Globals").isnil()) {
			LuaTable glob = new LuaTable();
			OneArgFunction has_prop = new OneArgFunction() {
				@Override
				public LuaValue call(LuaValue arg) {
					LuaTable dict = (LuaTable) glob.get("__dict");
					boolean has = !dict.get(arg.toString()).isnil();
					return LuaValue.valueOf(has);
				}
			};
			OneArgFunction get_prop = new OneArgFunction() {
				@Override
				public LuaValue call(LuaValue arg) {
					LuaTable dict = (LuaTable) glob.get("__dict");
					if (!dict.get(arg.toString()).isnil()) {
						return dict.get(arg);
					}
					return NIL;
				}
			};
			TwoArgFunction set_prop = new TwoArgFunction() {
				@Override
				public LuaValue call(LuaValue arg1, LuaValue arg2) {
					LuaTable dict = (LuaTable) glob.get("__dict");
					dict.set(arg1, arg2);
					return NIL;
				}
			};
			glob.set("__dict", new LuaTable());
			glob.set("hasProperty", has_prop);
			glob.set("getProperty", get_prop);
			glob.set("setProperty", set_prop);
			globals.set("Globals", glob);
		}
	}
	
	public static void freeGlobals() {
		LuaTable dict = (LuaTable) globals.get("Globals").get("__dict");
		for (int i = 0; i < dict.length(); i++) {
			dict.set(i, LuaValue.NIL);
		}
	}
}
