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


	writeln("This is pratical example of how this arquitecture works.");
	writeln("Write 'up', 'down', 'right' or left to move in each direction respectively.");
	writeln("Press any key to continue...");


	do
	{
		hub.update;
	} while (true);
}