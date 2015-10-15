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

   msgalert( "terminado" )
   
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

   DATA cReferenciaProveedor
   DATA cCodigoArticulo
   DATA cCodigoColor
   DATA cDescrpcionArticulo

   DATA cTalla       
   DATA cColor 
   DATA nUnidades

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
         METHOD setLineasPedidos()

   METHOD getCodigoColor( cColorDescripcion )

   METHOD getActiveSheetValue( nRow, nCol )  INLINE ( ::oActiveSheet:Cells( nRow, nCol ):Value )

   METHOD getTallaFromColumna( nCol )        INLINE ( if( hhaskey( ::hTallas, nCol ), hGet( ::hTallas, nCol ), "" ) )

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
         if ::isLineaTotal()
            msgAlert( ::getRow(), "isLineaTotal" ) 
         endif
      end while

      msgAlert( hb_valtoexp( ::aLineasPedidos ), "aLineasPedidos" )

      // ::setLineasPedidos()
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
      msgAlert( padr( '00001', 20 ) + cColorDescripcion, "no existe" )
   end if 

   ( D():PropiedadesLineas( ::nView ) )->( ordsetfocus( ordAnterior ) ) 

Return ( cCodigoColor )

//---------------------------------------------------------------------------//

METHOD getUnidadesPorTallas( nUnidades, nCol ) 

   local cTalla

   ::cTalla       := ""
   ::nUnidades    := 0

   cTalla         := ::getTallaFromColumna( nCol )

   if !empty( cTalla )
      ::cTalla       := cTalla
      ::nUnidades    := nUnidades
   end if 

Return ( self ) 

//---------------------------------------------------------------------------//

METHOD setLineasPedidos()

   local cTalla
   local hLinea  :=  {=>}

   for each cTalla in ::hTallas

      hLinea  :=  {=>}

      if hhaskey( ::hTallasColores, cTalla )

         hset( hLinea, "Articulo", substr( ::cCodigoArticulo, 1, at( " ", ::cCodigoArticulo ) - 1 ) )  
         hset( hLinea, "ReferenciaProveedor", ::cReferenciaProveedor)
         hset( hLinea, "DescripcionArticulo", substr( ::cCodigoArticulo, at(" ", ::cCodigoArticulo )+1 ) )
         hset( hLinea, "PorcentajeImpuesto", 21 )           //hay que buscarlo en la ficha del art
         hset( hLinea, "Unidades", hGet( ::hTallasColores, cTalla ) )
         hset( hLinea, "CodigoPropiedad1", '00001')
         hset( hLinea, "CodigoPropiedad2", '00002')
         hset( hLinea, "ValorPropiedad1", 'cCodigoColor')   //aqui tengo el nombre, debo buscar el codigo en la tabla de propiedades
         hset( hLinea, "ValorPropiedad2", cTalla )
         hset( hLinea, "Almacen", '000' )
         hset( hLinea, "PrecioCosto", 16.95 )               //hay que buscarlo en la ficha del art
         hset( hLinea, "Familia", '323' )                   //hay que buscarlo en la ficha del art

         aAdd( ::aLineasPedidos, hLinea)

      end if

   next 

   msgAlert( hb_valtoexp( ::aLineasPedidos), " final aLineasPedidos")

Return ( self )

//---------------------------------------------------------------------------//

METHOD addLineasPedido()

   local hLinea  :=  {=>}

   if !empty(::cCodigoArticulo)

      hset( hLinea, "Articulo", ::cCodigoArticulo )  
      hset( hLinea, "Descripcion", ::cDescrpcionArticulo )
      hset( hLinea, "ReferenciaProveedor", ::cReferenciaProveedor )
      hset( hLinea, "PorcentajeImpuesto", 21 )           //hay que buscarlo en la ficha del art
      hset( hLinea, "Unidades", ::nUnidades )
      hset( hLinea, "CodigoPropiedad1", '00001')
      hset( hLinea, "CodigoPropiedad2", '00002')
      hset( hLinea, "ValorPropiedad1", ::cCodigoColor )   //aqui tengo el nombre, debo buscar el codigo en la tabla de propiedades
      hset( hLinea, "ValorPropiedad2", ::cTalla )
      hset( hLinea, "Almacen", '000' )
      hset( hLinea, "PrecioCosto",  retFld( ::cCodigoArticulo, D():Articulos( ::nView ), "pCosto" ) )                //hay que buscarlo en la ficha del art
      hset( hLinea, "Familia",      retFld( ::cCodigoArticulo, D():Articulos( ::nView ), "Familia" ) )               //hay que buscarlo en la ficha del art

      aAdd( ::aLineasPedidos, hLinea)

   end if

   

Return ( self )

//---------------------------------------------------------------------------//                



      


