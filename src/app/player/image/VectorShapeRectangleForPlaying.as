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
         
         var cornerWidth:Number = GetCornerEclipseWidth ();
         var cornerHeight:Number = GetCornerEclipseHeight ();
         
         if (moduleSprite.IsAdjustShapeVisualSize ())
         {
            if (IsBuildBackground () || displayBorderThickness < Number.MIN_VALUE)
            {
               displayHalfWidth += 0.5 / moduleSprite.GetScale (); // + 0.5 to avoid the visual leaps between contacting shapes sometimes
               displayHalfHeight += 0.5 / moduleSprite.GetScale (); // + 0.5 to avoid the visual leaps between contacting shapes sometimes
               
               cornerWidth += 0.5;
               cornerHeight += 0.5;
            }
            else
            {
               displayBorderThickness += 1.0 / moduleSprite.GetScale (); // + 1.0 to avoid the visual leaps between contacting shapes sometimes
            }
         }
         
         if (cornerWidth > displayHalfWidth + displayHalfWidth)
            cornerWidth = displayHalfWidth + displayHalfWidth;
         if (cornerHeight > displayHalfHeight + displayHalfHeight)
            cornerHeight = displayHalfHeight + displayHalfHeight;
         var isRoundCorner:Boolean = IsRoundCorner () && (cornerWidth > 0) && (cornerHeight > 0);
         
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
         
            var bitmapModule:ImageBitmap = GetBodyTextureModule () as ImageBitmap;
            var bitmapTransform:Transform2D = GetBodyTextureTransform ();
            
            GraphicsUtil.ClearAndDrawRect (
                     bodyShape,
                     - displayHalfWidth,
                     - displayHalfHeight,
                     displayWidth,
                     displayHeight,
                     borderColor, // useless
                     -1, // not draw border
                     true, // draw background
                     bodyColor,
                     IsRoundJoint (), //IsRoundCorners (),
                     isRoundCorner, cornerWidth, cornerHeight,
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
                     IsRoundJoint () && (! isRoundCorner), // IsRoundCorners ()
                     isRoundCorner, cornerWidth, cornerHeight
                  );
            }
      }

      public function BuildPhysicsProxy (physicsShapeProxy:PhysicsProxyShape, transform:Transform2D):void
      {
         physicsShapeProxy.AddRectangle (transform, 
                                         GetHalfWidth (), // GetHalfWidthInPhysics (), 
                                         GetHalfHeight (), // GetHalfHeightInPhysics (), 
                                         IsBuildBackground (), 
                                         IsBuildBorder (), 
                                         GetBorderThickness (), // GetBorderThicknessInPhysics (), 
                                         IsRoundJoint () // IsRoundCorners ()
                                      );
      }
   }
}
