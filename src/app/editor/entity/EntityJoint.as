
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityJoint extends WorldEntity 
   {
      public var mCollideConnected:Boolean = false;
      
      private var mConnectedShape1:Sprite = null; //EntityShape = null; // also can be mWorld
      private var mConnectedShape2:Sprite = null; //EntityShape = null;
      
      protected var mIsBreakable:Boolean = false;
      
      public function EntityJoint (world:World)
      {
         super (world);
      }
      
      public function SetConnectedShape1Index (index:int):void
      {
         if (index == Define.EntityId_Ground)
            mConnectedShape1 = mWorld;
         else
            mConnectedShape1 = mWorld.GetEntityByCreationId (index);
      }
      
      public function SetConnectedShape2Index (index:int):void
      {
         
         if (index == Define.EntityId_Ground)
            mConnectedShape2 = mWorld;
         else
            mConnectedShape2 = mWorld.GetEntityByCreationId (index);
      }
      
      public function GetConnectedShape1Index ():int
      {
         if (mConnectedShape1 == null)
            return Define.EntityId_None;
         else if (mConnectedShape1 == mWorld)
            return Define.EntityId_Ground;
         else
         {
            var id:int = mWorld.GetEntityCreationId (mConnectedShape1 as Entity);
            
            if (id >= 0)
               return id;
            
            mConnectedShape1 = null;
            return Define.EntityId_None;
         }
      }
      
      public function GetConnectedShape2Index ():int
      {
         if (mConnectedShape2 == null)
            return Define.EntityId_None;
         else if (mConnectedShape2 == mWorld)
            return Define.EntityId_Ground;
         else
         {
            var id:int = mWorld.GetEntityCreationId (mConnectedShape2 as Entity);
            
            if (id >= 0)
               return id;
            
            mConnectedShape2 = null;
            return Define.EntityId_None;
         }
      }
      
      public function SetBreakable (breakable:Boolean):void
      {
         mIsBreakable = breakable;
      }
      
      public function IsBreakable ():Boolean
      {
         return mIsBreakable;
      }
      
//====================================================================
//   clone
//====================================================================
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, 0, 0);
         
         var joint:EntityJoint = entity as EntityJoint;
         
         joint.mCollideConnected = mCollideConnected;
         
         //joint.SetConnectedShape1Index ( GetConnectedShape1Index () );
         //joint.SetConnectedShape2Index ( GetConnectedShape2Index () );
         
         joint.SetBreakable (IsBreakable ());
      }
      
   }
}
