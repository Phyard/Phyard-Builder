
package Box2D.Collision
{
	public interface b2RayCastCallbackOwner
	{
		function RayCastCallback (subInput:b2RayCastInput, nodeId:int):Number;
	}
}
