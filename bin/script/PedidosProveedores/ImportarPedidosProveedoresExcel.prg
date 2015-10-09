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
   
   DATA nRowTalla
   DATA nColumnTalla

   METHOD New()
   
   METHOD isFile()

   METHOD processFile()
      METHOD isOpenFile()
      METHOD closeFile()
   
      METHOD getTallas()
         METHOD isFilaTallas()
         METHOD getValoresTallas()
         METHOD addValoresTallas( cValueTalla, nColumna )

   METHOD getActiveSheetValue( nRow, nCol )  INLINE ( ::oActiveSheet:Cells( nRow, nCol ):Value )

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
      hset( ::hTallas, cValueTalla, nColumna )
   end if 

Return ( self )

//---------------------------------------------------------------------------//

      


