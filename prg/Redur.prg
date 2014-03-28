#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

CLASS Redur FROM Cuaderno

   DATA cTipoRegisto                      INIT 'R00'
   DATA cCodigoCliente                    INIT 'CAZU' 
   DATA nTracking                         INIT 0
   DATA cRemitente                        INIT ''
   DATA cCodigoConsignatario              INIT ''
   DATA cDocumentacion                    INIT 'SALIDAS NACIONALES'
   DATA cProducto                         INIT '002'
   DATA dPreparacion                      INIT date() 
   DATA dRecogida                         INIT date() 
   DATA cNombreConsignatario              INIT ''
   DATA cDireccionConsignatario           INIT ''
   DATA cPoblacionConsignatario           INIT ''
   DATA cCodigoPostalConsignatario        INIT ''
   DATA cProvinciaConsignatario           INIT ''
   DATA cTipoMercancia                    INIT '05'
   DATA nBultos                           INIT 0
   DATA nPeso                             INIT 0
   DATA nVolumen                          INIT 0
   DATA cTipoPortes                       INIT 'P'
   DATA cReferencia                       INIT ''
   DATA cObservaciones1                   INIT ''
   DATA cObservaciones2                   INIT ''
   DATA cObservaciones3                   INIT ''
   DATA nValorAsegurado                   INIT 0
   DATA nNumeroFactura                    INIT 0
   DATA dFechaFactura                     INIT date()
   DATA nImporteFactura                   INIT 0
   DATA nImporteReembolso                 INIT 0 
   DATA cTipoServicio                     INIT     //¿A que se inicia?-------------------------------
   DATA cCodigoPais                       INIT 724 //¿Iniciado al Codigo de España?------------------
   DATA nVersionRedur                     INIT     //¿A que se inicia?-------------------------------
   DATA cNombreRemitente                  INIT ''
   DATA cDireccionRemitente               INIT ''
   DATA cPoblacionRemitente               INIT ''
   DATA cCodigoPostalRemitente            INIT ''
   DATA cColaborador                      INIT ''
   DATA cPlazaSalida                      INIT ''
   DATA nTotalBultosADR                   INIT 0
   DATA cNivelInformacionADR              INIT '0'
   DATA cAlbaranCliente                   INIT 'N' //¿Iniciado a "No"?-------------------------------
   DATA cDevolverAlbaranFirmado           INIT 'N' //¿Iniciado a "No"?-------------------------------
   DATA cInformacionAdicionalCliente      INIT ''
   DATA cNombreContacto                   INIT ''
   DATA cTelefonoContacto                 INIT ''
   DATA cTelefonoAlternativo              INIT ''
   DATA cEmailContacto                    INIT ''
   DATA cSmsContacto                      INIT ''
   DATA cDireccionAdicional               INIT ''
   DATA cDireccionAdicionalContinuacion   INIT ''
   DATA cInstruccionesAdicionales         INIT ''


   METHOD TipoRegisto( cValue )                    INLINE ( if( !Empty( cValue ), ::cTipoRegisto                     := cValue, padr( ::cTipoRegisto, 3 ) )
   METHOD CodigoCliente( cValue )                  INLINE ( if( !Empty( cValue ), ::cCodigoCliente                   := cValue, padr( ::cCodigoCliente, 12 ) )
   METHOD Tracking( cValue )                       INLINE ( if( !Empty( cValue ), ::nTracking                        := cValue, padr( str( ::nTracking ), 14 ) )
   METHOD Remitente( cValue )                      INLINE ( if( !Empty( cValue ), ::cRemitente                       := cValue, padr( ::cRemitente, 12 ) )
   METHOD CodigoConsignatario( cValue )            INLINE ( if( !Empty( cValue ), ::cCodigoConsignatario             := cValue, padr( ::cCodigoConsignatario, 12 ) )
   METHOD Documentacion( cValue )                  INLINE ( if( !Empty( cValue ), ::cDocumentacion                   := cValue, padr( ::cDocumentacion, 20 ) )
   METHOD Producto( cValue )                       INLINE ( if( !Empty( cValue ), ::cProducto                        := cValue, padr( ::cProducto, 3 ) )
   METHOD Preparacion( cValue )                    INLINE ( if( !Empty( cValue ), ::dPreparacion                     := cValue, dtos( ::dPreparacion ) )
   METHOD Recogida( cValue )                       INLINE ( if( !Empty( cValue ), ::dRecogida                        := cValue, dtos( ::dRecogida ) )
   METHOD NombreConsignatario( cValue )            INLINE ( if( !Empty( cValue ), ::cNombreConsignatario             := cValue, padr( ::cNombreConsignatario, 35 ) )
   METHOD DireccionConsignatario( cValue )         INLINE ( if( !Empty( cValue ), ::cDireccionConsignatario          := cValue, padr( ::cDireccionConsignatario, 60 ) )
   METHOD PoblacionConsignatario( cValue )         INLINE ( if( !Empty( cValue ), ::cPoblacionConsignatario          := cValue, padr( ::cPoblacionConsignatario, 35 ) )
   METHOD CodigoPostalConsignatario( cValue )      INLINE ( if( !Empty( cValue ), ::cCodigoPostalConsignatario       := cValue, padr( ::cCodigoPostalConsignatario, 10 ) )
   METHOD ProvinciaConsignatario( cValue )         INLINE ( if( !Empty( cValue ), ::cProvinciaConsignatario          := cValue, padr( ::cProvinciaConsignatario, 25 ) )
   METHOD TipoMercancia( cValue )                  INLINE ( if( !Empty( cValue ), ::cTipoMercancia                   := cValue, padr( ::cTipoMercancia, 2 ) )
   METHOD Bultos( cValue )                         INLINE ( if( !Empty( cValue ), ::nBultos                          := cValue, strzero( ::nBultos, 6 ) )
   METHOD Peso( cValue )                           INLINE ( if( !Empty( cValue ), ::nPeso                            := cValue, strzero( round( ::nPeso * 10, 0 ), 8 ) )
   METHOD Volumen( cValue )                        INLINE ( if( !Empty( cValue ), ::nVolumen                         := cValue, strzero( round( ::nVolumen * 100, 0 ), 6 ) )
   METHOD TipoPortes( cValue )                     INLINE ( if( !Empty( cValue ), ::cTipoPortes                      := cValue, padr( ::cTipoPortes, 1 ) )
   METHOD Referencia( cValue )                     INLINE ( if( !Empty( cValue ), ::cReferencia                      := cValue, padr( ::cReferencia, 22 ) )
   METHOD Observaciones1( cValue )                 INLINE ( if( !Empty( cValue ), ::cObservaciones1                  := cValue, padr( ::cObservaciones1, 40 ) )
   METHOD Observaciones2( cValue )                 INLINE ( if( !Empty( cValue ), ::cObservaciones2                  := cValue, padr( ::cObservaciones2, 40 ) )
   METHOD Observaciones3( cValue )                 INLINE ( if( !Empty( cValue ), ::cObservaciones3                  := cValue, padr( ::cObservaciones3, 40 ) )
   METHOD ValorAsegurado( cValue )                 INLINE ( if( !Empty( cValue ), ::nValorAsegurado                  := cValue, strzero( round( ::nValorAsegurado * 100, 0 ), 11 ) )
   METHOD NumeroFactura( cValue )                  INLINE ( if( !Empty( cValue ), ::nNumeroFactura                   := cValue, padr( str( ::nNumeroFactura ), 12 ) )
   METHOD FechaFactura( cValue )                   INLINE ( if( !Empty( cValue ), ::dFechaFactura                    := cValue, dtos( ::dFechaFactura ) )
   METHOD ImporteFactura( cValue )                 INLINE ( if( !Empty( cValue ), ::nImporteFactura                  := cValue, strzero( round( ::nImporteFactura * 100, 0 ), 13 ) )
   METHOD ImporteReembolso( cValue )               INLINE ( if( !Empty( cValue ), ::nImporteReembolso                := cValue, strzero( round( ::nImporteReembolso * 100, 0 ), 13 ) )
   METHOD TipoServicio( cValue )                   INLINE ( if( !Empty( cValue ), ::cTipoServicio                    := cValue, padr( ::cTipoServicio, 1 ) )
   METHOD CodigoPais( cValue )                     INLINE ( if( !Empty( cValue ), ::cCodigoPais                      := cValue, padr( ::cCodigoPais, 3 ) )
   METHOD VersionRedur( cValue )                   INLINE ( if( !Empty( cValue ), ::nVersionRedur                    := cValue, padr( str( ::nVersionRedur ), 3 ) )
   METHOD NombreRemitente( cValue )                INLINE ( if( !Empty( cValue ), ::cNombreRemitente                 := cValue, padr( ::cNombreRemitente, 35 ) )
   METHOD DireccionRemitente( cValue )             INLINE ( if( !Empty( cValue ), ::cDireccionRemitente              := cValue, padr( ::cDireccionRemitente, 60 ) )
   METHOD PoblacionRemitente( cValue )             INLINE ( if( !Empty( cValue ), ::cPoblacionRemitente              := cValue, padr( ::cPoblacionRemitente, 25 ) )
   METHOD CodigoPostalRemitente( cValue )          INLINE ( if( !Empty( cValue ), ::cCodigoPostalRemitente           := cValue, padr( ::cCodigoPostalRemitente, 10 ) )
   METHOD Colaborador( cValue )                    INLINE ( if( !Empty( cValue ), ::cColaborador                     := cValue, padr( ::cColaborador, 3 ) )
   METHOD PlazaSalida( cValue )                    INLINE ( if( !Empty( cValue ), ::cPlazaSalida                     := cValue, padr( ::cPlazaSalida, 3 ) )
   METHOD TotalBultosADR( cValue )                 INLINE ( if( !Empty( cValue ), ::nTotalBultosADR                  := cValue, padr( str( ::nTotalBultosADR ), 6 ) )
   METHOD NivelInformacionADR( cValue )            INLINE ( if( !Empty( cValue ), ::cNivelInformacionADR             := cValue, padr( ::cNivelInformacionADR, 1 ) )
   METHOD AlbaranCliente( cValue )                 INLINE ( if( !Empty( cValue ), ::cAlbaranCliente                  := cValue, padr( ::cAlbaranCliente, 1 ) )
   METHOD DevolverAlbaranFirmado( cValue )         INLINE ( if( !Empty( cValue ), ::cDevolverAlbaranFirmado          := cValue, padr( ::cDevolverAlbaranFirmado, 1 ) )
   METHOD InformacionAdicionalCliente( cValue )    INLINE ( if( !Empty( cValue ), ::cInformacionAdicionalCliente     := cValue, padr( ::cInformacionAdicionalCliente, 100 ) )
   METHOD NombreContacto( cValue )                 INLINE ( if( !Empty( cValue ), ::cNombreContacto                  := cValue, padr( ::cNombreContacto, 40 ) )
   METHOD TelefonoContacto( cValue )               INLINE ( if( !Empty( cValue ), ::cTelefonoContacto                := cValue, padr( ::cTelefonoContacto, 30 ) )
   METHOD TelefonoAlternativo( cValue )            INLINE ( if( !Empty( cValue ), ::cTelefonoAlternativo             := cValue, padr( ::cTelefonoAlternativo, 30 ) )
   METHOD EmailContacto( cValue )                  INLINE ( if( !Empty( cValue ), ::cEmailContacto                   := cValue, padr( ::cEmailContacto, 80 ) )
   METHOD SmsContacto( cValue )                    INLINE ( if( !Empty( cValue ), ::cSmsContacto                     := cValue, padr( ::cSmsContacto, 35 ) )
   METHOD DireccionAdicional( cValue )             INLINE ( if( !Empty( cValue ), ::cDireccionAdicional              := cValue, padr( ::cDireccionAdicional, 40 ) )
   METHOD DireccionAdicionalContinuacion( cValue ) INLINE ( if( !Empty( cValue ), ::cDireccionAdicionalContinuacion  := cValue, padr( ::cDireccionAdicionalContinuacion, 40 ) )
   METHOD InstruccionesAdicionales( cValue )       INLINE ( if( !Empty( cValue ), ::cInstruccionesAdicionales        := cValue, padr( ::cInstruccionesAdicionales, 70 ) )


   METHOD New()

   METHOD WriteASCII()
   METHOD SerializeASCII()

ENDCLASS

   //------------------------------------------------------------------------//

   METHOD New() CLASS Redur 

   Return ( Self )

   //------------------------------------------------------------------------//

   METHOD WriteASCII() CLASS Redur 

      ::hFile  := fCreate( ::cFile )

      if !Empty( ::hFile )
         fWrite( ::hFile, ::SerializeASCII() )
         fClose( ::hFile )
      end if

   Return ( Self )

   //------------------------------------------------------------------------//

   METHOD SerializeASCII() CLASS Redur 

      local cBuffer     := ""

      cBuffer           := ::GetPresentador():SerializeASCII()

      cBuffer           += ::CodigoRegistro()
      cBuffer           += ::TotalImporte() 
      cBuffer           += ::TotalRegistros() 
      cBuffer           += ::TotalFinalRegistros()

   Return ( cBuffer )

//---------------------------------------------------------------------------//

