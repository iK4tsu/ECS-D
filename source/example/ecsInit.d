module example.ecsInit;


import ecs.hub;
import example.componentFactory;
import example.systemFactory;
import example.entityFactory;
import ecs.icomponent;
import ecs.componentType;
import ecs.isystem;


void exampleInit()
{
	Hub _hub = new Hub();

	/*
	 * you should generate systems and components first and entities last
	 */

	generateSystems(_hub);
	generateComponents(_hub);
	generateEntities(_hub);


	assert(_hub._entityManager.HasEntity(0));
	assert(_hub._entityManager.HasComponents(0, [Position, Movable]));
	assert(is(typeof(_hub._system._systems["MovementSystem"]) == ISystem));

	/*
	 * for now you have to set ids manualy to your systems
	 */
	_hub._system.SetEids([0]);

	import std.stdio;
	import std.string : chomp;

	do
	{
		writeln("Write 'move' to update your position.");
		writeln("Each time the loop ends, the user 'movableComponent' will be removed.");
		writeln("Meaning that if you write 'move' the component will be added and you'll be able to move.");
		write("> ");

		switch (readln.chomp)
		{
			case "move":
				_hub.AddComponent!(MovableComponent)(0, Movable);
				_hub.GetComponent!(MovableComponent)(0, Movable).moveX = 4;
				break;
			default:
				_hub.RemoveComponent(0, Movable);
		}

		_hub.UpdateSystems;
		writeln("Your 'x' position: ", _hub.GetComponent!(PositionComponent)(0, Position).x);
	} while (true);
}