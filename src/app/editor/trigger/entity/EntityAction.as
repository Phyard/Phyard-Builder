
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
   
   import editor.trigger.CommandListDefinition;
   import editor.trigger.CommandListWithNameDefinition;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityAction extends EntityLogic 
   {
      private var mCommandListWithNameDefinition:CommandListWithNameDefinition;
      
      //
      public var mHalfWidth:Number;
      public var mHalfHeight:Number;
      public var mTextFieldHalfWidth:Number;
      public var mTextFieldHalfHeight:Number;
      public var mBorderThickness:Number = 1;
      
      public function EntityAction (world:World)
      {
         super (world);
         
         mCommandListWithNameDefinition = new CommandListWithNameDefinition ("Action");
      }
      
      public function GetName ():String
      {
         return mCommandListWithNameDefinition.GetName ();
      }
      
      public function SetName (name:String):void
      {
         mCommandListWithNameDefinition.SetName (name);
      }
      
      public function GetActionCommandListDefinition ():CommandListDefinition
      {
         return mCommandListWithNameDefinition;
      }
      
      public function ValidateEntityLinks ():void
      {
         mCommandListWithNameDefinition.ValidateValueSources ();
      }
      
      override public function GetTypeName ():String
      {
         return "Action";
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         // text
         
         var text:String = mCommandListWithNameDefinition.GetName ();
         if (text.length == 0)
            text = "Action";
         
         var text_field:TextFieldEx;
         text_field = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + text + "</font>", false, 0xFFFFFF, 0x0);
         
         var tw:int = text_field.width;
         var th:int = text_field.height;
         
         mHalfWidth  = (tw + 20) * 0.5;
         mHalfHeight = (th + 6) * 0.5;
         
         mTextFieldHalfWidth = tw * 0.5;
         mTextFieldHalfHeight = th * 0.5;
         
         // background
         
         var borderColor:int = 0x0;
         mBorderThickness = 1;
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            if (mBorderThickness * mWorld.GetZoomScale () < 3)
               mBorderThickness  = 3.0 / mWorld.GetZoomScale ();
         }
         
         var background:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawRect (background, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, mBorderThickness, true, 0xFFC0C0);
         var background2:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawRect (background2, - tw * 0.5, - th * 0.5, tw, th, 0x0, 1, true, 0xFFFFFF);
         
      // children
         
         background.alpha = 0.90;
         background2.alpha = 1.0;
         text_field.alpha = 1.0;
         
         addChild (background);
         addChild (background2);
         addChild (text_field); 
         text_field.x = - 0.5 * text_field.width;
         text_field.y = - 0.5 * text_field.height;
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
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle ( GetRotation (), GetPositionX (), GetPositionY (), mHalfWidth + borderThickness * 0.5 , mHalfHeight + borderThickness * 0.5 );
      }
      
//====================================================================
//   linkable
//====================================================================
      
      override public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         if (localX > mTextFieldHalfWidth || localX < -mTextFieldHalfWidth || localY > mTextFieldHalfHeight || localY < -mTextFieldHalfHeight)
            return 0;
         
         return -1;
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
