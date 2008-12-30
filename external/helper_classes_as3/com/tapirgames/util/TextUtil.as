
package com.tapirgames.util {
   
   
   import com.tapirgames.util.Logger;
   
   public class TextUtil {
      
      public static function CreateHtmlText (plainText:String, fontSize:int = 16, fontColor:String = "#000000", fontFace:String = "Verdana", bold:Boolean = false, italic:Boolean = false, underline:Boolean = false):String
      {
         plainText = CreateHtmlText_biu (plainText, bold, italic, underline);
         
         return CreateHtmlText_Font (plainText, fontSize, fontColor, fontFace);
         
         if (fontColor != null)
            return "<font face=\"" + fontFace + "\" size=\"" + fontSize + "\" color=\"" + fontColor + "\">" + plainText + "</font>";
         else
            return "<font face=\"" + fontFace + "\" size=\"" + fontSize + "\">" + plainText + "</font>";
      }
      
      public static function CreateHtmlText_biu (text:String, bold:Boolean = false, italic:Boolean = false, underline:Boolean = false):String
      {
         if (bold)
            text = "<b>" + text + "</b>";
         if (italic)
            text = "<i>" + text + "</i>";
         if (underline)
            text = "<u>" + text + "</u>";
         
         return text;
      }
      
      public static function CreateHtmlText_Link (text:String, url:String, targetWindow:String="_blank"):String
      {
         if (targetWindow == null)
            targetWindow = "_self";
            
         return "<a href=\"" + url + "\" target=\"" + targetWindow + "\">" + text + "</a>";
      }
      
      public static function CreateHtmlText_Font (text:String, fontSize:int = 16, fontColor:String = null, fontFace:String = "Verdana"):String
      {
         var newText:String = "<font";
         
         if (fontSize > 0)
            newText = newText + " size=\"" + fontSize + "\"";
         
         if (fontColor != null)
            newText = newText + " color=\"" + fontColor + "\"";
         
         if (fontFace != null)
            newText = newText + " face=\"" + fontFace + "\"";
         
         return newText + ">" + text + "</font>";
      
      }

   }
}