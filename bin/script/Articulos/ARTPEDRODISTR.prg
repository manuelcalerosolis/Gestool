#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"
#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelArguelles( nView )                	 
	      
   local oImportarExcel    := TImportarExcelArguelles():New( nView )

   oImportarExcel:Run()

Return nil

//---------------------------------------------------------------------------//  

CLASS TImportarExcelArguelles FROM TImportarExcel
   
   DATA idArticulo
   DATA aImagenes

   METHOD New()

   METHOD Run()

   METHOD getCampoClave()        INLINE ( alltrim( ::getExcelString( ::cColumnaCampoClave ) ) )

   METHOD procesaFicheroExcel()

   METHOD filaValida()
   
   METHOD siguienteLinea()       INLINE ( ++::nFilaInicioImportacion )

   METHOD existeRegistro()       INLINE ( D():gotoArticulos( ::getCampoClave(), ::nView ) )

   METHOD appendRegistro()       INLINE ( ( D():Articulos( ::nView ) )->( dbappend() ) )

   METHOD desbloqueaRegistro()   INLINE ( ( D():Articulos( ::nView ) )->( dbcommit() ),;
                                          ( D():Articulos( ::nView ) )->( dbunlock() ) )

   METHOD importarCampos()

   METHOD getNombre()

   METHOD addLineStock()

   METHOD addHeadStock()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   ::aImagenes                := {}

   /*
   Cambiar el nombre del fichero-----------------------------------------------
   */

   ::cFicheroExcel            := "C:\ficheros\falart.xls"

   /*
   Cambiar la fila de cominezo de la importacion-------------------------------
   */

   ::nFilaInicioImportacion   := 2

   /*
   Columna de campo clave------------------------------------------------------
   */

   ::cColumnaCampoClave       := 'B'

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run()

   if !file( ::cFicheroExcel )
      msgStop( "El fichero " + ::cFicheroExcel + " no existe." )
      Return ( .f. )
   end if 

   msgrun( "Procesando fichero " + ::cFicheroExcel, "Espere por favor...",  {|| ::procesaFicheroExcel() } )

   msginfo( "Proceso finalizado" )

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD procesaFicheroExcel()

   ::openExcel()

   while ( ::filaValida() )

      if !::existeRegistro()
      
         ::importarCampos()

      end if 

      ::siguienteLinea()

   end if

   if Len( ::aImagenes ) != 0
      ::descargaImagenes()
   end if

   ::closeExcel()

   ::addHeadStock()

Return nil

//---------------------------------------------------------------------------//

METHOD importarCampos()

   local aNameImagen                            := {}

   ( D():Articulos( ::nView ) )->( dbappend() )

   ::idArticulo                                 := ::getCampoClave()

   ( D():Articulos( ::nView ) )->Codigo         := ::idArticulo

   if !empty( ::getExcelString( "D" ) )
      ( D():Articulos( ::nView ) )->Nombre      := ::getNombre( ::getExcelString( "D" ) )
   end if 

   if !empty( ::getExcelNumeric( "BA" ) )
      ( D():Articulos( ::nView ) )->pCosto      := ::getExcelNumeric( "BA" )
   end if

   if !empty( ::getExcelNumeric( "BB" ) )
      ( D():Articulos( ::nView ) )->pVenta1     := ::getExcelNumeric( "BB" )
      ( D():Articulos( ::nView ) )->pVtaIva1    := ( ::getExcelNumeric( "BB" ) * 1.21 )
   end if

   ( D():Articulos( ::nView ) )->Familia        := ::getExcelString( "C" )

   ( D():Articulos( ::nView ) )->nStkCal        := ::getExcelNumeric( "L" )

   ( D():Articulos( ::nView ) )->TipoIva        := "G"
   ( D():Articulos( ::nView ) )->nCtlStock      := 1
   ( D():Articulos( ::nView ) )->nLabel         := 1

   ::addLineStock()

   /*
   Desbloqueamos la tabla de artículos-----------------------------------------
   */

   ( D():Articulos( ::nView ) )->( dbcommit() )

   ( D():Articulos( ::nView ) )->( dbunlock() )

Return nil

//---------------------------------------------------------------------------// 

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

METHOD getNombre( cGet )

   local cNombre        := ""

   if at( CRLF, cGet ) != 0
      cNombre           := substr( cGet, 1, at( CRLF, cGet ) )
   else
      cNombre           := cGet
   end if

Return ( cNombre )

//---------------------------------------------------------------------------//

METHOD addLineStock()

   ( D():MovimientosAlmacenLineas( ::nView ) )->( dbAppend() )

   ( D():MovimientosAlmacenLineas( ::nView ) )->dFecMov   := GetSysDate()
   ( D():MovimientosAlmacenLineas( ::nView ) )->cTimMov   := GetSysTime()
   ( D():MovimientosAlmacenLineas( ::nView ) )->nTipMov   := 4
   ( D():MovimientosAlmacenLineas( ::nView ) )->cAliMov   := "000"
   ( D():MovimientosAlmacenLineas( ::nView ) )->cRefMov   := ::idArticulo
   ( D():MovimientosAlmacenLineas( ::nView ) )->cNomMov   := ::getNombre( ::getExcelString( "D" ) )
   ( D():MovimientosAlmacenLineas( ::nView ) )->cCodUsr   := "000"
   ( D():MovimientosAlmacenLineas( ::nView ) )->cCodDlg   := "00"
   ( D():MovimientosAlmacenLineas( ::nView ) )->nCajMov   := 1
   ( D():MovimientosAlmacenLineas( ::nView ) )->nUndMov   := ::getExcelNumeric( "L" )
   ( D():MovimientosAlmacenLineas( ::nView ) )->nPreDiv   := ::getExcelNumeric( "BA" )
   ( D():MovimientosAlmacenLineas( ::nView ) )->lSndDoc   := .t.
   ( D():MovimientosAlmacenLineas( ::nView ) )->nNumRem   := 1
   ( D():MovimientosAlmacenLineas( ::nView ) )->cSufRem   := "00"
   ( D():MovimientosAlmacenLineas( ::nView ) )->lSelDoc   := .t.
 
   ( D():MovimientosAlmacenLineas( ::nView ) )->( dbUnlock() )   

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD addHeadStock()

   ( D():MovimientosAlmacen( ::nView ) )->( dbAppend() )

   ( D():MovimientosAlmacen( ::nView ) )->nNumRem     := 1
   ( D():MovimientosAlmacen( ::nView ) )->cSufRem     := "00"
   ( D():MovimientosAlmacen( ::nView ) )->nTipMov     := 4
   ( D():MovimientosAlmacen( ::nView ) )->cCodUsr     := "000"
   ( D():MovimientosAlmacen( ::nView ) )->cCodDlg     := "00"
   ( D():MovimientosAlmacen( ::nView ) )->dFecRem     := GetSysDate()
   ( D():MovimientosAlmacen( ::nView ) )->cTimRem     := GetSysTime()
   ( D():MovimientosAlmacen( ::nView ) )->cAlmOrg     := "000"
   ( D():MovimientosAlmacen( ::nView ) )->cCodDiv     := "EUR"
   ( D():MovimientosAlmacen( ::nView ) )->nVdvDiv     := 1

   ( D():MovimientosAlmacen( ::nView ) )->( dbUnlock() )


Return ( .t. )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"