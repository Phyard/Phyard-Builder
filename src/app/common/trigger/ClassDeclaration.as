package common.trigger
{
   public class ClassDeclaration
   {
      private var mId:int;
      internal var mDefaultDirectDefineValue:Object;
      
      public function ClassDeclaration (id:int, defaultDirectDefineValue:Object)
      {
         mId = id;
         mDefaultDirectDefineValue = defaultDirectDefineValue;
      }
      
      public function GetID ():int
      {
         return mId;
      }
     
      public function GetDefaultDirectDefineValue ():Object
      {
         return mDefaultDirectDefineValue;
      }
   }
}
      