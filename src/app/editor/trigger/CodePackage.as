package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   public class CodePackage
   {
      private var mName:String;
      
      private var mChildCodePackages:Array = new Array ();
      
      private var mClasses:Array = new Array (); // not including the ones in sub packages
      
      private var mFunctionDeclarations:Array = new Array (); // not including the ones in sub packages
      
      public function CodePackage (name:String, parentCodePackage:CodePackage = null)
      {
         SetName (name);
         
         //mParentCodePackage = parentCodePackage;
         if (parentCodePackage != null)
            parentCodePackage.AddChildCodePackage (this);
      }
      
      public function SetName (name:String):void
      {
         mName = name;
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function Clear ():void
      {
         mChildCodePackages.splice (0, mChildCodePackages.length);
         mFunctionDeclarations.splice (0, mFunctionDeclarations.length);
         mClasses.splice (0, mClasses.length);
      }
      
      public function GetNumChildCodePackages ():int
      {
         return mChildCodePackages.length;
      }
      
      public function GetChildCodePackageAtIndex (index:int):CodePackage
      {
         if (index < 0 || index >= mChildCodePackages.length)
            return null;
         
         return mChildCodePackages [index];
      }
      
      public function AddChildCodePackage (childCodePackage:CodePackage):void
      {
         if (mChildCodePackages.indexOf (childCodePackage) < 0)
         {
            mChildCodePackages.push (childCodePackage);
         }
      }
      
      public function RemoveChildCodePackage (childCodePackage:CodePackage):void
      {
         var index:int = mChildCodePackages.indexOf (childCodePackage);
         if (index >= 0)
         {
            mChildCodePackages.splice (index, 1);
         }
      }
      
      public function GetNumClasses ():int
      {
         return mClasses.length;
      }
      
      public function GetClassAtIndex (index:int):ClassDefinition
      {
         if (index < 0 || index >= mClasses.length)
            return null;
         
         return mClasses [index];
      }
      
      public function AddClass (aClass:ClassDefinition):void
      {
         if (mClasses.indexOf (aClass) < 0)
         {
            mClasses.push (aClass);
         }
      }
      
      public function RemoveClass (aClass:ClassDefinition):void
      {
         var index:int = mClasses.indexOf (aClass);
         if (index >= 0)
         {
            mClasses.splice (index, 1);
         }
      }
      
      public function GetNumFunctionDeclarations ():int
      {
         return mFunctionDeclarations.length;
      }
      
      public function GetFunctionDeclarationAtIndex (index:int):FunctionDeclaration
      {
         if (index < 0 || index >= mFunctionDeclarations.length)
            return null;
         
         return mFunctionDeclarations [index];
      }
      
      public function AddFunctionDeclaration (funcDeclaration:FunctionDeclaration):void
      {
         if (mFunctionDeclarations.indexOf (funcDeclaration) < 0)
         {
            mFunctionDeclarations.push (funcDeclaration);
         }
      }
      
      public function RemoveFunctionDeclaration (funcDeclaration:FunctionDeclaration):void
      {
         var index:int = mFunctionDeclarations.indexOf (funcDeclaration);
         if (index >= 0)
         {
            mFunctionDeclarations.splice (index, 1);
         }
      }
      
      //public function GetChildCodePackages ():Array
      //{
      //   return mChildCodePackages;
      //}
      
      //public function GetClasses ():Array
      //{
      //   return mClasses;
      //}
      
      //public function GetFunctionDeclarations ():Array
      //{
      //   return mFunctionDeclarations;
      //}
   }
}
