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
         var shape:EntityVectorShape =  entity as EntityVectorShape;
         
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
                  EntityVectorShape,
                  EntityJoint,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sMoveableEntityClasses:Array = [
                  EntityVectorShape,
                  EntityUtilityCamera,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sShapeEntityClasses:Array = [
                  EntityVectorShape,
                  EntityUtilityCamera, // appended from v1.55
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sCircleShapeEntityClasses:Array = [
                  EntityVectorShapeCircle,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sRectangleShapeEntityClasses:Array = [
                  EntityVectorShapeRectangle,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sPolyShapeEntityClasses:Array = [
                  EntityVectorShapePolygon,
                  EntityVectorShapePolyline,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sTextEntityClasses:Array = [
                  EntityVectorShapeText,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sCameraEntityClasses:Array = [
                  EntityUtilityCamera,
            ];
      
      // object can be an Entity subclass.prototype or a subclass instance
      public static const sGravityControllerEntityClasses:Array = [
                  EntityVectorShapeGravityController,
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

