
package editor.display.sprite {
   
   import flash.display.Sprite;
   import com.tapirgames.util.GraphicsUtil;
   
   public class CoordinateSprite extends Sprite 
   {
      protected var mViewWidth:Number = 0;
      protected var mViewHeight:Number = 0;
      protected var mOriginX:Number = 0;
      protected var mOriginY:Number = 0;
      protected var mScale:Number = 0.0;
      
      public function UpdateAppearance (newViewWidth:Number, newViewHeight:Number, newOriginX:Number, newOriginY:Number, newScale:Number):void
      {
         if (mViewWidth != newViewWidth || mViewHeight != newViewHeight || mOriginX != newOriginX || mOriginY != newOriginY || mScale != newScale)
         {
            mViewWidth = newViewWidth;
            mViewHeight = newViewHeight;
            mOriginX = newOriginX;
            mOriginY = newOriginY;
            mScale = newScale;
            
            Repaint ();
         }
      }
      
      private function Repaint ():void
      {     
         GraphicsUtil.Clear (this);
         if (mOriginX > 0 && mOriginX < mViewWidth)
         {
            GraphicsUtil.DrawLine (this, mOriginX, 0, mOriginX, mViewHeight);
         }
         
         if (mOriginY > 0 && mOriginY < mViewHeight)
         {
            GraphicsUtil.DrawLine (this, 0, mOriginY, mViewWidth, mOriginY);
         }
      }
   }
   
}
