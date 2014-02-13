   
   public /*static*/ function MergeScene (levelIndex:int):void
   {
      var world:World = this; //Global.GetCurrentWorld ();
      var worldEntityList:EntityList = world.GetEntityList ();
      var worldEntityBodyList:EntityList = world.GetEntityBodyList ();
   
      worldEntityList.MarkLastTail ();
      worldEntityBodyList.MarkLastTail ();
      
      Global.mWorldDefine.mCurrentSceneId = levelIndex;
      DataFormat2.WorldDefine2PlayerWorld (Global.mWorldDefine, world, true);
      
      world.BuildEntityPhysics (true);
      var mergedEntities:Array = worldEntityList.GetEntitiesFromLastMarkedTail ();
   
      worldEntityList.UnmarkLastTail ();
      worldEntityBodyList.UnmarkLastTail ();

      world.RegisterEventHandlersForRuntimeCreatedEntities (true, mergedEntities);
      EntityList.OnCreated_RuntimeCreatedEntities (mergedEntities);
      if (world.ShouldInitRuntimeCteatedEntitiesManually ())
      {
         world.RegisterEventHandlersForRuntimeCreatedEntities (false, mergedEntities);
         EntityList.InitEntities_RuntimeCreatedEntities (mergedEntities);
      }
   }
   