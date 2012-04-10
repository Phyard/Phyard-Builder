
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.util.GraphicsUtil;
   
   import editor.world.EntityContainer;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   
   
   import common.Define;
   
   public class EntityJoint extends Entity 
   {
      public var mCollideConnected:Boolean = false;
      
      private var mConnectedShape1:Sprite = null; //EntityShape = null; // also can be mEntityContainer
      private var mConnectedShape2:Sprite = null; //EntityShape = null;
      
      protected var mIsBreakable:Boolean = false;
      
      public function EntityJoint (container:EntityContainer)
      {
         super (container);
      }
      
      override public function GetVisibleAlpha ():Number
      {
         return 0.70;
      }
      
      public function SetConnectedShape1Index (index:int):void
      {
         if (index == Define.EntityId_Ground)
            mConnectedShape1 = mEntityContainer;
         else
            mConnectedShape1 = mEntityContainer.GetEntityByCreationId (index);
      }
      
      public function SetConnectedShape2Index (index:int):void
      {
         
         if (index == Define.EntityId_Ground)
            mConnectedShape2 = mEntityContainer;
         else
            mConnectedShape2 = mEntityContainer.GetEntityByCreationId (index);
      }
      
      public function GetConnectedShape1Index ():int
      {
         if (mConnectedShape1 == null)
            return Define.EntityId_None;
         else if (mConnectedShape1 == mEntityContainer)
            return Define.EntityId_Ground;
         else
         {
            var id:int = mEntityContainer.GetEntityCreationId (mConnectedShape1 as Entity);
            
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
         else if (mConnectedShape2 == mEntityContainer)
            return Define.EntityId_Ground;
         else
         {
            var id:int = mEntityContainer.GetEntityCreationId (mConnectedShape2 as Entity);
            
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
      
      final public function NotifyAnchorPositionChanged ():void
      {
         UpdateJointPosition ();
         
         UpdateAppearance ();
      }
      
      public function UpdateJointPosition ():void
      {
         
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
