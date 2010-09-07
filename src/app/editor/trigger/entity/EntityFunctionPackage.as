
package editor.trigger.entity {
   
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
   
   import editor.world.FunctionManager;
   
   import editor.selection.SelectionProxy;
   
   import editor.trigger.entity.Linkable;
   
   import common.Define;
   
   public class EntityFunctionPackage extends Entity implements Linkable 
   {
      public static const DragLinkHandleWidth:int = 16;
      
      protected var mFunctionManager:FunctionManager;
      protected var mPackageId:int = -1;
      
      private var mHalfWidth:Number;
      private var mHalfHeight:Number;
      
      private var mHalfTextWidth:Number;
      private var mHalfTextHeight:Number;
      
      // links
      protected var mFunctions:Array = new Array ();
      protected var mSubPackages:Array = new Array ();
      
      //
      protected var mContextMenuItem_BreakAllLinks:ContextMenuItem;
      
      public function EntityFunctionPackage (fm:FunctionManager)
      {
         super (fm);
         
         mFunctionManager = fm;
         
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
      
      override public function ToCodeString ():String
      {
         return "Package#" + mCreationOrderId;
      }
      
      override public function GetTypeName ():String
      {
         return "Function Package";
      }
      
      public function GetPackageName ():String
      {
         return GetName ();
      }
      
      public function SetPackageName (newName:String, checkValidity:Boolean = true):void
      {
         if (checkValidity)
         {
            mFunctionManager.ChangePackageName (newName, GetName ());
         }
         else
         {
            SetName (newName);
         }
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var ccName:String = GetName ();
         
         ccName = TextUtil.GetHtmlEscapedText (ccName);
         
         var textField:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>&lt;" + GetPackageIndex () + "&gt; " + ccName + "</font>", false, 0xFFFFFF, 0x0);
            
         addChild (textField);
         
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
         
         mHalfWidth = mHalfTextWidth + DragLinkHandleWidth / 2;
         mHalfHeight = mHalfTextHeight;
         
         textField.x = - mHalfWidth;
         textField.y = - textField.height * 0.5;
         
         GraphicsUtil.ClearAndDrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, -1, true, 0x6060FF);
         GraphicsUtil.DrawRect (this, - mHalfWidth + 1, - mHalfTextHeight, mHalfTextWidth + mHalfTextWidth, mHalfTextHeight + mHalfTextHeight, 0x0, 1, true, 0xFFFFD0);
         GraphicsUtil.DrawRect (this, - mHalfWidth, - mHalfHeight, mHalfWidth + mHalfWidth, mHalfHeight + mHalfHeight, borderColor, borderSize, false);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mFunctionManager.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle ( GetRotation (), GetPositionX (), GetPositionY (), mHalfWidth, mHalfHeight);
      }
      
 //====================================================================
//   linkable
//====================================================================
      
      public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         if (localX < - mHalfWidth || localX > mHalfWidth || localY < - mHalfHeight || localY > mHalfHeight)
            return -1;
         if (localX > mHalfWidth - DragLinkHandleWidth)
            return 0;
         
         return -1;
      }
      
      public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mFunctionManager, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         return false; // this is not done by category. It is finished by category manamger.
      }
      
   }
}
