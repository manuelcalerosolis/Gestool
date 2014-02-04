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
   DATA oFechaFactura
   DATA dFechaFactura

   METHOD FacturarLineas( cNumAlb )

   METHOD CreaTemporales()

   METHOD EliminaTemporales()

   METHOD Resource()

   METHOD InitResource()

   METHOD GenerarFactura()

   METHOD ActualizaPorcentajes()

   METHOD PasaUnidadAlbaran()
   METHOD PasaLineaAlbaran()
   METHOD PasaTodoAlbaran()

   METHOD PasaUnidadFactura()
   METHOD PasaLineaFactura()
   METHOD PasaTodoFactura()

END CLASS

//---------------------------------------------------------------------------//

METHOD FacturarLineas( nView ) CLASS TFacturarLineasAlbaranes

   /*
   Tomamos los valores iniciales-----------------------------------------------
   */

   ::nView     := nView
   ::cNumAlb   := ( TDataView():Get( "AlbCliT", ::nView ) )->cSerAlb + Str( ( TDataView():Get( "AlbCliT", ::nView ) )->nNumAlb ) + ( TDataView():Get( "AlbCliT", ::nView ) )->cSufAlb

   /*
   Comprobaciones antes de entrar----------------------------------------------
   */

   if ( TDataView():Get( "AlbCliT", ::nView ) )->lFacturado
      msgStop( "Albarán ya facturado" )
      Return .f.
   end if

   if Empty( ( TDataView():Get( "AlbCliT", ::nView ) )->cSerAlb )
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

   ::nPorcentajeAlbaran          := 100
   ::nPorcentajeFactura          := 0

   ::nPorcentajePropuestoAlbaran := 0
   ::nPorcentajePropuestoFactura := 0

   ::cSerieFactura               := "A"
   ::dFechaFactura               := GetSysDate()

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

Return ( Self )

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
   ( ::cTemporalLineaAlbaran )->( OrdCreate( ::cTmpAlbLin, "nNumAlb", "Str( Recno() )", {|| Str( Recno() ) } ) )

   /*
   Pasamos la información de la tabla definitiva a la temporal-----------------
   */

   if ( TDataView():Get( "AlbCliL", ::nView ) )->( dbSeek( ::cNumAlb ) )
      while ( ( TDataView():Get( "AlbCliL", ::nView ) )->cSerAlb + Str( ( TDataView():Get( "AlbCliL", ::nView ) )->nNumAlb ) + ( TDataView():Get( "AlbCliL", ::nView ) )->cSufAlb ) == ::cNumAlb .and. !( TDataView():Get( "AlbCliL", ::nView ) )->( eof() )
         dbPass( TDataView():Get( "AlbCliL", ::nView ), ::cTemporalLineaAlbaran, .t. )
         ( TDataView():Get( "AlbCliL", ::nView ) )->( dbSkip() )
      end while
      end if

   ( ::cTemporalLineaAlbaran )->( dbGoTop() )

   /*
   Creamos la base de datos temporal de lineas de facturas---------------------
   */

   dbCreate( ::cTmpFacLin, aSqlStruct( aColFacCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), ::cTmpFacLin, cCheckArea( cDbfFacLin, @::cTemporalLineaFactura ), .f. )

   ( ::cTemporalLineaFactura )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
   ( ::cTemporalLineaFactura )->( OrdCreate( ::cTmpFacLin, "nNumFac", "Str( Recno() )", {|| Str( Recno() ) } ) )

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

   DEFINE DIALOG ::oDlg RESOURCE "FacturaLineasAlbaranes"

      /*
      Porcentaje propuesto de albarán------------------------------------------
      */

      REDEFINE GET ::oPorcentajePropuestoAlbaran VAR ::nPorcentajePropuestoAlbaran ;
         ID       100 ;
         WHEN     ( .f. ) ;
         OF       ::oDlg

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
         :bEditValue          := {|| nTotUAlbCli( ::cTemporalLineaAlbaran ) }
         :cEditPicture        := cPouDiv()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "% " + cImp()
         :bEditValue          := {|| ( ::cTemporalLineaAlbaran )->nIva }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 35
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLAlbCli( ::cTemporalLineaAlbaran ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

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

      REDEFINE GET ::oPorcentajePropuestoFactura VAR ::nPorcentajePropuestoFactura ;
         ID       200 ;
         WHEN     ( .f. ) ;
         OF       ::oDlg

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
         :bEditValue          := {|| nTotNFacCli( ::cTemporalLineaFactura ) }
         :cEditPicture        := MasUnd()
         :nWidth              := 50
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Precio"
         :bEditValue          := {|| nTotUFacCli( ::cTemporalLineaFactura ) }
         :cEditPicture        := cPouDiv()
         :nWidth              := 60
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

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLFacCli( ::cTemporalLineaFactura ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
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
      Botones generales--------------------------------------------------------
      */   

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         ACTION   ( ::GenerarFactura() )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         CANCEL ;
         ACTION   ( ::oDlg:End() )

      ::oDlg:Activate( , , , .t., , , {|| ::InitResource() } )

      ::oBrwLineasAlbaran:CloseData()
      ::oBrwLineasFactura:CloseData()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD InitResource() CLASS TFacturarLineasAlbaranes

   ::oBrwLineasAlbaran:Load()

   ::oBrwLineasFactura:Load()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD PasaUnidadAlbaran() CLASS TFacturarLineasAlbaranes

   MsgInfo( "Unidad Albaran" )

   /*
   Actualizamos los porcentajes------------------------------------------------
   */

   ::ActualizaPorcentajes()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaLineaAlbaran() CLASS TFacturarLineasAlbaranes

   MsgInfo( "Linea Albaran" )

   /*
   Actualizamos los porcentajes------------------------------------------------
   */

   ::ActualizaPorcentajes()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaTodoAlbaran() CLASS TFacturarLineasAlbaranes

   MsgInfo( "Todo Albaran" )

   /*
   Actualizamos los porcentajes------------------------------------------------
   */

   ::ActualizaPorcentajes()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaUnidadFactura() CLASS TFacturarLineasAlbaranes

   MsgInfo( "Unidad Factura" )

   /*
   Actualizamos los porcentajes------------------------------------------------
   */

   ::ActualizaPorcentajes()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaLineaFactura() CLASS TFacturarLineasAlbaranes

   MsgInfo( "Linea Factura" )

   /*
   Actualizamos los porcentajes------------------------------------------------
   */

   ::ActualizaPorcentajes()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaTodoFactura() CLASS TFacturarLineasAlbaranes

   MsgInfo( "Todo Factura" )

   /*
   Actualizamos los porcentajes------------------------------------------------
   */

   ::ActualizaPorcentajes()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ActualizaPorcentajes() CLASS TFacturarLineasAlbaranes

   Msginfo( ::nPorcentajeAlbaran, "Por Albaran" )
   Msginfo( ::nPorcentajeFactura, "Por Factura" )

   ::oBrwLineasAlbaran:Refresh()
   ::oBrwLineasFactura:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GenerarFactura() CLASS TFacturarLineasAlbaranes

   MsgInfo( "Generamos la Factura y actualizamos el albarán" )

   ::oDlg:End( IDOK )

Return ( Self )

//---------------------------------------------------------------------------//