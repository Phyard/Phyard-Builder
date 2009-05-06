package Box2D.Dynamics {
   
   import Box2D.Common.b2Settings;
   
   public class b2WorldDef
   {
      // there is a bug in flex sdk: sometimes, the compiler can recognise the vondy input params
      //public function b2WorldDef (maxProxies:uint = b2Settings.Default_b2_maxProxies, maxPairs:uint = b2Settings.Default_b2_maxPairs)
      public function b2WorldDef (maxProxies:uint = 1024 * 2 * 2, maxPairs:uint = 1024 * 2 * 2 * 8)
      {
         //@todo: adjust input values, make them 2^n
         
         b2_maxProxies = maxProxies;
         b2_maxPairs = maxPairs;
         
         //
         b2_tableCapacity = b2_maxPairs;
         b2_tableMask = b2_tableCapacity - 1;
      }
      
      
      // this must be a power of two
      public var b2_maxProxies:int;
      
      // this must be a power of two, must be less than B2BROADPHASE_MAX
      public var b2_maxPairs:int;
      
      //todo: B2_FLT_EPSILON
      
      
      
      //
      public var b2_tableCapacity:int;	// must be a power of two
      public var b2_tableMask:int;
   }
}
