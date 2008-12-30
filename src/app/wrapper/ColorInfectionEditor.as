
package wrapper {

   import flash.display.Sprite;
   import flash.events.Event;
   
   public dynamic class ColorInfectionEditor extends Sprite 
   {
      
      [Embed(source="CIEditor.swf")]
      [Bindable]
      public var CIEditor:Class;

      
      public function ColorInfectionEditor ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage);
      }
      
      private function OnAddedToStage (e:Event):void 
      {
         addChild (new CIEditor ());
      }
   }
   
}
