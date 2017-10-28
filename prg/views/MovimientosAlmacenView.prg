#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenView FROM SQLBaseView

   DATA oDialog

   DATA oSQLBrowseView

   DATA oGetDivisa
   DATA oGetAgente
   DATA oGetAlmacenOrigen
   DATA oGetAlmacenDestino
   DATA oGetGrupoMovimiento
   DATA oRadioTipoMovimento

   METHOD New()

   METHOD Dialog()
   METHOD startDialog()

   METHOD changeTipoMovimiento()    INLINE   (  iif(  ::oRadioTipoMovimento:nOption() == __tipo_movimiento_entre_almacenes__,;
                                                      ::oGetAlmacenOrigen:Show(),;
                                                      ::oGetAlmacenOrigen:Hide() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName      := "gc_bookmarks_16"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oBtnOk
   local oBtnEdit
   local oBtnAppend
   local oBtnDelete
   local oBmpGeneral

   DEFINE DIALOG ::oDialog RESOURCE "RemMov" TITLE ::lblTitle() + "movimientos de almacén"

      REDEFINE BITMAP oBmpGeneral ;
        ID           990 ;
        RESOURCE     "gc_package_pencil_48" ;
        TRANSPARENT ;
        OF           ::oDialog

      REDEFINE GET   ::oController:oModel:hBuffer[ "delegacion" ] ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora" ] ;
         ID          120 ;
         PICTURE     "@DT" ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      REDEFINE GET   ::oController:oModel:hBuffer[ "usuario" ] ;
         ID          220 ;
         PICTURE     "XXX" ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE RADIO ::oRadioTipoMovimento ;
         VAR         ::oController:oModel:hBuffer[ "tipo_movimiento" ] ;
         ID          130, 131, 132, 133 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ON CHANGE   ( ::changeTipoMovimiento() ) ;
         OF          ::oDialog

      REDEFINE GET   ::oGetAlmacenOrigen ;
         VAR         ::oController:oModel:hBuffer[ "almacen_origen" ] ;
         ID          150 ;
         IDHELP      151 ;
         IDSAY       152 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDialog

      ::oGetAlmacenOrigen:bValid   := {|| ::oController:validateAlmacenOrigen() }
      ::oGetAlmacenOrigen:bHelp    := {|| brwAlmacen( ::oGetAlmacenOrigen, ::oGetAlmacenOrigen:oHelpText ) }

      REDEFINE GET   ::oGetAlmacenDestino ;
         VAR         ::oController:oModel:hBuffer[ "almacen_destino" ] ;
         ID          160 ;
         IDHELP      161 ;
         IDSAY       162 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDialog

      ::oGetAlmacenDestino:bValid   := {|| ::oController:validateAlmacenDestino() }
      ::oGetAlmacenDestino:bHelp    := {|| brwAlmacen( ::oGetAlmacenDestino, ::oGetAlmacenDestino:oHelpText ) }

      REDEFINE GET   ::oGetGrupoMovimiento ;
         VAR         ::oController:oModel:hBuffer[ "grupo_movimiento" ] ;
         ID          140 ;
         IDHELP      141 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDialog

      ::oGetGrupoMovimiento:bValid   := {|| ::oController:validateGrupoMovimiento() }
      ::oGetGrupoMovimiento:bHelp    := {|| browseGruposMovimientos( ::oGetGrupoMovimiento, ::oGetGrupoMovimiento:oHelpText ) }

      REDEFINE GET   ::oGetAgente ;
         VAR         ::oController:oModel:hBuffer[ "agente" ] ;
         ID          210 ;
         IDHELP      211 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDialog

      ::oGetAgente:bValid := {|| ::oController:validateAgente() }
      ::oGetAgente:bHelp  := {|| BrwAgentes( ::oGetAgente, ::oGetAgente:oHelpText ) }

      // Divisas-------------------------------------------------------

      DivisasView();
         :New( ::oController );
         :CreateEditControl( { "idGet" => 190, "idBmp" => 191, "idValue" => 192, "dialog" => ::oDialog } )

      // Comentarios-------------------------------------------------------

      REDEFINE GET   ::oController:oModel:hBuffer[ "comentarios" ] ;
         ID          170 ;
         MEMO ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      // Buttons lineas-------------------------------------------------------

      REDEFINE BUTTON oBtnAppend ;
         ID          500 ;
         OF          ::oDialog ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Append(), ::oSQLBrowseView:Refresh() )

      REDEFINE BUTTON oBtnEdit ;
         ID          501 ;
         OF          ::oDialog ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Edit(), ::oSQLBrowseView:Refresh() )

      REDEFINE BUTTON oBtnDelete ;
         ID          502 ;
         OF          ::oDialog ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Delete( ::oSQLBrowseView:getBrowseSelected() ), ::oSQLBrowseView:Refresh() )

      REDEFINE BUTTON ;
         ID          503 ;
         OF          ::oDialog ;
         ACTION      ( ::oController:oLineasController:Search() )

      REDEFINE BUTTON ;
         ID          509 ;
         OF          ::oDialog ;
         ACTION      ( ::oController:oImportadorController:Activate() )

      // Browse lineas--------------------------------------------------------- 

      ::oSQLBrowseView              := SQLBrowseViewDialog():New( Self )

      ::oSQLBrowseView:setController( ::oController:oLineasController )

      ::oSQLBrowseView:Activate( 180, ::oDialog )

      ::oSQLBrowseView:setView()

      // Buttons---------------------------------------------------------------

      REDEFINE BUTTON oBtnOk ;
         ID          IDOK ;
         OF          ::oDialog ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
         CANCEL ;
         ACTION      ( ::oDialog:End() )

      if ::oController:isNotZoomMode()
         ::oDialog:AddFastKey( VK_F5, {|| oBtnOk:Click() } )
         ::oDialog:AddFastKey( VK_F2, {|| oBtnAppend:Click() } )
         ::oDialog:AddFastKey( VK_F3, {|| oBtnEdit:Click() } )
         ::oDialog:AddFastKey( VK_F4, {|| oBtnDelete:Click() } )
      end if

      ::oDialog:bStart    := {|| ::startDialog() }

   ::oDialog:Activate( , , , .t. ) 

   oBmpGeneral:End()

RETURN ( ::oDialog:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD startDialog()
   
   ::changeTipoMovimiento()

   ::oController:stampAlmacenNombre( ::oGetAlmacenOrigen )

   ::oController:stampAlmacenNombre( ::oGetAlmacenDestino )

   ::oController:stampGrupoMovimientoNombre( ::oGetGrupoMovimiento )

   ::oController:stampAgente( ::oGetAgente )

RETURN ( Self )

//---------------------------------------------------------------------------//
