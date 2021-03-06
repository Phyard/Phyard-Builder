package editor.image.vector
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;

   import com.tapirgames.util.GraphicsUtil;

   import editor.selection.SelectionProxy;

   import editor.asset.Asset;
   import editor.asset.ControlPoint;
   import editor.asset.ControlPointModifyResult;
   
   import editor.image.AssetImageBitmapModule;

   import common.shape.VectorShapeRectangle;

   import common.Transform2D;

   public class VectorShapeRectangleForEditing extends VectorShapeRectangle implements VectorShapeForEditing
   {
      public static function OnCreatingRectangle (rectangle:VectorShapeRectangle, points:Array):Point
      {
         if (points == null || points.length < 2)
         {
            rectangle.SetValid (false);
            return null;
         }

         var point1:Point = points [0] as Point;
         var point2:Point = points [1] as Point;
         var posX:Number = 0.5 * (point2.x + point1.x);
         var posY:Number = 0.5 * (point2.y + point1.y);
         var halfWidth:Number  = 0.5 * Math.abs (point2.x - point1.x);
         var halfHeight:Number = 0.5 * Math.abs (point2.y - point1.y);

         rectangle.SetHalfWidth (halfWidth);
         rectangle.SetHalfHeight (halfHeight);

         rectangle.SetValid (true);

         return new Point (posX, posY);
      }

      public function OnCreating (points:Array):Point
      {
         return OnCreatingRectangle (this, points);
      }

      public static function CreateRectangleSprite (rectangle:VectorShapeRectangle, isSelected:Boolean, bodyTextureModule:AssetImageBitmapModule = null, bodyTextureTransform:Transform2D = null, inPreview:Boolean = false):DisplayObject
      {
         var filledColor:uint = rectangle.GetBodyColor ();
         var borderColor:uint = rectangle.GetBorderColor ();
         var drawBg:Boolean = rectangle.IsDrawBackground ();
         var drawBorder:Boolean = rectangle.IsDrawBorder ();
         var borderThickness:Number = rectangle.GetBorderThickness ();

         if ( ! drawBorder)
         {
            drawBg = true;
            borderThickness = -1;
         }
         
         var visualHalfWidth :Number = rectangle.GetHalfWidth  () + 0.5; // be consistent with player
         var visualHalfHeight:Number = rectangle.GetHalfHeight () + 0.5; // be consistent with player
         
         var cornerWidth:Number = rectangle.GetCornerEclipseWidth () + 1; // be consistent with player
         if (cornerWidth > visualHalfWidth + visualHalfWidth)
            cornerWidth = visualHalfWidth + visualHalfWidth;
         var cornerHeight:Number = rectangle.GetCornerEclipseHeight () + 1; // be consistent with player
         if (cornerHeight > visualHalfHeight + visualHalfHeight)
            cornerHeight = visualHalfHeight + visualHalfHeight;
         var isRoundCorner:Boolean = rectangle.IsRoundCorner () && (cornerWidth > 0) && (cornerHeight > 0);
         
         // here these "be consistent with player" are not very consistent with player.
         // see VectorShapeRectangleForPlaying for details.
         
         var rectSprite:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawRect (rectSprite, - visualHalfWidth, - visualHalfHeight, visualHalfWidth + visualHalfWidth, visualHalfHeight + visualHalfHeight, 
                                        borderColor, borderThickness, drawBg, filledColor, 
                                        rectangle.IsRoundJoint (), // IsRoundCorners (), 
                                        isRoundCorner, cornerWidth, cornerHeight,
                                        //false, 0, 0,
                                        bodyTextureModule == null ? null : bodyTextureModule.GetBitmapData (),
                                        bodyTextureTransform == null ? null : bodyTextureTransform.ToMatrix ());

         rectSprite.alpha = inPreview ? 1.0 : 0.39 + rectangle.GetBodyAlpha () * 0.40;
         
         if (isSelected)
         {
            var blueShape:Shape = new Shape ();
            GraphicsUtil.ClearAndDrawRect (blueShape, - visualHalfWidth, - visualHalfHeight, visualHalfWidth + visualHalfWidth, visualHalfHeight + visualHalfHeight, 
                                           0x0000FF, -1, true, 0x0000FF, 
                                           rectangle.IsRoundJoint () // IsRoundCorners ()
                                           );
            blueShape.alpha = 0.5;
            
            var contianer:Sprite = new Sprite ();
            contianer.addChild (rectSprite);
            contianer.addChild (blueShape);
            
            return contianer;
         }
         else
         {
            return rectSprite;
         }
      }

      public function CreateSprite (isSelected:Boolean = false, inPreview:Boolean = false):DisplayObject
      {
         return CreateRectangleSprite (this, isSelected, GetBodyTextureModule () as AssetImageBitmapModule, GetBodyTextureTransform (), inPreview);
      }

      public static function BuildRectangleSelectionProxy (rectangle:VectorShapeRectangle, selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         var borderThickness:Number = rectangle.GetBorderThickness ();
         if ( ! rectangle.IsDrawBorder () )
            borderThickness = 0;

         selectionProxy.AddRectangleShapeHalfWH (rectangle.GetHalfWidth () + borderThickness * 0.5 , rectangle.GetHalfHeight () + borderThickness * 0.5, transform);
      }

      public function BuildSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         BuildRectangleSelectionProxy (this, selectionProxy, transform, visualScale);
      }

      public static function CreateRectangleControlPointsForAsset (rectangle:VectorShapeRectangle, asset:Asset):Array
      {
         var controlPoints:Array = new Array (4);

         for (var i:int = 0; i < 4; ++ i)
         {
            var cp:ControlPoint = new ControlPoint (asset, i);
            cp.SetPosition ((i == 0 || i == 3) ? - rectangle.GetHalfWidth () : rectangle.GetHalfWidth (), (i == 0 || i == 1) ? - rectangle.GetHalfHeight () : rectangle.GetHalfHeight ());
            cp.Refresh ();

            controlPoints [i] = cp;
         }

         return controlPoints;
      }

      public function CreateControlPointsForAsset (asset:Asset):Array
      {
         return CreateRectangleControlPointsForAsset (this, asset)
      }

      public function GetSecondarySelectedControlPointId (primaryControlPointIndex:int):int
      {
         return -1;
      }

      public static function OnMoveRectangleControlPoint (rectangle:VectorShapeRectangle, controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):ControlPointModifyResult
      {
         if (controlPoints == null || controlPoints.length != 4)
            return null;

         if (movedControlPointIndex < 0 || movedControlPointIndex >= 4)
            return null;

         var halfDw:Number = 0.5 * ((movedControlPointIndex == 0 || movedControlPointIndex == 3) ? - dx : dx);
         var halfDh:Number = 0.5 * ((movedControlPointIndex == 0 || movedControlPointIndex == 1) ? - dy : dy);

         if (halfDw < - rectangle.GetHalfWidth ())
            halfDw = - rectangle.GetHalfWidth ();
         if (halfDh < - rectangle.GetHalfHeight ())
            halfDh = - rectangle.GetHalfHeight ();

         rectangle.SetHalfWidth  (rectangle.GetHalfWidth ()  + halfDw);
         rectangle.SetHalfHeight (rectangle.GetHalfHeight () + halfDh);

         var assetLocalDisplaymentX:Number = (movedControlPointIndex == 0 || movedControlPointIndex == 3) ? - halfDw : halfDw;
         var assetLocalDisplaymentY:Number = (movedControlPointIndex == 0 || movedControlPointIndex == 1) ? - halfDh : halfDh;

         for (var i:int = 0; i < 4; ++ i)
         {
            var cp:ControlPoint = controlPoints [i] as ControlPoint;
            cp.SetPosition ((i == 0 || i == 3) ? - rectangle.GetHalfWidth () : rectangle.GetHalfWidth (), (i == 0 || i == 1) ? - rectangle.GetHalfHeight () : rectangle.GetHalfHeight ());
         }

         return new ControlPointModifyResult (false, assetLocalDisplaymentX, assetLocalDisplaymentY, movedControlPointIndex);
      }

      public function OnMoveControlPoint (controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):ControlPointModifyResult
      {
         return OnMoveRectangleControlPoint (this, controlPoints, movedControlPointIndex, dx, dy);
      }

      public function DeleteControlPoint (controlPoints:Array, toDeleteControlPointIndex:int):ControlPointModifyResult
      {
         return null;
      }

      public function InsertControlPointBefore (controlPoints:Array, insertBeforeControlPointIndex:int):ControlPointModifyResult
      {
         return null;
      }
      
   }
}
