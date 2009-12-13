
package player.entity {
   
   import flash.display.Bitmap;
   
   import com.tapirgames.util.GraphicsUtil;
   import com.tapirgames.util.DisplayObjectUtil;
   import com.tapirgames.util.TextUtil;
   import com.tapirgames.display.TextFieldEx;
   
   import player.world.World;
   
   import common.Define;
   
   public class EntityShape_Text extends EntityShapeRectangle
   {
      public function EntityShape_Text (world:World)
      {
         super (world);
         
         mAppearanceObjectsContainer.addChild (mTextBitmap);
      }
      
//=============================================================
//   create
//=============================================================
      
      override public function Create (createStageId:int, entityDefine:Object):void
      {
         super.Create (createStageId, entityDefine);
         
         if (createStageId == 0)
         {
            if (entityDefine.mText != undefined)
               SetText (entityDefine.mText);
            
            if (entityDefine.mAutofitWidth != undefined)
               SetAutofitWidth (entityDefine.mAutofitWidth);
            
            // force 50
            SetTransparency (50);
         }
      }
      
//=============================================================
//   
//=============================================================
      
      private var mText:String = "";
      private var mAutofitWidth:Boolean = true;
      
      public function GetText ():String
      {
         return mText;
      }
      
      public function SetText (text:String):void
      {
         if (text == null)
            text = "";
         
         if (mText != text)
         {
            mText = text;
            
            mNeedRebuildAppearanceObjects = true;
            DelayUpdateAppearance ();
         }
      }
      
      public function SetAutofitWidth (auto:Boolean):void
      {
         if (mAutofitWidth != auto)
         {
            mAutofitWidth = auto;
            
            mNeedRebuildAppearanceObjects = true;
            DelayUpdateAppearance ();
         }
      }
      
//=============================================================
//   update
//=============================================================
      
      override protected function UpdateInternal (dt:Number):void
      {
      }
      
//=============================================================
//   appearance
//=============================================================
      
      private var mTextBitmap:Bitmap = new Bitmap ();
      
      override public function UpdateAppearance ():void
      {
         //mAppearanceObjectsContainer.visible = mVisible
         //mAppearanceObjectsContainer.alpha = mAlpha; 
         
         var needRebuildAppearanceObjects:Boolean = mNeedRebuildAppearanceObjects;
         //var needUpdateAppearanceProperties:Boolean = mNeedRebuildAppearanceProperties;
         
         super.UpdateAppearance ();
         
         if (needRebuildAppearanceObjects)
         {
            var displayHalfWidth :Number = mWorld.PhysicsLength2DisplayLength (mHalfWidth);
            //var displayHalfHeight:Number = mWorld.PhysicsLength2DisplayLength (mHalfHeight);
            
            var infoText:String = mText;
            
            if (infoText == null)
            {
               infoText = "";
            }
            else
            {
               infoText = TextUtil.GetHtmlEscapedText (infoText);
               infoText = TextUtil.ParseWikiString (infoText);
            }
            
            if (infoText.length == 0)
            {
               mTextBitmap.bitmapData = null;
            }
            else
            {
               var textFiled:TextFieldEx;
               if (mAutofitWidth)
                  textFiled = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + infoText + "</font>", false, 0xFFFFFF, 0x0, true, displayHalfWidth * 2 - 10);
               else
                  textFiled = TextFieldEx.CreateTextField ("<font face='Verdana' size='10'>" + infoText + "</font>", false, 0xFFFFFF, 0x0);
               
               DisplayObjectUtil.CreateCacheDisplayObjectInBitmap (textFiled, mTextBitmap);
            }
            
            mTextBitmap.x = - 0.5 * mTextBitmap.width;
            mTextBitmap.y = - 0.5 * mTextBitmap.height;
         }
         
         
      }
      
   }
   
}
