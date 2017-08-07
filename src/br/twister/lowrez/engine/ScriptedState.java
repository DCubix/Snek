package br.twister.lowrez.engine;

import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.jse.CoerceJavaToLua;

public class ScriptedState implements GameState {

	private LuaTable table;
	
	public ScriptedState(String fileName) {
		Scripting.registerTypes();
		
		LuaValue chunk = Scripting.loadScript(fileName);
		LuaValue v = chunk.call(); 
		if (v.istable()) {
			table = (LuaTable) v;
		}
	}
		
	@Override
	public void onStart() {
		if (table == null) { return; }
		LuaValue cb = table.get("on_start");
		if (cb != null && cb.isfunction()) {
			cb.invoke(table);
		}
	}

	@Override
	public void onEnd() {
		if (table == null) { return; }
		LuaValue cb = table.get("on_end");
		if (cb != null && cb.isfunction()) {
			cb.invoke(table);
		}
	}

	@Override
	public void onUpdate(float dt) {
		if (table == null) { return; }
		LuaValue cb = table.get("on_update");
		if (cb != null && cb.isfunction()) {
			cb.invoke(table, CoerceJavaToLua.coerce(Engine.getInput()), LuaValue.valueOf(dt));
		}
	}

	@Override
	public void onRender(Renderer renderer) {
		if (table == null) { return; }
		LuaValue cb = table.get("on_render");
		if (cb != null && cb.isfunction()) {
			cb.invoke(table, CoerceJavaToLua.coerce(renderer));
		}
	}

}
