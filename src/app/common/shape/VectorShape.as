package common.shape
{
   import common.Define;

   public class VectorShape
   {
      public function VectorShape ()
      {
         SetBuildBackground (true);
         SetDrawBackground (true);
      }

      protected var mIsValid:Boolean = true;
      public function IsValid ():Boolean
      {
         return mIsValid;
      }

      public function SetValid (valid:Boolean):void
      {
         mIsValid = valid;
      }

      // attibute bits

      protected var mAttributeBits:int = 0;
         // common
         //public static const Flag_BuildPhysics     :int = 1 << 0; //reserved
         public static const Flag_BuildBackground  :int = 1 << 1;
         public static const Flag_DrawBackground   :int = 1 << 2;
            // path shapes
            public static const Flag_Closed           :int = 1 << 3;
            public static const Flag_RoundEnds        :int = 1 << 4; // will not support other svg end types
            // area shapes
            public static const Flag_BuildBorder      :int = 1 << 5;
            public static const Flag_DrawBorder       :int = 1 << 6;
               // rect
               public static const Flag_RoundCorners   :int = 1 << 7;

      public function GetAttributeBits ():uint
      {
         return mAttributeBits;
      }

      public function SetAttributeBits (attributeBits:uint):void
      {
         mAttributeBits = attributeBits;
      }

      // appearance type

      public var mAppearanceType:int = 0;

      public function GetAppearanceType ():int
      {
         return mAppearanceType;
      }

      public function SetAppearanceType (type:int):void
      {
         mAppearanceType = type;
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

      // body color and opacity

      protected var mBodyOpacityAndColor:uint = 0xFFFFFFFF;
         public static const Mask_BodyColor:uint = 0x00FFFFFF;
         public static const Shift_BodyColor:int = 0;
         public static const Mask_BodyOpacity:uint = 0xFF000000;
         public static const Shift_BodyOpacity:int = 24;

      public function GetBodyOpacityAndColor ():uint
      {
         return mBodyOpacityAndColor;
      }

      public function SetBodyOpacityAndColor (bodyOpacityAndColor:uint):void
      {
         mBodyOpacityAndColor = bodyOpacityAndColor;
      }

      public function GetBodyColor ():uint
      {
         return (mBodyOpacityAndColor & Mask_BodyColor) >>> Shift_BodyColor;
      }

      public function SetBodyColor (color:uint):void
      {
         mBodyOpacityAndColor = (mBodyOpacityAndColor & (~Mask_BodyColor)) | ((color << Shift_BodyColor) & Mask_BodyColor);
      }

      public function GetBodyAlpha ():int
      {
         return Number (GetBodyOpacity ()) / 255.0;
      }

      public function GetBodyOpacity ():int
      {
         return (mBodyOpacityAndColor & Mask_BodyOpacity) >>> Shift_BodyOpacity;
      }

      public function SetBodyOpacity (opacity:int):void
      {
         if (opacity < 0)
            opacity = 0;
         if (opacity > 255)
            opacity = 255;

         mBodyOpacityAndColor = (mBodyOpacityAndColor & (~Mask_BodyOpacity)) | ((opacity << Shift_BodyOpacity) & Mask_BodyOpacity);
      }
   }
}
