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

   METHOD ActualizaPorcentajes()

   METHOD PasaUnidadAlbaran()
   METHOD PasaLineaAlbaran()
   METHOD PasaTodoAlbaran()

   METHOD PasaUnidadFactura()
   METHOD PasaLineaFactura()
   METHOD PasaTodoFactura()

   METHOD GuardaAlbaran()

   METHOD GeneraFactura()

   METHOD EndResource()

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
   ( ::cTemporalLineaAlbaran )->( OrdCreate( ::cTmpAlbLin, "cLinArt", "Str( nNumLin, 4 ) + cRef", {|| Str( Field->nNumLin ) + Field->cRef } ) )

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
         :nFooterType         := AGGR_SUM
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

   ::ActualizaPorcentajes()

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
      ( ::cTemporalLineaAlbaran )->( dbZap() )
   end if

   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPorcentajes()

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

   ( ::cTemporalLineaAlbaran )->( dbZap() )

   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPorcentajes()

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

   ::ActualizaPorcentajes()

   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPorcentajes()

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
      ( ::cTemporalLineaFactura )->( dbZap() )
   end if

   /*
   Actualizamos los porcentajes y  el browse-----------------------------------
   */

   ::ActualizaPorcentajes()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaTodoFactura() CLASS TFacturarLineasAlbaranes

   /*
   Añado a la tabla de facturas------------------------------------------------
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

   ::ActualizaPorcentajes()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ActualizaPorcentajes() CLASS TFacturarLineasAlbaranes

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

   local nNumFac
   local cSufFac

   /*
   Pasamos la cabecera de la factura-------------------------------------------
   */

   nNumFac     := nNewDoc( ::cSerieFactura, TDataView():Get( "FacCliT", ::nView ), "NFACCLI", , TDataView():Get( "NCount", ::nView ) )

   ( TDataView():Get( "FacCliT", ::nView ) )->( dbAppend() )

   ( TDataView():Get( "FacCliT", ::nView ) )->cSerie     := ::cSerieFactura
   ( TDataView():Get( "FacCliT", ::nView ) )->nNumFac    := nNumFac
   ( TDataView():Get( "FacCliT", ::nView ) )->cSufFac    := ( TDataView():Get( "AlbCliT", ::nView ) )->cSufAlb
   ( TDataView():Get( "FacCliT", ::nView ) )->dFecFac    := ::dFechaFactura
   ( TDataView():Get( "FacCliT", ::nView ) )->cCodCli    := ( TDataView():Get( "AlbCliT", ::nView ) )->cCodCli
   ( TDataView():Get( "FacCliT", ::nView ) )->cNomCli    := ( TDataView():Get( "AlbCliT", ::nView ) )->cNomCli
   ( TDataView():Get( "FacCliT", ::nView ) )->cDirCli    := ( TDataView():Get( "AlbCliT", ::nView ) )->cDirCli
   ( TDataView():Get( "FacCliT", ::nView ) )->cPobCli    := ( TDataView():Get( "AlbCliT", ::nView ) )->cPobCli
   ( TDataView():Get( "FacCliT", ::nView ) )->cPrvCli    := ( TDataView():Get( "AlbCliT", ::nView ) )->cPrvCli
   ( TDataView():Get( "FacCliT", ::nView ) )->cPosCli    := ( TDataView():Get( "AlbCliT", ::nView ) )->cPosCli
   ( TDataView():Get( "FacCliT", ::nView ) )->cDniCli    := ( TDataView():Get( "AlbCliT", ::nView ) )->cDniCli
   ( TDataView():Get( "FacCliT", ::nView ) )->cTlfCli    := ( TDataView():Get( "AlbCliT", ::nView ) )->cTlfCli
   ( TDataView():Get( "FacCliT", ::nView ) )->cCodAlm    := ( TDataView():Get( "AlbCliT", ::nView ) )->cCodAlm
   ( TDataView():Get( "FacCliT", ::nView ) )->cCodCaj    := ( TDataView():Get( "AlbCliT", ::nView ) )->cCodCaj
   ( TDataView():Get( "FacCliT", ::nView ) )->cCodPago   := ( TDataView():Get( "AlbCliT", ::nView ) )->cCodPago
   ( TDataView():Get( "FacCliT", ::nView ) )->cCodAge    := ( TDataView():Get( "AlbCliT", ::nView ) )->cCodAge
   ( TDataView():Get( "FacCliT", ::nView ) )->nPctComAge := ( TDataView():Get( "AlbCliT", ::nView ) )->nPctComAge
   ( TDataView():Get( "FacCliT", ::nView ) )->cCodTar    := ( TDataView():Get( "AlbCliT", ::nView ) )->cCodTar
   ( TDataView():Get( "FacCliT", ::nView ) )->cCodRut    := ( TDataView():Get( "AlbCliT", ::nView ) )->cCodRut
   ( TDataView():Get( "FacCliT", ::nView ) )->cCodObr    := ( TDataView():Get( "AlbCliT", ::nView ) )->cCodObr
   ( TDataView():Get( "FacCliT", ::nView ) )->cCodTrn    := ( TDataView():Get( "AlbCliT", ::nView ) )->cCodTrn
   ( TDataView():Get( "FacCliT", ::nView ) )->cCondEnt   := ( TDataView():Get( "AlbCliT", ::nView ) )->cCondEnt
   ( TDataView():Get( "FacCliT", ::nView ) )->mComent    := ( TDataView():Get( "AlbCliT", ::nView ) )->mComent
   ( TDataView():Get( "FacCliT", ::nView ) )->mObserv    := ( TDataView():Get( "AlbCliT", ::nView ) )->mObserv
   ( TDataView():Get( "FacCliT", ::nView ) )->cSuFac     := ( TDataView():Get( "AlbCliT", ::nView ) )->cSuPed
   ( TDataView():Get( "FacCliT", ::nView ) )->cDtoEsp    := ( TDataView():Get( "AlbCliT", ::nView ) )->cDtoEsp
   ( TDataView():Get( "FacCliT", ::nView ) )->cDpp       := ( TDataView():Get( "AlbCliT", ::nView ) )->cDpp
   ( TDataView():Get( "FacCliT", ::nView ) )->nDtoEsp    := ( TDataView():Get( "AlbCliT", ::nView ) )->nDtoEsp
   ( TDataView():Get( "FacCliT", ::nView ) )->nDpp       := ( TDataView():Get( "AlbCliT", ::nView ) )->nDpp
   ( TDataView():Get( "FacCliT", ::nView ) )->cDtoUno    := ( TDataView():Get( "AlbCliT", ::nView ) )->cDtoUno
   ( TDataView():Get( "FacCliT", ::nView ) )->nDtoUno    := ( TDataView():Get( "AlbCliT", ::nView ) )->nDtoUno
   ( TDataView():Get( "FacCliT", ::nView ) )->cDtoDos    := ( TDataView():Get( "AlbCliT", ::nView ) )->cDtoDos
   ( TDataView():Get( "FacCliT", ::nView ) )->nDtoDos    := ( TDataView():Get( "AlbCliT", ::nView ) )->nDtoDos
   ( TDataView():Get( "FacCliT", ::nView ) )->cManObr    := ( TDataView():Get( "AlbCliT", ::nView ) )->cManObr
   ( TDataView():Get( "FacCliT", ::nView ) )->nIvaMan    := ( TDataView():Get( "AlbCliT", ::nView ) )->nIvaMan
   ( TDataView():Get( "FacCliT", ::nView ) )->nManObr    := ( TDataView():Get( "AlbCliT", ::nView ) )->nManObr
   ( TDataView():Get( "FacCliT", ::nView ) )->nBultos    := ( TDataView():Get( "AlbCliT", ::nView ) )->nBultos
   ( TDataView():Get( "FacCliT", ::nView ) )->cRetPor    := ( TDataView():Get( "AlbCliT", ::nView ) )->cRetPor
   ( TDataView():Get( "FacCliT", ::nView ) )->cCodGrp    := ( TDataView():Get( "AlbCliT", ::nView ) )->cCodGrp
   ( TDataView():Get( "FacCliT", ::nView ) )->lModCli    := ( TDataView():Get( "AlbCliT", ::nView ) )->lModCli
   ( TDataView():Get( "FacCliT", ::nView ) )->lOperPv    := ( TDataView():Get( "AlbCliT", ::nView ) )->lOperPv

   ( TDataView():Get( "FacCliT", ::nView ) )->( dbUnLock() )

   /*
   Lineas de facturas----------------------------------------------------------
   */

   ( ::cTemporalLineaFactura )->( dbGoTop() )

   while !( ::cTemporalLineaFactura )->( Eof() )

      ( TDataView():Get( "FacCliL", ::nView ) )->( dbAppend() )

      ( TDataView():Get( "FacCliL", ::nView ) )->cSerie     := ::cSerieFactura
      ( TDataView():Get( "FacCliL", ::nView ) )->nNumFac    := nNumFac
      ( TDataView():Get( "FacCliL", ::nView ) )->cSufFac    := ( TDataView():Get( "AlbCliT", ::nView ) )->cSufAlb
      ( TDataView():Get( "FacCliL", ::nView ) )->nNumLin    := ( ::cTemporalLineaFactura )->nNumLin
      ( TDataView():Get( "FacCliL", ::nView ) )->cRef       := ( ::cTemporalLineaFactura )->cRef
      ( TDataView():Get( "FacCliL", ::nView ) )->cDetalle   := ( ::cTemporalLineaFactura )->cDetalle
      ( TDataView():Get( "FacCliL", ::nView ) )->mLngDes    := ( ::cTemporalLineaFactura )->mLngDes
      ( TDataView():Get( "FacCliL", ::nView ) )->mNumSer    := ( ::cTemporalLineaFactura )->mNumSer
      ( TDataView():Get( "FacCliL", ::nView ) )->nPreUnit   := ( ::cTemporalLineaFactura )->nPreUnit
      ( TDataView():Get( "FacCliL", ::nView ) )->nPntVer    := ( ::cTemporalLineaFactura )->nPntVer
      ( TDataView():Get( "FacCliL", ::nView ) )->nImpTrn    := ( ::cTemporalLineaFactura )->nImpTrn
      ( TDataView():Get( "FacCliL", ::nView ) )->nCanEnt    := ( ::cTemporalLineaFactura )->nCanEnt
      ( TDataView():Get( "FacCliL", ::nView ) )->cUnidad    := ( ::cTemporalLineaFactura )->cUnidad
      ( TDataView():Get( "FacCliL", ::nView ) )->nUniCaja   := ( ::cTemporalLineaFactura )->nUniCaja
      ( TDataView():Get( "FacCliL", ::nView ) )->nDto       := ( ::cTemporalLineaFactura )->nDto
      ( TDataView():Get( "FacCliL", ::nView ) )->nDtoPrm    := ( ::cTemporalLineaFactura )->nDtoPrm
      ( TDataView():Get( "FacCliL", ::nView ) )->nIva       := ( ::cTemporalLineaFactura )->nIva
      ( TDataView():Get( "FacCliL", ::nView ) )->nReq       := ( ::cTemporalLineaFactura )->nReq
      ( TDataView():Get( "FacCliL", ::nView ) )->nPesoKg    := ( ::cTemporalLineaFactura )->nPesoKg
      ( TDataView():Get( "FacCliL", ::nView ) )->cPesoKg    := ( ::cTemporalLineaFactura )->cPesoKg
      ( TDataView():Get( "FacCliL", ::nView ) )->nVolumen   := ( ::cTemporalLineaFactura )->nVolumen
      ( TDataView():Get( "FacCliL", ::nView ) )->cVolumen   := ( ::cTemporalLineaFactura )->cVolumen
      ( TDataView():Get( "FacCliL", ::nView ) )->nComAge    := ( ::cTemporalLineaFactura )->nComAge
      ( TDataView():Get( "FacCliL", ::nView ) )->dFecha     := ::dFechaFactura
      ( TDataView():Get( "FacCliL", ::nView ) )->cTipMov    := ( ::cTemporalLineaFactura )->cTipMov
      ( TDataView():Get( "FacCliL", ::nView ) )->cCodAlb    := ::cNumAlb
      ( TDataView():Get( "FacCliL", ::nView ) )->lTotLin    := ( ::cTemporalLineaFactura )->lTotLin
      ( TDataView():Get( "FacCliL", ::nView ) )->nDtoDiv    := ( ::cTemporalLineaFactura )->nDtoDiv
      ( TDataView():Get( "FacCliL", ::nView ) )->nCtlStk    := ( ::cTemporalLineaFactura )->nCtlStk
      ( TDataView():Get( "FacCliL", ::nView ) )->cAlmLin    := ( ::cTemporalLineaFactura )->cAlmLin
      ( TDataView():Get( "FacCliL", ::nView ) )->cTipMov    := ( ::cTemporalLineaFactura )->cTipMov
      ( TDataView():Get( "FacCliL", ::nView ) )->lIvaLin    := ( ::cTemporalLineaFactura )->lIvaLin
      ( TDataView():Get( "FacCliL", ::nView ) )->lImpLin    := ( ::cTemporalLineaFactura )->lImpLin
      ( TDataView():Get( "FacCliL", ::nView ) )->nValImp    := ( ::cTemporalLineaFactura )->nValImp
      ( TDataView():Get( "FacCliL", ::nView ) )->cCodImp    := ( ::cTemporalLineaFactura )->cCodImp
      ( TDataView():Get( "FacCliL", ::nView ) )->cCodPr1    := ( ::cTemporalLineaFactura )->cCodPr1
      ( TDataView():Get( "FacCliL", ::nView ) )->cCodPr2    := ( ::cTemporalLineaFactura )->cCodPr2
      ( TDataView():Get( "FacCliL", ::nView ) )->cValPr1    := ( ::cTemporalLineaFactura )->cValPr1
      ( TDataView():Get( "FacCliL", ::nView ) )->cValPr2    := ( ::cTemporalLineaFactura )->cValPr2
      ( TDataView():Get( "FacCliL", ::nView ) )->nCosDiv    := ( ::cTemporalLineaFactura )->nCosDiv
      ( TDataView():Get( "FacCliL", ::nView ) )->lKitArt    := ( ::cTemporalLineaFactura )->lKitArt
      ( TDataView():Get( "FacCliL", ::nView ) )->lKitChl    := ( ::cTemporalLineaFactura )->lKitChl
      ( TDataView():Get( "FacCliL", ::nView ) )->lKitPrc    := ( ::cTemporalLineaFactura )->lKitPrc
      ( TDataView():Get( "FacCliL", ::nView ) )->nMesGrt    := ( ::cTemporalLineaFactura )->nMesGrt
      ( TDataView():Get( "FacCliL", ::nView ) )->lLote      := ( ::cTemporalLineaFactura )->lLote
      ( TDataView():Get( "FacCliL", ::nView ) )->nLote      := ( ::cTemporalLineaFactura )->nLote
      ( TDataView():Get( "FacCliL", ::nView ) )->cLote      := ( ::cTemporalLineaFactura )->cLote
      ( TDataView():Get( "FacCliL", ::nView ) )->dFecCad    := ( ::cTemporalLineaFactura )->dFecCad
      ( TDataView():Get( "FacCliL", ::nView ) )->lControl   := ( ::cTemporalLineaFactura )->lControl
      ( TDataView():Get( "FacCliL", ::nView ) )->lMsgVta    := ( ::cTemporalLineaFactura )->lMsgVta
      ( TDataView():Get( "FacCliL", ::nView ) )->lNotVta    := ( ::cTemporalLineaFactura )->lNotVta
      ( TDataView():Get( "FacCliL", ::nView ) )->cCodTip    := ( ::cTemporalLineaFactura )->cCodTip
      ( TDataView():Get( "FacCliL", ::nView ) )->mObsLin    := ( ::cTemporalLineaFactura )->mObsLin
      ( TDataView():Get( "FacCliL", ::nView ) )->Descrip    := ( ::cTemporalLineaFactura )->Descrip
      ( TDataView():Get( "FacCliL", ::nView ) )->cCodPrv    := ( ::cTemporalLineaFactura )->cCodPrv
      ( TDataView():Get( "FacCliL", ::nView ) )->cNomPrv    := ( ::cTemporalLineaFactura )->cNomPrv
      ( TDataView():Get( "FacCliL", ::nView ) )->cImagen    := ( ::cTemporalLineaFactura )->cImagen
      ( TDataView():Get( "FacCliL", ::nView ) )->cCodFam    := ( ::cTemporalLineaFactura )->cCodFam
      ( TDataView():Get( "FacCliL", ::nView ) )->cGrpFam    := ( ::cTemporalLineaFactura )->cGrpFam
      ( TDataView():Get( "FacCliL", ::nView ) )->cRefPrv    := ( ::cTemporalLineaFactura )->cRefPrv
      ( TDataView():Get( "FacCliL", ::nView ) )->dFecEnt    := ( ::cTemporalLineaFactura )->dFecEnt
      ( TDataView():Get( "FacCliL", ::nView ) )->dFecSal    := ( ::cTemporalLineaFactura )->dFecSal
      ( TDataView():Get( "FacCliL", ::nView ) )->nPreAlq    := ( ::cTemporalLineaFactura )->nPreAlq
      ( TDataView():Get( "FacCliL", ::nView ) )->lAlquiler  := ( ::cTemporalLineaFactura )->lAlquiler
      ( TDataView():Get( "FacCliL", ::nView ) )->nNumMed    := ( ::cTemporalLineaFactura )->nNumMed
      ( TDataView():Get( "FacCliL", ::nView ) )->nMedUno    := ( ::cTemporalLineaFactura )->nMedUno
      ( TDataView():Get( "FacCliL", ::nView ) )->nMedDos    := ( ::cTemporalLineaFactura )->nMedDos
      ( TDataView():Get( "FacCliL", ::nView ) )->nMedTre    := ( ::cTemporalLineaFactura )->nMedTre
      ( TDataView():Get( "FacCliL", ::nView ) )->nPuntos    := ( ::cTemporalLineaFactura )->nPuntos
      ( TDataView():Get( "FacCliL", ::nView ) )->nValPnt    := ( ::cTemporalLineaFactura )->nValPnt
      ( TDataView():Get( "FacCliL", ::nView ) )->nDtoPnt    := ( ::cTemporalLineaFactura )->nDtoPnt
      ( TDataView():Get( "FacCliL", ::nView ) )->nIncPnt    := ( ::cTemporalLineaFactura )->nIncPnt
      ( TDataView():Get( "FacCliL", ::nView ) )->nFacCnv    := ( ::cTemporalLineaFactura )->nFacCnv
      ( TDataView():Get( "FacCliL", ::nView ) )->lLinOfe    := ( ::cTemporalLineaFactura )->lLinOfe

      ( TDataView():Get( "FacCliL", ::nView ) )->( dbUnLock() )

      ( ::cTemporalLineaFactura )->( dbSkip() )

   end while   

Return ( Self )

//---------------------------------------------------------------------------//