
package editor.entity {

   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.system.Capabilities;

   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;

   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyPolygon;
   
   import editor.image.vector.*;
   import common.shape.*;
   
   import common.Define;

   public class EntityVectorShapePolygon extends EntityVectorShapeArea
   {
   // geom

      //public var mVertexPoints:Array = new Array (); // in world coordinate
      //
      //public var mLocalPoints:Array = new Array (); // in local coordinate
      //
      //private var mIsValid:Boolean = true;
      //private var mMinX:Number;
      //private var mMaxX:Number;
      //private var mMinY:Number;
      //private var mMaxY:Number;
      
      protected var mVectorShapePolygon:VectorShapePolygonForEditing = new VectorShapePolygonForEditing ();

      public function EntityVectorShapePolygon (container:Scene)
      {
         super (container, mVectorShapePolygon);
         SetStatic (true);
         SetFilledColor (Define.ColorStaticObject);
         SetDrawBorder (false);
         SetBuildBorder (false);
         SetBorderThickness (0);
      }

      override public function GetTypeName ():String
      {
         return "Polygon";
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

         var count:uint = 0;

         if ( ! IsHollow () && mSelectionProxy != null && mIsValid)
            count += (mSelectionProxy as SelectionProxyPolygon).GetProxyShapesCount ();

         if (GetBorderThickness () > 1)
            count += mLocalPoints.length * 2;

         return count;
         */
      }

//====================================================================
//   vertex
//====================================================================

      public function GetVertexPointsCount ():int
      {
         //return mVertexPoints.length;
         return mVectorShapePolygon.GetVertexPointsCount ();
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
         
         return mVectorShapePolygon.GetLocalVertexPoints ();
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
         
         mVectorShapePolygon.SetLocalVertexPoints (points);
      }

//====================================================================
//   clone
//====================================================================
      
      public static function ScalePoints (points:Array, s:Number):void
      {
         if (points == null)
            return;
         
         var index:int = points.length;
         while (index > 0)
         {
            index = index - 1;
            
            var point:Point = points [index] as Point;
            if (point != null)
            {
               point.x *= s;
               point.y *= s;
            }
         }
      }
      
      override public function EnlargeSelf (s:Number/*, intentionDone:Boolean = true*/):void
      {  
         if (s < 0)
            s = -s;
         
         if (s > 0)
         {
            var points:Array = GetLocalVertexPoints ();
            ScalePoints (points, s);
            SetLocalVertexPoints (points);
            
            UpdateAppearance ();
         }
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
         return new EntityVectorShapePolygon (mEntityContainer);
      }

      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);

         var polygon:EntityVectorShapePolygon = entity as EntityVectorShapePolygon;

         //for (var i:int = 0; i < mLocalPoints.length; ++ i)
         //{
         //   polygon.mLocalPoints.push (new Point (mLocalPoints [i].x, mLocalPoints[i].y));
         //}
         polygon.SetLocalVertexPoints (GetLocalVertexPoints ());

         //polygon.SynchronizeWithLocalPoints ();
      }

//====================================================================
//   entity links
//====================================================================

      private var mLinkPoint:Point = new Point (); // in scene coordinate

      private function UpdateLinkPoint ():void
      {
         var localLinkPoint:Point = mVectorShapePolygon.GetLocalLinkPoint ();
         
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
