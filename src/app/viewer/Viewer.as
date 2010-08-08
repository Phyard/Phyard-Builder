package viewer
{
   import flash.display.Sprite;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public dynamic class Viewer extends Sprite
   {
      public function Viewer ()
      {
         addEventListener(Event.ADDED_TO_STAGE , OnAddedToStage);
      }
      
      private function OnAddedToStage (e:Event):void 
      {
         
      }
      
      private function LoadDesignInfoAndData ():void
      {
         //
      }
      
      private function LoadPlayer (playerUrl:String):void
      {
         var loader:Loader = new Loader();
         var request:URLRequest = new URLRequest(playerUrl);
         var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
         loader.load(request, loaderContext);   
      }
      
     private function OnLoadPlayerComplete (event:Event):void
     {
         //var myGreeter:Class = ApplicationDomain.currentDomain.getDefinition("Greeter") as Class;
         //var myGreeter:Greeter = Greeter(event.target.content);
         //var message:String = myGreeter.welcome("Tommy");
         //trace(message); // Hello, Tommy
     }
   }
   
}