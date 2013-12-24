#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"
#include "Xbrowse.ch"

#define exitAceptarRegalo           1
#define exitAceptarImprimir         2
#define exitAceptar                 3
#define exitCancelar                4
#define exitAceptarDesglosado       5

#define ubiGeneral                  0
#define ubiLlevar                   1
#define ubiSala                     2
#define ubiRecoger                  3
#define ubiEncargar                 4

#define documentoTicket             1
#define documentoAlbaran            2
#define documentoFactura            3

#define estadoParcial               1
#define estadoPagado                2

static oThis

//---------------------------------------------------------------------------//

CLASS TpvCobros  

   DATA oDlg
   DATA oSender
   DATA sTotalesCobros

   DATA aButtonsMoney
   DATA oBtnLimpiarTexto
   DATA oBtnAddCobro
   DATA oBtnTipoImpresion
   DATA oBtnAceptar
   DATA oBtnCalcMoney

   DATA oTextoTotal
   DATA cTextoTotal

   DATA oGetEntregado
   DATA cGetEntregado      INIT Space( 25 )

   DATA aFormasdePago

   DATA oBrwPago
   DATA oBrwFormasPago

   DATA nExit

   DATA nSalidaImpresora
   DATA cBmpSalidaImpresora

   DATA lEfectivoMoney

   DATA cResource

   DATA oDlg

   DATA cCodigoFormaPago

   DATA oGrupoCobro

   DATA lClickMoneda       INIT .f.

   DATA aCobros            INIT {}

   DATA nUbiTik            INIT ubiGeneral

   DATA nEstado            INIT estadoPagado

   METHOD New( oSender ) CONSTRUCTOR

   METHOD End()

   METHOD lCobro()

   METHOD lCobroExacto()

   METHOD lCobroExactoTicket()
   METHOD lCobroExactoAlbaran()

   METHOD lResource()
   METHOD StartResource()

   METHOD ClickBotonCobro( oBtnPago )

   METHOD ValidTotalesCobro()
   METHOD CreateButtonsCobro()
   METHOD nButtonsCobro( oGrupo )

   //------------------------------------------------------------------------//

   INLINE METHOD PushCalculadora( cTexto )

      ::cGetEntregado               := AllTrim( ::cGetEntregado ) + cTexto

      if !Empty( ::oGetEntregado )
         ::oGetEntregado:Refresh()
      end if   

      RETURN ( Self )

   ENDMETHOD

   //------------------------------------------------------------------------//

   INLINE METHOD PushMoney( nImporte )

      if !::lClickMoneda
         ::sTotalesCobros:nCobrado  := 0
         ::cGetEntregado            := Space( 25 )
      end if

      ::cGetEntregado               := Trans( Val( ::cGetEntregado ) + nImporte, ::oSender:cPictureTotal )

      if !Empty( ::oGetEntregado )
         ::oGetEntregado:Refresh()
      end if   

      ::lClickMoneda                := .t.

      RETURN ( Self )

   ENDMETHOD

   //------------------------------------------------------------------------//

   INLINE METHOD OnClickReset()

      ::cGetEntregado               := Space( 25 )

      if !Empty( ::oGetEntregado )
         ::oGetEntregado:Refresh()
      end if

      RETURN ( Self )

   ENDMETHOD

   //------------------------------------------------------------------------//

   METHOD OnClickCalculadora()      INLINE ( Calculadora( 0, ::sTotalesCobros:oCobrado ), ::sTotalesCobros:Recalcula()  )
   METHOD OnClickFormadePago( oBoton )

   //------------------------------------------------------------------------//

   METHOD CreaCobro()
   METHOD EliminaCobro()            INLINE ( aDel( ::aCobros, ::oBrwPago:nArrayAt, .t. ) )
   METHOD ValidCobro()

   METHOD CargaCobros( cNumeroTicket )
   METHOD EliminaCobros()
   METHOD GuardaCobros()

   //------------------------------------------------------------------------//

   INLINE METHOD OnClickAnnadirCobro()

      ::sTotalesCobros:nCobrado     := Val( ::cGetEntregado )

      ::CreaCobro()

      ::sTotalesCobros:nEntregado   := ::nTotal()

      ::sTotalesCobros:SetCobrado()
      ::sTotalesCobros:Recalcula()
      ::sTotalesCobros:Refresh()

      ::cGetEntregado               := Space( 25 )

      if !Empty( ::oGetEntregado )
         ::oGetEntregado:Refresh()
      end if

      ::oBrwPago:Refresh()

      ::SetTextoTotal()

      RETURN ( Self )

   ENDMETHOD

   //------------------------------------------------------------------------//

   INLINE METHOD OnClickEliminarCobro()

      if ApoloMsgNoYes( , , .t.)

            ::EliminaCobro()

            ::sTotalesCobros:nEntregado   := ::nTotal()

            ::sTotalesCobros:SetCobrado()
            ::sTotalesCobros:Recalcula()
            ::sTotalesCobros:Refresh()

            ::oBrwPago:Refresh()

            ::SetTextoTotal()

      end if      

      RETURN ( Self )

   ENDMETHOD

   //------------------------------------------------------------------------//

   INLINE METHOD OnClickAceptar( nExit )

      ::oDlg:Disable()

      if ::oSender:nTipoDocumento != documentoAlbaran

         ::ValidTotalesCobro()

         if ::nUbiTik == ubiEncargar

            if ( ::sTotalesCobros:nTotal ) > ( ::sTotalesCobros:nCobrado + ::sTotalesCobros:nEntregado )
               ::nEstado   := estadoParcial
            else
               ::nEstado   := estadoPagado
            end if

            ::CreaCobro()

            ::nExit        := nExit

         else

            if ::ValidCobro()

               ::CreaCobro()

               ::nEstado   := estadoPagado
               ::nExit     := nExit

            end if

         end if

      else

         ::nExit           := nExit
         
      end if   

      ::oDlg:Enable()
      ::oDlg:End( IDOK )

      RETURN ( Self )

   ENDMETHOD

   //------------------------------------------------------------------------//

   METHOD OnClickAnnadirVales()

   //------------------------------------------------------------------------//

   METHOD nTotal()
   METHOD nTotalCobro()
   METHOD nTotalCambio()

   METHOD InitCobros()                    INLINE ( ::aCobros := {} )

   METHOD CargaFormasdePago()

   METHOD RedefineButtonsMoney() 
   METHOD RedefineBrowsePagos()
   METHOD RedefineBrowseFormasdePago()

   METHOD ChangeButtonsFormaPago( cTipo )

   METHOD ChangeFormaPago()               INLINE ::ChangeButtonsFormaPago( if( ::oBrwFormasPago:aRow[ "lEfectivo" ], "Money", "Calculadora" ), ::oBrwFormasPago:aRow[ "lEfectivo" ] )

   METHOD RedefineSayTotal()

   METHOD RedefineButtonLimpieza()

   METHOD RedefineButtonAddCobro()
   
   METHOD RedefineButtonTipoImpresion()

   METHOD RedefineButtonChangeCalcMoney()
   
   METHOD RedefineButtonAceptar()

   METHOD RedefineGetEntrega()

   METHOD SetTextoTotal()

   METHOD ChangeBtnImpresion()

   METHOD ChangeCalcMoney()

   METHOD SalidaImpresoraDefecto()

