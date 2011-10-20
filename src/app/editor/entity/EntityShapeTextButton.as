
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
   
   public class EntityShapeTextButton extends EntityShapeText 
   {
      private var mUsingHandCursor:Boolean = true;
      
      private var mMouseOverShape:EntityShape; // not a real entity in world, just use it to store some values.
      
      public function EntityShapeTextButton (world:World)
      {
         super (world);
         
         SetText ("Button");
         SetWordWrap (false);
         SetFontSize (12);
         SetTextColor (Define.ColorTextButtonText);
         SetAdaptiveBackgroundSize (true);
         SetTextAlign (TextUtil.TextAlign_Center);
         
         SetDrawBorder (true);
         SetDrawBackground (true);
         SetFilledColor (Define.ColorTextButtonBackground);
         SetBorderColor (Define.ColorTextButtonBorder);
         SetBorderThickness (2);
         
         mMouseOverShape = new EntityShape (null);
         
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
      
      override protected function AdjustBackgroundSize ():void
      {
         if (IsAdaptiveBackgroundSize ())
         {
            SetHalfWidth  (0.5 * mTextSprite.width + 15);
            SetHalfHeight (0.5 * mTextSprite.height + 3);
         }
      }
      
      public function UsingHandCursor ():Boolean
      {
         return mUsingHandCursor;
      }
      
      public function SetUsingHandCursor (usingHandCursor:Boolean):void
      {
         mUsingHandCursor = usingHandCursor;
      }
      
      public function GetMouseOverShape ():EntityShape
      {
         return mMouseOverShape;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityShapeTextButton (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var text_button:EntityShapeTextButton = entity as EntityShapeTextButton;
         
         var anotherMouseOverShape:EntityShape = text_button.GetMouseOverShape ();
         
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
