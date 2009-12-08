      
//=======================================================================
//
//=======================================================================
      
      protected var mIsCICriterionEnabled:Boolean = true;
      
      public function IsCICriterionEnabled ():Boolean
      {
         return mIsCICriterionEnabled;
      }
      
      public function SetCICriterionEnabled (enabled:Boolean):void
      {
         mIsCICriterionEnabled = enabled;
      }
      
//=======================================================================
//
//=======================================================================
      
      public function IsSuccessed_CICriterion ():Boolean
      {
         return (mNumToBeInfecteds == mNumIntectedToBeInfecteds) && (mNumInfectedDontInfects == 0);
      }
      
      public function IsFailed_CICriterion ():Boolean
      {
         return mNumInfectedDontInfects > 0;
      }
      
      public function IsUnfinished_CICriterion ():Boolean
      {
         return ! (IsSuccessed_CICriterion () || IsFailed_CICriterion ());
      }
      
//=============================================================
// 
//=============================================================

private var mNumToBeInfecteds:int = 0;
private var mNumDontInfecteds:int = 0;
private var mNumIntectedToBeInfecteds:int = 0;
private var mNumInfectedDontInfects:int = 0;

public function UnregisterShapeAiType (origialAiType:int, aiType:int):void
{
   if (origialAiType == Define.ShapeAiType_Uninfected)
   {
      -- mNumToBeInfecteds;
      
      if (aiType == Define.ShapeAiType_Infected)
      {
         -- mNumIntectedToBeInfecteds;
      }
   }
   else if (origialAiType == Define.ShapeAiType_DontInfect)
   {
      -- mNumDontInfecteds;
      
      if (aiType == Define.ShapeAiType_Infected)
      {
         -- mNumInfectedDontInfects;
      }
   }
}

public function RegisterShapeAiType (origialAiType:int, aiType:int):void
{
   if (origialAiType == Define.ShapeAiType_Uninfected)
   {
      ++ mNumToBeInfecteds;
      
      if (aiType == Define.ShapeAiType_Infected)
      {
         ++ mNumIntectedToBeInfecteds;
      }
   }
   else if (origialAiType == Define.ShapeAiType_DontInfect)
   {
      ++ mNumDontInfecteds;
      
      if (aiType == Define.ShapeAiType_Infected)
      {
         ++ mNumInfectedDontInfects;
      }
   }
}

public function ChangeShapeAiType (origialAiType:int, oldAiType:int, newAiType:int):void
{
   UnregisterShapeAiType (origialAiType, oldAiType);
   RegisterShapeAiType (origialAiType, newAiType);
}

public function ChangeShapeOriginalAiType (oldOrigialAiType:int, newOrigialAiType:int, aiType:int):void
{
   UnregisterShapeAiType (oldOrigialAiType, aiType);
   RegisterShapeAiType (newOrigialAiType, aiType);
}

private function InfectShapes (shape1:EntityShape, shape2:EntityShape):void
{
   var infectable1:Boolean = Define.IsInfectableShape (shape1.GetShapeAiType ());
   var infectable2:Boolean = Define.IsInfectableShape (shape2.GetShapeAiType ());
   
   var infected1:Boolean = Define.IsInfectedShape (shape1.GetShapeAiType ());
   var infected2:Boolean = Define.IsInfectedShape (shape2.GetShapeAiType ());
   
   if (infected1 && ! infected2 && infectable2)
   {
      shape2.SetShapeAiType (Define.ShapeAiType_Infected);
   }
   
   if (infected2 && ! infected1 && infectable1)
   {
      shape1.SetShapeAiType (Define.ShapeAiType_Infected);
   }
}

protected function RemoveBombsAndRemovableShapes (stageDisplayPoint:Point):void
{
   var worldDisplayPoint:Point = globalToLocal (stageDisplayPoint);
   var physicsPoint:Point = DisplayPosition2PhysicsPoint (worldDisplayPoint.x, worldDisplayPoint.y);
   
   var shapeArray:Array = mPhysicsEngine.GetShapesAtPoint (physicsPoint.x, physicsPoint.y);
}