//---------------------------------------------------------------------------//

END CLASS

//--------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TpvCobros

   ::oSender                  := oSender

   ::InitCobros()

   /*if oUser():lUsrZur()
      ::cResource             := "BIG_COBRO_RIGHT"
   else
      ::cResource             := "BIG_COBRO_RIGHT"
   end if*/

   ::cResource                := "NEWCOBRO"

   ::sTotalesCobros           := STotalCobros()

   ::SalidaImpresoraDefecto()
   
   ::lEfectivoMoney           := .t.

   ::SetTextoTotal()

   ::aButtonsMoney            := {  {  "Id" => 170,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "50", "Action" => {|| ::PushMoney( 50 ) } },;
                                       "Calculadora" => { "Text" => "7", "Action" => {|| ::PushCalculadora( "7" ) } } },;
                                    {  "Id" => 180,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "20", "Action" => {|| ::PushMoney( 20 ) } },;
                                       "Calculadora" => { "Text" => "8", "Action" => {|| ::PushCalculadora( "8" ) } } },;   
                                    {  "Id" => 190,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "10", "Action" => {|| ::PushMoney( 10 ) } },;
                                       "Calculadora" => { "Text" => "9", "Action" => {|| ::PushCalculadora( "9" ) } } },;   
                                    {  "Id" => 200,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "5", "Action" => {|| ::PushMoney( 5 ) } },;
                                       "Calculadora" => { "Text" => "4", "Action" => {|| ::PushCalculadora( "4" ) } } },;   
                                    {  "Id" => 210,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "2", "Action" => {|| ::PushMoney( 2 ) } },;
                                       "Calculadora" => { "Text" => "5", "Action" => {|| ::PushCalculadora( "5" ) } } },;   
                                    {  "Id" => 220,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "1", "Action" => {|| ::PushMoney( 1 ) } },;
                                       "Calculadora" => { "Text" => "6", "Action" => {|| ::PushCalculadora( "6" ) } } },;   
                                    {  "Id" => 230,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "0.50", "Action" => {|| ::PushMoney( 0.50 ) } },;
                                       "Calculadora" => { "Text" => "1", "Action" => {|| ::PushCalculadora( "1" ) } } },;   
                                    {  "Id" => 240,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "0.20", "Action" => {|| ::PushMoney( 0.20 ) } },;
                                       "Calculadora" => { "Text" => "2", "Action" => {|| ::PushCalculadora( "2" ) } } },;   
                                    {  "Id" => 250,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "0.10", "Action" => {|| ::PushMoney( 0.10 ) } },;
                                       "Calculadora" => { "Text" => "3", "Action" => {|| ::PushCalculadora( "3" ) } } },;      
                                    {  "Id" => 260,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "0.05", "Action" => {|| ::PushMoney( 0.05 ) } },;
                                       "Calculadora" => { "Text" => "0", "Action" => {|| ::PushCalculadora( "0" ) } } },;         
                                    {  "Id" => 270,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "0.02", "Action" => {|| ::PushMoney( 0.02 ) } },;
                                       "Calculadora" => { "Text" => ".", "Action" => {|| ::PushCalculadora( "." ) } } },;   
                                    {  "Id" => 280,;
                                       "Object" => nil,;
                                       "Money" => { "Text" => "0.01", "Action" => {|| ::PushMoney( 0.01 ) } },;
                                       "Calculadora" => { "Text" => "", "Action" => {|| ::PushCalculadora( "" ) } } } }

Return Self

//--------------------------------------------------------------------------//

METHOD End() CLASS TpvCobros

   if !Empty( ::oDlg )
      ::oDlg:End()
   end if

   ::oDlg               := nil

Return Self

//--------------------------------------------------------------------------//

METHOD lCobro() CLASS TpvCobros
   
   /*
   Provisional para ponerselo al bollito---------------------------------------
   */

   if lImporteExacto()

      Return ::lCobroExacto()

   else

      Return ::lResource()

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD lCobroExacto() CLASS TpvCobros

   do case
      case ::oSender:nTipoDocumento == documentoAlbaran
         ::lCobroExactoAlbaran()

      otherwise
         ::lCobroExactoTicket()

   end case

