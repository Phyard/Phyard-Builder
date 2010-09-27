package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Custom;
   
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.ValueDefine;
   
   import common.TriggerFormatHelper2;
   
   public class EntityAction extends EntityLogic implements ScriptHolder
   {
      public var mVoidFunctionDefinition:FunctionDefinition_Custom;
      public var mName:String = null;
      
      public function EntityAction (world:World)
      {
         super (world);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mFunctionDefine != undefined)
            {
               mVoidFunctionDefinition = TriggerFormatHelper2.CreateFunctionDefinition (mWorld, entityDefine.mFunctionDefine, TriggerEngine.GetVoidFunctionDeclaration  ());
            }
            
         }
      }
            
//=============================================================
//   as action
//=============================================================
      
      public function Perform ():void
      {
         mVoidFunctionDefinition.ExcuteAction ();
      }
      
//=============================================================
//   as ScriptHolder
//=============================================================
      
      public function RunScript ():void
      {
         Perform ();
      }
      
   }
}
