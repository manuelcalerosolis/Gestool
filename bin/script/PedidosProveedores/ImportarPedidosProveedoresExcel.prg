#include "Factu.ch"
#include "FiveWin.Ch"

#define __referenciaFabricante__    "Ref. fabricante"
#define __articulo__                "Artículo"
#define __total__                   "Total"

//---------------------------------------------------------------------------//

function ImportaPedidosProveedorExcel( nView )

   local oImportarPedidoProveedor

   oImportarPedidoProveedor   := ImportarPedidosProveedorExcel():New( nView )

   if oImportarPedidoProveedor:isFile()
      oImportarPedidoProveedor:processFile()
   end if 
  
return .t.

//---------------------------------------------------------------------------//

CLASS ImportarPedidosProveedorExcel

   DATA nView
   DATA cFile
   
   DATA oExcelFile
   DATA oActiveSheet

   DATA hTallas                              INIT {=>}
   DATA hTallasColores                       INIT {=>}  
   DATA aLineasPedidos                       INIT {}                          
   
   DATA nRowTalla
      METHOD getRow()                        INLINE ( ::nRowTalla )
      METHOD nextRow()                       INLINE ( ::nRowTalla++ )

   DATA nColumnTalla

   DATA codigoArticuloAnterior               INIT ''

   DATA numeroLinea                          INIT 0

   DATA cReferenciaProveedor
   DATA cCodigoArticulo
   DATA cCodigoColor
   DATA cDescrpcionArticulo

   DATA cTalla       
   DATA cColor 
   DATA nUnidades

   DATA nNumeroPedido                      
   DATA cCodigoProveedor

   METHOD New()
   
   METHOD isFile()

   METHOD processFile()
      METHOD isOpenFile()
      METHOD closeFile()

      METHOD isInformationInExcel()
      METHOD valoresLineaArticulo() 
         METHOD isLineaArticulo()            INLINE   ( ::valoresLineaArticulo() == 2 )
         METHOD isLineaTallaColor()          INLINE   ( ::valoresLineaArticulo() > 2 )
         METHOD isLineaTotal()         
   
      METHOD getTallas()
         METHOD isFilaTallas()
         METHOD getValoresTallas()
         METHOD addValoresTallas( cValueTalla, nColumna )

      METHOD getArticulo()      
      METHOD getTallaColor()
         METHOD getUnidadesPorTallas()
         METHOD addLineasPedido()

   METHOD getCodigoProveedor()
   METHOD setCabeceraPedido()
      METHOD getNumeroPedido()               INLINE nNewDoc( 'A', D():PedidosProveedores( ::nView ), "NPEDPRV", , D():Contadores( ::nView ) )                
   METHOD setLineasPedidos()
   METHOD setTotalesPedido()

   METHOD getCodigoColor( cColorDescripcion )
   METHOD getCodigoTalla( cTallaDescripcion )

   METHOD getActiveSheetValue( nRow, nCol )  INLINE ( ::oActiveSheet:Cells( nRow, nCol ):Value )

   METHOD getTallaFromColumna( nCol )        INLINE ( if( hhaskey( ::hTallas, nCol ), hGet( ::hTallas, nCol ), "" ) )

   METHOD getNumeroLinea( hLinea )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS ImportarPedidosProveedorExcel

   ::nView  := nView

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isFile() CLASS ImportarPedidosProveedorExcel

   ::cFile  := cGetFile( ".xls,xlsx | *.xls; *.xlsx", "Seleccione el fichero a importar", "*.xls; *.xlsx" , , .f.)

   if empty( ::cFile ) .or. !file( ::cFile )
      msgStop( "No se encuentra el fichero" )
      Return ( .f. )
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD processFile() CLASS ImportarPedidosProveedorExcel

   if ::isOpenFile()

      ::getTallas()

      while ::isInformationInExcel()
         if ::isLineaArticulo()
            ::getArticulo()
         end if 
         if ::isLineaTallaColor()
            ::getTallaColor()
         end if 
      end while

      if !empty( ::getCodigoProveedor() )
         ::setCabeceraPedido()
         ::setLineasPedidos()
         ::setTotalesPedido()
      end if 

      msgAlert( "Se ha añadido el pedido de proveedor nº " + D():PedidosProveedoresId( ::nView ) )

   end if 

   ::closeFile()

