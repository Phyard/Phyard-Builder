
package editor.image {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
         
   import flash.net.FileReference;
   import flash.net.FileFilter;
   import flash.events.IOErrorEvent;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.selection.SelectionProxy;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.asset.Asset;
   
   import common.Define;
   import common.ValueAdjuster;
   
   public class AssetImageDivision extends Asset
   {  
      protected var mAssetImageDivisionManager:AssetImageDivisionManager;
      
      // in painting and saving, this 4 values are integers
      protected var mLeft:Number;
      protected var mTop:Number;
      protected var mRight:Number;
      protected var mBottom:Number;
      
      private var mBitmapData:BitmapData = null;
      
      protected var mImagePureModulePeer:AssetImagePureModule;
      
      public function AssetImageDivision (assetImageDivisionManager:AssetImageDivisionManager)
      {
         super (assetImageDivisionManager);
         
         mAssetImageDivisionManager = assetImageDivisionManager;
         
         alpha = 0.5;
      }
      
      public function GetAssetImageDivisionManager ():AssetImageDivisionManager
      {
         return mAssetImageDivisionManager;
      }
      
      public function GetAssetImage ():AssetImage
      {
         return GetAssetImageDivisionManager ().GetAssetImage ();
      }
      
      public function GetAssetImageId ():int
      {
         return GetAssetImage ().GetAppearanceLayerId ();
      }
      
      internal function SetImagePureModulePeer (assetImagePureModule:AssetImagePureModule):void
      {
         mImagePureModulePeer = assetImagePureModule;
      }
      
      public function GetImagePureModulePeer ():AssetImagePureModule
      {
         return mImagePureModulePeer;
      }
      
      override public function ToCodeString ():String
      {
         return "Pure Module#" + GetAppearanceLayerId ();
      }
      
      override public function GetTypeName ():String
      {
         return "Pure Module";
      }
      
//=============================================================
//   
//=============================================================
      
      override public function GetKey ():String
      {
         if (mImagePureModulePeer == null) // for creation stage
            return "dummy";
         
         return mImagePureModulePeer.GetKey ();
      }
      
      override public function SetKey (key:String):void
      {
         if (mImagePureModulePeer != null) // for creation stage
            mImagePureModulePeer.SetKey (key);
      }
      
      override public function GetTimeModified ():Number
      {
         if (mImagePureModulePeer == null) // for creation stage
            return 0;
         
         return mImagePureModulePeer.GetTimeModified ();
      }
      
      override public function SetTimeModified (time:Number):void
      {
         if (mImagePureModulePeer != null) // for creation stage
            mImagePureModulePeer.SetTimeModified (time);
      }
      
      override public function UpdateTimeModified ():void
      {
         mImagePureModulePeer.UpdateTimeModified ();
      }
      
//=============================================================
//   
//=============================================================
      
      public function GetLeft ():int
      {
         return Math.round (mLeft);
      }
      
      public function GetRight ():int
      {
         return Math.round (mRight);
      }
      
      public function GetTop ():int
      {
         return Math.round (mTop);
      }
      
      public function GetBottom ():int
      {
         return Math.round (mBottom);
      }
      
      override public function SetPosition (posX:Number, posY:Number):void
      {
         // mPosX and mPosY are always 0.
      
         //var dx:int = int (posX);
         //var dy:int = int (posY);
         var dx:Number = posX;
         var dy:Number = posY;
         
         SetRegion (mLeft + dx, mTop + dy, mRight + dx, mBottom + dy);
         
         UpdateAppearance ();
      }
      
      public function SetRegion (left:Number, top:Number, right:Number, bottom:Number):void
      {
         if (left < 0)
            left = 0;
         if (right < 0)
            right = 0;
         if (top < 0)
            top = 0;
         if (bottom < 0)
            bottom = 0;
         
         if (left <= right)
         {
            mLeft = left;
            mRight = right;
         }
         else
         {
            mLeft = right;
            mRight = left;
         }
         
         if (GetRight () - GetLeft () < 1)
         {
            mRight = mLeft + 1.0;
         }
         
         if (top <= bottom)
         {
            mTop = top;
            mBottom = bottom;
         }
         else
         {
            mTop = bottom;
            mBottom = top;
         }
         
         if (GetBottom () - GetTop () < 1)
         {
            mBottom = mTop + 1.0;
         }
         
         //
         UpdatePixels ();
         
         //
         if (mImagePureModulePeer != null)
         {
            mImagePureModulePeer.UpdateAppearance ();
         }
      }

//=============================================================
//   
//=============================================================
      
      public function GetBitmapData ():BitmapData
      {
         return mBitmapData;
      }
      
      public function UpdatePixels ():void
      {
         var assetImage:AssetImage = mAssetImageDivisionManager.GetAssetImage ();
         var imageBitmapData:BitmapData = assetImage == null ? null : assetImage.GetBitmapData ();
         if (imageBitmapData == null)
         {
            mBitmapData = null;
            return;
         }
         
         var left:int = GetLeft ();
         var top:int = GetTop ();
         var right:int = GetRight ();
         var bottom:int = GetBottom();
         
         //if (left < 0)
         //   left = 0;
         //if (top < 0)
         //   top = 0;
         if (right > imageBitmapData.width)
            right = imageBitmapData.width;
         if (bottom > imageBitmapData.height)
            bottom = imageBitmapData.height;
         
         if (left >= imageBitmapData.width || top >= imageBitmapData.height || right <= 0 || bottom <= 0)
         {
            mBitmapData = null;
            return;
         }  
         
         var w:int = right - left;
         var h:int = bottom - top;
         mBitmapData = new BitmapData (w, h, true);
         mBitmapData.copyPixels (imageBitmapData, new Rectangle (left, top, w, h), new Point (0, 0));
         
         if (mImagePureModulePeer != null)
         {
            mImagePureModulePeer.OnDivisionChanged ();
         }
      }
      
      public function CreateSpriteForImagePureModule ():DisplayObject
      {
         var assetImage:AssetImage = mAssetImageDivisionManager.GetAssetImage ();
         var imageBitmapData:BitmapData = assetImage == null ? null : assetImage.GetBitmapData ();
         var shape:Shape;
         if (imageBitmapData == null || mBitmapData == null)
         {
            shape = new Shape ();
            GraphicsUtil.ClearAndDrawRect (shape, 0, 0, GetRight () - GetLeft (), GetBottom () - GetTop (),
                                       0xC0FFC0, -1, true, 0xC0FFC0, false);
            
            return shape;
         }
         
         var bitmap:Bitmap = new Bitmap (mBitmapData);

         var left:int = GetLeft ();
         var top:int = GetTop ();
         var right:int = GetRight ();
         var bottom:int = GetBottom();
         if (left >= 0 && top >= 0 && right <= imageBitmapData.width && bottom < imageBitmapData.height)
            return bitmap;

         bitmap.x = left >= 0 ? 0 : - left;
         bitmap.y = top  >= 0 ? 0 : - top;
         
         shape = new Shape ();
         GraphicsUtil.ClearAndDrawRect (shape, 0, 0, GetRight () - GetLeft (), GetBottom () - GetTop (),
                                    0xC0FFC0, -1, true, 0xC0FFC0, false);
         shape.alpha = 0.3;
         
         var sprite:Sprite = new Sprite ();
         sprite.addChild (shape);
         sprite.addChild (bitmap);
         
         return sprite;
      }
      
      public function GetBoundingRectangleForImagePureModule ():Rectangle
      {
         var rectangle:Rectangle = new Rectangle (0, 0, GetRight () - GetLeft (), GetBottom () - GetTop ());
         return rectangle;
      }
      
//=============================================================
//   
//=============================================================
      
      override public function UpdateAppearance ():void
      {
         GraphicsUtil.ClearAndDrawRect (this, GetLeft (), GetTop (), GetRight () - GetLeft (), GetBottom () - GetTop (),
                                       IsSelected () ? 0x0000FF : 0x00FF00, 0, true, IsSelected () ? 0xC0C0FF : 0xC0FFC0, false);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mAssetManager.GetSelectionEngine ().CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         var centerX:Number = 0.5 * (mLeft + mRight);
         var centerY:Number = 0.5 * (mTop + mBottom); 
         var halfW:Number = 0.5 * (mRight - mLeft);
         var halfH:Number = 0.5 * (mBottom - mTop); 
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle (centerX, centerY, halfW, halfH);
      }
      
//=============================================================
//   
//=============================================================

      override protected function BuildContextMenuInternal (customMenuItemsStack:Array):void
      {
         super.BuildContextMenuInternal (customMenuItemsStack);
      }
      
  }
}