package editor.image.vector
{
   public class VectorShapeCircle extends VectorShapeArea
   {
      //protected var mAttributeBits:int = 0;
         public static const Shift_AppearanceType  :int = 16;
         public static const Mask_AppearanceType   :int = 0x0F0000;
            
      public var mRadius:Number;
      
      public function GetAppearanceType ():int
      {
         return (mAttributeBits & Mask_AppearanceType) >> Shift_AppearanceType;
      }
      
      public function SetAppearanceType (type:int):void
      {
         mAttributeBits = (mAttributeBits & (~Mask_AppearanceType)) | ((type << Shift_AppearanceType) & Mask_AppearanceType);
      }
      
      public function GetRadius ():Number
      {
         return mRadius;
      }
      
      public function SetRadius (radius:Number):void
      {
         mRadius = radius;
      }
   }
}
