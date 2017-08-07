package br.twister.lowrez.engine;

public interface GameState {
	void onStart();
	void onEnd();
	void onUpdate(float dt);
	void onRender(Renderer renderer);
}
