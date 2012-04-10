package common.shape
{
   import flash.geom.Point;

   import com.tapirgames.util.GraphicsUtil;

   public class VectorShapePolygon extends VectorShapeArea
   {
      protected var mLocalVertexPoints:Array = new Array (); // should not be null, at lesst 3 points

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
