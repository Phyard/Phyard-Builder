
package editor.selection {
   
   import Box2D.Common.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   
   
   public class SelectionProxy 
   {
      public var mSelectionEngine:SelectionEngine; // used within package
      
      public var mUserData:Object = null; // used within package
      
      public var _b2Body:b2Body = null; // used within package
      
      protected var mSelectable:Boolean = true;
      
      public function SelectionProxy (selEngine:SelectionEngine):void
      {
         mSelectionEngine = selEngine;
      }
      
      public function SetUserData (userData:Object):void
      {
         mUserData = userData;
      }
      
      public function SetSelectable (selectable:Boolean):void
      {
         mSelectable = selectable;
         
         if (_b2Body == null)
            return;
         
      //
         var shape:b2Shape = _b2Body.m_shapeList;
         
         while (shape != null)
         {
            shape.m_filter.groupIndex = mSelectable ? 0 : -1;
            
            shape = shape.m_next;
         }
      }
      
      public function IsSelectable ():Boolean
      {
         return mSelectable;
      }
      
      protected function Rebuild_b2Body (rotation:Number, pointX:Number, pointY:Number):void
      {
      //
         if (_b2Body != null)
            mSelectionEngine._b2World.DestroyBody (_b2Body);
         
      //
         var bodyDef:b2BodyDef = new b2BodyDef ();
         bodyDef.position.Set (pointX, pointY);
         bodyDef.angle = rotation;
         _b2Body = mSelectionEngine._b2World.CreateBody (bodyDef);
         
         _b2Body.SetUserData (this);
      }
      
      public function Destroy ():void
      {
         if (_b2Body != null);
            mSelectionEngine._b2World.DestroyBody (_b2Body);
      }
      
      public function ContainsPoint (pointX:Number, pointY:Number):Boolean
      {
         if (_b2Body == null)
            return false;
         
      //
         var shape:b2Shape = _b2Body.m_shapeList;
         
         while (shape != null)
         {
            if ( shape.TestPoint(_b2Body.GetXForm(), new b2Vec2 (pointX, pointY)) )
               return true;
            
            shape = shape.m_next;
         }
         
         return false;
      }
   }
}
