package editor.image {
   
   import editor.asset.IntentPut;
   
   import editor.image.dialog.AssetImageModuleListingPanel;
   
   public class IntentPickModule extends IntentPut
   {
      protected var mAssetImageModuleListingPanel:AssetImageModuleListingPanel;
      protected var mCallbackOnPick:Function;
      protected var mCallbackOnEnd:Function;
      
      public function IntentPickModule (assetImageModuleListingPanel:AssetImageModuleListingPanel, callbackOnPick:Function, callbackOnEnd:Function)
      {
         super (null, OnEnd);
         
         mAssetImageModuleListingPanel = assetImageModuleListingPanel;
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
            var module:AssetImageModule = mAssetImageModuleListingPanel.PickModuleAtPosition (mCurrentX, mCurrentY); 
            
            //if (module != null) // it is ok to set null
               mCallbackOnPick (module);
            
            OnEnd ();
         }
      }

   }
   
}
