
package editor.entity {
   
   import flash.display.Sprite;
   
   
   import editor.world.World;
   
   import editor.selection.SelectionProxy;
   
   public class Entity extends Sprite 
   {
      protected var mWorld:World;
      
      protected var mSelectionProxy:SelectionProxy = null;
      
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
         return x;
      }
      
      public function GetPositionY ():Number
      {
         return y;
      }
      
      public function GetRotation ():Number
      {
         return rotation * Math.PI / 180.0;
      }
      
      public function SetPosition (posX:Number, posY:Number):void
      {
         x = posX;
         y = posY;
      }
      
      public function SetRotation (rot:Number):void
      {
         rotation = rot * 180.0 / Math.PI;
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
         return null;
      }
      
      
//====================================================================
//   move, rotate, scale
//====================================================================
      
      public function Move (offsetX:Number, offsetY:Number):void
      {
         SetPosition (GetPositionX () + offsetX, GetPositionY () + offsetY);
         
         UpdateSelectionProxy ();
      }
      
      public function Rotate (centerX:Number, centerY:Number, dRadians:Number):void
      {
         RotatePositioon (centerX, centerY, dRadians);
         RotateSelf (dRadians);
         
         UpdateSelectionProxy ();
      }
      
      public function RotateSelf (dRadians:Number):void
      {
         rotation = (rotation + dRadians * 180.0 / Math.PI) % 360;
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
      
      public function Scale (centerX:Number, centerY:Number, ratio:Number):void
      {
         ScalePosition (centerX, centerY, ratio);
         ScaleSelf (ratio);
         
         UpdateAppearance ();
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
      
      
//====================================================================
//   when clone and delete, we need the main entity
//====================================================================
      
      public function GetMainEntity ():Entity
      {
         return this;
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
      
      protected function IsSelected ():Boolean
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

      
   }
}