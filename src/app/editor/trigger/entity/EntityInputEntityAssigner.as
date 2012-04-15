
package editor.trigger.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.asset.Asset;
   
   import editor.entity.Scene;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   
   
   import common.Define;
   
   public class EntityInputEntityAssigner extends EntityLogic implements IEntityLimiter 
   {
      public static const kRadius:Number = 6;
      public static const kRadius2:Number = 12;
      public static const kOffsetY:Number = 26;
      
      public var mBorderThickness:Number = 1;
      
      protected var mSelectorLayer:Sprite;
      protected var mInputEntitySelector:InputEntitySelector;
      
      // ...
      protected var mEntityAssignerType:int = Define.EntityAssignerType_Many;
      protected var mInputEntities:Array;
      
      public function EntityInputEntityAssigner (container:Scene)
      {
         super (container);
         
         mSelectorLayer = new Sprite ();
         mSelectorLayer.x = 0;
         mSelectorLayer.y = - kOffsetY;
         
         addChild (mSelectorLayer);
         
         RebuildEntityArray ();
         
         BuildContextMenu ();
      }
      
      override public function GetTypeName ():String
      {
         return "Entity Assigner";
      }
      
      override public function GetInfoText ():String
      {
         return mEntityContainer.AssetArray2AssetCreationIdArray (mInputEntities).toString ();
      }
      
      public function GetSelectorType ():int
      {
         return mEntityAssignerType;
      }
      
      public function GetInputEntities ():Array
      {
         //var entities:Array = new Array ();
         //var main_entity:Entity;
         //for (var i:int = 0; i < mInputEntities.length; ++ i)
         //{
         //   main_entity = (mInputEntities [i] as Entity).GetMainAsset ();
         //   if (main_entity != null && entities.indexOf (main_entity) < 0)
         //   {
         //      entities.push (main_entity);
         //   }
         //}
         //
         //return entities;
         
         ValidateEntityLinks ();
         
         return mInputEntities;
      }
      
      public function SetInputEntities (inputEntities:Array):void
      {
         if (mInputEntities.length > 0)
            mInputEntities.splice (0, mInputEntities.length);
         
         if (inputEntities != null && inputEntities.length > 0)
         {
            var num:int = inputEntities.length;
            for (var i:int = 0; i < num; ++ i)
            {
               mInputEntities.push (inputEntities [i]);
            }
         }
      }
      
      public function SetInputEntitiesByCreationIds (entityCreationIds:Array):void
      {
         if (mInputEntities.length > 0)
            mInputEntities.splice (0, mInputEntities.length);
         
         if (entityCreationIds != null && entityCreationIds.length > 0)
         {
            var num:int = entityCreationIds.length;
            for (var i:int = 0; i < num; ++ i)
            {
               mInputEntities.push (mEntityContainer.GetAssetByCreationId (entityCreationIds [i]));
            }
         }
      }
      
      private function RebuildEntityArray ():void
      {
         mInputEntities = new Array ();
      }
      
      public function ValidateEntityLinks ():void
      {
         if (mEntityAssignerType == Define.EntityAssignerType_Single)
         {
            InputEntitySelector_Single.ValidateSingleEntity (mInputEntities);
         }
         else if (mEntityAssignerType == Define.EntityAssignerType_Any)
         {
            mInputEntities.length = 0;
         }
         else
         {
            InputEntitySelector_Many.ValidateLinkedEntities (mInputEntities);
         }
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var borderColor:int = 0x0;
         mBorderThickness = 1;
         if ( IsSelected () )
         {
            borderColor = Define.BorderColorSelectedObject;
            if (mBorderThickness * mEntityContainer.GetZoomScale () < 3)
               mBorderThickness  = 3.0 / mEntityContainer.GetZoomScale ();
         }
         
         var background:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawCircle (background, 0, 0, kRadius2, borderColor, mBorderThickness, true, 0xFFC000);
         GraphicsUtil.DrawCircle (background, 0, 0, kRadius, 0x0, 1, true, 0xFFFF00);
         
         addChild (background);
         
         var text_field:Bitmap;
         text_field = DisplayObjectUtil.CreateCacheDisplayObject (TextFieldEx.CreateTextField ("<font face='Verdana' size='9'>1</font>", false, 0xFFFFFF, 0x0));
         
         addChild (text_field);
         
         text_field.x = - 0.5 * text_field.width;
         text_field.y = - 0.5 * text_field.height;
         
         addChild (mSelectorLayer);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mEntityContainer.mSelectionEngine.CreateProxyCircle ();
            mSelectionProxy.SetUserData (this);
            
            //SetInternalComponentsVisible (AreInternalComponentsVisible ());
         }
         
         var borderThickness:Number = mBorderThickness;
         
         (mSelectionProxy as SelectionProxyCircle).RebuildCircle(GetPositionX (), GetPositionY (), kRadius2, GetRotation ());
         
         UpdateInternalComponents ();
      }
      
      
