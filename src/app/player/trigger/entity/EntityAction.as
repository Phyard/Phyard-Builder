package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Logic;
   
   import common.trigger.define.CommandListDefine;
   
   public class EntityAction extends EntityLogic
   {
      public var mActionFunctionDefinition:FunctionDefinition_Logic;
      
      public function EntityAction (world:World)
      {
         super (world);
      }
      
      override public function BuildFromParams (params:Object, updateAppearance:Boolean = true):void
      {
         super.BuildFromParams (params, false);
         
         mActionFunctionDefinition = new FunctionDefinition_Logic (TriggerEngine.GetVoidFunctionDeclaration  ());
      }
      
      public function SetCommandListDefine (commandListDefine:CommandListDefine):void
      {
         if (mActionFunctionDefinition != null) // should not be null
            mActionFunctionDefinition.SetCommandListDefine (commandListDefine);
      }
      
   }
}