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
   DATA cFormatoLabel               INIT "MVP"

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

   METHOD getHashList()             INLINE ( ::oController:oHashList )

   METHOD setId( id )               INLINE ( ::nDocumentoInicio := id, ::nDocumentoFin := id )

   METHOD Anterior() 

   METHOD Siguiente() 

   METHOD sumarUnidades()           INLINE ( ::getHashList():fieldput( 'total_unidades', ::getHashList():fieldGet( 'total_unidades' ) + 1 ) ) 

   METHOD restarUnidades()          INLINE ( iif(  ::getHashList():fieldGet( 'total_unidades' ) > 0,;
                                                   ::getHashList():fieldput( 'total_unidades', ::getHashList():fieldGet( 'total_unidades' ) - 1 ),;
                                                   ) ) 

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG ::oDialog RESOURCE "ETIQUETAS_SELECTOR_0"

      REDEFINE PAGES ::oPages ;
         ID          10 ;
         OF          ::oDialog ;
         DIALOGS     "ETIQUETAS_SELECTOR_1",;
                     "ETIQUETAS_SELECTOR_2" 

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

         ::oFormatoLabel:bValid  := {|| ::oController:validateFormatoDocumento() }
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

      REDEFINE BUTTON ;
         ID          100 ;
         OF          ::oPages:aDialogs[ 2 ] ;
         ACTION      ( msgalert( "search" ) )

      ::oBrowse:nMarqueeStyle    := MARQSTYLE_HIGHLROWMS

      ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
      ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }

      ::oBrowse:setHashList( ::getHashList() )

      msgalert( ::getHashList():reccount(), "reccount()" )

      ::oBrowse:CreateFromResource( 110 )

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Id"
         :bEditValue       := {|| ::getHashList():fieldGet( 'id' ) }
         //:cSortOrder       := 'movimientos_almacen_lineas.id'
         :nWidth           := 40
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::oController:clickingHeader( oColumn ) }
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ::getHashList():fieldGet( 'codigo_articulo' ) }
         :cSortOrder       := 'movimientos_almacen_lineas.codigo_articulo'
         :nWidth           := 120
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::oController:clickingHeader( oColumn ) }
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| ::getHashList():fieldGet( 'nombre_articulo' ) }
         :cSortOrder       := 'movimientos_almacen_lineas.nombre_articulo'
         :nWidth           := 220
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::oController:clickingHeader( oColumn ) }
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Primera propiedad"
         :bEditValue       := {|| ::getHashList():fieldGet( 'valor_primera_propiedad' ) }
         :cSortOrder       := 'movimientos_almacen_lineas.valor_primera_propiedad'
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::oController:clickingHeader( oColumn ) }
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Segunda propiedad"
         :bEditValue       := {|| ::getHashList():fieldGet( 'valor_segunda_propiedad' ) }
         :cSortOrder       := 'movimientos_almacen_lineas.valor_segunda_propiedad'
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::oController:clickingHeader( oColumn ) }
      end with

/*
      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Sumar unidades"
         :bStrData         := {|| "" }
         :bOnPostEdit      := {|| .t. }
         :bEditBlock       := {|| ::sumarUnidades() }
         :nEditType        := 5
         :nWidth           := 20
         :nHeadBmpNo       := 1
         :nBtnBmp          := 1
         :nHeadBmpAlign    := 1
         :AddResource( "gc_navigate_plus_16" )
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Restar unidades"
         :bStrData         := {|| "" }
         :bOnPostEdit      := {|| .t. }
         :bEditBlock       := {|| ::restarUnidades() }
         :nEditType        := 5
         :nWidth           := 20
         :nHeadBmpNo       := 1
         :nBtnBmp          := 1
         :nHeadBmpAlign    := 1
         :AddResource( "gc_navigate_minus_16" )
      end with
*/
      
      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Etiquetas"
         :bEditValue       := {|| ::getHashList():fieldGet( 'total_unidades' ) }
         :cSortOrder       := 'total_unidades'
         :cEditPicture     := "@E 99,999"
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::oController:clickingHeader( oColumn ) }
         :bOnPostEdit      := {|o,x| ::getHashList():fieldput( 'total_unidades', x ) }
      end with
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

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD startDialog()

   ::oSerieInicio:Hide()
   ::oSerieFin:Hide()

   ::oSufijoInicio:Hide()
   ::oSufijoFin:Hide()

   ::oFormatoLabel:lValid()

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD Anterior() 

   ::oPages:GoPrev()

   ::oBtnAnterior:Hide()

   SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Siguiente() 

   do case
      case ::oPages:nOption == 1

         if empty( ::cFormatoLabel )

            msgStop( "Debe cumplimentar un formato de etiquetas" )

         else

            ::oController:GenerateRowSet()

            ::oPages:GoNext()

            ::oBtnAnterior:Show()

            SetWindowText( ::oBtnSiguiente:hWnd, "&Terminar" )

         end if

      case ::oPages:nOption == 2

         ::oController:GenerateLabels()

         SetWindowText( ::oBtnCancel:hWnd, "&Cerrar" )

   end case

RETURN ( Self )

//---------------------------------------------------------------------------//

