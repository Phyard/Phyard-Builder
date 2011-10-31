package common.shape
{
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;

   public class VectorShapePolyline extends VectorShapePath
   {
      public function VectorShapePolyline ()
      {
         SetBodyColor (0x000000);
      }
      
      protected var mLocalVertexPoints:Array = new Array (); // should not be null, at lesst 2 points

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
   }
}
