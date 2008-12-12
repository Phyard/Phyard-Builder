package mochi {
    import flash.display.Sprite;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    /*
    import mx.controls.TextInput;
    */
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.events.MouseEvent;

    public dynamic class ScoreInput extends Sprite {
        private var _playerName:String;
        private var _playerScore:Number;
        private var _sendScore:Function;

        public static var DEFAULT_NAME:String = "Your Name";

        public function ScoreInput(name:String, score:Number, sendScore:Function) {
            super();
            if (name == null || name == "") {
                name = DEFAULT_NAME;
            }
            _playerName = name;
            _playerScore = score;
            _sendScore = sendScore;
        }

        public function init():void {
            var scoreLabel:TextField = new_tf("label");
            scoreLabel.text = "Your Score:";

            var nameLabel:TextField = new_tf("label");
            nameLabel.text = "Your Name:";
            nameLabel.y = 20;

            var scoreInput:TextField = new_tf("input");
            scoreInput.text = commafy(_playerScore);
            scoreInput.x = 83;
            scoreInput.width = 185;

            // TODO: This doesn't actually work. Some weird Flex stuff.
            /*
            var nameInput:TextInput = new TextInput();
            addChild(nameInput);
            nameInput.setStyle("color", 0x000000);
            nameInput.setStyle("fontFamily", "_sans");
            nameInput.setStyle("fontSize", 14);
            */
            var nameInput:TextField = new_tf("input");
            nameInput.text = _playerName;
            nameInput.y = 20;
            nameInput.x = 83;
            nameInput.width = 185;

            var submitLabel:TextField = new_tf("label");
            submitLabel.text = "[submit]";
            submitLabel.y = nameInput.y;
            submitLabel.x = nameInput.x + nameInput.width + 10;
            submitLabel.width = 70;

            var s:Sprite = new Sprite();
            var hitSprite:Sprite = new Sprite();
            hitSprite.graphics.beginFill(0xCCFF00);
            hitSprite.graphics.drawRect(0, 0, submitLabel.width, submitLabel.height);
            s.hitArea = hitSprite;
            hitSprite.visible = false;
            s.addChild(hitSprite);
            s.buttonMode = true;
            s.mouseChildren = false;
            s.addEventListener(MouseEvent.CLICK, submitScore);
            addChild(s);
            s.x = submitLabel.x;
            s.y = submitLabel.y;
        }

        public function submitScore(ev:Object=null):void {
            visible = false;
            _sendScore(_playerName);
        }

        public function new_tf(format:String):TextField {
            var rval:TextField = new TextField();
            rval.defaultTextFormat = scoreTextFormat(format);
            rval.selectable = false;
            addChild(rval);
            return rval;
        }

        private function scoreTextFormat(kind:String):TextFormat {
            var fmt:TextFormat = new TextFormat();
            fmt.font = "_sans";
            fmt.color = 0x999999;
            fmt.size = 14;
            fmt.align = TextFormatAlign.LEFT;
            if (kind == "label") {
            } else if (kind == "input") {
                fmt.color = 0x000000;
            } else {
                throw new Error("Invalid text format " + kind)
            }
            return fmt;
        }

        /*
            Various utility functions used by this score table.
        */

        public function commafy(n:Number):String {
            /*
                Format an integer as ###,###.
            */
            var s:String = Math.floor(n).toString();
            var res:Array = [];
            while (s.length > 3) {
                res.unshift(s.slice(s.length - 3, s.length));
                s = s.slice(0, s.length - 3);
            }
            res.unshift(s);
            return res.join(",");
        }

    }

}
