package editor.trigger {
   
   import common.trigger.CoreClassIds;
   import common.trigger.ValueSourceTypeDefine;
   import common.DataFormat2;
   
   import editor.world.World;
   
   import editor.entity.Scene;
   
   import editor.entity.Entity;
   //import editor.entity.EntityCollisionCategory;
   import editor.ccat.CollisionCategory;
   
   import editor.EditorContext;
   
   public class ValueSource_Direct implements ValueSource
   {
      
   //========================================================================================================
   // 
   //========================================================================================================
      
      public var mValueObject:Object = null;
      
      public function ValueSource_Direct (valueObject:Object)
      {
         SetValueObject (valueObject);
      }
      
      // this is a shortcut to change the value object quickly without creating a new ValueSource_Direct
      public function SetValueObject (valueObject:Object):void
      {
         mValueObject = valueObject;
      }
      
      public function SourceToCodeString (vd:VariableDefinition):String
      {
         if (mValueObject == null)
            return "null";
         
         if (vd is VariableDefinitionString)
         {
            var str:String = mValueObject as String;
            var pattern:RegExp;
            pattern  = /\\/g;
            str = str.replace(pattern, "\\\\");
            pattern = /"/g;
            str = str.replace(pattern, "\\\"");
            
            return "\"" + str + "\"";
         }
         else if (vd is VariableDefinitionNumber)
         {
            var vdn:VariableDefinitionNumber = vd as VariableDefinitionNumber;
            if (vdn.IsColorValue ())
            {
               return DataFormat2.UInt2ColorString (uint (mValueObject));
            }
         }
         
         if (mValueObject.hasOwnProperty ("ToCodeString"))
            return mValueObject.ToCodeString ();
         
         return mValueObject.toString ();
      }
      
//=============================================================
// override
//=============================================================
      
      public function GetValueSourceType ():int
      {
         return ValueSourceTypeDefine.ValueSource_Direct;
      }
      
      public function GetValueObject ():Object
      {
         return mValueObject;
      }
      
      public function CloneSource (scene:Scene, /*triggerEngine:TriggerEngine, */targetFunctionDefinition:FunctionDefinition, callingFunctionDeclaration:FunctionDeclaration, paramIndex:int):ValueSource
      {
         var valueType:int = callingFunctionDeclaration.GetInputParamValueType (paramIndex);
         
         if (targetFunctionDefinition.IsCustom () && (! targetFunctionDefinition.IsDesignDependent ()))
         {
            //if (mValueObject is Entity)
            //{
            //   return new ValueSource_Direct (null);
            //}
            //else if (mValueObject is CollisionCategory)
            //{
            //   return new ValueSource_Direct (null);
            //}
            
            if (valueType != CoreClassIds.ValueType_Number && valueType != CoreClassIds.ValueType_Boolean && valueType != CoreClassIds.ValueType_String && valueType != CoreClassIds.ValueType_Void)
            {
               return new ValueSource_Direct (null);
            }
         }
         
         if (mValueObject is Entity)
         {
            if ((mValueObject as Entity).GetScene () != scene)
            {
               return new ValueSource_Direct (null);
            }
         }
         else if (mValueObject is CollisionCategory)
         {
            if ((mValueObject as CollisionCategory).GetCollisionCategoryManager ().GetScene () != scene)
            {
               return new ValueSource_Direct (null);
            }
         }
         else if (mValueObject is Scene)
         {
            if ((mValueObject as Scene).GetWorld () != scene.GetWorld ())
            {
               return new ValueSource_Direct (null);
            }
         }
         else
         {
          // todo: more type, such as sound, .... But in fact, when the Asset->Define->Asset implementation is applied, no need to do so.
         }
         
         return new ValueSource_Direct (mValueObject);
      }
      
      public function ValidateSource ():void
      {
         if (mValueObject is Entity)
         {
            var entity:Entity = mValueObject as Entity;
            if (entity.GetCreationOrderId () < 0)
               SetValueObject (null)
         }
         else if (mValueObject is CollisionCategory)
         {
            
         }
      }
      
   }
}

