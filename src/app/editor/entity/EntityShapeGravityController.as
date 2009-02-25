
package editor.entity {
   
   import flash.display.Sprite;
   import flash.display.Bitmap;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class EntityShapeGravityController extends EntityShapeCircle 
   {
      private var mIsInteractive:Boolean = true;
      private var mInitialGravityAcceleration:Number = Define.DefaultGravityAcceleration;
      private var mInitialGravityAngle:int = 90; // not float, for byteArray.writeArray has precision problems
      
      
      
      private var mTextG:Bitmap = null;
      
      public function EntityShapeGravityController (world:World)
      {
         super (world);
      }
      
      override public function IsBasicShapeEntity ():Boolean
      {
         return false;
      }
      
      override public function GetTypeName ():String
      {
         return "Gravity Controller";
      }
      
      public function SetInteractive (interactive:Boolean):void
      {
         mIsInteractive = interactive;
      }
      
      public function IsInteractive ():Boolean
      {
         return mIsInteractive;
      }
      
      public function SetInitialGravityAcceleration (ga:Number):void
      {
         //mInitialGravityAcceleration = ValueAdjuster.AdjustInitialGravityAcceleration (ga);
         mInitialGravityAcceleration = ga;
      }
      
      public function GetInitialGravityAcceleration ():Number
      {
         return mInitialGravityAcceleration;
      }
      
      public function SetInitialGravityAngle (angle:Number):void
      {
         mInitialGravityAngle = angle;
      }
      
      public function GetInitialGravityAngle ():int
      {
         return mInitialGravityAngle;
      }
      
      override public function UpdateAppearance ():void
      {
      // .
         if (mTextG == null)
         {
            var textField:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='9'><i>g</i></font>", false, 0xFFFFFF, 0x0);
            
            mTextG = DisplayObjectUtil.CreateCacheDisplayObject (textField);
            
            addChild (mTextG);
            
            mTextG.x = - mTextG.width * 0.5;
            mTextG.y = - mTextG.height * 0.5 - 2;
         }
         
      // .
         var borderColor:uint;
         var borderSize :int;
         
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            borderSize  = 3;
         }
         else
         {
            //borderColor = IsDrawBorder () ? mBorderColor : mFilledColor;
            //borderSize  = IsDrawBorder () ? 1 : 0;
            
            borderColor = mBorderColor;
            borderSize = 1;
         }
         
         var bandColor:uint = IsInteractive () ? Define.ColorMovableObject : Define.ColorStaticObject;
         
         alpha = 0.7;
         
         var radius_0b:Number = Define.GravityControllerZeroRegionRadius;
         if (radius_0b > mRadius)
            radius_0b = mRadius;
         var radius_1a:Number = mRadius - Define.GravityControllerOneRegionThinkness;
         if (radius_1a < radius_0b)
            radius_1a = radius_0b;
         var radius_1b:Number = mRadius;
         if (radius_1b < radius_1a)
            radius_1b = radius_1a;
         
         GraphicsUtil.Clear (this);
         GraphicsUtil.DrawCircle (this, 0, 0, radius_1b, borderColor, borderSize, true, bandColor);
         GraphicsUtil.DrawCircle (this, 0, 0, radius_1a, mBorderColor, 1, true, mFilledColor);
         GraphicsUtil.DrawCircle (this, 0, 0, radius_0b, mBorderColor, 1, true, mFilledColor);
         
         var direction:Number = mInitialGravityAngle * Math.PI / 180.0;;
         var acceleration:Number;
         var gx0:Number;
         var gy0:Number;
         var gx1:Number;
         var gy1:Number;
         if (radius_1a > radius_0b)
         {
            gx0 = radius_0b * Math.cos (direction);
            gy0 = radius_0b * Math.sin (direction);
            acceleration = radius_0b + (radius_1a - radius_0b) * mInitialGravityAcceleration / Define.DefaultGravityAcceleration;
            gx1 = acceleration * Math.cos (direction);
            gy1 = acceleration * Math.sin (direction);
         }
         else
         {
            gx0 = 0;
            gy0 = 0;
            acceleration = mRadius * mInitialGravityAcceleration / Define.DefaultGravityAcceleration;
            gx1 = acceleration * Math.cos (direction);
            gy1 = acceleration * Math.sin (direction);
         }
         GraphicsUtil.DrawLine (this, gx0, gy0, gx1, gy1);
      }
      
//====================================================================
//   clone
//====================================================================
      
      override public function IsClonedable ():Boolean
      {
         return false;
      }
      
      // only one gc most in a scene
      override protected function CreateCloneShell ():Entity
      {
         return null;
      }
      
//====================================================================
//   
//====================================================================
      
   }
}
