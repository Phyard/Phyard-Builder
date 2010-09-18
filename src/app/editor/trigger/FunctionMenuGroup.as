package editor.trigger {
   
   import flash.utils.ByteArray;
   //import flash.utils.Dictionary;
   
   public class FunctionMenuGroup
   {
      public var mName:String;
      
      public var mParentMenuGroup:FunctionMenuGroup = null;
      public var mChildMenuGroups:Array = new Array ();
      public var mFunctionDeclarations:Array = new Array ();
      
      public function FunctionMenuGroup (name:String, parentMenuGroup:FunctionMenuGroup = null)
      {
         mName = name;
         mParentMenuGroup = parentMenuGroup;
         
         if (mParentMenuGroup != null)
            mParentMenuGroup.AddChildMenuGroup (this);
      }
      
      public function Clear ():void
      {
         mChildMenuGroups.splice (0, mChildMenuGroups.length);
         mFunctionDeclarations.splice (0, mFunctionDeclarations.length);
      }
      
      public function AddChildMenuGroup (childMenuGroup:FunctionMenuGroup):void
      {
         mChildMenuGroups.push (childMenuGroup);
      }
      
      public function AddFunctionDeclaration (funcDeclaration:FunctionDeclaration):void
      {
         mFunctionDeclarations.push (funcDeclaration);
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function GetChildMenuGroups ():Array
      {
         return mChildMenuGroups;
      }
      
      public function GetFunctionDeclarations ():Array
      {
         return mFunctionDeclarations;
      }
   }
}
