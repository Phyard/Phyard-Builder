
package editor.entity {

   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.system.Capabilities;

   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;

   import editor.world.World;

   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyPolygon;



   import common.Define;

   public class EntityVectorShapePolygon extends EntityVectorShape
   {
   // geom

      public var mVertexPoints:Array = new Array (); // in world coordinate

      public var mLocalPoints:Array = new Array (); // in local coordinate

      private var mIsValid:Boolean = true;
      private var mMinX:Number;
      private var mMaxX:Number;
      private var mMinY:Number;
      private var mMaxY:Number;

      public function EntityVectorShapePolygon (world:World)
      {
         super (world);
      }

      override public function GetTypeName ():String
      {
         return "Polygon";
      }

      override public function GetInfoText ():String
      {
         var vertexController:VertexController = mWorld.GetTheOnlySelectedVertexControllers ();
         if (vertexController == null)
            return super.GetInfoText ();

         var vertexIndex:int = GetVertexControllerIndex (vertexController);

         return super.GetInfoText () + ", vertex#" + vertexIndex + " is selected.";
      }

      override public function GetPhysicsShapesCount ():uint
      {
         if ( ! IsPhysicsEnabled () )
            return 0;

         var count:uint = 0;

         if ( ! IsHollow () && mSelectionProxy != null && mIsValid)
            count += (mSelectionProxy as SelectionProxyPolygon).GetProxyShapesCount ();

         if (GetBorderThickness () > 1)
            count += mLocalPoints.length * 2;

         return count;
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
            borderColor = Define.BorderColorSelectedObject;
            if (borderThickness * mWorld.GetZoomScale () < 3)
               borderThickness  = 3.0 / mWorld.GetZoomScale ();
         }

         SetVisibleInEditor (mVisibleInEditor); //  recal alpha

         if (GetVertexPointsCount () == 1)
         {
            GraphicsUtil.Clear (this);
         }
         else if (GetVertexPointsCount () == 2)
         {
            GraphicsUtil.ClearAndDrawLine (this, mLocalPoints[0].x, mLocalPoints[0].y, mLocalPoints[1].x, mLocalPoints[1].y, borderColor, borderThickness);
         }
         else if (GetVertexPointsCount () > 2)
         {
            GraphicsUtil.ClearAndDrawPolygon (this, mLocalPoints, borderColor, borderThickness, drawBg, filledColor);
            
            //this.graphics.clear ();
            //var bitmapData:flash.display.BitmapData = (mWorld.GetAssetImageManager ().GetAssetByAppearanceId (0) as Object).GetBitmapData ();
            //this.graphics.beginBitmapFill (bitmapData);
            //GraphicsUtil.DrawPolygon (this, mLocalPoints, borderColor, borderThickness, false);
            //this.graphics.endFill ();
         }

         if (!mIsValid)
         {
             GraphicsUtil.DrawRect (this, mMinX, mMinY, mMaxX - mMinX, mMaxY - mMinY, 0xFF8080, IsSelected () ? 3 : 0, false);
         }
      }

      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyPolygon ();
            mSelectionProxy.SetUserData (this);

            SetInternalComponentsVisible (AreInternalComponentsVisible ());
         }

         (mSelectionProxy as SelectionProxyPolygon).RebuildConcavePolygon (GetPositionX (), GetPositionY (), mLocalPoints, GetRotation ());

         if ((mSelectionProxy as SelectionProxyPolygon).GetProxyShapesCount () == 0)
         {
            mIsValid = false;
            (mSelectionProxy as SelectionProxyPolygon).RebuildConvexPolygon (GetPositionX (), GetPositionY (),
                  [new Point (mMinX, mMinY), new Point (mMaxX, mMinY), new Point (mMaxX, mMaxY), new Point (mMinX, mMaxY)], GetRotation ());
         }
         else
         {
            mIsValid = true;
         }

         var borderThickness:Number = GetBorderThickness ();
         var halfThickness:Number = borderThickness * 0.5;

         if (halfThickness > 2)
         {
            if (GetVertexPointsCount () > 0)
               (mSelectionProxy as SelectionProxyPolygon).CreateCircleZone (mLocalPoints [0].x, mLocalPoints [0].y, halfThickness);
            for (var i:int = 1; i < mLocalPoints.length; ++ i)
            {
               (mSelectionProxy as SelectionProxyPolygon).CreateLineSegmentZone (mLocalPoints [i - 1].x, mLocalPoints [i - 1].y, mLocalPoints [i].x, mLocalPoints [i].y, borderThickness);
               (mSelectionProxy as SelectionProxyPolygon).CreateCircleZone (mLocalPoints [i].x, mLocalPoints [i].y, halfThickness);
            }
            if (GetVertexPointsCount () > 2)
               (mSelectionProxy as SelectionProxyPolygon).CreateLineSegmentZone (mLocalPoints [mLocalPoints.length - 1].x, mLocalPoints [mLocalPoints.length - 1].y, mLocalPoints [0].x, mLocalPoints [0].y, borderThickness);
         }

         if (Capabilities.isDebugger)// && false)
         {
            if (mPhysicsShapesLayer == null)
            {
               mPhysicsShapesLayer = new Sprite ();
               addChild (mPhysicsShapesLayer);
            }
            while (mPhysicsShapesLayer.numChildren > 0)
               mPhysicsShapesLayer.removeChildAt (0);

            mSelectionProxy.AddPhysicsShapes (mPhysicsShapesLayer);
         }
      }



