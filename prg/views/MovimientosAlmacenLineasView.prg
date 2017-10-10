#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasView FROM SQLBaseView

   DATA oGetCodigoArticulo
   DATA oGetNombreArticulo

   METHOD New()

   METHOD Dialog()

   METHOD stampArticulo()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName      := "gc_bookmarks_16"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oBtn

   DEFINE DIALOG oDlg RESOURCE "LMovAlm" TITLE ::lblTitle() + "lineas de movimientos de almacén"

      REDEFINE GET   ::oGetCodigoArticulo ;
         VAR         ::oController:oModel:hBuffer[ "codigo_articulo" ] ;
         ID          100 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          oDlg

      ::oGetCodigoArticulo:bValid   := {|| if( ::oController:validate( "codigo_articulo" ), ::stampArticulo(), .f. ) }
      ::oGetCodigoArticulo:bHelp    := {|| brwArticulo( ::oGetCodigoArticulo ) }

      REDEFINE GET   ::oGetNombreArticulo ;
         VAR         ::oController:oModel:hBuffer[ "nombre_articulo" ] ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          oDlg

      REDEFINE GET   ::oGetLote ;
         VAR         ::oController:oModel:hBuffer[ "lote" ] ;
         ID          150 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          oDlg

      REDEFINE BUTTON oBtn;
         ID          510 ;
         OF          oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID          520 ;
         OF          oDlg ;
         ACTION      ( oDlg:end() )

      if ::oController:isNotZoomMode()
         oDlg:AddFastKey( VK_F5, {|| oBtn:Click() } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD stampArticulo()

   local cAreaArticulo
   local cCodigoArticulo

   cCodigoArticulo   := ::oController:oModel:hBuffer[ "codigo_articulo" ]

   if empty( cCodigoArticulo )
      RETURN ( .t. )
   end if 

   cAreaArticulo   := ArticulosModel():get( cCodigoArticulo )
   if empty( cAreaArticulo )
      RETURN ( .t. )
   end if 

   ::oGetNombreArticulo:cText( ( cAreaArticulo )->Nombre )
   ::oGetLoteArticulo:cText( ( cAreaArticulo )->cLote )

RETURN ( .t. )

//---------------------------------------------------------------------------//


