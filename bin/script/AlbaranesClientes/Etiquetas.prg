//{D1515,1015,1490|}
//{C|}
//{LC;0010,0010,0995,1460,1,4|}
//{LC;0010,0010,0358,1168,1,4|}
//{LC;0640,0010,0995,0458,1,4|}
//{LC;0640,0460,0995,1168,1,4|}
//{LC;0360,1050,0637,1460,1,4|}
//{LC;0490,0010,0490,1048,1,2|}
//{LC;0360,0390,0637,0390,1,2|}
//  {LC;0490,0590,0637,0590,1,2|}
//  {LC;0490,0810,0637,0810,1,2|}
//{PC99;0800,0025,05,05,J,11,B=Remitente|}
//{PC98;0950,0480,05,05,J,11,B=Consignatario|}
//{PC97;0610,0400,05,05,J,11,B=Bultos:|}
//{PC96;0460,0025,05,05,J,11,B=Ref:|}
//{PC97;0460,0400,05,05,J,11,B=Obs:|}
//{PC96;0510,0480,1,15,J,11,B=/|}
//{PC96;0610,0600,05,05,J,11,B=Kilos:|}
//{PC95;0270,1200,06,07,J,11,B=RECOGIDAS:|}
//{PC94;0200,1200,06,07,J,11,B=902 11 19 11|}
//{PC93;0130,1200,06,07,J,11,B=www.redur.es|}
//{PC01;0950,0990,05,05,J,11,B|}
//{PC03;0780,1310,10,15,M,00,B|}
//{PC04;0760,0025,06,08,N,11,B|}
//{PC05;0720,0025,06,06,N,11,B|}
//{PC06;0680,0025,06,06,N,11,B|}
//{PC07;0850,0480,05,1,J,11,B|}
//{PC08;0780,0480,05,1,J,11,B|}
//{PC09;0710,0480,05,1,J,11,B|}
//{PC10;0510,0040,10,15,M,11,B|}
//{PC11;0410,1080,20,25,M,11,B|}
//{PC14;0430,0025,06,06,N,11,B|}
//{XB15;0340,0250,9,3,03,1,0280|}
//{PC16;0750,1250,20,20,M,11,B|}
//{PC18;0520,0510,06,1,J,11,B|}
//{PC19;0430,0400,06,06,N,11,B|}
//{PC20;0380,0400,06,06,N,11,B|}
//{PC21;0520,0600,06,1,J,11,B|}
//{PC22;0025,0440,06,06,J,11,B|}
//{PC23;0025,0580,06,06,J,11,B|}
//{PC24;0025,0800,06,06,J,11,B|}
//{PC26;0400,0400,06,06,N,11,B|} 
//{PC27;0370,0400,06,06,N,11,B|}
//{PC28;0350,0400,06,06,N,11,B|}
//{PC29;0520,0500,06,1,J,11,B|}
//{PC30;0520,0500,06,1,J,11,B|}
//{PC31;0520,0410,06,1,J,11,B|}
//{RC01;18/06/2015|}
//{RC04;CAFES Y ZUMOS S.L. 902194699|}
//{RC05;P.I.EL PINO C/PINO SILVESTRE,21|}
//{RC06;41016 SEVILLA|}
//{RC07;HOTEL EUROSTARS TARTESSOS|}
//{RC08;C/GRAN VIA, 13|}
//{RC09;HUELVA|}
//{RC10;21003|}
//{RC11;HLV|}
//{RC14;3113668|}
//{RB15;12100300072450032403113668001|}
//{RC16;U|}
//{RC18;005|}
//{RC19;OBSERVACIONES DEL CLIENTE|}
//{RC20;|}
//{RC21;23,10 Kg|}
//{RC22;500324-|} 
//{RC23;03113668-|} 
//{RC24;001|}
//{RC26;OBSERVACIONES 2 DEL CLIENTE|}
//{RC27;OBSERVACIONES 3 DEL CLIENTE|}
//{RC28;|}
//{RC31;001|}
//{XS;I,0001,0002CA000|}

#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio( nView )

   local oAlbarenesClientesRedur

   MsgInfo( nView )

   oAlbarenesClientesRedur    := AlbarenesClientesRedur():New( nView )

Return ( nil )

//---------------------------------------------------------------------------//

