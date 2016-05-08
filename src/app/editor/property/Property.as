
package editor.entity {
   
   import flash.display.Sprite;
   
   
   public class Property extends Sprite 
   {
      private var mName:String;
      private var mValue:Object;
      
      public function Property (name:String, value:Object)
      {
         mName = name == null ? "" : name;
         
         SetValue (value);
      }
      
      public function GetName ():String
      {
         return mName;
      }
      
      public function GetValue ():Object
      {
         return mValue;
      }
      
      public function SetValue (value:Object):void
      {
         mValue = value;
      }
      
   }
}
