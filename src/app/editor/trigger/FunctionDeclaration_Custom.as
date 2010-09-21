package editor.trigger {
   
   import common.trigger.FunctionTypeDefine;
   
   public class FunctionDeclaration_Custom extends FunctionDeclaration
   {
      protected var mRemoved:Boolean = false;
      
      public function FunctionDeclaration_Custom (name:String)
      {
         //super (id, name, description, inputDefinitions, outputDefinitions, showUpInApiMenu);
         super (0, name, "", null, null, true);
         
         //ParseAllCallingTextSegments (poemCallingFormat, traditionalCallingFormat);
      }
      
      override public function GetType ():int
      {
         return FunctionTypeDefine.FunctionType_Custom;
      }
      
      public function IsRemoved ():Boolean
      {
         return mRemoved;
      }
      
      public function NotifyRemoved ():void
      {
         mRemoved = true;
      }
      
      public function SetID (id:int):void
      {
         mId = id;
      }
      
      public function SetName (name:String):void
      {
         mName = name;
      }
      
      public function SetDescription (description:String):void
      {
         mDescription = description;
      }
      
      public function SetInputParamDefinitions (inputDefinitions:Array):void
      {
         mInputParamDefinitions = inputDefinitions;
      }
      
      public function SetOutputParamDefinitions (outputDefinitions:Array):void
      {
         mOutputParamDefinitions = outputDefinitions;
      }
      
   //======================
      
      protected var mNumModifiedTimes:int = 0;
      
      public function GetNumModifiedTimes ():int
      {
         return mNumModifiedTimes;
      }
      
      public function IncreaseModifiedTimes ():void
      {
         ++ mNumModifiedTimes;
      }
   }
}

