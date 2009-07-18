
package player.trigger {
   
   import player.entity.Entity;
   import player.entity.EntityShape;
   
   import common.trigger.ValueDefine;
   import common.trigger.PlayerCommandIds;
   
   public class PlayerCommandDefinesForPlaying
   {
      
      private static var sCommands:Array = new Array (128);
      
      public static function Initialize ():void
      {
      // system
      
      // world
      
      // entity
      
         // shape
            RegisterCommandDefine (PlayerCommandIds.CommandId_SetShapeDensity, SetShapeDensity, [ValueDefine.ValueType_Float]);
            
      }
      
//===========================================================
// util functions
//===========================================================
      
      private static function RegisterCommandDefine (command_id:int, callback:Function, param_defines:Array):void
      {
         if (command_id < 0)
            return;
         
         var command_def:PlayerCommand = new PlayerCommandDefine (callback, param_defines);
         sCommandDefines [command_id] = command_def;
      }
      
      public static function GetCommandById (commandId:int):PlayerCommandDefine
      {
         if (commandId < 0 || commandId >= sCommands.length)
            return null;
         
         return sCommandDefines [commandId];
      }
      
      public static function ExecuteCommand (commandId, paramValues:Array):void
      {
         var command_def:PlayerCommandDefine = GetCommandById (commandId);
         if (command_def == null)
            return;
         
         command_def.ValidateParamValues (paramValues);
         command_def.Execute (paramValues);
      }
      
//===========================================================
// command functions
//===========================================================
      
      public static function SetShapeDensity (shape:Entity, density:Number):void
      {
         if (shape is EntityShape)
         {
            
         }
      }
      
   }
}
