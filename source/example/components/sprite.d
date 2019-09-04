module example.components.sprite;

import ecs;


@safe pure final class Sprite : IComponent
{
	@safe pure public this(string _img = string.init) { img = _img; }

	string img;
}