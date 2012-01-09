package editor.runtime {
   
   import flash.display.DisplayObject;
   
   import flash.ui.ContextMenuItem;
   import flash.events.ContextMenuEvent;
   
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   import flash.media.SoundMixer;
   
   import mx.core.Application;
   
   import com.tapirgames.util.UrlUtil;
   
   import editor.world.World;
   
   import editor.WorldView;
   import editor.display.panel.CollisionManagerView;
   import editor.display.panel.FunctionEditingView;
   
   import editor.entity.Entity;
   
   import editor.asset.Asset;
   
   import editor.image.dialog.AssetImageModuleListDialog;
   import editor.image.AssetImageModule;
   import editor.sound.dialog.AssetSoundListDialog;
   
   import editor.trigger.CodeSnippet;
   import editor.trigger.FunctionDefinition;
   
   import editor.trigger.entity.InputEntitySelector;
   
   import common.Define;
   import common.Version;
   
   public class Runtime
   {
      
//=====================================================================
//
//=====================================================================

      // call this before loading a new world
      public static function Cleanup ():void
      {
         SetKeyboardListener (null);
         
         Asset.mNextActionId = -0x7FFFFFFF - 1; // maybe 0x10000000 is better
         Entity.mNextActionId = -0x7FFFFFFF - 1; // maybe 0x10000000 is better
         if (AssetImageModuleListDialog.sAssetImageModuleListDialog != null)
         {
            AssetImageModuleListDialog.HideAssetImageModuleListDialog ();
            AssetImageModuleListDialog.sAssetImageModuleListDialog = null;
         }
         if (AssetSoundListDialog.sAssetSoundListDialog != null)
         {
            AssetSoundListDialog.HideAssetSoundListDialog ();
            AssetSoundListDialog.sAssetSoundListDialog = null;
         }
         AssetImageModule.mCurrentAssetImageModule = null;
         InputEntitySelector.sNotifyEntityLinksModified = null;
         
         mHasSettingDialogOpened = false;
         mHasInputFocused = false;
         //mEditorWorldView = null;
         //mCollisionCategoryView = null;
         //mFunctionEditingView = null;
         
         mSessionVariablesEditingDialogClosedCallBack = null;
         mGlobalVariablesEditingDialogClosedCallBack = null;
         mEntityVariablesEditingDialogClosedCallBack = null;
         mLocalVariablesEditingDialogClosedCallBack = null;
         mInputVariablesEditingDialogClosedCallBack = null;
         mOutputVariablesEditingDialogClosedCallBack = null;
         
         // ...
         StopAllSounds ();
      }
   
//=====================================================================
//
//=====================================================================
      
      private static var mDesignFilename:String  = null;
      
      public static function SetRecommandDesignFilename (filename:String):void
      {
         mDesignFilename = filename;
      }
      
      public static function GetTimeStringInFilename ():String
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
      
      public static function GetRecommandDesignFilename ():String
      {
         if (mDesignFilename == null)
         {
            mDesignFilename = GetTimeStringInFilename () + " {design name}.phyardx";
         }
         
         return mDesignFilename;
      }
      
      
      private static var mApplication:Application;
      
      public static function SetApplication (app:Application):void
      {
         mApplication = app;
      }
      
      public static function GetApplication ():Application
      {
         return mApplication;
      }
      
      private static var mIsMouseButtonHold:Boolean = false;
      
      public static function SetMouseButtonHold (hold:Boolean):void
      {
         mIsMouseButtonHold = hold;
      }
      
      public static function IsMouseButtonHold ():Boolean
      {
         return mIsMouseButtonHold;
      }
      
//=====================================================================
//
//=====================================================================

      public static function GetAboutContextMenuItem ():ContextMenuItem
      {
         var majorVersion:int = (Version.VersionNumber & 0xFF00) >> 8;
         var minorVersion:Number = (Version.VersionNumber & 0xFF) >> 0;
         
         var menuItemAbout:ContextMenuItem = new ContextMenuItem("About Phyard Builder v" + majorVersion.toString (16) + (minorVersion < 16 ? ".0" : ".") + minorVersion.toString (16), true);
         menuItemAbout.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnAbout);
         
         return menuItemAbout;
      }
      
      private static function OnAbout (event:ContextMenuEvent):void
      {
         UrlUtil.PopupPage (Define.AboutUrl);
      }
      
//=====================================================================
//
//=====================================================================
      
      // used in loading editor world
      public static var mPauseCreateShapeProxy:Boolean = false;
      
//=====================================================================
//
//=====================================================================
      
      private static var mHasSettingDialogOpened:Boolean = false;
      
      public static function SetHasSettingDialogOpened (opened:Boolean):void
      {
         mHasSettingDialogOpened = opened;
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
      public static var mFunctionEditingView:FunctionEditingView = null;
      
//=====================================================================
//   key listener
//=====================================================================
      
      public static function OnKeyDown (event:KeyboardEvent):void
      {
         switch (event.keyCode)
         {
            case Keyboard.F3:
               AssetImageModuleListDialog.ShowAssetImageModuleListDialog ();
               break;
            case Keyboard.F4:
               AssetSoundListDialog.ShowAssetSoundListDialog ();
               break;
         }
            
         if (HasSettingDialogOpened ())
            return;
         
         if (HasInputFocused ())
            return;
         
         if (mKeyboardListener == null)
         {
            mEditorWorldView.OnKeyDown (event);
         }
         else
         {
            mKeyboardListener.OnKeyDown (event);
         }
      }
      
      private static var mKeyboardListener:KeyboardListener = null;
      
      public static function SetKeyboardListener (keyboardListener:KeyboardListener):void
      {
         mKeyboardListener = keyboardListener;
      }
      
      public static function GetKeyboardListener ():KeyboardListener
      {
         return mKeyboardListener;
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
      
      public static var mSessionVariablesEditingDialogClosedCallBack:Function = null;
      public static var mGlobalVariablesEditingDialogClosedCallBack:Function = null;
      public static var mEntityVariablesEditingDialogClosedCallBack:Function = null;
      public static var mLocalVariablesEditingDialogClosedCallBack:Function = null;
      public static var mInputVariablesEditingDialogClosedCallBack:Function = null;
      public static var mOutputVariablesEditingDialogClosedCallBack:Function = null;
      
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
            
            Runtime.mCopiedCodeSnippet = codeSnippet.Clone(ownerFunctionDefinition.Clone ());
         }
      }
      
      public static function CloneCopiedCodeSnippet (ownerFunctionDefinition:FunctionDefinition):CodeSnippet
      {
         if (mCopiedCodeSnippet == null)
         {
            return null;
         }
         else
         {
            mCopiedCodeSnippet.ValidateCallings ();
            
            var codeSnippet:CodeSnippet = Runtime.mCopiedCodeSnippet.Clone (ownerFunctionDefinition);
            codeSnippet.DisplayValues2PhysicsValues (GetCurrentWorld ().GetCoordinateSystem ());
            
            return codeSnippet;
         }
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
