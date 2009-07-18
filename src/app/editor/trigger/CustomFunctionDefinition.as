package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   public class CustomFunctionDefinition extends FunctionDefinition
   {
      public function CustomFunctionDefinition (name:String)
      {
         super (-1, mName, null);//, null);
      }
      
      public function SetId (id:int):void
      {
         mId = id;
      }
      
      public function ChangeName (newName:String):void
      {
         mName = newName;
      }
      
      public function AddParamDefine (paramDefine:ParamDefine):void
      {
         if (mParamDefines == null)
            mParamDefines = new Array ();
         
         mParamDefines.push (paramDefine);
      }
      
      //public function AddReturnDefine (returnDefine:VariableDefine):void
      //{
      //   if (mReturnDefines == null)
      //      mReturnDefines = new Array ();
      //   
      //   mReturnDefines.push (returnDefine);
      //}
      
      
      
   }
}

