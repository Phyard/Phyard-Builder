
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
      
      private var mTextDisplayObject:DisplayObject = null;
      private var mBackground:Shape = null;
      
      public function EntityShapeText (world:World, shapeContainer:ShapeContainer)
      {
         super (world, shapeContainer);
      }
      
      override public function BuildFromParams (params:Object):void
      {
         super.BuildFromParams (params);
         
         SetText (params.mText);
         mAutofitWidth = params.mAutofitWidth;
         
         RebuildAppearance ();
      }
      
      override public function RebuildAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
      // background
         
         var filledColor:uint = Define.GetShapeFilledColor (mAiType);
         var borderColor:uint = IsDrawBorder () ? Define.ColorObjectBorder : filledColor;
         var borderSize :int  = IsDrawBorder () ? 1 : 0;
         
         var background:Shape = new Shape ();
         background.alpha = 0.5;
         addChild (background);
         
         if (IsDrawBackground ())
            GraphicsUtil.ClearAndDrawRect (background, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderSize, true, filledColor);
         else if (IsDrawBorder ())
            GraphicsUtil.ClearAndDrawRect (background, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderSize, false, filledColor);
         else
            GraphicsUtil.Clear (background);
         
      // text
         
         var infoText:String = mText;
         
         if (infoText == null)
            return;
         
         infoText = TextUtil.GetHtmlEscapedText (infoText);
         infoText = TextUtil.ParseWikiString (infoText);
         
         trace ("infoText = " + infoText);
         
         var textDisplayObject:DisplayObject;
         
         var textField:TextFieldEx;
         
         if (mAutofitWidth)
            textField = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + infoText + "</font>", false, 0xFFFFFF, 0x0, true, mHalfWidth * 2 - 10);
         else
            textField = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + infoText + "</font>", false, 0xFFFFFF, 0x0);//, true, mHalfWidth * 2 - 10);
         
         if (GetRotation () == 0)
            textDisplayObject = textField;
         else
         {
            var textBitmap:Bitmap = DisplayObjectUtil.CreateCacheDisplayObject (textField);
            textDisplayObject = textBitmap;
         }
         
         addChild (textDisplayObject);
         
         textDisplayObject.x = - textDisplayObject.width * 0.5;
         textDisplayObject.y = - textDisplayObject.height * 0.5;
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
         
         RebuildAppearance ();
      }
      
   }
   
}
