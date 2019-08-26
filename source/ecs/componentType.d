module ecs.componentType;


const enum ComponentType : uint
{
	POSITION = 0,
	HEALTH
}

alias Position = ComponentType.POSITION;
alias Health   = ComponentType.HEALTH;