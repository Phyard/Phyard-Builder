package editor.world {
   
   import flash.ui.Keyboard;
   
   import common.Define;
   import common.KeyCodes;
   import common.trigger.ValueDefine;
   import common.trigger.ValueTypeDefine;
   
   public class Lists
   {
            
//=============================================================================
// 
//=============================================================================
      
      public static const mLevelStatusList:Array = [
            {label:"Failed", data:ValueDefine.TaskStatus_Failed},
            {label:"Succeeded", data:ValueDefine.TaskStatus_Successed},
            {label:"Unfinished", data:ValueDefine.TaskStatus_Unfinished},
         ];
      
      public static const mEntityTaskStatusList:Array = [
            {label:"Failed", data:ValueDefine.LevelStatus_Failed},
            {label:"Succeeded", data:ValueDefine.LevelStatus_Successed},
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
            {label:"0", data:KeyCodes.Key_0},
            {label:"1", data:KeyCodes.Key_1},
            {label:"2", data:KeyCodes.Key_2},
            {label:"3", data:KeyCodes.Key_3},
            {label:"4", data:KeyCodes.Key_4},
            {label:"5", data:KeyCodes.Key_5},
            {label:"6", data:KeyCodes.Key_6},
            {label:"7", data:KeyCodes.Key_7},
            {label:"8", data:KeyCodes.Key_8},
            {label:"9", data:KeyCodes.Key_9},
            {label:"A", data:KeyCodes.Key_A},
            {label:"B", data:KeyCodes.Key_B},
            {label:"C", data:KeyCodes.Key_C},
            {label:"D", data:KeyCodes.Key_D},
            {label:"E", data:KeyCodes.Key_E},
            {label:"F", data:KeyCodes.Key_F},
            {label:"G", data:KeyCodes.Key_G},
            {label:"H", data:KeyCodes.Key_H},
            {label:"I", data:KeyCodes.Key_I},
            {label:"J", data:KeyCodes.Key_J},
            {label:"K", data:KeyCodes.Key_K},
            {label:"L", data:KeyCodes.Key_L},
            {label:"M", data:KeyCodes.Key_M},
            {label:"N", data:KeyCodes.Key_N},
            {label:"O", data:KeyCodes.Key_O},
            {label:"P", data:KeyCodes.Key_P},
            {label:"Q", data:KeyCodes.Key_Q},
            {label:"R", data:KeyCodes.Key_R},
            {label:"S", data:KeyCodes.Key_S},
            {label:"T", data:KeyCodes.Key_T},
            {label:"U", data:KeyCodes.Key_U},
            {label:"V", data:KeyCodes.Key_V},
            {label:"W", data:KeyCodes.Key_W},
            {label:"X", data:KeyCodes.Key_X},
            {label:"Y", data:KeyCodes.Key_Y},
            {label:"Z", data:KeyCodes.Key_Z},
            {label:"Left", data:Keyboard.LEFT},
            {label:"Right", data:Keyboard.RIGHT},
            {label:"Top", data:Keyboard.UP},
            {label:"Down", data:Keyboard.DOWN},
            {label:"Space", data:Keyboard.SPACE},
            {label:"Backspace", data:Keyboard.BACKSPACE},
            {label:";", data:KeyCodes.Semicolon},
            {label:",", data:KeyCodes.Comma},
            {label:"=", data:KeyCodes.Add},
            {label:"-", data:KeyCodes.Subtract},
            {label:".", data:KeyCodes.Period},
            {label:"/", data:KeyCodes.Slash},
            {label:"\\", data:KeyCodes.BackSlash},
            {label:"' Quote", data:KeyCodes.Quote},
            {label:"` BackQuote", data:KeyCodes.BackQuote},
            {label:"[", data:KeyCodes.SquareBracketLeft},
            {label:"]", data:KeyCodes.SquareBracketRight},
            {label:"Caps Lock", data:Keyboard.CAPS_LOCK},
            {label:"Tab", data:Keyboard.TAB},
            {label:"Enter", data:Keyboard.ENTER},
            {label:"Insert", data:Keyboard.INSERT},
            {label:"Delete", data:Keyboard.DELETE},
            {label:"Home", data:Keyboard.HOME},
            {label:"End", data:Keyboard.END},
            {label:"Page Up", data:Keyboard.PAGE_UP},
            {label:"Page Down", data:Keyboard.PAGE_DOWN},
            {label:"Left Mouse Button", data:KeyCodes.LeftMouseButton},
         ];
      
      public static const mRngMethodList:Array = [
            {label:"Mersenne Twister", data:Define.RngMethod_MersenneTwister},
         ];
      
      public static const mRngIdList:Array = [
            {label:"Random Number Generator Slot 0", data:0},
            {label:"Random Number Generator Slot 1", data:1},
            {label:"Random Number Generator Slot 2", data:2},
            {label:"Random Number Generator Slot 3", data:3},
         ];
   }
}
