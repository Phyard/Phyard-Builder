
package editor.trigger.entity {
   
   import flash.display.Sprite;
   
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import editor.world.EntityContainer;
   import editor.world.World;
   import editor.entity.Entity;
   import editor.entity.WorldEntity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   public class InputEntitySelector extends Sprite implements Linkable
   {
      public static var kRadius:Number = 5.0;
      
      protected static var sContextMenu:ContextMenu;
      protected static var sContextMenuItem_Clear:ContextMenuItem;
      
      public static var sNotifyEntityLinksModified:Function = null;
      
      public static function NotifyEntityLinksModified ():void
      {
         if (sNotifyEntityLinksModified != null)
            sNotifyEntityLinksModified ();
      }
      
//=================================================================================================
//   
//=================================================================================================
      
    // ...
      
      protected var mWorld:World;
      
      protected var mSelectionProxy:SelectionProxy = null;
      
      protected var mOwnerEntity:Entity;
      
      protected var mParamId:int = 0;
      protected var mSelectorId:int = 0;
      
      protected var mOnSelectEntity:Function = null;
      protected var mOnClearEntities:Function = null;
      
      public function InputEntitySelector (world:World, ownerEntity:Entity, inputId:int = 0, selectorId:int = 0, onSelectEntity:Function = null, onClearEntities:Function = null)
      {
         mWorld = world;
         
         mOwnerEntity = ownerEntity;
         
         mOnSelectEntity = onSelectEntity;
         mOnClearEntities = onClearEntities;
         
         mParamId = inputId;
         mSelectorId = selectorId;
         
         BuildContextMenu ();
         
         contextMenu = sContextMenu;
      }
      
      public function SetSelectable (selectable:Boolean):void
      {
         if (mSelectionProxy != null)
            mSelectionProxy.SetSelectable (selectable);
      }
      
      public function GetOwnerEntity ():Entity
      {
         return mOwnerEntity;
      }
      
      public function Destroy ():void
      {
         if (mSelectionProxy != null)
         {
            mSelectionProxy.Destroy ();
         }
         
         contextMenu = null;
      }
      
      public function UpdateAppearance ():void
      {
         var borderColor:uint;
         var borderSize :Number;
         var filledColor:uint = 0xFFA000;
         var halfSize:Number = kRadius;
         
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            borderSize  = 3;
         }
         else
         {
            borderColor = 0x0;
            borderSize  = 1;
         }
         
         halfSize /= mWorld.GetZoomScale ();
         borderSize /= mWorld.GetZoomScale ();
         
         GraphicsUtil.ClearAndDrawCircle (this, 0, 0, halfSize, borderColor, borderSize, true, filledColor);
      }
      
//======================================================
// 
//======================================================
      
      public function IsEntitySelectable ():Boolean
      {
         return true;
      }
      
//======================================================
// pos, rotition
//======================================================
      
      public function GetPositionX ():Number
      {
         return x;
      }
      
      public function GetPositionY ():Number
      {
         return y;
      }
      
      public function SetPosition (posX:Number, posY:Number):void
      {
         x = posX;
         y = posY;
      }
      
//====================================================================
//   Selection Proxy
//====================================================================
      
      public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngineForVertexes.CreateProxyCircle ();
            
            mSelectionProxy.SetUserData (this);
         }
         
         var worldPos:Point = GetWorldPosition ();
         var halfSize:Number = kRadius;
         halfSize /= mWorld.GetZoomScale ();
         
         (mSelectionProxy as SelectionProxyCircle).RebuildCircle ( GetWorldRotation (), worldPos.x, worldPos.y, kRadius );
      }
      
      public function ContainsPoint (pointX:Number, pointY:Number):Boolean
      {
         if (mSelectionProxy == null)
            return false;
         
         return mSelectionProxy.ContainsPoint (pointX, pointY);
      }
      
      // these function will be moved to EditorObject
      
      
      
      public function GetWorldPosition ():Point
      {
         return DisplayObjectUtil.LocalToLocal (this, mWorld, new Point (0, 0))
      }
      
      public function GetWorldRotation ():Number
      {
         // !!! here this hould be GetOwnerEntity (), temp 
         var point1:Point = DisplayObjectUtil.LocalToLocal (mWorld, this, new Point (0, 0));
         var point2:Point = DisplayObjectUtil.LocalToLocal (mWorld, this, new Point (1, 0));
         
         return Math.atan2 (point2.y - point1.y, point2.x - point1.x);
      }
      
      
//====================================================================
//   selected
//====================================================================
      
      private var mSelected:Boolean = false;
      
      public function NotifySelectedChanged (selected:Boolean):void
      {
         mSelected = selected;
         
         //mOwnerEntity.OnVertexControllerSelectedChanged (this, mSelected);
         
         UpdateAppearance ();
      }
      
      public function IsSelected ():Boolean
      {
         return mSelected;
      }
      
//====================================================================
//   context menu
//====================================================================
      
      private static function BuildContextMenu ():void
      {
         if (sContextMenu != null)
            return;
         
         sContextMenu = new ContextMenu ();
         sContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = sContextMenu.builtInItems;
         defaultItems.print = false;
         
         sContextMenuItem_Clear = new ContextMenuItem ("Clear", false),
         
         sContextMenu.customItems.push (sContextMenuItem_Clear);
         sContextMenuItem_Clear.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
      }
      
      private static function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         var selector:InputEntitySelector = event.mouseTarget as InputEntitySelector;
         if (selector == null)
            return;
         
         if (event.target == sContextMenuItem_Clear)
         {
            selector.ClearEntities ();
         }
      }
      
      public function ClearEntities ():void
      {
         if (mOnClearEntities != null)
         {
            if (mOnClearEntities (mParamId, mSelectorId))
               NotifyEntityLinksModified ();
         }
      }
      
//====================================================================
//   linkable
//====================================================================
      
      public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         return 0;
      }
      
      public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         return true;
      }
      
      public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         if ( (toEntity is WorldEntity) && ! (toEntity is EntityLogic) )
         {
            if (mOnSelectEntity != null)
            {
               return mOnSelectEntity (toEntity, mParamId, mSelectorId);
            }
         }
         
         return false;
      }
   }
}