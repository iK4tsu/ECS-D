module ecs.componentType;


const enum ComponentType : uint
{
	POSITION = 0,
	HEALTH,
	MOVABLE
}

alias Position = ComponentType.POSITION;
alias Health   = ComponentType.HEALTH;
alias Movable  = ComponentType.MOVABLE;