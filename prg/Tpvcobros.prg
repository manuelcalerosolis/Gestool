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

   DATA oSender

   DATA nExit

   CLASSDATA aFormasdePago          INIT {}
   CLASSDATA aResourceFormaPago     INIT aMiddleResourceFormaPago()

   DATA oDlg

      DATA aButtonsMoney
      DATA oBtnLimpiarTexto
      DATA oBtnAddCobro
      DATA oBtnDelCobro
      DATA oBtnTipoImpresion
      DATA oBtnAceptar
      DATA oBtnCalcMoney

      DATA oTextoTotal
      DATA cTextoTotal

      DATA oGetEntregado
      DATA nGetEntregado            INIT 0
      DATA cGetEntregado            INIT ""

      DATA oBrwPago
      DATA oBrwFormasPago
      DATA cBmpSalidaImpresora

      DATA lDecimalPoint            INIT .f.

   DATA lEfectivoMoney
   DATA lClickMoneda                INIT .f.

   DATA cCodigoFormaPago

   DATA nUbiTik                     INIT ubiGeneral
   DATA nEstado                     INIT estadoPagado

   DATA nTotal                      INIT 0

   DATA aCobros                     INIT {}

   /*
   Constructores---------------------------------------------------------------
   */

   METHOD New( oSender ) CONSTRUCTOR

   METHOD End()

   METHOD lCobro()

   METHOD lCobroExacto()

   METHOD lCobroExactoTicket()
   METHOD lCobroExactoAlbaran()

   /*
   Metodos para el recurso-----------------------------------------------------
   */

   METHOD lResource()

      METHOD RefreshResource()         INLINE ( ::oBrwPago:Refresh(), ::SetTextoTotal() )
      METHOD PushCalculadora( cTexto )
      METHOD PushMoney( nImporte )

      METHOD OnClickReset()            INLINE ( ::oGetEntregado:cText( 0 ), ::cGetEntregado := "" )
      METHOD OnClickFormadePago( oBoton )
      METHOD OnClickAnnadirCobro()
      METHOD OnClickEliminarCobro()    INLINE ( ::EliminaCobro(), ::RefreshResource() )
      METHOD OnClickAceptar()

      METHOD ChangeButtonsFormaPago( cTipo )
      METHOD ChangeFormaPago()         INLINE ( ::ChangeButtonsFormaPago( if( ::oBrwFormasPago:aRow[ "lEfectivo" ], "Money", "Calculadora" ), ::oBrwFormasPago:aRow[ "lEfectivo" ] ) )
      METHOD ChangeBtnImpresion()
      METHOD ChangeCalcMoney()

      METHOD SetTextoTotal()

   //------------------------------------------------------------------------//

   METHOD CreaCobro()
   METHOD EliminaCobro()               INLINE ( aDel( ::aCobros, ::oBrwPago:nArrayAt, .t. ) )
   METHOD ValidCobro()                 INLINE ( ::Entregado() >= ::Total() )

   METHOD CargaCobros( cNumeroTicket )
   METHOD EliminaCobros()
   METHOD GuardaCobros()
   METHOD InitCobros()                 INLINE ( ::aCobros := {} )

   METHOD ArchivaCobros()              INLINE ( ::EliminaCobros(), ::GuardaCobros() ) //::InitCobros() )

   //------------------------------------------------------------------------//

   METHOD CargaFormasdePago()

   METHOD SalidaImpresoraDefecto()

   METHOD Total()                      INLINE ( ::nTotal )
   METHOD Entregado() 
   METHOD Cambio()                     INLINE ( ::Total() - ::Entregado() ) 

END CLASS