Return ( self )   

//----------------------------------------------------------------------------//

METHOD isOpenFile() CLASS ImportarPedidosProveedorExcel

   local oError
   local oBlock
   local isOpen                        := .t.

   oBlock                              := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oExcelFile                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )
   ::oExcelFile:oExcel:Visible         := .f.
   ::oExcelFile:oExcel:DisplayAlerts   := .f.
   ::oExcelFile:oExcel:WorkBooks:Open( ::cFile )

   ::oExcelFile:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

   ::oActiveSheet                      := ::oExcelFile:oExcel:ActiveSheet()

   RECOVER USING oError

      msgStop( "Error al crear el objeto Excel." + CRLF + ErrorMessage( oError ) )

      isOpen                           := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( isOpen )

//---------------------------------------------------------------------------//

METHOD closeFile() CLASS ImportarPedidosProveedorExcel

   if empty( ::oExcelFile )
      Return ( self )
   end if 

   ::oExcelFile:oExcel:WorkBooks:Close()
   ::oExcelFile:oExcel:Quit()
   ::oExcelFile:oExcel:DisplayAlerts   := .t.

   ::oExcelFile:End()

Return ( self )

//---------------------------------------------------------------------------//

METHOD getTallas() CLASS ImportarPedidosProveedorExcel

   if ::isFilaTallas()
      ::getValoresTallas()
   else
      msgalert( "no encuentro las tallas")
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD isInformationInExcel()

   local nCol

   ::nextRow()

   for nCol := 1 to 50
      if !empty( ::getActiveSheetValue( ::getRow(), nCol ) ) 
         Return .t.
      end if
   next 

Return .f.

//---------------------------------------------------------------------------//

METHOD isFilaTallas() CLASS ImportarPedidosProveedorExcel
   
   local oRange

   ::nRowTalla             := 0
   ::nColumnTalla          := 0

   oRange                  := ::oActiveSheet:Range("A1:AA10"):Find( __referenciaFabricante__ )
   if !empty(oRange)
      ::nRowTalla          := oRange:row
      ::nColumnTalla       := oRange:column
      return .t.
   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD getValoresTallas() CLASS ImportarPedidosProveedorExcel

   local cValueTalla

   for nColumna := ::nColumnTalla to ::nColumnTalla + 50

      cValueTalla          := ::getActiveSheetValue( ::nRowTalla, nColumna )    

      ::addValoresTallas( cValueTalla, nColumna )

   next 

Return ( self )

//---------------------------------------------------------------------------//

METHOD addValoresTallas( cValueTalla, nColumna )

   if empty( cValueTalla )
      Return ( self )
   end if 

   if alltrim(cValueTalla) != __referenciaFabricante__ .and. alltrim(cValueTalla) != __articulo__ .and. alltrim(cValueTalla) != __total__
      hset( ::hTallas, nColumna, cValueTalla )
   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD valoresLineaArticulo() CLASS ImportarPedidosProveedorExcel

   local nCol
   local uValue
   local nValue   := 0

   for nCol := 1 to 50
      uValue      := ::getActiveSheetValue( ::getRow(), nCol )
      if !empty(uValue)
         uValue   := cvaltochar( uValue )
         if ( uValue != __total__)
            ++nValue
         end if 
      end if
   next 

Return ( nValue )

//---------------------------------------------------------------------------//

