package editor.asset {
   
   public class BrothersManager 
   {
      // if add a member mBrothers to Asset, code will be more efficent.
      // meanwhile, need more code in World, would be more bugs.
      
      
      public var mBrotherGroupArray:Array = new Array ();
      
      
      public function MakeBrothers (assetArray:Array):void
      {
         var brothers:Array = assetArray.concat ();
         
         BreakBrothersApart (assetArray);
         
         if (brothers.length <= 1)
            return;
         
         //mBrotherGroupArray.unshift (brothers); // when loading, will makethe order of groups inversed
         mBrotherGroupArray.push (brothers);
         
         var i:int;
         for (i = 0; i < brothers.length; ++ i)
         {
            (brothers [i] as Asset).SetBrothers (brothers);
         }
      }
      
      public function BreakBrothersApart (assetArray:Array):void
      {
         var brotherGroupsToBreakApart:Array = new Array ();
         var assetId:int;
         var brothers:Array;
         var groupId:int;
         var index:int;
         
         for (assetId = 0; assetId < assetArray.length; ++ assetId)
         {
            brothers = (assetArray [assetId] as Asset).GetBrothers ();
            
            if (brothers != null)
            {
               index = brotherGroupsToBreakApart.indexOf (brothers);
               if (index < 0)
                  brotherGroupsToBreakApart.push (brothers);
            }
         }
         
         for (groupId = 0; groupId < brotherGroupsToBreakApart.length; ++ groupId)
         {
            brothers = brotherGroupsToBreakApart [groupId];
            
            index = mBrotherGroupArray.indexOf (brothers);
            if (index < 0)
            {
               trace ("brothers not in mBrotherGroupArray");
               continue;
            }
            mBrotherGroupArray.splice (index, 1);
            
            for (assetId = 0; assetId < brothers.length; ++ assetId)
            {
               (brothers [assetId] as Asset).SetBrothers (null);
            }
         }
      }
      
      public function GetBrothersOfAsset (asset:Asset):Array
      {
         return asset.GetBrothers ();
      }
      
      public function OnDestroyAsset (asset:Asset):void
      {
         var brothers:Array = asset.GetBrothers ();
         
         if (brothers == null)
            return;
         
         while (true) // mystery: sometimes, an asset will be put in a brother group more than one times
         {
            var index:int = brothers.indexOf (asset);
            
            if (index < 0)
            {
               //Logger.Assert (false, "asset not in brothers");
               //return;
               
               break;
            }
            
            brothers.splice (index, 1);
            asset.SetBrothers (null);
         }
         
         if (brothers.length == 1)
         {
            brothers [0].SetBrothers (null);
            brothers.splice (0, 1);
         }
         
         if (brothers.length == 0)
         {
            index = mBrotherGroupArray.indexOf (brothers);
            if (index < 0)
            {
               trace ("brothers not in mBrotherGroupArray (GetBrothersOfAsset)");
               return;
            }
            mBrotherGroupArray.splice (index, 1);
         }
      }
      
      
      
      
   }
}
