
package editor.display.control {
   
   import flash.events.MouseEvent;
   
   import mx.events.FlexEvent;
   
   import mx.controls.Button;
   
   import editor.image.AssetImageModule;
   import editor.image.dialog.AssetImageModuleListDialog;
   
   public class ModulePickButton extends Button 
   {
      protected var mModule:AssetImageModule;
      
      public function ModulePickButton (initialModule:AssetImageModule)
      {
         OnModulePicked (initialModule);
         
         addEventListener (MouseEvent.CLICK, OnClick);
      }
      
      public function GetPickedModule ():AssetImageModule
      {
         return mModule;
      }
      
      private function OnModulePicked (module:AssetImageModule):void 
      {
         mModule = module;
         
         label = module == null ? "Null" : module.ToCodeString ();
      }
      
      private function OnClick (event:MouseEvent):void 
      {
         AssetImageModuleListDialog.StartPickModule (OnModulePicked);
      }
   }
}
