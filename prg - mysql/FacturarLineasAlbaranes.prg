#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS TFacturarLineasAlbaranes

   DATA oDlg

   DATA cPath

   DATA nView

   DATA cNumAlb
   DATA cNumFac

   DATA lPrint

   DATA cTmpAlbLin
   DATA cTmpFacLin

   DATA cTemporalLineaAlbaran
   DATA cTemporalLineaFactura

   DATA oBrwLineasAlbaran
   DATA oBrwLineasFactura

   DATA nPorcentajeAlbaran
   DATA nPorcentajeFactura

   DATA oBtnUnidadAlbaran
   DATA oBtnLineaAlbaran
   DATA oBtnTodoAlbaran

   DATA oBtnUnidadFactura
   DATA oBtnLineaFactura
   DATA oBtnTodoFactura

   DATA oPorcentajePropuestoAlbaran
   DATA nPorcentajePropuestoAlbaran
   DATA oPorcentajePropuestoFactura
   DATA nPorcentajePropuestoFactura

   DATA oSerieFactura
   DATA cSerieFactura
   DATA nNumeroFactura
   DATA cSufijoFactura
   DATA oFechaFactura
   DATA dFechaFactura

   DATA oSayNeto
   DATA nSayNeto
   DATA oSayIva
   DATA nSayIva
   DATA oSayTotal
   DATA nSayTotal
   DATA oSayTextoTotal
   
   DATA nTotalAlbaran

   DATA oColNetoAlbaran
   DATA oColNetoFactura

   DATA oColIVAAlbaran
   DATA oColIVAFactura

   DATA oColReqAlbaran
   DATA oColReqFactura

   DATA oColTotalAlbaran
   DATA oColTotalFactura

   METHOD FacturarLineas( cNumAlb )

   METHOD CreaTemporales()

   METHOD CargaTemporal()

   METHOD EliminaTemporales()

   METHOD Resource()

   METHOD InitResource()

   METHOD ActualizaPantalla()

   METHOD CalculaPorcentajes()

   METHOD PasaUnidadAlbaran()
   METHOD PasaLineaAlbaran()
   METHOD PasaTodoAlbaran()

   METHOD PasaUnidadFactura()
   METHOD PasaLineaFactura()
   METHOD PasaTodoFactura()

   METHOD GuardaAlbaran()

   METHOD GuardaAlbaranModa()

   METHOD GeneraFactura()

   METHOD EndResource()

   METHOD CalculaTotales()

   METHOD ChangePorcentajePropuestoAlbaran()

   METHOD ChangePorcentajePropuestoFactura()

   METHOD RecalculaPorcentajes()

   METHOD RefreshPorcentajePropuesto()    INLINE ( ::oPorcentajePropuestoAlbaran:Refresh(), ::oPorcentajePropuestoFactura:Refresh() )

   METHOD ComprobacionesCalculoPorcentajes()

   METHOD lPorcentajeAlcanzado() INLINE ( ( Round( ::nPorcentajeFactura, 0 ) < ::nPorcentajePropuestoFactura ) )

   METHOD SaltoRegistro()

   METHOD FacturarLineasCompletas( nView )

   METHOD ResourceLineasCompleta()

END CLASS

//---------------------------------------------------------------------------//

METHOD FacturarLineas( nView ) CLASS TFacturarLineasAlbaranes

   /*
   Tomamos los valores iniciales-----------------------------------------------
   */

   ::cNumFac   := ""
   ::lPrint    := .f.
   ::nView     := nView
   ::cNumAlb   := D():AlbaranesClientesId( ::nView ) 

   /*
   Comprobaciones antes de entrar----------------------------------------------
   */

   if lFacturado( D():Get( "AlbCliT", ::nView ) )
      msgStop( "Albarán ya facturado" )
      Return .f.
   end if

   if Empty( ( D():Get( "AlbCliT", ::nView ) )->cSerAlb )
      msgStop( "Tiene que seleccionar un albarán para facturarlo" )
      Return .f.
   end if      

   if ::nView < 1
      msgStop( "La vista creada no es válida" )
      Return .f.
   end if

   /*
   Valores iniciales ----------------------------------------------------------
   */

   ::nPorcentajeAlbaran             := 100
   ::nPorcentajeFactura             := 0

   if ( "MODA" $ appParamsMain() )
      ::nPorcentajePropuestoAlbaran := 50
      ::nPorcentajePropuestoFactura := 50
   else
      ::nPorcentajePropuestoAlbaran := 100
      ::nPorcentajePropuestoFactura := 0
   end if 

   ::nSayNeto                       := 0
   ::nSayIva                        := 0
   ::nSayTotal                      := 0

   ::cSerieFactura                  := "A"
   ::dFechaFactura                  := GetSysDate()

   /*
   Creamos los temporales necesarios-------------------------------------------
   */

   ::CreaTemporales()

   /*
   Montamos el recurso---------------------------------------------------------
   */

   ::Resource()

   /*
   Destruimos las temporales---------------------------------------------------
   */

   ::EliminaTemporales()

Return ( ::lPrint )

//---------------------------------------------------------------------------//

