
package editor.trigger.entity {
   
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
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.trigger.FunctionDefinition;
   import editor.trigger.CodeSnippet;
   
   
   
   import common.Define;
   
   public class EntityIconInsider extends EntityLogic 
   {
      //
      protected var mBackgroundColor:uint = 0xFFFFFF;
      protected var mHalfWidth:Number;
      protected var mHalfHeight:Number;
      
      //protected var mTextFieldCenterX:Number;
      //protected var mTextFieldCenterY:Number;
      //protected var mTextFieldHalfWidth:Number;
      //protected var mTextFieldHalfHeight:Number;
      
      protected var mIconBitmap:Bitmap = null;
      protected var mIconCenterX:Number;
      protected var mIconCenterY:Number;
      protected var mIconHalfWidth:Number;
      protected var mIconHalfHeight:Number;
      
      //
      protected var mBorderThickness:Number = 1;
      
      public function EntityIconInsider (world:World)
      {
         super (world);
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         // text
         
         //var text:String = GetTypeName ();
         //if (mCodeSnippet.GetName () != null && mCodeSnippet.GetName ().length > 0)
         //   text = text + ": " + mCodeSnippet.GetName ();
         
         //var text_field:TextFieldEx;
         //text_field = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + text + "</font>", false, 0xFFFFFF, 0x0);
         
         //var tw:int = text_field.width;
         //var th:int = text_field.height;
         
         var iw:int = mIconBitmap == null ? 0 : mIconBitmap.width;
         var ih:int = mIconBitmap == null ? 0 : mIconBitmap.height;
         
         mHalfWidth  = (iw + 20) * 0.5;
         mHalfHeight = (ih) * 0.5;
         
         //mTextFieldHalfWidth = tw * 0.5;
         //mTextFieldHalfHeight = th * 0.5;
         
         mIconHalfWidth = iw * 0.5;
         mIconHalfHeight = ih * 0.5;
         
         // background
         
         var borderColor:int = 0x0;
         mBorderThickness = 1;
         if ( IsSelected () )
         {
            borderColor = Define.BorderColorSelectedObject;
            if (mBorderThickness * mWorld.GetZoomScale () < 3)
               mBorderThickness  = 3.0 / mWorld.GetZoomScale ();
         }
         
         var background:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawRect (background, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, -1, true, mBackgroundColor);
         //var background2:Shape = new Shape ();
         //GraphicsUtil.ClearAndDrawRect (background2,  mHalfWidth, - th * 0.5, tw, th, 0x0, 1, true, 0xFFFFFF);
         var border:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawRect (border, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, mBorderThickness, false);
         
      // children
         
         background.alpha = 0.90;
         //background2.alpha = 1.0;
         //text_field.alpha = 1.0;
         
         addChild (background);
         addChild (mIconBitmap);
         mIconBitmap.x = - mIconHalfWidth;
         mIconBitmap.y = - mIconHalfHeight;
         
         //text_field.x = mHalfWidth;
         //text_field.y = - mTextFieldHalfHeight;
         
         //addChild (background2);
         //addChild (text_field); 
         addChild (border); 
         
         //mTextFieldCenterX = text_field.x + mTextFieldHalfWidth;
         //mTextFieldCenterY = text_field.y + mTextFieldHalfHeight;
         
         mIconCenterX = mIconBitmap.x + mIconHalfWidth;
         mIconCenterY = mIconBitmap.y + mIconHalfHeight;
         
         GraphicsUtil.DrawRect (border, mIconBitmap.x, mIconBitmap.y, mIconHalfWidth + mIconHalfWidth, mIconHalfHeight + mIconHalfHeight, 0x0, 1, false);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
            
            SetInternalComponentsVisible (AreInternalComponentsVisible ());
         }
         
         var borderThickness:Number = mBorderThickness;
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (GetPositionX (), GetPositionY (), mHalfWidth + borderThickness * 0.5 , mHalfHeight + borderThickness * 0.5, GetRotation ());
      }
      
//====================================================================
//   linkable
//====================================================================
      
      public function ValidateEntityLinks ():void
      {
      }
      
      override public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         //if (localX > mTextFieldCenterX - mTextFieldHalfWidth && localX < mTextFieldCenterX + mTextFieldHalfWidth && localY > mTextFieldCenterY - mTextFieldHalfHeight && localY < mTextFieldCenterY + mTextFieldHalfHeight)
         //   return -1;
         if (localX > mIconCenterX - mIconHalfWidth && localX < mIconCenterX + mIconHalfWidth && localY > mIconCenterY - mIconHalfHeight && localY < mIconCenterY + mIconHalfHeight)
         {
            return -1;
         }
         
         return 0;
      }
      
      override public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mWorld, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      override public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         return false;
      }
      
   }
}
