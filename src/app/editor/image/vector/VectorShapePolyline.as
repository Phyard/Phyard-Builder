package editor.image.vector
{
   import flash.geom.Point;
   
   public class VectorShapePolyline extends VectorShapePath
   {
      protected var mLocalPoints:Array = new Array (); // should not be null, at lesst 2 points
      
      public function GetLocalPoints ():Array
      {
         return mLocalPoints;
      }
      
      public function SetLocalPoints (points:Array):void
      {
         mLocalPoints = points;
      }
   }
}
