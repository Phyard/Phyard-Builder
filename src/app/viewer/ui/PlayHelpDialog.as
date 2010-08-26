package viewer.ui {
   
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   import flash.events.Event;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.display.TextButton;
   import com.tapirgames.display.ImageButton;
   
   import common.Define;
   
   public class PlayHelpDialog extends Sprite
   {
      private var mTextTutorial:TextFieldEx;
      private var mButtonCloseHelpDialog:TextButton;
      
      private var mBox2dText:TextFieldEx;
      
      private var _OnClose:Function = null;
      
      public function PlayHelpDialog (onClose:Function)
      {
         _OnClose = onClose;
         
         var tutorialText:String = 
            "<font size='15' face='Verdana' color='#000000'>The goal of <b>Color Infection</b> puzzles is to infect all <font color='#FFFF00'><b>YELLOW</b></font> objects with "
                        + "the <font color='#804000'><b>BROWN</b></font> color by colliding them with <font color='#804000'><b>BROWN</b></font> objects "
                        + "but keep all <font color='#60FF60'><b>GREEN</b></font> objects uninfected."
                        + "<br /><br />To play, <br/>"
                        + "- click a <font color='#FF00FF'><b>PINK</b></font> object to destroy it,<br/>"
                        + "- click a <font color='#000000'><b>BOMB</b></font> object to explode it."
                        + "</font>";
         
         mTextTutorial = TextFieldEx.CreateTextField (tutorialText, false, 0xFFFFFF, 0x0, true, Define.DefaultWorldWidth / 2);
         
         var box2dText:String =  "<font size='10' face='Verdana' color='#000000'>(This player is based on fbox2d, an actionscript<br/>"
                                                                                + "port of the famous box2d c++ physics engine.)</font>";
         mBox2dText = TextFieldEx.CreateTextField (box2dText);
         
         mButtonCloseHelpDialog = new TextButton ("<font face='Verdana' size='16' color='#0000FF'>   Close   </font>", OnClickClose);
         
         UiUtil.CreateDialog ([mTextTutorial, 20 ,mBox2dText, 20, mButtonCloseHelpDialog], this);
      }
      
      private function OnClickClose ():void
      {
         if (_OnClose != null)
            _OnClose ();
      }
   }
}
