package player.entity {
   
   import flash.display.Shape;
   import flash.geom.Point;
   
   import player.world.World;
   
   import player.physics.PhysicsProxy;
   import player.physics.PhysicsProxyJoint;
   
   import player.trigger.entity.EntityEventHandler;
   import player.trigger.data.ListElement_EventHandler;
   import player.trigger.Parameter_Direct;
   
   import common.trigger.CoreEventIds;
   
   import common.Define;
   
   public class EntityJoint extends Entity
   {
      include "EntityJoint_APIs.as";
      
//=============================================================
//   create
//=============================================================
      
      // the two anchors
      protected var mAnchor1:SubEntityJointAnchor = null; // will attach to mShape1
      protected var mAnchor2:SubEntityJointAnchor = null; // will attach to mShape2
            
      public function EntityJoint (world:World)
      {
         super (world);
      }

      public function GetAnchor1 ():SubEntityJointAnchor
      {
         return mAnchor1;
      }
      
      public function GetAnchor2 ():SubEntityJointAnchor
      {
         return mAnchor2;
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object, extraInfos:Object):void
      {
         super.Create (createStageId, entityDefine, extraInfos);
         
         if (createStageId == 0)
         {
            // ...
            if (entityDefine.mCollideConnected != undefined)
               SetCollideConnected (entityDefine.mCollideConnected);
            
            //>>from v1.08
            if (entityDefine.mBreakable != undefined)
               SetBreakable (entityDefine.mBreakable);
            //<<
         
            //>>from v1.59, just a runtime info
            _JointIsFlipped = entityDefine._JointIsFlipped;
            //<<
         }
         else if (createStageId == 2)
         {
            // for joints with 1 anchor in editor (hinge)
            if (entityDefine.mAnchorEntityIndex != undefined)
            {
               var anchorIndex:int = entityDefine.mAnchorEntityIndex;
               if (anchorIndex >= 0)
                  anchorIndex = extraInfos.mEntityIdCorrectionTable [anchorIndex];
               mAnchor1 = mWorld.GetEntityByCreateOrderId (anchorIndex, true) as SubEntityJointAnchor; // may be a runtime-created entity
               
               mAnchor2 = new SubEntityJointAnchor (mWorld); // this one doesn't exit in editor
               mAnchor2.SetPositionX (mAnchor1.GetPositionX ());
               mAnchor2.SetPositionY (mAnchor1.GetPositionY ());
               mAnchor2.SetVisible (mAnchor1.IsVisible ());
               mAnchor2.SetAlpha (mAnchor1.GetAlpha ());
               
               mWorld.RegisterEntity (mAnchor2);
               
               mAnchor2.AdjustAppearanceOrder (mAnchor1, true);
               
               mAnchor2.InitCustomPropertyValues (); // fixed in v1.57
            }
            
            // for joint with 2 anchors in editor (slider, distance, spring, )
            if (entityDefine.mAnchor1EntityIndex != undefined)
            {
               var anchor1Index:int = entityDefine.mAnchor1EntityIndex;
               if (anchor1Index >= 0)
                  anchor1Index = extraInfos.mEntityIdCorrectionTable [anchor1Index];
               mAnchor1 = mWorld.GetEntityByCreateOrderId (anchor1Index, true) as SubEntityJointAnchor; // may be a runtime-created entity
            }

            if (entityDefine.mAnchor2EntityIndex != undefined)
            {
               var anchor2Index:int = entityDefine.mAnchor2EntityIndex;
               if (anchor2Index >= 0)
                  anchor2Index = extraInfos.mEntityIdCorrectionTable [anchor2Index];
               mAnchor2 = mWorld.GetEntityByCreateOrderId (anchor2Index, true) as SubEntityJointAnchor; // may be a runtime-created entity
            }

            // both anchors should not be null now
            mAnchor1.SetMainEntity (this);
            mAnchor2.SetMainEntity (this);
            mAnchor1.mJoint = this;
            mAnchor2.mJoint = this;
            mAnchor1.mAnotherJointAnchor = mAnchor2;
            mAnchor2.mAnotherJointAnchor = mAnchor1;

            // here, mAnchor1.mAnchorIndex and mAnchor1.mAnchorIndex are used to
            // store mConnectedShape1Index and mConnectedShape2Index temperarily.
            // they will be corrected in ConfirmConnectedShapes.
            
            if (entityDefine.mConnectedShape1Index != undefined)
            {
               var shape1Index:int = entityDefine.mConnectedShape1Index;
               if (shape1Index >= 0)
                  shape1Index = extraInfos.mEntityIdCorrectionTable [shape1Index];
               mAnchor1.mAnchorIndex = shape1Index;
            }
            else
            {
               mAnchor1.mAnchorIndex = Define.EntityId_None; // auto
            } 
               
            if (entityDefine.mConnectedShape2Index != undefined)
            {
               var shape2Index:int = entityDefine.mConnectedShape2Index;
               if (shape2Index >= 0)
                  shape2Index = extraInfos.mEntityIdCorrectionTable [shape2Index];
               mAnchor2.mAnchorIndex = shape2Index;
            }
            else
            {
               mAnchor2.mAnchorIndex = Define.EntityId_None; // auto
            }
         }
      }
      
      override public function ToEntityDefine (entityDefine:Object):Object
      {
         super.ToEntityDefine (entityDefine);
         
         entityDefine.mCollideConnected = IsCollideConnected ();
         //>>from v1.08
         entityDefine.mBreakable = IsBreakable ();
         //<<
         entityDefine.mConnectedShape1 = mAnchor1.GetShape ();
         entityDefine.mConnectedShape2 = mAnchor2.GetShape ();
         
         //>>from v1.59, just a runtime info
         entityDefine._JointIsFlipped = _JointIsFlipped;
         //<<
         
         return null;
      }
      
      public function CopyRuntimeInfosFrom (fromJoint:EntityJoint):void
      {
         if (fromJoint == null)
            return;
         
         var fromPhysicsProxy:PhysicsProxy = fromJoint.GetPhysicsProxy ();
         
         if (mPhysicsProxy != null && fromPhysicsProxy != null)
         {
            (mPhysicsProxy as PhysicsProxyJoint).CopyRuntimeInfosFrom (fromPhysicsProxy as PhysicsProxyJoint);
         }
      }
      
      // useful for hinge joints
      protected var _JointIsFlipped:Boolean = false;
      
      public function OnFlipped (pointX:Number, pointY:Number, normalXX2:Number, normalYY2:Number, normalXY2:Number):void
      {
         if (mPhysicsProxy != null)
         {
            (mPhysicsProxy as PhysicsProxyJoint).OnFlipped (pointX, pointY, normalXX2, normalYY2, normalXY2);
            
            _JointIsFlipped = ! _JointIsFlipped;
         }
      }
      
      public function OnScaled (scaleRatio:Number):void
      {
         if (mPhysicsProxy != null)
         {
            (mPhysicsProxy as PhysicsProxyJoint).OnScaled (scaleRatio);
         }
      }

//=============================================================
//   joint events
//=============================================================
      
      private var mReachLowerLimitEventHandlerList:ListElement_EventHandler = null;
      private var mReachUpperLimitEventHandlerList:ListElement_EventHandler = null;
      
      override public function RegisterEventHandler (eventId:int, eventHandler:EntityEventHandler):void
      {
         super.RegisterEventHandler (eventId, eventHandler);
         
         switch (eventId)
         {
            case CoreEventIds.ID_OnJointReachLowerLimit:
               mReachLowerLimitEventHandlerList = RegisterEventHandlerToList (mReachLowerLimitEventHandlerList, eventHandler);
               break;
            case CoreEventIds.ID_OnJointReachUpperLimit:
               mReachUpperLimitEventHandlerList = RegisterEventHandlerToList (mReachUpperLimitEventHandlerList, eventHandler);
               break;
            default:
               break;
         }
      }

      final public function OnJointReachLowerLimit ():void
      {
         var  list_element:ListElement_EventHandler = mReachLowerLimitEventHandlerList;
         
         //mEventHandlerValueSource0.mValueObject = this;
         var valueSource0:Parameter_Direct = new Parameter_Direct (this, null);
         
         mWorld.IncStepStage ();
         while (list_element != null)
         {
            //list_element.mEventHandler.HandleEvent (mEventHandlerValueSourceList);
            list_element.mEventHandler.HandleEvent (valueSource0);
            
            list_element = list_element.mNextListElement;
         }
      }

      final public function OnJointReachUpperLimit ():void
      {
         var  list_element:ListElement_EventHandler = mReachUpperLimitEventHandlerList;
         
         //mEventHandlerValueSource0.mValueObject = this;
         var valueSource0:Parameter_Direct = new Parameter_Direct (this, null);
         
         mWorld.IncStepStage ();
         while (list_element != null)
         {
            //list_element.mEventHandler.HandleEvent (mEventHandlerValueSourceList);
            list_element.mEventHandler.HandleEvent (valueSource0);
            
            list_element = list_element.mNextListElement;
         }
      }

//=============================================================
//   
//=============================================================
      
      protected var mCollideConnected:Boolean = false;

      public function SetCollideConnected (collide:Boolean):void
      {
         mCollideConnected = collide;
      }

      public function IsCollideConnected ():Boolean
      {
         return mCollideConnected;
      }
      
      protected var mBreakable:Boolean = false;
      
      public function SetBreakable (breakable:Boolean):void
      {
         mBreakable = breakable;
      }
      
      public function IsBreakable ():Boolean
      {
         return mBreakable;
      }
      
//=============================================================
//   destroy
//=============================================================
      
      override protected function DestroyInternal ():void
      {
         mAnchor1.Destroy ();
         mAnchor2.Destroy ();
      }
      
//=============================================================
//   
//=============================================================
      
      override public function SynchronizeWithPhysicsProxy ():void
      {
         if (mAlreadyDestroyed)
            return;
          
         SynchronizeAnchorWithPhysicsProxy (0);
         SynchronizeAnchorWithPhysicsProxy (1)  
         DelayUpdateAppearance ();
      }
      
      public function SynchronizeAnchorWithPhysicsProxy (anchorId:int):void
      {
         if (mPhysicsProxy == null)
            return;
         
         var proxyJoint:PhysicsProxyJoint = mPhysicsProxy as PhysicsProxyJoint;
            
         if (anchorId == 0)
         {
            var anchorPoint1:Point = proxyJoint.GetAnchorPoint1 ();
            
            //mAnchor1.mPositionX = anchorPoint1.x;
            //mAnchor1.mPositionY = anchorPoint1.y;
            mAnchor1.SetPositionX (anchorPoint1.x);
            mAnchor1.SetPositionY (anchorPoint1.y);
            mAnchor1.UpdateDisplayObjectPosition ();
         }
         else if (anchorId == 1)
         {
            var anchorPoint2:Point = proxyJoint.GetAnchorPoint2 ();
            
            //mAnchor2.mPositionX = anchorPoint2.x;
            //mAnchor2.mPositionY = anchorPoint2.y;
            mAnchor2.SetPositionX (anchorPoint2.x);
            mAnchor2.SetPositionY (anchorPoint2.y);
            mAnchor2.UpdateDisplayObjectPosition ();
         }
      } 
      
//=============================================================
//   physics proxy
//=============================================================

      internal function GetPhysicsProxyJoint ():PhysicsProxyJoint
      {
         return null; // to override
      }
      
      final public function ConfirmConnectedShapes ():void
      {
         if (mAlreadyDestroyed)
            return;
         
         ConfirmConnectedShapesInternal ();
      }
      
      protected function ConfirmConnectedShapesInternal ():void
      {
         // to override
      }
      
      final public function RebuildJointPhysics ():void
      {
         if (mAlreadyDestroyed)
            return;
         
         if (mPhysicsProxy != null)
            return;
         
         mAnchor1.UpdateTransformFromLocalTransform ();
         mAnchor2.UpdateTransformFromLocalTransform ();
         
         RebuildJointPhysicsInternal ();
      }
      
      protected function RebuildJointPhysicsInternal ():void
      {
         // to override
      }
      
      internal function SaveJointStatus ():void
      {
         
      }
      
//=============================================================
//   select connected shapes
//=============================================================
 
      // maybe it is a good idea to write a new hinge joint, which is like other joints, the 2 anchors can be different.
      protected function ConfirmConnectedShapes_OneAnchor (anchorWorldPhysicsX:Number, anchorWorldPhysicsY:Number):void
      {
         // ...
         var shapeIndex1:int = mAnchor1.mAnchorIndex;
         var shapeIndex2:int = mAnchor2.mAnchorIndex;
         mAnchor1.mAnchorIndex = 0;
         mAnchor2.mAnchorIndex = 1;

         var shape1:EntityShape = null;
         var shape2:EntityShape = null;
         
         if (shapeIndex1 != Define.EntityId_None)
            shape1 = mWorld.GetEntityByCreateOrderId (shapeIndex1, true) as EntityShape; // may be a runtime-created entity
         if (shapeIndex2 != Define.EntityId_None)
            shape2 = mWorld.GetEntityByCreateOrderId (shapeIndex2, true) as EntityShape; // may be a runtime-created entity

         if (shapeIndex1 == Define.EntityId_None || shapeIndex2 == Define.EntityId_None)
         {
            var shapes:Array = null;
            var bodies:Array = null;
            var body1:EntityBody = null;
            var body2:EntityBody = null;
            
            shapes = mWorld.GetPhysicsEngine ().GetShapesAtPoint (anchorWorldPhysicsX, anchorWorldPhysicsY);
            shapes.sort (CompareShape);

            bodies = GetBodyListFromShapeList (shapes);

            var bothAuto:Boolean = false;
            
            if (shapeIndex1 == Define.EntityId_None && shapeIndex2 == Define.EntityId_None) // both auto
            {
               if (bodies.length == 0)
               {
                  shapeIndex1 = Define.EntityId_Ground;
                  shapeIndex2 = Define.EntityId_Ground;
               }
               else
               {
                  bothAuto = true;

                  body2 = bodies [0];
                  if (body2.IsStatic ())
                     body1 = GetFirstDynamicBody (bodies, body2);

                  if (body1 == null)
                  {
                     if (bodies.length > 1)
                        body1 = bodies [1];
                     else
                     {
                        shapeIndex1 = Define.EntityId_Ground;
                        
                        bothAuto = false;
                     }
                  }
               }
            }
            else if (shapeIndex1 == Define.EntityId_None) // mShape2 !== undefined
            {
               if (bodies.length == 0)
               {
                  shapeIndex1 = Define.EntityId_Ground;
               }
               else
               {
                  if (shape2 != null)
                     body2 = shape2.GetBody ();

                  if (body2 == null || body2.IsStatic ())
                     body1 = GetFirstDynamicBody (bodies, body2);

                  if (body1 == null)
                  {
                     body1 = bodies [0];
                     if (body1 == body2)
                     {
                        if (bodies.length > 1)
                           body1 = bodies [1];
                        else
                           shapeIndex1 = Define.EntityId_Ground;
                     }
                  }
               }
            }
            else if (shapeIndex2 == Define.EntityId_None) // mShape1 !== undefined
            {
               if (bodies.length == 0)
               {
                  shapeIndex2 = Define.EntityId_Ground;
               }
               else
               {
                  if (shape1 != null)
                     body1 = shape1.GetBody ();

                  if (body1 == null || body1.IsStatic ())
                     body2 = GetFirstDynamicBody (bodies, body1);

                  if (body2 == null)
                  {
                     body2 = bodies [0];
                     if (body2 == body1)
                     {
                        if (bodies.length > 1)
                           body2 = bodies [1];
                        else
                           shapeIndex2 = Define.EntityId_Ground;
                     }
                  }
               }
            }

            if (shapeIndex1 == Define.EntityId_None) // body1 must not be null
               shape1 = GetFirstShapeByBody (shapes, body1);
            
            if (shapeIndex2 == Define.EntityId_None) // body2 must not be null
               shape2 = GetFirstShapeByBody (shapes, body2);

            // make shape1.appearanceId < shape2.appearanceId if bothAuto
            if (bothAuto) // neither mShape1 or mShape2 is null
            {
               if (shape1.GetAppearanceId () > shape2.GetAppearanceId ())
               {
                  var tempShape:EntityShape = shape1;
                  shape1 = shape2;
                  shape2 = tempShape;
               }
            }
         }

         // attach to shape
         mAnchor1.SetShape (shape1);
         mAnchor2.SetShape (shape2);
      }
      
      // for joints except hinges
      protected function ConfirmConnectedShapes_TwoAnchors (anchorWorldPhysicsX1:Number, anchorWorldPhysicsY1:Number, anchorWorldPhysicsX2:Number, anchorWorldPhysicsY2:Number):void
      {
         // ...
         var shapeIndex1:int = mAnchor1.mAnchorIndex;
         var shapeIndex2:int = mAnchor2.mAnchorIndex;
         mAnchor1.mAnchorIndex = 0;
         mAnchor2.mAnchorIndex = 1;

         var shape1:EntityShape = null;
         var shape2:EntityShape = null;
         
         if (shapeIndex1 != Define.EntityId_None)
            shape1 = mWorld.GetEntityByCreateOrderId (shapeIndex1, true) as EntityShape; // may be a runtime-created entity
         if (shapeIndex2 != Define.EntityId_None)
            shape2 = mWorld.GetEntityByCreateOrderId (shapeIndex2, true) as EntityShape; // may be a runtime-created entity
         
         if (shapeIndex1 == Define.EntityId_None || shapeIndex2 == Define.EntityId_None)
         {
            var shapes1:Array = null;
            var shapes2:Array = null;
            var bodies1:Array = null;
            var bodies2:Array = null;
            var body1:EntityBody = null;
            var body2:EntityBody = null;
            
            if (shapeIndex1 == Define.EntityId_None) // auto
            {
               shapes1 = mWorld.GetPhysicsEngine ().GetShapesAtPoint (anchorWorldPhysicsX1, anchorWorldPhysicsY1);
               
               if (shapes1.length > 1)
                  shapes1.sort (CompareShape);

               bodies1 = GetBodyListFromShapeList (shapes1);
               if (bodies1.length == 0)
                  shapeIndex1 = Define.EntityId_Ground;
            }
            
            if (shapeIndex2 == Define.EntityId_None) // auto
            {
               shapes2 = mWorld.GetPhysicsEngine ().GetShapesAtPoint (anchorWorldPhysicsX2, anchorWorldPhysicsY2);
               
               if (shapes2.length > 1)
                  shapes2.sort (CompareShape);

               bodies2 = GetBodyListFromShapeList (shapes2);
               if (bodies2.length == 0)
                  shapeIndex2 = Define.EntityId_Ground;
            }
            
            if (shapeIndex1 == Define.EntityId_None && shapeIndex2 == Define.EntityId_None) // bodies1 and bodies2 must contain more than one elements.
            {
               body1 = bodies1 [0];
               if (body1.IsStatic ())
               {
                  body2 = GetFirstDynamicBody (bodies2, body1);
                  if (body2 == null)
                  {
                     body1 = GetFirstDynamicBody (bodies1, body2);
                     if (body1 == null)
                        body1 = bodies1 [0];
                  }
               }
               
               if (body2 == null)
                  body2 = bodies2 [0];

               if (body1 == body2)
               {
                  if (bodies2.length > 1)
                     body2 = bodies2 [1];
                  else if (bodies1.length > 1)
                     body1 = bodies2 [1];
                  else
                     shapeIndex1 = Define.EntityId_Ground;
               }
            }
            else if (shapeIndex1 == Define.EntityId_None) // bodies1 must contain more than one elements.
            {
               if (shape2 != null)
                  body2 = shape2.GetBody ();

               if (body2 == null || body2.IsStatic ())
                  body1 = GetFirstDynamicBody (bodies1, body2); // try to avoid 2 static shapes
               
               if (body1 == null)
               {
                  body1 = bodies1 [0];

                  if (body1 == body2)
                  {
                     if (bodies1.length > 1)
                        body1 = bodies1 [1];
                     else
                        shapeIndex1 = Define.EntityId_Ground;
                  }
               }
            }
            else if (shapeIndex2 == Define.EntityId_None) // bodies2 must contain more than one elements.
            {
               if (shape1 != null)
                  body1 = shape1.GetBody ();

               if (body1 == null || body1.IsStatic ())
                  body2 = GetFirstDynamicBody (bodies2, body1); // try to avoid 2 static shapes

               if (body2 == null)
               {
                  body2 = bodies2 [0];

                  if (body2 == body1)
                  {
                     if (bodies2.length > 1)
                        body2 = bodies2 [1];
                     else
                        shapeIndex2 = Define.EntityId_Ground;
                  }
               }
            }

            if (shapeIndex1 == Define.EntityId_None) // body1 must not be null
               shape1 = GetFirstShapeByBody (shapes1, body1);
            
            if (shapeIndex2 == Define.EntityId_None) // body2 must not be null
               shape2 = GetFirstShapeByBody (shapes2, body2);
         }
         
         // attach to shape
         mAnchor1.SetShape (shape1);
         mAnchor2.SetShape (shape2);
      }
      
      private static function CompareShape (shape1:EntityShape, shape2:EntityShape):Number 
      {
         return shape1.GetCreationId () > shape2.GetCreationId () ? -1 : 1;
      }

      private static function GetBodyListFromShapeList (shapes:Array):Array
      {
         var bodies:Array = new Array ();
         var body:EntityBody;

         // all shapes must be physics shape, which means the body must be not null.
         for (var i:int = 0; i < shapes.length; ++ i)
         {
            body = (shapes [i] as EntityShape).GetBody ();
            
            if (bodies.indexOf (body) < 0)
               bodies.push (body);
         }

         return bodies;
      }

      private static function GetFirstDynamicBody (bodies:Array, exceptBody:EntityBody):EntityBody
      {
         var body:EntityBody;
         
         // all shapes must be physics shape, which means the body must be not null.
         for (var i:int = 0; i < bodies.length; ++ i)
         {
            body = bodies [i] as EntityBody;
            
            if ( (body != exceptBody) && (! body.IsStatic ()) )
               return body;
         }

         return null;
      }

      private static function GetFirstShapeByBody (shapes:Array, theBody:EntityBody):EntityShape
      {
         var shape:EntityShape;
         var body:EntityBody;
         
         // all shapes must be physics shape, which means the body must be not null.
         for (var i:int = 0; i < shapes.length; ++ i)
         {
            shape = shapes [i] as EntityShape;
            body = shape.GetBody ();
            
            if (body == theBody)
               return shape;
         }

         return null;
      }
   }
}
