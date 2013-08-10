
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
   
   import editor.trigger.ClassCustom;
   import editor.trigger.VariableSpaceClassInstance;
   
   import editor.display.dialog.NameSettingDialog;
   
   import editor.EditorContext;
   
   import common.Define;
   
   public class AssetClass extends Asset implements Linkable
   {
      protected var mCodeLibManager:CodeLibManager;
      protected var mClassId:int = -1;
      
      protected var mPackage:AssetPackage = null;
      
      protected var mCustomClass:ClassCustom;
      
      private var mHalfWidth:Number;
      private var mHalfHeight:Number;
      
      private var mHalfTextWidth:Number;
      private var mHalfTextHeight:Number;
      
      public function AssetClass (codeLibManager:CodeLibManager, key:String, name:String)
      {
         super (codeLibManager, key, name);
         
         doubleClickEnabled = true;
         
         mCodeLibManager = codeLibManager;
         
         mouseChildren = false;
         
         mCustomClass = new ClassCustom (GetName ());
      }
      
      public function SetClassIndex (classId:int):void
      {
         mClassId = classId;
         if (mCustomClass != null)
         {
            mCustomClass.SetID (mClassId);
         }
      }
      
      public function GetClassIndex ():int
      {
         return mClassId;
      }
      
      public function SetPackage (thePacakge:AssetPackage):void
      {
         mPackage = thePacakge;
      }
      
      public function GetPackage ():AssetPackage
      {
         if (mPackage != null && (mPackage.GetPackageIndex () < 0 || mPackage.GetCreationOrderId () < 0))
            mPackage = null;
         
         return mPackage;
      }
      
      public function GetCustomClass ():ClassCustom
      {
         return mCustomClass;
      }
      
      override public function ToCodeString ():String
      {
         return "Type#" + GetClassIndex ();
      }
      
      override public function GetTypeName ():String
      {
         return "Type";
      }
      
      override protected function OnNameChanged ():void
      {
         if (mCustomClass != null)
         {
            mCustomClass.SetName (GetName ());
         }
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
         
         var className:String = GetName ();
         
         className = TextUtil.GetHtmlEscapedText (className);
         
         var textField:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>&lt;" + GetClassIndex () + "&gt; " + className + "</font>", false, 0xFFFFFF, 0x0);
            
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
         
         GraphicsUtil.ClearAndDrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, -1, true, 0xFD8A7D);
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
         var menuItemChangeOrder:ContextMenuItem = new ContextMenuItem("Change Type Order ID ...");
         
         menuItemChangeOrder.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_ChangeOrderID);
         
         customMenuItemsStack.push (menuItemChangeOrder);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
         mCodeLibManager.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_ChangeOrderID (event:ContextMenuEvent):void
      {
         EditorContext.ShowModalDialog (NameSettingDialog, ConfirmChangeOrderID, 
                                    {mName: "" + GetClassIndex (), 
                                     mLabel: "New Order ID",
                                     mTitle: "Change Type Order ID"});
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
         
         codeLibManager.ChangeClassOrderIDs (GetClassIndex (), newIndex);
      }
      
//====================================================================
//   linkable
//====================================================================
      
      public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
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
      
      public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mCodeLibManager, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      public function TryToCreateLink (fromManagerDisplayX:Number, fromManagerDisplayY:Number, toAsset:Asset, toManagerDisplayX:Number, toManagerDisplayY:Number):Boolean
      {
         return false;
      }
      
//====================================================================
//   draw links
//====================================================================
      
      override public function DrawAssetLinks (canvasSprite:Sprite, forceDraw:Boolean, isExpanding:Boolean = false):void
      {
         var parentPackage:AssetPackage = GetPackage ();
         if (parentPackage != null)
         {
            var parentPoint:Point = DisplayObjectUtil.LocalToLocal (parentPackage, mCodeLibManager, new Point (parentPackage.GetHalfWidth (), 0));
            var thisPoint  :Point = DisplayObjectUtil.LocalToLocal (this, mCodeLibManager, new Point (- GetHalfWidth (), 0));
         
            GraphicsUtil.DrawLine (canvasSprite, thisPoint.x, thisPoint.y, parentPoint.x, parentPoint.y, 0x0, 0);
         }
      }
      
   }
}
