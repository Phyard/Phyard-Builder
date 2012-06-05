package editor {
   
   import flash.display.DisplayObject;
   
   import flash.ui.ContextMenuItem;
   import flash.events.ContextMenuEvent;
   
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   import flash.media.SoundMixer;
   
   import mx.core.Application;
   import mx.core.UIComponent;
   import mx.core.IFlexDisplayObject;
   import mx.managers.PopUpManager;
   import mx.controls.Alert;
   import mx.events.CloseEvent;
   
   import com.tapirgames.util.UrlUtil;
   
   import editor.display.container.ResizableTitleWindow;
   
   import editor.world.World;
   
   import editor.asset.Asset;
   
   import editor.entity.Entity;
   
   import editor.codelib.CodeLibManager;
   
   import editor.image.dialog.AssetImageModuleListDialog;
   import editor.image.AssetImageModule;
   import editor.sound.dialog.AssetSoundListDialog;
   import editor.ccat.dialog.CollisionCategoryListDialog;
   import editor.codelib.dialog.CodeLibListDialog;
   import editor.display.dialog.VariablesEditDialog;
   
   import editor.trigger.CodeSnippet;
   import editor.trigger.FunctionDefinition;
   import editor.trigger.VariableSpace;
   
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
      
      public static function OnAbout (event:ContextMenuEvent = null):void
      {
         UrlUtil.PopupPage (Define.AboutUrl);
      }
      
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
   // modal dialog
   //=====================================================================
      
      public static function ShowModalDialog (DialogClass:Class, onConfirmCallback:Function, initialParams:Object = null):void
      {
         if (GetSingleton ().HasSettingDialogOpened ())
            return;
         
         GetSingleton ().OnOpenModalDialog ();
         
         var settingDialog:Object = new DialogClass ();
         
         if (settingDialog.hasOwnProperty ("SetValues"))
            settingDialog.SetValues (initialParams);
         
         if (settingDialog.hasOwnProperty ("SetConfirmFunc"))
            settingDialog.SetConfirmFunc (onConfirmCallback);
         
         settingDialog.SetCloseFunc (GetSingleton ().OnCloseModalDialog);
         
         PopUpManager.addPopUp (settingDialog as IFlexDisplayObject, sEditorApp, true);
         PopUpManager.centerPopUp (settingDialog as IFlexDisplayObject);
      }
      
      // "showYesNo == false" means showOk
      public static function ShowAlert (title:String, question:String, showYesNo:Boolean = false, onYesHandler:Function = null):void
      {
         GetSingleton ().SetAlertOnYesCallback (onYesHandler);
         
         Alert.show(question, title, showYesNo ? (Alert.YES | Alert.NO) : Alert.OK, sEditorApp, OnCloseAlertDialog, null, Alert.NO);
      }
      
      private static function OnCloseAlertDialog (event:CloseEvent):void 
      {
         var onYesHandler:Function = GetSingleton ().GetAlertOnYesCallback ();
         GetSingleton ().SetAlertOnYesCallback (null);
         
         if (event.detail == Alert.YES)
         {
            onYesHandler ();
         }
      }
      
   //=====================================================================
   // variable space edit dialog
   //=====================================================================
      
      public static function ShowVariableSpaceEditDialog (parent:DisplayObject, variableSpace:VariableSpace, onCloseFunc:Function):void
      {
         if (GetSingleton ().mVariablesEditDialog == null)
         {
            GetSingleton ().mVariablesEditDialog = new VariablesEditDialog ();
         }
         
         GetSingleton ().mVariablesEditDialog.SetTitle (variableSpace.GetSpaceName ());
         GetSingleton ().mVariablesEditDialog.SetCloseFunc (onCloseFunc);
         //GetSingleton ().mVariablesEditDialog.visible = false; // useless, when change to true first time, show-event will not triggered
         
         //GetSingleton ().mVariablesEditDialog.SetOptions ({mSupportEditingInitialValues: mSupportEditingInitialValue});
         
         //GetSingleton ().mVariablesEditDialog.SetVariableSpace (variableSpace);
         
         PopUpManager.addPopUp (GetSingleton ().mVariablesEditDialog, parent, true);
         PopUpManager.centerPopUp (GetSingleton ().mVariablesEditDialog);
         PopUpManager.bringToFront (GetSingleton ().mVariablesEditDialog);
         
         //GetSingleton ().mVariablesEditDialog.NotifyVariableSpaceModified ();
         
         GetSingleton ().mVariablesEditDialog.UpdateVariableSpace (variableSpace);
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
         StopAllSounds ();
         
         if (mAssetImageModuleListDialog != null)
            AssetImageModuleListDialog.HideAssetImageModuleListDialog ();
         
         if (mAssetSoundListDialog != null)
            AssetSoundListDialog.HideAssetSoundListDialog ();
         
         if (mCollisionCategoryListDialog != null)
            CollisionCategoryListDialog.HideCollisionCategoryListDialog ();
         
         if (mCodeLibListDialog != null)
            CodeLibListDialog.HideCodeLibListDialog ();
         
         if (mVariablesEditDialog != null)
            PopUpManager.removePopUp (mVariablesEditDialog);
         
         CloseOtherPopupModelessDialog ();
      }
      
   //=====================================================================
   // file name
   //=====================================================================
      
      private var mDesignFilename:String  = null;
      
      public function SetRecommandDesignFilename (filename:String, appendTimePrefix:Boolean = false):void
      {
         if (appendTimePrefix)
         {
            var date:Date = new Date ();
            
            mDesignFilename = "[" 
               + date.getFullYear () + "-" 
               + (date.getMonth () < 9 ? "0" + (date.getMonth () + 1) : (date.getMonth () + 1)) + "-"
               + (date.getDate () < 10 ? "0" + date.getDate () : date.getDate ())
               + " " + (date.getHours () < 10 ? "0" + date.getHours () : date.getHours ())
               + "." + (date.getMinutes () < 10 ? "0" + date.getMinutes () : date.getMinutes ())
               + "." + (date.getSeconds () < 10 ? "0" + date.getSeconds () : date.getSeconds ())
               + "] " + filename;
         }
         else
         {
            mDesignFilename = filename;
         }
      }
      
      public function GetRecommandDesignFilename ():String
      {
         if (mDesignFilename == null)
         {
            SetRecommandDesignFilename ("{design name}.phyardx");
         }
         
         return mDesignFilename;
      }
      
   //=====================================================================
   //   key event
   //=====================================================================
      
      // this is the default
      public function OnKeyDownDefault (keyCode:int, ctrlDown:Boolean = false, shiftDown:Boolean = false):void
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
            //case 67: // C. It seems flash will never fire CTL+C events
            //   if (ctrlDown)
            //      GetEditorApp ().OnStartOfflineExporting ();
            //   break;
            case 83: // S
               if (ctrlDown)
               {
                  if (shiftDown)
                     GetEditorApp ().OnStartOnlineSaving ();
                  //else
                  // local save
               }
               else
               {
                  if (shiftDown)
                     GetEditorApp ().OnStartOfflineSaving ();
                  else
                     GetEditorApp ().CreateWorldSnapshot ("Snapshot created manually");
               }
               break;
         }
      }
   //=====================================================================
   //
   //=====================================================================
   
      private var mCurrentFocusedTitleWindow:ResizableTitleWindow = null;
      
      public function SetCurrentFocusedTitleWindow (titleWindow:ResizableTitleWindow):void
      {
         if (mCurrentFocusedTitleWindow != titleWindow)
         {
            if (mCurrentFocusedTitleWindow != null)
               mCurrentFocusedTitleWindow.OnFocusChanged (false);
            
            mCurrentFocusedTitleWindow = titleWindow;
            
            if (mCurrentFocusedTitleWindow != null)
               mCurrentFocusedTitleWindow.OnFocusChanged (true);
         }
         
         if (mCurrentFocusedTitleWindow == null)
         {
            if (GetEditorApp ().stage.focus == null || (! GetEditorApp ().contains (GetEditorApp ().stage.focus)))
               GetEditorApp ().GetSceneEditDialog ().SetAsFocus ();
         }
         else
         {
            if (GetEditorApp ().stage.focus == null || (! mCurrentFocusedTitleWindow.contains (GetEditorApp ().stage.focus)))
               GetEditorApp ().stage.focus = mCurrentFocusedTitleWindow; // todo: TitleWindow.GetDefaultFocusChild ()
         }
      }
   
   //=====================================================================
   //
   //=====================================================================
      
      public var mCurrentAssetImageModule:AssetImageModule = null;
      
      public var mAssetImageModuleListDialog:AssetImageModuleListDialog = null;      
      public var mAssetSoundListDialog:AssetSoundListDialog = null;
      public var mCollisionCategoryListDialog:CollisionCategoryListDialog = null;
      public var mCodeLibListDialog:CodeLibListDialog = null;
      public var mVariablesEditDialog:VariablesEditDialog = null;
      
      private var mOtherPopupModelessDialogs:Array = new Array ();
      
      public function RegisterOtherPopupModelessDialog (dialog:IFlexDisplayObject):void
      {
         if (mOtherPopupModelessDialogs.indexOf (dialog) < 0)
         {
            mOtherPopupModelessDialogs.push (dialog);
         }
      }
      
      public function UnregisterOtherPopupModelessDialog (dialog:IFlexDisplayObject):void
      {
         var index:int = mOtherPopupModelessDialogs.indexOf (dialog);
         if (index >= 0)
         {
            mOtherPopupModelessDialogs.splice (index, 1);
         }
      }
      
      private function CloseOtherPopupModelessDialog ():void
      {
         for each (var dialog:IFlexDisplayObject in mOtherPopupModelessDialogs)
         {
            PopUpManager.removePopUp (dialog);
         }
      }
      
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
         
         GetEditorApp ().stage.focus = GetEditorApp ();
         
         if (checkCustomVariablesModifications)
         {
            EditorContext.GetSingleton ().CancelSettingEntityProperties ();
         }
      }
      
      private var mAlertOnYesCallback:Function = null;
      
      public function SetAlertOnYesCallback (callback:Function):void
      {
         mAlertOnYesCallback = callback;
      }
      
      public function GetAlertOnYesCallback ():Function
      {
         return mAlertOnYesCallback;
      }
      
   //=====================================================================
   //
   //=====================================================================
      
      //public var mSessionVariablesEditingDialogClosedCallBack:Function = null;
      //public var mGlobalVariablesEditingDialogClosedCallBack:Function = null;
      //public var mEntityVariablesEditingDialogClosedCallBack:Function = null;
      //public var mLocalVariablesEditingDialogClosedCallBack:Function = null;
      //public var mInputVariablesEditingDialogClosedCallBack:Function = null;
      //public var mOutputVariablesEditingDialogClosedCallBack:Function = null;
      
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
      
      public function SetCopiedCodeSnippet (ownerFunctionDefinition:FunctionDefinition, copiedCallings:Array, codelibManager:CodeLibManager):void
      {
         if (copiedCallings == null || copiedCallings.length == 0)
         {
             ClearCopiedCodeSnippet ();
         }
         else
         {
            var codeSnippet:CodeSnippet =  new CodeSnippet (ownerFunctionDefinition);
            codeSnippet.AssignFunctionCallings (copiedCallings);
            codeSnippet.PhysicsValues2DisplayValues (codelibManager.GetScene ().GetCoordinateSystem ());
            
            mCopiedCodeSnippet = codeSnippet.Clone(ownerFunctionDefinition.Clone ());
         }
      }
      
      public function CloneCopiedCodeSnippet (ownerFunctionDefinition:FunctionDefinition, codelibManager:CodeLibManager):CodeSnippet
      {
         if (mCopiedCodeSnippet == null)
         {
            return null;
         }
         else
         {
            mCopiedCodeSnippet.ValidateCallings ();
            
            var codeSnippet:CodeSnippet = mCopiedCodeSnippet.Clone (ownerFunctionDefinition);
            codeSnippet.DisplayValues2PhysicsValues (codelibManager.GetScene ().GetCoordinateSystem ());
            
            return codeSnippet;
         }
      }
      
   //=====================================================================
   // hooks to detect if any variable definitions are changed
   //=====================================================================
      
      //private var mLastSessionVariableSpaceModifiedTimes:int = 0;
      //private var mLastGlobalVariableSpaceModifiedTimes:int = 0;
      //private var mLastEntityVariableSpaceModifiedTimes:int = 0;
      
      public function StartSettingEntityProperties ():void
      {
         //mLastSessionVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetSessionVariableSpace ().GetNumModifiedTimes ();
         //mLastGlobalVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetGlobalVariableSpace ().GetNumModifiedTimes ();
         //mLastEntityVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetEntityVariableSpace ().GetNumModifiedTimes ();
      }
      
      public function CancelSettingEntityProperties ():void
      {
         /*
         var sessionVariableSpaceModified:Boolean = EditorContext.GetEditorApp ().GetWorld ().GetSessionVariableSpace ().GetNumModifiedTimes () > mLastSessionVariableSpaceModifiedTimes;
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
            
            GetEditorApp ().CreateWorldSnapshot (message);
         }
         */
      }
      
      

   }
   
}
