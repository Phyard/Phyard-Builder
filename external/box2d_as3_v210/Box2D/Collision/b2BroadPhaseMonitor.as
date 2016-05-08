
package Box2D.Collision
{
	// this interface doesn't exist in the c++ version
	// maybe it is not a good idea to create this interface, now only b2ContactManager implements this interface.
	// maybe it is better to put this function in b2ContactManager
	public interface b2BroadPhaseMonitor
	{
		// Broad-phase callback.
		//void AddPair(void* proxyUserDataA, void* proxyUserDataB);
		function AddPair(proxyUserDataA:Object, proxyUserDataB:Object):void;
	}
}
