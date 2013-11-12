package common.trigger
{
   public class ClassDeclaration
   {
      private var mId:int;
      public var mName:String;
      internal var mDefaultDirectDefineValue:Object;
      public var mIsFinal:Boolean; // can't be extended if true. 
      
      public function ClassDeclaration (id:int, name:String, defaultDirectDefineValue:Object, isFinal:Boolean)
      {
         mId = id;
         mName = name;
         mDefaultDirectDefineValue = defaultDirectDefineValue;
         mIsFinal = isFinal;
      }
      
      public function GetID ():int
      {
         return mId;
      }
      
      public function GetName ():String
      {
         return mName;
      }
     
      public function GetDefaultDirectDefineValue ():Object
      {
         return mDefaultDirectDefineValue;
      }
   }
}
      