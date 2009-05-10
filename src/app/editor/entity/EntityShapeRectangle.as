
package editor.entity {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.world.EntityContainer;
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityShapeRectangle extends EntityShape 
   {
   // geom
      
      public var mHalfWidth:Number;
      public var mHalfHeight:Number;
      
      protected var mEnableVertexControllers:Boolean = true;
      
      public function EntityShapeRectangle (world:World)
      {
         super (world);
         
         SetHalfWidth (0);
         SetHalfHeight (0);
      }
      
      override public function GetTypeName ():String
      {
         return "Rectangle";
      }
      
      override public function GetPhysicsShapesCount ():uint
      {
         return IsPhysicsEnabled () ? 1 : 0;
      }
      
      override public function UpdateAppearance ():void
      {
         var filledColor:uint = GetFilledColor ();
         var borderColor:uint = GetBorderColor ();
         var drawBg:Boolean = IsDrawBackground ();
         var drawBorder:Boolean = IsDrawBorder ();
         var borderThickness:Number = GetBorderThickness ();
         
         if (mAiType >= 0)
         {
            filledColor =  Define.GetShapeFilledColor (mAiType);
            borderColor = Define.ColorObjectBorder;
            drawBg = true;
         }
         
         if ( ! drawBorder)
         {
            drawBg = true;
            borderThickness = -1;
         }
         
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            if (borderThickness * mWorld.GetZoomScale () < 3)
               borderThickness  = 3.0 / mWorld.GetZoomScale ();
         }
         
         alpha = 0.30 + GetTransparency () * 0.01 * 0.40;
         
         GraphicsUtil.ClearAndDrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderThickness, drawBg, filledColor);
         
         if (GetFilledColor () == Define.ColorBombObject)
            GraphicsUtil.DrawRect (this, - mHalfWidth * 0.5, - mHalfHeight * 0.5, mHalfWidth, mHalfHeight, 0x808080, 0, true, 0x808080);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
            
            SetVertexControllersVisible (AreVertexControlPointsVisible ());
         }
         
         var borderThickness:Number = GetBorderThickness ();
         if ( ! IsDrawBorder () )
            borderThickness = 0;
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle ( GetRotation (), GetPositionX (), GetPositionY (), GetHalfWidth () + borderThickness * 0.5 , GetHalfHeight () + borderThickness * 0.5 );
      }
      
      
      public function SetHalfWidth (halfWidth:Number, validate:Boolean = true):void
      {
         if (validate)
         {
            var minHalfWidth:Number = GetFilledColor () == Define.ColorBombObject ? EditorSetting.MinBombSquareSideLength * 0.5 : EditorSetting.MinRectSideLength * 0.5;
            var maxHalfWidth:Number = GetFilledColor () == Define.ColorBombObject ? EditorSetting.MaxBombSquareSideLength * 0.5 : EditorSetting.MaxRectSideLength * 0.5;
            
            if (halfWidth * mHalfHeight * 4 > EditorSetting.MaxRectArea)
               halfWidth = EditorSetting.MaxRectArea / (mHalfHeight * 4);
            
            if (halfWidth > maxHalfWidth)
               halfWidth = maxHalfWidth;
            if (halfWidth < minHalfWidth)
               halfWidth = minHalfWidth;
         }
         
         mHalfWidth = halfWidth;
      }
      
      public function SetHalfHeight (halfHeight:Number, validate:Boolean = true):void
      {
         if (validate)
         {
            var minHalfWidth:Number = GetFilledColor () == Define.ColorBombObject ? EditorSetting.MinBombSquareSideLength * 0.5 : EditorSetting.MinRectSideLength * 0.5;
            var maxHalfWidth:Number = GetFilledColor () == Define.ColorBombObject ? EditorSetting.MaxBombSquareSideLength * 0.5 : EditorSetting.MaxRectSideLength * 0.5;
            
            if (halfHeight * mHalfWidth * 4 > EditorSetting.MaxRectArea)
               halfHeight = EditorSetting.MaxRectArea / (mHalfWidth * 4);
            
            if (halfHeight > maxHalfWidth)
               halfHeight = maxHalfWidth;
            if (halfHeight < minHalfWidth)
               halfHeight = minHalfWidth;
         }
         
         mHalfHeight = halfHeight;
      }
      
      public function GetHalfWidth ():Number
      {
         return mHalfWidth;
      }
      
      public function GetHalfHeight ():Number
      {
         return mHalfHeight;
      }
      
      override public function Destroy ():void
      {
         SetVertexControllersVisible (false);
         
         super.Destroy ();
      }
      
      
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityShapeRectangle (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var rect:EntityShapeRectangle = entity as EntityShapeRectangle;
         rect.SetHalfWidth ( GetHalfWidth () );
         rect.SetHalfHeight ( GetHalfHeight () );
         rect.UpdateAppearance ();
         rect.UpdateSelectionProxy ();
      }
      
      
