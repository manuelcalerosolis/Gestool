#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS EtiquetasSelectorView FROM SQLBaseView 

   DATA oDialog

   DATA oPages

   DATA oBrowse

   DATA oSerieInicio
   DATA cSerieInicio                INIT "A"

   DATA oSerieFin
   DATA cSerieFin                   INIT "Z"

   DATA oDocumentoInicio
   DATA nDocumentoInicio

   DATA oDocumentoFin
   DATA nDocumentoFin

   DATA oSufijoInicio
   DATA cSufijoInicio

   DATA oSufijoFin
   DATA cSufijoFin

   DATA oFormatoLabel
   DATA cFormatoLabel

   DATA cPrinter

   DATA nFilaInicio                 INIT 1
   DATA nColumnaInicio              INIT 1

   DATA nCantidadLabels             INIT 1
   DATA nUnidadesLabels             INIT 1

   DATA oMtrLabel
   DATA nMtrLabel

   DATA lClose

   DATA lErrorOnCreate

   DATA oBtnListado
   DATA oBtnSiguiente
   DATA oBtnAnterior
   DATA oBtnCancel

   DATA oBtnPropiedades
   DATA oBtnModificar
   DATA oBtnZoom

   DATA inicialDoc                  INIT "MV"

   METHOD New( oController )

   METHOD Activate()

   METHOD startDialog()

   METHOD getRowSet()               INLINE ( ::oController:getRowSet() )

   METHOD setId()

   METHOD Anterior() 

   METHOD Siguiente() 

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG ::oDialog RESOURCE "SelectLabels_0"

      REDEFINE PAGES ::oPages ;
         ID          10;
         OF          ::oDialog ;
         DIALOGS     "SelectLabels_1",;
                     "SelectLabels_2"

      REDEFINE BITMAP ;
         RESOURCE    "gc_portable_barcode_scanner_48" ;
         ID          500 ;
         TRANSPARENT ;
         OF          ::oDialog ;

      REDEFINE GET   ::oSerieInicio ;
         VAR         ::cSerieInicio ;
         ID          100 ;
         PICTURE     "@!" ;
         SPINNER ;
         ON UP       ( UpSerie( ::oSerieInicio ) );
         ON DOWN     ( DwSerie( ::oSerieInicio ) );
         VALID       ( ( ::cSerieInicio >= "A" .and. ::cSerieInicio <= "Z" ) .or. ( ::lHideSerie ) );
         UPDATE ;
         OF          ::oPages:aDialogs[ 1 ]

      REDEFINE GET   ::oSerieFin ;
         VAR         ::cSerieFin ;
         ID          110 ;
         PICTURE     "@!" ;
         SPINNER ;
         ON UP       ( UpSerie( ::oSerieFin ) );
         ON DOWN     ( DwSerie( ::oSerieFin ) );
         VALID       ( ( ::cSerieInicio >= "A" .and. ::cSerieInicio <= "Z" ) .or. ( ::lHideSerie ) );
         UPDATE ;
         OF          ::oPages:aDialogs[ 1 ]

      REDEFINE GET   ::oDocumentoInicio ;
         VAR         ::nDocumentoInicio ;
         ID          120 ;
         PICTURE     "999999999" ;
         SPINNER ;
         OF          ::oPages:aDialogs[ 1 ]

      REDEFINE GET   ::oDocumentoFin ;
         VAR         ::nDocumentoFin ;
         ID          130 ;
         PICTURE     "999999999" ;
         SPINNER ;
         OF          ::oPages:aDialogs[ 1 ]

      REDEFINE GET   ::oSufijoInicio ;
         VAR         ::cSufijoInicio ;
         ID          140 ;
         PICTURE     "##" ;
         OF          ::oPages:aDialogs[ 1 ]

      REDEFINE GET   ::oSufijoFin ;
         VAR         ::cSufijoFin ;
         ID          150 ;
         PICTURE     "##" ;
         OF          ::oPages:aDialogs[ 1 ]

      REDEFINE GET   ::nFilaInicio ;
         ID          180 ;
         PICTURE     "999" ;
         SPINNER ;
         OF          ::oPages:aDialogs[ 1 ]

      REDEFINE GET   ::nColumnaInicio ;
         ID          190 ;
         PICTURE     "999" ;
         SPINNER ;
         OF          ::oPages:aDialogs[ 1 ]

      REDEFINE GET   ::oFormatoLabel ;
         VAR         ::cFormatoLabel ;
         ID          160 ;
         IDTEXT      161 ;
         BITMAP      "LUPA" ;
         OF          ::oPages:aDialogs[ 1 ]

         ::oFormatoLabel:bValid  := {|| DocumentosModel():exist( ::cFormatoLabel ) }
         ::oFormatoLabel:bHelp   := {|| brwDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, ::inicialDoc ) }

      TBtnBmp():ReDefine( 220, "gc_document_text_pencil_12",,,,, {|| EdtDocumento( ::cFormatoLabel ) }, ::oPages:aDialogs[ 1 ], .f., , .f., "Modificar formato de etiquetas" )

      REDEFINE RADIO ::nCantidadLabels ;
         ID          200, 201 ;
         OF          ::oPages:aDialogs[ 1 ]

      REDEFINE GET   ::nUnidadesLabels ;
         ID          210 ;
         PICTURE     "99999" ;
         SPINNER ;
         MIN         1 ;
         MAX         99999 ;
         WHEN        ( ::nCantidadLabels == 2 ) ;
         OF          ::oPages:aDialogs[ 1 ]

      // Segunda caja de dialogo--------------------------------------------------

      ::oBrowse                  := SQLXBrowse():New( ::oPages:aDialogs[ 2 ] )
      ::oBrowse:l2007            := .f.

      ::oBrowse:lRecordSelector  := .f.
      ::oBrowse:lAutoSort        := .t.
      ::oBrowse:lSortDescend     := .f.   

      // Propiedades del control--------------------------------------------------

      ::oBrowse:nMarqueeStyle    := MARQSTYLE_HIGHLROWMS

      ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
      ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }

      ::oBrowse:setRowSet( ::getRowSet() )

      ::oBrowse:CreateFromResource( 180 )

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Sl. Seleccionada"
         :bEditValue       := {|| ::getRowSet():fieldGet( 'selected' ) }
         :nWidth           := 20
         // :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ::getRowSet():fieldGet( 'codigo_articulo' ) }
         :nWidth           := 120
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| ::getRowSet():fieldGet( 'nombre_articulo' ) }
         :nWidth           := 120
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Primera propiedad"
         :bEditValue       := {|| ::getRowSet():fieldGet( 'valor_primera_propiedad' ) }
         :nWidth           := 80
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Segunda propiedad"
         :bEditValue       := {|| ::getRowSet():fieldGet( 'valor_segunda_propiedad' ) }
         :nWidth           := 80
      end with


      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Etiquetas"
         :bEditValue       := {|| ::getRowSet():fieldGet( 'total_unidades' ) }
         :cEditPicture     := "@E 99,999"
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
      end with

