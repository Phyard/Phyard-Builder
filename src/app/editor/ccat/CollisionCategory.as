
package editor.ccat {
   
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
   import com.tapirgames.util.ResourceLoadEvent;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   import editor.asset.Linkable;
   
   import common.Define;
   
   public class CollisionCategory extends Asset implements Linkable
   {
      protected var mCollisionCategoryManager:CollisionCategoryManager;
      
      // replaced with mName fron v1.53
      //private var mCategoryName:String = "Default Category";
      
      private var mCollideInternally:Boolean = true;
      
      private var mHalfWidth:Number;
      private var mHalfHeight:Number;
      
      private var mHalfTextWidth:Number;
      private var mHalfTextHeight:Number;
      
      public function CollisionCategory (collisionCategoryManager:CollisionCategoryManager, key:String)
      {
         super (collisionCategoryManager, key);
         
         mCollisionCategoryManager = collisionCategoryManager;
         
         mouseChildren = false;
      }
      
      public function GetCollisionCategoryManager ():CollisionCategoryManager
      {
         return mCollisionCategoryManager;
      }
      
      override public function ToCodeString ():String
      {
         return "CCat#" + GetCreationOrderId ();
      }
      
      override public function GetTypeName ():String
      {
         return "Collision Category";
      }
      
      public function GetCategoryName ():String
      {
         //return mCategoryName;
         return GetName ();
      }
      
      public function SetCategoryName (newName:String, checkValidity:Boolean = true):void
      {
         if (checkValidity)
         {
            mCollisionCategoryManager.ChangeCollisionCategoryName (newName, GetName ());
         }
         else
         {
            //mCategoryName = newName;
            SetName (newName);
            
            UpdateTimeModified ();
         }
      }
      
      public function IsCollideInternally ():Boolean
      {
         return mCollideInternally;
      }
      
      public function SetCollideInternally (collide:Boolean):void
      {
         mCollideInternally = collide;
         
         UpdateTimeModified ();
         
         mCollisionCategoryManager.SetChanged (true);
      }
      
      public function IsDefaultCategory ():Boolean
      {
         return mCollisionCategoryManager.GetDefaultCollisionCategory () == this;
      }
      
      public function SetAsDefaultCategory (isDefault:Boolean):void
      {
         if (!isDefault && mCollisionCategoryManager.GetDefaultCollisionCategory () == this)
            mCollisionCategoryManager.SetDefaultCollisionCategory (null);
         
         if (isDefault && mCollisionCategoryManager.GetDefaultCollisionCategory () != this)
            mCollisionCategoryManager.SetDefaultCollisionCategory (this);
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
         
         if (IsDefaultCategory ())
            ccName = "<b>" + ccName + "</b>";
         if (! IsCollideInternally ())
            ccName = "<i><u><b>" + ccName + "</b></u></i>";
         
         var textField:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>&lt;" + mCollisionCategoryManager.GetCollisionCategoryIndex (this) + "&gt; " + ccName + "</font>", false, 0xFFFFFF, 0x0);
            
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
         
         mHalfWidth = mHalfTextWidth + 15;
         mHalfHeight = mHalfTextHeight;
         
         GraphicsUtil.ClearAndDrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, -1, true, IsDefaultCategory () ? 0x6060FF : 0xFFA0A0);
         GraphicsUtil.DrawRect (this, - mHalfTextWidth, - mHalfTextHeight, mHalfTextWidth + mHalfTextWidth, mHalfTextHeight + mHalfTextHeight, 0x0, 1, true, IsCollideInternally () ? 0xFFFFFF : 0xD0FFD0);
         GraphicsUtil.DrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderSize, false);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mCollisionCategoryManager.GetSelectionEngine ().CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (GetPositionX (), GetPositionY (), mHalfWidth, mHalfHeight, GetRotation ());
      }
      
//=============================================================
//   context menu
//=============================================================
      
      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         var menuItemBreakAllLinks:ContextMenuItem = new ContextMenuItem("Break All Friend(s)");
         
         menuItemBreakAllLinks.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent_BreakAllLinks);
         
         customMenuItemsStack.push (menuItemBreakAllLinks);
         
         super.BuildContextMenuInternal (customMenuItemsStack);
         mCollisionCategoryManager.BuildContextMenuInternal (customMenuItemsStack);
      }
      
      private function OnContextMenuEvent_BreakAllLinks (event:ContextMenuEvent):void
      {
         mCollisionCategoryManager.BreakFriendLinks (this);
      }
      
 //====================================================================
//   linkable
//====================================================================
      
      public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         if (localX < - mHalfWidth || localX > mHalfWidth || localY < - mHalfHeight || localY > mHalfHeight)
            return -1;
         if (localX < - mHalfTextWidth || localX > mHalfTextWidth || localY < - mHalfTextHeight || localY > mHalfTextHeight)
            return 0;
         
         return -1;
      }
      
      public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mCollisionCategoryManager, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      public function TryToCreateLink (fromManagerDisplayX:Number, fromManagerDisplayY:Number, toAsset:Asset, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         return false; // this is not done by category. It is finished by category manamger.
      }

  }
}
