package editor.image.vector
{
   import flash.geom.Point;
   
   public class VectorShapePolygon extends VectorShapeArea
   {
      protected var mLocalVertexPoints:Array = new Array (); // should not be null, at lesst 3 points
      
      public function GetLocalVertexPoints ():Array
      {
         return mLocalVertexPoints;
      }
      
      public function SetLocalVertexPoints (points:Array):void
      {
         mLocalVertexPoints = points;
      }
   }
}
