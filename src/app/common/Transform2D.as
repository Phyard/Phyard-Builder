package common {

   import flash.display.DisplayObject;
   
   import flash.geom.Point;
   
   public class Transform2D extends Point
   {
      public static function CombineTransforms (transform1:Transform2D, transform2:Transform2D, combined:Transform2D = null):Transform2D
      {
         if (combined == null)
            combined = new Transform2D ();
         
      // offset
      
         transform1.TransformPoint (transform2, combined); // use transform2 and combined as a Points
         
      // scale
      
         combined.mScale = transform1.mScale * transform2.mScale;
      
      // flipped
      
         combined.mFlipped = transform1.mFlipped != transform2.mFlipped;
      
      // rotation
      
         combined.mRotation = (transform2.mFlipped ? - transform1.mRotation : transform1.mRotation) + transform2.mRotation;
         
      // ...
         
         return combined;
      }
      
      public static function CombineInverseTransformAndTransform (invTransform1:Transform2D, transform2:Transform2D, combined:Transform2D = null):Transform2D
      {
         if (combined == null)
            combined = new Transform2D ();
         
      // offset
      
         invTransform1.InverseTransformPoint (transform2, combined); // use transform2 and combined as a Points
         
      // scale
      
         combined.mScale = (1.0 / invTransform1.mScale) * transform2.mScale;
      
      // flipped
      
         combined.mFlipped = invTransform1.mFlipped != transform2.mFlipped;
      
      // rotation
      
         combined.mRotation = (transform2.mFlipped ? invTransform1.mRotation : - invTransform1.mRotation) + transform2.mRotation;
         
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
      
      // todo: change to protected
      //public var mOffsetX:Number;
      //public var mOffsetY:Number;
      public function get mOffsetX ():Number {return x;};
      public function set mOffsetX (ox:Number):void {this.x = ox;};
      public function get mOffsetY ():Number {return y;};
      public function set mOffsetY (oy:Number):void {this.y = oy;};
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
      
      override public function toString ():String
      {
         return ("{x: " + x + ", y: " + y + ", scale: " + mScale + ", flip: " + mFlipped + ", rotation: " + mRotation + "}");
      }
      
      public function Clone (clonedTransform:Transform2D = null):Transform2D
      {
         if (clonedTransform == null)
            return new Transform2D (mOffsetX, mOffsetY, mScale, mFlipped, mRotation);
         else
         {
            clonedTransform.SetValues (mOffsetX, mOffsetY, mScale, mFlipped, mRotation);
            return clonedTransform;
         }
      }
      
      //<=> CombineInverseTransformAndTransform (this, I);
      public function GetInverse ():Transform2D
      {
         var inverse:Transform2D = new Transform2D ();
         
      // offset
      
         this.InverseTransformPoint (new Point (0, 0), inverse);
         
      // scale
      
         inverse.mScale = 1.0 / this.mScale;
      
      // flipped
      
         inverse.mFlipped = this.mFlipped;
      
      // rotation
      
         inverse.mRotation = - this.mRotation;
         
      // ...
         
         return inverse;
      }
      
      public function TransformPoint (inPoint:Point, outPoint:Point = null):Point
      {
         outPoint = TransformVectorXY (inPoint.x, inPoint.y, outPoint);
         
         // offset
         outPoint.x += mOffsetX;
         outPoint.y += mOffsetY;
         
         //
         return outPoint;
      }
      
      public function TransformPointXY (inPointX:Number, inPointY:Number, outPoint:Point = null):Point
      {
         outPoint = TransformVectorXY (inPointX, inPointY, outPoint);
         
         // offset
         outPoint.x += mOffsetX;
         outPoint.y += mOffsetY;
         
         //
         return outPoint;
      }
      
      public function TransformVectorXY (inVectorX:Number, inVectorY:Number, outVector:Point = null):Point
      {
         if (outVector == null)
            outVector = new Point ();
         
         // rotate
         outVector.x = cos * inVectorX - sin * inVectorY;
         outVector.y = sin * inVectorX + cos * inVectorY;
         
         // flip
         if (mFlipped)
            outVector.x = - outVector.x;
         
         // scale
         outVector.x *= mScale;
         outVector.y *= mScale;
         
         //
         return outVector;
      }
      
      public function InverseTransformPoint (inPoint:Point, outPoint:Point = null):Point
      {
         return InverseTransformVectorXY (inPoint.x - mOffsetX, inPoint.y - mOffsetY, outPoint);
      }
      
      public function InverseTransformPointXY (inPointX:Number, inPointY:Number, outPoint:Point = null):Point
      {
         return InverseTransformVectorXY (inPointX - mOffsetX, inPointY - mOffsetY, outPoint);
      }
      
      public function InverseTransformVectorXY (inVectorX:Number, inVectorY:Number, outVector:Point = null):Point
      {
         if (outVector == null)
            outVector = new Point ();
         
         // scale
         inVectorX /= mScale;
         inVectorY /= mScale;
         
         // flip
         if (mFlipped)
            inVectorX = - inVectorX;
         
         // rotate
         outVector.x =   cos * inVectorX + sin * inVectorY;
         outVector.y = - sin * inVectorX + cos * inVectorY;
         
         //
         return outVector;
      }
      
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

