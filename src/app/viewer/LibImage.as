      
      private function LoadImageFromBytes (imageFileData:ByteArray, onComplete:Function, onError:Function):void
      {
         var loader:ResourceLoader = new ResourceLoader (imageFileData, onComplete, onError);
         loader.StartLoadingImage ();
      }
