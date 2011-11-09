package player.image
{
   import flash.display.BitmapData;
   
   import flash.geom.Rectangle;
   import flash.geom.Point;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;
   
   import player.module.Module;

   public class ImageBitmapDivision extends ImageBitmap
   {
      protected var mSourceImage:ImageBitmap;
      protected var mLeft:int;
      protected var mTop:int;
      protected var mRight:int;
      protected var mBottom:int;
      
      public function ImageBitmapDivision (imageBitmap:ImageBitmap, left:int, top:int, right:int, bottom:int)
      {
         mSourceImage = imageBitmap;
         mLeft   = left;
         mTop    = top;
         mRight  = right;
         mBottom = bottom;
      }
      
      public function GetSourceImage ():ImageBitmap
      {
         return mSourceImage;
      }
      
      public function OnSourceImageRebuilt ():void
      {
         mBitmapData = null;
         
         var sourceBitmapData:BitmapData = mSourceImage.GetBitmapData ();
         if (sourceBitmapData == null)
         {
            mStatus = -1;
         }
         else
         {
            var left:int = mLeft < 0 ? 0 : mLeft;
            var top :int = mTop  < 0 ? 0 : mTop;
            if (left < sourceBitmapData.width || top < sourceBitmapData.height)
            {
               var right :int = mRight  <= sourceBitmapData.width  ? mRight  : sourceBitmapData.width;
               var bottom:int = mBottom <= sourceBitmapData.height ? mBottom : sourceBitmapData.height;
               
               var w:int = right - left;
               var h:int = bottom - top;
               mBitmapData = new BitmapData (w, h, true);
               mBitmapData.copyPixels (sourceBitmapData, new Rectangle (left, top, w, h), new Point (0, 0));
            }
            
            mStatus = 1;
         }
      }
   }
}
