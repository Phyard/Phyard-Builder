package com.tapirgames.util
{
   import flash.events.Event;
   import flash.display.Bitmap;
   import flash.media.Sound;

   public class ResourceLoadEvent extends Event
   {
      public static const IMAGE_LOADED:String="image_loaded";
      public static const SOUND_LOADED:String="sound_loaded";
      
      private var mResource:Object;
         private var mSound:Sound;
         private var mBitmap:Bitmap;
      
      public function ResourceLoadEvent (resource:Object, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         var type:String = null;
         
         if (resource is Bitmap)
         {
            type = IMAGE_LOADED;
            mBitmap = resource as Bitmap;
         }
         else if (resource is Sound)
         {
            type = SOUND_LOADED;
            mSound = resource as Sound;
         }
         
         super(type, bubbles, cancelable);
         
         mResource = resource;
      }
      
      override public function clone():Event
      {
         return new ResourceLoadEvent (mResource);
      }
      
      public function get sound ():Sound
      {
         return mSound;
      }
      
      public function get bitmap ():Bitmap
      {
         return mBitmap;
      }
   }
}