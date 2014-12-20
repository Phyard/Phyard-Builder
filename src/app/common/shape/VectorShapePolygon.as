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
// for editing
//==============================================

      public function GetLocalLinkPoint ():Point
      {
         if (mLocalVertexPoints.length == 0)
            return new Point (0, 0);
         
         if (mLocalVertexPoints.length == 1)
         {
            var point:Point = mLocalVertexPoints [0] as Point;
            return new Point (point.x, point.y);
        }
        
        var point0:Point = mLocalVertexPoints [0] as Point;
        var point1:Point = mLocalVertexPoints [1] as Point;
        return new Point (0.5 * (point0.x + point1.x), 0.5 * (point0.y + point1.y));
      }

//==============================================
// for playing
//==============================================

      //protected var mLocalVertexPointsInPhysics:Array = new Array (); // should not be null, at lesst 3 points

      //public function GetLocalVertexPointsInPhysics ():Array
      //{
      //   //return mLocalVertexPoints;
      //   return GraphicsUtil.DeepClonePointArray (mLocalVertexPointsInPhysics);
      //}

      //public function SetLocalVertexPointsInPhysics (points:Array):void
      //{
      //   //mLocalVertexPoints = points;
      //   mLocalVertexPointsInPhysics = GraphicsUtil.DeepClonePointArray (points);
      //}

   }
}
