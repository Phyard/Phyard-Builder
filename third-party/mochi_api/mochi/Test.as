package mochi {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.events.MouseEvent;

    // The clip that MochiAd uses must be dynamic
    public dynamic class Test extends Sprite {

        public static var GAME_OPTIONS:Object = {id: "test", res:"550x400"};

        [Embed(source="assets/MochiAds_Logo.swf")]
        private var Logo:Class;

        private var sectionTitle:TextField;
        private var logo:DisplayObject;
        private var body:MovieClip;
        private var clickAwayAdMC:MovieClip;

        private var _playerName:String;
        private var _playerScore:Number;

        public function Test() {
            super();
            // This initializes if the preloader is turned off.
            if (stage != null) {
                init(false);
            }
        }
        
        public function init(did_load:Boolean):void {
            mouseChildren = true;
            placeLogo();
            showMainMenu();
            setSectionTitle("MochiAd " + MochiAd.getVersion() + " Demo");
        }

        public function getOptions():Object {
            var opts:Object = {clip: this};
            for (var k:String in GAME_OPTIONS) {
                opts[k] = GAME_OPTIONS[k];
            }
            return opts;
        }
            
        public function showInterLevel(ev:Object=null):void {
            clearSection();
            setSectionTitle("MochiAd Demo: showInterLevelAd");
            
            var opts:Object = getOptions();
            opts.ad_started = function ():void {};
            opts.ad_finished = showMainMenu;
            MochiAd.showInterLevelAd(opts);
        }        
        
        public function showClickAway(ev:Object=null):void {
            clearSection();
            setSectionTitle("MochiAd Demo: showClickAwayAd");
            
            clickAwayAdMC = new MovieClip();
            clickAwayAdMC.x = 0;
            clickAwayAdMC.y = 20;
            body.addChild(clickAwayAdMC);
            
            var unloadButton:Sprite = newMenuButton("Main Menu", "", unloadClickAway);
            unloadButton.x = 360;
            unloadButton.y = 120;
            clickAwayAdMC.addChild(unloadButton);
 
            var opts:Object = {id: "test", 
                               clip: clickAwayAdMC};

            MochiAd.showClickAwayAd(opts);
        }
        
        public function unloadClickAway(ev:Object=null):void {
            MochiAd.unload(clickAwayAdMC);
            body.removeChild(clickAwayAdMC);
            showMainMenu();
        }

        public function newMenuButton(title:String, subtitle:String, callback:Function):Sprite {
            var s:Sprite = new Sprite();
            
            var titleField:TextField = new TextField();
            titleField.selectable = false;
            titleField.autoSize = TextFieldAutoSize.LEFT;
            titleField.defaultTextFormat = menuTextFormat("big");
            titleField.text = title;
            s.addChild(titleField);
            
            var subtitleField:TextField = new TextField();
            subtitleField.selectable = false;
            subtitleField.autoSize = TextFieldAutoSize.LEFT;
            subtitleField.defaultTextFormat = menuTextFormat("small");
            subtitleField.text = subtitle;
            subtitleField.x = 24;
            subtitleField.y = titleField.height;
            s.addChild(subtitleField);

            var hitSprite:Sprite = new Sprite();
            hitSprite.graphics.beginFill(0xCCFF00);
            hitSprite.graphics.drawRect(0, 0,
                Math.max(titleField.x + titleField.width,
                        subtitleField.x + subtitleField.width),
                Math.max(titleField.y + titleField.height,
                        subtitleField.y + subtitleField.height));
            s.hitArea = hitSprite;
            hitSprite.visible = false;
            s.addChild(hitSprite);

            s.x = x;
            s.y = y;
            s.buttonMode = true;
            s.mouseChildren = false;
            s.addEventListener(MouseEvent.CLICK, callback);
            return s;
            
        }
        
        private function menuTextFormat(kind:String):TextFormat {
            var fmt:TextFormat = new TextFormat();
            fmt.font = "_sans";
            fmt.align = TextFormatAlign.LEFT;
            fmt.color = 0x999999;
            fmt.size = 14;
            if (kind == "section") {
                fmt.align = TextFormatAlign.CENTER;
            } else if (kind == "small") {
            } else if (kind == "big") {
                fmt.color = 0x000000;
                fmt.size = 18;                
            } else if (kind == "heading") {
                fmt.align = TextFormatAlign.CENTER;
                fmt.size = 18;
            } else {
                throw new Error("Invalid text format " + kind)
            }
            return fmt;
        }

        public function placeReturnButton():void {
            var s:Sprite = new Sprite();
            var titleField:TextField = new TextField();
            titleField.selectable = false;
            titleField.autoSize = TextFieldAutoSize.LEFT;
            titleField.defaultTextFormat = menuTextFormat("small");
            titleField.text = "(main menu)";
            s.addChild(titleField);

            var hitSprite:Sprite = new Sprite();
            hitSprite.graphics.beginFill(0xCCFF00);
            hitSprite.graphics.drawRect(0, 0, titleField.width, titleField.height);
            s.hitArea = hitSprite;
            hitSprite.visible = false;
            s.addChild(hitSprite);

            s.x = stage.stageWidth - s.width - 10;
            s.y = stage.stageHeight - s.height - 10 - body.y;
            s.buttonMode = true;
            s.mouseChildren = false;
            s.addEventListener(MouseEvent.CLICK, showMainMenu);
            body.addChild(s);

        }

        public function showMainMenu(ev:Object=null):void {
            clearSection();
            setSectionTitle("MochiAd " + MochiAd.getVersion() + " Demo");


            var menuTitle:TextField = new TextField();
            menuTitle.selectable = false;
            menuTitle.autoSize = TextFieldAutoSize.CENTER;
            menuTitle.y = 150 - body.y;
            menuTitle.x = 0.5 * stage.stageWidth;
            menuTitle.defaultTextFormat = menuTextFormat("heading");
            menuTitle.text = "Choose one of the functions below to demonstrate it in action";
            body.addChild(menuTitle);
            

            var menuItems:Array = [
                ["showInterLevelAd", "10 second inter-level ad", showInterLevel],
                ["showClickAwayAd", "Show an click-away ad", showClickAway]
            ];
            var m_x:Number = menuTitle.x;
            var m_y:Number = menuTitle.y + menuTitle.height + 5;
            for each (var menuItem:Array in menuItems) {
                var m:Sprite = newMenuButton(menuItem[0], menuItem[1], menuItem[2]);
                m.x = m_x;
                m.y = m_y;
                m_y += m.height + 5;
                body.addChild(m);
            }

        }
        
        private function clearSection():void {
            placeLogo();
            setSectionTitle("");
            if (body) {
                removeChild(body);
                body = null;
            }
            body = new MovieClip();
            body.y = sectionTitle.y + sectionTitle.height + 5;
            addChild(body);
        }
        
        private function setSectionTitle(title:String):void {
            if (sectionTitle == null) {
                sectionTitle = new TextField();
                sectionTitle.selectable = false;
                sectionTitle.autoSize = TextFieldAutoSize.CENTER;
                sectionTitle.y = logo.height + 5;
                sectionTitle.x = 0.5 * stage.stageWidth;
                sectionTitle.defaultTextFormat = menuTextFormat("section");
                addChild(sectionTitle);                        
            }
            sectionTitle.text = title;
        }
        
        private function placeLogo():void {
            if (logo == null) {
                logo = new Logo();
                logo.x = 0.5 * (stage.stageWidth - logo.width);
                addChild(logo);
            }
        }
        
        
    }

}
