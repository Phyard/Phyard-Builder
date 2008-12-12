package com.tapirgames.suit2d.loader {
   
   public class PropertyDefine 
   {
      public var mGroupName:String;
      public var mName:String;
      
      public var mTypeID:int;
      
      public function PropertyDefine (groupName:String, name:String, typeID:int)
      {
         mGroupName = groupName;
         mName = name;
         
         mTypeID = typeID;
      }
     
   }
}