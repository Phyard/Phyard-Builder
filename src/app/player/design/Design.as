package player.design
{
   import flash.display.Sprite;
   
   import player.world.World;
   
   import common.trigger.ValueDefine;
   
   public class Design extends Sprite
   {
      internal var mCurrentWorld:World = null; // must be
      
      public function Design ()
      {
      }
      
      public function RegisterWorld (world:World):void
      {
         if (world == null)
            return;
         
         if (numChildren == 0)
            SetCurrentWorld (world);
         
         addChild (world);
      }
      
      public function SetCurrentWorld (world:World):void
      {
         if (world == null)
            return;
         
         if (contains (world))
            mCurrentWorld = world;
      }
      
      public function GetCurrentWorld ():World
      {
         return mCurrentWorld;
      }
      
//=======================================================================
//
//=======================================================================
      
      protected var mLevelStatus_UserAssigned:int = ValueDefine.LevelStatus_Unfinished;
      
      public function SetLevelSuccessed ():void
      {
         mLevelStatus_UserAssigned = ValueDefine.LevelStatus_Successed;
      }
      
      public function IsLevelSuccessed ():Boolean
      {
         if (mLevelStatus_UserAssigned == ValueDefine.LevelStatus_Successed)
            return true;
         
         if (mLevelStatus_UserAssigned == ValueDefine.LevelStatus_Failed)
            return false;
         
         if (mCurrentWorld.IsCICriterionEnabled ())
         {
            return mCurrentWorld.IsSuccessed_CICriterion ();
         }
         
         return false;
      }
      
      public function SetLevelFailed ():void
      {
         mLevelStatus_UserAssigned = ValueDefine.LevelStatus_Failed;
      }
      
      public function IsLevelFailed ():Boolean
      {
         if (mLevelStatus_UserAssigned == ValueDefine.LevelStatus_Failed)
            return true;
         
         if (mLevelStatus_UserAssigned == ValueDefine.LevelStatus_Successed)
            return false;
         
         if (mCurrentWorld.IsCICriterionEnabled ())
         {
            return mCurrentWorld.IsFailed_CICriterion ();
         }
         
         return false;
      }
      
      public function SetLevelUnfinished ():void
      {
         mLevelStatus_UserAssigned = ValueDefine.LevelStatus_Unfinished;
      }
      
      public function IsLevelUnfinished ():Boolean
      {
         return ! (IsLevelSuccessed () || IsLevelFailed ());
      }
      
//=======================================================================
//
//=======================================================================
      
      //protected var mLevelMilliseconds:Number = 0.0;
      //protected var mLevelSteps:int = 0;
      
      public function GetLevelMilliseconds ():Number
      {
         return mCurrentWorld.GetLevelMilliseconds ();
      }
      
      public function GetLevelSteps ():int
      {
         return mCurrentWorld.GetSimulatedSteps ();
      }
      
//=======================================================================
//
//=======================================================================
      
      /*
      public function Initialize ():void
      {
         mLevelMilliseconds = 0.0;
         mLevelSteps = 0;
         
         for (var i:int = 0; i < numChildren; ++ i)
         {
            (getChildAt (i) as World).Initialize ();
         }
      }
      
      public function Update (escapedTime:Number, speedX:int):void
      {
         if (escapedTime < 0)
            escapedTime = 0.0;
         
         var i:int;
         
         for (i = 0; i < numChildren; ++ i)
         {
            (getChildAt (i) as World).Update (escapedTime, speedX);
         }
         
         for (i = 0; i < numChildren; ++ i)
         {
            (getChildAt (i) as World).Repaint ();
         }
      }
      */
   }
}
