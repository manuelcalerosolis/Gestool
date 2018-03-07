#include "FiveWin.Ch"
#include "Factu.ch"

/*
Hay que crear los campos extra necesarios para este script---------------------
*/

Function ImportarPedidosProveedor( nView )                  
         
   local oImportarPedidosProveedor    := TImportarPedidosProveedor():New( nView )

   oImportarPedidosProveedor:Run()

Return nil

//---------------------------------------------------------------------------//  

CLASS TImportarPedidosProveedor

   DATA oDialog
   DATA nView

   DATA cSelectHead
   DATA cSelectLines

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

   METHOD isSeekRegistro()    INLINE ( aScan( ::oBrowse:aSelected, ( ::cSelectHead )->cSerPed + Str( ( ::cSelectHead )->nNumPed ) + ( ::cSelectHead )->cSufPed ) != 0 )

   METHOD AddCabeceraAlbaran()

   METHOD AddLineasAlbaran()

   METHOD SetEstadoPedidos()

   METHOD selectPedidosProveedoresPendientes( idProveedor )

   METHOD AddRegLine()

   METHOD SetTotalesAlbaran()

   METHOD AddCamposExtra()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView ) CLASS TImportarPedidosProveedor

   ::nView                    := nView

   ::cCodigoProveedor         := ( D():PedidosProveedores( ::nView ) )->cCodPrv
   ::cNombreProveedor         := ( D():PedidosProveedores( ::nView ) )->cNomPrv

   ::SetOldProvee()

   ::aPedidos                 := { { .t., "A99999999900", ctod( "01/01/2017" ), "Proveedor", "Nombre", 0 }, { .t., "A99999999900", ctod( "01/01/2017" ), "Proveedor", "Nombre", 100 } }

   ::cSelectHead              := "pedidoProveedor"
   ::cSelectLines             := "LineasAlbaran"
   

   ::selectPedidosProveedoresPendientes( Padr( ::cCodigoProveedor, 12 ) )

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

      ::oBrowse:cAlias                 := ::cSelectHead

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
         :bStrData                  := {|| ( ::cSelectHead )->cSerPed + "/" + AllTrim( Str( ( ::cSelectHead )->nNumPed ) ) + "/" + ( ::cSelectHead )->cSufPed }
         :nWidth                    := 120
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader                   := "Fecha"
         :bStrData                  := {|| ( ::cSelectHead )->dFecPed }
         :nWidth                    := 80
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader                   := "Proveedor"
         :bStrData                  := {|| ( ::cSelectHead )->cCodPrv + Space(1) + ( ::cSelectHead )->cNomPrv }
         :nWidth                    := 510
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader                   := "Total"
         :bEditValue                := {|| ( ::cSelectHead )->nTotPed }
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

   ::oBrowse:aSelected     := {}

   if ::cOldProvee != ::cCodigoProveedor
      ::selectPedidosProveedoresPendientes( Padr( ::cCodigoProveedor, 12 ) )
   end if

   ::SetOldProvee()

   if !Empty( ::oBrowse )
      ::oBrowse:Refresh()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

