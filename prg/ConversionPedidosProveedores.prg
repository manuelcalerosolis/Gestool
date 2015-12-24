#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TConversionPedidosProveedores FROM TConversionDocumentos // FROM DialogBuilder

   DATA cCodigoProveedor                              INIT "000278      "

   METHOD Dialog()

   METHOD setCodigoProveedor( cCodigoProveedor )      INLINE ( ::cCodigoProveedor := cCodigoProveedor )
   METHOD getCodigoProveedor()                        INLINE ( ::cCodigoProveedor )

   METHOD startDialog()

   METHOD loadLinesDocument()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Dialog() 

   local oBmp

   DEFINE DIALOG ::oDlg ;
      RESOURCE    "ASS_CONVERSION_DOCUMENTO"

   REDEFINE BITMAP oBmp ;
      ID          500 ;
      RESOURCE    "hand_point_48" ;
      TRANSPARENT ;
      OF          ::oDlg

   REDEFINE PAGES ::oFld ;
      ID          100 ;
      OF          ::oDlg ;
      DIALOGS     "ASS_CONVERSION_DOCUMENTO_3"

   ::DialogSelectionLines( ::oFld:aDialogs[1] )
   
   // Botones -----------------------------------------------------------------

   REDEFINE BUTTON ::oBtnAnterior;
      ID          3 ;
      OF          ::oDlg ;
      ACTION      ( ::BotonAnterior() )

   REDEFINE BUTTON ::oBtnSiguiente;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::BotonSiguiente() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:End() )

   ::oDlg:bStart  := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::CloseFiles()

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD startDialog()

   ::oBrwLines:Load()

   ::loadLinesDocument()

   ::setBrowseLinesDocument()

RETURN ( Self )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

METHOD loadLinesDocument() 

   local hDictionary    

   if empty( ::getCodigoProveedor() )
      msgStop( "Es necesario codificar un proveedor." )
      Return .f.
   end if 

   ::oDocumentLines:reset()

   ( ::getHeaderAlias() )->( ordsetfocus( "cCodPrv" ) )

   if ( ::getHeaderAlias() )->( dbseek( ::getCodigoProveedor() ) )

      while ( ::getHeaderAlias() )->cCodPrv == ::getCodigoProveedor() .and. !::getHeaderEof() // 

         if ( ( ::getHeaderAlias() )->nEstado != 3 ) .and. ( ::getLineAlias() )->( dbSeek( ::getHeaderId() ) )

            while ::getHeaderId() == ::aliasDocumentLine:getDocumentId() .and. !::aliasDocumentLine:Eof()

               // if nTotNPedPrv( ::getLineAlias() ) > nUnidadesRecibidasPedPrv( ::getLineId(), ::getLineProductId(), cValPr1, cValPr2, cRefPrv, cAlbPrvL )

               hDictionary       := D():getHashFromAlias( ::getLineAlias(), ::getLineDictionary() )

               ::oDocumentLines:addLines( DocumentLine():newFromDictionary( self, hDictionary ) )

               ( ::getLineAlias() )->( dbskip() ) 

            end while

         end if 

         ( ::getHeaderAlias() )->( dbSkip() )

      end while

   end if 

RETURN ( .t. ) 

//---------------------------------------------------------------------------//
