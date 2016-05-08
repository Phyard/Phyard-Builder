package common.trigger {
   
   public class ValueDefine
   {
   // DON'T change these values
      
      public static const BoolValue_False:int = 0;
      public static const BoolValue_True:int = 1;
      
      public static const TaskStatus_Failed:int = BoolValue_False;
      public static const TaskStatus_Successed:int = BoolValue_True;
      public static const TaskStatus_Unfinished:int = 2;
      
      public static const LevelStatus_Failed:int = TaskStatus_Failed;
      public static const LevelStatus_Successed:int = TaskStatus_Successed;
      public static const LevelStatus_Unfinished:int = TaskStatus_Unfinished;
      
      public static const WorldStatus_Failed:int = TaskStatus_Failed;
      public static const WorldStatus_Successed:int = TaskStatus_Successed;
      public static const WorldStatus_Unfinished:int = TaskStatus_Unfinished;
   }
}
