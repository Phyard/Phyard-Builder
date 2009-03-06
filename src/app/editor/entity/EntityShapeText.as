
package editor.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityShapeText extends EntityShapeRectangle 
   {
      private var mText:String;
      private var mAutofitWidth:Boolean = true;
      
      private var mElementsContainer:Sprite;
      
      public function EntityShapeText (world:World)
      {
         super (world);
         
         SetText ("(not set yet)");
         SetDrawBorder (false);
         SetDrawBackground (false);
         
         mElementsContainer = new Sprite ();
         addChild (mElementsContainer);
      }
      
      override public function IsBasicShapeEntity ():Boolean
      {
         return false;
      }
      
      override public function GetTypeName ():String
      {
         return "Text";
      }
      
      override public function UpdateAppearance ():void
      {
         if (mElementsContainer == null)
            return;
         
         while (mElementsContainer.numChildren > 0)
            mElementsContainer.removeChildAt (0);
         
      // background
         
         var borderColor:uint;
         var borderSize :int;
         
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            borderSize  = 3;
            
            borderSize /= mWorld.GetZoomScale ();
         }
         else
         {
            //borderColor = IsDrawBorder () ? mBorderColor : mFilledColor;
            //borderSize  = IsDrawBorder () ? 1 : 0;
            borderColor = mBorderColor;
            borderSize  = 1;
         }
         
         var background:Shape = new Shape ();
         background.alpha = 0.5;
         mElementsContainer.addChild (background);
         
         //if (IsDrawBackground ())
            GraphicsUtil.ClearAndDrawRect (background, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderSize, true, mFilledColor);
         //else
         //   GraphicsUtil.ClearAndDrawRect (background, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderSize, false, mFilledColor);
         
         
         
      // text
         var infoText:String = mText;
         
         if (infoText == null)
            return;
         
         infoText = TextUtil.GetHtmlEscapedText (infoText);
         infoText = TextUtil.ParseWikiString (infoText);
         
         //trace ("infoText = " + infoText);
         
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
         
         mElementsContainer.addChild (textDisplayObject);
         
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
         
         if (text.length > Define.MaxTextLength)
            text = text.substr (0, Define.MaxTextLength);
         
         mText = text;
         
         UpdateAppearance ();
      }
      
      public function IsAutofitWidth ():Boolean
      {
         return mAutofitWidth;
      }
      
      public function SetAutofitWidth (auto:Boolean):void
      {
         mAutofitWidth = auto;
         
         UpdateAppearance ();
      }
      
      override public function SetHalfWidth (halfWidth:Number, validate:Boolean = true):void
      {
         super.SetHalfWidth (halfWidth, validate);
         
         UpdateAppearance ();
      }
      
      override public function SetRotation (rot:Number):void
      {
         var oldValue:Number  = GetRotation ();
         
         super.SetRotation (rot);
         
         if (oldValue == 0 || GetRotation () == 0)
            UpdateAppearance ();
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityShapeText (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var text:EntityShapeText = entity as EntityShapeText;
         text.SetText ( GetText () );
      }
      
   }
}
