package editor.runtime {
   
   import flash.display.DisplayObject;
   
   import editor.CollisionManagerView;
   import editor.WorldView;
   import editor.world.World;
   
   public class Runtime
   {
   
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
      
   }
   
}