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
   
   DATA nRowTalla
      METHOD getRow()                        INLINE ( ::nRowTalla )
      METHOD nextRow()                       INLINE ( ::nRowTalla++ )

   DATA nColumnTalla

   DATA cCodigoProveedor
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

   ? hb_valtoexp( ::hTallas, "hTallas" )

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

   ::nextRow()

   ::cCodigoProveedor   := ""
   ::cCodigoArticulo    := ""

   for nCol := 1 to 50
      uValue            := ::getActiveSheetValue( ::getRow(), nCol )    
      if !empty(uValue) 
         if empty( ::cCodigoProveedor )
            ::cCodigoProveedor   := alltrim( cvaltochar( uValue ) )
         else 
            ::cCodigoArticulo    := alltrim( cvaltochar( uValue ) )
         end if
      end if

   next 

   msgalert( ::cCodigoProveedor, "cCodigoProveedor" )
   msgalert( ::cCodigoArticulo, "cCodigoArticulo" )

Return ( self )

METHOD getTallaColorArticulo()

   local nCol

   ::nextRow()
   
   ::cCodigoColor    := ""

   for nCol := 1 to 50 
      uValue :=  ::getActiveSheetValue( ::getRow(), nCol )
      if !empty(uValue) 
         if empty( ::cCodigoColor )
            ::cCodigoColor   := alltrim( cvaltochar( uValue ) )
         else
            ::getUnidadesPorTallas( uValue, nCol )
         end if 
      end if
   next 

   msgAlert( hb_valtoexp( ::hTallasColores ), "hTallasColores" )

Return ( self )

METHOD getUnidadesPorTallas( uValue, nCol ) 

   local cTalla

   cTalla   := ::getTallaFromColumna( nCol )

   if !empty( cTalla )
      hset( ::hTallasColores, cTalla, uValue )
   end if 

Return ( self ) 






      


