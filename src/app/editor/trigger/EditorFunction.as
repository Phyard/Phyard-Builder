package editor.trigger {
   
   public class Command
   {
      private var mValidateParamValues:Array = null;
      
      public function Command (commandDefine:CommandDefine:void
      {
         mCommandDefine = commandDefine;
      }
      
      public function SetParamValues (paramValues:Array):void
      {
         super.SetParamValues (paramValues);
         
         mValidateParamValues = null;
      }
      
      private function ValidateParamValues ():void
      {
         if (mValidateParamValues == null)
         {
            mValidateParamValues = new Array (mParams.length);
            
            for (var i:int = 0; i < mParams.length; ++ i)
            {
               mValidateParamValues [i] = mParams [i].GetValidatedValue ();
            }
         }
      }
      
      public function Execute (params:Array):Array
      {
         if (mCallback == null)
            return;
         
         ValidateParamValues ();
         
         return mCallback.apply (null, mValidateParamValues);
      }
   }
}

