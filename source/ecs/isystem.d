module ecs.isystem;

import ecs.entity;
import ecs.icomponent;
import ecs.componentType;
import ecs.hub;

public interface ISystem
{
	public void update(EntityId eid);
	public void SetHub(Hub hub);
}


class MovementSystem : ISystem
{
	private Hub _hub;

	public void SetHub(Hub hub) { _hub = hub; }

	public void update(EntityId eid)
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