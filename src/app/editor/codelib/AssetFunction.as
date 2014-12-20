
package editor.codelib {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.media.SoundMixer;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
         
   import flash.net.FileReference;
   import flash.net.FileFilter;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   import editor.asset.Linkable;
   
   import editor.trigger.FunctionDefinition;
   import editor.trigger.CodeSnippet;
   import editor.trigger.FunctionDeclaration;
   import editor.trigger.FunctionDeclaration_Custom;
   
   import editor.display.dialog.NameSettingDialog;
   
   import editor.EditorContext;
   
   import common.Define;
   
   public class AssetFunction extends AssetCodeLibElement // Asset implements Linkable
   {
      protected var mFunctionId:int = -1;
      
      protected var mCodeSnippet:CodeSnippet;
      protected var mFunctionDeclaration:FunctionDeclaration_Custom;
      protected var mFunctionDefinition:FunctionDefinition;
      
      private var mHalfWidth:Number;
      private var mHalfHeight:Number;
      
      private var mHalfTextWidth:Number;
      private var mHalfTextHeight:Number;
      
      public function AssetFunction (codeLibManager:CodeLibManager, key:String, name:String)
      {
         super (codeLibManager, key, name);
         
         doubleClickEnabled = true;
         
         mouseChildren = false;
         
         mFunctionDeclaration = new FunctionDeclaration_Custom (mName);
         mFunctionDefinition = new FunctionDefinition (/*mCodeLibManager.mWorld.GetTriggerEngine (), */mFunctionDeclaration, true);
         mCodeSnippet = new CodeSnippet (mFunctionDefinition);
      }
      
      override public function Destroy ():void
      {
         SetFunctionIndex (-1);
         
         mFunctionDeclaration.NotifyRemoved ();
         
         // if a calling call this function, the calling will be converted into CoreFunctionIds.ID_Removed, when
         // 1. editing open the dialog to edit the calling's code snippet.
         // 2. saving as WorldDefine.
         //
         // maybe this lazy handling is not good and it is better to put this handling in mCodeLibManager.DestroyAsset ().
         
         super.Destroy ();
      }
      
      public function SetFunctionIndex (functionId:int):void
      {
         mFunctionId = functionId;
         
         mFunctionDeclaration.SetID (mFunctionId);
      }
      
      public function GetFunctionIndex ():int
      {
         return mFunctionId;
      }
      
      public function IsDesignDependent ():Boolean
      {
         return mFunctionDefinition.IsDesignDependent ();
      }
      
      public function SetDesignDependent (designDependent:Boolean):void
      {
         mFunctionDefinition.SetDesignDependent (designDependent);
      }
      
      override public function ToCodeString ():String
      {
         return "Function#" + GetFunctionIndex ();
      }
      
      override public function GetTypeName ():String
      {
         return "Function";
      }
      
      //public function GetFunctionName ():String
      //{
      //   return GetName ();
      //}
      
      //public function SetFunctionName (newName:String, checkValidity:Boolean = true):void
      //{
      //   if (checkValidity)
      //   {
      //      mCodeLibManager.ChangeFunctionName (newName, GetName ());
      //   }
      //   else
      //   {
      //      SetName (newName);
      //      
      //      mFunctionDeclaration.SetName (newName);
      //      mFunctionDeclaration.ParseAllCallingTextSegments ();
      //   }
      //}
      
      override protected function OnNameChanged ():void
      {
         if (mFunctionDeclaration != null)
         {
            mFunctionDeclaration.SetName (GetName ());
            mFunctionDeclaration.ParseAllCallingTextSegments ();
         }
      }
      
      public function Reset ():void
      {  
         mCodeSnippet.ClearFunctionCallings ();
         //mCodeSnippet.GetOwnerFunctionDefinition ()
         mFunctionDefinition.GetInputVariableSpace ().DestroyAllVariableInstances ();
         mFunctionDefinition.GetOutputVariableSpace ().DestroyAllVariableInstances ();
         mFunctionDefinition.GetLocalVariableSpace ().DestroyAllVariableInstances ();
      }
      
//=======================================================================================
// 
//=======================================================================================
      
      private var mLastModifyTimesOfInputVariableSpace:int = 0;
      private var mLastModifyTimesOfOutputVariableSpace:int = 0;
      private var mLastModifyTimesOfLocalVariableSpace:int = 0;
      
      override public function Update (escapedTime:Number):void
      {
         if (  mFunctionDefinition.GetInputVariableSpace ().GetNumModifiedTimes () > mLastModifyTimesOfInputVariableSpace
            || mFunctionDefinition.GetOutputVariableSpace ().GetNumModifiedTimes () > mLastModifyTimesOfOutputVariableSpace
            || mFunctionDefinition.GetLocalVariableSpace ().GetNumModifiedTimes () > mLastModifyTimesOfLocalVariableSpace
            )
         {
            UpdateTimeModified ();
         }
      }
      
      override public function SetTimeModified (time:Number):void
      {
         super.SetTimeModified (time);
         
         mLastModifyTimesOfInputVariableSpace = mFunctionDefinition.GetInputVariableSpace ().GetNumModifiedTimes ();
         mLastModifyTimesOfOutputVariableSpace = mFunctionDefinition.GetOutputVariableSpace ().GetNumModifiedTimes ();
         mLastModifyTimesOfLocalVariableSpace = mFunctionDefinition.GetLocalVariableSpace ().GetNumModifiedTimes ();
      }
      
//=======================================================================================
// code snippet
//=======================================================================================
      
      public function GetCodeSnippetName ():String
      {
         return mCodeSnippet.GetName ();
      }
      
      public function SetCodeSnippetName (name:String):void
      {
         mCodeSnippet.SetName (name);
      }
      
      public function GetCodeSnippet ():CodeSnippet
      {
         return mCodeSnippet;
      }
      
      public function ValidateEntityLinks ():void
      {
         //mCodeSnippet.ValidateValueSourcesAndTargets ();
      }
      
      public function GetFunctionDeclaration ():FunctionDeclaration_Custom
      {
         return mFunctionDeclaration;
      }
      
      public function GetFunctionDefinition ():FunctionDefinition
      {
         return mFunctionDefinition;
      }
      
//=============================================================
//   
//=============================================================
      
      public function GetHalfWidth ():Number
      {
         return mHalfWidth;
      }
      
      public function GetHalfHeight ():Number
      {
         return mHalfHeight;
      }
      
      private static const kDragLinkHandlerWidth:int = 10;
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var funcName:String = GetName ();
         
         funcName = TextUtil.GetHtmlEscapedText (funcName);
         
         var textField:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>&lt;" + GetFunctionIndex () + "&gt; " + funcName + "</font>", false, 0xFFFFFF, 0x0);
            
         addChild (textField);
         
         textField.x = - textField.width * 0.5;
         textField.y = - textField.height * 0.5;
         
         var borderColor:uint;
         var borderSize :int;
         
         if ( IsSelected () )
         {
            borderColor = Define.BorderColorSelectedObject;
            borderSize  = 3;
         }
         else
         {
            borderColor = 0x0;
            borderSize = 1;
         }
         
         mHalfTextWidth = 0.5 * textField.width + 2;
         mHalfTextHeight = 0.5 * textField.height + 1;
         
         textField.x += (kDragLinkHandlerWidth >> 1);
         mHalfWidth = mHalfTextWidth + (kDragLinkHandlerWidth >> 1);
         mHalfHeight = mHalfTextHeight;
         
         GraphicsUtil.ClearAndDrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, -1, true, IsDesignDependent () ? 0xFFC20E : 0xC0FFC0);
         GraphicsUtil.DrawRect (this, - mHalfWidth, - mHalfHeight, kDragLinkHandlerWidth, mHalfHeight + mHalfHeight, 0x0, 1, true, 0xB08888);
         GraphicsUtil.DrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderSize, false);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mCodeLibManager.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (GetPositionX (), GetPositionY (), mHalfWidth, mHalfHeight, GetRotation ());
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemChangeOrder:ContextMenuItem = new ContextMenuItem("Change Function Order ID ...");
         
         menuItemChangeOrder.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_ChangeOrderID);
         
         customMenuItemsStack.push (menuItemChangeOrder);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
         mCodeLibManager.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_ChangeOrderID (event:ContextMenuEvent):void
      {
         EditorContext.OpenSettingsDialog (NameSettingDialog, ConfirmChangeOrderID, 
                                    {mName: "" + GetFunctionIndex (), 
                                     mLabel: "New Order ID",
                                     mTitle: "Change Function Order ID"});
      }
      
      private function ConfirmChangeOrderID (params:Object):void
      {
         if (params == null || params.mName == null)
            return;
         
         var newIndex:int = parseInt (params.mName);
         if (isNaN (newIndex) || newIndex < 0)
            return;
         
         var codeLibManager:CodeLibManager = GetAssetManager () as CodeLibManager; 
         //codeLibManager.MoveAssetsToIndex ([this], newIndex);
         //codeLibManager.OnFunctionOrderIDsChanged ();
         
         codeLibManager.ChangeFunctionOrderIDs (GetFunctionIndex (), newIndex);
      }
      
