#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "RichEdit.ch" 

#define FW_BOLD                        700


//---------------------------------------------------------------------------//

CLASS ResourceBuilder

   DATA bInit 
   DATA bWhile                         INIT {|| .t. }
   DATA bFor                           INIT {|| .t. }
   DATA bAction   
   DATA bSkip                          INIT {|| .t. }
   DATA bExit
   DATA bStart 

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

   DATA oProveedorInicio
   DATA oProveedorFin

   DATA oGrupoProveedorInicio
   DATA oGrupoProveedorFin

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

   METHOD InRangeProveedor( uValue )      INLINE ( empty( uValue ) .or. ( uValue >= ::oProveedorInicio:Value() .and. uValue <= ::oProveedorFin:Value() ) )
   METHOD InRangeGrupoProveedor( uValue ) INLINE ( empty( uValue ) .or. ( uValue >= ::oGrupoProveedorInicio:Value() .and. uValue <= ::oGrupoProveedorFin:Value() ) )

   METHOD InRangeFecha( uValue )          INLINE ( empty( uValue ) .or. ( uValue >= ::oFechaInicio:Value() .and. uValue <= ::oFechaFin:Value() ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS PrintSeries FROM ResourceBuilder

   METHOD New( nView )

   METHOD SetCompras()
   METHOD SetVentas()

   METHOD AddComponent( oComponent )      INLINE ( aAdd( ::aComponents, oComponent ) )

   METHOD Resource()
      METHOD StartResource()
      METHOD ActionResource()
      METHOD DisableRange()

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

   ::oFormatoDocumento     := GetDocumento():New( 90, 91, 92, Self )

   ::oImpresora            := GetPrinter():New( 160, 161, Self )

   ::oCopias               := GetCopias():New( 170, 180, Self )

   ::oImageList            := TImageList():New( 16, 16 )
   ::oImageList:AddMasked( TBitmap():Define( "Bullet_Square_Red_16" ),    Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "Bullet_Square_Green_16" ),  Rgb( 255, 0, 255 ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetCompras()

   // Proveedores-----------------------------------------------------------------

   ::oProveedorInicio      := GetProveedor():New( 300, 310, 301, Self )
   ::oProveedorInicio:SetText( "Desde proveedor" )
   ::oProveedorInicio:First()

   ::oProveedorFin         := GetProveedor():New( 320, 330, 321, Self )
   ::oProveedorFin:SetText( "Hasta proveedor" )
   ::oProveedorFin:Last()

   // Grupo de proveedores---------------------------------------------------------

   ::oGrupoProveedorInicio := GetGrupoProveedor():New( 340, 350, 341, Self )
   ::oGrupoProveedorInicio:SetText( "Desde grupo proveedor" )
   ::oGrupoProveedorInicio:First()

   ::oGrupoProveedorFin    := GetGrupoProveedor():New( 360, 370, 361, Self )
   ::oGrupoProveedorFin:SetText( "Hasta grupo proveedor" )
   ::oGrupoProveedorFin:Last()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetVentas()

   // Clientes-----------------------------------------------------------------

   ::oClienteInicio        := GetCliente():New( 300, 310, 301, Self )
   ::oClienteInicio:SetText( "Desde cliente" )
   ::oClienteInicio:First()

   ::oClienteFin           := GetCliente():New( 320, 330, 321, Self )
   ::oClienteFin:SetText( "Hasta cliente" )
   ::oClienteFin:Last()

   // Grupo de cliente---------------------------------------------------------

   ::oGrupoClienteInicio   := GetGrupoCliente():New( 340, 350, 341, Self )
   ::oGrupoClienteInicio:SetText( "Desde grupo cliente" )
   ::oGrupoClienteInicio:First()

   ::oGrupoClienteFin      := GetGrupoCliente():New( 360, 370, 361, Self )
   ::oGrupoClienteFin:SetText( "Hasta grupo cliente" )
   ::oGrupoClienteFin:Last()

Return ( Self )

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

   //Si usamos clientes----------------------------------------------------

   if !Empty( ::oClienteInicio ) 
      ::oClienteInicio:Valid()
   end if

   if !Empty( ::oClienteFin )
      ::oClienteFin:Valid()
   end if

   if !Empty( ::oGrupoClienteInicio )
      ::oGrupoClienteInicio:Valid()
   end if   

   if !Empty( ::oGrupoClienteFin )
      ::oGrupoClienteFin:Valid()
   end if

   //Si usamos proveedores---------------------------------------------------

   if !Empty( ::oProveedorInicio ) 
      ::oProveedorInicio:Valid()
   end if

   if !Empty( ::oProveedorFin )
      ::oProveedorFin:Valid()
   end if

   if !Empty( ::oGrupoProveedorInicio )
      ::oGrupoProveedorInicio:Valid()
   end if   

   if !Empty( ::oGrupoProveedorFin )
      ::oGrupoProveedorFin:Valid()
   end if

   ::oFormatoDocumento:Valid()

   if !Empty( ::bStart )
      Eval( ::bStart )
   end if   

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

METHOD DisableRange() CLASS PrintSeries

   ::oSerieInicio:Disable()
   ::oSerieFin:Disable()

   ::oDocumentoInicio:Disable()
   ::oDocumentoFin:Disable()

   ::oSufijoInicio:Disable()
   ::oSufijoFin:Disable()

   ::oClienteInicio:Disable()
   ::oClienteFin:Disable()

   ::oGrupoClienteInicio:Disable()
   ::oGrupoClienteFin:Disable()

   ::oFechaInicio:Disable()
   ::oFechaFin:Disable()

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

   METHOD Disable()              INLINE ( ::oGetControl:Disable() )
   METHOD Enable()               INLINE ( ::oGetControl:Enable() )

END CLASS 

METHOD New( idGet, oContainer ) CLASS ComponentGet

   ::idGet  := idGet

   ::Super:New( oContainer )

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
   DATA idText

   DATA oSayControl        
   DATA cSayValue                INIT ""

   DATA oTextControl
   DATA cTextValue

   METHOD New( idGet, idSay, idText, oContainer )

   METHOD Resource()

   METHOD SetText( cText )       INLINE ( if( !empty( ::oTextControl ), ::oTextControl:SetText( cText ), ::cTextValue := cText ) )

END CLASS 

METHOD New( idGet, idSay, idText, oContainer ) CLASS ComponentGetSay

   ::idSay  := idSay
   ::idText := idText

   ::Super:New( idGet, oContainer )

RETURN ( Self )

METHOD Resource() CLASS ComponentGetSay

   ::Super:Resource()

   REDEFINE GET   ::oSayControl ;
      VAR         ::cSayValue ;
      ID          ::idSay ;
      WHEN        ( .f. ) ;
      OF          ::oContainer:oDlg

   if !Empty( ::idText )

   REDEFINE SAY   ::oTextControl ;
      PROMPT      ::cTextValue ;
      ID          ::idText ;
      OF          ::oContainer:oDlg

   end if 

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetCliente FROM ComponentGetSay

   METHOD New( idGet, idSay, idText, oContainer ) 

   METHOD First()    INLINE ( ::cText( Space( RetNumCodCliEmp() ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", RetNumCodCliEmp() ) ) )

   METHOD Top()      INLINE ( ::cText( TDataView():Top( "Client", ::oContainer:nView ) ) )
   METHOD Bottom()   INLINE ( ::cText( TDataView():Bottom( "Client", ::oContainer:nView ) ) )

END CLASS 

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetCliente

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cClient( ::oGetControl, TDataView():Clientes( ::oContainer:nView ), ::oSayControl ) }
   ::bHelp        := {|| BrwClient( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetGrupoCliente FROM ComponentGetSay

   METHOD New( idGet, idSay, idText, oContainer )

   METHOD First()    INLINE ( ::cText( Space( 4 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 4 ) ) )

   METHOD Top()      INLINE ( ::cText( TDataView():GetObject( "GruposClientes", ::oContainer:nView ):Top() ) )
   METHOD Bottom()   INLINE ( ::cText( TDataView():GetObject( "GruposClientes", ::oContainer:nView ):Bottom() ) )

END CLASS 

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetGrupoCliente

   ::Super:New( idGet, idSay, idText, oContainer )

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

   METHOD New( idGet, idSay, idBtn, oContainer )

   METHOD Resource()

   METHOD TypeDocumento( cType )    INLINE ( if( !empty( cType ), ::cTypeDocumento := cType, ::cTypeDocumento ) )

END CLASS 

METHOD New( idGet, idSay, idBtn, oContainer ) CLASS GetDocumento

   ::Super:New( idGet, idSay, nil, oContainer )

   ::idBtn        := idBtn

   ::uGetValue    := Space( 3 )

   ::bValid       := {|| cDocumento( ::oGetControl, ::oSayControl, TDataView():Documentos( ::oContainer:nView ) ) }
   ::bHelp        := {|| brwDocumento( ::oGetControl, ::oSayControl, ::TypeDocumento() ) }

Return ( Self )

METHOD Resource() CLASS GetDocumento

   ::Super:Resource()

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

   ::Super:New( idGet, oContainer )

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

   ::Super:New( idGet, oContainer )

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

   ::Super:New( idGet, oContainer )

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

   ::Super:New( idGet, oContainer )

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

   ::Super:New( idGet, oContainer )

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

   ::Super:New( idGet, oContainer )

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

   ::Super:New( idGet, oContainer )

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

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetProveedor FROM ComponentGetSay

   METHOD New( idGet, idSay, idText, oContainer ) 

   METHOD First()    INLINE ( ::cText( Space( RetNumCodPrvEmp() ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", RetNumCodPrvEmp() ) ) )

   METHOD Top()      INLINE ( ::cText( TDataView():Top( "Provee", ::oContainer:nView ) ) )
   METHOD Bottom()   INLINE ( ::cText( TDataView():Bottom( "Provee", ::oContainer:nView ) ) )

END CLASS 

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetProveedor

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cProvee( ::oGetControl, TDataView():Proveedores( ::oContainer:nView ), ::oSayControl ) }
   ::bHelp        := {|| BrwProvee( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetGrupoProveedor FROM ComponentGetSay

   METHOD New( idGet, idSay, idText, oContainer )

   METHOD First()    INLINE ( ::cText( Space( 4 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 4 ) ) )

   METHOD Top()      INLINE ( ::cText( TDataView():GetObject( "GruposProveedores", ::oContainer:nView ):Top() ) )
   METHOD Bottom()   INLINE ( ::cText( TDataView():GetObject( "GruposProveedores", ::oContainer:nView ):Bottom() ) )

END CLASS 

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetGrupoProveedor

   ::Super:New( idGet, idSay, idText, oContainer )

   ::uGetValue    := Space( 4 )

   ::bValid       := {|| TDataView():GruposProveedores( ::oContainer:nView ):Existe( ::oGetControl, ::oSayControl, "cNomGrp", .t., .t., "0" ) }
   ::bHelp        := {|| TDataView():GruposProveedores( ::oContainer:nView ):Buscar( ::oGetControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetRichEdit 

   DATA oDlg

   DATA oClp

   DATA oRTF
   DATA cRTF              INIT ""

   DATA oBtnPrint
   DATA oBtnPreview
   DATA oBtnSearch
   DATA oBtnCut
   DATA oBtnCopy
   DATA oBtnPaste
   DATA oBtnUndo
   DATA oBtnRedo
   DATA oBtnBold
   DATA oBtnItalics
   DATA oBtnTextAlignLeft
   DATA oBtnTextAlignCenter
   DATA oBtnTextAlignRight
   DATA oBtnTextJustify
   DATA oBtnBullet
   DATA oBtnUnderLine
   DATA oBtnDateTime
   
   DATA oZoom
   DATA cZoom              INIT "100%"
   DATA aZoom              INIT { "500%", "200%", "150%", "100%", "75%", "50%", "25%", "10%" }
   
   DATA oFuente
   DATA cFuente            INIT "Courier New"
   DATA aFuente            INIT aGetFont( oWnd() )
   
   DATA oSize
   DATA cSize              INIT "12"
   DATA aSize              INIT { " 6", " 7", " 8", " 9", "10", "11", "12", "13", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   
   DATA aRatio             INIT { { 5, 1 }, { 2, 1 }, { 3, 2 }, { 1, 1 }, { 3, 4 }, { 1, 2 }, { 1, 4 }, { 1, 10 } }

   DATA lItalic            INIT .f.
   DATA lUnderline         INIT .f.
   DATA lBullet            INIT .f.
   DATA lBold              INIT .f.

   METHOD Redefine( id, oDlg )

   METHOD RTFRefreshButtons()

   METHOD SetText( cText ) INLINE ( ::oRTF:SetText( cText ) )
   METHOD GetText()        INLINE ( ::oRTF:GetText() )

   METHOD cText( cText )   INLINE ( ::oRTF:cText( cText ) )
   METHOD SaveAsRTF()      INLINE ( ::oRTF:SaveAsRTF() )
   METHOD SaveToFile( cFileName ); 
                           INLINE ( ::oRTF:SavetoFile( cFileName ) )

   METHOD LoadFromRTFFile( cFileName ) ;
                           INLINE ( ::oRTF:LoadFromRTFFile( cFileName ) )                           

   METHOD Paste()          INLINE ( ::oRTF:Paste() )
   METHOD Blod()           INLINE ( ::oClp:Clear(), ::oClp:SetText( "<b></b>" ), ::oRTF:Paste() )

   METHOD SetHTML()        INLINE ( ::oBtnBold:Hide() ,;
      								::oBtnItalics:Hide() ,;
      								::oBtnUnderLine:Hide() ,;
      								::oBtnTextAlignLeft:Hide() ,;
      								::oBtnTextAlignCenter :Hide() ,;
      								::oBtnTextAlignRight:Hide() ,;
      								::oBtnTextJustify:Hide() ,;
      								::oBtnBullet:Hide() ,;
      								::oBtnDateTime:Hide() )

   METHOD SetRTF()         INLINE ( ::oBtnBold:Show() ,;
      								::oBtnItalics:Show() ,;
      								::oBtnUnderLine:Show() ,;
      								::oBtnTextAlignLeft:Show() ,;
      								::oBtnTextAlignCenter :Show() ,;
      								::oBtnTextAlignRight:Show() ,;
      								::oBtnTextJustify:Show() ,;
      								::oBtnBullet:Show() ,;
      								::oBtnDateTime:Show() )
   
   END CLASS

//--------------------------------------------------------------------------//

   METHOD Redefine( id, oDlg ) CLASS GetRichEdit 

      DEFAULT id  := 600

      DEFINE CLIPBOARD ::oClp OF ::oDlg FORMAT TEXT

      REDEFINE BTNBMP ::oBtnPrint ;
         ID       ( id ) ;
         WHEN     ( .t. ) ;
         OF       ::oDlg ;
         RESOURCE "IMP16" ;
         NOBORDER ;
         TOOLTIP  "Imprimir" ;

      ::oBtnPrint:bAction 	:= {|| ::oRTF:Print(), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnPreview ;
         ID       ( id + 1 ) ;
         WHEN     ( .t. ) ;
         OF       ::oDlg ;
         RESOURCE "PREV116" ;
         NOBORDER ;
         TOOLTIP  "Previsualizar" ;

      ::oBtnPreview:bAction := {|| ::oRTF:Preview( "Class TRichEdit" ) }

      REDEFINE BTNBMP ::oBtnSearch ;
         ID       ( id + 2 ) ;
         WHEN     ( .t. ) ;
         OF       ::oDlg ;
         RESOURCE "Bus16" ;
         NOBORDER ;
         TOOLTIP  "Buscar" ;
      
      ::oBtnSearch:bAction := {|| FindRich( ::oRTF ) } 

      REDEFINE BTNBMP ::oBtnCut ;
         ID       ( id + 3 ) ;
         WHEN     ( ! Empty( ::oRTF:GetSel() ) .and. ! ::oRTF:lReadOnly ) ;
         OF       ::oDlg ;
         RESOURCE "Cut_16" ;
         NOBORDER ;
         TOOLTIP  "Cortar" ;

      ::oBtnCut:bAction 	:= {|| ::oRTF:Cut(), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnCopy ;
         ID       ( id + 4 ) ;
         WHEN     ( ! Empty( ::oRTF:GetSel() ) ) ;
         OF       ::oDlg ;
         RESOURCE "Copy16" ;
         NOBORDER ;
         TOOLTIP  "Copiar" ;

      ::oBtnCopy:bAction	:= {|| ::oRTF:Copy(), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnPaste ;
         ID       ( id + 5 ) ;
         WHEN     ( ! Empty( ::oClp:GetText() ) .and. ! ::oRTF:lReadOnly ) ;
         OF       ::oDlg ;
         RESOURCE "Paste_16" ;
         NOBORDER ;
         TOOLTIP  "Pegar" ;

      ::oBtnPaste:bAction 	:= {|| ::oRTF:Paste(), ::oRTF:SetFocus() }         

      REDEFINE BTNBMP ::oBtnUndo ;
         ID       ( id + 6 ) ;
         WHEN     ( ::oRTF:SendMsg( EM_CANUNDO ) != 0 ) ;
         OF       ::oDlg ;
         RESOURCE "Undo1_16" ;
         NOBORDER ;
         TOOLTIP  "Deshacer" ;

      ::oBtnUndo:bAction 	:= {|| ::oRTF:Undo(), ::oRTF:SetFocus() }   

      REDEFINE BTNBMP ::oBtnRedo ;
         ID       ( id + 7 ) ;
         WHEN     ( ::oRTF:SendMsg( EM_CANREDO ) != 0 ) ;
         OF       ::oDlg ;
         RESOURCE "Redo_16" ;
         NOBORDER ;
         TOOLTIP  "Rehacer" ;

      ::oBtnRedo:bAction := {|| ::oRTF:Redo(), ::oRTF:SetFocus() }

      REDEFINE COMBOBOX ::oZoom ;
         VAR      ::cZoom ;
         ITEMS    ::aZoom ;
         ID       ( id + 8 ) ;
         OF       ::oDlg

      ::oZoom:bChange      := {|| ::oRTF:SetZoom( ::aRatio[ ::oZoom:nAt, 1 ], ::aRatio[ ::oZoom:nAt, 2 ] ), ::oRTF:SetFocus()  }
   
      REDEFINE COMBOBOX ::oFuente ;
         VAR      ::cFuente ;
         ITEMS    ::aFuente ;
         ID       ( id + 9 ) ;
         OF       ::oDlg

      ::oFuente:bChange    := {|| ::oRTF:SetFontName( ::oFuente:VarGet() ), ::oRTF:SetFocus() }

      REDEFINE COMBOBOX ::oSize ;
         VAR      ::cSize ;
         ITEMS    ::aSize ;
         ID       ( id + 10 ) ;
         OF       ::oDlg

      ::oSize:bChange      := {|| ::oRTF:SetFontSize( Val( ::oSize:VarGet() ) ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnBold ;
         ID       ( id + 11 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       ::oDlg ;
         RESOURCE "Text_Bold" ;
         NOBORDER ;
         TOOLTIP  "Negrita" ;

      ::oBtnBold:bAction	:= {|| ( ::lBold  := !::lBold, ::oRTF:SetBold( ::lBold ), ::oRTF:SetFocus() ) }   

      REDEFINE BTNBMP ::oBtnItalics ;
         ID       ( id + 12 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       ::oDlg ;
         RESOURCE "Text_Italics_16" ;
         NOBORDER ;
         TOOLTIP  "Cursiva" ;
         
      ::oBtnItalics:bAction 	:= {|| ( ::lItalic := !::lItalic, ::oRTF:SetItalic( ::lItalic ), ::oRTF:SetFocus() ) }

      REDEFINE BTNBMP ::oBtnUnderLine;
         ID       ( id + 13 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       ::oDlg ;
         RESOURCE "Text_Underlined_16" ;
         NOBORDER ;
         TOOLTIP  "Subrayado" ;

      ::oBtnUnderLine:bAction 	:= {|| ( ::lUnderline := !::lUnderline, ::oRTF:SetUnderline( ::lUnderline ), ::oRTF:SetFocus() ) }

      REDEFINE BTNBMP ::oBtnTextAlignLeft ;
         ID       ( id + 14 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       ::oDlg ;
         RESOURCE "Text_Align_Left_16" ;
         NOBORDER ;
         TOOLTIP  "Izquierda" ;

      ::oBtnTextAlignLeft:bAction 	:= {|| ::oRTF:SetAlign( PFA_LEFT ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnTextAlignCenter  ;
         ID       ( id + 15 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       ::oDlg ;
         RESOURCE "Text_Center" ;
         NOBORDER ;
         TOOLTIP  "Centro" ;

      ::oBtnTextAlignCenter:bAction := {|| ::oRTF:SetAlign( PFA_CENTER ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnTextAlignRight ;
         ID       ( id + 16 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       ::oDlg ;
         RESOURCE "Text_Align_Right_16" ;
         NOBORDER ;
         TOOLTIP  "Derecha" ;

      ::oBtnTextAlignRight:bAction 	:= {|| ::oRTF:SetAlign( PFA_RIGHT ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnTextJustify ;
         ID       ( id + 17 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       ::oDlg ;
         RESOURCE "Text_Justified_16" ;
         NOBORDER ;
         TOOLTIP  "Justificado" ;

      ::oBtnTextJustify:bAction 	:= {|| ::oRTF:SetAlign( PFA_JUSTIFY ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnBullet ;
         ID       ( id + 18 ) ;
         WHEN     ( ! ::oRTF:lReadOnly .and. ! ::oRTF:GetNumbering() ) ;
         OF       ::oDlg ;
         RESOURCE "Pin_Blue_16" ;
         NOBORDER ;
         TOOLTIP  "Viñetas" ;

      ::oBtnBullet:bAction 			:= {|| ::lBullet := !::lBullet, ::oRTF:SetBullet( ::lBullet ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnDateTime ;
         ID       ( id + 19 ) ;
         OF       ::oDlg ;
         RESOURCE "Calendar_16" ;
         NOBORDER ;
         TOOLTIP  "Fecha/Hora" ;

      ::oBtnDateTime:bAction 		:= {|| DateTimeRich( ::oRTF ) }

      REDEFINE RICHEDIT ::oRTF ;
         VAR      ::cRTF ;
         ID       ( id + 20 ) ;
         OF       ::oDlg

      ::oRTF:lHighLight 			:= .f.
      ::oRTF:bChange    			:= { || ::RTFRefreshButtons() }

   RETURN ( Self )

//--------------------------------------------------------------------------//

   METHOD RTFRefreshButtons() CLASS GetRichEdit 

      local aChar    := REGetCharFormat( ::oRTF:hWnd )
   
      ::lBold        := aChar[ 5 ] == FW_BOLD
      ::lItalic      := aChar[ 6 ]
      ::lUnderline   := aChar[ 7 ]
      ::lBullet      := REGetBullet( ::oRTF:hWnd )
   
      if ::oBtnCut:lWhen()
         ::oBtnCut:Enable()
      else
         ::oBtnCut:Disable()
      end if
   
      ::oBtnCut:Refresh()
   
      if ::oBtnCopy:lWhen()
         ::oBtnCopy:Enable()
      else
         ::oBtnCopy:Disable()
      end if
   
      ::oBtnCopy:Refresh()
   
   RETURN ( nil )

//---------------------------------------------------------------------------//




