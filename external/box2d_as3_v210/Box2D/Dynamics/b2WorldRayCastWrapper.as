
package Box2D.Dynamics
{
	import Box2D.Collision.b2RayCastCallbackOwner;
	import Box2D.Collision.b2BroadPhase;
	import Box2D.Collision.b2RayCastInput;
	import Box2D.Collision.b2RayCastOutput;
	import Box2D.Common.b2Vec2;
	
	public class b2WorldRayCastWrapper implements b2RayCastCallbackOwner
	{
		public function RayCastCallback(input:b2RayCastInput, proxyId:int):Number
		{
			var userData:Object = broadPhase.GetUserData(proxyId);
			var fixture:b2Fixture = userData as b2Fixture;
			var output:b2RayCastOutput = new b2RayCastOutput (); // if this is a member variable, the followed "output.normal" must be cloned 
			var hit:Boolean = fixture.RayCast(output, input);

			if (hit)
			{
				var fraction:Number = output.fraction;
				//b2Vec2 point = (1.0f - fraction) * input.p1 + fraction * input.p2;
				var point:b2Vec2 = new b2Vec2 ();
				point.x = (1.0 - fraction) * input.p1.x + fraction * input.p2.x;
				point.y = (1.0 - fraction) * input.p1.y + fraction * input.p2.y;
				return callback.ReportFixture(fixture, point, output.normal, fraction); // "output.normal" must be cloned if "output" is a member variable
			}

			return input.maxFraction;
		}

		public var broadPhase:b2BroadPhase;
		public var callback:b2RayCastCallback;
	} // class
} //package
