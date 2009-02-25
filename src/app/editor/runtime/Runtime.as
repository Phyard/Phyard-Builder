package editor.runtime {
   
   import editor.CollisionManagerView;
   import editor.WorldView;
   
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
      
//=====================================================================
//
//=====================================================================
      
      public static var mSynchronizeWorldSettingPanelWithWorld:Function = null;
      public static var mSynchronizeWorldWithWorldSettingPanel:Function = null;
      
   }
   
}