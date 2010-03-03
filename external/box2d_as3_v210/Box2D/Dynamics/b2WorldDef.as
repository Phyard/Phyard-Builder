
package Box2D.Dynamics
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Vec2;
	import Box2D.Collision.b2BroadPhase;

	//this class doesn't exist in the c++ version
	public class b2WorldDef
	{
		public var gravity:b2Vec2 = b2Vec2.b2Vec2_From2Numbers (0.0, 9.8);
		public var doSleep:Boolean = true;
		public var collisionBroadPhase:b2BroadPhase = null;
		
		public var maxTranslation:Number = b2Settings.b2_maxTranslation;
	}
}
