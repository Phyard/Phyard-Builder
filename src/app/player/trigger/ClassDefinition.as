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
         if (mParentClasses != null)
         {
            mParentClasses = new Array ();
            
            for each (var parentClass:ClassDefinition in mParentClasses)
            {
               parentClass.FindAncestorClasses ();
               if (mExtendOrder <= parentClass.mExtendOrder)
                  mExtendOrder = parentClass.mExtendOrder + 1;
               
               if (mParentClasses.indexOf (parentClass) < 0)
                  mParentClasses.push (parentClass);
               
               var parentPrentClasses:Array = parentClass.mParentClasses;
               if (parentPrentClasses != null)
               {
                  for each (var parentPrentClass:ClassDefinition in parentPrentClasses)
                  {
                     if (mParentClasses.indexOf (parentPrentClass) < 0)
                     {
                        mParentClasses.push (parentPrentClass);
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
   }
}