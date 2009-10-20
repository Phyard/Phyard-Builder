
package player.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import player.world.World;
   
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShapePolygon;
   
   import common.Define;
   
   public class EntityShapeText extends EntityShapeRectangle
   {
      private var mText:String = "";
      private var mAutofitWidth:Boolean = true;
      
      private var mBackground:Shape = null;
      private var mTextField:TextFieldEx = null;
      private var mTextBitmap:Bitmap = null;
      
      public function EntityShapeText (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
      }
      
      override protected function UpdateInternal (dt:Number):void
      {
         UpdateTextComponent ();
      }
      
      private var _usingBitmap:Boolean = false;
      private var _textChanged:Boolean = false;
      private function UpdateTextComponent ():void
      {
         var use_bitmap:Boolean = transform.concatenatedMatrix.b != 0
                               || transform.concatenatedMatrix.c != 0
                               || transform.concatenatedMatrix.a < 0
                               ;
         if ( ! _textChanged && _usingBitmap == use_bitmap )
            return;
         
         _textChanged = false;
         _usingBitmap = use_bitmap;
         
         //trace ("_usingBitmap = " + _usingBitmap);
         
         while (numChildren > 0)
            removeChildAt (0);
         
         addChild (mBackground);
         
         var textDisplayObject:DisplayObject;
         
         if (_usingBitmap)
            textDisplayObject = mTextBitmap;
         else
            textDisplayObject = mTextField;
         
         if (textDisplayObject != null)
         {
            addChild (textDisplayObject);
            
            textDisplayObject.x = - textDisplayObject.width * 0.5;
            textDisplayObject.y = - textDisplayObject.height * 0.5;
         }
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
         mAutofitWidth = params.mAutofitWidth;
         
         SetText (params.mText);
         RebuildAppearance ();
         
         if (updateAppearance)
            RebuildAppearance ();
      }
      
      override public function RebuildAppearanceInternal ():void
      {
         _textChanged = true;
         
      // background
         
         var filledColor:uint = Define.GetShapeFilledColor (mAiType);
         var borderColor:uint = IsDrawBorder () ? Define.ColorObjectBorder : filledColor;
         var borderSize :int  = IsDrawBorder () ? 1 : 0;
         
         if (mBackground == null)
         {
            mBackground = new Shape ();
            mBackground.alpha = 0.5;
         }
         
         if (IsDrawBackground ())
            GraphicsUtil.ClearAndDrawRect (mBackground, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderSize, true, filledColor);
         else if (IsDrawBorder ())
            GraphicsUtil.ClearAndDrawRect (mBackground, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderSize, false, filledColor);
         else
            GraphicsUtil.Clear (mBackground);
         
      // text
         
         var infoText:String = mText;
         
         if (infoText == null)
            return;
         
         infoText = TextUtil.GetHtmlEscapedText (infoText);
         infoText = TextUtil.ParseWikiString (infoText);
         
         //if (Compile::Is_Debugging)
         //{
         //   trace ("mAutofitWidth = " + mAutofitWidth + ", mText = " + mText + ", mText.length = " + mText.length + ",infoText = " + infoText + ", infoText.length = " + infoText.length);
         //}
         
         if (infoText == null || infoText.length == 0)
         {
            mTextBitmap = new Bitmap();
         }
         else
         {
            if (mAutofitWidth)
               mTextField = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + infoText + "</font>", false, 0xFFFFFF, 0x0, true, mHalfWidth * 2 - 10);
            else
               mTextField = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + infoText + "</font>", false, 0xFFFFFF, 0x0);//, true, mHalfWidth * 2 - 10);
            
            mTextBitmap = DisplayObjectUtil.CreateCacheDisplayObject (mTextField);
         }
         
         UpdateTextComponent ();
      }
      
      public function GetText ():String
      {
         return mText;
      }
      
      public function SetText (text:String):void
      {
         if (text == null)
            text = "";
         
         mText = text;
         
         //RebuildAppearance ();
      }
      
   }
   
}
