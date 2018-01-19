#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "RichEdit.ch" 
#include "FastRepH.ch" 

#define FW_BOLD                        700

#define NUMERO_TARIFAS                 6

//---------------------------------------------------------------------------//


CLASS DialogBuilder

   DATA aComponents                    INIT {}

   DATA nView

   DATA oDlg

   METHOD End()                        INLINE ( ::oDlg:end() )

   METHOD addComponent( oComponent )   INLINE ( aAdd( ::aComponents, oComponent ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS ResourceBuilder FROM DialogBuilder

   DATA bInit 
   DATA bWhile                         INIT {|| .t. }
   DATA bFor                           INIT {|| .t. }
   DATA bAction   
   DATA bSkip                          INIT {|| .t. }
   DATA bExit
   DATA bStart 

   DATA nTotalPrinted                  INIT 0

   DATA oSerieInicio       
   DATA oSerieFin           

   DATA oDocumentoInicio
   DATA oDocumentoFin   

   DATA oSufijoInicio                  
   DATA oSufijoFin                     

   DATA oClienteInicio
   DATA oClienteFin

   DATA oAgenteInicio
   DATA oAgenteFin
   
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

   METHOD InRangeAgente( uValue )         INLINE ( empty( uValue ) .or. ( uValue >= ::oAgenteInicio:Value() .and. uValue <= ::oAgenteFin:Value() ) )
  
   METHOD InRangeProveedor( uValue )      INLINE ( empty( uValue ) .or. ( uValue >= ::oProveedorInicio:Value() .and. uValue <= ::oProveedorFin:Value() ) )
   METHOD InRangeGrupoProveedor( uValue ) INLINE ( empty( uValue ) .or. ( uValue >= ::oGrupoProveedorInicio:Value() .and. uValue <= ::oGrupoProveedorFin:Value() ) )

   METHOD InRangeFecha( uValue )          INLINE ( empty( uValue ) .or. ( uValue >= ::oFechaInicio:Value() .and. uValue <= ::oFechaFin:Value() ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS PrintSeries FROM ResourceBuilder

   DATA lShowAgentes                      INIT .t.

   METHOD New( nView )

   METHOD SetCompras()
   METHOD SetVentas()

   METHOD setPrinter( cPrinter )          INLINE ( if( !empty( ::oImpresora ), ::oImpresora:set( cPrinter ), ) )

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

   ::oAgenteInicio         := GetAgente():New( 400, 410, 401, Self )
   ::oAgenteFin            := GetAgente():New( 420, 430, 421, Self )
   
   ::lShowAgentes          := .f.

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

   // Agentes-----------------------------------------------------------------

   ::oAgenteInicio        := GetAgente():New( 400, 410, 401, Self )
   ::oAgenteInicio:SetText( "Desde agente" )
   ::oAgenteInicio:First()

   ::oAgenteFin           := GetAgente():New( 420, 430, 421, Self )
   ::oAgenteFin:SetText( "Hasta agente" )
   ::oAgenteFin:Last()

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
      RESOURCE    "gc_printer2_48" ;
      TRANSPARENT ;
      OF          ::oDlg

   aEval( ::aComponents, {| o | o:Resource(::oDlg) } )

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
   
RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD StartResource() CLASS PrintSeries

   //Si usamos clientes----------------------------------------------------

   if !empty( ::oClienteInicio ) 
      ::oClienteInicio:Valid()
   end if

   if !empty( ::oClienteFin )
      ::oClienteFin:Valid()
   end if

   if !empty( ::oAgenteInicio ) 
      if ::lShowAgentes
         ::oAgenteInicio:Valid()
      else
         ::oAgenteInicio:Hide()
      end if
   end if

   if !empty( ::oAgenteFin )
      if ::lShowAgentes
         ::oAgenteFin:Valid()
      else
         ::oAgenteFin:Hide()
      end if
   end if

   if !empty( ::oGrupoClienteInicio )
      ::oGrupoClienteInicio:Valid()
   end if   

   if !empty( ::oGrupoClienteFin )
      ::oGrupoClienteFin:Valid()
   end if

   //Si usamos proveedores---------------------------------------------------

   if !empty( ::oProveedorInicio ) 
      ::oProveedorInicio:Valid()
   end if

   if !empty( ::oProveedorFin )
      ::oProveedorFin:Valid()
   end if

   if !empty( ::oGrupoProveedorInicio )
      ::oGrupoProveedorInicio:Valid()
   end if   

   if !empty( ::oGrupoProveedorFin )
      ::oGrupoProveedorFin:Valid()
   end if

   ::oFormatoDocumento:Valid()

   if !empty( ::bStart )
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

   DATA oProceso

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

   ::oProceso              := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS ImportarProductosProveedor

   DEFINE DIALOG ::oDlg RESOURCE "ImportarProductosProveedor"

   aEval( ::aComponents, {| o | o:Resource(::oDlg) } )

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
   
   if !empty( oContainer )
      ::oContainer   := oContainer
      ::oContainer:AddComponent( Self )
   end if 

Return ( Self )
   
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS ComponentGet FROM Component

   DATA idGet
   DATA idSay

   DATA bValid                   INIT {|| .t. }
   DATA bHelp                    INIT {|| .t. }
   DATA bWhen                    INIT {|| .t. }

   DATA oGetControl
   DATA uGetValue                INIT Space( 12 )
   
   METHOD New( idGet, oContainer )

   METHOD Resource( oDlg )

   METHOD cText( uGetValue )     INLINE ( if( !empty( ::oGetControl ), ::oGetControl:cText( uGetValue ), ), ::uGetValue := uGetValue )
   METHOD varGet()               INLINE ( ::oGetControl:varGet() )
   METHOD Value()                INLINE ( ::uGetValue )

   METHOD Valid()                INLINE ( if( !empty( ::oGetControl ), ::oGetControl:lValid(), .t. ) )

   METHOD Disable()              INLINE ( ::oGetControl:Disable() )
   METHOD Enable()               INLINE ( ::oGetControl:Enable() )

END CLASS 

METHOD New( idGet, oContainer ) CLASS ComponentGet

   ::idGet  := idGet

   ::Super:New( oContainer )

RETURN ( Self )

METHOD Resource( oDlg ) CLASS ComponentGet

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      BITMAP      "LUPA" ;
      OF          oDlg

   ::oGetControl:bValid    := ::bValid
   ::oGetControl:bHelp     := ::bHelp
   ::oGetControl:bWhen     := ::bWhen

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS ComponentSay FROM Component

   DATA idSay

   DATA oSayControl
   DATA uSayValue                INIT Space( 12 )
   
   METHOD New( idSay, oContainer )

   METHOD Resource( oDlg )

   METHOD cText( uSayValue )     INLINE ( if( !empty( ::oSayControl ), ::oSayControl:SetText( uSayValue ), ::uSayValue := uSayValue ) )
   METHOD Value()                INLINE ( ::uSayValue )

   METHOD Disable()              INLINE ( ::oSayControl:Disable() )
   METHOD Enable()               INLINE ( ::oSayControl:Enable() )

END CLASS 

METHOD New( idSay, oContainer ) CLASS ComponentSay

   ::idSay        := idSay

   ::Super:New( oContainer )

RETURN ( Self )

METHOD Resource( oDlg ) CLASS ComponentSay

   REDEFINE SAY   ::oSayControl ;
      PROMPT      ::uSayValue ;
      ID          ::idSay ;
      OF          oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS ComponentCheck FROM Component

   DATA idCheck

   DATA oCheckControl
   DATA uCheckValue

   DATA bWhen                    INIT {|| .t. }
   
   METHOD New( idCheck, lDefault, oContainer )

   METHOD Resource( oDlg )

   METHOD Value()                INLINE ( ::uCheckValue )

   METHOD Disable()              INLINE ( ::oCheckControl:Disable() )
   METHOD Enable()               INLINE ( ::oCheckControl:Enable() )

END CLASS 

METHOD New( idCheck, lDefault, oContainer ) CLASS ComponentCheck

   DEFAULT lDefault  := .t.

   ::idCheck         := idCheck

   ::uCheckValue     := lDefault

   ::Super:New( oContainer )

RETURN ( Self )

METHOD Resource( oDlg ) CLASS ComponentCheck

   REDEFINE CHECKBOX ::oCheckControl ;
      VAR            ::uCheckValue ;
      ID             ::idCheck ;
      OF             oDlg

   ::oCheckControl:bWhen     := ::bWhen

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ComponentUrlLink FROM Component

   DATA idUrlLink
   DATA bAction
   DATA cCaption

   DATA oUrlLinkControl
   
   METHOD New( idCheck, oContainer )

   METHOD Resource( oDlg )

   METHOD Disable()              INLINE ( ::oUrlLinkControl:Disable() )
   METHOD Enable()               INLINE ( ::oUrlLinkControl:Enable() )

END CLASS 

METHOD New( idUrlLink, bAction, cCaption, oContainer ) CLASS ComponentUrlLink

   ::idUrlLink    := idUrlLink
   ::bAction      := bAction
   ::cCaption     := cCaption

   ::Super:New( oContainer )

RETURN ( Self )

METHOD Resource( oDlg ) CLASS ComponentUrlLink

   ::oUrlLinkControl          := TURLLink():ReDefine( ::idUrlLink, oDlg, , ::cCaption, ::cCaption ) 
   ::oUrlLinkControl:bAction  := ::bAction

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SayCompras FROM ComponentSay

   METHOD New( idSay, oContainer )

   METHOD Resource( oDlg )

END CLASS 

METHOD New( idSay, oContainer ) CLASS SayCompras

   ::Super:New( idSay, oContainer )

   ::uSayValue    := 0

RETURN ( Self )

METHOD Resource( oDlg ) CLASS SayCompras

   REDEFINE SAY   ::oSayControl ;
      PROMPT      ::uSayValue ;
      ID          ::idSay ;
      PICTURE     ( cPorDiv() ) ;
      OF          oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS ComponentGetSay FROM ComponentGet

   DATA idSay
   DATA idText

   DATA oSayControl        
   DATA cSayValue                INIT ""

   DATA oTextControl
   DATA cTextValue               

   METHOD New( idGet, idSay, idText, oContainer )

   METHOD Resource(oDlg)

   METHOD Show()                 INLINE ( if( !empty( ::oGetControl ), ::oGetControl:Show(), ),;
                                          if( !empty( ::oSayControl ), ::oSayControl:Show(), ),;
                                          if( !empty( ::oTextControl ), ::oTextControl:Show(), ) )
   METHOD Hide()                 INLINE ( if( !empty( ::oGetControl ), ::oGetControl:Hide(), ),;
                                          if( !empty( ::oSayControl ), ::oSayControl:Hide(), ),;
                                          if( !empty( ::oTextControl ), ::oTextControl:Hide(), ) )

   METHOD SetText( cText )       INLINE ( if( !empty( ::oTextControl ), ::oTextControl:SetText( cText ), ::cTextValue := cText ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS ComponentGetSay

   ::idSay        := idSay
   ::idText       := idText

   ::Super:New( idGet, oContainer )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Resource( oDlg ) CLASS ComponentGetSay

   ::Super:Resource( oDlg )

   REDEFINE GET   ::oSayControl ;
      VAR         ::cSayValue ;
      ID          ::idSay ;
      WHEN        ( .f. ) ;
      OF          oDlg

   if !empty( ::idText )

   REDEFINE SAY   ::oTextControl ;
      PROMPT      ::cTextValue ;
      ID          ::idText ;
      OF          oDlg

   end if 

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetCombo FROM Component

   DATA oControl

   DATA idCombo

   DATA uValue                   INIT "Combo" 
   DATA aValues                  INIT {"Combo"}
   
   DATA bChange

   METHOD Build( hBuilder )
   METHOD New( idGet, uValue, aValues, oContainer )

   METHOD Resource(oDlg)

   METHOD Value()                INLINE ( eval( ::oControl:bSetGet ) )

   METHOD Disable()              INLINE ( ::oControl:Disable() )
   METHOD Enable()               INLINE ( ::oControl:Enable() )

   METHOD SetChange( bChange )   INLINE ( if( isBlock( bChange ), ::bChange := bChange, ) )
   METHOD Change()               INLINE ( if( isBlock( ::bChange ), eval( ::bChange ), ) )

   METHOD setWhen( bWhen )       INLINE ( if( isBlock( bWhen ), ::oControl:bWhen := bWhen, ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetCombo

   local idCombo     := if( hhaskey( hBuilder, "idCombo" ),    hBuilder[ "idCombo"   ], nil )
   local uValue      := if( hhaskey( hBuilder, "uValue"),      hBuilder[ "uValue"    ], nil )
   local aValues     := if( hhaskey( hBuilder, "aValues"),     hBuilder[ "aValues"   ], nil )
   local oContainer  := if( hhaskey( hBuilder, "oContainer"),  hBuilder[ "oContainer"], nil )

   ::New( idCombo, uValue, aValues, oContainer )

Return ( Self )

METHOD New( idCombo, uValue, aValues, oContainer ) CLASS GetCombo

   ::idCombo      := idCombo
   ::uValue       := uValue

   if !empty( aValues )
      ::aValues   := aValues
   end if 

   ::Super:New( oContainer )

RETURN ( Self )

METHOD Resource( oDlg ) CLASS GetCombo

   REDEFINE COMBOBOX ::oControl ;
      VAR      ::uValue ;
      ID       ::idCombo ;
      ITEMS    ::aValues ;
      OF       oDlg

   ::oControl:bChange      := {|| ::Change() }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS comboTarifa FROM GetCombo

   DATA idCombo
   DATA uValue                   INIT "Combo" 
   DATA aValues                  INIT {"Combo"}
   DATA oControl

   METHOD Build( hBuilder ) 

   METHOD getTarifa()                  
   METHOD setTarifa( nTarifa )         INLINE   ( ::oControl:set( ::getTarifaNombre( nTarifa ) ) )
   METHOD getTarifaNombre( nTarifa )  

   METHOD varGet()                     INLINE   ( ::oControl:varGet() )

END CLASS 

//--------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS comboTarifa

   local idCombo     := if( hhaskey( hBuilder, "idCombo" ),    hBuilder[ "idCombo"   ], nil )
   local uValue      := if( hhaskey( hBuilder, "uValue"),      hBuilder[ "uValue"    ], nil )
   local oContainer  := if( hhaskey( hBuilder, "oContainer"),  hBuilder[ "oContainer"], nil )

   ::aValues         := aNombreTarifas()

   uValue            := ::getTarifaNombre( uValue )

   ::New( idCombo, uValue )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD getTarifa()

   local n

   for n := 1 to NUMERO_TARIFAS

      if uFieldEmpresa( "lShwTar" + alltrim( str( n ) ) )
         if !empty( alltrim( uFieldEmpresa( "cTxtTar" + alltrim( str( n ) ) ) ))
            if alltrim( uFieldEmpresa( "cTxtTar" + alltrim( str( n ) ) ) ) == ::VarGet()
               Return ( n )
            end if 
         else
            if ( 'Precio ' + alltrim( str( n ) ) ) == ::VarGet()
               Return( n )
            end if 
         end if

      endif
   next

Return ( 1 )

//--------------------------------------------------------------------------//

METHOD getTarifaNombre( nTarifa )

   local cTarifaNombre  := ""

   if aScan( ::aValues, uFieldEmpresa( "cTxtTar" + alltrim( str( nTarifa ) ) ) ) != 0
      cTarifaNombre     := uFieldEmpresa( "cTxtTar" + alltrim( str( nTarifa ) ) )
   end if 

   /*----Tarifa por defecto

   else
      cTarifaNombre     := ::aValues[1]

   */

Return ( cTarifaNombre )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS ComponentGetSayDatabase FROM ComponentGetSay

   DATA nView

   METHOD getView()        INLINE ( if( empty( ::nView ), ::oContainer:nView, ::nView ) )
   METHOD setView( nView ) INLINE ( ::nView := nView )

END CLASS 

//--------------------------------------------------------------------------//

CLASS GetCliente FROM ComponentGetSayDatabase

   METHOD New( idGet, idSay, idText, oContainer ) 
   METHOD Build( hBuilder )

   METHOD First()          INLINE ( ::cText( Space( RetNumCodCliEmp() ) ) )
   METHOD Last()           INLINE ( ::cText( Replicate( "Z", RetNumCodCliEmp() ) ) )

   METHOD Top()            INLINE ( ::cText( D():Top( "Client", ::oContainer:nView ) ) )
   METHOD Bottom()         INLINE ( ::cText( D():Bottom( "Client", ::oContainer:nView ) ) )

END CLASS 

METHOD Build( hBuilder ) CLASS GetCliente 

   local idGet          := if( hhaskey( hBuilder, "idGet" ),      hBuilder[ "idGet"  ], nil )
   local idSay          := if( hhaskey( hBuilder, "idSay" ),      hBuilder[ "idSay"  ], nil )
   local idText         := if( hhaskey( hBuilder, "idText" ),     hBuilder[ "idText" ], nil )
   local oContainer     := if( hhaskey( hBuilder, "oContainer" ), hBuilder[ "oContainer" ], nil )

   ::New( idGet, idSay, idText, oContainer )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetCliente

   ::cTextValue   := "Cliente"

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cClient( ::oGetControl, D():Clientes( ::getView() ), ::oSayControl ) }
   ::bHelp        := {|| BrwClient( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//

CLASS GetAgente FROM ComponentGetSayDatabase

   METHOD New( idGet, idSay, idText, oContainer ) 
   METHOD Build( hBuilder )

   METHOD First()          INLINE ( ::cText( space( 3 ) ) )
   METHOD Last()           INLINE ( ::cText( replicate( "Z", 3 ) ) )

   METHOD Top()            INLINE ( ::cText( D():Top( "Agentes", ::oContainer:nView ) ) )
   METHOD Bottom()         INLINE ( ::cText( D():Bottom( "Agentes", ::oContainer:nView ) ) )

END CLASS 

METHOD Build( hBuilder ) CLASS GetAgente

   local idGet          := if( hhaskey( hBuilder, "idGet" ),      hBuilder[ "idGet"  ], nil )
   local idSay          := if( hhaskey( hBuilder, "idSay" ),      hBuilder[ "idSay"  ], nil )
   local idText         := if( hhaskey( hBuilder, "idText" ),     hBuilder[ "idText" ], nil )
   local oContainer     := if( hhaskey( hBuilder, "oContainer" ), hBuilder[ "oContainer" ], nil )

   ::New( idGet, idSay, idText, oContainer )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetAgente

   ::cTextValue   := "Agentes"

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cAgentes( ::oGetControl, D():Agentes( ::getView() ), ::oSayControl ) }
   ::bHelp        := {|| BrwAgentes( ::oGetControl, ::oSayControl ) }
   
Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetGrupoCliente FROM ComponentGetSay

   METHOD New( idGet, idSay, idText, oContainer )

   METHOD First()    INLINE ( ::cText( Space( 4 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 4 ) ) )

   METHOD Top()      INLINE ( ::cText( D():GetObject( "GruposClientes", ::oContainer:nView ):Top() ) )
   METHOD Bottom()   INLINE ( ::cText( D():GetObject( "GruposClientes", ::oContainer:nView ):Bottom() ) )

END CLASS 

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetGrupoCliente

   ::Super:New( idGet, idSay, idText, oContainer )

   ::uGetValue    := Space( 4 )

   ::bValid       := {|| D():objectGruposClientes( ::oContainer:nView ):Existe( ::oGetControl, ::oSayControl, "cNomGrp", .t., .t., "0" ) }
   ::bHelp        := {|| D():objectGruposClientes( ::oContainer:nView ):Buscar( ::oGetControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetDocumento FROM ComponentGetSay

   DATA idBtn
   DATA cTypeDocumento              INIT Space( 2 )

   METHOD New( idGet, idSay, idBtn, oContainer )

   METHOD Resource(oDlg)

   METHOD TypeDocumento( cType )    INLINE ( if( !empty( cType ), ::cTypeDocumento := cType, ::cTypeDocumento ) )

END CLASS 

METHOD New( idGet, idSay, idBtn, oContainer ) CLASS GetDocumento

   ::Super:New( idGet, idSay, nil, oContainer )

   ::idBtn        := idBtn

   ::uGetValue    := Space( 3 )

   ::bValid       := {|| cDocumento( ::oGetControl, ::oSayControl, D():Documentos( ::oContainer:nView ) ) }
   ::bHelp        := {|| brwDocumento( ::oGetControl, ::oSayControl, ::TypeDocumento() ) }

Return ( Self )

METHOD Resource(oDlg) CLASS GetDocumento

   ::Super:Resource(oDlg)

   TBtnBmp():ReDefine( ::idBtn, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( ::uGetValue ) }, oDlg, .f., , .f.,  )

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetPrinter FROM ComponentGet

   DATA idBtn

   DATA cTypeDocumento              INIT Space( 2 )

   METHOD New( idGet, oContainer )

   METHOD Resource(oDlg)

   METHOD TypeDocumento( cType )    INLINE ( if( !empty( cType ), ::cTypeDocumento := cType, ::cTypeDocumento ) )

   METHOD set( cPrinter )

END CLASS 

//--------------------------------------------------------------------------//

METHOD New( idGet, idBtn, oContainer ) CLASS GetPrinter

   ::Super:New( idGet, oContainer )

   ::idBtn        := idBtn

   ::uGetValue    := prnGetName()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD Resource( oDlg ) CLASS GetPrinter

   REDEFINE COMBOBOX ::oGetControl ;
      VAR      ::uGetValue ;
      ID       ::idGet ;
      ITEMS    aGetPrinters() ;
      OF       oDlg

Return ( Self )

//--------------------------------------------------------------------------//

METHOD set( cPrinter ) 

   if !empty( ::oGetControl )
      ::oGetControl:set( cPrinter )
   end if 

   ::uGetValue    := cPrinter

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetSerie FROM ComponentGet

   METHOD New( idGet, oContainer )

   METHOD Resource( oDlg )

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetSerie

   ::Super:New( idGet, oContainer )

   ::uGetValue    := "A"

Return ( Self )

METHOD Resource( oDlg ) CLASS GetSerie

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP       ( UpSerie( ::oGetControl ) );
      ON DOWN     ( DwSerie( ::oGetControl ) );
      OF          oDlg

   ::oGetControl:bValid    := {|| if( ::oGetControl:varGet() >= "A" .and. ::oGetControl:varGet() <= "Z", .t., ( msgStop( "La serie no es valida" ), .f. ) ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetNumero FROM ComponentGet

   METHOD New( idGet, oContainer )

   METHOD Resource(oDlg)

   METHOD SetPicture()

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetNumero

   ::Super:New( idGet, oContainer )

   ::uGetValue    := 1
   
   ::bValid       := {|| ::uGetValue >= 1 .and. ::uGetValue <= 999999999 }

Return ( Self )

METHOD Resource(oDlg) CLASS GetNumero

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "999999999" ;
      SPINNER ;
      VALID       ::bValid ;
      OF          oDlg

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

   METHOD Resource(oDlg)

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetSufijo

   ::Super:New( idGet, oContainer )

   ::uGetValue    := RetSufEmp()

Return ( Self )

METHOD Resource(oDlg) CLASS GetSufijo

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "@!" ;
      OF          oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetFecha FROM ComponentGet

   METHOD New( idGet, oContainer )

   METHOD Resource()

   METHOD FirstDayLastYear()     INLINE ( ::cText( ctod( "01/01/" + str( year( GetSysDate() ) - 1 ) ) ) )

   METHOD FirstDayYear()         INLINE ( ::cText( BoY( date() ) ) )
   METHOD LastDayYear()          INLINE ( ::cText( EoY( date() ) ) )

   METHOD FirstDayMonth()        INLINE ( ::cText( BoM( date() ) ) )
   METHOD LastDayMonth()         INLINE ( ::cText( EoM( date() ) ) )

   METHOD FirstDayPreviusMonth() INLINE ( ::cText( BoM( AddMonth( date(), -1 ) ) ) )
   METHOD LastDayPreviusMonth()  INLINE ( ::cText( EoM( AddMonth( date(), -1 ) ) ) ) 

END CLASS 

METHOD New( idGet, oContainer ) CLASS GetFecha

   ::Super:New( idGet, oContainer )

   ::uGetValue    := Date()
   
Return ( Self )

METHOD Resource(oDlg) CLASS GetFecha

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      SPINNER ;
      OF          oDlg

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetPeriodo FROM ComponentGet

   DATA oComboPeriodo

   DATA oFechaInicio
   DATA oFechaFin

   DATA cPeriodo                 INIT "Año anterior y en curso" 
   DATA aPeriodo                 INIT {}

   METHOD Build( hBuilder )
   METHOD New( idCombo, idFechaInicio, idFechaFin, oContainer )

   METHOD CambiaPeriodo()
   METHOD CargaPeriodo()

   METHOD Resource( oContainer )

   METHOD getFechaInicio()       INLINE ( ::oFechaInicio:Value() )
   METHOD getFechaFin()          INLINE ( ::oFechaFin:Value() )
   METHOD inRange( uValue )      INLINE ( uValue >= ::getFechaInicio() .and. uValue <= ::getFechaFin() )

END CLASS 

METHOD Build( hBuilder ) CLASS GetPeriodo 

   local idCombo        := if( hhaskey( hBuilder, "idCombo" ),       hBuilder[ "idCombo"        ], nil )
   local idFechaInicio  := if( hhaskey( hBuilder, "idFechaInicio"),  hBuilder[ "idFechaInicio"  ], nil )
   local idFechaFin     := if( hhaskey( hBuilder, "idFechaFin"),     hBuilder[ "idFechaFin"     ], nil )
   local oContainer     := if( hhaskey( hBuilder, "oContainer"),     hBuilder[ "oContainer"     ], nil )

   ::New( idCombo, idFechaInicio, idFechaFin, oContainer )

Return ( Self )

METHOD New( idCombo, idFechaInicio, idFechaFin, oContainer ) CLASS GetPeriodo

   ::CargaPeriodo()

   ::oComboPeriodo            := GetCombo():New( idCombo, ::cPeriodo, ::aPeriodo, oContainer )
   ::oComboPeriodo:SetChange( {|| ::CambiaPeriodo() } )

   ::oFechaInicio             := GetFecha():New( idFechaInicio, oContainer )
   ::oFechaInicio:FirstDayLastYear()

   ::oFechaFin                := GetFecha():New( idFechaFin, oContainer )

Return ( Self )

METHOD Resource( oContainer ) CLASS GetPeriodo

   ::oComboPeriodo:Resource( oContainer )
   ::oFechaInicio:Resource( oContainer )
   ::oFechaFin:Resource( oContainer )

Return ( Self )

METHOD CargaPeriodo() CLASS GetPeriodo 

   ::aPeriodo                 := {}

   aAdd( ::aPeriodo, "Hoy" )
   aAdd( ::aPeriodo, "Ayer" )
   aAdd( ::aPeriodo, "Mes en curso" )
   aAdd( ::aPeriodo, "Mes anterior" )
   aAdd( ::aPeriodo, "Primer trimestre" )
   aAdd( ::aPeriodo, "Segundo trimestre" )
   aAdd( ::aPeriodo, "Tercer trimestre" )
   aAdd( ::aPeriodo, "Cuatro trimestre" )
   aAdd( ::aPeriodo, "Doce últimos meses" )
   aAdd( ::aPeriodo, "Año anterior y en curso" )
   aAdd( ::aPeriodo, "Año en curso" )
   aAdd( ::aPeriodo, "Año anterior" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CambiaPeriodo() CLASS GetPeriodo 

   local cPeriodo    := ::oComboPeriodo:Value()

   do case
      case cPeriodo == "Hoy"

         ::oFechaInicio:cText( GetSysDate() )
         ::oFechaFin:cText( GetSysDate() )

      case cPeriodo == "Ayer"

         ::oFechaInicio:cText( GetSysDate() -1 )
         ::oFechaFin:cText( GetSysDate() -1 )

      case cPeriodo == "Mes en curso"

         ::oFechaInicio:cText( CtoD( "01/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( GetSysDate() )

      case cPeriodo == "Mes anterior"

         ::oFechaInicio:cText( BoM( addMonth( GetSysDate(), - 1 ) ) )
         ::oFechaFin:cText( EoM( addMonth( GetSysDate(), - 1 ) ) )

      case cPeriodo == "Primer trimestre"

         ::oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( CtoD( "31/03/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Segundo trimestre"

         ::oFechaInicio:cText( CtoD( "01/04/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( CtoD( "30/06/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Tercer trimestre"

         ::oFechaInicio:cText( CtoD( "01/07/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( CtoD( "30/09/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Cuatro trimestre"

         ::oFechaInicio:cText( CtoD( "01/10/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Doce últimos meses"

         ::oFechaInicio:cText( BoY( GetSysDate() ) )
         ::oFechaFin:cText( EoY( GetSysDate() ) )

      case cPeriodo == "Año anterior y en curso" 

         ::oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) - 1 ) ) )
         ::oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )
         
      case cPeriodo == "Año en curso"

         ::oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case cPeriodo == "Año anterior"

         ::oFechaInicio:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) - 1 ) ) )
         ::oFechaFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) - 1 ) ) )

   end case

RETURN ( .t. )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetRangoCliente FROM Component

   DATA oAll
   DATA oInicio
   DATA oFin

   METHOD Build( hBuilder )
   METHOD New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer )

   METHOD Resource( oContainer )

   METHOD InRange( uValue )      INLINE ( ::oAll:Value() .or. ( uValue >= ::oInicio:Value() .and. uValue <= ::oFin:Value() ) )

END CLASS 

METHOD Build( hBuilder ) CLASS GetRangoCliente 

   local idAll          := if( hhaskey( hBuilder, "idAll" ),         hBuilder[ "idAll"        ], nil )
   local idGetInicio    := if( hhaskey( hBuilder, "idGetInicio" ),   hBuilder[ "idGetInicio"  ], nil )
   local idSayInicio    := if( hhaskey( hBuilder, "idSayInicio" ),   hBuilder[ "idSayInicio"  ], nil )
   local idTextInicio   := if( hhaskey( hBuilder, "idTextInicio" ),  hBuilder[ "idTextInicio" ], nil )
   local idGetFin       := if( hhaskey( hBuilder, "idGetFin" ),      hBuilder[ "idGetFin"     ], nil )
   local idSayFin       := if( hhaskey( hBuilder, "idSayFin" ),      hBuilder[ "idSayFin"     ], nil )
   local idTextFin      := if( hhaskey( hBuilder, "idTextFin" ),     hBuilder[ "idTextFin"    ], nil )
   local oContainer     := if( hhaskey( hBuilder, "oContainer" ),    hBuilder[ "oContainer"   ], nil )

   ::New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer )

Return ( Self )

METHOD New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer ) CLASS GetRangoCliente

   ::oAll           := ComponentCheck():New( idAll, .t., oContainer )

   ::oInicio        := GetCliente():New( idGetInicio, idSayInicio, idTextInicio, oContainer )
   ::oInicio:SetText( "Desde" )
   ::oInicio:First()
   ::oInicio:bWhen  := {|| !::oAll:Value() }

   ::oFin           := GetCliente():New( idGetFin, idSayFin, idTextFin, oContainer )
   ::oFin:SetText( "Hasta" )
   ::oFin:Last()
   ::oFin:bWhen     := {|| !::oAll:Value() }

Return ( Self )

METHOD Resource( oDialog ) CLASS GetRangoCliente

   ::oAll:Resource( oDialog )
   ::oInicio:Resource( oDialog )
   ::oFin:Resource( oDialog )

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetRangoGrupoCliente FROM Component

   DATA oAll
   DATA oInicio
   DATA oFin

   METHOD Build( hBuilder )
   METHOD New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer )

   METHOD Resource( oContainer )

   METHOD InRange( uValue )      INLINE ( ::oAll:Value() .or. ( uValue >= ::oInicio:Value() .and. uValue <= ::oFin:Value() ) )

END CLASS 

METHOD Build( hBuilder ) CLASS GetRangoGrupoCliente 

   local idAll          := if( hhaskey( hBuilder, "idAll" ),         hBuilder[ "idAll"        ], nil )
   local idGetInicio    := if( hhaskey( hBuilder, "idGetInicio" ),   hBuilder[ "idGetInicio"  ], nil )
   local idSayInicio    := if( hhaskey( hBuilder, "idSayInicio" ),   hBuilder[ "idSayInicio"  ], nil )
   local idTextInicio   := if( hhaskey( hBuilder, "idTextInicio" ),  hBuilder[ "idTextInicio" ], nil )
   local idGetFin       := if( hhaskey( hBuilder, "idGetFin" ),      hBuilder[ "idGetFin"     ], nil )
   local idSayFin       := if( hhaskey( hBuilder, "idSayFin" ),      hBuilder[ "idSayFin"     ], nil )
   local idTextFin      := if( hhaskey( hBuilder, "idTextFin" ),     hBuilder[ "idTextFin"    ], nil )
   local oContainer     := if( hhaskey( hBuilder, "oContainer" ),    hBuilder[ "oContainer"   ], nil )

   ::New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer )

Return ( Self )

METHOD New( idAll, idGetInicio, idSayInicio, idTextInicio, idGetFin, idSayFin, idTextFin, oContainer ) CLASS GetRangoGrupoCliente

   ::oAll           := ComponentCheck():New( idAll, .t., oContainer )

   ::oInicio        := GetGrupoCliente():New( idGetInicio, idSayInicio, idTextInicio, oContainer )
   ::oInicio:SetText( "Desde" )
   ::oInicio:First()
   ::oInicio:bWhen  := {|| !::oAll:Value() }

   ::oFin           := GetGrupoCliente():New( idGetFin, idSayFin, idTextFin, oContainer )
   ::oFin:SetText( "Hasta" )
   ::oFin:Last()
   ::oFin:bWhen     := {|| !::oAll:Value() }

Return ( Self )

METHOD Resource( oDialog ) CLASS GetRangoGrupoCliente

   ::oAll:Resource( oDialog )
   ::oInicio:Resource( oDialog )
   ::oFin:Resource( oDialog )

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetRangoSeries FROM Component

   DATA oTodas
   DATA oNinguna
   DATA hObjectSerie

   METHOD Build( hBuilder )
   METHOD New( idTodas, idNinguna, idInicio, oContainer )

   METHOD Resource( oDialog )

   METHOD SelectAll()         INLINE ( if( !empty( ::hObjectSerie ), hEval( ::hObjectSerie, {| h, o, i | o:uCheckValue := .t., o:oCheckControl:Refresh() } ), ) )

   METHOD UnselectAll()       INLINE ( if( !empty( ::hObjectSerie ), hEval( ::hObjectSerie, {| h, o, i | o:uCheckValue := .f., o:oCheckControl:Refresh() } ), ) )

   METHOD InRange( uValue )

END CLASS 

METHOD Build( hBuilder ) CLASS GetRangoSeries 

   local idTodas        := if( hhaskey( hBuilder, "idTodas" ),          hBuilder[ "idTodas"        ], nil )
   local idNinguna      := if( hhaskey( hBuilder, "idNinguna" ),        hBuilder[ "idNinguna"      ], nil )
   local idInicio       := if( hhaskey( hBuilder, "idInicio" ),         hBuilder[ "idInicio"       ], nil )
   local bActionTodas   := if( hhaskey( hBuilder, "bActionTodas" ),     hBuilder[ "bActionTodas"   ], nil )
   local bActionNinguna := if( hhaskey( hBuilder, "bActionNinguna" ),   hBuilder[ "bActionNinguna" ], nil )
   local oContainer     := if( hhaskey( hBuilder, "oContainer" ),       hBuilder[ "oContainer"     ], nil )

   ::New( idTodas, idNinguna, idInicio, oContainer )

Return ( Self )

METHOD New( idTodas, idNinguna, idInicio, oContainer ) CLASS GetRangoSeries

   ::oTodas          := ComponentUrlLink():New( idTodas, {|| ::SelectAll() }, "Todas", oContainer )
   ::oNinguna        := ComponentUrlLink():New( idNinguna, {|| ::UnselectAll() }, "Ninguna", oContainer )

   ::hObjectSerie    := { "A"  =>  ComponentCheck():New( idInicio, .t., oContainer ),;
                          "B"  =>  ComponentCheck():New( idInicio + 1, .t., oContainer ),;
                          "C"  =>  ComponentCheck():New( idInicio + 2, .t., oContainer ),;
                          "D"  =>  ComponentCheck():New( idInicio + 3, .t., oContainer ),;
                          "E"  =>  ComponentCheck():New( idInicio + 4, .t., oContainer ),;
                          "F"  =>  ComponentCheck():New( idInicio + 5, .t., oContainer ),;
                          "G"  =>  ComponentCheck():New( idInicio + 6, .t., oContainer ),;
                          "H"  =>  ComponentCheck():New( idInicio + 7, .t., oContainer ),;
                          "I"  =>  ComponentCheck():New( idInicio + 8, .t., oContainer ),;
                          "J"  =>  ComponentCheck():New( idInicio + 9, .t., oContainer ),;
                          "K"  =>  ComponentCheck():New( idInicio + 10, .t., oContainer ),;
                          "L"  =>  ComponentCheck():New( idInicio + 11, .t., oContainer ),;
                          "M"  =>  ComponentCheck():New( idInicio + 12, .t., oContainer ),;
                          "N"  =>  ComponentCheck():New( idInicio + 13, .t., oContainer ),;
                          "O"  =>  ComponentCheck():New( idInicio + 14, .t., oContainer ),;
                          "P"  =>  ComponentCheck():New( idInicio + 15, .t., oContainer ),;
                          "Q"  =>  ComponentCheck():New( idInicio + 16, .t., oContainer ),;
                          "R"  =>  ComponentCheck():New( idInicio + 17, .t., oContainer ),; 
                          "S"  =>  ComponentCheck():New( idInicio + 18, .t., oContainer ),; 
                          "T"  =>  ComponentCheck():New( idInicio + 19, .t., oContainer ),; 
                          "U"  =>  ComponentCheck():New( idInicio + 20, .t., oContainer ),; 
                          "V"  =>  ComponentCheck():New( idInicio + 21, .t., oContainer ),; 
                          "W"  =>  ComponentCheck():New( idInicio + 22, .t., oContainer ),; 
                          "X"  =>  ComponentCheck():New( idInicio + 23, .t., oContainer ),; 
                          "Y"  =>  ComponentCheck():New( idInicio + 24, .t., oContainer ),; 
                          "Z"  =>  ComponentCheck():New( idInicio + 25, .t., oContainer ) }

Return ( Self )

METHOD Resource( oDialog ) CLASS GetRangoSeries

   ::oTodas:Resource( oDialog )
   ::oNinguna:Resource( oDialog )

   if !empty( ::hObjectSerie )

      hEval( ::hObjectSerie, {| h, o, i | o:Resource( oDialog ) } )

   end if   

Return ( Self )

METHOD InRange( uValue ) CLASS GetRangoSeries

   local value    := .f.

   if empty( uValue )
      Return .f.
   end if

   if !( isChar( uValue ) )
      Return .f.
   end if 

   uValue         := upper( uValue ) 

   if !empty( ::hObjectSerie )

      if !( hb_hhaskey( ::hObjectSerie, uValue ) )
         Return .f.
      end if 

      value       := hGet( ::hObjectSerie, uValue ):Value()
   
   end if

return ( value )

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

METHOD Resource(oDlg) CLASS GetCopias

   REDEFINE CHECKBOX ::lCopiasPredeterminadas ;
      ID          ::idCheck ;
      OF          oDlg

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "99999" ;
      SPINNER ;
      WHEN        !::lCopiasPredeterminadas ;
      VALID       ::bValid ;
      OF          oDlg

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

METHOD Resource(oDlg) CLASS GetPorcentaje

   REDEFINE GET   ::oGetControl ;
      VAR         ::uGetValue ;
      ID          ::idGet ;
      PICTURE     "999" ;
      SPINNER ;
      VALID       ::bValid ;
      OF          oDlg

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

CLASS GetProveedor FROM ComponentGetSayDatabase

   METHOD Build( hBuilder ) 
   METHOD New( idGet, idSay, idText, oContainer ) 

   METHOD First()    INLINE ( ::cText( Space( RetNumCodPrvEmp() ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", RetNumCodPrvEmp() ) ) )

   METHOD Top()      INLINE ( ::cText( D():Top( "Provee", ::getView() ) ) )
   METHOD Bottom()   INLINE ( ::cText( D():Bottom( "Provee", ::getView() ) ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD Build( hBuilder ) 

   local idGet       := if( hhaskey( hBuilder, "idGet" ),      hBuilder[ "idGet"     ], nil )
   local idSay       := if( hhaskey( hBuilder, "idSay"),       hBuilder[ "idSay"     ], nil )
   local idText      := if( hhaskey( hBuilder, "idText"),      hBuilder[ "idText"    ], nil )
   local oContainer  := if( hhaskey( hBuilder, "oContainer"),  hBuilder[ "oContainer"], nil )

   ::New( idGet, idSay, idText, oContainer )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetProveedor

   ::cTextValue   := "Proveedor"

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cProvee( ::oGetControl, D():Proveedores( ::getView() ), ::oSayControl ) }
   ::bHelp        := {|| BrwProvee( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetEmpresa FROM ComponentGetSayDatabase

   METHOD Build( hBuilder ) 
   METHOD New( idGet, idSay, idText, oContainer ) 

   METHOD Current()  INLINE ( ::cText( cCodEmp() ), ::Valid() )

END CLASS 

//--------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetEmpresa 

   local idGet       := if( hhaskey( hBuilder, "idGet" ),      hBuilder[ "idGet"     ], nil )
   local idSay       := if( hhaskey( hBuilder, "idSay"),       hBuilder[ "idSay"     ], nil )
   local idText      := if( hhaskey( hBuilder, "idText"),      hBuilder[ "idText"    ], nil )
   local oContainer  := if( hhaskey( hBuilder, "oContainer"),  hBuilder[ "oContainer"], nil )

   ::New( idGet, idSay, idText, oContainer )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetEmpresa

   ::cTextValue   := "Empresa"

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cEmpresa( ::oGetControl, D():Empresa( ::getView() ), ::oSayControl ) }
   ::bHelp        := {|| brwEmpresa( ::oGetControl, D():Empresa( ::getView() ), ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetArticulo FROM ComponentGetSayDatabase

   METHOD Build( hBuilder ) 
   METHOD New( idGet, idSay, idText, oContainer ) 

   METHOD First()    INLINE ( ::cText( Space( 18 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 18 ) ) )

   METHOD Top()      INLINE ( ::cText( D():Top( "Articulo", ::getView() ) ) )
   METHOD Bottom()   INLINE ( ::cText( D():Bottom( "Articulo", ::getView() ) ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetArticulo

   local idGet       := if( hhaskey( hBuilder, "idGet" ),      hBuilder[ "idGet"     ], nil )
   local idSay       := if( hhaskey( hBuilder, "idSay"),       hBuilder[ "idSay"     ], nil )
   local idText      := if( hhaskey( hBuilder, "idText"),      hBuilder[ "idText"    ], nil )
   local oContainer  := if( hhaskey( hBuilder, "oContainer"),  hBuilder[ "oContainer"], nil )

   ::New( idGet, idSay, idText, oContainer )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetArticulo

   ::cTextValue   := "Artículo"

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cArticulo( ::oGetControl, D():Get( "Articulo", ::getView() ), ::oSayControl ) }
   ::bHelp        := {|| brwArticulo( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetAlmacen FROM ComponentGetSayDatabase

   METHOD Build( hBuilder ) 
   METHOD New( idGet, idSay, idText, oContainer ) 

   METHOD First()    INLINE ( ::cText( Space( 16 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 16 ) ) )

   METHOD Top()      INLINE ( ::cText( D():Top( "Articulo", ::getView() ) ) )
   METHOD Bottom()   INLINE ( ::cText( D():Bottom( "Articulo", ::getView() ) ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetAlmacen

   local idGet       := if( hhaskey( hBuilder, "idGet" ),      hBuilder[ "idGet"     ], nil )
   local idSay       := if( hhaskey( hBuilder, "idSay"),       hBuilder[ "idSay"     ], nil )
   local idText      := if( hhaskey( hBuilder, "idText"),      hBuilder[ "idText"    ], nil )
   local oContainer  := if( hhaskey( hBuilder, "oContainer"),  hBuilder[ "oContainer"], nil )

   ::New( idGet, idSay, idText, oContainer )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetAlmacen

   ::cTextValue   := "Almacén"

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cAlmacen( ::oGetControl, D():Almacen( ::getView() ), ::oSayControl ) }
   ::bHelp        := {|| brwAlmacen( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetPropiedad FROM ComponentGetSay

   METHOD Build( hBuilder ) 
   METHOD New( idGet, idSay, idText, oContainer ) 

   METHOD First()    INLINE ( ::cText( Space( 20 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 20 ) ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetPropiedad

   local idGet       := if( hhaskey( hBuilder, "idGet" ),      hBuilder[ "idGet"     ], nil )
   local idSay       := if( hhaskey( hBuilder, "idSay"),       hBuilder[ "idSay"     ], nil )
   local idText      := if( hhaskey( hBuilder, "idText"),      hBuilder[ "idText"    ], nil )
   local oContainer  := if( hhaskey( hBuilder, "oContainer"),  hBuilder[ "oContainer"], nil )

   ::New( idGet, idSay, idText, oContainer )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetPropiedad

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cProp( ::oGetControl, ::oSayControl ) }
   ::bHelp        := {|| brwProp( ::oGetControl, ::oSayControl ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetPropiedadActual FROM GetPropiedad

   DATA cPropiedad

   METHOD New( idGet, idSay, idText, oContainer )

   METHOD PropiedadActual( cPropiedad )   INLINE ( iif( cPropiedad != nil, ::cPropiedad := cPropiedad, ::cPropiedad ) )

END CLASS 

//--------------------------------------------------------------------------//

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetPropiedadActual

   ::Super:New( idGet, idSay, idText, oContainer )

   ::bValid       := {|| cProp( ::oGetControl, ::oSayControl ) }
   ::bHelp        := {|| brwPropiedadActual( ::oGetControl, ::oSayControl, ::PropiedadActual() ) }

Return ( Self )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS GetGrupoProveedor FROM ComponentGetSay

   METHOD New( idGet, idSay, idText, oContainer )

   METHOD First()    INLINE ( ::cText( Space( 4 ) ) )
   METHOD Last()     INLINE ( ::cText( Replicate( "Z", 4 ) ) )

   METHOD Top()      INLINE ( ::cText( D():GetObject( "GruposProveedores", ::oContainer:nView ):Top() ) )
   METHOD Bottom()   INLINE ( ::cText( D():GetObject( "GruposProveedores", ::oContainer:nView ):Bottom() ) )

END CLASS 

METHOD New( idGet, idSay, idText, oContainer ) CLASS GetGrupoProveedor

   ::Super:New( idGet, idSay, idText, oContainer )

   ::uGetValue    := Space( 4 )

   ::bValid       := {|| D():GruposProveedores( ::oContainer:nView ):Existe( ::oGetControl, ::oSayControl, "cNomGrp", .t., .t., "0" ) }
   ::bHelp        := {|| D():GruposProveedores( ::oContainer:nView ):Buscar( ::oGetControl ) }

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

   METHOD end()            INLINE ( ::oRTF:oFont:end(), ::oRTF:end(), ::oRTF := nil )
   
END CLASS

//--------------------------------------------------------------------------//

   METHOD Redefine( id, oDlg ) CLASS GetRichEdit 

      DEFAULT id     := 600
      DEFAULT oDlg   := ::oDlg 

      DEFINE CLIPBOARD ::oClp OF oDlg FORMAT TEXT

      REDEFINE BTNBMP ::oBtnPrint ;
         ID       ( id ) ;
         WHEN     ( .t. ) ;
         OF       oDlg ;
         RESOURCE "gc_printer2_16" ;
         NOBORDER ;
         TOOLTIP  "Imprimir" ;

      ::oBtnPrint:bAction 	:= {|| ::oRTF:Print(), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnPreview ;
         ID       ( id + 1 ) ;
         WHEN     ( .t. ) ;
         OF       oDlg ;
         RESOURCE "PREV116" ;
         NOBORDER ;
         TOOLTIP  "Previsualizar" ;

      ::oBtnPreview:bAction := {|| ::oRTF:Preview( "Class TRichEdit" ) }

      REDEFINE BTNBMP ::oBtnSearch ;
         ID       ( id + 2 ) ;
         WHEN     ( .t. ) ;
         OF       oDlg ;
         RESOURCE "Bus16" ;
         NOBORDER ;
         TOOLTIP  "Buscar" ;
      
      ::oBtnSearch:bAction := {|| FindRich( ::oRTF ) } 

      REDEFINE BTNBMP ::oBtnCut ;
         ID       ( id + 3 ) ;
         WHEN     ( ! empty( ::oRTF:GetSel() ) .and. ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "gc_cut_16" ;
         NOBORDER ;
         TOOLTIP  "Cortar" ;

      ::oBtnCut:bAction 	:= {|| ::oRTF:Cut(), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnCopy ;
         ID       ( id + 4 ) ;
         WHEN     ( ! empty( ::oRTF:GetSel() ) ) ;
         OF       oDlg ;
         RESOURCE "gc_copy_16" ;
         NOBORDER ;
         TOOLTIP  "Copiar" ;

      ::oBtnCopy:bAction	:= {|| ::oRTF:Copy(), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnPaste ;
         ID       ( id + 5 ) ;
         WHEN     ( ! empty( ::oClp:GetText() ) .and. ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "gc_clipboard_paste_16" ;
         NOBORDER ;
         TOOLTIP  "Pegar" ;

      ::oBtnPaste:bAction 	:= {|| ::oRTF:Paste(), ::oRTF:SetFocus() }         

      REDEFINE BTNBMP ::oBtnUndo ;
         ID       ( id + 6 ) ;
         WHEN     ( ::oRTF:SendMsg( EM_CANUNDO ) != 0 ) ;
         OF       oDlg ;
         RESOURCE "gc_undo_inv_16" ;
         NOBORDER ;
         TOOLTIP  "Deshacer" ;

      ::oBtnUndo:bAction 	:= {|| ::oRTF:Undo(), ::oRTF:SetFocus() }   

      REDEFINE BTNBMP ::oBtnRedo ;
         ID       ( id + 7 ) ;
         WHEN     ( ::oRTF:SendMsg( EM_CANREDO ) != 0 ) ;
         OF       oDlg ;
         RESOURCE "gc_undo_16" ;
         NOBORDER ;
         TOOLTIP  "Rehacer" ;

      ::oBtnRedo:bAction := {|| ::oRTF:Redo(), ::oRTF:SetFocus() }

      REDEFINE COMBOBOX ::oZoom ;
         VAR      ::cZoom ;
         ITEMS    ::aZoom ;
         ID       ( id + 8 ) ;
         OF       oDlg

      ::oZoom:bChange      := {|| ::oRTF:SetZoom( ::aRatio[ ::oZoom:nAt, 1 ], ::aRatio[ ::oZoom:nAt, 2 ] ), ::oRTF:SetFocus()  }
   
      REDEFINE COMBOBOX ::oFuente ;
         VAR      ::cFuente ;
         ITEMS    ::aFuente ;
         ID       ( id + 9 ) ;
         OF       oDlg

      ::oFuente:bChange    := {|| ::oRTF:SetFontName( ::oFuente:VarGet() ), ::oRTF:SetFocus() }

      REDEFINE COMBOBOX ::oSize ;
         VAR      ::cSize ;
         ITEMS    ::aSize ;
         ID       ( id + 10 ) ;
         OF       oDlg

      ::oSize:bChange      := {|| ::oRTF:SetFontSize( Val( ::oSize:VarGet() ) ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnBold ;
         ID       ( id + 11 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "gc_text_bold_16" ;
         NOBORDER ;
         TOOLTIP  "Negrita" ;

      ::oBtnBold:bAction	:= {|| ( ::lBold  := !::lBold, ::oRTF:SetBold( ::lBold ), ::oRTF:SetFocus() ) }   

      REDEFINE BTNBMP ::oBtnItalics ;
         ID       ( id + 12 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "gc_text_italics_16" ;
         NOBORDER ;
         TOOLTIP  "Cursiva" ;
         
      ::oBtnItalics:bAction 	:= {|| ( ::lItalic := !::lItalic, ::oRTF:SetItalic( ::lItalic ), ::oRTF:SetFocus() ) }

      REDEFINE BTNBMP ::oBtnUnderLine;
         ID       ( id + 13 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "gc_text_underline_16" ;
         NOBORDER ;
         TOOLTIP  "Subrayado" ;

      ::oBtnUnderLine:bAction 	:= {|| ( ::lUnderline := !::lUnderline, ::oRTF:SetUnderline( ::lUnderline ), ::oRTF:SetFocus() ) }

      REDEFINE BTNBMP ::oBtnTextAlignLeft ;
         ID       ( id + 14 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "gc_text_align_left_16" ;
         NOBORDER ;
         TOOLTIP  "Izquierda" ;

      ::oBtnTextAlignLeft:bAction 	:= {|| ::oRTF:SetAlign( PFA_LEFT ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnTextAlignCenter  ;
         ID       ( id + 15 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "gc_text_center_16" ;
         NOBORDER ;
         TOOLTIP  "Centro" ;

      ::oBtnTextAlignCenter:bAction := {|| ::oRTF:SetAlign( PFA_CENTER ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnTextAlignRight ;
         ID       ( id + 16 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "gc_text_align_right_16" ;
         NOBORDER ;
         TOOLTIP  "Derecha" ;

      ::oBtnTextAlignRight:bAction 	:= {|| ::oRTF:SetAlign( PFA_RIGHT ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnTextJustify ;
         ID       ( id + 17 ) ;
         WHEN     ( ! ::oRTF:lReadOnly ) ;
         OF       oDlg ;
         RESOURCE "gc_text_justified_16" ;
         NOBORDER ;
         TOOLTIP  "Justificado" ;

      ::oBtnTextJustify:bAction 	:= {|| ::oRTF:SetAlign( PFA_JUSTIFY ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnBullet ;
         ID       ( id + 18 ) ;
         WHEN     ( ! ::oRTF:lReadOnly .and. ! ::oRTF:GetNumbering() ) ;
         OF       oDlg ;
         RESOURCE "gc_pin_blue_16" ;
         NOBORDER ;
         TOOLTIP  "Viñetas" ;

      ::oBtnBullet:bAction 			:= {|| ::lBullet := !::lBullet, ::oRTF:SetBullet( ::lBullet ), ::oRTF:SetFocus() }

      REDEFINE BTNBMP ::oBtnDateTime ;
         ID       ( id + 19 ) ;
         OF       oDlg ;
         RESOURCE "gc_calendar_16" ;
         NOBORDER ;
         TOOLTIP  "Fecha/Hora" ;

      ::oBtnDateTime:bAction 		:= {|| DateTimeRich( ::oRTF ) }

      REDEFINE RICHEDIT ::oRTF ;
         VAR      ::cRTF ;
         ID       ( id + 20 ) ;
         OF       oDlg

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

CLASS BrowseRangos

   DATA idBrowse
   DATA oContainer
   DATA aInitGroup            INIT {}
   DATA oBrwRango
   DATA oColNombre
   DATA oColDesde
   DATA oColHasta

   METHOD New()
   METHOD Resource()

   METHOD AddGroup( oGroup )  INLINE ( aAdd( ::aInitGroup, oGroup ) )

   METHOD EditValueTextDesde()         INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:HelpDesde ) )
   METHOD EditValueTextHasta()         INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:HelpHasta ) )
   METHOD EditTextDesde()              INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:TextDesde ) )
   METHOD EditTextHasta()              INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:TextHasta ) )

   METHOD ValidValueTextDesde( oGet )  INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:ValidDesde, oGet ) )
   METHOD ValidValueTextHasta( oGet )  INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:ValidHasta, oGet ) )

   METHOD ResizeColumns()

END CLASS 

//---------------------------------------------------------------------------//

METHOD New( idBrowse, oContainer ) CLASS BrowseRangos

   ::idBrowse     := idBrowse
   ::oContainer   := oContainer
   
Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS BrowseRangos

   local o

   ::oBrwRango                      := IXBrowse():New( ::oContainer )

   ::oBrwRango:bClrSel              := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwRango:bClrSelFocus         := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwRango:SetArray( ::aInitGroup, , , .f. )

   ::oBrwRango:lHScroll             := .f.
   ::oBrwRango:lVScroll             := .f.
   ::oBrwRango:lRecordSelector      := .t.
   ::oBrwRango:lFastEdit            := .t.

   ::oBrwRango:nFreeze              := 1
   ::oBrwRango:nMarqueeStyle        := 3

   ::oBrwRango:nColSel              := 2

   ::oBrwRango:CreateFromResource( ::idBrowse )

   ::oColNombre                     := ::oBrwRango:AddCol()
   ::oColNombre:cHeader             := ""
   ::oColNombre:bStrData            := {|| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Nombre }
   ::oColNombre:bBmpData            := {|| ::oBrwRango:nArrayAt }
   ::oColNombre:nWidth              := 200
   ::oColNombre:Cargo               := 0.20

   for each o in ::aInitGroup
      ::oColNombre:AddResource( o:cBitmap )
   next

   with object ( ::oColDesde := ::oBrwRango:AddCol() )
      :cHeader       := "Desde"
      :bEditValue    := {|| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Desde }
      :bOnPostEdit   := {|o,x| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Desde := x }
      :bEditValid    := {|oGet| ::ValidValueTextDesde( oGet ) }
      :bEditBlock    := {|| ::EditValueTextDesde() }
      :cEditPicture  := "@!"
      :nEditType     := 5
      :nWidth        := 120
      :Cargo         := 0.15
      :nBtnBmp       := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bEditValue    := {|| ::EditTextDesde() } 
      :nEditType     := 0
      :nWidth        := 200
      :Cargo         := 0.25
   end with

   with object ( ::oColHasta := ::oBrwRango:AddCol() )
      :cHeader       := "Hasta"
      :bEditValue    := {|| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Hasta }
      :bOnPostEdit   := {|o,x| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Hasta := x }
      :bEditValid    := {|oGet| ::ValidValueTextHasta( oGet ) }
      :bEditBlock    := {|| ::EditValueTextHasta() }
      :cEditPicture  := "@!"
      :nEditType     := 5
      :nWidth        := 120
      :Cargo         := 0.15
      :nBtnBmp       := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bEditValue    := {|| ::EditTextHasta() }
      :nEditType     := 0
      :nWidth        := 200
      :Cargo         := 0.25
   end with

Return .t.

//---------------------------------------------------------------------------//

METHOD ResizeColumns() CLASS BrowseRangos

   ::oBrwRango:CheckSize()

   aeval( ::oBrwRango:aCols, {|o, n, oCol| o:nWidth := ::oBrwRango:nWidth * o:Cargo } )

Return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS BrowseProperties

   DATA idBrowse
   DATA oContainer
   
   DATA nView

   DATA oBrwProperties
   DATA aPropertiesTable

   DATA oGetUnidades

   CLASSDATA oInstance

   METHOD New()
   METHOD newInstance( idBrowse, oContainer, nView )  INLINE ( ::endInstance(), ::GetInstance( idBrowse, oContainer, nView ), ::oInstance ) 
   METHOD getInstance( idBrowse, oContainer, nView )  INLINE ( if( empty( ::oInstance ), ::oInstance := ::New( idBrowse, oContainer, nView ), ::oInstance ) ) 
   METHOD endInstance()                               INLINE ( if( !empty( ::oInstance ), ::oInstance := nil, ), nil ) 

   METHOD Resource()
   METHOD buildPropertiesTable()
   METHOD setPropertiesTableToBrowse()

   METHOD bGenerateEditText( n )
   METHOD bGenerateEditValue( n )
   METHOD bGenerateRGBValue( n )   

   METHOD bPostEditProperties()
   METHOD nTotalProperties()

   METHOD Hide()                                      INLINE ( ::setCargo(), ::oBrwProperties:Hide() )
   METHOD setCargo( uValue )                          INLINE ( ::oBrwProperties:Cargo := uValue ) 
   METHOD Cargo                                       INLINE ( ::oBrwProperties:Cargo )
   METHOD setBindingUnidades( oGetUnidades )          INLINE ( ::oGetUnidades := oGetUnidades )

   METHOD setPropertiesUnits()
   METHOD cleanPropertiesUnits()

END CLASS 

//---------------------------------------------------------------------------//

METHOD New( idBrowse, oContainer, nView ) CLASS BrowseProperties

   ::idBrowse     := idBrowse
   ::oContainer   := oContainer
   ::nView        := nView

   ::Resource()
   
Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS BrowseProperties

   ::oBrwProperties                 := IXBrowse():New( ::oContainer )

   ::oBrwProperties:nDataType       := DATATYPE_ARRAY

   ::oBrwProperties:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwProperties:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwProperties:lHScroll        := .t.
   ::oBrwProperties:lVScroll        := .t.

   ::oBrwProperties:nMarqueeStyle   := 3
   ::oBrwProperties:lRecordSelector := .f.
   ::oBrwProperties:lFastEdit       := .t.
   ::oBrwProperties:nFreeze         := 1
   ::oBrwProperties:lFooter         := .f.

   ::oBrwProperties:SetArray( {}, .f., 0, .f. )

   ::oBrwProperties:CreateFromResource( ::idBrowse )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildPropertiesTable( idArticulo, idPrimeraPropiedad, idSegundaPropiedad, nPrecioCosto ) CLASS BrowseProperties

   local n
   local a
   local o
   local nRow                    := 1
   local nCol                    := 1
   local nTotalRow               := 0
   local nTotalCol               := 0
   local hValorPropiedad
   local aHeadersTable           := {}
   local aSizesTable             := {}
   local aJustifyTable           := {}
   local aPropiedadesArticulo1   
   local aPropiedadesArticulo2   

   ::aPropertiesTable            := {}

   aPropiedadesArticulo1         := aPropiedadesArticulo1( idArticulo, ::nView ) 
   nTotalRow                     := len( aPropiedadesArticulo1 )
   if nTotalRow != 0
      aPropiedadesArticulo2      := aPropiedadesArticulo2( idArticulo, ::nView ) 
   else 
      aPropiedadesArticulo1      := aPropiedadesGeneral( idPrimeraPropiedad, ::nView )
      nTotalRow                  := len( aPropiedadesArticulo1 )
      if nTotalRow != 0
         aPropiedadesArticulo2   := aPropiedadesGeneral( idSegundaPropiedad, ::nView )
      else
         Return nil
      end if 
   end if

   // Montamos los array con las propiedades-----------------------------------

   if len( aPropiedadesArticulo2 ) == 0
      nTotalCol                  := 2
   else
      nTotalCol                  := len( aPropiedadesArticulo2 ) + 1
   end if

   ::aPropertiesTable            := array( nTotalRow, nTotalCol )

   if ( D():Propiedades( ::nView ) )->( dbSeek( idPrimeraPropiedad ) )
      aadd( aHeadersTable, ( D():Propiedades( ::nView ) )->cDesPro )
      aadd( aSizesTable,   60 )
      aadd( aJustifyTable, .f. )
   end if

   for each hValorPropiedad in aPropiedadesArticulo1

      ::aPropertiesTable[ nRow, nCol ]                        := TPropertiesItems():New()
      ::aPropertiesTable[ nRow, nCol ]:cCodigo                := idArticulo
      ::aPropertiesTable[ nRow, nCol ]:cHead                  := hValorPropiedad[ "TipoPropiedad" ]
      ::aPropertiesTable[ nRow, nCol ]:cText                  := hValorPropiedad[ "CabeceraPropiedad" ]
      ::aPropertiesTable[ nRow, nCol ]:cCodigoPropiedad1      := hValorPropiedad[ "CodigoPropiedad" ]
      ::aPropertiesTable[ nRow, nCol ]:cValorPropiedad1       := hValorPropiedad[ "ValorPropiedad" ]
      ::aPropertiesTable[ nRow, nCol ]:lColor                 := hValorPropiedad[ "ColorPropiedad" ]
      ::aPropertiesTable[ nRow, nCol ]:nRgb                   := hValorPropiedad[ "RgbPropiedad" ]

      nRow++

   next

   if !empty( idSegundaPropiedad ) .and. !empty( aPropiedadesArticulo2 )

      for each hValorPropiedad in aPropiedadesArticulo2

         nCol++

         aadd( aHeadersTable, hValorPropiedad[ "CabeceraPropiedad" ] )
         aadd( aSizesTable,   60 )
         aadd( aJustifyTable, .t. )

         for n := 1 to nTotalRow
            ::aPropertiesTable[ n, nCol ]                     := TPropertiesItems():New()
            ::aPropertiesTable[ n, nCol ]:Value               := 0
            ::aPropertiesTable[ n, nCol ]:cHead               := hValorPropiedad[ "CabeceraPropiedad" ]
            ::aPropertiesTable[ n, nCol ]:cCodigo             := idArticulo
            ::aPropertiesTable[ n, nCol ]:cCodigoPropiedad1   := ::aPropertiesTable[ n, 1 ]:cCodigoPropiedad1
            ::aPropertiesTable[ n, nCol ]:cValorPropiedad1    := ::aPropertiesTable[ n, 1 ]:cValorPropiedad1
            ::aPropertiesTable[ n, nCol ]:cCodigoPropiedad2   := hValorPropiedad[ "CodigoPropiedad" ]
            ::aPropertiesTable[ n, nCol ]:cValorPropiedad2    := hValorPropiedad[ "ValorPropiedad" ]
            ::aPropertiesTable[ n, nCol ]:lColor              := ::aPropertiesTable[ n, 1 ]:lColor
            ::aPropertiesTable[ n, nCol ]:nRgb                := ::aPropertiesTable[ n, 1 ]:nRgb
         next

      next

   else

      nCol++

      aAdd( aHeadersTable, "Unidades" )
      aAdd( aSizesTable,   60 )
      aAdd( aJustifyTable, .t. )

      for n := 1 to nTotalRow
         ::aPropertiesTable[ n, nCol ]                        := TPropertiesItems():New()
         ::aPropertiesTable[ n, nCol ]:Value                  := 0
         ::aPropertiesTable[ n, nCol ]:cHead                  := "Unidades"
         ::aPropertiesTable[ n, nCol ]:cCodigo                := idArticulo
         ::aPropertiesTable[ n, nCol ]:cCodigoPropiedad1      := ::aPropertiesTable[ n, 1 ]:cCodigoPropiedad1
         ::aPropertiesTable[ n, nCol ]:cValorPropiedad1       := ::aPropertiesTable[ n, 1 ]:cValorPropiedad1
         ::aPropertiesTable[ n, nCol ]:cCodigoPropiedad2      := Space( 20 )
         ::aPropertiesTable[ n, nCol ]:cValorPropiedad2       := Space( 40 )
         ::aPropertiesTable[ n, nCol ]:lColor                 := ::aPropertiesTable[ n, 1 ]:lColor
         ::aPropertiesTable[ n, nCol ]:nRgb                   := ::aPropertiesTable[ n, 1 ]:nRgb
      next

   end if

   // Calculo de precios----------------------------------------------------------

   for each a in ::aPropertiesTable
      for each o in a
         if IsObject( o )
            o:PrecioCompra( nPrecioCosto, D():ArticuloPrecioPropiedades( ::nView ) )
         end if
      next
   next

   // Asignamos la informacion al browse---------------------------------------

   ::setPropertiesTableToBrowse()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD setPropertiesTableToBrowse( aPropertiesTable ) CLASS BrowseProperties

   local n

   if empty( ::oBrwProperties )
      Return ( Self )
   end if 

   if !empty( aPropertiesTable )
      ::aPropertiesTable      := aPropertiesTable
   end if 

   ::oBrwProperties:Hide()

   ::oBrwProperties:aCols     := {}
   ::oBrwProperties:Cargo     := ::aPropertiesTable   
   ::oBrwProperties:nFreeze   := 1
   
   ::oBrwProperties:SetArray( ::aPropertiesTable, .f., 0, .f. )

   for n := 1 to len( ::aPropertiesTable[ 1 ] )

      if isNil( ::aPropertiesTable[ ::oBrwProperties:nArrayAt, n ]:Value )

         // Columna del titulo de la propiedad---------------------------------

         with object ( ::oBrwProperties:AddCol() )
            :Adjust()
            :cHeader          := ::aPropertiesTable[ ::oBrwProperties:nArrayAt, n ]:getHead()
            :bEditValue       := ::bGenerateEditText( n )
            :nWidth           := 100
         end with

         // Columna del color de la propiedad----------------------------------

         if ::aPropertiesTable[ ::oBrwProperties:nArrayAt, n ]:lColor

            with object ( ::oBrwProperties:AddCol() )
               :Adjust()
               :cHeader       := "Color"
               :nWidth        := 40
               :bStrData      := {|| "" }
               :nWidth        := 16
               :bClrStd       := ::bGenerateRGBValue( n )
               :bClrSel       := ::bGenerateRGBValue( n )
               :bClrSelFocus  := ::bGenerateRGBValue( n )
            end with
            
            ::oBrwProperties:nFreeze++
            // ::oBrwProperties:nColOffset++

         end if 

      else

         with object ( ::oBrwProperties:AddCol() )
            :Adjust()
            :cHeader          := ::aPropertiesTable[ ::oBrwProperties:nArrayAt, n ]:getHead()
            :bEditValue       := ::bGenerateEditValue( n )
            :cEditPicture     := MasUnd()
            :nWidth           := 50
            :setAlign( AL_RIGHT )
            :nEditType        := EDIT_GET
            :nHeadStrAlign    := AL_RIGHT
            :bOnPostEdit      := {| oCol, xVal, nKey | ::bPostEditProperties( oCol, xVal, nKey ) }
            :nFootStyle       := :defStyle( AL_RIGHT, .t. )               
            :Cargo            := n
         end with

      end if

   next
      
   ::oBrwProperties:aCols[ 1 ]:Hide()
   ::oBrwProperties:Adjust()

   ::oBrwProperties:nColSel         := ::oBrwProperties:nFreeze + 1

   ::oBrwProperties:nRowHeight      := 20
   ::oBrwProperties:nHeaderHeight   := 20

   ::oBrwProperties:Show()

Return ( self )

//---------------------------------------------------------------------------//

METHOD bGenerateEditText( n ) CLASS BrowseProperties

Return ( {|| ::aPropertiesTable[ ::oBrwProperties:nArrayAt, n ]:cText } )

//--------------------------------------------------------------------------//

METHOD bGenerateEditValue( n ) CLASS BrowseProperties

Return ( {|| ::aPropertiesTable[ ::oBrwProperties:nArrayAt, n ]:Value } )

//--------------------------------------------------------------------------//

METHOD bGenerateRGBValue( n ) CLASS BrowseProperties

Return ( {|| { nRGB( 0, 0, 0), ::aPropertiesTable[ ::oBrwProperties:nArrayAt, n ]:nRgb } } )

//--------------------------------------------------------------------------//

METHOD bPostEditProperties( oCol, xVal, nKey ) CLASS BrowseProperties

   ::oBrwProperties:Cargo[ ::oBrwProperties:nArrayAt, oCol:Cargo ]:Value := xVal 

   ::nTotalProperties()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD nTotalProperties() CLASS BrowseProperties

   local aRow  
   local aCol
   local nTot     := 0

   for each aRow in ::aPropertiesTable
      for each aCol in aRow
         if isNum( aCol:Value )
            nTot  += aCol:Value 
         end if
      next
   next 

   if !empty( ::oGetUnidades )
      ::oGetUnidades:cText( nTot )
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setPropertiesUnits( idArticulo, idCodigoPrimeraPropiedad, idCodigoSegundaPropiedad, idValorPrimeraPropiedad, idValorSegundaPropiedad, nUnidades )

   local oColumn
   local aProperty

   for each aProperty in ::aPropertiesTable
      for each oColumn in aProperty
         if rtrim( oColumn:cCodigo )            == rtrim( idArticulo ) .and. ;
            rtrim( oColumn:cCodigoPropiedad1 )  == rtrim( idCodigoPrimeraPropiedad ) .and. ;
            rtrim( oColumn:cCodigoPropiedad2 )  == rtrim( idCodigoSegundaPropiedad ) .and. ;
            rtrim( oColumn:cValorPropiedad1 )   == rtrim( idValorPrimeraPropiedad ) .and. ;
            rtrim( oColumn:cValorPropiedad2 )   == rtrim( idValorSegundaPropiedad )

            oColumn:Value  := nUnidades

         end if
      next
   next 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD cleanPropertiesUnits()

   local oColumn
   local aProperty

   for each aProperty in ::aPropertiesTable
      for each oColumn in aProperty
         oColumn:Value  := 0
      next
   next 

   ::nTotalProperties()

   ::oBrwProperties:Refresh()

Return ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DialogBrowseProperties

   DATA oSender

   DATA oContainer
   DATA oBrwProperties
   DATA oGetUnidades

   CLASSDATA oInstance

   METHOD New( nView )
   METHOD newInstance( nView )         INLINE ( ::endInstance(), ::GetInstance( nView ), ::oInstance ) 
   METHOD getInstance( nView )         INLINE ( if( empty( ::oInstance ), ::oInstance := ::New( nView ), ::oInstance ) ) 
   METHOD endInstance()                INLINE ( if( !empty( ::oInstance ), ::oInstance := nil, ) ) 

   METHOD getPropertiesTable()         INLINE ( ::oSender:aPropertiesTable )

   METHOD Dialog()
   METHOD StartDialog() 
   METHOD SaveDialog( oDlg )           INLINE ( oDlg:end( IDOK ) )

END CLASS 

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS DialogBrowseProperties

   ::oSender   := oSender

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog() CLASS DialogBrowseProperties

   local n
   local oDlg
   local oGetUnidades
   local nGetUnidades   := 0

   DEFINE DIALOG oDlg RESOURCE "Propiedades"
   
      ::oBrwProperties  := BrowseProperties():new( 100, oDlg )

      ::oBrwProperties:setPropertiesTableToBrowse( ::getPropertiesTable() )

      REDEFINE GET      oGetUnidades ;
         VAR            nGetUnidades ;
         ID             110 ;
         WHEN           ( .f. ) ;
         PICTURE        masUnd() ;
         OF             oDlg 

      ::oBrwProperties:setBindingUnidades( oGetUnidades )

      REDEFINE BUTTON;
         ID             IDOK ;
         OF             oDlg ;
         ACTION         ( ::SaveDialog( oDlg ) )

      REDEFINE BUTTON ;
         ID             IDCANCEL ;
         OF             oDlg ;
         CANCEL ;
         ACTION         ( oDlg:end() )

      oDlg:bStart       := {|| ::StartDialog() }

      oDlg:AddFastKey( VK_F5, {|| ::SaveDialog( oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD StartDialog() CLASS DialogBrowseProperties

   ::oBrwProperties:setPropertiesTableToBrowse( ::getPropertiesTable() )

   ::oBrwProperties:nTotalProperties()

Return ( Self )

//--------------------------------------------------------------------------//


