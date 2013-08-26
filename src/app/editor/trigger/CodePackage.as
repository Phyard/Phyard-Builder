package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   public class CodePackage
   {
      public var mName:String;
      
      public var mParentCodePackage:CodePackage = null;
      public var mChildCodePackages:Array = new Array ();
      
      public var mFunctionDeclarations:Array = new Array ();
      public var mClasses:Array = new Array ();
      
      public function CodePackage (name:String, parentCodePackage:CodePackage = null)
      {
         mName = name;
         mParentCodePackage = parentCodePackage;
         
         if (mParentCodePackage != null)
            mParentCodePackage.AddChildCodePackage (this);
      }
      
      public function Clear ():void
      {
         mChildCodePackages.splice (0, mChildCodePackages.length);
         mFunctionDeclarations.splice (0, mFunctionDeclarations.length);
         mClasses.splice (0, mClasses.length);
      }
      
      public function AddChildCodePackage (childCodePackage:CodePackage):void
      {
         mChildCodePackages.push (childCodePackage);
      }
      
      public function AddFunctionDeclaration (funcDeclaration:FunctionDeclaration):void
      {
         mFunctionDeclarations.push (funcDeclaration);
      }
      
      public function AddClass (aClass:ClassDefinition):void
      {
         mClasses.push (aClass);
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function GetChildCodePackages ():Array
      {
         return mChildCodePackages;
      }
      
      public function GetFunctionDeclarations ():Array
      {
         return mFunctionDeclarations;
      }
      
      public function GetClasses ():Array
      {
         return mClasses;
      }
   }
}