//====================================================================
//   vertex
//====================================================================

      public function GetVertexPointsCount ():int
      {
         return mVertexPoints.length;
      }

      public function GetVertexPointAt (index:uint):Point
      {
         if (index >= mVertexPoints.length)
            return null;

         return new Point (mVertexPoints[index].x, mVertexPoints[index].y);
      }

      public function AddVertexPoint (pointX:Number, pointY:Number, synchronize:Boolean = true):void
      {
         AddVertexPointAt (pointX, pointY, mVertexPoints.length, synchronize);
      }

      public function AddVertexPointAt (pointX:Number, pointY:Number, beforeIndex:uint, synchronize:Boolean = true):void
      {
         mVertexPoints.splice (beforeIndex, 0, new Point (pointX, pointY));

         mLocalPoints.push (new Point ());

         if (synchronize)
            SynchronizeWithWorldPoints ();
      }

      public function UpdateVertexPointAt (pointX:Number, pointY:Number, index:uint):void
      {
         if (index >= mVertexPoints.length)
            return;

         mVertexPoints [index].x = pointX;
         mVertexPoints [index].y = pointY;

         SynchronizeWithWorldPoints ();
      }

      public function RemoveVertexPointAt (index:uint):void
      {
         mVertexPoints.splice (index, 1);

         mLocalPoints.pop ();

         SynchronizeWithWorldPoints ();
      }

      public function GetLocalVertexPointAt (index:uint):Point
      {
         if (index >= mLocalPoints.length)
            return null;

         return new Point (mLocalPoints[index].x, mLocalPoints[index].y);
      }

      public function GetLocalVertexPoints ():Array
      {
         var points:Array = new Array (mLocalPoints.length);

         for (var i:int = 0; i < mLocalPoints.length; ++ i)
         {
            points [i] = new Point (mLocalPoints[i].x, mLocalPoints[i].y);
         }

         return points;
      }

      public function SetLocalVertexPoints (points:Array):void
      {
         if (mLocalPoints.length != points.length)
         {
            mLocalPoints = new Array (points.length);
            for (i = 0; i < mLocalPoints.length; ++ i)
               mLocalPoints [i] = new Point ();
         }

         for (var i:int = 0; i < mLocalPoints.length; ++ i)
         {
            mLocalPoints [i].x =  points [i].x;
            mLocalPoints [i].y =  points [i].y;
         }

         SynchronizeWithLocalPoints ();
      }

      public function SynchronizeWithWorldPoints ():void
      {
         var centerX:Number = 0;
         var centerY:Number = 0;

         var point:Point;
         var i:int;
         for (i = 0; i < mVertexPoints.length; ++ i)
         {
            point = mVertexPoints [i] as Point;
            centerX += point.x;
            centerY += point.y;
         }

         if (mVertexPoints.length > 0)
         {
            centerX /= mVertexPoints.length;
            centerY /= mVertexPoints.length;
         }

         if (mLocalPoints.length != mVertexPoints.length)
         {
            mLocalPoints = new Array (mVertexPoints.length);
            for (i = 0; i < mLocalPoints.length; ++ i)
               mLocalPoints [i] = new Point ();
         }

         var radians:Number = - GetRotation ();
         var cos:Number = Math.cos (radians);
         var sin:Number = Math.sin (radians);
         var dx:Number;
         var dy:Number;
         for (i = 0; i < mLocalPoints.length; ++ i)
         {
            point = mVertexPoints [i] as Point;
            dx = point.x - centerX;
            dy = point.y - centerY;
            mLocalPoints [i].x =  dx * cos - dy * sin;
            mLocalPoints [i].y =  dx * sin + dy * cos;
         }

         SetPosition (centerX, centerY);

         UpdateLocalBoundingBox ();
      }

      private function SynchronizeWithLocalPoints ():void
      {
         var centerX:Number = GetPositionX ();
         var centerY:Number = GetPositionY ();

         if (mVertexPoints.length != mLocalPoints.length)
         {
            mVertexPoints = new Array (mLocalPoints.length);
            for (i = 0; i < mVertexPoints.length; ++ i)
               mVertexPoints [i] = new Point ();
         }

         var point:Point;
         var i:int;
         var radians:Number = GetRotation ();
         var cos:Number = Math.cos (radians);
         var sin:Number = Math.sin (radians);
         var dx:Number;
         var dy:Number;
         for (i = 0; i < mVertexPoints.length; ++ i)
         {
            point = mLocalPoints [i] as Point;
            dx = point.x - 0;
            dy = point.y - 0;
            mVertexPoints [i].x = centerX + dx * cos - dy * sin;
            mVertexPoints [i].y = centerY + dx * sin + dy * cos;
         }

         UpdateLocalBoundingBox ();
      }

      private function UpdateLocalBoundingBox ():void
      {
         mMinX = mMinY = -1.0;
         mMaxX = mMaxY = 1.0;

         for (var i:int = 0; i < mLocalPoints.length; ++ i)
         {
            if (mMinX > mLocalPoints [i].x)
               mMinX = mLocalPoints [i].x;
            if (mMaxX < mLocalPoints [i].x)
               mMaxX = mLocalPoints [i].x;
            if (mMinY > mLocalPoints [i].y)
               mMinY = mLocalPoints [i].y;
            if (mMaxY < mLocalPoints [i].y)
               mMaxY = mLocalPoints [i].y;
         }
      }

