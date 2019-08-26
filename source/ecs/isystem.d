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

		if (_hub._entityManager.HasComponents(eid, [Position, Movable]))
		{
			position = _hub._entityManager.GetComponent!(PositionComponent)(eid, Position);
			movable = _hub._entityManager.GetComponent!(MovableComponent)(eid, Movable);

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

	EntityId e = _hub._entityManager.CreateEntity();
	Entity _entity = _hub._entityManager.GetEntity(e);

	_entity.AddComponent!(PositionComponent)(Position);
	_entity.AddComponent!(MovableComponent)(Movable);

	_entity.GetComponent!(MovableComponent)(Movable).moveX = 4;

	_system.Update(e);

	assert(_entity.GetComponent!(PositionComponent)(Position).x == 4);

	_entity.RemoveComponent(Movable);

	_system.Update(e);

	assert(_entity.GetComponent!(PositionComponent)(Position).x == 4);
}