#include "FiveWin.Ch"
#include "Factu.ch"
#include "Report.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDeleleteObsoletos

   DATA oDialog
   DATA oPages
   DATA oBtnSiguiente
   DATA oBtnPrevio
   DATA oMtrProceso
   DATA nMtrProceso
   DATA oBrwArticulos

   DATA lNoCom          INIT .t.
   DATA lNoPre          INIT .t.
   DATA lNoVta          INIT .t.
   DATA lNoMov          INIT .t.

   DATA nAction         INIT 1

   DATA nBmp

   DATA aArticulos      INIT { { .f., "", "" } }

   DATA dFechaInicial   INIT CtoD( "01/01/" + Str( Year( Date() ) ) )
   DATA dFechaFinal     INIT Date()

   DATA lTodasFamilias  INIT .t.
   DATA cFamiliaOrigen
   DATA cFamiliaDestino

   DATA oPedPrvT
   DATA oPedPrvL
   DATA oAlbPrvT
   DATA oAlbPrvL
   DATA oFacPrvT
   DATA oFacPrvL
   DATA oPreCliT
   DATA oPreCliL
   DATA oPedCliT
   DATA oPedCliL
   DATA oAlbCliT
   DATA oAlbCliL
   DATA oFacCliT
   DATA oFacCliL
   DATA oFacRecT
   DATA oFacRecL
   DATA oTikCliT
   DATA oTikCliL
   DATA oHisMov
   DATA oDbfFam
   DATA oDbfArt
   DATA oPrvArt
   DATA oArtDiv
   DATA oArtKit
   DATA oCodeBar

   METHOD New()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource()

   METHOD BtnPrevio()

   METHOD BtnSiguiente()

   METHOD Search()

   METHOD lNoHayMovimientos()

   METHOD BorraSeleccionados()

   METHOD SelDel()

   METHOD SelAllDel( lOpcion )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::OpenFiles()

   ::Resource()

   ::CloseFiles()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   DATABASE NEW ::oPedPrvT PATH ( cPatEmp() ) FILE "PEDPROVT.DBF"    VIA ( cDriver() )  SHARED INDEX "PEDPROVT.CDX"
   DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) FILE "PEDPROVL.DBF"    VIA ( cDriver() )  SHARED INDEX "PEDPROVL.CDX"
   ::oPedPrvL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF"    VIA ( cDriver() )  SHARED INDEX "ALBPROVT.CDX"
   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF"    VIA ( cDriver() )  SHARED INDEX "ALBPROVL.CDX"
   ::oAlbPrvL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF"     VIA ( cDriver() )  SHARED INDEX "FACPRVT.CDX"
   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"     VIA ( cDriver() )  SHARED INDEX "FACPRVL.CDX"
   ::oFacPrvL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oPreCliT PATH ( cPatEmp() ) FILE "PRECLIT.DBF"     VIA ( cDriver() )  SHARED INDEX "PRECLIT.CDX"
   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF"     VIA ( cDriver() )  SHARED INDEX "PRECLIL.CDX"
   ::oPreCliL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oPedCliT PATH ( cPatEmp() ) FILE "PEDCLIT.DBF"     VIA ( cDriver() )  SHARED INDEX "PEDCLIT.CDX"
   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF"     VIA ( cDriver() )  SHARED INDEX "PEDCLIL.CDX"
   ::oPedCliL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oAlbCliT PATH ( cPatEmp() ) FILE "ALBCLIT.DBF"     VIA ( cDriver() )  SHARED INDEX "ALBCLIT.CDX"
   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"     VIA ( cDriver() )  SHARED INDEX "ALBCLIL.CDX"
   ::oAlbCliL:OrdSetFocus( "cRef" )

   ::oFacCliT := TDataCenter():oFacCliT()  
   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"     VIA ( cDriver() )  SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"     VIA ( cDriver() )  SHARED INDEX "FACRECT.CDX"
   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"     VIA ( cDriver() )  SHARED INDEX "FACRECL.CDX"
   ::oFacRecL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"       VIA ( cDriver() )  SHARED INDEX "TIKET.CDX"
   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"       VIA ( cDriver() )  SHARED INDEX "TIKEL.CDX"
   ::oTikCliL:OrdSetFocus( "cCbaTil" )

   DATABASE NEW ::oHisMov  PATH ( cPatEmp() ) FILE "HISMOV.DBF"      VIA ( cDriver() )  SHARED INDEX "HISMOV.CDX"
   ::oHisMov:OrdSetFocus( "cRefMov" )

   DATABASE NEW ::oDbfFam  PATH ( cPatArt() ) FILE "FAMILIAS.DBF"    VIA ( cDriver() )  SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF"    VIA ( cDriver() )  SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oPrvArt  PATH ( cPatArt() ) FILE "PROVART.DBF"     VIA ( cDriver() )  SHARED INDEX "PROVART.CDX"
   ::oPrvArt:OrdSetFocus( "cCodArt" )

   DATABASE NEW ::oArtDiv  PATH ( cPatArt() ) FILE "ARTDIV.DBF"      VIA ( cDriver() )  SHARED INDEX "ARTDIV.CDX"
   ::oArtDiv:OrdSetFocus( "cCodArt" )

   DATABASE NEW ::oArtKit  PATH ( cPatArt() ) FILE "ARTKIT.DBF"      VIA ( cDriver() )  SHARED INDEX "ARTKIT.CDX"
   ::oArtKit:OrdSetFocus( "cCodKit" )

   DATABASE NEW ::oCodeBar PATH ( cPatArt() ) FILE "ARTCODEBAR.DBF"  VIA ( cDriver() )  SHARED INDEX "ARTCODEBAR.CDX"
   ::oCodeBar:OrdSetFocus( "cCodArt" )

   ::nBmp               := LoadBitmap( 0, 32760 )