CLASS AlbarenesClientesRedur

   DATA nView

   DATA oAlbaran
   DATA aAlbaranes   INIT {}

   METHOD New()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS AlbarenesClientesRedur

   ::nView     := nView

   MsgInfo( ( D():AlbaranesClientes( ::nView ) )->cSerAlb + Str( ( D():AlbaranesClientes( ::nView ) )->nNumAlb ) + ( D():AlbaranesClientes( ::nView ) )->cSufAlb )

   if Empty( ::oAlbaran )
      ::oAlbaran                         := Redur():New()
   end if

   MsgInfo( "voy a hacer el fichero" )

   ::oAlbaran:cFechaEnvio( ( D():AlbaranesClientes( ::nView ) )->dFecAlb )
   ::oAlbaran:NombreConsignatario( ( D():AlbaranesClientes( ::nView ) )->cNomCli )

   /*
   
   {RC08;C/GRAN VIA, 13|}                           Dirección Consignatario
   {RC09;HUELVA|}                                   Población Consignatario
   {RC10;21003|}                                    Código postal Consignatario
   {RC11;HLV|}                                      Plaza de reparto (Mas abajo te explico)
   {RC14;3113668|}                                  Vuestra referencia
   {RB15;12100300072450032403113668001|}            Información en código de Barras
   {RC16;U|}
   {RC18;005|}                                      Numero Total de bultos
   {RC19;OBSERVACIONES DEL CLIENTE|}                Observaciones 1
   {RC20;|}                                          
   {RC21;23,10 Kg|}                                 Kilos
   {RC22;500324-|}                                  Prefijo Tracking (no cambia)
   {RC23;03113668-|}                                Sufijo Tracking, (vuestra referencia con un 0 delante)
   {RC24;001|}                                      Numero de Bulto
   {RC26;OBSERVACIONES 2 DEL CLIENTE|}              Observaciones 2
   {RC27;OBSERVACIONES 3 DEL CLIENTE|}              Observaciones 3
   {RC28;|}
   {RC31;001|}                                      Numero de Bulto*/





   Msginfo( ::oAlbaran:SerializeASCII() )

   Msginfo( "despues de hacer el asscii" )





               /*::oAlbaran:Tracking(                   '500324' + strzero( ( D():AlbaranesClientes( ::nView ) )->nNumAlb, 8 ) )
               ::oAlbaran:Remitente(                  'CAZU' )
               ::oAlbaran:NombreConsignatario(        ( D():AlbaranesClientes( ::nView ) )->cNomCli )

               if Empty( ( D():AlbaranesClientes( ::nView ) )->cCodObr )

                  ::oAlbaran:DireccionConsignatario(     ( D():AlbaranesClientes( ::nView ) )->cDirCli )
                  ::oAlbaran:PoblacionConsignatario(     ( D():AlbaranesClientes( ::nView ) )->cPobCli )
                  ::oAlbaran:CodigoPostalConsignatario(  ( D():AlbaranesClientes( ::nView ) )->cPosCli )
                  ::oAlbaran:ProvinciaConsignatario(     '00' + left( ( D():AlbaranesClientes( ::nView ) )->cPosCli, 2 ) )

               else

                  if dbSeekInOrd( ( D():AlbaranesClientes( ::nView ) )->cCodCli + ( D():AlbaranesClientes( ::nView ) )->cCodObr, "cCodCli", D():Get( "ObrasT", ::nView ) )
                     ::oAlbaran:DireccionConsignatario(     ( D():Get( "ObrasT", ::nView ) )->cDirObr )
                     ::oAlbaran:PoblacionConsignatario(     ( D():Get( "ObrasT", ::nView ) )->cPobObr )
                     ::oAlbaran:CodigoPostalConsignatario(  ( D():Get( "ObrasT", ::nView ) )->cPosObr )
                     ::oAlbaran:ProvinciaConsignatario(     '00' + left( ( D():Get( "ObrasT", ::nView ) )->cPosObr, 2 ) )
                  end if   

               end if
               
               ::oAlbaran:Bultos(                     ( D():AlbaranesClientes( ::nView ) )->nBultos )
               ::oAlbaran:Referencia(                 str( ( D():AlbaranesClientes( ::nView ) )->nNumAlb ) )
               ::oAlbaran:Peso(                       nTotalPesoAlbaranCliente( ( D():AlbaranesClientesId( ::nView ) ), ::nView ) )*/
               
            //end if

            /*msgWait( "Procesando " + str( ( D():AlbaranesClientes( ::nView ) )->( ordkeyNo() ) ) + " de " + ;
                     str( ( D():AlbaranesClientes( ::nView ) )->( ordkeyCount() ) ), , 0.3 )

            ( D():AlbaranesClientes( ::nView ) )->( dbSkip() )

         end while

         DestroyFastFilter( D():AlbaranesClientes( ::nView ) )

         if !empty( ::oAlbaran )
            //::oAlbaran:WriteASCII()
            //::SendFile()
         end if */
         
