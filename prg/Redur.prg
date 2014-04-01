#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio()

   local oAlbarenesClientesRedur

   oAlbarenesClientesRedur    := AlbarenesClientesRedur():New()

Return ( nil )

//---------------------------------------------------------------------------//

CLASS AlbarenesClientesRedur

   DATA nView

   DATA oAlbaran
   DATA aAlbaranes   INIT {}

   METHOD New()

   METHOD OpenFiles()
   METHOD CloseFiles()

ENDCLASS

//---------------------------------------------------------------------------//

   METHOD New() CLASS AlbarenesClientesRedur

      if ::OpenFiles()

         if ( TDataView():AlbaranesClientes( ::nView ) )->( dbseek( date() ) )
            while !( TDataView():AlbaranesClientes( ::nView ) )->( eof() )

               ::oAlbaran  := Redur():New()

               ::oAlbaran:NombreConsignatario( ( TDataView():AlbaranesClientes( ::nView ) )->cNomCli )
               
               ::oAlbaran:WriteASCII()

            end while
         end if 

         ::CloseFiles()

      end if 

   Return ( Self )

//---------------------------------------------------------------------------//

   METHOD OpenFiles() CLASS AlbarenesClientesRedur

      TDataView():AlbaranesClientes( ::nView )

      ( TDataView():AlbaranesClientes( ::nView ) )->( ordsetfocus( "dFecAlb" ) )

   Return ( Self )

