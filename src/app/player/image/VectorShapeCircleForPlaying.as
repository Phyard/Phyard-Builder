package player.image
{
   import common.display.ModuleSprite;
   import flash.display.Shape;

   import player.physics.PhysicsProxyBody;
   
   import player.design.Global;
   
   import com.tapirgames.util.GraphicsUtil;

   import common.Transform2D;
   import common.shape.VectorShapeCircle;
   
   import common.CoordinateSystem;
   import common.Define;

   public class VectorShapeCircleForPlaying extends VectorShapeCircle implements VectorShapeForPlaying
   {
      public function BuildAppearance (moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
         var displayRadius:Number = GetRadius ();
         var displayBorderThickness:Number = GetBorderThickness ();
         
         if (moduleSprite.IsAdjustShapeVisualSize ())
         {
            if (IsBuildBackground () || displayBorderThickness < Number.MIN_VALUE)
            {
               displayRadius += 0.5 / moduleSprite.GetScale (); // + 0.5 to avoid the visual leaps between contacting shapes sometimes
            }
            else
            {
               displayBorderThickness += 1.0 / moduleSprite.GetScale (); // + 1.0 to avoid the visual leaps between contacting shapes sometimes
            }
         }
         
         var bodyColor:int = GetBodyColor ();
         var borderColor:int = GetBorderColor ();
         
         if (IsDrawBackground ())
         {
            var bodyShape:Shape = new Shape ();
            bodyShape.alpha = GetBodyAlpha () * alpha;
            if (transform != null)
               transform.TransformUntransformedDisplayObject (bodyShape);
            
            moduleSprite.addChild (bodyShape);
            
            GraphicsUtil.ClearAndDrawCircle (
                     bodyShape,
                     0,
                     0,
                     displayRadius,
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
            
            GraphicsUtil.ClearAndDrawCircle (
                     borderShape,
                     0,
                     0,
                     displayRadius,
                     borderColor,
                     displayBorderThickness, // draw border
                     false // not draw background
                  );
            
            var appearanceType:int = GetAppearanceType ();
            if (appearanceType == Define.CircleAppearanceType_Ball)
            {
               GraphicsUtil.DrawCircle (
                        borderShape,
                        displayRadius * 0.67,
                        0,
                        0.5, // radius
                        IsDrawBackground () ? GraphicsUtil.GetInvertColor_b (bodyColor) : borderColor, 
                        1, 
                        false
                     );
            }
            else if (appearanceType == Define.CircleAppearanceType_Column)
            {
               var halfRadius:Number = displayRadius * 0.5;
               GraphicsUtil.DrawCircle (
                        borderShape,
                        0,
                        0,
                        halfRadius,
                        borderColor, 
                        1, 
                        false
                     );
               GraphicsUtil.DrawLine (
                        borderShape, 
                        halfRadius, 
                        0, 
                        displayRadius, 
                        0, 
                        borderColor, 
                        1
                     );
            }
         }
      }

      public function BuildPhysicsProxy (physicsBodyProxy:PhysicsProxyBody, transform:Transform2D):void
      {
      }
   }
}
