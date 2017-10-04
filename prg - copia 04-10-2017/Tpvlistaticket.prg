#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"
#include "Xbrowse.ch"

#define ExitAceptarRegalo     1
#define ExitAceptarImprimir   2
#define ExitAceptar           3
#define ExitCancelar          4

#define ubiGeneral            0
#define ubiLlevar             1
#define ubiSala               2
#define ubiRecoger            3
#define ubiEncargar           4

#define gprGeneral            1
#define grpParaLlevar         2
#define grpMesas              3
#define grpParaRecoger        4
#define grpParaEncargar       5

//--------------------------------------------------------------------------//

CLASS TpvListaTicket

   DATA oSender

   DATA oDlg
   DATA oDlgFiltro

   DATA nExit

   DATA oFntDlg

   DATA oBrwListaTicket

   DATA oBtnAbiertos
   DATA oBtnTodos
   DATA oBtnFiltro

   DATA oListViewPendiente

   DATA oImageListPendiente

   DATA cAliasTicketCabecera

   DATA oOfficeBar

   DATA cNumeroTicket

   DATA cResource

   DATA oPrimeraLinea
   DATA oAnteriorPagina
   DATA oSiguientePagina
   DATA oAnteriorLinea
   DATA oSiguienteLinea
   DATA oUltimaLinea

   DATA oGetFechaIni
   DATA dGetFechaIni
   DATA oGetFechaFin
   DATA dGetFechaFin
   DATA oGetUsuario
   DATA cUsuario
   DATA oNombreUsuario
   DATA cNombreUsuario
   DATA oGetCliente
   DATA cCliente
   DATA oCodigoCliente
   DATA cCodigoCliente
   DATA oGetCaja
   DATA cCaja
   DATA oTextoCaja
   DATA cTextoCaja
   DATA oGetTotal
   DATA cComparacionesTotales
   DATA aTotal
   DATA oGetImporteTotal
   DATA nImporteTotal
   DATA oBmpGeneral
   DATA oGetUbicacion
   DATA cUbicacionTicket
   DATA aUbicacion
   DATA aTextEstado

   DATA nTotalSelect

   DATA oBtnLstMesas
   DATA oBtnLstGeneral
   DATA oBtnLstRecoger
   DATA oBtnLstLlevar
   DATA oBtnLstEncargar

   METHOD New( oSender ) CONSTRUCTOR

   METHOD End()

   METHOD lResource( nOption )
   METHOD StartResource()

   METHOD OnClickListaTicket()
   METHOD OnClickReabrirTicket() 

   METHOD LineaPrimera()      INLINE ( ::oBrwListaTicket:GoTop(),    ::oBrwListaTicket:Select(0), ::oBrwListaTicket:Select(1) )
   METHOD PaginaAnterior()    INLINE ( ::oBrwListaTicket:PageUp(),   ::oBrwListaTicket:Select(0), ::oBrwListaTicket:Select(1) )
   METHOD PaginaSiguiente()   INLINE ( ::oBrwListaTicket:PageDown(), ::oBrwListaTicket:Select(0), ::oBrwListaTicket:Select(1) )
   METHOD LineaAnterior()     INLINE ( ::oBrwListaTicket:GoUp(),     ::oBrwListaTicket:Select(0), ::oBrwListaTicket:Select(1) )
   METHOD LineaSiguiente()    INLINE ( ::oBrwListaTicket:GoDown(),   ::oBrwListaTicket:Select(0), ::oBrwListaTicket:Select(1) )
   METHOD LineaUltima()       INLINE ( ::oBrwListaTicket:GoBottom(), ::oBrwListaTicket:Select(0), ::oBrwListaTicket:Select(1) )

   METHOD cSelectedTicket()   INLINE ( ::cNumeroTicket )

   METHOD OnClickTodos()
   METHOD OnClickAbiertos()
   METHOD OnClickFiltro()

   METHOD OnClickMesas()
   METHOD OnClickGeneral()
   METHOD OnClickRecoger()
   METHOD OnClickLlevar()
   METHOD OnClickEncargar()

   METHOD OnAceptarFiltro()

   METHOD lPendientes()
   METHOD StartPendientes()
   METHOD SelectPedientes( nOpt )

   METHOD InsertUbicacionGeneral()

   METHOD lVales()
   METHOD StartVales()

   METHOD OnClickSelectVales()
   METHOD OnClickAceptarVales()
   METHOD OnClickSelectTodosVales()
   METHOD OnClickSelectNingunoVales()

   METHOD nEstadoTickets()

   METHOD Imprimir( lPrevisualizar )
   
   METHOD UnSelectButtons()

END CLASS

//--------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TpvListaTicket

   ::oSender                  := oSender

   ::cNumeroTicket            := nil

   ::dGetFechaIni             := GetSysDate()
   ::dGetFechaFin             := GetSysDate()

   ::cCliente                 := Space( 12 )
   ::cCaja                    := Space( 3 )

   ::aTotal                   := { "Igual", "Mayor", "Mayor o igual", "Menor", "Menor o igual", "Distinto" }
   ::aUbicacion               := { "Mesas", "General", "Para llevar" }
   ::aTextEstado              := { "Abierto", "Pendiente", "Cobrado" }

   ::nImporteTotal            := 0

   ::cUsuario                 := Space( 3 )

   ::cResource                := "Tpv_Lista_Ticket"

Return Self

//--------------------------------------------------------------------------//

METHOD End() CLASS TpvListaTicket

   if !Empty( ::oOfficeBar )
      ::oOfficeBar:End()
   end if

   if !Empty( ::oBrwListaTicket )
      ::oBrwListaTicket:End()
   end if

   if !Empty( ::oDlg )
      ::oDlg:End()
   end if

   if !Empty( ::oImageListPendiente )
      ::oImageListPendiente:End()
   end if

   ::oOfficeBar               := nil
   ::oDlg                     := nil
   ::oImageListPendiente      := nil

