
// these values are in display space
private var mWorldLeft:int = 0;
private var mWorldTop:int = 0;
private var mWorldWidth:int = Define.DefaultWorldWidth;
private var mWorldHeight:int = Define.DefaultWorldHeight;

public function GetWorldLeft ():int
{
   return mWorldLeft;
}

public function GetWorldTop ():int
{
   return mWorldTop;
}

public function GetWorldWidth ():int
{
   return mWorldWidth;
}

public function GetWorldHeight ():int
{
   return mWorldHeight;
}

// these values are in display space
private var mCameraWidth:Number = Define.DefaultWorldWidth;
private var mCameraHeight:Number = Define.DefaultWorldHeight;
private var mCameraCenterX:Number = Define.DefaultWorldWidth * 0.5;
private var mCameraCenterY:Number = Define.DefaultWorldHeight * 0.5;

private var mZoomScale:Number = 1.0;

private var mCurrentCamera:EntityShape_Camera = null;

public function GetCurrentCamera ():EntityShape_Camera
{
   return mCurrentCamera;
}

public function SetCameraCenterX (physicsCenterX:Number):void
{
   mCameraCenterX = PhysicsX2DisplayX (physicsCenterX);
}

public function SetCameraCenterY (physicsCenterY:Number):void
{
   mCameraCenterY = PhysicsY2DisplayY (physicsCenterY);
}

public function GetCameraCenterX ():Number
{
   return mCameraCenterX;
}

public function GetCameraCenterY ():Number
{
   return mCameraCenterY;
}

public function SetCameraWidth (width:Number):void
{
   mCameraWidth = width;
}

public function SetCameraHeight (height:Number):void
{
   mCameraHeight = height;
}

public function GetZoomScale ():Number
{
   return mZoomScale;
}
      
public function SetZoomScale (zoomScale:Number):void
{
   var oldViewCenterX:Number = x + mCameraCenterX * scaleX;
   var oldViewCenterY:Number = y + mCameraCenterY * scaleY;
   
   mZoomScale = zoomScale;
   
   scaleX = zoomScale;
   scaleY = zoomScale;
   
   x = oldViewCenterX - mCameraCenterX * scaleX;
   y = oldViewCenterY - mCameraCenterY * scaleY;
   
   MoveWorldScene (0, 0);
}

public function SetTargetCameraCenter (physicsX:Number, physicsY:Number):void
{
   MoveWorldScene (mCameraCenterX - PhysicsX2DisplayX (physicsX), mCameraCenterY - PhysicsY2DisplayY (physicsY));
}

public function MoveWorldScene (displayDx:Number, displayDy:Number):void
{
   // assume no scales and rotation for world
   
   var leftInView:Number;
   var topInView:Number;
   
   var worldViewWidth :Number = mWorldWidth  * scaleX;
   var worldViewHeight:Number = mWorldHeight * scaleY;
   
   if (worldViewWidth < mCameraWidth)
   {
      mCameraCenterX = mWorldLeft + mWorldWidth * 0.5;
      leftInView = (mWorldLeft - mCameraCenterX) * scaleX + mCameraWidth * 0.5;
   }
   else
   {
      mCameraCenterX -= displayDx;
      leftInView =(mWorldLeft - mCameraCenterX) * scaleX + mCameraWidth * 0.5;
      
      if (leftInView > 0)
         leftInView = 0;
      if (leftInView + worldViewWidth < mCameraWidth)
         leftInView = mCameraWidth - worldViewWidth;
      
      mCameraCenterX = mWorldLeft + (mCameraWidth * 0.5 - leftInView) / scaleX;
   }
   
   if (worldViewHeight < mCameraHeight)
   {
      mCameraCenterY = mWorldTop + mWorldHeight * 0.5;
      topInView = (mWorldTop - mCameraCenterY) * scaleY + mCameraHeight * 0.5;
   }
   else
   {
      mCameraCenterY -= displayDy;
      topInView = (mWorldTop - mCameraCenterY) * scaleY + mCameraHeight * 0.5;
      
      if (topInView > 0)
         topInView = 0;
      if (topInView + worldViewHeight < mCameraHeight)
         topInView = mCameraHeight - worldViewHeight;
      
      mCameraCenterY = mWorldTop + (mCameraHeight * 0.5 - topInView) / scaleY;
   }
   
   x = leftInView - mWorldLeft * scaleX;
   y = topInView  - mWorldTop  * scaleY;
}