//--------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TpvCobros

   ::oSender                  := oSender

   ::lEfectivoMoney           := .t.

   ::aButtonsMoney            := {  {  "Id" => 170,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "50",    "Action" => {|| ::PushMoney( 50 ) } },;
                                       "Calculadora" =>  { "Text" => "7",     "Action" => {|| ::PushCalculadora( "7" ) } } },;
                                    {  "Id" => 180,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "20",    "Action" => {|| ::PushMoney( 20 ) } },;
                                       "Calculadora" =>  { "Text" => "8",     "Action" => {|| ::PushCalculadora( "8" ) } } },;   
                                    {  "Id" => 190,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "10",    "Action" => {|| ::PushMoney( 10 ) } },;
                                       "Calculadora" =>  { "Text" => "9",     "Action" => {|| ::PushCalculadora( "9" ) } } },;   
                                    {  "Id" => 200,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "5",     "Action" => {|| ::PushMoney( 5 ) } },;
                                       "Calculadora" =>  { "Text" => "4",     "Action" => {|| ::PushCalculadora( "4" ) } } },;   
                                    {  "Id" => 210,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "2",     "Action" => {|| ::PushMoney( 2 ) } },;
                                       "Calculadora" =>  { "Text" => "5",     "Action" => {|| ::PushCalculadora( "5" ) } } },;   
                                    {  "Id" => 220,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "1",     "Action" => {|| ::PushMoney( 1 ) } },;
                                       "Calculadora" =>  { "Text" => "6",     "Action" => {|| ::PushCalculadora( "6" ) } } },;   
                                    {  "Id" => 230,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "0,50",  "Action" => {|| ::PushMoney( 0.50 ) } },;
                                       "Calculadora" =>  { "Text" => "1",     "Action" => {|| ::PushCalculadora( "1" ) } } },;   
                                    {  "Id" => 240,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "0,20",  "Action" => {|| ::PushMoney( 0.20 ) } },;
                                       "Calculadora" =>  { "Text" => "2",     "Action" => {|| ::PushCalculadora( "2" ) } } },;   
                                    {  "Id" => 250,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "0,10",  "Action" => {|| ::PushMoney( 0.10 ) } },;
                                       "Calculadora" =>  { "Text" => "3",     "Action" => {|| ::PushCalculadora( "3" ) } } },;      
                                    {  "Id" => 260,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "0,05",  "Action" => {|| ::PushMoney( 0.05 ) } },;
                                       "Calculadora" =>  { "Text" => "0",     "Action" => {|| ::PushCalculadora( "0" ) } } },;         
                                    {  "Id" => 270,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "0,02",  "Action" => {|| ::PushMoney( 0.02 ) } },;
                                       "Calculadora" =>  { "Text" => ",",     "Action" => {|| ::PushCalculadora( "." ) } } },;   
                                    {  "Id" => 280,;
                                       "Object" => nil,;
                                       "Money" =>        { "Text" => "0.01",  "Action" => {|| ::PushMoney( 0.01 ) } },;
                                       "Calculadora" =>  { "Text" => "",      "Action" => {|| ::PushCalculadora( "." ) } } } }

 
   ::CargaFormasdePago()

Return Self

//--------------------------------------------------------------------------//

METHOD End() CLASS TpvCobros

   if !Empty( ::oDlg )
      ::oDlg:End()
   end if

   ::oDlg               := nil

Return Self

//--------------------------------------------------------------------------//
/*
Si nos piden cobros exactos o cobros rapidos no mostramos el dialogo-----------
*/

METHOD lCobro() CLASS TpvCobros

   ::nTotal             := ::oSender:sTotal:nTotalDocumento
   ::nUbiTik            := ::oSender:oTiketCabecera:nUbiTik
   ::cCodigoFormaPago   := ::oSender:oTiketCabecera:cFpgTik

   ::InitCobros()
  
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

   ::CreaCobro( ::Total() )

   ::nEstado                  := estadoPagado

   ::nExit                    := exitAceptar

Return .t.

//---------------------------------------------------------------------------//

METHOD lCobroExactoAlbaran() CLASS TpvCobros

   ::nExit                    := exitAceptarImprimir

Return .t.

//---------------------------------------------------------------------------//

