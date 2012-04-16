package common.shape
{
   import flash.geom.Point;

   import com.tapirgames.util.GraphicsUtil;

   public class VectorShapePolyline extends VectorShapePath
   {
      public function VectorShapePolyline ()
      {
         SetBodyColor (0x000000); // the path color <=> body color
         SetRoundEnds (false);
      }

      protected var mLocalVertexPoints:Array = new Array (); // should not be null, at lesst 2 points

      public function GetVertexPointsCount ():int
      {
         return mLocalVertexPoints.length;
      }

      public function GetLocalVertexPoints ():Array
      {
         //return mLocalVertexPoints;
         return GraphicsUtil.DeepClonePointArray (mLocalVertexPoints);
      }

      public function SetLocalVertexPoints (points:Array):void
      {
         //mLocalVertexPoints = points;
         mLocalVertexPoints = GraphicsUtil.DeepClonePointArray (points);
      }

//==============================================
// for editing
//==============================================

      public function GetLocalLinkPoint ():Point
      {
         if (mLocalVertexPoints.length == 0)
            return new Point (0, 0);
         
         var point:Point;
         
         if (mLocalVertexPoints.length == 1)
         {
            point = mLocalVertexPoints [0] as Point;
            return new Point (point.x, point.y);
         }
         
         var index2:int = Math.round (mLocalVertexPoints.length / 2);
         var index1:int = index2 - 1;
         
         var point1:Point = mLocalVertexPoints [index1] as Point;
         var point2:Point = mLocalVertexPoints [index2] as Point;

         return new Point (0.5 * (point1.x + point2.x), 0.5 * (point1.y + point2.y));
      }

//==============================================
// for playing
//==============================================

      protected var mLocalVertexPointsInPhysics:Array = new Array (); // should not be null, at lesst 3 points

      public function GetLocalVertexPointsInPhysics ():Array
      {
         //return mLocalVertexPoints;
         return GraphicsUtil.DeepClonePointArray (mLocalVertexPointsInPhysics);
      }

      public function SetLocalVertexPointsInPhysics (points:Array):void
      {
         //mLocalVertexPoints = points;
         mLocalVertexPointsInPhysics = GraphicsUtil.DeepClonePointArray (points);
      }
   }
}
