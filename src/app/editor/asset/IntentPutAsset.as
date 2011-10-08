package editor.asset {

   public class IntentPutAsset extends IntentPut
   {
      protected var mAssetToPut:Asset;
      
      protected var mCallbackOnCancel_IntentPutAsset:Function;
      
      public function IntentPutAsset (assetToPut:Asset, callbackOnPutting:Function = null, callbackOnCancel:Function = null)
      {
         super (callbackOnPutting, OnCancelled);
         
         mCallbackOnCancel_IntentPutAsset = callbackOnCancel;
         
         mAssetToPut = assetToPut;
      }
      
      protected function OnCancelled ():void
      {
         mAssetToPut.GetAssetManager ().DestroyAsset (mAssetToPut);
         
         if (mCallbackOnCancel_IntentPutAsset != null)
         {
            mCallbackOnCancel_IntentPutAsset ();
         }
      }
      
   //================================================================
   // to override 
   //================================================================
      
      override protected function Process (finished:Boolean):void
      {
         mAssetToPut.MoveTo (mCurrentX, mCurrentY, finished);
         
         super.Process (finished);
      }

   }
   
}
