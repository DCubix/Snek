package br.twister.lowrez.engine;

import org.luaj.vm2.LuaFunction;
import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;

public class ScriptedState implements GameState {

	private LuaFunction on_start, on_end, on_update, on_render;
	private LuaTable table;
	
	public ScriptedState(String fileName) {
		LuaValue chunk = Scripting.loadScript(fileName);
		LuaValue v = chunk.call(); 
		if (v.istable()) {
			table = (LuaTable) v;
			on_start = get("on_start");
			on_end = get("on_end");
			on_update = get("on_update");
			on_render = get("on_render");
		}
	}
	
	private LuaFunction get(String name) {
		LuaValue v = table.get(name);
		if (v.isfunction()) {
			return (LuaFunction) v;
		}
		return null;
	}
		
	@Override
	public void onStart() {
		if (on_start != null) {
			on_start.call(table);
		}
	}

	@Override
	public void onEnd() {
		if (on_end != null) {
			on_end.call(table);
		}
	}

	@Override
	public void onUpdate(float dt) {
		if (on_update != null) {
			on_update.call(table, Scripting.getInput(), LuaValue.valueOf(dt));
		}
	}

	@Override
	public void onRender(Renderer renderer) {
		if (on_render != null) {
			on_render.call(table, Scripting.getRenderer());
		}
	}

}
