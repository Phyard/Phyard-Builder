package com.tapirgames.util {
   
   import flash.net.navigateToURL;
   import flash.net.URLRequest;
   
   public class UrlUtil 
   {
      
      public static function GetFullFilePath (filePath:String, relativeTo:String):String
      {
         // to do
         return filePath;
      }
      
      public static function CheckDomainValidity (domain:String, validDomainsList:Array):Boolean
      {
         if (validDomainsList == null || validDomainsList.length == 0)
            return true;
         
         if (domain == null)
            return true;
         
         if ( IsLocalDomain (domain) )
            return true;
         
         var valid:Boolean = false;
         for (var domID:int = 0; domID < validDomainsList.length; ++ domID)
         {
            if (validDomainsList [domID] is String)
            {
               var validDomain:String = (validDomainsList [domID] as String).toLowerCase ();
               if (domain == validDomain)
               {
                  valid = true;
                  break;
               }
            }
         }
         
         return valid;
      }
      
      public static function CheckUrlValidity (url:String, validDomainsList:Array):Boolean
      {
         var domain:String = RetrieveDomainFromUrl (url);
         
         return CheckDomainValidity (domain, validDomainsList);
      }
      
      public static function RetrieveDomainFromUrl (url:String):String
      {
         if (url == null)
            return null;
         
         url = url.toLowerCase ();
         
         var urlStart:int = url.indexOf("://") + 3;
         
         if (urlStart < 0)
            return null;
         
         var urlEnd:int = url.indexOf("/", urlStart);
         if (urlEnd < 0)
            urlEnd = url.length;
         
         var domain:String = url.substring(urlStart, urlEnd);
         
         if ( IsLocalDomain (domain) )
         {
            return domain;
         }
         
         var lastDot:int = domain.lastIndexOf(".") - 1;
         
         if (lastDot < 0)
            return null;
         
         var domStart:int = domain.lastIndexOf(".", lastDot) + 1;
         domain = domain.substring(domStart, domain.length);
         
         return domain;
      }
      
      public static function IsLocalDomain (domain:String):Boolean
      {
         if (domain == "localhost" || domain == "127.0.0.1")
            return true;
         
         return false;
      }
      
      public static function GetRootUrl (url:String):String
      {
         if (url == null)
            return null;
         
         url = url.toLowerCase ();
         
         var urlStart:int = url.indexOf("://") + 3;
         
         if (urlStart < 0)
            return null;
         
         var urlEnd:int = url.indexOf("/", urlStart);
         if (urlEnd < 0)
            return url + "/"
         else
            return url.substring(0, urlEnd + 1);
      }
      
//==============================================================================
//
//==============================================================================
      
      public static function PopupPage (url:String):void
      {
         var request:URLRequest = new URLRequest(url);
         try {            
             navigateToURL(request, "_blank"); // "MathSolitaireSolutions"
         }
         catch (e:Error) {
             Logger.Trace ("navigateToURL error.");
         }
      }
      
      
   }
}