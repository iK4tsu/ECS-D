module example.ecsInit;


import ecs.hub;
import example.componentFactory;
import example.systemFactory;
import example.entityFactory;
import ecs.icomponent;
import ecs.componentType;
import ecs.isystem;
import ecs.entity;


import std.stdio;
import std.string : chomp;


void exampleInit()
{
	Hub _hub = new Hub();


	/*
	 * you should generate systems and components first and entities last
	 */
	generateSystems(_hub);
	generateComponents(_hub);
	generateEntities(_hub);

	EntityId playerExample = 1;


	assert(_hub._entityManager.hasEntity(playerExample));
	assert(_hub._entityManager.hasComponents(playerExample, [1, 2]));
	assert(cast(ISystem)(_hub._system._systems["MovementSystem"]) !is null);


	/*
	 * for now you have to set ids manualy to your systems
	 */
	_hub._system.SetEids([playerExample]);


	do
	{
		writeln("Write 'move' to update your position.");
		writeln("Each time the loop ends, the user 'movableComponent' will be removed.");
		writeln("Meaning that if you write 'move' the component will be added and you'll be able to move.");
		write("> ");

		switch (readln.chomp)
		{
			case "move":
				_hub.entityEnableComponent(playerExample, Movable);
				break;
			default:
				_hub.entityDisableComponent(playerExample, Movable);
		}

		_hub.UpdateSystems;
		writeln("Your 'x' position: ", _hub.entityGetComponent!PositionComponent(playerExample).x);
	} while (true);
}