Return .t.

//---------------------------------------------------------------------------//

METHOD lCobroExactoTicket() CLASS TpvCobros

   ::nUbiTik                  := ::oSender:oTiketCabecera:nUbiTik

   ::cCodigoFormaPago         := ::oSender:oTiketCabecera:cFpgTik

   ::sTotalesCobros:GetTotal( ::oSender:sTotal )

   ::sTotalesCobros:nCobrado  := ::sTotalesCobros:nTotal

   ::CreaCobro()

   ::nEstado                  := estadoPagado

   ::nExit                    := exitAceptar

Return .t.

//---------------------------------------------------------------------------//

METHOD lCobroExactoAlbaran() CLASS TpvCobros

   ::nExit                    := exitAceptarImprimir

Return .t.

//---------------------------------------------------------------------------//

METHOD lResource() CLASS TpvCobros

   local n
   local aFPago         := {}

   /*
   Cargamos las formas de pago para mostrarlas en el browse--------------------
   */

   ::CargaFormasdePago()

   /*
   Tomamos valores por defecto-------------------------------------------------
   */

   ::nUbiTik            := ::oSender:oTiketCabecera:nUbiTik

   ::lClickMoneda       := .f.

   ::sTotalesCobros:GetTotal( ::oSender:sTotal )

   if uFieldEmpresa( "lTotTikCob" )
      ::cGetEntregado         := Trans( ::sTotalesCobros:nCobrado, ::oSender:cPictureTotal )
   end if

   DEFINE DIALOG ::oDlg RESOURCE ::cResource TITLE ::oSender:cTipoDocumento() FONT ::oSender:oFntDlg

      /*
      SAY con la imformación de los cobros-------------------------------------
      */

      ::RedefineSayTotal()

      /*
      Boton para cambiar el tipo de impresión----------------------------------
      */

      ::RedefineButtonTipoImpresion()

      /*
      Boton de finalizar el cobro----------------------------------------------
      */

      ::RedefineButtonAceptar()

      /*
      Browse con los diferentes pagos------------------------------------------
      */

      ::RedefineBrowsePagos()

      /*
      Browse con las formas de pago--------------------------------------------
      */

      ::RedefineBrowseFormasdePago() 

      /*
      Caja de texto para escribir la cantidad----------------------------------
      */

      ::RedefineGetEntrega()

      /*
      Boton para limpiar la caja de texto--------------------------------------
      */

      ::RedefineButtonLimpieza()

      /*
      Botones del teclado------------------------------------------------------
      */

      ::RedefineButtonsMoney()

      /*
      Boton cambiar teclado de monedas a calculadora---------------------------
      */

      ::RedefineButtonChangeCalcMoney()

      /*
      Boton de validar la cantidad introducida---------------------------------
      */

      ::RedefineButtonAddCobro()

   ::oDlg:bStart  := {|| ::SetTextoTotal() }

   /*
   Activamos el dialogo--------------------------------------------------------
   */

   ACTIVATE DIALOG ::oDlg CENTER
 
   if !Empty( ::oBrwPago )
      ::oBrwPago:End()
   end if

   if !Empty( ::oBrwFormasPago )
      ::oBrwFormasPago:End()
   end if

   ::oBrwPago              := nil
   ::oBrwFormasPago        := nil
   
Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD RedefineSayTotal() CLASS TpvCobros

   REDEFINE SAY ::oTextoTotal ;
         VAR      ::cTextoTotal ;
         ID       100 ;
         OF       ::oDlg

Return ( Self )

//---------------------------------------------------------------------------//

METHOD RedefineButtonsMoney() CLASS TpvCobros

Return ( AEval( ::aButtonsMoney, {|h| h[ "Object" ] := TButton():ReDefine( h[ "Id" ], h[ "Money", "Action" ], ::oDlg ) } ) )

//---------------------------------------------------------------------------//

METHOD RedefineGetEntrega() CLASS TpvCobros

   REDEFINE GET ::oGetEntregado ;
      VAR      ::cGetEntregado ;
      ID       150 ;
      OF       ::oDlg

Return ( Self )

//---------------------------------------------------------------------------//

METHOD RedefineButtonLimpieza() CLASS TpvCobros

   ::oBtnLimpiarTexto := TButton():ReDefine( 160, {|| ::OnClickReset() }, ::oDlg )

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD RedefineButtonAddCobro() CLASS TpvCobros

   ::oBtnAddCobro := TButtonBmp():ReDefine( 290, {|| ::OnClickAnnadirCobro() }, ::oDlg,,, .F.,,,, .F., "NEW32",, )

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD RedefineButtonChangeCalcMoney() CLASS TpvCobros

   ::oBtnCalcMoney := TButtonBmp():ReDefine( 300, {|| ::ChangeCalcMoney() }, ::oDlg,,, .F.,,,, .F., "Calculator_32",, )

Return ( Self )

//---------------------------------------------------------------------------//
   
METHOD RedefineButtonTipoImpresion() CLASS TpvCobros

   ::oBtnTipoImpresion := TButtonBmp():ReDefine( 110, {|| ::ChangeBtnImpresion() }, ::oDlg,,, .F.,,,, .F., ::cBmpSalidaImpresora,, )

Return ( Self )

//---------------------------------------------------------------------------//
   
