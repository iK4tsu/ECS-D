module example.ecsInit;


import ecs;

// Import your factories
import example.factories;
import example.components;


import std.stdio;
import std.string : chomp;


void exampleInit()
{
	Hub hub = new Hub();


	// Generate components, systems, and entities by this order
	generateComponents(hub);
	generateSystems(hub);
	generateEntities(hub);


	// You can get an entity by passing a component
	Entity player = hub.entity.get!Hero;

	// Or a group of components
	assert(hub.entity.get!(Hero, Position, Movable) == player);

	// You can also get all the entities containing a component or a group of components
	assert(hub.entity.getAll!Hero[0] == player);
	assert(hub.entity.getAll!(Hero, Position, Movable)[0] == player);


	do
	{
		writeln("Write 'move' to update your position.");
		writeln("Each time the loop ends, the user 'movableComponent' will be removed.");
		writeln("Meaning that if you write 'move' the component will be added and you'll be able to move.");
		write("> ");

		switch (readln.chomp)
		{
			case "move":
				if (player.isComponentDisabled!Movable)
					player.enableComponent!Movable;
				break;
			default:
				if (player.hasAnyComponent!Movable)
					player.disableComponent!Movable;
		}

		hub.update;
		writeln("Your 'x' position: ", player.getComponent!Position.x);
	} while (true);
}