METHOD lResource() CLASS TpvCobros

   local cResourceFormaPago

   /*
   Tomamos valores por defecto-------------------------------------------------
   */

   ::SalidaImpresoraDefecto()

   ::CargaCobros()

   ::lClickMoneda       := .f.

   if uFieldEmpresa( "lTotTikCob" )
      ::nGetEntregado   := ( ::Total() - ::Entregado() )
   else 
      ::nGetEntregado   := 0
   end if

   DEFINE DIALOG ::oDlg ;
      RESOURCE          ( "NewCobro" ) ;
      TITLE             ( ::oSender:cTipoDocumento() );
      FONT              ( ::oSender:oFntDlg )

      /*
      SAY con la imformación de los cobros-------------------------------------
      */

      REDEFINE SAY      ::oTextoTotal ;
         VAR            ::cTextoTotal ;
         ID             100 ;
         OF             ::oDlg

      /*
      Boton para cambiar el tipo de impresión----------------------------------
      */

      ::oBtnTipoImpresion  := TButtonBmp():ReDefine( 110, {|| ::ChangeBtnImpresion() }, ::oDlg,,, .f.,,,, .f., ::cBmpSalidaImpresora )

      /*
      Boton de finalizar el cobro----------------------------------------------
      */

      ::oBtnAceptar        := TButtonBmp():ReDefine( 120, {|| ::OnClickAceptar() }, ::oDlg,,, .f.,,,, .f., "gc_check_32" )

      /*
      Browse con los diferentes pagos------------------------------------------
      */

      ::oBrwPago                 := IXBrowse():New( ::oDlg )
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

      ::oBrwPago:CreateFromResource( 130 )

      /*
      Browse con las formas de pago--------------------------------------------
      */

      ::oBrwFormasPago                 := IXBrowse():New( ::oDlg )
      ::oBrwFormasPago:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwFormasPago:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwFormasPago:lVScroll        := .f.
      ::oBrwFormasPago:lHScroll        := .f.
      ::oBrwFormasPago:nMarqueeStyle   := 5
      ::oBrwFormasPago:lHeader         := .f.
      ::oBrwFormasPago:lFooter         := .f.
      ::oBrwFormasPago:lRecordSelector := .f.
      ::oBrwFormasPago:nRowHeight      := 50
   
      ::oBrwFormasPago:SetArray( ::aFormasdePago, , , .f. )
   
      ::oBrwFormasPago:bChange         := {|| ::ChangeFormaPago() }
    
      with object ( ::oBrwFormasPago:AddCol() )
         :cHeader                      := "Imagen"
         :bBmpData                     := {|| ::oBrwFormasPago:aRow[ "Imagen" ] }
         :nWidth                       := 24
               
         for each cResourceFormaPago in ::aResourceFormaPago
            :AddResource( cResourceFormaPago )
         next
      end with
   
      with object ( ::oBrwFormasPago:AddCol() )
         :cHeader                      := "Forma"
         :bEditValue                   := {|| ::oBrwFormasPago:aRow[ "Descripcion" ] }
         :nWidth                       := 90
      end with

      ::oBrwFormasPago:CreateFromResource( 140 )

      /*
      Caja de texto para escribir la cantidad----------------------------------
      */

      REDEFINE GET   ::oGetEntregado ;
         VAR         ::nGetEntregado ;
         PICTURE     ::oSender:cPictureTotal ;
         ID          150 ;
         OF          ::oDlg

      /*
      Boton para limpiar la caja de texto--------------------------------------
      */

      ::oBtnLimpiarTexto   := TButton():ReDefine( 160, {|| ::OnClickReset() }, ::oDlg, , , .f. )  

      /*
      Botones del teclado------------------------------------------------------
      */

      aEval( ::aButtonsMoney, {|h| h[ "Object" ] := TButton():ReDefine( h[ "Id" ], h[ "Money", "Action" ], ::oDlg, , , .f. ) } ) 

      /*
      Boton cambiar teclado de monedas a calculadora---------------------------
      */

      ::oBtnCalcMoney      := TButtonBmp():ReDefine( 300, {|| ::ChangeCalcMoney() }, ::oDlg,,, .f.,,,, .f., "gc_calculator_32",, )

      /*
      Boton de validar la cantidad introducida---------------------------------
      */

      ::oBtnAddCobro       := TButtonBmp():ReDefine( 290, {|| ::OnClickAnnadirCobro() }, ::oDlg,,, .f.,,,, .f., "New32",, )

      /*
      Boton de eliminar cobro--------------------------------------------------
      */

      ::oBtnDelCobro       := TButtonBmp():ReDefine( 310, {|| ::OnClickEliminarCobro() }, ::oDlg,,, .f.,,,, .f., "Del32",, )

   /*
   Evento a lanzar a inicio----------------------------------------------------
   */

   ::oDlg:bStart           := {|| ::SetTextoTotal() }

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

