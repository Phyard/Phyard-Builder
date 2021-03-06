package editor.trigger {
   
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   import editor.world.World;
   import editor.entity.Scene;
   
   import editor.EditorContext;
   
   import common.trigger.CoreFunctionIds;
   
   import common.Define;
   import common.CoordinateSystem;
   
   public class CodeSnippet
   {
      protected var mOwnerFunctionDefinition:FunctionDefinition = null;
      
      protected var mName:String = "";
      
      protected var mFunctionCallings:Array = new Array ();
      
      public function CodeSnippet (ownerFunctionDefinition:FunctionDefinition = null)
      {
         mOwnerFunctionDefinition = ownerFunctionDefinition;
      }
      
      public function GetOwnerFunctionDefinition ():FunctionDefinition
      {
         return mOwnerFunctionDefinition;
      }
      
      public function SetName (newName:String):void
      {
         if (newName == null)
            newName = "";
         
         if (newName.length > Define.MaxLogicComponentNameLength)
            newName = newName.substr (0, Define.MaxLogicComponentNameLength);
         
         mName = newName;
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function ClearFunctionCallings ():void
      {
         mFunctionCallings.splice (0, mFunctionCallings.length);
      }
      
      public function AssignFunctionCallings (funcCallings:Array):void
      {
         if (funcCallings == null)
            funcCallings = new Array ();
         
         mFunctionCallings = funcCallings;
      }
      
      public function AddFunctionCalling (funcCalling:FunctionCalling):void
      {
         mFunctionCallings.push (funcCalling);
      }
      
      public function GetNumFunctionCallings ():int
      {
         return mFunctionCallings.length;
      }
      
      public function GetFunctionCallingAt (index:int):FunctionCalling
      {
         if (index < 0 || index >= mFunctionCallings.length)
            return null;
         
         return mFunctionCallings [index];
      }
      
      public function ValidateValueSourcesAndTargets ():void
      {
         var func_calling:FunctionCalling;
         for (var i:int = 0; i < mFunctionCallings.length; ++ i)
         {
            func_calling = mFunctionCallings [i] as FunctionCalling;
            if (func_calling != null)
            {
               func_calling.ValidateValueSourcesAndTargets ();
            }
         }
      }
      
      public function ValidateCallings ():void
      {
         mOwnerFunctionDefinition.GetLocalVariableSpace ().Validate ();
         if (mOwnerFunctionDefinition.GetFunctionDeclaration () is FunctionDeclaration_Custom)
         {
            mOwnerFunctionDefinition.GetFunctionDeclaration ().GetInputVariableSpace ().Validate ();
            mOwnerFunctionDefinition.GetFunctionDeclaration ().GetOutputVariableSpace ().Validate ();
         }
         
         var func_calling:FunctionCalling;
         for (var i:int = mFunctionCallings.length - 1; i >= 0 ; -- i)
         {
            func_calling = mFunctionCallings [i] as FunctionCalling;
            if (func_calling != null)
            {
               if (func_calling.Validate ()) // removed already
               {
                   mFunctionCallings [i] = new FunctionCalling_Core (/*EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine (), */World.GetPlayerCoreFunctionDeclarationById (CoreFunctionIds.ID_Removed), true);
               }
            }
         }
      }
      
//====================================================================
//
//====================================================================
      
      public function CopyCallingsFrom (scene:Scene, sameAsSourceScene:Boolean, codeSnippet:CodeSnippet, insertAt:int = 0, callingIds:Array = null):void
      {
         if (codeSnippet == null)
            return;
         
         var i:int;
         var count:int = codeSnippet.GetNumFunctionCallings ();
         
         if (callingIds == null)
         {
            callingIds = new Array (count);
            
            for (i = 0; i < count; ++ i)
               callingIds [i] = i;
         }
         
         var num:int = callingIds.length;
         
         var callingId:int;
         var clonedCallings:Array = new Array (callingIds.length);
         var clonedCount:int = 0;
         
         for (i = 0; i < num; ++ i)
         {
            callingId = callingIds [i];
            if (callingId >= 0 && callingId < count)
            {
               clonedCallings [clonedCount ++] = codeSnippet.GetFunctionCallingAt (callingId).Clone (scene, sameAsSourceScene, mOwnerFunctionDefinition);
            }
         }
         
         if (insertAt < 0)
            insertAt = 0;
         else if (insertAt > mFunctionCallings.length)
            insertAt = mFunctionCallings.length;
         
         for (i = 0; i < clonedCount; ++ i)
            mFunctionCallings.splice (insertAt ++, 0, clonedCallings [i]);
      }
      
//====================================================================
//
//====================================================================
      
      public function Clone (scene:Scene, sameAsSourceScene:Boolean, ownerFunctionDefinition:FunctionDefinition, callingIds:Array = null):CodeSnippet
      {
         ValidateCallings ();
         
         if (ownerFunctionDefinition == null)
            ownerFunctionDefinition = mOwnerFunctionDefinition;
         
         var codeSnippet:CodeSnippet = new CodeSnippet (ownerFunctionDefinition);
         
         codeSnippet.SetName (mName);
         
         codeSnippet.CopyCallingsFrom (scene, sameAsSourceScene, this, 0, callingIds);
         if (ownerFunctionDefinition.IsCustom ())
         {
            //ownerFunctionDefinition.SybchronizeDeclarationWithDefinition ();
            ownerFunctionDefinition.NotifyModified ();
         }
         
         return codeSnippet;
      }
      
      public function DisplayValues2PhysicsValues (coordinateSystem:CoordinateSystem):void
      {
         var i:int;
         var num:int = mFunctionCallings.length;
         for (i = 0; i < num; ++ i)
         {
           (mFunctionCallings [i] as FunctionCalling).DisplayValues2PhysicsValues (coordinateSystem);
         }
      }
      
      public function PhysicsValues2DisplayValues (coordinateSystem:CoordinateSystem):void
      {
         var i:int;
         var num:int = mFunctionCallings.length;
         for (i = 0; i < num; ++ i)
         {
           (mFunctionCallings [i] as FunctionCalling).PhysicsValues2DisplayValues (coordinateSystem);
         }
      }
      
      public function AdjustNumberPrecisions ():void
      {
         var i:int;
         var num:int = mFunctionCallings.length;
         for (i = 0; i < num; ++ i)
         {
           (mFunctionCallings [i] as FunctionCalling).AdjustNumberPrecisions ();
         }
      }
      
//====================================================================
//
//====================================================================
      
      public function ConvertRegisterVariablesToGlobalVariables (scene:Scene):void
      {
         var num:int = mFunctionCallings.length;
         for (var i:int = 0; i < num; ++ i)
         {
           (mFunctionCallings [i] as FunctionCalling).ConvertRegisterVariablesToGlobalVariables (scene);
         }
      }
   }
}

