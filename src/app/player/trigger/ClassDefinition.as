package player.trigger
{
   import common.trigger.ClassTypeDefine;
   
   public class ClassDefinition
   {
      // these static values were defined in CoreClassesHub.as,
      // no errors in compiling.
      // but flash player reports runtime errors.
      // so move them here.
      
      // num
      public static const NumPrimitiveClasses:int = 3;
      
      // primitive classes
      public static const ValueConvertOrder_Boolean:int = 0; // 1;
      public static const ValueConvertOrder_Number:int = 1; // 0;
      public static const ValueConvertOrder_String:int = 2;

      // other non-promitive classes
      public static const ValueConvertOrder_Others:int = 3;
         
   //================================================
   
      public var mParentClasses:Array = null; // direct ones.
      public var mAncestorClasses:Array = null;
      public var mExtendOrder:int = 0; 
                  // an ancestor class's extend order must be smaller than its sub classes.
      
      public var mValueConvertFunctions:Array = new Array (NumPrimitiveClasses);
      public var mValueConvertOrder:int; 
                  // for compare API. higher will be converted to lower before comparing.
      
      public function SetParentClasses (parentClasses:Array):void
      {
         mParentClasses = parentClasses;
         
         mValueConvertFunctions [ValueConvertOrder_Boolean] = ToBoolean;
         mValueConvertFunctions [ValueConvertOrder_Number] = ToNumber;
         mValueConvertFunctions [ValueConvertOrder_String] = ToString;
      }
      
      public function FindAncestorClasses ():void
      {
         if (mAncestorClasses == null)
         {
            mAncestorClasses = new Array ();
            
            if (mParentClasses != null)
            {  
               for each (var parentClass:ClassDefinition in mParentClasses)
               {
                  parentClass.FindAncestorClasses ();
                  if (mExtendOrder <= parentClass.mExtendOrder)
                     mExtendOrder = parentClass.mExtendOrder + 1;
                  
                  if (mAncestorClasses.indexOf (parentClass) < 0)
                     mAncestorClasses.push (parentClass);
                  
                  var parentPrentClasses:Array = parentClass.mParentClasses;
                  if (parentPrentClasses != null)
                  {
                     for each (var parentPrentClass:ClassDefinition in parentPrentClasses)
                     {
                        if (mAncestorClasses.indexOf (parentPrentClass) < 0)
                        {
                           mAncestorClasses.push (parentPrentClass);
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function GetID ():int
      {
         return 0; // to override
      }
      
      public function GetName ():String
      {
         return null; // to override
      }
      
      public function GetClassType ():int
      {
         return ClassTypeDefine.ClassType_Unknown;
      }
      
      //public function IsCustomClass ():Boolean
      //{
      //   return false;
      //}
      
      public function CreateDefaultInitialValue ():Object
      {
         return null;
      }
      
      //===============================
      // value convert
      //===============================
      
      // generally, these 3 should not be null
      public var mToNumberFunc:Function; // only null for Number
      public var mToBooleanFunc:Function; // only null for Boolean
      public var mToStringFunc:Function; // only null for String
      
      // for non primitive classes
      public var mIsNullFunc:Function;
      public var mGetNullFunc:Function;
      
      //public function GetNullValue ():Object
      //{
      //   return mGetNullFunc ();
      //}
      
      public function ToNumber (valueObject:Object):Number
      {
         return mToNumberFunc (valueObject);
      }
      
      public function ToBoolean (valueObject:Object):Boolean
      {
         return mToBooleanFunc (valueObject);
      }
      
      private var mClassNameForToString:String = null;
      public function ToString (valueObject:Object, extraInfos:Object = null):String 
      {
         if (mIsNullFunc == null) // primitive (edit: not for primitives, this is also not null for sure)
         {
            return mToStringFunc (valueObject);
         }
         else
         {
            if (mIsNullFunc (valueObject))
               return null; // "null";
                            // different from action script, which returns "null"
                            // all nulls of any classes mean VariableInstanceConstant.kVoidVariableInstance
            
            if (mClassNameForToString == null)
               mClassNameForToString = "<" + GetName () + ">"; // for debug only, the format may be changed later,
            
            return mToStringFunc (valueObject, mClassNameForToString, extraInfos);
         }
      }
   }
}
