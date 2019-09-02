module ecs.exceptions.component.componentDoesNotExistException;

import ecs.exceptions.ecsException;
import std.conv : to;

class ComponentDoesNotExistException : ECS_Exception
{
	public this(string message, string hint)
	{
		super(message ~ "\nThe component does not exist! Is it initialized?", hint);
	}
}