
package editor.display.control {
   
   import flash.events.MouseEvent;
   
   import mx.events.FlexEvent;
   
   import mx.controls.Button;
   
   import editor.asset.Asset;
   import editor.sound.AssetSound;
   import editor.sound.dialog.AssetSoundListDialog;
   
   public class SoundPickButton extends Button 
   {
      protected var mSound:AssetSound;
      
      public function SoundPickButton (initialSound:AssetSound = null)
      {
         OnSoundPicked (initialSound);
         
         addEventListener (MouseEvent.CLICK, OnClick);
      }
      
      public function GetPickedSound ():AssetSound
      {
         return mSound;
      }
      
      public function SetPickedSound (sound:AssetSound):void
      {
         OnSoundPicked (sound);
      }
      
      private function OnSoundPicked (asset:AssetSound):void 
      {
         mSound = asset as AssetSound;
         
         label = mSound == null ? "Null" : mSound.ToCodeString ();
      }
      
      private function OnClick (event:MouseEvent):void 
      {
         AssetSoundListDialog.StartPickSound (OnSoundPicked);
      }
   }
}
