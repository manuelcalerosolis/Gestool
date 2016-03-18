#include "hbclass.ch"

#define CRLF                           chr( 13 ) + chr( 10 )

#define OFN_PATHMUSTEXIST              0x00000800
#define OFN_NOCHANGEDIR                0x00000008
#define OFN_ALLOWMULTISELECT           0x00000200
#define OFN_EXPLORER                   0x00080000     // new look commdlg
#define OFN_LONGNAMES                  0x00200000     // force long names for 3.x modules
#define OFN_ENABLESIZING               0x00800000

//---------------------------------------------------------------------------//

Function Inicio()

   ImportadorFacturas():New()

   msgInfo( "Proceso finalizado")

Return ( nil )

//---------------------------------------------------------------------------//

CLASS ImportadorFacturas

   DATA oOleExcel

   DATA aExcelFiles                       INIT {}

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
   DATA porcentajeIVA1
   DATA porcentajeRecargoEquivalencia1
   DATA importeFactura1

   DATA baseImponible2
   DATA porcentajeIVA2
   DATA porcentajeRecargoEquivalencia2
   DATA importeFactura2

   DATA baseImponible3
   DATA porcentajeIVA3
   DATA porcentajeRecargoEquivalencia3
   DATA importeFactura3

   DATA porcentajeRetencion

   DATA totalFactura

   METHOD New()                           CONSTRUCTOR

   METHOD openExcelFile()
   METHOD closeExcelFile()

   METHOD selectExcelFile()  

   METHOD processFile()

      METHOD getCompanyCode()             INLINE ( ::companyCode  := ::getCharacterWithoutPoint( ::getCharacter( "A", 2 ) ) )
      METHOD getRow()
      METHOD isValidRow()
      METHOD processRow()
      METHOD emptyRow()                   INLINE ( empty( ::fechaApunte ) )
      
      METHOD buildInvoice()
         METHOD buildSales()

   METHOD buildAccountingExportFile()     

   METHOD getRange()
      METHOD getDate()
      METHOD getNumeric()
      METHOD getCharacter( cColumn )
      METHOD getCharacterWithoutPoint( cCharacter )

   METHOD addErrors( errorDescription )   INLINE ( ::validRow := .f., aadd( ::aErrors, errorDescription + ", en línea " + alltrim( str( ::nRow ) ) ) )
   METHOD cleanErrors()                   INLINE ( ::aErrors := {} )
   METHOD emptyErrors()                   INLINE ( empty( ::aErrors ) )
   METHOD showErrors() 

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ImportadorFacturas

   local cExcelFile

   EnlaceA3():getInstance()

   ::selectExcelFile()

   if empty( ::aExcelFiles )
      Return ( Self )
   end if 

   for each cExcelFile in ::aExcelFiles
      if !empty( cExcelFile )
         msgRun( "Procesando hoja de calculo " + alltrim( cExcelFile ), "Espere", {|| ::ProcessFile( cExcelFile ) } )
      end if 
   next 

   if ::emptyErrors()
      ::buildAccountingExportFile()
   else
      ::showErrors()
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD selectExcelFile() CLASS ImportadorFacturas

   local i
   local cFile
   local aFile
   local nFlag    := nOr( OFN_PATHMUSTEXIST, OFN_NOCHANGEDIR, OFN_ALLOWMULTISELECT, OFN_EXPLORER, OFN_LONGNAMES )

   ::aExcelFiles  := {}

   cFile          := cGetFile( "Excel ( *.Xls ) | *.xls |Excel ( *.Xlsx ) | *.xlsx", "Seleccione los ficheros a importar", "*.*" , , .f., .t., nFlag )
   cFile          := left( cFile, at( chr( 0 ) + chr( 0 ), cFile ) - 1 )

   if !empty( cFile ) 

      cFile       := strtran( cFile, chr( 0 ), "," )
      aFile       := hb_atokens( cFile, "," )

      if len( aFile ) > 1

         for i := 2 to Len( aFile )
            aFile[ i ] := aFile[ 1 ] + "\" + aFile[ i ]
         next

         adel( aFile, 1, .t. )

      endif

      if IsArray( aFile )

         for i := 1 to Len( aFile )
            aadd( ::aExcelFiles, aFile[ i ] ) 
         next

      else

         aadd( ::aExcelFiles, aFile )

      endif

   end if

RETURN ( ::aExcelFiles )

//---------------------------------------------------------------------------//

