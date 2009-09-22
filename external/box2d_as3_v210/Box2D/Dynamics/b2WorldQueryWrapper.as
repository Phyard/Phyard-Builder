
package Box2D.Dynamics
{
	import Box2D.Collision.b2QueryCallbackOwner;
	import Box2D.Collision.b2BroadPhase;
	
	public class b2WorldQueryWrapper implements b2QueryCallbackOwner
	{
		public function QueryCallback(proxyId:int):void
		{
			var fixture:b2Fixture = broadPhase.GetUserData(proxyId) as b2Fixture;
			callback.ReportFixture(fixture);
		}

		public var broadPhase:b2BroadPhase;
		public var callback:b2QueryCallback;
	} // class
} //package
