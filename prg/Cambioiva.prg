#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TConversionDocumentos

   DATA oDlg
   DATA oFld

   DATA oBtnAnterior
   DATA oBtnSiguiente
   DATA oBtnSalir

   DATA nView

   METHOD Create()
      METHOD OpenFiles()
      METHOD CloseFiles()

   METHOD BotonSiguiente()
   METHOD BotonAnterior()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Create() 

   local oBmp

   if !::OpenFiles()
      Return nil
   end if

   DEFINE DIALOG ::oDlg RESOURCE "ASS_CONVERSION_DOCUMENTO"

   REDEFINE BITMAP oBmp ;
      ID       500 ;
      RESOURCE "hand_point_48" ;
      TRANSPARENT ;
      OF       ::oDlg

   REDEFINE PAGES ::oFld ;
      ID       100;
      OF       ::oDlg ;
      DIALOGS  "ASS_CONVERSION_DOCUMENTO_1",;
               "ASS_CONVERSION_DOCUMENTO_2"

   REDEFINE COMBOBOX aGet[ ( D():Articulos( nView ) )->( fieldpos( "nTipDur" ) ) ];
      VAR      aTmp[ ( D():Articulos( nView ) )->( fieldpos( "nTipDur" ) ) ];
      ITEMS    { "Compras" };
      ID       251 ;
      OF       ::oFld:aDialogs[1]


   REDEFINE BUTTON ::oBtnAnterior;
      ID       3 ;
      OF       ::oDlg ;
      ACTION   ( ::BotonAnterior() )

   REDEFINE BUTTON ::oBtnSiguiente;
      ID       IDOK ;
      OF       ::oDlg ;
      ACTION   ( ::BotonSiguiente() )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       ::oDlg ;
      ACTION   ( ::oDlg:End() )

   // ::oDlg:bStart := {|| ::oBtnInforme:Disable() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::CloseFiles()

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

Method BotonSiguiente()

   ::oFld:goNext()

return ( Self )

//---------------------------------------------------------------------------//

Method BotonAnterior()

   ::oFld:goPrev()

return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::nView           := D():CreateView()

   RECOVER USING oError

      lOpen             := .f.
      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   D():CloseView( ::nView )

Return ( Self )

//---------------------------------------------------------------------------//

