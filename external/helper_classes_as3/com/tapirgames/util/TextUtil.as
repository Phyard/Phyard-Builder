
package com.tapirgames.util {
   
   import com.tapirgames.util.Logger;
   
   public class TextUtil
   {
      public static const TextPadding:Number = 5;
      
      public static const TextAlign_Left:int = 0;
      public static const TextAlign_Center:int = 1;
      public static const TextAlign_Right:int = 2;
      
      public static const TextAlign_Top:int = 0 << 4;
      public static const TextAlign_Middle:int = 1 << 4;
      public static const TextAlign_Bottom:int = 2 << 4;      
      
      public static const TextFlag_WordWrap:int   = 1 << 0;
      public static const TextFlag_Editable:int   = 1 << 1;
      public static const TextFlag_Selectable:int = 1 << 2;
      
      public static const TextFlag_AdaptiveBackgroundSize:int   = 1 << 0;
      public static const TextFlag_ClipText:int   = 1 << 1;
      
      public static const Shift_TextFormat:int = 4;
      public static const Mask_TextFormat:int = 0xF0;
      
      public static const TextFormat_Plain:int = 0;
      public static const TextFormat_Wiki:int = 1;
      public static const TextFormat_Html:int = 2;

      public static function GetTextAlignText (hAlign:int):String
      {
         hAlign = hAlign & 0x0F;
         
         if (hAlign == TextAlign_Right)
            return "right";
         else if (hAlign == TextAlign_Center)
            return "center";
         else
            return "left";
      }
      
      public static function Uint2ColorString (colorValue:uint):String
      {
         colorValue = colorValue & 0xFFFFFF;
         var colorString:String = colorValue.toString (16);
         while (colorString.length < 6)
            colorString = "0" + colorString;
         
         return "#" + colorString;
      }
      
      public static function GetHtmlWikiText (theText:String, textFormat:int, textAlign:String, fontSize:int = 16, fontColor:String = null, fontFace:String = null, bold:Boolean = false, italic:Boolean = false, underline:Boolean = false):String
      {
         if (fontFace == null)
            fontFace = "Verdana";
         
         var wikiText:String = theText;
         
         if (textFormat != TextFormat_Html)
         {
            wikiText = TextUtil.GetHtmlEscapedText (theText);
            if (textFormat == TextFormat_Wiki)
            {
               wikiText = TextUtil.ParseWikiString (wikiText);
            }
         }
         wikiText = TextUtil.CreateHtmlText (wikiText, fontSize, fontColor, fontFace, bold, italic, underline);
         wikiText = "<p align='" + textAlign + "'>" + wikiText + "</p>";
         
         return wikiText;
      }

      //fontFace:String = "Verdana"
      public static function CreateHtmlText (plainText:String, fontSize:int = 16, fontColor:String = null, fontFace:String = null, bold:Boolean = false, italic:Boolean = false, underline:Boolean = false):String
      {
         plainText = CreateHtmlText_biu (plainText, bold, italic, underline);
         
         return CreateHtmlText_Font (plainText, fontSize, fontColor, fontFace);
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
         //result = ParseBullets(result); 
         //result = ParseLinks(result);
         // since v2.04
         result = ParseLinks(result);
         result = ParseBullets(result); 
         
         //trace ("wikiString = " + wikiString);
         //trace ("result = " + result);
         
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
          var pattern:RegExp = /^\*(.*)([\r\n]|$)/gm; 
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
         
      //trace ("input = " + input);
         var startUrlPart:String = "([ \t\r\n\v\f]|^)"; 
         var protocol:String = "((?:http|https)://)"; 
         var urlPart:String = "([\x21-\x7E]+)"; 
         var endUrlPart:String = "([ \<\t\r\n\v\f]|$)"; 
         var urlPattern:RegExp = new RegExp(startUrlPart + protocol + urlPart + endUrlPart, "ig");
         //var output:String = input.replace(urlPattern, "$1<font color='#0000FF'><a href='$2$3' target='_blank'><u>$2$3</u></a></font>$4");
         var output:String = input.replace(urlPattern, RegReplace);
      //trace ("output = " + output);
         
         return output;
      }
      
      private static function RegReplace ():String
      {
trace ("arguments = " + arguments);
trace ("        1 = " + arguments [1]);
trace ("        2 = " + arguments [2]);
trace ("        3 = " + arguments [3]);
trace ("        4 = " + arguments [4]);
         var url:String = arguments[2] + arguments[3];
         var endPart:String = arguments[4];
         var lastChar:String = url.charAt (url.length - 1);
         if (lastChar == "." || lastChar == ",")
         {
            endPart = lastChar + endPart;
            url = url.substring (0, url.length - 1);
         }
         
         return arguments[1] + "<font color='#0000FF'><a href='" + url + "' target='_blank'><u>" + url + "</u></a></font>" + endPart;
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