METHOD CreaTemporales() CLASS TFacturarLineasAlbaranes

   local cDbfAlbLin     := "ACliL"
   local cDbfFacLin     := "FCliL"

   ::cTmpAlbLin         := cGetNewFileName( cPatTmp() + cDbfAlbLin )
   ::cTmpFacLin         := cGetNewFileName( cPatTmp() + cDbfFacLin )

   /*
   Creamos la base de datos temporal de lineas de albaranes--------------------
   */

   dbCreate( ::cTmpAlbLin, aSqlStruct( aColAlbCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), ::cTmpAlbLin, cCheckArea( cDbfAlbLin, @::cTemporalLineaAlbaran ), .f. )

   ( ::cTemporalLineaAlbaran )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
   ( ::cTemporalLineaAlbaran )->( OrdCreate( ::cTmpAlbLin, "cLinArt", "Str( nNumLin, 4 ) + cRef", {|| Str( Field->nNumLin ) + Field->cRef } ) )

   ( ::cTemporalLineaAlbaran )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
   ( ::cTemporalLineaAlbaran )->( OrdCreate( ::cTmpAlbLin, "nNumAlb", "Str( Recno() )", {|| Str( Recno() ) } ) )

   /*
   Pasamos la información de la tabla definitiva a la temporal-----------------
   */

   ::CargaTemporal()

   /*
   Creamos la base de datos temporal de lineas de facturas---------------------
   */

   dbCreate( ::cTmpFacLin, aSqlStruct( aColAlbCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), ::cTmpFacLin, cCheckArea( cDbfFacLin, @::cTemporalLineaFactura ), .f. )

   ( ::cTemporalLineaFactura )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
   ( ::cTemporalLineaFactura )->( OrdCreate( ::cTmpFacLin, "cLinArt", "Str( nNumLin, 4 ) + cRef", {|| Str( Field->nNumLin ) + Field->cRef } ) )

   ( ::cTemporalLineaFactura )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
   ( ::cTemporalLineaFactura )->( OrdCreate( ::cTmpFacLin, "nNumFac", "Str( Recno() )", {|| Str( Recno() ) } ) )

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD CargaTemporal() CLASS TFacturarLineasAlbaranes

   if ( D():Get( "AlbCliL", ::nView ) )->( dbSeek( ::cNumAlb ) )
      while ( ( D():Get( "AlbCliL", ::nView ) )->cSerAlb + Str( ( D():Get( "AlbCliL", ::nView ) )->nNumAlb ) + ( D():Get( "AlbCliL", ::nView ) )->cSufAlb ) == ::cNumAlb .and. !( D():Get( "AlbCliL", ::nView ) )->( eof() )
         dbPass( D():Get( "AlbCliL", ::nView ), ::cTemporalLineaAlbaran, .t. )
         ( D():Get( "AlbCliL", ::nView ) )->( dbSkip() )
      end while
      end if

   ( ::cTemporalLineaAlbaran )->( dbGoTop() )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD EliminaTemporales() CLASS TFacturarLineasAlbaranes

   if !Empty( ::cTemporalLineaAlbaran ) .and. ( ::cTemporalLineaAlbaran )->( Used() )
      ( ::cTemporalLineaAlbaran )->( dbCloseArea() )
   end if

   if !Empty( ::cTemporalLineaFactura ) .and. ( ::cTemporalLineaFactura )->( Used() )
      ( ::cTemporalLineaFactura )->( dbCloseArea() )
   end if

   ::cTemporalLineaAlbaran      := nil
   ::cTemporalLineaFactura      := nil

   dbfErase( ::cTmpAlbLin )
   dbfErase( ::cTmpFacLin )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TFacturarLineasAlbaranes

   local oFont             := TFont():New( "Arial", 8, 26, .F., .T. )

   DEFINE DIALOG ::oDlg RESOURCE "FacturaLineasAlbaranes"

      /*
      Porcentaje propuesto de albarán------------------------------------------
      */

      REDEFINE GET ::oPorcentajePropuestoAlbaran ;
         VAR      ::nPorcentajePropuestoAlbaran ;
         ID       100 ;
         VALID    ( ::nPorcentajePropuestoAlbaran > 0 .and. ::nPorcentajePropuestoAlbaran < 101 );
         PICTURE  "999";
         SPINNER ;
         MIN      0 ;
         MAX      100 ;
         OF       ::oDlg

         ::oPorcentajePropuestoAlbaran:bChange  := {|| ::ChangePorcentajePropuestoAlbaran() }

      TBtnBmp():ReDefine( 101, "gc_recycle_16",,,,,{|| ::RecalculaPorcentajes() }, ::oDlg, .f., , .f.,  )      

      /*
      Detalle de albaranes-----------------------------------------------------
      */

      ::oBrwLineasAlbaran                 := IXBrowse():New( ::oDlg )

      ::oBrwLineasAlbaran:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwLineasAlbaran:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwLineasAlbaran:bClrStd         := {|| { if( ( ::cTemporalLineaAlbaran )->lKitChl, CLR_GRAY, CLR_BLACK ), GetSysColor( COLOR_WINDOW ) } }

      ::oBrwLineasAlbaran:cAlias          := ::cTemporalLineaAlbaran

      ::oBrwLineasAlbaran:lFooter         := .t.

      ::oBrwLineasAlbaran:nMarqueeStyle   := 6
      ::oBrwLineasAlbaran:cName           := "Temporal albaran clientes"

      ::oBrwLineasAlbaran:CreateFromResource( 110 )

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Código"
         :bEditValue          := {|| ( ::cTemporalLineaAlbaran )->cRef }
         :nWidth              := 40
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| Descrip( ::cTemporalLineaAlbaran ) }
         :nWidth              := 175
         :bFooter             := {|| Trans( ::nPorcentajeAlbaran, "@E 999.99%" ) }
         :nFootStrAlign       := AL_RIGHT
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Prop. 1"
         :bEditValue          := {|| ( ::cTemporalLineaAlbaran )->cValPr1 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Prop. 2"
         :bEditValue          := {|| ( ::cTemporalLineaAlbaran )->cValPr2 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Lote"
         :bEditValue          := {|| ( ::cTemporalLineaAlbaran )->cLote }
         :nWidth              := 60
         :lHide               := .t.
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Caducidad"
         :bEditValue          := {|| Dtoc( ( ::cTemporalLineaAlbaran)->dFecCad ) }
         :nWidth              := 60
         :lHide               := .t.
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := cNombreCajas()
         :bEditValue          := {|| ( ::cTemporalLineaAlbaran )->nCanEnt }
         :cEditPicture        := MasUnd()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| ( ::cTemporalLineaAlbaran )->nUniCaja }
         :cEditPicture        := MasUnd()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Total " + cNombreUnidades()
         :bEditValue          := {|| nTotNAlbCli( ::cTemporalLineaAlbaran ) }
         :cEditPicture        := MasUnd()
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Precio"
         :bEditValue          := {|| nNetUAlbCli( ::cTemporalLineaAlbaran ) }
         :cEditPicture        := cPouDiv()
         :nWidth              := 55
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      if ( "MODA" $ appParamsMain() )

      with object ( ::oColTotalAlbaran := ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nNetLAlbCli( D():Get( "AlbCliT", ::nView ), ::cTemporalLineaAlbaran, , , , .f. ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      else

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "% " + cImp()
         :bEditValue          := {|| ( ::cTemporalLineaAlbaran )->nIva }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 35
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oColNetoAlbaran := ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Base"
         :bEditValue          := {|| nNetLAlbCli( D():Get( "AlbCliT", ::nView ), ::cTemporalLineaAlbaran, , , , .f. ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( ::oColIVAAlbaran := ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "IVA"
         :bEditValue          := {|| nIvaLAlbCli( ::cTemporalLineaAlbaran ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 45
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
         :lHide               := .t.
      end with

      with object ( ::oColReqAlbaran := ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "R.E."
         :bEditValue          := {|| nReqLAlbCli( ::cTemporalLineaAlbaran ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 45
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
         :lHide               := .t.
      end with

      with object ( ::oColTotalAlbaran := ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nNetLAlbCli( D():Get( "AlbCliT", ::nView ), ::cTemporalLineaAlbaran, , , , .f. ) + nIvaLAlbCli( ::cTemporalLineaAlbaran ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 45
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
         :lHide               := .t.
      end with

      end if

      /*
      Botones de albaran-------------------------------------------------------
      */

      REDEFINE BUTTON ::oBtnUnidadAlbaran;
         ID       140 ;
         OF       ::oDlg ;
         ACTION   ( ::PasaUnidadAlbaran() )

      REDEFINE BUTTON ::oBtnLineaAlbaran;
         ID       130 ;
         OF       ::oDlg ;
         ACTION   ( ::PasaLineaAlbaran() )

      REDEFINE BUTTON ::oBtnTodoAlbaran;
         ID       120 ;
         OF       ::oDlg ;
         ACTION   ( ::PasaTodoAlbaran() )

      /*
      Porcentaje propuesto de factura------------------------------------------
      */

      REDEFINE GET ::oPorcentajePropuestoFactura ;
         VAR      ::nPorcentajePropuestoFactura ;
         ID       200 ;
         VALID    ( ::nPorcentajePropuestoFactura > 0 .and. ::nPorcentajePropuestoFactura < 101 );
         PICTURE  "999";
         SPINNER ;
         MIN      0 ;
         MAX      100 ;
         OF       ::oDlg   

         ::oPorcentajePropuestoFactura:bChange  := {|| ::ChangePorcentajePropuestoFactura() }

      TBtnBmp():ReDefine( 201, "gc_recycle_16",,,,,{|| ::RecalculaPorcentajes() }, ::oDlg, .f., , .f.,  )   

      /*
      Serie de la factura------------------------------------------------------
      */   

      REDEFINE GET ::oSerieFactura VAR ::cSerieFactura ;
         ID       210 ;
         SPINNER ;
         ON UP    ( UpSerie( ::oSerieFactura ) );
         ON DOWN  ( DwSerie( ::oSerieFactura ) );
         PICTURE  "@!" ;
         VALID    ( ::cSerieFactura >= "A" .AND. ::cSerieFactura <= "Z"  );
         OF       ::oDlg

      /*
      Fecha de la factura------------------------------------------------------
      */   

      REDEFINE GET ::oFechaFactura VAR ::dFechaFactura;
         ID       220 ;  
         SPINNER ;
         OF       ::oDlg

      /*
      Detalle de facturas------------------------------------------------------
      */

      ::oBrwLineasFactura                 := IXBrowse():New( ::oDlg )

      ::oBrwLineasFactura:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwLineasFactura:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwLineasFactura:bClrStd         := {|| { if( ( ::cTemporalLineaFactura )->lKitChl, CLR_GRAY, CLR_BLACK ), GetSysColor( COLOR_WINDOW ) } }

      ::oBrwLineasFactura:cAlias          := ::cTemporalLineaFactura

      ::oBrwLineasFactura:lFooter         := .t.

      ::oBrwLineasFactura:nMarqueeStyle   := 6
      ::oBrwLineasFactura:cName           := "Temporal facturas clientes"

      ::oBrwLineasFactura:CreateFromResource( 230 )

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Código"
         :bEditValue          := {|| ( ::cTemporalLineaFactura )->cRef }
         :nWidth              := 40
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Descripción"
         :bEditValue          := {|| Descrip( ::cTemporalLineaFactura ) }
         :nWidth              := 175
         :bFooter             := {|| Trans( ::nPorcentajeFactura, "@E 999.99%" ) }
         :nFootStrAlign       := AL_RIGHT
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Prop. 1"
         :bEditValue          := {|| ( ::cTemporalLineaFactura )->cValPr1 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Prop. 2"
         :bEditValue          := {|| ( ::cTemporalLineaFactura )->cValPr2 }
         :nWidth              := 40
         :lHide               := .t.
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Lote"
         :bEditValue          := {|| ( ::cTemporalLineaFactura )->cLote }
         :nWidth              := 60
         :lHide               := .t.
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Caducidad"
         :bEditValue          := {|| Dtoc( ( ::cTemporalLineaFactura )->dFecCad ) }
         :nWidth              := 60
         :lHide               := .t.
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := cNombreCajas()
         :bEditValue          := {|| ( ::cTemporalLineaFactura )->nCanEnt }
         :cEditPicture        := MasUnd()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := cNombreUnidades()
         :bEditValue          := {|| ( ::cTemporalLineaFactura )->nUniCaja }
         :cEditPicture        := MasUnd()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :lHide               := .t.
         :nFooterType         := AGGR_SUM
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Total " + cNombreUnidades()
         :bEditValue          := {|| nTotNAlbCli( ::cTemporalLineaFactura ) }
         :cEditPicture        := MasUnd()
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Precio"
         :bEditValue          := {|| nNetUAlbCli( ::cTemporalLineaFactura ) }
         :cEditPicture        := cPouDiv()
         :nWidth              := 55
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "% " + cImp()
         :bEditValue          := {|| ( ::cTemporalLineaFactura )->nIva }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 35
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oColNetoFactura := ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Base"
         :bEditValue          := {|| nNetLAlbCli( D():Get( "AlbCliT", ::nView ), ::cTemporalLineaFactura, , , , .f. ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( ::oColIVAFactura := ::oBrwLineasFactura:AddCol() )
         :cHeader             := "IVA"
         :bEditValue          := {|| nIvaLAlbCli( ::cTemporalLineaFactura ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
         :lHide               := .t.
      end with

      with object ( ::oColReqFactura := ::oBrwLineasFactura:AddCol() )
         :cHeader             := "R.E."
         :bEditValue          := {|| nReqLAlbCli( ::cTemporalLineaFactura ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
         :lHide               := .t.
      end with

      with object ( ::oColTotalFactura := ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nNetLAlbCli( D():Get( "AlbCliT", ::nView ), ::cTemporalLineaFactura, , , , .f. ) + nIvaLAlbCli( ::cTemporalLineaFactura ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
         :lHide               := .t.
      end with

      /*
      Botones facturas---------------------------------------------------------
      */

      REDEFINE BUTTON ::oBtnUnidadFactura;
         ID       240 ;
         OF       ::oDlg ;
         ACTION   ( ::PasaUnidadFactura )

      REDEFINE BUTTON ::oBtnLineaFactura;
         ID       250 ;
         OF       ::oDlg ;
         ACTION   ( ::PasaLineaFactura )

      REDEFINE BUTTON ::oBtnTodoFactura;
         ID       260 ;
         OF       ::oDlg ;
         ACTION   ( ::PasaTodoFactura )

      /*
      Say de totales-----------------------------------------------------------
      */

      REDEFINE SAY ::oSayNeto VAR ::nSayNeto ;
         ID       270 ;
         OF       ::oDlg

      REDEFINE SAY ::oSayIva VAR ::nSayIva ;
         ID       280 ;
         OF       ::oDlg
         
      REDEFINE SAY ::oSayTotal VAR ::nSayTotal ;
         ID       290 ;
         FONT     oFont ;
         OF       ::oDlg

      REDEFINE SAY ::oSayTextoTotal ;
         ID       291 ;
         FONT     oFont ;
         OF       ::oDlg

      /*
      Botones generales--------------------------------------------------------
      */   

      REDEFINE BUTTON ;
         ID       500 ;
         OF       ::oDlg ;
         ACTION   ( ::EndResource( .t. ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         ACTION   ( ::EndResource() )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         CANCEL ;
         ACTION   ( ::oDlg:End() )

      if ( "MODA" $ appParamsMain() )
         ::oDlg:bStart  := {|| ::RecalculaPorcentajes() }
      else
         ::oDlg:bStart  := {|| ::ActualizaPantalla() }
      end if   

      ::oDlg:Activate( , , , .t., , , {|| ::InitResource() } )

      ::oBrwLineasAlbaran:CloseData()
      ::oBrwLineasFactura:CloseData()

      oFont:End()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD InitResource() CLASS TFacturarLineasAlbaranes

   ::oBrwLineasAlbaran:Load()

   ::oBrwLineasFactura:Load()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD PasaUnidadAlbaran() CLASS TFacturarLineasAlbaranes

   /*
   Comprobamos que hayan registros que pasar-----------------------------------
   */

   if ( ::cTemporalLineaAlbaran )->( OrdKeyCount() ) == 0
      Return .t.
   end if

   /*
   Pasamos los registros-------------------------------------------------------
   */

   do case
      case ( ::cTemporalLineaAlbaran )->nUniCaja > 1

         if !dbSeekInOrd( Str( ( ::cTemporalLineaAlbaran )->nNumLin, 4 ) + ( ::cTemporalLineaAlbaran )->cRef , "cLinArt", ::cTemporalLineaFactura )

            dbPass( ::cTemporalLineaAlbaran, ::cTemporalLineaFactura, .t. )
            
            if dbDialogLock( ::cTemporalLineaFactura )
               ( ::cTemporalLineaFactura )->nUniCaja := 1
               ( ::cTemporalLineaFactura )->( dbUnLock() )
            end if   

         else

            if dbDialogLock( ::cTemporalLineaFactura )
               ( ::cTemporalLineaFactura )->nUnicaja++
               ( ::cTemporalLineaFactura )->( dbUnLock() )
            end if

         end if

         if dbDialogLock( ::cTemporalLineaAlbaran )
            ( ::cTemporalLineaAlbaran )->nUniCaja--
            ( ::cTemporalLineaAlbaran )->( dbUnLock() )
         end if

      case ( ::cTemporalLineaAlbaran )->nUniCaja <= 0

         dbPass( ::cTemporalLineaAlbaran, ::cTemporalLineaFactura, .t. )

         if dbDialogLock( ::cTemporalLineaAlbaran )
            ( ::cTemporalLineaAlbaran )->( dbDelete() )
            ( ::cTemporalLineaAlbaran )->( dbUnLock() )
         end if         

      otherwise // == 1

         if !dbSeekInOrd( Str( ( ::cTemporalLineaAlbaran )->nNumLin, 4 ) + ( ::cTemporalLineaAlbaran )->cRef , "cLinArt", ::cTemporalLineaFactura )

            dbPass( ::cTemporalLineaAlbaran, ::cTemporalLineaFactura, .t. )
            
         else

            if dbDialogLock( ::cTemporalLineaFactura )
               ( ::cTemporalLineaFactura )->nUniCaja++
               ( ::cTemporalLineaFactura )->( dbUnLock() )
            end if

         end if

         if dbDialogLock( ::cTemporalLineaAlbaran )
            ( ::cTemporalLineaAlbaran )->( dbDelete() )
            ( ::cTemporalLineaAlbaran )->( dbUnLock() )
         end if

   end case

   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPantalla()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaLineaAlbaran() CLASS TFacturarLineasAlbaranes

   if ( ::cTemporalLineaAlbaran )->( OrdKeyCount() ) == 0
      Return .t.
   end if

   /*
   Añado a la tabla de facturas------------------------------------------------
   */

   dbPass( ::cTemporalLineaAlbaran, ::cTemporalLineaFactura, .t. )

   /*
   Elimino de albaranes--------------------------------------------------------
   */

   if dbDialogLock( ::cTemporalLineaAlbaran )
      ( ::cTemporalLineaAlbaran )->( dbDelete() )
      ( ::cTemporalLineaAlbaran )->( dbUnLock() )
   end if

   if ( ::cTemporalLineaAlbaran )->( OrdKeyCount() ) == 0
      ( ::cTemporalLineaAlbaran )->( __dbZap() )
   end if

   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPantalla()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaTodoAlbaran() CLASS TFacturarLineasAlbaranes

   /*
   Añado a la tabla de facturas------------------------------------------------
   */

   ( ::cTemporalLineaAlbaran )->( dbGoTop() )

   while !( ::cTemporalLineaAlbaran )->( Eof() )

      dbPass( ::cTemporalLineaAlbaran, ::cTemporalLineaFactura, .t. )

      ( ::cTemporalLineaAlbaran )->( dbSkip() )

   end while

   /*
   Elimino de albaranes--------------------------------------------------------
   */

   ( ::cTemporalLineaAlbaran )->( __dbZap() )

   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPantalla()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaUnidadFactura() CLASS TFacturarLineasAlbaranes

   /*
   Comprobamos que hayan registros que pasar-----------------------------------
   */

   if ( ::cTemporalLineaFactura )->( OrdKeyCount() ) == 0
      Return .t.
   end if

   /*
   Pasamos los registros-------------------------------------------------------
   */

   do case
      case ( ::cTemporalLineaFactura )->nUniCaja > 1

         if !dbSeekInOrd( Str( ( ::cTemporalLineaFactura )->nNumLin, 4 ) + ( ::cTemporalLineaFactura )->cRef , "cLinArt", ::cTemporalLineaAlbaran )

            dbPass( ::cTemporalLineaFactura, ::cTemporalLineaAlbaran, .t. )
            
            if dbDialogLock( ::cTemporalLineaAlbaran )
               ( ::cTemporalLineaAlbaran )->nUniCaja := 1
               ( ::cTemporalLineaAlbaran )->( dbUnLock() )
            end if   

         else

            if dbDialogLock( ::cTemporalLineaAlbaran )
               ( ::cTemporalLineaAlbaran )->nUnicaja++
               ( ::cTemporalLineaAlbaran )->( dbUnLock() )
            end if

         end if

         if dbDialogLock( ::cTemporalLineaFactura )
            ( ::cTemporalLineaFactura )->nUniCaja--
            ( ::cTemporalLineaFactura )->( dbUnLock() )
         end if

      case ( ::cTemporalLineaFactura )->nUniCaja <= 0

         dbPass( ::cTemporalLineaFactura, ::cTemporalLineaAlbaran, .t. )

         if dbDialogLock( ::cTemporalLineaFactura )
            ( ::cTemporalLineaFactura )->( dbDelete() )
            ( ::cTemporalLineaFactura )->( dbUnLock() )
         end if         

      otherwise

         if !dbSeekInOrd( Str( ( ::cTemporalLineaFactura )->nNumLin, 4 ) + ( ::cTemporalLineaFactura )->cRef , "cLinArt", ::cTemporalLineaAlbaran )

            dbPass( ::cTemporalLineaFactura, ::cTemporalLineaAlbaran, .t. )
            
         else

            if dbDialogLock( ::cTemporalLineaAlbaran )
               ( ::cTemporalLineaAlbaran )->nUniCaja++
               ( ::cTemporalLineaAlbaran )->( dbUnLock() )
            end if

         end if

         if dbDialogLock( ::cTemporalLineaFactura )
            ( ::cTemporalLineaFactura )->( dbDelete() )
            ( ::cTemporalLineaFactura )->( dbUnLock() )
         end if

   end case
   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPantalla()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaLineaFactura() CLASS TFacturarLineasAlbaranes

   /*
   Comprobamos que haya mas registros------------------------------------------
   */

   if ( ::cTemporalLineaFactura )->( OrdKeyCount() ) == 0
      Return .f.
   end if

   /*
   Añado a la tabla de facturas------------------------------------------------
   */

   dbPass( ::cTemporalLineaFactura, ::cTemporalLineaAlbaran, .t. )

   /*
   Elimino de albaranes--------------------------------------------------------
   */

   if dbDialogLock( ::cTemporalLineaFactura )
      ( ::cTemporalLineaFactura )->( dbDelete() )
      ( ::cTemporalLineaFactura )->( dbUnLock() )
   end if

   if ( ::cTemporalLineaFactura )->( OrdKeyCount() ) == 0
      ( ::cTemporalLineaFactura )->( __dbZap() )
   end if

   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPantalla()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaTodoFactura() CLASS TFacturarLineasAlbaranes

   /*
   Elimino de albaran----------------------------------------------------------
   */

   ( ::cTemporalLineaAlbaran )->( __dbZap() )


   /*
   Cargo de albaran------------------------------------------------------------
   */   

   ::CargaTemporal()

   /*
   Elimino de factura----------------------------------------------------------
   */

   ( ::cTemporalLineaFactura )->( __dbZap() )

   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPantalla()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ActualizaPantalla() CLASS TFacturarLineasAlbaranes

   /*
   Refrescamos los browse------------------------------------------------------
   */

   if !Empty( ::oBrwLineasAlbaran )
      ::oBrwLineasAlbaran:MakeTotals()
      ::oBrwLineasAlbaran:Refresh()
   end if

   if !Empty( ::oBrwLineasFactura )
      ::oBrwLineasFactura:MakeTotals()
      ::oBrwLineasFactura:Refresh()
   end if

   /*
   Calculamos los porcentajes del Browse---------------------------------------
   */

   ::CalculaPorcentajes()

   /*
   Calcula totales-------------------------------------------------------------
   */

   ::CalculaTotales()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CalculaPorcentajes() CLASS TFacturarLineasAlbaranes

   local nTotal

   ::oBrwLineasAlbaran:MakeTotals()
   ::oBrwLineasFactura:MakeTotals()

   nTotal                  := ::oColTotalAlbaran:nTotal + ::oColTotalFactura:nTotal

   ::nPorcentajeAlbaran    := ( ::oColTotalAlbaran:nTotal * 100 ) / nTotal

   ::nPorcentajeFactura    := ( ::oColTotalFactura:nTotal * 100 ) / nTotal

   /*
   Refrescamos los browse------------------------------------------------------
   */

   if !Empty( ::oBrwLineasAlbaran )
      ::oBrwLineasAlbaran:Refresh()
   end if

   if !Empty( ::oBrwLineasFactura )
      ::oBrwLineasFactura:Refresh()
   end if
   
Return ( Self )

//---------------------------------------------------------------------------//

METHOD EndResource( lPrint ) CLASS TFacturarLineasAlbaranes

   DEFAULT lPrint    := .f.

   if ( ::cTemporalLineaFactura )->( OrdKeyCount() ) == 0
      MsgStop( "Tiene que pasar al menos una línea del albarán para crear una nueva factura." )
      Return .f.
   end if

   /*
   Guardamos el albarán--------------------------------------------------------
   */

   if ( "MODA" $ appParamsMain() )
      ::GuardaAlbaranModa()
   else
      ::GuardaAlbaran()
   end if   

   /*
   Guardamos la factura--------------------------------------------------------
   */

   ::GeneraFactura()

   /*
   Imprimimos los documentos---------------------------------------------------
   */

   if lPrint
      ::lPrint       := lPrint
      PrnFacCli( ::cNumFac )
   end if 

   /*
   Cerramos el diálogo---------------------------------------------------------
   */  

   ::oDlg:End( IDOK )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GuardaAlbaran() CLASS TFacturarLineasAlbaranes

   local aTotAlb

   /*
   Hacemos un RollBack---------------------------------------------------------
   */

   while ( D():Get( "AlbCliL", ::nView ) )->( dbSeek( ::cNumAlb ) ) .and. !( D():Get( "AlbCliL", ::nView ) )->( eof() )
      if dbLock( D():Get( "AlbCliL", ::nView ) )
         ( D():Get( "AlbCliL", ::nView ) )->( dbDelete() )
         ( D():Get( "AlbCliL", ::nView ) )->( dbUnLock() )
      end if
   end while

   /*
   Escribimos definitivamente en la tabla--------------------------------------
   */

   ( ::cTemporalLineaAlbaran )->( dbGoTop() )

   while !( ::cTemporalLineaAlbaran )->( eof() )

      dbPass( ::cTemporalLineaAlbaran, D():Get( "AlbCliL", ::nView ), .t. )

      ( ::cTemporalLineaAlbaran )->( dbSkip() )

   end while

   /*
   Rellenamos los campos de totales de la factura------------------------------
   */

   aTotAlb  := aTotAlbCli( ::cNumAlb,;
                           D():Get( "AlbCliT", ::nView ),;
                           D():Get( "AlbCliL", ::nView ),;
                           D():Get( "TIva", ::nView ),;
                           D():Get( "Divisas", ::nView ) )

   if dbLock( D():Get( "AlbCliT", ::nView ) )
      ( D():Get( "AlbCliT", ::nView ) )->nTotNet    := aTotAlb[1]
      ( D():Get( "AlbCliT", ::nView ) )->nTotIva    := aTotAlb[2]
      ( D():Get( "AlbCliT", ::nView ) )->nTotReq    := aTotAlb[3]
      ( D():Get( "AlbCliT", ::nView ) )->nTotAlb    := aTotAlb[4]
      ( D():Get( "AlbCliT", ::nView ) )->( dbUnLock() )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GuardaAlbaranModa() CLASS TFacturarLineasAlbaranes

   local aTotAlb

   /*
   Hacemos un RollBack---------------------------------------------------------
   */

   while ( D():Get( "AlbCliL", ::nView ) )->( dbSeek( ::cNumAlb ) ) .and. !( D():Get( "AlbCliL", ::nView ) )->( eof() )
      if dbLock( D():Get( "AlbCliL", ::nView ) )
         ( D():Get( "AlbCliL", ::nView ) )->( dbDelete() )
         ( D():Get( "AlbCliL", ::nView ) )->( dbUnLock() )
      end if
   end while

   /*
   Escribimos definitivamente en la tabla--------------------------------------
   */

   ( ::cTemporalLineaAlbaran )->( dbGoTop() )

   while !( ::cTemporalLineaAlbaran )->( eof() )

      appendRegisterByHash(::cTemporalLineaAlbaran,;
                  D():Get( "AlbCliL", ::nView ),;
                  {  "nIva" => 0,;
                     "nReq" => 0 } )

      ( ::cTemporalLineaAlbaran )->( dbSkip() )

   end while

   /*
   Rellenamos los campos de totales de la factura------------------------------
   */

   aTotAlb  := aTotAlbCli( ::cNumAlb,;
                           D():Get( "AlbCliT", ::nView ),;
                           D():Get( "AlbCliL", ::nView ),;
                           D():Get( "TIva", ::nView ),;
                           D():Get( "Divisas", ::nView ) )

   if dbLock( D():Get( "AlbCliT", ::nView ) )
      ( D():Get( "AlbCliT", ::nView ) )->nTotNet    := aTotAlb[1]
      ( D():Get( "AlbCliT", ::nView ) )->nTotIva    := aTotAlb[2]
      ( D():Get( "AlbCliT", ::nView ) )->nTotReq    := aTotAlb[3]
      ( D():Get( "AlbCliT", ::nView ) )->nTotAlb    := aTotAlb[4]
      ( D():Get( "AlbCliT", ::nView ) )->( dbUnLock() )
   end if

Return ( Self )


//---------------------------------------------------------------------------//

METHOD GeneraFactura() CLASS TFacturarLineasAlbaranes

   local aTotFac

   ::oDlg:Disable()

   CursorWait()

   /*
   Pasamos la cabecera de la factura-------------------------------------------
   */

   ::nNumeroFactura     := nNewDoc( ::cSerieFactura, D():Get( "FacCliT", ::nView ), "NFACCLI", , D():Get( "NCount", ::nView ) )
   ::cSufijoFactura     := ( D():Get( "AlbCliT", ::nView ) )->cSufAlb

   ::cNumFac            := ::cSerieFactura + Str( ::nNumeroFactura ) + ::cSufijoFactura

   /*
   Pasamos los datos de la cabecera--------------------------------------------
   */

   appendRegisterByHash(D():Get( "AlbCliT", ::nView ),;
               D():Get( "FacCliT", ::nView ),;
               {  "cSerie"    => ::cSerieFactura,;
                  "nNumFac"   => ::nNumeroFactura,;
                  "cSufFac"   => ::cSufijoFactura,;
                  "dFecFac"   => ::dFechaFactura,;
                  "cTurFac"   => cCurSesion(),;
                  "lCloFac"   => .f. } )

   /*
   Pasamos los datos de las lineas---------------------------------------------
   */

   ( ::cTemporalLineaFactura )->( dbGoTop() )

   while !( ::cTemporalLineaFactura )->( Eof() )

      appendRegisterByHash(::cTemporalLineaFactura,;
                  D():Get( "FacCliL", ::nView ),;
                  {  "cSerie"    => ::cSerieFactura,;
                     "nNumFac"   => ::nNumeroFactura,;
                     "cSufFac"   => ::cSufijoFactura,;
                     "dFecFac"   => ::dFechaFactura,;
                     "cCodAlb"   => ::cNumAlb } )

      ( ::cTemporalLineaFactura )->( dbSkip() )

   end while   

   /*
   Rellenamos los campos de totales de la factura------------------------------
   */

   aTotFac  := aTotFacCli( ::cSerieFactura + str( ::nNumeroFactura ) + ::cSufijoFactura,;
                           D():Get( "FacCliT", ::nView ),;
                           D():Get( "FacCliL", ::nView ),;
                           D():Get( "TIva", ::nView ),;
                           D():Get( "Divisas", ::nView ),;
                           D():Get( "FacCliP", ::nView ),;
                           D():Get( "AntCliT", ::nView ) )

   if dbLock( D():Get( "FacCliT", ::nView ) )
      ( D():Get( "FacCliT", ::nView ) )->nTotNet    := aTotFac[1]
      ( D():Get( "FacCliT", ::nView ) )->nTotIva    := aTotFac[2]
      ( D():Get( "FacCliT", ::nView ) )->nTotReq    := aTotFac[3]
      ( D():Get( "FacCliT", ::nView ) )->nTotFac    := aTotFac[4]
      ( D():Get( "FacCliT", ::nView ) )->( dbUnLock() )
   end if   

   /*
   Generamos los pagos de la factura-------------------------------------------
   */

   GenPgoFacCli( ::cSerieFactura + Str( ::nNumeroFactura ) + ::cSufijoFactura,;
                 D():Get( "FacCliT", ::nView ),;
                 D():Get( "FacCliL", ::nView ),;
                 D():Get( "FacCliP", ::nView ),;
                 D():Get( "AntCliT", ::nView ),;
                 D():Get( "Client", ::nView ),;
                 D():Get( "FPago", ::nView ),;
                 D():Get( "Divisas", ::nView ),; 
                 D():Get( "TIva", ::nView ),;
                 APPD_MODE )

   /*
   Checkeamos el estado de la factura------------------------------------------
   */

   ChkLqdFacCli( nil,;
                 D():Get( "FacCliT", ::nView ),;
                 D():Get( "FacCliL", ::nView ),;
                 D():Get( "FacCliP", ::nView ),;
                 D():Get( "AntCliT", ::nView ),;
                 D():Get( "TIva", ::nView ),;
                 D():Get( "Divisas", ::nView ) )

   /*
   Quito el recargo del albaran en modo modas----------------------------------
   */

   if ( "MODA" $ appParamsMain() )

      if dbLock( D():Get( "AlbCliT", ::nView ) )
         ( D():Get( "AlbCliT", ::nView ) )->lRecargo   := .f.
         ( D():Get( "AlbCliT", ::nView ) )->( dbUnLock() )
      end if

   end if   

   CursorWe()

   ::oDlg:Enable()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CalculaTotales() CLASS TFacturarLineasAlbaranes

   /*
   Calculamos los totales------------------------------------------------------
   */

   if ( "MODA" $ appParamsMain() )

      ::nSayNeto     := ::oColTotalAlbaran:nTotal + ::oColNetoFactura:nTotal

      ::nSayIva      := ::oColIVAFactura:nTotal

      ::nSayTotal    := ::oColTotalAlbaran:nTotal + ::oColTotalFactura:nTotal   

      if ( D():Get( "AlbCliT", ::nView ) )->lRecargo
         ::nSayIva   += ::oColReqFactura:nTotal
         ::nSayTotal += ::oColReqFactura:nTotal
      end if   

   else

      ::nSayNeto  := ::oColNetoAlbaran:nTotal + ::oColNetoFactura:nTotal

      ::nSayIva   := ::oColIVAAlbaran:nTotal + ::oColIVAFactura:nTotal

      ::nSayTotal := ::oColTotalAlbaran:nTotal + ::oColTotalFactura:nTotal

      if ( D():Get( "AlbCliT", ::nView ) )->lRecargo
         ::nSayIva   += ::oColReqAlbaran:nTotal
         ::nSayIva   += ::oColReqFactura:nTotal
         ::nSayTotal += ::oColReqAlbaran:nTotal
         ::nSayTotal += ::oColReqFactura:nTotal
      end if

   end if

   /*
   Refrescamos los totales-----------------------------------------------------
   */

   if !Empty( ::oSayNeto )
      ::oSayNeto:Refresh()
   end if
   
   if !Empty( ::oSayIva )
      ::oSayIva:Refresh()
   end if   

   if !Empty( ::oSayTotal )
      ::oSayTotal:Refresh()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ChangePorcentajePropuestoAlbaran() CLASS TFacturarLineasAlbaranes

   ::oPorcentajePropuestoFactura:cText( 100 - ::nPorcentajePropuestoAlbaran )

   ::RefreshPorcentajePropuesto()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ChangePorcentajePropuestoFactura() CLASS TFacturarLineasAlbaranes

   ::oPorcentajePropuestoAlbaran:cText( 100 - ::nPorcentajePropuestoFactura )

   ::RefreshPorcentajePropuesto()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD RecalculaPorcentajes() CLASS TFacturarLineasAlbaranes

   local nUnidadesCalculadas  := 0

   /*
   Compruebo que el porcentaje de albaran no sea 100%--------------------------
   */

   if ::nPorcentajePropuestoAlbaran == 100 .and. ( ::cTemporalLineaFactura )->( OrdKeyCount() ) == 0
      Return .f.
   end if

   ::ComprobacionesCalculoPorcentajes()

   /*
   Calculo de porcentaje-------------------------------------------------------
   */

   while ::lPorcentajeAlcanzado()

      ::PasaUnidadAlbaran()

      ::SaltoRegistro()

   end while

   /*
   Actualizamos la pantalla----------------------------------------------------
   */

   ::ActualizaPantalla()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ComprobacionesCalculoPorcentajes() CLASS TFacturarLineasAlbaranes

   /*
   Si no existen lineas en la temporal de facturas inicializamos las dos tablas
   */

   if ( ::cTemporalLineaFactura )->( OrdKeyCount() ) != 0

      /*
      Elimino de albaran-------------------------------------------------------
      */

      ( ::cTemporalLineaAlbaran )->( __dbZap() )

      /* 
      Cargo de albaran---------------------------------------------------------
      */   

      ::CargaTemporal()

      /*
      Elimino de factura-------------------------------------------------------
      */

      ( ::cTemporalLineaFactura )->( __dbZap() )

   end if

   ( ::cTemporalLineaAlbaran )->( dbGoTop() )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SaltoRegistro() CLASS TFacturarLineasAlbaranes

   ( ::cTemporalLineaAlbaran )->( dbSkip() )

   if ( ::cTemporalLineaAlbaran )->( Eof() )

      ( ::cTemporalLineaAlbaran )->( dbGoTop() )

   end if   

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//----------------------Nuevo facturar por lineas----------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD FacturarLineasCompletas( nView ) CLASS TFacturarLineasAlbaranes

   ?"Entro por donde debo"

   /*
   Tomamos los valores iniciales-----------------------------------------------
   */

   ::cNumFac   := ""
   ::lPrint    := .f.
   ::nView     := nView

   /*
   Comprobaciones antes de entrar----------------------------------------------
   */

   if ::nView < 1
      msgStop( "La vista creada no es válida" )
      Return .f.
   end if

   /*
   Valores iniciales ----------------------------------------------------------
   */

   /*
   Creamos los temporales necesarios-------------------------------------------
   */

   //::CreaTemporales()

   /*
   Montamos el recurso---------------------------------------------------------
   */

   ::ResourceLineasCompleta()

   /*
   Destruimos las temporales---------------------------------------------------
   */

   //::EliminaTemporales()

Return ( ::lPrint )

//---------------------------------------------------------------------------//

METHOD ResourceLineasCompleta() CLASS TFacturarLineasAlbaranes

   local oFont             := TFont():New( "Arial", 8, 26, .F., .T. )

   DEFINE DIALOG ::oDlg RESOURCE "FacturaLineasCompletasAlbaranes"

      REDEFINE COMBOBOX ::oPeriodoCli ;
         VAR         ::cPeriodoCli ;
         ID          100 ;
         ITEMS       ::aPeriodoCli ;
         ON CHANGE   ( Msginfo( "cambio" ) ); //lRecargaFecha( oFecIniCli, oFecFinCli, cPeriodoCli ), LoadPageClient( aTmp[ _COD ] ) ) ;
         OF          ::oDlg

      REDEFINE GET ::oFecIniCli VAR ::dFecIniCli;
         ID          110 ;
         SPINNER ;
         VALID       ( .t. ); //LoadPageClient( aTmp[ _COD ] ) );
         OF          ::oDlg

      REDEFINE GET ::oFecFinCli VAR ::dFecFinCli;
         ID          120 ;
         SPINNER ;
         VALID       ( .t. ); //LoadPageClient( aTmp[ _COD ] ) );
         OF          ::oDlg





      /*
      Botones------------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:End() )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         CANCEL ;
         ACTION   ( ::oDlg:End() )

      ::oDlg:Activate( , , , .t., , , {|| msginfo( "abriendo el recurso" ) } ) //::InitResource() } )

      //::oBrwLineasAlbaran:CloseData()
      //::oBrwLineasFactura:CloseData()

      oFont:End()

Return ( Self )

//---------------------------------------------------------------------------//

