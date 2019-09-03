module ecs.exceptions.component.componentAlreadyExistsException;

import ecs.exceptions.ecsException;
import std.conv : to;

class ComponentDoesNotExistException : ECS_Exception
{
	public this(string message, string hint)
	{
		super(message ~ "\nThe component already exists!", hint);
	}
}