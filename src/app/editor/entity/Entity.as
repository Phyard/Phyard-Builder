
package editor.entity {
   
   import flash.display.Sprite;
   
   
   import editor.world.World;
   
   import editor.selection.SelectionProxy;
   
   public class Entity extends Sprite 
   {
      protected var mWorld:World;
      
      protected var mSelectionProxy:SelectionProxy = null;
      
      private var mPosX:Number = 0;
      private var mPosY:Number = 0;
      private var mRotation:Number = 0;
      
      
      public function Entity (world:World)
      {
         mWorld = world;
      }
      
      
      public function Destroy ():void
      {
         if (mSelectionProxy != null)
            mSelectionProxy.Destroy ();
      }
      
      public function Update (escapedTime:Number):void
      {
      }
      
      public function UpdateAppearance ():void
      {
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
      
      public function SetRotation (rot:Number):void
      {
         mRotation = rot;
         
         rotation = mRotation * 180.0 / Math.PI;
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
      
      public function Clone (displayOffsetX:Number, displayOffsetY:Number):Entity
      {
         var entity:Entity = CreateCloneShell ();
         
         SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
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
      
      public function FlipHorizontally (mirrorX:Number):void
      {
         SetPosition (mirrorX + mirrorX - GetPositionX (), GetPositionY ());
         SetRotation (Math.PI + Math.PI - GetRotation () );
         
         UpdateSelectionProxy ();
      }
      
      public function FlipVertically (mirrorY:Number):void
      {
         SetPosition (GetPositionX (), mirrorY + mirrorY - GetPositionY ());
         SetRotation (Math.PI + Math.PI - GetRotation () );
         
         UpdateSelectionProxy ();
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
         mSelected = selected;
         
         if (! mSelected)
         {
            SetVertexControllersVisible (false);
         }
         
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
      
      public function SetVertexControllersVisible (visible:Boolean):void
      {
         mVertexControllersVisible = visible;
      }
      
      public function AreVertexControlPointsVisible ():Boolean
      {
         return mVertexControllersVisible;
      }
      
      public function OnMovingVertexController (vertexController:VertexController, offsetX:Number, offsetY:Number):void
      {
         
      }
      
      public function DestroyVertexController (vertexController:VertexController):void
      {
      // selected
      
      //   mSelectionListManager.RemoveSelectedEntity (entity);
         
      // ...
         
         vertexController.Destroy ();
         
         if ( contains (vertexController) )
            removeChild (vertexController);
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
      
   }
}