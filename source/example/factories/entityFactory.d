module example.factories.entityFactory;


import ecs;


// import your components
import example.components;

void generateEntities(ref Hub hub)
{
	// Generate all your entities through the hub
	Entity example = hub.entity.create();
	
	// Add the components for you entity
	Position examplePosition = example.addComponent!Position;
	Movable exampleMovable = example.addComponent!Movable;

	// Init all your component variables with values you need
	examplePosition.x = 2;
	examplePosition.y = 5;
	exampleMovable.speed = 3;
	

	// You can also create an entity this way
	import example.entities;
	Entity player = createPlayer(hub);
}