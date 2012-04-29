package player.image
{
   import common.display.ModuleSprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   import com.tapirgames.util.ResourceLoader;
   import com.tapirgames.util.ResourceLoadEvent;
   
   import player.physics.PhysicsProxyBody;
   
   import common.Transform2D;
   
   import player.module.Module;

   public class ImageBitmap extends Module
   {
      protected var mBitmapData:BitmapData = null;
      protected var mStatus:int = 0;
         // 0  : pending
         // 1  : ok
         // -1 : error
      
      public function ImageBitmap ()
      {
      }
      
      public function GetBitmapData ():BitmapData
      {
         return mBitmapData;
      }
      
      public function GetStatus ():int
      {
         return mStatus;
      }
      
      override public function BuildAppearance (frameIndex:int, moduleSprite:ModuleSprite, transform:Transform2D, alpha:Number):void
      {
         if (mBitmapData != null)
         {
            var bitmap:Bitmap = new Bitmap (mBitmapData);
            if (transform != null)
               transform.TransformUntransformedDisplayObject (bitmap);
            
            bitmap.alpha = alpha;
            moduleSprite.addChild (bitmap);
         }
      }
      
      public function CreateAsBlankImage (widht:int, height:int, bgColor:uint):void
      {
         // todo
      }
      
      private var mCallbackOnLoadDone :Function = null;
      private var mCallbackOnLoadError:Function = null;
      public function SetFileData (fileData:ByteArray, onLoadDone:Function, onLoadError:Function):void
      {
         if (fileData == null)
         {
            mStatus = 1;
            
            //onLoadDone (this); // not essential, will cause bugs
         }
         else
         {
            mCallbackOnLoadDone  = onLoadDone;
            mCallbackOnLoadError = onLoadError;
            
            // ...
            var loader:ResourceLoader = new ResourceLoader ();
            loader.addEventListener (IOErrorEvent.IO_ERROR, OnLoadImageError);
            loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadImageError);
            loader.addEventListener (ResourceLoadEvent.RESOURCE_LOADED, OnLoadImageComplete);
            loader.loadImageFromByteArray (fileData);
         }
      }
      
      private function OnLoadImageComplete (event:Event):void
      {
         var newBitmap:Bitmap = (event as ResourceLoadEvent).resource as Bitmap;
         mBitmapData = newBitmap.bitmapData;
         
         mStatus = 1;
         
         if (mCallbackOnLoadDone != null)
            mCallbackOnLoadDone (this);
         
         mCallbackOnLoadDone  = null;
         mCallbackOnLoadError = null;
      }
      
      private function OnLoadImageError (event:Object):void
      {
         mStatus = -1;
         
         if (mCallbackOnLoadError != null)
            mCallbackOnLoadError (this);
         
         mCallbackOnLoadDone  = null;
         mCallbackOnLoadError = null;
      }
   }
}