//==============================================================================================================
//
//==============================================================================================================
      
      protected /*static*/ var sContextMenu:ContextMenu = null;
      protected /*static*/ var sContextMenuItems:Array = [
               new ContextMenuItem ("One", false),
               new ContextMenuItem ("Many", false),
               new ContextMenuItem ("Any", false),
            ];
      protected static var sContextMenuItemValues:Array = [
               Define.EntityAssignerType_Single,
               Define.EntityAssignerType_Many,
               Define.EntityAssignerType_Any,
            ];
      
      private /*static*/ function BuildContextMenu ():void
      {
         if (sContextMenu != null)
            return;
         
         sContextMenu = new ContextMenu ();
         sContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = sContextMenu.builtInItems;
         defaultItems.print = false;
         
         for (var i:int = 0; i < sContextMenuItems.length; ++ i)
         {
            sContextMenu.customItems.push (sContextMenuItems [i] as ContextMenuItem);
            (sContextMenuItems [i] as ContextMenuItem).addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         }
      }
      
      private /*static*/ function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         var assigner:EntityInputEntityAssigner = event.mouseTarget as EntityInputEntityAssigner;
         if (assigner == null)
            return;
         
         var index:int = sContextMenuItems.indexOf (event.target);
         
         if (index >= 0)
            assigner.SetSelectorType (sContextMenuItemValues[index]);
      }
      
