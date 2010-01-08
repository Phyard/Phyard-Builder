

//=====================================================================================
//
//=====================================================================================

private var mIsInfiniteWorldSize:Boolean = false;

// these values are in display space
private var mWorldLeft:Number = 0;
private var mWorldTop:Number = 0;
private var mWorldWidth:Number = Define.DefaultWorldWidth;
private var mWorldHeight:Number = Define.DefaultWorldHeight;

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

//=====================================================================================
//
//=====================================================================================

private var mZoomScale:Number = 1.0;

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
   
   MoveCameraCenterTo_DisplayPoint (mCameraCenterX, mCameraCenterY);
}

//=====================================================================================
//
//=====================================================================================

// these values are in display world space, pixels, assume scale = 1
private var mCameraWidth:Number   = Define.DefaultWorldWidth;
private var mCameraHeight:Number  = Define.DefaultWorldHeight;
private var mCameraCenterX:Number = Define.DefaultWorldWidth * 0.5;
private var mCameraCenterY:Number = Define.DefaultWorldHeight * 0.5;

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

public function MoveWorldScene_PhysicsOffset (physicsDx:Number, physicsDy:Number):void
{
   var displayOffet:Point = mCoordinateSystem.PhysicsVector2DisplayVector (physicsDx, physicsDy);
   
   MoveCameraCenterTo_DisplayPoint (mCameraCenterX + displayOffet.x, mCameraCenterY + displayOffet.y);
}

public function MoveWorldScene_DisplayOffset (displayDx:Number, displayDy:Number):void
{
   MoveCameraCenterTo_DisplayPoint (mCameraCenterX + displayDx, mCameraCenterY + displayDy);
}

public function MoveCameraCenterTo_PhysicsPoint (physicsX:Number, physicsY:Number):void
{
   MoveCameraCenterTo_DisplayPoint (mCoordinateSystem.P2D_PositionX (physicsX), mCoordinateSystem.P2D_PositionY (physicsY));
}

public function MoveCameraCenterTo_DisplayPoint (targetDisplayX:Number, targetDisplayY:Number):void
{
   // assume rotation of world is zero
   
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
      mCameraCenterX = targetDisplayX;
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
      mCameraCenterY = targetDisplayY;
      topInView = (mWorldTop - mCameraCenterY) * scaleY + mCameraHeight * 0.5;
      
      if (topInView > 0)
         topInView = 0;
      if (topInView + worldViewHeight < mCameraHeight)
         topInView = mCameraHeight - worldViewHeight;
      
      mCameraCenterY = mWorldTop + (mCameraHeight * 0.5 - topInView) / scaleY;
   }
   
   x = leftInView - mWorldLeft * scaleX;
   y = topInView  - mWorldTop  * scaleY;
   
   UpdateBackgroundSpriteOffsetAndScale ();
}

private function UpdateBackgroundSpriteOffsetAndScale ():void
{
   if (mBackgroundSprite != null)
   {
      mBackgroundSprite.x = mCameraCenterX;
      mBackgroundSprite.y = mCameraCenterY;
      mBackgroundSprite.scaleX = 1.0 / scaleX;
      mBackgroundSprite.scaleY = 1.0 / scaleY;
   }
}

protected function UpdateCamera ():void
{
   var targetX:Number = mCameraCenterX;
   var targetY:Number = mCameraCenterY;
   
   if (mFollowedEntityCameraCenterX != null && mFollowedEntityCameraCenterX.IsDestroyedAlready ())
      mFollowedEntityCameraCenterX = null;
   
   if (mFollowedEntityCameraCenterX != null)
      targetX = mCoordinateSystem.P2D_PositionX (mFollowedEntityCameraCenterX.GetPositionX ());
   else
      targetX = mCameraCenterX + mCameraMovedOffsetX_ByMouse;
   
   if (mFollowedEntityCameraCenterY != null && mFollowedEntityCameraCenterY.IsDestroyedAlready ())
      mFollowedEntityCameraCenterY = null;
   
   if (mFollowedEntityCameraCenterY != null)
      targetY = mCoordinateSystem.P2D_PositionY (mFollowedEntityCameraCenterY.GetPositionY ());
   else
      targetY = mCameraCenterY + mCameraMovedOffsetY_ByMouse;
   
   MoveCameraCenterTo_DisplayPoint (targetX, targetY);
   
   mCameraMovedOffsetX_ByMouse = 0;
   mCameraMovedOffsetY_ByMouse = 0;
}

//=====================================================================================
//
//=====================================================================================

protected var mCameraMovedOffsetX_ByMouse:Number = 0;
protected var mCameraMovedOffsetY_ByMouse:Number = 0;

public function MouseMoveCamera (offsetX:Number, offsetY:Number):void
{
   mCameraMovedOffsetX_ByMouse += offsetX;
   mCameraMovedOffsetY_ByMouse += offsetY;
}

//=====================================================================================
//
//=====================================================================================

protected var mFollowedEntityCameraCenterX:Entity = null;
protected var mFollowedEntityCameraCenterY:Entity = null;
protected var mFollowedEntityCameraAngle:Entity = null;

protected var mSmoothFollowingCameraCenterX:Boolean = false;
protected var mSmoothFollowingCameraCenterY:Boolean = false;
protected var mSmoothFollowingCameraAngle:Boolean = false;

public function FollowCameraWithEntity (entity:Entity, bSmooth:Boolean, followAngle:Boolean):void
{
   FollowCameraCenterXWithEntity (entity, bSmooth);
   FollowCameraCenterYWithEntity (entity, bSmooth);
   
   if (followAngle)
      FollowCameraAngleWithEntity (entity, bSmooth);
}

public function FollowCameraCenterXWithEntity (entity:Entity, bSmooth:Boolean):void
{
   mFollowedEntityCameraCenterX = entity;
   mSmoothFollowingCameraCenterX = bSmooth;
}

public function FollowCameraCenterYWithEntity (entity:Entity, bSmooth:Boolean):void
{
   mFollowedEntityCameraCenterY = entity;
   mSmoothFollowingCameraCenterY = bSmooth;
}

public function FollowCameraAngleWithEntity (entity:Entity, bSmooth:Boolean):void
{
   mFollowedEntityCameraAngle = entity;
   mSmoothFollowingCameraAngle = bSmooth;
}
