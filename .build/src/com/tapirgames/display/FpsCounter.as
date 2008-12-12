package com.tapirgames.display {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.FpsStat;
   
   public class FpsCounter extends MessageBox
   {
      
      private var mFpsStat:FpsStat;
      
      public function FpsCounter ()
      {
         super ("fps: 0", false);
         mFpsStat = new FpsStat ();
      }
      
      public function Update (dt:Number = NaN):void
      {
         if (mFpsStat.Step (dt))
         {
            mTextFieldEx.text = "fps: " + mFpsStat.GetFps ();
            
            mBorderMarginX = 10;
            Rebuild ();
            alpha = 0.6;
         }
      }
   }
}
