package wrapper {
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import flash.events.IOErrorEvent;
   import flash.utils.getDefinitionByName;
   //import flash.events.Event;

   import mochi.MochiAd;
   //import mochi.MochiBot;
   //import mochi.MochiServices;
   //import mochi.MochiScores;
   

    // Must be dynamic!
    public dynamic class EditorPreloader extends MovieClip {
        public static var _mochiads_game_id:String = "5de1b1a3984adfa3";
        //public static var _mochibot_id:String = "7a478df7"; // to g
        
        // Change this class name to your main class
        public static var MAIN_CLASS:String = "wrapper.ColorInfectionEditor";
        public static var GAME_OPTIONS:Object = {id: _mochiads_game_id, res:"730x600"};
        
        
        // Keep track to see if an ad loaded or not
        private var did_load:Boolean;

        // url
        public static var sSwfUrl:String = null;

        // Substitute these for what's in the MochiAd code
        
        public static var sPreloader:MovieClip;

        public function EditorPreloader () 
        {
            super();
            
            sPreloader = this;
            
            var f:Function = function(ev:IOErrorEvent):void {
                // Ignore event to prevent unhandled error exception
            }
            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, f);
            
            sSwfUrl = loaderInfo.url;
            //trace ("sSwfUrl= " + sSwfUrl);
            //trace ("root.loaderInfo.url= " + root.loaderInfo.url);
            //trace ("root.loaderInfo.loaderURL= " + root.loaderInfo.loaderURL);
            
            
            //

            
            // mochi bot
            //if (sSwfUrl == null || sSwfUrl.indexOf ("//:localhost") < 0)
            //   MochiBot.track(this, _mochibot_id);
            
            // mochi services
            //MochiServices.connect(_mochiads_game_id, this);
            
            // loader ...
            var opts:Object = {};
            for (var k:String in GAME_OPTIONS) {
                opts[k] = GAME_OPTIONS[k];
            }

            opts.ad_started = function ():void {
                did_load = true;
            }

            opts.ad_finished = function ():void {
                
                //HideTitle ();
                
                
                // don't directly reference the class, otherwise it will be
                // loaded before the preloader can begin
                var mainClass:Class = Class(getDefinitionByName(MAIN_CLASS));
                var app:Object = new mainClass();
                addChild(app as DisplayObject);
                if (app.init) {
                    app.init(did_load);
                }
            }
      
            //var adContainer:MovieClip = MochiAd.createEmptyMovieClip(this, "_ad_clip", 3);
            //adContainer.y = 100;
      
            //opts.clip = adContainer; //this;
            opts.clip = this;
            MochiAd.showPreGameAd(opts);
            
            //ShowTitle ();
            
            //addEventListener(Event.ENTER_FRAME, Update);
        }
    }

}
