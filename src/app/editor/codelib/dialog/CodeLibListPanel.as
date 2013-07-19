
package editor.codelib.dialog {
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.events.EventPhase;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import flash.net.URLRequest;
   import flash.geom.Point;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import mx.controls.RadioButton;
   
   import com.tapirgames.util.TimeSpan;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   
   import editor.asset.Asset;
   import editor.asset.AssetManagerPanel;
   import editor.asset.IntentPutAsset;
   
   import editor.codelib.CodeLibManager;
   import editor.codelib.AssetFunction;
   
   import editor.trigger.CodeSnippet;
   
   import editor.display.dialog.FunctionEditDialog;
   import editor.EditorContext;
   
   import common.Define;
   import common.Version;
   
   public class CodeLibListPanel extends AssetManagerPanel
   {
      private var mCodeLibManager:CodeLibManager = null;
      
      public function SetCodeLibManager (codeLibManager:CodeLibManager):void
      {
         if (mCodeLibManager != codeLibManager)
         {
            mCodeLibManager = codeLibManager;
         }
         
         super.SetAssetManager (codeLibManager);
         
         UpdateInterface ();
      }
      
      public function GetCodeLibManager ():CodeLibManager
      {
         return mCodeLibManager;
      }
      
//============================================================================
//   
//============================================================================
      
      override public function UpdateInterface ():void
      {
         var numSelecteds:int = 0;
         var onlySelected:Asset = null;
         if (mCodeLibManager != null)
         {
            var selecteds:Array = mCodeLibManager.GetSelectedAssets ();
            numSelecteds = selecteds.length;
            
            if (numSelecteds == 1)
               onlySelected = selecteds [0] as Asset;
         }
         
         mButtonDelete.enabled = numSelecteds > 0;
         mButtonSetting.enabled = (onlySelected is AssetFunction);
         
         mLabelName.enabled = numSelecteds == 1;
         mTextInputName.enabled = numSelecteds == 1;
         
         if (onlySelected != null)
         {
            mTextInputName.text = onlySelected.GetName ();
         }
         else
         {
            mTextInputName.text = "";
         }
      }
      
//============================================================================
//   
//============================================================================
      
      public var mButtonCreatePureFunction:Button;
      public var mButtonCreateDirtyFunction:Button;
      //public var mButtonCreatePackage:Button;
      //public var mButtonCreateClass:Button;
      
      private var mCurrentSelectedCreateButton:Button = null;
      
      protected function OnCreatingFinished (asset:Asset):void
      {
         if (mCurrentSelectedCreateButton != null)
            mCurrentSelectedCreateButton.selected = false;
         
         mCurrentSelectedCreateButton = null;
         
         OnAssetSelectionsChanged (false);
      }
      
      protected function OnCreatingCancelled (asset:Asset = null):void
      {
         DeleteSelectedAssets ();
         OnAssetSelectionsChanged ();
                  
         if (mCurrentSelectedCreateButton != null)
            mCurrentSelectedCreateButton.selected = false;
         
         mCurrentSelectedCreateButton = null;
      }
      
      protected function OnPutingCreating (asset:Asset, done:Boolean):void
      {
         if (done)
         {
            OnCreatingFinished (asset);
         }
      }
      
      public function OnCreateButtonClick (event:MouseEvent):void
      {
         if (! event.target is Button)
            return;
         
         SetCurrentIntent (null);
         
         // cancel old
         if (mCurrentSelectedCreateButton == event.target)
         {
            mCurrentSelectedCreateButton = null;
            return;
         }
         
         mCurrentSelectedCreateButton = event.target as Button;
         
         switch (event.target)
         {
            case mButtonCreatePureFunction:
               SetCurrentIntent (new IntentPutAsset (
                                 mCodeLibManager.CreateFunction (null, null, false, true), 
                                 OnPutingCreating, OnCreatingCancelled));
               break;
            case mButtonCreateDirtyFunction:
               SetCurrentIntent (new IntentPutAsset (
                                 mCodeLibManager.CreateFunction (null, null, true, true), 
                                 OnPutingCreating, OnCreatingCancelled));
               break;
            //case mButtonCreatePackage:
            //   //SetCurrentIntent (new FunctionModePlaceCreateAsset (this, CreateAssetFunctionPackage));
            //   break;
            //case mButtonCreateClass:
            //   //SetCurrentIntent (new FunctionModePlaceCreateAsset (this, CreateAssetClass));
            //   break;
         // ...
            default:
               SetCurrentIntent (null);
               break;
         }
         
      }
      
      public var mButtonDelete:Button;
      public var mButtonSetting:Button;
      
      public function OnEditButtonClick (event:MouseEvent):void
      {
         switch (event.target)
         {
            case mButtonDelete:
               DeleteSelectedAssets ();
               break;
            case mButtonSetting:
               OpenAssetSettingDialog ();
               break;
            default:
               break;
         }
      }
      
      public var mLabelName:Label;
      public var mTextInputName:TextInput;
      public var mButtonIsPure:RadioButton;
      public var mButtonIsDirty:RadioButton;
      
      public function OnTextInputEnter (event:Event):void
      {
         if (event.target == mTextInputName)
         {
            if (mCodeLibManager == null)
               return;
            
            if (mCodeLibManager.GetNumSelectedAssets () != 1)
               return;
            
            var asset:Asset = mCodeLibManager.GetSelectedAssets () [0] as Asset;
            
            if (asset is AssetFunction)
            {
               (asset as AssetFunction).SetFunctionName (mTextInputName.text);
               (asset as AssetFunction).UpdateTimeModified ();
            }
            
            asset.UpdateAppearance ();
            
            UpdateInterface ();
         }
      }
      
      private function OpenAssetSettingDialog ():void
      {
         if (EditorContext.GetSingleton ().HasSettingDialogOpened ())
            return;
         
         var selectedAssets:Array = mCodeLibManager.GetSelectedAssets ();
         if (selectedAssets == null || selectedAssets.length != 1)
            return;
         
         var asset:Asset = selectedAssets [0] as Asset;
         
         var values:Object = new Object ();
         
         if (asset is AssetFunction)
         {
            var aFunction:AssetFunction = asset as AssetFunction;
            
            values.mCodeLibManager = mCodeLibManager;
            values.mCodeSnippetName = aFunction.GetCodeSnippetName ();
            values.mCodeSnippet  = aFunction.GetCodeSnippet ().Clone (mCodeLibManager.GetScene (), true, null);
            (values.mCodeSnippet as CodeSnippet).DisplayValues2PhysicsValues (mCodeLibManager.GetScene ().GetCoordinateSystem ());
            
            EditorContext.ShowModalDialog (FunctionEditDialog, ConfirmSettingAssetProperties, values);
         }
      }
      
      private function ConfirmSettingAssetProperties (params:Object):void
      {
         var selectedAssets:Array = mCodeLibManager.GetSelectedAssets ();
         if (selectedAssets == null || selectedAssets.length != 1)
            return;
         
         var asset:Asset = selectedAssets [0] as Asset;
         
         if (asset is AssetFunction)
         {
            var aFunction:AssetFunction = asset as AssetFunction;
            
            var code_snippet:CodeSnippet = aFunction.GetCodeSnippet ();
            code_snippet.AssignFunctionCallings (params.mReturnFunctionCallings);
            code_snippet.PhysicsValues2DisplayValues (mCodeLibManager.GetScene ().GetCoordinateSystem ());
            
            aFunction.UpdateTimeModified ();
         }
      }
      
   }
}