//========================================================================
// vertex controllers
//========================================================================
      
      private var mVertexController0:VertexController = null;
      private var mVertexController1:VertexController = null;
      private var mVertexController2:VertexController = null;
      private var mVertexController3:VertexController = null;
      
      override public function GetVertexControllerIndex (vertexController:VertexController):int
      {
         if (vertexController != null)
         {
            if (vertexController == mVertexController0)
               return 0;
            if (vertexController == mVertexController1)
               return 1;
            if (vertexController == mVertexController2)
               return 2;
            if (vertexController == mVertexController3)
               return 3;
         }
         
         return -1;
      }
      
      override public function GetVertexControllerByIndex (index:int):VertexController
      {
         if (index == 0)
            return mVertexController0;
         if (index == 1)
            return mVertexController1;
         if (index == 2)
            return mVertexController2;
         if (index == 3)
            return mVertexController3;
         
         return null;
      }
      
      override public function SetVertexControllersVisible (visible:Boolean):void
      {
         if (! mEnableVertexControllers)
            return;
         
         // mVertexControlPointsVisible = visible;
         super.SetVertexControllersVisible (visible);
         
         if (mSelectionProxy == null)
            return;
         
      // create / destroy controllers
         
         if ( AreVertexControlPointsVisible () )
         {
            SetVertexControllersVisible (false);
            super.SetVertexControllersVisible (true);
            
            if (mVertexController0 == null)
            {
               mVertexController0 = new VertexController (mWorld, this);
               addChild (mVertexController0);
            }
            
            if (mVertexController1 == null)
            {
               mVertexController1 = new VertexController (mWorld, this);
               addChild (mVertexController1);
            }
            
            if (mVertexController2 == null)
            {
               mVertexController2 = new VertexController (mWorld, this);
               addChild (mVertexController2);
            }
            
            if (mVertexController3 == null)
            {
               mVertexController3 = new VertexController (mWorld, this);
               addChild (mVertexController3);
            }
            
            UpdateVertexControllers (true);
         }
         else
         {
            if (mVertexController0 != null)
            {
               mVertexController0.Destroy ();
               if (contains (mVertexController0))
                  removeChild (mVertexController0);
               
               mVertexController0 = null;
            }
            
            if (mVertexController1 != null)
            {
               mVertexController1.Destroy ();
               if (contains (mVertexController1))
                  removeChild (mVertexController1);
               
               mVertexController1 = null;
            }
            
            if (mVertexController2 != null)
            {
               mVertexController2.Destroy ();
               if (contains (mVertexController2))
                  removeChild (mVertexController2);
               
               mVertexController2 = null;
            }
            
            if (mVertexController3 != null)
            {
               mVertexController3.Destroy ();
               if (contains (mVertexController3))
                  removeChild (mVertexController3);
               
               mVertexController3 = null;
            }
         }
      }
      
      public function UpdateVertexControllers (updateSelectionProxy:Boolean):void
      {
         if (mVertexController0 != null)
         {
            mVertexController0.SetPosition (- GetHalfWidth (), - GetHalfHeight ());
            
            if (updateSelectionProxy)
               mVertexController0.UpdateSelectionProxy ();
         }
         
         if (mVertexController1 != null)
         {
            mVertexController1.SetPosition ( GetHalfWidth (), - GetHalfHeight ());
            
            if (updateSelectionProxy)
               mVertexController1.UpdateSelectionProxy ();
         }
         
         if (mVertexController2 != null)
         {
            mVertexController2.SetPosition ( GetHalfWidth (), GetHalfHeight ());
            
            if (updateSelectionProxy)
               mVertexController2.UpdateSelectionProxy ();
         }
         
         if (mVertexController3 != null)
         {
            mVertexController3.SetPosition (- GetHalfWidth (), GetHalfHeight ());
            
            if (updateSelectionProxy)
               mVertexController3.UpdateSelectionProxy ();
         }
      }
      
      public function GetDigonalVertexController (vertexController:VertexController):VertexController
      {
         if (vertexController == mVertexController0)
            return mVertexController2;
         if (vertexController == mVertexController1)
            return mVertexController3;
         if (vertexController == mVertexController2)
            return mVertexController0;
         if (vertexController == mVertexController3)
            return mVertexController1;
         
         return null;
      }
      
      private var _DigonalVertexControllerX:Number = 0;
      private var _DigonalVertexControllerY:Number = 0;
      override public function OnBeginMovingVertexController (vertexController:VertexController):void
      {
         var vertexController2:VertexController = GetDigonalVertexController (vertexController);
         
         if (vertexController2 == null)
            return;
         
         var worldVertex2Pos:Point = DisplayObjectUtil.LocalToLocal (this, mWorld, new Point ( vertexController2.GetPositionX (), vertexController2.GetPositionY () ) );
         
         _DigonalVertexControllerX = worldVertex2Pos.x;
         _DigonalVertexControllerY = worldVertex2Pos.y;
      }
      
      override public function OnMovingVertexController (vertexController:VertexController, localOffsetX:Number, localOffsetY:Number):void
      {
      // ...
         var vertexController2:VertexController = GetDigonalVertexController (vertexController);
         
         if (vertexController2 == null)
            return;
      
         var x1:Number;
         var y1:Number;
         var x2:Number;
         var y2:Number;
         
         if (vertexController.GetPositionX () < vertexController2.GetPositionX ())
         {
            x1 = vertexController.GetPositionX () + localOffsetX;
            x2 = vertexController2.GetPositionX ();
         }
         else
         {
            x1 = vertexController2.GetPositionX ();
            x2 = vertexController.GetPositionX () + localOffsetX;
         }
         if (vertexController.GetPositionY () < vertexController2.GetPositionY ())
         {
            y1 = vertexController.GetPositionY () + localOffsetY;
            y2 = vertexController2.GetPositionY ();
         }
         else
         {
            y1 = vertexController2.GetPositionY ();
            y2 = vertexController.GetPositionY () + localOffsetY;
         }
         
         var halfWidth:Number  = (x2 - x1);// * 0.5;
         var halfHeight:Number = (y2 - y1);// * 0.5;
      
         if (halfWidth < EditorSetting.MinRectSideLength)
            return;
         if (halfWidth > EditorSetting.MaxRectSideLength)
            return;
         
         if (halfHeight < EditorSetting.MinRectSideLength)
            return;
         if (halfHeight > EditorSetting.MaxRectSideLength)
            return;
         
         if (halfWidth * halfHeight > EditorSetting.MaxRectArea)
            return;
         
         if (GetFilledColor () == Define.ColorBombObject)
         {
            if (halfHeight > halfWidth)
               halfWidth = halfHeight;
            else
               halfHeight = halfWidth;
            
            if (halfHeight < EditorSetting.MinBombSquareSideLength)
               return;
            if (halfHeight > EditorSetting.MaxBombSquareSideLength)
               return;
         }
         
         halfWidth  *= 0.5;
         halfHeight *= 0.5;
         
         var worldCenterPos:Point = DisplayObjectUtil.LocalToLocal (this, mWorld, new Point ( (x2 + x1) * 0.5, (y2 + y1) * 0.5 ) );
         
         SetPosition (worldCenterPos.x, worldCenterPos.y);
         
         // seems, in SetPosition, flash will slightly adjust the values provided.
         // to make the postion of vertex controller2 uncahnged ...
         
         var localVertex2Pos:Point = DisplayObjectUtil.LocalToLocal (mWorld, this, new Point (_DigonalVertexControllerX, _DigonalVertexControllerY) );
         
         halfWidth  = localVertex2Pos.x;
         halfHeight = localVertex2Pos.y;
         if (halfWidth  < 0) halfWidth  = - halfWidth;
         if (halfHeight < 0) halfHeight = - halfHeight;
         
         SetHalfWidth  (halfWidth);
         SetHalfHeight (halfHeight);
         
         
         
         
         
      // ...
         
         UpdateAppearance ();
         UpdateSelectionProxy ();
         UpdateVertexControllers (true);
      }
      
