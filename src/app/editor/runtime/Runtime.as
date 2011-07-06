package editor.runtime {
   
   import flash.display.DisplayObject;
   
   import editor.world.World;
   
   import editor.WorldView;
   import editor.CollisionManagerView;
   import editor.FunctionEditingView;
   
   import editor.trigger.CodeSnippet;
   import editor.trigger.FunctionDefinition
   
   import common.Define;
   
   public class Runtime
   {
   
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