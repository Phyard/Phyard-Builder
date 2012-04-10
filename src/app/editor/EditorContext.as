package editor {
   
   import flash.display.DisplayObject;
   
   import flash.ui.ContextMenuItem;
   import flash.events.ContextMenuEvent;
   
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   import flash.media.SoundMixer;
   
   import mx.core.Application;
   import mx.core.UIComponent;
   import mx.managers.PopUpManager;
   
   import com.tapirgames.util.UrlUtil;
   
   import editor.world.World;
   
   import editor.entity.Entity;
   
   import editor.asset.Asset;
   
   import editor.image.dialog.AssetImageModuleListDialog;
   import editor.image.AssetImageModule;
   import editor.sound.dialog.AssetSoundListDialog;
   import editor.ccat.dialog.CollisionCategoryListDialog;
   import editor.codelib.dialog.CodeLibListDialog;
   
   import editor.trigger.CodeSnippet;
   import editor.trigger.FunctionDefinition;
   
   import editor.trigger.entity.InputEntitySelector;
   
   import common.Define;
   import common.Version;
   
   public class EditorContext
   {
      
//=====================================================================
// static methods
//=====================================================================
      
   //=====================================================================
   // singleton
   //=====================================================================

      internal static var sEditorApp:Editor; // set by editor app
      
      public static function GetEditorApp ():Editor
      {
         return EditorContext.sEditorApp;
      }
      
      internal static var sEditorContext:EditorContext = null; // lifecycle is the same as app.mWorld
      
      public static function GetSingleton ():EditorContext
      {
         return sEditorContext;
      }
      
   //=====================================================================
   //
   //=====================================================================
      
      // used in loading editor world
      public static var mPauseCreateShapeProxy:Boolean = false;

      // for code editing
      public static var mLongerCodeEditorMenuBar:Boolean = false;
      public static var mPoemCodingFormat:Boolean = false;
      
      // for some special optimizaitons. Another possible good mehtod: use bit masks to ...
      public static var mNextActionId:int = -0x7FFFFFFF - 1; // maybe 0x10000000 is better
      
      // for ResizableTitleWindow
      public static var mIsMouseButtonHold:Boolean = false;
      
   //=====================================================================
   // sound
   //=====================================================================
      
      private static var mSoundVolume:Number = 0.5;
      
      public static function GetSoundVolume ():Number
      {
         return mSoundVolume;
      }
      
      public static function SetSoundVolume (volume:Number):void
      {
         if (volume < 0)
            volume = 0;
         if (volume > 1.0)
            volume = 1.0;
         
         mSoundVolume = volume;
      }
      
      public static function StopAllSounds ():void
      {
         SoundMixer.stopAll ();
      }
      
   //=====================================================================
   //
   //=====================================================================

      public static function GetVersionString ():String
      {
         var majorVersion:int = (Version.VersionNumber & 0xFF00) >> 8;
         var minorVersion:Number = (Version.VersionNumber & 0xFF) >> 0;
         
         return majorVersion.toString (16) + (minorVersion < 16 ? ".0" : ".") + minorVersion.toString (16);
      }

      public static function GetAboutContextMenuItem ():ContextMenuItem
      {
         var menuItemAbout:ContextMenuItem = new ContextMenuItem("About Phyard Builder v" + GetVersionString (), true);
         menuItemAbout.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnAbout);
         
         return menuItemAbout;
      }
      
      private static function OnAbout (event:ContextMenuEvent):void
      {
         UrlUtil.PopupPage (Define.AboutUrl);
      }
      
//=====================================================================
// non-static methods
//=====================================================================
      
      public function EditorContext ()
      {
         mNextActionId = -0x7FFFFFFF - 1; // maybe 0x10000000 is better
         
         mIsMouseButtonHold = false;
      }
      
      public function Cleanup ():void
      {  
         if (mAssetImageModuleListDialog != null)
            AssetImageModuleListDialog.HideAssetImageModuleListDialog ();
         
         if (mAssetSoundListDialog != null)
            AssetSoundListDialog.HideAssetSoundListDialog ();
         
         if (mCollisionCategoryListDialog != null)
            CollisionCategoryListDialog.HideCollisionCategoryListDialog ();
         
         if (mCodeLibListDialog != null)
            CodeLibListDialog.HideCodeLibListDialog ();
         
         StopAllSounds ();
      }
      
   //=====================================================================
   // file name
   //=====================================================================
      
      private var mDesignFilename:String  = null;
      
      public function SetRecommandDesignFilename (filename:String):void
      {
         mDesignFilename = filename;
      }
      
      public function GetTimeStringInFilename ():String
      {
         var date:Date = new Date ();
         return "[" 
               + date.getFullYear () + "-" 
               + (date.getMonth () < 9 ? "0" + (date.getMonth () + 1) : (date.getMonth () + 1)) + "-"
               + (date.getDate () < 10 ? "0" + date.getDate () : date.getDate ())
               + " " + (date.getHours () < 10 ? "0" + date.getHours () : date.getHours ())
               + "." + (date.getMinutes () < 10 ? "0" + date.getMinutes () : date.getMinutes ())
               + "." + (date.getSeconds () < 10 ? "0" + date.getSeconds () : date.getSeconds ())
               + "]";
      }
      
      public function GetRecommandDesignFilename ():String
      {
         if (mDesignFilename == null)
         {
            mDesignFilename = GetTimeStringInFilename () + " {design name}.phyardx";
         }
         
         return mDesignFilename;
      }
      
   //=====================================================================
   //   key event
   //=====================================================================
      
      // this is the default
      public function OnKeyDownDefault (keyCode:int):void
      {
         if (HasSettingDialogOpened ())
            return;
         
         if (HasInputFocused ())
            return;
         
         switch (keyCode)
         {
            case Keyboard.F3:
               AssetImageModuleListDialog.ShowAssetImageModuleListDialog ();
               break;
            case Keyboard.F4:
               AssetSoundListDialog.ShowAssetSoundListDialog ();
               break;
            case Keyboard.F5:
               CollisionCategoryListDialog.ShowCollisionCategoryListDialog ();
               break;
            case Keyboard.F6:
               CodeLibListDialog.ShowCodeLibListDialog ();
               break;
         }
      }
      
   //=====================================================================
   //
   //=====================================================================
      
      public var mCurrentAssetImageModule:AssetImageModule = null;
      
      public var mAssetImageModuleListDialog:AssetImageModuleListDialog = null;      
      public var mAssetSoundListDialog:AssetSoundListDialog = null;
      public var mCollisionCategoryListDialog:CollisionCategoryListDialog = null;
      public var mCodeLibListDialog:CodeLibListDialog  = null;
      
   //=====================================================================
   //
   //=====================================================================
      
      private var mHasSettingDialogOpened:Boolean = false;
      
      public function SetHasSettingDialogOpened (opened:Boolean):void
      {
         mHasSettingDialogOpened = opened;
      }
      
      public function HasSettingDialogOpened ():Boolean
      {
         return mHasSettingDialogOpened;
      }
      
      private var mHasInputFocused:Boolean = false;
      
      public function SetHasInputFocused (has:Boolean):void
      {
         mHasInputFocused = has;
      }
      
      public function HasInputFocused ():Boolean
      {
         return mHasInputFocused;
      }
      
      public function OnOpenModalDialog ():void
      {
         SetHasSettingDialogOpened (true);
         EditorContext.GetSingleton ().StartSettingEntityProperties ();
      }
      
      public function OnCloseModalDialog (checkCustomVariablesModifications:Boolean = false):void
      {
         SetHasSettingDialogOpened (false);
         
         if (checkCustomVariablesModifications)
         {
            EditorContext.GetSingleton ().CancelSettingEntityProperties ();
         }
      }
      
      public function OpenSettingsDialog (DialigClass:Class, initialValues:Object, onConfirmFunc:Function):void
      {
         OnOpenModalDialog ();
         
         var settingDialog:Object = new DialigClass ();
         settingDialog.SetValues (initialValues);
         settingDialog.SetConfirmFunc (onConfirmFunc);
         settingDialog.SetCloseFunc (OnCloseModalDialog);
         
         PopUpManager.addPopUp (settingDialog as UIComponent, sEditorApp, true);
         PopUpManager.centerPopUp (settingDialog as UIComponent);
      }
      
   //=====================================================================
   //
   //=====================================================================
      
      public var mSessionVariablesEditingDialogClosedCallBack:Function = null;
      public var mGlobalVariablesEditingDialogClosedCallBack:Function = null;
      public var mEntityVariablesEditingDialogClosedCallBack:Function = null;
      public var mLocalVariablesEditingDialogClosedCallBack:Function = null;
      public var mInputVariablesEditingDialogClosedCallBack:Function = null;
      public var mOutputVariablesEditingDialogClosedCallBack:Function = null;
      
   //=====================================================================
   // todo: use defines instead so that the (static) copied snippet can be used across worlds.
   //=====================================================================
      
      private var mCopiedCodeSnippet:CodeSnippet = null;
      
      public function ClearCopiedCodeSnippet ():void
      {
         mCopiedCodeSnippet = null;
      }
      
      public function HasCopiedCodeSnippet ():Boolean
      {
         return mCopiedCodeSnippet != null;
      }
      
      public function SetCopiedCodeSnippet (ownerFunctionDefinition:FunctionDefinition, copiedCallings:Array):void
      {
         if (copiedCallings == null || copiedCallings.length == 0)
         {
             ClearCopiedCodeSnippet ();
         }
         else
         {
            var codeSnippet:CodeSnippet =  new CodeSnippet (ownerFunctionDefinition);
            codeSnippet.AssignFunctionCallings (copiedCallings);
            codeSnippet.PhysicsValues2DisplayValues (EditorContext.GetEditorApp ().GetWorld ().GetEntityContainer ().GetCoordinateSystem ());
            
            mCopiedCodeSnippet = codeSnippet.Clone(ownerFunctionDefinition.Clone ());
         }
      }
      
      public function CloneCopiedCodeSnippet (ownerFunctionDefinition:FunctionDefinition):CodeSnippet
      {
         if (mCopiedCodeSnippet == null)
         {
            return null;
         }
         else
         {
            mCopiedCodeSnippet.ValidateCallings ();
            
            var codeSnippet:CodeSnippet = mCopiedCodeSnippet.Clone (ownerFunctionDefinition);
            codeSnippet.DisplayValues2PhysicsValues (EditorContext.GetEditorApp ().GetWorld ().GetEntityContainer ().GetCoordinateSystem ());
            
            return codeSnippet;
         }
      }
      
   //=====================================================================
   // hooks to detect if any variable definitions are changed
   //=====================================================================
      
      private var mLastSessionVariableSpaceModifiedTimes:int = 0;
      private var mLastGlobalVariableSpaceModifiedTimes:int = 0;
      private var mLastEntityVariableSpaceModifiedTimes:int = 0;
      
      public function StartSettingEntityProperties ():void
      {
         mLastSessionVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetSessionVariableSpace ().GetNumModifiedTimes ();
         mLastGlobalVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetGlobalVariableSpace ().GetNumModifiedTimes ();
         mLastEntityVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetEntityVariableSpace ().GetNumModifiedTimes ();
      }
      
      public function CancelSettingEntityProperties ():void
      {
         var sessionVariableSpaceModified:Boolean = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetSessionVariableSpace ().GetNumModifiedTimes () > mLastSessionVariableSpaceModifiedTimes;
         var globalVariableSpaceModified:Boolean = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetGlobalVariableSpace ().GetNumModifiedTimes () > mLastGlobalVariableSpaceModifiedTimes;
         var entityVariableSpaceModified:Boolean = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetEntityVariableSpace ().GetNumModifiedTimes () > mLastEntityVariableSpaceModifiedTimes;
         
         if (sessionVariableSpaceModified || globalVariableSpaceModified || entityVariableSpaceModified)
         {
            var message:String = "Custom variables (";
            
            var first:Boolean = true;
            if (sessionVariableSpaceModified)
            {
               message = message + "session";
               first = false;
            }
            if (globalVariableSpaceModified)
            {
               message = message + (first ? "global" : (entityVariableSpaceModified ? ", global" : "and global"));
               first = false;
            }
            if (entityVariableSpaceModified)
            {
               message = message + (first ? "entity property" : "and entity property");
               first = false;
            }
            
            message = message + ") are modified";
         }
      }
      
      

   }
   
}