METHOD ChangeBtnImpresion() CLASS TpvCobros

   do case
      case ::nExit == exitAceptar

         ::nExit   := exitAceptarImprimir
         ::oBtnTipoImpresion:LoadBitmap( "gc_printer2_ok_32" )

      case ::nExit == exitAceptarImprimir

         ::nExit   := exitAceptarRegalo
         ::oBtnTipoImpresion:LoadBitmap( "gc_printer2_sun_32" )

      case ::nExit == exitAceptarRegalo

         ::nExit   := exitAceptar
         ::oBtnTipoImpresion:LoadBitmap( "gc_printer2_delete_32" )

   end case

   ::oBtnTipoImpresion:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SalidaImpresoraDefecto CLASS TpvCobros

   do case
      case uFieldEmpresa( "nTipImpTpv" ) <= 1
      
         ::nExit                 := exitAceptar
         ::cBmpSalidaImpresora   := "gc_printer2_delete_32"

      case uFieldEmpresa( "nTipImpTpv" ) == 2
         
         ::nExit                 := exitAceptarImprimir
         ::cBmpSalidaImpresora   := "gc_printer2_ok_32"

      otherwise
         
         ::nExit                 := exitAceptarRegalo
         ::cBmpSalidaImpresora   := "gc_printer2_sun_32"

   end case

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetTextoTotal() CLASS TpvCobros

   if ::Entregado() >= ::Total()
      ::oTextoTotal:SetText( "Cambio: " + alltrim( Trans( Abs( ::Cambio() ), ::oSender:cPictureTotal ) ) )
   else 
      ::oTextoTotal:SetText( "Pendiente: " + alltrim( Trans( ::Cambio(), ::oSender:cPictureTotal ) ) )
   end if 

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD PushCalculadora( cTexto )

   ::cGetEntregado            += cTexto

   ::oGetEntregado:cText( ValToMoney( ::cGetEntregado ) )

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD PushMoney( nImporte )

   if !::lClickMoneda
      ::oGetEntregado:cText( 0 )
   end if

   ::nGetEntregado      += nImporte

   ::oGetEntregado:cText( ::nGetEntregado )

   ::lClickMoneda       := .t.

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD CargaFormasdePago() CLASS TpvCobros

   if empty( ::aFormasdePago )

      if ( ::oSender:oFormaPago:Used() )

         ::oSender:oFormaPago:GetStatus()

         ::oSender:oFormaPago:OrdSetFocus( "nPosTpv" )

         ::oSender:oFormaPago:GoTop()
         while !::oSender:oFormaPago:eof()

            aAdd( ::aFormasdePago, { "Codigo" =>      ::oSender:oFormaPago:cCodPago,;
                                     "Descripcion" => Rtrim( ::oSender:oFormaPago:cDesPago ),;
                                     "lEfectivo" =>   ( ::oSender:oFormaPago:nTipPgo <= 1 ) ,;
                                     "Imagen" =>      ::oSender:oFormaPago:nImgTpv } )

            ::oSender:oFormaPago:Skip()

         end while

         ::oSender:oFormaPago:SetStatus()

      end if

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
         ::oGetEntregado:cText( ::Cambio() )
         ::oBtnCalcMoney:Hide()
      end if

      ::oBtnCalcMoney:Refresh()

   end if

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD OnClickAceptar()

   local lEnd        := .t.

   ::oDlg:Disable()

   ::CreaCobro( ::nGetEntregado )

   ::RefreshResource()

   // Si guardamos un albaran dejamos importes menores al ticket 

   if ( ::oSender:nTipoDocumento != documentoAlbaran )

      if ::ValidCobro() 
         ::nEstado   := estadoPagado
      else 
         msgStop( "Importe insuficiente." )
         lEnd        := .f. 
      end if

   end if

   ::oDlg:Enable()

   if lEnd
      ::oDlg:End( IDOK )
   end if

RETURN ( .t. )

//------------------------------------------------------------------------//

METHOD ChangeCalcMoney CLASS TpvCobros

   if ::lEfectivoMoney
      AEval( ::aButtonsMoney, {|h| h[ "Object" ]:bAction := h[ "Calculadora", "Action" ], SetWindowText( h[ "Object" ]:hWnd, h[ "Calculadora", "Text" ] ) } )
      ::oBtnCalcMoney:LoadBitmap( "gc_money2_32" )
      ::oBtnCalcMoney:Refresh()
   else
      AEval( ::aButtonsMoney, {|h| h[ "Object" ]:bAction := h[ "Money", "Action" ], SetWindowText( h[ "Object" ]:hWnd, h[ "Money", "Text" ] ) } )
      ::oBtnCalcMoney:LoadBitmap( "gc_calculator_32" )
      ::oBtnCalcMoney:Refresh()
   end if   

   ::lEfectivoMoney := !::lEfectivoMoney

Return ( Self )

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

