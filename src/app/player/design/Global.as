package player.design
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.IPropertyOwner;
   import player.trigger.VariableSpace;
   import player.trigger.VariableInstance;
   
   import common.trigger.ValueTypeDefine;
   import common.Define;
   
   public class Global implements IPropertyOwner
   {
      public static var sTheGlobal:Global = null;
      
      public static var mCurrentDesign:Design = null;
      
      // these variables are static, which mmeans there can only be one player instance running at the same time.
      
      public static var mRegisterVariableSpace_Boolean:VariableSpace;
      public static var mRegisterVariableSpace_String :VariableSpace;
      public static var mRegisterVariableSpace_Number :VariableSpace;
      public static var mRegisterVariableSpace_Entity :VariableSpace;
      public static var mRegisterVariableSpace_CollisionCategory:VariableSpace;
      
//==============================================================================
// static values
//==============================================================================
      
      public static function InitGlobalData ():void
      {
         //
         sTheGlobal = new Global ();
         
         //
         TriggerEngine.InitializeConstData ();
         
         //
         mRegisterVariableSpace_Boolean           = CreateRegisterVariableSpace (false);
         mRegisterVariableSpace_String            = CreateRegisterVariableSpace (false);
         mRegisterVariableSpace_Number            = CreateRegisterVariableSpace (false);
         mRegisterVariableSpace_Entity            = CreateRegisterVariableSpace (false);
         mRegisterVariableSpace_CollisionCategory = CreateRegisterVariableSpace (false);
      }
      
      public static function SetCurrentDesign (design:Design):void
      {
         mCurrentDesign = design;
      }
      
      public static function GetCurrentDesign ():Design
      {
         return mCurrentDesign;
      }
      
      public static function GetCurrentWorld ():World
      {
         if (mCurrentDesign == null)
            return null;
         
         return mCurrentDesign.mCurrentWorld;
      }
      
      protected static function CreateRegisterVariableSpace (initValueObject:Object):VariableSpace
      {
         var vs:VariableSpace = new VariableSpace (Define.NumRegistersPerType);
         
         for (var i:int = 0; i < Define.NumRegistersPerType; ++ i)
            vs.GetVariableAt (i).SetValueObject (initValueObject);
         
         return vs;
      }
      
      public static function GetRegisterVariableSpace (valueType:int):VariableSpace
      {
         switch (valueType)
         {
            case ValueTypeDefine.ValueType_Boolean:
               return mRegisterVariableSpace_Boolean;
            case ValueTypeDefine.ValueType_String:
               return mRegisterVariableSpace_String;
            case ValueTypeDefine.ValueType_Number:
               return mRegisterVariableSpace_Number;
            case ValueTypeDefine.ValueType_Entity:
               return mRegisterVariableSpace_Entity;
            case ValueTypeDefine.ValueType_CollisionCategory:
               return mRegisterVariableSpace_CollisionCategory;
            default:
               return null;
         }
      }
      
      public static function GetPropertyValue (propertyId:int):Object
      {
         return sTheGlobal.GetPropertyValue (propertyId);
      }
      
      public static function SetPropertyValue (propertyId:int, value:Object):void
      {
         sTheGlobal.SetPropertyValue (propertyId, value);
      }
      
//==============================================================================
// IPropertyOwner
//==============================================================================
      
      public function Global ()
      {
      }
      
      public function GetPropertyValue (propertyId:int):Object
      {
         return null;
      }
      
      public function SetPropertyValue (propertyId:int, value:Object):void
      {
      }
      
      
      
   }
}