package player.trigger
{
   import common.trigger.ClassTypeDefine;
   
   public class ClassDefinition
   {
      public var mParentClasses:Array = null; //ClassDefinition;
      public var mExtendOrder:int = 0; // an ancestor class's extend order must be smaller than its sub classes.
      public var mAncestorClasses:Array = null;
      
      public function SetParentClasses (parentClasses:Array):void
      {
         mParentClasses = parentClasses;
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
      
      public function GetClassType ():int
      {
         return ClassTypeDefine.ClassType_Unknown;
      }
      
      public function IsCustomClass ():Boolean
      {
         return false;
      }
      
      public function GetDefaultInitialValue ():Object
      {
         return null;
      }
      
      //===============================
      // 
      //===============================
      
      public function ConvertValueOfClassInstance (classInstance:ClassInstance):Object
      {
         if (classInstance.mRealClassDefinition == this)
            return classInstance.mValueObject;
         
         var realClassDefinition:ClassDefinition = classInstance.mRealClassDefinition;
         if (mExtendOrder != realClassDefinition.mExtendOrder) // possible one is the other's ancestor.
         {
            if (mExtendOrder < realClassDefinition.mExtendOrder) // this is possible the ancestor
            {
               if (realClassDefinition.mAncestorClasses.indexOf (this) >= 0)
                  return classInstance.mValueObject;
            }
            else // realClassDefinition is possible the ancestor
            {
               
            }
         }
         
         return null;
      }
      
   }
}