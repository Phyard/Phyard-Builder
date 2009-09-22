
package Box2D.Common
{
	//struct b2Version
	public class b2Version
	{
		public function b2Version (ma:int, mi:int, rev:int)
		{
			major = ma;
			minor = mi;
			revision = rev;
		}
		
		public var major:int;		///< significant changes
		public var minor:int;		///< incremental changes
		public var revision:int;		///< bug fixes
	} // class
} // package
