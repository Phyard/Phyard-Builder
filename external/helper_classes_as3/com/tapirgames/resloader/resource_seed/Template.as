package 
{
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.media.Sound;
   
   public class Template extends Sprite
   {
      [Embed(source="small.jpg")]
      public var BitmapClass:Class;
      
      [Embed(source="short.mp3")]
      public var SoundClass:Class;
      
      public function GetBitmap ():Bitmap 
      {
         return new BitmapClass ();
      }
      
      public function GetSound ():Sound 
      {
         return new SoundClass ();
      }
   }
}