METHOD openExcelFile( cExcelFile )

   local oError
   local oBlock

   oBlock                              := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oOleExcel                         := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

   ::oOleExcel:oExcel:Visible          := .f.
   ::oOleExcel:oExcel:DisplayAlerts    := .f.
   ::oOleExcel:oExcel:WorkBooks:Open( cExcelFile )

   ::oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

   RECOVER USING oError
       msgStop( "Imposible importar datos de excel" + CRLF + ErrorMessage( oError ) )
   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( .t.  )

//---------------------------------------------------------------------------//

METHOD closeExcelFile()

   if empty( ::oOleExcel )
      Return ( .f. )
   end if 

   ::oOleExcel:oExcel:WorkBooks:Close() 
   ::oOleExcel:oExcel:Quit()
   ::oOleExcel:oExcel:DisplayAlerts   := .t.

   ::oOleExcel:End()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ProcessFile( cExcelFile ) CLASS ImportadorFacturas

   local oError
   local oBlock

   // oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   // BEGIN SEQUENCE

   CursorWait()

      if !::openExcelFile( cExcelFile )
         Return .f.
      end if 

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
            ::buildInvoice()
         end if 

         sysrefresh()

      next

      ::closeExcelFile()

   CursorWE()

   // RECOVER USING oError

   //    msgStop( "Imposible importar datos de excel" + CRLF + ErrorMessage( oError ) )

   // END SEQUENCE

   // ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getRow() CLASS ImportadorFacturas

   ::fechaApunte                    := ::getDate( "A" )
   ::cuentaCliente                  := ::getCharacterWithoutPoint( ::getCharacter( "B" ) )
   ::descripcionCuentaCliente       := ::getCharacter( "C" )
   ::numeroFactura                  := ::getCharacterWithoutPoint( ::getCharacter( "D" ) )
   ::descripcionApunte              := ::getCharacter( "E" )
   ::nifCliente                     := ::getCharacterWithoutPoint( ::getCharacter( "F" ) )
   ::nombreCliente                  := ::getCharacter( "G" )
   ::codigoPostalCliente            := ::getCharacterWithoutPoint( ::getCharacter( "H" ) )
   ::fechaFactura                   := ::getDate( "I" )
   ::cuentaVenta                    := ::getCharacterWithoutPoint( ::getCharacter( "J" ) )
   ::descripcionCuentaVenta         := ::getCharacter( "K" )

   ::baseImponible1                 := ::getNumeric( "L" )
   ::porcentajeIVA1                 := ::getNumeric( "M" )
   ::porcentajeRecargoEquivalencia1 := ::getNumeric( "N" )
   ::importeFactura1                := ::getNumeric( "P" )

   ::baseImponible2                 := ::getNumeric( "Q" )
   ::porcentajeIVA2                 := ::getNumeric( "R" )
   ::porcentajeRecargoEquivalencia2 := ::getNumeric( "S" )
   ::importeFactura2                := ::getNumeric( "T" ) 

   ::baseImponible3                 := ::getNumeric( "U" )
   ::porcentajeIVA3                 := ::getNumeric( "V" )
   ::porcentajeRecargoEquivalencia3 := ::getNumeric( "W" )
   ::importeFactura3                := ::getNumeric( "X" )

   ::porcentajeRetencion            := ::getNumeric( "O" )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD isValidRow() CLASS ImportadorFacturas

   ::validRow     := .t.

   if( empty( ::fechaApunte               ), ::addErrors( "Fecha de apunte vacia" ), )
   if( empty( ::cuentaCliente             ), ::addErrors( "Cuenta de cliente vacia" ), )
   if( empty( ::descripcionCuentaCliente  ), ::addErrors( "Descripción de cuenta cliente vacia" ), )
   if( empty( ::numeroFactura             ), ::addErrors( "Número de factura vacia" ), )
   if( empty( ::descripcionApunte         ), ::addErrors( "Descripción de apunte vacio" ), )
   if( empty( ::nifCliente                ), ::addErrors( "NIF de cliente vacio" ), )
   if( empty( ::nombreCliente             ), ::addErrors( "Nombre de cliente vacio" ), )
   if( empty( ::codigoPostalCliente       ), ::addErrors( "Código postal de cliente vacio" ), )
   if( empty( ::fechaFactura              ), ::addErrors( "Fecha de factura vacia" ), )
   if( empty( ::cuentaVenta               ), ::addErrors( "Cuenta de venta vacia" ), )
   if( empty( ::baseImponible1            ), ::addErrors( "Base imponible vacia" ), )
   if( empty( ::porcentajeIVA1            ), ::addErrors( "Porcentaje de IVA vacio" ), )
   if( empty( ::importeFactura1           ), ::addErrors( "Importe de factura vacio" ), )

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

   if valtype( nValue ) == "C"
      nValue      := Val( StrTran( nValue, ",", "." ) )
   end if 

   if valtype( nValue ) == "U"
      nValue      := 0
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

