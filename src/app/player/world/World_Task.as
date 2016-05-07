
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
      
      if (IsCiRulesEnabled ())
      {
         return IsSuccessed_CICriterion ();
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
      
      if (IsCiRulesEnabled ())
      {
         return IsFailed_CICriterion ();
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
   
