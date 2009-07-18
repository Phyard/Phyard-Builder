
package editor.entity {
   
   import flash.display.Sprite;
   
   import editor.world.EntityContainer;
   //import editor.world.World;
   
   import editor.selection.SelectionProxy;
   
   public class Entity extends Sprite 
   {
      protected var mEntityContainer:EntityContainer;
      protected var mEntityIndex:int = -1;
      
      protected var mSelectionProxy:SelectionProxy = null;
      
      private var mPosX:Number = 0;
      private var mPosY:Number = 0;
      private var mRotation:Number = 0;
      
      private var mIsVisible:Boolean = true;
      
      public function Entity (container:EntityContainer)
      {
         mEntityContainer = container;
      }
      
      public function SetEntityIndex (index:int):void
      {
         mEntityIndex = index;
      }
      
      public function GetEntityIndex ():int
      {
         mEntityContainer.CorrectEntityIndices ();
         
         return mEntityIndex;
      }
      
      public function IsUtilityEntity ():Boolean
      {
         return false;
      }
      
//======================================================
// 
//======================================================
      
      public function Destroy ():void
      {
         SetInternalComponentsVisible (false);
         
         if (mSelectionProxy != null)
            mSelectionProxy.Destroy ();
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
      
      public function GetTypeName ():String
      {
         return "Entity";
      }
      
      public function GetInfoText ():String
      {
         return "x: " + mPosX + ", y = " + mPosY + ", angle = " + (mRotation * 180.0 / Math.PI);
      }
      
      public function GetPhysicsShapesCount ():uint
      {
         return 0;
      }
      
//======================================================
// visible
//======================================================
      
      public function SetVisible (visible:Boolean):void
      {
         mIsVisible = visible;
      }
      
      public function IsVisible ():Boolean
      {
         return mIsVisible;
      }
      
//======================================================
// pos, rotition
//======================================================
      
      public function GetPositionX ():Number
      {
         return mPosX;
      }
      
      public function GetPositionY ():Number
      {
         return mPosY;
      }
      
      public function GetRotation ():Number
      {
         return mRotation;
      }
      
      public function SetPosition (posX:Number, posY:Number):void
      {
         mPosX = posX;
         mPosY = posY;
         x = mPosX;
         y = mPosY;
      }
      
      private static const PI2:Number = Math.PI * 2.0;
      
      public function SetRotation (rot:Number):void
      {
         mRotation = rot % PI2;
         if (mRotation < 0)
            mRotation += PI2;
         
         rotation = (mRotation * 180.0 / Math.PI) % 360;
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
//   clone
//====================================================================
      
      public function IsClonedable ():Boolean
      {
         return true;
      }
      
      public function Clone (displayOffsetX:Number, displayOffsetY:Number):Entity
      {
         var entity:Entity = CreateCloneShell ();
         
         if (entity != null)
         {
            SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         }
         
         return entity;
      }
      
      // to override
      protected function CreateCloneShell ():Entity
      {
         return null;
      }
      
      // to override
      public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         entity.SetPosition ( GetPositionX () + displayOffsetX, GetPositionY () + displayOffsetY );
         entity.SetRotation ( GetRotation () );
         entity.SetVisible ( IsVisible () );
      }
      
      
//====================================================================
//   move, rotate, scale, flip
//====================================================================
      
      public function Move (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean = true):void
      {
         SetPosition (GetPositionX () + offsetX, GetPositionY () + offsetY);
         
         if (updateSelectionProxy)
            UpdateSelectionProxy ();
      }
      
      public function Rotate (centerX:Number, centerY:Number, dRadians:Number, updateSelectionProxy:Boolean = true):void
      {
         RotatePositioon (centerX, centerY, dRadians);
         RotateSelf (dRadians);
         
         if (updateSelectionProxy)
            UpdateSelectionProxy ();
      }
      
      public function RotateSelf (dRadians:Number):void
      {
         // rotation = (rotation + dRadians * 180.0 / Math.PI) % 360;// bug
         SetRotation (GetRotation () + dRadians);
      }
      
      public function RotatePositioon (centerX:Number, centerY:Number, dRadians:Number):void
      {
         var dx:Number = GetPositionX () - centerX;
         var dy:Number = GetPositionY () - centerY;
         var distance:Number = Math.sqrt (dx * dx + dy * dy);
         var radians:Number = Math.atan2 (dy, dx);
         radians += dRadians;
         
         SetPosition (centerX + distance * Math.cos (radians), centerY + distance * Math.sin (radians));
      }
      
      public function Scale (centerX:Number, centerY:Number, ratio:Number, updateSelectionProxy:Boolean = true):void
      {
         ScalePosition (centerX, centerY, ratio);
         ScaleSelf (ratio);
         
         UpdateAppearance ();
         
         if (updateSelectionProxy)
            UpdateSelectionProxy ();
      }
      
      public function ScaleSelf (ratio:Number):void
      {
         
      }
      
      public function ScalePosition (centerX:Number, centerY:Number, ratio:Number):void
      {
         var dx:Number = GetPositionX () - centerX;
         var dy:Number = GetPositionY () - centerY;
         
         SetPosition (centerX + dx * ratio, centerY + dy * ratio);
      }
      
      public function FlipHorizontally (mirrorX:Number, updateSelectionProxy:Boolean = true):void
      {
         FlipPositionHorizontally (mirrorX);
         FlipSelfHorizontally ();
         
         if (updateSelectionProxy)
            UpdateSelectionProxy ();
      }
      
      public function FlipSelfHorizontally ():void
      {
         //SetRotation (Math.PI + Math.PI - GetRotation () );
         SetRotation (Math.PI - GetRotation () );
      }
      
      public function FlipPositionHorizontally (mirrorX:Number):void
      {
         SetPosition (mirrorX + mirrorX - GetPositionX (), GetPositionY ());
      }
      
      public function FlipVertically (mirrorY:Number, updateSelectionProxy:Boolean = true):void
      {
         FlipPositionVertically (mirrorY);
         FlipSelfVertically ();
         
         if (updateSelectionProxy)
            UpdateSelectionProxy ();
      }
      
      public function FlipSelfVertically ():void
      {
         SetRotation (Math.PI + Math.PI - GetRotation () );
      }
      
      public function FlipPositionVertically (mirrorY:Number):void
      {
         SetPosition (GetPositionX (), mirrorY + mirrorY - GetPositionY ());
      }
      
//====================================================================
//   when clone and delete, we need the main entity.
//   after cloned, we need select new selectable sub entities
//====================================================================
      
      public function GetMainEntity ():Entity
      {
         return this;
      }
      
      public function GetSubEntities ():Array
      {
         return [this];
      }
      
      public function GetSubIndex ():int
      {
         return 0;
      }
      
//====================================================================
//   when move and clone, we need the glued entity
//====================================================================
      
      public function GetGluedEntity ():Entity
      {
         return null;
      }
      
//====================================================================
//   selected
//====================================================================
      
      private var mSelected:Boolean = false;
      
      public function NotifySelectedChanged (selected:Boolean):void
      {
         var changed:Boolean =  mSelected != selected;
         
         mSelected = selected;
         
         if (! mSelected)
         {
            SetInternalComponentsVisible (false);
         }
         
         if (changed)
            UpdateAppearance ();
      }
      
      public function IsSelected ():Boolean // used internally, for external, use world.IsEntitySelected instead
      {
         return mSelected;
      }
      
//====================================================================
//   vertex control points
//====================================================================
      
      private var mVertexControllersVisible:Boolean = false;
      
      public function GetVertexControllerIndex (vertexController:VertexController):int
      {
         return -1;
      }
      
      public function GetVertexControllerByIndex (index:int):VertexController
      {
         return null;
      }
      
      public function SetInternalComponentsVisible (visible:Boolean):void
      {
         mVertexControllersVisible = visible;
      }
      
      public function AreInternalComponentsVisible ():Boolean
      {
         return mVertexControllersVisible;
      }
      
      public function OnBeginMovingVertexController (movingVertexController:VertexController):void
      {
      }
      
      public function OnMovingVertexController (movingVertexController:VertexController, offsetX:Number, offsetY:Number):void
      {
      }
      
      public function OnEndMovingVertexController (movingVertexController:VertexController):void
      {
      }
      
      public function OnVertexControllerSelectedChanged (movingVertexController:VertexController, selected:Boolean):void
      {
      }
      
      // if the vertext is not deleted, return it, otherwise, return null
      public function RemoveVertexController(vertexController:VertexController):VertexController
      {
         return vertexController;
      }
      
      // the returned VertexController is not the inserted one but the new one for beforeVertexController
      public function InsertVertexController(beforeVertexController:VertexController):VertexController
      {
         return beforeVertexController;
      }
      
//====================================================================
//   selected
//====================================================================
      
      public function OnWorldZoomScaleChanged ():void
      {
         if (IsSelected ())
         {
            if (AreInternalComponentsVisible ())
            {
               SetInternalComponentsVisible (false);
               SetInternalComponentsVisible (true);
            }
         }
      }
      
//====================================================================
//   brothers
//====================================================================
      
      private var mBrothers:Array = null;
      
      public function GetBrothers ():Array // used only by BorthersManager
      {
         return mBrothers;
      }
      
      public function SetBrothers (brothers:Array):void // used only by BorthersManager
      {
         mBrothers = brothers;
      }
      
//====================================================================
//   entity links
//====================================================================
      
      public function DrawEntityLinkLines (canvasSprite:Sprite):void
      {
         
      }
      
   }
}