METHOD OnClickAnnadirCobro()

   ::CreaCobro( ::nGetEntregado )
   
   ::oGetEntregado:cText( 0 )
   
   ::RefreshResource()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreaCobro( nImporte ) CLASS TpvCobros

   local cCodigo
   local sTipoCobro
   local nCambio              := 0

   if !lImporteExacto()
   
      if empty( ::oBrwFormasPago ) .or. empty( ::oBrwFormasPago:aRow )
         msgStop( "No existen formas de pago" )
         Return .f.
      end if

   end if

   CursorWait()

   if lImporteExacto() 
      cCodigo                 := ::cCodigoFormaPago
   else
      cCodigo                 := ::oBrwFormasPago:aRow[ "Codigo" ]
   end if

   if !empty( nImporte )

      nCambio                 := ::Total() - ::Entregado() - nImporte

      sTipoCobro              := STipoCobro()

      sTipoCobro:cCodigo      := cCodigo
      sTipoCobro:cTexto       := oRetFld( cCodigo, ::oSender:oFormaPago )
      sTipoCobro:nImporte     := nImporte

      if ( nCambio < 0 )
         sTipoCobro:nCambio   := abs( nCambio )
      end if

      sTipoCobro:AddCobro( ::aCobros )

   end if

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//
/*
Cargamos los pagos-------------------------------------------------------------
*/

METHOD CargaCobros() CLASS TpvCobros

   local sTipoCobro
   local cNumeroTicket           

   if ::oSender:lBlankTicket()
      return .f.
   endif

   cNumeroTicket                 := ::oSender:cNumeroTicket()

   ::InitCobros()

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

Return .t.

//---------------------------------------------------------------------------//
/*
Elimina los pagos--------------------------------------------------------
*/

METHOD EliminaCobros( cNumeroTicket ) CLASS TpvCobros

   DEFAULT cNumeroTicket   := ::oSender:cNumeroTicket()

   if !empty( cNumeroTicket )

      ::oSender:oTiketCobro:GetStatus()

      while ( ::oSender:oTiketCobro:Seek( cNumeroTicket ) )
         ::oSender:oTiketCobro:Delete(.f.)
      end while

      ::oSender:oTiketCobro:SetStatus()

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD Entregado() CLASS TpvCobros

   local nEntregado  := 0
   
   aEval( ::aCobros, {|sCobro| nEntregado += sCobro:nImporte } )

RETURN ( nEntregado )

//---------------------------------------------------------------------------//

METHOD GuardaCobros() CLASS TpvCobros

   local sCobro

   for each sCobro in ::aCobros

      if ::oSender:oTiketCobro:Append()

         ::oSender:oTiketCobro:cSerTik    := ::oSender:oTiketCabecera:cSerTik
         ::oSender:oTiketCobro:cNumTik    := ::oSender:oTiketCabecera:cNumTik
         ::oSender:oTiketCobro:cSufTik    := ::oSender:oTiketCabecera:cSufTik

         ::oSender:oTiketCobro:cCtaRec    := cCtaCob()
         ::oSender:oTiketCobro:dPgoTik    := GetSysDate()
         ::oSender:oTiketCobro:cTimTik    := SubStr( Time(), 1, 5 )
         ::oSender:oTiketCobro:cCodCaj    := Application():CodigoCaja()

         ::oSender:oTiketCobro:cDivPgo    := cDivEmp()
         ::oSender:oTiketCobro:nVdvPgo    := nChgDiv( cDivEmp(), ::oSender:oDivisas:cAlias )

         ::oSender:oTiketCobro:lCloPgo    := sCobro:lCloseCobro
         ::oSender:oTiketCobro:cFpgPgo    := sCobro:cCodigo
         ::oSender:oTiketCobro:nImpTik    := sCobro:nImporte
         ::oSender:oTiketCobro:nDevTik    := sCobro:nCambio

         if sCobro:lCloseCobro
            ::oSender:oTiketCobro:cTurPgo := sCobro:cSesionCobro
         else
            ::oSender:oTiketCobro:cTurPgo := ::oSender:oTiketCabecera:cTurTik //cCurSesion()
         end if

         ::oSender:oTiketCobro:Save()

      else

         msgStop( "No he podido almacenar los pagos del ticket " + ::oSender:cNumeroTicketFormato() )
         
         Return .f.

      end if

   next

Return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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

   METHOD cNumeroVale()       INLINE ( ::cSerie + ::cNumero + ::cSufijo )

   METHOD AddCobro( aCobros ) INLINE aAdd( aCobros, Self )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//