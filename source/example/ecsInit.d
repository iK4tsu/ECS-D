module example.ecsInit;


import ecs;

// Import your factories
import example.factories;


import std.stdio;
import std.string : chomp;


void exampleInit()
{
	Hub _hub = new Hub();


	// generate components, systems, and entities by this order
	generateComponents(_hub);
	generateSystems(_hub);
	generateEntities(_hub);

	EntityId playerId = _hub.entityGetId("Player");


	import example.components;
	ComponentTypeId positionId = _hub.componentGetTypeId!Position;
	ComponentTypeId movableId = _hub.componentGetTypeId!Movable;

	assert(_hub._entityManager.hasEntity(playerId));
	assert(_hub.entityHasComponents(playerId, [positionId, movableId]));


	do
	{
		writeln("Write 'move' to update your position.");
		writeln("Each time the loop ends, the user 'movableComponent' will be removed.");
		writeln("Meaning that if you write 'move' the component will be added and you'll be able to move.");
		write("> ");

		switch (readln.chomp)
		{
			case "move":
				if (_hub.entityIsComponentDisabled(playerId, movableId))
					_hub.entityEnableComponent(playerId, movableId);
				break;
			default:
				if (_hub.entityHasComponent(playerId, movableId))
					_hub.entityDisableComponent(playerId, movableId);
		}

		_hub.updateSystems;
		writeln("Your 'x' position: ", _hub.entityGetComponent!Position(playerId).x);
	} while (true);
}