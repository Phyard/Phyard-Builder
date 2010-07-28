package editor.runtime {
   
   import flash.display.DisplayObject;
   
   import editor.CollisionManagerView;
   import editor.WorldView;
   import editor.world.World;
   
   import editor.trigger.CodeSnippet;
   import editor.trigger.FunctionDefinition
   
   import common.Define;
   
   public class Runtime
   {
   
//=====================================================================
//
//=====================================================================
      
      // used in loading editor world
      public static var mPauseCreateShapeProxy:Boolean = false;
      
//=====================================================================
//
//=====================================================================
      
      private static var mHasSettingDialogOpened:Boolean = false;
      
      public static function SetHasSettingDialogOpened (has:Boolean):void
      {
         mHasSettingDialogOpened = has;
      }
      
      public static function HasSettingDialogOpened ():Boolean
      {
         return mHasSettingDialogOpened;
      }
      
      private static var mHasInputFocused:Boolean = false;
      
      public static function SetHasInputFocused (has:Boolean):void
      {
         mHasInputFocused = has;
      }
      
      public static function HasInputFocused ():Boolean
      {
         return mHasInputFocused;
      }
      
//=====================================================================
//
//=====================================================================
      
      public static var mEditorWorldView:WorldView = null;
      public static var mCollisionCategoryView:CollisionManagerView = null;
      
      private static var mActiveView:DisplayObject = null;
      
      public static function SetActiveView (view:DisplayObject):void
      {
         mActiveView = view;
      }
      
      public static function IsActiveView (view:DisplayObject):Boolean
      {
         return mActiveView == view;
      }
      
//=====================================================================
//
//=====================================================================
      
      public static function GetCurrentWorld ():World
      {
         if (mEditorWorldView == null)
            return null;
         
         return mEditorWorldView.GetEditorWorld ();
      }
      
//=====================================================================
//
//=====================================================================
      
      public static var mLongerCodeEditorMenuBar:Boolean = false;
      public static var mPoemCodingFormat:Boolean = false;
      
      public static var mGlobalVariablesEditingDialogClosedCallBack:Function = null;
      public static var mEntityVariablesEditingDialogClosedCallBack:Function = null;
      
//=====================================================================
//
//=====================================================================
      
      private static var mCopiedCodeSnippet:CodeSnippet = null;
      
      public static function ClearCopiedCodeSnippet ():void
      {
         Runtime.mCopiedCodeSnippet = null;
      }
      
      public static function HasCopiedCodeSnippet ():Boolean
      {
         return Runtime.mCopiedCodeSnippet != null;
      }
      
      public static function SetCopiedCodeSnippet (ownerFunctionDefinition:FunctionDefinition, copiedCallings:Array):void
      {
         if (copiedCallings == null || copiedCallings.length == 0)
         {
             ClearCopiedCodeSnippet ();
         }
         else
         {
            var codeSnippet:CodeSnippet =  new CodeSnippet (ownerFunctionDefinition);
            codeSnippet.AssignFunctionCallings (copiedCallings);
            codeSnippet.PhysicsValues2DisplayValues (GetCurrentWorld ().GetCoordinateSystem ());
            
            Runtime.mCopiedCodeSnippet = codeSnippet.Clone(null);
         }
      }
      
      public static function CloneCopiedCodeSnippet (ownerFunctionDefinition:FunctionDefinition):CodeSnippet
      {
         if (Runtime.mCopiedCodeSnippet == null)
         {
            return null;
         }
         else
         {
            var codeSnippet:CodeSnippet = Runtime.mCopiedCodeSnippet.Clone (ownerFunctionDefinition);
            codeSnippet.DisplayValues2PhysicsValues (GetCurrentWorld ().GetCoordinateSystem ());
            
            return codeSnippet;
         }
      }
      
//=====================================================================
// create initial properties
//=====================================================================
      
   // shapes
      
      //public static var mShape_EnablePhysics:Boolean = true;
      //public static var mShape_IsStatic:Boolean = false;
      //public static var mShape_IsSensor:Boolean = false;
      //
      //public static var mShape_DrawBackground:Boolean = true;
      //public static var mShape_BackgroundColor:uint = Define.ColorMovableObject;
      //
      //public static var mShape_DrawBorder:Boolean = true;
      //public static var mShape_BorderColor:uint = Define.ColorObjectBorder;
   }
   
}