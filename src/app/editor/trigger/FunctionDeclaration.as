package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import common.trigger.ValueTypeDefine;
   
   public class FunctionDeclaration
   {
      protected var mId:int;
      protected var mName:String;
      
      protected var mReturnValueType:int;
      
      private var mDescription:String = null;
      
      protected var mParamDefinitions:Array; // input variable defines
      
      public function FunctionDeclaration (id:int, name:String, paramDefinitions:Array = null, description:String = null, returnValueType:int=0) //ValueTypeDefine.ValueType_Void)
      {
         mId = id;
         mName = name;
         mDescription = description;
         mParamDefinitions = paramDefinitions;
         
         mReturnValueType = returnValueType;
      }
      
      public function GetID ():int
      {
         return mId;
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function GetReturnValueType ():int
      {
         return mReturnValueType;
      }
      
      public function GetDescription ():String
      {
         return mDescription;
      }
      
      public function GetNumParameters ():int
      {
         if (mParamDefinitions == null)
            return 0;
         
         return mParamDefinitions.length;
      }
      
      public function GetParamDefinitionAt (defId:int):VariableDefinition
      {
         if (mParamDefinitions == null)
            return null;
         
         if (defId < 0 || defId >= mParamDefinitions.length)
            return null;
         
         return mParamDefinitions [defId];
      }
      
   //=======================================================
   // for custom function declatations and definitions
   //=======================================================
      
      public function InsertParamDefinition ():void
      {
      }
      
      public function DeleteParamDefinition ():void
      {
      }
      
      public function ChangeParamDefinitionIndex ():void
      {
      }
      
      public function ReplaceParamDefinition ():void
      {
      }
      
      public function SetID ():void
      {
      }
      
      public function SetName ():void
      {
      }
      
      public function SetDescription ():void
      {
      }
      
   }
}

