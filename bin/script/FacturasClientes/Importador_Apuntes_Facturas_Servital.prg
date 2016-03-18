#include "hbclass.ch"

#define CRLF                           chr( 13 ) + chr( 10 )

#define OFN_PATHMUSTEXIST              0x00000800
#define OFN_NOCHANGEDIR                0x00000008
#define OFN_ALLOWMULTISELECT           0x00000200
#define OFN_EXPLORER                   0x00080000     // new look commdlg
#define OFN_LONGNAMES                  0x00200000     // force long names for 3.x modules
#define OFN_ENABLESIZING               0x00800000

#define __porcentajeIVA__            1.21 

//---------------------------------------------------------------------------//

Function Inicio()

   ImportadorFacturas():New()

   msgInfo( "Proceso finalizado")

Return ( nil )

//---------------------------------------------------------------------------//

CLASS ImportadorFacturas

   DATA oOleExcel

   DATA aFichero                          INIT {}

   DATA aErrors                           INIT {}
   
   DATA nRow
   DATA nLineaComienzo                    INIT 4

   DATA validRow                          INIT .t.

   DATA companyCode                       INIT ""

   DATA aInvoices                         INIT {}
   DATA aSales                            INIT {}

   DATA fechaApunte
   DATA cuentaCliente
   DATA descripcionCuentaCliente
   DATA numeroFactura
   DATA descripcionApunte
   DATA nifCliente
   DATA nombreCliente
   DATA codigoPostalCliente
   DATA fechaFactura
   DATA cuentaVenta
   DATA descripcionCuentaVenta

   DATA baseImponible1
   DATA porcentajeIVA
   DATA porcentajeRecargoEquivalencia
   DATA porcentajeRetencion
   DATA importeFactura   

   METHOD New()                           CONSTRUCTOR

   METHOD addFichero()  

   METHOD processFile()

      METHOD getCompanyCode()             INLINE ( ::companyCode  := ::getCharacter( "A", 2 ) )
      METHOD getRow()
      METHOD isValidRow()
      METHOD processRow()
      METHOD emptyRow()                   INLINE ( empty( ::fechaApunte ) )
      
      METHOD buildAccountingEntry()
         METHOD buildSales()
         METHOD buildInvoice()         

   METHOD buildAccountingExportFile()     VIRTUAL

   METHOD getRange()
      METHOD getDate()
      METHOD getNumeric()
      METHOD getCharacter( cColumn )

   METHOD addErrors( errorDescription )   INLINE ( ::validRow := .f., aadd( ::aErrors, errorDescription + ", en línea " + alltrim( str( ::nRow ) ) ) )
   METHOD cleanErrors()                   INLINE ( ::aErrors := {} )
   METHOD emptyErrors()                   INLINE ( empty( ::aErrors ) )
   METHOD showErrors() 

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ImportadorFacturas

   local cFichero

   ::addFichero()
   if empty( ::aFichero )
      Return ( Self )
   end if 

   for each cFichero in ::aFichero
      if !empty( cFichero )
         msgRun( "Procesando hoja de calculo " + cFichero, "Espere", {|| ::ProcessFile( cFichero ) } )
      end if 
   next 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddFichero() CLASS ImportadorFacturas

   local i
   local cFile
   local aFile
   local nFlag    := nOr( OFN_PATHMUSTEXIST, OFN_NOCHANGEDIR, OFN_ALLOWMULTISELECT, OFN_EXPLORER, OFN_LONGNAMES )

   ::aFichero     := {}

   cFile          := cGetFile( "Excel ( *.Xls ) | *.xls |Excel ( *.Xlsx ) | *.xlsx", "Seleccione los ficheros a importar", "*.*" , , .f., .t., nFlag )
   cFile          := Left( cFile, At( Chr( 0 ) + Chr( 0 ), cFile ) - 1 )

   if !Empty( cFile ) //.or. Valtype( cFile ) == "N"

      cFile       := StrTran( cFile, Chr( 0 ), "," )
      aFile       := hb_aTokens( cFile, "," )

      if Len( aFile ) > 1

         for i := 2 to Len( aFile )
            aFile[ i ] := aFile[ 1 ] + "\" + aFile[ i ]
         next

         aDel( aFile, 1, .t. )

      endif

      if IsArray( aFile )

         for i := 1 to Len( aFile )
            aAdd( ::aFichero, aFile[ i ] ) // if( SubStr( aFile[ i ], 4, 1 ) == "\", aFileDisc( aFile[i] ) + "\" + aFileName( aFile[ i ] ), aFile[ i ] ) )
         next

      else

         aAdd( ::aFichero, aFile )

      endif

   end if

