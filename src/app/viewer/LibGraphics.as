      
      private function LoadImageFromBytes (imageFileData:ByteArray, onComplete:Function, onError:Function):void
      {
         var loader:ResourceLoader = new ResourceLoader (imageFileData, onComplete, onError);
         loader.StartLoadingImage ();
      }
      
      private var mDefaultRenderQuality:String = StageQuality.HIGH;
      
      private function SetRenderQuality (quality:String):void
      {
         if (stage == null) return; // should not
         
         if (quality == "default")
         {
            stage.quality = mDefaultRenderQuality;
         }
         else if (quality == StageQuality.BEST || quality == StageQuality.HIGH || quality == StageQuality.MEDIUM || quality == StageQuality.LOW)
         {
            stage.quality = quality;
         }
      }
