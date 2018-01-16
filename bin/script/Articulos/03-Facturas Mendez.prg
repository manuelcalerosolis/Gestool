#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"
#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelArguelles( nView )                	 
	      
   local oImportarExcel    := TImportarExcelClientes():New( nView )

   oImportarExcel:Run()      

Return nil

//---------------------------------------------------------------------------//  

CLASS TImportarExcelClientes FROM TImportarExcel

   METHOD New()

   METHOD Run()

   METHOD getCampoClave()        INLINE ( ::getExcelNumeric( ::cColumnaCampoClave ) )

   METHOD procesaFicheroExcel()

   METHOD filaValida()
   
   METHOD siguienteLinea()       INLINE ( ++::nFilaInicioImportacion )

   METHOD existeRegistro()       INLINE ( D():gotoCliente( ::getCampoClave(), ::nView ) )

   METHOD importarCampos()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   /*
   Cambiar el nombre del fichero-----------------------------------------------
   */

   ::cFicheroExcel            := "C:\ficheros\Facturas.xls"

   /*
   Cambiar la fila de cominezo de la importacion-------------------------------
   */

   ::nFilaInicioImportacion   := 3603

   /*
   Columna de campo clave------------------------------------------------------
   */

   ::cColumnaCampoClave       := 'M'

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

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD importarCampos()

   local cCodCli
   local nTotalFactura        := 0

   ( D():FacturasClientes( ::nView ) )->( dbappend() )

   if !empty( ::getExcelString( "A" ) )
      ( D():FacturasClientes( ::nView ) )->cSerie        := ::getExcelString( "A" )
   end if 

   if !empty( ::getExcelString( "B" ) )
      ( D():FacturasClientes( ::nView ) )->nNumFac       := ::getExcelNumeric( "B" )
   end if 

   if !empty( ::getExcelString( "E" ) )
      ( D():FacturasClientes( ::nView ) )->cCodCli       := ::getExcelString( "E" )
      cCodCli                                            := ::getExcelString( "E" )
   end if

   if !empty( ::getExcelString( "C" ) )
      ( D():FacturasClientes( ::nView ) )->dFecFac       := ctod( ::getExcelString( "C" ) )
   end if

   if !empty( ::getExcelString( "I" ) )
      ( D():FacturasClientes( ::nView ) )->nTotNet       := ::getExcelNumeric( "I" )
      nTotalFactura                                      := ::getExcelNumeric( "I" )
   end if

   if !empty( ::getExcelString( "J" ) )
      ( D():FacturasClientes( ::nView ) )->nTotIva       := ::getExcelNumeric( "J" )
      nTotalFactura                                      += ::getExcelNumeric( "J" )
   end if

   if !empty( ::getExcelString( "L" ) )
      ( D():FacturasClientes( ::nView ) )->nTotReq       := ::getExcelNumeric( "L" )
      nTotalFactura                                      += ::getExcelNumeric( "L" )
   end if

   ( D():FacturasClientes( ::nView ) )->nTotFac          := nTotalFactura

   ( D():FacturasClientes( ::nView ) )->cSufFac          := "00"
   ( D():FacturasClientes( ::nView ) )->cCodDlg          := "00"
   ( D():FacturasClientes( ::nView ) )->cCodAlm          := "001"
   ( D():FacturasClientes( ::nView ) )->cCodCaj          := "000"
   ( D():FacturasClientes( ::nView ) )->cTurFac          := "1"
   ( D():FacturasClientes( ::nView ) )->lModCli          := .t.
   ( D():FacturasClientes( ::nView ) )->mComEnt          := "Factura pasada por virus"
   ( D():FacturasClientes( ::nView ) )->cDtoEsp          := Padr( "General", 50 )
   ( D():FacturasClientes( ::nView ) )->cDpp             := Padr( "Pronto pago", 50 )
   ( D():FacturasClientes( ::nView ) )->lSndDoc          := .t.
   ( D():FacturasClientes( ::nView ) )->cDivFac          := "EUR"
   ( D():FacturasClientes( ::nView ) )->nVdvFac          := 1
   ( D():FacturasClientes( ::nView ) )->cCodUsr          := "000"
   ( D():FacturasClientes( ::nView ) )->cCodUsr          := "000"
   ( D():FacturasClientes( ::nView ) )->tFecFac          := "08:00:00"
   ( D():FacturasClientes( ::nView ) )->nTarifa          := 1

   if ( D():Clientes( ::nView ) )->( dbSeek( cCodCli ) )
      ( D():FacturasClientes( ::nView ) )->cNomCli       := ( D():Clientes( ::nView ) )->Titulo
      ( D():FacturasClientes( ::nView ) )->cDirCli       := ( D():Clientes( ::nView ) )->Domicilio
      ( D():FacturasClientes( ::nView ) )->cPobCli       := ( D():Clientes( ::nView ) )->Poblacion
      ( D():FacturasClientes( ::nView ) )->cPrvCli       := ( D():Clientes( ::nView ) )->Provincia
      ( D():FacturasClientes( ::nView ) )->cPosCli       := ( D():Clientes( ::nView ) )->CodPostal
      ( D():FacturasClientes( ::nView ) )->cDniCli       := ( D():Clientes( ::nView ) )->Nif
      ( D():FacturasClientes( ::nView ) )->cCodAge       := ( D():Clientes( ::nView ) )->cAgente
      ( D():FacturasClientes( ::nView ) )->cCodRut       := ( D():Clientes( ::nView ) )->cCodRut
      ( D():FacturasClientes( ::nView ) )->cCodTar       := ( D():Clientes( ::nView ) )->cCodTar
      ( D():FacturasClientes( ::nView ) )->cCodPago      := ( D():Clientes( ::nView ) )->CodPago
      ( D():FacturasClientes( ::nView ) )->lRecargo      := ( D():Clientes( ::nView ) )->lReq
   end if

   ( D():FacturasClientes( ::nView ) )->( dbcommit() )

   ( D():FacturasClientes( ::nView ) )->( dbunlock() )

   /*
   Metemos las lineas----------------------------------------------------------
   */


   ( D():FacturasClientesLineas( ::nView ) )->( dbappend() )

   if !empty( ::getExcelString( "A" ) )
      ( D():FacturasClientesLineas( ::nView ) )->cSerie        := ::getExcelString( "A" )
   end if 

   if !empty( ::getExcelString( "B" ) )
      ( D():FacturasClientesLineas( ::nView ) )->nNumFac       := ::getExcelNumeric( "B" )
   end if 

   if !empty( ::getExcelString( "I" ) )
      ( D():FacturasClientesLineas( ::nView ) )->nPreUnit      := ::getExcelNumeric( "I" )
   end if

   if !empty( ::getExcelString( "H" ) )
      ( D():FacturasClientesLineas( ::nView ) )->nIva          := ::getExcelNumeric( "H" )
   end if

   if !empty( ::getExcelString( "C" ) )
      ( D():FacturasClientesLineas( ::nView ) )->dFecFac       := ctod( ::getExcelString( "C" ) )
   end if

   if !empty( ::getExcelString( "K" ) )
      ( D():FacturasClientesLineas( ::nView ) )->nReq          := ::getExcelNumeric( "K" )
   end if

   ( D():FacturasClientesLineas( ::nView ) )->cSufFac          := "00"
   ( D():FacturasClientesLineas( ::nView ) )->cDetalle         := "Líneas perdidas por el virus"
   ( D():FacturasClientesLineas( ::nView ) )->mLngDes          := "Líneas perdidas por el virus"
   ( D():FacturasClientesLineas( ::nView ) )->nCanEnt          := 1
   ( D():FacturasClientesLineas( ::nView ) )->nUniCaja         := 1
   ( D():FacturasClientesLineas( ::nView ) )->nNumLin          := 1
   ( D():FacturasClientesLineas( ::nView ) )->cAlmLin          := "000"
   ( D():FacturasClientesLineas( ::nView ) )->cCodCli          := cCodCli


   ( D():FacturasClientesLineas( ::nView ) )->( dbcommit() )

   ( D():FacturasClientesLineas( ::nView ) )->( dbunlock() )

   logwrite( ::getExcelString( "A" ) + Str( ::getExcelNumeric( "B" ) ) + "-" + Str( ::getExcelValue( ::cColumnaCampoClave ) ) )

Return nil

//---------------------------------------------------------------------------// 

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"