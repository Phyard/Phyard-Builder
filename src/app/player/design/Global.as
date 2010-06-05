package player.design
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.IPropertyOwner;
   import player.trigger.VariableSpace;
   import player.trigger.VariableInstance;
   
   import actionscript.util.RandomNumberGenerator;
   import com.stephencalenderblog.MersenneTwisterRNG;
   
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
      
      public static var mRandomNumberGenerators:Array;
      
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
         mRegisterVariableSpace_String            = CreateRegisterVariableSpace (null);
         mRegisterVariableSpace_Number            = CreateRegisterVariableSpace (0);
         mRegisterVariableSpace_Entity            = CreateRegisterVariableSpace (null);
         mRegisterVariableSpace_CollisionCategory = CreateRegisterVariableSpace (null);
         
         mRandomNumberGenerators = new Array (Define.NumRngSlots);
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
         var vs:VariableSpace = new VariableSpace (Define.NumRegistersPerVariableType);
         
         for (var i:int = 0; i < Define.NumRegistersPerVariableType; ++ i)
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
      
      public static function CreateRandomNumberGenerator (rngSlot:int, rngMethod:int):void
      {
         if (rngSlot < 0 || rngSlot >= Define.NumRngSlots)
            throw new Error ("Invalid RNG slot " + rngSlot);
         
         if (rngMethod < 0 || rngMethod >= Define.NumRngMethods)
            throw new Error ("Invalid RNG method " + rngMethod);
         
         if (rngMethod == 0)
         {
            mRandomNumberGenerators [rngSlot] = new MersenneTwisterRNG ();
         }
      }
      
      public static function GetRandomNumberGenerator (rngSlot:int):RandomNumberGenerator
      {
         return mRandomNumberGenerators [rngSlot];
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
      
//==============================================================================
// callbacks
//==============================================================================
      
      public static var RestartPlay:Function = null;
      public static var IsPlaying:Function = null;
      public static var SetPlaying:Function = null;
      public static var GetSpeedX:Function = null;
      public static var SetSpeedX:Function = null;
      public static var GetScale:Function = null;
      public static var SetScale:Function = null;
      
   }
}