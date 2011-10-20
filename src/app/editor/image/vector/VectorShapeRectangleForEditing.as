package editor.image.vector
{
   import flash.display.DisplayObject; 
   import flash.display.Shape;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.selection.SelectionProxy;
   
   import common.Transform2D;
   
   public class VectorShapeRectangleForEditing extends VectorShapeRectangle implements VectorShapeForEditing
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
         var posX:Number = 0.5 * (point2.x + point1.x);
         var posY:Number = 0.5 * (point2.y + point1.y);
         var halfWidth:Number  = 0.5 * Math.abs (point2.x - point1.x);
         var halfHeight:Number = 0.5 * Math.abs (point2.y - point1.y);
         
         SetHalfWidth (halfWidth);
         SetHalfHeight (halfHeight);
         
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
         
         if ( ! drawBorder)
         {
            drawBg = true;
            borderThickness = -1;
         }
         
         var visualHalfWidth:Number = mHalfWidth + 0.5; // be consistent with player
         var visualHalfHeight:Number = mHalfHeight + 0.5; // be consistent with player
         
         var rectSprite:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawRect (rectSprite, - visualHalfWidth, - visualHalfHeight, visualHalfWidth + visualHalfWidth, visualHalfHeight + visualHalfHeight, borderColor, borderThickness, drawBg, filledColor, IsRoundCorners ());
         
         return rectSprite;
      }
      
      public function BuildSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         var borderThickness:Number = GetBorderThickness ();
         if ( ! IsDrawBorder () )
            borderThickness = 0;
         
         selectionProxy.AddRectangleShapeHalfWH (GetHalfWidth () + borderThickness * 0.5 , GetHalfHeight () + borderThickness * 0.5, transform);
      }
   }
}
