
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
      
      public function GetTheFirstSelectedAsset ():Asset
      {
         if (mSelectedAssets.length == 0)
            return null;
         
         return mSelectedAssets [0] as Asset;
      }
      
      public function AddSelectedAsset (asset:Asset, push:Boolean = false):void
      {
         if (asset == null)
            return;
         
         if (mSelectedAssets.indexOf (asset) >= 0)
            return;
         
         if (push)
            mSelectedAssets.push (asset);
         else
            mSelectedAssets.unshift (asset);
         
         asset.OnSelectedChanged (true);
      }
      
      public function RemoveSelectedAsset (asset:Asset):void
      {
         if (asset == null)
            return;
         
         var index:int = mSelectedAssets.indexOf (asset);
         if (index >= 0)
         {
            mSelectedAssets.splice (index, 1);
            asset.OnSelectedChanged (false);
         }
      }
      
      public function ClearSelectedAssets ():void
      {
         var oldSelectedAssets:Array = mSelectedAssets;
         mSelectedAssets = new Array ();
         
         for each (var asset:Asset in oldSelectedAssets)
         {
            asset.OnSelectedChanged (false);
         }
      }
      
      public function SetSelectedAssets (assetArray:Array):Boolean
      {
         if (assetArray == null)
         {
            if (mSelectedAssets.length > 0)
            {
               ClearSelectedAssets ();
               
               return true;
            }
            
            return false;
         }
         
         var asset:Asset;
         var actionId:int = Asset.GetNextActionId ();
         
         var assetsToSelect:Array = new Array ();
         for each (asset in assetArray)
         {
            asset.SetCurrentActionId (actionId);
            if (! asset.IsSelected ())
            {
               assetsToSelect.push (asset);
            }
         }
         
         var assetsToDeselect:Array = new Array ();
         var assetsToKeepSelected:Array = new Array ();
         for each (asset in mSelectedAssets)
         {
            if (asset.GetCurrentActionId () < actionId)
            {
               assetsToDeselect.push (asset);
            }
            else
            {
               assetsToKeepSelected.push (asset);
            }
         }
         
         if (assetsToSelect.length == 0 && assetsToDeselect.length == 0)
            return false;
         
         if (assetsToSelect.length == 0)
            mSelectedAssets = assetsToKeepSelected;
         else if (assetsToKeepSelected.length == 0)
            mSelectedAssets = assetsToSelect;
         else
            mSelectedAssets = assetsToSelect.concat (assetsToKeepSelected);
         
         for each (asset in assetsToDeselect)
         {
            asset.OnSelectedChanged (false);
         }
         
         for each (asset in assetsToSelect)
         {
            asset.OnSelectedChanged (true);
         }
         
         return true;
      }
      
      public function IsAssetSelected (asset:Asset):Boolean
      {
         if (asset == null)
            return false;
         
         return mSelectedAssets.indexOf (asset) >= 0;
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
