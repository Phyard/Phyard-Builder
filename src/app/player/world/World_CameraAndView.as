
public function GlobalToLocal (point:Point):Point
{
   return mContentLayer.globalToLocal (point);
}

public function LocalToGlobal (point:Point):Point
{
   return mContentLayer.localToGlobal (point);
}

//=====================================================================================
//
//=====================================================================================

private var mViewerUiFlags:int = Define.PlayerUiFlag_ShowPlayBar
                               | Define.PlayerUiFlag_ShowSpeedAdjustor
                               | Define.PlayerUiFlag_ShowScaleAdjustor
                               | Define.PlayerUiFlag_ShowHelpButton
                               ;
private var mPlayBarColor:uint = 0x606060;
private var mViewportWidth:int = Define.DefaultPlayerWidth;
private var mViewportHeight:int = Define.DefaultPlayerHeight;

private var mCameraRotatingEnabled:Boolean = false;

public function GetViewerUiFlags ():int
{
   return mViewerUiFlags;
}

public function GetPlayBarColor ():uint
{
   return mPlayBarColor;
}

public function GetViewportWidth ():int
{
   return mViewportWidth;
}

public function GetViewportHeight ():int
{
   return mViewportHeight;
}

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
   //var oldViewCenterX:Number = mContentLayer.x + mCameraCenterX * mContentLayer.scaleX;
   //var oldViewCenterY:Number = mContentLayer.y + mCameraCenterY * mContentLayer.scaleY;
   
   mZoomScale = zoomScale;

   mContentLayer.scaleX = zoomScale;
   mContentLayer.scaleY = zoomScale;
   
   //mContentLayer.x = oldViewCenterX - mCameraCenterX * mContentLayer.scaleX;
   //mContentLayer.y = oldViewCenterY - mCameraCenterY * mContentLayer.scaleY;
   
   MoveCameraCenterTo_DisplayPoint (mCameraCenterX, mCameraCenterY, mCameraAngle);
}

//=====================================================================================
//
//=====================================================================================

// these values are in display world space, pixels, assume scale = 1
private var mCameraCenterX:Number = Define.DefaultWorldWidth * 0.5;
private var mCameraCenterY:Number = Define.DefaultWorldHeight * 0.5;
private var mCameraAngle:Number = 0; // degrees

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

public function GetCameraPhysicsRotationIn360Degrees ():Number
{
   var cameraRotation:Number = mCoordinateSystem.D2P_RotationDegrees (mCameraAngle);
   cameraRotation = cameraRotation % 360;
   if (cameraRotation < 0) // shouldn't
      cameraRotation += 360;
   
   return cameraRotation;
}

public function MoveWorldScene_PhysicsOffset (physicsDx:Number, physicsDy:Number):void
{
   var displayOffet:Point = mCoordinateSystem.PhysicsVector2DisplayVector (physicsDx, physicsDy);
   
   MoveCameraCenterTo_DisplayPoint (mCameraCenterX + displayOffet.x, mCameraCenterY + displayOffet.y, mCameraAngle);
}

public function MoveWorldScene_DisplayOffset (displayDx:Number, displayDy:Number):void
{
   MoveCameraCenterTo_DisplayPoint (mCameraCenterX + displayDx, mCameraCenterY + displayDy, mCameraAngle);
}

public function MoveCameraCenterTo_PhysicsPoint (physicsX:Number, physicsY:Number):void
{
   MoveCameraCenterTo_DisplayPoint (mCoordinateSystem.P2D_PositionX (physicsX), mCoordinateSystem.P2D_PositionY (physicsY), mCameraAngle);
}

