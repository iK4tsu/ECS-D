module ecs.ientity;

import ecs.icomponent;
import ecs.componentManager;

public interface IEntity
{
	public void addComponent(T)(ComponentTypeId id);
	public bool removeComponent(ComponentTypeId id);

	public T getComponent(T)();
	public IComponent[] getComponents();
	public ComponentTypeId[] getComponentTypes();

	public bool hasComponent(ComponentTypeId id);
	public bool hasComponents(ComponentTypeId[] ids);
	public bool hasAnyComponent(ComponentTypeId[] ids);
}