
package editor.mode {
   
   import editor.WorldView;
   
   
   public class Mode
   {
      protected var mMainView:WorldView;
      
      
      public function Mode (mainView:WorldView)
      {
         mMainView = mainView;
      }
      
      public function Initialize ():void
      {
      }
      
      public function Destroy ():void
      {
      }
      
      public function Update (escapedTime:Number):void
      {
         
      }
      
      public function OnMouseDown (mouseX:Number, mouseY:Number):void
      {
         
      }
      
      public function OnMouseMove (mouseX:Number, mouseY:Number):void
      {
      }
      
      public function OnMouseUp (mouseX:Number, mouseY:Number):void
      {
      }
   }
   
}