//====================================================================
//   move, rotate, scale
//====================================================================
      
      override public function Move (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Move (offsetX, offsetY, updateSelectionProxy);
         
         UpdateVertexControllers (updateSelectionProxy);
      }
      
      override public function Rotate (centerX:Number, centerY:Number, dRadians:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Rotate (centerX, centerY, dRadians, updateSelectionProxy);
         
         UpdateVertexControllers (updateSelectionProxy);
      }
      
      override public function Scale (centerX:Number, centerY:Number, ratio:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Scale (centerX, centerY, ratio, updateSelectionProxy);
         
         UpdateVertexControllers (updateSelectionProxy);
      }
      
      override public function ScaleSelf (ratio:Number):void
      {
         var halfWidth:Number  = mHalfWidth * ratio;
         var halfHeight:Number = mHalfHeight * ratio;
         
         //if (halfWidth < EditorSetting.MinRectSideLength)
         //   halfWidth =  EditorSetting.MinRectSideLength;
         //if (halfWidth > EditorSetting.MaxRectSideLength)
         //   halfWidth =  EditorSetting.MaxRectSideLength;
         
         //if (halfHeight < EditorSetting.MinRectSideLength)
         //   halfHeight =  EditorSetting.MinRectSideLength;
         //if (halfHeight > EditorSetting.MaxRectSideLength)
         //   halfHeight =  EditorSetting.MaxRectSideLength;
         
         SetHalfWidth (halfWidth);
         SetHalfHeight (halfHeight);
      }
      
      override public function FlipSelfHorizontally ():void
      {
         super.FlipSelfHorizontally ();
         
         UpdateVertexControllers (true);
      }
      
      override public function FlipSelfVertically ():void
      {
         super.FlipSelfVertically ();
         
         UpdateVertexControllers (true);
      }
      

   }
}
