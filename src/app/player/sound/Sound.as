package player.sound
{
   import flash.utils.ByteArray;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   import player.world.Global;
   
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
            Global.Viewer_mLibSound.LoadSoundFromBytes (fileData, OnLoadSoundComplete, OnLoadSoundError, 
                                                                                                {
                                                                                                   mFileFormat: GetFileFormat (),
                                                                                                   mSamplingRate: GetSamplingRate (),
                                                                                                   mSampleSize: GetSampleSize (),
                                                                                                   mIsStereo: IsStereo (),
                                                                                                   mNumSamples: GetNumSamples ()
                                                                                                }
            );
         }
      }
      
      private function OnLoadSoundComplete (sound:Object/*flash.media.Sound*/):void
      {
         mSound = sound;
         
         mStatus = 1;
         
         if (mCallbackOnLoadDone != null)
            mCallbackOnLoadDone (this);
         
         mCallbackOnLoadDone  = null;
         mCallbackOnLoadError = null;
      }
      
      private function OnLoadSoundError (message:String):void
      {
         //trace ("Loading sound error: " + message);
         
         //mStatus = -1;
         mStatus = 1;
         
         if (mCallbackOnLoadError != null)
            mCallbackOnLoadError (this);
         
         mCallbackOnLoadDone  = null;
         mCallbackOnLoadError = null;
      }
   }
}
