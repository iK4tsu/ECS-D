module example.factories.entityFactory;


import ecs;


// import your components
import example.components;

void generateEntities(ref Hub hub)
{
	// Generate all your entities through the hub
	Entity example = hub.entity.create();
	
	// Add the components for you entity with or without variables
	example.addComponent(new Position(2,5));
	Movable exampleMovable = example.addComponent!Movable;

	// Init all your component variables with values you need if you haven't
	exampleMovable.speed = 3;

	assert(example.getComponent!Movable == exampleMovable);
	assert(example.getComponent!Movable.speed == 3);


	// You can also create an entity this way
	import example.entities;
	Entity player = createPlayer(hub);
	
	player.name = "Player";
	player.type = "Player";
	player.description = "I'm a player!";


	Entity object = hub.entity.create();
	object.addComponent(new Position(2,3));
	object.addComponent(new Sprite("H"));


	Entity explosive = hub.entity.create();
	explosive.addComponent!Explosive;
	explosive.addComponent(new Position(2,1));
	explosive.addComponent(new Sprite("T"));


	Entity game = hub.entity.create();
	game.addComponent(new Area2D(5,5));
	game.getComponent!Area2D.entities ~= [player, object, explosive];
	game.getComponent!Area2D.eids ~= [player._id, object._id, explosive._id];

	player.addComponent(new Conection(game));
	object.addComponent(new Conection(game));
	explosive.addComponent(new Conection(game));
}