package editor.image.vector
{
   import flash.display.DisplayObject; 
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.selection.SelectionProxy;
   
   import editor.asset.Asset;
   import editor.asset.ControlPoint;
   
   import common.Transform2D;
   import common.Define;
   
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
      
      public function CreateSprite ():DisplayObject
      {
         var filledColor:uint = GetBackgroundColor ();
         var borderColor:uint = GetBorderColor ();
         var drawBg:Boolean = IsDrawBackground ();
         var drawBorder:Boolean = IsDrawBorder ();
         var borderThickness:Number = GetBorderThickness ();
         var appearanceType:int = GetAppearanceType ();
         
         if ( ! drawBorder)
         {
            drawBg = true;
            borderThickness = -1;
         }
         
         var visualRadius:Number = mRadius + 0.5; // be consistent with player
         
         var circleSprite:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawCircle (circleSprite, 0, 0, visualRadius, borderColor, 
                                                            borderThickness, drawBg, filledColor);
         
         if (appearanceType == Define.CircleAppearanceType_Ball)
         {
            var pos:Number;
            pos = (mRadius * 0.66) - 1;// * 0.707 - 1;
            if (pos < 0) pos = 0;
            
            var invertFilledColor:uint = GraphicsUtil.GetInvertColor_b (filledColor);
            GraphicsUtil.DrawEllipse (circleSprite, pos, 0, 1, 1, invertFilledColor, 1, true, invertFilledColor);
         }
         else if (appearanceType == Define.CircleAppearanceType_Column)
         {
            var radius2:Number = mRadius * 0.5;
            GraphicsUtil.DrawEllipse (circleSprite, - radius2, - radius2, radius2 + radius2, radius2 + radius2, borderColor, 1, false, filledColor);
            GraphicsUtil.DrawLine (circleSprite, radius2, 0, visualRadius, 0, borderColor, 1);
         }
         
         return circleSprite;
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
      
      public function GetSecondarySelectedControlPointId (primaryControlPoint:ControlPoint):int
      {
         return -1;
      }
      
      public function OnMoveControlPoint (controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):Array
      {
         return null;
      }
      
      public function DeleteControlPoint (controlPoint:ControlPoint):int
      {
         return -1;
      }
      
      public function InsertControlPointBefore (controlPoint:ControlPoint):int
      {
         return -1;
      }
   }
}
