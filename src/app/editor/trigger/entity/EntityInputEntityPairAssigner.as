
package editor.trigger.entity {
   
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenuBuiltInItems;
   //import flash.ui.ContextMenuClipboardItems; // flash 10
   import flash.events.ContextMenuEvent;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import editor.world.World;
   import editor.entity.Entity;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyCircle;
   
   
   
   import common.Define;
   
   public class EntityInputEntityPairAssigner extends EntityLogic 
   {
      public static var kRadius:Number = 6;
      public static var kRadius2:Number = 12;
      public static var kOffsetY:Number = 26;
      public static var kOffsetX2:Number = 15;
      public static var kOffsetY2:Number = 15;
      
      protected static var sContextMenu:ContextMenu;
      protected static var sContextMenuItems:Array = [
               new ContextMenuItem ("Change Pairing Type to \"One to One\"", false),
               new ContextMenuItem ("Change Pairing Type to \"Many to Many\"", false),
               new ContextMenuItem ("Change Pairing Type to \"Many to Any\"", false),
               new ContextMenuItem ("Change Pairing Type to \"Any to Many\"", false),
               new ContextMenuItem ("Change Pairing Type to \"Any to Any\"", false),
               new ContextMenuItem ("Change Pairing Type to \"Either in Many\"", false),
               new ContextMenuItem ("Change Pairing Type to \"Both in Many\"", false),
            ];
      
      //...
      
      public var mBorderThickness:Number = 1;
      protected var mSelectorLayer:Sprite;
      public var mInputEntitySelectors:Array = null;
      
      //
      protected var mEntityPairAssignerType:int = Define.EntityPairAssignerType_OneToOne;
      //protected var mEntityPairAssignerType:int = Define.EntityPairAssignerType_AnyToMany;
      //protected var mEntityPairAssignerType:int = Define.EntityPairAssignerType_EitherInMany;
      
      protected var mInputEntities1:Array = new Array ();
      protected var mInputEntities2:Array = new Array ();
      
      public function EntityInputEntityPairAssigner (world:World)
      {
         super (world);
         
         mSelectorLayer = new Sprite ();
         mSelectorLayer.x = 0;
         mSelectorLayer.y = - kOffsetY;
         
         addChild (mSelectorLayer);
         
         RebuildEntityArrays ();
         
         BuildContextMenu ();
      }
      
      public function GetPairingType ():int
      {
         return mEntityPairAssignerType;
      }
      
      //public function GetInputEntities1 ():Array
      //{
      //   //return mInputEntities1;
      //   
      //   var entities:Array = new Array ();
      //   
      //   if (mInputEntities1 != null)
      //   {
      //      var entity:Entity;
      //      var main_entity:Entity;
      //      for (var i:int = 0; i < mInputEntities1.length; ++ i)
      //      {
      //         entity = mInputEntities1 [i] as Entity;
      //         
      //         if (mEntityPairAssignerType == Define.EntityPairAssignerType_OneToOne)
      //         {
      //            main_entity = entity == null ? null : entity.GetMainEntity ();
      //            entities.push (main_entity);
      //         }
      //         else if (entity != null)
      //         {
      //            main_entity = entity.GetMainEntity ();
      //            if (entities.indexOf (main_entity) < 0)
      //            {
      //               entities.push (main_entity);
      //            }
      //         }
      //      }
      //   }
      //   
      //   return entities;
      //}
      //
      //public function GetInputEntities2 ():Array
      //{
      //   //return mInputEntities2;
      //   
      //   var entities:Array = new Array ();
      //   
      //   if (mInputEntities2 != null)
      //   {
      //      var entity:Entity;
      //      var main_entity:Entity;
      //      for (var i:int = 0; i < mInputEntities2.length; ++ i)
      //      {
      //         entity = mInputEntities2 [i] as Entity;
      //         
      //         if (mEntityPairAssignerType == Define.EntityPairAssignerType_OneToOne)
      //         {
      //            main_entity = entity == null ? null : entity.GetMainEntity ();
      //            entities.push (main_entity);
      //         }
      //         else if (entity != null)
      //         {
      //            main_entity = entity.GetMainEntity ();
      //            if (entities.indexOf (main_entity) < 0)
      //            {
      //               entities.push (main_entity);
      //            }
      //         }
      //      }
      //   }
      //   
      //   return entities;
      //}
      
      public function GetInputPairEntities ():Array
      {
         ValidateEntityLinks ();
         
         return [mInputEntities1, mInputEntities2];
      }
      
      public function SetInputPairEntities (entities1:Array, entities2:Array):void
      {
         var creationIds1:Array = new Array (entities1.length);
         var creationIds2:Array = new Array (entities2.length);
         
         var i:int;
         
         for (i = 0; i < entities1.length; ++ i)
            creationIds1 [i] = (entities1 [i] as Entity).GetCreationOrderId ();
         
         for (i = 0; i < entities2.length; ++ i)
            creationIds2 [i] = (entities2 [i] as Entity).GetCreationOrderId ();
         
         SetInputPairEntitiesByCreationdIds (creationIds1, creationIds2);
      }
      
      public function SetInputPairEntitiesByCreationdIds (inputEntityCreationIds1:Array, inputEntityCreationIds2:Array):void
      {
         if (mInputEntities1 == null)
            inputEntityCreationIds1 = null;
         else (mInputEntities1.length > 0)
            mInputEntities1.splice (0, mInputEntities1.length);
          
         if (mInputEntities2 == null)
            inputEntityCreationIds2 = null;
         else (mInputEntities2.length > 0)
            mInputEntities2.splice (0, mInputEntities2.length);
         
         var num:int;
         var i:int;
         
         if (mEntityPairAssignerType == Define.EntityPairAssignerType_OneToOne)
         {
            if (inputEntityCreationIds1 != null && mInputEntities2 != null)
            {
               num = inputEntityCreationIds1.length;
               if (num > inputEntityCreationIds2.length)
                  num = inputEntityCreationIds2.length;
               
               for (i = 0; i < num; ++ i)
               {
                  mInputEntities1.push (mWorld.GetEntityByCreationId (inputEntityCreationIds1 [i]));
                  mInputEntities2.push (mWorld.GetEntityByCreationId (inputEntityCreationIds2 [i]));
               }
            }
         }
         else
         {
            num = inputEntityCreationIds1.length;
            for (i = 0; i < num; ++ i)
            {
               mInputEntities1.push (mWorld.GetEntityByCreationId (inputEntityCreationIds1 [i]));
            }
            
            num = inputEntityCreationIds2.length;
            for (i = 0; i < num; ++ i)
            {
               mInputEntities2.push (mWorld.GetEntityByCreationId (inputEntityCreationIds2 [i]));
            }
         }
         
      }
      
      public function ValidateEntityLinks ():void
      {
         if (mEntityPairAssignerType == Define.EntityPairAssignerType_OneToOne)
         {
            InputEntitySelector_Single.ValidateLinkedEntities (mInputEntities1, mInputEntities2);
         }
         else 
         {
            InputEntitySelector_Many.ValidateLinkedEntities (mInputEntities1);
            InputEntitySelector_Many.ValidateLinkedEntities (mInputEntities2);
         }
      }
      
      override public function GetTypeName ():String
      {
         return "Entity Pair Assigner";
      }
      
      protected function RebuildEntityArrays ():void
      {
         switch (mEntityPairAssignerType)
         {
            case Define.EntityPairAssignerType_OneToOne:
            {
               mInputEntities1 = new Array ();//Define.MaxEntityPairesCountEachOneToOnePairAssigner);
               mInputEntities2 = new Array ();//Define.MaxEntityPairesCountEachOneToOnePairAssigner);
               
               break;
            }
            case Define.EntityPairAssignerType_ManyToMany:
            case Define.EntityPairAssignerType_ManyToAny:
            case Define.EntityPairAssignerType_AnyToMany:
            case Define.EntityPairAssignerType_AnyToAny:
            {
               if (mEntityPairAssignerType == Define.EntityPairAssignerType_ManyToMany || mEntityPairAssignerType == Define.EntityPairAssignerType_ManyToAny)
                  mInputEntities1 = new Array ();
               else
                  mInputEntities1 = null;
               
               if (mEntityPairAssignerType == Define.EntityPairAssignerType_ManyToMany || mEntityPairAssignerType == Define.EntityPairAssignerType_AnyToMany)
                  mInputEntities2 = new Array ();
               else
                  mInputEntities2 = null;
               
               break;
            }
            case Define.EntityPairAssignerType_EitherInMany:
            case Define.EntityPairAssignerType_BothInMany:
            {
               mInputEntities1 = new Array ();
               mInputEntities2 = null;
               
               break;
            }
            default:
               mInputEntities1 = null;
               mInputEntities2 = null;
               
               break;
         }
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var borderColor:int = 0x0;
         mBorderThickness = 1;
         if ( IsSelected () )
         {
            borderColor = Define.BorderColorSelectedObject;
            if (mBorderThickness * mWorld.GetZoomScale () < 3)
               mBorderThickness  = 3.0 / mWorld.GetZoomScale ();
         }
         
         var background:Shape = new Shape ();
         GraphicsUtil.ClearAndDrawCircle (background, 0, 0, kRadius2, borderColor, mBorderThickness, true, 0xFFC000);
         GraphicsUtil.DrawLine (background, -kRadius2, 0, kRadius2, 0);
         GraphicsUtil.DrawCircle (background, 0, 0, kRadius, 0x0, 1, true, 0xFFFF00);
         
         addChild (background);
         
         var text_field:Bitmap;
         text_field = DisplayObjectUtil.CreateCacheDisplayObject (TextFieldEx.CreateTextField ("<font face='Verdana' size='9'>2</font>", false, 0xFFFFFF, 0x0));
         
         addChild (text_field);
         
         text_field.x = - 0.5 * text_field.width;
         text_field.y = - 0.5 * text_field.height;
         
         addChild (mSelectorLayer);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mWorld.mSelectionEngine.CreateProxyCircle ();
            mSelectionProxy.SetUserData (this);
            
            SetInternalComponentsVisible (AreInternalComponentsVisible ());
         }
         
         var borderThickness:Number = mBorderThickness;
         
         (mSelectionProxy as SelectionProxyCircle).RebuildCircle( GetRotation (), GetPositionX (), GetPositionY (), kRadius2 );
      }
      
//==============================================================================================================
//
//==============================================================================================================
      
      private static function BuildContextMenu ():void
      {
         if (sContextMenu != null)
            return;
         
         sContextMenu = new ContextMenu ();
         sContextMenu.hideBuiltInItems ();
         var defaultItems:ContextMenuBuiltInItems = sContextMenu.builtInItems;
         defaultItems.print = false;
         
         for (var i:int = 0; i < sContextMenuItems.length; ++ i)
         {
            sContextMenu.customItems.push (sContextMenuItems [i] as ContextMenuItem);
            (sContextMenuItems [i] as ContextMenuItem).addEventListener (ContextMenuEvent.MENU_ITEM_SELECT, OnContextMenuEvent);
         }
      }
      
      private static function OnContextMenuEvent (event:ContextMenuEvent):void
      {
         var pair_assigner:EntityInputEntityPairAssigner = event.mouseTarget as EntityInputEntityPairAssigner;
         if (pair_assigner == null)
            return;
         
         var index:int = sContextMenuItems.indexOf (event.target);
         
         if (index >= 0)
            pair_assigner.SetPairingType (index);
      }
      
      override public function SetInternalComponentsVisible (visible:Boolean):void
      {
         if (mSelectionProxy == null)
            return; // this happens when creating this entity
         
         super.SetInternalComponentsVisible (visible);
         
         mSelectorLayer.visible = AreInternalComponentsVisible ();
         
         if (AreInternalComponentsVisible ())
         {
            mSelectorLayer.visible = true;
            
            contextMenu = sContextMenu;
            
            for (var i:int = 0; i < sContextMenuItems.length; ++ i)
               (sContextMenuItems [i] as ContextMenuItem).enabled = (i != mEntityPairAssignerType);
         }
         else
         {
            mSelectorLayer.visible = false;
            
            contextMenu = null;
         }
         
         if (! visible && mInputEntitySelectors != null)
         {
            DestroyInternalComponents ();
         }
         
         if (visible && mInputEntitySelectors == null)
         {
            CreateInternalComponents ();
         }
         
         if (mInputEntities1 != null && mInputEntities1.length > 0 || mInputEntities2 != null && mInputEntities2.length > 0)
            InputEntitySelector.NotifyEntityLinksModified ();
      }
      
      public function SetPairingType (newType:int):void
      {
         var oldType:int = mEntityPairAssignerType;
         mEntityPairAssignerType = newType;
         
         for (var i:int = 0; i < sContextMenuItems.length; ++ i)
            (sContextMenuItems [i] as ContextMenuItem).enabled = (i != mEntityPairAssignerType);
         
         if (AreInternalComponentsVisible () && oldType != newType)
         {
            DestroyInternalComponents ();
            
            RebuildEntityArrays ();
            
            CreateInternalComponents ();
            
            InputEntitySelector.NotifyEntityLinksModified ();
         }
      }
      
      protected function CreateInternalComponents ():void
      {
         DestroyInternalComponents ();
         
         var i:int;
         var selector:InputEntitySelector;
         var line:Shape;
         
         var offset_x:Number = kOffsetX2 / mWorld.GetZoomScale ();
         var offset_y:Number = kOffsetY2 / mWorld.GetZoomScale ();
         
         switch (mEntityPairAssignerType)
         {
            case Define.EntityPairAssignerType_OneToOne:
            {
               //mInputEntitySelectors = new Array (2 * Define.MaxEntityPairesCountEachOneToOnePairAssigner);
               var num_selector_pairs:int;
               if (mInputEntities1.length < Define.MaxEntityPairesCountEachOneToOnePairAssigner)
                  num_selector_pairs = mInputEntities1.length + 1;
               else
                  num_selector_pairs = mInputEntities1.length;
                  
               mInputEntitySelectors = new Array (2 * num_selector_pairs);
               
               var pair_y:Number = 0;
               var selectorId:int = 0;
               for (i = 0; i < mInputEntitySelectors.length; i += 2)
               {
                  selector = new InputEntitySelector_Single (mWorld, this, 0, selectorId, OnSelectEntity, OnClearEntities);
                  mInputEntitySelectors [i] = selector;
                  selector.x = - offset_x;
                  selector.y = pair_y;
                  mSelectorLayer.addChild (selector);
                  selector.UpdateAppearance ();
                  selector.UpdateSelectionProxy ();
                  
                  selector = new InputEntitySelector_Single (mWorld, this, 1, selectorId, OnSelectEntity, OnClearEntities);
                  mInputEntitySelectors [i+1] = selector;
                  selector.x = offset_x;
                  selector.y = pair_y;
                  mSelectorLayer.addChild (selector);
                  selector.UpdateAppearance ();
                  selector.UpdateSelectionProxy ();
                  
                  GraphicsUtil.DrawLine (mSelectorLayer, - offset_x, pair_y, offset_x, pair_y, 0x0, 0);
                  
                  pair_y -= offset_y;
                  ++ selectorId;
               }
               
               break;
            }
            case Define.EntityPairAssignerType_ManyToMany:
            case Define.EntityPairAssignerType_ManyToAny:
            case Define.EntityPairAssignerType_AnyToMany:
            case Define.EntityPairAssignerType_AnyToAny:
            {
               mInputEntitySelectors = new Array (2);
               
               if (mEntityPairAssignerType == Define.EntityPairAssignerType_ManyToMany || mEntityPairAssignerType == Define.EntityPairAssignerType_ManyToAny)
               {
                  selector = new InputEntitySelector_Many (mWorld, this, 0, 0, OnSelectEntity, OnClearEntities);
               }
               else
               {
                  selector = new InputEntitySelector_Any (mWorld, this);
               }
               
               mInputEntitySelectors [0] = selector;
               selector.x = - offset_x;
               selector.y = 0;
               mSelectorLayer.addChild (selector);
               selector.UpdateAppearance ();
               selector.UpdateSelectionProxy ();
               
               if (mEntityPairAssignerType == Define.EntityPairAssignerType_ManyToMany || mEntityPairAssignerType == Define.EntityPairAssignerType_AnyToMany)
               {
                  selector = new InputEntitySelector_Many (mWorld, this, 1, 0, OnSelectEntity, OnClearEntities);
               }
               else
               {
                  selector = new InputEntitySelector_Any (mWorld, this);
               }
               
               mInputEntitySelectors [1] = selector;
               selector.x = offset_x;
               selector.y = 0;
               mSelectorLayer.addChild (selector);
               selector.UpdateAppearance ();
               selector.UpdateSelectionProxy ();
               
               GraphicsUtil.DrawLine (mSelectorLayer, - offset_x, 0, offset_x, 0, 0x0, 0);
               
               break;
            }
            case Define.EntityPairAssignerType_EitherInMany:
            case Define.EntityPairAssignerType_BothInMany:
            {
               mInputEntitySelectors = new Array (1);
               selector = new InputEntitySelector_Many (mWorld, this, 0, 0, OnSelectEntity, OnClearEntities);
               mInputEntitySelectors [0] = selector;
               selector.x = 0;
               selector.y = 0;
               mSelectorLayer.addChild (selector);
               selector.UpdateAppearance ();
               selector.UpdateSelectionProxy ();
               
               break;
            }
            default:
               break;
         }
         
      // 
         
         if (mInputEntitySelectors != null)
         {
            GraphicsUtil.DrawLine (mSelectorLayer, 0, (kOffsetY - kRadius2), 0, - ( (mInputEntitySelectors.length - 1) >> 1) * offset_y, 0x0, 0);
            UpdateInternalComponents (true);
         }
      }
      
      protected function DestroyInternalComponents ():void
      {
         var i:int;
         var selector:InputEntitySelector;
         
         if (mInputEntitySelectors != null)
         {
            for (i = 0; i < mInputEntitySelectors.length; ++ i)
            {
               selector = mInputEntitySelectors [i] as InputEntitySelector;
               if (selector != null)
               {
                  selector.Destroy ();
               }
            }
         }
         
         mInputEntitySelectors = null;
         
         GraphicsUtil.Clear (mSelectorLayer);
         while (mSelectorLayer.numChildren > 0)
            mSelectorLayer.removeChildAt (0);
      }
      
      protected function UpdateInternalComponents (updateSelectionProxy:Boolean = true):void
      {
         if (mInputEntitySelectors != null && updateSelectionProxy)
         {
            var selector:InputEntitySelector;
            for (var i:int = 0; i < mInputEntitySelectors.length; ++ i)
            {
               selector = mInputEntitySelectors [i] as InputEntitySelector;
               if (selector != null)
                  selector.UpdateSelectionProxy ();
            }
         }
      }
      
//====================================================================
//   clone
//====================================================================
      
      override protected function CreateCloneShell ():Entity
      {
         return new EntityInputEntityPairAssigner (mWorld);
      }
      
      override public function SetPropertiesForClonedEntity (entity:Entity, displayOffsetX:Number, displayOffsetY:Number):void // used internally
      {
         super.SetPropertiesForClonedEntity (entity, displayOffsetX, displayOffsetY);
         
         var pairAssigner:EntityInputEntityPairAssigner = entity as EntityInputEntityPairAssigner;
         
         pairAssigner.SetPairingType (GetPairingType ());
         
         var inputEntitites:Array = GetInputPairEntities ();
         pairAssigner.SetInputPairEntities (inputEntitites [0], inputEntitites[1]);
      }
      
//====================================================================
//   entity links
//====================================================================
      
      private function OnSelectEntity (entity:Entity, inputId:int, selectorId:int):Boolean
      {
         //ValidateEntityLinks (); // can't do this here, do this in DrawLinks
         
         var index:int;
         if (inputId == 0)
         {
            if (mInputEntities1 != null)
            {
               if (mEntityPairAssignerType == Define.EntityPairAssignerType_OneToOne)
               {
                  if (selectorId >= 0 && selectorId <= mInputEntities1.length) // note: here <= is not <, for c and java, need more to do
                  {
                     if (mInputEntities1 [selectorId] == entity)
                        mInputEntities1 [selectorId] = null
                     else
                        mInputEntities1 [selectorId] = entity;
                        
                     return true;
                  }
               }
               else 
               {
                  index = mInputEntities1.indexOf (entity);
                  
                  if (index >= 0)
                  {
                     mInputEntities1.splice (index, 1);
                     return true;
                  }
                  else (mInputEntities1.length < Define.MaxEntitiesCountEachAssigner)
                  {
                     mInputEntities1.push (entity);
                     return true;
                  }
               }
            }
         }
         else if (inputId == 1)
         {
            if (mInputEntities2 != null)
            {
               if (mEntityPairAssignerType == Define.EntityPairAssignerType_OneToOne)
               {
                  if (selectorId >= 0 && selectorId <= mInputEntities2.length) // note: here <= is not <, for c and java, need more to do
                  {
                     if (mInputEntities2 [selectorId] == entity)
                        mInputEntities2 [selectorId] = null;
                     else
                        mInputEntities2 [selectorId] = entity;
                     
                     return true;
                  }
               }
               else 
               {
                  index = mInputEntities2.indexOf (entity);
                  
                  if (index >= 0)
                  {
                     mInputEntities2.splice (index, 1);
                     return true;
                  }
                  else (mInputEntities2.length < Define.MaxEntitiesCountEachAssigner)
                  {
                     mInputEntities2.push (entity);
                     return true;
                  }
               }
            }
         }
         
         return false;
      }
      
      private function OnClearEntities (inputId:int, selectorId:int):Boolean
      {
         if (inputId == 0)
         {
            if (mEntityPairAssignerType == Define.EntityPairAssignerType_OneToOne)
            {
               if (selectorId >= 0 && selectorId < mInputEntities1.length)
               {
                  mInputEntities1 [selectorId] = null;
                  
                  return true;
               }
            }
            else if (mInputEntities1 != null && mInputEntities1.length > 0)
            {
               mInputEntities1.splice (0, mInputEntities1.length);
               
               return true;
            }
         }
         else if (inputId == 1)
         {
            if (mEntityPairAssignerType == Define.EntityPairAssignerType_OneToOne)
            {
               if (selectorId >= 0 && selectorId < mInputEntities2.length)
               {
                  mInputEntities2 [selectorId] = null;
                  
                  return true;
               }
            }
            else if (mInputEntities2 != null && mInputEntities2.length > 0)
            {
               mInputEntities2.splice (0, mInputEntities2.length);
               
               return true;
            }
         }
         
         return false;
      }
      
      override public function DrawEntityLinkLines (canvasSprite:Sprite):void
      {
         ValidateEntityLinks ();
         
         if (! AreInternalComponentsVisible ())
            return;
         
         if (!visible)
            return;
         
         if (mEntityPairAssignerType == Define.EntityPairAssignerType_OneToOne)
         {
            var num_selector_pairs:int;
            if (mInputEntities1.length < Define.MaxEntityPairesCountEachOneToOnePairAssigner)
               num_selector_pairs = mInputEntities1.length + 1;
            else
               num_selector_pairs = mInputEntities1.length;
            
            if (num_selector_pairs + num_selector_pairs != mInputEntitySelectors.length)
            {
               DestroyInternalComponents ();
               CreateInternalComponents ();
            }
         }
         
         if (mEntityPairAssignerType == Define.EntityPairAssignerType_OneToOne)
         {
            var i:int;
            var index:int = 0;
            for (i = 0; i < mInputEntities1.length; ++ i)
            {
               if (mInputEntities1 [i] != null && mInputEntitySelectors [index] != null)
                  (mInputEntitySelectors [index] as InputEntitySelector_Single).DrawEntityLinkLine (canvasSprite, mInputEntities1 [i]);
               ++ index;
               
               if (mInputEntities2 [i] != null && mInputEntitySelectors [index] != null)
                  (mInputEntitySelectors [index] as InputEntitySelector_Single).DrawEntityLinkLine (canvasSprite, mInputEntities2 [i]);
               ++ index;
            }
         }
         else 
         {
            if (mInputEntities1 != null && mInputEntities1.length > 0)
            {
               (mInputEntitySelectors [0] as InputEntitySelector_Many).DrawEntityLinkLines (canvasSprite, mInputEntities1);
            }
            
            if (mInputEntities2 != null && mInputEntities2.length > 0)
            {
               (mInputEntitySelectors [1] as InputEntitySelector_Many).DrawEntityLinkLines (canvasSprite, mInputEntities2);
            }
         }
      }
      
//====================================================================
//   move, rotate, scale
//====================================================================
      
      override public function Move (offsetX:Number, offsetY:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Move (offsetX, offsetY, updateSelectionProxy);
         
         UpdateInternalComponents (updateSelectionProxy);
      }
      
      override public function Rotate (centerX:Number, centerY:Number, dRadians:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Rotate (centerX, centerY, dRadians, updateSelectionProxy);
         
         UpdateInternalComponents (updateSelectionProxy);
      }
      
      override public function Scale (centerX:Number, centerY:Number, ratio:Number, updateSelectionProxy:Boolean = true):void
      {
         super.Scale (centerX, centerY, ratio, updateSelectionProxy);
         
         UpdateInternalComponents (updateSelectionProxy);
      }
      
//====================================================================
//   linkable
//====================================================================
      
      override public function GetLinkZoneId (localX:Number, localY:Number, checkActiveZones:Boolean = true, checkPassiveZones:Boolean = true):int
      {
         if (localX * localX + localY * localY > kRadius * kRadius) 
            return 0;
         
         return -1;
      }
      
      override public function CanStartCreatingLink (worldDisplayX:Number, worldDisplayY:Number):Boolean
      {
         var local_point:Point = DisplayObjectUtil.LocalToLocal (mWorld, this, new Point (worldDisplayX, worldDisplayY));
         
         return GetLinkZoneId (local_point.x, local_point.y) >= 0;
      }
      
      override public function TryToCreateLink (fromWorldDisplayX:Number, fromWorldDisplayY:Number, toEntity:Entity, toWorldDisplayX:Number, toWorldDisplayY:Number):Boolean
      {
         return false;
      }
      
   }
}
