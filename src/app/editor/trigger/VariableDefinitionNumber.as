package editor.trigger {
   
   import mx.core.UIComponent;
   import mx.controls.TextInput;
   import mx.controls.ComboBox;
   
   import editor.world.World;
   
   import editor.world.DataUtil;
   
   import editor.entity.Scene;
   
   import com.tapirgames.util.TextUtil;
   
   import common.trigger.CoreClassIds;
   
   public class VariableDefinitionNumber extends VariableDefinition_Core
   {
      
   //========================================================================================================
   //
   //========================================================================================================
      
      //protected var mDefaultValue:Number = 0.0;
      //protected var mMinValue:Number = - Number.MAX_VALUE;
      //protected var mMaxValue:Number = Number.MAX_VALUE;
      //
      //internal var mIsColorValue:Boolean = false;
      //
      //protected var mValueLists:Array = null;
      
      public function VariableDefinitionNumber (name:String, description:String = null, options:Object = null)
      {
         super (World.GetCoreClassById (CoreClassIds.ValueType_Number), name, description, options);
         
         //if (options != null)
         //{
         //   if (options.mMinValue != undefined)
         //      mMinValue = Number (options.mMinValue);
         //   if (options.mMaxValue != undefined)
         //      mMaxValue = Number (options.mMaxValue);
         //   if (options.mDefaultValue != undefined)
         //      mDefaultValue = Number (options.mDefaultValue);
         //   if (options.mIsColorValue != undefined)
         //      mIsColorValue = Boolean (options.mIsColorValue);
         //   if (options.mValueLists != undefined)
         //      mValueLists = options.mValueLists as Array;
         //   
         //   if (mMinValue > mMaxValue)
         //   {
         //      var tempValue:Number = mMaxValue;
         //      mMaxValue = mMinValue;
         //      mMinValue = tempValue;
         //   }
         //}
      }
      
      //override public function SetDefaultValue (valueObject:Object):void
      //{
      //   mDefaultValue = Number (valueObject);
      //}
      
      //public function GetDefaultValue ():Number
      //{
      //   return mDefaultValue;
      //}
      
      //protected function ValidateValue (value:Number):Number
      //{
      //   if (isNaN (value))
      //      value = mDefaultValue;
      //   
      //   if (value < mMinValue)
      //      value = mMinValue;
      //   if (value > mMaxValue)
      //      value = mMaxValue;
      //   
      //   return value;
      //}
      
      public function IsColorValue ():Boolean
      {
         return mOptions.mIsColorValue;
      }
      
//==============================================================================
// clone
//==============================================================================
      
      override public function Clone ():VariableDefinition
      {
         return new VariableDefinitionNumber (mName, mDescription, mOptions);
      }
      
//==============================================================================
// to override
//==============================================================================
      
      override public function GetDefaultDirectValueSource ():ValueSource_Direct
      {
         return new ValueSource_Direct (mDefaultValueObject);
      }
      
      override public function CreateControlForDirectValueSource (scene:Scene, valueSourceDirect:ValueSource_Direct, isForPureCustomFunction:Boolean):UIComponent
      {
         var directValue:Number = Number (valueSourceDirect.GetValueObject ());
         
         if (mOptions.mValueLists != null)
         {
            var combo_box:ComboBox = new ComboBox ();
            
            combo_box.dataProvider = DataUtil.GetListWithDataInLabel (mOptions.mValueLists as Array);
            combo_box.selectedIndex = DataUtil.SelectedValue2SelectedIndex (mOptions.mValueLists as Array, directValue);
            combo_box.rowCount = 11;
            
            return combo_box;
         }
         else 
         {
            var text_input:TextInput = new TextInput ();
            
            if (IsColorValue ())
            {
               var text:String = (int (directValue) & 0xFFFFFF).toString (16);
               while (text.length < 6)
                  text = "0" + text;
               
               text_input.text = "0x" + text.toUpperCase ();
            }
            else
            {
               text_input.text = (parseFloat (directValue.toFixed (12))).toString ();
            }
            
            return text_input;
         }
      }
      
      override public function RetrieveDirectValueSourceFromControl (scene:Scene, valueSourceDirect:ValueSource_Direct, control:UIComponent/*, triggerEngine:TriggerEngine*/):ValueSource
      {
         var value:Number = mDefaultValueObject as Number;
         
         if (mOptions.mValueLists != null)
         {
            if (control is ComboBox)
            {
               var combo_box:ComboBox = control as ComboBox;
               
               if (combo_box.selectedItem != null)
                  value = combo_box.selectedItem.data;
            }
         }
         else 
         {
            if (control is TextInput)
            {
               var text_input:TextInput = control as TextInput;
               var text:String = text_input.text;
               text = TextUtil.TrimString (text);
               
               if (text.length > 2 && text.substr (0, 2).toLowerCase() == "0x")
               {
                  value = parseInt (text.substr (2), 16);
               }
               // register variables are disabled now
               //else if (text.length > 1 && text.substr (0, 1).toLowerCase() == "#")
               //{
               //   value = parseInt (text.substr (1));
               //   if (isNaN (value))
               //   {
               //      value = mDefaultValue;
               //   }
               //   else
               //   {
               //      var vi:VariableInstance = triggerEngine.GetRegisterVariableSpace (CoreClassIds.ValueType_Number).GetVariableInstanceAt (value);
               //      return new ValueSource_Variable (vi);
               //   }
               //}
               else
               {
                  value = parseFloat (text);
               }
            }
         }
         
         //value = ValidateValue (value);
         value = ValidateDirectValueObject (value) as Number;
         
         valueSourceDirect.SetValueObject (value);
         
         return null;
      }
   }
}

