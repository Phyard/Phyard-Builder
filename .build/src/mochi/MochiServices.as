/**
* MochiServices
* Connection class for all MochiAds Remote Services
* @author Mochi Media
* @version 1.33
*/

package mochi {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.system.Security;
	import flash.system.Capabilities;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.LocalConnection;
    import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
    import flash.utils.setTimeout;
	
	public class MochiServices {

		private static var _id:String;
		private static var _container:Object;
		private static var _clip:MovieClip;
		private static var _loader:Loader;
		private static var _timer:Timer;
		private static var _startTime:Number;
		
		private static var _gatewayURL:String = "http://www.mochiads.com/static/lib/services/services.swf";
		private static var _swfVersion:String;
		
		private static var _listenChannel:LocalConnection;
		private static var _listenChannelName:String = "__mochiservices";
		private static var _sendChannel:LocalConnection;
		private static var _sendChannelName:String;
		private static var _rcvChannel:LocalConnection;
		private static var _rcvChannelName:String;
		
		private static var _connecting:Boolean = false;
		private static var _connected:Boolean = false;
		
		public static var onError:Object;
		
		//
		public static function get id ():String {
			return _id;
		}
		
		//
		public static function get clip ():Object {
			return _container;
		}
		
		//
		public static function get childClip ():Object {
			return _clip;
		}

		//
		//
		public static function getVersion():String {
			return "1.35";
		}
		
		//
		//
        public static function allowDomains(server:String):String {

            flash.system.Security.allowDomain("*");
            flash.system.Security.allowInsecureDomain("*");
			
			if (server.indexOf("http://") != -1) {
				var hostname:String = server.split("/")[2].split(":")[0];
				flash.system.Security.allowDomain(hostname);
				flash.system.Security.allowInsecureDomain(hostname);
			}
            
            return hostname;
        }
		
		//
		//
        public static function isNetworkAvailable():Boolean {
            return Security.sandboxType != "localWithFile";
        }
		
		//
		public static function set comChannelName(val:String):void {
			if (val != null) {
				if (val.length > 3) {
					_sendChannelName = val + "_fromgame";
					_rcvChannelName = val;
					initComChannels();
				}
			}
		}
		
		//
		public static function get connected ():Boolean {
			return _connected;
		}
		
		/**
		 * Method: connect
		 * Connects your game to the MochiServices API
		 * @param	id the MochiAds ID of your game
		 * @param	clip the MovieClip in which to load the API (optional for all but AS3, defaults to _root)
		 * @param	onError a function to call upon connection or IO error
		 */
		public static function connect (id:String, clip:Object, onError:Object = null):void {
			if (clip is DisplayObject) {
				if (!_connected && _clip == null) {
					trace("MochiServices Connecting...");
					_connecting = true;
					init(id, clip);	
				}
			} else {
				trace("Error, MochiServices requires a Sprite, Movieclip or instance of the stage.");
			}
			if (onError != null) {
				MochiServices.onError = onError;
			} else if (MochiServices.onError == null) {
				MochiServices.onError = function (errorCode:String):void { trace(errorCode); }
			}
		}
	
		public static function disconnect ():void {
			if (_connected || _connecting) {
				if (_clip != null) {
					if (_clip.parent != null) {
						if (_clip.parent is Sprite) {
							Sprite(_clip.parent).removeChild(_clip);
							_clip = null;
						}
					}
				}
				_connecting = _connected = false;
				flush(true);
				try {
					_listenChannel.close();
					_rcvChannel.close();
				} catch (error:Error) { }
			}
			if (_timer != null) {
				try {
					_timer.stop();
				} catch (error:Error) { }
			}
		}
		
        public static function createEmptyMovieClip(parent:Object, name:String, depth:Number, doAdd:Boolean = true):MovieClip {
            var mc:MovieClip = new MovieClip();
			if (doAdd) {
				if (false && depth) {
					parent.addChildAt(mc, depth);
				} else {
					parent.addChild(mc);
				}
			}
			try {
				parent[name] = mc;
			} catch (e:Error) {
				throw new Error("MochiServices requires a clip that is an instance of a dynamic class.  If your class extends Sprite or MovieClip, you must make it dynamic.");
			}
            mc["_name"] = name;
            return mc;
        }
		
		public static function stayOnTop ():void {
			_container.addEventListener(Event.ENTER_FRAME, MochiServices.bringToTop, false, 0, true);
			if (_clip != null) { _clip.visible = true; }
		}
		
		
		public static function doClose ():void {
			_container.removeEventListener(Event.ENTER_FRAME, MochiServices.bringToTop);
			if (_clip.parent != null) {
				Sprite(_clip.parent).removeChild(_clip);
			}
		}
		
		
		public static function bringToTop (e:Event):void {
			if (MochiServices.clip != null) {
				if (MochiServices.childClip != null) {
					try {
						if (MochiServices.clip.numChildren > 1) {
							MochiServices.clip.setChildIndex(MochiServices.childClip, MochiServices.clip.numChildren - 1);
						}
					} catch (errorObject:Error) {
						trace("Warning: Depth sort error.");
						_container.removeEventListener(Event.ENTER_FRAME, MochiServices.bringToTop);
					}
				}
			}
		}
		
		//
		//
		private static function init (id:String, clip:Object):void {
			_id = id;
			if (clip != null) {
				_container = clip;
				loadCommunicator(id, _container);
			}
			
		}
		
		//
		//
		public static function setContainer (container:Object = null, doAdd:Boolean = true):void {
			
			if (container != null) {
				if (container is Sprite) _container = container;
			}
			
			if (doAdd) {
				if (_container is Sprite) {
					Sprite(_container).addChild(_clip);
				}
			}
			
		}
		
		
		//
		//
		private static function loadCommunicator (id:String, clip:Object):MovieClip {
				
			var clipname:String = '_mochiservices_com_' + id;
			
			if (_clip != null) {
				return _clip;
			}
			
			if (!MochiServices.isNetworkAvailable()) {
				return null;
			}
			
			MochiServices.allowDomains(_gatewayURL);
			
			_clip = createEmptyMovieClip(clip, clipname, 10336, false);
			 
			// load com swf into container

			_loader = new Loader();
			_timer = new Timer(1000, 0);
			_startTime = getTimer();
			_timer.addEventListener(TimerEvent.TIMER, connectWait);
			_timer.start();
			
            var f:Function = function (ev:Object):void { 
				_clip._mochiad_ctr_failed = true;
				trace("MochiServices could not load.");
				MochiServices.disconnect();
				MochiServices.onError("IOError");
			}
			
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, f);
			 
			var req:URLRequest = new URLRequest(_gatewayURL);
            _loader.load(req);
			
            _clip.addChild(_loader);
			_clip._mochiservices_com = _loader;

			// init send channel
			_sendChannel = new LocalConnection();
			_clip._queue = [];
			
			// init rcv channel
			_rcvChannel = new LocalConnection();
            _rcvChannel.allowDomain("*", "localhost");
            _rcvChannel.allowInsecureDomain("*", "localhost");
			_rcvChannel.client = _clip;
			_clip._nextcallbackID = 0;
			_clip._callbacks = {};
			listen();
			return _clip;
		}
		
		//
		//
		public static function connectWait (e:TimerEvent):void { 
			if (getTimer() - _startTime > 10000) {
				if (!_connected) {
					_clip._mochiad_ctr_failed = true;
					trace("MochiServices could not load.");
					MochiServices.disconnect();
					MochiServices.onError("IOError");
				}
				_timer.stop();
			}
		}

		//
		//
		private static function onStatus (event:StatusEvent):void {
			switch (event.level) {	
				case 'error' :
					_connected = false;
					_listenChannel.connect(_listenChannelName);
					break;	
			}
		}
		
		//
		//
		private static function listen ():void {
			_listenChannel = new LocalConnection();
			_listenChannel.client = _clip;
			_clip.handshake = function (args:Object):void { MochiServices.comChannelName = args.newChannel; }
			_listenChannel.allowDomain("*", "localhost");
			_listenChannel.allowInsecureDomain("*", "localhost");
			_listenChannel.connect(_listenChannelName);
			trace("Waiting for MochiAds services to connect...");
		}
		
		//
		//
		private static function initComChannels ():void {	
			if (!_connected) {	
				_sendChannel.addEventListener(StatusEvent.STATUS, MochiServices.onStatus);
				_sendChannel.send(_sendChannelName, "onReceive", {methodName: "handshakeDone"});
				_sendChannel.send(_sendChannelName, "onReceive", { methodName: "registerGame", id: _id, clip: _container, version: getVersion(), parentURL: _container.loaderInfo.loaderURL } );
				_rcvChannel.addEventListener(StatusEvent.STATUS, MochiServices.onStatus);
				_clip.onReceive = function (pkg:Object):void {
					var cb:String = pkg.callbackID;
					var cblst:Object = this.client._callbacks[cb];
					if (!cblst) return;
					var method:* = cblst.callbackMethod;
					var methodName:String = "";
					var obj:Object = cblst.callbackObject;
					if (obj && typeof(method) == 'string') {
						methodName = method;
						if (obj[method] != null) {
							method = obj[method];
						} else {
							trace("Error: Method  " + method + " does not exist.");
						}
					}
					if (method != undefined) {
						try { 
							method.apply(obj, pkg.args); 
						} catch (error:Error) {
							trace("Error invoking callback method '" + methodName + "': " + error.toString());
						}
					} else if (obj != null) {
						try { 
							obj(pkg.args);
						} catch (error:Error) {
							trace("Error invoking method on object: " + error.toString());
						}
					}
					delete this.client._callbacks[cb];
				}
				_clip.onError = function ():void { MochiServices.onError("IOError"); };
				_rcvChannel.connect(_rcvChannelName);
				trace("connected!");
				_connecting = false;
				_connected = true;
				_listenChannel.close();
				while(_clip._queue.length > 0) {
					_sendChannel.send(_sendChannelName, "onReceive", _clip._queue.shift());
				}
			}	
		}
		
			
		//
		//
		private static function flush (error:Boolean):void {
			
			var request:Object;
			var callback:Object;
		
			if (_clip != null) {
				if (_clip._queue != null) {
					while (_clip._queue.length > 0) {
						
						request = _clip._queue.shift();
						callback = null;
						
						if (request != null) {
							
							if (request.callbackID != null) callback = _clip._callbacks[request.callbackID];
							delete _clip._callbacks[request.callbackID];
							
							if (error && callback != null) {
								handleError(request.args, callback.callbackObject, callback.callbackMethod);
							}
						
						}
						
					}	
				}
			}
			
		}
		
		//
		//
		private static function handleError (args:Object, callbackObject:Object, callbackMethod:Object):void {
			
			if (args != null) {
				if (args.onError != null) {
					args.onError.apply(null, ["NotConnected"]);
				} 
				if (args.options != null && args.options.onError != null) {
					args.options.onError.apply(null, ["NotConnected"]);
				}
			}
			
			if (callbackMethod != null) {
				
				args = { };
				args.error = true;
				args.errorCode = "NotConnected";
			
				if (callbackObject != null && callbackMethod is String) {
					try {
						callbackObject[callbackMethod](args);
					} catch (error:Error) { }
				} else if (callbackMethod != null) {
					try {
						callbackMethod.apply(args);
					} catch (error:Error) { }
				}	
				
			}
			
		}
		
		//
		//
		public static function send (methodName:String, args:Object = null, callbackObject:Object = null, callbackMethod:Object = null):void {
			if (_connected) {
				_sendChannel.send(_sendChannelName, "onReceive", {methodName: methodName, args: args, callbackID: _clip._nextcallbackID});
			} else if (_clip == null || !_connecting) {
				onError("NotConnected");
				handleError(args, callbackObject, callbackMethod);
				flush(true);
				return;
			} else {
				_clip._queue.push({methodName: methodName, args: args, callbackID: _clip._nextcallbackID});
			}
			if (_clip != null) {
				if (_clip._callbacks != null && _clip._nextcallbackID != null) {
					_clip._callbacks[_clip._nextcallbackID] = {callbackObject: callbackObject, callbackMethod: callbackMethod};
					_clip._nextcallbackID++;
				}
			}
		}		

        public static function addLinkEvent(url:String, burl:String, btn:DisplayObjectContainer, onClick:Function = null):void {
            var netup:Boolean;
            var vars:Object = new Object();
            vars["mav"] = getVersion();
            vars["swfv"] = "9";
            vars["swfurl"] = btn.loaderInfo.loaderURL;
            vars["fv"] = Capabilities.version;
            vars["os"] = Capabilities.os;
            vars["lang"] = Capabilities.language;
            vars["scres"] = (Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY);
            
            var s:String = "?";
            var i:Number = 0;
            for (var x:String in vars) {
                if (i != 0) s = s + "&";
                i++;
                s = s + x + "=" + escape(vars[x]);
            }
            
            var req:URLRequest = new URLRequest("http://x.mochiads.com/linkping.swf");
            var loader:Loader = new Loader();
            
            var err:Function = function (ev:Object):void {
                netup = false;
                ev.target.removeEventListener(ev.type, arguments.callee);
            }
            var complete:Function = function(ev:Object):void {
                netup = true;
                ev.target.removeEventListener(ev.type, arguments.callee);
            }
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, err);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
            loader.load(req);

            var setURL:Function = function():void {
                var u:String;
                
                if (netup) {
                    u = url + s;
                } else {
                    u = burl;
                }
                
                var avm1Click:DisplayObject = clickMovie(u, onClick );
                btn.addChild(avm1Click);
                avm1Click.scaleX = 0.01 * btn.width;
                avm1Click.scaleY = 0.01 * btn.height;
            }
            
            setTimeout(setURL, 1500);
        }
        
        
        private static function clickMovie(url:String, cb:Function):MovieClip {
            var avm1_bytecode:Array = [150, 21, 0, 7, 1, 0, 0, 0, 0, 98, 116, 110, 0, 7, 2, 0, 0, 0, 0, 116, 104, 105, 115, 0, 28, 150, 22, 0, 0, 99, 114, 101, 97, 116, 101, 69, 109, 112, 116, 121, 77, 111, 118, 105, 101, 67, 108, 105, 112, 0, 82, 135, 1, 0, 0, 23, 150, 13, 0, 4, 0, 0, 111, 110, 82, 101, 108, 101, 97, 115, 101, 0, 142, 8, 0, 0, 0, 0, 2, 42, 0, 114, 0, 150, 17, 0, 0, 32, 0, 7, 1, 0, 0, 0, 8, 0, 0, 115, 112, 108, 105, 116, 0, 82, 135, 1, 0, 1, 23, 150, 7, 0, 4, 1, 7, 0, 0, 0, 0, 78, 150, 8, 0, 0, 95, 98, 108, 97, 110, 107, 0, 154, 1, 0, 0, 150, 7, 0, 0, 99, 108, 105, 99, 107, 0, 150, 7, 0, 4, 1, 7, 1, 0, 0, 0, 78, 150, 27, 0, 7, 2, 0, 0, 0, 7, 0, 0, 0, 0, 0, 76, 111, 99, 97, 108, 67, 111, 110, 110, 101, 99, 116, 105, 111, 110, 0, 64, 150, 6, 0, 0, 115, 101, 110, 100, 0, 82, 79, 150, 15, 0, 4, 0, 0, 95, 97, 108, 112, 104, 97, 0, 7, 0, 0, 0, 0, 79, 150, 23, 0, 7, 255, 0, 255, 0, 7, 1, 0, 0, 0, 4, 0, 0, 98, 101, 103, 105, 110, 70, 105, 108, 108, 0, 82, 23, 150, 25, 0, 7, 0, 0, 0, 0, 7, 0, 0, 0, 0, 7, 2, 0, 0, 0, 4, 0, 0, 109, 111, 118, 101, 84, 111, 0, 82, 23, 150, 25, 0, 7, 100, 0, 0, 0, 7, 0, 0, 0, 0, 7, 2, 0, 0, 0, 4, 0, 0, 108, 105, 110, 101, 84, 111, 0, 82, 23, 150, 25, 0, 7, 100, 0, 0, 0, 7, 100, 0, 0, 0, 7, 2, 0, 0, 0, 4, 0, 0, 108, 105, 110, 101, 84, 111, 0, 82, 23, 150, 25, 0, 7, 0, 0, 0, 0, 7, 100, 0, 0, 0, 7, 2, 0, 0, 0, 4, 0, 0, 108, 105, 110, 101, 84, 111, 0, 82, 23, 150, 25, 0, 7, 0, 0, 0, 0, 7, 0, 0, 0, 0, 7, 2, 0, 0, 0, 4, 0, 0, 108, 105, 110, 101, 84, 111, 0, 82, 23, 150, 16, 0, 7, 0, 0, 0, 0, 4, 0, 0, 101, 110, 100, 70, 105, 108, 108, 0, 82, 23];
            var b:int;
            var header:Array = [
                0x68, 0x00, 0x1f, 0x40, 0x00, 0x07, 0xd0, 0x00,
                0x00, 0x0c, 0x01, 0x00, 0x43, 0x02, 0xff, 0xff,
                0xff, 0x3f, 0x03
            ];
            var footer:Array = [0x00, 0x40, 0x00, 0x00, 0x00];

            var mc:MovieClip = new MovieClip();
            var lc:LocalConnection = new LocalConnection();
            var lc_name:String = "_click_" + Math.floor(Math.random() * 999999) + "_" + Math.floor((new Date()).getTime());
            lc = new LocalConnection();
            mc.lc = lc;
            mc.click = cb;
            lc.client = mc;
            lc.connect(lc_name)

            var ba:ByteArray = new ByteArray();
            var cpool:ByteArray = new ByteArray();

            cpool.endian = Endian.LITTLE_ENDIAN;
            cpool.writeShort(1);
            cpool.writeUTFBytes(url + " " + lc_name);
            cpool.writeByte(0);

            var actionLength:uint = avm1_bytecode.length + cpool.length + 4;
            var fileLength:uint = actionLength + 35;

            ba.endian = Endian.LITTLE_ENDIAN;
            ba.writeUTFBytes("FWS");
            ba.writeByte(8);
            ba.writeUnsignedInt(fileLength);
            for each (b in header) {
                ba.writeByte(b);
            }
            ba.writeUnsignedInt(actionLength);

            ba.writeByte(0x88);
            ba.writeShort(cpool.length);
            ba.writeBytes(cpool);

            for each (b in avm1_bytecode) {
                ba.writeByte(b);
            }

            for each (b in footer) {
                ba.writeByte(b);
            }

            var loader:Loader = new Loader();
            loader.loadBytes(ba);
            mc.addChild(loader);
            return mc;
        }
	}
}

