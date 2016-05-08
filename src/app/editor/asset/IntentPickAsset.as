package editor.asset {
   
   public class IntentPickAsset extends IntentPut
   {
      protected var mAssetManagerPanel:AssetManagerPanel;
      protected var mCallbackOnPick:Function;
      protected var mCallbackOnEnd:Function;
      
      public function IntentPickAsset (assetManagerPanel:AssetManagerPanel, callbackOnPick:Function, callbackOnEnd:Function)
      {
         super (null, OnEnd);
         
         mAssetManagerPanel = assetManagerPanel;
         mCallbackOnPick = callbackOnPick;
         mCallbackOnEnd = callbackOnEnd;
      }
      
      protected function OnEnd ():void
      {
         if (mCallbackOnEnd != null)
         {
            mCallbackOnEnd ();
         }
      }
      
   //================================================================
   // to override 
   //================================================================
      
      override protected function Process (finished:Boolean):void
      {
         if (mCallbackOnPick != null && finished)
         {
            var asset:Asset = mAssetManagerPanel.PickAssetAtPosition (mCurrentX, mCurrentY); 
            
            //if (module != null) // it is ok to set null
               mCallbackOnPick (asset);
            
            OnEnd ();
         }
      }

   }
   
}
