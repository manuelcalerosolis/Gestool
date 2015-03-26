#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio()

   local oAlbarenesClientesRedur

   msgStop( "Inicio")

   oAlbarenesClientesRedur    := AlbarenesClientesRedur():New()

Return ( nil )

//---------------------------------------------------------------------------//

CLASS AlbarenesClientesRedur

   DATA nView

   DATA oAlbaran
   DATA aAlbaranes   INIT {}

   METHOD New()

   METHOD SendFile()

   METHOD OpenFiles()
   METHOD CloseFiles()

ENDCLASS

//---------------------------------------------------------------------------//

   METHOD New() CLASS AlbarenesClientesRedur

      if ::OpenFiles()

         if ( D():AlbaranesClientes( ::nView ) )->( dbseek( date() ) )

            while !( D():AlbaranesClientes( ::nView ) )->( eof() )

               if rtrim( ( D():AlbaranesClientes( ::nView ) )->cCodTrn ) == "001"

                  if Empty( ::oAlbaran )
                     ::oAlbaran                          := Redur():New()
                  end if 

                  ::oAlbaran:Tracking(                   '500324' + strzero( ( D():AlbaranesClientes( ::nView ) )->nNumAlb, 9 ) )
                  ::oAlbaran:Remitente(                  'CAZU' )
                  ::oAlbaran:NombreConsignatario(        ( D():AlbaranesClientes( ::nView ) )->cNomCli )

                  if Empty( D():AlbaranesClientes( ::nView ) )->cCodObr )

                     ::oAlbaran:DireccionConsignatario(     ( D():AlbaranesClientes( ::nView ) )->cDirCli )
                     ::oAlbaran:PoblacionConsignatario(     ( D():AlbaranesClientes( ::nView ) )->cPobCli )
                     ::oAlbaran:CodigoPostalConsignatario(  ( D():AlbaranesClientes( ::nView ) )->cPosCli )
                     ::oAlbaran:ProvinciaConsignatario(     '00' + left( ( D():AlbaranesClientes( ::nView ) )->cPosCli, 2 ) )

                  else

                     if dbSeekInOrd( D():AlbaranesClientes( ::nView ) )->cCodCli + D():AlbaranesClientes( ::nView ) )->cCodObr, "cCodCli", D():Get( "ObrasT", nView ) )
                        ::oAlbaran:DireccionConsignatario(     ( D():Get( "ObrasT", nView ) )->cDirObr )
                        ::oAlbaran:PoblacionConsignatario(     ( D():Get( "ObrasT", nView ) )->cPobObr )
                        ::oAlbaran:CodigoPostalConsignatario(  ( D():Get( "ObrasT", nView ) )->cPosObr )
                        ::oAlbaran:ProvinciaConsignatario(     '00' + left( ( D():Get( "ObrasT", nView ) )->cPosObr, 2 ) )
                     end if   

                  end if
                  ::oAlbaran:Bultos(                     ( D():AlbaranesClientes( ::nView ) )->nBultos )
                  ::oAlbaran:Referencia(                 str( ( D():AlbaranesClientes( ::nView ) )->nNumAlb ) )
                  ::oAlbaran:Peso(                       nTotalPesoAlbaranCliente( ( D():AlbaranesClientesId( ::nView ) ), ::nView ) )
                  
                  ::oAlbaran:SerializeASCII()

               end if 

               ( D():AlbaranesClientes( ::nView ) )->( dbSkip() )

            end while

            if !empty( ::oAlbaran )
               ::oAlbaran:WriteASCII()
               ::SendFile()
            end if 

         else

            msgStop( "No hay albaranes para " + dtoc( date() ) )

         end if 

         ::CloseFiles()

      end if 

   Return ( Self )

