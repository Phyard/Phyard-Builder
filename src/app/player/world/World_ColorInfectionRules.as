//=============================================================
//   C.I. rules
//=============================================================

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
