package viewer
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public dynamic class Viewer extends Sprite
   {
      public function Viewer ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage);
      }
      
      private function OnAddedToStage (e:Event):void 
      {
         
      }
   }
   
}