Return Self

//--------------------------------------------------------------------------//

METHOD lResource() CLASS TpvListaTicket

   local oFont                            := TFont():New( "Segoe UI",  0, 20, .f., .t. )

   ::cNumeroTicket                        := nil 

   ::oSender:oTiketCabecera:GetStatus()

   ::oSender:oTiketCabecera:OrdSetFocus( "lCloTik" )
   ::oSender:oTiketCabecera:GoTop()

   DEFINE DIALOG ::oDlg RESOURCE ( ::cResource ) TITLE ( "Lista de tickets: Tickets abiertos" )

      ::oBrwListaTicket                   := IXBrowse():New( ::oDlg )

      ::oBrwListaTicket:lRecordSelector   := .f.
      ::oBrwListaTicket:lHScroll          := .f.
      ::oBrwListaTicket:lVScroll          := .t.
      ::oBrwListaTicket:nHeaderLines      := 2
      ::oBrwListaTicket:nDataLines        := 2
      ::oBrwListaTicket:cName             := "Tpv.Lista tickets"
      ::oBrwListaTicket:nRowHeight        := 54

      ::oBrwListaTicket:nMarqueeStyle     := 5
      ::oBrwListaTicket:nRowDividerStyle  := 4

      ::oBrwListaTicket:bClrSel           := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }
      ::oBrwListaTicket:bClrSelFocus      := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }

      ::oBrwListaTicket:bLDblClick        := {|| ::OnClickListaTicket() }

      ::oBrwListaTicket:SetFont( oFont )

      ::oSender:oTiketCabecera:SetBrowse( ::oBrwListaTicket )

      ::oBrwListaTicket:CreateFromResource( 100 )

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Sesión cerrada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ::oSender:oTiketCabecera:lCloTik }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_lock2_16" )
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Estado"
         :nHeadBmpNo       := 4
         :bStrData         := {|| ::aTextEstado[ ::nEstadoTickets() ] }
         :bBmpData         := {|| ::nEstadoTickets() }
         :nWidth           := 24
         :AddResource( "gc_delete_12" )
         :AddResource( "gc_shape_square_12" )
         :AddResource( "gc_check_12" )
         :AddResource( "gc_trafficlight_on_16" )
      end with

      //:bStrData         := {|| if( ::oSender:oTiketCabecera:lAbierto, "Abierto", if( !::oSender:oTiketCabecera:lPgdTik, "Pendiente", "Cobrado" ) ) }
      //:bBmpData         := {|| if( ::oSender:oTiketCabecera:lAbierto, 1, if( !::oSender:oTiketCabecera:lPgdTik, 2, 3 ) ) }

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Ubicación"
         :bEditValue       := {|| ::oSender:cUbicacion() }
         :nWidth           := 190
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Número" + CRLF + "Delegación"
         :bEditValue       := {|| ::oSender:oTiketCabecera:cSerTik + "/" + lTrim( ::oSender:oTiketCabecera:cNumTik ) + CRLF + ::oSender:oTiketCabecera:cSufTik }
         :nWidth           := 90
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ::oSender:oTiketCabecera:cTurTik, "######" ) }
         :nWidth           := 80
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Fecha" + CRLF + "Hora"
         :bEditValue       := {|| Dtoc( ::oSender:oTiketCabecera:dFecTik ) + CRLF + ::oSender:oTiketCabecera:cHorTik }
         :nWidth           := 100
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ::oSender:oTiketCabecera:cNcjTik }
         :nWidth           := 75
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ::oSender:oTiketCabecera:cCcjTik }
         :nWidth           := 75
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Estado"
         :bEditValue       := {|| ::oSender:cEstado() }
         :nWidth           := 90
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Cliente"
         :bEditValue       := {|| Rtrim( ::oSender:oTiketCabecera:cCliTik ) + CRLF + ::oSender:oTiketCabecera:cNomTik }
         :nWidth           := 180
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ::oSender:oTiketCabecera:nTotTik }
         :cEditPicture     := ::oSender:cPictureTotal
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nWidth           := 100
      end with

      ::oDlg:bStart        := {|| ::StartResource() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::oSender:oTiketCabecera:SetStatus()

   oFont:End()

   ::End()

Return .t.

//---------------------------------------------------------------------------//

METHOD StartResource() CLASS TpvListaTicket

   local oBoton
   local oGrupo
   local oCarpeta
   local nLen                 := 126
   local nPos                 := 3

   if Empty( ::oOfficeBar )

      /*
      Calculo la longitud para oGrpSalones
      */

      if uFieldEmpresa( "lLlevar" )
         nLen                 += 60
      end if

      if uFieldEmpresa( "lRecoger" )
         nLen                 += 60
      end if

      if uFieldEmpresa( "lEncargar" )
         nLen                 += 60
      end if

      ::oOfficeBar            := TDotNetBar():New( 0, 0, 1020, 120, ::oDlg, 1 )

      ::oOfficeBar:lPaintAll  := .f.
      ::oOfficeBar:lDisenio   := .f.

      ::oOfficeBar:SetStyle( 1 )

      ::oDlg:oTop             := ::oOfficeBar

      oCarpeta                := TCarpeta():New( ::oOfficeBar, "Inicio" )

      oGrupo        := TDotNetGroup():New( oCarpeta, nLen, "Salones", .f., , "gc_cup_32" )
         ::oBtnLstMesas      := TDotNetButton():New( 60, oGrupo, "gc_cup_32",             "Mesas",          1,    {|| ::OnClickMesas() }, , , .f., .f., .f. )
         ::oBtnLstGeneral    := TDotNetButton():New( 60, oGrupo, "gc_cash_register_32",   "General",        2,    {|| ::OnClickGeneral() }, , , .f., .f., .f. )

      if uFieldEmpresa( "lRecoger" )
         ::oBtnLstRecoger    := TDotNetButton():New( 60, oGrupo, "gc_shopping_basket_32", "Para recoger",   nPos, {|| ::OnClickRecoger() }, , , .f., .f., .f. )
         nPos++
      end if

      if uFieldEmpresa( "lLlevar" )
         ::oBtnLstLlevar     := TDotNetButton():New( 60, oGrupo, "gc_motor_scooter_32",   "Para llevar",    nPos, {|| ::OnClickLlevar() }, , , .f., .f., .f. )
         nPos++
      end if

      if uFieldEmpresa( "lEncargar" )
         ::oBtnLstEncargar   := TDotNetButton():New( 60, oGrupo, "gc_notebook2_32",       "Encargos",       nPos, {|| ::OnClickEncargar() }, , , .f., .f., .f. )
         nPos++
      end if

      oGrupo                  := TDotNetGroup():New( oCarpeta, 186,  "Tipo de ticket", .f. )
         ::oBtnAbiertos       := TDotNetButton():New( 60, oGrupo,    "gc_note_block_delete_32",    "Abiertos",           1, {|| ::OnClickAbiertos() }, , , .f., .f., .f. )
         ::oBtnTodos          := TDotNetButton():New( 60, oGrupo,    "gc_note_block_32",           "Todos",              2, {|| ::OnClickTodos() }, , , .f., .f., .f. )
         ::oBtnFiltro         := TDotNetButton():New( 60, oGrupo,    "gc_calendar_32",             "Filtrar",            3, {|| ::OnClickFiltro() }, , , .f., .f., .f. )

      oGrupo                  := TDotNetGroup():New( oCarpeta, 366,  "Seleción de tickets", .f. )
         ::oPrimeraLinea      := TDotNetButton():New( 60, oGrupo,    "gc_navigate_line_up_32",     "Primera línea",      1, {|| ::LineaPrimera() } )
         ::oUltimaLinea       := TDotNetButton():New( 60, oGrupo,    "gc_navigate_line_down_32",   "Última línea",       2, {|| ::LineaUltima() } )
         ::oAnteriorPagina    := TDotNetButton():New( 60, oGrupo,    "gc_navigate_up2a_32",        "Página anterior",    3, {|| ::PaginaAnterior() } )
         ::oSiguientePagina   := TDotNetButton():New( 60, oGrupo,    "gc_navigate_down2a_32",      "Página siguiente",   4, {|| ::PaginaSiguiente() } )
         ::oAnteriorLinea     := TDotNetButton():New( 60, oGrupo,    "gc_arrow_up_32",             "Línea anterior",     5, {|| ::LineaAnterior() } )
         ::oSiguienteLinea    := TDotNetButton():New( 60, oGrupo,    "gc_arrow_down_32",           "Línea siguiente",    6, {|| ::LineaSiguiente() } )

      oGrupo                  := TDotNetGroup():New( oCarpeta, 126,  "Salida", .f. )
         oBoton               := TDotNetButton():New( 60, oGrupo,    "gc_check_32",                "Aceptar",            1, {|| ::OnClickListaTicket() }, , , .f., .f., .f. )
         oBoton               := TDotNetButton():New( 60, oGrupo,    "End32",                   "Salida",             2, {|| ::End() }, , , .f., .f., .f. )

   end if

   return ( nil )      


   /*
   Ponemos el boton seleccionado por defecto-----------------------------------
   */

   ::oBtnAbiertos:Selected()

   ::oBrwListaTicket:Load()
   ::oBrwListaTicket:Refresh()
   ::oBrwListaTicket:SelectOne()

Return ( nil )

//-------------------------------------------------------------------------//

METHOD nEstadoTickets() CLASS TpvListaTicket

   local nEstado     := 1
   local nCobTik     := 0

   if ::oSender:oTiketCabecera:lAbierto

      if !::oSender:oTiketCobro:SeekInOrd( ::oSender:oTiketCabecera:cSerTik + ::oSender:oTiketCabecera:cNumTik + ::oSender:oTiketCabecera:cSufTik, "CNUMTIK" )
         nEstado     := 1
      else
         nEstado     := 2
      end if

   else

      if !::oSender:oTiketCabecera:lPgdTik
         nEstado     := 2
      else
         nEstado     := 3
      end if

   end if

Return nEstado

//-------------------------------------------------------------------------//

METHOD OnClickListaTicket() CLASS TpvListaTicket

   ::cNumeroTicket            := ::oSender:oTiketCabecera:cSerTik + ::oSender:oTiketCabecera:cNumTik + ::oSender:oTiketCabecera:cSufTik

   ::oDlg:End()

Return ( nil )

//-------------------------------------------------------------------------//

METHOD OnClickReabrirTicket() CLASS TpvListaTicket

   local cTextoTicket         := ::oSender:oTiketCabecera:cSerTik + "/" + alltrim( ::oSender:oTiketCabecera:cNumTik ) + "/" + alltrim( ::oSender:oTiketCabecera:cSufTik )
   local cNumeroTicket        := ::oSender:oTiketCabecera:cSerTik + ::oSender:oTiketCabecera:cNumTik + ::oSender:oTiketCabecera:cSufTik
   
   if ::oSender:oTiketCabecera:lCloTik
      apoloMsgStop( "El ticket " + cTextoTicket + " pertenece a una sesión cerrada.", "Atención" )
      Return ( nil )
   end if 

   if !::oSender:oTiketCabecera:lPgdTik
      apoloMsgStop( "El ticket " + cTextoTicket + " no esta pagado.", "Atención" )
      Return ( nil )
   end if 

   if apoloMsgNoYes( "¿ Desea realmente reabir el ticket " + cTextoTicket + "?" + ;
                     CRLF + ;
                     "Se eliminaran los pagos de este ticket y el ticket podrá ser modificado",;
                     "Confirme", .t. )

      CursorWait()

      ::oSender:oTpvCobros:EliminaCobros( cNumeroTicket ) 
      ::oSender:oTiketCabecera:fieldPutByName( "lPgdTik", .f. )

      CursorWE()

      ::OnClickListaTicket()

   end if 

Return ( nil )

//-------------------------------------------------------------------------//

METHOD OnClickFiltro() CLASS TpvListaTicket

   DEFINE DIALOG ::oDlgFiltro RESOURCE "Tpv_Filtro_Ticket"

      REDEFINE GET ::oGetFechaIni VAR ::dGetFechaIni;
         ID       100 ;
         SPINNER ;
         OF       ::oDlgFiltro

      REDEFINE BUTTONBMP ;
         ID       101 ;
         OF       ::oDlgFiltro ;
         BITMAP   "gc_calendar_16" ;
         ACTION   ( ::oGetFechaIni:cText( Calendario( ::dGetFechaIni ) ) )

      REDEFINE GET ::oGetFechaFin VAR ::dGetFechaFin;
         ID       110 ;
         SPINNER ;
         OF       ::oDlgFiltro

      REDEFINE BUTTONBMP ;
         ID       111 ;
         OF       ::oDlgFiltro ;
         BITMAP   "gc_calendar_16" ;
         ACTION   ( ::oGetFechaFin:cText( Calendario( ::dGetFechaFin ) ) )

      REDEFINE GET ::oGetUsuario VAR ::cUsuario ;
         ID       120 ;
         BITMAP   "lupa_24" ;
         OF       ::oDlgFiltro

      ::oGetUsuario:nMargin   := 25
      ::oGetUsuario:bValid    := {|| cUser( ::oGetUsuario, ::oSender:oUsuario:cAlias, ::oNombreUsuario ) }
      ::oGetUsuario:bHelp     := {|| BrwUserTactil( ::oGetUsuario, ::oSender:oUsuario:cAlias, ::oNombreUsuario ) }

      REDEFINE GET ::oNombreUsuario VAR ::cNombreUsuario ;
         ID       121 ;
         WHEN     ( .f. ) ;
         OF       ::oDlgFiltro

      REDEFINE GET ::oGetCliente VAR ::cCliente ;
         ID       130 ;
         BITMAP   "lupa_24" ;
         OF       ::oDlgFiltro

      ::oGetCliente:nMargin   := 25
      ::oGetCliente:bValid    := {|| cClient( ::oGetCliente, ::oSender:oCliente:cAlias, ::oCodigoCliente ) }
      ::oGetCliente:bHelp     := {|| BrwCliTactil( ::oGetCliente, ::oSender:oCliente:cAlias, ::oCodigoCliente ) }

      REDEFINE GET ::oCodigoCliente VAR ::cCodigoCliente ;
         ID       131 ;
         WHEN     ( .f. ) ;
         OF       ::oDlgFiltro

      REDEFINE GET ::oGetCaja VAR ::cCaja ;
         ID       140 ;
         BITMAP   "lupa_24" ;
         OF       ::oDlgFiltro

      ::oGetCaja:nMargin      := 25
      ::oGetCaja:bValid       := {|| cCajas( ::oGetCaja, ::oSender:oCajaCabecera:cAlias, ::oTextoCaja ) }
      ::oGetCaja:bHelp        := {|| BrwCajaTactil( ::oGetCaja, ::oSender:oCajaCabecera:cAlias, ::oTextoCaja ) }

      REDEFINE GET ::oTextoCaja VAR ::cTextoCaja ;
         ID       141 ;
         WHEN     ( .f. ) ;
         OF       ::oDlgFiltro

      REDEFINE COMBOBOX ::oGetTotal VAR ::cComparacionesTotales;
         ITEMS    ::aTotal ;
         ID       150 ;
         OF       ::oDlgFiltro

      REDEFINE GET ::oGetImporteTotal VAR ::nImporteTotal ;
         ID       151 ;
         PICTURE  ::oSender:cPictureTotal ;
         OF       ::oDlgFiltro ;

      REDEFINE COMBOBOX ::oGetUbicacion VAR ::cUbicacionTicket;
         ITEMS    ::aUbicacion ;
         ID       160 ;
         OF       ::oDlgFiltro

      REDEFINE BITMAP ::oBmpGeneral ;
         ID       500 ;
         RESOURCE "gc_funnel_48"  ;
         TRANSPARENT ;
         OF       ::oDlgFiltro

      REDEFINE BUTTONBMP ;
         BITMAP   "gc_check_32" ;
         ID       IDOK ;
         OF       ::oDlgFiltro ;
         ACTION   ( ::OnAceptarFiltro() )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       ::oDlgFiltro ;
         ACTION   ( ::oDlgFiltro:End() )

   ACTIVATE DIALOG ::oDlgFiltro CENTER

   if !Empty( ::oBmpGeneral )
      ::oBmpGeneral:End()
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD OnAceptarFiltro() CLASS TpvListaTicket

   local cFiltro  := ''

   ::oSender:oTiketCabecera:OrdSetFocus( "cNumTik" )

   if !Empty( ::dGetFechaIni )
      cFiltro     += 'Field->dFecTik >= ' + 'Ctod( "' + Rtrim( cValToChar( ::dGetFechaIni ) ) + '" )'
   end if

   if !Empty( ::dGetFechaFin )
      if !Empty( cFiltro )
         cFiltro  += ' .and. '
      end if
      cFiltro     += 'Field->dFecTik <= ' + 'Ctod( "' + Rtrim( cValToChar( ::dGetFechaFin ) ) + '" )'
   end if

   if !Empty( ::cUsuario )
      if !Empty( cFiltro )
         cFiltro  += ' .and. '
      end if
      cFiltro     += 'Field->cCcjTik == "' + ::cUsuario + '"'
   end if

   if !Empty( ::cCliente )
      if !Empty( cFiltro )
         cFiltro  += ' .and. '
      end if
      cFiltro     += 'Field->cCliTik == "' + ::cCliente + '"'
   end if

   if !Empty( ::cCaja )
      if !Empty( cFiltro )
         cFiltro  += ' .and. '
      end if
      cFiltro     += 'Field->cNcjTik == "' + ::cCaja + '"'
   end if

   if !Empty( ::cUbicacionTicket )

      if !Empty( cFiltro )
         cFiltro  += ' .and. '
      end if

      do case
         case ::cUbicacionTicket == "Mesas"
            cFiltro  += 'Field->nUbiTik == ' + Alltrim( Str( ubiSala ) )
         case ::cUbicacionTicket == "General"
            cFiltro  += 'Field->nUbiTik == ' + Alltrim( Str( ubiGeneral ) )
         case ::cUbicacionTicket == "Para recoger"
            cFiltro  += 'Field->nUbiTik == ' + Alltrim( Str( ubiRecoger ) )
         case ::cUbicacionTicket == "Para llevar"
            cFiltro  += 'Field->nUbiTik == ' + Alltrim( Str( ubiLlevar ) )
      end case

   end if

   if !Empty( ::cComparacionesTotales ) .and. !Empty( ::nImporteTotal )

      if !Empty( cFiltro )
         cFiltro  += ' .and. '
      end if

      do case
         case ::cComparacionesTotales == "Igual"
            cFiltro  += 'Field->nTotTik == Val( "' + Alltrim( Str( ::nImporteTotal ) ) + '" )'
         case ::cComparacionesTotales == "Distinto"
            cFiltro  += 'Field->nTotTik != Val( "' + Alltrim( Str( ::nImporteTotal ) ) + '" )'
         case ::cComparacionesTotales == "Menor"
            cFiltro  += 'Field->nTotTik <  Val( "' + Alltrim( Str( ::nImporteTotal ) ) + '" )'
         case ::cComparacionesTotales == "Menor o igual"
            cFiltro  += 'Field->nTotTik <= Val( "' + Alltrim( Str( ::nImporteTotal ) ) + '" )'
         case ::cComparacionesTotales == "Mayor"
            cFiltro  += 'Field->nTotTik >  Val( "' + Alltrim( Str( ::nImporteTotal ) ) + '" )'
         case ::cComparacionesTotales == "Mayor o igual"
            cFiltro  += 'Field->nTotTik >= Val( "' + Alltrim( Str( ::nImporteTotal ) ) + '" )'
      end case

   end if

   if Empty( cFiltro ) .or. ( Type( cFiltro ) != "UE" .and. Type( cFiltro ) == "UI" )

      msgStop( "Expresión " + Rtrim( cFiltro ) + " no valida" )

   else

      ::oDlgFiltro:Disable()

      CursorWait()

      ::oSender:oTiketCabecera:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oSender:oTiketCabecera:cFile ), ::oSender:oTiketCabecera:OrdKey(), ( cFiltro ), , , , , , , , .t. )
      ::oSender:oTiketCabecera:GoTop()

      ::oBtnAbiertos:UnSelected()
      ::oBtnTodos:UnSelected()
      ::oBtnFiltro:Selected()

      ::oBrwListaTicket:Refresh()
      ::oBrwListaTicket:SelectOne()

      CursorWE()

      ::oDlgFiltro:Enable()

   end if

   ::oDlgFiltro:End( IDOK )

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickTodos() CLASS TpvListaTicket

   CursorWait()

   ::UnSelectButtons()

   ::oBtnTodos:Selected()

   if file( ::oSender:oTiketCabecera:cFile )
      ::oSender:oTiketCabecera:IdxDelete( cCurUsr(), GetFileNoExt( ::oSender:oTiketCabecera:cFile ) )
   end if 

   ::oSender:oTiketCabecera:OrdSetFocus( "dFecTik" )
   ::oSender:oTiketCabecera:GoTop()

   CursorWE()

   ::oBrwListaTicket:Refresh()
   ::oBrwListaTicket:SelectOne()

   ::oDlg:cTitle( "Lista de tickets" )

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickAbiertos() CLASS TpvListaTicket

   ::UnSelectButtons()

   ::oBtnAbiertos:Selected()

   ::oSender:oTiketCabecera:OrdSetFocus( "lCloTik" )
   ::oSender:oTiketCabecera:GoTop()

   ::oBrwListaTicket:Refresh()
   ::oBrwListaTicket:SelectOne()

   ::oDlg:cTitle( "Lista de tickets: Tickets abiertos" )

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickMesas()

   CursorWait()

   ::UnSelectButtons()

   ::oBtnLstMesas:Selected()

   ::oSender:oTiketCabecera:OrdSetFocus( "lCloUbiTik" )
   ::oSender:oTiketCabecera:OrdScope( "2" )
   ::oSender:oTiketCabecera:GoTop()

   CursorWE()

   ::oBrwListaTicket:Refresh()
   ::oBrwListaTicket:SelectOne()

   ::oDlg:cTitle( "Lista de tickets: Tickets con ubicación" )

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickGeneral()

   CursorWait()

   ::UnSelectButtons()

   ::oBtnLstGeneral:Selected()

   ::oSender:oTiketCabecera:OrdSetFocus( "lCloUbiTik" )
   ::oSender:oTiketCabecera:OrdScope( "0" )
   ::oSender:oTiketCabecera:GoTop()

   CursorWE()

   ::oBrwListaTicket:Refresh()
   ::oBrwListaTicket:SelectOne()

   ::oDlg:cTitle( "Lista de tickets: Tickets generales sin ubicación" )

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickRecoger()

   CursorWait()

   ::UnSelectButtons()

   ::oBtnLstRecoger:Selected()

   ::oSender:oTiketCabecera:OrdSetFocus( "lCloUbiTik" )
   ::oSender:oTiketCabecera:OrdScope( "3" )
   ::oSender:oTiketCabecera:GoTop()

   CursorWE()

   ::oBrwListaTicket:Refresh()
   ::oBrwListaTicket:SelectOne()

   ::oDlg:cTitle( "Lista de tickets: Tickets para recoger" )

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickLlevar()

   CursorWait()

   ::UnSelectButtons()
   
   ::oBtnLstLlevar:Selected()

   ::oSender:oTiketCabecera:OrdSetFocus( "lCloUbiTik" )
   ::oSender:oTiketCabecera:OrdScope( "1" )
   ::oSender:oTiketCabecera:GoTop()

   CursorWE()

   ::oBrwListaTicket:Refresh()
   ::oBrwListaTicket:SelectOne()

   ::oDlg:cTitle( "Lista de tickets: Tickets para llevar" )

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickEncargar()

   CursorWait()

   ::UnSelectButtons()

   ::oBtnLstEncargar:Selected()

   ::oSender:oTiketCabecera:OrdSetFocus( "lCloUbiTik" )
   ::oSender:oTiketCabecera:OrdScope( "4" )
   ::oSender:oTiketCabecera:GoTop()

   CursorWE()

   ::oBrwListaTicket:Refresh()
   ::oBrwListaTicket:SelectOne()

   ::oDlg:cTitle( "Lista de tickets: Encargos" )

