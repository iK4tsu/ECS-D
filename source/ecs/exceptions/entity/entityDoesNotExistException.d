module ecs.exceptions.entity.entityDoesNotExistException;

import ecs.exceptions.ecsException;
import std.conv : to;

class EntityDoesNotExistException : ECS_Exception
{
	public this(uint eid, string message, string hint)
	{
		super(message ~ "\nThe entity with the id of " ~ to!(string)(eid) ~
		" does not exist! Maybe it was already killed or it was not created yet!", hint);
	}
}