METHOD isLineaTotal() CLASS ImportarPedidosProveedorExcel

   local nCol
   local uValue

   for nCol := 1 to 50
      uValue      := ::getActiveSheetValue( ::getRow(), nCol )
      if !empty(uValue)
         uValue   := cvaltochar( uValue )
         if ( uValue == __total__ )
            Return ( .t. )
         end if 
      end if
   next 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD getArticulo() CLASS ImportarPedidosProveedorExcel

   local nCol
   local uValue

   ::cReferenciaProveedor           := ""
   ::cCodigoArticulo                := ""
   ::cDescrpcionArticulo            := ""

   for nCol := 1 to 50

      uValue                        := ::getActiveSheetValue( ::getRow(), nCol )    

      if !empty(uValue) 

         uValue                     := alltrim( cvaltochar( uValue ) )

         if empty( ::cReferenciaProveedor )
            ::cReferenciaProveedor  := uValue
         else 
            ::cCodigoArticulo       := substr( uValue, 1, at( " ", uValue ) - 1 )
            ::cDescrpcionArticulo   := substr( uValue, at( " ", uValue ) + 1 )
         end if
      end if

   next 

Return ( self )

//----------------------------------------------------------------------------//

METHOD isLineaTallaColorArticulo()

   local nCol
   local uValue

   ::nextRow()

   for nCol := 1 to 50

      uValue                        := ::getActiveSheetValue( ::getRow(), nCol )    

      if !empty(uValue) .and. ( uValue != __total__ )
         return .f.
      end if

   next 

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD getTallaColor()

   local nCol
   local uValue
   
   ::cCodigoColor             := ""

   for nCol := 1 to 50 

      uValue                  :=  ::getActiveSheetValue( ::getRow(), nCol )

      if !empty(uValue) 
         if empty( ::cCodigoColor )
            ::cCodigoColor    := ::getCodigoColor( alltrim( cvaltochar( uValue ) ) )
         else
            ::getUnidadesPorTallas( uValue, nCol )
            ::addLineasPedido()
         end if 
      end if

   next 

Return ( self )

//---------------------------------------------------------------------------//

METHOD getCodigoColor( cColorDescripcion )

   local ordAnterior
   local cCodigoColor   := ""

   ordAnterior          := ( D():PropiedadesLineas( ::nView ) )->( ordsetfocus( "cCodDes" ) ) 

   if ( D():PropiedadesLineas( ::nView ) )->( dbseek( padr( '00001', 20 ) + cColorDescripcion ) )
      cCodigoColor      := ( D():PropiedadesLineas( ::nView ) )->cCodTbl
   else
      msgAlert( padr( '00001', 20 ) + cColorDescripcion, "No existe el color:" )
   end if 

   ( D():PropiedadesLineas( ::nView ) )->( ordsetfocus( ordAnterior ) ) 

Return ( cCodigoColor )

//---------------------------------------------------------------------------//

METHOD getCodigoTalla( cTallaDescripcion )

   local ordAnterior
   local cCodigoTalla   := ""

   ordAnterior          := ( D():PropiedadesLineas( ::nView ) )->( ordsetfocus( "cCodDes" ) ) 

   if ( D():PropiedadesLineas( ::nView ) )->( dbseek( padr( '00002', 20 ) + cTallaDescripcion ) )
      cCodigoTalla      := ( D():PropiedadesLineas( ::nView ) )->cCodTbl
   else
      msgAlert( padr( '00002', 20 ) + cTallaDescripcion, "No existe el color:" )
   end if 

   ( D():PropiedadesLineas( ::nView ) )->( ordsetfocus( ordAnterior ) ) 

Return ( cCodigoTalla )

//---------------------------------------------------------------------------//

METHOD getUnidadesPorTallas( nUnidades, nCol ) 

   local cTalla

   ::cTalla          := ""
   ::nUnidades       := 0

   cTalla            := ::getTallaFromColumna( nCol )

   if !empty( cTalla )
      ::cTalla       := ::getCodigoTalla( cTalla )
      ::nUnidades    := nUnidades
   end if 

Return ( self ) 

//---------------------------------------------------------------------------//

