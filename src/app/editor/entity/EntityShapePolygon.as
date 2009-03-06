
package editor.entity {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.world.EntityContainer;
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyPolygon;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityShapePolygon extends EntityShape 
   {
   // geom
      
      public var mVertexPoints:Array = new Array (); // in world coordinate
      
      public var mLocalPoints:Array = new Array (); // in local coordinate
      
      private var mIsValid:Boolean = true;
      private var mMinX:Number;
      private var mMaxX:Number;
      private var mMinY:Number;
      private var mMaxY:Number;
      
      public function EntityShapePolygon (world:World)
      {
         super (world);
      }
      
      override public function GetTypeName ():String
      {
         return "Polygon";
      }
      
      override public function UpdateAppearance ():void
      {
         var filledColor:uint = GetFilledColor ();
         var borderColor:uint = GetBorderColor ();
         var drawBg:Boolean = IsDrawBackground ();
         var drawBorder:Boolean = IsDrawBorder ();
         var borderThickness:Number = GetBorderThickness ();
         
         borderThickness = 1;
         
         if ( ! drawBorder || borderThickness < 1)
            drawBg = true;
         
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            borderThickness  = 3.0 / mWorld.GetZoomScale ();
         }
         
         alpha = 0.3 + GetTransparency () * 0.01 * 0.4;
         
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
         }
         
         if (!mIsValid)
         {
             GraphicsUtil.DrawRect (this, mMinX, mMinY, mMaxX - mMinX, mMaxY - mMinY, 0xFF8080, IsSelected () ? 3 : 2, false);
         }
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyPolygon ();
            mSelectionProxy.SetUserData (this);
            
            SetVertexControllersVisible (AreVertexControlPointsVisible ());
         }
         
         (mSelectionProxy as SelectionProxyPolygon).RebuildConcavePolygon ( GetRotation (), GetPositionX (), GetPositionY (), mLocalPoints );
         
         if ((mSelectionProxy as SelectionProxyPolygon).GetProxyShapesCount () == 0)
         {
            mIsValid = false;
            (mSelectionProxy as SelectionProxyPolygon).RebuildConvexPolygon ( GetRotation (), GetPositionX (), GetPositionY (), 
                  [new Point (mMinX, mMinY), new Point (mMaxX, mMinY), new Point (mMaxX, mMaxY), new Point (mMinX, mMaxY)] );
         }
         else
         {
            mIsValid = true;
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
         mMinX = mMinY = mMaxX = mMaxY = 0;
         
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
         return new EntityShapePolygon (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var polygon:EntityShapePolygon = entity as EntityShapePolygon;
         
         for (var i:int = 0; i < mLocalPoints.length; ++ i)
         {
            polygon.mLocalPoints.push (new Point (mLocalPoints [i].x, mLocalPoints[i].y));
         }
         
         polygon.SynchronizeWithLocalPoints ();
         
         polygon.UpdateSelectionProxy ();
         polygon.UpdateAppearance ();
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
      
      override public function SetVertexControllersVisible (visible:Boolean):void
      {
         // mVertexControlPointsVisible = visible;
         super.SetVertexControllersVisible (visible);
         
         if (mSelectionProxy == null)
            return;
         
      // create / destroy controllers
         
         var i:int;
         var vertexController:VertexController;
         
         if ( AreVertexControlPointsVisible () )
         {
            SetVertexControllersVisible (false);
            super.SetVertexControllersVisible (true);
            
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
            var vcVisible:Boolean = AreVertexControlPointsVisible (); // should be true
            SetVertexControllersVisible (false);
            
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
               
               SetVertexControllersVisible (vcVisible);
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
            var vcVisible:Boolean = AreVertexControlPointsVisible (); // should be true
            SetVertexControllersVisible (false);
            var beforeIsSelected:Boolean = beforeVertexController.IsSelected (); // should be true
            
            var prevIndex:int = (index - 1) % mVertexPoints.length;
            
            var centerX:Number = (mVertexPoints [index].x +  mVertexPoints [prevIndex].x) * 0.5;
            var centerY:Number = (mVertexPoints [index].y +  mVertexPoints [prevIndex].y) * 0.5;
            
            mVertexPoints.splice (index, 0, new Point (centerX, centerY));
            
            SynchronizeWithWorldPoints ();
            
            UpdateSelectionProxy ();
            UpdateAppearance ();
            
            SetVertexControllersVisible (vcVisible);
            beforeVertexController = mVertexControllers [index + 1];
            beforeVertexController.NotifySelectedChanged (beforeIsSelected);
         }
         
         return beforeVertexController;
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
      
      override public function FlipSelfHorizontally ():void
      {
         //super.FlipSelfHorizontally ();
         
         //for (var i:int = 0; i < mLocalPoints.length; ++ i)
         //{
         //   mVertexPoints [i].x = mirrorX + mirrorX - mVertexPoints [i].x;
         //}
         //
         //SynchronizeWithWorldPoints ();
         
         for (var i:int = 0; i < mLocalPoints.length; ++ i)
         {
            mLocalPoints [i].x = - mLocalPoints [i].x;
         }
         
         SynchronizeWithLocalPoints ();
         
         UpdateSelectionProxy ();
         UpdateAppearance ();
         
         UpdateVertexControllers (true);
      }
      
      override public function FlipSelfVertically ():void
      {
         //super.FlipSelfVertically ();
         
         //for (var i:int = 0; i < mLocalPoints.length; ++ i)
         //{
         //   mVertexPoints [i].y = mirrorY + mirrorY - mVertexPoints [i].y;
         //}
         //
         //SynchronizeWithWorldPoints ();
         
         for (var i:int = 0; i < mLocalPoints.length; ++ i)
         {
            mLocalPoints [i].y = - mLocalPoints [i].y;
         }
         
         SynchronizeWithLocalPoints ();
         
         UpdateSelectionProxy ();
         UpdateAppearance ();
         
         UpdateVertexControllers (true);
      }
      

   }
}
