
# I/O Hooks Inheritance Example

This repository presents an example of how to use several Synergy DBL I/O Hooks
classes concurrently via inheritance.

The I/O hooks class HookClass1 is a regular standalone I/O hook implementation.

The I/O hooks class HookClass2 is also an I/O hook implementation, but notice
how it also inherits from HookClass1, and how the constructor calls the parent
class constructor, and how each override method also calls the parent class
method.

The program instantiates HookClass2 and associates it with the channel that
it has opened, and by doing so the code in both hooks classes is called
as I/O operations occur.

Note that the code in HookClass1 executes first. This is because the
HookClass2 constructor and methods call the equivalent code in HookClass1
(via the parent keyword) before executing their own code.
