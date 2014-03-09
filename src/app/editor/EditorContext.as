package editor {
   
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   
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
   
   import editor.entity.Scene;
   
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
   
   import common.ViewerDefine;
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
            
      // todo: use editor.context instead of context.editor
      //       add editor.settings for static values
      // it is best to untilizing the coming Property(Group) feature.
      
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
         UrlUtil.PopupPage (ViewerDefine.AboutUrl);
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
         
         //if (mAssetImageModuleListDialog != null)
         //   AssetImageModuleListDialog.HideAssetImageModuleListDialog ();
         //
         //if (mAssetSoundListDialog != null)
         //   AssetSoundListDialog.HideAssetSoundListDialog ();
         //
         //if (mCollisionCategoryListDialog != null)
         //   CollisionCategoryListDialog.HideCollisionCategoryListDialog ();
         //
         //if (mCodeLibListDialog != null)
         //   CodeLibListDialog.HideCodeLibListDialog ();
         //
         //if (mVariablesEditDialog != null)
         //   PopUpManager.removePopUp (mVariablesEditDialog);
         
         CloseAllVisibleModelessDialogs ();
      }
   
   //=====================================================================
   // current module
   //=====================================================================
      
      public var mCurrentAssetImageModule:AssetImageModule = null;
   
   //=====================================================================
   // asset dialogs
   //=====================================================================
      
      public var mAssetImageModuleListDialog:AssetImageModuleListDialog = null;      
      public var mAssetSoundListDialog:AssetSoundListDialog = null;
      public var mCollisionCategoryListDialog:CollisionCategoryListDialog = null;
      public var mCodeLibListDialog:CodeLibListDialog = null;
      public var mVariablesEditDialog:VariablesEditDialog = null;
   
   //=====================================================================
   // modeless dialogs
   //=====================================================================
      
      // todo: disgard Flex Framwork, write a custom UI lib totally based on core AS3.
      
      // for the defects of Flex Framework. Dialog management will be difficult and ugly sometimes.
      
      // the current implementation will maker sure all modeless dialogs are under all modal dialogs.
      
      // currently, ccat and code lib dialog are modal style. It is best to make modeless style later.
      // when changed them to modeless:
      // 1. update them if they are opened when scene is switched.
      // 2. when something changed in them, sync othe opened dialogs.
      
      private var mVisibleModelessDialogs:Array = new Array ();
      
      public function OpenModelessDialog (dialog:ResizableTitleWindow, centerDialog:Boolean):void
      {
         if (dialog.parent != null)
         {
            PopUpManager.bringToFront (dialog);
         }
         else
         {
            PopUpManager.addPopUp (dialog, EditorContext.GetEditorApp (), false);
         }
         
         if (centerDialog)
            PopUpManager.centerPopUp (dialog);
         
         dialog.SetAsCurrentFocusedTitleWindow ();
         
         var index:int = mVisibleModelessDialogs.indexOf (dialog);
         if (index >= 0)
         {
            if (index == mVisibleModelessDialogs.length - 1)
               return;
            
            mVisibleModelessDialogs.splice (index, 1);
         }
         mVisibleModelessDialogs.push (dialog);
         
//trace ("++ mNumVisibleModelessDialogs = " + mVisibleModelessDialogs.length + ", dialog.parent.numChildren = " + dialog.parent.numChildren);
      }
      
      public function CloseModelessDialog (dialog:ResizableTitleWindow):void
      {
         var index:int = mVisibleModelessDialogs.indexOf (dialog);
         if (index >= 0)
         {
            PopUpManager.removePopUp (dialog);
            
            mVisibleModelessDialogs.splice (index, 1);
         }
//trace ("-- mNumVisibleModelessDialogs = " + mVisibleModelessDialogs.length);
      }
      
      private function CloseAllVisibleModelessDialogs ():void
      {
         for each (var dialog:IFlexDisplayObject in mVisibleModelessDialogs)
         {
            PopUpManager.removePopUp (dialog);
         }
         
         mVisibleModelessDialogs.splice (0, mVisibleModelessDialogs.length);
      }
   
   //=== current modeless panel 
   
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
         
         //var index:int = mVisibleModelessDialogs.indexOf (mCurrentFocusedTitleWindow));
         //if (index >= 0) // should
         //{
         //   mVisibleModelessDialogs.splice (index, 1);
         //   mVisibleModelessDialogs.push (mCurrentFocusedTitleWindow);
         //}
      }
      
      //public function GetTopModelessDialog ():ResizableTitleWindow
      //{
      //   if (mVisibleModelessDialogs.length == 0)
      //      return 0;
      //   
      //   // should be mCurrentFocusedTitleWindow
      //   return mVisibleModelessDialogs [mVisibleModelessDialogs.length - 1];
      //}
      
   //=====================================================================
   // modal dialog (settings / alerts / variable space / picking)
   //=====================================================================
      
      private var mModalDialogStack:Array = new Array ();
      private var mModalDialogLevels:int = 0;
      
      // baseWindow is only essential when:
      // 1. the modal dialog is the first level modal dialog.
      // 2. and the baseWindow can't be scene panel, it must be a modeless dialog.
      // 3. and it is possible there will be a picking dialog opened on this first level dialog.
      // 4. and the picking dialog will not close on done.
      //
      // now only picking dialog in module edit dialog satisfies all these.
      //
      public function OnOpenModalDialog (modalDialog:IFlexDisplayObject, centerDialog:Boolean, keepDialogOpenOnDone:Boolean, baseWindow:IFlexDisplayObject = null):void
      {
         var restoreIndex:int = -1;

         if (modalDialog == null)
         {
            keepDialogOpenOnDone = false;
         }
         else
         {
            if (mVisibleModelessDialogs.indexOf (modalDialog) >= 0)
            {
               CloseModelessDialog (modalDialog as ResizableTitleWindow);
            }
         
            if (keepDialogOpenOnDone)
            {
               // maybe the new dialog is a low level modal dialog.
               for (restoreIndex = mModalDialogLevels - 1; restoreIndex >= 0; -- restoreIndex)
               {
                  if (mModalDialogStack [restoreIndex].mCurrentModalDialog == modalDialog)
                     break;
               }
               
               // restoreIndex == -1 means the new dialog will be restored as a modeless dialog.
            }
         }
         
         var modalDialogInfo:Object = {
                     mCurrentModalDialog   : modalDialog,
                     mKeepDialogOpenOnDone : keepDialogOpenOnDone,
                     mDialogRestoreIndex   : restoreIndex, // valid when mKeepDialogOpenOnDone
                     mBaseWindow           : baseWindow,
                     mOldStageFocus        : GetEditorApp ().stage.focus
                  };
         
         mModalDialogStack [mModalDialogLevels ++] = modalDialogInfo;
         
         if (modalDialog != null) // for alert, it is null
         {
            if (modalDialog.parent != null) // picking dialog
               PopUpManager.removePopUp (modalDialog);
            
            PopUpManager.addPopUp (modalDialog, GetEditorApp (), true);
            
            if (centerDialog)
               PopUpManager.centerPopUp (modalDialog);
         }
         
         //SetHasSettingDialogOpened (true);
         //StartSettingEntityProperties ();
//if (modalDialog != null)
//trace ("++ mModalDialogLevels = " + mModalDialogLevels + ", modalDialog.parent.numChildren = " + modalDialog.parent.numChildren);
//else
//trace ("++ mModalDialogLevels = " + mModalDialogLevels);
      }
      
      public function OnCloseModalDialog (forceClose:Boolean = false):IFlexDisplayObject //checkCustomVariablesModifications:Boolean = false):void
      {
         var info:Object = null;
         if (mModalDialogLevels > 0)
         {
            info = mModalDialogStack [0];
         }
         
         var modalDialogInfo:Object = mModalDialogStack [-- mModalDialogLevels];
         mModalDialogStack [mModalDialogLevels] = null;
//trace ("-- mModalDialogLevels = " + mModalDialogLevels);
//trace (new Error ().getStackTrace ());
         
         if (modalDialogInfo.mCurrentModalDialog != null && modalDialogInfo.mCurrentModalDialog.parent != null)
         {
            // this is must be an asset pick dialog.
            
            if ((! forceClose) && modalDialogInfo.mKeepDialogOpenOnDone)
            {
               if (modalDialogInfo.mDialogRestoreIndex < 0)
               {
                  PopUpManager.removePopUp (modalDialogInfo.mCurrentModalDialog);
                  OpenModelessDialog (modalDialogInfo.mCurrentModalDialog, false);
               }
               
               if (info != null)
               {
                  if (info.mBaseWindow != null) // it should be modeless dialog
                  {
                     //CloseModelessDialog (info.mBaseWindow);
                     //OpenModelessDialog (info.mBaseWindow, false);
                     PopUpManager.bringToFront (info.mBaseWindow);
                     
                     if (info.mBaseWindow is ResizableTitleWindow) // should
                     {
                        SetCurrentFocusedTitleWindow (null);
                        (info.mBaseWindow as ResizableTitleWindow).SetAsCurrentFocusedTitleWindow ();
                     }
                  }
               }

               for (var index:int = modalDialogInfo.mDialogRestoreIndex + 1; index < mModalDialogLevels; ++ index)
               {
                  info = mModalDialogStack [index];
                  // info.mCurrentModalDialog must not be null (alert dialog).
                  //PopUpManager.removePopUp (info.mCurrentModalDialog);
                  //PopUpManager.addPopUp (info.mCurrentModalDialog, GetEditorApp (), true);
                  
                  // thicky? yes!
                  var dialogParent:DisplayObjectContainer = info.mCurrentModalDialog.parent;
                  var transparentLayer:DisplayObject = dialogParent.getChildAt (dialogParent.getChildIndex (info.mCurrentModalDialog) - 1);
                  dialogParent.removeChild (transparentLayer);
                  dialogParent.addChild (transparentLayer);
                  PopUpManager.bringToFront (info.mCurrentModalDialog);
                  
                  if (info.mCurrentModalDialog is ResizableTitleWindow)
                  {
                     SetCurrentFocusedTitleWindow (null);
                     (info.mCurrentModalDialog as ResizableTitleWindow).SetAsCurrentFocusedTitleWindow ();
                  }
               }
            }
            else
            {
               PopUpManager.removePopUp (modalDialogInfo.mCurrentModalDialog);
            }
         }
         
         GetEditorApp ().stage.focus = modalDialogInfo.mOldStageFocus;
         
         //SetHasSettingDialogOpened (false);
         
         //if (checkCustomVariablesModifications)
         //{
         //   CancelSettingEntityProperties ();
         //}
         
         return modalDialogInfo.mCurrentModalDialog;
      }
      
   //================ picking ===============================================
      
      // to changed to non static
      
      // if oldTopPanel != null, it will be bring to top again when pick mode is exited.
      public static function OpenAssetPickingDialog (pickPanel:ResizableTitleWindow, centerPickPanel:Boolean, closeDialogOnDone:Boolean, baseWindow:IFlexDisplayObject = null):void
      {
         pickPanel.SetInPickingMode (true);
         GetSingleton ().OnOpenModalDialog (pickPanel, centerPickPanel, closeDialogOnDone, baseWindow);
      }
      
      public static function CloseAssetPickingDialog (forceClose:Boolean = false):void
      {
         var pickPanel:ResizableTitleWindow = GetSingleton ().OnCloseModalDialog (forceClose) as ResizableTitleWindow;
         pickPanel.SetInPickingMode (false);
      }
      
   //================ settings ===============================================
      
      // to changed to non static
      
      public static function OpenSettingsDialog (DialogClass:Class, onConfirmCallback:Function, initialParams:Object = null):void
      {
         // will block fucntion setting dialog
         //if (GetSingleton ().HasSettingDialogOpened ())
         //   return;
         
         var settingDialog:Object = new DialogClass ();
         
         if (settingDialog.hasOwnProperty ("SetValues"))
            settingDialog.SetValues (initialParams);
         
         if (settingDialog.hasOwnProperty ("SetConfirmFunc"))
            settingDialog.SetConfirmFunc (onConfirmCallback);
         
         settingDialog.SetCloseFunc (CloseSettingsDialog);
         
         GetSingleton ().OnOpenModalDialog (settingDialog as IFlexDisplayObject, true, false);
      }
      
      // the param is ignored now.
      public static function CloseSettingsDialog (checkCustomVariablesModifications:Boolean = false):void
      {
         GetSingleton ().OnCloseModalDialog (); //checkCustomVariablesModifications);
      }
      
   //================ alert ===============================================
      
      // to changed to non static
            
      // "showYesNo == false" means showOk
      public static function OpenAlertDialog (title:String, question:String, showYesNo:Boolean = false, onYesHandler:Function = null):void
      {
         GetSingleton ().OnOpenModalDialog (null, true, false, null);
         GetSingleton ().SetAlertOnYesCallback (onYesHandler);
         Alert.show(question, title, showYesNo ? (Alert.YES | Alert.NO) : Alert.OK, GetEditorApp (), CloseAlertDialog, null, Alert.NO);
      }
      
      private static function CloseAlertDialog (event:CloseEvent):void 
      {
         var onYesHandler:Function = GetSingleton ().GetAlertOnYesCallback ();
         GetSingleton ().SetAlertOnYesCallback (null);
         
         GetSingleton ().OnCloseModalDialog (); //false); // must put before yes handler, for a new Context may be created there.
         
         if (event.detail == Alert.YES)
         {
            onYesHandler ();
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
      
   //================ variable space ===============================================
      
      // to changed to non static
      
      public static function OpenVariableSpaceEditDialog (parent:DisplayObject, variableSpace:VariableSpace, onCloseFunc:Function, codeLibManager:CodeLibManager = null, titlePrefix:String = null):void
      {
         if (GetSingleton ().mVariablesEditDialog == null)
         {
            GetSingleton ().mVariablesEditDialog = new VariablesEditDialog ();
         }
         
         GetSingleton ().mVariablesEditDialog.SetTitle (titlePrefix == null ? variableSpace.GetSpaceName () : titlePrefix + variableSpace.GetSpaceName ());
         GetSingleton ().mVariablesEditDialog.SetCloseFunc (CloseVariablesEditDialog);
         GetSingleton ().SetOnVariiablesEditDialogClosed (onCloseFunc);
         //GetSingleton ().mVariablesEditDialog.visible = false; // useless, when change to true first time, show-event will not triggered
         
         //GetSingleton ().mVariablesEditDialog.SetOptions ({mSupportEditingInitialValues: mSupportEditingInitialValue});
         
         //GetSingleton ().mVariablesEditDialog.SetVariableSpace (variableSpace);
         
         //PopUpManager.addPopUp (GetSingleton ().mVariablesEditDialog, parent, true);
         //PopUpManager.centerPopUp (GetSingleton ().mVariablesEditDialog);
         //PopUpManager.bringToFront (GetSingleton ().mVariablesEditDialog);
         GetSingleton ().OnOpenModalDialog (GetSingleton ().mVariablesEditDialog, true, false, null);
         
         //GetSingleton ().mVariablesEditDialog.NotifyVariableSpaceModified ();
         
         GetSingleton ().mVariablesEditDialog.UpdateVariableSpace (variableSpace);
         GetSingleton ().mVariablesEditDialog.SetCodeLibManager (codeLibManager);
      }
      
      public static function CloseVariablesEditDialog ():void
      {
         var onClosed:Function = GetSingleton ().GetOnVariiablesEditDialogClosed ();
         GetSingleton ().SetOnVariiablesEditDialogClosed (null);
         if (onClosed != null)
            onClosed ();
         
         GetSingleton ().OnCloseModalDialog (); //false);
      }
      
      private var mOnVariiableEditDialogClosedFunc:Function = null;
      
      public function GetOnVariiablesEditDialogClosed ():Function
      {
         return mOnVariiableEditDialogClosedFunc;
      }
      
      public function SetOnVariiablesEditDialogClosed (onClosed:Function ):void
      {
         mOnVariiableEditDialogClosedFunc = onClosed;
      }
      
   //=====================================================================
   //   key event
   //=====================================================================
      
      //private var mHasSettingDialogOpened:Boolean = false;
      //
      //public function SetHasSettingDialogOpened (opened:Boolean):void      
      //{
      //   mHasSettingDialogOpened = opened;
      //}
      
      public function HasSettingDialogOpened ():Boolean
      {
         //return mHasSettingDialogOpened;
         return mModalDialogLevels > 0;
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
            case Keyboard.F7:
               CodeLibListDialog.ShowCodeLibListDialog ();
               break;
            //case 67: // C. It seems flash will never fire CTL+C events
            //   if (ctrlDown)
            //      GetEditorApp ().OnStartOfflineExporting ();
            //   break;
            
            case 83: // S
               if (GetSingleton ().mVariablesEditDialog == null || GetSingleton ().mVariablesEditDialog.parent == null) // this fixing is not graceful
               {
                  if (ctrlDown)
                  {
                     //if (shiftDown)
                     //   GetEditorApp ().OnStartOnlineSaving ();
                     //else
                     // local save
                  }
                  else
                  {
                     //if (shiftDown)
                     //   GetEditorApp ().OnStartOfflineSaving ();
                     //else
                     {
                        //GetEditorApp ().CreateWorldSnapshot ("Undo point created manually");
                        GetEditorApp ().CreateSnapshotForCurrentScene ("Undo point created manually");
                     }
                  }
               }
               break;
         }
      }
      
   //=====================================================================
   // todo: use defines instead so that the (static) copied snippet can be used across worlds.
   //=====================================================================
      
      private var mCopiedCodeSnippetSceneKey:String = null;
      private var mCopiedCodeSnippet:CodeSnippet = null;
      
      public function ClearCopiedCodeSnippet ():void
      {
         mCopiedCodeSnippet = null;
      }
      
      public function HasCopiedCodeSnippet ():Boolean
      {
         return mCopiedCodeSnippet != null;
      }
      
      public function SetCopiedCodeSnippet (ownerFunctionDefinition:FunctionDefinition, copiedCallings:Array, scene:Scene):void
      {
         if (copiedCallings == null || copiedCallings.length == 0)
         {
             ClearCopiedCodeSnippet ();
             mCopiedCodeSnippetSceneKey = null;
         }
         else
         {
            var codeSnippet:CodeSnippet = new CodeSnippet (ownerFunctionDefinition);
            codeSnippet.AssignFunctionCallings (copiedCallings);
            //codeSnippet.PhysicsValues2DisplayValues (scene.GetCoordinateSystem ()); 
               // superfluous? and should it be DisplayValues2PhysicsValues? (removed from v2.00)
            
            mCopiedCodeSnippetSceneKey = scene.GetKey ();
            mCopiedCodeSnippet = codeSnippet.Clone (scene, true, ownerFunctionDefinition.Clone ()); // cloning a definition is essential
         }
      }
      
      public function CloneCopiedCodeSnippet (ownerFunctionDefinition:FunctionDefinition, scene:Scene):CodeSnippet
      {
         if (mCopiedCodeSnippet == null)
         {
            return null;
         }
         else
         {
            mCopiedCodeSnippet.ValidateCallings ();
            
            var codeSnippet:CodeSnippet = mCopiedCodeSnippet.Clone (scene, scene.GetKey () == mCopiedCodeSnippetSceneKey, ownerFunctionDefinition);
            //codeSnippet.DisplayValues2PhysicsValues (scene.GetCoordinateSystem ());
               // superfluous? and should it be PhysicsValues2DisplayValues? (removed from v2.00)
            
            return codeSnippet;
         }
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
   //
   //=====================================================================
      
      //public var mSessionVariablesEditingDialogClosedCallBack:Function = null;
      //public var mGlobalVariablesEditingDialogClosedCallBack:Function = null;
      //public var mEntityVariablesEditingDialogClosedCallBack:Function = null;
      //public var mLocalVariablesEditingDialogClosedCallBack:Function = null;
      //public var mInputVariablesEditingDialogClosedCallBack:Function = null;
      //public var mOutputVariablesEditingDialogClosedCallBack:Function = null;
      
   //=====================================================================
   // hooks to detect if any variable definitions are changed
   //=====================================================================
      
      // to use new implementations
      
      //private var mLastSessionVariableSpaceModifiedTimes:int = 0;
      //private var mLastGlobalVariableSpaceModifiedTimes:int = 0;
      //private var mLastEntityVariableSpaceModifiedTimes:int = 0;
      
      //public function StartSettingEntityProperties ():void
      //{
      //   //mLastSessionVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetSessionVariableSpace ().GetNumModifiedTimes ();
      //   //mLastGlobalVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetGlobalVariableSpace ().GetNumModifiedTimes ();
      //   //mLastEntityVariableSpaceModifiedTimes = EditorContext.GetEditorApp ().GetWorld ().GetTriggerEngine ().GetEntityVariableSpace ().GetNumModifiedTimes ();
      //}
      //
      //public function CancelSettingEntityProperties ():void
      //{
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
            
            //GetEditorApp ().CreateWorldSnapshot (message);
            GetEditorApp ().CreateSnapshotForCurrentScene (message);
         }
         */
      //}
      
      

   }
   
}
