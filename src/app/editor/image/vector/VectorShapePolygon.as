pacakge editor.image.vector
{
   import flash.geom.Point;
   
   public class VectorShapePolygon extends VectorShapeArea
   {
      protected var mLocalPoints:Array = new Array (); // should not be null, at lesst 3 points
      
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
