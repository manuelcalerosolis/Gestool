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
   DATA nNumeroFactura
   DATA cSufijoFactura
   DATA oFechaFactura
   DATA dFechaFactura
   
   DATA nTotalAlbaran

   DATA oColTotalAlbaran
   DATA oColTotalFactura

   METHOD FacturarLineas( cNumAlb )

   METHOD CreaTemporales()

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

   METHOD GeneraFactura()

   METHOD EndResource()

   METHOD CambioIva()

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
      msgStop( "Albar�n ya facturado" )
      Return .f.
   end if

   if Empty( ( TDataView():Get( "AlbCliT", ::nView ) )->cSerAlb )
      msgStop( "Tiene que seleccionar un albar�n para facturarlo" )
      Return .f.
   end if      

   if ::nView < 1
      msgStop( "La vista creada no es v�lida" )
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
   Guardamos el total del albara
   */

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
   ( ::cTemporalLineaAlbaran )->( OrdCreate( ::cTmpAlbLin, "cLinArt", "Str( nNumLin, 4 ) + cRef", {|| Str( Field->nNumLin ) + Field->cRef } ) )

   ( ::cTemporalLineaAlbaran )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
   ( ::cTemporalLineaAlbaran )->( OrdCreate( ::cTmpAlbLin, "nNumAlb", "Str( Recno() )", {|| Str( Recno() ) } ) )

   /*
   Pasamos la informaci�n de la tabla definitiva a la temporal-----------------
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

   dbCreate( ::cTmpFacLin, aSqlStruct( aColAlbCli() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), ::cTmpFacLin, cCheckArea( cDbfFacLin, @::cTemporalLineaFactura ), .f. )

   ( ::cTemporalLineaFactura )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
   ( ::cTemporalLineaFactura )->( OrdCreate( ::cTmpFacLin, "cLinArt", "Str( nNumLin, 4 ) + cRef", {|| Str( Field->nNumLin ) + Field->cRef } ) )

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
      Porcentaje propuesto de albar�n------------------------------------------
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
         :cHeader             := "C�digo"
         :bEditValue          := {|| ( ::cTemporalLineaAlbaran )->cRef }
         :nWidth              := 40
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Descripci�n"
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

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "% " + cImp()
         :bEditValue          := {|| ( ::cTemporalLineaAlbaran )->nIva }
         :cEditPicture        := "@E 999.99"
         :nWidth              := 35
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :bLClickFooter       := {|| ::CambioIva() }
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Base"
         :bEditValue          := {|| nNetLAlbCli( TDataView():Get( "AlbCliT", ::nView ), ::cTemporalLineaAlbaran, , , , .f. ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "IVA"
         :bEditValue          := {|| nIvaLAlbCli( ::cTemporalLineaAlbaran ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 45
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
         :lHide               := .t.
      end with

      with object ( ::oColTotalAlbaran := ::oBrwLineasAlbaran:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLAlbCli( ::cTemporalLineaAlbaran ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 45
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
         :lHide               := .t.
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
         :cHeader             := "C�digo"
         :bEditValue          := {|| ( ::cTemporalLineaFactura )->cRef }
         :nWidth              := 40
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Descripci�n"
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

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Base"
         :bEditValue          := {|| nNetLAlbCli( TDataView():Get( "AlbCliT", ::nView ), ::cTemporalLineaFactura, , , , .f. ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 80
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
      end with

      with object ( ::oBrwLineasFactura:AddCol() )
         :cHeader             := "IVA"
         :bEditValue          := {|| nIvaLAlbCli( ::cTemporalLineaFactura ) }
         :cEditPicture        := cPorDiv()
         :nWidth              := 60
         :nDataStrAlign       := 1
         :nHeadStrAlign       := 1
         :nFooterType         := AGGR_SUM
         :lHide               := .t.
      end with

      with object ( ::oColTotalFactura := ::oBrwLineasFactura:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| nTotLAlbCli( ::cTemporalLineaFactura ) }
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
      Botones generales--------------------------------------------------------
      */   

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         ACTION   ( ::EndResource() )

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
   A�ado a la tabla de facturas------------------------------------------------
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
      ( ::cTemporalLineaAlbaran )->( dbZap() )
   end if

   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPantalla()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaTodoAlbaran() CLASS TFacturarLineasAlbaranes

   /*
   A�ado a la tabla de facturas------------------------------------------------
   */

   ( ::cTemporalLineaAlbaran )->( dbGoTop() )

   while !( ::cTemporalLineaAlbaran )->( Eof() )

      dbPass( ::cTemporalLineaAlbaran, ::cTemporalLineaFactura, .t. )

      ( ::cTemporalLineaAlbaran )->( dbSkip() )

   end while

   /*
   Elimino de albaranes--------------------------------------------------------
   */

   ( ::cTemporalLineaAlbaran )->( dbZap() )

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
   A�ado a la tabla de facturas------------------------------------------------
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
      ( ::cTemporalLineaFactura )->( dbZap() )
   end if

   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPantalla()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaTodoFactura() CLASS TFacturarLineasAlbaranes

   /*
   A�ado a la tabla de facturas------------------------------------------------
   */

   ( ::cTemporalLineaFactura )->( dbGoTop() )

   while !( ::cTemporalLineaFactura )->( Eof() )

      dbPass( ::cTemporalLineaFactura, ::cTemporalLineaAlbaran, .t. )

      ( ::cTemporalLineaFactura )->( dbSkip() )

   end while

   /*
   Elimino de factura----------------------------------------------------------
   */

   ( ::cTemporalLineaFactura )->( dbZap() )

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
      ::oBrwLineasAlbaran:Refresh()
   end if

   if !Empty( ::oBrwLineasFactura )
      ::oBrwLineasFactura:Refresh()
   end if

   /*
   Calculamos los porcentajes del Browse-------------------------------------//
   */

   ::CalculaPorcentajes()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CalculaPorcentajes() CLASS TFacturarLineasAlbaranes

   local nTotal

   nTotal               := ::oColTotalAlbaran:nTotal + ::oColTotalFactura:nTotal

   nPorcentajeAlbaran   := ( ::oColTotalAlbaran:nTotal * 100 ) / nTotal

   nPorcentajeFactura   := ( ::oColTotalFactura:nTotal * 100 ) / nTotal

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

