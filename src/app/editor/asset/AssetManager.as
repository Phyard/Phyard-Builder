
package editor.asset {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Matrix;
   
   import flash.utils.Dictionary;
   
   import editor.selection.SelectionEngine;
   
   import editor.core.EditorObject;
   
   import editor.EditorContext;
   
   import common.CoordinateSystem;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetManager extends EditorObject 
   {
      public var mCoordinateSystem:CoordinateSystem;
      
      public var mSelectionEngine:SelectionEngine; // used within package
      
      public var mSelectionList:AssetSelectionList;
      
      public var mBrothersManager:BrothersManager;
      
      protected var mAssetsSortedByCreationId:Array = new Array ();
      
      public function AssetManager ()
      {
         mCoordinateSystem = CoordinateSystem.kDefaultCoordinateSystem;
         
         mSelectionEngine = new SelectionEngine ();
         
         mSelectionList = new AssetSelectionList ();
         
         mBrothersManager = new BrothersManager ();
      }
      
      public function GetSelectionEngine ():SelectionEngine
      {
         return mSelectionEngine;
      }
      
      public function SupportScaleRotateFlipTransforms ():Boolean
      {
         if (mAssetManagerLayout != null)
            return mAssetManagerLayout.SupportScaleRotateFlipTransforms ();
         
         return true;
      }
      
//=================================================================================
//   coordinates
//=================================================================================
      
      public function GetCoordinateSystem ():CoordinateSystem
      {
         return mCoordinateSystem;
      }
      
      public function RebuildCoordinateSystem (originX:Number, originY:Number, scale:Number, rightHand:Boolean):void
      {
         if (scale <= 0)
            scale = 1.0;
         
         mCoordinateSystem = new CoordinateSystem (originX, originY, scale, rightHand);
      }
      
//=================================================================================
//   
//=================================================================================
      
      protected var mAssetManagerLayout:AssetManagerLayout = null;
      
      public function GetLayout ():AssetManagerLayout
      {
         return mAssetManagerLayout;
      }
      
      public function SetLayout (layout:AssetManagerLayout):void
      {
         mAssetManagerLayout = layout;
      }
      
      public function UpdateLayout (forcely:Boolean = false, alsoUpdateAssetAppearance:Boolean = false):void
      {
         if (mAssetManagerLayout != null)
         {
            mAssetManagerLayout.DoLayout (forcely, alsoUpdateAssetAppearance);
         }
      }

      // recommended
      public function GetAssetSpriteWidth ():Number
      {
         if (mAssetManagerLayout != null)
            return mAssetManagerLayout.GetAssetSpriteWidth ();
         
         return 100;
      }
      
      // recommended
      public function GetAssetSpriteHeight ():Number
      {
         if (mAssetManagerLayout != null)
            return mAssetManagerLayout.GetAssetSpriteHeight ();
         
         return 100;
      }
      
      // recommended
      public function GetAssetSpriteGap ():Number
      {
         if (mAssetManagerLayout != null)
            return mAssetManagerLayout.GetAssetSpriteGap ();
         
         return 10;
      }
      
//=================================================================================
//   
//=================================================================================
      
      public function SetPosition (px:Number, py:Number):void
      {
         x = px;
         y = py;
         
         UpdateLayout ();
      }
      
      public function GetPositionX ():Number
      {
         return x;
      }
      
      public function GetPositionY ():Number
      {
         return y;
      }
      
      public function SetScale (s:Number):void
      {
         scaleX = scaleY = s;
         
         var numAssets:int = mAssetsSortedByCreationId.length;
         
         for (var i:uint = 0; i < numAssets; ++ i)
         {
            var asset:Asset = GetAssetByCreationId (i);
            
            if (asset != null)
            {
               asset.OnManagerScaleChanged ();
            }
         }
         
         UpdateLayout ();
      }
      
      public function GetScale ():Number
      {
         return scaleX;
      }
      
      public function OnViewportSizeChanged ():void
      {
         UpdateLayout ();
      }
      
//=================================================================================
//   update
//=================================================================================
      
      public function Update (escapedTime:Number):void
      {
         var numAssets:int = mAssetsSortedByCreationId.length;
         
         for (var i:uint = 0; i < numAssets; ++ i)
         {
            var asset:Asset = GetAssetByCreationId (i);
            
            if (asset != null)
            {
               asset.Update (escapedTime);
            }
         }
      }
      
//=================================================================================
//   
//=================================================================================
      
      private var mAccAssetId:int = 0; // used to create key
      
      final public function GetAccAssetId ():int
      {
         return mAccAssetId;
      }
      
      protected function ValidateAssetKey (key:String):String
      {  
         if (key != null && key.length == 0)
            key = null;
         
         while (key == null || mLookupTableByKey [key] != null)
         {
            key = EditorObject.BuildKey (GetAccAssetId ());
         }
         
         return key;
      }
      
      final public function OnAssetCreated (asset:Asset):void
      {
         if (asset.GetKey () != null)
         {
            //>> generally, this will not happen
            var oldAsset:Asset = mLookupTableByKey [asset.GetKey ()];
            if (oldAsset != null)
            {
               DestroyAsset (oldAsset);
            }
            //<<
            
            mLookupTableByKey [asset.GetKey ()] = asset;
         }
         
         // ...
         
         ++ mAccAssetId; // never decrease
         
         // ...
         
         mNeedToCorrectAssetCreationIds = true;
         
         if (mIsCreationArrayOpened)
         {
            if (mAssetsSortedByCreationId.indexOf (asset) < 0)
               mAssetsSortedByCreationId.push (asset);
         }
      }
      
      final public function OnAssetDestroyed (asset:Asset):void
      {
         if (asset.GetKey () != null)
         {
            delete mLookupTableByKey [asset.GetKey ()];
         }
         
         // ...
         
         mNeedToCorrectAssetCreationIds = true;
         
         if (mIsCreationArrayOpened)
         {
            var index:int = mAssetsSortedByCreationId.indexOf (asset);
            if (index >= 0)
            {
               mAssetsSortedByCreationId.splice (index, 1);
               asset.SetCreationOrderId (-1);
            }
         }
      }
      
//=================================================================================
//   destroy assets
//=================================================================================
      
      public function Destroy ():void
      {
         DestroyAllAssets ();
         
         mSelectionEngine.Destroy ();
         
         NotifyDestroyedForReferers ();
      }
      
      public function DestroyAllAssets ():void
      {
         while (mAssetsSortedByCreationId.length > 0)
         {
            var asset:Asset = GetAssetByCreationId (0);
            DestroyAsset (asset.GetMainAsset ());
         }
      }
      
      public function DestroyAsset (asset:Asset):void
      {
         mBrothersManager.OnDestroyAsset (asset);
         
         mSelectionList.RemoveSelectedAsset (asset);
         
         asset.Destroy ();
         
         if ( contains (asset) )
         {
            removeChild (asset);
         }
         
         if (asset == mCachedLastSelectedAsset)
         {
            mCachedLastSelectedAsset = null;
         }
      }

//=================================================================================
//   brothers (only useful for some certain AssetManagers)
//=================================================================================

      public function GetBrotherGroups ():Array
      {
         return mBrothersManager.mBrotherGroupArray;
      }

      public function MakeBrothers (assets:Array):void
      {
         mBrothersManager.MakeBrothers (assets);
      }

      public function MakeSelectedAssetsBrothers ():void
      {
         mBrothersManager.MakeBrothers (GetSelectedAssets ());
      }

      public function MakeBrothersByCreationIds (entityIndices:Array):void
      {
         var entities:Array = new Array (entityIndices.length);

         for (var i:int = 0; i < entityIndices.length; ++ i)
         {
            entities [i] = GetAssetByCreationId (entityIndices [i]);
         }

         mBrothersManager.MakeBrothers (entities);
      }

      public function BreakBrothersApartBwtweenSelectedAssets ():void
      {
         var assetArray:Array = GetSelectedAssets ();

         mBrothersManager.BreakBrothersApart (assetArray);
      }

      public function GetBrothersOfAsset (asset:Asset):Array
      {
         var brothers:Array = mBrothersManager.GetBrothersOfAsset (asset);
         return brothers == null ? new Array () : brothers;
      }
      
      public function GetAllBrothersOfAssets (assets:Array):Array
      {
         var allGluedAssets:Array = new Array ();
         
         var asset:Asset;
         var brothers:Array;
         var actionId:int = ++ EditorContext.mNextActionId;
         var brotherGroups:Array = new Array ();
         
         for each (asset in assets)
         {
            if (asset.GetCurrentActionId () < actionId)
            {
               asset.SetCurrentActionId (actionId);
               allGluedAssets.push (asset);
            }
            
            brothers = asset.GetBrothers ();

            if (brothers != null)
            {
               if (brotherGroups.indexOf (brothers) < 0)
                  brotherGroups.push (brothers);
            }
         }
         
         for each (brothers in brotherGroups)
         {
            for each (asset in brothers)
            {
               if (asset.GetCurrentActionId () < actionId)
               {
                  asset.SetCurrentActionId (actionId);
                  allGluedAssets.push (asset);
               }
            }
         }
         
         return allGluedAssets;
      }

      public function SelectAllBrothersOfSelectedAssets ():void
      {
         var brotherGroups:Array = new Array ();
         var assetId:int;
         var brothers:Array;
         var groupId:int;
         var index:int;
         var asset:Asset;

         var selectedAssets:Array = GetSelectedAssets ();

         for (assetId = 0; assetId < selectedAssets.length; ++ assetId)
         {
            brothers = (selectedAssets [assetId] as Asset).GetBrothers ();

            if (brothers != null)
            {
               index = brotherGroups.indexOf (brothers);
               if (index < 0)
                  brotherGroups.push (brothers);
            }
         }

         for (groupId = 0; groupId < brotherGroups.length; ++ groupId)
         {
            brothers = brotherGroups [groupId];

            for (assetId = 0; assetId < brothers.length; ++ assetId)
            {
               asset = brothers [assetId] as Asset;

               //if ( ! IsEntitySelected (entity) )
               if ( ! asset.IsSelected () )  // not formal, but fast
               {
                  //SelectAsset (entity);
                  AddAssetSelection (asset);
               }
            }
         }
      }
      
//=================================================================================
//   selection list
//=================================================================================
      
      public function OnAssetSelectionsChanged ():void
      {
         // called by Panel
         // to override
      }
      
      //============= 3 basic ones
      
      public function CancelAllAssetSelections ():void
      {
         mSelectionList.ClearSelectedAssets ();
         
         mMainSelectedAsset = null;
      }
      
      public function AddAssetSelection (asset:Asset):void
      {
         if (asset != null)
         {
            mSelectionList.AddSelectedAsset (asset);
         }
      }
      
      public function CancelAssetSelection (asset:Asset):void
      {
         if (asset != null)
         {
            mSelectionList.RemoveSelectedAsset (asset)
            
            if (asset == mMainSelectedAsset)
            {
               mMainSelectedAsset = null;
            }
         }
      }
      
      //========================
      
      public function GetNumSelectedAssets ():int
      {
         return mSelectionList.GetNumSelectedAssets ();
      }
      
      public function GetSelectedAssets ():Array
      {
         return mSelectionList.GetSelectedAssets ();
      }
      
      public function GetTheFirstSelectedAsset ():Asset
      {
         return mSelectionList.GetTheFirstSelectedAsset ();
      }
      
      public function AddAssetSelections (assetArray:Array):void
      {
         if (assetArray == null)
            return;
         
         for (var i:uint = 0; i < assetArray.length; ++ i)
         {
            AddAssetSelection (assetArray[i] as Asset);
         }
      }
      
      public function CancelAssetSelections (assetArray:Array):void
      {
         if (assetArray == null)
            return;
         
         for (var i:uint = 0; i < assetArray.length; ++ i)
         {
            CancelAssetSelection (assetArray[i] as Asset);
         }
      }
      
      // return whether selections changed or not
      public function SetSelectedAssets (assetArray:Array):Boolean
      {
         return mSelectionList.SetSelectedAssets (assetArray);
      }
      
      public function SetSelectedAssetsByToggleTwoAssetArrays (oldSelections:Array, newSelections:Array):Boolean
      {
         if (oldSelections == null && newSelections == null)
         {
            if (mSelectionList.GetNumSelectedAssets () > 0)
            {
               CancelAllAssetSelections ();
               
               return true;
            }
            
            return false;
         }
         
         if (oldSelections == null)
         {
            return SetSelectedAssets (newSelections);
         }
         
         if (newSelections == null)
         {
            return SetSelectedAssets (oldSelections);
         }
         
         var assetsToSelect:Array = new Array ();
         
         var asset:Asset;
         var actionId1:int;
         var actionId2:int;

         actionId1 = ++ EditorContext.mNextActionId;
         for each (asset in newSelections)
         {
            asset.SetCurrentActionId (actionId1);
         }
         
         actionId2 = ++ EditorContext.mNextActionId;
         for each (asset in oldSelections)
         {
            if (asset.GetCurrentActionId () < actionId1)
               assetsToSelect.push (asset);
            
            asset.SetCurrentActionId (actionId2);
         }
         
         for each (asset in newSelections)
         {
            if (asset.GetCurrentActionId () < actionId2)
               assetsToSelect.push (asset);
            
            asset.SetCurrentActionId (actionId1);
         }
         
         return SetSelectedAssets (assetsToSelect);
      }
      
      // return whether selections changed or not
      public function SetSelectedAsset (asset:Asset, mainSelection:Boolean = true):Boolean
      {
         SetMainSelectedAsset (mainSelection ? asset : null);
         
         var assets:Array;
         if (asset == null)
            assets = new Array ();
         else
         {
            assets = new Array (1);
            assets [0] = asset;
         }
         
         return SetSelectedAssets (assets);
      }
      
      public function ToggleAssetSelected (asset:Asset):void
      {
         if ( IsAssetSelected (asset) )
            CancelAssetSelection (asset);
         else
            AddAssetSelection (asset);
      }
      
      protected var mMainSelectedAsset:Asset = null;
      
      public function GetMainSelectedAsset ():Asset
      {
         return mMainSelectedAsset;
      }
      
      public function SetMainSelectedAsset (asset:Asset):void
      {
         mMainSelectedAsset = asset;
      }
      
      public function IsAssetSelected (asset:Asset):Boolean
      {
         return mSelectionList.IsAssetSelected (asset);
      }
      
      public function AreSelectedAssetsContainingPoint (pointX:Number, pointY:Number):Boolean
      {
         return mSelectionList.AreSelectedAssetsContainingPoint (pointX, pointY);
      }
      
      public function SupportSelectingEntitiesWithMouse ():Boolean
      {
         return true;
      }
      
//=================================================================================
//   select assets / control points / linkables
//=================================================================================
      
      public function GetObjectAssetAncestor (displayObject:DisplayObject):Asset
      {
         while (displayObject != null)
         {
            if (displayObject is Asset)
               return displayObject as Asset;
            else
               displayObject = displayObject.parent;
         }
         
         return null;
      }
      
      private function Sorter_ByAppearanceOrder (o1:Object, o2:Object):int
      {
         var id1:int = -1;
         var id2:int = -1;
         
         var asset:Asset;
         
         asset = o1 as Asset;
         if (asset != null)
            id1 = asset.GetAppearanceLayerId ();
         else
         {
            asset = GetObjectAssetAncestor (o1 as DisplayObject);
            if (asset != null)
               id1 = asset.GetAppearanceLayerId ();
         }
         
         asset = o2 as Asset;
         if (asset != null)
            id2 = asset.GetAppearanceLayerId ();
         else
         {
            asset = GetObjectAssetAncestor (o2 as DisplayObject);
            if (asset != null)
               id2 = asset.GetAppearanceLayerId ();
         }
         
         if (id1 > id2)
            return -1;
         else if (id1 < id2)
            return 1;
         else
            return 0;
      }
      
      public function GetAssetsIntersectWithRegion (displayX1:Number, displayY1:Number, displayX2:Number, displayY2:Number):Array
      {
         var objectArray:Array = mSelectionEngine.GetObjectsIntersectWithRegion (displayX1, displayY1, displayX2, displayY2);
         
         return ConvertObjectArrayToAssetArray (objectArray);
      }
      
      private var mCachedLastSelectedAsset:Asset = null; // for asset overlapping cases
      
      public function GetAssetsAtPoint (managerX:Number, managerY:Number):Array
      {
         var objectArray:Array = mSelectionEngine.GetObjectsAtPoint (managerX, managerY);
         
         return FilterAssets (objectArray);
      }
      
      public function FilterAssets (objectArray:Array):Array
      {
         var assetArray:Array = ConvertObjectArrayToAssetArray (objectArray);
         assetArray.sort (Sorter_ByAppearanceOrder);
         
         if (mCachedLastSelectedAsset != null)
         {
            for (var i:int = 0; i < assetArray.length - 1; ++ i)
            {
               if (assetArray [i] == mCachedLastSelectedAsset)
               {
                  while (i -- >= 0)
                  {
                     assetArray.push (assetArray.shift ());
                  }
                  
                  break;
               }
            }
         }
         
         if (assetArray.length > 0)
         {
            mCachedLastSelectedAsset = assetArray [0] as Asset;
         }
         
         return assetArray;
      }
      
      private function ConvertObjectArrayToAssetArray (objectArray:Array):Array
      {
         var assetArray:Array = new Array ();
         
         for (var i:uint = 0; i < objectArray.length; ++ i)
         {
            if (objectArray [i] is Asset && (objectArray [i] as Asset).IsVisibleForEditing ())
            {
               assetArray.push (objectArray [i]);
            }
         }
         
         return assetArray;
      }
      
      public function GetFirstLinkableAtPoint (displayX:Number, displayY:Number, objectArray:Array = null):Linkable
      {
         if (objectArray == null)
            objectArray = mSelectionEngine.GetObjectsAtPoint (displayX, displayY);
         
         objectArray.sort (Sorter_ByAppearanceOrder);
         var linkable:Linkable = null;
         for (var i:uint = 0; i < objectArray.length; ++ i)
         {
            var obj:Object = objectArray [i];
            
            if (obj is Linkable)
            {
               if ( (! (obj is Asset)) || (obj as Asset).IsVisibleForEditing ())
               {
                  linkable = obj as Linkable;
                  if (linkable.CanStartCreatingLink (displayX, displayY))
                     return linkable;
                  else
                     return null;
               }
            }
         }
         
         return null;
      }
      
      public function GetControlPointsAtPoint (displayX:Number, displayY:Number):Array
      {
         var objectArray:Array = mSelectionEngine.GetObjectsAtPoint (displayX, displayY);
         
         return FilterControlPoints (objectArray);
      }
      
      public function FilterControlPoints (objectArray:Array):Array
      {
         var controlPointArray:Array = new Array ();
         
         for (var i:uint = 0; i < objectArray.length; ++ i)
         {
            if (objectArray [i] is ControlPoint)
               controlPointArray.push (objectArray [i]);
         }
         
         return controlPointArray;
      }
      
      public function GetSelectableObjectsAtPoint (displayX:Number, displayY:Number):Array
      {
         return mSelectionEngine.GetObjectsAtPoint (displayX, displayY);
      }
      
//=================================================================================
//   actions on selected assets
//=================================================================================
      
      public function DeleteSelectedAssets (passively:Boolean = false):Boolean
      {
         var assetArray:Array = mSelectionList.GetSelectedMainAssets ();
         
         var asset:Asset;
         
         var count:int = 0;
         
         for (var i:int = 0; i < assetArray.length; ++ i)
         {
            asset = assetArray [i] as Asset;
            
            DestroyAsset (asset);
            
            ++ count;
         }
         
         if (count > 0)
         {
            NotifyModifiedForReferers ();
            
            UpdateLayout (true);
         }
         
         return count > 0;
      }
      
      public function GetMoveSelectedAssetsStyle ():int
      {
         if (mAssetManagerLayout == null)
            return AssetManagerPanel.kMoveSelectedAssetsStyle_Smooth;
            
         return mAssetManagerLayout.GetMoveSelectedAssetsStyle ();
      }
      
      public function MoveSelectedAssets (moveBodyTexture:Boolean, offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean):void
      {
         if ((GetMoveSelectedAssetsStyle () != AssetManagerPanel.kMoveSelectedAssetsStyle_Smooth) && (! moveBodyTexture))
            return;
         
         var assetArray:Array = GetSelectedAssets ();
         
         var asset:Asset;
         
         for (var i:int = 0; i < assetArray.length; ++ i)
         {
            asset = assetArray [i] as Asset;
            
            if (moveBodyTexture)
               asset.MoveBodyTexture (offsetX, offsetY/*, updateSelectionProxy*/);
            else
               asset.Move (offsetX, offsetY/*, updateSelectionProxy*/);
            
            if (updateSelectionProxy)
            {
               asset.OnTransformIntentDone ();
            }
         }
         
         if (updateSelectionProxy && assetArray.length > 0)
         {
            NotifyModifiedForReferers ();
         }
      }
      
      public function RotateSelectedAssets (rotateBodyTexture:Boolean, updateSelectionProxy:Boolean, deltaRot:Number, rotateSelf:Boolean, rotatePosition:Boolean = false, centerX:Number = NaN, centerY:Number = NaN):void
      {
         var assetArray:Array = GetSelectedAssets ();
         
         var asset:Asset;
         
         var cos:Number = Math.cos (deltaRot);
         var sin:Number = Math.sin (deltaRot);
         //var updateSelectionProxyWhenRotatePosition:Boolean = updateSelectionProxy && (! rotateSelf);
         
         for (var i:int = 0; i < assetArray.length; ++ i)
         {
            asset = assetArray [i] as Asset;
            
            if (rotatePosition)
            {
               if (rotateBodyTexture)
                  asset.RotateBodyTexturePositionByCosSin (centerX, centerY, cos, sin/*, updateSelectionProxyWhenRotatePosition*/);
               else
                  asset.RotatePositionByCosSin (centerX, centerY, cos, sin/*, updateSelectionProxyWhenRotatePosition*/);
            }
            
            if (rotateSelf)
            {
               if (rotateBodyTexture)
                  asset.RotateBodyTextureSelf (deltaRot/*, updateSelectionProxy*/);
               else
                  asset.RotateSelf (deltaRot/*, updateSelectionProxy*/);
            }
            
            if (updateSelectionProxy)
            {
               asset.OnTransformIntentDone ();
            }
         }
         
         if (updateSelectionProxy && assetArray.length > 0)
         {
            NotifyModifiedForReferers ();
         }
      }
      
      public function ScaleSelectedAssets (scaleBodyTexture:Boolean, updateSelectionProxy:Boolean, s:Number, scaleSelf:Boolean, scalePosition:Boolean = false, centerX:Number = NaN, centerY:Number = NaN):void
      {
         var assetArray:Array = GetSelectedAssets ();
         
         var asset:Asset;
         
         //var updateSelectionProxyWhenScalePosition:Boolean = updateSelectionProxy && (! scaleSelf);
         
         for (var i:int = 0; i < assetArray.length; ++ i)
         {
            asset = assetArray [i] as Asset;
            
            if (scalePosition)
            {
               if (scaleBodyTexture)
                  asset.ScaleBodyTexturePosition (centerX, centerY, s/*, updateSelectionProxyWhenScalePosition*/);
               else
                  asset.ScalePosition (centerX, centerY, s/*, updateSelectionProxyWhenScalePosition*/);
            }
            
            if (scaleSelf)
            {
               if (scaleBodyTexture)
                  asset.ScaleBodyTextureSelf (s/*, updateSelectionProxy*/);
               else
                  asset.ScaleSelf (s/*, updateSelectionProxy*/);
            }
            
            if (updateSelectionProxy)
            {
               asset.OnTransformIntentDone ();
            }
         }
         
         if (updateSelectionProxy && assetArray.length > 0)
         {
            NotifyModifiedForReferers ();
         }
      }
      
      public function FlipSelectedAssets (flipBodyTexture:Boolean, updateSelectionProxy:Boolean, flipSelf:Boolean, flipPosition:Boolean = false, planeX:Number = NaN):void
      {
         var assetArray:Array = GetSelectedAssets ();
         
         var asset:Asset;
         
         //var updateSelectionProxyWhenScalePosition:Boolean = updateSelectionProxy && (! flipSelf);
         
         for (var i:int = 0; i < assetArray.length; ++ i)
         {
            asset = assetArray [i] as Asset;
            
            if (flipPosition)
            {
               if (flipBodyTexture)
                  asset.FlipBodyTexturePosition (planeX/*, updateSelectionProxyWhenScalePosition*/);
               else
                  asset.FlipPosition (planeX/*, updateSelectionProxyWhenScalePosition*/);
            }
            
            if (flipSelf)
            {
               if (flipBodyTexture)
                  asset.FlipBodyTextureSelf (/*updateSelectionProxy*/);
               else
                  asset.FlipSelf (/*updateSelectionProxy*/);
            }
            
            if (updateSelectionProxy)
            {
               asset.OnTransformIntentDone ();
            }
         }
         
         if (assetArray.length > 0)
         {
            NotifyModifiedForReferers ();
         }
      }
      
      //public function AdjustAssetAppearanceOrder (asset:Asset, newIndex:int):void
      //{
      //   if (newIndex < 0 || newIndex >= GetNumAssets ())
      //      return;
      //   
      //   if (asset == null || asset.GetAssetManager () != this)
      //      return;
      //   
      //   var currentIndex:int = asset.GetAppearanceLayerId ();
      //   if (currentIndex == newIndex)
      //      return;
      //   
      //   removeChild (asset);
      //   addChildAt (asset, newIndex);
      //   
      //   NotifyModifiedForReferers ();
      //}
      
      public function MoveSelectedAssetsToIndex (aCurrentIndex:int):void
      {
         MoveAssetsToIndex (GetSelectedAssets (), aCurrentIndex);
      }
      
      public function MoveAssetsToIndex (assetArray:Array, aCurrentIndex:int):void
      {
         if (assetArray == null)
            return;
         
         assetArray.sortOn("appearanceLayerId", Array.NUMERIC);
         
         var count:int = numChildren;
         
         if (count == assetArray.length)
            return;
         
         var beforeAsset:Asset = null;
         
         var asset:Asset;
         var i:int;
         for (i = aCurrentIndex; i < count; ++ i)
         {
            asset = getChildAt (i) as Asset;
            if ((! asset.IsSelected ()) && contains (asset))
            {
               beforeAsset = asset;
               break;
            }
         }
         
         for (i = 0; i < assetArray.length; ++ i)
         {
            asset = assetArray [i] as Asset;
            
            if ( asset != null && contains (asset) )
            {
               removeChild (asset);
               addChildAt (asset, beforeAsset == null ? count - 1 : getChildIndex (beforeAsset));
            }
         }
         
         if (assetArray.length > 0)
         {
            NotifyModifiedForReferers ();
         }
      }
      
      public function MoveSelectedAssetsToTop ():void
      {
         var assetArray:Array = GetSelectedAssets ();
         assetArray.sortOn("appearanceLayerId", Array.NUMERIC);
         
         var asset:Asset;
         
         for (var i:int = 0; i < assetArray.length; ++ i)
         {
            asset = assetArray [i];
            
            //if ( asset.GetMainAsset () != null && contains (asset.GetMainAsset ()) )
            //{
            //   removeChild (asset.GetMainAsset ());
            //   addChild (asset.GetMainAsset ());
            //}
            
            if ( asset != null && contains (asset) )
            {
               removeChild (asset);
               addChild (asset);
            }
         }
         
         if (assetArray.length > 0)
         {
            NotifyModifiedForReferers ();
         }
      }
      
      public function MoveSelectedAssetsToBottom ():void
      {
         var assetArray:Array = GetSelectedAssets ();
         assetArray.sortOn("appearanceLayerId", Array.NUMERIC);
         
         var asset:Asset;
         
         for (var i:int = assetArray.length - 1; i >= 0; -- i)
         {
            asset = assetArray [i];
            
            if ( asset != null && contains (asset) )
            {
               removeChild (asset);
               addChildAt (asset, 0);
            }
            
            //if ( asset.GetMainAsset () != null && contains (asset.GetMainAsset ()) )
            //{
            //   removeChild (asset.GetMainAsset ());
            //   addChildAt (asset.GetMainAsset (), 0);
            //}
         }
         
         if (assetArray.length > 0)
         {
            NotifyModifiedForReferers ();
         }
      }
      
//=================================================================================
//   
//=================================================================================

      

//=================================================================================
//   control points
//=================================================================================

      protected var mCurrentShownControlPoints:Array = new Array ();

      // assets == null means hide all control points
      public function SetAssetsShowingControlPoints (inputAssets:Array):void
      {
         /*
         var i:int;
         var count:int;
         var cp:ControlPoint;
         
         // collect current assets with CPs shown 
         
         var currentAssetsWithControlPointsShown:Array = new Array ();
         count = mCurrentShownControlPoints.length;
         for (i = 0; i < count; ++ i)
         {
            cp = mCurrentShownControlPoints [i] as ControlPoint;
            if (currentAssetsWithControlPointsShown.indexOf (cp.GetOwnerAsset ()) < 0)
            {
               currentAssetsWithControlPointsShown.push (cp.GetOwnerAsset ());
            }
         }
         
         // collect assets to show/hide CPs
         
         var assetsToHideControlPoints:Array;
         var assetsToShowControlPoints:Array;
         var asset:Asset;
         
         if (inputAssets == null || inputAssets.length == 0)
         {
            assetsToHideControlPoints = currentAssetsWithControlPointsShown;
            assetsToShowControlPoints = new Array ();
         }
         else
         {
            assetsToHideControlPoints = new Array ();
            assetsToShowControlPoints = new Array ();

            count = currentAssetsWithControlPointsShown.length;
            for (i = 0; i < count; ++ i)
            {
               asset = currentAssetsWithControlPointsShown [i] as Asset;
               if (inputAssets.indexOf (asset) < 0)
               {
                  assetsToHideControlPoints.push (asset);
               }
            }
            
            count = inputAssets.length;
            for (i = 0; i < count; ++ i)
            {
               asset = inputAssets [i] as Asset;
               if (currentAssetsWithControlPointsShown.indexOf (asset) < 0)
               {
                  assetsToShowControlPoints.push (asset);
               }
            }
         }
         
         // hide
         
         count = assetsToHideControlPoints.length;
         for (i = 0; i < count; ++ i)
         {
            (assetsToHideControlPoints [i] as Asset).SetControlPointsVisible (false);
         }
         
         // show
         
         count = assetsToShowControlPoints.length;
         for (i = 0; i < count; ++ i)
         {
            (assetsToShowControlPoints [i] as Asset).SetControlPointsVisible (true);
         }
         */
         
         var numAssets:int = mAssetsSortedByCreationId.length;
         
         for (var i:uint = 0; i < numAssets; ++ i)
         {
            var asset:Asset = GetAssetByCreationId (i);
            
            if (asset != null)
            {
               asset.SetControlPointsVisible (inputAssets != null && inputAssets.indexOf (asset) >= 0);
            }
         }
      }

      // for Assets register selves CPs
      public function RegisterShownControlPoints (controlPoints:Array):void
      {
         if (controlPoints != null)
         {
            for (var i:int = controlPoints.length - 1; i >= 0; -- i)
            {
               mCurrentShownControlPoints.push (controlPoints [i]);
            }
         }
      }
      
      public function UnregisterShownControlPointsOfAsset (asset:Asset):void
      {
         var i:int;
         var cp:ControlPoint;
         
         for (i = mCurrentShownControlPoints.length - 1; i >= 0; -- i)
         {
            cp = mCurrentShownControlPoints [i] as ControlPoint;
            if (cp.GetOwnerAsset () == asset)
            {
               mCurrentShownControlPoints.splice (i, 1);
            }
         }
      }
      
      public function SetSelectedControlPoints (selectedControlPoints:Array):void
      {
         var i:int;
         
         for (i = mCurrentShownControlPoints.length - 1; i >= 0; -- i)
         {
            (mCurrentShownControlPoints [i] as ControlPoint).SetSelectedLevel (ControlPoint.SelectedLevel_None);
         }
         
         if (selectedControlPoints != null)
         {
            if (selectedControlPoints.length == 1)
            {
               var cp:ControlPoint = selectedControlPoints [0] as ControlPoint;
               cp.GetOwnerAsset ().OnSoloControlPointSelected (cp);
            }
            else
            {
               for (i = selectedControlPoints.length - 1; i >= 0; -- i)
               {
                  (selectedControlPoints [i] as ControlPoint).SetSelectedLevel (ControlPoint.SelectedLevel_Primary);
               }
            }
         }
      }
      
      public function DeleteSelectedControlPoints ():Boolean
      {
         for (var i:int = mCurrentShownControlPoints.length - 1; i >= 0; -- i)
         {
            var cp:ControlPoint = mCurrentShownControlPoints [i] as ControlPoint;
            if (cp.GetSelectedLevel () == ControlPoint.SelectedLevel_Primary)
            {
               // todo: currently, onpy support most one control point
               
               if (cp.GetOwnerAsset ().DeleteControlPoint (cp))
                  return true;
            }
         }
         
         return false;
      }
      
      public function InsertControlPoint ():Boolean
      {
         for (var i:int = mCurrentShownControlPoints.length - 1; i >= 0; -- i)
         {
            var cp:ControlPoint = mCurrentShownControlPoints [i] as ControlPoint;
            if (cp.GetSelectedLevel () == ControlPoint.SelectedLevel_Primary)
            {
               // todo: currently, onpy support most one control point
               
               if (cp.GetOwnerAsset ().InsertControlPointBefore (cp))
                  return true;
            }
         }
         
         return false;
      }
      
      public function AlignControlPoints (horizontally:Boolean):Boolean
      {
         var primaryCP:ControlPoint = null;
         var secondaryCP:ControlPoint = null;
         
         for (var i:int = mCurrentShownControlPoints.length - 1; i >= 0; -- i)
         {
            var cp:ControlPoint = mCurrentShownControlPoints [i] as ControlPoint;
            if (cp.GetSelectedLevel () == ControlPoint.SelectedLevel_Primary)
            {
               primaryCP = cp;
            }
            else if (cp.GetSelectedLevel () == ControlPoint.SelectedLevel_Secondary)
            {
               secondaryCP = cp;
            }
         }
         
         if (primaryCP != null && secondaryCP != null)
         {
            if (horizontally)
            {
               if (cp.GetOwnerAsset ().AlignControlPointsHorizontally (primaryCP, secondaryCP))
                  return true;
            }
            else
            {
               if (cp.GetOwnerAsset ().AlignControlPointsVertically (primaryCP, secondaryCP))
                  return true;
            }
         }
         
         return false;
      }
      
      public function AlignControlPointsHorizontally ():Boolean
      {
         return AlignControlPoints (true);
      }
      
      public function AlignControlPointsVertically ():Boolean
      {
         return AlignControlPoints (false);
      }
      
//=================================================================================
// appearance and creation order
//=================================================================================
      
      override public function addChild(child:DisplayObject):DisplayObject
      {
         mNeedToCorrectAssetAppearanceIds = true;
         mNeedToCorrectAssetCreationIds = true;
         
         return super.addChild(child);
      }
      
      override public function addChildAt(child:DisplayObject, index:int):DisplayObject
      {
         mNeedToCorrectAssetAppearanceIds = true;
         mNeedToCorrectAssetCreationIds = true;
         
         return super.addChildAt(child, index);
      }
      
      override public function removeChild(child:DisplayObject):DisplayObject
      {
         mNeedToCorrectAssetAppearanceIds = true;
         mNeedToCorrectAssetCreationIds = true;
         
         var asset:Asset = child as Asset;
         if (asset != null)
         {
            asset.SetAppearanceLayerId (-1);
         }
         
         return super.removeChild(child);
      }
      
      override public function removeChildAt(index:int):DisplayObject
      {
         mNeedToCorrectAssetAppearanceIds = true;
         mNeedToCorrectAssetCreationIds = true;
         
         var child:DisplayObject = super.removeChildAt(index);
         var asset:Asset = child as Asset;
         if (asset != null)
         {
            asset.SetAppearanceLayerId (-1);
         }
         
         return child;
      }
      
      override public function setChildIndex(child:DisplayObject, index:int):void
      {
         mNeedToCorrectAssetAppearanceIds = true;
         
         super.setChildIndex(child, index);
      }
      
      override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
      {
         mNeedToCorrectAssetAppearanceIds = true;
         
         super.swapChildren(child1, child2);
      }
      
      override public function swapChildrenAt(index1:int, index2:int):void
      {
         mNeedToCorrectAssetAppearanceIds = true;
         
         super.swapChildrenAt(index1, index2);
      }
      
      protected var mNeedToCorrectAssetAppearanceIds:Boolean = false;
      
      public function CorrectAssetAppearanceIds ():void
      {
         if ( mNeedToCorrectAssetAppearanceIds)
         {
            mNeedToCorrectAssetAppearanceIds = false;
            
            var asset:Asset;
            var i:int = 0;
            for (i = 0; i < numChildren; ++ i)
            {
               asset = getChildAt (i) as Asset;
               if (asset != null)
                  asset.SetAppearanceLayerId (i);
            }
         }
      }
      
      public function GetAssetByAppearanceId (appearanceId:int):Asset
      {
         CorrectAssetAppearanceIds ();
         
         if (appearanceId < 0 || appearanceId >= numChildren)
            return null;
         
         return getChildAt (appearanceId) as Asset;
      }
      
      private var mNeedToCorrectAssetCreationIds:Boolean = false;
      
      public function CorrectAssetCreationIds ():void
      {
         if (mNeedToCorrectAssetCreationIds)
         {
            mNeedToCorrectAssetCreationIds = false;
            
            var numAssets:int = mAssetsSortedByCreationId.length;
            for (var i:int = 0; i < numAssets; ++ i)
            {
               (mAssetsSortedByCreationId [i] as Asset).SetCreationOrderId (i);
            }
         }
      }
      
      public function GetAssetByCreationId (creationId:int):Asset
      {
         CorrectAssetCreationIds ();
         
         if (creationId < 0 || creationId >= mAssetsSortedByCreationId.length)
            return null;
         
         return mAssetsSortedByCreationId [creationId];
      }
      
      // for loading into editor
      private var mIsCreationArrayOpened:Boolean = true;
      public function SetCreationAssetArrayLocked (locked:Boolean):void
      {
         mIsCreationArrayOpened = ! locked;
      }
      
      public function AddAssetToCreationArray (asset:Asset):void
      {
         mNeedToCorrectAssetCreationIds = true;
         
         if (mIsCreationArrayOpened)
            mAssetsSortedByCreationId.push (asset);
      }
      
//============================================================================
// lookup tables
//============================================================================
      
      private var mLookupTableByKey:Dictionary = new Dictionary ();
      
      public function GetAssetByKey (key:String):Asset
      {
         return mLookupTableByKey [key] as Asset;
      }
      
      // todo: lookup table by name
      
//============================================================================
// utils
//============================================================================
      
      public function GetNumAssets (filterFunc:Function = null):int
      {
         var numAssets:int = mAssetsSortedByCreationId.length;
         if ( filterFunc == null)
            return numAssets;
         
         var count:int = 0;
         var asset:Asset;
         for (var i:int = 0; i < numAssets; ++ i)
         {
            asset = GetAssetByCreationId (i);
            if (filterFunc (asset))
               ++ count;
         }
         
         return count;
      }
      
      public function GetAssetAppearanceId (asset:Asset):int
      {
         if (asset == null)
            return -1;
         
         // for speed, commented off
         //if (asset.GetAssetManager () != this)
         //   return -1;
         
         return asset.GetAppearanceLayerId ();
      }
      
      public function GetAssetCreationId (asset:Asset):int
      {
         if (asset == null)
            return -1;
         
         // for speed, commented off
         //if (asset.GetAssetManager () != this)
         //   return -1;
         
         return asset.GetCreationOrderId ();
      }
      
      public function AssetArray2AssetCreationIdArray (assets:Array):Array
      {
         if (assets == null)
            return null;
         
         var ids:Array = new Array (assets.length);
         for (var i:int = 0; i < assets.length; ++ i)
         {
            ids [i] = GetAssetCreationId (assets [i] as Asset);
         }
         
         return ids;
      }
      
      public function AssetCreationIdArray2AssetArray (ids:Array):Array
      {
         if (ids == null)
            return null;
         
         var assets:Array = new Array (ids.length);
         for (var i:int = 0; i < ids.length; ++ i)
         {
            assets [i] = GetAssetByCreationId (int (ids [i]));
         }
         
         return assets;
      }
        
//=====================================================================
// picking asset status
//=====================================================================
      
      public function NotifyPickingStatusChanged (inPicking:Boolean):void
      {
         // some managers will override this
      }

//=================================================================================
// internal linkables
//=================================================================================

      public function SetAssetsShowingInternalLinkables (inputAssets:Array):void
      {
         var numAssets:int = mAssetsSortedByCreationId.length;
         
         for (var i:uint = 0; i < numAssets; ++ i)
         {
            var asset:Asset = GetAssetByCreationId (i);
            
            if (asset != null)
            {
               asset.SetInternalLinkablesVisible (inputAssets != null && inputAssets.indexOf (asset) >= 0);
            }
         }
      }
      
//====================================================================
//   interfaces between manager and UI
//====================================================================
      
      protected var mAssetLinksChangedCallback:Function = null;
      
      public function SetAssetLinksChangedCallback (assetLinksChangedCallback:Function):void
      {
         mAssetLinksChangedCallback = assetLinksChangedCallback;
      } 
      
      public function GetAssetLinksChangedCallback ():Function
      {
         return mAssetLinksChangedCallback;
      }
      
      public function DrawAssetLinks (canvasSprite:Sprite, forceDraw:Boolean):void
      {
         // to override
      }
      
      public function UpdateAssetIdTexts (canvasSprite:Sprite):void
      {
         var asset:Asset;
         var i:int;
         var numAssets:int = mAssetsSortedByCreationId.length;
         for (i = 0; i < numAssets; ++ i)
         {
            asset = GetAssetByCreationId (i) as Asset;
            if (asset != null)
            {
               asset.UpdateAssetIdText (canvasSprite);
            }
         }
      }
        
//=====================================================================
// context menu
//=====================================================================
      
      // used in panel and assets
      public function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
      } 
      
//====================================================================
//   properties
//====================================================================
      
      public function GetPropertyValue (propertyId:int):Object
      {
         return null;
      }
      
      public function SetPropertyValue (propertyId:int, value:Object):void
      {
      }
   }
}

