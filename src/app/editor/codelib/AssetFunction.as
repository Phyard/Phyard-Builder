
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
   import com.tapirgames.util.ResourceLoader;
   import com.tapirgames.util.ResourceLoadEvent;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   
   import editor.trigger.FunctionDefinition;
   import editor.trigger.CodeSnippet;
   import editor.trigger.TriggerEngine;
   import editor.trigger.FunctionDeclaration;
   import editor.trigger.FunctionDeclaration_Custom;
   
   import common.Define;
   
   public class AssetFunction extends Asset
   {
      protected var mCodeLibManager:CodeLibManager;
      protected var mFunctionId:int = -1;
      
      protected var mCodeSnippet:CodeSnippet;
      protected var mFunctionDeclaration:FunctionDeclaration_Custom;
      protected var mFunctionDefinition:FunctionDefinition;
      
      private var mHalfWidth:Number;
      private var mHalfHeight:Number;
      
      private var mHalfTextWidth:Number;
      private var mHalfTextHeight:Number;
      
      public function AssetFunction (codeLibManager:CodeLibManager)
      {
         super (codeLibManager);
         
         mCodeLibManager = codeLibManager;
         
         mouseChildren = false;
         
         mFunctionDeclaration = new FunctionDeclaration_Custom (mName);
         mFunctionDefinition = new FunctionDefinition (mCodeLibManager.mWorld.GetTriggerEngine (), mFunctionDeclaration, true);
         mCodeSnippet = new CodeSnippet (mFunctionDefinition);
      }
      
      override public function Destroy ():void
      {
         mFunctionDeclaration.SetID (-1);
         mFunctionDeclaration.NotifyRemoved ();
         
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
         return "Function#" + GetCreationOrderId ();
      }
      
      override public function GetTypeName ():String
      {
         return "Function";
      }
      
      public function GetFunctionName ():String
      {
         return GetName ();
      }
      
      public function SetFunctionName (newName:String, checkValidity:Boolean = true):void
      {
         if (checkValidity)
         {
            mCodeLibManager.ChangeFunctionName (newName, GetName ());
         }
         else
         {
            SetName (newName);
            
            mFunctionDeclaration.SetName (newName);
            mFunctionDeclaration.ParseAllCallingTextSegments ();
         }
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
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var ccName:String = GetName ();
         
         ccName = TextUtil.GetHtmlEscapedText (ccName);
         
         var textField:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>&lt;" + GetFunctionIndex () + "&gt; " + ccName + "</font>", false, 0xFFFFFF, 0x0);
            
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
         
         mHalfWidth = mHalfTextWidth;// + 15;
         mHalfHeight = mHalfTextHeight;
         
         GraphicsUtil.ClearAndDrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, -1, true, IsDesignDependent () ? 0xFFC20E : 0xC0FFC0);
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
         //var menuItemBreakAllLinks:ContextMenuItem = new ContextMenuItem("Break All Friend(s)");
         //
         //menuItemBreakAllLinks.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_BreakAllLinks);
         //
         //customMenuItemsStack.push (menuItemBreakAllLinks);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
         mCodeLibManager.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      //private function OnContextMenuEvent_BreakAllLinks (event:ContextMenuEvent):void
      //{
      //   mCollisionCategoryManager.BreakFriendLinks (this);
      //}

  }
}
