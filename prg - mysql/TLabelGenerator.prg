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

   Data nRecno
   DATA nOrder

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

   Data cPrinter

   Data nFilaInicio
   Data nColumnaInicio

   Data oBrwLabel

   Data nCantidadLabels
   Data nUnidadesLabels

   Data oMtrLabel
   Data nMtrLabel

   Data lClose

   Data lErrorOnCreate

   Data oBtnListado
   Data oBtnSiguiente
   Data oBtnAnterior
   Data oBtnCancel

   DATA oBtnPropiedades
   DATA oBtnModificar
   DATA oBtnZoom

   DATA oComboBoxOrden
   DATA cComboBoxOrden                 INIT "Código"
   DATA aComboBoxOrden                 INIT { "Código", "Nombre" }

   DATA lHideSerie                     INIT .f.

   Data aSearch

   Data cFileTmpLabel
   Data tmpLabelEdition

   Data dbfCabecera
   Data dbfLineas 

   Data idDocument
   Data dbfDocumento

   Data cNombreDocumento

   Data inicialDoc

   Data aStructureField 

   DATA tmpLabelReport
   DATA fileLabelReport

   Data nView

   METHOD New()
   METHOD Create( oSender )

   METHOD isErrorOnCreate()               INLINE ( ::lErrorOnCreate )

   METHOD Dialog()
   METHOD startDialog()

   METHOD lCreateTempLabelEdition()      
   METHOD loadTempLabelEdition()          VIRTUAL
   METHOD loadTempLabelReport()           INLINE ( ::loadTempLabelEdition( ::tmpLabelReport ) )
   METHOD destroyTempLabelEdition()

   METHOD createTempLabelReport()            
   METHOD loadTempReport()   
   METHOD destroyTempReport()     

   METHOD PrepareTempReport( oFr )    
      METHOD buildReportLabels()

   METHOD End()

   METHOD BotonAnterior()
   METHOD BotonSiguiente()

   METHOD PutLabel()

   METHOD SelectAllLabels()
   METHOD AddLabel()
   METHOD DelLabel()
   METHOD EditLabel()
   METHOD SelectColumn( oCombo )

   METHOD lPrintLabels()
   METHOD InitLabel( oLabel )

   METHOD closeFiles()                    INLINE ( D():DeleteView( ::nView ) )
   METHOD dataLabel( oFr )                VIRTUAL
   METHOD variableLabel( oFr )            VIRTUAL 

   //METHOD nombrePrimeraPropiedad()        INLINE ( if( !empty( ::tmpLabelReport ), ( ::tmpLabelReport )->cCodPr1 + ( ::tmpLabelReport )->cValPr1, "empty(tmpLabelReport)" ) )
   //METHOD nombreSegundaPropiedad()        INLINE ( if( !empty( ::tmpLabelReport ), ( ::tmpLabelReport )->cCodPr2 + ( ::tmpLabelReport )->cValPr2, "empty(tmpLabelReport)" ) )

   METHOD nombrePrimeraPropiedad()        INLINE ( if( !empty( ::tmpLabelReport ), nombrePropiedad( ( ::tmpLabelReport )->cCodPr1, ( ::tmpLabelReport )->cValPr1, ::nView ), "" ) )
   METHOD nombreSegundaPropiedad()        INLINE ( if( !empty( ::tmpLabelReport ), nombrePropiedad( ( ::tmpLabelReport )->cCodPr2, ( ::tmpLabelReport )->cValPr2, ::nView ), "" ) )

   METHOD refreshBrowseLabel()            INLINE ( if( !empty( ::oBrwLabel ), ::oBrwLabel:Refresh(), ) )

   METHOD buildCodeColumn() 
   METHOD buildDetailColumn()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView ) CLASS TLabelGenerator

   local oError
   local oBlock

   if !empty( nView )
      ::nView              := nView
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::dbfDocumento       := ( D():Documentos( ::nView ) )

      ::nRecno             := ( ::dbfCabecera )->( Recno() )
      ::nOrder             := ( ::dbfCabecera )->( OrdSetFocus( 1 ) )

      ::cFormatoLabel      := GetPvProfString( "Etiquetas", ::cNombreDocumento, Space( 3 ), cPatEmp() + "Empresa.Ini" )
      if len( ::cFormatoLabel ) < 3
         ::cFormatoLabel   := Space( 3 )
      end if

      ::nMtrLabel          := 0
 
      ::nFilaInicio        := 1
      ::nColumnaInicio     := 1

      ::nCantidadLabels    := 1
      ::nUnidadesLabels    := 1

      ::aSearch            := { "Código", "Nombre" }

      ::lErrorOnCreate     := .f.

      setFastReportObject( self )

   RECOVER USING oError

      ::lErrorOnCreate     := .t.

      msgStop( "Error en la creación de generador de etiquetas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD Create( oSender )

   ::New( oSender:nView )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD buildCodeColumn() CLASS TLabelGenerator

   with object ( ::oBrwLabel:AddCol() )
      :cHeader          := "Código"
      :bEditValue       := {|| ( ::tmpLabelEdition )->cRef }
      :nWidth           := 80
      :cSortOrder       := "cRef"
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oComboBoxOrden:Set( oCol:cHeader ) }
   end with

Return ( Self )

//------------------------------------------------------------------------//

METHOD buildDetailColumn() CLASS TLabelGenerator

   with object ( ::oBrwLabel:AddCol() )
      :cHeader          := "Nombre"
      :bEditValue       := {|| ( ::tmpLabelEdition )->cDetalle }
      :nWidth           := 250
      :cSortOrder       := "cDetalle"
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oComboBoxOrden:Set( oCol:cHeader ) }
   end with

Return ( Self )

//------------------------------------------------------------------------//

METHOD Dialog() CLASS TLabelGenerator

   local oGetOrd
   local cGetOrd     := Space( 100 )

   if ::lErrorOnCreate
      Return ( Self )
   endif

   if !::lCreateTempLabelEdition()
      Return ( Self )
   endif

   DEFINE DIALOG ::oDlg RESOURCE "SelectLabels_0"

      REDEFINE PAGES ::oFld ;
         ID       10;
         OF       ::oDlg ;
         DIALOGS  "SelectLabels_1",;
                  "SelectLabels_2"

      REDEFINE BITMAP ;
         RESOURCE "gc_portable_barcode_scanner_48" ;
         ID       500 ;
         TRANSPARENT ;
         OF       ::oDlg ;

      REDEFINE GET ::oSerieInicio VAR ::cSerieInicio ;
         ID       100 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( ::oSerieInicio ) );
         ON DOWN  ( DwSerie( ::oSerieInicio ) );
         VALID    ( ( ::cSerieInicio >= "A" .and. ::cSerieInicio <= "Z" ) .or. ( ::lHideSerie ) );
         UPDATE ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE GET ::oSerieFin VAR ::cSerieFin ;
         ID       110 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( ::oSerieFin ) );
         ON DOWN  ( DwSerie( ::oSerieFin ) );
         VALID    ( ( ::cSerieInicio >= "A" .and. ::cSerieInicio <= "Z" ) .or. ( ::lHideSerie ) );
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

         ::oFormatoLabel:bValid  := {|| cDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, ::dbfDocumento, ::inicialDoc ) }
         ::oFormatoLabel:bHelp   := {|| brwDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, ::inicialDoc ) }

      TBtnBmp():ReDefine( 220, "gc_document_text_pencil_12",,,,, {|| EdtDocumento( ::cFormatoLabel ) }, ::oFld:aDialogs[ 1 ], .f., , .f., "Modificar formato de etiquetas" )

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
      */

      REDEFINE GET oGetOrd ;
         VAR      cGetOrd ;
         ID       200 ;
         BITMAP   "FIND" ;
         OF       ::oFld:aDialogs[ 2 ]

      oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwLabel, ::tmpLabelEdition ) }
      oGetOrd:bValid    := {|| ( ::tmpLabelEdition )->( OrdScope( 0, nil ) ), ( ::tmpLabelEdition )->( OrdScope( 1, nil ) ), ::refreshBrowseLabel(), .t. }

      REDEFINE COMBOBOX ::oComboBoxOrden ;
         VAR      ::cComboBoxOrden ;
         ID       210 ;
         ITEMS    ::aComboBoxOrden ;
         OF       ::oFld:aDialogs[ 2 ]

      ::oComboBoxOrden:bChange   := {|| ::SelectColumn( ::oComboBoxOrden ) }

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

      REDEFINE BUTTON ::oBtnPropiedades ;
         ID       220 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( nil )

      REDEFINE BUTTON ::oBtnModificar;
         ID       160 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( nil )

      REDEFINE BUTTON ::oBtnZoom;
         ID       165 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( nil )

      ::oBrwLabel                 := IXBrowse():New( ::oFld:aDialogs[ 2 ] )

      ::oBrwLabel:nMarqueeStyle   := 5
      ::oBrwLabel:nColSel         := 2

      ::oBrwLabel:lHScroll        := .f.
      ::oBrwLabel:cAlias          := ::tmpLabelEdition

      ::oBrwLabel:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwLabel:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwLabel:bLDblClick      := {|| ::PutLabel() }

      ::oBrwLabel:CreateFromResource( 180 )

      with object ( ::oBrwLabel:AddCol() )
         :cHeader          := "Sl. Seleccionada"
         :bEditValue       := {|| ( ::tmpLabelEdition )->lLabel }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      ::buildCodeColumn()

      ::buildDetailColumn()

      with object ( ::oBrwLabel:AddCol() )
         :cHeader          := "Prp. 1"
         :bEditValue       := {|| ( ::tmpLabelEdition )->cValPr1 }
         :nWidth           := 40
      end with

      with object ( ::oBrwLabel:AddCol() )
         :cHeader          := "Prp. 2"
         :bEditValue       := {|| ( ::tmpLabelEdition )->cValPr2 }
         :nWidth           := 40
      end with

      with object ( ::oBrwLabel:AddCol() )
         :cHeader          := "N. etiquetas"
         :bEditValue       := {|| ( ::tmpLabelEdition )->nLabel }
         :cEditPicture     := "@E 99,999"
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :bOnPostEdit      := {|o,x| if( dbDialogLock( ::tmpLabelEdition ), ( ( ::tmpLabelEdition )->nLabel := x, ( ::tmpLabelEdition )->( dbUnlock() ) ), ) }
      end with

      REDEFINE APOLOMETER ::oMtrLabel ;
         VAR      ::nMtrLabel ;
         PROMPT   "" ;
         ID       190 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         TOTAL    ( ::tmpLabelEdition  )->( lastrec() )

      ::oMtrLabel:nClrText   := rgb( 128,255,0 )
      ::oMtrLabel:nClrBar    := rgb( 128,255,0 )
      ::oMtrLabel:nClrBText  := rgb( 128,255,0 )

      /*
      Botones generales-------------------------------------------------------
      */

      REDEFINE BUTTON ::oBtnListado ;          // Boton anterior
         ID       40 ;
         OF       ::oDlg ;
         ACTION   ( ::BotonAnterior() )

      REDEFINE BUTTON ::oBtnAnterior ;          // Boton anterior
         ID       20 ;
         OF       ::oDlg ;
         ACTION   ( ::BotonAnterior() )

      REDEFINE BUTTON ::oBtnSiguiente ;         // Boton de Siguiente
         ID       30 ;
         OF       ::oDlg ;
         ACTION   ( ::BotonSiguiente() )

      REDEFINE BUTTON ::oBtnCancel ;            // Boton de Cancelar
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:End() )

   ::oDlg:bStart  := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::DestroyTempLabelEdition()

   ::End()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD startDialog()

   ::oBtnListado:Hide()
   ::oBtnAnterior:Hide()
   
   ::oFormatoLabel:lValid()
   
   ::oBtnModificar:Hide()
   ::oBtnZoom:Hide()
   ::oBtnPropiedades:Hide()

   if ::lHideSerie
      ::oSerieInicio:Hide()
      ::oSerieFin:Hide()
   end if 

Return ( Self )

//--------------------------------------------------------------------------//

METHOD lCreateTempLabelEdition() CLASS TLabelGenerator

   local oBlock
   local oError
   local lCreateTempLabelEdition   := .t.

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::tmpLabelEdition       := "LblEdt" + cCurUsr()

      ::cFileTmpLabel         := cGetNewFileName( cPatTmp() + "LblEdt" )

      ::DestroyTempLabelEdition()

      dbCreate( ::cFileTmpLabel,  ::aStructureField , cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), ::cFileTmpLabel, ::tmpLabelEdition, .f. )

      if!( ::tmpLabelEdition )->( neterr() )
         ( ::tmpLabelEdition )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( ::tmpLabelEdition )->( OrdCreate( ::cFileTmpLabel, "cRef", "cRef", {|| Field->cRef } ) )

         ( ::tmpLabelEdition )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( ::tmpLabelEdition )->( OrdCreate( ::cFileTmpLabel, "cDetalle", "Upper( cDetalle )", {|| Upper( Field->cDetalle ) } ) )
      end if

      ( ::tmpLabelEdition )->( OrdsetFocus( "cRef" ) )

   RECOVER USING oError

      lCreateTempLabelEdition      := .f.

      MsgStop( 'Imposible crear fichero temporal' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateTempLabelEdition )

