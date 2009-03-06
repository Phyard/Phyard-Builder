
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.World;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityJoint extends Entity 
   {
      protected var mWorld:World;
      
      public var mCollideConnected:Boolean = false;
      
      private var mConnectedShape1:Sprite = null; //EntityShape = null; // also can be mWorld
      private var mConnectedShape2:Sprite = null; //EntityShape = null;
      
      public function EntityJoint (world:World)
      {
         super (world);
         
         mWorld = world;
      }
      
      public function SetConnectedShape1Index (index:int):void
      {
         if (index == Define.EntityId_Ground)
            mConnectedShape1 = mWorld;
         else if (index >= 0 && index < mWorld.numChildren)
         {
            mConnectedShape1 = mWorld.getChildAt (index) as EntityShape;
         }
         else //if (index == Define.EntityId_None)
         {
            mConnectedShape1 = null;
         }
      }
      
      public function SetConnectedShape2Index (index:int):void
      {
         
         if (index == Define.EntityId_Ground)
            mConnectedShape2 = mWorld;
         else if (index >= 0 && index < mWorld.numChildren)
         {
            mConnectedShape2 = mWorld.getChildAt (index) as EntityShape;
         }
         else // if (index == Define.EntityId_None)
         {
            mConnectedShape2 = null;
         }
      }
      
      public function GetConnectedShape1Index ():int
      {
         if (mConnectedShape1 == null)
            return Define.EntityId_None;
         else if (mConnectedShape1 == mWorld)
            return Define.EntityId_Ground;
         else
         {
            if (mWorld.contains (mConnectedShape1))
               return mWorld.getChildIndex (mConnectedShape1);
            
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
            if (mWorld.contains (mConnectedShape2))
               return mWorld.getChildIndex (mConnectedShape2);
            
            mConnectedShape2 = null;
            return Define.EntityId_None;
         }
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
      }
      
   }
}
