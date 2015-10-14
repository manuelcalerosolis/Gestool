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

   METHOD New()
   
   METHOD isFile()

   METHOD processFile()
      METHOD isOpenFile()
      METHOD closeFile()
   
      METHOD getTallas()
         METHOD isFilaTallas()
         METHOD getValoresTallas()
         METHOD addValoresTallas( cValueTalla, nColumna )

      METHOD getArticulo()      
      METHOD getTallaColorArticulo()
         METHOD getUnidadesPorTallas()
         METHOD setLineasPedidos()

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
      ::getArticulo()
      ::getTallaColorArticulo()
      // ::setLineasPedidos()
   end if 

   msgalert( hb_valtoexp( ::hTallasColores ), "hTallasColores")

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

      isOpen                        := .f.

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

    msgalert( hb_valtoexp( ::hTallas), "hTallas" )

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

METHOD getArticulo() CLASS ImportarPedidosProveedorExcel

   local nCol
   local uValue

   ::nextRow()

   ::cReferenciaProveedor  := ""
   ::cCodigoArticulo       := ""

   for nCol := 1 to 50
      uValue               := ::getActiveSheetValue( ::getRow(), nCol )    
      if !empty(uValue) 
         if empty( ::cReferenciaProveedor )
            ::cReferenciaProveedor  := alltrim( cvaltochar( uValue ) )
         else 
            ::cCodigoArticulo       := alltrim( cvaltochar( uValue ) )
         end if
      end if

   next 

   msgalert( ::cReferenciaProveedor, "cReferenciaProveedor" )
   msgalert( ::cCodigoArticulo, "cCodigoArticulo" )

Return ( self )

//----------------------------------------------------------------------------//

METHOD getTallaColorArticulo()

   local nCol
   local uValue

   ::nextRow()
   
   ::cCodigoColor    := ""

   for nCol := 1 to 50 

      uValue         :=  ::getActiveSheetValue( ::getRow(), nCol )

      if !empty(uValue) 
         if empty( ::cCodigoColor )
            ::cCodigoColor   := alltrim( cvaltochar( uValue ) )
         else
            ::getUnidadesPorTallas( uValue, nCol )
            ::addLineasPedido()
         end if 
      end if
   next 

   msgAlert( ::cCodigoColor, "cCodigoColor" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getUnidadesPorTallas( nUnidades, nCol ) 

   local cTalla

   ::cTalla       := ""
   ::nUnidades    := 0

   cTalla         := ::getTallaFromColumna( nCol )

   if !empty( cTalla )
      ::cTalla       := cTalla
      ::nUnidades    := nUnidades
      hset( ::hTallasColores, cTalla, nUnidades )
   end if 

Return ( self ) 

//---------------------------------------------------------------------------//

METHOD setLineasPedidos()

   local cTalla
   local hLinea  :=  {=>}

   for each cTalla in ::hTallas

      hLinea  :=  {=>}

      if hhaskey( ::hTallasColores, cTalla )

         hset( hLinea, "Articulo", substr( ::cCodigoArticulo, 1, at( " ", ::cCodigoArticulo )-1 ) )  
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

METHOD addLineasPedido()

   local hLinea  :=  {=>}

   ? ::cCodigoArticulo

   if .f.

      hset( hLinea, "Articulo", substr( ::cCodigoArticulo, 1, at( " ", ::cCodigoArticulo )-1 ) )  
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

Return ( self )

                



      