//---------------------------------------------------------------------------//

METHOD DestroyTempLabelEdition() CLASS TLabelGenerator

   if !empty( ::tmpLabelEdition ) .and. ( ::tmpLabelEdition )->( Used() )
      ( ::tmpLabelEdition )->( dbCloseArea() )
   end if

   dbfErase( ::cFileTmpLabel )

   SysRefresh()

Return ( nil )

//--------------------------------------------------------------------------//

METHOD BotonAnterior() CLASS TLabelGenerator

   ::oFld:GoPrev()

   ::oBtnAnterior:Hide()

   SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD BotonSiguiente() CLASS TLabelGenerator

   do case
      case ::oFld:nOption == 1

         if empty( ::cFormatoLabel )

            MsgStop( "Debe cumplimentar un formato de etiquetas" )

         else

            ::loadTempLabelEdition()

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

//---------------------------------------------------------------------------//

METHOD lPrintLabels() CLASS TLabelGenerator

   ::oDlg:Disable()

   if ::createTempLabelReport()
      ::loadTempReport()
      ::buildReportLabels()
      ::destroyTempReport()
   end if

   ::oDlg:Enable()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD buildReportLabels() CLASS TLabelGenerator

   local oFr
   local nCopies     := 1
   local nDevice     := IS_SCREEN
   local cPrinter    := PrnGetName()

   sysRefresh()

   oFr               := frReportManager():New()
   oFr:LoadLangRes( "Spanish.Xml" )
   oFr:SetIcon( 1 )
   oFr:SetTitle( "Diseñador de documentos" )

   // Manejador de eventos--------------------------------------------------------

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( ::dbfDocumento )->( Select() ), "mReport" ) } )
   
   // Zona de datos---------------------------------------------------------------

   ::dataLabel( oFr )

   ::variableLabel( oFr )

   // Cargar el informe-----------------------------------------------------------
   
   if !empty( ( ::dbfDocumento )->mReport )

      oFr:LoadFromBlob( ( ::dbfDocumento )->( select() ), "mReport")

      ::prepareTempReport( oFr )
      
      // Imprimir el informe------------------------------------------------------

      do case
         case nDevice == IS_SCREEN
            oFr:ShowReport()

         case nDevice == IS_PRINTER
            oFr:PrepareReport()
            oFr:PrintOptions:SetPrinter( cPrinter )
            oFr:PrintOptions:SetCopies( nCopies )
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:Print()

         case nDevice == IS_PDF
            oFr:PrepareReport()
            oFr:DoExport( "PDFExport" )

      end case

   else 

      msgStop( "Imposible cargar el documento de la etiquetas.")

   end if
   
   // Destruye el diseñador-------------------------------------------------------
   
   oFr:DestroyFr()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD createTempLabelReport() CLASS TLabelGenerator

   local oBlock
   local oError
   local createTempLabelReport := .t.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::tmpLabelReport     := "LblRpt" + cCurUsr()
      ::fileLabelReport    := cGetNewFileName( cPatTmp() + "LblRpt" )

      dbCreate( ::fileLabelReport, ::aStructureField, cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), ::fileLabelReport, ::tmpLabelReport, .f. )

      if!( ::tmpLabelReport )->( neterr() )
         ( ::tmpLabelReport )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( ::tmpLabelReport )->( OrdCreate( ::fileLabelReport, "cRef", "cRef", {|| Field->cRef } ) )
      end if

   RECOVER USING oError

      createTempLabelReport    := .f.

      MsgStop( 'Imposible crear un fichero temporal de lineas del documento' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( createTempLabelReport )

//---------------------------------------------------------------------------//

METHOD loadTempReport() CLASS TLabelGenerator

   local n
   local nRec           

   ( ::tmpLabelReport )->( __dbzap() )

   nRec                 := ( ::tmpLabelEdition )->( recno() )

   if !empty(::oMtrLabel)
      ::oMtrLabel:setTotal( ( ::tmpLabelEdition )->( lastRec() ) )
   end if 

   ( ::tmpLabelEdition )->( dbgotop() )
   while !( ::tmpLabelEdition )->( eof() )

      if ( ::tmpLabelEdition )->lLabel
         for n := 1 to ( ::tmpLabelEdition )->nLabel
            dbPass( ::tmpLabelEdition, ::tmpLabelReport, .t. )
         next
      end if

      ( ::tmpLabelEdition )->( dbskip() )

      if !empty(::oMtrLabel)
         ::oMtrLabel:autoInc()
      end if 

   end while

   ( ::tmpLabelReport )->( dbgotop() )

   ( ::tmpLabelEdition )->( dbgoto( nRec ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DestroyTempReport() CLASS TLabelGenerator

   if ( ::tmpLabelReport )->( Used() )
      ( ::tmpLabelReport )->( dbCloseArea() )
   end if

   dbfErase( ::fileLabelReport )

   ::tmpLabelReport           := nil

   SysRefresh()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD prepareTempReport( oFr ) CLASS TLabelGenerator

   local n
   local nBlancos       := 0
   local nItemsInColumn := 0
   local nPaperHeight   := oFr:GetProperty( "MainPage", "PaperHeight" ) * fr01cm
   local nColumns       := oFr:GetProperty( "MainPage", "Columns" )
   local nHeight        := oFr:GetProperty( "MasterData", "Height" )

   if !empty( nPaperHeight ) .and. !empty( nHeight ) .and. !empty( nColumns )

      nItemsInColumn    := int( nPaperHeight / nHeight )

      nBlancos          := ( ::nColumnaInicio - 1 ) * nItemsInColumn
      nBlancos          += ( ::nFilaInicio - 1 )

      for n := 1 to nBlancos
         dbPass( dbBlankRec( ::tmpLabelEdition ), ::tmpLabelReport, .t. )
      next

   end if 

   ( ::tmpLabelReport )->( dbGoTop() )
   
Return ( .t. )

//--------------------------------------------------------------------------//

METHOD End() CLASS TLabelGenerator

   if !empty( ::nOrder )
      ( ::dbfCabecera )->( ordsetfocus( ::nOrder ) )
   end if

   if !empty( ::nRecno )
      ( ::dbfCabecera )->( dbGoTo( ::nRecno ) )
   end if

   if IsTrue( ::lClose )
      ::CloseFiles()
   end if

   // Destruye el fichero temporal------------------------------------------------

   ::DestroyTempLabelEdition()

   WritePProString( "Etiquetas", ::cNombreDocumento, ::cFormatoLabel, cPatEmp() + "Empresa.Ini" )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD PutLabel() CLASS TLabelGenerator

   ( ::tmpLabelEdition )->lLabel   := !( ::tmpLabelEdition )->lLabel

   ::refreshBrowseLabel()
   ::oBrwLabel:Select()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelectAllLabels( lLabel ) CLASS TLabelGenerator

   local n        := 0
   local nRecno   := ( ::tmpLabelEdition )->( Recno() )

   CursorWait()

   ( ::tmpLabelEdition )->( dbGoTop() )
   while !( ::tmpLabelEdition )->( eof() )

      ( ::tmpLabelEdition )->lLabel := lLabel

      ( ::tmpLabelEdition )->( dbSkip() )

      ::oMtrLabel:Set( ++n )

   end while

   ( ::tmpLabelEdition )->( dbGoTo( nRecno ) )

   ::oMtrLabel:set( 0 )

   ::refreshBrowseLabel()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD AddLabel() CLASS TLabelGenerator

   ( ::tmpLabelEdition )->nLabel++

   ::refreshBrowseLabel()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD DelLabel() CLASS TLabelGenerator

   if ( ::tmpLabelEdition )->nLabel > 1
      ( ::tmpLabelEdition )->nLabel--
   end if

   ::refreshBrowseLabel()
   ::oBrwLabel:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD EditLabel() CLASS TLabelGenerator

   ::oBrwLabel:aCols[ 6 ]:Edit()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD InitLabel( oLabel ) CLASS TLabelGenerator

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

METHOD SelectColumn( oCombo ) CLASS TLabelGenerator

   local oCol
   local cOrd                    := oCombo:VarGet()

   if ::oBrwLabel != nil

      with object ::oBrwLabel

         for each oCol in :aCols

            if Equal( cOrd, oCol:cHeader )
               oCol:cOrder       := "A"
               oCol:SetOrder()
            else
               oCol:cOrder       := " "
            end if

         next

      end with

      ::refreshBrowseLabel()

   end if

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TLabelGeneratorPedidoProveedores FROM TLabelGenerator

   METHOD New( nView )

   METHOD loadTempLabelEdition() 
   
   METHOD dataLabel( oFr )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TLabelGeneratorPedidoProveedores

   ::dbfCabecera        := ( D():PedidosProveedores( nView ) )
   ::dbfLineas          := ( D():PedidosProveedoresLineas( nView ) )
   ::idDocument         := D():PedidosProveedoresId( nView ) 

   ::cSerieInicio       := ( ::dbfCabecera )->cSerPed
   ::cSerieFin          := ( ::dbfCabecera )->cSerPed

   ::nDocumentoInicio   := ( ::dbfCabecera )->nNumPed
   ::nDocumentoFin      := ( ::dbfCabecera )->nNumPed

   ::cSufijoInicio      := ( ::dbfCabecera )->cSufPed
   ::cSufijoFin         := ( ::dbfCabecera )->cSufPed

   ::cNombreDocumento   := "Pedido proveedores"

   ::inicialDoc         := "PE"

   ::aStructureField    := aSqlStruct( aColPedPrv() )

   ::nView              := nView 

   ::Super:New() 

Return( Self )

//---------------------------------------------------------------------------//

METHOD loadTempLabelEdition( tmpLabel ) CLASS TLabelGeneratorPedidoProveedores

   local nRec
   local nOrd

   DEFAULT tmpLabel     := ::tmpLabelEdition

   //Limpiamos la base de datos temporal-----------------------------------------

   if ( tmpLabel )->( Used() )
      ( tmpLabel )->( __dbZap() )
   end if 

   //Llenamos la tabla temporal--------------------------------------------------

   nRec                 := ( ::dbfCabecera )->( Recno() )
   nOrd                 := ( ::dbfCabecera )->( OrdSetFocus( "nNumPed" ) )

   if ( ::dbfCabecera )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( ::dbfCabecera )->cSerPed + Str( ( ::dbfCabecera )->nNumPed ) + ( ::dbfCabecera )->cSufPed >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio  .and.;
            ( ::dbfCabecera )->cSerPed + Str( ( ::dbfCabecera )->nNumPed ) + ( ::dbfCabecera )->cSufPed <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin           .and.;
            ( ::dbfCabecera )->( !eof() )

         if ( ::dbfLineas )->( dbSeek( ( ::dbfCabecera )->cSerPed + Str( ( ::dbfCabecera )->nNumPed ) + ( ::dbfCabecera )->cSufPed ) )

            while ( ::dbfLineas )->cSerPed + Str( ( ::dbfLineas )->nNumPed ) + ( ::dbfLineas )->cSufPed == ( ::dbfCabecera )->cSerPed + Str( ( ::dbfCabecera )->nNumPed ) + ( ::dbfCabecera )->cSufPed  .and.;
                  ( ::dbfLineas )->( !eof() )

               if !empty( ( ::dbfLineas )->cRef )

                  dbPass( ::dbfLineas, tmpLabel, .t. )

                  dblock( tmpLabel )

                  ( tmpLabel )->nNumLin   := nTotNPedPrv( ::dbfLineas )
                  ( tmpLabel )->lLabel    := .t.

                  if ::nCantidadLabels == 1
                     ( tmpLabel )->nLabel := nTotNPedPrv( ::dbfLineas )
                  else
                     ( tmpLabel )->nLabel := ::nUnidadesLabels
                  end if

                  ( tmpLabel )->( dbUnlock() )

               end if

               ( ::dbfLineas )->( dbSkip() )

            end while

         end if

         ( ::dbfCabecera )->( dbSkip() )

      end while

   end if

   ( ::dbfCabecera )->( OrdSetFocus( nOrd ) )
   ( ::dbfCabecera )->( dbGoTo( nRec ) )

   ( tmpLabel )->( dbGoTop() )

   ::refreshBrowseLabel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD dataLabel( oFr ) CLASS TLabelGeneratorPedidoProveedores

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de pedidos", ( ::tmpLabelReport )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   oFr:SetFieldAliases( "Lineas de pedidos", cItemsToReport( aColPedPrv() ) )

   oFr:SetWorkArea(     "Pedidos", ( ::dbfCabecera )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Pedidos", cItemsToReport( aItmPedPrv() ) )

   oFr:SetWorkArea(     "Incidencias de pedidos", ( D():PedidosProveedoresIncidencias( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de pedidos", cItemsToReport( aIncPedPrv() ) )

   oFr:SetWorkArea(     "Documentos de pedidos", ( D():PedidosProveedoresDocumentos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de pedidos", cItemsToReport( aPedPrvDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedor", ( D():Proveedores( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Proveedor", cItemsToReport( aItmPrv() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( D():ArticuloPrecioPropiedades( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", ::nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", ::nView ):oDbf) )

   oFr:SetWorkArea(     "Impuestos especiales",  D():ImpuestosEspeciales( ::nView ):Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( D():ImpuestosEspeciales( ::nView ):oDbf) )
   
   oFr:SetMasterDetail( "Lineas de pedidos", "Pedidos",                    {|| ( ::tmpLabelReport )->cSerPed + Str( ( ::tmpLabelReport )->nNumPed ) + ( ::tmpLabelReport )->cSufPed } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Artículos",                  {|| ( ::tmpLabelReport )->cRef } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Precios por propiedades",    {|| ( ::tmpLabelReport )->cDetalle + ( ::tmpLabelReport )->cCodPr1 + ( ::tmpLabelReport )->cCodPr2 + ( ::tmpLabelReport )->cValPr1 + ( ::tmpLabelReport )->cValPr2 } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Incidencias de pedidos",     {|| ( ::tmpLabelReport )->cSerPed + Str( ( ::tmpLabelReport )->nNumPed ) + ( ::tmpLabelReport )->cSufPed } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Documentos de pedidos",      {|| ( ::tmpLabelReport )->cSerPed + Str( ( ::tmpLabelReport )->nNumPed ) + ( ::tmpLabelReport )->cSufPed } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Impuestos especiales",       {|| ( ::tmpLabelReport )->cCodImp } )

   oFr:SetMasterDetail( "Pedidos", "Proveedor",                            {|| ( ::dbfCabecera )->cCodPrv } )
   oFr:SetMasterDetail( "Pedidos", "Almacenes",                            {|| ( ::dbfCabecera )->cCodAlm } )
   oFr:SetMasterDetail( "Pedidos", "Formas de pago",                       {|| ( ::dbfCabecera )->cCodPgo } )
   oFr:SetMasterDetail( "Pedidos", "Bancos",                               {|| ( ::dbfCabecera )->cCodPrv } )
   oFr:SetMasterDetail( "Pedidos", "Empresa",                              {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(   "Lineas de pedidos", "Pedidos" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Artículos" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Precios por propiedades" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Incidencias de pedidos" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Documentos de pedidos" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Impuestos especiales" )   

   oFr:SetResyncPair(   "Pedidos", "Proveedor" )
   oFr:SetResyncPair(   "Pedidos", "Almacenes" )
   oFr:SetResyncPair(   "Pedidos", "Formas de pago" )
   oFr:SetResyncPair(   "Pedidos", "Bancos" )
   oFr:SetResyncPair(   "Pedidos", "Empresa" )

Return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TLabelGeneratorAlbaranClientes FROM TLabelGenerator

   METHOD New( nView )
   METHOD LoadTempLabelEdition() 
   METHOD dataLabel( oFr)

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TLabelGeneratorAlbaranClientes

   ::cSerieInicio       := ( D():AlbaranesClientes( nView ) )->cSerAlb
   ::cSerieFin          := ( D():AlbaranesClientes( nView ) )->cSerAlb

   ::nDocumentoInicio   := ( D():AlbaranesClientes( nView ) )->nNumAlb
   ::nDocumentoFin      := ( D():AlbaranesClientes( nView ) )->nNumAlb
   ::cSufijoInicio      := ( D():AlbaranesClientes( nView ) )->cSufAlb
   ::cSufijoFin         := ( D():AlbaranesClientes( nView ) )->cSufAlb

   ::cNombreDocumento   := "Albaran clientes"

   ::inicialDoc         := "AB"

   ::DbfCabecera        := ( D():AlbaranesClientes( nView ) )
   ::dbfLineas          := ( D():AlbaranesClientesLineas( nView ) )

   ::idDocument         := D():AlbaranesClientesId( nView ) 

   ::aStructureField    := aSqlStruct( aColAlbCli() )

   ::nView              := nView 

   ::Super:New() 

Return( Self )
 
//---------------------------------------------------------------------------//

METHOD LoadTempLabelEdition( tmpLabel ) CLASS TLabelGeneratorAlbaranClientes

   local nRec
   local nOrd

   DEFAULT tmpLabel     := ::tmpLabelEdition

   //Limpiamos la base de datos temporal-----------------------------------------

   if ( tmpLabel )->( Used() )
      ( tmpLabel )->( __dbZap() )
   end if 

   //Llenamos la tabla temporal--------------------------------------------------

   nRec                 := ( ::dbfCabecera )->( Recno() )
   nOrd                 := ( ::dbfCabecera )->( OrdSetFocus( "nNumAlb" ) )

   if ( ::dbfCabecera )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( ::dbfCabecera )->cSerAlb + Str( ( ::dbfCabecera )->nNumAlb ) + ( ::dbfCabecera )->cSufAlb >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio  .and.;
            ( ::dbfCabecera )->cSerAlb + Str( ( ::dbfCabecera )->nNumAlb ) + ( ::dbfCabecera )->cSufAlb <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin           .and.;
            !( ::dbfCabecera )->( eof() )

         if ( ::dbfLineas )->( dbSeek( ( ::dbfCabecera )->cSerAlb + Str( ( ::dbfCabecera )->nNumAlb ) + ( ::dbfCabecera )->cSufAlb ) )

            while ( ::dbfLineas )->cSerAlb + Str( ( ::dbfLineas )->nNumAlb ) + ( ::dbfLineas )->cSufAlb == ( ::dbfCabecera )->cSerAlb + Str( ( ::dbfCabecera )->nNumAlb ) + ( ::dbfCabecera )->cSufAlb  .and. ( ::dbfLineas )->( !eof() )

               if !empty( ( ::dbfLineas )->cRef )

                  dbPass( ::dbfLineas, tmpLabel, .t. )

                  dblock( tmpLabel )

                  ( tmpLabel )->nNumLin  := nTotNAlbCli( ::dbfLineas )
                  ( tmpLabel )->lLabel   := .t.

                  if ::nCantidadLabels == 1
                     ( tmpLabel )->nLabel   := nTotNAlbCli( ::dbfLineas )
                  else
                     ( tmpLabel )->nLabel   := ::nUnidadesLabels
                  end if

                  ( tmpLabel )->( dbUnlock() )

               end if

               ( ::dbfLineas )->( dbSkip() )

            end while

         end if

         ( ::dbfCabecera )->( dbSkip() )

      end while

   end if

   ( ::dbfCabecera )->( OrdSetFocus( nOrd ) )
   ( ::dbfCabecera )->( dbGoTo( nRec ) )

   ( tmpLabel )->( dbGoTop() )

   ::refreshBrowseLabel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD dataLabel( oFr ) CLASS TLabelGeneratorAlbaranClientes

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de albaranes", ( ::tmpLabelReport )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   oFr:SetFieldAliases( "Lineas de albaranes", cItemsToReport( aColAlbCli() ) )

   oFr:SetWorkArea(     "Albaranes", ( ::dbfCabecera )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Albaranes", cItemsToReport( aItmAlbCli() ) )

   oFr:SetWorkArea(     "Incidencias de albaranes", ( D():AlbaranesClientesIncidencias( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de albaranes", cItemsToReport( aIncAlbCli() ) )

   oFr:SetWorkArea(     "Documentos de albaranes", ( D():AlbaranesClientesDocumentos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de albaranes", cItemsToReport( aAlbCliDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Clientes( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( D():ArticuloPrecioPropiedades( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", ::nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", ::nView ):oDbf) )

   oFr:SetWorkArea(     "Impuestos especiales",  D():ImpuestosEspeciales( ::nView ):Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( D():ImpuestosEspeciales( ::nView ):oDbf) )
   
   oFr:SetMasterDetail( "Lineas de albaranes", "Albaranes",                  {|| ( ::tmpLabelReport )->cSerAlb + Str( ( ::tmpLabelReport )->nNumAlb ) + ( ::tmpLabelReport )->cSufAlb } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Artículos",                  {|| ( ::tmpLabelReport )->cRef } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Precios por propiedades",    {|| ( ::tmpLabelReport )->cDetalle + ( ::tmpLabelReport )->cCodPr1 + ( ::tmpLabelReport )->cCodPr2 + ( ::tmpLabelReport )->cValPr1 + ( ::tmpLabelReport )->cValPr2 } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Incidencias de albaranes",   {|| ( ::tmpLabelReport )->cSerAlb + Str( ( ::tmpLabelReport )->nNumAlb ) + ( ::tmpLabelReport )->cSufAlb } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Documentos de albaranes",    {|| ( ::tmpLabelReport )->cSerAlb + Str( ( ::tmpLabelReport )->nNumAlb ) + ( ::tmpLabelReport )->cSufAlb } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Impuestos especiales",       {|| ( ::tmpLabelReport )->cCodImp } )

   oFr:SetMasterDetail( "Albaranes", "Clientes",                             {|| ( ::dbfCabecera )->cCodCli } )
   oFr:SetMasterDetail( "Albaranes", "Almacenes",                            {|| ( ::dbfCabecera )->cCodAlm } )
   oFr:SetMasterDetail( "Albaranes", "Formas de pago",                       {|| ( ::dbfCabecera )->cCodPago} )
   oFr:SetMasterDetail( "Albaranes", "Bancos",                               {|| ( ::dbfCabecera )->cCodPrv } )
   oFr:SetMasterDetail( "Albaranes", "Empresa",                              {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(   "Lineas de albaranes", "Albaranes" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Artículos" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Precios por propiedades" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Incidencias de albaranes" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Documentos de albaranes" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Impuestos especiales" )   

   oFr:SetResyncPair(   "Albaranes", "Clientes" )
   oFr:SetResyncPair(   "Albaranes", "Almacenes" )
   oFr:SetResyncPair(   "Albaranes", "Formas de pago" )
   oFr:SetResyncPair(   "Albaranes", "Bancos" )
   oFr:SetResyncPair(   "Albaranes", "Empresa" )

Return ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TLabelGeneratorPedidoClientes FROM TLabelGenerator

   METHOD New( nView )
   METHOD LoadTempLabelEdition() 
   METHOD dataLabel( oFr )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TLabelGeneratorPedidoClientes

   ::cSerieInicio       := ( D():PedidosClientes( nView ) )->cSerPed
   ::cSerieFin          := ( D():PedidosClientes( nView ) )->cSerPed

   ::nDocumentoInicio   := ( D():PedidosClientes( nView ) )->nNumPed
   ::nDocumentoFin      := ( D():PedidosClientes( nView ) )->nNumPed

   ::cSufijoInicio      := ( D():PedidosClientes( nView ) )->cSufPed
   ::cSufijoFin         := ( D():PedidosClientes( nView ) )->cSufPed

   ::cNombreDocumento   := "Pedido clientes"

   ::inicialDoc         := "PB"

   ::dbfCabecera        := ( D():PedidosClientes( nView ) )
   ::dbfLineas          := ( D():PedidosClientesLineas( nView ) )

   ::idDocument         := D():PedidosClientesId( nView ) 

   ::aStructureField    := aSqlStruct( aColPedCli() )

   ::nView              := nView 

   ::Super:New() 

Return( Self )
 
//---------------------------------------------------------------------------//

METHOD LoadTempLabelEdition( tmpLabel ) CLASS TLabelGeneratorPedidoClientes

   local nRec
   local nOrd

   DEFAULT tmpLabel     := ::tmpLabelEdition

   //Limpiamos la base de datos temporal-----------------------------------------

   if ( tmpLabel )->( Used() )
      ( tmpLabel )->( __dbZap() )
   end if 

   //Llenamos la tabla temporal--------------------------------------------------

   nRec           := ( ::dbfCabecera )->( Recno() )
   nOrd           := ( ::dbfCabecera )->( OrdSetFocus( "nNumPed" ) )

   if ( ::dbfCabecera )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( ::dbfCabecera )->cSerPed + Str( ( ::dbfCabecera )->nNumPed ) + ( ::dbfCabecera )->cSufPed >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio  .and.;
            ( ::dbfCabecera )->cSerPed + Str( ( ::dbfCabecera )->nNumPed ) + ( ::dbfCabecera )->cSufPed <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin           .and.;
            !( ::dbfCabecera )->( eof() )

         if ( ::dbfLineas )->( dbSeek( ( ::dbfCabecera )->cSerPed + Str( ( ::dbfCabecera )->nNumPed ) + ( ::dbfCabecera )->cSufPed ) )

            while ( ::dbfLineas )->cSerPed + Str( ( ::dbfLineas )->nNumPed ) + ( ::dbfLineas )->cSufPed == ( ::dbfCabecera )->cSerPed + Str( ( ::dbfCabecera )->nNumPed ) + ( ::dbfCabecera )->cSufPed  .and. ( ::dbfLineas )->( !eof() )

               if !empty( ( ::dbfLineas )->cRef )

                  dbPass( ::dbfLineas, tmpLabel, .t. )

                  dblock( tmpLabel )

                  ( tmpLabel )->nNumLin  := nTotNPedCli( ::dbfLineas )
                  ( tmpLabel )->lLabel   := .t.

                  if ::nCantidadLabels == 1
                     ( tmpLabel )->nLabel   := nTotNPedCli( ::dbfLineas )
                  else
                     ( tmpLabel )->nLabel   := ::nUnidadesLabels
                  end if

                  ( tmpLabel )->( dbUnlock() )

               end if

               ( ::dbfLineas )->( dbSkip() )

            end while

         end if

         ( ::dbfCabecera )->( dbSkip() )

      end while

   end if

   ( ::dbfCabecera )->( OrdSetFocus( nOrd ) )
   ( ::dbfCabecera )->( dbGoTo( nRec ) )

   ( tmpLabel )->( dbGoTop() )

   ::refreshBrowseLabel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD dataLabel( oFr ) CLASS TLabelGeneratorPedidoClientes

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de pedidos", ( ::tmpLabelReport )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   oFr:SetFieldAliases( "Lineas de pedidos", cItemsToReport( aColPedCli() ) )

   oFr:SetWorkArea(     "Pedidos", ( ::dbfCabecera )->( Select() ) )
   oFr:SetFieldAliases( "Pedidos", cItemsToReport( aItmPedCli() ) )

   oFr:SetWorkArea(     "Incidencias de pedidos", ( D():PedidosClientesIncidencias( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de pedidos", cItemsToReport( aIncPedCli() ) )

   oFr:SetWorkArea(     "Documentos de pedidos", ( D():PedidosClientesDocumentos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de pedidos", cItemsToReport( aPedCliDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Clientes( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( D():ArticuloPrecioPropiedades( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", ::nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", ::nView ):oDbf) )

   oFr:SetWorkArea(     "Impuestos especiales",  D():ImpuestosEspeciales( ::nView ):Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( D():ImpuestosEspeciales( ::nView ):oDbf) )
   
   oFr:SetMasterDetail( "Lineas de pedidos", "Pedidos",                    {|| ( ::tmpLabelReport )->cSerPed + Str( ( ::tmpLabelReport )->nNumPed ) + ( ::tmpLabelReport )->cSufPed } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Artículos",                  {|| ( ::tmpLabelReport )->cRef } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Precios por propiedades",    {|| ( ::tmpLabelReport )->cDetalle + ( ::tmpLabelReport )->cCodPr1 + ( ::tmpLabelReport )->cCodPr2 + ( ::tmpLabelReport )->cValPr1 + ( ::tmpLabelReport )->cValPr2 } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Incidencias de pedidos",     {|| ( ::tmpLabelReport )->cSerPed + Str( ( ::tmpLabelReport )->nNumPed ) + ( ::tmpLabelReport )->cSufPed } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Documentos de pedidos",      {|| ( ::tmpLabelReport )->cSerPed + Str( ( ::tmpLabelReport )->nNumPed ) + ( ::tmpLabelReport )->cSufPed } )
   oFr:SetMasterDetail( "Lineas de pedidos", "Impuestos especiales",       {|| ( ::tmpLabelReport )->cCodImp } )

   oFr:SetMasterDetail( "Pedidos", "Clientes",                             {|| ( ::dbfCabecera )->cCodCli } )
   oFr:SetMasterDetail( "Pedidos", "Almacenes",                            {|| ( ::dbfCabecera )->cCodAlm } )
   oFr:SetMasterDetail( "Pedidos", "Formas de pago",                       {|| ( ::dbfCabecera )->cCodPgo} )
   oFr:SetMasterDetail( "Pedidos", "Empresa",                              {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(   "Lineas de pedidos", "Pedidos" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Artículos" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Precios por propiedades" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Incidencias de pedidos" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Documentos de pedidos" )
   oFr:SetResyncPair(   "Lineas de pedidos", "Impuestos especiales" )   

   oFr:SetResyncPair(   "Pedidos", "Clientes" )
   oFr:SetResyncPair(   "Pedidos", "Almacenes" )
   oFr:SetResyncPair(   "Pedidos", "Formas de pago" )
   oFr:SetResyncPair(   "Pedidos", "Empresa" )

Return ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TLabelGeneratorPresupuestoClientes FROM TLabelGenerator

   METHOD New( nView )
   METHOD LoadTempLabelEdition() 
   METHOD dataLabel( oFr )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TLabelGeneratorPresupuestoClientes

   ::cSerieInicio       := ( D():PresupuestosClientes( nView ) )->cSerPre
   ::cSerieFin          := ( D():PresupuestosClientes( nView ) )->cSerPre

   ::nDocumentoInicio   := ( D():PresupuestosClientes( nView ) )->nNumPre
   ::nDocumentoFin      := ( D():PresupuestosClientes( nView ) )->nNumPre
   ::cSufijoInicio      := ( D():PresupuestosClientes( nView ) )->cSufPre
   ::cSufijoFin         := ( D():PresupuestosClientes( nView ) )->cSufPre

   ::cNombreDocumento   := "Presupuesto clientes"
   ::inicialDoc         := "PR"

   ::dbfCabecera        := ( D():PresupuestosClientes( nView ) )
   ::dbfLineas          := ( D():PresupuestosClientesLineas( nView ) )

   ::idDocument         := D():PresupuestosClientesId( nView ) 

   ::aStructureField    := aSqlStruct( aColPreCli() )

   ::nView              := nView 

   ::Super:New() 

Return( Self )
 
//---------------------------------------------------------------------------//

METHOD LoadTempLabelEdition( tmpLabelEdition ) CLASS TLabelGeneratorPresupuestoClientes

   local nRec
   local nOrd

   DEFAULT tmpLabelEdition    := ::tmpLabelEdition

   //Limpiamos la base de datos temporal-----------------------------------------

   if ( tmpLabelEdition )->( Used() )
      ( tmpLabelEdition )->( __dbZap() )
   end if 

   //Llenamos la tabla temporal--------------------------------------------------

   nRec           := ( ::dbfCabecera )->( Recno() )
   nOrd           := ( ::dbfCabecera )->( OrdSetFocus( "nNumPre" ) )

   if ( ::dbfCabecera )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( ::dbfCabecera )->cSerPre + Str( ( ::dbfCabecera )->nNumPre ) + ( ::dbfCabecera )->cSufPre >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio  .and.;
            ( ::dbfCabecera )->cSerPre + Str( ( ::dbfCabecera )->nNumPre ) + ( ::dbfCabecera )->cSufPre <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin           .and.;
            !( ::dbfCabecera )->( eof() )

         if ( ::dbfLineas )->( dbSeek( ( ::dbfCabecera )->cSerPre + Str( ( ::dbfCabecera )->nNumPre ) + ( ::dbfCabecera )->cSufPre ) )

            while ( ::dbfLineas )->cSerPre + Str( ( ::dbfLineas )->nNumPre ) + ( ::dbfLineas )->cSufPre == ( ::dbfCabecera )->cSerPre + Str( ( ::dbfCabecera )->nNumPre ) + ( ::dbfCabecera )->cSufPre  .and. ( ::dbfLineas )->( !eof() )

               if !empty( ( ::dbfLineas )->cRef )

                  dbPass( ::dbfLineas, tmpLabelEdition, .t. )

                  dblock( tmpLabelEdition )

                  ( tmpLabelEdition )->nNumLin  := nTotNPreCli( ::dbfLineas )
                  ( tmpLabelEdition )->lLabel   := .t.

                  if ::nCantidadLabels == 1
                     ( tmpLabelEdition )->nLabel   := nTotNPreCli( ::dbfLineas )
                  else
                     ( tmpLabelEdition )->nLabel   := ::nUnidadesLabels
                  end if

                  ( tmpLabelEdition )->( dbUnlock() )

               end if

               ( ::dbfLineas )->( dbSkip() )

            end while

         end if

         ( ::dbfCabecera )->( dbSkip() )

      end while

   end if

   ( ::dbfCabecera )->( OrdSetFocus( nOrd ) )
   ( ::dbfCabecera )->( dbGoTo( nRec ) )

   ( tmpLabelEdition )->( dbGoTop() )

   if !empty( ::oBrwLabel )
      ::refreshBrowseLabel()
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD dataLabel( oFr ) CLASS TLabelGeneratorPresupuestoClientes

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de presupuestos", ( ::tmpLabelReport )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   oFr:SetFieldAliases( "Lineas de presupuestos", cItemsToReport( aColPreCli() ) )

   oFr:SetWorkArea(     "Presupuestos", ( ::dbfCabecera )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Presupuestos", cItemsToReport( aItmPreCli() ) )

   oFr:SetWorkArea(     "Incidencias de presupuestos", ( D():PresupuestosClientesIncidencias( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de presupuestos", cItemsToReport( aIncPreCli() ) )

   oFr:SetWorkArea(     "Documentos de presupuestos", ( D():PresupuestosClientesDocumentos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de presupuestos", cItemsToReport( aPreCliDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Clientes( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( D():ArticuloPrecioPropiedades( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", ::nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", ::nView ):oDbf) )

   oFr:SetWorkArea(     "Impuestos especiales",  D():ImpuestosEspeciales( ::nView ):Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( D():ImpuestosEspeciales( ::nView ):oDbf) )
   
   oFr:SetMasterDetail( "Lineas de presupuestos", "Presupuestos",                  {|| ( ::tmpLabelReport )->cSerPre + Str( ( ::tmpLabelReport )->nNumPre ) + ( ::tmpLabelReport )->cSufPre } )
   oFr:SetMasterDetail( "Lineas de presupuestos", "Artículos",                     {|| ( ::tmpLabelReport )->cRef } )
   oFr:SetMasterDetail( "Lineas de presupuestos", "Precios por propiedades",       {|| ( ::tmpLabelReport )->cDetalle + ( ::tmpLabelReport )->cCodPr1 + ( ::tmpLabelReport )->cCodPr2 + ( ::tmpLabelReport )->cValPr1 + ( ::tmpLabelReport )->cValPr2 } )
   oFr:SetMasterDetail( "Lineas de presupuestos", "Incidencias de presupuestos",   {|| ( ::tmpLabelReport )->cSerPre + Str( ( ::tmpLabelReport )->nNumPre ) + ( ::tmpLabelReport )->cSufPre } )
   oFr:SetMasterDetail( "Lineas de presupuestos", "Documentos de presupuestos",    {|| ( ::tmpLabelReport )->cSerPre + Str( ( ::tmpLabelReport )->nNumPre ) + ( ::tmpLabelReport )->cSufPre } )
   oFr:SetMasterDetail( "Lineas de presupuestos", "Impuestos especiales",          {|| ( ::tmpLabelReport )->cCodImp } )

   oFr:SetMasterDetail(    "Presupuestos", "Clientes",                             {|| ( ::dbfCabecera )->cCodCli } )
   oFr:SetMasterDetail(    "Presupuestos", "Almacenes",                            {|| ( ::dbfCabecera )->cCodAlm } )
   oFr:SetMasterDetail(    "Presupuestos", "Formas de pago",                       {|| ( ::dbfCabecera )->cCodPgo} )
   oFr:SetMasterDetail(    "Presupuestos", "Empresa",                              {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(      "Lineas de presupuestos", "Presupuestos" )
   oFr:SetResyncPair(      "Lineas de presupuestos", "Artículos" )
   oFr:SetResyncPair(      "Lineas de presupuestos", "Precios por propiedades" )
   oFr:SetResyncPair(      "Lineas de presupuestos", "Incidencias de presupuestos" )
   oFr:SetResyncPair(      "Lineas de presupuestos", "Documentos de presupuestos" )
   oFr:SetResyncPair(      "Lineas de presupuestos", "Impuestos especiales" )   

   oFr:SetResyncPair(      "Presupuestos", "Clientes" )
   oFr:SetResyncPair(      "Presupuestos", "Almacenes" )
   oFr:SetResyncPair(      "Presupuestos", "Formas de pago" )
   oFr:SetResyncPair(      "Presupuestos", "Empresa" )

Return ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TLabelGeneratorFacturasClientes FROM TLabelGenerator

   METHOD New( nView )
   METHOD LoadTempLabelEdition() 
   METHOD dataLabel( oFr )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TLabelGeneratorFacturasClientes

   ::cSerieInicio       := ( D():FacturasClientes( nView ) )->cSerie
   ::cSerieFin          := ( D():FacturasClientes( nView ) )->cSerie

   ::nDocumentoInicio   := ( D():FacturasClientes( nView ) )->nNumFac
   ::nDocumentoFin      := ( D():FacturasClientes( nView ) )->nNumFac
   ::cSufijoInicio      := ( D():FacturasClientes( nView ) )->cSufFac
   ::cSufijoFin         := ( D():FacturasClientes( nView ) )->cSufFac

   ::cNombreDocumento   := "Facturas clientes"
   ::inicialDoc         := "FB"

   ::dbfCabecera        := ( D():FacturasClientes( nView ) )
   ::dbfLineas          := ( D():FacturasClientesLineas( nView ) )

   ::idDocument         := D():FacturasClientesId( nView ) 

   ::aStructureField    := aSqlStruct( aColFacCli() )

   ::nView              := nView 

   ::Super:New() 

Return( Self )
 
//---------------------------------------------------------------------------//

METHOD LoadTempLabelEdition( tmpLabelEdition ) CLASS TLabelGeneratorFacturasClientes

   local nRec
   local nOrd

   DEFAULT tmpLabelEdition    := ::tmpLabelEdition

   //Limpiamos la base de datos temporal-----------------------------------------

   if ( tmpLabelEdition )->( Used() )
      ( tmpLabelEdition )->( __dbZap() )
   end if 

   //Llenamos la tabla temporal--------------------------------------------------

   nRec           := ( ::dbfCabecera )->( Recno() )
   nOrd           := ( ::dbfCabecera )->( OrdSetFocus( "nNumFac" ) )

   if ( ::dbfCabecera )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( ::dbfCabecera )->cSerie + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio  .and.;
            ( ::dbfCabecera )->cSerie + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin           .and.;
            !( ::dbfCabecera )->( eof() )

         if ( ::dbfLineas )->( dbSeek( ( ::dbfCabecera )->cSerie + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac ) )

            while ( ::dbfLineas )->cSerie + Str( ( ::dbfLineas )->nNumFac ) + ( ::dbfLineas )->cSufFac == ( ::dbfCabecera )->cSerie + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac  .and. ( ::dbfLineas )->( !eof() )

               if !empty( ( ::dbfLineas )->cRef )

                  dbPass( ::dbfLineas, tmpLabelEdition, .t. )

                  dblock( tmpLabelEdition )

                  ( tmpLabelEdition )->nNumLin     := nTotNFacCli( ::dbfLineas )
                  ( tmpLabelEdition )->lLabel      := .t.

                  if ::nCantidadLabels == 1
                     ( tmpLabelEdition )->nLabel   := nTotNFacCli( ::dbfLineas )
                  else
                     ( tmpLabelEdition )->nLabel   := ::nUnidadesLabels
                  end if

                  ( tmpLabelEdition )->( dbUnlock() )

               end if

               ( ::dbfLineas )->( dbSkip() )

            end while

         end if

         ( ::dbfCabecera )->( dbSkip() )

      end while

   end if

   ( ::dbfCabecera )->( OrdSetFocus( nOrd ) )
   ( ::dbfCabecera )->( dbGoTo( nRec ) )

   ( tmpLabelEdition )->( dbGoTop() )

   ::refreshBrowseLabel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD dataLabel( oFr ) CLASS TLabelGeneratorFacturasClientes

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de facturas", ( ::tmpLabelReport )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   oFr:SetFieldAliases( "Lineas de facturas", cItemsToReport( aColFacCli() ) )

   oFr:SetWorkArea(     "Facturas", ( ::dbfCabecera )->( Select() ) )
   oFr:SetFieldAliases( "Facturas", cItemsToReport( aItmFacCli() ) )

   oFr:SetWorkArea(     "Incidencias de facturas", ( D():FacturasClientesIncidencias( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de facturas", cItemsToReport( aIncFacCli() ) )

   oFr:SetWorkArea(     "Documentos de facturas", ( D():FacturasClientesDocumentos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de facturas", cItemsToReport( aFacCliDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Clientes( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( D():ArticuloPrecioPropiedades( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", ::nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", ::nView ):oDbf) )

   oFr:SetWorkArea(     "Impuestos especiales",  D():ImpuestosEspeciales( ::nView ):Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( D():ImpuestosEspeciales( ::nView ):oDbf) )
   
   oFr:SetMasterDetail( "Lineas de facturas", "Facturas",                  {|| ( ::tmpLabelReport )->cSerie + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas", "Artículos",                 {|| ( ::tmpLabelReport )->cRef } )
   oFr:SetMasterDetail( "Lineas de facturas", "Precios por propiedades",   {|| ( ::tmpLabelReport )->cDetalle + ( ::tmpLabelReport )->cCodPr1 + ( ::tmpLabelReport )->cCodPr2 + ( ::tmpLabelReport )->cValPr1 + ( ::tmpLabelReport )->cValPr2 } )
   oFr:SetMasterDetail( "Lineas de facturas", "Incidencias de facturas",   {|| ( ::tmpLabelReport )->cSerie + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas", "Documentos de facturas",    {|| ( ::tmpLabelReport )->cSerie + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas", "Impuestos especiales",      {|| ( ::tmpLabelReport )->cCodImp } )

   oFr:SetMasterDetail( "Facturas", "Clientes",                            {|| ( ::dbfCabecera )->cCodCli } )
   oFr:SetMasterDetail( "Facturas", "Almacenes",                           {|| ( ::dbfCabecera )->cCodAlm } )
   oFr:SetMasterDetail( "Facturas", "Formas de pago",                      {|| ( ::dbfCabecera )->cCodPago} )
   oFr:SetMasterDetail( "Facturas", "Empresa",                             {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(   "Lineas de facturas", "Facturas" )
   oFr:SetResyncPair(   "Lineas de facturas", "Artículos" )
   oFr:SetResyncPair(   "Lineas de facturas", "Precios por propiedades" )
   oFr:SetResyncPair(   "Lineas de facturas", "Incidencias de facturas" )
   oFr:SetResyncPair(   "Lineas de facturas", "Documentos de facturas" )
   oFr:SetResyncPair(   "Lineas de facturas", "Impuestos especiales" )   

   oFr:SetResyncPair(   "Facturas", "Clientes" )
   oFr:SetResyncPair(   "Facturas", "Almacenes" )
   oFr:SetResyncPair(   "Facturas", "Formas de pago" )
   oFr:SetResyncPair(   "Facturas", "Empresa" )

Return ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TLabelGeneratorFacturasRectificativaClientes FROM TLabelGenerator

   METHOD New( nView )
   METHOD LoadTempLabelEdition() 
   METHOD dataLabel( oFr )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TLabelGeneratorFacturasRectificativaClientes

   ::cSerieInicio       := ( D():FacturasRectificativas( nView ) )->cSerie
   ::cSerieFin          := ( D():FacturasRectificativas( nView ) )->cSerie

   ::nDocumentoInicio   := ( D():FacturasRectificativas( nView ) )->nNumFac
   ::nDocumentoFin      := ( D():FacturasRectificativas( nView ) )->nNumFac
   ::cSufijoInicio      := ( D():FacturasRectificativas( nView ) )->cSufFac
   ::cSufijoFin         := ( D():FacturasRectificativas( nView ) )->cSufFac

   ::cNombreDocumento   := "Facturas rectificativa clientes"

   ::inicialDoc         := "FI"

   ::dbfCabecera        := ( D():FacturasRectificativas( nView ) )
   ::dbfLineas          := ( D():FacturasRectificativasLineas( nView ) )

   ::idDocument         := D():FacturasRectificativasId( nView ) 

   ::aStructureField    := aSqlStruct( aColFacCli() )

   ::nView              := nView 

   ::Super:New() 

Return( Self )
 
//---------------------------------------------------------------------------//

METHOD LoadTempLabelEdition( tmpLabelEdition ) CLASS TLabelGeneratorFacturasRectificativaClientes

   local nRec
   local nOrd

   DEFAULT tmpLabelEdition    := ::tmpLabelEdition

   //Limpiamos la base de datos temporal-----------------------------------------

   if ( tmpLabelEdition )->( Used() )
      ( tmpLabelEdition )->( __dbZap() )
   end if 

   //Llenamos la tabla temporal--------------------------------------------------

   nRec           := ( ::dbfCabecera )->( Recno() )
   nOrd           := ( ::dbfCabecera )->( OrdSetFocus( "nNumFac" ) )

   if ( ::dbfCabecera )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( ::dbfCabecera )->cSerie + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio  .and.;
            ( ::dbfCabecera )->cSerie + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin           .and.;
            !( ::dbfCabecera )->( eof() )

         if ( ::dbfLineas )->( dbSeek( ( ::dbfCabecera )->cSerie + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac ) )

            while ( ::dbfLineas )->cSerie + Str( ( ::dbfLineas )->nNumFac ) + ( ::dbfLineas )->cSufFac == ( ::dbfCabecera )->cSerie + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac  .and. ( ::dbfLineas )->( !eof() )

               if !empty( ( ::dbfLineas )->cRef )

                  dbPass( ::dbfLineas, tmpLabelEdition, .t. )

                  dblock( tmpLabelEdition )

                  ( tmpLabelEdition )->nNumLin  := nTotNFacRec( ::dbfLineas )
                  ( tmpLabelEdition )->lLabel   := .t.

                  if ::nCantidadLabels == 1
                     ( tmpLabelEdition )->nLabel   := nTotNFacRec( ::dbfLineas )
                  else
                     ( tmpLabelEdition )->nLabel   := ::nUnidadesLabels
                  end if

                  ( tmpLabelEdition )->( dbUnlock() )

               end if

               ( ::dbfLineas )->( dbSkip() )

            end while

         end if

         ( ::dbfCabecera )->( dbSkip() )

      end while

   end if

   ( ::dbfCabecera )->( OrdSetFocus( nOrd ) )
   ( ::dbfCabecera )->( dbGoTo( nRec ) )

   ( tmpLabelEdition )->( dbGoTop() )

   ::refreshBrowseLabel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD dataLabel( oFr ) CLASS TLabelGeneratorFacturasRectificativaClientes

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de facturas", ( ::tmpLabelReport )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   oFr:SetFieldAliases( "Lineas de facturas", cItemsToReport( aColFacRec() ) )

   oFr:SetWorkArea(     "Facturas", ( ::dbfCabecera )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Facturas", cItemsToReport( aItmFacRec() ) )

   oFr:SetWorkArea(     "Incidencias de facturas", ( D():FacturasRectificativasIncidencias( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de facturas", cItemsToReport( aIncFacRec() ) )

   oFr:SetWorkArea(     "Documentos de facturas", ( D():FacturasRectificativasDocumentos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de facturas", cItemsToReport( aFacRecDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Clientes( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( D():ArticuloPrecioPropiedades( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", ::nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", ::nView ):oDbf) )

   oFr:SetWorkArea(     "Impuestos especiales",  D():ImpuestosEspeciales( ::nView ):Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( D():ImpuestosEspeciales( ::nView ):oDbf) )
   
   oFr:SetMasterDetail( "Lineas de facturas", "Facturas",                    {|| ( ::tmpLabelReport )->cSerie + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas", "Artículos",                   {|| ( ::tmpLabelReport )->cRef } )
   oFr:SetMasterDetail( "Lineas de facturas", "Precios por propiedades",     {|| ( ::tmpLabelReport )->cDetalle + ( ::tmpLabelReport )->cCodPr1 + ( ::tmpLabelReport )->cCodPr2 + ( ::tmpLabelReport )->cValPr1 + ( ::tmpLabelReport )->cValPr2 } )
   oFr:SetMasterDetail( "Lineas de facturas", "Incidencias de facturas",     {|| ( ::tmpLabelReport )->cSerie + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas", "Documentos de facturas",      {|| ( ::tmpLabelReport )->cSerie + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas", "Impuestos especiales",        {|| ( ::tmpLabelReport )->cCodImp } )

   oFr:SetMasterDetail(    "Facturas", "Clientes",                             {|| ( ::dbfCabecera )->cCodCli } )
   oFr:SetMasterDetail(    "Facturas", "Almacenes",                            {|| ( ::dbfCabecera )->cCodAlm } )
   oFr:SetMasterDetail(    "Facturas", "Formas de pago",                       {|| ( ::dbfCabecera )->cCodPago} )
   oFr:SetMasterDetail(    "Facturas", "Empresa",                              {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(      "Lineas de facturas", "Facturas" )
   oFr:SetResyncPair(      "Lineas de facturas", "Artículos" )
   oFr:SetResyncPair(      "Lineas de facturas", "Precios por propiedades" )
   oFr:SetResyncPair(      "Lineas de facturas", "Incidencias de facturas" )
   oFr:SetResyncPair(      "Lineas de facturas", "Documentos de facturas" )
   oFr:SetResyncPair(      "Lineas de facturas", "Impuestos especiales" )   

   oFr:SetResyncPair(      "Facturas", "Clientes" )
   oFr:SetResyncPair(      "Facturas", "Almacenes" )
   oFr:SetResyncPair(      "Facturas", "Formas de pago" )
   oFr:SetResyncPair(      "Facturas", "Empresa" )

Return ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TLabelGeneratorSATClientes FROM TLabelGenerator

   METHOD New( nView )
   METHOD LoadTempLabelEdition() 
   METHOD dataLabel( oFr )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TLabelGeneratorSATClientes

   ::cSerieInicio       := ( D():SatClientes( nView ) )->cSerSat
   ::cSerieFin          := ( D():SatClientes( nView ) )->cSerSat

   ::nDocumentoInicio   := ( D():SatClientes( nView ) )->nNumSat
   ::nDocumentoFin      := ( D():SatClientes( nView ) )->nNumSat
   ::cSufijoInicio      := ( D():SatClientes( nView ) )->cSufSat
   ::cSufijoFin         := ( D():SatClientes( nView ) )->cSufSat

   ::cNombreDocumento   := "SAT clientes"
   ::inicialDoc         := "SA"

   ::dbfCabecera        := ( D():SatClientes( nView ) )
   ::dbfLineas          := ( D():SatClientesLineas( nView ) )

   ::idDocument         := D():SatClientesId( nView ) 

   ::aStructureField    := aSqlStruct( aColSatCli() )

   ::nView              := nView 

   ::Super:New() 

Return( Self )
 
//---------------------------------------------------------------------------//

METHOD LoadTempLabelEdition( tmpLabelEdition ) CLASS TLabelGeneratorSATClientes

   local nRec
   local nOrd

   DEFAULT tmpLabelEdition    := ::tmpLabelEdition

   //Limpiamos la base de datos temporal-----------------------------------------

   if ( tmpLabelEdition )->( Used() )
      ( tmpLabelEdition )->( __dbZap() )
   end if 

   //Llenamos la tabla temporal--------------------------------------------------

   nRec           := ( ::dbfCabecera )->( Recno() )
   nOrd           := ( ::dbfCabecera )->( OrdSetFocus( "nNumSat" ) )

   if ( ::dbfCabecera )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( ::dbfCabecera )->cSerSat + Str( ( ::dbfCabecera )->nNumSat ) + ( ::dbfCabecera )->cSufSat >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio  .and.;
            ( ::dbfCabecera )->cSerSat + Str( ( ::dbfCabecera )->nNumsat ) + ( ::dbfCabecera )->cSufSat <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin           .and.;
            !( ::dbfCabecera )->( eof() )

         if ( ::dbfLineas )->( dbSeek( ( ::dbfCabecera )->cSerSat + Str( ( ::dbfCabecera )->nNumSat ) + ( ::dbfCabecera )->cSufSat ) )

            while ( ::dbfLineas )->cSerSat + Str( ( ::dbfLineas )->nNumSat ) + ( ::dbfLineas )->cSufSat == ( ::dbfCabecera )->cSerSat + Str( ( ::dbfCabecera )->nNumSat ) + ( ::dbfCabecera )->cSufSat  .and. ( ::dbfLineas )->( !eof() )

               if !empty( ( ::dbfLineas )->cRef )

                  dbPass( ::dbfLineas, tmpLabelEdition, .t. )

                  dblock( tmpLabelEdition )

                  ( tmpLabelEdition )->nNumLin  := nTotNSatCli( ::dbfLineas )
                  ( tmpLabelEdition )->lLabel   := .t.

                  if ::nCantidadLabels == 1
                     ( tmpLabelEdition )->nLabel   := nTotNSatCli( ::dbfLineas )
                  else
                     ( tmpLabelEdition )->nLabel   := ::nUnidadesLabels
                  end if

                  ( tmpLabelEdition )->( dbUnlock() )

               end if

               ( ::dbfLineas )->( dbSkip() )

            end while

         end if

         ( ::dbfCabecera )->( dbSkip() )

      end while

   end if

   ( ::dbfCabecera )->( OrdSetFocus( nOrd ) )
   ( ::dbfCabecera )->( dbGoTo( nRec ) )

   ( tmpLabelEdition )->( dbGoTop() )

   ::refreshBrowseLabel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD dataLabel( oFr ) CLASS TLabelGeneratorSATClientes

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de SAT", ( ::tmpLabelReport )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   oFr:SetFieldAliases( "Lineas de SAT", cItemsToReport( aColSatCli() ) )

   oFr:SetWorkArea(     "SAT", ( ::dbfCabecera )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "SAT", cItemsToReport( aItmSatCli() ) )

   oFr:SetWorkArea(     "Incidencias de SAT", ( D():SatClientesIncidencias( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de SAT", cItemsToReport( aIncSatCli() ) )

   oFr:SetWorkArea(     "Documentos de SAT", ( D():SatClientesDocumentos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de SAT", cItemsToReport( aSatCliDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Clientes", ( D():Clientes( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Clientes", cItemsToReport( aItmCli() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( D():ArticuloPrecioPropiedades( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", ::nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", ::nView ):oDbf) )

   oFr:SetWorkArea(     "Impuestos especiales",  D():ImpuestosEspeciales( ::nView ):Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( D():ImpuestosEspeciales( ::nView ):oDbf) )
   
   oFr:SetMasterDetail( "Lineas de SAT", "SAT",                      {|| ( ::tmpLabelReport )->cSerSat + Str( ( ::tmpLabelReport )->nNumSat ) + ( ::tmpLabelReport )->cSufSat } )
   oFr:SetMasterDetail( "Lineas de SAT", "Artículos",                {|| ( ::tmpLabelReport )->cRef } )
   oFr:SetMasterDetail( "Lineas de SAT", "Precios por propiedades",  {|| ( ::tmpLabelReport )->cDetalle + ( ::tmpLabelReport )->cCodPr1 + ( ::tmpLabelReport )->cCodPr2 + ( ::tmpLabelReport )->cValPr1 + ( ::tmpLabelReport )->cValPr2 } )
   oFr:SetMasterDetail( "Lineas de SAT", "Incidencias de SAT",       {|| ( ::tmpLabelReport )->cSerSat + Str( ( ::tmpLabelReport )->nNumSat ) + ( ::tmpLabelReport )->cSufSat } )
   oFr:SetMasterDetail( "Lineas de SAT", "Documentos de SAT",        {|| ( ::tmpLabelReport )->cSerSat + Str( ( ::tmpLabelReport )->nNumSat ) + ( ::tmpLabelReport )->cSufSat } )
   oFr:SetMasterDetail( "Lineas de SAT", "Impuestos especiales",     {|| ( ::tmpLabelReport )->cCodImp } )

   oFr:SetMasterDetail(    "SAT", "Clientes",             {|| ( ::dbfCabecera )->cCodCli } )
   oFr:SetMasterDetail(    "SAT", "Almacenes",            {|| ( ::dbfCabecera )->cCodAlm } )
   oFr:SetMasterDetail(    "SAT", "Formas de pago",       {|| ( ::dbfCabecera )->cCodPgo} )
   oFr:SetMasterDetail(    "SAT", "Empresa",              {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(      "Lineas de SAT", "SAT" )
   oFr:SetResyncPair(      "Lineas de SAT", "Artículos" )
   oFr:SetResyncPair(      "Lineas de SAT", "Precios por propiedades" )
   oFr:SetResyncPair(      "Lineas de SAT", "Incidencias de SAT" )
   oFr:SetResyncPair(      "Lineas de SAT", "Documentos de SAT" )
   oFr:SetResyncPair(      "Lineas de SAT", "Impuestos especiales" )   

   oFr:SetResyncPair(      "Facturas", "Clientes" )
   oFr:SetResyncPair(      "Facturas", "Almacenes" )
   oFr:SetResyncPair(      "Facturas", "Formas de pago" )
   oFr:SetResyncPair(      "Facturas", "Empresa" )

Return ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TLabelGeneratorAlbaranProveedores FROM TLabelGenerator

   data newImp

   METHOD New( nView, oNewImp )

   METHOD loadTempLabelEdition() 
   
   METHOD dataLabel( oFr )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView, oNewImp ) CLASS TLabelGeneratorAlbaranProveedores

   ::cSerieInicio       := ( D():AlbaranesProveedores( nView ) )->cSerAlb
   ::cSerieFin          := ( D():AlbaranesProveedores( nView ) )->cSerAlb

   ::nDocumentoInicio   := ( D():AlbaranesProveedores( nView ) )->nNumAlb
   ::nDocumentoFin      := ( D():AlbaranesProveedores( nView ) )->nNumAlb

   ::cSufijoInicio      := ( D():AlbaranesProveedores( nView ) )->cSufAlb
   ::cSufijoFin         := ( D():AlbaranesProveedores( nView ) )->cSufAlb

   ::cNombreDocumento   := "Albaran proveedores"

   ::inicialDoc         := "AL"

   ::dbfCabecera        := ( D():AlbaranesProveedores( nView ) )
   ::dbfLineas          := ( D():AlbaranesProveedoresLineas( nView ) )

   ::idDocument         := D():AlbaranesProveedoresId( nView ) 

   ::aStructureField    := aSqlStruct( aColAlbPrv() )

   ::nView              := nView 

   ::newImp             := oNewImp

   ::Super:New() 

Return( Self )

//---------------------------------------------------------------------------//

METHOD loadTempLabelEdition( tmpLabel ) CLASS TLabelGeneratorAlbaranProveedores

   local nRec
   local nOrd

   DEFAULT tmpLabel     := ::tmpLabelEdition

   //Limpiamos la base de datos temporal-----------------------------------------

   if ( tmpLabel )->( Used() )
      ( tmpLabel )->( __dbZap() )
   end if 

   //Llenamos la tabla temporal--------------------------------------------------

   nRec                 := ( ::dbfCabecera )->( Recno() )
   nOrd                 := ( ::dbfCabecera )->( OrdSetFocus( "nNumAlb" ) )

   if ( ::dbfCabecera )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( ::dbfCabecera )->cSerAlb + Str( ( ::dbfCabecera )->nNumAlb ) + ( ::dbfCabecera )->cSufAlb >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio  .and.;
            ( ::dbfCabecera )->cSerAlb + Str( ( ::dbfCabecera )->nNumAlb ) + ( ::dbfCabecera )->cSufAlb <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin           .and.;
            ( ::dbfCabecera )->( !eof() )

         if ( ::dbfLineas )->( dbSeek( ( ::dbfCabecera )->cSerAlb + Str( ( ::dbfCabecera )->nNumAlb ) + ( ::dbfCabecera )->cSufAlb ) )

            while ( ::dbfLineas )->cSerAlb + Str( ( ::dbfLineas )->nNumAlb ) + ( ::dbfLineas )->cSufAlb == ( ::dbfCabecera )->cSerAlb + Str( ( ::dbfCabecera )->nNumAlb ) + ( ::dbfCabecera )->cSufAlb  .and.;
                  ( ::dbfLineas )->( !eof() )

               if !empty( ( ::dbfLineas )->cRef )

                  dbPass( ::dbfLineas, tmpLabel, .t. )

                  dblock( tmpLabel )

                  ( tmpLabel )->nNumLin   := nTotNAlbPrv( ::dbfLineas )
                  ( tmpLabel )->lLabel    := .t.

                  if ::nCantidadLabels == 1
                     ( tmpLabel )->nLabel := nTotNAlbPrv( ::dbfLineas )
                  else
                     ( tmpLabel )->nLabel := ::nUnidadesLabels
                  end if

                  ( tmpLabel )->( dbUnlock() )

               end if

               ( ::dbfLineas )->( dbSkip() )

            end while

         end if

         ( ::dbfCabecera )->( dbSkip() )

      end while

   end if

   ( ::dbfCabecera )->( OrdSetFocus( nOrd ) )
   ( ::dbfCabecera )->( dbGoTo( nRec ) )

   ( tmpLabel )->( dbGoTop() )

   ::refreshBrowseLabel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD dataLabel( oFr ) CLASS TLabelGeneratorAlbaranProveedores

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de albaranes", ( ::tmpLabelReport )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   oFr:SetFieldAliases( "Lineas de albaranes", cItemsToReport( aColAlbPrv() ) )

   oFr:SetWorkArea(     "Albaranes", ( ::dbfCabecera )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Albaranes", cItemsToReport( aItmAlbPrv() ) )

   oFr:SetWorkArea(     "Incidencias de albaranes", ( D():AlbaranesProveedoresIncidencias( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de albaranes", cItemsToReport( aIncAlbPrv() ) )

   oFr:SetWorkArea(     "Documentos de albaranes", ( D():AlbaranesProveedoresDocumentos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de albaranes", cItemsToReport( aAlbPrvDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedor", ( D():Proveedores( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Proveedor", cItemsToReport( aItmPrv() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( D():ArticuloPrecioPropiedades( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", ::nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", ::nView ):oDbf) )

   oFr:SetWorkArea(     "Impuestos especiales",  ::newImp:Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( ::newImp:oDbf ) )
   
   oFr:SetMasterDetail( "Lineas de albaranes", "Albaranes",                  {|| ( ::tmpLabelReport )->cSerAlb + Str( ( ::tmpLabelReport )->nNumAlb ) + ( ::tmpLabelReport )->cSufAlb } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Artículos",                  {|| ( ::tmpLabelReport )->cRef } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Precios por propiedades",    {|| ( ::tmpLabelReport )->cDetalle + ( ::tmpLabelReport )->cCodPr1 + ( ::tmpLabelReport )->cCodPr2 + ( ::tmpLabelReport )->cValPr1 + ( ::tmpLabelReport )->cValPr2 } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Incidencias de albaranes",   {|| ( ::tmpLabelReport )->cSerAlb + Str( ( ::tmpLabelReport )->nNumAlb ) + ( ::tmpLabelReport )->cSufAlb } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Documentos de albaranes",    {|| ( ::tmpLabelReport )->cSerAlb + Str( ( ::tmpLabelReport )->nNumAlb ) + ( ::tmpLabelReport )->cSufAlb } )
   oFr:SetMasterDetail( "Lineas de albaranes", "Impuestos especiales",       {|| ( ::tmpLabelReport )->cCodImp } )

   oFr:SetMasterDetail( "Albaranes", "Proveedor",                            {|| ( ::dbfCabecera )->cCodPrv } )
   oFr:SetMasterDetail( "Albaranes", "Almacenes",                            {|| ( ::dbfCabecera )->cCodAlm } )
   oFr:SetMasterDetail( "Albaranes", "Formas de pago",                       {|| ( ::dbfCabecera )->cCodPgo} )
   oFr:SetMasterDetail( "Albaranes", "Bancos",                               {|| ( ::dbfCabecera )->cCodPrv } )
   oFr:SetMasterDetail( "Albaranes", "Empresa",                              {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(   "Lineas de albaranes", "Albaranes" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Artículos" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Precios por propiedades" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Incidencias de albaranes" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Documentos de albaranes" )
   oFr:SetResyncPair(   "Lineas de albaranes", "Impuestos especiales" )   

   oFr:SetResyncPair(   "Albaranes", "Proveedor" )
   oFr:SetResyncPair(   "Albaranes", "Almacenes" )
   oFr:SetResyncPair(   "Albaranes", "Formas de pago" )
   oFr:SetResyncPair(   "Albaranes", "Bancos" )
   oFr:SetResyncPair(   "Albaranes", "Empresa" )

Return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TLabelGeneratorFacturaProveedores FROM TLabelGenerator

   data newImp 

   METHOD New( nView )

   METHOD loadTempLabelEdition() 
   
   METHOD dataLabel( oFr )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView, oNewImp ) CLASS TLabelGeneratorFacturaProveedores

   ::cSerieInicio       := ( D():FacturasProveedores( nView ) )->cSerFac
   ::cSerieFin          := ( D():FacturasProveedores( nView ) )->cSerFac

   ::nDocumentoInicio   := ( D():FacturasProveedores( nView ) )->nNumFac
   ::nDocumentoFin      := ( D():FacturasProveedores( nView ) )->nNumFac

   ::cSufijoInicio      := ( D():FacturasProveedores( nView ) )->cSufFac
   ::cSufijoFin         := ( D():FacturasProveedores( nView ) )->cSufFac

   ::cNombreDocumento   := "Factura proveedores"

   ::inicialDoc         := "FL"

   ::dbfCabecera        := ( D():FacturasProveedores( nView ) )
   ::dbfLineas          := ( D():FacturasProveedoresLineas( nView ) )

   ::idDocument         := D():FacturasProveedoresId( nView ) 

   ::aStructureField    := aSqlStruct( aColFacPrv() )

   ::nView              := nView
   ::newImp             := oNewImp

   ::Super:New() 

Return( Self )

//---------------------------------------------------------------------------//

METHOD loadTempLabelEdition( tmpLabel ) CLASS TLabelGeneratorFacturaProveedores

   local nRec
   local nOrd

   DEFAULT tmpLabel     := ::tmpLabelEdition

   //Limpiamos la base de datos temporal-----------------------------------------

   if ( tmpLabel )->( Used() )
      ( tmpLabel )->( __dbZap() )
   end if 

   //Llenamos la tabla temporal--------------------------------------------------

   nRec                 := ( ::dbfCabecera )->( Recno() )
   nOrd                 := ( ::dbfCabecera )->( OrdSetFocus( "nNumFac" ) )

   if ( ::dbfCabecera )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( ::dbfCabecera )->cSerFac + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio  .and.;
            ( ::dbfCabecera )->cSerFac + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin           .and.;
            ( ::dbfCabecera )->( !eof() )

         if ( ::dbfLineas )->( dbSeek( ( ::dbfCabecera )->cSerFac + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac ) )

            while ( ::dbfLineas )->cSerFac + Str( ( ::dbfLineas )->nNumFac ) + ( ::dbfLineas )->cSufFac == ( ::dbfCabecera )->cSerFac + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac  .and.;
                  ( ::dbfLineas )->( !eof() )

               if !empty( ( ::dbfLineas )->cRef )

                  dbPass( ::dbfLineas, tmpLabel, .t. )

                  dblock( tmpLabel )

                  ( tmpLabel )->nNumLin   := nTotNFacPrv( ::dbfLineas )
                  ( tmpLabel )->lLabel    := .t.

                  if ::nCantidadLabels == 1
                     ( tmpLabel )->nLabel := nTotNFacPrv( ::dbfLineas )
                  else
                     ( tmpLabel )->nLabel := ::nUnidadesLabels
                  end if

                  ( tmpLabel )->( dbUnlock() )

               end if

               ( ::dbfLineas )->( dbSkip() )

            end while

         end if

         ( ::dbfCabecera )->( dbSkip() )

      end while

   end if

   ( ::dbfCabecera )->( OrdSetFocus( nOrd ) )
   ( ::dbfCabecera )->( dbGoTo( nRec ) )

   ( tmpLabel )->( dbGoTop() )

   ::refreshBrowseLabel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD dataLabel( oFr ) CLASS TLabelGeneratorFacturaProveedores

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de facturas", ( ::tmpLabelReport )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   oFr:SetFieldAliases( "Lineas de facturas", cItemsToReport( aColFacPrv() ) )

   oFr:SetWorkArea(     "Facturas", ( ::dbfCabecera )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Facturas", cItemsToReport( aItmFacPrv() ) )

   oFr:SetWorkArea(     "Incidencias de facturas", ( D():FacturasProveedoresIncidencias( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de facturas", cItemsToReport( aIncFacPrv() ) )

   oFr:SetWorkArea(     "Documentos de facturas", ( D():FacturasProveedoresDocumentos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de facturas", cItemsToReport( aFacPrvDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedor", ( D():Proveedores( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Proveedor", cItemsToReport( aItmPrv() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( D():ArticuloPrecioPropiedades( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", ::nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", ::nView ):oDbf) )

   //oFr:SetWorkArea(     "Impuestos especiales",  D():ImpuestosEspeciales( ::nView ):Select() )
   //oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( D():ImpuestosEspeciales( ::nView ):oDbf) )

   oFr:SetWorkArea(     "Impuestos especiales",  ::newImp:Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( ::newImp:oDbf ) )
   
   oFr:SetMasterDetail( "Lineas de facturas", "Facturas",                  {|| ( ::tmpLabelReport )->cSerFac + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas", "Artículos",                 {|| ( ::tmpLabelReport )->cRef } )
   oFr:SetMasterDetail( "Lineas de facturas", "Precios por propiedades",   {|| ( ::tmpLabelReport )->cDetalle + ( ::tmpLabelReport )->cCodPr1 + ( ::tmpLabelReport )->cCodPr2 + ( ::tmpLabelReport )->cValPr1 + ( ::tmpLabelReport )->cValPr2 } )
   oFr:SetMasterDetail( "Lineas de facturas", "Incidencias de facturas",   {|| ( ::tmpLabelReport )->cSerFac + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas", "Documentos de facturas",    {|| ( ::tmpLabelReport )->cSerFac + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas", "Impuestos especiales",      {|| ( ::tmpLabelReport )->cCodImp } )

   oFr:SetMasterDetail( "Facturas", "Proveedor",                           {|| ( ::dbfCabecera )->cCodPrv } )
   oFr:SetMasterDetail( "Facturas", "Almacenes",                           {|| ( ::dbfCabecera )->cCodAlm } )
   oFr:SetMasterDetail( "Facturas", "Formas de pago",                      {|| ( ::dbfCabecera )->cCodPago } )
   oFr:SetMasterDetail( "Facturas", "Bancos",                              {|| ( ::dbfCabecera )->cCodPrv } )
   oFr:SetMasterDetail( "Facturas", "Empresa",                             {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(   "Lineas de facturas", "Facturas" )
   oFr:SetResyncPair(   "Lineas de facturas", "Artículos" )
   oFr:SetResyncPair(   "Lineas de facturas", "Precios por propiedades" )
   oFr:SetResyncPair(   "Lineas de facturas", "Incidencias de facturas" )
   oFr:SetResyncPair(   "Lineas de facturas", "Documentos de facturas" )
   oFr:SetResyncPair(   "Lineas de facturas", "Impuestos especiales" )   

   oFr:SetResyncPair(   "Facturas", "Proveedor" )
   oFr:SetResyncPair(   "Facturas", "Almacenes" )
   oFr:SetResyncPair(   "Facturas", "Formas de pago" )
   oFr:SetResyncPair(   "Facturas", "Bancos" )
   oFr:SetResyncPair(   "Facturas", "Empresa" )

Return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TLabelGeneratorFacturaRectificativaProveedores FROM TLabelGenerator

   METHOD New( nView )

   METHOD loadTempLabelEdition() 
   
   METHOD dataLabel( oFr )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TLabelGeneratorFacturaRectificativaProveedores

   ::cSerieInicio       := ( D():FacturasRectificativasProveedores( nView ) )->cSerFac
   ::cSerieFin          := ( D():FacturasRectificativasProveedores( nView ) )->cSerFac

   ::nDocumentoInicio   := ( D():FacturasRectificativasProveedores( nView ) )->nNumFac
   ::nDocumentoFin      := ( D():FacturasRectificativasProveedores( nView ) )->nNumFac

   ::cSufijoInicio      := ( D():FacturasRectificativasProveedores( nView ) )->cSufFac
   ::cSufijoFin         := ( D():FacturasRectificativasProveedores( nView ) )->cSufFac

   ::cNombreDocumento   := "Factura rectificativa proveedores"

   ::inicialDoc         := "RL"

   ::dbfCabecera        := ( D():FacturasRectificativasProveedores( nView ) )
   ::dbfLineas          := ( D():FacturasRectificativasProveedoresLineas( nView ) )

   ::idDocument         := D():FacturasRectificativasProveedoresId( nView ) 

   ::aStructureField    := aSqlStruct( aColFacPrv() )

   ::nView              := nView 

   ::Super:New() 

Return( Self )

//---------------------------------------------------------------------------//

METHOD loadTempLabelEdition( tmpLabel ) CLASS TLabelGeneratorFacturaRectificativaProveedores

   local nRec
   local nOrd

   DEFAULT tmpLabel     := ::tmpLabelEdition

   //Limpiamos la base de datos temporal-----------------------------------------

   if ( tmpLabel )->( Used() )
      ( tmpLabel )->( __dbZap() )
   end if 

   //Llenamos la tabla temporal--------------------------------------------------

   nRec                 := ( ::dbfCabecera )->( Recno() )
   nOrd                 := ( ::dbfCabecera )->( OrdSetFocus( "nNumFac" ) )

   if ( ::dbfCabecera )->( dbSeek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio, .t. ) )

      while ( ::dbfCabecera )->cSerFac + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio  .and.;
            ( ::dbfCabecera )->cSerFac + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac <= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin           .and.;
            ( ::dbfCabecera )->( !eof() )

         if ( ::dbfLineas )->( dbSeek( ( ::dbfCabecera )->cSerFac + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac ) )

            while ( ::dbfLineas )->cSerFac + Str( ( ::dbfLineas )->nNumFac ) + ( ::dbfLineas )->cSufFac == ( ::dbfCabecera )->cSerFac + Str( ( ::dbfCabecera )->nNumFac ) + ( ::dbfCabecera )->cSufFac  .and.;
                  ( ::dbfLineas )->( !eof() )

               if !empty( ( ::dbfLineas )->cRef )

                  dbPass( ::dbfLineas, tmpLabel, .t. )

                  dblock( tmpLabel )

                  ( tmpLabel )->nNumLin   := nTotNRctPrv( ::dbfLineas )
                  ( tmpLabel )->lLabel    := .t.

                  if ::nCantidadLabels == 1
                     ( tmpLabel )->nLabel := nTotNRctPrv( ::dbfLineas )
                  else
                     ( tmpLabel )->nLabel := ::nUnidadesLabels
                  end if

                  ( tmpLabel )->( dbUnlock() )

               end if

               ( ::dbfLineas )->( dbSkip() )

            end while

         end if

         ( ::dbfCabecera )->( dbSkip() )

      end while

   end if

   ( ::dbfCabecera )->( OrdSetFocus( nOrd ) )
   ( ::dbfCabecera )->( dbGoTo( nRec ) )

   ( tmpLabel )->( dbGoTop() )

   ::refreshBrowseLabel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD dataLabel( oFr ) CLASS TLabelGeneratorFacturaRectificativaProveedores

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de facturas rectificativas", ( ::tmpLabelReport )->( Select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   oFr:SetFieldAliases( "Lineas de facturas rectificativas", cItemsToReport( aColFacPrv() ) )

   oFr:SetWorkArea(     "Facturas", ( ::dbfCabecera )->( Select() ), .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Facturas", cItemsToReport( aItmFacPrv() ) )

   oFr:SetWorkArea(     "Incidencias de facturas rectificativas", ( D():FacturasRectificativasProveedoresIncidencias( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Incidencias de facturas rectificativas", cItemsToReport( aIncFacPrv() ) )

   oFr:SetWorkArea(     "Documentos de facturas rectificativas", ( D():FacturasRectificativasProveedoresDocumentos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Documentos de facturas rectificativas", cItemsToReport( aFacPrvDoc() ) )

   oFr:SetWorkArea(     "Empresa", ( D():Empresa( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Proveedor", ( D():Proveedores( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Proveedor", cItemsToReport( aItmPrv() ) )

   oFr:SetWorkArea(     "Almacenes", ( D():Almacen( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Formas de pago", ( D():FormasPago( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Formas de pago", cItemsToReport( aItmFPago() ) )

   oFr:SetWorkArea(     "Artículos", ( D():Articulos( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Precios por propiedades", ( D():ArticuloPrecioPropiedades( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Precios por propiedades", cItemsToReport( aItmVta() ) )

   oFr:SetWorkArea(     "Código de proveedores", ( D():ProveedorArticulo( ::nView ) )->( Select() ) )
   oFr:SetFieldAliases( "Código de proveedores", cItemsToReport( aItmArtPrv() ) )

   oFr:SetWorkArea(     "Unidades de medición",  D():GetObject( "UnidadMedicion", ::nView ):Select() )
   oFr:SetFieldAliases( "Unidades de medición",  cObjectsToReport( D():GetObject( "UnidadMedicion", ::nView ):oDbf) )

   oFr:SetWorkArea(     "Impuestos especiales",  D():ImpuestosEspeciales( ::nView ):Select() )
   oFr:SetFieldAliases( "Impuestos especiales",  cObjectsToReport( D():ImpuestosEspeciales( ::nView ):oDbf) )
   
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Facturas",                                 {|| ( ::tmpLabelReport )->cSerFac + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Artículos",                                {|| ( ::tmpLabelReport )->cRef } )
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Precios por propiedades",                  {|| ( ::tmpLabelReport )->cDetalle + ( ::tmpLabelReport )->cCodPr1 + ( ::tmpLabelReport )->cCodPr2 + ( ::tmpLabelReport )->cValPr1 + ( ::tmpLabelReport )->cValPr2 } )
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Incidencias de facturas rectificativas",   {|| ( ::tmpLabelReport )->cSerFac + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Documentos de facturas rectificativas",    {|| ( ::tmpLabelReport )->cSerFac + Str( ( ::tmpLabelReport )->nNumFac ) + ( ::tmpLabelReport )->cSufFac } )
   oFr:SetMasterDetail( "Lineas de facturas rectificativas", "Impuestos especiales",                     {|| ( ::tmpLabelReport )->cCodImp } )

   oFr:SetMasterDetail( "Facturas", "Proveedor",                          {|| ( ::dbfCabecera )->cCodPrv } )
   oFr:SetMasterDetail( "Facturas", "Almacenes",                          {|| ( ::dbfCabecera )->cCodAlm } )
   oFr:SetMasterDetail( "Facturas", "Formas de pago",                     {|| ( ::dbfCabecera )->cCodPago } )
   oFr:SetMasterDetail( "Facturas", "Bancos",                             {|| ( ::dbfCabecera )->cCodPrv } )
   oFr:SetMasterDetail( "Facturas", "Empresa",                            {|| cCodigoEmpresaEnUso() } )

   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Facturas" )
   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Artículos" )
   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Precios por propiedades" )
   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Incidencias de facturas rectificativas" )
   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Documentos de facturas rectificativas" )
   oFr:SetResyncPair(   "Lineas de facturas rectificativas", "Impuestos especiales" )   

   oFr:SetResyncPair(   "Facturas", "Proveedor" )
   oFr:SetResyncPair(   "Facturas", "Almacenes" )
   oFr:SetResyncPair(   "Facturas", "Formas de pago" )
   oFr:SetResyncPair(   "Facturas", "Bancos" )
   oFr:SetResyncPair(   "Facturas", "Empresa" )

Return nil

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TLabelGeneratorMovimientosAlmacen FROM TLabelGenerator

   DATA oSender

   METHOD New( oSender )

   METHOD loadTempLabelEdition() 
   
   METHOD dataLabel( oFr )

   METHOD lCreateTempLabelEdition()

   METHOD createTempLabelReport()

   METHOD buildCodeColumn()

   METHOD buildDetailColumn()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TLabelGeneratorMovimientosAlmacen

   ::oSender            := oSender

   ::dbfCabecera        := oSender:oDbf:cAlias
   ::dbfLineas          := oSender:oDetMovimientos:oDbf:cAlias
   
   ::nDocumentoInicio   := oSender:oDbf:nNumRem 
   ::nDocumentoFin      := oSender:oDbf:nNumRem 

   ::cSufijoInicio      := oSender:oDbf:cSufRem 
   ::cSufijoFin         := oSender:oDbf:cSufRem 

   ::cNombreDocumento   := "Movimientos de almacén"

   ::lHideSerie         := .t.

   ::inicialDoc         := "MV"

   ::idDocument         := str( oSender:oDbf:nNumRem, 9 ) + oSender:oDbf:cSufRem 

   ::aStructureField    := oSender:oDetMovimientos:oDbf:aField() 

   ::Super:New( oSender:nView ) 

Return( Self )

//---------------------------------------------------------------------------//

METHOD lCreateTempLabelEdition() CLASS TLabelGeneratorMovimientosAlmacen

   local oBlock
   local oError
   local lCreateTempLabelEdition   := .t.

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::tmpLabelEdition       := "LblEdt" + cCurUsr()

      ::cFileTmpLabel         := cGetNewFileName( cPatTmp() + "LblEdt" )

      ::DestroyTempLabelEdition()

      dbCreate( ::cFileTmpLabel,  ::aStructureField , cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), ::cFileTmpLabel, ::tmpLabelEdition, .f. )

      if!( ::tmpLabelEdition )->( neterr() )
         ( ::tmpLabelEdition )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( ::tmpLabelEdition )->( OrdCreate( ::cFileTmpLabel, "cRefMov", "cRefMov", {|| Field->cRefMov } ) )

         ( ::tmpLabelEdition )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( ::tmpLabelEdition )->( OrdCreate( ::cFileTmpLabel, "cNomMov", "Upper( cNomMov )", {|| Upper( Field->cNomMov ) } ) )
      end if

      ( ::tmpLabelEdition )->( OrdsetFocus( "cRef" ) )

   RECOVER USING oError

      lCreateTempLabelEdition      := .f.

      MsgStop( 'Imposible crear fichero temporal' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateTempLabelEdition )

//---------------------------------------------------------------------------//

METHOD createTempLabelReport() CLASS TLabelGeneratorMovimientosAlmacen

   local oBlock
   local oError
   local createTempLabelReport := .t.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::tmpLabelReport     := "LblRpt" + cCurUsr()
      ::fileLabelReport    := cGetNewFileName( cPatTmp() + "LblRpt" )

      dbCreate( ::fileLabelReport, ::aStructureField, cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), ::fileLabelReport, ::tmpLabelReport, .f. )

      if!( ::tmpLabelReport )->( neterr() )
         ( ::tmpLabelReport )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( ::tmpLabelReport )->( OrdCreate( ::fileLabelReport, "cRefMov", "cRefMov", {|| Field->cRefMov } ) )
      end if

   RECOVER USING oError

      createTempLabelReport    := .f.

      MsgStop( 'Imposible crear un fichero temporal de lineas del documento' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( createTempLabelReport )

//---------------------------------------------------------------------------//

METHOD buildCodeColumn() CLASS TLabelGeneratorMovimientosAlmacen

   with object ( ::oBrwLabel:AddCol() ) 
      :cHeader          := "Código"
      :bEditValue       := {|| ( ::tmpLabelEdition )->cRefMov }
      :nWidth           := 80
      :cSortOrder       := "cRefMov"
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oComboBoxOrden:Set( oCol:cHeader ) }
   end with

Return ( Self )

//------------------------------------------------------------------------//

METHOD buildDetailColumn() CLASS TLabelGeneratorMovimientosAlmacen

   with object ( ::oBrwLabel:AddCol() )
      :cHeader          := "Nombre"
      :bEditValue       := {|| ( ::tmpLabelEdition )->cNomMov }
      :nWidth           := 250
      :cSortOrder       := "cNomMov"
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oComboBoxOrden:Set( oCol:cHeader ) }
   end with

Return ( Self )

//------------------------------------------------------------------------//

METHOD loadTempLabelEdition( tmpLabel ) CLASS TLabelGeneratorMovimientosAlmacen

   local nRec
   local nOrd

   DEFAULT tmpLabel     := ::tmpLabelEdition

   //Limpiamos la base de datos temporal-----------------------------------------

   if ( tmpLabel )->( used() )
      ( tmpLabel )->( __dbZap() )
   end if 

   //Llenamos la tabla temporal--------------------------------------------------

   nRec                 := ( ::dbfCabecera )->( recno() )
   nOrd                 := ( ::dbfCabecera )->( ordsetfocus( "cNumRem" ) )

   if ( ::dbfCabecera )->( dbseek( ::idDocument, .t. ) )

      while str( ( ::dbfCabecera )->nNumRem ) + ( ::dbfCabecera )->cSufRem >= str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio  .and.;
            str( ( ::dbfCabecera )->nNumRem ) + ( ::dbfCabecera )->cSufRem <= str( ::nDocumentoFin, 9 ) + ::cSufijoFin        .and.;
            ( ::dbfCabecera )->( !eof() )

         if ( ::dbfLineas )->( dbseek( str( ( ::dbfCabecera )->nNumRem ) + ( ::dbfCabecera )->cSufRem ) )

            while str( ( ::dbfLineas )->nNumRem ) + ( ::dbfLineas )->cSufRem == str( ( ::dbfCabecera )->nNumRem ) + ( ::dbfCabecera )->cSufRem  .and.;
                  ( ::dbfLineas )->( !eof() )

               if !empty( ( ::dbfLineas )->cRefMov )

                  dbPass( ::dbfLineas, tmpLabel, .t. )

                  dblock( tmpLabel )

                  ( tmpLabel )->lLabel    := .t.

                  if ::nCantidadLabels == 1
                     ( tmpLabel )->nLabel := nTotNMovAlm( ::dbfLineas )
                  else
                     ( tmpLabel )->nLabel := ::nUnidadesLabels
                  end if

                  ( tmpLabel )->( dbUnlock() )

               end if

               ( ::dbfLineas )->( dbSkip() )

            end while

         end if

         ( ::dbfCabecera )->( dbSkip() )

      end while

   end if

   ( ::dbfCabecera )->( OrdSetFocus( nOrd ) )
   ( ::dbfCabecera )->( dbGoTo( nRec ) )

   ( tmpLabel )->( dbGoTop() )

   ::refreshBrowseLabel()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD dataLabel( oFr ) CLASS TLabelGeneratorMovimientosAlmacen

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de movimientos",   ( ::tmpLabelReport )->( select() ), .f., { FR_RB_FIRST, FR_RE_LAST, 0 } )
   oFr:SetFieldAliases( "Lineas de movimientos",   cObjectsToReport( ::oSender:oDetMovimientos:oDbf ) )

   oFr:SetWorkArea(     "Movimientos",             ::oSender:oDbf:nArea )
   oFr:SetFieldAliases( "Movimientos",             cObjectsToReport( ::oSender:oDbf ) )

   oFr:SetWorkArea(     "Empresa",                 ::oSender:oDbfEmp:nArea )
   oFr:SetFieldAliases( "Empresa",                 cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Almacén origen",          ::oSender:oAlmacenOrigen:nArea )
   oFr:SetFieldAliases( "Almacén origen",          cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Almacén destino",         ::oSender:oAlmacenDestino:nArea )
   oFr:SetFieldAliases( "Almacén destino",         cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Agentes",                 ::oSender:oDbfAge:nArea )
   oFr:SetFieldAliases( "Agentes",                 cItemsToReport( aItmAge() ) )
   
   oFr:SetWorkArea(     "Artículos",               ::oSender:oArt:nArea )
   oFr:SetFieldAliases( "Artículos",               cItemsToReport( aItmArt() ) )

   oFr:SetMasterDetail( "Lineas de movimientos",   "Movimientos",             {|| str( ( ::tmpLabelReport )->nNumRem ) + ( ::tmpLabelReport )->cSufRem } )
   oFr:SetMasterDetail( "Lineas de movimientos",   "Artículos",               {|| ( ::tmpLabelReport )->cRefMov } )
   oFr:SetMasterDetail( "Movimientos",             "Empresa",                 {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Movimientos",             "Almacén origen",          {|| ::oSender:oDbf:cAlmOrg } )
   oFr:SetMasterDetail( "Movimientos",             "Almacén destino",         {|| ::oSender:oDbf:cAlmDes } )
   oFr:SetMasterDetail( "Movimientos",             "Agentes",                 {|| ::oSender:oDbf:cCodAge } )

   oFr:SetResyncPair(   "Lineas de movimientos",   "Movimientos" )
   oFr:SetResyncPair(   "Lineas de movimientos",   "Artículos" )
   oFr:SetResyncPair(   "Movimientos",             "Empresa" )
   oFr:SetResyncPair(   "Movimientos",             "Almacén origen" )
   oFr:SetResyncPair(   "Movimientos",             "Almacén destino" )
   oFr:SetResyncPair(   "Movimientos",             "Agentes" )

Return nil

//---------------------------------------------------------------------------//