//---------------------------------------------------------------------------//

   METHOD OpenFiles() CLASS AlbarenesClientesRedur

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():AlbaranesClientes( ::nView )

      D():AlbaranesClientesLineas( ::nView )      

      ( D():AlbaranesClientes( ::nView ) )->( ordsetfocus( "dFecAlb" ) )

      D():Get( "ObrasT", nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   Return ( lOpenFiles )

//---------------------------------------------------------------------------//

   METHOD CloseFiles CLASS AlbarenesClientesRedur

      D():DeleteView( ::nView )

   Return ( Self )

//---------------------------------------------------------------------------//

   METHOD SendFile() CLASS AlbarenesClientesRedur

      local oFtp
      local oFile
      local oInternet

      oInternet         := TInternet():New()
      oFtp              := TFtp():New( 'redlab.redur.es', oInternet, 'CAZU', 'bU5B80rU', .f. )

      if Empty( oFtp ) .or. Empty( oFtp:hFtp )

         msgStop( "Imposible conectar con el sitio ftp redlab.redur.es" )

      else

         oFile          := TFtpFile():New( ::oAlbaran:cFile, oFtp )

         if ( oFile:PutFile() )
            msgInfo( ::oAlbaran:cFile + " enviado con exito" )
         else 
            msgStop( GetErrMsg(), "Error" )
         end if

      end if 

      if !Empty( oInternet )
         oInternet:end()
      end if

      if !Empty( oFtp )
         oFtp:end()
      end if

/*
open redlab.redur.es
user CAZU
bU5B80rU
bin
prompt
mput redur_CAZU*.dcf
quit
*/

   RETURN ( Self)

//---------------------------------------------------------------------------//

CLASS Redur FROM Cuaderno

   DATA cFile                             INIT 'redur_CAZU_' + dateToEUString( date() ) + '.dcf'
   DATA cBuffer                           INIT ''

   DATA cTipoRegisto                      INIT 'R00'
   DATA cCodigoCliente                    INIT 'CAZU' 
   DATA cTracking                         INIT ''
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
   DATA cNumeroFactura                    INIT ''
   DATA dFechaFactura                     INIT date()
   DATA nImporteFactura                   INIT 0
   DATA nImporteReembolso                 INIT 0 
   DATA cTipoServicio                     INIT 'U'
   DATA cCodigoPais                       INIT '724'
   DATA cVersionRedur                     INIT ''
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

   METHOD TipoRegisto(uValue)                    INLINE ( if( !Empty(uValue), ::cTipoRegisto                     := uValue, padr( ::cTipoRegisto, 3 ) ) )
   METHOD CodigoCliente(uValue)                  INLINE ( if( !Empty(uValue), ::cCodigoCliente                   := uValue, padr( ::cCodigoCliente, 12 ) ) )
   METHOD Tracking(uValue)                       INLINE ( if( !Empty(uValue), ::cTracking                        := uValue, padr( ::cTracking, 14 ) ) )
   METHOD Remitente(uValue)                      INLINE ( if( !Empty(uValue), ::cRemitente                       := uValue, padr( ::cRemitente, 12 ) ) )
   METHOD CodigoConsignatario(uValue)            INLINE ( if( !Empty(uValue), ::cCodigoConsignatario             := uValue, padr( ::cCodigoConsignatario, 12 ) ) )
   METHOD Documentacion(uValue)                  INLINE ( if( !Empty(uValue), ::cDocumentacion                   := uValue, padr( ::cDocumentacion, 20 ) ) )
   METHOD Producto(uValue)                       INLINE ( if( !Empty(uValue), ::cProducto                        := uValue, padr( ::cProducto, 3 ) ) )
   METHOD Preparacion(uValue)                    INLINE ( if( !Empty(uValue), ::dPreparacion                     := uValue, dateToEUString( ::dPreparacion ) ) )
   METHOD Recogida(uValue)                       INLINE ( if( !Empty(uValue), ::dRecogida                        := uValue, dateToEUString( ::dRecogida ) ) )
   METHOD NombreConsignatario(uValue)            INLINE ( if( !Empty(uValue), ::cNombreConsignatario             := uValue, padr( ::cNombreConsignatario, 35 ) ) )
   METHOD DireccionConsignatario(uValue)         INLINE ( if( !Empty(uValue), ::cDireccionConsignatario          := uValue, padr( ::cDireccionConsignatario, 60 ) ) )
   METHOD PoblacionConsignatario(uValue)         INLINE ( if( !Empty(uValue), ::cPoblacionConsignatario          := uValue, padr( ::cPoblacionConsignatario, 35 ) ) )
   METHOD CodigoPostalConsignatario(uValue)      INLINE ( if( !Empty(uValue), ::cCodigoPostalConsignatario       := uValue, padr( ::cCodigoPostalConsignatario, 10 ) ) )
   METHOD ProvinciaConsignatario(uValue)         INLINE ( if( !Empty(uValue), ::cProvinciaConsignatario          := uValue, padr( ::cProvinciaConsignatario, 25 ) ) )
   METHOD TipoMercancia(uValue)                  INLINE ( if( !Empty(uValue), ::cTipoMercancia                   := uValue, padr( ::cTipoMercancia, 2 ) ) )
   METHOD Bultos(uValue)                         INLINE ( if( !Empty(uValue), ::nBultos                          := uValue, strzero( ::nBultos, 6 ) ) )
   METHOD Peso(uValue)                           INLINE ( if( !Empty(uValue), ::nPeso                            := uValue, strzero( round( ::nPeso * 10, 0 ), 8 ) ) )
   METHOD Volumen(uValue)                        INLINE ( if( !Empty(uValue), ::nVolumen                         := uValue, strzero( round( ::nVolumen * 100, 0 ), 6 ) ) )
   METHOD TipoPortes(uValue)                     INLINE ( if( !Empty(uValue), ::cTipoPortes                      := uValue, padr( ::cTipoPortes, 1 ) ) )

   METHOD Referencia(uValue)                     INLINE ( if(  !Empty(uValue),;
                                                               ::cReferencia := alltrim( uValue ),; 
                                                               padr( ::cReferencia, 22 ) ) ) 

   METHOD Observaciones1(uValue)                 INLINE ( if( !Empty(uValue), ::cObservaciones1                  := uValue, padr( ::cObservaciones1, 40 ) ) )
   METHOD Observaciones2(uValue)                 INLINE ( if( !Empty(uValue), ::cObservaciones2                  := uValue, padr( ::cObservaciones2, 40 ) ) )
   METHOD Observaciones3(uValue)                 INLINE ( if( !Empty(uValue), ::cObservaciones3                  := uValue, padr( ::cObservaciones3, 40 ) ) )
   METHOD ValorAsegurado(uValue)                 INLINE ( if( !Empty(uValue), ::nValorAsegurado                  := uValue, strzero( round( ::nValorAsegurado * 100, 0 ), 11 ) ) )
   METHOD NumeroFactura(uValue)                  INLINE ( if( !Empty(uValue), ::cNumeroFactura                   := uValue, padr( ::cNumeroFactura, 12 ) ) )
   METHOD FechaFactura(uValue)                   INLINE ( if( !Empty(uValue), ::dFechaFactura                    := uValue, dateToEUString( ::dFechaFactura ) ) )
   METHOD ImporteFactura(uValue)                 INLINE ( if( !Empty(uValue), ::nImporteFactura                  := uValue, strzero( round( ::nImporteFactura * 100, 0 ), 13 ) ) )
   METHOD ImporteReembolso(uValue)               INLINE ( if( !Empty(uValue), ::nImporteReembolso                := uValue, strzero( round( ::nImporteReembolso * 100, 0 ), 13 ) ) )
   METHOD TipoServicio(uValue)                   INLINE ( if( !Empty(uValue), ::cTipoServicio                    := uValue, padr( ::cTipoServicio, 1 ) ) )
   METHOD CodigoPais(uValue)                     INLINE ( if( !Empty(uValue), ::cCodigoPais                      := uValue, padr( ::cCodigoPais, 3 ) ) )
   METHOD VersionRedur(uValue)                   INLINE ( if( !Empty(uValue), ::cVersionRedur                    := uValue, padr( ::cVersionRedur, 3 ) ) )
   METHOD NombreRemitente(uValue)                INLINE ( if( !Empty(uValue), ::cNombreRemitente                 := uValue, padr( ::cNombreRemitente, 35 ) ) )
   METHOD DireccionRemitente(uValue)             INLINE ( if( !Empty(uValue), ::cDireccionRemitente              := uValue, padr( ::cDireccionRemitente, 60 ) ) )
   METHOD PoblacionRemitente(uValue)             INLINE ( if( !Empty(uValue), ::cPoblacionRemitente              := uValue, padr( ::cPoblacionRemitente, 25 ) ) )
   METHOD CodigoPostalRemitente(uValue)          INLINE ( if( !Empty(uValue), ::cCodigoPostalRemitente           := uValue, padr( ::cCodigoPostalRemitente, 10 ) ) )
   METHOD Colaborador(uValue)                    INLINE ( if( !Empty(uValue), ::cColaborador                     := uValue, padr( ::cColaborador, 3 ) ) )
   METHOD PlazaSalida(uValue)                    INLINE ( if( !Empty(uValue), ::cPlazaSalida                     := uValue, padr( ::cPlazaSalida, 3 ) ) )
   METHOD TotalBultosADR(uValue)                 INLINE ( if( !Empty(uValue), ::nTotalBultosADR                  := uValue, padr( str( ::nTotalBultosADR ), 6 ) ) )
   METHOD NivelInformacionADR(uValue)            INLINE ( if( !Empty(uValue), ::cNivelInformacionADR             := uValue, padr( ::cNivelInformacionADR, 1 ) ) )
   METHOD AlbaranCliente(uValue)                 INLINE ( if( !Empty(uValue), ::cAlbaranCliente                  := uValue, padr( ::cAlbaranCliente, 1 ) ) )
   METHOD DevolverAlbaranFirmado(uValue)         INLINE ( if( !Empty(uValue), ::cDevolverAlbaranFirmado          := uValue, padr( ::cDevolverAlbaranFirmado, 1 ) ) )
   METHOD InformacionAdicionalCliente(uValue)    INLINE ( if( !Empty(uValue), ::cInformacionAdicionalCliente     := uValue, padr( ::cInformacionAdicionalCliente, 100 ) ) )
   METHOD NombreContacto(uValue)                 INLINE ( if( !Empty(uValue), ::cNombreContacto                  := uValue, padr( ::cNombreContacto, 40 ) ) )
   METHOD TelefonoContacto(uValue)               INLINE ( if( !Empty(uValue), ::cTelefonoContacto                := uValue, padr( ::cTelefonoContacto, 30 ) ) )
   METHOD TelefonoAlternativo(uValue)            INLINE ( if( !Empty(uValue), ::cTelefonoAlternativo             := uValue, padr( ::cTelefonoAlternativo, 30 ) ) )
   METHOD EmailContacto(uValue)                  INLINE ( if( !Empty(uValue), ::cEmailContacto                   := uValue, padr( ::cEmailContacto, 80 ) ) )
   METHOD SmsContacto(uValue)                    INLINE ( if( !Empty(uValue), ::cSmsContacto                     := uValue, padr( ::cSmsContacto, 35 ) ) )
   METHOD DireccionAdicional(uValue)             INLINE ( if( !Empty(uValue), ::cDireccionAdicional              := uValue, padr( ::cDireccionAdicional, 40 ) ) )
   METHOD DireccionAdicionalContinuacion(uValue) INLINE ( if( !Empty(uValue), ::cDireccionAdicionalContinuacion  := uValue, padr( ::cDireccionAdicionalContinuacion, 40 ) ) )
   METHOD InstruccionesAdicionales(uValue)       INLINE ( if( !Empty(uValue), ::cInstruccionesAdicionales        := uValue, padr( ::cInstruccionesAdicionales, 70 ) ) )

ENDCLASS

   //------------------------------------------------------------------------//

   METHOD New() CLASS Redur 

   Return ( Self )

   //------------------------------------------------------------------------//

   METHOD WriteASCII() CLASS Redur 

      if empty( ::cBuffer )
         Return ( .f. )
      end if

      ::hFile           := fCreate( ::cFile )

      if !Empty( ::hFile ) 
         fWrite( ::hFile, ::cBuffer )
         fClose( ::hFile )
      end if

   Return ( .t. )

   //------------------------------------------------------------------------//

   METHOD SerializeASCII() CLASS Redur 

      ::cBuffer         += ::TipoRegisto()                    
      ::cBuffer         += ::CodigoCliente()                  
      ::cBuffer         += ::Tracking()                       
      ::cBuffer         += ::Remitente()                      
      ::cBuffer         += ::CodigoConsignatario()            
      ::cBuffer         += ::Documentacion()                  
      ::cBuffer         += ::Producto()                       
      ::cBuffer         += ::Preparacion()                    
      ::cBuffer         += ::Recogida()                       
      ::cBuffer         += ::NombreConsignatario()            
      ::cBuffer         += ::DireccionConsignatario()         
      ::cBuffer         += ::PoblacionConsignatario()         
      ::cBuffer         += ::CodigoPostalConsignatario()      
      ::cBuffer         += ::ProvinciaConsignatario()         
      ::cBuffer         += ::TipoMercancia()                  
      ::cBuffer         += ::Bultos()                         
      ::cBuffer         += ::Peso()                           
      ::cBuffer         += ::Volumen()                        
      ::cBuffer         += ::TipoPortes()                     
      ::cBuffer         += ::Referencia()                     
      ::cBuffer         += ::Observaciones1()                 
      ::cBuffer         += ::Observaciones2()                 
      ::cBuffer         += ::Observaciones3()                 
      ::cBuffer         += ::ValorAsegurado()                 
      ::cBuffer         += ::NumeroFactura()                  
      ::cBuffer         += ::FechaFactura()                   
      ::cBuffer         += ::ImporteFactura()                 
      ::cBuffer         += ::ImporteReembolso()               
      ::cBuffer         += ::TipoServicio()                   
      ::cBuffer         += ::CodigoPais()                     
      ::cBuffer         += ::VersionRedur()                   
      ::cBuffer         += ::NombreRemitente()                
      ::cBuffer         += ::DireccionRemitente()             
      ::cBuffer         += ::PoblacionRemitente()             
      ::cBuffer         += ::CodigoPostalRemitente()          
      ::cBuffer         += ::Colaborador()                    
      ::cBuffer         += ::PlazaSalida()                    
      ::cBuffer         += ::TotalBultosADR()                 
      ::cBuffer         += ::NivelInformacionADR()            
      ::cBuffer         += ::AlbaranCliente()                 
      ::cBuffer         += ::DevolverAlbaranFirmado()         
      ::cBuffer         += ::InformacionAdicionalCliente()    
      ::cBuffer         += ::NombreContacto()                 
      ::cBuffer         += ::TelefonoContacto()               
      ::cBuffer         += ::TelefonoAlternativo()            
      ::cBuffer         += ::EmailContacto()                  
      ::cBuffer         += ::SmsContacto()                    
      ::cBuffer         += ::DireccionAdicional()             
      ::cBuffer         += ::DireccionAdicionalContinuacion() 
      ::cBuffer         += ::InstruccionesAdicionales()             
      ::cBuffer         += CRLF

   Return ( ::cBuffer )

//---------------------------------------------------------------------------//

