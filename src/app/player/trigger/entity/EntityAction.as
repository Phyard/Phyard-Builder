package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Logic;
   import player.trigger.ValueTarget_BooleanReturn;
   
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.ValueDefine;
   
   public class EntityAction extends EntityLogic
   {
      public var mVoidFunctionDefinition:FunctionDefinition_Logic;
      public var mName:String = null;
      
      public function EntityAction (world:World)
      {
         super (world);
         
         mVoidFunctionDefinition = new FunctionDefinition_Logic (TriggerEngine.GetVoidFunctionDeclaration  ());
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mName != undefined)
               mName = entityDefine.mName;
            
            if (entityDefine.mCodeSnippetDefine != undefined)
            {
               var codeSnippetDefine:CodeSnippetDefine = entityDefine.mCodeSnippetDefine.Clone ();
               codeSnippetDefine.DisplayValues2PhysicsValues (mWorld.GetCoordinateSystem ());
               mVoidFunctionDefinition.SetCodeSnippetDefine (codeSnippetDefine);
            }
         }
      }
            
//=============================================================
//   as action
//=============================================================
      
      public function Excute ():void
      {
         mVoidFunctionDefinition.ExcuteAction ();
      }
      
   }
}
