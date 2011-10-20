package editor.image.vector
{
   import flash.geom.Point;
   
   public class VectorShapePolyline extends VectorShapePath
   {
      protected var mLocalVertexPoints:Array = new Array (); // should not be null, at lesst 2 points
      
      public function VectorShapePolyline ()
      {
         SetBackgroundColor (0x000000);
      }
      
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
