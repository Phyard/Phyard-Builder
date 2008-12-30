package player.world {
   
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.events.MouseEvent;
   
   import player.physics.PhysicsEngine;
   import player.physics.PhysicsProxyBody;
   import player.physics.PhysicsProxyShape;
   import player.physics.PhysicsProxyJoint;
   
   import player.entity.Entity;
   import player.entity.EntityVoid;
   import player.entity.ShapeContainer;
   import player.entity.EntityShape;
   import player.entity.EntityShapeCircle;
   import player.entity.EntityShapeRectangle;
   import player.entity.EntityJoint;
   import player.entity.EntityJointHinge;
   import player.entity.EntityJointSlider;
   import player.entity.EntityJointDistance;
   
   import common.Define;
   
   public class World extends Sprite
   {
      public static const WorldWidth:int = Define.WorldWidth; 
      public static const WorldHeight:int = Define.WorldHeight;
      public static const WorldBorderThinkness:int = Define.WorldBorderThinkness;
      
      
   // ...
      public var mPhysicsEngine:PhysicsEngine; // used internally
      
   // ...
      //protected var mEditorEntityArray:Array = new Array ();
      
   // ...
      
      private var mAuthorName:String = "";
      private var mAuthorHonepage:String = "";
      
      public function World ()
      {
         mPhysicsEngine = new PhysicsEngine ();
         mPhysicsEngine.SetJointRemovedListener (OnJointRemoved);
         mPhysicsEngine.SetShapeRemovedListener (OnShapeRemoved);
         mPhysicsEngine.SetShapeCollisionListener (OnShapeCollision);
         
         
      // create borders
         
         CreateBackgroundAndBorders ();
         
      // 
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
      }
      
      public function SetAuthorName (name:String):void
      {
         mAuthorName = name;
      }
      
      public function SetAuthorHomepage (url:String):void
      {
         mAuthorHonepage = url;
      }
      
      public function GetAuthorName ():String
      {
         return mAuthorName;
      }
      
      public function GetAuthorHomepage ():String
      {
         return mAuthorHonepage;
      }
      
      public function Destroy ():void
      {
      }
      
      public function Update (escapedTime:Number, speedX:int):void
      {
         //var dt:Number = escapedTime * 0.5;
         var dt:Number = Define.WorldStepTimeInterval * 0.5;
         
         for (var k:int = 0; k < speedX; ++ k)
            mPhysicsEngine.Update (dt);
         
         
         ClearReport ();
         
         for (var i:uint=0; i < numChildren; ++ i)
         {
            var displayBoject:Object = getChildAt (i);
            if (displayBoject is Entity)
            {
               (displayBoject as Entity).Update (escapedTime);
            }
         }
         
         trace ("mNumToBeInfecteds = " + mNumToBeInfecteds);
         trace ("mNumIntectedToBeInfecteds = " + mNumIntectedToBeInfecteds);
         trace ("mNumDontInfecteds = " + mNumDontInfecteds);
         trace ("mNumInfectedDontInfects = " + mNumInfectedDontInfects);
      }
      
      private var mPuzzleSolved:Boolean = false;
      private var mNumToBeInfecteds:int = 0;
      private var mNumDontInfecteds:int = 0;
      private var mNumIntectedToBeInfecteds:int = 0;
      private var mNumInfectedDontInfects:int = 0;
      
      public function ClearReport ():void
      {
         mPuzzleSolved = true;
         
         mNumToBeInfecteds = 0;
         mNumDontInfecteds = 0;
         mNumIntectedToBeInfecteds = 0;
         mNumInfectedDontInfects = 0;
      }
      
      public function ReportShapeStatus (origionalShapeAiType:int, currentShapeAiType:int):void
      {
         if (origionalShapeAiType == Define.ShapeAiType_Uninfected)
         {
            mNumToBeInfecteds ++ ;
            
            if (currentShapeAiType == Define.ShapeAiType_Infected)
            {
               mNumIntectedToBeInfecteds ++;
            }
         }
         
         if (origionalShapeAiType == Define.ShapeAiType_DontInfect)
         {
            mNumDontInfecteds ++;
            
            if (currentShapeAiType == Define.ShapeAiType_Infected)
            {
               mNumInfectedDontInfects ++;
            }
         }
         
         mPuzzleSolved = mNumToBeInfecteds != 0 && (mNumIntectedToBeInfecteds == mNumToBeInfecteds) && (mNumInfectedDontInfects == 0);
      }
      
      public function IsPuzzleSolved ():Boolean
      {
         return mPuzzleSolved;
      }
      
      private function CreateBackgroundAndBorders ():void
      {
         var bgSprite:Sprite = new Sprite ();
         bgSprite.graphics.clear ();
         bgSprite.graphics.beginFill(0xDDDDA0);
         bgSprite.graphics.drawRect (0, 0, WorldWidth, WorldHeight);
         bgSprite.graphics.endFill ();
         addChild (bgSprite);
         
         
         var borderContainerParams:Object = new Object ();
         borderContainerParams.mPosX = WorldWidth * 0.5;
         borderContainerParams.mPosY = WorldHeight * 0.5;
         
         var borderContainer:ShapeContainer = CreateShapeContainer (borderContainerParams, true);
         CreateBorder (borderContainer, WorldWidth * 0.5, WorldBorderThinkness * 0.5 - 0.5, WorldWidth, WorldBorderThinkness);
         CreateBorder (borderContainer, WorldWidth * 0.5, WorldHeight - WorldBorderThinkness * 0.5, WorldWidth, WorldBorderThinkness);
         CreateBorder (borderContainer, WorldBorderThinkness * 0.5 - 0.5, WorldHeight * 0.5, WorldBorderThinkness, WorldWidth);
         CreateBorder (borderContainer, WorldWidth - WorldBorderThinkness * 0.5, WorldHeight * 0.5, WorldBorderThinkness, WorldWidth);
      }
      
      private function CreateBorder (borderContainer:ShapeContainer, posX:Number, posY:Number, rectW:Number, rectH:Number):void
      {
         var shapeParams:Object = new Object ();
         shapeParams.mHalfWidth = rectW * 0.5;
         shapeParams.mHalfHeight = rectH * 0.5;
         shapeParams.mPosX = posX;
         shapeParams.mPosY = posY;
         shapeParams.mRotation = 0;
         shapeParams.mAiType = Define.ShapeAiType_Static;
         shapeParams.mIsStatic = true;
         shapeParams.mIsVisible = true;
         shapeParams.mIsBullet = true;
         shapeParams.mDensity = 0;
         shapeParams.mFriction = 0.1;
         shapeParams.mRestitution = 0.2;
         
         CreateEntityShapeRectangle (borderContainer, shapeParams);
      }
      
//=============================================================
//   editor entities
//=============================================================
      
      //public function RegisterEditorEntity (index:int, entity:Entity):void
      //{
      //   mEditorEntityArray [index] = entity;
      //}
      
//=============================================================
//   shape container
//=============================================================
      
      
      public function CreateShapeContainer (params:Object, containsPhyShapes:Boolean):ShapeContainer
      {
         var shapeContainer:ShapeContainer = new ShapeContainer (this);
         if (containsPhyShapes)
            shapeContainer.BuildPhysicsProxy (params);
         
         addChild (shapeContainer);
            
         return shapeContainer;
      }
      
      public function UpdateShapeMasses ():void
      {
         for (var i:uint=0; i < numChildren; ++ i)
         {
            var displayBoject:Object = getChildAt (i);
            if (displayBoject is ShapeContainer)
            {
               (displayBoject as ShapeContainer).UpdateMass ();
            }
         }
      }
      
//=============================================================
//   shapes & joints
//=============================================================
      
      private var mWorldEntities:Array = new Array ();
      
      public function CreateVoidEntity ():EntityVoid
      {
         var voidEntity:EntityVoid = new EntityVoid (this);
         
         //mEditorEntityArray.push (voidEntity);
         
         return voidEntity;
      }
      
      
      public function CreateEntityShapeCircle (shapeContainer:ShapeContainer, params:Object):EntityShapeCircle
      {
         var shapeCircle:EntityShapeCircle = new EntityShapeCircle (this, shapeContainer);
         shapeCircle.BuildPhysicsProxy (params);
         
         return shapeCircle;
      }
      
      public function CreateEntityShapeRectangle (shapeContainer:ShapeContainer, params:Object):EntityShapeRectangle
      {
         var shapeRect:EntityShapeRectangle = new EntityShapeRectangle (this, shapeContainer);
         shapeRect.BuildPhysicsProxy (params);
         
         return shapeRect;
      }
      
      public function CreateEntityJointHinge (params:Object):EntityJointHinge
      {
         var jointHinge:EntityJointHinge = new EntityJointHinge (this);
         jointHinge.BuildPhysicsProxy (params);
         
         addChild (jointHinge);
         
         return jointHinge;
      }
      
      public function CreateEntityJointSlider (params:Object):EntityJointSlider
      {
         var jointSlider:EntityJointSlider = new EntityJointSlider (this);
         jointSlider.BuildPhysicsProxy (params);
         
         addChild (jointSlider);
         
         return jointSlider;
      }
      
      public function CreateEntityJointDistance (params:Object):EntityJointDistance
      {
         var jointDistance:EntityJointDistance = new EntityJointDistance (this);
         jointDistance.BuildPhysicsProxy (params);
         
         addChild (jointDistance);
         
         return jointDistance;
      }
      
      
      
//=============================================================
//   PhysicsEngine callbacks 
//=============================================================
      
      private function OnJointRemoved (proxyJoint:PhysicsProxyJoint):void
      {
         var joint:EntityJoint = proxyJoint.GetUserData () as EntityJoint;
         
         removeChild (joint);
         
         // !!! b2Joint has already been destroyed before entering this function
         //joint.Destroy ();
      }
      
      private function OnShapeRemoved (proxyShape:PhysicsProxyShape):void
      {
      }
      
      private function OnShapeCollision (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
      {
         var shape1:EntityShape = proxyShape1.GetUserData () as EntityShape;
         var shape2:EntityShape = proxyShape2.GetUserData () as EntityShape;
         
         var infectable1:Boolean = Define.IsInfectableShape (shape1.GetShapeAiType ());
         var infectable2:Boolean = Define.IsInfectableShape (shape2.GetShapeAiType ());
         
         var infected1:Boolean = Define.IsInfectedShape (shape1.GetShapeAiType ());
         var infected2:Boolean = Define.IsInfectedShape (shape2.GetShapeAiType ());
         
         if (infected1 && ! infected2 && infectable2)
         {
            shape2.SetShapeAiType (Define.ShapeAiType_Infected);
            shape2.RebuildAppearance ();
         }
         
         if (infected2 && ! infected1 && infectable1)
         {
            shape1.SetShapeAiType (Define.ShapeAiType_Infected);
            shape1.RebuildAppearance ();
         }
      }
      
      protected function OnMouseUp (event:MouseEvent):void
      {
         var levelPoint:Point = globalToLocal (new Point (event.stageX, event.stageY));
         
         var shapeArray:Array = mPhysicsEngine.GetProxyShapesAtPoint (levelPoint.x, levelPoint.y);
         
         var shapeId:int;
         var shape:EntityShape;
         
         var body:ShapeContainer;
         var breakableBodies:Array = new Array ();
         
         for (shapeId = 0; shapeId < shapeArray.length; ++ shapeId)
         {
            shape = (shapeArray [shapeId] as PhysicsProxyShape).GetUserData () as EntityShape;
            
            if ( Define.IsBreakableShape (shape.GetShapeAiType ()) )
            {
               body = shape.GetParentContainer ();
               if ( breakableBodies.indexOf (body) < 0 )
                  breakableBodies.push (body);
            }
         }
         
         while (breakableBodies.length > 0)
         {
            removeChild (breakableBodies[0]);
            (breakableBodies[0] as ShapeContainer).Destroy ();
            breakableBodies.splice (0, 1);
         }
      }
      
      
      
   }
}