public function MoveCameraCenterTo_DisplayPoint (targetDisplayX:Number, targetDisplayY:Number, targetDisplayAngle:Number):void
{
   if (mCameraRotatingEnabled)
   {
      // set world sprite rotation
      mCameraAngle = targetDisplayAngle;
      
      if (targetDisplayX < mWorldLeft)
         mCameraCenterX = mWorldLeft;
      else if (targetDisplayX > (mWorldLeft + mWorldWidth))
         mCameraCenterX = mWorldLeft + mWorldWidth;
      else
         mCameraCenterX = targetDisplayX;
      
      if (targetDisplayY < mWorldTop)
         mCameraCenterY = mWorldTop;
      else if (targetDisplayY > (mWorldTop + mWorldHeight))
         mCameraCenterY = mWorldTop + mWorldHeight;
      else
         mCameraCenterY = targetDisplayY;
         
      mContentLayer.rotation = - targetDisplayAngle % 360; // important, flash has rotation limit (65536?);
      
      var point:Point = globalToLocal (mContentLayer.localToGlobal (new Point (mCameraCenterX, mCameraCenterY)));
      
      mContentLayer.x -= point.x;
      mContentLayer.y -= point.y;
      mContentLayer.x += mViewportWidth  * 0.5;
      mContentLayer.y += mViewportHeight * 0.5;
      
      // use the above code now. The following code has some number errors.
      ////var angleRadians:Number = Math.PI * (- targetDisplayAngle) / 180.0;
      //var angleRadians:Number = Math.PI * mContentLayer.rotation / 180.0;
      //var cos:Number = Math.cos (angleRadians);
      //var sin:Number = Math.sin (angleRadians);
      //
      //mContentLayer.x = (( - mCameraCenterX) * cos - ( - mCameraCenterY) * sin) * mContentLayer.scaleX + mViewportWidth  * 0.5;
      //mContentLayer.y = (( - mCameraCenterX) * sin + ( - mCameraCenterY) * cos) * mContentLayer.scaleY + mViewportHeight * 0.5;
   }
   else
   {
      var worldViewWidth :Number = mWorldWidth  * mContentLayer.scaleX;
      var worldViewHeight:Number = mWorldHeight * mContentLayer.scaleY;
      
      if (worldViewWidth < mViewportWidth)
      {
         mCameraCenterX = mWorldLeft + mWorldWidth * 0.5;
         mContentLayer.x = (- mCameraCenterX) * mContentLayer.scaleX + mViewportWidth * 0.5;
      }
      else
      {
         mCameraCenterX = targetDisplayX;
         var leftInView:Number = (mWorldLeft - mCameraCenterX) * mContentLayer.scaleX + mViewportWidth * 0.5;
         
         if (leftInView > 0)
            leftInView = 0;
         if (leftInView + worldViewWidth < mViewportWidth)
            leftInView = mViewportWidth - worldViewWidth;
         
         mCameraCenterX = mWorldLeft + (mViewportWidth * 0.5 - leftInView) / mContentLayer.scaleX;
         mContentLayer.x = leftInView - mWorldLeft * mContentLayer.scaleX;
      }
      
      if (worldViewHeight < mViewportHeight)
      {
         mCameraCenterY = mWorldTop + mWorldHeight * 0.5;
         mContentLayer.y = (- mCameraCenterY) * mContentLayer.scaleY + mViewportHeight * 0.5;
      }
      else
      {
         mCameraCenterY = targetDisplayY;
         var topInView:Number = (mWorldTop - mCameraCenterY) * mContentLayer.scaleY + mViewportHeight * 0.5;
         
         if (topInView > 0)
            topInView = 0;
         if (topInView + worldViewHeight < mViewportHeight)
            topInView = mViewportHeight - worldViewHeight;
         
         mCameraCenterY = mWorldTop + (mViewportHeight * 0.5 - topInView) / mContentLayer.scaleY;
         mContentLayer.y = topInView  - mWorldTop  * mContentLayer.scaleY;
      }
   }
}

protected function InitCamera ():void
{
   SetZoomScale (mZoomScale);
   MoveCameraCenterTo_DisplayPoint (mCameraCenterX, mCameraCenterY, mCameraAngle);
}