Return ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oPedPrvT:End()
   ::oPedPrvL:End()
   ::oAlbPrvT:End()
   ::oAlbPrvL:End()
   ::oFacPrvT:End()
   ::oFacPrvL:End()
   ::oPreCliT:End()
   ::oPreCliL:End()
   ::oPedCliT:End()
   ::oPedCliL:End()
   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oFacRecT:End()
   ::oFacRecL:End()
   ::oTikCliT:End()
   ::oTikCliL:End()
   ::oHisMov:End()
   ::oDbfFam:End()
   ::oDbfArt:End()
   ::oPrvArt:End()
   ::oArtDiv:End()
   ::oArtKit:End()
   ::oCodeBar:End()

   DeleteObject( ::nBmp )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource()

   local oFamiliaOrigen
   local oFamiliaDestino

   local oSayFamiliaOrigen
   local oSayFamiliaDestino
   local cSayFamiliaOrigen
   local cSayFamiliaDestino
   local oBmp

   ::cFamiliaOrigen     := dbFirst( ::oDbfFam, 1 )
   ::cFamiliaDestino    := dbLast ( ::oDbfFam, 1 )
   cSayFamiliaOrigen    := dbFirst( ::oDbfFam, 2 )
   cSayFamiliaDestino   := dbLast ( ::oDbfFam, 2 )

   /*
   Dialogo---------------------------------------------------------------------
   */

   DEFINE DIALOG ::oDialog RESOURCE "ASS_EURO"

   REDEFINE BITMAP oBmp RESOURCE "EliminarArticulos" ID 600 OF ::oDialog

   REDEFINE PAGES ::oPages ID 110 OF ::oDialog ;
      DIALOGS "ASS_EURO01", "ASS_EURO02"

   REDEFINE GET ::dFechaInicial;
		SPINNER ;
      ID       100 ;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE GET ::dFechaFinal;
		SPINNER ;
      ID       110 ;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE RADIO ::nAction ;
      ID       200, 210 ;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lTodasFamilias;
      ID       120 ;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE GET oFamiliaOrigen VAR ::cFamiliaOrigen;
      ID       130;
      WHEN     !::lTodasFamilias ;
      VALID    cFamilia( oFamiliaOrigen, ::oDbfFam:cAlias, oSayFamiliaOrigen ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwFamilia( oFamiliaOrigen, oSayFamiliaDestino ) ;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE GET oSayFamiliaOrigen VAR cSayFamiliaOrigen ;
      ID       131;
      WHEN     .f.;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE GET oFamiliaDestino VAR ::cFamiliaDestino;
      ID       140;
      WHEN     !::lTodasFamilias ;
      VALID    cFamilia( oFamiliaDestino, ::oDbfFam:cAlias, oSayFamiliaDestino ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwFamilia( oFamiliaDestino, oSayFamiliaDestino ) ;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE GET oSayFamiliaDestino VAR cSayFamiliaDestino ;
      ID       141;
      WHEN     .f.;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lNoCom ;
      ID       160 ;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lNoPre ;
      ID       170 ;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lNoVta ;
      ID       180 ;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE CHECKBOX ::lNoMov ;
      ID       190 ;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE METER ::oMtrProceso ;
      VAR      ::nMtrProceso ;
		PROMPT	"Procesando" ;
      ID       150 ;
      TOTAL    100 ;
      OF       ::oPages:aDialogs[ 1 ]

   ::oBrwArticulos                        := IXBrowse():New( ::oPages:aDialogs[ 2 ] )

   ::oBrwArticulos:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwArticulos:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwArticulos:SetArray( ::aArticulos, , , .f. )

   ::oBrwArticulos:nMarqueeStyle          := 5
   ::oBrwArticulos:lRecordSelector        := .f.
   ::oBrwArticulos:lHScroll               := .f.
   ::oBrwArticulos:cName                  := "Eliminar artículos sin movimientos"
   ::oBrwArticulos:bLDblClick             := {|| ::SelDel(), ::oBrwArticulos:Refresh() }

   ::oBrwArticulos:CreateFromResource( 100 )

   with object ( ::oBrwArticulos:AddCol() )
      :cHeader          := "Se. seleccionado"
      :bStrData         := {|| "" }
      :bEditValue       := {|| ::aArticulos[ ::oBrwArticulos:nArrayAt, 1 ] }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwArticulos:AddCol() )
      :cHeader          := "Código"
      :bStrData         := {|| ::aArticulos[ ::oBrwArticulos:nArrayAt, 2 ] }
      :nWidth           := 80
   end with

   with object ( ::oBrwArticulos:AddCol() )
      :cHeader          := "Nombre"
      :bStrData         := {|| ::aArticulos[ ::oBrwArticulos:nArrayAt, 3 ] }
      :nWidth           := 400
   end with

   REDEFINE BUTTON;
      ID       130 ;
      OF       ::oPages:aDialogs[ 2 ];
      ACTION   ( ::SelDel(), ::oBrwArticulos:Refresh() )

   REDEFINE BUTTON;
      ID       110 ;
      OF       ::oPages:aDialogs[ 2 ];
      ACTION   ( ::SelAllDel( .t. ), ::oBrwArticulos:Refresh() )

   REDEFINE BUTTON;
      ID       120 ;
      OF       ::oPages:aDialogs[ 2 ];
      ACTION   ( ::SelAllDel( .f. ), ::oBrwArticulos:Refresh() )

   REDEFINE BUTTON ::oBtnPrevio ;                        // Boton de Anterior
      ID       401 ;
      OF       ::oDialog;
      ACTION   ( ::BtnPrevio() )

   REDEFINE BUTTON ::oBtnSiguiente ;                     // Boton de Siguiente
      ID       402 ;
      OF       ::oDialog;
      ACTION   ( ::BtnSiguiente() )

   REDEFINE BUTTON ;                                     // Boton de salida
      ID       403 ;
      OF       ::oDialog ;
      ACTION   ( ::oDialog:end() )

   ::oDialog:bStart  := {|| ::oBtnPrevio:Hide(), ::oBrwArticulos:Load() }

   ACTIVATE DIALOG ::oDialog CENTER

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BtnPrevio()

   if ::oPages:nOption == 2
      ::oPages:GoPrev()
      SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )
      ::oBtnPrevio:Hide()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BtnSiguiente()

   do case
      case ::oPages:nOption == 1
         if !::lNoCom .and. !::lNoPre .and. !::lNoVta .and. !::lNoMov
            MsgStop( "Tienes que seleccionar alguna de las opciones a incluir en la búsqueda" )
            Return .f.
         end if
         ::Search()
         ::oPages:GoNext()
         SetWindowText( ::oBtnSiguiente:hWnd, "&Proceder" )
         ::oBtnPrevio:Show()

      case ::oPages:nOption == 2
         ::BorraSeleccionados()
         ::oDialog:End()
   end case

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Search()

   ::oDialog:Disable()

   ::aArticulos               := {}

   aEval( ::oBrwArticulos:aArrayData, {|a,n| aDel( ::oBrwArticulos:aArrayData, n, .t. ), ::oBrwArticulos:Refresh() } )

   ::oMtrProceso:SetTotal( ::oDbfArt:Lastrec() )

   ::oDbfArt:GoTop()
   while !::oDbfArt:Eof()

      if ::lTodasFamilias  .or.;
         ( ::oDbfArt:Familia >= ::cFamiliaOrigen .and. ::oDbfArt:Familia <= ::cFamiliaDestino )

         if ::lNoHayMovimientos()
            aAdd( ::aArticulos, { .t., ::oDbfArt:Codigo, ::oDbfArt:Nombre } )
         end if

      end if

      ::oMtrProceso:Set( ::oDbfArt:OrdKeyNo() )

      ::oDbfArt:Skip()

   end while

   ::oMtrProceso:Set( ::oDbfArt:LastRec() )

   aEval( ::aArticulos, {|a| aAdd( ::oBrwArticulos:aArrayData, a ), ::oBrwArticulos:Refresh() } )

   ::oDialog:Enable()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD lNoHayMovimientos()

   local dFecha
   local cCodArt     := ::oDbfArt:Codigo

   if ::lNoCom

      if ::oPedPrvL:Seek( cCodArt )

         while ::oPedPrvL:cRef == cCodArt .and. !::oPedPrvL:Eof()

            dFecha   := dFecPedPrv( ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed, ::oPedPrvT:cAlias )

            if dFecha >= ::dFechaInicial .and. dFecha <= ::dFechaFinal

               Return .f.

            end if

            ::oPedPrvL:Skip()

         end while

      end if

      if ::oAlbPrvL:Seek( cCodArt )

         while ::oAlbPrvL:cRef == cCodArt .and. !::oAlbPrvL:Eof()

            dFecha   := dFecAlbPrv( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb, ::oAlbPrvT:cAlias )

            if dFecha >= ::dFechaInicial .and. dFecha <= ::dFechaFinal

               Return .f.

            end if

            ::oAlbPrvL:Skip()

         end while

      end if

      if ::oFacPrvL:Seek( cCodArt )

         while ::oFacPrvL:cRef == cCodArt .and. !::oFacPrvL:Eof()

            dFecha   := dFecFacPrv( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac, ::oFacPrvT:cAlias )

            if dFecha >= ::dFechaInicial .and. dFecha <= ::dFechaFinal

               Return .f.

            end if

            ::oFacPrvL:Skip()

         end while

      end if

   end if

   if ::lNoPre

      if ::oPreCliL:Seek( cCodArt )

         while ::oPreCliL:cRef == cCodArt .and. !::oPreCliL:Eof()

            dFecha   := dFecPreCli( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre, ::oPreCliT:cAlias )

            if dFecha >= ::dFechaInicial .and. dFecha <= ::dFechaFinal

               Return .f.

            end if

            ::oPreCliL:Skip()

         end while

      end if

   end if

   if ::lNoVta

      if ::oPedCliL:Seek( cCodArt )

         while ::oPedCliL:cRef == cCodArt .and. !::oPedCliL:Eof()

            dFecha   := dFecPedCli( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliT:cAlias )

            if dFecha >= ::dFechaInicial .and. dFecha <= ::dFechaFinal

               Return .f.

            end if

            ::oPedCliL:Skip()

         end while

      end if

      if ::oAlbCliL:Seek( cCodArt )

         while ::oAlbCliL:cRef == cCodArt .and. !::oAlbCliL:Eof()

            dFecha   := dFecAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT:cAlias )

            if dFecha >= ::dFechaInicial .and. dFecha <= ::dFechaFinal

               Return .f.

            end if

            ::oAlbCliL:Skip()

         end while

      end if

      if ::oFacCliL:Seek( cCodArt )

         while ::oFacCliL:cRef == cCodArt .and. !::oFacCliL:Eof()

            dFecha   := dFecFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT:cAlias )

            if dFecha >= ::dFechaInicial .and. dFecha <= ::dFechaFinal

               Return .f.

            end if

            ::oFacCliL:Skip()

         end while

      end if

      if ::oFacRecL:Seek( cCodArt )

         while ::oFacRecL:cRef == cCodArt .and. !::oFacRecL:Eof()

            dFecha   := dFecFacRec( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac, ::oFacRecT:cAlias )

            if dFecha >= ::dFechaInicial .and. dFecha <= ::dFechaFinal

               Return .f.

            end if

            ::oFacRecL:Skip()

         end while

      end if

      if ::oTikCliL:Seek( cCodArt )

         while ::oTikCliL:cCbaTil == cCodArt .and. !::oTikCliL:Eof()

            dFecha   := dFecTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT:cAlias )

            if dFecha >= ::dFechaInicial .and. dFecha <= ::dFechaFinal

               Return .f.

            end if

            ::oTikCliL:Skip()

         end while

      end if

   end if

   if ::lNoMov

      if ::oHisMov:Seek( cCodArt )

         while ::oHisMov:cRefMov == cCodArt .and. !::oHisMov:Eof()

            if ::oHisMov:dFecMov >= ::dFechaInicial .and. ::oHisMov:dFecMov <= ::dFechaFinal

               Return .f.

            end if

            ::oHisMov:Skip()

         end while

      end if

   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD BorraSeleccionados()

   local n
   local cText       := "¡Atención!" + CRLF
   local nBorrados   := 0

   for n := 1 to len( ::aArticulos )

      if ::aArticulos[ n, 1 ]
         nBorrados++
      end if

   next

   if nBorrados > 0
      if ::nAction == 1
         cText       += "Se van a eliminar " + Alltrim( Str( nBorrados ) ) + " árticulos." + CRLF
      else
         cText       += "Se van a marcar como obsoletos " + Alltrim( Str( nBorrados ) ) + " árticulos." + CRLF
      end if
   end if

   if !ApoloMsgNoYes(cText, "Confirme proceso" )
      Return ( Self )
   end if

   for n := 1 to len( ::aArticulos )

      do case

         case ::nAction == 1 .and. ::aArticulos[ n, 1 ]

            while ::oPrvArt:Seek( ::aArticulos[ n, 2 ] )
               ::oPrvArt:Delete()
            end while

            while ::oArtDiv:Seek( ::aArticulos[ n, 2 ] )
               ::oArtDiv:Delete()
            end while

            while ::oArtKit:Seek( ::aArticulos[ n, 2 ] )
               ::oArtKit:Delete()
            end while

            while ::oCodeBar:Seek( ::aArticulos[ n, 2 ] )
               ::oCodeBar:Delete()
            end while

            while ::oDbfArt:Seek( ::aArticulos[ n, 2 ] )
               ::oDbfArt:Delete()
            end while

         case ::nAction == 2 .and. ::aArticulos[ n, 1 ]

            if ::oDbfArt:Seek( ::aArticulos[ n, 2 ] )
               ::oDbfArt:Load()
               if !::oDbfArt:lNevObs
                  ::oDbfArt:lObs := .t.
               end if
               ::oDbfArt:Save()
            end if

      end case

   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SelDel()

   if len( ::aArticulos ) != 0
      ::aArticulos[ ::oBrwArticulos:nArrayAt, 1 ] := !::aArticulos[ ::oBrwArticulos:nArrayAt, 1 ]
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SelAllDel( lOpcion )

   aEval( ::aArticulos, {|a| a[ 1 ] := lOpcion } )

RETURN ( Self )

//---------------------------------------------------------------------------//