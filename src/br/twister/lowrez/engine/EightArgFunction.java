package br.twister.lowrez.engine;

import org.luaj.vm2.LuaValue;
import org.luaj.vm2.Varargs;
import org.luaj.vm2.lib.LibFunction;

public abstract class EightArgFunction  extends LibFunction {
	
	abstract public LuaValue call(LuaValue arg1, LuaValue arg2, LuaValue arg3, LuaValue arg4,
			LuaValue arg5, LuaValue arg6, LuaValue arg7, LuaValue arg8);
	
	public EightArgFunction() {
	}
	
	public final LuaValue call() {
		return call(NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL);
	}

	public final LuaValue call(LuaValue arg) {
		return call(arg, NIL, NIL, NIL, NIL, NIL, NIL, NIL);
	}

	public LuaValue call(LuaValue arg1, LuaValue arg2) {
		return call(arg1, arg2, NIL, NIL, NIL, NIL, NIL, NIL);
	}
	
	public LuaValue call(LuaValue arg1, LuaValue arg2, LuaValue arg3) {
		return call(arg1, arg2, arg3, NIL, NIL, NIL, NIL, NIL);
	}
	
	public LuaValue call(LuaValue arg1, LuaValue arg2, LuaValue arg3, LuaValue arg4) {
		return call(arg1, arg2, arg3, arg4, NIL, NIL, NIL, NIL);
	}
	
	public LuaValue call(LuaValue arg1, LuaValue arg2, LuaValue arg3, LuaValue arg4, LuaValue arg5) {
		return call(arg1, arg2, arg3, arg4, arg5, NIL, NIL, NIL);
	}
	
	public LuaValue call(LuaValue arg1, LuaValue arg2, LuaValue arg3, LuaValue arg4, LuaValue arg5, LuaValue arg6) {
		return call(arg1, arg2, arg3, arg4, arg5, arg6, NIL, NIL);
	}
	
	public LuaValue call(LuaValue arg1, LuaValue arg2, LuaValue arg3, LuaValue arg4, LuaValue arg5, LuaValue arg6, LuaValue arg7) {
		return call(arg1, arg2, arg3, arg4, arg5, arg6, arg7, NIL);
	}
	
	public Varargs invoke(Varargs varargs) {
		return call(varargs.arg1(),varargs.arg(2),varargs.arg(3),varargs.arg(4),varargs.arg(5),varargs.arg(6),varargs.arg(7),varargs.arg(8));
	}
	
}
