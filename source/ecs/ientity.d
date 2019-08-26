module ecs.ientity;

import ecs.icomponent;
import ecs.componentType;

public interface IEntity
{
	public void AddComponent(ComponentType index, IComponent component);
	public void RemoveComponent(ComponentType index);

	public IComponent GetComponent(ComponentType index);
	public IComponent[] GetComponents();
	public ComponentType[] GetComponentTypes();

	public bool HasComponent(ComponentType index);
	public bool HasComponents(ComponentType[] indices);
	public bool HasAnyComponent(ComponentType[] indices);
}