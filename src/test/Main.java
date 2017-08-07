package test;

import br.twister.lowrez.engine.Engine;
import br.twister.lowrez.engine.EngineConfig;
import br.twister.lowrez.engine.ScriptedState;

public class Main {

	public static void main(String[] args) {
//		Font fnt = new Font("res://test/FSEX300.ttf", 10.0f);
		
		EngineConfig conf = new EngineConfig();
		conf.bufferWidth = 64;
		conf.bufferHeight = 64;
		conf.frameCap = 60;
//		conf.startupState = new ScriptedState("res://test/test.lua");
		conf.windowWidth = 128;
		conf.windowHeight = 128;
		conf.windowTitle = "#LOWREZ2017";
		Engine.start(conf);
	}

}
