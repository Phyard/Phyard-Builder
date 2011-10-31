package common.shape
{
   public class VectorShapeArea extends VectorShape
   {
      public function VectorShapeArea ()
      {
         SetBuildBorder (true);
         SetDrawBorder (true);
      }

      public function IsBuildBorder ():Boolean
      {
         return (mAttributeBits & Flag_BuildBorder) != 0;
      }

      public function SetBuildBorder (buildBorder:Boolean):void
      {
         if (buildBorder)
            mAttributeBits |= Flag_BuildBorder;
         else
            mAttributeBits &= ~Flag_BuildBorder;
      }
      
      // border thickness

      public function IsDrawBorder ():Boolean
      {
         return (mAttributeBits & Flag_DrawBorder) != 0;
      }

      public function SetDrawBorder (showBorder:Boolean):void
      {
         if (showBorder)
            mAttributeBits |= Flag_DrawBorder;
         else
            mAttributeBits &= ~Flag_DrawBorder;
      }
      
      protected var mBorderThickness:Number = 1.0;

      public function GetBorderThickness ():Number
      {
         return mBorderThickness;
      }

      public function SetBorderThickness (thickness:Number):void
      {
         mBorderThickness = thickness;
      }
            
      // border color and opacity

      protected var mBorderOpacityAndColor:uint = 0xFF000000;
         public static const Mask_BorderColor:uint = 0x00FFFFFF;
         public static const Shift_BorderColor:int = 0;
         public static const Mask_BorderOpacity:uint = 0xFF000000;
         public static const Shift_BorderOpacity:int = 24;
      
      public function GetBorderOpacityAndColor ():uint
      {
         return mBorderOpacityAndColor;
      }

      public function SetBorderOpacityAndColor (borderOpacityAndColor:uint):void
      {
         mBorderOpacityAndColor = borderOpacityAndColor;
      }

      public function GetBorderColor ():uint
      {
         return (mBorderOpacityAndColor & Mask_BorderColor) >>> Shift_BorderColor;
      }

      public function SetBorderColor (color:uint):void
      {
         mBorderOpacityAndColor = (mBorderOpacityAndColor & (~Mask_BorderColor)) | ((color << Shift_BorderColor) & Mask_BorderColor);
      }
   }
}