METHOD RedefineButtonAceptar() CLASS TpvCobros

   ::oBtnAceptar := TButtonBmp():ReDefine( 120, {|| ::OnClickAceptar( ::nSalidaImpresora ) }, ::oDlg,,, .F.,,,, .F., "Check_32",, )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD RedefineBrowsePagos() CLASS TpvCobros

   ::oBrwPago                 := TXBrowse():New( ::oDlg )
   ::oBrwPago:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwPago:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   ::oBrwPago:lVScroll        := .t.
   ::oBrwPago:lHScroll        := .f.
   ::oBrwPago:nMarqueeStyle   := 5
   ::oBrwPago:lHeader         := .f.
   ::oBrwPago:lFooter         := .f.
   ::oBrwPago:lRecordSelector := .f.

   ::oBrwPago:SetArray( ::aCobros, , , .f. )

   with object ( ::oBrwPago:AddCol() )
      :cHeader                := "Pago"
      :bEditValue             := {|| ::aCobros[ ::oBrwPago:nArrayAt ]:cTexto }
      :nWidth                 := 210
   end with

   with object ( ::oBrwPago:AddCol() )
      :cHeader                := "Importe"
      :bEditValue             := {|| ::aCobros[ ::oBrwPago:nArrayAt ]:nImporte }
      :cEditPicture           := ::oSender:cPictureTotal
      :nWidth                 := 150
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
   end with

   with object ( ::oBrwPago:AddCol() )
      :cHeader             := "Restar unidades"
      :bStrData            := {|| "" }
      :bOnPostEdit         := {|| .t. }
      :bEditBlock          := {|| ::OnClickEliminarCobro() }
      :nEditType           := 5
      :nWidth              := 40
      :nBtnBmp             := 1
      :nHeadBmpAlign       := 1
      :AddResource( "Delete2_24" )
   end with

   ::oBrwPago:CreateFromResource( 130 )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD RedefineBrowseFormasdePago() CLASS TpvCobros

   local cResFormaPago
   local aResFormaPago              := aMiddleResourceFormaPago()

   ::oBrwFormasPago                 := TXBrowse():New( ::oDlg )
   ::oBrwFormasPago:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwFormasPago:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   ::oBrwFormasPago:lVScroll        := .f.
   ::oBrwFormasPago:lHScroll        := .f.
   ::oBrwFormasPago:nMarqueeStyle   := 5
   ::oBrwFormasPago:lHeader         := .f.
   ::oBrwFormasPago:lFooter         := .f.
   ::oBrwFormasPago:lRecordSelector := .f.

   ::oBrwFormasPago:SetArray( ::aFormasdePago, , , .f. )

   ::oBrwFormasPago:bChange := {|| ::ChangeFormaPago() }

   ::oBrwFormasPago:CreateFromResource( 140 )
   
   with object ( ::oBrwFormasPago:AddCol() )
      :cHeader          := "Imagen"
      :bBmpData         := {|| ::oBrwFormasPago:aRow[ "Imagen" ] }
      :nWidth           := 24

      for each cResFormaPago in aResFormaPago
         :AddResource( cResFormaPago )
      next

   end with

   with object ( ::oBrwFormasPago:AddCol() )
      :cHeader          := "Forma"
      :bEditValue       := {|| ::oBrwFormasPago:aRow[ "Descripcion" ] }
      :nWidth           := 90
   end with

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ChangeBtnImpresion() CLASS TpvCobros

   do case
      case ::nSalidaImpresora == exitAceptar

         ::nSalidaImpresora   := exitAceptarImprimir
         ::oBtnTipoImpresion:LoadBitmap( "printer_ok" )
         ::oBtnTipoImpresion:Refresh()


      case ::nSalidaImpresora == exitAceptarImprimir

         ::nSalidaImpresora   := exitAceptarRegalo
         ::oBtnTipoImpresion:LoadBitmap( "printer_new" )
         ::oBtnTipoImpresion:Refresh()


      case ::nSalidaImpresora == exitAceptarRegalo

         ::nSalidaImpresora   := exitAceptar
         ::oBtnTipoImpresion:LoadBitmap( "printer_delete" )
         ::oBtnTipoImpresion:Refresh()

   end case

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SalidaImpresoraDefecto CLASS TpvCobros

   do case
      case uFieldEmpresa( "nTipImpTpv" ) <= 1
      
         ::nSalidaImpresora      := exitAceptar
         ::cBmpSalidaImpresora   := "printer_delete"

      case uFieldEmpresa( "nTipImpTpv" ) == 2
         
         ::nSalidaImpresora      := exitAceptarImprimir
         ::cBmpSalidaImpresora   := "printer_ok"

      otherwise
         
         ::nSalidaImpresora      := exitAceptarRegalo
         ::cBmpSalidaImpresora   := "printer_new"

   end case

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetTextoTotal() CLASS TpvCobros

   do case
      case ::sTotalesCobros:nCobrado < 0

         if !Empty( ::oTextoTotal )
            ::oTextoTotal:SetText( "Cambio: " + AllTrim( Trans( Abs( ::sTotalesCobros:nCobrado ), ::oSender:cPictureTotal ) ) )
         end if

         ::cTextoTotal  := "Cambio: " + AllTrim( Trans( Abs( ::sTotalesCobros:nCobrado ), ::oSender:cPictureTotal ) )

      case ::sTotalesCobros:nCobrado == 0

         if Len( ::aCobros ) == 0

           if !Empty( ::oTextoTotal )
               ::oTextoTotal:SetText( "Pendiente: " + AllTrim( Trans( ::sTotalesCobros:nCobrado, ::oSender:cPictureTotal ) ) )
            end if

            ::cTextoTotal  := "Pendiente: " + AllTrim( Trans( ::sTotalesCobros:nCobrado, ::oSender:cPictureTotal )  )

         else

            if !Empty( ::oTextoTotal )
               ::oTextoTotal:SetText( "Importe exaxto" )
            end if

            ::cTextoTotal  := "Importe exaxto"

         end if   

      case ::sTotalesCobros:nCobrado > 0      

         if !Empty( ::oTextoTotal )
            ::oTextoTotal:SetText( "Pendiente: " + AllTrim( Trans( ::sTotalesCobros:nCobrado, ::oSender:cPictureTotal ) ) )
         end if

         ::cTextoTotal  := "Pendiente: " + AllTrim( Trans( ::sTotalesCobros:nCobrado, ::oSender:cPictureTotal ) )

   end case   

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD CargaFormasdePago CLASS TpvCobros

   ::aFormasdePago      := {}

   if ( ::oSender:oFormaPago:Used() )

      ::oSender:oFormaPago:GetStatus()

      ::oSender:oFormaPago:OrdSetFocus( "nPosTpv" )

      ::oSender:oFormaPago:GoTop()
      while !::oSender:oFormaPago:eof()

         aAdd( ::aFormasdePago, { "Codigo" => ::oSender:oFormaPago:cCodPago,;
                                  "Descripcion" => Rtrim( ::oSender:oFormaPago:cDesPago ),;
                                  "lEfectivo" => ( ::oSender:oFormaPago:nTipPgo <= 1 ) ,;
                                  "Imagen" => ::oSender:oFormaPago:nImgTpv } )

         ::oSender:oFormaPago:Skip()

      end while

      ::oSender:oFormaPago:SetStatus()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ChangeButtonsFormaPago( cTipo, lEfectivo ) CLASS TpvCobros

    AEval( ::aButtonsMoney, {|h| h[ "Object" ]:bAction := h[ cTipo, "Action" ], SetWindowText( h[ "Object" ]:hWnd, h[ cTipo, "Text" ] ) } )

    if !Empty( ::oBtnCalcMoney )

      if lEfectivo
         ::oBtnCalcMoney:Show()
         ::lEfectivoMoney := .t.
      else
         ::oBtnCalcMoney:Hide()
      end if

      ::oBtnCalcMoney:Refresh()

   end if

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD ChangeCalcMoney CLASS TpvCobros

   if ::lEfectivoMoney
      AEval( ::aButtonsMoney, {|h| h[ "Object" ]:bAction := h[ "Calculadora", "Action" ], SetWindowText( h[ "Object" ]:hWnd, h[ "Calculadora", "Text" ] ) } )
      ::oBtnCalcMoney:LoadBitmap( "Money2_32" )
      ::oBtnCalcMoney:Refresh()
   else
      AEval( ::aButtonsMoney, {|h| h[ "Object" ]:bAction := h[ "Money", "Action" ], SetWindowText( h[ "Object" ]:hWnd, h[ "Money", "Text" ] ) } )
      ::oBtnCalcMoney:LoadBitmap( "Calculator_32" )
      ::oBtnCalcMoney:Refresh()
   end if   

   ::lEfectivoMoney := !::lEfectivoMoney

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ClickBotonCobro( oBtnCobro ) CLASS TpvCobros

   aEval( ::aCobros, {|o| o:oButton:lBtnDown := .f., o:oButton:Refresh() } )

   oBtnCobro:lBtnDown      := .t.

   if !oBtnCobro:Cargo:lEfectivo
      aEval( ::aButtonsMoney, {|o| o:Hide() } )
   else
      aEval( ::aButtonsMoney, {|o| o:Show() } )
   end if

   ::cCodigoFormaPago      := oBtnCobro:Cargo

