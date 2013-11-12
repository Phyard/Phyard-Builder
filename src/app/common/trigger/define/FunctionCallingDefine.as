package common.trigger.define
{
   import common.trigger.FunctionCoreBasicDefine;
   import common.trigger.CoreFunctionDeclarations;
   
   import common.trigger.CoreClassIds;
   import common.trigger.FunctionTypeDefine;
   
   import common.CoordinateSystem;
   
   public class FunctionCallingDefine
   {
      public var mFunctionType:int;
      public var mFunctionId:int;
      
      public var mNumInputs:int;
      public var mInputValueSourceDefines:Array;
      
      public var mNumOutputs:int;
      public var mOutputValueTargetDefines:Array;
      
//====================================================================
//
//====================================================================
      
      public function Clone ():FunctionCallingDefine
      {
         var i:int;
         
         var callingDefine:FunctionCallingDefine = new FunctionCallingDefine ();
         
         callingDefine.mFunctionType = mFunctionType;
         callingDefine.mFunctionId = mFunctionId;
         
         callingDefine.mNumInputs = mNumInputs;
         callingDefine.mInputValueSourceDefines = new Array (mNumInputs);
         for (i = 0; i < mNumInputs; ++ i)
         {
            callingDefine.mInputValueSourceDefines [i] = (mInputValueSourceDefines [i] as ValueSourceDefine).Clone ();
         }
         
         callingDefine.mNumOutputs = mNumOutputs;
         callingDefine.mOutputValueTargetDefines = new Array (mNumOutputs);
         for (i = 0; i < mNumOutputs; ++ i)
         {
            callingDefine.mOutputValueTargetDefines [i] = (mOutputValueTargetDefines [i] as ValueTargetDefine).Clone ();
         }
         
         return callingDefine;
      }
      
//====================================================================
//
//====================================================================
      
      public function DisplayValues2PhysicsValues (coordinateSystem:CoordinateSystem):void
      {
         if (mFunctionType == FunctionTypeDefine.FunctionType_Core)
         {
            var functionDeclaration:FunctionCoreBasicDefine = CoreFunctionDeclarations.GetCoreFunctionDeclaration (mFunctionId);
            
            var sourceDefine:ValueSourceDefine;
            var directSourceDefine:ValueSourceDefine_Direct;
            var directValue:Number;
            var valueType:int;
            var numberUsage:int;
            
            for (var i:int = 0; i < mNumInputs; ++ i)
            {
               sourceDefine = mInputValueSourceDefines [i] as ValueSourceDefine;
               valueType = functionDeclaration.GetInputParamValueType (i);
               
               if (valueType == CoreClassIds.ValueType_Number && sourceDefine is ValueSourceDefine_Direct)
               {
                  directSourceDefine = sourceDefine as ValueSourceDefine_Direct;
                  directValue = Number (directSourceDefine.mValueObject);
                  numberUsage = functionDeclaration.GetInputNumberTypeUsage (i);
                  
                  directSourceDefine.mValueObject = coordinateSystem.D2P (directValue, numberUsage);
               }
            }
         }
      }
      
      public function PhysicsValues2DisplayValues (coordinateSystem:CoordinateSystem):void
      {
         if (mFunctionType == FunctionTypeDefine.FunctionType_Core)
         {
            var functionDeclaration:FunctionCoreBasicDefine = CoreFunctionDeclarations.GetCoreFunctionDeclaration (mFunctionId);
            
            var sourceDefine:ValueSourceDefine;
            var directSourceDefine:ValueSourceDefine_Direct;
            var directValue:Number;
            var valueType:int;
            var numberUsage:int;
            
            for (var i:int = 0; i < mNumInputs; ++ i)
            {
               sourceDefine = mInputValueSourceDefines [i] as ValueSourceDefine;
               valueType = functionDeclaration.GetInputParamValueType (i);
               
               if (valueType == CoreClassIds.ValueType_Number && sourceDefine is ValueSourceDefine_Direct)
               {
                  directSourceDefine = sourceDefine as ValueSourceDefine_Direct;
                  directValue = Number (directSourceDefine.mValueObject);
                  numberUsage = functionDeclaration.GetInputNumberTypeUsage (i);
                  
                  directSourceDefine.mValueObject = coordinateSystem.P2D (directValue, numberUsage);
               }
            }
         }
      }
      
   }
   
}