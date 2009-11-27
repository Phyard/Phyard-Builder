package editor.trigger {
   
   import editor.entity.*;
   import editor.trigger.entity.*;
   
   public class Filters
   {
      
      
      
//=====================================================
//
//=====================================================
      
      public static function IsPhysicsShapeEntity (entity:Entity):Boolean
      {
         var shape:EntityShape =  entity as EntityShape;
         
         return shape != null && shape.IsBasicShapeEntity () && shape.IsPhysicsEnabled ();
      }
      
      public static function IsCameraEntity (entity:Entity):Boolean
      {
         return entity is EntityUtilityCamera;
      }
      
      public static function IsGravityControllerEntity (entity:Entity):Boolean
      {
         return entity is EntityShapeGravityController;
      }
      
   }
}