Return ( nil )

//-------------------------------------------------------------------------//

METHOD StartResource() CLASS TpvCobros

   local oBoton
   local oGrupo
   local oCarpeta
   local oGrupoImprimir

   ::oOfficeBar            := TDotNetBar():New( 0, 0, 1020, 120, ::oDlg, 1 )

   ::oOfficeBar:lPaintAll  := .f.
   ::oOfficeBar:lDisenio   := .f.

   ::oOfficeBar:SetStyle( 1 )

   oCarpeta                := TCarpeta():New( ::oOfficeBar, "Gestión de cobros" )

   ::oGrupoCobro              := TDotNetGroup():New( oCarpeta, ( ( ::nButtonsCobro() * 60 ) + 6 ), "Formas", .f. )
      ::CreateButtonsCobro()

   if ::oSender:nTipoDocumento != documentoAlbaran
      oGrupo                  := TDotNetGroup():New( oCarpeta, 66,   "Vales", .f. )
                                 TDotNetButton():New( 60, oGrupo,    "Document_Money2_32",               "Liquidar vales",     1, {|| ::OnClickAnnadirVales() }, , , .f., .f., .f. )
   end if                              

   oGrupo                     := TDotNetGroup():New( oCarpeta, 126,  "Cobro combinado", .f. )
                                 TDotNetButton():New( 60, oGrupo,    "Money2_Add2_32",                   "Añadir cobro",       1, {|| ::OnClickAnnadirCobro() }, , , .f., .f., .f. )
                                 TDotNetButton():New( 60, oGrupo,    "Money2_Minus_32",                  "Eliminar cobro",     2, {|| ::OnClickEliminarCobro() }, , , .f., .f., .f. )

   
   if ::oSender:nTipoDocumento != documentoAlbaran

      oGrupoImprimir          := TDotNetGroup():New( oCarpeta, 186,  "Imprimir", .f. )
                                 TDotNetButton():New( 60, oGrupoImprimir,   "Check2_Printer2_32",        "Aceptar [F6]",       1, {|| ::OnClickAceptar( exitAceptarImprimir ) }, , , .f., .f., .f. )
                                 TDotNetButton():New( 60, oGrupoImprimir,   "package_new_printer2_32",   "Aceptar regalo",     2, {|| ::OnClickAceptar( exitAceptarRegalo ) }, , , .f., .f., .f. )
                                 TDotNetButton():New( 60, oGrupoImprimir,   "document_text_printer2_32", "Aceptar desglosado", 3, {|| ::OnClickAceptar( exitAceptarDesglosado ) }, , , .f., .f., .f. )

   else

      oGrupoImprimir          := TDotNetGroup():New( oCarpeta, 66,  "Imprimir", .f. )
                                 TDotNetButton():New( 60, oGrupoImprimir,   "Check2_Printer2_32",        "Aceptar [F6]",       1, {|| ::OnClickAceptar( exitAceptarImprimir ) }, , , .f., .f., .f. )
   
   end if                              
                              
   oGrupo                     := TDotNetGroup():New( oCarpeta, 66,  "No imprimir", .f. ) 
                              
                                 TDotNetButton():New( 60, oGrupo,   "Check_32",                          "Aceptar F5]",       1, {|| ::OnClickAceptar( exitAceptar ) }, , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 66,  "Salida", .f. )
                              
                                 TDotNetButton():New( 60, oGrupo,   "End32",                             "Salida",             1, {|| ::oDlg:End() }, , , .f., .f., .f. )

   ::oDlg:oTop                := ::oOfficeBar
   
