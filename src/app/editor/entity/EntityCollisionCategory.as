
package editor.entity {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.TextUtil;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.entity.Entity;
   
   import editor.world.CollisionManager;
   
   import editor.selection.SelectionProxy;
   
   import editor.trigger.entity.Linkable;
   
   import common.Define;
   
   public class EntityCollisionCategory extends Entity implements Linkable 
   {
      protected var mCollisionManager:CollisionManager;
      
      private var mCategoryName:String = "Default Category";
      
      private var mCollideInternally:Boolean = true;
      
      private var mHalfWidth:Number;
      private var mHalfHeight:Number;
      
      private var mHalfTextWidth:Number;
      private var mHalfTextHeight:Number;
      
      protected var mContextMenuItem_BreakAllLinks:ContextMenuItem;
      
      public function EntityCollisionCategory (cm:CollisionManager)
      {
         super (cm);
         
         mCollisionManager = cm;
         
         BuildContextMenu ();
         
         mouseChildren = false;
      }
      
      override public function ToCodeString ():String
      {
         return "CCat#" + mCreationOrderId;
      }
      
      public function IsDefaultCategory ():Boolean
      {
         return mCollisionManager.GetDefaultCollisionCategory () == this;
      }
      
      public function SetDefaultCategory (isDefault:Boolean):void
      {
         if (!isDefault && mCollisionManager.GetDefaultCollisionCategory () == this)
            mCollisionManager.SetDefaultCollisionCategory (null);
         
         if (isDefault && mCollisionManager.GetDefaultCollisionCategory () != this)
            mCollisionManager.SetDefaultCollisionCategory (this);
      }
      
      override public function GetTypeName ():String
      {
         return "Collision Category";
      }
      
      public function GetCategoryName ():String
      {
         return mCategoryName;
      }
      
      public function SetCategoryName (newName:String, checkValidity:Boolean = true):void
      {
         if (checkValidity)
            mCollisionManager.ChangeCollisionCategoryName (newName, mCategoryName)
         else
            mCategoryName = newName;
      }
      
      public function IsCollideInternally ():Boolean
      {
         return mCollideInternally;
      }
      
      public function SetCollideInternally (collide:Boolean):void
      {
         mCollideInternally = collide;
         
         mCollisionManager.SetChanged (true);
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var ccName:String = mCategoryName;
         
         ccName = TextUtil.GetHtmlEscapedText (ccName);
         
         if (IsDefaultCategory ())
            ccName = "<b>" + ccName + "</b>";
         if (! IsCollideInternally ())
            ccName = "<i><u><b>" + ccName + "</b></u></i>";
         
         var textField:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>&lt;" + mCollisionManager.GetCollisionCategoryIndex (this) + "&gt; " + ccName + "</font>", false, 0xFFFFFF, 0x0);
            
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
            mSelectionProxy = mCollisionManager.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle ( GetRotation (), GetPositionX (), GetPositionY (), mHalfWidth, mHalfHeight);
      }
      
 //====================================================================
//   context menu
//====================================================================
      
      private function BuildContextMenu ():void
      {
         contextMenu = new ContextMenu ();
         contextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = contextMenu.builtInItems;
         defaultItems.print = false;
         
         mContextMenuItem_BreakAllLinks = new ContextMenuItem ("Break All Friend(s)", false),
         contextMenu.customItems.push (mContextMenuItem_BreakAllLinks);
         mContextMenuItem_BreakAllLinks.addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
      }
      
      private function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         var ccat:EntityCollisionCategory = event.mouseTarget as EntityCollisionCategory;
         //if (ccat == null)
         //   return;
         if (ccat != this)
            return;
         
         if (event.target == mContextMenuItem_BreakAllLinks)
         {
            mCollisionManager.BreakFriendLinks (this);
         }
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
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mCollisionManager, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         return false; // this is not done by category. It is finished by category manamger.
      }
      
   }
}
