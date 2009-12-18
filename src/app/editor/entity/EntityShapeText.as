
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
   
   
   
   import common.Define;
   
   public class EntityShapeText extends EntityShapeRectangle 
   {
      private var mText:String;
      private var mAutofitWidth:Boolean = true;
      
      private var mTextColor:uint = 0x000000;
      
      public function EntityShapeText (world:World)
      {
         super (world);
         
         SetText ("(not set yet)");
         SetDrawBorder (false);
         SetDrawBackground (false);
      }
      
      override public function IsBasicShapeEntity ():Boolean
      {
         return false;
      }
      
      override public function GetTypeName ():String
      {
         return "Text";
      }
      
      override public function GetPhysicsShapesCount ():uint
      {
         return 0;
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
      // background
         
         super.UpdateAppearance ();
         
         
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
            textField = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + infoText + "</font>", false, 0xFFFFFF, mTextColor, true, mHalfWidth * 2 - 10 - mBorderThickness);
         else
            textField = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + infoText + "</font>", false, 0xFFFFFF, mTextColor);
            
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
      
      public function GetTextColor ():uint
      {
         return mTextColor;
      }
      
      public function SetTextColor (color:uint):void
      {
         mTextColor = color;
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
         text.SetAutofitWidth (IsAutofitWidth ());
      }
      
   }
}
