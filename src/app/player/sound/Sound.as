package player.sound
{
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   import com.tapirgames.util.ResourceLoader;
   import com.tapirgames.util.ResourceLoadEvent;
   
   import player.design.Global;
   
   import common.sound.SoundFile;

   public class Sound extends SoundFile
   {
      private var mSound:Object; //flash.media.Sound;

      protected var mStatus:int = 0;
         // 0  : pending
         // 1  : ok
         // -1 : error

      protected var mId:int = -1; // for debug mainly
      
      public function Sound ()
      {
      }
      
      public function GetId ():int
      {
         return mId;
      }
      
      public function SetId (id:int):void
      {
         mId = id;
      }
      
      public function GetStatus ():int
      {
         return mStatus;
      }
      
      // mxmlc is a shit, using "flash.media.Sound" will get error, sometimes! Without rules!
      public function GetSoundObject ():Object // flash.media.Sound
      {
         return mSound;
      }
      
      // now put in Viewer/LibSound
      //public function Play (times:int = 1):void
      //{
      //   if (Global.IsSoundEnabled ())
      //   {
      //      if (mSound != null)
      //      {
      //         //mSoundChannel = mSound.play ();
      //         //mSoundChannel.addEventListener (Event.SOUND_COMPLETE, OnSoundPlayComplete);
      //         
      //         var loops:int = times <= 0 ? 0x7FFFFFFF : times;
      //         mSound.play (0, loops);
      //      }
      //   }
      //}
      
      private var mCallbackOnLoadDone :Function = null;
      private var mCallbackOnLoadError:Function = null;
      public function SetFileDataAndLoad (fileData:ByteArray, onLoadDone:Function, onLoadError:Function):void
      {
         if (fileData == null)
         {
            mStatus = 1;
            
            //onLoadDone (this); // not essential, will cause bug
         }
         else
         {
            mCallbackOnLoadDone  = onLoadDone;
            mCallbackOnLoadError = onLoadError;
            
            // ...
            var loader:ResourceLoader = new ResourceLoader ();
            loader.addEventListener (IOErrorEvent.IO_ERROR, OnLoadSoundError);
            loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, OnLoadSoundError);
            loader.addEventListener (ResourceLoadEvent.RESOURCE_LOADED, OnLoadSoundComplete);
            loader.loadSoundFromByteArray (fileData, GetFileFormat (), GetSamplingRate (), GetSampleSize (), IsStereo (), GetNumSamples ());
         }
      }
      
      private function OnLoadSoundComplete (event:Event):void
      {
         mSound = (event as ResourceLoadEvent).resource; // as flash.media.Sound;
         
         mStatus = 1;
         
         if (mCallbackOnLoadDone != null)
            mCallbackOnLoadDone (this);
         
         mCallbackOnLoadDone  = null;
         mCallbackOnLoadError = null;
      }
      
      private function OnLoadSoundError (event:Object):void
      {
         //mStatus = -1;
         mStatus = 1;
         
         if (mCallbackOnLoadError != null)
            mCallbackOnLoadError (this);
         
         mCallbackOnLoadDone  = null;
         mCallbackOnLoadError = null;
      }
   }
}
