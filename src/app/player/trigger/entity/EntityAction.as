package player.trigger.entity
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.FunctionDefinition_Custom;
   
   import common.trigger.define.CodeSnippetDefine;
   import common.trigger.define.FunctionDefine;
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
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
            if (entityDefine.mFunctionDefine != undefined)
            {
               // ! clone is important
               var codeSnippetDefine:CodeSnippetDefine = ((entityDefine.mFunctionDefine as FunctionDefine).mCodeSnippetDefine as CodeSnippetDefine).Clone ();
               codeSnippetDefine.DisplayValues2PhysicsValues (mWorld.GetCoordinateSystem ());
               
               mVoidFunctionDefinition = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (mWorld, entityDefine.mFunctionDefine, TriggerEngine.GetVoidFunctionDeclaration  ());
               mVoidFunctionDefinition.SetCodeSnippetDefine (mWorld, codeSnippetDefine, extraInfos);
            }
         }
      }
            
//=============================================================
//   as action
//=============================================================
      
      public function Perform ():void
      {
         mVoidFunctionDefinition.DoCall (mWorld.GetFunctionCallingContext (), null, null);
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
