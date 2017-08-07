package br.twister.lowrez.engine;

import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;

public class ScriptedStartupState implements StartupState {

	private LuaTable table;
	
	public ScriptedStartupState(String fileName) {
		Scripting.registerTypes();
		
		LuaValue chunk = Scripting.loadScript(fileName);
		LuaValue v = chunk.call(); 
		if (v.istable()) {
			table = (LuaTable) v;
		}
	}
	
	@Override
	public void onPreLoad() {
		if (table == null) { return; }
		LuaValue cb = table.get("on_preload");
		if (cb != null && cb.isfunction()) {
			cb.invoke(table);
		}
	}

	@Override
	public void onUnLoad() {
		if (table == null) { return; }
		LuaValue cb = table.get("on_unload");
		if (cb != null && cb.isfunction()) {
			cb.invoke(table);
		}
	}

}
