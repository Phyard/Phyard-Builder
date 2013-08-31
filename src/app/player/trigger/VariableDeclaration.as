package player.trigger
{
   import common.trigger.ClassTypeDefine;
   import common.trigger.CoreClassIds;
   
   public class VariableDeclaration
   {
      private var mKey:String = null;
      private var mIndex:int = -1;
      
      public var mName:String = null; // for debug usage only
      
      //private var mClassType:int = ClassTypeDefine.ClassType_Unknown;  // since v2.05
      //private var mValueType:int = CoreClassIds.ValueType_Void;
      internal var mShellClassDefinition:ClassDefinition = CoreClasses.kVoidClassDefinition;
      
      public function VariableDeclaration (classDef:ClassDefinition)
      {
         mShellClassDefinition = classDef;
      }
      
      public function SetIndex (index:int):void
      {
         mIndex = index;
      }
      
      public function GetIndex ():int
      {
         return mIndex;
      }
      
      public function SetKey (key:String):void
      {
         mKey = key;
      }
      
      public function GetKey ():String
      {
         return mKey;
      }
      
      public function SetName (name:String):void
      {
         mName = name;
      }
      
      public function SetShellClassDefinition (classDefinition:ClassDefinition):void
      {
         mShellClassDefinition = classDefinition == null ? CoreClasses.kVoidClassDefinition : classDefinition;
      }
      
      //public function SetClassType (type:int):void
      //{
      //   mClassType = type;
      //}
      
      //public function GetShellClassType ():int
      //{
      //   //return mClassType;
      //   return mShellClassDefinition.GetClassType ();
      //}
      
      //public function SetValueType (type:int):void
      //{
      //   mValueType = type;
      //}
      
      //public function GetShellValueType ():int
      //{
      //   //return mValueType;
      //   return mShellClassDefinition.GetID ();
      //}
   }
}