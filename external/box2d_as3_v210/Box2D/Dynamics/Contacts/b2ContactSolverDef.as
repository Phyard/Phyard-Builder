package Box2D.Dynamics.Contacts
{
	import Box2D.Common.b2StackAllocator;
	
	public class b2ContactSolverDef
	{
		//b2Contact** contacts;
		public var contacts:Array;
		public var count:int;
		public var allocator:b2StackAllocator;
		public var impulseRatio:Number;
		public var warmStarting:Boolean;
	} // class
} // package
