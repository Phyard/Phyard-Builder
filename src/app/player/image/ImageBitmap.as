package player.image
{
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   import com.tapirgames.util.LocalImageLoader;
   
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
      
      override public function BuildAppearance (frameIndex:int, container:Sprite, transform:Transform2D):void
      {
      trace ("  BuildAppearance, mBitmapData= " + mBitmapData + "\n" + new Error ().getStackTrace ());
         if (mBitmapData != null)
         {
            var bitmap:Bitmap = new Bitmap (mBitmapData);
            if (transform != null)
               transform.TransformUntransformedDisplayObject (bitmap);
            
            container.addChild (bitmap);
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
            onLoadDone (this);
         }
         else
         {
            mCallbackOnLoadDone  = onLoadDone;
            mCallbackOnLoadError = onLoadError;
            
            //var loader:Loader = new Loader();
            var loader:LocalImageLoader = new LocalImageLoader ();
            loader.contentLoaderInfo.addEventListener (Event.COMPLETE, OnLoadImageComplete);
            loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, OnLoadImageError);
            loader.contentLoaderInfo.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadImageError);
            loader.loadBytes (fileData);
         }
      }
      
      private function OnLoadImageComplete (event:Event):void
      {
         //var newBitmap:Bitmap = event.target.content as Bitmap;
         var newBitmap:Bitmap = ((event.target.content.GetBitmap as Function) ()) as Bitmap;
         mBitmapData = newBitmap.bitmapData;
trace ("  OnLoadImageComplete, mBitmapData = " + mBitmapData);
         
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
