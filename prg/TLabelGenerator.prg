#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TLabelGenerator

   Data oDlg
   Data oFld

   Data oSerieInicio
   Data cSerieInicio

   Data oSerieFin
   Data cSerieFin

   Data nDocumentoInicio
   Data nDocumentoFin

   Data cSufijoInicio
   Data cSufijoFin

   Data oFormatoLabel
   Data cFormatoLabel

   Data nFilaInicio
   Data nColumnaInicio

   Data nRecno

   Data oBrwLabel

   Data nCantidadLabels
   Data nUnidadesLabels

   Data oMtrLabel
   Data nMtrLabel

   Data lClose

   Data lErrorOnCreate

   Data oBtnSiguiente
   Data oBtnAnterior
   Data oBtnCancel

   Data aSearch

   Data cFileTmpLabel
   Data cAreaTmpLabel

   Method Resource()

   /*Method lCreateAuxiliar()

   Method lCreateTemporal()
   Method PrepareTemporal( oFr )
   Method DestroyTemporal()

   Method End()

   Method BotonAnterior()

   Method BotonSiguiente()

   Method PutLabel()

   Method SelectAllLabels()

   Method AddLabel()

   Method DelLabel()

   Method EditLabel()

   Method LoadAuxiliar()

   Method lPrintLabels()

   Method InitLabel( oLabel )

   Method SelectColumn( oCombo )*/

END CLASS

//----------------------------------------------------------------------------//

