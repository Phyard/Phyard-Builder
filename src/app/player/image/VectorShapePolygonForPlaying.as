package player.image
{
   import common.display.ModuleSprite;
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import player.physics.PhysicsProxyShape;

   import common.Transform2D;
   import common.shape.VectorShapePolygon;

   public class VectorShapePolygonForPlaying extends VectorShapePolygon implements VectorShapeForPlaying
   {
      public function BuildAppearance (moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
         var displayVertexPoints:Array = GetLocalVertexPoints ();
         var displayBorderThickness:Number = GetBorderThickness ();
         
         var bodyColor:int = GetBodyColor ();
         var borderColor:int = GetBorderColor ();

         if (IsDrawBackground ())
         {
            var bodyShape:Shape = new Shape ();
            bodyShape.alpha = GetBodyAlpha () * alpha;
            if (transform != null)
               transform.TransformUntransformedDisplayObject (bodyShape);
            
            moduleSprite.addChild (bodyShape);
         
            var bitmapModule:ImageBitmap = GetBodyTextureModule () as ImageBitmap;
            var bitmapTransform:Transform2D = GetBodyTextureTransform ();
            
            GraphicsUtil.ClearAndDrawPolygon (
                     bodyShape,
                     displayVertexPoints,
                     borderColor,
                     -1, // not draw border
                     true, // draw background
                     bodyColor,
                     bitmapModule == null ? null : bitmapModule.GetBitmapData (),
                     bitmapTransform == null ? null : bitmapTransform.ToMatrix ()
                  );
         }
         
         if (IsDrawBorder ())
         {
            var borderShape:Shape = new Shape ();
            borderShape.alpha = GetBorderAlpha () * alpha;
            if (transform != null)
               transform.TransformUntransformedDisplayObject (borderShape);
            
            moduleSprite.addChild (borderShape);
            
            GraphicsUtil.ClearAndDrawPolygon (
                     borderShape,
                     displayVertexPoints,
                     borderColor,
                     displayBorderThickness, // draw border
                     false // not draw background
                  );
         }
      }

      public function BuildPhysicsProxy (physicsShapeProxy:PhysicsProxyShape, transform:Transform2D):void
      {
         //physicsShapeProxy.AddPolygon (transform, GetLocalVertexPointsInPhysics (), IsBuildBackground (), IsBuildBorder (), GetBorderThicknessInPhysics ());
         physicsShapeProxy.AddPolygon (transform, 
                                       GetLocalVertexPoints (), 
                                       IsBuildBackground (), 
                                       IsBuildBorder (), 
                                       GetBorderThickness () // GetBorderThicknessInPhysics ()
                                       );
      }
   }
}
