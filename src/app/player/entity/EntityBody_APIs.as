
public function DestroyAllBreakableShapes ():void
{
   var shape:EntityShape = mShapeListHead;
   var nextShape:EntityShape;
   var numDestroyeds:int = 0;
   while (shape != null)
   {
      nextShape = shape.mNextShapeInBody;
      
      if (shape.GetShapeAiType () == Define.ShapeAiType_Breakable)
      {
         shape.Destroy ();
         ++ numDestroyeds;
      }
      
      shape = nextShape;
   }
   
   if (numDestroyeds > 0)
   {
      OnPhysicsShapeListChanged ();
   }
}
