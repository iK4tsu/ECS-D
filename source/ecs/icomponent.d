module ecs.icomponent;


public interface IComponent {}


version(unittest)
{
	class Foo : IComponent { int someData; }
	class Goo : IComponent { string someData; }
}

@safe pure unittest
{
	Foo foo = new Foo();
	assert(foo.someData == int.init);
}

@safe pure unittest
{
	Foo foo = new Foo();
	Goo goo = new Goo();

	foo.someData = 4;
	goo.someData = "I am goo!";

	assert(foo.someData == 4);
	assert(goo.someData == "I am goo!");
}