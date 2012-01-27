package player.sound
{
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   import flash.media.SoundMixer;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   import com.tapirgames.util.ResourceLoader;
   import com.tapirgames.util.ResourceLoadEvent;
   
   import player.design.Global;
   
   import common.sound.SoundFile;

   public class Sound extends SoundFile
   {
      private static var mSoundOn:Boolean = true;
      private static var mSoundVolume:Number = 0.5;
      
      public static function SetSoundEnabled (enalbed:Boolean):void
      {
         mSoundOn = enalbed;
         
         UpdateSoundVolume ();
      }
      
      public static function SetSoundVolume (volume:Number):void
      {
         if (volume < 0.0)
            volume = 0.0;
         if (volume > 1.0)
            volume = 1.0;
         
         mSoundVolume = volume;
         
         UpdateSoundVolume ();
      }
      
      public static function UpdateSoundVolume ():void
      {
         var transform:SoundTransform = new SoundTransform();
         transform.volume = mSoundOn ? mSoundVolume : 0.0;
         SoundMixer.soundTransform = transform;
      }
      
      public static function StopAllSounds ():void
      {
         SoundMixer.stopAll ();
      }
   
//=====================================
   
      private var mSound:flash.media.Sound;
      //private var mSoundChannel:SoundChannel = null;
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
      
      public function Play (times:int = 1):void
      {
         if (Global.IsSoundEnabled ())
         {
            if (mSound != null)
            {
               //mSoundChannel = mSound.play ();
               //mSoundChannel.addEventListener (Event.SOUND_COMPLETE, OnSoundPlayComplete);
               
               var loops:int = times <= 0 ? 0x7FFFFFFF : times;
               mSound.play (0, loops);
            }
         }
      }
      
      private var mCallbackOnLoadDone :Function = null;
      private var mCallbackOnLoadError:Function = null;
      public function SetFileDataAndLoad (fileData:ByteArray, onLoadDone:Function, onLoadError:Function):void
      {
         if (fileData == null)
         {
            mStatus = 1;
            
            onLoadDone (this);
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
         mSound = (event as ResourceLoadEvent).resource as flash.media.Sound;
         
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
