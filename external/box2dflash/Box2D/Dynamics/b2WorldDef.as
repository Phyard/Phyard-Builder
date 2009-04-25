package Box2D.Dynamics {
   
   
   
   public class b2WorldDef
   {
      // should be larger than b2_maxPairs
      static public var B2BROADPHASE_MAX:int = 0x000fffff;
      
      // this must be a power of two
      static public var b2_maxProxies:int = 1024 * 2 * 2;
      
      // this must be a power of two, must be less than B2BROADPHASE_MAX
      static public var b2_maxPairs:int = 8 * b2_maxProxies * 16;	
      
      //B2_FLT_EPSILON
   }

}