package player.image {

   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import flash.display.Sprite;

   public class BitmapModuleAnimation extends BitmapModule
   {
      protected var mSequenceHead:BitmapModuleSequence; // BitmapModuleSequence list. Should not be null.
      
      // ...
      
      protected var mCurrentSequence:BitmapModuleSequence;
      protected var mCurrentSequenceSteps:int;
      
      protected var mEverReachedEnd:Boolean;
      
      protected var mSequenceContainer:Sprite = new Sprite ();
      
      public function BitmapSprite ()
      {
      }
      
      override public function OnSequenceStart ():void
      {
         mEverReachedEnd = false;
         
         if (mCurrentSequence.mBitmapModule != null)
         {
            mCurrentSequence.mBitmapModule.OnSequenceStart ();
         }
      }
      
      override public function Step ():Boolean
      {
         if (mCurrentSequence.mBitmapModule.Step ())
         {
            if (++ mCurrentSequenceSteps >= mCurrentSequence.mSequenceDuration)
            {
               var nextSequence:BitmapModuleSequence = mCurrentSequence.mNextSequence;
               
               mEverReachedEnd = (nextSequence == mSequenceHead || nextSequence == null);
               
               if (nextSequence != null)
               {
                  mCurrentSequenceSteps = 0;
                  
                  mCurrentSequence = nextSequence;
                  mCurrentSequence.OnSequenceStart ();
                  
                  BuildCurrentSequenceAppearance ();
               }
            }
         }
         
         return mEverReachedEnd;
      }
      
      override public function BuildAppearance (contianer:Sprite):void
      {
         contianer.addChild (mSequenceContainer);
         
         BuildCurrentSequenceAppearance ();
      }
      
      provtected function BuildCurrentSequenceAppearance ():void
      {
         while (mSequenceContainer.numChildren > 0)
            mSequenceContainer.removeChildAt (0);
         
         if (mCurrentSequence.mBitmapModule != null)
         {
            mCurrentSequence.mBitmapModule.BuildAppearance (mSequenceContainer);
         }
      }
   }
}
