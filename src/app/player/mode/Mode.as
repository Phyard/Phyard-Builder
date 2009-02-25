
package player.mode {
   
   import player.world.World;
   
   
   public class Mode
   {
      protected var mWorld:World;
      
      
      public function Mode (world:World)
      {
         mWorld = world;
      }
      
      public function Initialize ():void
      {
      }
      
      public function Destroy ():void
      {
      }
      
      public function Reset ():void
      {
      }
      
      public function Update (escapedTime:Number):void
      {
         
      }
      
      public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
         
      }
      
      public function OnMouseMove (mouseX:Number, mouseY:Number):void
      {
      }
      
      public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
      }
   }
   
}