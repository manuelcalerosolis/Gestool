#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ini.ch"

//---------------------------------------------------------------------------//

CLASS ResourceBuilder

   DATA bInit 
   DATA bWhile                         INIT {|| .t. }
   DATA bFor                           INIT {|| .t. }
   DATA bAction   
   DATA bSkip                          INIT {|| .t. }
   DATA bExit 

   DATA nTotalPrinted                  INIT 0

   DATA aComponents                    INIT {}

   DATA nView

   DATA oDlg

   DATA oSerieInicio       
   DATA oSerieFin           

   DATA oDocumentoInicio
   DATA oDocumentoFin   

   DATA oSufijoInicio                  
   DATA oSufijoFin                     

   DATA oClienteInicio
   DATA oClienteFin
   
   DATA oGrupoClienteInicio
   DATA oGrupoClienteFin

   DATA oFechaInicio
   DATA oFechaFin

   DATA oImpresora

   DATA oCopias

   DATA oFormatoDocumento

   DATA oInforme

   DATA oImageList

   METHOD End()                           INLINE ( ::oDlg:end() )

   METHOD Serie( cSerie )                 INLINE ( ::oSerieInicio:cText( cSerie ), ::oSerieFin:cText( cSerie ) )
   METHOD Documento( cDocumento )         INLINE ( ::oDocumentoInicio:cText( cDocumento ), ::oDocumentoFin:cText( cDocumento ) )
   METHOD Sufijo( cSufijo )               INLINE ( ::oSufijoInicio:cText( cSufijo ), ::oSufijoFin:cText( cSufijo ) )
   METHOD FormatoDocumento( cFormato )    INLINE ( ::oFormatoDocumento:cText( cFormato ) )

   METHOD DocumentoInicio()               INLINE ( ::oSerieInicio:Value() + str( ::oDocumentoInicio:Value(), 9 ) + ::oSufijoInicio:Value() )
   METHOD DocumentoFin()                  INLINE ( ::oSerieFin:Value() + str( ::oDocumentoFin:Value(), 9 ) + ::oSufijoFin:Value() )

   // Metdos auxiliares para comparaciones -----------------------------------

   METHOD InRangeDocumento( uValue )      INLINE ( empty( uValue ) .or. ( uValue >= ::DocumentoInicio() .and. uValue <= ::DocumentoFin() ) )
   
   METHOD InRangeCliente( uValue )        INLINE ( empty( uValue ) .or. ( uValue >= ::oClienteInicio:Value() .and. uValue <= ::oClienteFin:Value() ) )
   METHOD InRangeGrupoCliente( uValue )   INLINE ( empty( uValue ) .or. ( uValue >= ::oGrupoClienteInicio:Value() .and. uValue <= ::oGrupoClienteFin:Value() ) )

   METHOD InRangeFecha( uValue )          INLINE ( empty( uValue ) .or. ( uValue >= ::oFechaInicio:Value() .and. uValue <= ::oFechaFin:Value() ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS PrintSeries FROM ResourceBuilder

   METHOD New( nView )

   METHOD AddComponent( oComponent )   INLINE ( aAdd( ::aComponents, oComponent ) )

   METHOD Resource()
      METHOD StartResource()
      METHOD ActionResource()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS PrintSeries

   ::nView                 := nView

   ::oSerieInicio          := GetSerie():New( 100, Self )
   ::oSerieFin             := GetSerie():New( 110, Self )

   ::oDocumentoInicio      := GetNumero():New( 120, Self )
   ::oDocumentoFin         := GetNumero():New( 130, Self )

   ::oSufijoInicio         := GetSufijo():New( 140, Self )
   ::oSufijoFin            := GetSufijo():New( 150, Self )

   ::oFechaInicio          := GetFecha():New( 210, Self )
   ::oFechaInicio:FirstDayYear()

   ::oFechaFin             := GetFecha():New( 220, Self )

   // Clientes-----------------------------------------------------------------

   ::oClienteInicio        := GetCliente():New( 300, 310, Self )
   ::oClienteFin           := GetCliente():New( 320, 330, Self )

   // Grupo de cliente---------------------------------------------------------

   ::oGrupoClienteInicio   := GetGrupoCliente():New( 340, 350, Self )
   ::oGrupoClienteFin      := GetGrupoCliente():New( 360, 370, Self )

   ::oFormatoDocumento     := GetDocumento():New( 90, 91, 92, Self )

   ::oImpresora            := GetPrinter():New( 160, 161, Self )

   ::oCopias               := GetCopias():New( 170, 180, Self )

   ::oImageList            := TImageList():New( 16, 16 )
   ::oImageList:AddMasked( TBitmap():Define( "Bullet_Square_Red_16" ),    Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "Bullet_Square_Green_16" ),  Rgb( 255, 0, 255 ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS PrintSeries

   local oBmp

   DEFINE DIALOG ::oDlg RESOURCE "ImprimirSeries" TITLE "Imprimir series de documentos"

   REDEFINE BITMAP oBmp ;
      ID          500 ;
      RESOURCE    "Printer_alpha_48" ;
      TRANSPARENT ;
      OF          ::oDlg

   aEval( ::aComponents, {| o | o:Resource() } )

   ::oInforme     := TTreeView():Redefine( 400, ::oDlg )

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::ActionResource() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:end() )

   ::oDlg:AddFastKey( VK_F5, {|| ::ActionResource() } )

   ::oDlg:bStart  := {|| ::StartResource() }

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:end()   
   
   ::oImageList:End()

   ::oInforme:Destroy()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD StartResource() CLASS PrintSeries

   ::oInforme:SetImageList( ::oImageList )

   ::oClienteInicio:Valid()   
   ::oClienteFin:Valid()

   ::oGrupoClienteInicio:Valid()   
   ::oGrupoClienteFin:Valid()

   ::oFormatoDocumento:Valid()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD ActionResource() CLASS PrintSeries

   local nRecno
   local nOrdAnt

   ::nTotalPrinted   := 0

   ::oDlg:disable()

   if !empty( ::bInit )
      eval( ::bInit )
   end if 

   while eval( ::bWhile )

      if eval( ::bFor )

         if !empty( ::bAction )
            eval( ::bAction )
            ++::nTotalPrinted
         end if

      end if 

      eval( ::bSkip )
          
   end while 

   if !empty( ::bExit )
      eval( ::bExit )
   end if 

   ::oDlg:enable()
   ::oDlg:end( IDOK )

RETURN ( Self )

//--------------------------------------------------------------------------//

CLASS ImportarProductosProveedor FROM PrintSeries

   DATA oPorcentaje

   METHOD New( nView )

   METHOD Resource()

   METHOD ActionResource()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS ImportarProductosProveedor

   ::nView                 := nView

   ::oFechaInicio          := GetFecha():New( 100, Self )
   ::oFechaInicio:FirstDayPreviusMonth()

   ::oFechaFin             := GetFecha():New( 110, Self )
   ::oFechaFin:LastDayPreviusMonth()

   ::oPorcentaje           := GetPorcentaje():New( 120, Self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ImportarProductosProveedor

   DEFINE DIALOG ::oDlg RESOURCE "ImportarProductosProveedor"

   aEval( ::aComponents, {| o | o:Resource() } )

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::ActionResource() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:end() )

   ::oDlg:AddFastKey( VK_F5, {|| ::ActionResource() } )

   ACTIVATE DIALOG ::oDlg CENTER

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD ActionResource() CLASS ImportarProductosProveedor

   ::oDlg:disable()

      if !empty( ::bAction )
         eval( ::bAction )
      end if 

   ::oDlg:enable()
   ::oDlg:end( IDOK )

RETURN ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS Component

   DATA oContainer

   METHOD New( oContainer )

END CLASS

METHOD New( oContainer )
   
   ::oContainer   := oContainer

   ::oContainer:AddComponent( Self )

Return ( Self )
   
//---------------------------------------------------------------------------//

CLASS ComponentGet FROM Component

   DATA idGet
   DATA idSay

   DATA bValid                   INIT {|| .t. }
   DATA bHelp                    INIT {|| .t. }

   DATA oGetControl
   DATA uGetValue                INIT Space( 12 )
   
   METHOD New( idGet, oContainer )

   METHOD Resource()

   METHOD cText( uGetValue )     INLINE ( if( !empty( ::oGetControl ), ::oGetControl:cText( uGetValue ), ::uGetValue := uGetValue ) )
   METHOD Value()                INLINE ( ::uGetValue )

   METHOD Valid()                INLINE ( if( !empty( ::oGetControl ), ::oGetControl:lValid(), .t. ) )

END CLASS 

METHOD New( idGet, oContainer ) CLASS ComponentGet

   ::idGet  := idGet

   Super:New( oContainer )

RETURN ( Self )

METHOD Resource() CLASS ComponentGet

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      BITMAP      "LUPA" ;
      OF          ::oContainer:oDlg

   ::oGetControl:bValid    := ::bValid
   ::oGetControl:bHelp     := ::bHelp

Return ( Self )

//--------------------------------------------------------------------------//

CLASS ComponentGetSay FROM ComponentGet

   DATA idSay

   DATA oSayControl        
   DATA cSayValue                INIT ""

   METHOD New( idGet, idSay, oContainer )

   METHOD Resource()

END CLASS 

METHOD New( idGet, idSay, oContainer ) CLASS ComponentGetSay

   ::idSay  := idSay

   Super:New( idGet, oContainer )

RETURN ( Self )

METHOD Resource() CLASS ComponentGetSay

   Super:Resource()

   REDEFINE GET   ::oSayControl ;
      VAR         ::cSayValue ;
      ID          ::idSay ;
      WHEN        ( .f. ) ;
      OF          ::oContainer:oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetCliente FROM ComponentGetSay

   METHOD New( idGet, idSay, oContainer ) 

   METHOD First()    INLINE ( ::cText( Space( RetNumCodCliEmp() ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", RetNumCodCliEmp() ) ) )

   METHOD Top()      INLINE ( ::cText( TDataView():Top( "Client", ::oContainer:nView ) ) )
   METHOD Bottom()   INLINE ( ::cText( TDataView():Bottom( "Client", ::oContainer:nView ) ) )

END CLASS 

METHOD New( idGet, idSay, oContainer ) CLASS GetCliente

   Super:New( idGet, idSay, oContainer )

   ::bValid       := {|| cClient( ::oGetControl, TDataView():Clientes( ::oContainer:nView ), ::oSayControl ) }
   ::bHelp        := {|| BrwClient( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetGrupoCliente FROM ComponentGetSay

   METHOD New( idGet, idSay, oContainer )

   METHOD First()    INLINE ( ::cText( Space( 4 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 4 ) ) )

   METHOD Top()      INLINE ( ::cText( TDataView():GetObject( "GruposClientes", ::oContainer:nView ):Top() ) )
   METHOD Bottom()   INLINE ( ::cText( TDataView():GetObject( "GruposClientes", ::oContainer:nView ):Bottom() ) )

END CLASS 

METHOD New( idGet, idSay, oContainer ) CLASS GetGrupoCliente

   Super:New( idGet, idSay, oContainer )

   ::uGetValue    := Space( 4 )

   ::bValid       := {|| TDataView():GruposClientes( ::oContainer:nView ):Existe( ::oGetControl, ::oSayControl, "cNomGrp", .t., .t., "0" ) }
   ::bHelp        := {|| TDataView():GruposClientes( ::oContainer:nView ):Buscar( ::oGetControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetDocumento FROM ComponentGetSay

   DATA idBtn
   DATA cTypeDocumento              INIT Space( 2 )

   METHOD New( idGet, idSay, oContainer )

   METHOD Resource()

   METHOD TypeDocumento( cType )    INLINE ( if( !empty( cType ), ::cTypeDocumento := cType, ::cTypeDocumento ) )

END CLASS 

METHOD New( idGet, idSay, idBtn, oContainer ) CLASS GetDocumento

   Super:New( idGet, idSay, oContainer )

   ::idBtn        := idBtn

   ::uGetValue    := Space( 3 )

   ::bValid       := {|| cDocumento( ::oGetControl, ::oSayControl, TDataView():Documentos( ::oContainer:nView ) ) }
   ::bHelp        := {|| brwDocumento( ::oGetControl, ::oSayControl, ::TypeDocumento() ) }

Return ( Self )

METHOD Resource() CLASS GetDocumento

   Super:Resource()

   TBtnBmp():ReDefine( ::idBtn, "Printer_pencil_16",,,,,{|| EdtDocumento( ::uGetValue ) }, ::oContainer:oDlg, .f., , .f.,  )

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetPrinter FROM ComponentGet

   DATA idBtn

   DATA cTypeDocumento              INIT Space( 2 )

   METHOD New( idGet, oContainer )

   METHOD Resource()

   METHOD TypeDocumento( cType )    INLINE ( if( !empty( cType ), ::cTypeDocumento := cType, ::cTypeDocumento ) )

END CLASS 

METHOD New( idGet, idBtn, oContainer ) CLASS GetPrinter

   Super:New( idGet, oContainer )

   ::idBtn        := idBtn

   ::uGetValue    := PrnGetName()

Return ( Self )

METHOD Resource() CLASS GetPrinter

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      WHEN        ( .f. ) ;
      OF          ::oContainer:oDlg

   TBtnBmp():ReDefine( ::idBtn, "Printer_preferences_16",,,,, {|| PrinterPreferences( ::oGetControl ) }, ::oContainer:oDlg, .f., , .f. )

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetSerie FROM ComponentGet

   METHOD New( idGet, oContainer )

   METHOD Resource()

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetSerie

   Super:New( idGet, oContainer )

   ::uGetValue    := "A"

   ::bValid       := {|| ::uGetValue >= "A" .and. ::uGetValue <= "Z" }

Return ( Self )

METHOD Resource() CLASS GetSerie

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP       ( UpSerie( ::oGetControl ) );
      ON DOWN     ( DwSerie( ::oGetControl ) );
      VALID       ( ::bValid );
      OF          ::oContainer:oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetNumero FROM ComponentGet

   METHOD New( idGet, oContainer )

   METHOD Resource()

   METHOD SetPicture()

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetNumero

   Super:New( idGet, oContainer )

   ::uGetValue    := 1
   
   ::bValid       := {|| ::uGetValue >= 1 .and. ::uGetValue <= 999999999 }

Return ( Self )

METHOD Resource() CLASS GetNumero

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "999999999" ;
      SPINNER ;
      VALID       ::bValid ;
      OF          ::oContainer:oDlg

Return ( Self )

METHOD SetPicture( cPicture )

   ::oGetControl:oGet:Assign()
   ::oGetControl:oGet:Picture   := cPicture
   ::oGetControl:oGet:UpdateBuffer()

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetSufijo FROM ComponentGet

   METHOD New( idGet, oContainer )

   METHOD Resource()

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetSufijo

   Super:New( idGet, oContainer )

   ::uGetValue    := RetSufEmp()

Return ( Self )

METHOD Resource() CLASS GetSufijo

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "@!" ;
      OF          ::oContainer:oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetFecha FROM ComponentGet

   METHOD New( idGet, oContainer )

   METHOD Resource()

   METHOD FirstDayYear()         INLINE ( ::cText( BoY( Date() ) ) )
   METHOD LastDayYear()          INLINE ( ::cText( EoY( Date() ) ) )

   METHOD FirstDayMonth()        INLINE ( ::cText( BoM( Date() ) ) )
   METHOD LastDayMonth()         INLINE ( ::cText( EoM( Date() ) ) )

   METHOD FirstDayPreviusMonth() INLINE ( ::cText( BoM( AddMonth( Date(), -1 ) ) ) )
   METHOD LastDayPreviusMonth()  INLINE ( ::cText( EoM( AddMonth( Date(), -1 ) ) ) ) 

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetFecha

   Super:New( idGet, oContainer )

   ::uGetValue    := Date()
   
Return ( Self )

METHOD Resource() CLASS GetFecha

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      SPINNER ;
      OF          ::oContainer:oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetCopias FROM ComponentGet

   DATA idCheck 

   DATA lCopiasPredeterminadas   INIT .t.

   METHOD New( idGet, oContainer )

   METHOD Resource()

END CLASS 

METHOD New( idCheck, idGet, oContainer ) CLASS GetCopias

   Super:New( idGet, oContainer )

   ::idCheck      := idCheck

   ::uGetValue    := 1
   
   ::bValid       := {|| ::uGetValue >= 1 .and. ::uGetValue <= 99999 }

Return ( Self )

METHOD Resource() CLASS GetCopias

   REDEFINE CHECKBOX ::lCopiasPredeterminadas ;
      ID          ::idCheck ;
      OF          ::oContainer:oDlg

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "99999" ;
      SPINNER ;
      WHEN        !::lCopiasPredeterminadas ;
      VALID       ::bValid ;
      OF          ::oContainer:oDlg

Return ( Self )

//--------------------------------------------------------------------------//

CLASS GetPorcentaje FROM ComponentGet

   DATA idGet 

   METHOD New( idGet, oContainer )

   METHOD Resource()

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetPorcentaje

   Super:New( idGet, oContainer )

   ::uGetValue    := 0
   
   ::bValid       := {|| ::uGetValue >= 0 .and. ::uGetValue <= 100 }

Return ( Self )

METHOD Resource() CLASS GetPorcentaje

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "999" ;
      SPINNER ;
      VALID       ::bValid ;
      OF          ::oContainer:oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

Function nLastDay( nMes )

   local cMes     := Str( if( nMes == 12, 1, nMes + 1 ), 2 )
   local cAno     := Str( if( nMes == 12, Year( Date() ) + 1, Year( Date() ) ) )

Return ( Ctod( "01/" + cMes + "/" + cAno ) - 1 )

//---------------------------------------------------------------------------//



CLASS FacturasClientesRisi

   DATA nView

   DATA getFechaInicio  INIT ( BoM( Date() ) ) 
   DATA getFechaFin     INIT ( EoM( Date() ) ) 

   DATA oAlbaran
   DATA aAlbaranes      INIT {}

   METHOD New()

   METHOD Dialog()

   METHOD SendFile()

   METHOD OpenFiles()
   METHOD CloseFiles()

ENDCLASS

//---------------------------------------------------------------------------//

   METHOD New() CLASS FacturasClientesRisi

      if !::Dialog()
         Return ( Self )
      end if 
   
    if !::OpenFiles()
         Return ( Self )
      end if 

    if ( TDataView():AlbaranesClientes( ::nView ) )->( dbseek( date() ) )

        while !( TDataView():AlbaranesClientes( ::nView ) )->( eof() )

           if rtrim( ( TDataView():AlbaranesClientes( ::nView ) )->cCodTrn ) == "001"

              if Empty( ::oAlbaran )
                 ::oAlbaran                          := Redur():New()
              end if 

            ::oAlbaran:Tracking(                   '500324' + strzero( ( TDataView():AlbaranesClientes( ::nView ) )->nNumAlb, 9 ) )
            ::oAlbaran:Remitente(                  'CAZU' )
            ::oAlbaran:NombreConsignatario(        ( TDataView():AlbaranesClientes( ::nView ) )->cNomCli )
            ::oAlbaran:DireccionConsignatario(     ( TDataView():AlbaranesClientes( ::nView ) )->cDirCli )
            ::oAlbaran:PoblacionConsignatario(     ( TDataView():AlbaranesClientes( ::nView ) )->cPobCli )
            ::oAlbaran:CodigoPostalConsignatario(  ( TDataView():AlbaranesClientes( ::nView ) )->cPosCli )
            ::oAlbaran:ProvinciaConsignatario(     '00' + left( ( TDataView():AlbaranesClientes( ::nView ) )->cPosCli, 2 ) )
            ::oAlbaran:Bultos(                     ( TDataView():AlbaranesClientes( ::nView ) )->nBultos )
            ::oAlbaran:Referencia(                 str( ( TDataView():AlbaranesClientes( ::nView ) )->nNumAlb ) )
            ::oAlbaran:Peso(                       nTotalPesoAlbaranCliente( ( TDataView():AlbaranesClientesId( ::nView ) ), ::nView ) )
              
              ::oAlbaran:SerializeASCII()

           end if 

           ( TDataView():AlbaranesClientes( ::nView ) )->( dbSkip() )

        end while

        if !empty( ::oAlbaran )
           ::oAlbaran:WriteASCII()
           ::SendFile()
        end if 

     else

        msgStop( "No hay albaranes para " + dtoc( date() ) )

     end if 

     ::CloseFiles()

   Return ( Self )

//---------------------------------------------------------------------------//

   METHOD Dialog() CLASS FacturasClientesRisi

      local oDlg
      local oBtn
      local getFechaInicio
      local getFechaFin
      local lExit             := .f.

      DEFINE DIALOG oDlg FROM 5, 5 TO 15, 40 TITLE "Exportacion Risi"

      @ 1,  2 GET getFechaInicio VAR ::dFechaInicio SIZE 100, 25

      @ 3,  4 BUTTON "&Ok" OF oDlg SIZE 40, 12

      @ 3, 12 BUTTON oBtn PROMPT "&Cancel" OF oDlg SIZE 40, 12 ;
         ACTION ( MsgInfo( "Cancel" ), lExit := .t., oDlg:End() )

      ACTIVATE DIALOG oDlg VALID lExit

   Return ( Self )

//---------------------------------------------------------------------------//

   METHOD OpenFiles() CLASS FacturasClientesRisi

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := TDataView():CreateView()

      TDataView():AlbaranesClientes( ::nView )

      TDataView():AlbaranesClientesLineas( ::nView )      

      ( TDataView():AlbaranesClientes( ::nView ) )->( ordsetfocus( "dFecAlb" ) )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   Return ( lOpenFiles )

//---------------------------------------------------------------------------//

   METHOD CloseFiles CLASS FacturasClientesRisi

      TDataView():DeleteView( ::nView )

   Return ( Self )

//---------------------------------------------------------------------------//

   METHOD SendFile() CLASS FacturasClientesRisi

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

   DATA cFile                             INIT 'redur_CAZU_' + dtos( date() ) + '.dcf'
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
   METHOD Preparacion(uValue)                    INLINE ( if( !Empty(uValue), ::dPreparacion                     := uValue, dtos( ::dPreparacion ) ) )
   METHOD Recogida(uValue)                       INLINE ( if( !Empty(uValue), ::dRecogida                        := uValue, dtos( ::dRecogida ) ) )
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
   METHOD FechaFactura(uValue)                   INLINE ( if( !Empty(uValue), ::dFechaFactura                    := uValue, dtos( ::dFechaFactura ) ) )
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