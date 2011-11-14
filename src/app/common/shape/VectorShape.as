package common.shape
{
   import common.Define;

   public class VectorShape
   {
      public function VectorShape ()
      {
         SetBuildBackground (true);
         SetDrawBackground (true);
         SetJointType (JointType_Round); // rect to override
         SetEndType (EndType_None); // polyline can modify it
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

      // attibute bits (DON"T change this values)

      protected var mAttributeBits:int = 0;
         // common
         public static const Flag_BuildBackground  :int = 1 << 1;
         public static const Flag_DrawBackground   :int = 1 << 2;
            // for area shapes
            public static const Flag_BuildBorder      :int = 1 << 3;
            public static const Flag_DrawBorder       :int = 1 << 4;
         // joint type (0 - round, 1 - 尖的, 2 - 钝的), useless for circle
         public static const Mask_JointType   :int = (1 << 5) | (1 << 6) | (1 << 7); // 7th bit is reserved
         public static const Shift_JointType  :int = 5;
            // path shapes
            public static const Flag_Closed      :int = 1 << 8;
            public static const Mask_EndType   :int = (1 << 9) | (1 << 10) | (1 << 11); // 10th and 11 bit are reserved
            public static const Shift_EndType  :int = 9;

      public static const JointType_Moter:int = 0; // 尖的
      public static const JointType_Round:int = 1; 
      public static const JointType_Bevel:int = 2; // 钝的, now supported now

      public static const EndType_None:int = 0; 
      public static const EndType_Round:int = 1;
      public static const EndType_Square:int = 2; // not supported now

      public function GetAttributeBits ():uint
      {
         return mAttributeBits;
      }

      public function SetAttributeBits (attributeBits:uint):void
      {
         mAttributeBits = attributeBits;
      }

      // joint type

      public function GetJointType ():int
      {
         return (mAttributeBits & Mask_JointType) >>> Shift_JointType;
      }

      public function SetJointType (type:int):void
      {
         mAttributeBits = (mAttributeBits & (~Mask_JointType)) | ((type << Shift_JointType) & Mask_JointType);
      }

      // end type

      public function GetEndType ():int
      {
         return (mAttributeBits & Mask_EndType) >>> Shift_EndType;
      }

      public function SetEndType (type:int):void
      {
         mAttributeBits = (mAttributeBits & (~Mask_EndType)) | ((type << Shift_EndType) & Mask_EndType);
      }
      
      // background (body)

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
