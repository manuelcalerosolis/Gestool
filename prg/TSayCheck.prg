#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS TSayCheck FROM TCheckBox

   DATA oSay
   
   METHOD Redefine( idSay, idCheck, oDialog )
   
   METHOD Hide()

   METHOD Show()

END CLASS

//---------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, bChange, bValid, nClrFore,;
                 nClrBack, cMsg, lUpdate, bWhen, cPrompt, nIdSay ) CLASS TSayCheck

   ::Super:ReDefine( nId, bSetGet, oWnd, nHelpId, bChange, bValid, nClrFore,;
                     nClrBack, cMsg, lUpdate, bWhen, cPrompt )

   if !empty( nIdSay )
      ::oSay               := TSay():ReDefine( nIdSay, nil, oWnd )
      ::oSay:lWantClick    := .t.
      ::oSay:bLClicked     := {|| if( ::lWhen(), ::Click(), )  }
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Hide() CLASS TSayCheck

   if ::oSay != nil
      ::oSay:Hide()
   end if 

RETURN ( ::Super:Hide() )

//---------------------------------------------------------------------------//

METHOD Show() CLASS TSayCheck
   
   if ::oSay != nil
      ::oSay:Show()
   end if 
   
RETURN ( ::Super:Show() )

//---------------------------------------------------------------------------//