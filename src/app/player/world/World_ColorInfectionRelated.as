      
//=======================================================================
//
//=======================================================================

protected var mIsCiRulesEnabled:Boolean = true;
protected var mRemovePinksOnMouseDown:Boolean = true;

public function IsCiRulesEnabled ():Boolean
{
   return mIsCiRulesEnabled;
}
      
public function IsRemovePinksOnMouseDown ():Boolean
{
   return mRemovePinksOnMouseDown;
}

public function SetCiRulesSettings (ciRulesEnabled:Boolean, removePinksOnMouseDown:Boolean):void
{
   mIsCiRulesEnabled = ciRulesEnabled;
   mRemovePinksOnMouseDown = removePinksOnMouseDown;
}

//=======================================================================
//
//=======================================================================

public function IsSuccessed_CICriterion ():Boolean
{
   return (mNumToBeInfecteds == mNumIntectedToBeInfecteds) && (mNumInfectedDontInfects == 0) && (mNumToBeInfecteds + mNumDontInfecteds > 0);
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

protected function RemoveBombsAndRemovableShapes (shapeArray:Array):void
{
   var shape:EntityShape;
   var aiType:int;
   var num:int = shapeArray.length;
   for (var i:int = 0; i < num; ++ i)
   {
      shape = shapeArray [i] as EntityShape;
      
      if (! shape.IsDestroyedAlready ())
      {
         aiType = shape.GetShapeAiType ();
         
         if (aiType == Define.ShapeAiType_Breakable)
         {
            shape.GetBody ().DestroyAllBreakableShapes ();
         }
         else if (aiType == Define.ShapeAiType_Bomb) 
         {
            var bombSize:Number = 0.0;
            if (shape is EntityShape_CircleBomb)
            {
               bombSize = (shape as EntityShape_CircleBomb).GetRadius ();
            }
            else if (shape is EntityShape_RectangleBomb)
            {
               bombSize = Math.sqrt ((shape as EntityShape_RectangleBomb).GetHalfWidth () * (shape as EntityShape_RectangleBomb).GetHalfHeight ());
            }
            
            if (bombSize > 0)
            {
               ExplodeBomb (shape, bombSize);
            }
            
            //shape.DestroyEntity (); // now destroyed in UpdateParticelSystem ()
         }
      }
   }
}