METHOD addLineasPedido()

   local hLinea  :=  {=>}

   if !empty( ::cCodigoArticulo ) .and. !empty( ::cReferenciaProveedor ) .and. !empty( ::nUnidades ) .and. ;
      !empty( ::cCodigoColor ) .and. !empty( ::cTalla ) 

      hset( hLinea, "Articulo", ::cCodigoArticulo )  
      hset( hLinea, "Descripcion", ::cDescrpcionArticulo )
      hset( hLinea, "ReferenciaProveedor", ::cReferenciaProveedor )
      hset( hLinea, "PorcentajeImpuesto", retFld( retFld( ::cCodigoArticulo, D():Articulos( ::nView ), "tipoIva" ), D():TiposIva( ::nView ), "TPIva" ) )           //hay que buscarlo en la ficha del art
      hset( hLinea, "Unidades", ::nUnidades )
      hset( hLinea, "CodigoPropiedad1", '00001')
      hset( hLinea, "CodigoPropiedad2", '00002')
      hset( hLinea, "ValorPropiedad1", ::cCodigoColor )   
      hset( hLinea, "ValorPropiedad2", ::cTalla )
      hset( hLinea, "Almacen", '000' )
      hset( hLinea, "PrecioCosto",  retFld( ::cCodigoArticulo, D():Articulos( ::nView ), "pCosto" ) )                
      hset( hLinea, "Familia",      retFld( ::cCodigoArticulo, D():Articulos( ::nView ), "Familia" ) ) 

      aAdd( ::aLineasPedidos, hLinea)

   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD getCodigoProveedor()

   ::cCodigoProveedor :=  BrwProvee( nil, nil, .f. )

Return ( ::cCodigoProveedor )

//---------------------------------------------------------------------------//     

METHOD setCabeceraPedido()           

   ::nNumeroPedido   :=  ::getNumeroPedido()

   ( D():PedidosProveedores( ::nView ) )->( dbappend() )

      ( D():PedidosProveedores( ::nView ) )->cSerPed        := 'A'
      ( D():PedidosProveedores( ::nView ) )->nNumPed        := ::nNumeroPedido
      ( D():PedidosProveedores( ::nView ) )->cSufPed        := '00'
      ( D():PedidosProveedores( ::nView ) )->cTurPed        := cCurSesion()
      ( D():PedidosProveedores( ::nView ) )->dFecPed        := GetSysDate()
      ( D():PedidosProveedores( ::nView ) )->cCodPrv        := ::cCodigoProveedor 
      ( D():PedidosProveedores( ::nView ) )->cCodAlm        := '000' 
      ( D():PedidosProveedores( ::nView ) )->cCodCaj        := oUser():cCaja()
      ( D():PedidosProveedores( ::nView ) )->cNomPrv        := retFld( ::cCodigoProveedor, D():Proveedores( ::nView ), "TITULO" ) 
      ( D():PedidosProveedores( ::nView ) )->cDirPrv        := retFld( ::cCodigoProveedor, D():Proveedores( ::nView ), "DOMICILIO" )
      ( D():PedidosProveedores( ::nView ) )->cPobPrv        := retFld( ::cCodigoProveedor, D():Proveedores( ::nView ), "POBLACION" )
      ( D():PedidosProveedores( ::nView ) )->cProPrv        := retFld( ::cCodigoProveedor, D():Proveedores( ::nView ), "PROVINCIA" )
      ( D():PedidosProveedores( ::nView ) )->cPosPrv        := retFld( ::cCodigoProveedor, D():Proveedores( ::nView ), "CODPOSTAL" )
      ( D():PedidosProveedores( ::nView ) )->cDniPrv        := retFld( ::cCodigoProveedor, D():Proveedores( ::nView ), "NIF" )
      ( D():PedidosProveedores( ::nView ) )->nEstado        := 1
      ( D():PedidosProveedores( ::nView ) )->cCodPgo        := retFld( ::cCodigoProveedor, D():Proveedores( ::nView ), "FPAGO" )
      ( D():PedidosProveedores( ::nView ) )->cDivPed        := cDivEmp()
      ( D():PedidosProveedores( ::nView ) )->nVdvPed        := nChgDiv( cDivEmp(), D():Divisas( ::nView ) )
      ( D():PedidosProveedores( ::nView ) )->lSndDoc        := .t.
      ( D():PedidosProveedores( ::nView ) )->cCodUsr        := cCurUsr()
      ( D():PedidosProveedores( ::nView ) )->cCodDlg        := '00'
      ( D():PedidosProveedores( ::nView ) )->nRegIva        := 1
     
   ( D():PedidosProveedores( ::nView ) )->( dbunlock() ) 