protected function UpdateCamera ():void
{
   var targetX:Number;
   var targetY:Number
   var targetAngle:Number
   
   var smoothX:Boolean;
   var smoothY:Boolean;
   var smoothAngle:Boolean;
   
   var updateCamera:Boolean = mSingleStepMode || (! mIsPaused);
   
   if (mFollowedEntityCameraCenterX != null && mFollowedEntityCameraCenterX.IsDestroyedAlready ())
      mFollowedEntityCameraCenterX = null;
   
   if (updateCamera && mFollowedEntityCameraCenterX != null)
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
   
   if (updateCamera && mFollowedEntityCameraCenterY != null)
   {
      smoothY = mSmoothFollowingCameraCenterY;
      targetY = mCoordinateSystem.P2D_PositionY (mFollowedEntityCameraCenterY.GetPositionY ());
   }
   else
   {
      smoothY = false;
      targetY = mCameraCenterY + mCameraMovedOffsetY_ByMouse;
   }
   
   if (mFollowedEntityCameraAngle != null && mFollowedEntityCameraAngle.IsDestroyedAlready ())
      mFollowedEntityCameraAngle = null;
   
   if (updateCamera && mFollowedEntityCameraAngle != null)
   {
      smoothAngle = mSmoothFollowingCameraAngle;
      targetAngle = mCoordinateSystem.P2D_RotationRadians (mFollowedEntityCameraAngle.GetRotation ()) * Define.kRadians2Degrees;
   }
   else
   {
      smoothAngle = false;
      targetAngle = mCameraAngle + mCameraMovedOffsetAngle_ByMouse;
   }
   
   var elasticStaticLength:Number = mViewportWidth < mViewportHeight ? mViewportWidth : mViewportHeight;
   elasticStaticLength /= (mZoomScale * 4.0);
   
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
      
      if (distance > elasticStaticLength)
      {
      }
      
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
   
   var newAngle:Number;
   var dAngle:Number;
   var distanceAngle:Number;
   
   var criteriaAngle1:Number = 180; // degrees
   var criteriaAngle2:Number = 0.3; // degrees
   
   var maxAngularSpeed:Number = 10; // degrees
   
   if (smoothAngle)
   {
      dAngle = (targetAngle - mCameraAngle) % 360;
      if (dAngle > 180)
         dAngle = dAngle - 360;
      distanceAngle = Math.abs (dAngle);
      
      if (distanceAngle <= criteriaAngle2)
      {
         newAngle = targetAngle;
      }
      else if (distanceAngle > criteriaAngle1)
      {
         newAngle = mCameraAngle + maxAngularSpeed * dAngle / distanceAngle;
      }
      else
      {
         newAngle = mCameraAngle + maxAngularSpeed * dAngle / criteriaAngle1;
      }
   }
   else
   {
      newAngle = targetAngle;
   }
   
   MoveCameraCenterTo_DisplayPoint (nextX, nextY, newAngle);
   
   //UpdateSpriteOffsetAndScale (mBackgroundSprite);
   
   FadingCamera ();
   
   mCameraMovedOffsetX_ByMouse = 0;
   mCameraMovedOffsetY_ByMouse = 0;
   mCameraMovedOffsetAngle_ByMouse = 0;
}

//private function UpdateSpriteOffsetAndScale (sprite:Sprite):void
//{
//   if (sprite != null)
//   {
   //   var angleChanged:Boolean = sprite.rotation != mCameraAngle;
   //   if (angleChanged || (int(sprite.x * 20.0)) != (int (mCameraCenterX * 20.0)))
   //      sprite.x = mCameraCenterX;
   //   if (angleChanged || (int(sprite.y * 20.0)) != (int (mCameraCenterY * 20.0)))
   //      sprite.y = mCameraCenterY;
   //   
   //   //var targetAngle:Number = mCameraAngle % 360.0; // the result is a float number
   //   //if (targetAngle >= 180.0)
   //   //   targetAngle = targetAngle - 360.0;
   //   //if (mBackgroundSprite.rotation != targetAngle)
   //   //   mBackgroundSprite.rotation = targetAngle;
   //   sprite.rotation = mCameraAngle;
   //      
   //   var sx:Number = 1.0 / scaleX;
   //   if (sprite.scaleX != sx)
   //      sprite.scaleX = sx;
   //   
   //   var sy:Number = 1.0 / scaleY;
   //   if (sprite.scaleY != sy)
   //      sprite.scaleY = sy;
//   }
//}

//=====================================================================================
// mouse move camera
//=====================================================================================

protected var mCameraMovedOffsetX_ByMouse:Number = 0;
protected var mCameraMovedOffsetY_ByMouse:Number = 0;
protected var mCameraMovedOffsetAngle_ByMouse:Number = 0; // degrees

public function MouseMoveCamera (offsetX:Number, offsetY:Number):void
{
   mCameraMovedOffsetX_ByMouse += offsetX;
   mCameraMovedOffsetY_ByMouse += offsetY;
   
   if (mIsPaused)
   {
      UpdateCamera ();
   }
}

// for pad: thwo hands rotate world (delta degrees)
public function MouseRotateCamera (offsetAngle:Number):void 
{
   mCameraMovedOffsetAngle_ByMouse += offsetAngle;
   
   if (mIsPaused)
   {
      UpdateCamera ();
   }
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
   }
   
   if (mFadeMaskSprite.visible)
   {
      if (mCameraFadeParams.mFadeColor != mCameraFadeColor)
      {
         mCameraFadeColor = mCameraFadeParams.mFadeColor;
         mCameraFadeMaskNeedRepaint = true;
      }
      
      if (mFadeMaskSprite.alpha != mCameraFadeParams.mCurrentAlpha)
         mFadeMaskSprite.alpha = mCameraFadeParams.mCurrentAlpha;
         
      //UpdateSpriteOffsetAndScale (mFadeMaskSprite);
   }
}
