      
      private static var mIsSoundEnabled:Boolean = true; // to record and init sound setting
      private static var mSoundVolume:Number = 0.5;
      //private static var mSoundVolume:Number = -1;
      
      public static function IsSoundEnabled ():Boolean
      {
         return mIsSoundEnabled;
      }

      public static function SetSoundEnabled (soundOn:Boolean):void
      {
         if (mIsSoundEnabled != soundOn)
         {
            mIsSoundEnabled = soundOn;
            
            //if (! mIsSoundEnabled)
            //{
            //   StopAllSounds (true);
            //}

            UpdateSoundVolume ();
         }
      }
      
      public static function GetSoundVolume ():Number
      {
         //if (mSoundVolume < 0)
         //{
         //   mSoundVolume = ValidateVolume (SoundMixer.soundTransform.volume);
         //}

         return mSoundVolume;
      }
      
      public static function SetSoundVolume (volume:Number):void
      {
         mSoundVolume = ValidateVolume (volume);
         
         UpdateSoundVolume ();
      }
      
      private static function ValidateVolume (volume:Number):Number
      {
         if (volume < 0.0)
            return 0.0;
         if (volume > 1.0)
            return 1.0;
         
         return volume;
      }
      
      private static function UpdateSoundVolume ():void
      {
         //var transform:SoundTransform = new SoundTransform();
         //transform.volume = mIsSoundEnabled ? mSoundVolume : 0.0;
         //SoundMixer.soundTransform = transform;
         
         //if (mSoundVolume < 0)
         //   mSoundVolume = SoundMixer.soundTransform.volume;
         //GetSoundVolume (); // needed! To backup the old value.

         var newTransform:SoundTransform = new SoundTransform (mIsSoundEnabled ? mSoundVolume : 0.0);
         SoundMixer.soundTransform = newTransform;
      }
      
      private function LoadSoundFromBytes (soundFileData:ByteArray, onComplete:Function, onError:Function, soundProperties:Object):void
      {
         var loader:ResourceLoader = new ResourceLoader (soundFileData, onComplete, onError);
         loader.StartLoadingSound (mParamsFromContainer.mIsLoadBytesForbidden, soundProperties.mFileFormat, soundProperties.mSamplingRate, soundProperties.mSampleSize, soundProperties.mIsStereo, soundProperties.mNumSamples);
      }
      
      // sounds in playing
      //private var mInLevelSoundLookupTable:Dictionary = new Dictionary ();
      //private var mCrossingLevelsSoundLookupTable:Dictionary = new Dictionary ();
      private var mInLevelSoundChannels:Array = new Array (50); // maybe 32 is enough
      private var mNumInLevelSounds:int = 0;
      private var mCrossingLevelsSoundChannels:Array = new Array (50); // maybe 32 is enough
      private var mCrossingLevelsSounds:Array = new Array (50); // maybe 32 is enough
      private var mNumCrossingLevelsSounds:int = 0;

      private function PlaySound (sound:Sound, times:int, crossingLevels:Boolean, volume:Number = 1.0):void
      {
         if (IsSoundEnabled () && sound != null)
         {
//trace (">>>>>> crossingLevels = " + crossingLevels);
            if (crossingLevels && mCrossingLevelsSounds.indexOf (sound) >= 0)
            {
               return;
            }
            
            //mSoundChannel = mSound.play ();
            //mSoundChannel.addEventListener (Event.SOUND_COMPLETE, OnSoundPlayComplete);
            
            var transform:SoundTransform = new SoundTransform (ValidateVolume (volume));
               //var loops:int = times < 0 ? 0x7FFFFFFF : times;
               //var channel:SoundChannel = sound.play (0, loops, transform);
            var loops:int = times <= 0 ? 0x7FFFFFFF : times;
            var channel:SoundChannel = sound.play (0, loops, transform);
               // ??? loops == 0 and loops == 1 will both play once? Flash is weird!
            
            if (channel != null)
            {
               channel.addEventListener(Event.SOUND_COMPLETE, OnSoundCompletePlaying);
               
               if (crossingLevels)
               {
//trace ("PlaySound, crossing level: times = " + times);
                  mCrossingLevelsSounds [mNumCrossingLevelsSounds] = sound; // for c/java, need check index out of range
                  mCrossingLevelsSoundChannels [mNumCrossingLevelsSounds ++] = channel; // for c/java, need check index out of range
               }
               else
               {
//trace ("PlaySound, in level: times = " + times);
                  mInLevelSoundChannels [mNumInLevelSounds ++] = channel; // for c/java, need check index out of range
               }
            }
//trace ("+++++ mNumInLevelSounds = " + mNumInLevelSounds + ", mNumCrossingLevelsSounds = " + mNumCrossingLevelsSounds);
         }
      }
      
      private function OnSoundCompletePlaying (event:Event):void
      {
//trace ("========= OnSoundCompletePlaying");

         var index:int;
         
         var channel:SoundChannel = event.currentTarget as SoundChannel;
         
         index = mInLevelSoundChannels.indexOf (channel);
         if (index >= 0)
         {
//trace ("in level");
            mInLevelSoundChannels [index] = mInLevelSoundChannels [-- mNumInLevelSounds];
            mInLevelSoundChannels [mNumInLevelSounds] = null;
         }
         
         index = mCrossingLevelsSoundChannels.indexOf (channel);
         if (index >= 0)
         {
//trace ("crossing level");
            mCrossingLevelsSoundChannels [index] = mCrossingLevelsSoundChannels [-- mNumCrossingLevelsSounds];
            mCrossingLevelsSoundChannels [mNumCrossingLevelsSounds] = null;
            
            mCrossingLevelsSounds [index] = mCrossingLevelsSounds [mNumCrossingLevelsSounds];
            mCrossingLevelsSounds [mNumCrossingLevelsSounds] = null;
         }
         
//trace ("----- mNumInLevelSounds = " + mNumInLevelSounds + ", mNumCrossingLevelsSounds = " + mNumCrossingLevelsSounds);
      }
      
      // todo
      //public function SetAllInLevelSoundsPaused (paused:Boolean):void
      //{
      //}

      public function StopAllInLevelSounds ():void
      {
         for (var index:int = 0; index < mNumInLevelSounds; ++ index)
         {
            var channel:SoundChannel = mInLevelSoundChannels [index] as SoundChannel;
            // assert (channel != null);
            
            channel.stop ();
            
            mInLevelSoundChannels [index] = null;
         }
         
         mNumInLevelSounds = 0;
      }

      // null means all
      public function StopCrossLevelsSound (sound:Sound):void
      {
         var index:int;
         var channel:SoundChannel;
         
         if (sound == null)
         {
            // stop all crossing levels sounds 
            
            for (index = 0; index < mNumCrossingLevelsSounds; ++ index)
            {
               channel = mCrossingLevelsSoundChannels [index] as SoundChannel;
               // assert (channel != null);
               
               channel.stop ();
               
               mCrossingLevelsSoundChannels [index] = null;
               mCrossingLevelsSounds [index] = null;
            }
            
            mNumCrossingLevelsSounds = 0;
            
            return;
         }
         
         index = mCrossingLevelsSounds.indexOf (sound);
         if (index >= 0)
         {
            channel = mCrossingLevelsSoundChannels [index] as SoundChannel;
            // assert (channel != null);
            
            channel.stop ();
            
            mCrossingLevelsSoundChannels [index] = mCrossingLevelsSoundChannels [-- mNumCrossingLevelsSounds];
            mCrossingLevelsSoundChannels [mNumCrossingLevelsSounds] = null;
            
            mCrossingLevelsSounds [index] = mCrossingLevelsSounds [mNumCrossingLevelsSounds];
            mCrossingLevelsSounds [mNumCrossingLevelsSounds] = null;
         }
      }
      
      public function CloseAllSounds ():void
      {
         StopAllInLevelSounds ();
         StopCrossLevelsSound (null);
         
         SoundMixer.stopAll (); // maybe it is not essential
      }