//---------------------------------------------------------------------------//

   METHOD CloseFiles CLASS AlbarenesClientesRedur

      TDataView():DeleteView( ::nView )

   Return ( Self )

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
   DATA cTipoServicio                     INIT 'U'
   DATA cCodigoPais                       INIT '724'
   DATA nVersionRedur                     INIT ''
   DATA cNombreRemitente                  INIT ''
   DATA cDireccionRemitente               INIT ''
   DATA cPoblacionRemitente               INIT ''
   DATA cCodigoPostalRemitente            INIT ''
   DATA cColaborador                      INIT ''
   DATA cPlazaSalida                      INIT ''
   DATA nTotalBultosADR                   INIT 0
   DATA cNivelInformacionADR              INIT '0'
   DATA cAlbaranCliente                   INIT 'N'
   DATA cDevolverAlbaranFirmado           INIT 'N'
   DATA cInformacionAdicionalCliente      INIT ''
   DATA cNombreContacto                   INIT ''
   DATA cTelefonoContacto                 INIT ''
   DATA cTelefonoAlternativo              INIT ''
   DATA cEmailContacto                    INIT ''
   DATA cSmsContacto                      INIT ''
   DATA cDireccionAdicional               INIT ''
   DATA cDireccionAdicionalContinuacion   INIT ''
   DATA cInstruccionesAdicionales         INIT ''

   METHOD New()

   METHOD WriteASCII()
   METHOD SerializeASCII()

   METHOD TipoRegisto()                    INLINE ( if( !Empty(), ::cTipoRegisto                     := , padr( ::cTipoRegisto, 3 ) )
   METHOD CodigoCliente()                  INLINE ( if( !Empty(), ::cCodigoCliente                   := , padr( ::cCodigoCliente, 12 ) )
   METHOD Tracking()                       INLINE ( if( !Empty(), ::nTracking                        := , padr( str( ::nTracking ), 14 ) )
   METHOD Remitente()                      INLINE ( if( !Empty(), ::cRemitente                       := , padr( ::cRemitente, 12 ) )
   METHOD CodigoConsignatario()            INLINE ( if( !Empty(), ::cCodigoConsignatario             := , padr( ::cCodigoConsignatario, 12 ) )
   METHOD Documentacion()                  INLINE ( if( !Empty(), ::cDocumentacion                   := , padr( ::cDocumentacion, 20 ) )
   METHOD Producto()                       INLINE ( if( !Empty(), ::cProducto                        := , padr( ::cProducto, 3 ) )
   METHOD Preparacion()                    INLINE ( if( !Empty(), ::dPreparacion                     := , dtos( ::dPreparacion ) )
   METHOD Recogida()                       INLINE ( if( !Empty(), ::dRecogida                        := , dtos( ::dRecogida ) )
   METHOD NombreConsignatario()            INLINE ( if( !Empty(), ::cNombreConsignatario             := , padr( ::cNombreConsignatario, 35 ) )
   METHOD DireccionConsignatario()         INLINE ( if( !Empty(), ::cDireccionConsignatario          := , padr( ::cDireccionConsignatario, 60 ) )
   METHOD PoblacionConsignatario()         INLINE ( if( !Empty(), ::cPoblacionConsignatario          := , padr( ::cPoblacionConsignatario, 35 ) )
   METHOD CodigoPostalConsignatario()      INLINE ( if( !Empty(), ::cCodigoPostalConsignatario       := , padr( ::cCodigoPostalConsignatario, 10 ) )
   METHOD ProvinciaConsignatario()         INLINE ( if( !Empty(), ::cProvinciaConsignatario          := , padr( ::cProvinciaConsignatario, 25 ) )
   METHOD TipoMercancia()                  INLINE ( if( !Empty(), ::cTipoMercancia                   := , padr( ::cTipoMercancia, 2 ) )
   METHOD Bultos()                         INLINE ( if( !Empty(), ::nBultos                          := , strzero( ::nBultos, 6 ) )
   METHOD Peso()                           INLINE ( if( !Empty(), ::nPeso                            := , strzero( round( ::nPeso * 10, 0 ), 8 ) )
   METHOD Volumen()                        INLINE ( if( !Empty(), ::nVolumen                         := , strzero( round( ::nVolumen * 100, 0 ), 6 ) )
   METHOD TipoPortes()                     INLINE ( if( !Empty(), ::cTipoPortes                      := , padr( ::cTipoPortes, 1 ) )
   METHOD Referencia()                     INLINE ( if( !Empty(), ::cReferencia                      := , padr( ::cReferencia, 22 ) )
   METHOD Observaciones1()                 INLINE ( if( !Empty(), ::cObservaciones1                  := , padr( ::cObservaciones1, 40 ) )
   METHOD Observaciones2()                 INLINE ( if( !Empty(), ::cObservaciones2                  := , padr( ::cObservaciones2, 40 ) )
   METHOD Observaciones3()                 INLINE ( if( !Empty(), ::cObservaciones3                  := , padr( ::cObservaciones3, 40 ) )
   METHOD ValorAsegurado()                 INLINE ( if( !Empty(), ::nValorAsegurado                  := , strzero( round( ::nValorAsegurado * 100, 0 ), 11 ) )
   METHOD NumeroFactura()                  INLINE ( if( !Empty(), ::nNumeroFactura                   := , padr( str( ::nNumeroFactura ), 12 ) )
   METHOD FechaFactura()                   INLINE ( if( !Empty(), ::dFechaFactura                    := , dtos( ::dFechaFactura ) )
   METHOD ImporteFactura()                 INLINE ( if( !Empty(), ::nImporteFactura                  := , strzero( round( ::nImporteFactura * 100, 0 ), 13 ) )
   METHOD ImporteReembolso()               INLINE ( if( !Empty(), ::nImporteReembolso                := , strzero( round( ::nImporteReembolso * 100, 0 ), 13 ) )
   METHOD TipoServicio()                   INLINE ( if( !Empty(), ::cTipoServicio                    := , padr( ::cTipoServicio, 1 ) )
   METHOD CodigoPais()                     INLINE ( if( !Empty(), ::cCodigoPais                      := , padr( ::cCodigoPais, 3 ) )
   METHOD VersionRedur()                   INLINE ( if( !Empty(), ::nVersionRedur                    := , padr( str( ::nVersionRedur ), 3 ) )
   METHOD NombreRemitente()                INLINE ( if( !Empty(), ::cNombreRemitente                 := , padr( ::cNombreRemitente, 35 ) )
   METHOD DireccionRemitente()             INLINE ( if( !Empty(), ::cDireccionRemitente              := , padr( ::cDireccionRemitente, 60 ) )
   METHOD PoblacionRemitente()             INLINE ( if( !Empty(), ::cPoblacionRemitente              := , padr( ::cPoblacionRemitente, 25 ) )
   METHOD CodigoPostalRemitente()          INLINE ( if( !Empty(), ::cCodigoPostalRemitente           := , padr( ::cCodigoPostalRemitente, 10 ) )
   METHOD Colaborador()                    INLINE ( if( !Empty(), ::cColaborador                     := , padr( ::cColaborador, 3 ) )
   METHOD PlazaSalida()                    INLINE ( if( !Empty(), ::cPlazaSalida                     := , padr( ::cPlazaSalida, 3 ) )
   METHOD TotalBultosADR()                 INLINE ( if( !Empty(), ::nTotalBultosADR                  := , padr( str( ::nTotalBultosADR ), 6 ) )
   METHOD NivelInformacionADR()            INLINE ( if( !Empty(), ::cNivelInformacionADR             := , padr( ::cNivelInformacionADR, 1 ) )
   METHOD AlbaranCliente()                 INLINE ( if( !Empty(), ::cAlbaranCliente                  := , padr( ::cAlbaranCliente, 1 ) )
   METHOD DevolverAlbaranFirmado()         INLINE ( if( !Empty(), ::cDevolverAlbaranFirmado          := , padr( ::cDevolverAlbaranFirmado, 1 ) )
   METHOD InformacionAdicionalCliente()    INLINE ( if( !Empty(), ::cInformacionAdicionalCliente     := , padr( ::cInformacionAdicionalCliente, 100 ) )
   METHOD NombreContacto()                 INLINE ( if( !Empty(), ::cNombreContacto                  := , padr( ::cNombreContacto, 40 ) )
   METHOD TelefonoContacto()               INLINE ( if( !Empty(), ::cTelefonoContacto                := , padr( ::cTelefonoContacto, 30 ) )
   METHOD TelefonoAlternativo()            INLINE ( if( !Empty(), ::cTelefonoAlternativo             := , padr( ::cTelefonoAlternativo, 30 ) )
   METHOD EmailContacto()                  INLINE ( if( !Empty(), ::cEmailContacto                   := , padr( ::cEmailContacto, 80 ) )
   METHOD SmsContacto()                    INLINE ( if( !Empty(), ::cSmsContacto                     := , padr( ::cSmsContacto, 35 ) )
   METHOD DireccionAdicional()             INLINE ( if( !Empty(), ::cDireccionAdicional              := , padr( ::cDireccionAdicional, 40 ) )
   METHOD DireccionAdicionalContinuacion() INLINE ( if( !Empty(), ::cDireccionAdicionalContinuacion  := , padr( ::cDireccionAdicionalContinuacion, 40 ) )
   METHOD InstruccionesAdicionales()       INLINE ( if( !Empty(), ::cInstruccionesAdicionales        := , padr( ::cInstruccionesAdicionales, 70 ) )

ENDCLASS

   //------------------------------------------------------------------------//

   METHOD New() CLASS Redur 

   Return ( Self )

   //------------------------------------------------------------------------//

   METHOD WriteASCII() CLASS Redur 

      ::hFile           := fCreate( ::cFile )

      if !Empty( ::hFile )
         fWrite( ::hFile, ::SerializeASCII() )
         fClose( ::hFile )
      end if

      msgAlert( ::SerializeASCII() )

   Return ( Self )

   //------------------------------------------------------------------------//

   METHOD SerializeASCII() CLASS Redur 

      local cBuffer     := ""


      cBuffer           += ::TipoRegisto()                    
      cBuffer           += ::CodigoCliente()                  
      cBuffer           += ::Tracking()                       
      cBuffer           += ::Remitente()                      
      cBuffer           += ::CodigoConsignatario()            
      cBuffer           += ::Documentacion()                  
      cBuffer           += ::Producto()                       
      cBuffer           += ::Preparacion()                    
      cBuffer           += ::Recogida()                       
      cBuffer           += ::NombreConsignatario()            
      cBuffer           += ::DireccionConsignatario()         
      cBuffer           += ::PoblacionConsignatario()         
      cBuffer           += ::CodigoPostalConsignatario()      
      cBuffer           += ::ProvinciaConsignatario()         
      cBuffer           += ::TipoMercancia()                  
      cBuffer           += ::Bultos()                         
      cBuffer           += ::Peso()                           
      cBuffer           += ::Volumen()                        
      cBuffer           += ::TipoPortes()                     
      cBuffer           += ::Referencia()                     
      cBuffer           += ::Observaciones1()                 
      cBuffer           += ::Observaciones2()                 
      cBuffer           += ::Observaciones3()                 
      cBuffer           += ::ValorAsegurado()                 
      cBuffer           += ::NumeroFactura()                  
      cBuffer           += ::FechaFactura()                   
      cBuffer           += ::ImporteFactura()                 
      cBuffer           += ::ImporteReembolso()               
      cBuffer           += ::TipoServicio()                   
      cBuffer           += ::CodigoPais()                     
      cBuffer           += ::VersionRedur()                   
      cBuffer           += ::NombreRemitente()                
      cBuffer           += ::DireccionRemitente()             
      cBuffer           += ::PoblacionRemitente()             
      cBuffer           += ::CodigoPostalRemitente()          
      cBuffer           += ::Colaborador()                    
      cBuffer           += ::PlazaSalida()                    
      cBuffer           += ::TotalBultosADR()                 
      cBuffer           += ::NivelInformacionADR()            
      cBuffer           += ::AlbaranCliente()                 
      cBuffer           += ::DevolverAlbaranFirmado()         
      cBuffer           += ::InformacionAdicionalCliente()    
      cBuffer           += ::NombreContacto()                 
      cBuffer           += ::TelefonoContacto()               
      cBuffer           += ::TelefonoAlternativo()            
      cBuffer           += ::EmailContacto()                  
      cBuffer           += ::SmsContacto()                    
      cBuffer           += ::DireccionAdicional()             
      cBuffer           += ::DireccionAdicionalContinuacion() 
      cBuffer           += ::InstruccionesAdicionales()             

   Return ( cBuffer )

//---------------------------------------------------------------------------//