//====================================================================
//   linkable
//====================================================================
      
      override public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         //if (localX > mTextFieldCenterX - mTextFieldHalfWidth && localX < mTextFieldCenterX + mTextFieldHalfWidth && localY > mTextFieldCenterY - mTextFieldHalfHeight && localY < mTextFieldCenterY + mTextFieldHalfHeight)
         //   return -1;
         //if (localX > - mHalfTextWidth) // && localX < mHalfTextWidth) // && localY > - mIconHalfHeight && localY < mIconHalfHeight)
         if (localX > - mHalfTextWidth + (kDragLinkHandlerWidth >> 1))
         {
            return -1;
         }
         
         return 0;
      }
      
      override public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mCodeLibManager, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      override public function TryToCreateLink (fromManagerDisplayX:Number, fromManagerDisplayY:Number, toAsset:Asset, toManagerDisplayX:Number, toManagerDisplayY:Number):Boolean
      {
         return false;
      }
      
//====================================================================
//   draw links
//====================================================================
      
      override public function DrawAssetLinks (canvasSprite:Sprite, forceDraw:Boolean, isExpanding:Boolean = false):void
      {
         for each (var aPackage:AssetPackage in mPackages)
         {
            var index:int = aPackage.GetPackageIndex ();
            if (index >= 0)
            {
               var packagePoint:Point = DisplayObjectUtil.LocalToLocal (aPackage, mCodeLibManager, new Point (aPackage.GetHalfWidth (), 0));
               var thisPoint  :Point = DisplayObjectUtil.LocalToLocal (this, mCodeLibManager, new Point (- GetHalfWidth (), 0));
            
               GraphicsUtil.DrawLine (canvasSprite, thisPoint.x, thisPoint.y, packagePoint.x, packagePoint.y, GetAssetManager ().GetLinkLineColor (), 0);
            }
         }
      }

  }
}
