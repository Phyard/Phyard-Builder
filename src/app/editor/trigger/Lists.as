package editor.trigger {
   
   import flash.ui.Keyboard;
   
   import common.Define;
   import common.KeyCodes;
   import common.trigger.ValueDefine;
   
   public class Lists
   {
      // the list must have label and data field
      public static function SelectedValue2SelectedIndex (list:Array, value:Object):int
      {
         for (var i:int = 0; i < list.length; ++ i)
         {
            if (list [i].data == value)
               return i;
         }
         
         return -1;
      }
      
      public static function GetListWithDataInLabel (list:Array):Array
      {
         var newList:Array = new Array (list.length);
         
         for (var i:int = 0; i < list.length; ++ i)
         {
            newList [i] = {label: list [i].label + " (" + list [i].data + ")", data: list [i].data};
         }
         
         return newList;
      }
      
//=============================================================================
// 
//=============================================================================
      
      public static const mLevelStatusList:Array = [
            {label:"Failed", data:ValueDefine.TaskStatus_Failed},
            {label:"Successed", data:ValueDefine.TaskStatus_Successed},
            {label:"Unfinished", data:ValueDefine.TaskStatus_Unfinished},
         ];
      
      public static const mEntityTaskStatusList:Array = [
            {label:"Failed", data:ValueDefine.LevelStatus_Failed},
            {label:"Successed", data:ValueDefine.LevelStatus_Successed},
            {label:"Unfinished", data:ValueDefine.LevelStatus_Unfinished},
         ];
      
      public static const mAiTypeList:Array = [
            {label:"Unknown", data:Define.ShapeAiType_Unknown},
            {label:"Static", data:Define.ShapeAiType_Static},
            {label:"Movable", data:Define.ShapeAiType_Movable},
            {label:"Breakable", data:Define.ShapeAiType_Breakable},
            {label:"Infected", data:Define.ShapeAiType_Infected},
            {label:"Uninfected", data:Define.ShapeAiType_Uninfected},
            {label:"DontInfect", data:Define.ShapeAiType_DontInfect},
         ];
      
      public static const mCircleAppearanceList:Array = [
            {label:"Ball", data:Define.CircleAppearanceType_Ball},
            {label:"Column", data:Define.CircleAppearanceType_Column},
            {label:"Circle", data:Define.CircleAppearanceType_Circle},
         ];
      
      public static const mKeyCodeList:Array = [
            {label:"W", data:KeyCodes.Key_W},
            {label:"A", data:KeyCodes.Key_A},
            {label:"S", data:KeyCodes.Key_S},
            {label:"D", data:KeyCodes.Key_D},
            {label:"Left", data:Keyboard.LEFT},
            {label:"Right", data:Keyboard.RIGHT},
            {label:"Top", data:Keyboard.UP},
            {label:"Down", data:Keyboard.DOWN},
            {label:"Space", data:Keyboard.SPACE},
         ];
   }
}