METHOD getCharacterWithoutPoint( cCharacter )

   local nPointPosition    := at( ".", cCharacter ) 

   if nPointPosition != 0
      RETURN ( substr( cCharacter, 1, nPointPosition - 1 ) )
   end if

RETURN ( cCharacter )

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

METHOD buildInvoice()

   ::buildSales()

   aadd( ::aInvoices,{  "Id"                    => ::nRow,;
                        "Empresa"               => ::companyCode,;
                        "Fecha"                 => ::fechaApunte ,;
                        "TipoRegistro"          => '1',; // Facturas
                        "Cuenta"                => ::cuentaCliente,;
                        "DescripcionCuenta"     => ::descripcionCuentaCliente,;
                        "TipoFactura"           => '1',; // Ventas
                        "NumeroFactura"         => ::numeroFactura,;
                        "DescripcionApunte"     => ::descripcionApunte,;
                        "Importe"               => ::totalFactura,;
                        "Nif"                   => ::nifCliente,;
                        "NombreCliente"         => ::nombreCliente,;
                        "CodigoPostal"          => ::codigoPostalCliente,;
                        "FechaOperacion"        => ::fechaFactura,;
                        "FechaFactura"          => ::fechaFactura,;
                        "Moneda"                => 'E',; // Euros
                        "Render"                => 'CabeceraFactura',;
                        "Sales"                 => ::aSales } )

   msgAlert( hb_valtoexp( ::aInvoices ) )

Return ( self )   

//------------------------------------------------------------------------

METHOD buildSales()

   ::aSales       := {}

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
                        "BaseImponible"         => ::baseImponible1,;
                        "PorcentajeIVA"         => ::porcentajeIVA1,;
                        "PorcentajeRecargo"     => ::porcentajeRecargoEquivalencia1,;
                        "PorcentajeRetencion"   => ::porcentajeRetencion,;
                        "Impreso"               => '01',; // 347
                        "SujetaIVA"             => if( ::porcentajeIVA1 != 0, 'S', 'N' ),;
                        "Modelo415"             => ' ',;
                        "Analitico"             => ' ',;
                        "Moneda"                => 'E',; // Euros
                        "Render"                => 'VentaFactura' } )

   ::totalFactura    := ::importeFactura1

   if ::baseImponible2 != 0

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
                           "BaseImponible"         => ::baseImponible2,;
                           "PorcentajeIVA"         => ::porcentajeIVA2,;
                           "PorcentajeRecargo"     => ::porcentajeRecargoEquivalencia2,;
                           "PorcentajeRetencion"   => ::porcentajeRetencion,;
                           "Impreso"               => '01',; // 347
                           "SujetaIVA"             => if( ::porcentajeIVA1 != 0, 'S', 'N' ),;
                           "Modelo415"             => ' ',;
                           "Analitico"             => ' ',;
                           "Moneda"                => 'E',; // Euros
                           "Render"                => 'VentaFactura' } )

      ::totalFactura += ::importeFactura2

   end if 

   if ::baseImponible3 != 0

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
                           "BaseImponible"         => ::baseImponible3,;
                           "PorcentajeIVA"         => ::porcentajeIVA3,;
                           "PorcentajeRecargo"     => ::porcentajeRecargoEquivalencia3,;
                           "PorcentajeRetencion"   => ::porcentajeRetencion,;
                           "Impreso"               => '01',; // 347
                           "SujetaIVA"             => if( ::porcentajeIVA1 != 0, 'S', 'N' ),;
                           "Modelo415"             => ' ',;
                           "Analitico"             => ' ',;
                           "Moneda"                => 'E',; // Euros
                           "Render"                => 'VentaFactura' } )

      ::totalFactura += ::importeFactura3

   end if 

Return ( self )   

//------------------------------------------------------------------------

METHOD buildAccountingExportFile()

   local hSale
   local hInvoice

   for each hInvoice in ::aInvoices
      
      EnlaceA3():getInstance():Add( hInvoice )

      for each hSale in hInvoice[ "Sales" ]
         EnlaceA3():getInstance():Add( hSale )
      next

   next

   EnlaceA3():getInstance():Render()
   EnlaceA3():getInstance():WriteASCII()

Return ( self )

//------------------------------------------------------------------------
