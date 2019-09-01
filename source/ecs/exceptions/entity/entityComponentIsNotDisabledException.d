module ecs.exceptions.entity.entityComponentIsNotDisabledException;

import ecs.exceptions.ecsException;
import std.conv : to;

class EntityComponentIsNotDisabledException : ECS_Exception
{
	public this(uint id, string message, string hint)
	{
		super(message ~ "\nEntity does not have a compontent with the id of " ~ to!(string)(id) ~ " disabled!", hint);
	}
}