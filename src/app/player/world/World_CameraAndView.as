

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
private var mViewportWidth:Number   = Define.DefaultWorldWidth;
private var mViewportHeight:Number  = Define.DefaultWorldHeight;
private var mCameraCenterX:Number = Define.DefaultWorldWidth * 0.5;
private var mCameraCenterY:Number = Define.DefaultWorldHeight * 0.5;

public function GetCameraCenterDisplayX ():Number
{
   return mCameraCenterX;
}

public function GetCameraCenterDisplayY ():Number
{
   return mCameraCenterY;
}

public function GetCameraCenterPhysicsX ():Number
{
   return mCoordinateSystem.D2P_PositionX (mCameraCenterX);
}

public function GetCameraCenterPhysicsY ():Number
{
   return mCoordinateSystem.D2P_PositionY (mCameraCenterY);
}

public function SetCameraWidth (width:Number):void
{
   mViewportWidth = width;
}

public function SetCameraHeight (height:Number):void
{
   mViewportHeight = height;
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
   
   if (worldViewWidth < mViewportWidth)
   {
      mCameraCenterX = mWorldLeft + mWorldWidth * 0.5;
      leftInView = (mWorldLeft - mCameraCenterX) * scaleX + mViewportWidth * 0.5;
   }
   else
   {
      mCameraCenterX = targetDisplayX;
      leftInView =(mWorldLeft - mCameraCenterX) * scaleX + mViewportWidth * 0.5;
      
      if (leftInView > 0)
         leftInView = 0;
      if (leftInView + worldViewWidth < mViewportWidth)
         leftInView = mViewportWidth - worldViewWidth;
      
      mCameraCenterX = mWorldLeft + (mViewportWidth * 0.5 - leftInView) / scaleX;
   }
   
   if (worldViewHeight < mViewportHeight)
   {
      mCameraCenterY = mWorldTop + mWorldHeight * 0.5;
      topInView = (mWorldTop - mCameraCenterY) * scaleY + mViewportHeight * 0.5;
   }
   else
   {
      mCameraCenterY = targetDisplayY;
      topInView = (mWorldTop - mCameraCenterY) * scaleY + mViewportHeight * 0.5;
      
      if (topInView > 0)
         topInView = 0;
      if (topInView + worldViewHeight < mViewportHeight)
         topInView = mViewportHeight - worldViewHeight;
      
      mCameraCenterY = mWorldTop + (mViewportHeight * 0.5 - topInView) / scaleY;
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
   var targetX:Number;
   var targetY:Number
   
   var smoothX:Boolean;
   var smoothY:Boolean;
   
   if (mFollowedEntityCameraCenterX != null && mFollowedEntityCameraCenterX.IsDestroyedAlready ())
      mFollowedEntityCameraCenterX = null;
   
   if (! mIsPaused && mFollowedEntityCameraCenterX != null)
   {
      smoothX = mSmoothFollowingCameraCenterX;
      targetX = mCoordinateSystem.P2D_PositionX (mFollowedEntityCameraCenterX.GetPositionX ());
   }
   else
   {
      smoothX = false;
      targetX = mCameraCenterX + mCameraMovedOffsetX_ByMouse;
   }
   
   if (mFollowedEntityCameraCenterY != null && mFollowedEntityCameraCenterY.IsDestroyedAlready ())
      mFollowedEntityCameraCenterY = null;
   
   if (! mIsPaused && mFollowedEntityCameraCenterY != null)
   {
      smoothY = mSmoothFollowingCameraCenterY;
      targetY = mCoordinateSystem.P2D_PositionY (mFollowedEntityCameraCenterY.GetPositionY ());
   }
   else
   {
      smoothY = false;
      targetY = mCameraCenterY + mCameraMovedOffsetY_ByMouse;
   }
   
   var nextX:Number;
   var nextY:Number;
   
   var dx:Number;
   var dy:Number;
   var distance:Number;
   
   var criteria1:Number = 300;
   var criteria2:Number = 1;
   
   var maxSpeed:Number = 8;
   
   if (smoothX && smoothY)
   {
      dx = targetX - mCameraCenterX;
      dy = targetY - mCameraCenterY;
      distance = Math.sqrt (dx * dx + dy * dy);
      
      if (distance <= criteria2)
      {
         nextX = targetX;
         nextY = targetY;
      }
      else if (distance > criteria1)
      {
         nextX = mCameraCenterX + maxSpeed * dx / distance;
         nextY = mCameraCenterY + maxSpeed * dy / distance;
      }
      else
      {
         nextX = mCameraCenterX + maxSpeed * dx / criteria1;
         nextY = mCameraCenterY + maxSpeed * dy / criteria1;
      }
   }
   else if (smoothX)
   {
      nextY = targetY;
      
      dx = targetX - mCameraCenterX;
      distance = Math.abs (dx);
      
      if (distance <= criteria2)
      {
         nextX = targetX;
      }
      else if (distance > criteria1)
      {
         nextX = mCameraCenterX + maxSpeed * dx / distance;
      }
      else
      {
         nextX = mCameraCenterX + maxSpeed * dx / criteria1;
      }
   }
   else if (smoothY)
   {
      nextX = targetX;
      
      dy = targetY - mCameraCenterY;
      distance = Math.abs (dy);
      
      if (distance <= criteria2)
      {
         nextY = targetY;
      }
      else if (distance > criteria1)
      {
         nextY = mCameraCenterY + maxSpeed * dy / distance;
      }
      else
      {
         nextY = mCameraCenterY + maxSpeed * dy / criteria1;
      }
   }
   else
   {
      nextX = targetX;
      nextY = targetY;
   }
   
   MoveCameraCenterTo_DisplayPoint (nextX, nextY);
   
   mCameraMovedOffsetX_ByMouse = 0;
   mCameraMovedOffsetY_ByMouse = 0;
   
   FadingCamera ();
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
   
   if (mIsPaused)
      UpdateCamera ();
}

//=====================================================================================
// camera follow entity
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

//=====================================================================================
// fade
//=====================================================================================

private var mTempCameraFadeParams:CameraFadeParams = null; // to avoid IsForbidMouseAndKeyboardEventHandling returning a wrong result if CameraFadeOutThenFadeIn is called in a mouse or keyboard event

private var mCameraFadeParams:CameraFadeParams = null;

public function CameraFadeOutThenFadeIn (fadeColor:uint, stepsFadeOut:Number, stepsFadeIn:Number, stepsFadeStaying:int, scriptToRun:ScriptHolder):void
{
   mTempCameraFadeParams = new CameraFadeParams (fadeColor, stepsFadeOut, stepsFadeIn, stepsFadeStaying, scriptToRun);
   mFadeMaskSprite.visible = true;
}

protected function FadingCamera ():void
{
   if (mTempCameraFadeParams != null)
   {
      mCameraFadeParams = mTempCameraFadeParams;
      mTempCameraFadeParams = null;
   }
   
   if (mCameraFadeParams != null)
   {
      var finished:Boolean = mCameraFadeParams.Step ();
      
      if (finished)
      {
         mCameraFadeParams = null;
         mFadeMaskSprite.visible = false;
      }
      else
      {
         if (mCameraFadeParams.mFadeColor != mCameraFadeColor)
         {
            mCameraFadeColor = mCameraFadeParams.mFadeColor;
            mCameraFadeMaskNeedRepaint = true;
         }
         
         mFadeMaskSprite.alpha = mCameraFadeParams.mCurrentAlpha;
         mFadeMaskSprite.x = mCameraCenterX;
         mFadeMaskSprite.y = mCameraCenterY;
      }
   }
}
