package common.shape
{
   import common.Define;

   public class VectorShape
   {
      protected var mIsValid:Boolean = true;
      public function IsValid ():Boolean
      {
         return mIsValid;
      }

      public function SetValid (valid:Boolean):void
      {
         mIsValid = valid;
      }

      protected var mAttributeBits:int = 0;
         public static const Flag_BuildBackground  :int = 1 << 0;
         public static const Flag_DrawBackground   :int = 1 << 1;

      protected var mBackgroundColor:uint = 0xFFFFFF; // To change to mBodyColor
      protected var mBackgroundOpacity:int = 100; // 0-100. To change to float later

      public function VectorShape ()
      {
         SetBuildBackground (true);
         SetDrawBackground (true);
      }

      public function GetBackgroundColor ():uint
      {
         return mBackgroundColor;
      }

      public function SetBackgroundColor (color:uint):void
      {
         mBackgroundColor = color;
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

      public function IsDrawBackground ():Boolean
      {
         return (mAttributeBits & Flag_DrawBackground) != 0;
      }

      public function SetDrawBackground (buildBackground:Boolean):void
      {
         if (buildBackground)
            mAttributeBits |= Flag_DrawBackground;
         else
            mAttributeBits &= ~Flag_DrawBackground;
      }
   }
}
