package editor.trigger {
   
   import common.trigger.FunctionTypeDefine;
   
   public class FunctionDeclaration_Custom extends FunctionDeclaration
   {
      public function FunctionDeclaration_Custom (id:int, name:String, description:String = null, 
                                                poemCallingFormat:String = null, traditionalCallingFormat:String = null, 
                                                inputDefinitions:Array = null, returnDefinitions:Array = null, 
                                                showUpInApiMenu:Boolean = true)
      {
         super (id, name, description, poemCallingFormat, traditionalCallingFormat, inputDefinitions, null, showUpInApiMenu);
      }
      
      override public function GetType ():int 
      {
         return FunctionTypeDefine.FunctionType_Custom;
      }
      
   //=======================================================
   // todo: for custom function declatations and definitions
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

