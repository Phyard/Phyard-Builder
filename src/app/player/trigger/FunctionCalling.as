package player.trigger
{
   import common.trigger.ValueTypeDefine;
   import common.trigger.FunctionDeclaration;
   import common.CoordinateSystem;
   
   public class FunctionCalling
   {
      internal var mNextFunctionCalling:FunctionCalling = null;
      
   // .........
      
      protected var mFunctionDefinition:FunctionDefinition;
      protected var mInputValueSourceList:ValueSource;
      protected var mReturnValueTargetList:ValueTarget;
      
      public function FunctionCalling (functionDefinition:FunctionDefinition, valueSourceList:ValueSource, valueTargetList:ValueTarget)
      {
         mFunctionDefinition = functionDefinition;
         
         mInputValueSourceList = valueSourceList;
         mReturnValueTargetList = valueTargetList;
      }
      
      public function SetNextCalling (nextCalling:FunctionCalling):void
      {
         mNextFunctionCalling = nextCalling;
      }
      
      public function Call ():void
      {
         //trace ("FunctionCalling.Call");
         
         mFunctionDefinition.DoCall (mInputValueSourceList, mReturnValueTargetList);
      }
      
      // can optimize a bit
      //public function CallEventHandler ()
      
//====================================================================
//
//====================================================================
      
      public function DisplayValues2PhysicsValues (coordinateSystem:CoordinateSystem):void
      {
         var functionDeclaration:FunctionDeclaration = mFunctionDefinition.GetFunctionDeclaration ();
         
         var directSource:ValueSource_Direct;
         var directValue:Number;
         var valueType:int;
         var numberUsage:int;
         var i:int = 0;
         
         var source:ValueSource = mInputValueSourceList;
         while (source != null)
         {
            valueType = functionDeclaration.GetInputValueType (i);
            
            if (valueType == ValueTypeDefine.ValueType_Number && source is ValueSource_Direct)
            {
               directSource = source as ValueSource_Direct;
               directValue = Number (directSource.mValueObject);
               numberUsage = functionDeclaration.GetInputNumberTypeUsage (i);
               
               directSource.mValueObject = coordinateSystem.D2P (directValue, numberUsage);
            }
            
            ++ i;
            source = source.mNextValueSourceInList;
         }
      }
      
      public function PhysicsValues2DisplayValues (coordinateSystem:CoordinateSystem):void
      {
         var functionDeclaration:FunctionDeclaration = mFunctionDefinition.GetFunctionDeclaration ();
         
         var directSource:ValueSource_Direct;
         var directValue:Number;
         var valueType:int;
         var numberUsage:int;
         var i:int = 0;
         
         var source:ValueSource = mInputValueSourceList;
         while (source != null)
         {
            valueType = functionDeclaration.GetInputValueType (i);
            
            if (valueType == ValueTypeDefine.ValueType_Number && source is ValueSource_Direct)
            {
               directSource = source as ValueSource_Direct;
               directValue = Number (directSource.mValueObject);
               numberUsage = functionDeclaration.GetInputNumberTypeUsage (i);
               
               directSource.mValueObject = coordinateSystem.P2D (directValue, numberUsage);
            }
            
            ++ i;
            source = source.mNextValueSourceInList;
         }
      }
      
   }
}