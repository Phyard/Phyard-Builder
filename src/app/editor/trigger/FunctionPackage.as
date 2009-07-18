package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   public class FunctionPackage
   {
      public var mName:String;
      
      public var mParentPackage:FunctionPackage = null;
      public var mChildPackages:Array = new Array ();
      public var mFunctionDeclarations:Array = new Array ();
      
      public function FunctionPackage (name:String, parentPackage:FunctionPackage = null)
      {
         mName = name;
         mParentPackage = parentPackage;
         
         if (mParentPackage != null)
            mParentPackage.AddChildPackage (this);
      }
      
      public function AddChildPackage (childPackage:FunctionPackage):void
      {
         mChildPackages.push (childPackage);
      }
      
      public function AddFunctionDeclaration (funcDeclaration:FunctionDeclaration):void
      {
         mFunctionDeclarations.push (funcDeclaration);
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function GetChildPackages ():Array
      {
         return mChildPackages;
      }
      
      public function GetFunctionDeclarations ():Array
      {
         return mFunctionDeclarations;
      }
   }
}
