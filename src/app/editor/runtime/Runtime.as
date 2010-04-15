package editor.runtime {
   
   import flash.display.DisplayObject;
   
   import editor.CollisionManagerView;
   import editor.WorldView;
   import editor.world.World;
   
   import editor.trigger.CodeSnippet;
   
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
      
//=====================================================================
//
//=====================================================================
      
      public static var mCopiedCodeSnippet:CodeSnippet = null;
      
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