package editor.trigger {
   
   import editor.entity.*;
   import editor.trigger.entity.*;
   
   public class Filters
   {
      
      
      
//=====================================================
// used in joint dialog
//=====================================================
      
      public static function IsPhysicsShapeEntity (entity:Entity):Boolean
      {
         var shape:EntityShape =  entity as EntityShape;
         
         return shape != null && shape.IsBasicShapeEntity () && shape.IsPhysicsEnabled ();
      }
      
//=====================================================
// used in api
//=====================================================
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function IsTaskEntity (object:Object):Boolean
      {
         return Boolean (
                  Entity.prototype == object || Entity.prototype.isPrototypeOf (object)
                  );
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function IsVisualEntity (object:Object):Boolean
      {
         return Boolean (
                     EntityShape.prototype == object || EntityShape.prototype.isPrototypeOf (object) 
                  || EntityJoint.prototype == object || EntityJoint.prototype.isPrototypeOf (object)
                  );
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function DoesEntityHasPosition (object:Object):Boolean
      {
         return Boolean (
                EntityShape.prototype == object || EntityShape.prototype.isPrototypeOf (object)
             || EntityUtilityCamera.prototype == object || EntityUtilityCamera.prototype.isPrototypeOf (object)
             ); 
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function CanEntityBeDestroyedManually (object:Object):Boolean
      {
         return Boolean (
                  ! ( EntityLogic.prototype == object || EntityLogic.prototype.isPrototypeOf (object)
                   || SubEntityJointAnchor.prototype == object || SubEntityJointAnchor.prototype.isPrototypeOf (object)
                   )
               ); 
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function IsShapeEntity (object:Object):Boolean
      {
         return Boolean (
                  EntityShape.prototype == object || EntityShape.prototype.isPrototypeOf (object)
               ); 
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function IsTextEntity (object:Object):Boolean
      {
         return Boolean (
                  EntityShapeText.prototype == object || EntityShapeText.prototype.isPrototypeOf (object)
               ); 
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function IsCameraEntity (object:Object):Boolean
      {
         return Boolean (
                  EntityUtilityCamera.prototype == object || EntityUtilityCamera.prototype.isPrototypeOf (object)
               ); 
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function IsGravityControllerEntity (object:Object):Boolean
      {
         return Boolean (
                  EntityShapeGravityController.prototype == object || EntityShapeGravityController.prototype.isPrototypeOf (object)
               ); 
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function IsJointEntity (object:Object):Boolean
      {
         return Boolean (
                  EntityJoint.prototype == object || EntityJoint.prototype.isPrototypeOf (object)
               ); 
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function IsHingeEntity (object:Object):Boolean
      {
         return Boolean (
                  EntityJointHinge.prototype == object || EntityJointHinge.prototype.isPrototypeOf (object)
               ); 
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function IsSliderEntity (object:Object):Boolean
      {
         return Boolean (
                  EntityJointSlider.prototype == object || EntityJointSlider.prototype.isPrototypeOf (object)
               ); 
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function IsScriptHolderEntity (object:Object):Boolean
      {
         return Boolean (
                  EntityAction.prototype == object || EntityAction.prototype.isPrototypeOf (object)
               || EntityBasicCondition.prototype == object || EntityBasicCondition.prototype.isPrototypeOf (object)
               ); 
      }
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static function IsBasicConditionEntity (object:Object):Boolean
      {
         return Boolean (
                  EntityBasicCondition.prototype == object || EntityBasicCondition.prototype.isPrototypeOf (object)
               ); 
      }
      
   }
}

