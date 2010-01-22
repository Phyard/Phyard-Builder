
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
   
   public class EntityCodeSnippetHolder extends EntityLogic 
   {
      protected var mCodeSnippet:CodeSnippet;
      
      //
      protected var mHalfWidth:Number;
      protected var mHalfHeight:Number;
      
      protected var mTextFieldCenterX:Number;
      protected var mTextFieldCenterY:Number;
      protected var mTextFieldHalfWidth:Number;
      protected var mTextFieldHalfHeight:Number;
      
      protected var mEventIconBitmap:Bitmap = null;
      protected var mIconCenterX:Number;
      protected var mIconCenterY:Number;
      protected var mIconHalfWidth:Number;
      protected var mIconHalfHeight:Number;
      
      //
      protected var mBorderThickness:Number = 1;
      
      public function EntityCodeSnippetHolder (world:World)
      {
         super (world);
         
         // child class must create a valid CodeSnippet
         //mCodeSnippet = new CodeSnippet (new FunctionDefinition ());
      }
      
      public function GetCodeSnippetName ():String
      {
         return mCodeSnippet.GetName ();
      }
      
      public function SetCodeSnippetName (name:String):void
      {
         mCodeSnippet.SetName (name);
      }
      
      public function GetCodeSnippet ():CodeSnippet
      {
         return mCodeSnippet;
      }
      
      public function ValidateEntityLinks ():void
      {
         mCodeSnippet.ValidateValueSources ();
      }
      
      override public function UpdateAppearance ():void
      {
         // to be overrided
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
