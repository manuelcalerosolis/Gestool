#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio( nView, oPais )

   local oAlbarenesClientesRedur

   oAlbarenesClientesRedur    := AlbarenesClientesRedur():New( nView, oPais )

Return ( nil )

//---------------------------------------------------------------------------//

CLASS AlbarenesClientesRedur

   DATA nView
   DATA oPais

   DATA oAlbaran
   DATA cNumAlbaran
   DATA cOutDirectory
   DATA nTotalBultos
   DATA cImpresora

   DATA cFileCodigosPostales
   DATA aCodigosPostales   

   METHOD New()
   METHOD getCodigosPostalesCVS()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView, oPais ) CLASS AlbarenesClientesRedur

   local nBulto
   local cFileName               := ""

   ::nView                       := nView
   ::oPais                       := oPais
   ::cNumAlbaran                 := ( D():AlbaranesClientes( ::nView ) )->cSerAlb + Str( ( D():AlbaranesClientes( ::nView ) )->nNumAlb ) + ( D():AlbaranesClientes( ::nView ) )->cSufAlb
   ::cOutDirectory               := cPatScript() + "AlbaranesClientes\Resultado\"
   ::cFileCodigosPostales        := cPatScript() + "AlbaranesClientes\CODIGOS_POSTALES_PLAZA.CSV"
   ::nTotalBultos                := ( D():AlbaranesClientes( ::nView ) )->nBultos
   ::cImpresora                  := "PDFCreator"

   if !::getCodigosPostalesCVS()
      MsgInfo( "No hemos encontrado la tabla de plaza de reparto" )
      Return .f.
   end if

   for nBulto := 1 to ::nTotalBultos

      MsgWait( "Generando fichero " + AllTrim( Str( nBulto ) ) + " de " + AllTrim( Str( ::nTotalBultos ) ), "Procesando", 0.2 )

      if Empty( ::oAlbaran )
         ::oAlbaran                 := Redur():New( self )
      end if

      ::oAlbaran:FechaEnvio( ( D():AlbaranesClientes( ::nView ) )->dFecAlb )
      ::oAlbaran:NombreConsignatario( ( D():AlbaranesClientes( ::nView ) )->cNomCli )
      
      if ( D():Clientes( ::nView ) )->( dbSeek( ( D():AlbaranesClientes( ::nView ) )->cCodCli ) )
         ::oAlbaran:DireccionConsignatario( ( D():Clientes( ::nView ) )->cDomEnt )
         ::oAlbaran:PoblacionConsignatario( ( D():Clientes( ::nView ) )->cPobEnt )
         ::oAlbaran:CodigoPostalConsignatario( ( D():Clientes( ::nView ) )->cCPEnt )
         ::oAlbaran:PlazaReparto( ( D():Clientes( ::nView ) )->cCPEnt )
         ::oAlbaran:Observaciones1( ( D():Clientes( ::nView ) )->mComent )
      else
         ::oAlbaran:DireccionConsignatario( ( D():AlbaranesClientes( ::nView ) )->cDirCli )
         ::oAlbaran:PoblacionConsignatario( ( D():AlbaranesClientes( ::nView ) )->cPobCli )
         ::oAlbaran:CodigoPostalConsignatario( ( D():AlbaranesClientes( ::nView ) )->cPosCli )
         ::oAlbaran:PlazaReparto( ( D():AlbaranesClientes( ::nView ) )->cPosCli )
         ::oAlbaran:Observaciones1( ( D():AlbaranesClientes( ::nView ) )->mObserv )
      end if

      ::oAlbaran:ReferenciaAlbaran( ( D():AlbaranesClientes( ::nView ) )->nNumAlb )
      ::oAlbaran:CodigoBarras( nBulto )
      ::oAlbaran:TotalBultos( FotmatoBultos( ( D():AlbaranesClientes( ::nView ) )->nBultos ) )
      //::oAlbaran:Observaciones1( ( D():AlbaranesClientes( ::nView ) )->mObserv )
      ::oAlbaran:TotalPeso( nTotalPesoAlbaranCliente( ::cNumAlbaran, ::nView, MasUnd() ) )
      ::oAlbaran:SufijoTraking( ( D():AlbaranesClientes( ::nView ) )->nNumAlb )
      ::oAlbaran:NumeroBulto( FotmatoBultos( nBulto ) )
      ::oAlbaran:Observaciones2( ( D():AlbaranesClientes( ::nView ) )->MComent )
      ::oAlbaran:Observaciones3( ( D():AlbaranesClientes( ::nView ) )->cCondEnt )
      ::oAlbaran:NumeroBulto2( FotmatoBultos( nBulto ) )

      cFileName      := ( D():AlbaranesClientes( ::nView ) )->cSerAlb
      cFileName      += AllTrim( Str( ( D():AlbaranesClientes( ::nView ) )->nNumAlb ) )
      cFileName      += ( D():AlbaranesClientes( ::nView ) )->cSufAlb
      cFileName      += FotmatoBultos( nBulto )
      cFileName      += ".txt"

      ::oAlbaran:SerializeASCII()
      ::oAlbaran:WriteASCII( ::cOutDirectory + cFileName )

      if File( ::cOutDirectory + cFileName )
         win_printFileRaw( ::cImpresora, ::cOutDirectory + cFileName )
         fErase( ::cOutDirectory + cFileName )
      end if

      ::oAlbaran     := nil

   next

   MsgInfo( "Proceso terminado con éxito" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getCodigosPostalesCVS() CLASS AlbarenesClientesRedur

   local cMemoRead
   local aLineas
   local line

   ::aCodigosPostales            := {}

   if !File( ::cFileCodigosPostales )
      Return .f.
   end if

   alineas           := hb_aTokens( MemoRead( ::cFileCodigosPostales ), CRLF )

   for each line in alineas
      aadd( ::aCodigosPostales, hb_aTokens( line, ";" ) )
   next

Return .t.

//---------------------------------------------------------------------------//

CLASS Redur FROM Cuaderno

   DATA oParent
   DATA nView
   DATA oPais

   DATA cBuffer                        INIT ''

   DATA dFechaEnvio                    INIT ''
   DATA cNombreConsignatario           INIT ''
   DATA cDireccionConsignatario        INIT ''
   DATA cPoblacionConsignatario        INIT ''
   DATA cCodigoPostalConsignatario     INIT ''
   DATA cPlazaReparto                  INIT ''
   DATA cReferenciaAlbaran             INIT ''
   DATA cTotalBultos                   INIT ''
   DATA cObservaciones1                INIT '{RC19;|}'
   DATA cTotalPeso                     INIT ''
   DATA cSufijoTraking                 INIT ''
   DATA cNumeroBulto                   INIT ''
   DATA cObservaciones2                INIT '{RC26;|}'
   DATA cObservaciones3                INIT '{RC27;|}'
   DATA cNumeroBulto2                  INIT ''
   DATA cCodigoBarras                  INIT ''

   METHOD New()

   METHOD WriteASCII()
   METHOD SerializeASCII()

   METHOD FechaEnvio( uValue )                  INLINE ( if( !Empty( uValue ), ::dFechaEnvio := '{RC01;' + dToc( uValue ) + '|}', ::dFechaEnvio ) )
   METHOD NombreConsignatario( uValue )         INLINE ( if( !Empty( uValue ), ::cNombreConsignatario := '{RC07;' + AllTrim( uValue ) + '|}', ::cNombreConsignatario ) )
   METHOD DireccionConsignatario( uValue )      INLINE ( if( !Empty( uValue ), ::cDireccionConsignatario := '{RC08;' + AllTrim( uValue ) + '|}', ::cDireccionConsignatario ) )
   METHOD PoblacionConsignatario( uValue )      INLINE ( if( !Empty( uValue ), ::cPoblacionConsignatario := '{RC09;' + AllTrim( uValue ) + '|}', ::cPoblacionConsignatario ) )
   METHOD CodigoPostalConsignatario( uValue )   INLINE ( if( !Empty( uValue ), ::cCodigoPostalConsignatario := '{RC10;' + AllTrim( uValue ) + '|}', ::cCodigoPostalConsignatario ) )
   METHOD PlazaReparto( uValue )
   METHOD ReferenciaAlbaran( uValue )           INLINE ( if( !Empty( uValue ), ::cReferenciaAlbaran := '{RC14;' + AllTrim( Str( uValue ) ) + '|}', ::cReferenciaAlbaran ) )
   METHOD CodigoBarras( nBulto )
   METHOD TotalBultos( uValue )                 INLINE ( if( !Empty( uValue ), ::cTotalBultos := '{RC18;' + AllTrim( uValue ) + '|}', ::cTotalBultos ) )
   METHOD Observaciones1( uValue )              INLINE ( if( !Empty( uValue ), ::cObservaciones1 := '{RC19;' + AllTrim( uValue ) + '|}', ::cObservaciones1 ) )
   METHOD TotalPeso( uValue )                   INLINE ( if( !Empty( uValue ), ::cTotalPeso := '{RC21;' + AllTrim( uValue ) + ' Kg|}', ::cTotalPeso ) )
   METHOD SufijoTraking( uValue )               INLINE ( if( !Empty( uValue ), ::cSufijoTraking := '{RC23;0' + AllTrim( Str( uValue ) ) + '-|}', ::cSufijoTraking ) )
   METHOD NumeroBulto( uValue )                 INLINE ( if( !Empty( uValue ), ::cNumeroBulto := '{RC24;' + AllTrim( uValue ) + '|}', ::cNumeroBulto ) )
   METHOD Observaciones2( uValue )              INLINE ( if( !Empty( uValue ), ::cObservaciones2 := '{RC26;' + AllTrim( uValue ) + '|}', ::cObservaciones2 ) )
   METHOD Observaciones3( uValue )              INLINE ( if( !Empty( uValue ), ::cObservaciones3 := '{RC27;' + AllTrim( uValue ) + '|}', ::cObservaciones3 ) )
   METHOD NumeroBulto2( uValue )                INLINE ( if( !Empty( uValue ), ::cNumeroBulto2 := '{RC31;' + AllTrim( uValue ) + '|}', ::cNumeroBulto2 ) )

ENDCLASS

   //------------------------------------------------------------------------//

   METHOD New( oParent ) CLASS Redur 

   ::oParent         := oParent
   ::nView           := ::oParent:nView
   ::oPais           := ::oParent:oPais

   Return ( Self )

   //------------------------------------------------------------------------//

   METHOD WriteASCII( cFileName ) CLASS Redur 

      local hFile

      if empty( ::cBuffer )
         Return ( .f. )
      end if

      hFile           := fCreate( cFileName )

      if !Empty( hFile ) 
         fWrite( hFile, ::cBuffer )
         fClose( hFile )
      end if

   Return ( .t. )

   //------------------------------------------------------------------------//

   METHOD SerializeASCII() CLASS Redur 

      
      ::cBuffer   += '{D1515,1015,1490|}' + CRLF
      ::cBuffer   += '{C|}' + CRLF
      ::cBuffer   += '{LC;0010,0010,0995,1460,1,4|}' + CRLF
      ::cBuffer   += '{LC;0010,0010,0358,1168,1,4|}' + CRLF
      ::cBuffer   += '{LC;0640,0010,0995,0458,1,4|}' + CRLF
      ::cBuffer   += '{LC;0640,0460,0995,1168,1,4|}' + CRLF
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
      ::cBuffer   += ::FechaEnvio() + CRLF
      ::cBuffer   += '{RC04;CAFES Y ZUMOS S.L. 902194699|}' + CRLF
      ::cBuffer   += '{RC05;P.I.EL PINO C/PINO SILVESTRE,21|}' + CRLF
      ::cBuffer   += '{RC06;41016 SEVILLA|}' + CRLF
      ::cBuffer   += ::NombreConsignatario() + CRLF
      ::cBuffer   += ::DireccionConsignatario() + CRLF
      ::cBuffer   += ::PoblacionConsignatario() + CRLF
      ::cBuffer   += ::CodigoPostalConsignatario() + CRLF
      ::cBuffer   += ::cPlazaReparto + CRLF
      ::cBuffer   += ::ReferenciaAlbaran() + CRLF
      ::cBuffer   += ::cCodigoBarras + CRLF
      ::cBuffer   += '{RC16;U|}' + CRLF
      ::cBuffer   += ::TotalBultos() + CRLF
      ::cBuffer   += ::Observaciones1() + CRLF
      ::cBuffer   += '{RC20;|}' + CRLF
      ::cBuffer   += ::cTotalPeso() + CRLF
      ::cBuffer   += '{RC22;500324-|}' + CRLF
      ::cBuffer   += ::SufijoTraking() + CRLF
      ::cBuffer   += ::NumeroBulto() + CRLF
      ::cBuffer   += ::Observaciones2() + CRLF
      ::cBuffer   += ::Observaciones3() + CRLF
      ::cBuffer   += '{RC28;|}' + CRLF
      ::cBuffer   += ::NumeroBulto2() + CRLF
      ::cBuffer   += '{XS;I,0001,0002CA000|}' + CRLF

Return ( ::cBuffer )

//---------------------------------------------------------------------------//

METHOD CodigoBarras( nBulto ) CLASS Redur

   local cCodPai        := ''
   local cCodBar        := ''

   cCodBar      += '1'

   if ( D():Clientes( ::nView ) )->( dbSeek( ( D():AlbaranesClientes( ::nView ) )->cCodCli ) )

      cCodBar   += AllTrim( ( D():Clientes( ::nView ) )->cCPEnt )
    
      cCodPai           := ::oPais:GetIsoPais( ( D():Clientes( ::nView ) )->cCodPai )

   end if

   cCodBar      += '000'
   cCodBar      += cCodPai
   cCodBar      += '500324'
   cCodBar      += RJust( AllTrim( Str( ( D():AlbaranesClientes( ::nView ) )->nNumAlb ) ), "0", 8 )
   cCodBar      += FotmatoBultos( nBulto )

   ::cCodigoBarras      := '{RB15;' + cCodBar + '|}'

Return nil

//---------------------------------------------------------------------------//

METHOD PlazaReparto( uValue ) CLASS Redur

   local cPlaza   := ""
   local nPos     := 0
   
   
   if len( ::oParent:aCodigosPostales ) > 0
      nPos        := aScan( ::oParent:aCodigosPostales, {|x| if( isArray(x), x[2] == AllTrim( uValue ), .f. ) } )
   end if

   if nPos != 0
      cPlaza      := AllTrim( ::oParent:aCodigosPostales[ nPos, 4 ] )
   end if

   ::cPlazaReparto   := '{RC11;' + cPlaza + '|}'

Return nil

//----------------------------------------------------------------------------//

Function DateToEU( dDate )
   
   local strDate  := if( dDate != NIL, dtoc( dDate ), dtoc( date() ) )
   strDate        := strtran( strDate, "/", "" )

Return( strDate )

//---------------------------------------------------------------------------//

Function FotmatoBultos( uBultos )

return RJust( AllTrim( Str( uBultos ) ), "0", 3 )

//---------------------------------------------------------------------------//