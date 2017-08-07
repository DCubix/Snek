package br.twister.lowrez.game;

import br.twister.lowrez.engine.Engine;
import br.twister.lowrez.engine.EngineConfig;
import br.twister.lowrez.engine.ScriptedStartupState;

public class Game {

	public static void main(String[] args) {
		EngineConfig conf = new EngineConfig();
		conf.bufferWidth = 64;
		conf.bufferHeight = 64;
		conf.frameCap = 30;
		conf.startupState = new ScriptedStartupState("res://br/twister/lowrez/game/startup.lua");
		conf.windowWidth = 512;
		conf.windowHeight = 512;
		conf.windowTitle = "Snek!";
		Engine.start(conf);
	}

}
