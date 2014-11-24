package viewer
{
   public class ProxyAdvertisement
   {
      private var mExternalAdProxy:Object;
      
      public function ProxyAdvertisement (externalAdProxy:Object)
      {
         mExternalAdProxy = externalAdProxy;
      }
      
      public function Call (providerName:String, methodName:String, defaultReturnValue:*, ... args):*
      {
         if (mExternalAdProxy != null)
         {
            //return mExternalAdProxy.Call (providerName, methodName, defaultReturnValue, args);
            var params:Array = new Array (providerName, methodName, defaultReturnValue);
            return mExternalAdProxy.Call.apply (mExternalAdProxy, params.concat (args));
         }
         
         return defaultReturnValue;
      }
   }
}
