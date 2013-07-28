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

#define nParcial                    1
#define nPagado                     2

static oThis

//---------------------------------------------------------------------------//

CLASS TpvCobros

   DATA oDlg
   DATA oSender
   DATA sTotalesCobros

   DATA oBtnCalculadora
   DATA aButtonsMoney
   DATA oOfficeBar

   DATA oBrwPago

   DATA nExit

   DATA cResource

   DATA oDlg

   DATA cCodigoFormaPago

   DATA oGrupoCobro

   DATA lClickMoneda       INIT .f.

   DATA aCobros            INIT {}

   DATA nUbiTik            INIT ubiGeneral

   DATA nEstado            INIT nPagado

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

   INLINE METHOD OnClickMoneda( nImporte )

      if !::lClickMoneda
         ::sTotalesCobros:nCobrado  := 0
      end if

      ::sTotalesCobros:nCobrado     += nImporte

      ::sTotalesCobros:Refresh()

      ::lClickMoneda                := .t.

      RETURN ( Self )

   ENDMETHOD

   //------------------------------------------------------------------------//

   INLINE METHOD OnClickReset()

      ::sTotalesCobros:oCobrado:cText( 0 )

      ::sTotalesCobros:Recalcula()

      ::sTotalesCobros:Refresh()

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

      ::CreaCobro()

      ::sTotalesCobros:nEntregado   := ::nTotal()

      ::sTotalesCobros:SetCobrado()
      ::sTotalesCobros:Recalcula()
      ::sTotalesCobros:Refresh()

      ::oBrwPago:Refresh()

      RETURN ( Self )

   ENDMETHOD

   //------------------------------------------------------------------------//

   INLINE METHOD OnClickEliminarCobro()

      ::EliminaCobro()

      ::sTotalesCobros:nEntregado   := ::nTotal()

      ::sTotalesCobros:SetCobrado()
      ::sTotalesCobros:Recalcula()
      ::sTotalesCobros:Refresh()

      ::oBrwPago:Refresh()

      RETURN ( Self )

   ENDMETHOD

   //------------------------------------------------------------------------//

   INLINE METHOD OnClickAceptar( nExit )

      if ::oSender:nTipoDocumento != documentoAlbaran

         if ::nUbiTik == ubiEncargar

            if ( ::sTotalesCobros:nTotal ) > ( ::sTotalesCobros:nCobrado + ::sTotalesCobros:nEntregado )
               ::nEstado   := nParcial
            else
               ::nEstado   := nPagado
            end if

            ::CreaCobro()

            ::nExit  := nExit

            ::oDlg:End( IDOK )

         else

            if ::ValidCobro()

               ::CreaCobro()

               ::nEstado   := nPagado

               ::nExit     := nExit

               ::oDlg:End( IDOK )

            end if

         end if

      else

         ::nExit     := nExit
         ::oDlg:End( IDOK )

      end if   

      RETURN ( Self )

   ENDMETHOD

   //------------------------------------------------------------------------//

   METHOD OnClickAnnadirVales()

   //------------------------------------------------------------------------//

   METHOD nTotal()
   METHOD nTotalCobro()
   METHOD nTotalCambio()

   METHOD InitCobros()        INLINE ( ::aCobros := {} )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TpvCobros

   ::oSender                  := oSender

   ::aButtonsMoney            := Array( 16 )

   ::InitCobros()

   if oUser():lUsrZur()
      ::cResource             := "BIG_COBRO_RIGHT"
   else
      ::cResource             := "BIG_COBRO_RIGHT"
   end if

   ::sTotalesCobros           := STotalCobros()

Return Self

//--------------------------------------------------------------------------//

METHOD End() CLASS TpvCobros

   if !Empty( ::oDlg )
      ::oDlg:End()
   end if

   if !Empty( ::oOfficeBar )
      ::oOfficeBar:End()
   end if

   if !Empty( ::aButtonsMoney )
      aEval( ::aButtonsMoney, {|o| if( !Empty( o ), o:End(), ) } )
   end if

   if !Empty( ::oBtnCalculadora )
      ::oBtnCalculadora:End()
   end if

   ::oDlg               := nil
   ::oOfficeBar         := nil
   ::oBtnCalculadora    := nil
   ::aButtonsMoney      := nil

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

   ::nEstado                  := nPagado

   ::nExit                    := exitAceptar