Method Resource() CLASS TLabelGenerator

   local oBtnPrp
   local oBtnMod
   local oBtnZoo
   local oGetOrd
   local cGetOrd     := Space( 100 )
   local oCbxOrd
   local cCbxOrd     := "Código"
   local aCbxOrd     := { "Código", "Nombre" }

   //::New()

   //if !::lErrorOnCreate .and. ::lCreateAuxiliar()

      DEFINE DIALOG ::oDlg RESOURCE "SelectLabels_0"

         REDEFINE PAGES ::oFld ;
            ID       10;
            OF       ::oDlg ;
            DIALOGS  "SelectLabels_1",;
                     "SelectLabels_2"

         /*
         Bitmap-------------------------------------------------------------------
         */

         REDEFINE BITMAP ;
            RESOURCE "EnvioEtiquetas" ;
            ID       500 ;
            OF       ::oDlg ;

         REDEFINE GET ::oSerieInicio VAR ::cSerieInicio ;
            ID       100 ;
            PICTURE  "@!";
            SPINNER ;
            ON UP    ( UpSerie( ::oSerieInicio ) );
            ON DOWN  ( DwSerie( ::oSerieInicio ) );
            VALID    ( ::cSerieInicio >= "A" .and. ::cSerieInicio <= "Z" );
            UPDATE ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::oSerieFin VAR ::cSerieFin ;
            ID       110 ;
            PICTURE  "@!" ;
            SPINNER ;
            ON UP    ( UpSerie( ::oSerieFin ) );
            ON DOWN  ( DwSerie( ::oSerieFin ) );
            VALID    ( ::cSerieFin >= "A" .and. ::cSerieFin <= "Z" );
            UPDATE ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nDocumentoInicio ;
            ID       120 ;
            PICTURE  "999999999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nDocumentoFin ;
            ID       130 ;
            PICTURE  "999999999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::cSufijoInicio ;
            ID       140 ;
            PICTURE  "##" ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::cSufijoFin ;
            ID       150 ;
            PICTURE  "##" ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nFilaInicio ;
            ID       180 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nColumnaInicio ;
            ID       190 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::oFormatoLabel VAR ::cFormatoLabel ;
            ID       160 ;
            IDTEXT   161 ;
            BITMAP   "LUPA" ;
            OF       ::oFld:aDialogs[ 1 ]

            //::oFormatoLabel:bValid  := {|| cDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, dbfDoc, "FL" ) }
            //::oFormatoLabel:bHelp   := {|| BrwDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, "FL" ) }

         TBtnBmp():ReDefine( 220, "Printer_pencil_16",,,,,{|| EdtDocumento( ::cFormatoLabel ) }, ::oFld:aDialogs[ 1 ], .f., , .f., "Modificar formato de etiquetas" )

         REDEFINE RADIO ::nCantidadLabels ;
            ID       200, 201 ;
            OF       ::oFld:aDialogs[ 1 ]

         REDEFINE GET ::nUnidadesLabels ;
            ID       210 ;
            PICTURE  "99999" ;
            SPINNER ;
            MIN      1 ;
            MAX      99999 ;
            WHEN     ( ::nCantidadLabels == 2 ) ;
            OF       ::oFld:aDialogs[ 1 ]

         /*
         Segunda caja de dialogo--------------------------------------------------
         

         REDEFINE GET oGetOrd ;
            VAR      cGetOrd ;
            ID       200 ;
            BITMAP   "FIND" ;
            OF       ::oFld:aDialogs[ 2 ]

         oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwLabel, ::cAreaTmpLabel ) }
         oGetOrd:bValid    := {|| ( ::cAreaTmpLabel )->( OrdScope( 0, nil ) ), ( ::cAreaTmpLabel )->( OrdScope( 1, nil ) ), ::oBrwLabel:Refresh(), .t. }

         REDEFINE COMBOBOX oCbxOrd ;
            VAR      cCbxOrd ;
            ID       210 ;
            ITEMS    aCbxOrd ;
            OF       ::oFld:aDialogs[ 2 ]

         oCbxOrd:bChange   := {|| ::SelectColumn( oCbxOrd ) }

         REDEFINE BUTTON ;
            ID       100 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::PutLabel() )

         REDEFINE BUTTON ;
            ID       110 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::SelectAllLabels( .t. ) )

         REDEFINE BUTTON ;
            ID       120 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::SelectAllLabels( .f. ) )

         REDEFINE BUTTON ;
            ID       130 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::AddLabel() )

         REDEFINE BUTTON ;
            ID       140 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::DelLabel() )

         REDEFINE BUTTON ;
            ID       150 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( ::EditLabel() )

         REDEFINE BUTTON oBtnMod;
            ID       160 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( nil )

         REDEFINE BUTTON oBtnZoo;
            ID       165 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( nil )

         REDEFINE BUTTON oBtnPrp ;
            ID       220 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            ACTION   ( nil )

         ::oBrwLabel                 := TXBrowse():New( ::oFld:aDialogs[ 2 ] )

         ::oBrwLabel:nMarqueeStyle   := 5
         ::oBrwLabel:nColSel         := 2

         ::oBrwLabel:lHScroll        := .f.
         ::oBrwLabel:cAlias          := ::cAreaTmpLabel

         ::oBrwLabel:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         ::oBrwLabel:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
         ::oBrwLabel:bLDblClick      := {|| ::PutLabel() }

         ::oBrwLabel:CreateFromResource( 180 )

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Sl. Seleccionada"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->lLabel }
            :nWidth           := 20
            :SetCheck( { "Sel16", "Nil16" } )
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Código"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->cRef }
            :nWidth           := 80
            :cSortOrder       := "cRef"
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Nombre"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->cDetalle }
            :nWidth           := 250
            :cSortOrder       := "cDetalle"
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

        with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Prp. 1"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->cValPr1 }
            :nWidth           := 40
        end with

        with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Prp. 2"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->cValPr2 }
            :nWidth           := 40
        end with

        with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "N. etiquetas"
            :bEditValue       := {|| ( ::cAreaTmpLabel )->nLabel }
            :cEditPicture     := "@E 99,999"
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nEditType        := 1
            :bOnPostEdit      := {|o,x| if( dbDialogLock( ::cAreaTmpLabel ), ( ( ::cAreaTmpLabel )->nLabel := x, ( ::cAreaTmpLabel )->( dbUnlock() ) ), ) }
        end with

        REDEFINE METER ::oMtrLabel ;
            VAR      ::nMtrLabel ;
            PROMPT   "" ;
            ID       190 ;
            OF       ::oFld:aDialogs[ 2 ] ;
            TOTAL    ( ::cAreaTmpLabel  )->( lastrec() )

        ::oMtrLabel:nClrText   := rgb( 128,255,0 )
        ::oMtrLabel:nClrBar    := rgb( 128,255,0 )
        ::oMtrLabel:nClrBText  := rgb( 128,255,0 )

        /*
        Botones generales--------------------------------------------------------
        */

        REDEFINE BUTTON ::oBtnAnterior ;          	// Boton anterior
            ID       20 ;
            OF       ::oDlg ;
            ACTION   ( msginfo( "Anterior" ) )    	//::BotonAnterior() )

        REDEFINE BUTTON ::oBtnSiguiente ;         	// Boton de Siguiente
            ID       30 ;
            OF       ::oDlg ;
            ACTION   ( msginfo( "Siguiente" ) ) 	//::BotonSiguiente() )

        REDEFINE BUTTON ::oBtnCancel ;            	// Boton de Siguiente
            ID       IDCANCEL ;
            OF       ::oDlg ;
            ACTION   ( ::oDlg:End() )

      //::oDlg:bStart  := {|| ::oBtnAnterior:Hide(), ::oFormatoLabel:lValid(), oBtnMod:Hide(), oBtnZoo:Hide(), oBtnPrp:Hide() }

      ACTIVATE DIALOG ::oDlg CENTER

      //::End()

   //end if

