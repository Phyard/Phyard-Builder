package Box2D.Collision
{
	import Box2D.Common.b2Vec2;
	
	/// A node in the dynamic tree. The client does not interact with this directly.
	public class b2DynamicTreeNode
	{
		public function IsLeaf():Boolean
		{
			return child1 == b2DynamicTree.b2_nullNode;
		}

		/// This is the fattened AABB.
		public var aabb:b2AABB = new b2AABB ();

		//int32 userData;
		public var userData:Object;

		//union
		//{
		//	int32 parent;
		//	int32 next;
		//};
		
		private var parent_or_next:int;
		
		//maybe the implementation is not very efficient
		public function set parent (p:int):void {parent_or_next = p;}
		public function get parent ():int {return parent_or_next;}
		public function set next (n:int):void {parent_or_next = n;}
		public function get next ():int {return parent_or_next;}

		public var child1:int;
		public var child2:int;
	} // class
} // package
