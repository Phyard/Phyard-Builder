package editor.util {
   
   import editor.entity.Entity;
   import editor.entity.EntityShape;
   import editor.entity.EntityJoint;
   
   public class EntityFilter
   {
      
//===================================================
// filters
//===================================================
      
      public static function IsShapeEntity (entity:Entity):Boolean
      {
         if (entity == null)
            return false;
         
         return entity is EntityShape;
      }
      
      public static function IsPhysicsShapeEntity (entity:Entity):Boolean
      {
         if (IsShapeEntity (entity))
         {
            var shape:EntityShape = entity as EntityShape;
            
            return shape.IsPhysicsEnabled () && shape.IsBasicShapeEntity ();
         }
         
         return false;
      }
      
      public static function IsSensorPhysicsShapeEntity (entity:Entity):Boolean
      {
         if (IsPhysicsShapeEntity (entity))
         {
            var shape:EntityShape = entity as EntityShape;
            
            return shape.IsSensor ();
         }
         
         return false;
      }
      
      public static function IsJointEntity (entity:Entity):Boolean
      {
         return entity != null && entity is EntityJoint;
      }
      
   }
}
