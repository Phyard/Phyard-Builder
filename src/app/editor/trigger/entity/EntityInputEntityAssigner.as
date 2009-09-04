
package editor.trigger.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.world.World;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityInputEntityAssigner extends EntityLogic 
   {
      public static var kRadius:Number = 6;
      public static var kRadius2:Number = 12;
      public static var kOffsetY:Number = 26;
      
      public var mBorderThickness:Number = 1;
      
      protected var mSelectorLayer:Sprite;
      protected var mInputEntitySelector:InputEntitySelector;
      
      // ...
      protected var mEntityAssignerType:int = Define.EntityAssignerType_Many;
      protected var mInputEntities:Array = new Array ();
      
      public function EntityInputEntityAssigner (world:World)
      {
         super (world);
         
         mSelectorLayer = new Sprite ();
         mSelectorLayer.x = 0;
         mSelectorLayer.y = - kOffsetY;
      }
      
      override public function GetTypeName ():String
      {
         return "Entity Assigner";
      }
      
      public function GetSelectorType ():int
      {
         return mEntityAssignerType;
      }
      
      public function GetInputEntities ():Array
      {
         return mInputEntities;
      }
      
      public function ValidateEntityLinks ():void
      {
         InputEntitySelector_Many.ValidateLinkedEntities (mInputEntities);
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var borderColor:int = 0x0;
         mBorderThickness = 1;
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            if (mBorderThickness * mWorld.GetZoomScale () < 3)
               mBorderThickness  = 3.0 / mWorld.GetZoomScale ();
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
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyCircle ();
            mSelectionProxy.SetUserData (this);
            
            SetInternalComponentsVisible (AreInternalComponentsVisible ());
         }
         
         var borderThickness:Number = mBorderThickness;
         
         (mSelectionProxy as SelectionProxyCircle).RebuildCircle( GetRotation (), GetPositionX (), GetPositionY (), kRadius2 );
      }
      
//==============================================================================================================
//
//==============================================================================================================
      
      override public function SetInternalComponentsVisible (visible:Boolean):void
      {
         if (mSelectionProxy == null)
            return; // this happens when creating this entity
         
         super.SetInternalComponentsVisible (visible);
         
         mSelectorLayer.visible = AreInternalComponentsVisible ();
         
         GraphicsUtil.Clear (mSelectorLayer);
         while (mSelectorLayer.numChildren > 0)
            mSelectorLayer.removeChildAt (0);
         
         if (! visible && mInputEntitySelector != null)
         {
            mInputEntitySelector.Destroy ();
            mInputEntitySelector = null;
         }
         
         if (visible && mInputEntitySelector == null)
         {
            mInputEntitySelector = new InputEntitySelector_Many (mWorld, this, 0, 0, OnSelectEntity, OnClearEntities);
            mInputEntitySelector.UpdateAppearance ();
            mSelectorLayer.addChild (mInputEntitySelector);
            mInputEntitySelector.UpdateSelectionProxy ();
            
         // ...
            GraphicsUtil.DrawLine (mSelectorLayer, 0, (kOffsetY - kRadius2), 0, 0, 0x0, 0);
         }
         
         if (mInputEntities.length > 0)
            InputEntitySelector.NotifyEntityLinksModified ();
      }
      
      protected function UpdateInternalComponents (updateSelectionProxy:Boolean = true):void
      {
         if (mInputEntitySelector != null)
         {
            if (updateSelectionProxy)
               mInputEntitySelector.UpdateSelectionProxy ();
         }
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
         else if (mInputEntities.length < Define.MaxEntitiesCountEachAssigner)
         {
            mInputEntities.push (entity);
            
            return true;
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
      
      override public function DrawEntityLinkLines (canvasSprite:Sprite):void
      {
         if (! AreInternalComponentsVisible ())
            return;
         
         ValidateEntityLinks ();
         
         if (mInputEntities.length > 0)
         {
            if (mInputEntitySelector is InputEntitySelector_Many)
            {
               (mInputEntitySelector as InputEntitySelector_Many).DrawEntityLinkLines (canvasSprite, mInputEntities);
            }
         }
      }
      
//====================================================================
//   move, rotate, scale
//====================================================================
      
      override public function Move (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Move (offsetX, offsetY, updateSelectionProxy);
         
         UpdateInternalComponents (updateSelectionProxy);
      }
      
      override public function Rotate (centerX:Number, centerY:Number, dRadians:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Rotate (centerX, centerY, dRadians, updateSelectionProxy);
         
         UpdateInternalComponents (updateSelectionProxy);
      }
      
      override public function Scale (centerX:Number, centerY:Number, ratio:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Scale (centerX, centerY, ratio, updateSelectionProxy);
         
         UpdateInternalComponents (updateSelectionProxy);
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
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mWorld, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      override public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         return false;
      }
      
   }
}
