package player.trigger {
   
   public class PlayerCommandDefine
   {
      public var mParamValueTypes:Array; // ValueTypes
      
      // for api
      public var mCallback:Function;
      
      // for custom function
      public var mCustomFunction:CustomFunction;
      
      public function PlayerFunctionDefine (callback:Function, paramValueTypes:Array = null):void
      {
         mCallback = callback;
         
         mParamValueTypes = paramValueTypes;
      }
      
      public function ValidateParams (rawParams:Array):void
      {
      }
      
      public function ValidateParamValues (rawParamValues:Array, paramId:int):void
      {
      }
      
      public function Execute (validatedParams:Array, context:TriggerContext):Array
      {
         if (mCallback == null)
            return;
         
         return mCallback.apply (null, validatedParams);
         
         mCustomFunction.
      }
   }
}

