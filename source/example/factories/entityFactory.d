module example.factories.entityFactory;


import ecs;


// import your components
import example.components;

void generateEntities(ref Hub hub)
{
	// Generate all your entities through the hub
	EntityId exampleId = hub.entityCreate("exampleId", "noType");
	
	// Add the components for you entity
	Position examplePosition = hub.entityAddComponent!Position(exampleId);
	Movable exampleMovable = hub.entityAddComponent!Movable(exampleId);

	// Init all your component variables with values you need
	examplePosition.x = 2;
	examplePosition.y = 5;
	exampleMovable.speed = 3;
	

	// You can also create an entity this way
	import example.entities;
	EntityId playerId = createPlayer(hub);
}