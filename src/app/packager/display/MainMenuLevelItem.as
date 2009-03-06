
package packager.display {
   
   import flash.display.SimpleButton;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   import com.tapirgames.display.TextFieldEx;
   import flash.text.TextFieldAutoSize;
   
   public class MainMenuLevelItem extends SimpleButton 
   {
      private var mLevelIndex:uint;
      
      public function MainMenuLevelItem (levelIndex:uint, finished:Boolean, locked:Boolean, w:uint, h:uint) 
      {
         mLevelIndex = levelIndex;
         
         // Create the different states of the button, using the
         // helper method to create different colors circles
         upState = new Sprite ();
         
         (upState as Sprite).addChild (CreateRoundRect( finished ? 0x60C060 : 0xC06060, w, h ));
         if (finished)
         {
         }
         if (locked)
         {
         }
         
         overState = new Sprite ();
         
         (overState as Sprite).addChild (CreateRoundRect( 0x8080FF, w, h ));
         if (finished)
         {
         }
         if (locked)
         {
         }
         
         downState = overState;
         hitTestState = upState;
      }
      
      public function GetLevelIndex ():uint
      {
         return mLevelIndex;
      }
      
      // Helper function to create a circle shape with a given color
      // and radius
      private function CreateRoundRect( color:uint, w:Number, h:Number ):Sprite 
      {
         var block:Sprite = new Sprite();
         block.graphics.beginFill(color);
         block.graphics.lineStyle(2, 0xC2C2C2);
         block.graphics.drawRoundRect(0, 0, w, h, 8);
         block.graphics.endFill();
         
         var idText:String = "<font size='10' face='Verdana' color='#000000'>" + mLevelIndex + "</font>";
         var idTextField:TextFieldEx = TextFieldEx.CreateTextField (idText, false, 0x0, 0x0, false);
         idTextField.x = (w - idTextField.width) * 0.5;
         idTextField.y = (h - idTextField.height) * 0.5;
         
         block.addChild (idTextField);
         
         return block;
      }
      

   }
}