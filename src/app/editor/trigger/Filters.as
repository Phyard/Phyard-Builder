package editor.trigger {
   
   import editor.entity.*;
   import editor.trigger.entity.*;
   
   public class Filters
   {
      
      
      
//=====================================================
// filter, used in joint dialog
//=====================================================
      
      public static function IsPhysicsShapeEntity (entity:Entity):Boolean
      {
         var shape:EntityShape =  entity as EntityShape;
         
         return shape != null && shape.IsBasicShapeEntity () && shape.IsPhysicsEnabled ();
      }
      
//=====================================================
// all kind of prototypes list
//=====================================================
      
   // can apply SetTask?
      
      public static const sTaskEntityClasses:Array  = [
                  WorldEntity,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sVisualEntityClasses:Array = [
                  EntityShape,
                  EntityJoint,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sMoveableEntityClasses:Array = [
                  EntityShape,
                  EntityUtilityCamera,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sShapeEntityClasses:Array = [
                  EntityShape,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sCircleShapeEntityClasses:Array = [
                  EntityShapeCircle,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sRectangleShapeEntityClasses:Array = [
                  EntityShapeRectangle,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sPolyShapeEntityClasses:Array = [
                  EntityShapePolygon,
                  EntityShapePolyline,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sTextEntityClasses:Array = [
                  EntityShapeText,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sCameraEntityClasses:Array = [
                  EntityUtilityCamera,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sGravityControllerEntityClasses:Array = [
                  EntityShapeGravityController,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sJointEntityClasses:Array = [
                  EntityJoint,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sLimitsConfigureableJointEntityClasses:Array = [
                  EntityJointHinge,
                  EntityJointSlider,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sMotorConfigureableJointEntityClasses:Array = [
                  EntityJointHinge,
                  EntityJointSlider,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sJointHingeEntityClasses :Array = [
                  EntityJointHinge,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sJointSliderEntityClasses :Array = [
                  EntityJointSlider,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sLogicEntityClasses:Array = [
                  EntityLogic,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sScriptHolderEntityClasses:Array = [
                  EntityAction,
                  EntityBasicCondition,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sBasicConditionEntityClasses:Array = [
                  EntityBasicCondition,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sTimerEventHandlerEntityClasses:Array = [
                  EntityEventHandler_Timer
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sCanBeDisabledEntityClasses:Array = [
                  EntityEventHandler,
                  EntityUtilityPowerSource,
            ];
   }
}

