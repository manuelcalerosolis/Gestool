#include "FiveWin.Ch"
#include "Factu.ch"

Function ImportarPedidosProveedor( nView )                  
         
   local oImportarPedidosProveedor    := TImportarPedidosProveedor():New( nView )

   oImportarPedidosProveedor:Run()

Return nil

//---------------------------------------------------------------------------//  

CLASS TImportarPedidosProveedor

   DATA oDialog
   DATA nView

   DATA cSelectAlias

   DATA oBrowse

   DATA oCodigoProveedor
   DATA cCodigoProveedor
   DATA oNombreProveedor
   DATA cNombreProveedor

   DATA cOldProvee

   DATA aPedidos

   DATA cSerieAlbaran
   DATA nNumeroAlbaran
   DATA cSufijoAlbaran

   METHOD New()

   METHOD Run()

   METHOD SetResources()      INLINE ( SetResources( fullcurdir() + "Script\PedidosProveedores\agruparmuriel.dll" ) )

   METHOD FreeResources()     INLINE ( FreeResources() )

   METHOD Resource() 

   METHOD lValidProcess()

   METHOD Process()

   METHOD LoadBrowse()

   METHOD SetOldProvee()      INLINE ( ::cOldProvee := ::cCodigoProveedor )

   METHOD seleccionaRegistro()

   METHOD todosRegistro()

   METHOD isSeekRegistro()    INLINE ( aScan( ::oBrowse:aSelected, ( ::cSelectAlias )->cSerPed + Str( ( ::cSelectAlias )->nNumPed ) + ( ::cSelectAlias )->cSufPed ) != 0 )

   METHOD AddCabeceraAlbaran()

   METHOD AddLineasAlbaran()

   METHOD CreaArrayLineas()

   METHOD GuardaLineas()

   METHOD SetEstadoPedidos()  INLINE ( MsgInfo( "Ponemos bien el estado de los pedidos pasados" ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView ) CLASS TImportarPedidosProveedor

   ::nView                    := nView

   ::cCodigoProveedor         := ( D():PedidosProveedores( ::nView ) )->cCodPrv
   ::cNombreProveedor         := ( D():PedidosProveedores( ::nView ) )->cNomPrv

   ::SetOldProvee()

   ::aPedidos                 := { { .t., "A99999999900", ctod( "01/01/2017" ), "Proveedor", "Nombre", 0 }, { .t., "A99999999900", ctod( "01/01/2017" ), "Proveedor", "Nombre", 100 } }

   ::cSelectAlias             := "pedidoProveedor"
   PedidosProveedoresModel():selectPedidosProveedoresPendientes( Padr( ::cCodigoProveedor, 12 ), @::cSelectAlias )

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run() CLASS TImportarPedidosProveedor

   ::SetResources()

   ::Resource()

   ::FreeResources()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TImportarPedidosProveedor

   DEFINE DIALOG ::oDialog RESOURCE "AGRUPARPEDIDOS" 

      REDEFINE GET   ::oCodigoProveedor ;
         VAR         ::cCodigoProveedor ;
         ID          100 ;
         BITMAP      "LUPA" ;
         OF          ::oDialog

         ::oCodigoProveedor:bHelp   := {|| BrwProvee( ::oCodigoProveedor, ::oNombreProveedor ) }
         ::oCodigoProveedor:bValid  := {|| cProvee( ::oCodigoProveedor, D():Proveedores( ::nView ), ::oNombreProveedor ), ::LoadBrowse() }

      REDEFINE GET   ::oNombreProveedor ;
         VAR         ::cNombreProveedor ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE BUTTON ;
         ID          500 ;
         OF          ::oDialog ;
         ACTION      ( ::seleccionaRegistro() )

      REDEFINE BUTTON ;
         ID          510 ;
         OF          ::oDialog ;
         ACTION      ( ::todosRegistro( .t. ) )

      REDEFINE BUTTON ;
         ID          520 ;
         OF          ::oDialog ;
         ACTION      ( ::todosRegistro( .f. ) )

      ::oBrowse                        := IXBrowse():New( ::oDialog )

      ::oBrowse:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrowse:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrowse:cAlias                 := ::cSelectAlias

      ::oBrowse:nMarqueeStyle          := 5
      ::oBrowse:lRecordSelector        := .f.
      ::oBrowse:lHScroll               := .f.
      ::oBrowse:cName                  := "Agrupar pedidos proveedor"

      ::oBrowse:bLDblClick             := {|| ::seleccionaRegistro() }

      ::oBrowse:CreateFromResource( 200 )

      with object ( ::oBrowse:AddCol() )
         :cHeader                   := "Se. seleccionado"
         :bStrData                  := {|| "" }
         :bEditValue                := {|| ::isSeekRegistro() }
         :nWidth                    := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader                   := "Número"
         :bStrData                  := {|| ( ::cSelectAlias )->cSerPed + "/" + AllTrim( Str( ( ::cSelectAlias )->nNumPed ) ) + "/" + ( ::cSelectAlias )->cSufPed }
         :nWidth                    := 120
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader                   := "Fecha"
         :bStrData                  := {|| ( ::cSelectAlias )->dFecPed }
         :nWidth                    := 80
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader                   := "Proveedor"
         :bStrData                  := {|| ( ::cSelectAlias )->cCodPrv + Space(1) + ( ::cSelectAlias )->cNomPrv }
         :nWidth                    := 510
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader                   := "Total"
         :bEditValue                := {|| ( ::cSelectAlias )->nTotPed }
         :cEditPicture              := cPinDiv()
         :nWidth                    := 110
         :nDataStrAlign             := 1
         :nHeadStrAlign             := 1
      end with

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ::oDialog ;
         ACTION      ( if( ::lValidProcess(), ::Process(), ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:End( IDCANCEL ) )

      ::oDialog:AddFastKey( VK_F5, {|| if( ::lValidProcess(), ::Process(), ) } )

   ACTIVATE DIALOG ::oDialog CENTER

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD LoadBrowse() CLASS TImportarPedidosProveedor

   if Empty( ::cCodigoProveedor )
      Return nil
   end if

   if ::cOldProvee != ::cCodigoProveedor
      PedidosProveedoresModel():selectPedidosProveedoresPendientes( Padr( ::cCodigoProveedor, 12 ), @::cSelectAlias )
   end if

   ::SetOldProvee()

   if !Empty( ::oBrowse )
      ::oBrowse:Refresh()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

METHOD seleccionaRegistro() CLASS TImportarPedidosProveedor
   
   local n

   n  := aScan( ::oBrowse:aSelected, ( ::cSelectAlias )->cSerPed + Str( ( ::cSelectAlias )->nNumPed ) + ( ::cSelectAlias )->cSufPed )

   if n != 0
      aDel( ::oBrowse:aSelected, n, .t. )   
   else
      aAdd( ::oBrowse:aSelected, ( ::cSelectAlias )->cSerPed + Str( ( ::cSelectAlias )->nNumPed ) + ( ::cSelectAlias )->cSufPed )
   end if

   if !Empty( ::oBrowse )
      ::oBrowse:Refresh()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD todosRegistro( lSel ) CLASS TImportarPedidosProveedor

   ::oBrowse:aSelected  := {}

   if lSel

      ( ::cSelectAlias )->( dbGoTop() )

      while !( ::cSelectAlias )->( Eof() )

         aAdd( ::oBrowse:aSelected, ( ::cSelectAlias )->cSerPed + Str( ( ::cSelectAlias )->nNumPed ) + ( ::cSelectAlias )->cSufPed )

         ( ::cSelectAlias )->( dbSkip() )

      end while

      ( ::cSelectAlias )->( dbGoTop() )

   end if

   if !Empty( ::oBrowse )
      ::oBrowse:Refresh()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD lValidProcess() CLASS TImportarPedidosProveedor

   if Empty( ::cCodigoProveedor )
      MsgStop( "Es necesario seleccionar un proveedor para hacer este proceso." )
      ::oCodigoProveedor:SetFocus()
      Return .f.
   end if

   if Len( ::oBrowse:aSelected ) == 0
      MsgStop( "Tiene que seleccionar algún pedido para crear el albarán agrupado." )
      Return .f.
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD Process() CLASS TImportarPedidosProveedor

   ::AddCabeceraAlbaran()

   ::AddLineasAlbaran()

   ::SetEstadoPedidos()

   ::oDialog:End( IDOK )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AddCabeceraAlbaran() CLASS TImportarPedidosProveedor

   /*
   Me posiciono en la cabecera del primer pedido seleccionado para crearme la
   cabecera del albarán a crear
   */

   ( ::cSelectAlias )->( dbGoTop() )

   /*
   Tomo valores para el número del albarán a crear
   */

   ::cSerieAlbaran      := ( ::cSelectAlias )->cSerPed
   ::nNumeroAlbaran     := nNewDoc( ( ::cSelectAlias )->cSerPed, D():AlbaranesProveedores( ::nView ), "nAlbPrv", , D():Contadores( ::nView ) )
   ::cSufijoAlbaran     := ( ::cSelectAlias )->cSufPed

   /*
   Creo un regustro nuevo en las cabeceras de llos albaranes-------------------
   */

   ( D():AlbaranesProveedores( ::nView ) )->( dbAppend() )

   ( D():AlbaranesProveedores( ::nView ) )->cSerAlb        := ::cSerieAlbaran
   ( D():AlbaranesProveedores( ::nView ) )->nNumAlb        := ::nNumeroAlbaran
   ( D():AlbaranesProveedores( ::nView ) )->cSufAlb        := ::cSufijoAlbaran
   ( D():AlbaranesProveedores( ::nView ) )->cTurAlb        := ( ::cSelectAlias )->cTurPed
   ( D():AlbaranesProveedores( ::nView ) )->dFecAlb        := GetSysDate()
   ( D():AlbaranesProveedores( ::nView ) )->cCodPrv        := ( ::cSelectAlias )->cCodPrv
   ( D():AlbaranesProveedores( ::nView ) )->cCodAlm        := ( ::cSelectAlias )->cCodAlm
   ( D():AlbaranesProveedores( ::nView ) )->cCodCaj        := ( ::cSelectAlias )->cCodCaj
   ( D():AlbaranesProveedores( ::nView ) )->cNomPrv        := ( ::cSelectAlias )->cNomPrv
   ( D():AlbaranesProveedores( ::nView ) )->cDirPrv        := ( ::cSelectAlias )->cDirPrv
   ( D():AlbaranesProveedores( ::nView ) )->cPobPrv        := ( ::cSelectAlias )->cPobPrv
   ( D():AlbaranesProveedores( ::nView ) )->cProPrv        := ( ::cSelectAlias )->cProPrv
   ( D():AlbaranesProveedores( ::nView ) )->cPosPrv        := ( ::cSelectAlias )->cPosPrv
   ( D():AlbaranesProveedores( ::nView ) )->cDniPrv        := ( ::cSelectAlias )->cDniPrv
   ( D():AlbaranesProveedores( ::nView ) )->dFecEnt        := ( ::cSelectAlias )->dFecEnt
   ( D():AlbaranesProveedores( ::nView ) )->cCodPgo        := ( ::cSelectAlias )->cCodPgo
   ( D():AlbaranesProveedores( ::nView ) )->nBultos        := ( ::cSelectAlias )->nBultos
   ( D():AlbaranesProveedores( ::nView ) )->nPortes        := ( ::cSelectAlias )->nPortes
   ( D():AlbaranesProveedores( ::nView ) )->cDtoEsp        := ( ::cSelectAlias )->cDtoEsp
   ( D():AlbaranesProveedores( ::nView ) )->nDtoEsp        := ( ::cSelectAlias )->nDtoEsp
   ( D():AlbaranesProveedores( ::nView ) )->cDpp           := ( ::cSelectAlias )->cDpp
   ( D():AlbaranesProveedores( ::nView ) )->nDpp           := ( ::cSelectAlias )->nDpp
   ( D():AlbaranesProveedores( ::nView ) )->lRecargo       := ( ::cSelectAlias )->lRecargo
   ( D():AlbaranesProveedores( ::nView ) )->cCondEnt       := ( ::cSelectAlias )->cCondEnt
   ( D():AlbaranesProveedores( ::nView ) )->cExped         := ( ::cSelectAlias )->cExped
   ( D():AlbaranesProveedores( ::nView ) )->lFacturado     := .f.
   ( D():AlbaranesProveedores( ::nView ) )->cDivAlb        := ( ::cSelectAlias )->cDivPed
   ( D():AlbaranesProveedores( ::nView ) )->nVdvAlb        := ( ::cSelectAlias )->nVdvPed
   ( D():AlbaranesProveedores( ::nView ) )->lSndDoc        := .t.
   ( D():AlbaranesProveedores( ::nView ) )->cDtoUno        := ( ::cSelectAlias )->cDtoUno
   ( D():AlbaranesProveedores( ::nView ) )->nDtoUno        := ( ::cSelectAlias )->nDtoUno
   ( D():AlbaranesProveedores( ::nView ) )->cDtoDos        := ( ::cSelectAlias )->cDtoDos
   ( D():AlbaranesProveedores( ::nView ) )->nDtoDos        := ( ::cSelectAlias )->nDtoDos
   ( D():AlbaranesProveedores( ::nView ) )->lCloAlb        := .f.
   ( D():AlbaranesProveedores( ::nView ) )->cCodUsr        := ( ::cSelectAlias )->cCodUsr
   ( D():AlbaranesProveedores( ::nView ) )->dFecChg        := GetSysDate()
   ( D():AlbaranesProveedores( ::nView ) )->cTimChg        := getSysTime()
   ( D():AlbaranesProveedores( ::nView ) )->cCodDlg        := ( ::cSelectAlias )->cCodDlg
   ( D():AlbaranesProveedores( ::nView ) )->nRegIva        := ( ::cSelectAlias )->nRegIva
   ( D():AlbaranesProveedores( ::nView ) )->nFacturado     := 1
   ( D():AlbaranesProveedores( ::nView ) )->tFecAlb        := getSysTime()

   ( D():AlbaranesProveedores( ::nView ) )->( dbUnlock() )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AddLineasAlbaran() CLASS TImportarPedidosProveedor

   local cSelectLineas  := "LineasAlbaran"

   MsgInfo( hb_Valtoexp( ::oBrowse:aSelected ) )

   PedidosProveedoresModel():selectPedidosProveedoresLineasToArray( ::oBrowse:aSelected, @::cSelectLineas )

   ( cSelectLineas )->( Browse() )

   

   //::CreaArrayLineas()

   //::GuardaLineas()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD CreaArrayLineas() CLASS TImportarPedidosProveedor

   MsgInfo( ::cSerieAlbaran )
   MsgInfo( ::nNumeroAlbaran )
   MsgInfo( ::cSufijoAlbaran )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD GuardaLineas() CLASS TImportarPedidosProveedor


Return ( .t. )

//---------------------------------------------------------------------------//