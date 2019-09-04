module example.systems.input;

import ecs;


import example.components.input;
import example.components.hero;


@system pure final class InputSystem : ISystem
{
	private Hub hub;
	private Input input;

	@safe pure public void init(ref Hub _hub)
	{
		hub = _hub;
	}

	public void update(Entity e)
	{
		if (e.hasComponent!Input)
		{
			input = e.getComponent!Input;
			if (e.hasComponent!Hero)
				input.word = playerInput;
		}
	}

	public string playerInput()
	{
		import std.stdio;
		import std.string : chomp;

		write("> ");
		return readln.chomp;
	}
}