METHOD seleccionaRegistro() CLASS TImportarPedidosProveedor
   
   local n

   n  := aScan( ::oBrowse:aSelected, ( ::cSelectHead )->cSerPed + Str( ( ::cSelectHead )->nNumPed ) + ( ::cSelectHead )->cSufPed )

   if n != 0
      aDel( ::oBrowse:aSelected, n, .t. )   
   else
      aAdd( ::oBrowse:aSelected, ( ::cSelectHead )->cSerPed + Str( ( ::cSelectHead )->nNumPed ) + ( ::cSelectHead )->cSufPed )
   end if

   if !Empty( ::oBrowse )
      ::oBrowse:Refresh()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD todosRegistro( lSel ) CLASS TImportarPedidosProveedor

   ::oBrowse:aSelected  := {}

   if lSel

      ( ::cSelectHead )->( dbGoTop() )

      while !( ::cSelectHead )->( Eof() )

         aAdd( ::oBrowse:aSelected, ( ::cSelectHead )->cSerPed + Str( ( ::cSelectHead )->nNumPed ) + ( ::cSelectHead )->cSufPed )

         ( ::cSelectHead )->( dbSkip() )

      end while

      ( ::cSelectHead )->( dbGoTop() )

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

   ::SetTotalesAlbaran()

   ::SetEstadoPedidos()

   ::oDialog:End( IDOK )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AddCabeceraAlbaran() CLASS TImportarPedidosProveedor

   /*
   Me posiciono en la cabecera del primer pedido seleccionado para crearme la
   cabecera del albarán a crear
   */

   ( ::cSelectHead )->( dbGoTop() )

   /*
   Tomo valores para el número del albarán a crear
   */

   //::cSerieAlbaran      := ( ::cSelectHead )->cSerPed
   ::cSerieAlbaran      := RetFld( ::cCodigoProveedor, D():Proveedores( ::nView ), "Serie" )
   ::nNumeroAlbaran     := nNewDoc( ( ::cSelectHead )->cSerPed, D():AlbaranesProveedores( ::nView ), "nAlbPrv", , D():Contadores( ::nView ) )
   ::cSufijoAlbaran     := ( ::cSelectHead )->cSufPed

   /*
   Creo un regustro nuevo en las cabeceras de llos albaranes-------------------
   */

   ( D():AlbaranesProveedores( ::nView ) )->( dbAppend() )

   ( D():AlbaranesProveedores( ::nView ) )->cSerAlb        := ::cSerieAlbaran
   ( D():AlbaranesProveedores( ::nView ) )->nNumAlb        := ::nNumeroAlbaran
   ( D():AlbaranesProveedores( ::nView ) )->cSufAlb        := ::cSufijoAlbaran
   ( D():AlbaranesProveedores( ::nView ) )->cTurAlb        := ( ::cSelectHead )->cTurPed
   ( D():AlbaranesProveedores( ::nView ) )->dFecAlb        := GetSysDate()
   ( D():AlbaranesProveedores( ::nView ) )->cCodPrv        := ( ::cSelectHead )->cCodPrv
   ( D():AlbaranesProveedores( ::nView ) )->cCodAlm        := ( ::cSelectHead )->cCodAlm
   ( D():AlbaranesProveedores( ::nView ) )->cCodCaj        := ( ::cSelectHead )->cCodCaj
   ( D():AlbaranesProveedores( ::nView ) )->cNomPrv        := ( ::cSelectHead )->cNomPrv
   ( D():AlbaranesProveedores( ::nView ) )->cDirPrv        := ( ::cSelectHead )->cDirPrv
   ( D():AlbaranesProveedores( ::nView ) )->cPobPrv        := ( ::cSelectHead )->cPobPrv
   ( D():AlbaranesProveedores( ::nView ) )->cProPrv        := ( ::cSelectHead )->cProPrv
   ( D():AlbaranesProveedores( ::nView ) )->cPosPrv        := ( ::cSelectHead )->cPosPrv
   ( D():AlbaranesProveedores( ::nView ) )->cDniPrv        := ( ::cSelectHead )->cDniPrv
   ( D():AlbaranesProveedores( ::nView ) )->dFecEnt        := ( ::cSelectHead )->dFecEnt
   ( D():AlbaranesProveedores( ::nView ) )->cCodPgo        := ( ::cSelectHead )->cCodPgo
   ( D():AlbaranesProveedores( ::nView ) )->nBultos        := ( ::cSelectHead )->nBultos
   ( D():AlbaranesProveedores( ::nView ) )->nPortes        := ( ::cSelectHead )->nPortes
   ( D():AlbaranesProveedores( ::nView ) )->cDtoEsp        := ( ::cSelectHead )->cDtoEsp
   ( D():AlbaranesProveedores( ::nView ) )->nDtoEsp        := ( ::cSelectHead )->nDtoEsp
   ( D():AlbaranesProveedores( ::nView ) )->cDpp           := ( ::cSelectHead )->cDpp
   ( D():AlbaranesProveedores( ::nView ) )->nDpp           := ( ::cSelectHead )->nDpp
   ( D():AlbaranesProveedores( ::nView ) )->lRecargo       := ( ::cSelectHead )->lRecargo
   ( D():AlbaranesProveedores( ::nView ) )->cCondEnt       := ( ::cSelectHead )->cCondEnt
   ( D():AlbaranesProveedores( ::nView ) )->cExped         := ( ::cSelectHead )->cExped
   ( D():AlbaranesProveedores( ::nView ) )->lFacturado     := .f.
   ( D():AlbaranesProveedores( ::nView ) )->cDivAlb        := ( ::cSelectHead )->cDivPed
   ( D():AlbaranesProveedores( ::nView ) )->nVdvAlb        := ( ::cSelectHead )->nVdvPed
   ( D():AlbaranesProveedores( ::nView ) )->lSndDoc        := .t.
   ( D():AlbaranesProveedores( ::nView ) )->cDtoUno        := ( ::cSelectHead )->cDtoUno
   ( D():AlbaranesProveedores( ::nView ) )->nDtoUno        := ( ::cSelectHead )->nDtoUno
   ( D():AlbaranesProveedores( ::nView ) )->cDtoDos        := ( ::cSelectHead )->cDtoDos
   ( D():AlbaranesProveedores( ::nView ) )->nDtoDos        := ( ::cSelectHead )->nDtoDos
   ( D():AlbaranesProveedores( ::nView ) )->lCloAlb        := .f.
   ( D():AlbaranesProveedores( ::nView ) )->cCodUsr        := ( ::cSelectHead )->cCodUsr
   ( D():AlbaranesProveedores( ::nView ) )->dFecChg        := GetSysDate()
   ( D():AlbaranesProveedores( ::nView ) )->cTimChg        := getSysTime()
   ( D():AlbaranesProveedores( ::nView ) )->cCodDlg        := ( ::cSelectHead )->cCodDlg
   ( D():AlbaranesProveedores( ::nView ) )->nRegIva        := ( ::cSelectHead )->nRegIva
   ( D():AlbaranesProveedores( ::nView ) )->nFacturado     := 1
   ( D():AlbaranesProveedores( ::nView ) )->tFecAlb        := getSysTime()

   ( D():AlbaranesProveedores( ::nView ) )->( dbUnlock() )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD selectPedidosProveedoresPendientes( idProveedor )

   local cSql  := "SELECT * FROM " + cPatEmp() + "PedProvT " + ;
                           "WHERE " + ;
                              "cCodPrv = " + quoted( idProveedor )  + " AND " + ;
                              "nEstado = 1"

