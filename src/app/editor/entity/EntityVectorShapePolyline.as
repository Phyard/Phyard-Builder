
package editor.entity {

   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.system.Capabilities;

   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;

   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxy;
   
   import editor.image.vector.*;
   import common.shape.*;
   
   import common.Define;

   public class EntityVectorShapePolyline extends EntityVectorShapePath
   {
   // geom

      //public var mVertexPoints:Array = new Array (); // in world coordinate
      //
      //public var mLocalPoints:Array = new Array (); // in local coordinate
      //
      // moved to EntityVectorShapePath now.
      //protected var mCurveThickness:uint = 1;
      //
      //protected var mIsRoundEnds:Boolean = true; // v1.08
      //
      //protected var mIsClosed:Boolean = false; // v1.57
      protected var mVectorShapePolyline:VectorShapePolylineForEditing = new VectorShapePolylineForEditing ();

      //private var mMinX:Number;
      //private var mMaxX:Number;
      //private var mMinY:Number;
      //private var mMaxY:Number;

      public function EntityVectorShapePolyline (container:Scene)
      {
         super (container, mVectorShapePolyline);
         SetStatic (true);
         SetFilledColor (Define.ColorStaticObject);
         SetCurveThickness (0);
      }

      override public function GetTypeName ():String
      {
         return "Polyline";
      }

      override public function GetInfoText ():String
      {
         return super.GetInfoText ();
         /*
         var vertexController:VertexController = mEntityContainer.GetTheOnlySelectedVertexControllers ();
         if (vertexController == null)
            return super.GetInfoText ();

         var vertexIndex:int = GetVertexControllerIndex (vertexController);

         return super.GetInfoText () + ", vertex#" + vertexIndex + " is selected.";
         */
      }

      override public function GetPhysicsShapesCount ():uint
      {
         return 1;
         /*
         if ( ! IsPhysicsEnabled () )
            return 0;

         if (GetCurveThickness () <= 1)
            return 0;

         return mLocalPoints.length * 2 - 1;
         */
      }

      override public function OnWorldZoomScaleChanged ():void
      {
         super.OnWorldZoomScaleChanged ();

         UpdateSelectionProxy ();
      }

//====================================================================
//   curve, moved to EntityVectorShapePath now
//====================================================================

      //public function SetCurveThickness (thickness:uint):void
      //{
      //   mCurveThickness = thickness;
      //}
      //
      //public function GetCurveThickness ():uint
      //{
      //   return mCurveThickness;
      //}
      //
      //public function SetRoundEnds (roundEnds:Boolean):void
      //{
      //   mIsRoundEnds = roundEnds;
      //}
      //
      //public function IsRoundEnds ():Boolean
      //{
      //   return mIsClosed || mIsRoundEnds;
      //}
      //
      //public function SetClosed (closed:Boolean):void
      //{
      //   mIsClosed = closed;
      //}
      //
      //public function IsClosed ():Boolean
      //{
      //   return mIsClosed;
      //}

//====================================================================
//   vertex
//====================================================================

      public function GetVertexPointsCount ():int
      {
         //return mVertexPoints.length;
         return mVectorShapePolyline.GetVertexPointsCount ();
      }

      public function GetLocalVertexPoints ():Array
      {
         //var points:Array = new Array (mLocalPoints.length);
         //
         //for (var i:int = 0; i < mLocalPoints.length; ++ i)
         //{
         //   points [i] = new Point (mLocalPoints[i].x, mLocalPoints[i].y);
         //}
         //
         //return points;
         
         return mVectorShapePolyline.GetLocalVertexPoints ();
      }

      public function SetLocalVertexPoints (points:Array):void
      {
         //if (mLocalPoints.length != points.length)
         //{
         //   mLocalPoints = new Array (points.length);
         //   for (i = 0; i < mLocalPoints.length; ++ i)
         //      mLocalPoints [i] = new Point ();
         //}
         //
         //for (var i:int = 0; i < mLocalPoints.length; ++ i)
         //{
         //   mLocalPoints [i].x =  points [i].x;
         //   mLocalPoints [i].y =  points [i].y;
         //}
         //
         //SynchronizeWithLocalPoints ();
         
         mVectorShapePolyline.SetLocalVertexPoints (points);
      }

//====================================================================
//   appearacne and selection proxy
//====================================================================
      
      override public function UpdateSelectionProxy ():void
      {
         super.UpdateSelectionProxy ();
         
         UpdateLinkPoint ();
      }

//====================================================================
//   clone
//====================================================================

      override protected function CreateCloneShell ():Entity
      {
         return new EntityVectorShapePolyline (mEntityContainer);
      }

      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var polyline:EntityVectorShapePolyline = entity as EntityVectorShapePolyline;

         polyline.SetCurveThickness (GetCurveThickness ());
         polyline.SetRoundEnds (IsRoundEnds ());
         polyline.SetClosed (IsClosed ());

         //for (var i:int = 0; i < mLocalPoints.length; ++ i)
         //{
         //   polyline.mLocalPoints.push (new Point (mLocalPoints [i].x, mLocalPoints[i].y));
         //}
         polyline.SetLocalVertexPoints (GetLocalVertexPoints ());

         //polyline.SynchronizeWithLocalPoints ();
         //polyline.UpdateSelectionProxy ();
      }

//====================================================================
//   entity links
//====================================================================

      private var mLinkPoint:Point = new Point (); // in scene coordinate

      private function UpdateLinkPoint ():void
      {
         var localLinkPoint:Point = mVectorShapePolyline.GetLocalLinkPoint ();
         
         mTransform.TransformPoint (localLinkPoint, mLinkPoint);
      }

      override public function GetLinkPointX ():Number
      {
         return mLinkPoint.x;
      }

      override public function GetLinkPointY ():Number
      {
         return mLinkPoint.y;
      }
   }
}
