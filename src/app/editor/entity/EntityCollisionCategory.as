
package editor.entity {
   
   import flash.display.Sprite;
   
   import com.tapirgames.display.TextFieldEx;
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.TextUtil;
   
   import editor.selection.SelectionEngine;
   import editor.selection.SelectionProxyRectangle;
   
   import editor.entity.Entity;
   
   import editor.world.CollisionManager;
   
   import editor.selection.SelectionProxy;
   
   import editor.setting.EditorSetting;
   
   import common.Define;
   
   public class EntityCollisionCategory extends Entity 
   {
      protected var mCollisionManager:CollisionManager;
      
      private var mCategoryName:String = "Default Category";
      
      private var mCollideInternally:Boolean = true;
      
      public function EntityCollisionCategory (cm:CollisionManager)
      {
         super (cm);
         
         mCollisionManager = cm;
      }
      
      public function IsDefaultCategory ():Boolean
      {
         return mCollisionManager.GetDefaultCollisionCategory () == this;
      }
      
      public function SetDefaultCategory (isDefault:Boolean):void
      {
         if (!isDefault && mCollisionManager.GetDefaultCollisionCategory () == this)
            mCollisionManager.SetDefaultCollisionCategory (null);
         
         if (isDefault && mCollisionManager.GetDefaultCollisionCategory () != this)
            mCollisionManager.SetDefaultCollisionCategory (this);
      }
      
      override public function GetTypeName ():String
      {
         return "Collision Category";
      }
      
      public function GetCategoryName ():String
      {
         return mCategoryName;
      }
      
      public function SetCategoryName (newName:String, checkValidity:Boolean = true):void
      {
         if (checkValidity)
            mCollisionManager.ChangeCollisionCategoryName (newName, mCategoryName)
         else
            mCategoryName = newName;
      }
      
      public function IsCollideInternally ():Boolean
      {
         return mCollideInternally;
      }
      
      public function SetCollideInternally (collide:Boolean):void
      {
         mCollideInternally = collide;
      }
      
      override public function UpdateAppearance ():void
      {
         while (numChildren > 0)
            removeChildAt (0);
         
         var ccName:String = mCategoryName;
         
         ccName = TextUtil.GetHtmlEscapedText (ccName);
         
         if (! IsCollideInternally ())
            ccName = "<i><u>" + ccName + "</u></i>";
         
         var textField:TextFieldEx = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + ccName + "</font>", false, 0xFFFFFF, 0x0);
            
         addChild (textField);
         
         textField.x = - textField.width * 0.5;
         textField.y = - textField.height * 0.5;
         
         var borderColor:uint;
         var borderSize :int;
         
         if ( IsSelected () )
         {
            borderColor = EditorSetting.BorderColorSelectedObject;
            borderSize  = 3;
         }
         else
         {
            borderColor = 0x0;
            borderSize = 1;
         }
         
         var filledColor:int;
         
         if (IsDefaultCategory ())
            filledColor = 0xD0D0FF;
         else
            filledColor = 0xFFFFFF;
         
         var bgWidth:Number = textField.width + 20;
         var bgHeight:Number = textField.height + 6;
         
         GraphicsUtil.ClearAndDrawRect (this, - bgWidth * 0.5, - bgHeight * 0.5, bgWidth, bgHeight, borderColor, borderSize, true, filledColor);
      }
      
      override public function UpdateSelectionProxy ():void
      {
         if (mSelectionProxy == null)
         {
            mSelectionProxy = mCollisionManager.mSelectionEngine.CreateProxyRectangle ();
            mSelectionProxy.SetUserData (this);
         }
         
         (mSelectionProxy as SelectionProxyRectangle).RebuildRectangle ( GetRotation (), GetPositionX (), GetPositionY (), width * 0.5, height * 0.5 );
      }
      
   }
}
