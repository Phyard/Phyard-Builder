package editor.asset {

   public class IntentPutAsset extends IntentPut
   {
      protected var mAssetToPut:Asset;
      
      protected var mCallbackOnPutting_IntentPutAsset:Function;
      protected var mCallbackOnCancel_IntentPutAsset:Function;
      
      public function IntentPutAsset (assetToPut:Asset, callbackOnPutting:Function = null, callbackOnCancel:Function = null)
      {
         super (OnPutting, OnCancelled);
         
         mCallbackOnPutting_IntentPutAsset = callbackOnPutting;
         mCallbackOnCancel_IntentPutAsset = callbackOnCancel;
         
         mAssetToPut = assetToPut;
         
         if (mAssetToPut == null)
         {
            Terminate (true);
         }
      }
      
      protected function OnPutting (finished:Boolean):void
      {
         if (mCallbackOnPutting_IntentPutAsset != null)
         {
            mCallbackOnPutting_IntentPutAsset (mAssetToPut, finished);
         }
      }
      
      protected function OnCancelled ():void
      {
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
trace ("mAssetToPut.visible = " + mAssetToPut.visible + ", mAssetToPut.width = " + mAssetToPut.width + ", mAssetToPut.height = " + mAssetToPut.height);
         mAssetToPut.MoveTo (mCurrentX, mCurrentY, finished);
         
         super.Process (finished);
      }

   }
   
}
