
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
   
   public class AssetPackage extends Asset implements Linkable
   {
      protected var mCodeLibManager:CodeLibManager;
      protected var mPackageId:int = -1;
      
      protected var mParentPackage:AssetPackage = null;
      
      private var mHalfWidth:Number;
      private var mHalfHeight:Number;
      
      private var mHalfTextWidth:Number;
      private var mHalfTextHeight:Number;
      
      public function AssetPackage (codeLibManager:CodeLibManager, key:String, name:String)
      {
         super (codeLibManager, key, name);
         
         doubleClickEnabled = true;
         
         mCodeLibManager = codeLibManager;
         
         mouseChildren = false;
      }
      
      public function SetPackageIndex (packageId:int):void
      {
         mPackageId = packageId;
      }
      
      public function GetPackageIndex ():int
      {
         return mPackageId;
      }
      
      public function SetParentPackage (parentPacakge:AssetPackage):void
      {
         mParentPackage = parentPacakge;
      }
      
      public function GetParentPackage ():AssetPackage
      {
         if (mParentPackage != null && (mParentPackage.GetPackageIndex () < 0 || mParentPackage.GetCreationOrderId () < 0))
            mParentPackage = null;
         
         return mParentPackage;
      }
      
      override public function ToCodeString ():String
      {
         return "Package#" + GetPackageIndex ();
      }
      
      override public function GetTypeName ():String
      {
         return "Package";
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
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var packageName:String = GetName ();
         
         packageName = TextUtil.GetHtmlEscapedText (packageName);
         
         var textField:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>&lt;" + GetPackageIndex () + "&gt; " + packageName + "</font>", false, 0xFFFFFF, 0x0);
            
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
         
         mHalfWidth = mHalfTextWidth + 10;
         mHalfHeight = mHalfTextHeight;
         
         GraphicsUtil.ClearAndDrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, -1, true, 0xB08888);
         GraphicsUtil.DrawRect (this, - mHalfTextWidth, - mHalfTextHeight, mHalfTextWidth + mHalfTextWidth, mHalfTextHeight + mHalfTextHeight, 0x0, 1, true, 0xC0FFC0);
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
         var menuItemChangeOrder:ContextMenuItem = new ContextMenuItem("Change Package Order ID ...");
         
         menuItemChangeOrder.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_ChangeOrderID);
         
         customMenuItemsStack.push (menuItemChangeOrder);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
         mCodeLibManager.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_ChangeOrderID (event:ContextMenuEvent):void
      {
         EditorContext.ShowModalDialog (NameSettingDialog, ConfirmChangeOrderID, 
                                    {mName: "" + GetPackageIndex (), 
                                     mLabel: "New Order ID",
                                     mTitle: "Change Package Order ID"});
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
         
         codeLibManager.ChangePackageOrderIDs (GetPackageIndex (), newIndex);
      }
      
//====================================================================
//   linkable
//====================================================================
      
      public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         //if (localX > mTextFieldCenterX - mTextFieldHalfWidth && localX < mTextFieldCenterX + mTextFieldHalfWidth && localY > mTextFieldCenterY - mTextFieldHalfHeight && localY < mTextFieldCenterY + mTextFieldHalfHeight)
         //   return -1;
         if (localX > - mHalfTextWidth && localX < mHalfTextWidth) // && localY > - mIconHalfHeight && localY < mIconHalfHeight)
         {
            return -1;
         }
         
         return localX > 0 ? 1 : 0;
      }
      
      public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mCodeLibManager, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      public function TryToCreateLink (fromManagerDisplayX:Number, fromManagerDisplayY:Number, toAsset:Asset, toManagerDisplayX:Number, toManagerDisplayY:Number):Boolean
      {
         if (toAsset is AssetPackage)
         {
            var toPackage:AssetPackage = toAsset as AssetPackage;
            
            var fromPoint:Point = DisplayObjectUtil.LocalToLocal (mCodeLibManager, this, new Point (fromManagerDisplayX, fromManagerDisplayY));
            var fromZoneId:int = this.GetLinkZoneId (fromPoint.x, fromPoint.y);
            
            var toPoint:Point = DisplayObjectUtil.LocalToLocal (mCodeLibManager, toAsset, new Point (toManagerDisplayX, toManagerDisplayY));
            var toZoneId:int = toPackage.GetLinkZoneId (toPoint.x, toPoint.y);
            
            if (fromZoneId != toZoneId)
            {
               if ((fromZoneId == 0 || toZoneId == 1) && (! toPackage.IsInPackage (this)))
               {
                  if (this.GetParentPackage () == toPackage)
                     this.SetParentPackage (null);
                  else
                     this.SetParentPackage (toPackage);
               }
               
               if ((toZoneId == 0 || fromZoneId == 1) && (! this.IsInPackage (toPackage)))
               {
                  if (toPackage.GetParentPackage () == this)
                     toPackage.SetParentPackage (null);
                  else
                     toPackage.SetParentPackage (this);
               }
               
               return true;
            }
         }
         else if (toAsset is AssetFunction)
         {
            if ((toAsset as AssetFunction).GetPackage () == this)
               (toAsset as AssetFunction).SetPackage (null);
            else
               (toAsset as AssetFunction).SetPackage (this);
            
            return true;
         }
         else if (toAsset is AssetClass)
         {
            if ((toAsset as AssetClass).GetPackage () == this)
               (toAsset as AssetClass).SetPackage (null);
            else
               (toAsset as AssetClass).SetPackage (this);
            
            return true;
         }
         
         return false;
      }
      
      private function IsInPackage (thePackage:AssetPackage):Boolean
      {
         var aPackage:AssetPackage = this;
         while (aPackage != thePackage)
         {
            aPackage = aPackage.GetParentPackage ();
            if (aPackage == null)
            {
               break;
            }
         }
         
         return aPackage != null;
      }
      
//====================================================================
//   draw links
//====================================================================
      
      override public function DrawAssetLinks (canvasSprite:Sprite, forceDraw:Boolean, isExpanding:Boolean = false):void
      {
         var parentPackage:AssetPackage = GetParentPackage ();
         if (parentPackage != null)
         {
            var parentPoint:Point = DisplayObjectUtil.LocalToLocal (parentPackage, mCodeLibManager, new Point (parentPackage.GetHalfWidth (), 0));
            var thisPoint  :Point = DisplayObjectUtil.LocalToLocal (this, mCodeLibManager, new Point (- GetHalfWidth (), 0));
         
            GraphicsUtil.DrawLine (canvasSprite, thisPoint.x, thisPoint.y, parentPoint.x, parentPoint.y, 0x0, 0);
         }
      }
      
   }
}