METHOD EndResource() CLASS TFacturarLineasAlbaranes

   if ( ::cTemporalLineaFactura )->( OrdKeyCount() ) == 0
      MsgStop( "Tiene que pasar almenos una linea del albar�n para crear una nueva factura." )
      Return .f.
   end if

   ::GuardaAlbaran()

   ::GeneraFactura()

   ::oDlg:End( IDOK )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GuardaAlbaran() CLASS TFacturarLineasAlbaranes

   /*
   Hacemos un RollBack---------------------------------------------------------
   */

   while ( TDataView():Get( "AlbCliL", ::nView ) )->( dbSeek( ::cNumAlb ) ) .and. !( TDataView():Get( "AlbCliL", ::nView ) )->( eof() )
      if dbLock( TDataView():Get( "AlbCliL", ::nView ) )
         ( TDataView():Get( "AlbCliL", ::nView ) )->( dbDelete() )
         ( TDataView():Get( "AlbCliL", ::nView ) )->( dbUnLock() )
      end if
   end while

   /*
   Escribimos definitivamente en la tabla--------------------------------------
   */

   ( ::cTemporalLineaAlbaran )->( dbGoTop() )

   while !( ::cTemporalLineaAlbaran )->( eof() )

      dbPass( ::cTemporalLineaAlbaran, TDataView():Get( "AlbCliL", ::nView ), .t. )

      ( ::cTemporalLineaAlbaran )->( dbSkip() )

   end while

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GeneraFactura() CLASS TFacturarLineasAlbaranes

   local aTotFac

   ::oDlg:Disable()

   CursorWait()

   /*
   Pasamos la cabecera de la factura-------------------------------------------
   */

   ::nNumeroFactura     := nNewDoc( ::cSerieFactura, TDataView():Get( "FacCliT", ::nView ), "NFACCLI", , TDataView():Get( "NCount", ::nView ) )
   ::cSufijoFactura     := ( TDataView():Get( "AlbCliT", ::nView ) )->cSufAlb

   /*
   Pasamos los datos de la cabecera--------------------------------------------
   */

   appendPass( TDataView():Get( "AlbCliT", ::nView ),;
               TDataView():Get( "FacCliT", ::nView ),;
               {  "cSerie"    => ::cSerieFactura,;
                  "nNumFac"   => ::nNumeroFactura,;
                  "cSufFac"   => ::cSufijoFactura,;
                  "dFecFac"   => ::dFechaFactura } )

   /*
   Pasamos los datos de las lineas---------------------------------------------
   */

   appendPass( ::cTemporalLineaFactura,;
               TDataView():Get( "FacCliL", ::nView ),;
               {  "cSerie"    => ::cSerieFactura,;
                  "nNumFac"   => ::nNumeroFactura,;
                  "cSufFac"   => ::cSufijoFactura,;
                  "dFecFac"   => ::dFechaFactura,;
                  "cCodAlb"   => ::cNumAlb } )

   /*
   Rellenamos los campos de totales de la factura------------------------------
   */

   aTotFac  := aTotFacCli( ::cSerieFactura + str( ::nNumeroFactura ) + ::cSufijoFactura,;
                           TDataView():Get( "FacCliT", ::nView ),;
                           TDataView():Get( "FacCliL", ::nView ),;
                           TDataView():Get( "TIva", ::nView ),;
                           TDataView():Get( "Divisas", ::nView ),;
                           TDataView():Get( "FacCliP", ::nView ),;
                           TDataView():Get( "AntCliT", ::nView ) )

   if dbLock( TDataView():Get( "FacCliT", ::nView ) )
      ( TDataView():Get( "FacCliT", ::nView ) )->nTotNet    := aTotFac[1]
      ( TDataView():Get( "FacCliT", ::nView ) )->nTotIva    := aTotFac[2]
      ( TDataView():Get( "FacCliT", ::nView ) )->nTotReq    := aTotFac[3]
      ( TDataView():Get( "FacCliT", ::nView ) )->nTotFac    := aTotFac[4]
   end if   

   /*
   Generamos los pagos de la factura-------------------------------------------
   */

   GenPgoFacCli( ::cSerieFactura + Str( ::nNumeroFactura ) + ::cSufijoFactura,;
                 TDataView():Get( "FacCliT", ::nView ),;
                 TDataView():Get( "FacCliL", ::nView ),;
                 TDataView():Get( "FacCliP", ::nView ),;
                 TDataView():Get( "AntCliT", ::nView ),;
                 TDataView():Get( "Client", ::nView ),;
                 TDataView():Get( "FPago", ::nView ),;
                 TDataView():Get( "Divisas", ::nView ),; 
                 TDataView():Get( "TIva", ::nView ),;
                 APPD_MODE )

   /*
   Checkeamos el estado de la factura------------------------------------------
   */

   ChkLqdFacCli( nil,;
                 TDataView():Get( "FacCliT", ::nView ),;
                 TDataView():Get( "FacCliL", ::nView ),;
                 TDataView():Get( "FacCliP", ::nView ),;
                 TDataView():Get( "AntCliT", ::nView ),;
                 TDataView():Get( "TIva", ::nView ),;
                 TDataView():Get( "Divisas", ::nView ) )

   CursorWe()

   ::oDlg:Enable()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CambioIva() CLASS TFacturarLineasAlbaranes

   local nRec

   if ApoloMsgNoYes( "�Desea cambiar el tipo de I.V.A.?", "Elija una opci�n" )

      nRec     := ( ::cTemporalLineaAlbaran )->( Recno() )

      ( ::cTemporalLineaAlbaran )->( dbGoTop() )

      while !( ::cTemporalLineaAlbaran )->( Eof() )
      
         if dbDialogLock( ::cTemporalLineaAlbaran )
            ( ::cTemporalLineaAlbaran )->nIva := 0
            ( ::cTemporalLineaAlbaran )->( dbUnLock() )
         end if

         ( ::cTemporalLineaAlbaran )->( dbSkip() )

      end while

      ( ::cTemporalLineaAlbaran )->( dbGoTo( nRec ) )

   end if   

   /*
   Actualizamos Browses y porcentajes------------------------------------------
   */

   ::ActualizaPantalla()

Return ( Self )

//---------------------------------------------------------------------------//