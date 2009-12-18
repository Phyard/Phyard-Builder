package player.trigger
{
   import common.trigger.ValueTypeDefine;
   import common.CoordinateSystem;
   
   public class CodeSnippet
   {
      protected var mFirstFunctionCalling:FunctionCalling = null;
      
      public function CodeSnippet (firstCalling:FunctionCalling)
      {
         mFirstFunctionCalling = firstCalling;
      }
      
      public function Excute ():void
      {
         var calling:FunctionCalling = mFirstFunctionCalling;
         
         while (calling != null)
         {
            calling.Call ();
            calling = calling.mNextFunctionCalling;
         }
      }
      
//====================================================================
//
//====================================================================
      
      public function DisplayValues2PhysicsValues (coordinateSystem:CoordinateSystem):void
      {
         var calling:FunctionCalling = mFirstFunctionCalling;
         
         while (calling != null)
         {
            calling.DisplayValues2PhysicsValues (coordinateSystem);
            calling = calling.mNextFunctionCalling;
         }
      }
      
      public function PhysicsValues2DisplayValues (coordinateSystem:CoordinateSystem):void
      {
         var calling:FunctionCalling = mFirstFunctionCalling;
         
         while (calling != null)
         {
            calling.PhysicsValues2DisplayValues (coordinateSystem);
            calling = calling.mNextFunctionCalling;
         }
      }
      
   }
}