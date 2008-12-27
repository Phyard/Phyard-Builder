
package editor.entity {
   
   import flash.display.Sprite;
   
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.setting.EditorSetting;
   
   public class VertexController extends Sprite 
   {
      protected var mWorld:World;
      
      protected var mSelectionProxy:SelectionProxy = null;
      
      protected var mOwnerEntity:Entity;
      
      private var mHalfSize:Number = 3.0;
      
      public function VertexController (world:World, ownerEntity:Entity)
      {
         mWorld = world;
         
         mOwnerEntity = ownerEntity;
         
         UpdateAppearance ();
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
            mSelectionProxy.Destroy ();
      }
      
      public function UpdateAppearance ():void
      {
         var borderColor:uint;
         var borderSize :int;
         var filledColor:uint = 0xFFFFFF;
         
         if ( IsSelected () )
         {
            borderColor = 0x008080; // EditorSetting.BorderColorSelectedObject;
            borderSize  = 3;
         }
         else
         {
            borderColor = 0x0;
            borderSize  = 1;
         }
         
         GraphicsUtil.ClearAndDrawRect (this, - mHalfSize, - mHalfSize, mHalfSize + mHalfSize, mHalfSize + mHalfSize, borderColor, borderSize, true, filledColor);
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
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         var worldPos:Point = GetWorldPosition ();
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle ( GetWorldRotation (), worldPos.x, worldPos.y, mHalfSize, mHalfSize );
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
         return World.LocalToLocal (this, mWorld, new Point (0, 0))
      }
      
      public function GetWorldRotation ():Number
      {
         // !!! here this hould be GetOwnerEntity (), temp 
         var point1:Point = World.LocalToLocal (mWorld, this, new Point (0, 0));
         var point2:Point = World.LocalToLocal (mWorld, this, new Point (1, 0));
         
         return Math.atan2 (point2.y - point1.y, point2.x - point1.x);
      }
      
      
//====================================================================
//   move
//====================================================================
      
      public function Move (worldOffsetX:Number, worldOffsetY:Number):void
      {
         var point1:Point = World.LocalToLocal (mWorld, mOwnerEntity, new Point (0, 0));
         var point2:Point = World.LocalToLocal (mWorld, mOwnerEntity, new Point (worldOffsetX, worldOffsetY));
         
         mOwnerEntity.OnMovingVertexController (this, point2.x - point1.x, point2.y - point1.y);
      }
      
//====================================================================
//   selected
//====================================================================
      
      private var mSelected:Boolean = false;
      
      public function NotifySelectedChanged (selected:Boolean):void
      {
         mSelected = selected;
         
         UpdateAppearance ();
      }
      
      protected function IsSelected ():Boolean
      {
         return mSelected;
      }
      
   }
}