Return ( self )

//---------------------------------------------------------------------------//

METHOD setLineasPedidos()

   local hLinea
   local nNumLin     := 1

   for each hLinea in ::aLineasPedidos

      ( D():PedidosProveedoresLineas( ::nView ) )->( dbappend() )
      
         ( D():PedidosProveedoresLineas( ::nView ) )->cSerPed  := 'A'
         ( D():PedidosProveedoresLineas( ::nView ) )->nNumPed  := ::nNumeroPedido
         ( D():PedidosProveedoresLineas( ::nView ) )->cSufPed  := '00'
         ( D():PedidosProveedoresLineas( ::nView ) )->cRef     := hLinea['Articulo']         
         ( D():PedidosProveedoresLineas( ::nView ) )->cRefPrv  := hLinea['ReferenciaProveedor']
         ( D():PedidosProveedoresLineas( ::nView ) )->cDetalle := hLinea['Descripcion']
         ( D():PedidosProveedoresLineas( ::nView ) )->nIva     := hLinea['PorcentajeImpuesto']
         ( D():PedidosProveedoresLineas( ::nView ) )->nUniCaja := hLinea['Unidades']
         ( D():PedidosProveedoresLineas( ::nView ) )->nPreDiv  := hLinea['PrecioCosto']
         ( D():PedidosProveedoresLineas( ::nView ) )->cCodPr1  := hLinea['CodigoPropiedad1']
         ( D():PedidosProveedoresLineas( ::nView ) )->cCodPr2  := hLinea['CodigoPropiedad2']
         ( D():PedidosProveedoresLineas( ::nView ) )->cValPr1  := hLinea['ValorPropiedad1']
         ( D():PedidosProveedoresLineas( ::nView ) )->cValPr2  := hLinea['ValorPropiedad2']         
         ( D():PedidosProveedoresLineas( ::nView ) )->nCtlStk  := 1
         ( D():PedidosProveedoresLineas( ::nView ) )->cAlmLin  := hLinea['Almacen']
         ( D():PedidosProveedoresLineas( ::nView ) )->lLote    := .f.         
         ( D():PedidosProveedoresLineas( ::nView ) )->nNumLin  := ::getNumeroLinea(hLinea)
         ( D():PedidosProveedoresLineas( ::nView ) )->cCodFam  := hLinea['Familia']
         ( D():PedidosProveedoresLineas( ::nView ) )->nEstado  := 1

      nNumLin++
      ( D():PedidosProveedoresLineas( ::nView ) )->( dbunlock() )

   next 

Return ( self )

//---------------------------------------------------------------------------//

METHOD getNumeroLinea( hLinea )

   if hLinea['Articulo'] != ::codigoArticuloAnterior
      ::codigoArticuloAnterior   := hLinea['Articulo']
      ::numeroLinea++
   endif

Return ( ::numeroLinea )

//---------------------------------------------------------------------------//

METHOD setTotalesPedido()

   local sPedido 

   sPedido     := sTotPedPrv( D():PedidosProveedoresId( ::nView ), D():PedidosProveedores (::nView ), D():PedidosProveedoresLineas (::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ) )

   if ( D():PedidosProveedores( ::nView ) )->( dbrlock() )

      ( D():PedidosProveedores( ::nView ) )->nTotNet    := sPedido:nTotalNeto
      ( D():PedidosProveedores( ::nView ) )->nTotIva    := sPedido:nTotalIva
      ( D():PedidosProveedores( ::nView ) )->nTotReq    := sPedido:nTotalRecargoEquivalencia
      ( D():PedidosProveedores( ::nView ) )->nTotPed    := sPedido:nTotalDocumento

      ( D():PedidosProveedores( ::nView ) )->( dbunlock() )
   end if

Return ( self )

//---------------------------------------------------------------------------//


      


