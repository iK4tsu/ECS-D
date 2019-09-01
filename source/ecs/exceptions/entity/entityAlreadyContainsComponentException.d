module ecs.exceptions.entity.entityAlreadyContainsComponentException;

import ecs.exceptions.ecsException;
import std.conv : to;

class EntityAlreadyContainsComponentException : ECS_Exception
{
	public this(uint id, string message, string hint)
	{
		super(message ~ "\nEntity already has a component with an id value of " ~ to!(string)(id) ~ "!", hint);
	}
}