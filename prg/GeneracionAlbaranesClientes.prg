#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TGeneracionAlbaranesClientes FROM TConversionDocumentos 

   DATA oAlmacen

   METHOD Dialog()

   METHOD DialogSelectionCriteria( oDlg )
   METHOD isDialogSelectionCriteria( oDlg )

   METHOD isHeadersConditions()
   METHOD isLineConditions()

   METHOD startDialog()
      METHOD botonSiguiente()

   METHOD loadLinesDocument()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Dialog() 

   local oBmp

   DEFINE DIALOG  ::oDlg ;
      RESOURCE    "ASS_CONVERSION_DOCUMENTO"

   REDEFINE BITMAP oBmp ;
      ID          500 ;
      RESOURCE    "hand_point_48" ;
      TRANSPARENT ;
      OF          ::oDlg

   REDEFINE PAGES ::oFld ;
      ID          100 ;
      OF          ::oDlg ;
      DIALOGS     "ASS_CONVERSION_DOCUMENTO_5",;
                  "ASS_CONVERSION_DOCUMENTO_3"

   ::DialogSelectionCriteria( ::oFld:aDialogs[1] )
   
   // Botones -----------------------------------------------------------------

   REDEFINE BUTTON ::oBtnAnterior;
      ID          3 ;
      OF          ::oDlg ;
      ACTION      ( ::BotonAnterior() )

   REDEFINE BUTTON ::oBtnSiguiente;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::botonSiguiente() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:End() )

   ::oDlg:bStart  := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::CloseFiles()

   oBmp:End()

RETURN ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD DialogSelectionCriteria( oDlg )

   ::oPeriodo     := GetPeriodo()
      ::oPeriodo:New( 110, 120, 130 )
      ::oPeriodo:Resource( oDlg )

   ::oCliente     := GetCliente()
      ::oCliente:New( 140, 141, 142 )
      ::oCliente:Resource( oDlg )
      ::oCliente:setView( ::nView )

   ::oArticulo    := GetArticulo()
      ::oArticulo:New( 200, 201, 202 )
      ::oArticulo:Resource( oDlg )
      ::oArticulo:setView( ::nView )

   ::oAlmacen     := GetAlmacen()
      ::oAlmacen:New( 210, 211, 212 )
      ::oAlmacen:Resource( oDlg )
      ::oAlmacen:setView( ::nView )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD startDialog()

   ::oAlmacen:cText( cDefAlm() )
   ::oAlmacen:Valid()

   ::setDocumentPedidosClientes()

   ::oBtnAnterior:Hide()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD isDialogSelectionCriteria()

   if empty( ::oAlmacen:Varget() )
      msgStop( "Código de almcén no puede estar vacio.")
      Return .f.
   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD botonSiguiente()

   if ::isDialogSelectionCriteria()
      Return .f.
   end if 

   if !::oDocumentLines:anySelect()
      msgStop( "No hay líneas seleccionadas." )
   else
      ::oDlg:End( IDOK )
   end if

Return ( Self )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

METHOD isHeadersConditions()

   if !::oPeriodo:inRange( ( ::getHeaderAlias() )->dFecPed )
      Return .f.
   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD isLineConditions()

   if empty( ::oArticulo:Value() )
      Return .t.
   end if

Return ( ::aliasDocumentLine:getCode() == ::oArticulo:Value() )

//---------------------------------------------------------------------------//

METHOD loadLinesDocument() 

   local oDocumentLine

   ::oDocumentLines:reset()

   ( ::getHeaderAlias() )->( ordsetfocus( "dFecPed" ) )

   while ( ::getHeaderAlias() )->dFecPed <= ::oPeriodo:getFechaFin() .and. !::getHeaderEof() // 

      if ::isHeadersConditions() .and. ;
         ( ::getLineAlias() )->( dbSeek( ::getHeaderId() ) )

         while ::getHeaderId() == ::aliasDocumentLine:getDocumentId() .and. !::aliasDocumentLine:Eof()

            oDocumentLine     := ClientDeliveryNoteDocumentLine():newBuildDictionary( self )

            if oDocumentLine:getUnitsAwaitingProvided() > 0
               ::oDocumentLines:addLines( oDocumentLine )
            end if 

            ( ::getLineAlias() )->( dbskip() ) 

         end while

      end if 

      ( ::getHeaderAlias() )->( dbSkip() )

   end while

RETURN ( .t. ) 

//---------------------------------------------------------------------------//