//==============================================================================================================
//
//==============================================================================================================
      
      override public function SetInternalLinkablesVisible (visible:Boolean):void
      {
         if (mSelectionProxy == null)
            return; // this happens when creating this entity
         
         mouseChildren = true;
         
         super.SetInternalLinkablesVisible (visible);
         
         if (AreInternalLinkablesVisible ())
         {
            mSelectorLayer.visible = true;
            
            contextMenu = sContextMenu;
            
            for (var i:int = 0; i < sContextMenuItems.length; ++ i)
               (sContextMenuItems [i] as ContextMenuItem).enabled = (sContextMenuItemValues[i] != mEntityAssignerType);
         }
         else
         {
            mSelectorLayer.visible = false;
            
            contextMenu = null;
         }
         
         if (! visible && mInputEntitySelector != null)
         {
            DestroyInternalComponents ();
         }
         
         if (visible && mInputEntitySelector == null)
         {
            CreateInternalComponents ();
         }
      }
      
      public function SetSelectorType (newType:int):void
      {
         var oldType:int = mEntityAssignerType;
         mEntityAssignerType = newType;
         
         for (var i:int = 0; i < sContextMenuItems.length; ++ i)
            (sContextMenuItems [i] as ContextMenuItem).enabled = (sContextMenuItemValues [i] != mEntityAssignerType);
         
         if (AreInternalLinkablesVisible () && oldType != newType)
         {
            DestroyInternalComponents ();
            RebuildEntityArray ();
            CreateInternalComponents ();
            mEntityContainer.NotifyEntityLinksModified ();
         }
      }
      
      protected function CreateInternalComponents ():void
      {
         DestroyInternalComponents ();
         
         if (mEntityAssignerType == Define.EntityAssignerType_Single)
            mInputEntitySelector = new InputEntitySelector_Single (mEntityContainer, this, 0, 0, OnSelectEntity, OnClearEntities);
         else if (mEntityAssignerType == Define.EntityAssignerType_Any)
            mInputEntitySelector = new InputEntitySelector_Any (mEntityContainer, this);
         else
            mInputEntitySelector = new InputEntitySelector_Many (mEntityContainer, this, 0, 0, OnSelectEntity, OnClearEntities);
            
         mInputEntitySelector.UpdateAppearance ();
         mSelectorLayer.addChild (mInputEntitySelector);
         mInputEntitySelector.UpdateSelectionProxy ();
         
         // ...
         GraphicsUtil.DrawLine (mSelectorLayer, 0, (kOffsetY - kRadius2), 0, 0, 0x0, 0);
      }
      
      protected function DestroyInternalComponents ():void
      {
         if (mInputEntitySelector != null)
         {
            mInputEntitySelector.Destroy ();
            mInputEntitySelector = null;
         }
         
         GraphicsUtil.Clear (mSelectorLayer);
         while (mSelectorLayer.numChildren > 0)
            mSelectorLayer.removeChildAt (0);
      }
      
      protected function UpdateInternalComponents ():void
      {
         if (mInputEntitySelector != null)
         {
            mInputEntitySelector.UpdateSelectionProxy ();
         }
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityInputEntityAssigner (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var assigner:EntityInputEntityAssigner = entity as EntityInputEntityAssigner;
         
         assigner.SetSelectorType (GetSelectorType ());
         assigner.SetInputEntities (GetInputEntities ());
      }
      
//====================================================================
//   entity links
//====================================================================
      
      private function OnSelectEntity (entity:Entity, inputId:int, selectorId:int):Boolean
      {
         ValidateEntityLinks ();
         
         var index:int = mInputEntities.indexOf (entity);
         
         if (index >= 0)
         {
            mInputEntities.splice (index, 1);
            
            return true;
         }
         else
         {
            if (mEntityAssignerType == Define.EntityAssignerType_Single)
            {
               mInputEntities [0] = entity;
               mInputEntities.length = 1;
               
               return true;
            }
            else if (mEntityAssignerType == Define.EntityAssignerType_Any)
            {
               mInputEntities.length = 0;
            }
            else
            {
               if (mInputEntities.length < Define.MaxEntitiesCountEachAssigner)
               {
                  mInputEntities.push (entity);
                  
                  return true;
               }
            }
         }
         
         return false;
      }
      
      private function OnClearEntities (inputId:int, selectorId:int):Boolean
      {
         if (mInputEntities.length > 0)
         {
            mInputEntities.splice (0, mInputEntities.length);
            
            return true;
         }
         
         return false;
      }
      
      override public function DrawEntityLinks (canvasSprite:Sprite, forceDraw:Boolean, isExpanding:Boolean = false):void
      {
         if (forceDraw || isExpanding)
         {
            if (! AreInternalLinkablesVisible ())
            {
               SetInternalLinkablesVisible (true);
            }
         }
         else if (! IsSelected ())
         {
            if (AreInternalLinkablesVisible ())
            {
               SetInternalLinkablesVisible (false);
            }
         }
         
         if (! AreInternalLinkablesVisible ())
            return;
         
         ValidateEntityLinks ();
         
         if (mInputEntities.length > 0)
         {
            if (mInputEntitySelector is InputEntitySelector_Many)
            {
               (mInputEntitySelector as InputEntitySelector_Many).DrawEntityLinks (canvasSprite, mInputEntities);
            }
            else if (mInputEntitySelector is InputEntitySelector_Single)
            {
               (mInputEntitySelector as InputEntitySelector_Single).DrawEntityLinkLine (canvasSprite, mInputEntities [0]);
            }
         }
      }
      
//====================================================================
//   as IEntityLimiter
//====================================================================
      
      public function IsPairLimiter ():Boolean
      {
         return false;
      }
      
//====================================================================
//   linkable
//====================================================================
      
      override public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         if (localX * localX + localY * localY > kRadius * kRadius)
            return 0;
         
         return -1;
      }
      
      override public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mEntityContainer, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      override public function TryToCreateLink (fromManagerDisplayX:Number, fromManagerDisplayY:Number, toAsset:Asset, toManagerDisplayX:Number, toManagerDisplayY:Number):Boolean
      {
         return false;
      }
      
   }
}