/*

      REDEFINE GET oGetOrd ;
         VAR      cGetOrd ;
         ID       200 ;
         BITMAP   "FIND" ;
         OF       ::oPages:aDialogs[ 2 ]

      oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwLabel, ::tmpLabelEdition ) }
      oGetOrd:bValid    := {|| ( ::tmpLabelEdition )->( OrdScope( 0, nil ) ), ( ::tmpLabelEdition )->( OrdScope( 1, nil ) ), ::refreshBrowseLabel(), .t. }

      REDEFINE COMBOBOX ::oComboBoxOrden ;
         VAR      ::cComboBoxOrden ;
         ID       210 ;
         ITEMS    ::aComboBoxOrden ;
         OF       ::oPages:aDialogs[ 2 ]

      ::oComboBoxOrden:bChange   := {|| ::SelectColumn( ::oComboBoxOrden ) }

      REDEFINE BUTTON ;
         ID       100 ;
         OF       ::oPages:aDialogs[ 2 ] ;
         ACTION   ( ::PutLabel() )

      REDEFINE BUTTON ;
         ID       110 ;
         OF       ::oPages:aDialogs[ 2 ] ;
         ACTION   ( ::SelectAllLabels( .t. ) )

      REDEFINE BUTTON ;
         ID       120 ;
         OF       ::oPages:aDialogs[ 2 ] ;
         ACTION   ( ::SelectAllLabels( .f. ) )

      REDEFINE BUTTON ;
         ID       130 ;
         OF       ::oPages:aDialogs[ 2 ] ;
         ACTION   ( ::AddLabel() )

      REDEFINE BUTTON ;
         ID       140 ;
         OF       ::oPages:aDialogs[ 2 ] ;
         ACTION   ( ::DelLabel() )

      REDEFINE BUTTON ;
         ID       150 ;
         OF       ::oPages:aDialogs[ 2 ] ;
         ACTION   ( ::EditLabel() )

      REDEFINE BUTTON ::oBtnPropiedades ;
         ID       220 ;
         OF       ::oPages:aDialogs[ 2 ] ;
         ACTION   ( nil )

      REDEFINE BUTTON ::oBtnModificar;
         ID       160 ;
         OF       ::oPages:aDialogs[ 2 ] ;
         ACTION   ( nil )

      REDEFINE BUTTON ::oBtnZoom;
         ID       165 ;
         OF       ::oPages:aDialogs[ 2 ] ;
         ACTION   ( nil )

      ::oBrwLabel                 := IXBrowse():New( ::oPages:aDialogs[ 2 ] )

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
         OF       ::oPages:aDialogs[ 2 ] ;
         TOTAL    ( ::tmpLabelEdition  )->( lastrec() )

      ::oMtrLabel:nClrText   := rgb( 128,255,0 )
      ::oMtrLabel:nClrBar    := rgb( 128,255,0 )
      ::oMtrLabel:nClrBText  := rgb( 128,255,0 )
*/
      // Botones generales-------------------------------------------------------

      REDEFINE BUTTON ::oBtnAnterior ;          // Boton anterior
         ID          20 ;
         OF          ::oDialog ;
         ACTION      ( ::Anterior() )

      REDEFINE BUTTON ::oBtnSiguiente ;         // Boton de Siguiente
         ID          30 ;
         OF          ::oDialog ;
         ACTION      ( ::Siguiente() )

      REDEFINE BUTTON ::oBtnCancel ;            // Boton de Cancelar
         ID          IDCANCEL ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:End() )

   ::oDialog:bStart  := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDialog CENTER
/*
   ::DestroyTempLabelEdition()

   ::End()
*/
RETURN ( self )

//----------------------------------------------------------------------------//

METHOD startDialog()

   ::oSerieInicio:Hide()
   ::oSerieFin:Hide()

   ::oSufijoInicio:Hide()
   ::oSufijoFin:Hide()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD Anterior() 

   ::oPages:GoPrev()

   ::oBtnAnterior:Hide()

   SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD Siguiente() 

   do case
      case ::oPages:nOption == 1

         if empty( ::cFormatoLabel )

            msgStop( "Debe cumplimentar un formato de etiquetas" )

         else

            ::oController:GenerateRowSet()

            ::oBrowse:Refresh()

            ::oPages:GoNext()

            ::oBtnAnterior:Show()

            SetWindowText( ::oBtnSiguiente:hWnd, "&Terminar" )

         end if

      case ::oPages:nOption == 2

         if ::lPrintLabels()

            SetWindowText( ::oBtnCancel:hWnd, "&Cerrar" )

         end if

   end case

Return ( Self )

//---------------------------------------------------------------------------//

METHOD setId( id )

   ::nDocumentoInicio   := id 
   ::nDocumentoFin      := id 

RETURN ( self )

//----------------------------------------------------------------------------//