Return ( Self )

//---------------------------------------------------------------------------//

CLASS Redur FROM Cuaderno

   DATA cFile                          INIT 'redur_CAZU_' + dateToEU( date() ) + '.dcf'
   DATA cBuffer                        INIT ''

   DATA cFechaEnvio                    INIT ''
   DATA NombreConsignatario            INIT ''

   METHOD New()

   METHOD WriteASCII()
   METHOD SerializeASCII()

   METHOD cFechaEnvio( uValue )           INLINE ( if( !Empty( uValue ), ::cFechaEnvio := '{RC01;' + dToc( uValue ) + '|}', ::cFechaEnvio ) )
   METHOD NombreConsignatario( uValue )   INLINE ( if( !Empty( uValue ), ::NombreConsignatario := '{RC07;' + AllTrim( uValue ) + '|}', ::NombreConsignatario ) )





   /*METHOD LineaObligatoria1(uValue)              INLINE ( if( !Empty(uValue), ::cTipoRegisto                     := uValue, padr( ::cTipoRegisto, 3 ) ) )
   METHOD CodigoCliente(uValue)                  INLINE ( if( !Empty(uValue), ::cCodigoCliente                   := uValue, padr( ::cCodigoCliente, 12 ) ) )
   METHOD Tracking(uValue)                       INLINE ( if( !Empty(uValue), ::cTracking                        := uValue, padr( ::cTracking, 14 ) ) )
   METHOD Remitente(uValue)                      INLINE ( if( !Empty(uValue), ::cRemitente                       := uValue, padr( ::cRemitente, 12 ) ) )
   METHOD CodigoConsignatario(uValue)            INLINE ( if( !Empty(uValue), ::cCodigoConsignatario             := uValue, padr( ::cCodigoConsignatario, 12 ) ) )
   METHOD Documentacion(uValue)                  INLINE ( if( !Empty(uValue), ::cDocumentacion                   := uValue, padr( ::cDocumentacion, 20 ) ) )
   METHOD Producto(uValue)                       INLINE ( if( !Empty(uValue), ::cProducto                        := uValue, padr( ::cProducto, 3 ) ) )
   METHOD Preparacion(uValue)                    INLINE ( if( !Empty(uValue), ::dPreparacion                     := uValue, dateToEU( ::dPreparacion ) ) )
   METHOD Recogida(uValue)                       INLINE ( if( !Empty(uValue), ::dRecogida                        := uValue, dateToEU( ::dRecogida ) ) )
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
   METHOD FechaFactura(uValue)                   INLINE ( if( !Empty(uValue), ::dFechaFactura                    := uValue, dateToEU( ::dFechaFactura ) ) )
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
*/

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

      ::cBuffer   += '{LC;0360,1050,0637,1460,1,4|}' + CRLF
      ::cBuffer   += '{LC;0490,0010,0490,1048,1,2|}' + CRLF
      ::cBuffer   += '{LC;0360,0390,0637,0390,1,2|}' + CRLF
      ::cBuffer   += '  {LC;0490,0590,0637,0590,1,2|}' + CRLF
      ::cBuffer   += '  {LC;0490,0810,0637,0810,1,2|}' + CRLF
      ::cBuffer   += '{PC99;0800,0025,05,05,J,11,B=Remitente|}' + CRLF
      ::cBuffer   += '{PC98;0950,0480,05,05,J,11,B=Consignatario|}' + CRLF
      ::cBuffer   += '{PC97;0610,0400,05,05,J,11,B=Bultos:|}' + CRLF
      ::cBuffer   += '{PC96;0460,0025,05,05,J,11,B=Ref:|}' + CRLF
      ::cBuffer   += '{PC97;0460,0400,05,05,J,11,B=Obs:|}' + CRLF
      ::cBuffer   += '{PC96;0510,0480,1,15,J,11,B=/|}' + CRLF
      ::cBuffer   += '{PC96;0610,0600,05,05,J,11,B=Kilos:|}' + CRLF
      ::cBuffer   += '{PC95;0270,1200,06,07,J,11,B=RECOGIDAS:|}' + CRLF
      ::cBuffer   += '{PC94;0200,1200,06,07,J,11,B=902 11 19 11|}' + CRLF
      ::cBuffer   += '{PC93;0130,1200,06,07,J,11,B=www.redur.es|}' + CRLF
      ::cBuffer   += '{PC01;0950,0990,05,05,J,11,B|}' + CRLF
      ::cBuffer   += '{PC03;0780,1310,10,15,M,00,B|}' + CRLF
      ::cBuffer   += '{PC04;0760,0025,06,08,N,11,B|}' + CRLF
      ::cBuffer   += '{PC05;0720,0025,06,06,N,11,B|}' + CRLF
      ::cBuffer   += '{PC06;0680,0025,06,06,N,11,B|}' + CRLF
      ::cBuffer   += '{PC07;0850,0480,05,1,J,11,B|}' + CRLF
      ::cBuffer   += '{PC08;0780,0480,05,1,J,11,B|}' + CRLF
      ::cBuffer   += '{PC09;0710,0480,05,1,J,11,B|}' + CRLF
      ::cBuffer   += '{PC10;0510,0040,10,15,M,11,B|}' + CRLF
      ::cBuffer   += '{PC11;0410,1080,20,25,M,11,B|}' + CRLF
      ::cBuffer   += '{PC14;0430,0025,06,06,N,11,B|}' + CRLF
      ::cBuffer   += '{XB15;0340,0250,9,3,03,1,0280|}' + CRLF
      ::cBuffer   += '{PC16;0750,1250,20,20,M,11,B|}' + CRLF
      ::cBuffer   += '{PC18;0520,0510,06,1,J,11,B|}' + CRLF
      ::cBuffer   += '{PC19;0430,0400,06,06,N,11,B|}' + CRLF
      ::cBuffer   += '{PC20;0380,0400,06,06,N,11,B|}' + CRLF
      ::cBuffer   += '{PC21;0520,0600,06,1,J,11,B|}' + CRLF
      ::cBuffer   += '{PC22;0025,0440,06,06,J,11,B|}' + CRLF
      ::cBuffer   += '{PC23;0025,0580,06,06,J,11,B|}' + CRLF
      ::cBuffer   += '{PC24;0025,0800,06,06,J,11,B|}' + CRLF
      ::cBuffer   += '{PC26;0400,0400,06,06,N,11,B|} ' + CRLF
      ::cBuffer   += '{PC27;0370,0400,06,06,N,11,B|}' + CRLF
      ::cBuffer   += '{PC28;0350,0400,06,06,N,11,B|}' + CRLF
      ::cBuffer   += '{PC29;0520,0500,06,1,J,11,B|}' + CRLF
      ::cBuffer   += '{PC30;0520,0500,06,1,J,11,B|}' + CRLF
      ::cBuffer   += '{PC31;0520,0410,06,1,J,11,B|}' + CRLF
      ::cBuffer   += ::cFechaEnvio() + CRLF
      ::cBuffer   += '{RC04;CAFES Y ZUMOS S.L. 902194699|}' + CRLF
      ::cBuffer   += '{RC05;P.I.EL PINO C/PINO SILVESTRE,21|}' + CRLF
      ::cBuffer   += '{RC06;41016 SEVILLA|}' + CRLF
      ::cBuffer   += ::NombreConsignatario() + CRLF






      /*::cBuffer         += ::TipoRegisto()                    
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
      ::cBuffer         += CRLF*/

   Return ( ::cBuffer )

//---------------------------------------------------------------------------//

Function DateToEU( dDate )
   
   local strDate  := if( dDate != NIL, dtoc( dDate ), dtoc( date() ) )
   strDate        := strtran( strDate, "/", "" )

Return( strDate )

//---------------------------------------------------------------------------//