package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   import editor.EditorContext;
   
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   import common.trigger.FunctionTypeDefine;
   import common.trigger.FunctionCoreBasicDefine;
   
   public class FunctionDeclaration
   {
      internal var mId:int;
      internal var mName:String;
      
      internal var mDescription:String = null;
      
      // before v2.05
      //internal var mInputParamDefinitions:Array; // input variable defines
      //internal var mOutputParamDefinitions:Array; // returns
      
      // since v2.05
      internal var mInputVariableSpace:VariableSpaceInput;
      internal var mOutputVariableSpace:VariableSpaceOutput;
      
      // 
      internal var mShowUpInApiMenu:Boolean = true;
      
      public function FunctionDeclaration (id:int, name:String, description:String = null, 
                                          //inputDefinitions:Array = null, returnDefinitions:Array = null, 
                                          //inputVariableSpace:VariableSpaceInput = null, outputVariableSpace:VariableSpaceOutput = null,
                                          showUpInApiMenu:Boolean = true)
      {
         mId = id;
         mName = name;
         mDescription = description;
         
         mShowUpInApiMenu = showUpInApiMenu;
         
         if (mName == null)
            mName = "";
         
         //mInputParamDefinitions = inputDefinitions;
         //mOutputParamDefinitions = returnDefinitions;
         
         //mInputVariableSpace = inputVariableSpace;
         //if (mInputVariableSpace == null)
            mInputVariableSpace = new VariableSpaceInput ();
         
         //mOutputVariableSpace = outputVariableSpace;
         //if (mOutputVariableSpace == null)
            mOutputVariableSpace = new VariableSpaceOutput ();
      }
      
      public function ParseAllCallingTextSegments (poemCallingFormat:String = null, traditionalCallingFormat:String = null):void
      {
         if (poemCallingFormat == null || poemCallingFormat.length == 0)
         {
            poemCallingFormat = mName;
         }
         
         mPoemCallingTextSegments = ParseCallingTextSegments (poemCallingFormat);
         
         if (traditionalCallingFormat == null || traditionalCallingFormat.length == 0)
         {
            var pattern:RegExp = /[\s]*/g;
            traditionalCallingFormat = mName.replace(pattern, "");
            pattern = /[\?]*/g;
            traditionalCallingFormat = traditionalCallingFormat.replace(pattern, "");
         }
         
         mTraditionalCallingTextSegments = ParseCallingTextSegments (traditionalCallingFormat);
      }
      
      public function GetID ():int
      {
         return mId;
      }
      
      // todo: chagne to GetFunctionType
      public function GetType ():int 
      {
         return FunctionTypeDefine.FunctionType_Unknown;
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function GetDescription ():String
      {
         return mDescription;
      }
      
      public function IsShowUpInApiMenu ():Boolean
      {
         return mShowUpInApiMenu;
      }
      
      public function GetNumOutputs ():int
      {
         //if (mOutputParamDefinitions == null)
         //   return 0;
         //
         //return mOutputParamDefinitions.length;
         
         return mOutputVariableSpace.GetNumVariableInstances ();
      }
      
      public function GetOutputParamDefinitionAt (returnId:int):VariableDefinition
      {
         //if (mOutputParamDefinitions == null)
         //   return null;
         //
         //if (returnId < 0 || returnId >= mOutputParamDefinitions.length)
         //   return null;
         //
         //return mOutputParamDefinitions [returnId];
         
         return mOutputVariableSpace.GetVariableInstanceAt (returnId).GetVariableDefinition ();
      }
      
      public function GetOutputParamClassType (returnId:int):int
      {
         var vd:VariableDefinition = GetOutputParamDefinitionAt (returnId);
         
         // commented off since v2.05
         //if (vd == null)
         //   return ClassTypeDefine.ClassType_Unknown;
         
         return vd.GetClassType ();
      }
      
      public function GetOutputParamValueType (returnId:int):int
      {
         var vd:VariableDefinition = GetOutputParamDefinitionAt (returnId);
         
         // commented off since v2.05
         //if (vd == null)
         //   return CoreClassIds.ValueType_Void;
         
         return vd.GetValueType ();
      }
      
      public function GetOutputVariableSpace ():VariableSpaceOutput
      {
         return mOutputVariableSpace;
      }
      
      public function GetInputVariableSpace ():VariableSpaceInput
      {
         return mInputVariableSpace;
      }
      
      public function GetNumInputs ():int
      {
         //if (mInputParamDefinitions == null)
         //   return 0;
         //
         //return mInputParamDefinitions.length;
         
         return mInputVariableSpace.GetNumVariableInstances ();
      }
      
      public function GetInputParamDefinitionAt (inputId:int):VariableDefinition
      {
         //if (mInputParamDefinitions == null)
         //   return null;
         //
         //if (inputId < 0 || inputId >= mInputParamDefinitions.length)
         //   return null;
         //
         //return mInputParamDefinitions [inputId];
         
         return mInputVariableSpace.GetVariableInstanceAt (inputId).GetVariableDefinition ();
      }
      
      public function GetInputParamClassType (inputId:int):int
      {
         var vd:VariableDefinition = GetInputParamDefinitionAt (inputId);
         
         // commented off since v2.05
         //if (vd == null)
         //   return ClassTypeDefine.ClassType_Unknown;
         
         return vd.GetClassType ();
      }
      
      public function GetInputParamValueType (inputId:int):int
      {
         var vd:VariableDefinition = GetInputParamDefinitionAt (inputId);
         
         // commented off since v2.05
         //if (vd == null)
         //   return CoreClassIds.ValueType_Void;
         
         return vd.GetValueType ();
      }
      
      //public function HasInputsWithValueTypeOf (valueType:int):Boolean
      //{
      //   if (mInputParamDefinitions == null)
      //      return false;
      //   
      //   for (var i:int = 0; i < mInputParamDefinitions.length; ++ i)
      //   {
      //      if (GetInputParamValueType (i) == valueType)
      //         return true;
      //   }
      //   
      //   return false;
      //}
      
      //public function HasInputsSatisfy (variableDefinition:VariableDefinition):Boolean
      //{
      //   if (mInputParamDefinitions != null)
      //   {
      //      for (var i:int = 0; i < mInputParamDefinitions.length; ++ i)
      //      {
      //         if (GetInputParamDefinitionAt (i).IsCompatibleWith (variableDefinition) || variableDefinition.IsCompatibleWith (GetInputParamDefinitionAt (i)))
      //            return true;
      //      }
      //   }
      //   
      //   return false;
      //}
      
      // edit at v2.05: why this function? Maybe for sometimes, the variable definitions in Declaration adn Definition are not synchronized.
      //                so under the later new implementation, this function may be not essential.
      // or, it is for the variable definition in declaration is more detail than the spaces in function definition?
      //                seems this claim is not valid now. So it is safe the remvoe this function?
      //public function GetInputVariableIndexesSatisfy (variableDefinition:VariableDefinition):Array
      //{
      //   var indexes:Array = new Array ();
      //   
      //   if (mInputParamDefinitions != null)
      //   {
      //      for (var i:int = 0; i < mInputParamDefinitions.length; ++ i)
      //      {
      //         if (GetInputParamDefinitionAt (i).IsCompatibleWith (variableDefinition) || variableDefinition.IsCompatibleWith (GetInputParamDefinitionAt (i)))
      //         {
      //            indexes.push (i);
      //         }
      //      }
      //   }
      //   
      //   return indexes;
      //}
      
      //public function HasOutputsSatisfiedBy (variableDefinition:VariableDefinition):Boolean
      //{
      //   if (mOutputParamDefinitions != null)
      //   {
      //      for (var i:int = 0; i < mOutputParamDefinitions.length; ++ i)
      //      {
      //         if (variableDefinition.IsCompatibleWith (GetOutputParamDefinitionAt (i)))
      //            return true;
      //      }
      //   }
      //   
      //   return false;
      //}
      
      //public function GetOutputVariableIndexesSatisfiedBy (variableDefinition:VariableDefinition):Array
      //{
      //   var indexes:Array = new Array ();
      //   
      //   if (mOutputParamDefinitions != null)
      //   {
      //      for (var i:int = 0; i < mOutputParamDefinitions.length; ++ i)
      //      {
      //         if (variableDefinition.IsCompatibleWith (GetOutputParamDefinitionAt (i)))
      //            indexes.push (i);
      //      }
      //   }
      //   
      //   return indexes;
      //}

      public function AddInputVariableFromDefinitions (variableDefinitions:Array):void
      {
         if (variableDefinitions == null)
            return;
          
         var num:int = variableDefinitions.length;
         for (var j:int = 0; j < num; ++ j)
         {
            mInputVariableSpace.CreateVariableInstanceFromDefinition (null, variableDefinitions [j] as VariableDefinition);
         }
      }

      public function AddOutputVariableFromDefinitions (variableDefinitions:Array):void
      {
         if (variableDefinitions == null)
            return;
          
         var num:int = variableDefinitions.length;
         for (var j:int = 0; j < num; ++ j)
         {
            mOutputVariableSpace.CreateVariableInstanceFromDefinition (null, variableDefinitions [j] as VariableDefinition);
         }
      }
      
//=================================================================
// some to override
//=================================================================
      
      //public function IsSupportLocalVariables ():Boolean
      //{
      //   return false;
      //}
      
      //public function IsSupportParameters ():Boolean // input and output
      //{
      //   return false;
      //}
      
//=================================================================
//
//=================================================================
      
      public function GetInputNumberTypeDetail (inputId:int):int
      {
         return CoreClassIds.NumberTypeDetail_Double;
      }
      
      public function GetInputNumberTypeUsage (inputId:int):int
      {
         return CoreClassIds.NumberTypeUsage_General;
      }
      
//=================================================================
//
//=================================================================
      
      // check core APIs
      
      protected function CheckConsistent (coreDelcaration:FunctionCoreBasicDefine):String
      {
         if (coreDelcaration == null)
            return "delc is null";
         
         if ( mId != coreDelcaration.GetID ())
            return "id not equals";
         
         var num_inputs:int = coreDelcaration.GetNumInputs ();
         
         //if ((mInputParamDefinitions == null && num_inputs != 0) || (mInputParamDefinitions != null && num_inputs == 0))
         if (GetNumInputs () != num_inputs)
            return "number of inputs is wrong!";
         
         var i:int;
         
         //if (mInputParamDefinitions != null && num_inputs != 0)
         //{
         //   if (mInputParamDefinitions.length != num_inputs)
         //      return "numInputs wrong";
         //   
            for (i = 0; i < num_inputs; ++ i)
            {
               if (GetInputParamValueType (i) != coreDelcaration.GetInputParamValueType (i))
                  return "input#" + i + " is wrong";
            }
         //}
         
         var num_outputs:int = coreDelcaration.GetNumOutputs ();
         
         //if ((mOutputParamDefinitions == null && num_outputs != 0) || (mOutputParamDefinitions != null && num_outputs == 0))
         if (GetNumOutputs () != num_outputs)
            return "number of outputs is wrong";
         
         //if (mOutputParamDefinitions != null && num_outputs != 0)
         //{
         //   if (mOutputParamDefinitions.length != num_outputs)
         //      return "numOutputs wrong";
         //   
            for (i = 0; i < num_outputs; ++ i)
            {
               if (GetOutputParamValueType (i) != coreDelcaration.GetOutputParamValueType (i))
                  return "ouput#" + i + " is wrong";
            }
         //}
         
         return null; // no problems
      }
      
//==========================================================================================
// calling format
//==========================================================================================
      
      protected var mPoemCallingTextSegments:Array;
      protected var mTraditionalCallingTextSegments:Array;
      
      private static const kSegmentType_PlainText:int = 0;
      private static const kSegmentType_InputParam:int = 1;
      private static const kSegmentType_OutputParam:int = 2;
      
      private static const kAtCharCode:int = "@".charCodeAt (0);
      private static const kZeroCharCode:int = "0".charCodeAt (0);
      private static const kNineCharCode:int = "9".charCodeAt (0);
      
      private function ParseCallingTextSegments (callingForamtText:String):Array
      {
         var textSegments:Array = new Array ();
         
         if (callingForamtText.charCodeAt (0) == kAtCharCode)
         {
            if (ParseCallingFormatText (textSegments, callingForamtText, 1))
            {
               textSegments.unshift (new Array (kSegmentType_PlainText, " = "));
               
               InsertDefaultValueTargetSegmentsAt (textSegments, 0);
            }
         }
         else
         {
            InsertDefaultValueSourceSegmentsAt (textSegments, 0);
            
            if (GetNumOutputs () > 0)
            {
               textSegments.unshift (new Array (kSegmentType_PlainText, " = " + callingForamtText + " "));
               InsertDefaultValueTargetSegmentsAt (textSegments, 0);
            }
            else
            {
               textSegments.unshift (new Array (kSegmentType_PlainText, callingForamtText + " "));
            }
         }
         
         return textSegments;
      }
      
      private function InsertDefaultValueSourceSegmentsAt (textSegments:Array, insertAt:int):void
      {
         var i:int = GetNumInputs ();
         
         if (i == 0)
         {
            textSegments.splice (insertAt, null, new Array (kSegmentType_PlainText, "()"));
         }
         else
         {
            textSegments.splice (insertAt, null, new Array (kSegmentType_PlainText, ")"));
            while (-- i > 0)
            {
               textSegments.splice (insertAt, null, new Array (kSegmentType_InputParam, i));
               textSegments.splice (insertAt, null, new Array (kSegmentType_PlainText, ", "));
            }
            textSegments.splice (insertAt, null, new Array (kSegmentType_InputParam, i));
            textSegments.splice (insertAt, null, new Array (kSegmentType_PlainText, "("));
         }
      }
      
      private function InsertDefaultValueTargetSegmentsAt (textSegments:Array, insertAt:int):void
      {
         var i:int = GetNumOutputs ();
         if (i == 0)
         {
            return;
         }
         else if (i == 1)
         {
            textSegments.splice (insertAt, null, new Array (kSegmentType_OutputParam, 0));
         }
         else
         {
            textSegments.splice (insertAt, null, new Array (kSegmentType_PlainText, "}"));
            while (-- i > 0)
            {
               textSegments.splice (insertAt, null, new Array (kSegmentType_OutputParam, i));
               textSegments.splice (insertAt, null, new Array (kSegmentType_PlainText, ", "));
            }
            textSegments.splice (insertAt, null, new Array (kSegmentType_OutputParam, i));
            textSegments.splice (insertAt, null, new Array (kSegmentType_PlainText, "{"));
         }
      }
      
      // return: whether or not to used the defalut value target formatting
      private function ParseCallingFormatText (textSegments:Array, callingForamtText:String, startIndex:int):Boolean
      {
         var hasTargetRegExp:Boolean = false;
         
         var len:int = callingForamtText.length;
         
         var posDollar:int = 0;
         var posAnd:int = 0;
         
         var id:int;
         var isTarget:Boolean;
         
         var charIndex:int;
         var charCode:int;
         
         var lastPos:int;
         var currentPos:int = startIndex;
         
         while (currentPos < len)
         {
            if (posDollar == 0)
               posDollar = callingForamtText.indexOf ("$", currentPos);
            if (posAnd == 0)
               posAnd = callingForamtText.indexOf ("#", currentPos);
            
            if (posDollar < 0)
               posDollar = len;
            if (posAnd < 0)
               posAnd = len;
            
            lastPos = currentPos;
            
            if (posDollar == posAnd) // == len
            {
               textSegments.push (new Array (kSegmentType_PlainText, callingForamtText.substring (currentPos)));
               currentPos = len;
            }
            else
            {
               if (posDollar < posAnd)
               {
                  isTarget = false;
                  currentPos = posDollar;
                  posDollar = 0;
               }
               else // if (posDollar > posAnd)
               {
                  isTarget = true;
                  currentPos = posAnd;
                  posAnd = 0;
               }
               
               id = 0;
               charIndex = currentPos;
               
               while (++ charIndex < len)
               {
                  charCode = callingForamtText.charCodeAt (charIndex);
                  if (charCode >= kZeroCharCode && charCode <= kNineCharCode)
                  {
                     id = id * 10 + (charCode - kZeroCharCode);
                  }
                  else
                  {
                     break;
                  }
               }
               
               if (charIndex > currentPos + 1)
               {
                  if (isTarget)
                  {
                     if (id >= GetNumOutputs ())
                     {
                        id = -1;
                     }
                     else
                     {
                        hasTargetRegExp = true;
                     }
                  }
                  else if (id >= GetNumInputs ())
                  {
                     id = -1;
                  }
               }
               else
               {
                  id = -1;
               }
               
               if (id >= 0)
               {
                  textSegments.push (new Array (kSegmentType_PlainText, callingForamtText.substring (lastPos, currentPos)));
                  
                  textSegments.push (new Array (isTarget ? kSegmentType_OutputParam : kSegmentType_InputParam, id));
                  
                  currentPos = charIndex;
               }
               else
               {
                  currentPos = charIndex;
                  
                  textSegments.push (new Array (kSegmentType_PlainText, callingForamtText.substring (lastPos, currentPos)));
               }
            }
         }
         
         if (currentPos < len)
         {
            textSegments.push (new Array (kSegmentType_PlainText, callingForamtText.substring (currentPos)));
         }
         
         return GetNumOutputs () > 0 && (! hasTargetRegExp);
      }
      
      public function CreateFormattedCallingText (valueSources:Array, valueTargets:Array):String
      {
         var textSegments:Array = EditorContext.mPoemCodingFormat ? mPoemCallingTextSegments : mTraditionalCallingTextSegments;
         
         var len:int = textSegments.length;
         var segment:Array;
         
         var callingText:String = "";
         
         for (var i:int = 0; i < len; ++ i)
         {
            segment = textSegments [i];
            
            switch (segment [0])
            {
               case kSegmentType_InputParam:
                  callingText = callingText + (valueSources [segment [1]] as ValueSource).SourceToCodeString (GetInputParamDefinitionAt(segment [1]));
                  break;
               case kSegmentType_OutputParam:
                  callingText = callingText + (valueTargets [segment [1]] as ValueTarget).TargetToCodeString (GetOutputParamDefinitionAt(segment [1]));
                  break;
               case kSegmentType_PlainText:
                  callingText = callingText + segment [1];
                  break;
               default:
                  break;
            }
         }
         
         return callingText;
      }
   }
}
