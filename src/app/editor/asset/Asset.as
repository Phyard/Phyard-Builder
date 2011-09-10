
package editor.asset {
   
   import flash.display.Sprite;
   
   import editor.core.EditorObject;
   
   import editor.selection.SelectionProxy;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class Asset extends EditorObject
   {
      protected var mAssetManager:AssetManager;
      protected var mAppearanceLayerId:int = -1;
      protected var mCreationOrderId:int = -1; // to reduce random factors
      
      protected var mSelectionProxy:SelectionProxy = null;
      
      protected var mName:String = "";
      
      private var mPosX:Number = 0;
      private var mPosY:Number = 0;
      
      public function Asset (assetManager:AssetManager)
      {
         mAssetManager = assetManager;
         
         if (mAssetManager != null) // at some special cases, mAssetManager is null
            mAssetManager.OnAssetCreated (this);
         
         //SetName (null);
         
         mouseChildren = false;
      }
      
      public function GetAssetManager ():AssetManager
      {
         return mAssetManager;
      }
      
      public function GetDefaultName ():String
      {
         return GetTypeName ();
      }
      
      public function ToCodeString ():String
      {
         return "Asset#" + mCreationOrderId;
      }
      
      public function GetTypeName ():String
      {
         return "Asset";
      }
      
      public function GetInfoText ():String
      {
         return     "x = " + ValueAdjuster.Number2Precision (mAssetManager.GetCoordinateSystem ().D2P_PositionX (mPosX), 6) 
                + ", y = " + ValueAdjuster.Number2Precision (mAssetManager.GetCoordinateSystem ().D2P_PositionY (mPosY), 6) ;
      }
      
//======================================================
// 
//======================================================
      
      public function SetAppearanceLayerId (index:int):void
      {
         mAppearanceLayerId = index;
      }
      
      public function GetAppearanceLayerId ():int
      {
         mAssetManager.CorrectAssetAppearanceIds ();
         
         return mAppearanceLayerId;
      }
      
      public function SetCreationOrderId (index:int):void
      {
         mCreationOrderId = index;
      }
      
      public function GetCreationOrderId ():int
      {
         mAssetManager.CorrectAssetCreationIds ();
         
         return mCreationOrderId;
      }
      
//======================================================
// 
//======================================================
      
      public function Destroy ():void
      {
         if (mSelectionProxy != null)
            mSelectionProxy.Destroy ();
         
         mAssetManager.OnAssetDestroyed (this);
      }
      
      public function Update (escapedTime:Number):void
      {
      }
      
      public function UpdateAppearance ():void
      {
      }
      
      public function SetSelectable (selectable:Boolean):void
      {
         if (mSelectionProxy != null)
            mSelectionProxy.SetSelectable (selectable);
      }
      
//====================================================================
//   main entity
//====================================================================
      
      public function GetMainAsset ():Asset
      {
         return this;
      }
      
      public function GetSelectableAssets ():Array
      {
         return [this];
      }
      
      public function GetSubAssets ():Array
      {
         return [];
      }
      
      public function GetSubIndex ():int
      {
         return -1;
      }
      
//======================================================
// name, position
//======================================================
      
      public function SetName (name:String):void
      {
         //if (name == null)
         //   name = GetDefaultName ();
         
         mName = name;
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function GetPositionX ():Number
      {
         return mPosX;
      }
      
      public function GetPositionY ():Number
      {
         return mPosY;
      }
      
      public function SetPosition (posX:Number, posY:Number):void
      {
         mPosX = posX;
         mPosY = posY;
         x = mPosX;
         y = mPosY;
      }
      
//======================================================
// 
//======================================================
      
      protected var mVisibleForEditing:Boolean = true;
      
      public function SetVisibleForEditing (visibleForEditing:Boolean):void
      {
         mVisibleForEditing = visibleForEditing;
         
         alpha = mVisibleForEditing ? 1.0 : 0.2;
      }
      
      public function IsVisibleForEditing ():Boolean
      {
         return mVisibleForEditing;
      }
      
//====================================================================
//   Selection Proxy
//====================================================================
      
      public function UpdateSelectionProxy ():void
      {
      }
      
      public function ContainsPoint (pointX:Number, pointY:Number):Boolean
      {
         if (mSelectionProxy == null)
            return false;
         
         return mSelectionProxy.ContainsPoint (pointX, pointY);
      }
      
//====================================================================
//   move
//====================================================================
      
      public function Move (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean = true):void
      {
         SetPosition (GetPositionX () + offsetX, GetPositionY () + offsetY);
         
         if (updateSelectionProxy)
         {
            UpdateSelectionProxy ();
         }
      }
      
      public function MoveTo (targetX:Number, targetY:Number, updateSelectionProxy:Boolean = true):void
      {
         SetPosition (targetX, targetY);
         
         if (updateSelectionProxy)
         {
            UpdateSelectionProxy ();
         }
      }
      
//====================================================================
//   selected
//====================================================================
      
      private var mSelected:Boolean = false;
      
      public function NotifySelectedChanged (selected:Boolean):void
      {
         var changed:Boolean =  mSelected != selected;
         
         mSelected = selected;
         
         if (changed)
         {
            UpdateAppearance ();
         }
      }
      
      public function IsSelected ():Boolean // used internally, for external, use world.IsAssetSelected instead
      {
         return mSelected;
      }

//====================================================================
//   draw entity links
//====================================================================
      
      public static const DrawLinksOrder_Normal:int = 10;
      public static const DrawLinksOrder_Logic:int = 20;
      public static const DrawLinksOrder_Task:int = 30;
      public static const DrawLinksOrder_EventHandler:int = 50;
      
      public function GetDrawLinksOrder ():int
      {
         return DrawLinksOrder_Normal;
      }
      
      public function DrawAssetLinks (canvasSprite:Sprite, forceDraw:Boolean, isExpanding:Boolean = false):void
      {
         // to override
      }
      
      public function GetLinkPointX ():Number
      {
         return mPosX;
      }
      
      public function GetLinkPointY ():Number
      {
         return mPosY;
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