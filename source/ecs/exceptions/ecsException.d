module ecs.exceptions.ecsException;

import std.exception;


class ECS_Exception : Exception
{
	public this(string msg, string hint)
	{
		hint !is null ? super(msg ~ "\n" ~ hint) : super(msg);
	}
} 