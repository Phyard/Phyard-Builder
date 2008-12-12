package com.tapirgames.util {

   
   import flash.utils.Dictionary;
   
   public class ResourceManager {
   

            
//======================================================================================================
// resource list
//======================================================================================================
      
      private static var mResourceDict:Dictionary = new Dictionary ();
      
      public static function RegisterResource (resourceName:String, resource:Object):void
      {
         mResourceDict [resourceName] = resource;
      }
      
      public static function UnregisterResource (resourceName:String):void
      {
         delete mResourceDict [resourceName];
      }
      
      public static function GetResource (resourceName:String):Object
      {
         return mResourceDict [resourceName];
      }
   }
   
}