package editor.trigger {
   
   import editor.entity.*;
   import editor.trigger.entity.*;
   
   public class Filters
   {
      
      
      
//=====================================================
//
//=====================================================
      
      public static function IsTaskEntity (entity:Entity):Boolean
      {
         //return ! (entity is EntityLogic || entity is SubEntityJointAnchor);
         
         // all entities are task
         return true;
      }
      
      public static function IsVisualEntity (entity:Entity):Boolean
      {
         return entity is EntityShape || entity is EntityJoint
      }
      
      public static function DoesEntityHasPosition (entity:Entity):Boolean
      {
         return entity is EntityShape || entity is EntityUtilityCamera
      }
      
      public static function CanEntityBeDestroyedManually (entity:Entity):Boolean
      {
         return ! (entity is EntityLogic || entity is SubEntityJointAnchor);
      }
      
      public static function IsShapeEntity (entity:Entity):Boolean
      {
         return entity is EntityShape;
      }
      
      public static function IsPhysicsShapeEntity (entity:Entity):Boolean
      {
         var shape:EntityShape =  entity as EntityShape;
         
         return shape != null && shape.IsBasicShapeEntity () && shape.IsPhysicsEnabled ();
      }
      
      public static function IsTextEntity (entity:Entity):Boolean
      {
         return entity is EntityShapeText;
      }
      
      public static function IsCameraEntity (entity:Entity):Boolean
      {
         return entity is EntityUtilityCamera;
      }
      
      public static function IsGravityControllerEntity (entity:Entity):Boolean
      {
         return entity is EntityShapeGravityController;
      }
      
      public static function IsJointEntity (entity:Entity):Boolean
      {
         return entity is EntityJoint;
      }
      
      public static function IsHingeEntity (entity:Entity):Boolean
      {
         return entity is EntityJointHinge;
      }
      
      public static function IsSliderEntity (entity:Entity):Boolean
      {
         return entity is EntityJointSlider;
      }
      
   }
}