Return .t.

//-------------------------------------------------------------------------//

METHOD ValidTotalesCobro() CLASS TpvCobros

   ::sTotalesCobros:nCambio   := - ( ::sTotalesCobros:nTotal - ::sTotalesCobros:nEntregado - ::sTotalesCobros:nCobrado )

   ::sTotalesCobros:Refresh()

Return .t.

//---------------------------------------------------------------------------//

METHOD CreateButtonsCobro() CLASS TpvCobros

   local n                       := 1
   local oBoton
   local aBigResourceFormaPago   := aBigResourceFormaPago()
   local aPressResourceFormaPago := aPressResourceFormaPago()

   if ( ::oSender:oFormaPago:Used() )

      ::oSender:oFormaPago:GetStatus()

      ::oSender:oFormaPago:OrdSetFocus( "nPosTpv" )

      ::oSender:oFormaPago:GoTop()
      while !::oSender:oFormaPago:eof()

         oBoton                  := TDotNetButton():New( 60, ::oGrupoCobro, aBigResourceFormaPago[ Min( Max( ::oSender:oFormaPago:nImgTpv, 1 ), len( aBigResourceFormaPago ) ) ], Rtrim( ::oSender:oFormaPago:cDesPago ), n, {| oBoton | ::OnClickFormadePago( oBoton ) }, , , .f., .f., .f. )
         oBoton:Cargo            := SButtonCobros()
         oBoton:Cargo:cCodigo    := ::oSender:oFormaPago:cCodPago
         oBoton:Cargo:cTexto     := Rtrim( ::oSender:oFormaPago:cDesPago )
         oBoton:Cargo:lEfectivo  := ::oSender:oFormaPago:nTipPgo <= 1

         oBoton:lSelected        := ( n == 1 )

         n++

         ::oSender:oFormaPago:Skip()

      end while

      ::oSender:oFormaPago:SetStatus()

   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD nButtonsCobro( oGrupo ) CLASS TpvCobros

   local nButtons          := 0

   if ( ::oSender:oFormaPago:Used() )

      ::oSender:oFormaPago:GetStatus()
      ::oSender:oFormaPago:OrdSetFocus( "nPosTpv" )

      nButtons             := ::oSender:oFormaPago:OrdKeyCount()

      ::oSender:oFormaPago:SetStatus()

   end if

RETURN ( nButtons )

//---------------------------------------------------------------------------//

METHOD ValidCobro() CLASS TpvCobros

   if ( ::sTotalesCobros:nTotal ) > ( ::sTotalesCobros:nCobrado + ::sTotalesCobros:nEntregado )

      msgStop( "Importe insuficiente " )

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickFormadePago( oBoton ) CLASS TpvCobros

   if !Empty( ::oGrupoCobro )
      aSend( ::oGrupoCobro:aItems, "UnSelected" )
   end if

   ::cCodigoFormaPago      := oBoton:Cargo:cCodigo

   if !oBoton:Cargo:lEfectivo
      aEval( ::aButtonsMoney, {|o| o:Hide() } )
   else
      aEval( ::aButtonsMoney, {|o| o:Show() } )
   end if

   oBoton:Selected()

Return .t.

//---------------------------------------------------------------------------//

METHOD CreaCobro() CLASS TpvCobros

   local sTipoCobro

   CursorWait()

   if ::sTotalesCobros:nCobrado != 0

      sTipoCobro              := STipoCobro()

      if lImporteExacto() 
         sTipoCobro:cCodigo   := ::cCodigoFormaPago
         sTipoCobro:cTexto    := oRetFld( ::cCodigoFormaPago, ::oSender:oFormaPago )
      else
         sTipoCobro:cCodigo   := ::oBrwFormasPago:aRow[ "Codigo" ]
         sTipoCobro:cTexto    := oRetFld( ::oBrwFormasPago:aRow[ "Codigo" ], ::oSender:oFormaPago )
      end if

      sTipoCobro:nImporte     := ::sTotalesCobros:nCobrado
      sTipoCobro:nCambio      := Max( ::sTotalesCobros:nCambio, 0 )

      sTipoCobro:AddCobro( ::aCobros )

   end if

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//

