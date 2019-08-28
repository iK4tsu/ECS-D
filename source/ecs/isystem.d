module ecs.isystem;

import ecs.entity;
import ecs.icomponent;
import ecs.componentType;
import ecs.hub;

public interface ISystem
{
	public void Update(EntityId eid);
	public void SetHub(Hub hub);
}


class MovementSystem : ISystem
{
	private Hub _hub;

	public void SetHub(Hub hub) { _hub = hub; }

	public void Update(EntityId eid)
	{
		PositionComponent position;
		MovableComponent movable;

		if (_hub._entityManager.hasComponents(eid, [1, 2]))
		{
			position = _hub._entityManager.getComponent!(PositionComponent)(eid);
			movable = _hub._entityManager.getComponent!(MovableComponent)(eid);

			position.x += movable.moveX;
			position.y += movable.moveY;
		}
	}
}


unittest
{
	Hub _hub = new Hub;
	MovementSystem _system = new MovementSystem();
	_system.SetHub(_hub);

	EntityId e = _hub._entityManager.createEntity();
	Entity _entity = _hub._entityManager.getEntity(e);

	_entity.addComponent!(PositionComponent)(1);
	_entity.addComponent!(MovableComponent)(2);

	_entity.getComponent!(MovableComponent).moveX = 4;

	assert(_entity.hasComponents([1, 2]));

	_system.Update(e);

	assert(_entity.getComponent!PositionComponent.x == 4);

	_entity.removeComponent(2);

	_system.Update(e);

	assert(_entity.getComponent!PositionComponent.x == 4);
}