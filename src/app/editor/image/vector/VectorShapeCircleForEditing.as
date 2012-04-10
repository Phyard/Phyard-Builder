package editor.image.vector
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.geom.Point;

   import com.tapirgames.util.GraphicsUtil;

   import editor.selection.SelectionProxy;

   import editor.asset.Asset;
   import editor.asset.ControlPoint;
   import editor.asset.ControlPointModifyResult;
   
   import editor.image.AssetImageBitmapModule;

   import common.shape.VectorShapeCircle;

   import common.Transform2D;

   public class VectorShapeCircleForEditing extends VectorShapeCircle implements VectorShapeForEditing
   {
      public function OnCreating (points:Array):Point
      {
         if (points == null || points.length < 2)
         {
            SetValid (false);
            return null;
         }

         var point1:Point = points [0] as Point;
         var point2:Point = points [1] as Point;
         var posX:Number = point1.x;
         var posY:Number = point1.y;
         var dx:Number = point2.x - point1.x;
         var dy:Number = point2.y - point1.y;
         var radius:Number = Math.sqrt (dx * dx + dy * dy);

         SetRadius (radius);

         SetValid (true);

         return new Point (posX, posY);
      }

      public function CreateSprite (isSelected:Boolean = false):DisplayObject
      {
         var filledColor:uint = GetBodyColor ();
         var borderColor:uint = GetBorderColor ();
         var drawBg:Boolean = IsDrawBackground ();
         var drawBorder:Boolean = IsDrawBorder ();
         var borderThickness:Number = GetBorderThickness ();

         if ( ! drawBorder)
         {
            drawBg = true;
            borderThickness = -1;
         }

         var visualRadius:Number = mRadius + 0.5; // be consistent with player
         
         var bitmapModule:AssetImageBitmapModule = GetBodyTextureModule () as AssetImageBitmapModule;
         var bitmapTransform:Transform2D = GetBodyTextureTransform ();

         var circleSprite:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawCircle (circleSprite, 0, 0, visualRadius, borderColor,
                                                            borderThickness, drawBg, filledColor, 
                                                            bitmapModule == null ? null : bitmapModule.GetBitmapData (),
                                                            bitmapTransform == null ? null : bitmapTransform.ToMatrix ());

         if (isSelected)
         {
            var blueShape:Shape = new Shape ();
            GraphicsUtil.ClearAndDrawCircle (blueShape, 0, 0, visualRadius, 0x0000FF,
                                                               -1, true, 0x0000FF);
            blueShape.alpha = 0.5;
            
            var contianer:Sprite = new Sprite ();
            contianer.addChild (circleSprite);
            contianer.addChild (blueShape);
            
            return contianer;
         }
         else
         {
            return circleSprite;
         }
      }

      public function BuildSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         var borderThickness:Number = GetBorderThickness ();
         selectionProxy.AddCircleShape (GetRadius () + borderThickness * 0.5, transform);
      }

      public function CreateControlPointsForAsset (asset:Asset):Array
      {
         return null;
      }

      public function GetSecondarySelectedControlPointId (primaryControlPointIndex:int):int
      {
         return -1;
      }

      public function OnMoveControlPoint (controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):ControlPointModifyResult
      {
         return null;
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
