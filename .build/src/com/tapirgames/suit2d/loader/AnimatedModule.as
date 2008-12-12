package com.tapirgames.suit2d.loader {
   
   import flash.utils.ByteArray;
   
   import flash.display.DisplayObjectContainer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   
   public class AnimatedModule // extends Module
   {
      public var mModuleSequences:Array;
      
      public function AnimatedModule (moduleSequences:Array)
      {
         mModuleSequences = moduleSequences
      }
      
      public function GetModuleSequencesCount ():int
      {
         return mModuleSequences == null ? 0 : mModuleSequences.length;
      }
      
      public function GetModuleSequence (sequenceID:int):ModuleSequence
      {
         return mModuleSequences [sequenceID];
      }
      
   }
}