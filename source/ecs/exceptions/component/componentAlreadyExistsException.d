module ecs.exceptions.component.componentAlreadyExistsException;

import ecs.exceptions.ecsException;
import std.conv : to;

class ComponentAlreadyExistsException : ECS_Exception
{
	public this(string message, string hint)
	{
		super(message ~ "\nThe component already exists!", hint);
	}
}