METHOD CargaCobros( cNumeroTicket ) CLASS TpvCobros

   local sTipoCobro

   /*
   Cargamos los pagos----------------------------------------------------------
   */

   if ::oSender:oTiketCobro:Seek( cNumeroTicket )

      while ( ::oSender:oTiketCobro:cSerTik + ::oSender:oTiketCobro:cNumTik + ::oSender:oTiketCobro:cSufTik == cNumeroTicket ) .and. !( ::oSender:oTiketCobro:Eof() )

         sTipoCobro              := STipoCobro()
         sTipoCobro:cCodigo      := ::oSender:oTiketCobro:cFpgPgo
         sTipoCobro:cTexto       := oRetFld( ::oSender:oTiketCobro:cFpgPgo, ::oSender:oFormaPago )
         sTipoCobro:nImporte     := ::oSender:oTiketCobro:nImpTik
         sTipoCobro:nCambio      := Max( ::oSender:oTiketCobro:nDevTik, 0 )
         sTipoCobro:lCloseCobro  := ::oSender:oTiketCobro:lCloPgo
         sTipoCobro:cSesionCobro := ::oSender:oTiketCobro:cTurPgo

         sTipoCobro:AddCobro( ::aCobros )

         ::oSender:oTiketCobro:Skip()

      end while

      ::oSender:oTemporalCobro:GoTop()

   end if

   /*
   Cargamos los vales----------------------------------------------------------
   */

   ::oSender:oTiketCabecera:GetStatus()
   ::oSender:oTiketCabecera:OrdSetFocus( "cDocVal" )

   if ::oSender:oTiketCabecera:Seek( cNumeroTicket )

      while ( ::oSender:oTiketCabecera:FieldGetByName( "cValDoc" ) == cNumeroTicket ) .and. !( ::oSender:oTiketCabecera:eof() )

         sTipoCobro           := STipoCobro()
         sTipoCobro:lVale     := .t.
         sTipoCobro:cTexto    := "Vale " + ::oSender:oTiketCabecera:FieldGetByName( "cSerTik" ) + "/" + ltrim( ::oSender:oTiketCabecera:FieldGetByName( "cNumTik" ) ) + "/" + ltrim( ::oSender:oTiketCabecera:FieldGetByName( "cSufTik" ) )
         sTipoCobro:cSerie    := ::oSender:oTiketCabecera:FieldGetByName( "cSerTik" )
         sTipoCobro:cNumero   := ::oSender:oTiketCabecera:FieldGetByName( "cNumTik" )
         sTipoCobro:cSufijo   := ::oSender:oTiketCabecera:FieldGetByName( "cSufTik" )
         sTipoCobro:nImporte  := ::oSender:oTiketCabecera:FieldGetByName( "nTotTik" )

         sTipoCobro:AddVale( ::aCobros )

         ::oSender:oTiketCabecera:Skip()

      end while

   end if

   ::oSender:oTiketCabecera:SetStatus()

Return .t.

//---------------------------------------------------------------------------//

METHOD EliminaCobros() CLASS TpvCobros

   local cNumeroTicket

   ::oSender:oTiketCabecera:GetStatus()

   cNumeroTicket        := ::oSender:cNumeroTicket()

   if !Empty( cNumeroTicket )

      /*
      Elimina los pagos--------------------------------------------------------
      */

      while ( ::oSender:oTiketCobro:Seek( cNumeroTicket ) )
         ::oSender:oTiketCobro:Delete(.f.)
      end while

      /*
      Elimina los vales--------------------------------------------------------
      */

      while ( ::oSender:oTiketCabecera:SeekInOrd( cNumeroTicket, "cDocVal" ) )
         ::oSender:oTiketCabecera:FieldPutByName( "lLiqTik", .f. )
         ::oSender:oTiketCabecera:FieldPutByName( "lSndDoc", .t. )
         ::oSender:oTiketCabecera:FieldPutByName( "cValDoc", "" )
         ::oSender:oTiketCabecera:FieldPutByName( "cTurVal", "" )
      end if

   end if

   ::oSender:oTiketCabecera:SetStatus()

Return .t.

//---------------------------------------------------------------------------//

METHOD GuardaCobros() CLASS TpvCobros

   local sCobro
   local cSerTik                          := ::oSender:oTiketCabecera:cSerTik
   local cNumTik                          := ::oSender:oTiketCabecera:cNumTik
   local cSufTik                          := ::oSender:oTiketCabecera:cSufTik

   for each sCobro in ::aCobros

      if !sCobro:lVale

         ::oSender:oTiketCobro:Append()

         ::oSender:oTiketCobro:cSerTik    := cSerTik
         ::oSender:oTiketCobro:cNumTik    := cNumTik
         ::oSender:oTiketCobro:cSufTik    := cSufTik

         ::oSender:oTiketCobro:cCtaRec    := cCtaCob()

         if sCobro:lCloseCobro
            ::oSender:oTiketCobro:lCloPgo := sCobro:lCloseCobro
            ::oSender:oTiketCobro:cTurPgo := sCobro:cSesionCobro
         else
            ::oSender:oTiketCobro:lCloPgo := sCobro:lCloseCobro
            ::oSender:oTiketCobro:cTurPgo := cCurSesion()
         end if

         ::oSender:oTiketCobro:dPgoTik    := GetSysDate()
         ::oSender:oTiketCobro:cTimTik    := SubStr( Time(), 1, 5 )
         ::oSender:oTiketCobro:cCodCaj    := oUser():cCaja()
         ::oSender:oTiketCobro:cDivPgo    := cDivEmp()
         ::oSender:oTiketCobro:nVdvPgo    := nChgDiv( cDivEmp(), ::oSender:oDivisas:cAlias )
         ::oSender:oTiketCobro:cFpgPgo    := sCobro:cCodigo
         ::oSender:oTiketCobro:nImpTik    := sCobro:nImporte
         ::oSender:oTiketCobro:nDevTik    := sCobro:nCambio

         ::oSender:oTiketCobro:Save()

      else

         ::oSender:oTiketCabecera:GetStatus()

         if ::oSender:oTiketCabecera:Seek( sCobro:cNumeroVale() )
            ::oSender:oTiketCabecera:FieldPutByName( "lLiqTik", .t. )
            ::oSender:oTiketCabecera:FieldPutByName( "lSndDoc", .t. )
            ::oSender:oTiketCabecera:FieldPutByName( "cValDoc", cSerTik + cNumTik + cSufTik )
            ::oSender:oTiketCabecera:FieldPutByName( "cTurVal", cCurSesion() )
         end if

         ::oSender:oTiketCabecera:SetStatus()

      end if

   next

