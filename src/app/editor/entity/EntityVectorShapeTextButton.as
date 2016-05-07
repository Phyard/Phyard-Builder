
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
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.image.vector.*;
   import common.shape.*;
   
   import common.Define;
   
   public class EntityVectorShapeTextButton extends EntityVectorShapeText 
   {
      private var mUsingHandCursor:Boolean = true;
      
      private var mMouseOverShape:EntityVectorShape; // not a real entity in world, just use it to store some values.
      
      public function EntityVectorShapeTextButton (container:Scene)
      {
         super (container);
         
         SetText ("Button");
         SetWordWrap (false);
         SetFontSize (12);
         SetTextColor (Define.ColorTextButtonText);
         SetAdaptiveBackgroundSize (true);
         SetTextAlign (TextUtil.TextAlign_Center | TextUtil.TextAlign_Middle);
         
         SetDrawBorder (true);
         SetDrawBackground (true);
         SetFilledColor (Define.ColorTextButtonBackground);
         SetBorderColor (Define.ColorTextButtonBorder);
         SetBorderThickness (2);
         
         mMouseOverShape = new EntityVectorShapeArea (null, new VectorShapeRectangleForEditing ());
         
         mMouseOverShape.SetDrawBorder (true);
         mMouseOverShape.SetDrawBackground (true);
         mMouseOverShape.SetFilledColor (Define.ColorTextButtonBackground_MouseOver);
         mMouseOverShape.SetBorderColor (Define.ColorTextButtonBorder);
         mMouseOverShape.SetBorderThickness (2);
      }
      
      override public function GetTypeName ():String
      {
         return "Text Button";
      }
      
      // why? same as super
      //override protected function AdjustBackgroundSize ():void
      //{
      //   if (IsAdaptiveBackgroundSize ())
      //   {
      //      if (! IsWordWrap ())
      //         SetHalfWidth  (0.5 * mTextSprite.width + 5);
      //      
      //      SetHalfHeight (0.5 * mTextSprite.height + 3);
      //   }
      //}
      
      public function UsingHandCursor ():Boolean
      {
         return mUsingHandCursor;
      }
      
      public function SetUsingHandCursor (usingHandCursor:Boolean):void
      {
         mUsingHandCursor = usingHandCursor;
      }
      
      public function GetMouseOverShape ():EntityVectorShape
      {
         return mMouseOverShape;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityVectorShapeTextButton (mEntityContainer);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var text_button:EntityVectorShapeTextButton = entity as EntityVectorShapeTextButton;
         
         var anotherMouseOverShape:EntityVectorShape = text_button.GetMouseOverShape ();
         
         anotherMouseOverShape.SetDrawBackground (mMouseOverShape.IsDrawBackground ());
         anotherMouseOverShape.SetFilledColor (mMouseOverShape.GetFilledColor ());
         anotherMouseOverShape.SetTransparency (mMouseOverShape.GetTransparency ());
         anotherMouseOverShape.SetDrawBorder (mMouseOverShape.IsDrawBorder ());
         anotherMouseOverShape.SetBorderColor (mMouseOverShape.GetBorderColor ());
         anotherMouseOverShape.SetBorderTransparency (mMouseOverShape.GetBorderTransparency ());
         anotherMouseOverShape.SetBorderThickness (mMouseOverShape.GetBorderThickness ());
      }
      
   }
}
