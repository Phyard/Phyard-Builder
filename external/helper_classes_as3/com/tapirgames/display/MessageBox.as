
package com.tapirgames.display {
   
   
   public class MessageBox extends Dialog 
   {
      protected var mTextFieldEx:TextFieldEx;
      
      public function MessageBox (msg:String, showClose:Boolean = true)
      {
         mTextFieldEx = new TextFieldEx ();
         mTextFieldEx.htmlText = msg;
         mTextFieldEx.background = false;
         
         super (mTextFieldEx, showClose);
         
         Rebuild ();
      }
   }
}