Return .t.

//---------------------------------------------------------------------------//

METHOD OnClickAnnadirVales() CLASS TpvCobros

   local u
   local sTipoCobro

   CursorWait()

   if ::oSender:oTpvListaTicket:lVales()

      for each u in ( ::oSender:oTpvListaTicket:oBrwListaTicket:Cargo )

         ::oSender:oTiketCabecera:GoTo( u )

         sTipoCobro           := STipoCobro()
         sTipoCobro:lVale     := .t.
         sTipoCobro:cTexto    := "Vale " + ::oSender:oTiketCabecera:FieldGetByName( "cSerTik" ) + "/" + ltrim( ::oSender:oTiketCabecera:FieldGetByName( "cNumTik" ) ) + "/" + ltrim( ::oSender:oTiketCabecera:FieldGetByName( "cSufTik" ) )
         sTipoCobro:cSerie    := ::oSender:oTiketCabecera:FieldGetByName( "cSerTik" )
         sTipoCobro:cNumero   := ::oSender:oTiketCabecera:FieldGetByName( "cNumTik" )
         sTipoCobro:cSufijo   := ::oSender:oTiketCabecera:FieldGetByName( "cSufTik" )
         sTipoCobro:nImporte  := ::oSender:oTiketCabecera:FieldGetByName( "nTotTik" )

         sTipoCobro:AddVale( ::aCobros )

      next

   end if

   ::oSender:oTpvListaTicket:End()

   ::sTotalesCobros:nEntregado   := ::nTotal()

   ::sTotalesCobros:SetCobrado()
   ::sTotalesCobros:Recalcula()
   ::sTotalesCobros:Refresh()

   ::oBrwPago:Refresh()

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//

METHOD nTotal() CLASS TpvCobros

   local nTotal   := 0

   aEval( ::aCobros, {|u| nTotal += ( u:nImporte - u:nCambio ) } )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotalCobro() CLASS TpvCobros

   local nTotal   := 0

   aEval( ::aCobros, {|u| nTotal += u:nImporte } )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotalCambio() CLASS TpvCobros

   local nTotal   := 0

   aEval( ::aCobros, {|u| nTotal += u:nCambio } )

RETURN ( nTotal )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS STotalCobros

   DATA  oTotal
   DATA  oEntregado
   DATA  oCobrado
   DATA  oCobradoDivisa
   DATA  oCambio

   DATA  nTotal               INIT  0
   DATA  nEntregado           INIT  0
   DATA  nCobrado             INIT  0
   DATA  nVale                INIT  0
   DATA  nAnticipo            INIT  0
   DATA  nCambio              INIT  0

   METHOD lValeMayorTotal()   INLINE ( ( ::nVale <= ::nTotal ) .or. ( ::nTotal < 0 ) )

   METHOD Recalcula()         INLINE ( ::nCambio   := - ( ::nTotal - ::nEntregado - ::nCobrado ) )

   METHOD SetCobrado()        INLINE ( ::nCobrado  := ( ::nTotal - ::nEntregado ) )

   METHOD GetTotal( sTotal )

   METHOD Refresh()

END CLASS

//---------------------------------------------------------------------------//

METHOD GetTotal( sTotal ) CLASS STotalCobros

   ::nVale                    := 0
   ::nAnticipo                := 0
   ::nCambio                  := 0
   ::nTotal                   := sTotal:nTotalDocumento
   ::nEntregado               := sTotal:nTotalCobro()

   ::nCobrado                 := ::nTotal - ::nEntregado

   ::Recalcula()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Refresh() CLASS STotalCobros

   ::Recalcula()

   if !Empty( ::oTotal )
      ::oTotal:Refresh()
   end if

   if !Empty( ::oEntregado )
      ::oEntregado:Refresh()
   end if

   if !Empty( ::oCobrado )
      ::oCobrado:Refresh()
   end if

   if !Empty( ::oCobradoDivisa )
      ::oCobradoDivisa:Refresh()
   end if

   if !Empty( ::oCambio )
      ::oCambio:Refresh()
   end if

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SButtonCobros

   DATA  oButton
   DATA  oSay

   DATA  cTexto               INIT ""
   DATA  cCodigo              INIT ""
   DATA  lEfectivo            INIT .f.
   DATA  cBigResource         INIT ""
   DATA  cPressResource       INIT ""

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS STipoCobro

   DATA  cCodigo              INIT ""
   DATA  cTexto               INIT ""
   DATA  nImporte             INIT 0
   DATA  nCambio              INIT 0
   DATA  lCloseCobro          INIT .f.
   DATA  cSesionCobro         INIT ""

   DATA  lVale                INIT .f.
   DATA  cSerie               INIT ""
   DATA  cNumero              INIT ""
   DATA  cSufijo              INIT ""

   //------------------------------------------------------------------------//

   METHOD cNumeroVale()       INLINE ( ::cSerie + ::cNumero + ::cSufijo )

   //------------------------------------------------------------------------//

   METHOD AddCobro( aCobros ) INLINE aAdd( aCobros, Self )

   //------------------------------------------------------------------------//

   INLINE METHOD AddVale( aCobros )

      local u
      local nScan

      for each u in aCobros

         if u:lVale == ::lVale .and. u:cSerie == ::cSerie .and. u:cNumero == ::cNumero .and. u:cSufijo == ::cSufijo
            RETURN ( .f. )
         end if

      next

      aAdd( aCobros, Self )

      RETURN ( .t. )

   ENDMETHOD

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//