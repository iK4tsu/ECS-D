module ecs.exceptions.entity.entityDoesNotContainComponentException;

import ecs.exceptions.ecsException;
import std.conv : to;

class EntityDoesNotContainComponentException : ECS_Exception
{
	public this(uint id, string message, string hint)
	{
		super(message ~ "\nEntity does not contain a component with an id value of " ~ to!(string)(id) ~ "!", hint);
	}
}