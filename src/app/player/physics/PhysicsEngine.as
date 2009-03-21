
package player.physics {
   
   import flash.geom.Point;
   
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.b2Body;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Collision.b2AABB;
   import Box2D.Dynamics.b2ContactFilter;
   
   import Box2D.Dynamics.b2ContactFilter;
   import Box2D.Dynamics.b2ContactListener;
   import Box2D.Dynamics.b2DestructionListener;
   
   import Box2D.b2WorldPool;
   
   public class PhysicsEngine
   {
      /*
      private static var s_b2World:b2World;
      private static var s_b2ContactListener_old:b2ContactListener;
      private static var s_b2DestructionListener_old:b2DestructionListener;
      private static var s_b2ContactFilter_old:b2ContactFilter;
      
      private static function CreateB2World (worldAABB:b2AABB, gravity:b2Vec2, doSleep:Boolean):b2World
      {
         if (s_b2World == null)
         {
            s_b2World = new b2World(worldAABB, gravity, doSleep);
            
            s_b2ContactListener_old = s_b2World.m_contactListener;
            s_b2DestructionListener_old = s_b2World.m_destructionListener;
            s_b2ContactFilter_old = s_b2World.m_contactFilter;
         }
         else
         {
            DestroyB2World ();
            
            s_b2World.Reset (worldAABB, gravity, doSleep);
         }
         
         return s_b2World;
      }
      
      private static function DestroyB2World ():void
      {
         if (s_b2World != null)
         {
            s_b2World.Destroy ();
            
            // here is bug prone.when 2 PhysicsEngines are created crossingly (½»²æµØ).
            
            s_b2World.SetContactListener (s_b2ContactListener_old);
            s_b2World.SetDestructionListener (s_b2DestructionListener_old);
            s_b2World.SetContactFilter (s_b2ContactFilter_old);
         }
      }
      */
      
//=================================================================
//   
//=================================================================
      
      public var _b2World:b2World; // used within package
      
      
      private var _OnJointRemoved:Function = null; // (proxyJoint:PhysicsProxyJoint):void
      private var _OnShapeRemoved:Function = null; //  (proxyShape:PhysicsProxyShape):void
      private var _OnShapeCollision:Function = null; //  (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
      
      private var _GetBodyIndex:Function = null; // (proxyBody:PhysicsProxyBody):int
      private var _GetShapeIndex:Function = null; // (proxyBody:PhysicsProxyShape):int
      
      private var mDefaultCollisionCategories:Object = null;
      private var mCollisionCategories:Array = new Array ();
      private var mContactFilter:_ContactFilter = null;
      
      public function PhysicsEngine (initialGravity:Point, lowerDisplayPoint:Point, upperDisplayPoint:Point, numCollisionCategories:uint, version100:Boolean):void
      {
         if (! version100)
         {
            _DisplayPoint2PhysicsPoint (lowerDisplayPoint);
            _DisplayPoint2PhysicsPoint (upperDisplayPoint);
         }
         
         var worldAABB:b2AABB = new b2AABB();
         worldAABB.lowerBound.Set(lowerDisplayPoint.x, lowerDisplayPoint.y);
         worldAABB.upperBound.Set(upperDisplayPoint.x, upperDisplayPoint.y);
         
         var gravity:b2Vec2 = new b2Vec2 (initialGravity.x * GlobalGravityScale, initialGravity.y * GlobalGravityScale);
         var doSleep:Boolean = true;
         
         //_b2World = new b2World(worldAABB, gravity, doSleep);
         //_b2World = CreateB2World (worldAABB, gravity, doSleep);
         _b2World = b2WorldPool.AllocB2World (worldAABB, gravity, doSleep);
         
         _b2World.SetContactListener(new _ContactListener (this));
         _b2World.SetDestructionListener(new _DestructionListener (this));
         
         RebuildContactFilter (numCollisionCategories);
      }
      
      public function Destroy ():void
      {
         //DestroyB2World ();
         b2WorldPool.ReleaseB2World (_b2World);
         
         _b2World = null;
      }
      
//=================================================================
//   
//=================================================================
      
      public function RebuildContactFilter (numCollisitionCategories:uint):void
      {
         if (numCollisitionCategories > 16)
         {
            mContactFilter = new _ContactFilter (this, numCollisitionCategories);
            _b2World.SetContactFilter (mContactFilter);
         }
         else
         {
            mContactFilter = null;
            _b2World.SetContactFilter (b2ContactFilter.b2_defaultFilter);
         }
         
         CreateDefaultCollisionCategory ();
      }
      
      public function CreateDefaultCollisionCategory ():void
      {
         if (mDefaultCollisionCategories == null)
         {
            mDefaultCollisionCategories = new Object ();
            
            mDefaultCollisionCategories.mGroupIndex = 0;
            
            if (mContactFilter == null)
            {
               mDefaultCollisionCategories.mMaskBits = 0xFFFF;
               mDefaultCollisionCategories.mCategoryBits = 0x1;
            }
            else
            {
               mDefaultCollisionCategories.mMaskBits = 0;
               mDefaultCollisionCategories.mCategoryBits = 0;
            }
         }
      }
      
      public function GetDefaultCollisionCategory ():Object
      {
         return mDefaultCollisionCategories;
      }
      
      public function CreateCollisionCategory (ccDefine:Object):void
      {
         var numCategories:int = mCollisionCategories.length; // with out the default one
         
         var categoryIndex:int = numCategories + 1;
         
         var category:Object = new Object ();
         
         category.mGroupIndex = ccDefine.mCollideInternally ? categoryIndex : - categoryIndex;
         
         if (mContactFilter == null)
         {
            category.mMaskBits = 0xFFFF;
            category.mCategoryBits = 0x1 << categoryIndex;
         }
         else
         {
            category.mMaskBits = 0;
            category.mCategoryBits = 0;
         }
         
         mCollisionCategories.push (category);
      }
      
      public function GetCollisioonCategory (index:int):Object
      {
         if (index < 0 || index >= mCollisionCategories.length)
            return mDefaultCollisionCategories;
         
         return mCollisionCategories [index];
      }
      
      // here category1Index and category2Index are custom CC id
      public function CreateCollisionCategoryFriendLink (category1Index:int, category2Index:int):void
      {
         var category1:Object = GetCollisioonCategory (category1Index);
         var category2:Object = GetCollisioonCategory (category2Index);
         
         if (mContactFilter == null)
         {
            category1.mMaskBits &= ~category2.mCategoryBits;
            category2.mMaskBits &= ~category1.mCategoryBits;
         }
         else
         {
            mContactFilter.CreateCollisionCategoryFriendLink (category1.mGroupIndex, category2.mGroupIndex);
         }
      }
      
      public function SetCollisionCategoryParamsForShapeParams (shapeParams:Object, shapeCCid:int):void
      {
         var category:Object = GetCollisioonCategory (shapeCCid);
         
         shapeParams.mGroupIndex = category.mGroupIndex;
         
         if (mContactFilter == null)
         {
            shapeParams.mMaskBits = category.mMaskBits;
            shapeParams.mCategoryBits = category.mCategoryBits;
         }
         else
         {
            shapeParams.mMaskBits = 0;
            shapeParams.mCategoryBits = 0;
         }
      }
      
//=================================================================
//   
//=================================================================
      
      private static const GlobalGravityScale:Number = 2.0; // don't change
      
      public function SetGravityByScaleAndAngle (ga:Number, angle:Number):void
      {
         //
         ga *= GlobalGravityScale;
         
         var gravity:b2Vec2 = new b2Vec2 (ga * Math.cos (angle), ga * Math.sin (angle));
         
         _b2World.SetGravity (gravity);
         
          _b2World.WakeUpAllBodies ();
      }
      
      public function SetGravityByVector (gx:Number, gy:Number):void
      {
         //
         var gravity:b2Vec2 = new b2Vec2 (gx * GlobalGravityScale, gy * GlobalGravityScale);
         
         _b2World.SetGravity (gravity);
         
          _b2World.WakeUpAllBodies ();
      }
      
//=================================================================
//   
//=================================================================
      
      public function GetActiveMovableBodiesCount (excludeBodiesConnectedWithJoints:Boolean = false):uint
      {
         var count:int = 0;
         for (var b:b2Body = _b2World.m_bodyList; b != null; b = b.m_next)
         {
            if ( b.IsStatic () )
               continue;
            
            if (excludeBodiesConnectedWithJoints && b.m_jointList != null)
               continue;
            
            if ( b.IsSleeping () )
               continue;
            
            ++ count;
         }
         
         return count;
      }
      
//=================================================================
//   
//=================================================================
      
      public function Update (escapedTime:Number):void
      {
         _b2World.Step (escapedTime, 30);
      }
      
      public function SetJointRemovedListener (func:Function):void
      {
         _OnJointRemoved = func;
      }
      
      public function SetShapeRemovedListener (func:Function):void
      {
         _OnShapeRemoved = func;
      }
      
      public function SetShapeCollisionListener (func:Function):void
      {
         _OnShapeCollision = func;
      }
      
      public function SetGetBodyIndexCallback (func:Function):void
      {
         _GetBodyIndex = func;
      }
      
      public function SetGetShapeIndexCallback (func:Function):void
      {
         _GetShapeIndex = func;
      }
      
//=================================================================
//   
//=================================================================
      
      public function OnJointRemoved (proxyJoint:PhysicsProxyJoint):void
      {
         // ...
         
         if (_OnJointRemoved != null)
            _OnJointRemoved (proxyJoint);
      }
      
      public function OnShapeRemoved (proxyShape:PhysicsProxyShape):void
      {
         // ...
         
         if (_OnShapeRemoved != null)
            _OnShapeRemoved (proxyShape);
      }
      
      public function OnShapeCollision (proxyShape1:PhysicsProxyShape, proxyShape2:PhysicsProxyShape):void
      {
         // ...
         
         if (_OnShapeCollision != null)
            _OnShapeCollision (proxyShape1, proxyShape2);
      }
      
//=================================================================
//   
//=================================================================
      
      public function GetProxyBoiesAtPoint (displayX:Number, displayY:Number, setMaxShapeIndex:Boolean = false):Array
      {
         return GetProxiesAtPoint (displayX, displayY, true, setMaxShapeIndex);
      }
      
      public function GetProxyShapesAtPoint (displayX:Number, displayY:Number):Array
      {
         return GetProxiesAtPoint (displayX, displayY, false);
      }
      
      // isGettingBody - false means to get shapes
      private function GetProxiesAtPoint (displayX:Number, displayY:Number, isGettingBody:Boolean, setMaxShapeIndex:Boolean = false):Array
      {
         var windowSize:Number = 3.0;
         var lowerPoint:Point = DisplayPosition2PhysicsPoint (displayX - windowSize, displayY - windowSize);
         var upperPoint:Point = DisplayPosition2PhysicsPoint (displayX + windowSize, displayY + windowSize);
         var point:Point = DisplayPosition2PhysicsPoint (displayX, displayY);
         
         // 
         
         var aabb:b2AABB = new b2AABB ();
         aabb.lowerBound.Set (lowerPoint.x, lowerPoint.y);
         aabb.upperBound.Set (upperPoint.x, upperPoint.y);
         
         var maxCount:uint = 128;
         var shapes:Array;
         
         var count:int = maxCount;
         
         while (count == maxCount)
         {
            maxCount *= 2;
            shapes = new Array (maxCount);
            
            count = _b2World.Query(aabb, shapes, maxCount);
         }
         
         var vertex:b2Vec2 = new b2Vec2 ();
         vertex.Set(point.x, point.y);
         
         var objectArray:Array = new Array ();
         
         for (var i:int = 0; i < count; ++ i)
         {
            var body:b2Body = shapes[i].GetBody();
            
            if (shapes[i].TestPoint(body.GetXForm(), vertex))
            {
               if (isGettingBody)
               {
                  var proxyBody:PhysicsProxyBody = body.GetUserData () as PhysicsProxyBody;
                  
                  var shapeIndex:Number = _GetShapeIndex (shapes[i].GetUserData () as PhysicsProxyShape);
                  
                  if (objectArray.indexOf (proxyBody) < 0)
                  {
                     objectArray.push (proxyBody);
                     proxyBody.SetTempValue (shapeIndex);
                  }
                  else if (setMaxShapeIndex && (_GetShapeIndex != null) )
                  {
                     var oldShapeIndex:Number = proxyBody.GetTempValue ();
                     
                     if (oldShapeIndex < shapeIndex)
                        proxyBody.SetTempValue (shapeIndex);
                  }
               }
               else
               {
                  var proxyShape:PhysicsProxyShape = shapes[i].GetUserData () as PhysicsProxyShape;
                  
                  if (objectArray.indexOf (proxyShape) < 0)
                  {
                     objectArray.push (proxyShape);
                  }
               }
            }
         }
         
         return objectArray;
      }
      
//=================================================================
//   
//=================================================================
      
      public function CreateProxyBody (displayX:Number, displayY:Number, rotation:Number, static:Boolean, params:Object = null):PhysicsProxyBody
      {
         var point:Point = DisplayPosition2PhysicsPoint (displayX, displayY);
         
         var proxyBody:PhysicsProxyBody = new PhysicsProxyBody (this, point.x, point.y, rotation, static, params);
         
         return proxyBody;
      }
      
      public function CreateProxyShape (proxyBody:PhysicsProxyBody):PhysicsProxyShape
      {
         if (proxyBody == null)
            return null;
         
         var proxyShape:PhysicsProxyShape = new PhysicsProxyShape (this, proxyBody);
         
         return proxyShape;
      }
      
      public function AddCircleToProxyShape (proxyShape:PhysicsProxyShape, displayX:Number, displayY:Number, displayRadius:Number, params:Object):void
      {
         SetCollisionCategoryParamsForShapeParams (params, params.mCollisionCategoryIndex);
         
         var point:Point = DisplayPosition2PhysicsPoint (displayX, displayY);
         
         var physicsRadius:Number = DisplayLength2PhysicsLength (displayRadius);
         
         proxyShape.AddCircleShape (point.x, point.y, physicsRadius, params);
      }
      
      private function AddPolygonToProxyShape (proxyShape:PhysicsProxyShape, displayPoints:Array, params:Object):void
      {
         SetCollisionCategoryParamsForShapeParams (params, params.mCollisionCategoryIndex);
         
         var vertexCount:int = displayPoints.length;
         var worldPhysicsPoints:Array = new Array (vertexCount);
         for (var vertexId:int = 0; vertexId < vertexCount; ++ vertexId)
         {
            worldPhysicsPoints [vertexId] = DisplayPoint2PhysicsPoint (displayPoints [vertexId] as Point);
         }
         
         proxyShape.AddPolygonShape (worldPhysicsPoints, params);
      }
      
      public function AddConvexPolygonToProxyShape (proxyShape:PhysicsProxyShape, displayPoints:Array, params:Object):void
      {
         params.mIsConcavePotentially = false;
         
         AddPolygonToProxyShape (proxyShape, displayPoints, params);
      }
      
      public function AddConcavePolygonToProxyShape (proxyShape:PhysicsProxyShape, displayPoints:Array, params:Object):void
      {
         params.mIsConcavePotentially = true;
         
         AddPolygonToProxyShape (proxyShape, displayPoints, params);
      }
      
      public function AddLineSegmentToProxyShape (proxyShape:PhysicsProxyShape, displayX1:Number, displayY1:Number, displayX2:Number, displayY2:Number, thinkness:Number, params:Object):void
      {
         var dx:Number = displayX2 - displayX1;
         var dy:Number = displayY2 - displayY1;
         var rot:Number = Math.atan2 (dy, dx);
         rot += Math.PI * 0.5;
         
         thinkness *= 0.5;
         dx = thinkness * Math.cos (rot);
         dy = thinkness * Math.sin (rot);
         
         var p1:Point = new Point (displayX1 + dx, displayY1 + dy);
         var p2:Point = new Point (displayX1 - dx, displayY1 - dy);
         var p3:Point = new Point (displayX2 - dx, displayY2 - dy);
         var p4:Point = new Point (displayX2 + dx, displayY2 + dy);
         
         AddConvexPolygonToProxyShape (proxyShape, [p1, p2, p3, p4], params);
      }
      
      public function CreateProxyShapeCircle (proxyBody:PhysicsProxyBody, displayX:Number, displayY:Number, displayRadius:Number, params:Object = null):PhysicsProxyShapeCircle
      {
         if (proxyBody == null)
            return null;
         
         if (params != null)
            SetCollisionCategoryParamsForShapeParams (params, params.mCollisionCategoryIndex);
         
         var point:Point = DisplayPosition2PhysicsPoint (displayX, displayY);
         
         var physicsRadius:Number = DisplayLength2PhysicsLength (displayRadius);
         
         var proxyShapeCircle:PhysicsProxyShapeCircle = new PhysicsProxyShapeCircle (this, proxyBody, point.x, point.y, physicsRadius, params);
         
         return proxyShapeCircle;
      }
      
      // displayPoints is a Point array
      public function CreateProxyShapePolygon (proxyBody:PhysicsProxyBody, displayPoints:Array, params:Object = null):PhysicsProxyShapePolygon
      {
         if (proxyBody == null)
            return null;
         
         if (params != null)
            SetCollisionCategoryParamsForShapeParams (params, params.mCollisionCategoryIndex);
         
         var vertexCount:int = displayPoints.length;
         var worldPhysicsPoints:Array = new Array (vertexCount);
         for (var vertexId:int = 0; vertexId < vertexCount; ++ vertexId)
         {
            worldPhysicsPoints [vertexId] = DisplayPoint2PhysicsPoint (displayPoints [vertexId] as Point);
         }
         
         var proxyShapePolygon:PhysicsProxyShapePolygon = new PhysicsProxyShapePolygon (this, proxyBody, worldPhysicsPoints, params);
         
         return proxyShapePolygon;
      }
      
      public function CreateProxyShapeConvexPolygon (proxyBody:PhysicsProxyBody, displayPoints:Array, params:Object = null):PhysicsProxyShapePolygon
      {
         params.mIsConcavePotentially = false;
         
         return CreateProxyShapePolygon (proxyBody, displayPoints, params);
      }
      
      public function CreateProxyShapeConcavePolygon (proxyBody:PhysicsProxyBody, displayPoints:Array, params:Object = null):PhysicsProxyShapePolygon
      {
         params.mIsConcavePotentially = true;
         
         return CreateProxyShapePolygon (proxyBody, displayPoints, params);
      }
      
      public function CreateProxyJointHinge (proxyBody1:PhysicsProxyBody, proxyBody2:PhysicsProxyBody, anchorDisplayX:Number, anchorDisplayY:Number, params:Object):PhysicsProxyJointHinge
      {
         var point:Point = DisplayPosition2PhysicsPoint (anchorDisplayX, anchorDisplayY);
         
         return new PhysicsProxyJointHinge (this, proxyBody1, proxyBody2, point.x, point.y, params);
      }
      
      public function CreateProxyJointHingeAuto (anchorDisplayX:Number, anchorDisplayY:Number, params:Object):PhysicsProxyJointHinge
      {
         var object:Object = GetJointConnectedBodies_a (anchorDisplayX, anchorDisplayY, params);
         var proxyBody1:PhysicsProxyBody = object.mProxyBody1;
         var proxyBody2:PhysicsProxyBody = object.mProxyBody2;
         
         return CreateProxyJointHinge (proxyBody1, proxyBody2, anchorDisplayX, anchorDisplayY, params);
      }
      
      
      public function CreateProxyJointSlider (proxyBody1:PhysicsProxyBody, proxyBody2:PhysicsProxyBody, anchorDisplayX1:Number, anchorDisplayY1:Number, anchorDisplayX2:Number, anchorDisplayY2:Number, params:Object):PhysicsProxyJointSlider
      {
         var point1:Point = DisplayPosition2PhysicsPoint (anchorDisplayX1, anchorDisplayY1);
         var point2:Point = DisplayPosition2PhysicsPoint (anchorDisplayX2, anchorDisplayY2);
         
         return new PhysicsProxyJointSlider (this, proxyBody1, proxyBody2, point1.x, point1.y, point2.x, point2.y, params);
      }
      
      public function CreateProxyJointSliderAuto (anchorDisplayX1:Number, anchorDisplayY1:Number, anchorDisplayX2:Number, anchorDisplayY2:Number, params:Object):PhysicsProxyJointSlider
      {
         var object:Object = GetJointConnectedBodies_b (anchorDisplayX1, anchorDisplayY1, anchorDisplayX2, anchorDisplayY2, params);
         var proxyBody1:PhysicsProxyBody = object.mProxyBody1;
         var proxyBody2:PhysicsProxyBody = object.mProxyBody2;
         
         return CreateProxyJointSlider (proxyBody1, proxyBody2, anchorDisplayX1, anchorDisplayY1, anchorDisplayX2, anchorDisplayY2, params);
      }
      
      public function CreateProxyJointDistance (proxyBody1:PhysicsProxyBody, proxyBody2:PhysicsProxyBody, anchorDisplayX1:Number, anchorDisplayY1:Number, anchorDisplayX2:Number, anchorDisplayY2:Number, params:Object):PhysicsProxyJointDistance
      {
         var point1:Point = DisplayPosition2PhysicsPoint (anchorDisplayX1, anchorDisplayY1);
         var point2:Point = DisplayPosition2PhysicsPoint (anchorDisplayX2, anchorDisplayY2);
         
         return new PhysicsProxyJointDistance (this, proxyBody1, proxyBody2, point1.x, point1.y, point2.x, point2.y, params);
      }
      
      public function CreateProxyJointDistanceAuto (anchorDisplayX1:Number, anchorDisplayY1:Number, anchorDisplayX2:Number, anchorDisplayY2:Number, params:Object):PhysicsProxyJointDistance
      {
         var object:Object = GetJointConnectedBodies_b (anchorDisplayX1, anchorDisplayY1, anchorDisplayX2, anchorDisplayY2, params);
         var proxyBody1:PhysicsProxyBody = object.mProxyBody1;
         var proxyBody2:PhysicsProxyBody = object.mProxyBody2;
         
         return CreateProxyJointDistance (proxyBody1, proxyBody2, anchorDisplayX1, anchorDisplayY1, anchorDisplayX2, anchorDisplayY2, params);
      }
      
      
//=================================================================
//   
//=================================================================
      
      private function SortBodiesByTempValues (bodies:Array):void
      {
         // sort bodies by temp value
         var i:int;
         var params:Array = new Array ();
         for (i = 0; i < bodies.length; ++ i)
         {
            var param:Object = new Object ();
            param.mTempValue = (bodies [i] as PhysicsProxyBody).GetTempValue ();
            param.mBody = bodies [i] as PhysicsProxyBody;
            params.push (param);
         }
         
         params.sortOn("mTempValue", Array.NUMERIC);
         
         for (i = 0; i < bodies.length; ++ i)
            bodies [i] = params[i].mBody;
      }
      
      private function GetJointConnectedBodies_a (anchorDisplayX:Number, anchorDisplayY:Number, params:Object):Object
      {
         var proxyBody1:PhysicsProxyBody = null;
         var proxyBody2:PhysicsProxyBody = null;
         
         var temp:PhysicsProxyBody;
         
         var bodies:Array;
         
         if ( params.mWorldDefine != null && params.mWorldDefine.mVersion >= 0x0102)
         {
            if (params.mConnectedShape1 != null && params.mConnectedShape1 != this)
               proxyBody1 = (params.mConnectedShape1 as PhysicsProxyShape).GetProxyBody ();
            if (params.mConnectedShape2 != null && params.mConnectedShape2 != this)
               proxyBody2 = (params.mConnectedShape2 as PhysicsProxyShape).GetProxyBody ();
            
            var auto1:Boolean = params.mConnectedShape1 != this && proxyBody1 == null;
            var auto2:Boolean = params.mConnectedShape2 != this && proxyBody2 == null;
            
            if (auto1 || auto2)
            {
               // sort
               bodies = GetProxyBoiesAtPoint (anchorDisplayX, anchorDisplayY, true);
               SortBodiesByTempValues (bodies);
               
               var index:int = 0;
               
               if (auto1)
               {
                  while ( bodies.length > index && proxyBody1 == null )
                  {
                     proxyBody1 = bodies [index] as PhysicsProxyBody;
                     ++ index;
                     if (proxyBody1 == proxyBody2)
                        proxyBody1 = null;
                  }
               }
               
               if (auto2)
               {
                  while ( bodies.length > index && proxyBody2 == null )
                  {
                     proxyBody2 = bodies [index] as PhysicsProxyBody;
                     ++ index;
                     if (proxyBody2 == proxyBody1)
                        proxyBody2 = null;
                  }
                  
                  // if both auto, try to put proxyBody1 as null (ground)
                  if (auto1 && proxyBody2 == null && proxyBody1 != null)
                  {
                     proxyBody2 = proxyBody1;
                     proxyBody1 = null;
                  }
               }
            }
         }
         else
         {
            bodies = GetProxyBoiesAtPoint (anchorDisplayX, anchorDisplayY, true);
            
            if (bodies.length >= 2)
            {
               proxyBody1 = bodies [0] as PhysicsProxyBody;
               proxyBody2 = bodies [1] as PhysicsProxyBody;
               
               if (proxyBody2.IsStatic () && ! proxyBody1.IsStatic ())
               {
                  temp = proxyBody1;
                  proxyBody1 = proxyBody2;
                  proxyBody2 = temp;
               }
            }
            else if (bodies.length == 1)
            {
               proxyBody2 = bodies [0] as PhysicsProxyBody;
            }
            
            if ( params.mWorldDefine != null && params.mWorldDefine.mVersion >= 0x0101)
            {
               if (bodies.length >= 2 && _GetShapeIndex != null)
               {
                  var shapeMaxIndex1:int = proxyBody1.GetTempValue ();
                  var shapeMaxIndex2:int = proxyBody2.GetTempValue ();
                  
                  //trace ("shapeMaxIndex1 = " + shapeMaxIndex1);
                  //trace ("shapeMaxIndex2 = " + shapeMaxIndex2);
                  
                  if (shapeMaxIndex1 > shapeMaxIndex2)
                  {
                     temp = proxyBody2;
                     proxyBody2 = proxyBody1;
                     proxyBody1 = temp;
                  }
               }
            }
         } 
         
         var object:Object = new Object ();
         object.mProxyBody1= proxyBody1;
         object.mProxyBody2= proxyBody2;
         
         return object;
      }
      
      private function GetJointConnectedBodies_b (anchorDisplayX1:Number, anchorDisplayY1:Number, anchorDisplayX2:Number, anchorDisplayY2:Number, params:Object):Object
      {
         var proxyBody1:PhysicsProxyBody = null;
         var proxyBody2:PhysicsProxyBody = null;
         
         var bodies:Array = GetProxyBoiesAtPoint (anchorDisplayX1, anchorDisplayY1);
         
         if ( params.mWorldDefine != null && params.mWorldDefine.mVersion >= 0x0102)
         {
            SortBodiesByTempValues (bodies);
            
            if (params.mConnectedShape1 == this) // ground
               ;
            else if (params.mConnectedShape1 != null)
               proxyBody1 = (params.mConnectedShape1 as PhysicsProxyShape).GetProxyBody ();
            else // auto
            {
               if (bodies.length >= 1)
                  proxyBody1 = bodies [0] as PhysicsProxyBody;
            }
         }
         else
         {
            if (bodies.length >= 1)
            {
               proxyBody1 = bodies [0] as PhysicsProxyBody;
            }
         }
         
         bodies = GetProxyBoiesAtPoint (anchorDisplayX2, anchorDisplayY2);
         
         if ( params.mWorldDefine != null && params.mWorldDefine.mVersion >= 0x0102)
         {
            SortBodiesByTempValues (bodies);
            
            if (params.mConnectedShape2 == this) // ground
               ;
            else if (params.mConnectedShape2 != null)
               proxyBody2 = (params.mConnectedShape2 as PhysicsProxyShape).GetProxyBody ();
            else // auto
            {
               if (bodies.length >= 1)
               {
                  proxyBody2 = bodies [0] as PhysicsProxyBody;
                  
                  if (proxyBody2 == proxyBody1 && bodies.length >= 2)
                     proxyBody2 = bodies [1] as PhysicsProxyBody;
               }
            }
         }
         else
         {
            if (bodies.length >= 1)
            {
               proxyBody2 = bodies [0] as PhysicsProxyBody;
               
               if (proxyBody2 == proxyBody1 && bodies.length >= 2)
                  proxyBody2 = bodies [1] as PhysicsProxyBody;
            }
         }
         
         var object:Object = new Object ();
         object.mProxyBody1= proxyBody1;
         object.mProxyBody2= proxyBody2;
         
         return object;
      }
      
//=================================================================
//   
//=================================================================
      
      private var mDisplay2PhysicsScale:Number = 0.10;
      private var mPhysics2DisplayScale:Number = 1.0 / mDisplay2PhysicsScale;
      
      private var mDisplay2PhysicsOffsetX:Number = 0;
      private var mDisplay2PhysicsOffsetY:Number = 0;
      
      public function SetDisplay2PhysicsScale (scale:Number):void
      {
         if (scale <= 0)
            return;
         
         mDisplay2PhysicsScale = scale;
         mPhysics2DisplayScale = 1.0 / scale;
      }

      public function SetDisplay2PhysicsOffset (physicsOffsetX:Number, physicsOffsetY:Number):void
      {
         mDisplay2PhysicsOffsetX = physicsOffsetX;
         mDisplay2PhysicsOffsetY = physicsOffsetY;
      }
      
      public function DisplayLength2PhysicsLength (dl:Number):Number
      {
         return dl * mDisplay2PhysicsScale;
      }
      
      public function PhysicsLength2DisplayLength (pl:Number):Number
      {
         return pl * mPhysics2DisplayScale;
      }
      
      public function _DisplayPoint2PhysicsPoint (dp:Point):void
      {
         dp.x = (dp.x - mDisplay2PhysicsOffsetX) * mDisplay2PhysicsScale;
         dp.y = (dp.y - mDisplay2PhysicsOffsetY) * mDisplay2PhysicsScale;
      }
      
      public function _PhysicsPoint2DisplayPoint (pp:Point):void
      {
         pp.x = pp.x * mPhysics2DisplayScale + mDisplay2PhysicsOffsetX;
         pp.y = pp.y * mPhysics2DisplayScale + mDisplay2PhysicsOffsetY;
      }
      
      
      public function DisplayPoint2PhysicsPoint (dp:Point):Point
      {
         return DisplayPosition2PhysicsPoint (dp.x, dp.y);
      }
      
      public function DisplayPosition2PhysicsPoint (posX:Number, posY:Number):Point
      {
         var pp:Point = new Point ();
         pp.x = posX;
         pp.y = posY;
         _DisplayPoint2PhysicsPoint (pp);
         return pp;
      }
      
      public function PhysicsPoint2DisplayPoint (pp:Point):Point
      {
         var dp:Point = new Point ();
         dp.x = pp.x;
         dp.y = pp.y;
         _PhysicsPoint2DisplayPoint (dp);
         return dp;
      }
      
      
      
   }
   
}