Return ( Self )

//--------------------------------------------------------------------------//

/*Method lCreateAuxiliar() CLASS TLabelGenerator

   local oBlock
   local oError
   local lCreateAuxiliar   := .t.

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::cAreaTmpLabel      := "Lbl" + cCurUsr()
      ::cFileTmpLabel      := cGetNewFileName( cPatTmp() + "Lbl" )

      dbCreate( ::cFileTmpLabel, aSqlStruct( aColFacPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), ::cFileTmpLabel, ::cAreaTmpLabel, .f. )

      if!( ::cAreaTmpLabel )->( neterr() )
         ( ::cAreaTmpLabel )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( ::cAreaTmpLabel )->( OrdCreate( ::cFileTmpLabel, "cRef", "cRef", {|| Field->cRef } ) )

         ( ::cAreaTmpLabel )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( ::cAreaTmpLabel )->( OrdCreate( ::cFileTmpLabel, "cDetalle", "Upper( cDetalle )", {|| Upper( Field->cDetalle ) } ) )
      end if

      ( ::cAreaTmpLabel )->( OrdsetFocus( "cRef" ) )

   RECOVER USING oError

      lCreateAuxiliar      := .f.

      MsgStop( 'Imposible crear fichero temporal' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateAuxiliar )

//--------------------------------------------------------------------------//

Method BotonAnterior() CLASS TLabelGenerator

   ::oFld:GoPrev()

   ::oBtnAnterior:Hide()

   SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonSiguiente() CLASS TLabelGenerator

   do case
      case ::oFld:nOption == 1

         if Empty( ::cFormatoLabel )

            MsgStop( "Debe cumplimentar un formato de etiquetas" )

         else

            ::LoadAuxiliar()

            ::oFld:GoNext()
            ::oBtnAnterior:Show()
            SetWindowText( ::oBtnSiguiente:hWnd, "&Terminar" )

         end if

      case ::oFld:nOption == 2

         if ::lPrintLabels()

            SetWindowText( ::oBtnCancel:hWnd, "&Cerrar" )

         end if

   end case

Return ( Self )

//--------------------------------------------------------------------------//

Method lCreateTemporal() CLASS TLabelGenerator

   local n
   local nRec
   local oBlock
   local oError
   local nBlancos
   local lCreateTemporal   := .t.

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      tmpFacPrvL           := "LblFac"
      filFacPrvL           := cGetNewFileName( cPatTmp() + "LblFac" )

      dbCreate( filFacPrvL, aSqlStruct( aColFacPrv() ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), filFacPrvL, tmpFacPrvL, .f. )

      ( tmpFacPrvL )->( OrdCondSet( "!Deleted()", {||!Deleted()} ) )
      ( tmpFacPrvL )->( OrdCreate( filFacPrvL, "nNumFac", "cSerFac + Str( nNumFac ) + cSufFac", {|| Field->cSerFac + Str( Field->nNumFac ) + Field->cSufFac } ) )

      nRec                 := ( ::cAreaTmpLabel )->( Recno() )

      ( ::cAreaTmpLabel )->( dbGoTop() )
      while !( ::cAreaTmpLabel )->( eof() )

         if ( ::cAreaTmpLabel )->lLabel
            for n := 1 to ( ::cAreaTmpLabel )->nLabel
               dbPass( ::cAreaTmpLabel, tmpFacPrvL, .t. )
            next
         end if

         ( ::cAreaTmpLabel )->( dbSkip() )

      end while
      ( tmpFacPrvL )->( dbGoTop() )

      ( ::cAreaTmpLabel )->( dbGoTo( nRec ) )

   RECOVER USING oError

      lCreateTemporal      := .f.

      MsgStop( 'Imposible abrir ficheros de artículos' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateTemporal )

//---------------------------------------------------------------------------//

Method DestroyTemporal() CLASS TLabelGenerator

   if ( tmpFacPrvL )->( Used() )
      ( tmpFacPrvL )->( dbCloseArea() )
   end if

   dbfErase( filFacPrvL )

   tmpFacPrvL           := nil

   SysRefresh()

Return ( .t. )

//---------------------------------------------------------------------------//

Method PrepareTemporal( oFr ) CLASS TLabelGenerator

   local n
   local nBlancos       := 0
   local nPaperHeight   := oFr:GetProperty( "MainPage", "PaperHeight" ) * fr01cm
   local nHeight        := oFr:GetProperty( "CabeceraColumnas", "Height" )
   local nColumns       := oFr:GetProperty( "MainPage", "Columns" )
   local nItemsInColumn := 0

   if !Empty( nPaperHeight ) .and. !Empty( nHeight ) .and. !Empty( nColumns )

      nItemsInColumn       := int( nPaperHeight / nHeight )

      nBlancos             := ( ::nColumnaInicio - 1 ) * nItemsInColumn
      nBlancos             += ( ::nFilaInicio - 1 )

      for n := 1 to nBlancos
         dbPass( dbBlankRec( dbfFacPrvL ), tmpFacPrvL, .t. )
      next

   end if 

   ( tmpFacPrvL )->( dbGoTop() )

Return ( .t. )

//---------------------------------------------------------------------------//

Method lPrintLabels() CLASS TLabelGenerator

   local oFr

   local nCopies      := 1
   local nDevice      := IS_SCREEN
   local cPrinter     := PrnGetName()

   if ::lCreateTemporal()

      SysRefresh()

      oFr                  := frReportManager():New()

      oFr:LoadLangRes(     "Spanish.Xml" )

      oFr:SetIcon( 1 )

      oFr:SetTitle(        "Diseñador de documentos" )


      /*
      Manejador de eventos--------------------------------------------------------
      

      oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

      /*
      Zona de datos---------------------------------------------------------------
      

      DataLabel( oFr, .t. )

      /*
      Cargar el informe-----------------------------------------------------------
      

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

         /*
         Zona de variables--------------------------------------------------------
         

         ::PrepareTemporal( oFr )

         /*
         Preparar el report-------------------------------------------------------
         

         oFr:PrepareReport()

         /*
         Imprimir el informe------------------------------------------------------
         

         do case
            case nDevice == IS_SCREEN
               oFr:ShowPreparedReport()

            case nDevice == IS_PRINTER
               oFr:PrintOptions:SetPrinter( cPrinter )
               oFr:PrintOptions:SetCopies( nCopies )
               oFr:PrintOptions:SetShowDialog( .f. )
               oFr:Print()

            case nDevice == IS_PDF
               oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
               oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
               oFr:SetProperty(  "PDFExport", "Outline",          .t. )
               oFr:DoExport(     "PDFExport" )

         end case

      end if

      /*
      Destruye el diseñador-------------------------------------------------------
      

      oFr:DestroyFr()

      /*
      Destruye el fichero temporal------------------------------------------------
      

      ::DestroyTemporal()

   end if

Return .t.

//---------------------------------------------------------------------------//

Method End() CLASS TLabelGenerator

   if !Empty( ::nRecno )
      ( dbfFacPrvT )->( dbGoTo( ::nRecno ) )
   end if

   if IsTrue( ::lClose )
      CloseFiles()
   end if

   if !Empty( ::cAreaTmpLabel ) .and. ( ::cAreaTmpLabel )->( Used() )
      ( ::cAreaTmpLabel )->( dbCloseArea() )
   end if

   dbfErase( ::cFileTmpLabel )

   WritePProString( "Etiquetas", "Factura proveedor", ::cFormatoLabel, cPatEmp() + "Empresa.Ini" )

Return ( Self )

//--------------------------------------------------------------------------//

Method PutLabel() CLASS TLabelGenerator

   ( ::cAreaTmpLabel )->lLabel   := !( ::cAreaTmpLabel )->lLabel

   ::oBrwLabel:Refresh()
   ::oBrwLabel:Select()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectAllLabels( lSelect ) CLASS TLabelGenerator

   local n        := 0
   local nRecno   := ( ::cAreaTmpLabel )->( Recno() )

   CursorWait()

   ( ::cAreaTmpLabel )->( dbGoTop() )
   while !( ::cAreaTmpLabel )->( eof() )

      ( ::cAreaTmpLabel )->lLabel := lSelect

      ( ::cAreaTmpLabel )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ( ::cAreaTmpLabel )->( dbGoTo( nRecno ) )

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

Method AddLabel() CLASS TLabelGenerator

   ( ::cAreaTmpLabel )->nLabel++

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method DelLabel() CLASS TLabelGenerator

   if ( ::cAreaTmpLabel )->nLabel > 1
      ( ::cAreaTmpLabel )->nLabel--
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

Method EditLabel() CLASS TLabelGenerator

   ::oBrwLabel:aCols[ 6 ]:Edit()

Return ( Self )

//---------------------------------------------------------------------------//

Method LoadAuxiliar() CLASS TLabelGenerator

   local nRec
   local nOrd

   /*
   Limpiamos la base de datos temporal-----------------------------------------
   

   ( ::cAreaTmpLabel )->( __dbZap() )

   /*
   Llenamos la tabla temporal--------------------------------------------------
   

   nRec           := ( dbfFacPrvT )->( Recno() )
   nOrd           := ( dbfFacPrvT )->( OrdSetFocus( "nNumFac" ) )

   if ( dbfFacPrvT )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( dbfFacPrvT )->cSerFac + Str( ( dbfFacPrvT )->nNumFac ) + ( dbfFacPrvT )->cSufFac >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio .and. ;
            ( dbfFacPrvT )->cSerFac + Str( ( dbfFacPrvT )->nNumFac ) + ( dbfFacPrvT )->cSufFac <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin          .and. ;
            !( dbfFacPrvT )->( eof() )

         if ( dbfFacPrvL )->( dbSeek( ( dbfFacPrvT )->cSerFac + Str( ( dbfFacPrvT )->nNumFac ) + ( dbfFacPrvT )->cSufFac ) )

            while ( ( dbfFacPrvL )->cSerFac + Str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac == ( dbfFacPrvT )->cSerFac + Str( ( dbfFacPrvT )->nNumFac ) + ( dbfFacPrvT )->cSufFac ) .and. ( dbfFacPrvL )->( !eof() )

               if !Empty( ( dbfFacPrvL )->cRef )

                  ( ::cAreaTmpLabel )->( dbAppend() )

                  ( ::cAreaTmpLabel )->cSerFac  := ( dbfFacPrvL )->cSerFac
                  ( ::cAreaTmpLabel )->nNumFac  := ( dbfFacPrvL )->nNumFac
                  ( ::cAreaTmpLabel )->cSufFac  := ( dbfFacPrvL )->cSufFac
                  ( ::cAreaTmpLabel )->cRef     := ( dbfFacPrvL )->cRef
                  ( ::cAreaTmpLabel )->cRefPrv  := ( dbfFacPrvL )->cRefPrv
                  ( ::cAreaTmpLabel )->cDetalle := ( dbfFacPrvL )->cDetalle
                  ( ::cAreaTmpLabel )->nPreUnit := ( dbfFacPrvL )->nPreUnit
                  ( ::cAreaTmpLabel )->nIva     := ( dbfFacPrvL )->nIva
                  ( ::cAreaTmpLabel )->nReq     := ( dbfFacPrvL )->nReq
                  ( ::cAreaTmpLabel )->nCanEnt  := ( dbfFacPrvL )->nCanEnt
                  ( ::cAreaTmpLabel )->lControl := ( dbfFacPrvL )->lControl
                  ( ::cAreaTmpLabel )->cUnidad  := ( dbfFacPrvL )->cUnidad
                  ( ::cAreaTmpLabel )->nUniCaja := ( dbfFacPrvL )->nUniCaja
                  ( ::cAreaTmpLabel )->lChgLin  := ( dbfFacPrvL )->lChgLin
                  ( ::cAreaTmpLabel )->mLngDes  := ( dbfFacPrvL )->mLngDes
                  ( ::cAreaTmpLabel )->nDtoLin  := ( dbfFacPrvL )->nDtoLin
                  ( ::cAreaTmpLabel )->nDtoPrm  := ( dbfFacPrvL )->nDtoPrm
                  ( ::cAreaTmpLabel )->nDtoRap  := ( dbfFacPrvL )->nDtoRap
                  ( ::cAreaTmpLabel )->nPreCom  := ( dbfFacPrvL )->nPreCom
                  ( ::cAreaTmpLabel )->lBnfLin1 := ( dbfFacPrvL )->lBnfLin1
                  ( ::cAreaTmpLabel )->lBnfLin2 := ( dbfFacPrvL )->lBnfLin2
                  ( ::cAreaTmpLabel )->lBnfLin3 := ( dbfFacPrvL )->lBnfLin3
                  ( ::cAreaTmpLabel )->lBnfLin4 := ( dbfFacPrvL )->lBnfLin4
                  ( ::cAreaTmpLabel )->lBnfLin5 := ( dbfFacPrvL )->lBnfLin5
                  ( ::cAreaTmpLabel )->lBnfLin6 := ( dbfFacPrvL )->lBnfLin6
                  ( ::cAreaTmpLabel )->nBnfLin1 := ( dbfFacPrvL )->nBnfLin1
                  ( ::cAreaTmpLabel )->nBnfLin2 := ( dbfFacPrvL )->nBnfLin2
                  ( ::cAreaTmpLabel )->nBnfLin3 := ( dbfFacPrvL )->nBnfLin3
                  ( ::cAreaTmpLabel )->nBnfLin4 := ( dbfFacPrvL )->nBnfLin4
                  ( ::cAreaTmpLabel )->nBnfLin5 := ( dbfFacPrvL )->nBnfLin5
                  ( ::cAreaTmpLabel )->nBnfLin6 := ( dbfFacPrvL )->nBnfLin6
                  ( ::cAreaTmpLabel )->nBnfSbr1 := ( dbfFacPrvL )->nBnfSbr1
                  ( ::cAreaTmpLabel )->nBnfSbr2 := ( dbfFacPrvL )->nBnfSbr2
                  ( ::cAreaTmpLabel )->nBnfSbr3 := ( dbfFacPrvL )->nBnfSbr3
                  ( ::cAreaTmpLabel )->nBnfSbr4 := ( dbfFacPrvL )->nBnfSbr4
                  ( ::cAreaTmpLabel )->nBnfSbr5 := ( dbfFacPrvL )->nBnfSbr5
                  ( ::cAreaTmpLabel )->nBnfSbr6 := ( dbfFacPrvL )->nBnfSbr6
                  ( ::cAreaTmpLabel )->nPvpLin1 := ( dbfFacPrvL )->nPvpLin1
                  ( ::cAreaTmpLabel )->nPvpLin2 := ( dbfFacPrvL )->nPvpLin2
                  ( ::cAreaTmpLabel )->nPvpLin3 := ( dbfFacPrvL )->nPvpLin3
                  ( ::cAreaTmpLabel )->nPvpLin4 := ( dbfFacPrvL )->nPvpLin4
                  ( ::cAreaTmpLabel )->nPvpLin5 := ( dbfFacPrvL )->nPvpLin5
                  ( ::cAreaTmpLabel )->nPvpLin6 := ( dbfFacPrvL )->nPvpLin6
                  ( ::cAreaTmpLabel )->nIvaLin1 := ( dbfFacPrvL )->nIvaLin1
                  ( ::cAreaTmpLabel )->nIvaLin2 := ( dbfFacPrvL )->nIvaLin2
                  ( ::cAreaTmpLabel )->nIvaLin3 := ( dbfFacPrvL )->nIvaLin3
                  ( ::cAreaTmpLabel )->nIvaLin4 := ( dbfFacPrvL )->nIvaLin4
                  ( ::cAreaTmpLabel )->nIvaLin5 := ( dbfFacPrvL )->nIvaLin5
                  ( ::cAreaTmpLabel )->nIvaLin6 := ( dbfFacPrvL )->nIvaLin6
                  ( ::cAreaTmpLabel )->nIvaLin  := ( dbfFacPrvL )->nIvaLin
                  ( ::cAreaTmpLabel )->lIvaLin  := ( dbfFacPrvL )->lIvaLin
                  ( ::cAreaTmpLabel )->cCodPr1  := ( dbfFacPrvL )->cCodPr1
                  ( ::cAreaTmpLabel )->cCodPr2  := ( dbfFacPrvL )->cCodPr2
                  ( ::cAreaTmpLabel )->cValPr1  := ( dbfFacPrvL )->cValPr1
                  ( ::cAreaTmpLabel )->cValPr2  := ( dbfFacPrvL )->cValPr2
                  ( ::cAreaTmpLabel )->nFacCnv  := ( dbfFacPrvL )->nFacCnv
                  ( ::cAreaTmpLabel )->cAlmLin  := ( dbfFacPrvL )->cAlmLin
                  ( ::cAreaTmpLabel )->nCtlStk  := ( dbfFacPrvL )->nCtlStk
                  ( ::cAreaTmpLabel )->lLote    := ( dbfFacPrvL )->lLote
                  ( ::cAreaTmpLabel )->nLote    := ( dbfFacPrvL )->nLote
                  ( ::cAreaTmpLabel )->cLote    := ( dbfFacPrvL )->cLote
                  ( ::cAreaTmpLabel )->nNumLin  := ( dbfFacPrvL )->nNumLin
                  ( ::cAreaTmpLabel )->nUndKit  := ( dbfFacPrvL )->nUndKit
                  ( ::cAreaTmpLabel )->lKitArt  := ( dbfFacPrvL )->lKitArt
                  ( ::cAreaTmpLabel )->lKitChl  := ( dbfFacPrvL )->lKitChl
                  ( ::cAreaTmpLabel )->lKitPrc  := ( dbfFacPrvL )->lKitPrc
                  ( ::cAreaTmpLabel )->lImpLin  := ( dbfFacPrvL )->lImpLin
                  ( ::cAreaTmpLabel )->mNumSer  := ( dbfFacPrvL )->mNumSer
                  ( ::cAreaTmpLabel )->cCodUbi1 := ( dbfFacPrvL )->cCodUbi1
                  ( ::cAreaTmpLabel )->cCodUbi2 := ( dbfFacPrvL )->cCodUbi2
                  ( ::cAreaTmpLabel )->cCodUbi3 := ( dbfFacPrvL )->cCodUbi3
                  ( ::cAreaTmpLabel )->cValUbi1 := ( dbfFacPrvL )->cValUbi1
                  ( ::cAreaTmpLabel )->cValUbi2 := ( dbfFacPrvL )->cValUbi2
                  ( ::cAreaTmpLabel )->cValUbi3 := ( dbfFacPrvL )->cValUbi3
                  ( ::cAreaTmpLabel )->cNomUbi1 := ( dbfFacPrvL )->cNomUbi1
                  ( ::cAreaTmpLabel )->cNomUbi2 := ( dbfFacPrvL )->cNomUbi2
                  ( ::cAreaTmpLabel )->cNomUbi3 := ( dbfFacPrvL )->cNomUbi3
                  ( ::cAreaTmpLabel )->cCodFam  := ( dbfFacPrvL )->cCodFam
                  ( ::cAreaTmpLabel )->cGrpFam  := ( dbfFacPrvL )->cGrpFam
                  ( ::cAreaTmpLabel )->mObsLin  := ( dbfFacPrvL )->mObsLin
                  ( ::cAreaTmpLabel )->nPvpRec  := ( dbfFacPrvL )->nPvpRec
                  ( ::cAreaTmpLabel )->nUndLin  := nTotNFacPrv( dbfFacPrvL )
                  ( ::cAreaTmpLabel )->lLabel   := .t.

                  if ::nCantidadLabels == 1
                  ( ::cAreaTmpLabel )->nLabel   := nTotNFacPrv( dbfFacPrvL )
                  else
                  ( ::cAreaTmpLabel )->nLabel   := ::nUnidadesLabels
                  end if

               end if

               ( dbfFacPrvL )->( dbSkip() )

            end while

         end if

         ( dbfFacPrvT )->( dbSkip() )

      end while

   end if

   ( dbfFacPrvT )->( OrdSetFocus( nOrd ) )
   ( dbfFacPrvT )->( dbGoTo( nRec ) )

   ( ::cAreaTmpLabel )->( dbGoTop() )

   ::oBrwLabel:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

Method InitLabel( oLabel ) CLASS TLabelGenerator

   local nStartRow

   if ::nFilaInicio > 1
      nStartRow            := oLabel:nStartRow
      nStartRow            += ( ::nFilaInicio - 1 ) * ( oLabel:nLblHeight + oLabel:nVSeparator )

      if nStartRow < oLabel:nBottomRow
         oLabel:nStartRow  := nStartRow
      end if
   end if

   if ::nColumnaInicio > 1 .and. ::nColumnaInicio <= oLabel:nLblOnLine
      oLabel:nLblCurrent   := ::nColumnaInicio
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method SelectColumn( oCombo ) CLASS TLabelGenerator

   local oCol
   local cOrd                    := oCombo:VarGet()

   if ::oBrwLabel != nil

      with object ::oBrwLabel

         for each oCol in :aCols

            if Eq( cOrd, oCol:cHeader )
               oCol:cOrder       := "A"
               oCol:SetOrder()
            else
               oCol:cOrder       := " "
            end if

         next

      end with

      ::oBrwLabel:Refresh()

   end if

Return ( Self )*/

//---------------------------------------------------------------------------//