Return .t.

//---------------------------------------------------------------------------//

METHOD lCobroExactoAlbaran() CLASS TpvCobros

   ::nExit                    := exitAceptarImprimir

Return .t.

//---------------------------------------------------------------------------//

METHOD lResource() CLASS TpvCobros

   local n

   ::nUbiTik            := ::oSender:oTiketCabecera:nUbiTik

   ::lClickMoneda       := .f.
   ::cCodigoFormaPago   := ::oSender:oTiketCabecera:cFpgTik

   ::sTotalesCobros:GetTotal( ::oSender:sTotal )

   DEFINE DIALOG ::oDlg RESOURCE ::cResource TITLE ::oSender:cTipoDocumento()

      /*
      Totales------------------------------------------------------------------
      */

      REDEFINE SAY ::sTotalesCobros:oTotal ;
         VAR      ::sTotalesCobros:nTotal ;
         ID       150 ;
         FONT     ::oSender:oFntDlg ;
         PICTURE  ::oSender:cPictureTotal ;
         OF       ::oDlg

      /*
      Total entregado__________________________________________________________
      */

      REDEFINE SAY ::sTotalesCobros:oEntregado ;
         VAR      ::sTotalesCobros:nEntregado ;
         ID       160 ;
         FONT     ::oSender:oFntDlg ;
         PICTURE  ::oSender:cPictureTotal ;
         OF       ::oDlg

      /*
      Cobrado en divisas__________________________________________________________________
      */

      REDEFINE GET ::sTotalesCobros:oCobrado ;
         VAR      ::sTotalesCobros:nCobrado ;
         ID       170 ;
         FONT     ::oSender:oFntDlg ;
         PICTURE  ::oSender:cPictureTotal ;
         OF       ::oDlg

      ::sTotalesCobros:oCobrado:bWhen  := {|| .t. }
      ::sTotalesCobros:oCobrado:bValid := {|| ::ValidTotalesCobro() }

      /*
      Cambio en divisas del cambio____________________________________________
		*/

      REDEFINE SAY ::sTotalesCobros:oCambio ;
         VAR      ::sTotalesCobros:nCambio ;
         ID       180 ;
         FONT     ::oSender:oFntDlg ;
         PICTURE  ::oSender:cPictureTotal ;
         OF       ::oDlg

      /*
      Calculadora-----------------------------------------------------------------
      */

      REDEFINE BUTTONBMP ::oBtnCalculadora ;
         ID       220 ;
         OF       ::oDlg ;
         BITMAP   "Calculator_32" ;
         ACTION   ( ::OnClickCalculadora() )

      /*
      Monedas y billetes----------------------------------------------------------
      */

      REDEFINE BUTTONBMP ::aButtonsMoney[ 1 ];
         ID       800 ;
         OF       ::oDlg ;
         BITMAP   "Img500Euros" ;
         ACTION   ( ::OnClickMoneda( 500 ) )

      REDEFINE BUTTONBMP ::aButtonsMoney[ 2 ];
         ID       801 ;
         OF       ::oDlg ;
         BITMAP   "Img200Euros" ;
         ACTION   ( ::OnClickMoneda( 200 ) )

      REDEFINE BUTTONBMP ::aButtonsMoney[ 3 ];
         BITMAP   "Img100EUROS" ;
         ACTION   ( ::OnClickMoneda( 100 ) ) ;
         ID       802;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 4 ];
         BITMAP   "Img50EUROS" ;
         ACTION   ( ::OnClickMoneda( 50 ) ) ;
         ID       803;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 5 ];
         BITMAP   "Img20EUROS" ;
         ACTION   ( ::OnClickMoneda( 20 ) ) ;
         ID       804;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 6 ];
         BITMAP   "Img10EUROS" ;
         ACTION   ( ::OnClickMoneda( 10 ) ) ;
         ID       805;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 7 ];
         BITMAP   "Img5EUROS" ;
         ACTION   ( ::OnClickMoneda( 5 ) ) ;
         ID       806;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 8 ];
         BITMAP   "Img2EUROS" ;
         ACTION   ( ::OnClickMoneda( 2 ) ) ;
         ID       807;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 9 ];
         BITMAP   "Img1EURO" ;
         ACTION   ( ::OnClickMoneda( 1 ) ) ;
         ID       808;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 10 ];
         BITMAP   "Img50CENT" ;
         ACTION   ( ::OnClickMoneda( 0.5 ) ) ;
         ID       809;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 11 ];
         BITMAP   "Img20CENT" ;
         ACTION   ( ::OnClickMoneda( 0.2 ) ) ;
         ID       810;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 12 ];
         BITMAP   "Img10CENT" ;
         ACTION   ( ::OnClickMoneda( 0.1 ) ) ;
         ID       811;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 13];
         BITMAP   "Img5CENT" ;
         ACTION   ( ::OnClickMoneda( 0.05 ) ) ;
         ID       812;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 14 ];
         BITMAP   "Img2CENT" ;
         ACTION   ( ::OnClickMoneda( 0.02 ) ) ;
         ID       813;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 15 ];
         BITMAP   "Img1CENT" ;
         ACTION   ( ::OnClickMoneda( 0.01 ) ) ;
         ID       814;
         OF       ::oDlg

      REDEFINE BUTTONBMP ::aButtonsMoney[ 16 ];
         BITMAP   "Img0EUROS" ;
         ACTION   ( ::OnClickReset() ) ;
         ID       815;
         OF       ::oDlg

      /*
      Monedas y billetes----------------------------------------------------------
      */

      ::oBrwPago                 := TXBrowse():New( ::oDlg )
      ::oBrwPago:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwPago:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwPago:lVScroll        := .t.
      ::oBrwPago:lHScroll        := .f.
      ::oBrwPago:nMarqueeStyle   := 5
      ::oBrwPago:SetFont( ::oSender:oFntDlg )

      ::oBrwPago:SetArray( ::aCobros, , , .f. )

      with object ( ::oBrwPago:AddCol() )
         :cHeader          := "Pago"
         :bEditValue       := {|| ::aCobros[ ::oBrwPago:nArrayAt ]:cTexto }
         :nWidth           := 290
      end with

      with object ( ::oBrwPago:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| ::aCobros[ ::oBrwPago:nArrayAt ]:nImporte }
         :cEditPicture     := ::oSender:cPictureTotal
         :nWidth           := 155
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwPago:AddCol() )
         :cHeader          := "Cambio"
         :bEditValue       := {|| ::aCobros[ ::oBrwPago:nArrayAt ]:nCambio }
         :cEditPicture     := ::oSender:cPictureTotal
         :nWidth           := 155
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      ::oBrwPago:CreateFromResource( 400 )

      /*
      Botones------------------------------------------------------------------
      */

      ::oDlg:bStart        := {|| ::StartResource() }

      ::oDlg:AddFastKey( VK_F5, {|| ::OnClickAceptar( exitAceptar ) } )
      ::oDlg:AddFastKey( VK_F6, {|| ::OnClickAceptar( exitAceptarImprimir ) } )

   ACTIVATE DIALOG ::oDlg CENTER

   if !Empty( ::oOfficeBar )
      ::oOfficeBar:End()
   end if

   if !Empty( ::aButtonsMoney )
      aEval( ::aButtonsMoney, {|o| if( !Empty( o ), o:End(), ) } )
   end if

   if !Empty( ::oBtnCalculadora )
      ::oBtnCalculadora:End()
   end if

   if !Empty( ::oBrwPago )
      ::oBrwPago:End()
   end if

   ::oOfficeBar            := nil
   ::oBtnCalculadora       := nil
   ::oBrwPago              := nil
   ::aButtonsMoney         := Array( 16 )

Return ( ::oDlg:nResult == IDOK )

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
                              
                                 TDotNetButton():New( 60, oGrupo,   "Check_32",                          "Aceptar [F5]",       1, {|| ::OnClickAceptar( exitAceptar ) }, , , .f., .f., .f. )

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

      sTipoCobro           := STipoCobro()
      sTipoCobro:cCodigo   := ::cCodigoFormaPago
      sTipoCobro:cTexto    := oRetFld( ::cCodigoFormaPago, ::oSender:oFormaPago )
      sTipoCobro:nImporte  := ::sTotalesCobros:nCobrado
      sTipoCobro:nCambio   := Max( ::sTotalesCobros:nCambio, 0 )

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