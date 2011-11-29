package com.tapirgames.util
{
   import flash.events.Event;

   public class ResourceLoadEvent extends Event
   {
      public static const RESOURCE_LOADED:String="resource_loaded";
      
      private var mResource:Object;
      
      public function ResourceLoadEvent (resource:Object, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         var type:String = RESOURCE_LOADED;
         
         mResource = resource;
         
         super(type, bubbles, cancelable);
      }
      
      override public function clone():Event
      {
         return new ResourceLoadEvent (mResource);
      }
      
      public function get resource ():Object
      {
         return mResource;
      }
   }
}
