
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
      
   import editor.display.dialog.NameSettingDialog;
   
   import editor.trigger.CodePackage;
   
   import editor.EditorContext;
   
   import common.Define;
   
   public class AssetPackage extends AssetCodeLibElement // Asset implements Linkable
   {
      protected var mPackageId:int = -1;
      
      protected var mCodePackageData:CodePackage; // not null for sure
      
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
         
         mCodePackageData = new CodePackage (GetName ());
      }
      
      override public function Destroy ():void
      {
         SetPackageIndex (-1);
         
         super.Destroy ();
      }
      
      public function SetPackageIndex (packageId:int):void
      {
         mPackageId = packageId;
      }
      
      public function GetPackageIndex ():int
      {
         return mPackageId;
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
      
      public function GetCodePackageData ():CodePackage
      {
         return mCodePackageData;
      }
      
      public function OnElementAdded (element:AssetCodeLibElement):void
      {
         if (element is AssetPackage)
         {
            mCodePackageData.AddChildCodePackage ((element as AssetPackage).GetCodePackageData ());
         }
         else if (element is AssetClass)
         {
            mCodePackageData.AddClass ((element as AssetClass).GetCustomClass ());
         }
         else if (element is AssetFunction)
         {
            mCodePackageData.AddFunctionDeclaration ((element as AssetFunction).GetFunctionDeclaration ());
         }
      }
      
      public function OnElementRemoved (element:AssetCodeLibElement):void
      {
         if (element is AssetPackage)
         {
            mCodePackageData.RemoveChildCodePackage ((element as AssetPackage).GetCodePackageData ());
         }
         else if (element is AssetClass)
         {
            mCodePackageData.RemoveClass ((element as AssetClass).GetCustomClass ());
         }
         else if (element is AssetFunction)
         {
            mCodePackageData.RemoveFunctionDeclaration ((element as AssetFunction).GetFunctionDeclaration ());
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
      
      override public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         //if (localX > mTextFieldCenterX - mTextFieldHalfWidth && localX < mTextFieldCenterX + mTextFieldHalfWidth && localY > mTextFieldCenterY - mTextFieldHalfHeight && localY < mTextFieldCenterY + mTextFieldHalfHeight)
         //   return -1;
         if (localX > - mHalfTextWidth && localX < mHalfTextWidth) // && localY > - mIconHalfHeight && localY < mIconHalfHeight)
         {
            return -1;
         }
         
         return localX > 0 ? 1 : 0;
      }
      
      override public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mCodeLibManager, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      override public function TryToCreateLink (fromManagerDisplayX:Number, fromManagerDisplayY:Number, toAsset:Asset, toManagerDisplayX:Number, toManagerDisplayY:Number):Boolean
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
               if ((fromZoneId == 0 || toZoneId == 1) && CanStayInPackage (toPackage))
               {
                  if (this.IsInPackage (toPackage))
                     this.RemoveFromPackage (toPackage);
                  else
                     this.AddIntoPackage (toPackage);
               }
               
               if ((toZoneId == 0 || fromZoneId == 1) && toPackage.CanStayInPackage (this))
               {
                  if (toPackage.IsInPackage (this))
                     toPackage.RemoveFromPackage (this);
                  else
                     toPackage.AddIntoPackage (this);
               }
               
               return true;
            }
         }
         else if (toAsset is AssetFunction)
         {
            if ((toAsset as AssetFunction).IsInPackage (this))
               (toAsset as AssetFunction).RemoveFromPackage (this);
            else
               (toAsset as AssetFunction).AddIntoPackage (this);
            
            return true;
         }
         else if (toAsset is AssetClass)
         {
            if ((toAsset as AssetClass).IsInPackage (this))
               (toAsset as AssetClass).RemoveFromPackage (this);
            else
               (toAsset as AssetClass).AddIntoPackage (this);
            
            return true;
         }
         
         return false;
      }
      
      private function CanStayInPackage (thePackage:AssetPackage):Boolean
      {  
         if (thePackage == null || thePackage.GetPackageIndex () < 0)
            return false;
         
         if (this == thePackage)
            return false;
         
         var actionId:int = ++ EditorContext.mNextActionId;
         return ! thePackage.IsInPackageDirectlyOrIndirectly (this, actionId);
      }
      
      private function IsInPackageDirectlyOrIndirectly (thePackage:AssetPackage, actionId:int):Boolean
      {
         for each (var aPackage:AssetPackage in mPackages)
         {
            if (aPackage.GetCurrentActionId () < actionId)
            {
               aPackage.SetCurrentActionId (actionId);
               
               if (thePackage == aPackage)
                  return true;
               
               return aPackage.IsInPackageDirectlyOrIndirectly (thePackage, actionId);
            }
         }
         
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
            
               GraphicsUtil.DrawLine (canvasSprite, thisPoint.x, thisPoint.y, packagePoint.x, packagePoint.y, 0x0, 0);
            }
         }
      }
      
   }
}
