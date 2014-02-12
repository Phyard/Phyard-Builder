package player.image
{
   import common.display.ModuleSprite;
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import player.physics.PhysicsProxyShape;

   import common.Transform2D;
   import common.shape.VectorShapePolyline;

   public class VectorShapePolylineForPlaying extends VectorShapePolyline implements VectorShapeForPlaying
   {
      public function BuildAppearance (moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
         if (IsDrawBackground ())
         {
            var displayVertexPoints:Array = GetLocalVertexPoints ();
            var displayCurveThickness:Number = GetPathThickness ();
            
            var bodyColor:int = GetBodyColor ();
            
            var bodyShape:Shape = new Shape ();
            bodyShape.alpha = GetBodyAlpha () * alpha;
            if (transform != null)
               transform.TransformUntransformedDisplayObject (bodyShape);
            
            moduleSprite.addChild (bodyShape);
            
            GraphicsUtil.ClearAndDrawPolyline (bodyShape, displayVertexPoints, bodyColor, displayCurveThickness, IsRoundEnds (), IsClosed ());
         }
      }

      public function BuildPhysicsProxy (physicsShapeProxy:PhysicsProxyShape, transform:Transform2D):void
      {
         //physicsShapeProxy.AddPolyline (transform, GetLocalVertexPointsInPhysics (), IsBuildBackground (), GetPathThicknessInPhysics (), IsRoundEnds (), IsClosed ());
         physicsShapeProxy.AddPolyline (transform, 
                                        GetLocalVertexPoints (), 
                                        IsBuildBackground (), 
                                        GetPathThickness (), // GetPathThicknessInPhysics (), 
                                        IsRoundEnds (), 
                                        IsClosed ()
                                        );
      }
   }
}
