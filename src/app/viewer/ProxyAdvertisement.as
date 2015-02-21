package viewer
{
   public class ProxyAdvertisement
   {
      private var mExternalAdProxy:Object;
      
      public function ProxyAdvertisement (externalAdProxy:Object)
      {
         mExternalAdProxy = externalAdProxy;
      }
      
      private static const kSupportAdProviders:Array = new Array ("admob");
      
      public function Call (providerName:String, methodName:String, defaultReturnValue:*, ... args):*
      {
         if (mExternalAdProxy != null)
         {
            var params:Array;
            if (providerName != null && providerName != "*")
            {
               //return mExternalAdProxy.Call (providerName, methodName, defaultReturnValue, args);
               params = new Array (providerName, methodName, defaultReturnValue);
               return mExternalAdProxy.Call.apply (mExternalAdProxy, params.concat (args));
            }
            
            for (providerName in kSupportAdProviders)
            {
               //return mExternalAdProxy.Call (providerName, methodName, defaultReturnValue, args);
               params = new Array (providerName, methodName, defaultReturnValue);
               mExternalAdProxy.Call.apply (mExternalAdProxy, params.concat (args));
               // the return must be not important
            }
         }
         
         return defaultReturnValue;
      }
   }
}