RETURN ( ::aFichero )

//---------------------------------------------------------------------------//

METHOD ProcessFile( cFichero ) CLASS ImportadorFacturas

   local oError
   local oBlock

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   CursorWait()

      ::oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      ::oOleExcel:oExcel:Visible         := .f.
      ::oOleExcel:oExcel:DisplayAlerts   := .f.
      ::oOleExcel:oExcel:WorkBooks:Open( cFichero )

      ::oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

      ::cleanErrors()

      ::getCompanyCode()

      // Recorremos la hoja de calculo--------------------------------------------

      sysrefresh()

      for ::nRow := ::nLineaComienzo to 65536

         msgWait( "Procesando linea " + str(::nRow), "", 0.0001 )

         ::getRow()

         if ::emptyRow()
            exit 
         end if

         if ::isValidRow()
            ::buildAccountingEntry()
         end if 

         sysrefresh()

      next

      // Montamos el fichero de exportacion contable ----------------------------

      if ::emptyErrors()

         ::buildAccountingExportFile()

         sysrefresh()

      else

         ::showErrors()

      end if 

      // Cerramos la conexion con el objeto oOleExcel-----------------------------

      ::oOleExcel:oExcel:WorkBooks:Close() 
      ::oOleExcel:oExcel:Quit()
      ::oOleExcel:oExcel:DisplayAlerts   := .t.

      ::oOleExcel:End()

      Msginfo( "Porceso finalizado con exito" )

   CursorWE()

   RECOVER USING oError

      msgStop( "Imposible importar datos de excel" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getRow() CLASS ImportadorFacturas

   ::fechaApunte                    := ::getDate( "A" )
   ::cuentaCliente                  := ::getCharacter( "B" )
   ::descripcionCuentaCliente       := ::getCharacter( "C" )
   ::numeroFactura                  := ::getCharacter( "D" )
   ::descripcionApunte              := ::getCharacter( "E" )
   ::nifCliente                     := ::getCharacter( "F" )
   ::nombreCliente                  := ::getCharacter( "G" )
   ::codigoPostalCliente            := ::getCharacter( "H" )
   ::fechaFactura                   := ::getDate( "I" )
   ::cuentaVenta                    := ::getCharacter( "J" )
   ::descripcionCuentaVenta         := ::getCharacter( "K" )

   ::baseImponible1                 := ::getNumeric( "L" )
   ::porcentajeIVA1                 := ::getNumeric( "M" )
   ::porcentajeRecargoEquivalencia1 := ::getNumeric( "N" )
   ::importeFactura1                := ::getNumeric( "P" )

   ::porcentajeRetencion            := ::getNumeric( "O" )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD isValidRow() CLASS ImportadorFacturas

   ::validRow     := .t.

   if( empty( ::fechaApunte                   ), ::addErrors( "Fecha de apunte vacia" ), )
   if( empty( ::cuentaCliente                 ), ::addErrors( "Cuenta de cliente vacia" ), )
   if( empty( ::descripcionCuentaCliente      ), ::addErrors( "Descripción de cuenta cliente vacia" ), )
   if( empty( ::numeroFactura                 ), ::addErrors( "Número de factura vacia" ), )
   if( empty( ::descripcionApunte             ), ::addErrors( "Descripción de apunte vacio" ), )
   if( empty( ::nifCliente                    ), ::addErrors( "NIF de cliente vacio" ), )
   if( empty( ::nombreCliente                 ), ::addErrors( "Nombre de cliente vacio" ), )
   if( empty( ::codigoPostalCliente           ), ::addErrors( "Código postal de cliente vacio" ), )
   if( empty( ::fechaFactura                  ), ::addErrors( "Fecha de factura vacia" ), )
   if( empty( ::cuentaVenta                   ), ::addErrors( "Cuenta de venta vacia" ), )
   // if( empty( ::descripcionCuentaVenta        ), ::addErrors( "Descripción de cuenta de venta vacia" ), )
   if( empty( ::baseImponible1                ), ::addErrors( "Base imponible vacia" ), )
   if( empty( ::porcentajeIVA                 ), ::addErrors( "Porcentaje de IVA vacio" ), )
   // if( empty( ::porcentajeRecargoEquivalencia ), ::addErrors( "Porcentaje de recargo de equivalencia vacio" ), )
   // if( empty( ::porcentajeRetencion           ), ::addErrors( "Porcentaje de rectención vacia" ), )
   if( empty( ::importeFactura                ), ::addErrors( "Importe de factura vacio" ), )

Return ( ::validRow )

//---------------------------------------------------------------------------//

METHOD ProcessRow() CLASS ImportadorFacturas

   msgAlert( ::fechaApunte )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getRange( cColumn, nRow ) CLASS ImportadorFacturas

   local oError
   local oBlock
   local uValue

   if nRow == nil
      nRow        := ::nRow
   end if 

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      uValue      := ::oOleExcel:oExcel:ActiveSheet:Range( cColumn + ltrim( str( nRow ) ) ):Value

   RECOVER USING oError

      msgStop( "Imposible obtener columna de excel" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( uValue )

//---------------------------------------------------------------------------//

METHOD getDate( cColumn, nRow ) CLASS ImportadorFacturas

   local dValue   := ::getRange( cColumn, nRow )

   if valtype( dValue ) == "C"
      dValue      := ctod( dValue )
   end if 

Return ( dValue )

//---------------------------------------------------------------------------//

METHOD getNumeric( cColumn, nRow ) CLASS ImportadorFacturas

   local nValue   := ::getRange( cColumn, nRow )

   if Valtype( nValue ) == "C"
      nValue      := Val( StrTran( nValue, ",", "." ) )
   end if 

Return ( nValue ) 

//------------------------------------------------------------------------

METHOD getCharacter( cColumn, nRow ) CLASS ImportadorFacturas

   local cValue   := ::getRange( cColumn, nRow )

   if Valtype( cValue ) != "C"
      cValue      := cValToChar( cValue )
   end if 

Return ( cValue ) 

//------------------------------------------------------------------------

METHOD showErrors()

   local cError
   local errorMessage   := ""

   for each cError in ::aErrors
      errorMessage      += cError
      errorMessage      += CRLF
   next

   msgStop( errorMessage, "Error al procesar" )

Return ( self )   

//------------------------------------------------------------------------

METHOD buildAccountingEntry()

   ::buildInvoice()
   ::buildSales()   

   msgAlert( hb_valtoexp( ::aInvoices ) )
   msgAlert( hb_valtoexp( ::aSales ) )

Return ( self )   

//------------------------------------------------------------------------

METHOD buildInvoice()

   aadd( ::aInvoices,{  "Id"                    => ::nRow,;
                        "Empresa"               => ::companyCode,;
                        "Fecha"                 => ::fechaApunte ,;
                        "TipoRegistro"          => '1',; // Facturas
                        "Cuenta"                => ::cuentaCliente,;
                        "DescripcionCuenta"     => ::descripcionCuentaCliente,;
                        "TipoFactura"           => '1',; // Ventas
                        "NumeroFactura"         => ::numeroFactura,;
                        "DescripcionApunte"     => ::descripcionApunte,;
                        "Importe"               => ::importeFactura,;
                        "Nif"                   => ::nifCliente,;
                        "NombreCliente"         => ::nombreCliente,;
                        "CodigoPostal"          => ::codigoPostalCliente,;
                        "FechaOperacion"        => ::fechaFactura,;
                        "FechaFactura"          => ::fechaFactura,;
                        "Moneda"                => 'E',; // Euros
                        "Render"                => 'CabeceraFactura' } )

Return ( self )   

//------------------------------------------------------------------------

METHOD buildSales()

   aadd( ::aSales,   {  "Id"                    => ::nRow,;
                        "Empresa"               => ::companyCode,;
                        "Fecha"                 => ::fechaApunte ,;
                        "TipoRegistro"          => '9',; // Facturas
                        "Cuenta"                => ::cuentaVenta,;
                        "DescripcionCuenta"     => ::descripcionCuentaCliente,;
                        "TipoImporte"           => 'C',;
                        "NumeroFactura"         => ::numeroFactura,;
                        "DescripcionApunte"     => ::descripcionApunte,;
                        "SubtipoFactura"        => '01',; // Ventas
                        "BaseImponible"         => ::baseImponible1;
                        "PorcentajeIVA"         => ::porcentajeIVA,;
                        "PorcentajeRecargo"     => ::porcentajeRecargoEquivalencia,;
                        "PorcentajeRetencion"   => ::porcentajeRetencion,;
                        "Impreso"               => '01',; // 347
                        "SujetaIVA"             => if( ::porcentajeIVA != 0, 'S', 'N' ),;
                        "Modelo415"             => ' ',;
                        "Analitico"             => ' ',;
                        "Moneda"                => 'E',; // Euros
                        "Render"                => 'VentaFactura' } )

Return ( self )   

//------------------------------------------------------------------------
