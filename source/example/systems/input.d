module example.systems.input;

import ecs;


import example.components.input;
import example.components.hero;


@system pure final class InputSystem : ISystem
{
	private System system;
	private Input input;
	public bool manual = false;

	public bool ismanual() { return manual; }

	@safe pure public void init(System _system)
	{
		system = _system;
	}

	public void update()
	{
		foreach(e; system.entities)
		{
			if (e.hasComponent!Input)
			{
				input = e.getComponent!Input;
				if (e.hasComponent!Hero)
					input.word = playerInput;
			}
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