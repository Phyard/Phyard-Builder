
package editor.entity {
   
   import flash.display.Sprite;
   
   import flash.system.Capabilities;
   
   import editor.selection.SelectionProxy;
   
   //import editor.core.EditorObject;
   
   import editor.asset.Asset;
   
   import common.Define;
   import common.ValueAdjuster;
   import common.Transform2D;
   
   //todo: extends from Asset (or merge Asset and EditorObject)
   public class Entity extends Asset //EditorObject// Sprite
   {
      protected var mEntityContainer:Scene;
      
      protected var mIsEnabled:Boolean = true;
      
      public function Entity (container:Scene)
      {
         super (container);
         
         mEntityContainer = container;
      }
      
      public function GetScene ():Scene
      {
         return mEntityContainer;
      }
      
      public function IsUtilityEntity ():Boolean
      {
         return false;
      }
      
      override public function GetDefaultName ():String
      {
         return GetTypeName ();
      }
      
      override public function ToCodeString ():String
      {
         return "Entity#" + GetCreationOrderId ();
      }
      
//======================================================
// 
//======================================================
      
      //public function SetSelectable (selectable:Boolean):void
      //{
      //   if (mSelectionProxy != null)
      //      mSelectionProxy.SetSelectable (selectable);
      //}
      
      override public function GetTypeName ():String
      {
         return "Entity";
      }
      
      override public function GetInfoText ():String
      {
         var infoText:String = "x = " + ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionX (GetPositionX ()), 6) 
                             + ", y = " + ValueAdjuster.Number2Precision (mEntityContainer.GetCoordinateSystem ().D2P_PositionY (GetPositionY ()), 6) 
                             + ", angle = " + ValueAdjuster.Number2Precision ((mEntityContainer.GetCoordinateSystem ().D2P_RotationRadians (GetRotation ()) * Define.kRadians2Degrees), 6)
                             + ", scale = " + ValueAdjuster.Number2Precision (GetScale (), 6)
                             ;
         
         if (IsFlipped ())
            infoText = infoText + ", flipped";
         
         return infoText;
      }
      
      public function GetPhysicsShapesCount ():uint
      {
         return 0;
      }
      
//======================================================
// visible, alpha, active
//======================================================
      
      public function SetEnabled (enabled:Boolean):void
      {
         mIsEnabled = enabled;
      }
      
      public function IsEnabled ():Boolean
      {
         return mIsEnabled;
      }
      
//====================================================================
//   clone
//====================================================================
      
      public final function Clone (displayOffsetX:Number, displayOffsetY:Number):Entity
      {
         var entity:Entity = CreateCloneShell ();
         
         if (entity != null)
         {
            SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
            
            entity.UpdateAppearance ();
            entity.UpdateSelectionProxy ();
         }
         
         return entity;
      }
      
      // to override
      protected function CreateCloneShell ():Entity
      {
         return null;
      }
      
      // to override
      public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         entity.SetPosition ( GetPositionX () + displayOffsetX, GetPositionY () + displayOffsetY );
         entity.SetRotation ( GetRotation () );
         entity.SetVisible ( IsVisible () );
         entity.SetAlpha ( GetAlpha () );
         entity.SetEnabled ( IsEnabled () );
         entity.SetScale ( GetScale () );
         entity.SetFlipped ( IsFlipped () );
      }
      
//====================================================================
//   selected
//====================================================================
      
      public function OnWorldZoomScaleChanged ():void
      {
         if (AreControlPointsVisible ())
         {
            // rebuild control points
            SetControlPointsVisible (false);
            SetControlPointsVisible (true);
         }
      }
      
//====================================================================
//   draw entity links
//====================================================================
      
      public static const DrawLinksOrder_Normal:int = 10;
      public static const DrawLinksOrder_Logic:int = 20;
      public static const DrawLinksOrder_Task:int = 30;
      public static const DrawLinksOrder_EventHandler:int = 50;
      
      public function GetDrawLinksOrder ():int
      {
         return DrawLinksOrder_Normal;
      }
      
      override public function DrawAssetLinks (canvasSprite:Sprite, forceDraw:Boolean, isExpanding:Boolean = false):void
      {
         DrawEntityLinks (canvasSprite, forceDraw, isExpanding);
      }
      
      public function DrawEntityLinks (canvasSprite:Sprite, forceDraw:Boolean, isExpanding:Boolean = false):void
      {
         // to override
      }

   }
}