Return ( ADSBaseModel():ExecuteSqlStatement( cSql, ::cSelectHead ) )

//---------------------------------------------------------------------------//

METHOD AddLineasAlbaran() CLASS TImportarPedidosProveedor

   local n              := 1
   local cPedido
   local cSql

   cSql        := "SELECT cRef, cAlmLin, cCodPr1, cCodPr2, cValPr1, cValPr2, sum(nUniCaja) AS nUniCaja, sum(nCanPed) AS nCanPed, sum(nBultos) AS nBultos"
   cSql        += " FROM " + + cPatEmp() + "PedProvL WHERE "

   for each cPedido in ::oBrowse:aSelected

      cSql     += "( cSerPed = " + quoted( SubStr( cPedido, 1, 1 ) )
      cSql     += " AND"
      cSql     += " nNumPed = " + AllTrim( SubStr( cPedido, 2, 9 ) )
      cSql     += " AND"
      cSql     += " cSufPed = " + quoted( SubStr( cPedido, 11, 2 ) )
      cSql     += " )"
      
      if n != Len( ::oBrowse:aSelected )
         cSql  += " OR"
      end if

      n++

   next

   cSql     += " GROUP BY cRef, cAlmLin, cCodPr1, cCodPr2, cValPr1, cValPr2"

   ADSBaseModel():ExecuteSqlStatement( cSql, ::cSelectLines )

   ::AddRegLine()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AddRegLine() CLASS TImportarPedidosProveedor

   local nOrdAnt

   ( ::cSelectLines )->( dbGoTop() )

   while !( ::cSelectLines )->( Eof() )

      ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbAppend() )

      ( D():AlbaranesProveedoresLineas( ::nView ) )->cSerAlb      := ::cSerieAlbaran
      ( D():AlbaranesProveedoresLineas( ::nView ) )->nNumAlb      := ::nNumeroAlbaran
      ( D():AlbaranesProveedoresLineas( ::nView ) )->cSufAlb      := ::cSufijoAlbaran
      ( D():AlbaranesProveedoresLineas( ::nView ) )->cRef         := ( ::cSelectLines )->cRef

      if ( D():Articulos( ::nView ) )->( dbSeek( ( ::cSelectLines )->cRef ) )

         ( D():AlbaranesProveedoresLineas( ::nView ) )->cDetalle     := ( D():Articulos( ::nView ) )->Nombre
         ( D():AlbaranesProveedoresLineas( ::nView ) )->nIva         := nIva( D():TiposIva( ::nView ), ( D():Articulos( ::nView ) )->TipoIva )
         ( D():AlbaranesProveedoresLineas( ::nView ) )->nReq         := nReq( D():TiposIva( ::nView ), ( D():Articulos( ::nView ) )->TipoIva )
         ( D():AlbaranesProveedoresLineas( ::nView ) )->nCtlStk      := ( D():Articulos( ::nView ) )->nCtlStock
         ( D():AlbaranesProveedoresLineas( ::nView ) )->lLote        := ( D():Articulos( ::nView ) )->lLote
         ( D():AlbaranesProveedoresLineas( ::nView ) )->cCodFam      := ( D():Articulos( ::nView ) )->Familia
         ( D():AlbaranesProveedoresLineas( ::nView ) )->cGrpFam      := cGruFam( ( D():AlbaranesProveedoresLineas( ::nView ) )->cCodFam, D():Familias( ::nView ) )

      end if

      nOrdAnt                 := ( D():ProveedorArticulo( ::nView ) )->( OrdSetFocus( "cCodPrv" ) )

      if ( D():ProveedorArticulo( ::nView ) )->( dbSeek( ::cCodigoProveedor + ( ::cSelectLines )->cRef ) )
         ( D():AlbaranesProveedoresLineas( ::nView ) )->cRefPrv   :=  ( D():ProveedorArticulo( ::nView ) )->cRefPrv
      end if

      ( D():ProveedorArticulo( ::nView ) )->( ordSetFocus( nOrdAnt ) )

      ( D():AlbaranesProveedoresLineas( ::nView ) )->nCanEnt      := ( ::cSelectLines )->nCanPed
      ( D():AlbaranesProveedoresLineas( ::nView ) )->nUniCaja     := ( ::cSelectLines )->nUniCaja
      ( D():AlbaranesProveedoresLineas( ::nView ) )->nPreDiv      := nCosto( nil, D():Articulos( ::nView ), D():Kit( ::nView ), .f., 1, D():Divisas( ::nView ) )
      ( D():AlbaranesProveedoresLineas( ::nView ) )->cCodPr1      := ( ::cSelectLines )->cCodPr1
      ( D():AlbaranesProveedoresLineas( ::nView ) )->cCodPr2      := ( ::cSelectLines )->cCodPr2
      ( D():AlbaranesProveedoresLineas( ::nView ) )->cValPr1      := ( ::cSelectLines )->cValPr1
      ( D():AlbaranesProveedoresLineas( ::nView ) )->cValPr2      := ( ::cSelectLines )->cValPr2
      ( D():AlbaranesProveedoresLineas( ::nView ) )->cAlmLin      := ( ::cSelectLines )->cAlmLin
      ( D():AlbaranesProveedoresLineas( ::nView ) )->nNumLin      := ( ::cSelectLines )->( Recno() )
      ( D():AlbaranesProveedoresLineas( ::nView ) )->nPosPrint    := ( ::cSelectLines )->( Recno() )
      ( D():AlbaranesProveedoresLineas( ::nView ) )->lFacturado   :=  .f.
      ( D():AlbaranesProveedoresLineas( ::nView ) )->nBultos      := ( ::cSelectLines )->nBultos
      ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbUnlock() )

      ::AddCamposExtra()

      ( ::cSelectLines )->( dbSkip() )

   end while

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AddCamposExtra() CLASS TImportarPedidosProveedor

   /*
   001 - bultos original-------------------------------------------------------
   */

   ( D():DetCamposExtras( ::nView ) )->( dbAppend() )

   ( D():DetCamposExtras( ::nView ) )->cTipDoc     := "37"
   ( D():DetCamposExtras( ::nView ) )->cCodTipo    := "001"
   ( D():DetCamposExtras( ::nView ) )->cClave      := ::cSerieAlbaran + Str( ::nNumeroAlbaran ) + ::cSufijoAlbaran + Str( ( ::cSelectLines )->( Recno() ), 4 )
   ( D():DetCamposExtras( ::nView ) )->cValor      := Str( ( ::cSelectLines )->nBultos )

   ( D():DetCamposExtras( ::nView ) )->( dbUnlock() )

   /*
   002 - cajas original--------------------------------------------------------
   */

   ( D():DetCamposExtras( ::nView ) )->( dbAppend() )

   ( D():DetCamposExtras( ::nView ) )->cTipDoc     := "37"
   ( D():DetCamposExtras( ::nView ) )->cCodTipo    := "002"
   ( D():DetCamposExtras( ::nView ) )->cClave      := ::cSerieAlbaran + Str( ::nNumeroAlbaran ) + ::cSufijoAlbaran + Str( ( ::cSelectLines )->( Recno() ), 4 )
   ( D():DetCamposExtras( ::nView ) )->cValor      := Str( ( ::cSelectLines )->nCanPed )

   ( D():DetCamposExtras( ::nView ) )->( dbUnlock() )

   /*
   003 - unidades original-----------------------------------------------------
   */

   ( D():DetCamposExtras( ::nView ) )->( dbAppend() )

   ( D():DetCamposExtras( ::nView ) )->cTipDoc     := "37"
   ( D():DetCamposExtras( ::nView ) )->cCodTipo    := "003"
   ( D():DetCamposExtras( ::nView ) )->cClave      := ::cSerieAlbaran + Str( ::nNumeroAlbaran ) + ::cSufijoAlbaran + Str( ( ::cSelectLines )->( Recno() ), 4 )
   ( D():DetCamposExtras( ::nView ) )->cValor      := Str( ( ::cSelectLines )->nUniCaja )

   ( D():DetCamposExtras( ::nView ) )->( dbUnlock() )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD SetTotalesAlbaran() CLASS TImportarPedidosProveedor

   local aTotalAlbaran

   aTotalAlbaran     := aTotAlbPrv( ::cSerieAlbaran + Str( ::nNumeroAlbaran ) + ::cSufijoAlbaran, D():AlbaranesProveedores( ::nView ), D():AlbaranesProveedoresLineas( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ) )

   if ( D():AlbaranesProveedores( ::nView ) )->( dbSeek( ::cSerieAlbaran + Str( ::nNumeroAlbaran ) + ::cSufijoAlbaran ) ) .and.;
      dbLock( D():AlbaranesProveedores( ::nView ) )

      ( D():AlbaranesProveedores( ::nView ) )->nTotNet     := aTotalAlbaran[1]
      ( D():AlbaranesProveedores( ::nView ) )->nTotIva     := aTotalAlbaran[2]
      ( D():AlbaranesProveedores( ::nView ) )->nTotReq     := aTotalAlbaran[3]
      ( D():AlbaranesProveedores( ::nView ) )->nTotAlb     := aTotalAlbaran[4]

      ( D():AlbaranesProveedores( ::nView ) )->( dbUnlock() )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD SetEstadoPedidos() CLASS TImportarPedidosProveedor

   local cPedido
   local nOrdAnt

   for each cPedido in ::oBrowse:aSelected

      nOrdAnt  := ( D():PedidosProveedores( ::nView ) )->( OrdSetFocus( "nNumPed" ) )

      if ( D():PedidosProveedores( ::nView ) )->( dbSeek( cPedido ) )

         if dbLock( D():PedidosProveedores( ::nView ) )

            ( D():PedidosProveedores( ::nView ) )->nEstado    := 3
         
            ( D():PedidosProveedores( ::nView ) )->( dbUnlock() )

         end if

      end if

      ( D():PedidosProveedores( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

      nOrdAnt  := ( D():PedidosProveedoresLineas( ::nView ) )->( OrdSetFocus( "nNumPed" ) )

      if ( D():PedidosProveedoresLineas( ::nView ) )->( dbSeek( cPedido ) )
         
         while ( D():PedidosProveedoresLineas( ::nView ) )->cSerPed + Str( ( D():PedidosProveedoresLineas( ::nView ) )->nNumPed ) + ( D():PedidosProveedoresLineas( ::nView ) )->cSufPed == cPedido .and.;
               !( D():PedidosProveedoresLineas( ::nView ) )->( eof() )

               if dbLock( D():PedidosProveedoresLineas( ::nView ) )
                  ( D():PedidosProveedoresLineas( ::nView ) )->nEstado    := 3
                  ( D():PedidosProveedoresLineas( ::nView ) )->( dbUnlock() )
               end if
            
            ( D():PedidosProveedoresLineas( ::nView ) )->( dbSkip() )

         end while

      end if      

      ( D():PedidosProveedoresLineas( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

   next

Return ( .t. )

//---------------------------------------------------------------------------//