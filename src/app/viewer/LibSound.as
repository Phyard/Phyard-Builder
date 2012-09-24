      
      private static var mIsSoundEnabled:Boolean = true; // to record and init sound setting
      private static var mSoundVolume:Number = 0.5;
      
      public function IsSoundEnabled ():Boolean
      {
         return mIsSoundEnabled;
      }

      public function SetSoundEnabled (soundOn:Boolean):void
      {
         if (mIsSoundEnabled != soundOn)
         {
            mIsSoundEnabled = soundOn;
            
            //if (! mIsSoundEnabled)
            //{
            //   StopAllSounds (true);
            //}

            SetSoundVolume (mIsSoundEnabled ? 1.0 : 0.0);
         }
      }
      
      public function GetSoundVolume (volume:Number):Number
      {
         return mSoundVolume;
      }
      
      public function SetSoundVolume (volume:Number):void
      {
         if (volume < 0.0)
            volume = 0.0;
         if (volume > 1.0)
            volume = 1.0;
         
         mSoundVolume = volume;
         
         UpdateSoundVolume ();
      }
      
      private function UpdateSoundVolume ():void
      {
         var transform:SoundTransform = new SoundTransform();
         transform.volume = mIsSoundEnabled ? mSoundVolume : 0.0;
         SoundMixer.soundTransform = transform;
      }

      private function PlaySound (sound:Sound, times:int, crossingLevel:Boolean, volume:Number = 1.0):void
      {
         if (IsSoundEnabled () && sound != null)
         {
            //mSoundChannel = mSound.play ();
            //mSoundChannel.addEventListener (Event.SOUND_COMPLETE, OnSoundPlayComplete);
            
            var loops:int = times <= 0 ? 0x7FFFFFFF : times;
            sound.play (0, loops);
         }
      }

      public function StopAllInLevelSounds ():void
      {
         SoundMixer.stopAll ();
         
         // ...
      }

      // null means all
      public function StopCrossLevelsSound (sound:Sound):void
      {
         if (sound == null)
         {
            // stop all crossing levels sounds 
            return;
         }
         
         // ...
      }
      
      public function CloseAllSounds ():void
      {
         StopAllInLevelSounds ();
         StopCrossLevelsSound (null);
      }