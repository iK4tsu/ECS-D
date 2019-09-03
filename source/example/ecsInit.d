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


	// generate components, systems, and entities by this order
	generateComponents(hub);
	generateSystems(hub);
	generateEntities(hub);

	Entity player = hub.entity.create();
	player.addComponent!Position;
	player.addComponent(new Movable(4));
	
	ComponentTypeId positionId = hub.component.idOf!Position;
	ComponentTypeId movableId = hub.component.idOf!Movable;

	EntityId playerId = player._id;
	assert(hub.entity.exists(playerId));
	assert(player.hasComponents([positionId, movableId]));


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