//====================================================================
//   clone
//====================================================================

      override protected function CreateCloneShell ():Entity
      {
         return new EntityVectorShapePolygon (mWorld);
      }

      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var polygon:EntityVectorShapePolygon = entity as EntityVectorShapePolygon;

         for (var i:int = 0; i < mLocalPoints.length; ++ i)
         {
            polygon.mLocalPoints.push (new Point (mLocalPoints [i].x, mLocalPoints[i].y));
         }

         polygon.SynchronizeWithLocalPoints ();
      }


//========================================================================
// vertex controllers
//========================================================================

      private var mVertexControllers:Array = null;

      override public function GetVertexControllerIndex (vertexController:VertexController):int
      {
         if (mVertexControllers != null)
         {
            for (var i:int = 0; i < mVertexPoints.length; ++ i)
            {
               if (mVertexControllers [i] == vertexController)
               {
                  return i;
               }
            }
         }

         return -1;
      }

      override public function GetVertexControllerByIndex (index:int):VertexController
      {
         if (mVertexControllers != null && index >= 0 && index < mVertexControllers.length)
         {
            return mVertexControllers [index];
         }

         return null;
      }

      override public function SetInternalComponentsVisible (visible:Boolean):void
      {
         // mVertexControlPointsVisible = visible;
         super.SetInternalComponentsVisible (visible);

         if (mSelectionProxy == null)
            return;

      // create / destroy controllers

         var i:int;
         var vertexController:VertexController;

         if ( AreInternalComponentsVisible () )
         {
            SetInternalComponentsVisible (false);
            super.SetInternalComponentsVisible (true);

            mVertexControllers = new Array (mVertexPoints.length);

            for (i = 0; i < mVertexPoints.length; ++ i)
            {
               vertexController = new VertexController (mWorld, this);
               mVertexControllers [i] = vertexController;
               addChild (vertexController);
            }

            UpdateVertexControllers (true);
         }
         else
         {
            if (mVertexControllers != null)
            {
               for (i = 0; i < mVertexControllers.length; ++ i)
               {
                  vertexController = mVertexControllers [i] as VertexController;
                  vertexController.Destroy ();
                  if (contains (vertexController))
                     removeChild (vertexController);

                  mVertexControllers [i] = null;
               }
            }

            mVertexControllers = null;
         }
      }

      public function UpdateVertexControllers (updateSelectionProxy:Boolean):void
      {
         if (mVertexControllers != null)
         {
            var i:int;
            var vertexController:VertexController;

            for (i = 0; i < mVertexPoints.length; ++ i)
            {
               vertexController = mVertexControllers [i] as VertexController;

               if (vertexController != null)
               {
                  vertexController.SetPosition (mLocalPoints [i].x, mLocalPoints [i].y);

                  if (updateSelectionProxy)
                     vertexController.UpdateSelectionProxy ();
               }
            }
         }
      }

      private var _MovingVertexIndex:int = -1;
      override public function OnBeginMovingVertexController (movingVertexController:VertexController):void
      {
         _MovingVertexIndex = GetVertexControllerIndex (movingVertexController);
      }

      override public function OnEndMovingVertexController (movingVertexController:VertexController):void
      {
         _MovingVertexIndex = -1;

         UpdateSelectionProxy ();
         UpdateVertexControllers (true);
         UpdateAppearance ();
      }

      override public function OnMovingVertexController (movingVertexController:VertexController, localOffsetX:Number, localOffsetY:Number):void
      {
      // ...
         if (mVertexControllers == null || _MovingVertexIndex < 0 || mVertexControllers [_MovingVertexIndex] != movingVertexController)
            return;

         if (_MovingVertexIndex < mLocalPoints.length)
         {
            mLocalPoints [_MovingVertexIndex].x += localOffsetX;
            mLocalPoints [_MovingVertexIndex].y += localOffsetY;
         }

         SynchronizeWithLocalPoints ();
         SynchronizeWithWorldPoints ();

         //UpdateSelectionProxy ();
         UpdateAppearance ();
         //UpdateVertexControllers (true);
         UpdateVertexControllers (false);
      }

      override public function OnVertexControllerSelectedChanged (selectedVertexController:VertexController, selected:Boolean):void
      {
         var index:int = GetVertexControllerIndex (selectedVertexController);

         if (index >= 0)
         {
            var prevVertexController:VertexController = mVertexControllers [(index + mVertexControllers.length - 1) % mVertexControllers.length];
            prevVertexController.NotifySelectedSecondarilyChanged (selected);
         }
      }

      override public function RemoveVertexController(vertexController:VertexController):VertexController
      {
         var index:int = GetVertexControllerIndex (vertexController);

         if (index >= 0)
         {
            var vcVisible:Boolean = AreInternalComponentsVisible (); // should be true
            SetInternalComponentsVisible (false);

            if (mVertexPoints.length <= 3)
            {
               mWorld.DestroyEntity (this);
            }
            else
            {
               mVertexPoints.splice (index, 1);
               SynchronizeWithWorldPoints ();

               UpdateSelectionProxy ();
               UpdateAppearance ();

               SetInternalComponentsVisible (vcVisible);
            }

            return null;
         }

         return vertexController;
      }

      override public function InsertVertexController(beforeVertexController:VertexController):VertexController
      {
         var index:int = GetVertexControllerIndex (beforeVertexController);

         if (index >= 0)
         {
            var vcVisible:Boolean = AreInternalComponentsVisible (); // should be true
            SetInternalComponentsVisible (false);
            var beforeIsSelected:Boolean = beforeVertexController.IsSelected (); // should be true

            var prevIndex:int = (index - 1 + mVertexPoints.length) % mVertexPoints.length;

            var centerX:Number = (mVertexPoints [index].x +  mVertexPoints [prevIndex].x) * 0.5;
            var centerY:Number = (mVertexPoints [index].y +  mVertexPoints [prevIndex].y) * 0.5;

            mVertexPoints.splice (index, 0, new Point (centerX, centerY));

            SynchronizeWithWorldPoints ();

            UpdateSelectionProxy ();
            UpdateAppearance ();

            SetInternalComponentsVisible (vcVisible);
            beforeVertexController = mVertexControllers [index + 1];
            beforeVertexController.NotifySelectedChanged (beforeIsSelected);
         }

         return beforeVertexController;
      }

