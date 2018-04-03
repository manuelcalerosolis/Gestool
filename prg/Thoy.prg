#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS THoy

   DATA nLevel
   DATA aAvisos
   DATA lShowInit
   DATA oFacCliP
   DATA dHoy
   DATA oBrw
   DATA oAnimation

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD Resource( nMode )

   METHOD GetInformation()

   METHOD AddItem( cItem, nImporte, dFecha )

   METHOD AddGroup( cGrupo )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem ) CLASS THoy

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := 0
   end if

   ::aAvisos            := {}

   ::lShowInit          := .f.
   ::dHoy               := Date()

   /*
   Cerramos todas las ventanas
   */

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS THoy

   ::oFacCliP := TDataCenter():oFacCliP()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD CloseFiles() CLASS THoy

   ::oFacCliP:End()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS THoy

	local oDlg
   local oGet

   ::OpenFiles()

   DEFINE DIALOG oDlg RESOURCE "Hoy" TITLE "Hoy : " + Dtoc( Date() )

   REDEFINE LISTBOX ::oBrw ;
         FIELDS   "" ;
         HEAD     "" ;
         ID       100 ;
         OF       oDlg

   ::oBrw:nLineHeight      := 20
   ::oBrw:lDrawHeaders     := .f.
   ::oBrw:nLineStyle       := 0

   REDEFINE CHECKBOX ::lShowInit ;
         ID       110 ;
         OF       oDlg

   ::oAnimation   := TAnimat():Redefine( oDlg, 120, { "BAR_01" }, 1 )

   REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( HtmlHelp( "Hoy" ) )

   oDlg:bStart := {|| ::GetInformation() }

	ACTIVATE DIALOG oDlg	CENTER

   ::CloseFiles()

   ::oAnimation:Stop()

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD GetInformation() CLASS THoy

   ::aAvisos   := {}

   ::AddGroup( "Vencimiento de recibos" )

   ::oFacCliP:GoTop()
   while !::oFacCliP:Eof()

      if ::dHoy < ::oFacCliP:dFecVto .and. !::oFacCliP:lCobrado
         ::AddItem( ::oFacCliP:cDescrip, ::oFacCliP:nImporte, ::oFacCliP:dFecVto )
      end if

      ::oFacCliP:Skip()

   end while

   ::oAnimation:Stop()

   ::oBrw:bLine            := { || { ::aAvisos[ ::oBrw:nAt, 1 ], ::aAvisos[ ::oBrw:nAt, 3 ], ::aAvisos[ ::oBrw:nAt, 2 ],  } }
   ::oBrw:aJustify         := { .f., .f., .t. }
   ::oBrw:aColSizes        := { 220, 80, 80 }
   ::oBrw:nClrPane         := {|| if( ::aAvisos[ ::oBrw:nAt, 4 ], Rgb( 236, 233, 216 ), Rgb( 255, 255, 255 ) ) }
   ::oBrw:SetArray( ::aAvisos )

   ::oBrw:Refresh()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD AddItem( cItem, nImporte, dFecha )

   aAdd( ::aAvisos, { cItem, Trans( nImporte, "@E 999,999" ), Dtoc( dFecha ), .f., {|| msginfo( "Item" ) } } )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD AddGroup( cGrupo )

   aAdd( ::aAvisos, { cGrupo, "", "", .t., {|| nil } } )

RETURN ( Self )

//--------------------------------------------------------------------------//

FUNCTION Hoy( oMenuItem, oWnd )

   local oGrpFam

   DEFAULT  oMenuItem   := "01011"
   DEFAULT  oWnd        := oWnd()

   oGrpFam  := THoy():New()
   oGrpFam:Resource()

RETURN NIL

//--------------------------------------------------------------------------//