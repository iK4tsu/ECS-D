module ecs.isystem;

import ecs.entity;
import ecs.hub;

public interface ISystem
{
	public void update(EntityId eid);
	public void init(ref Hub hub);
}