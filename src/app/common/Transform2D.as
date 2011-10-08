package common {

   import flash.display.DisplayObject;
   
   public class Transform2D
   {  
      public static function CombineTransform2Ds (transform1:Transform2D, transform2:Transform2D, combined:Transform2D = null):Transform2D
      {
         if (combined == null)
            combined = new Transform2D ();
         
      // offset
      
         // rotate
         combined.mOffsetX = transform1.cos * transform2.mOffsetX - transform1.sin * transform2.mOffsetY;
         combined.mOffsetY = transform1.sin * transform2.mOffsetX + transform1.cos * transform2.mOffsetY;
         
         // flip
         if (transform1.mFlipped)
            combined.mOffsetX = - combined.mOffsetX;
         
         // scale
         combined.mOffsetX *= transform1.mScale;
         combined.mOffsetY *= transform1.mScale;
         
         // offset
         combined.mOffsetX += transform1.mOffsetX;
         combined.mOffsetY += transform1.mOffsetY;
         
      // scale
      
         combined.mScale = transform1.mScale * transform2.mScale;
      
      // flipped
      
         combined.mFlipped = transform1.mFlipped != transform2.mFlipped;
      
      // rotation
      
         combined.mRotation = ((transform1.mFlipped != combined.mFlipped) ? - transform1.mRotation : transform1.mRotation) + ((transform2.mFlipped != combined.mFlipped) ? - transform2.mRotation : transform2.mRotation);
         
      // ...
         
         return combined;
      }
      
//================================================================
// 
//================================================================
      
      // cached value
      protected var mLastRotation:Number = 0.0;
      protected var mCos:Number = 1.0;
      protected var mSin:Number = 0.0;
      
      protected function CalculateSinCos ():void
      {
         mLastRotation = mRotation;
         mCos = Math.cos (mLastRotation);
         mSin = Math.sin (mLastRotation);
      }
      
      public function get cos ():Number
      {
         if (mLastRotation != mRotation)
            CalculateSinCos ();
         
         return mCos;
      }
      
      public function get sin ():Number
      {
         if (mLastRotation != mRotation)
            CalculateSinCos ();
         
         return mSin;
      }
      
//================================================================
// 
//================================================================
      
      public var mOffsetX:Number;
      public var mOffsetY:Number;
      public var mScale:Number;
      public var mFlipped:Boolean; // maybe can be mergerd in mScale, mScale is negative means flipped
      public var mRotation:Number;
      
      public function Transform2D (ox:Number = 0.0, oy:Number = 0.0, s:Number = 1.0, f:Boolean = false, r:Number = 0.0)
      {
         SetValues (ox, oy, s, f, r);
      }
      
      public function SetValues (ox:Number, oy:Number, s:Number, f:Boolean, r:Number):void
      {
         mOffsetX = ox;
         mOffsetY = oy;
         mScale = Math.abs (s);
         mFlipped = f;
         mRotation = r;
      }
      
      // transfromed: the displayObject is transfromed or not.
      public function TransformUntransformedDisplayObject (displayObject:DisplayObject):DisplayObject
      {
         if (displayObject != null)
         {
            displayObject.x = mOffsetX;
            displayObject.y = mOffsetY;
            displayObject.scaleX = mScale;
            displayObject.scaleY = mScale;
            displayObject.rotation = mRotation * 180.0 / Math.PI;
            
            if (mFlipped)
            {
               displayObject.scaleX = - displayObject.scaleX;
               displayObject.rotation = - displayObject.rotation;
            }
         }
         
         return displayObject;
      }
      
   }
}

