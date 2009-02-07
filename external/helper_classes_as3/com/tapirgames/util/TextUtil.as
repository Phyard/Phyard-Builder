
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
      
      public static function GetHtmlEscapedText (htmlText:String):String
      {
         if (htmlText == null)
            return "";
         
         htmlText = htmlText.replace (/</g, "&lt;");
         htmlText = htmlText.replace (/>/g, "&gt;");
         
         return htmlText;
      }
      
      // the folliwong is copied from http://help.adobe.com/en_US/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7e94.html
      
      public static function ParseWikiString (wikiString:String):String
      {
         var result:String = wikiString; 
         result = ParseBoldItalic(result); 
         result = ParseBold(result); 
         result = ParseItalic(result); 
         result = ParseBullets(result); 
         result = ParseLinks(result); 
         
         trace ("wikiString = " + wikiString);
         trace ("result = " + result);
         
         return result; 
      }
      
      private static function ParseBoldItalic(input:String):String 
      {
          var pattern:RegExp = /'''''(.*?)'''''/g; 
          return input.replace(pattern, "<b><i>$1</i></b>"); 
      }
      
      private static function ParseBold(input:String):String 
      {
          var pattern:RegExp = /'''(.*?)'''/g; 
          return input.replace(pattern, "<b>$1</b>"); 
      }
      
      private static function ParseItalic(input:String):String 
      {
          var pattern:RegExp = /''(.*?)''/g; 
          return input.replace(pattern, "<i>$1</i>"); 
      }
      
      private static function ParseBullets(input:String):String 
      { 
          var pattern:RegExp = /^\*(.*)/gm; 
          //return input.replace(pattern, "<li>$1</li>"); 
          return input.replace(pattern, TrimBulletsTextBeginningSpaces); 
      }
      
      private static function TrimBulletsTextBeginningSpaces ():String
      {
         return "<li>" + TrimFrontString (arguments[1]) + "</li>";
      }
      
      private static function ParseLinks(input:String):String 
      {
         //var protocol:String = "((?:http|ftp)://)"; 
         //var urlPart:String = "([a-z0-9_-]+\.[a-z0-9_-]+)"; 
         //var optionalUrlPart:String = "(\.[a-z0-9_-]*)"; 
         //var urlPattern:RegExp = new RegExp(protocol + urlPart + optionalUrlPart, "ig");
         //return input.replace(urlPattern, "<font color='#0000FF'><a href='$1$2$3'><u>$1$2$3</u></a></font>");
         
         var protocol:String = "((?:http|https)://)"; 
         var urlPart:String = "([\x21-\x7E]+)"; 
         var optionalUrlPart:String = "([ \t\r\n\v\f])"; 
         var urlPattern:RegExp = new RegExp(protocol + urlPart + optionalUrlPart, "ig");
         return input.replace(urlPattern, "<font color='#0000FF'><a href='$1$2' target='_blank'><u>$1$2</u></a></font>$3");
      }
      
      // the following is copied from adobe website, url is forgetten
      
      public static function ReplaceString (str:String, oldSubStr:String, newSubStr:String):String {
        return str.split(oldSubStr).join(newSubStr);
      }

      public static function TrimString (str:String, char:String = " "):String {
        return TrimBackString(TrimFrontString(str, char), char);
      }

      public static function TrimFrontString(str:String, char:String = " "):String {
        char = stringToCharacter(char);
        if (str.charAt(0) == char) {
            str = TrimFrontString(str.substring(1), char);
        }
        return str;
      }

      public static function TrimBackString (str:String, char:String = " "):String {
        char = stringToCharacter(char);
        if (str.charAt(str.length - 1) == char) {
            str = TrimBackString(str.substring(0, str.length - 1), char);
        }
        return str;
      }
      
      private static function stringToCharacter(str:String):String {
         if (str.length == 1) {
            return str;
         }
         return str.slice(0, 1);
      }
      
   }
}