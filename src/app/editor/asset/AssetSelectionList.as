
package editor.asset {
   
   import flash.utils.Dictionary;
   
   import editor.asset.Asset;
   
   public class AssetSelectionList 
   {  
      private var mSelectedAssets:Array = new Array ();
      
      public function GetNumSelectedAssets ():int
      {
         return mSelectedAssets.length;
      }
      
      public function GetSelectedAssets ():Array
      {
         return mSelectedAssets.concat (); // Clone
      }
      
      public function ClearSelectedAssets ():void
      {
         while (mSelectedAssets.length > 0)
         {
            if (mSelectedAssets [0] is Asset)
            {
               RemoveSelectedAsset (mSelectedAssets[0]);
            }
         }
      }
      
      public function AddSelectedAsset (asset:Asset):void
      {
         if (asset == null)
            return;
         
         for (var i:uint = 0; i < mSelectedAssets.length; ++ i)
         {
            if (mSelectedAssets [i] == asset)
               return;
         }
         
         mSelectedAssets.unshift (asset);
         asset.NotifySelectedChanged (true);
      }
      
      public function RemoveSelectedAsset (asset:Asset):void
      {
         if (asset == null)
            return;
         
         for (var i:uint = 0; i < mSelectedAssets.length; ++ i)
         {
            if (mSelectedAssets [i] == asset)
            {
               mSelectedAssets.splice (i, 1);
               asset.NotifySelectedChanged (false);
               return;
            }
         }
      }
      
      public function IsAssetSelected (asset:Asset):Boolean
      {
         if (asset == null)
            return false;
         
         for (var i:uint = 0; i < mSelectedAssets.length; ++ i)
         {
            if (mSelectedAssets [i] == asset)
            {
               return true;
            }
         }
         
         return false;
      }
      
      public function AreSelectedAssetsContainingPoint (pointX:Number, pointY:Number):Boolean
      {
         for (var i:uint = 0; i < mSelectedAssets.length; ++ i)
         {
            if (mSelectedAssets [i].ContainsPoint (pointX, pointY))
            {
               return true;
            }
         }
         
         return false;
      }
      
      public function GetSelectedMainAssets ():Array
      {
         var i:uint;
         var entity:Asset;
         
         var checkTable:Dictionary = new Dictionary ();
         var newArray:Array = new Array ();
          
         for (i = 0; i < mSelectedAssets.length; ++ i)
         {
            entity = (mSelectedAssets [i] as Asset).GetMainAsset ();
            
            if (checkTable [entity] != true)
            {
               newArray.push (entity);
               checkTable [entity] = true;
            }
         }
         
         return newArray;
      }
   }
}
