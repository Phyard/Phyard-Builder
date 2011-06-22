package player.design
{
   import player.world.World;
   
   import player.trigger.TriggerEngine;
   import player.trigger.VariableSpace;
   import player.trigger.VariableInstance;
   import player.trigger.FunctionDefinition_Custom;
   
   import actionscript.util.RandomNumberGenerator;
   import com.stephencalenderblog.MersenneTwisterRNG;
   
   import common.trigger.ValueTypeDefine;
   import common.trigger.define.FunctionDefine;
   
   import common.TriggerFormatHelper2;
   
   import common.Define;
   
   public class Global
   {
      public static var sTheGlobal:Global = null;
      
      public static var mCurrentWorld:World = null;
      
      // these variables are static, which mmeans there can only be one player instance running at the same time.
      
      public static var mRegisterVariableSpace_Boolean:VariableSpace;
      public static var mRegisterVariableSpace_String :VariableSpace;
      public static var mRegisterVariableSpace_Number :VariableSpace;
      public static var mRegisterVariableSpace_Entity :VariableSpace;
      public static var mRegisterVariableSpace_CollisionCategory:VariableSpace;
      public static var mRegisterVariableSpace_Array:VariableSpace;
      
      public static var mRandomNumberGenerators:Array;
      
      //public static var mGlobalVariableSpaces:Array;
      public static var mGlobalVariableSpace:VariableSpace;
      
      //public static var mEntityVariableSpaces:Array;
      public static var mEntityVariableSpace:VariableSpace;
      
      public static var mCustomFunctionDefinitions:Array;
      
   // callbacks
      
      public static var RestartPlay:Function;
      public static var IsPlaying:Function;
      public static var SetPlaying:Function;
      public static var GetSpeedX:Function;
      public static var SetSpeedX:Function;
      public static var GetScale:Function;
      public static var SetScale:Function;
      
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
         mRegisterVariableSpace_Array             = CreateRegisterVariableSpace (null);
         
         mRandomNumberGenerators = new Array (Define.NumRngSlots);
         
         mGlobalVariableSpace = null;
         mEntityVariableSpace = null;
         
         //
         RestartPlay = null;
         IsPlaying = null;
         SetPlaying = null;
         GetSpeedX = null;
         SetSpeedX = null;
         GetScale = null;
         SetScale = null;
      }
      
      public static function SetCurrentWorld (world:World):void
      {
         mCurrentWorld = world;
      }
      
      public static function GetCurrentWorld ():World
      {
         return mCurrentWorld;
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
            case ValueTypeDefine.ValueType_Array:
               return mRegisterVariableSpace_Array;
            default:
               return null;
         }
      }
      
      //public static function InitCustomVariables (globalVarialbeSpaceDefines:Array, entityVarialbeSpaceDefines:Array):void // v1.52 only
      public static function InitCustomVariables (globalVarialbeDefines:Array, entityVarialbeDefines:Array):void
      {
         //>> v1.52 only
         //var numSpaces:int;
         //
         //numSpaces = globalVarialbeSpaceDefines.length;
         //mGlobalVariableSpaces = new Array (numSpaces);
         //
         //for (var spaceId:int = 0; spaceId < numSpaces; ++ spaceId)
         //{
         //   mGlobalVariableSpaces [spaceId] = TriggerFormatHelper2.VariableSpaceDefine2VariableSpace (mCurrentWorld, globalVarialbeSpaceDefines [spaceId] as VariableSpaceDefine);
         //}
         //
         //numSpaces = entityVarialbeSpaceDefines.length;
         //mEntityVariableSpaces = new Array (numSpaces);
         //
         //for (var spaceId:int = 0; spaceId < numSpaces; ++ spaceId)
         //{
         //   mEntityVariableSpaces [spaceId] = TriggerFormatHelper2.VariableSpaceDefine2VariableSpace (mCurrentWorld, entityVarialbeSpaceDefines [spaceId] as VariableSpaceDefine);
         //}
         //<<
         
         mGlobalVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, globalVarialbeDefines);
         mEntityVariableSpace = TriggerFormatHelper2.VariableDefines2VariableSpace (mCurrentWorld, entityVarialbeDefines);
      }
      
      public static function GetGlobalVariableSpace ():VariableSpace
      {
         //>> v1.52 only
         //if (spaceId < 0 || spaceId >= mGlobalVariableSpaces.length)
         //   return null;
         //
         //return mGlobalVariableSpaces [spaceId] as VariableSpace;
         //<<
         
         return mGlobalVariableSpace;
      }
      
      //>> v1.52 only
      //// propertyValues should not be null
      //public static function InitEntityPropertyValues (proeprtySpaces:Array):void
      //{
      //   var numSpaces:int = mEntityVariableSpaces.length;
      //   
      //   proeprtySpaces.length = numSpaces;
      //   for (var spaceId:int = 0; spaceId < numSpaces; ++ spaceId)
      //   {
      //      proeprtySpaces [spaceId] = (mEntityVariableSpaces [spaceId] as VariableSpace).CloneSpace ();
      //   }
      //}
      //<<
      
      public static function CloneEntityPropertyInitialValues ():VariableSpace
      {
         return mEntityVariableSpace.CloneSpace ();
      }
      
      public static function GetDefaultEntityPropertyValue (propertyId:int):Object
      {
         var vi:VariableInstance = mEntityVariableSpace.GetVariableAt (propertyId);
         return vi == null ? null : vi.GetValueObject ();
      }
      
      public static function CreateCustomFunctionDefinitions (functionDefines:Array):void
      {
         var numFunctions:int = functionDefines.length;
         mCustomFunctionDefinitions = new Array (numFunctions);
         
         for (var functionId:int = 0; functionId < numFunctions; ++ functionId)
         {
            mCustomFunctionDefinitions [functionId] = TriggerFormatHelper2.FunctionDefine2FunctionDefinition (functionDefines [functionId] as FunctionDefine, null);
         }
      }
      
      public static function GetCustomFunctionDefinition (functionId:int):FunctionDefinition_Custom
      {
         if (functionId < 0 || functionId >= mCustomFunctionDefinitions.length)
            return null;
         
         return mCustomFunctionDefinitions [functionId] as FunctionDefinition_Custom;
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
// instance
//==============================================================================
      
      public function Global ()
      {
      }
   }
}