package editor.image.vector
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   
   import flash.geom.Point;
   
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.selection.SelectionProxy;
   
   import common.shape.VectorShapeRectangle;
   import common.shape.VectorShapeText;
   
   import editor.asset.Asset;
   import editor.asset.ControlPoint;
   import editor.asset.ControlPointModifyResult;
   
   import common.Transform2D;
   
   public class VectorShapeTextForEditing extends VectorShapeText implements VectorShapeForEditing
   {
      public function OnCreating (points:Array):Point
      {
         return VectorShapeRectangleForEditing.OnCreatingRectangle (this, points);
      }
      
      public function CreateSprite ():DisplayObject
      {
         var container:Sprite = new Sprite ();
         
         var background:DisplayObject = VectorShapeRectangleForEditing.CreateRectangleSprite (this);
         container.addChild (background);
         
         
         var displayText:String = TextUtil.GetHtmlWikiText (GetText (), TextUtil.GetTextAlignText (mTextAlign), mFontSize, TextUtil.Uint2ColorString (mTextColor), null, mIsBold, mIsItalic, mIsUnderlined);
         
         var textField:TextFieldEx;
         
         if (mWordWrap && (! mAdaptiveBackgroundSize))
            textField = TextFieldEx.CreateTextField (displayText, false, 0xFFFFFF, mTextColor, true, mHalfWidth * 2 - 10 - mBorderThickness);
         else
            textField = TextFieldEx.CreateTextField (displayText, false, 0xFFFFFF, mTextColor);
            
         //if (GetRotation () == 0)
         //   mTextSprite = textField;
         //else
         //{
         //   var textBitmap:Bitmap = DisplayObjectUtil.CreateCacheDisplayObject (textField);
         //   mTextSprite = textBitmap;
         //}
         //
         //mTextSprite.x = - mTextSprite.width * 0.5;
         //mTextSprite.y = - mTextSprite.height * 0.5;
         
         var textBitmap:Bitmap = DisplayObjectUtil.CreateCacheDisplayObject (textField);
         textBitmap.x = - textBitmap.width  * 0.5;
         textBitmap.y = - textBitmap.height * 0.5;
         container.addChild (textBitmap);
         
         return container;
      }
      
      public function BuildSelectionProxy (selectionProxy:SelectionProxy, transform:Transform2D, visualScale:Number = 1.0):void
      {
         VectorShapeRectangleForEditing.BuildRectangleSelectionProxy (this, selectionProxy, transform, visualScale);
      }
      
      public function CreateControlPointsForAsset (asset:Asset):Array
      {
         if (IsAdaptiveBackgroundSize ())
            return null;
         
         return VectorShapeRectangleForEditing.CreateRectangleControlPointsForAsset (this, asset);
      }
      
      public function GetSecondarySelectedControlPointId (primaryControlPointIndex:int):int
      {
         return -1;
      }
      
      public function OnMoveControlPoint (controlPoints:Array, movedControlPointIndex:int, dx:Number, dy:Number):ControlPointModifyResult
      {
         return VectorShapeRectangleForEditing.OnMoveRectangleControlPoint (this, controlPoints, movedControlPointIndex, dx, dy);
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
