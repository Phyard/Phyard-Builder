pacakge editor.image.vector
{
   import common.Define; 
   
   public class VectorShape
   {
      
      
      
      protected var mAttributeBits:int = 0; 
         public static const Flag_Flipped          :int = 1 << 0;
         public static const Flag_BuildBackground  :int = 1 << 1;
         public static const Flag_ShowBackground   :int = 1 << 2;

      protected var mBackgroundColor:uint; // To change to mBodyColor
      protected var mBackgroundOpacity:int; // 0-100. To change to float later

      // relative to parent
      protected var mOffsetX:Number;
      protected var mOffsetY:Number;
      protected var mScale:Number;
      //mFlipped // Flag_Flipped
      protected var mRotation:Number;
      
      public function GetBackgroundColor ():uint
      {
         return mBackgroundColor;
      }
      
      public function SetBackgroundColor (color:uint):void
      {
         mbodyColor = color;
      }
      
      public function GetBackgroundOpacity ():int
      {
         return mBackgroundOpacity;
      }
      
      public function SetBackgroundOpacity (opacity:int):void
      {
         if (opacity < 0)
            opacity = 0;
         if (opacity > 100)
            opacity = 100;
         
         mBackgroundOpacity = opacity;
      }
      
      public function IsBuildBackground ():Boolean
      {
         return (mAttributeBits & Flag_BuildBackground) != 0;
      }
      
      public function SetBuildBackground (buildBackground:Boolean):void
      {
         if (buildBackground)
            mAttributeBits |= Flag_BuildBackground;
         else
            mAttributeBits &= ~Flag_BuildBackground;
      }
      
      public function IsShowBackground ():Boolean
      {
         return (mAttributeBits & Flag_ShowBackground) != 0;
      }
      
      public function SetShowBackground (buildBackground:Boolean):void
      {
         if (buildBackground)
            mAttributeBits |= Flag_ShowBackground;
         else
            mAttributeBits &= ~Flag_ShowBackground;
      }
      
      public function GetOffsetX ():Number
      {
         return mOffsetX;
      }
      
      public function SetOffsetX (offsetX:Number):void
      {
         mOffsetX = offsetX;
      }
      
      public function GetOffsetY ():Number
      {
         return mOffsetY;
      }
      
      public function SetOffsetY (offsetY:Number):void
      {
         mOffsetY = offsetY;
      }
      
      public function GetScale ():Number
      {
         return mScale;
      }
      
      public function SetScale (scale:Number):void
      {
         if (scale < Define.kFloatEpsilon)
            scale = Define.kFloatEpsilon;
         
         mScale = scale;
      }
      
      public function IsFlipped ():Boolean
      {
         return (mAttributeBits & Flag_Flipped) != 0;
      }
      
      public function SetFlipped (flipped:Boolean):void
      {
         if (flipped)
            mAttributeBits |= Flag_Flipped;
         else
            mAttributeBits &= ~Flag_Flipped;
      }
      
      public function GetRotation ():Number
      {
         return mRotation;
      }
      
      public function SetRotation (rotation:Number):void
      {
         mRotation = rotation;
      }
   }
}
