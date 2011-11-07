package player.image
{
   import common.display.ModuleSprite;
   import flash.display.Shape;
   
   import com.tapirgames.util.GraphicsUtil;

   import player.physics.PhysicsProxyShape;

   import common.Transform2D;
   import common.shape.VectorShapeRectangle;

   public class VectorShapeRectangleForPlaying extends VectorShapeRectangle implements VectorShapeForPlaying
   {
      public function BuildAppearance (moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
         var displayHalfWidth :Number = GetHalfWidth ();
         var displayHalfHeight:Number = GetHalfHeight ();
         var displayBorderThickness:Number = GetBorderThickness ();

         if (moduleSprite.IsAdjustShapeVisualSize ())
         {
            if (IsBuildBackground () || displayBorderThickness < Number.MIN_VALUE)
            {
               displayHalfWidth += 0.5 / moduleSprite.GetScale (); // + 0.5 to avoid the visual leaps between contacting shapes sometimes
               displayHalfHeight += 0.5 / moduleSprite.GetScale (); // + 0.5 to avoid the visual leaps between contacting shapes sometimes
            }
            else
            {
               displayBorderThickness += 1.0 / moduleSprite.GetScale (); // + 1.0 to avoid the visual leaps between contacting shapes sometimes
            }
         }
         
         var bodyColor:int = GetBodyColor ();
         var borderColor:int = GetBorderColor ();
         
         var displayWidth :Number = displayHalfWidth +  displayHalfWidth;
         var displayHeight:Number = displayHalfHeight +  displayHalfHeight;
         
         if (IsDrawBackground ())
         {
            var bodyShape:Shape = new Shape ();
            bodyShape.alpha = GetBodyAlpha () * alpha;
            if (transform != null)
               transform.TransformUntransformedDisplayObject (bodyShape);
            
            moduleSprite.addChild (bodyShape);
            
            GraphicsUtil.ClearAndDrawRect (
                     bodyShape,
                     - displayHalfWidth,
                     - displayHalfHeight,
                     displayWidth,
                     displayHeight,
                     borderColor, // useless
                     -1, // not draw border
                     true, // draw background
                     bodyColor
                  );
         }
         
         if (IsDrawBorder ())
         {
            var borderShape:Shape = new Shape ();
            borderShape.alpha = GetBorderAlpha () * alpha;
            if (transform != null)
               transform.TransformUntransformedDisplayObject (borderShape);
            
            moduleSprite.addChild (borderShape);
            
            GraphicsUtil.ClearAndDrawRect (
                     borderShape,
                     - displayHalfWidth,
                     - displayHalfHeight,
                     displayWidth,
                     displayHeight,
                     borderColor,
                     displayBorderThickness, // draw border
                     false, // not draw background
                     0x0, // invald bg color
                     IsRoundCorners ()
                  );
            }
      }

      public function BuildPhysicsProxy (physicsShapeProxy:PhysicsProxyShape, transform:Transform2D):void
      {
         physicsShapeProxy.AddRectangleByTransform (transform, GetHalfWidthInPhysics (), GetHalfHeightInPhysics (), IsBuildBackground (), IsBuildBorder (), GetBorderThicknessInPhysics (), IsRoundCorners ());
      }
   }
}
