module ecs.ientity;

import ecs.icomponent;
import ecs.componentType;

public interface IEntity
{
	template AddComponent(T) { public void AddComponent(ComponentType index); }
	public void RemoveComponent(ComponentType index);

	template GetComponent(T) { public IComponent GetComponent(ComponentType index); }
	public IComponent[] GetComponents();
	public ComponentType[] GetComponentTypes();

	public bool HasComponent(ComponentType index);
	public bool HasComponents(ComponentType[] indices);
	public bool HasAnyComponent(ComponentType[] indices);
}