Return .t.

//---------------------------------------------------------------------------//

METHOD lPendientes() CLASS TpvListaTicket

   ::cNumeroTicket                     := nil 

   DEFINE DIALOG ::oDlg RESOURCE "Tpv_Ticket_Pendiente"

      ::oImageListPendiente            := TImageList():New( 32, 32 )

      ::oImageListPendiente:AddMasked( TBitmap():Define( "gc_cup_32",    ), Rgb( 255, 0, 255 ) )
      ::oImageListPendiente:AddMasked( TBitmap():Define( "gc_cash_register_32" ), Rgb( 255, 0, 255 ) )
      ::oImageListPendiente:AddMasked( TBitmap():Define( "gc_shopping_basket_32"   ), Rgb( 255, 0, 255 ) )
      ::oImageListPendiente:AddMasked( TBitmap():Define( "gc_motor_scooter_32"   ), Rgb( 255, 0, 255 ) )

      ::oListViewPendiente             := TListView():Redefine( 100, ::oDlg )

      ::oListViewPendiente:nOption     := 0
      ::oListViewPendiente:bClick      := {| nOpt | ::SelectPedientes( nOpt ) }

      ::oDlg:bStart                    := {|| ::StartPendientes() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::End()

Return .t.

//---------------------------------------------------------------------------//

METHOD StartPendientes() CLASS TpvListaTicket

   local oGrupo
   local oBoton
   local oCarpeta

   ::oOfficeBar            := TDotNetBar():New( 0, 0, 1020, 120, ::oDlg, 1 )

   ::oOfficeBar:lPaintAll  := .f.
   ::oOfficeBar:lDisenio   := .f.

   ::oOfficeBar:SetStyle( 1 )

   ::oDlg:oTop             := ::oOfficeBar

   oCarpeta                := TCarpeta():New( ::oOfficeBar, "Tickets pendientes" )

   oGrupo                  := TDotNetGroup():New( oCarpeta, 66, "Salida", .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "End32", "Salida", 1, {|| ::End() }, , , .f., .f., .f. )

   ::oListViewPendiente:SetImageList( ::oImageListPendiente )

   ::oListViewPendiente:SetIconSpacing( 160, 100 )

   ::oListViewPendiente:EnableGroupView()

   ::oListViewPendiente:InsertGroup( gprGeneral,      "General" )
   ::oListViewPendiente:InsertGroup( grpParaRecoger,  "Para recoger" )
   ::oListViewPendiente:InsertGroup( grpParaLlevar,   "Para llevar" )
   ::oListViewPendiente:InsertGroup( grpMesas,        "Mesas" )
   ::oListViewPendiente:InsertGroup( grpParaEncargar, "Encargo" )

   ::InsertUbicacionGeneral()

Return .t.

//---------------------------------------------------------------------------//

METHOD SelectPedientes( nOpt ) CLASS TpvListaTicket

   if ( nOpt != 0 )
      ::cNumeroTicket      := ::oListViewPendiente:aCargo[ nOpt ]
      ::oDlg:End()
   end if

Return ( Self )

//-------------------------------------------------------------------------//

METHOD InsertUbicacionGeneral() CLASS TpvListaTicket

   local oBlock
   local oError

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oSender:oTiketCabecera:GetStatus()

      ::oSender:oTiketCabecera:OrdSetFocus( "nUbiTik" )
      ::oSender:oTiketCabecera:GoTop()

      while !( ::oSender:oTiketCabecera:eof() )

         do case
            case ( ::oSender:oTiketCabecera:nUbiTik == ubiSala )
               ::oListViewPendiente:aAddItemGroup( 0, ::oSender:cInfoPendiente(), grpMesas, ::oSender:cNumeroTicket() )

            case ( ::oSender:oTiketCabecera:nUbiTik == ubiGeneral )
               ::oListViewPendiente:aAddItemGroup( 1, ::oSender:cInfoPendiente(), gprGeneral, ::oSender:cNumeroTicket() )

            case ( ::oSender:oTiketCabecera:nUbiTik == ubiRecoger )
               ::oListViewPendiente:aAddItemGroup( 2, ::oSender:cInfoPendiente(), grpParaRecoger, ::oSender:cNumeroTicket() )

            case ( ::oSender:oTiketCabecera:nUbiTik == ubiLlevar )
               ::oListViewPendiente:aAddItemGroup( 3, ::oSender:cInfoPendiente(), grpParaLlevar, ::oSender:cNumeroTicket() )

            case ( ::oSender:oTiketCabecera:nUbiTik == ubiEncargar )
               ::oListViewPendiente:aAddItemGroup( 4, ::oSender:cInfoPendiente(), grpParaEncargar, ::oSender:cNumeroTicket() )

         end case

         ::oSender:oTiketCabecera:Skip()

      end while

      ::oSender:oTiketCabecera:SetStatus()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible cargar las ventas pendientes" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//-------------------------------------------------------------------------//

METHOD lVales() CLASS TpvListaTicket

   local cCodigoCliente                   := ::oSender:oTiketCabecera:cCliTik

   if Empty( cCodigoCliente )
      MsgStop( "Cliente no puede estar vacio" )
      Return .f.
   end if

   ::nTotalSelect                         := 0

   ::oSender:oTiketCabecera:GetStatus()

   ::oSender:oTiketCabecera:OrdSetFocus( "cCliVal" )
   ::oSender:oTiketCabecera:OrdScope( cCodigoCliente )
   ::oSender:oTiketCabecera:GoTop()

   DEFINE DIALOG ::oDlg RESOURCE ( ::cResource ) TITLE "Lista de vales"

      ::oBrwListaTicket                   := IXBrowse():New( ::oDlg )

      ::oBrwListaTicket:lRecordSelector   := .f.
      ::oBrwListaTicket:lHScroll          := .f.
      ::oBrwListaTicket:lVScroll          := .t.
      ::oBrwListaTicket:nHeaderLines      := 2
      ::oBrwListaTicket:nDataLines        := 2
      ::oBrwListaTicket:cName             := "Tpv.Lista vales"
      ::oBrwListaTicket:nRowHeight        := 54

      ::oBrwListaTicket:nMarqueeStyle     := MARQSTYLE_HIGHLROWMS

      ::oBrwListaTicket:bClrSel           := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }
      ::oBrwListaTicket:bClrSelFocus      := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }

      ::oBrwListaTicket:bLDblClick        := {|| ::OnClickListaTicket() }
      ::oBrwListaTicket:Cargo             := {}
      ::oBrwListaTicket:lFooter           := .t.


      ::oSender:oTiketCabecera:SetBrowse( ::oBrwListaTicket )

      ::oBrwListaTicket:CreateFromResource( 100 )

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := ""
         :bStrData         := {|| "" }
         :bEditValue       := {|| aScan( ::oBrwListaTicket:Cargo, Eval( ::oBrwListaTicket:bBookMark ) ) > 0 }
         :nHeadBmpNo       := 3
         :nWidth           := 24
         :bLClickHeader    := {|| ::OnClickSelectTodosVales() }
         :SetCheck(        { "BSel", "Nil16" }, {|| ::OnClickSelectVales() } )
         :AddResource(     "BSel" )
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| ::oSender:oTiketCabecera:FieldGetByName( "cSerTik" ) + "/" + lTrim( ::oSender:oTiketCabecera:FieldGetByName( "cNumTik" ) ) + "/" + ::oSender:oTiketCabecera:FieldGetByName( "cSufTik" ) }
         :nWidth           := 90
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Sesión"
         :bEditValue       := {|| Trans( ::oSender:oTiketCabecera:FieldGetByName( "cTurTik" ), "######" ) }
         :nWidth           := 80
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Fecha" + CRLF + "Hora"
         :bEditValue       := {|| Dtoc( ::oSender:oTiketCabecera:FieldGetByName( "dFecTik" ) ) + CRLF + ::oSender:oTiketCabecera:FieldGetByName( "cHorTik" ) }
         :nWidth           := 100
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ::oSender:oTiketCabecera:FieldGetByName( "cNcjTik" ) }
         :nWidth           := 75
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ::oSender:oTiketCabecera:FieldGetByName( "cCcjTik" ) }
         :nWidth           := 75
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Estado"
         :bEditValue       := {|| ::oSender:cEstado() }
         :nWidth           := 90
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Cliente"
         :bEditValue       := {|| Rtrim( ::oSender:oTiketCabecera:FieldGetByName( "cCliTik" ) ) + CRLF + ::oSender:oTiketCabecera:FieldGetByName( "cNomTik" ) }
         :nWidth           := 280
         :bFooter          := {|| "Total vales seleccionados" }
      end with

      with object ( ::oBrwListaTicket:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ::oSender:oTiketCabecera:FieldGetByName( "nTotTik" ) }
         :bFooter          := {|| ::nTotalSelect }
         :cEditPicture     := ::oSender:cPictureTotal
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFootStrAlign    := 1
         :nWidth           := 100
      end with

      ::oDlg:bStart        := {|| ::StartVales() }

      ::oDlg:bResized      := {|| ::oBrwListaTicket:AdjClient() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::oSender:oTiketCabecera:SetStatus()

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD StartVales() CLASS TpvListaTicket

   local oBoton
   local oGrupo
   local oCarpeta

   if Empty( ::oOfficeBar )

      ::oOfficeBar            := TDotNetBar():New( 0, 0, 1020, 120, ::oDlg, 1 )

      ::oOfficeBar:lPaintAll  := .f.
      ::oOfficeBar:lDisenio   := .f.

      ::oOfficeBar:SetStyle( 1 )

      ::oDlg:oTop             := ::oOfficeBar

      oCarpeta                := TCarpeta():New( ::oOfficeBar, "Vales de cliente" )

      oGrupo                  := TDotNetGroup():New( oCarpeta, 186,  "Selección", .f., , "gc_check_32" )
         oBoton               := TDotNetButton():New( 60, oGrupo,    "gc_check_32",               "Seleccionar",        1, {|| ::OnClickSelectVales() }, , , .f., .f., .f. )
         oBoton               := TDotNetButton():New( 60, oGrupo,    "gc_checks_32",               "Todos",              2, {|| ::OnClickSelectTodosVales() }, , , .f., .f., .f. )
         oBoton               := TDotNetButton():New( 60, oGrupo,    "Del32",                   "Ninguno",            3, {|| ::OnClickSelectNingunoVales() }, , , .f., .f., .f. )

      oGrupo                  := TDotNetGroup():New( oCarpeta, 366,  "Seleción de tickets", .f. )
         ::oPrimeraLinea      := TDotNetButton():New( 60, oGrupo,    "gc_navigate_line_up_32",         "Primera línea",      1, {|| ::LineaPrimera() } )
         ::oUltimaLinea       := TDotNetButton():New( 60, oGrupo,    "gc_navigate_line_down_32",         "Última línea",       2, {|| ::LineaUltima() } )
         ::oAnteriorPagina    := TDotNetButton():New( 60, oGrupo,    "gc_navigate_up2a_32",            "Página anterior",    3, {|| ::PaginaAnterior() } )
         ::oSiguientePagina   := TDotNetButton():New( 60, oGrupo,    "gc_navigate_down2a_32",          "Página siguiente",   4, {|| ::PaginaSiguiente() } )
         ::oAnteriorLinea     := TDotNetButton():New( 60, oGrupo,    "gc_arrow_up_32",             "Línea anterior",     5, {|| ::LineaAnterior() } )
         ::oSiguienteLinea    := TDotNetButton():New( 60, oGrupo,    "gc_arrow_down_32",           "Línea siguiente",    6, {|| ::LineaSiguiente() } )

      oGrupo                  := TDotNetGroup():New( oCarpeta, 126,  "Salida", .f. )
         oBoton               := TDotNetButton():New( 60, oGrupo,    "gc_check_32",                "Aceptar",            1, {|| ::oDlg:End( IDOK ) }, , , .f., .f., .f. )
         oBoton               := TDotNetButton():New( 60, oGrupo,    "End32",                   "Salida",             2, {|| ::oDlg:End() }, , , .f., .f., .f. )

   end if

   ::oBrwListaTicket:Load()

Return ( nil )

//-------------------------------------------------------------------------//

METHOD OnClickSelectVales() CLASS TpvListaTicket

   local uBook       := Eval( ::oBrwListaTicket:bBookMark )
   local nScan       := aScan( ::oBrwListaTicket:Cargo, uBook )

   if nScan == 0
      aAdd( ::oBrwListaTicket:Cargo, uBook )
      ::nTotalSelect += ::oSender:oTiketCabecera:FieldGetByName( "nTotTik" )
   else
      aDel( ::oBrwListaTicket:Cargo, nScan, .t. )
      ::nTotalSelect -= ::oSender:oTiketCabecera:FieldGetByName( "nTotTik" )
   end if

   ::oBrwListaTicket:Refresh()

Return ( Self )

//-------------------------------------------------------------------------//

METHOD OnClickSelectTodosVales() CLASS TpvListaTicket

   local nAt               := 1
   local uBook

   CursorWait()

   ::nTotalSelect          := 0

   with object ( ::oBrwListaTicket )

      uBook                := Eval( :bBookMark )

      :Cargo               := Array( :KeyCount() )

      Eval( :bGoTop )
      while nAt <= :nLen
         :Cargo[ nAt++ ]   := Eval( :bBookMark )
         ::nTotalSelect    += ::oSender:oTiketCabecera:FieldGetByName( "nTotTik" )
         :Skip( 1 )
      enddo

      Eval( :bBookMark, uBook )

      :Refresh()

   end with

   CursorArrow()

Return ( Self )

//-------------------------------------------------------------------------//

METHOD OnClickSelectNingunoVales() CLASS TpvListaTicket

   CursorWait()

   ::nTotalSelect          := 0

   ::oBrwListaTicket:Cargo := {}
   ::oBrwListaTicket:Refresh()

   CursorArrow()

Return ( Self )

//-------------------------------------------------------------------------//

METHOD OnClickAceptarVales() CLASS TpvListaTicket

   local u

   for each u in ( ::oBrwListaTicket:Cargo )
      ? u
   next

   ::End()

Return ( Self )

//-------------------------------------------------------------------------//

METHOD Imprimir( lPrevisualizar )

   DEFAULT lPrevisualizar  := .f.

   if lPrevisualizar
      ::oSender:PrevisualizaTicket()
   else
      ::oSender:ImprimeTicket()
   end if

Return ( self )   

//-------------------------------------------------------------------------//

METHOD UnSelectButtons()

   if !Empty( ::oBtnAbiertos )
      ::oBtnAbiertos:UnSelected()
   end if

   if !Empty( ::oBtnTodos )
      ::oBtnTodos:UnSelected()
   end if 

   if !Empt( ::oBtnFiltro )
      ::oBtnFiltro:UnSelected()
   end if 
   
   if !Empty( ::oBtnLstGeneral )
      ::oBtnLstGeneral:UnSelected()
   end if 

   if !Empty( ::oBtnLstMesas )
      ::oBtnLstMesas:UnSelected()
   end if 

   if !Empty( ::oBtnLstRecoger )
      ::oBtnLstRecoger:UnSelected()
   end if 

   if !Empty( ::oBtnLstLlevar )
      ::oBtnLstLlevar:UnSelected()
   end if 

   if !Empty( ::oBtnLstEncargar )
      ::oBtnLstEncargar:UnSelected()
   end if 

Return ( self )   

//-------------------------------------------------------------------------//