//====================================================================
//  SetRotation / SetPosition
//====================================================================

      override public function SetPosition (posX:Number, posY:Number):void
      {
         super.SetPosition (posX, posY);

         SynchronizeWithLocalPoints ();
      }

      override  public function SetRotation (rot:Number):void
      {
         super.SetRotation (rot);

         SynchronizeWithLocalPoints ();
      }

//====================================================================
//   move, rotate, scale
//====================================================================

      override public function Move (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Move (offsetX, offsetY, false);

         SynchronizeWithLocalPoints ();

         if (updateSelectionProxy)
            UpdateSelectionProxy ();

         UpdateVertexControllers (updateSelectionProxy);
      }

      override public function Rotate (centerX:Number, centerY:Number, dRadians:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Rotate (centerX, centerY, dRadians, false);

         SynchronizeWithLocalPoints ();

         if (updateSelectionProxy)
            UpdateSelectionProxy ();

         UpdateVertexControllers (updateSelectionProxy);
      }

      override public function Scale (centerX:Number, centerY:Number, ratio:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Scale (centerX, centerY, ratio, false);

         SynchronizeWithLocalPoints ();

         if (updateSelectionProxy)
            UpdateSelectionProxy ();

         UpdateVertexControllers (updateSelectionProxy);
      }

      override public function ScaleSelf (ratio:Number):void
      {
         super.ScaleSelf (ratio);

         for (var i:int = 0; i < mLocalPoints.length; ++ i)
         {
            mLocalPoints [i].x = ratio * mLocalPoints [i].x;
            mLocalPoints [i].y = ratio * mLocalPoints [i].y;
         }

         //SynchronizeWithLocalPoints ();
      }

      override public function FlipHorizontally (mirrorX:Number, updateSelectionProxy:Boolean = true):void
      {
         for (var i:int = 0; i < mLocalPoints.length; ++ i)
         {
            mVertexPoints [i].x = mirrorX + mirrorX - mVertexPoints [i].x;
         }

         SynchronizeWithWorldPoints ();

         //for (var i:int = 0; i < mLocalPoints.length; ++ i)
         //{
         //   mLocalPoints [i].x = - mLocalPoints [i].x;
         //}
         //
         //SynchronizeWithLocalPoints ();

         if (updateSelectionProxy)
            UpdateSelectionProxy ();

         UpdateAppearance ();

         UpdateVertexControllers (true);
      }

      override public function FlipSelfHorizontally ():void
      {
      }

      override public function FlipVertically (mirrorY:Number, updateSelectionProxy:Boolean = true):void
      {
         for (var i:int = 0; i < mLocalPoints.length; ++ i)
         {
            mVertexPoints [i].y = mirrorY + mirrorY - mVertexPoints [i].y;
         }

         SynchronizeWithWorldPoints ();

         //for (var i:int = 0; i < mLocalPoints.length; ++ i)
         //{
         //   mLocalPoints [i].y = - mLocalPoints [i].y;
         //}
         //
         //SynchronizeWithLocalPoints ();

         if (updateSelectionProxy)
            UpdateSelectionProxy ();

         UpdateAppearance ();

         UpdateVertexControllers (true);
      }

      override public function FlipSelfVertically ():void
      {
      }

   }
}
