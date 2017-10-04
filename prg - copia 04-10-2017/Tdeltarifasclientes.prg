#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDelTarifasClientes

   DATA oDialog
   DATA oPages
   DATA oBtnSiguiente
   DATA oBtnPrevio
   DATA oMtrProceso
   DATA nMtrProceso
   DATA oBrwArticulos

   DATA oDbfCli
   DATA oCliAtp
   DATA oDbfFam
   DATA oDbfArt

   DATA nBmp

   DATA aArticulos      INIT { { .f., "", "" } }

   DATA dFechaInicial   INIT CtoD( "01/01/" + Str( Year( Date() ) ) )
   DATA dFechaFinal     INIT Date()

   DATA lTodasFamilias  INIT .t.
   DATA cFamiliaOrigen
   DATA cFamiliaDestino

   METHOD New()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource()

   METHOD BtnPrevio()

   METHOD BtnSiguiente()

   METHOD Search()

   METHOD BorraSeleccionados()

   METHOD SelDel()

   METHOD SelAllDel( lOpcion )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   if ::OpenFiles()
      ::Resource()
   end if

   ::CloseFiles()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF"    VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      DATABASE NEW ::oCliAtp PATH ( cPatCli() ) FILE "CLIATP.DBF"    VIA ( cDriver() ) SHARED INDEX "CLIATP.CDX"

      DATABASE NEW ::oDbfFam PATH ( cPatArt() ) FILE "FAMILIAS.DBF"  VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

      DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF"  VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      ::nBmp      := LoadBitmap( 0, 32760 )

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfCli )
      ::oDbfCli:End()
   end if

   if !Empty( ::oCliAtp )
      ::oCliAtp:End()
   end if

   if !Empty( ::oDbfFam )
      ::oDbfFam:End()
   end if

   if !Empty( ::oDbfArt )
      ::oDbfArt:End()
   end if

   if !Empty( ::nBmp )
      DeleteObject( ::nBmp )
   end if

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

   DEFINE DIALOG ::oDialog RESOURCE "ASS_EURO" TITLE "Eliminar tarifas de clientes"

   REDEFINE BITMAP oBmp RESOURCE "gc_delete_48" ID 500 TRANSPARENT OF ::oDialog

   REDEFINE PAGES ::oPages ID 110 OF ::oDialog ;
      DIALOGS "ASS_DELTAR01", "ASS_EURO02"

   REDEFINE GET ::dFechaInicial;
		SPINNER ;
      ID       100 ;
      OF       ::oPages:aDialogs[ 1 ]

   REDEFINE GET ::dFechaFinal;
		SPINNER ;
      ID       110 ;
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

 REDEFINE APOLOMETER ::oMtrProceso ;
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
   ::oBrwArticulos:cName                  := "Eliminar atipicas sin movimientos"

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

   local cCodFam

   ::oDialog:Disable()

   ::aArticulos               := {}

   aEval( ::oBrwArticulos:aArrayData, {|a,n| aDel( ::oBrwArticulos:aArrayData, n, .t. ), ::oBrwArticulos:Refresh() } )

   ::oMtrProceso:SetTotal( ::oCliAtp:Lastrec() )

   ::oCliAtp:GoTop()
   while !::oCliAtp:Eof()

      if ::oCliAtp:nTipAtp <= 1

         cCodFam              := oRetFld( ::oCliAtp:cCodArt, ::oDbfArt, "Familia" )

         if ( ::lTodasFamilias  .or. ( cCodFam >= ::cFamiliaOrigen .and. cCodFam <= ::cFamiliaDestino ) )   .and.;
            ( Empty( ::oCliAtp:dFecIni ) .or. ::oCliAtp:dFecIni <= ::dFechaInicial )                        .and.;
            ( !Empty( ::oCliAtp:dFecFin ) .and. ::oCliAtp:dFecFin <= ::dFechaFinal )

            aAdd( ::aArticulos, { .t., ::oCliAtp:cCodArt, oRetFld( ::oCliAtp:cCodArt, ::oDbfArt, "Nombre" ), ::oCliAtp:cCodCli, oRetFld( ::oCliAtp:cCodCli, ::oDbfCli, "Titulo" ), ::oCliAtp:Recno() } )

         end if

      else

         if ( ::lTodasFamilias  .or. ( ::oCliAtp:cCodFam >= ::cFamiliaOrigen .and. ::oCliAtp:cCodFam <= ::cFamiliaDestino ) ) .and.;
            ( Empty( ::oCliAtp:dFecIni ) .or. ::oCliAtp:dFecIni <= ::dFechaInicial )                                          .and.;
            ( !Empty( ::oCliAtp:dFecFin ) .and. ::oCliAtp:dFecFin <= ::dFechaFinal )

            aAdd( ::aArticulos, { .t., ::oCliAtp:cCodFam, oRetFld( ::oCliAtp:cCodFam, ::oDbfFam, "Nombre" ), ::oCliAtp:cCodCli, oRetFld( ::oCliAtp:cCodCli, ::oDbfCli, "Titulo" ), ::oCliAtp:Recno() } )

         end if

      end if

      ::oMtrProceso:Set( ::oCliAtp:OrdKeyNo() )

      ::oCliAtp:Skip()

   end while

   ::oMtrProceso:Set( ::oCliAtp:LastRec() )

   aEval( ::aArticulos, {|a| aAdd( ::oBrwArticulos:aArrayData, a ), ::oBrwArticulos:Refresh() } )

   ::oDialog:Enable()

Return ( Self )

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

      cText          += "Se van a eliminar " + Alltrim( Str( nBorrados ) ) + " tarifa de cliente." + CRLF

      if !ApoloMsgNoYes(cText, "Confirme proceso" )
         Return ( Self )
      end if

   end if

   for n := 1 to len( ::aArticulos )

      if ::aArticulos[ n, 1 ]

         ::oCliAtp:GoTo( ::aArticulos[ n, 6 ] )
         ::oCliAtp:Delete()

      end if

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