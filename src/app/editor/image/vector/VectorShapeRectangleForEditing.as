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
      
      public function CreateControlPointsForAsset (asset:Asset):Array
      {
         var controlPoints:Array = new Array (4);
         
         for (var i:int = 0; i < 4; ++ i)
         {
            var cp:ControlPoint = new ControlPoint (asset, i);
            cp.SetPosition ((i == 0 || i == 3) ? - mHalfWidth : mHalfWidth, (i == 0 || i == 1) ? - mHalfHeight : mHalfHeight);
            cp.RebuildAppearance ();
            cp.RebuildSelectionProxy ();
            
            controlPoints [i] = cp;
         }
         
         return controlPoints;
      }
      
      public function GetSecondarySelectedControlPointId (primaryControlPoint:ControlPoint):int
      {
         return -1;
      }
      
      public function OnMoveControlPoint (controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):Array
      {
         if (controlPoints == null || controlPoints.length != 4)
            return null;
         
         if (movedControlPointIndex < 0 || movedControlPointIndex >= 4)
            return null;
         
         var halfDw:Number = 0.5 * ((movedControlPointIndex == 0 || movedControlPointIndex == 3) ? - dx : dx);
         var halfDh:Number = 0.5 * ((movedControlPointIndex == 0 || movedControlPointIndex == 1) ? - dy : dy);
         
         if (halfDw < - mHalfWidth)
            halfDw = - mHalfWidth;
         if (halfDh < - mHalfHeight)
            halfDh = - mHalfHeight;
         
         mHalfWidth  += halfDw;
         mHalfHeight += halfDh;
         
         var assetLocalDisplaymentX:Number = (movedControlPointIndex == 0 || movedControlPointIndex == 3) ? - halfDw : halfDw;
         var assetLocalDisplaymentY:Number = (movedControlPointIndex == 0 || movedControlPointIndex == 1) ? - halfDh : halfDh;

         for (var i:int = 0; i < 4; ++ i)
         {
            var cp:ControlPoint = controlPoints [i] as ControlPoint;
            cp.SetPosition ((i == 0 || i == 3) ? - mHalfWidth : mHalfWidth, (i == 0 || i == 1) ? - mHalfHeight : mHalfHeight);
         }
         
         return new Array (assetLocalDisplaymentX, assetLocalDisplaymentY, movedControlPointIndex);
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
