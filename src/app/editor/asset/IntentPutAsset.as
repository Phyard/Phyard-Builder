package editor.asset {

   public class IntentPutAsset extends IntentPut
   {
      protected var mAssetToPut:Asset;
      
      public function IntentPutAsset (assetToPut:Asset, callbackOnPut:Function = null, callbackOnCancel:Function = null)
      {
         super (callbackOnPut, callbackOnCancel);
         
         mAssetToPut = assetToPut;
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
