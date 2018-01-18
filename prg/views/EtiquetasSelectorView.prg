#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS EtiquetasSelectorView FROM SQLBaseView 

   DATA oDialog

   DATA oPages

   DATA oBrowse

   DATA aIds

   DATA oSayRegistrosSeleccionados

   DATA oListboxFile
   DATA aListboxFile                INIT {}
   DATA cListboxFile                INIT ""

   DATA cPrinter

   DATA nFilaInicio                 INIT 1
   DATA nColumnaInicio              INIT 1

   DATA nCantidadLabels             INIT 1
   DATA nUnidadesLabels             INIT 1

   DATA oMtrLabel
   DATA nMtrLabel

   DATA oGetSearch
   DATA cGetSearch                  INIT space( 200 )

   DATA lClose

   DATA lErrorOnCreate

   DATA oBtnListado
   DATA oBtnSiguiente
   DATA oBtnAnterior
   DATA oBtnCancel

   DATA oBtnPropiedades
   DATA oBtnModificar
   DATA oBtnZoom

   DATA oColumnUnidades

   METHOD New( oController )

   METHOD Activate()

   METHOD startDialog()

   METHOD getHashList()                INLINE ( ::oController:oHashList )

   METHOD hashListFind()

   METHOD getColumnOrder()             INLINE ( ::oBrowse:getColumnOrder():cOrder )

   METHOD getRegistrosSeleccionados()  INLINE ( "( " + alltrim( str( len( ::oController:getIds() ) ) ) + ") registro(s) seleccionado(s)" )

   METHOD Anterior() 

   METHOD Siguiente() 

   METHOD sortColumn( oColumn, nColumn )

   METHOD sumarUnidades()              INLINE ( ::getHashList():fieldput( 'total_unidades', ::getHashList():fieldGet( 'total_unidades' ) + 1 ),;
                                                ::oBrowse:Refresh() ) 

   METHOD restarUnidades()             INLINE ( iif(  ::getHashList():fieldGet( 'total_unidades' ) > 0,;
                                                      ::getHashList():fieldput( 'total_unidades', ::getHashList():fieldGet( 'total_unidades' ) - 1 ),;
                                                      ),;
                                                ::oBrowse:Refresh() ) 

   METHOD limpiarUnidades()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

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

      REDEFINE SAY   ::oSayRegistrosSeleccionados ;
         VAR         ::getRegistrosSeleccionados() ;
         ID          100 ;
         OF          ::oPages:aDialogs[ 1 ]

      TBtnBmp():ReDefine( 110, "new16",,,,, {|| ::oController:createLabel() }, ::oPages:aDialogs[ 1 ], .f., , .f., "Añadir formato" )

      TBtnBmp():ReDefine( 120, "edit16",,,,, {|| ::oController:editDocument() }, ::oPages:aDialogs[ 1 ], .f., , .f., "Modificar formato" )

      TBtnBmp():ReDefine( 130, "del16",,,,, {|| ::oController:deleteDocument() }, ::oPages:aDialogs[ 1 ], .f., , .f., "Eliminar formato" )

      REDEFINE LISTBOX ::oListboxFile ;
         VAR         ::cListboxFile ;
         ITEMS       ::aListboxFile ;
         ID          140 ;
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

      REDEFINE GET   ::oGetSearch ;
         VAR         ::cGetSearch ;
         ID          100 ;
         BITMAP      "gc_binocular2_16" ;
         OF          ::oPages:aDialogs[ 2 ]

         ::oGetSearch:bChange    := {|| ::hashListFind() }

      REDEFINE BUTTON ; 
         ID          110 ; 
         OF          ::oPages:aDialogs[ 2 ] ;
         ACTION      ( ::sumarUnidades() )

      REDEFINE BUTTON ; 
         ID          120 ; 
         OF          ::oPages:aDialogs[ 2 ] ;
         ACTION      ( ::restarUnidades() )

      REDEFINE BUTTON ; 
         ID          130 ; 
         OF          ::oPages:aDialogs[ 2 ] ;
         ACTION      ( ::oColumnUnidades:Edit() )

      REDEFINE BUTTON ; 
         ID          140 ; 
         OF          ::oPages:aDialogs[ 2 ] ;
         ACTION      ( ::limpiarUnidades() )

      // Propiedades del control--------------------------------------------------

      ::oBrowse                  := SQLXBrowse():New( ::oPages:aDialogs[ 2 ] )
      ::oBrowse:l2007            := .f.

      ::oBrowse:lRecordSelector  := .f.
      ::oBrowse:lAutoSort        := .t.
      ::oBrowse:lSortDescend     := .f.   

      ::oBrowse:nMarqueeStyle    := MARQSTYLE_HIGHLROWMS

      ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
      ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }

      ::oBrowse:setHashList( ::oController ) 

      ::oBrowse:CreateFromResource( 200 )

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Id"
         :cSortOrder       := 'id'
         :cOrder           := 'D'
         :bEditValue       := {|| ::getHashList():fieldget( 'id' ) }
         :nWidth           := 40
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::sortColumn( oColumn ) }
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := 'codigo_articulo'
         :bEditValue       := {|| ::getHashList():fieldGet( 'codigo_articulo' ) }
         :nWidth           := 120
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::sortColumn( oColumn ) }
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := 'nombre_articulo'
         :bEditValue       := {|| ::getHashList():fieldGet( 'nombre_articulo' ) }
         :nWidth           := 220
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::sortColumn( oColumn ) }
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Código primera propiedad"
         :cSortOrder       := 'codigo_primera_propiedad'
         :bEditValue       := {|| ::getHashList():fieldGet( 'codigo_primera_propiedad' ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::sortColumn( oColumn ) }
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Código segunda propiedad"
         :cSortOrder       := 'codigo_segunda_propiedad'
         :bEditValue       := {|| ::getHashList():fieldGet( 'codigo_segunda_propiedad' ) }
         :nWidth           := 80
         :lHide            := .t.
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::sortColumn( oColumn ) }
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Primera propiedad"
         :cSortOrder       := 'valor_primera_propiedad'
         :bEditValue       := {|| ::getHashList():fieldGet( 'valor_primera_propiedad' ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::sortColumn( oColumn ) }
      end with

      with object ( ::oBrowse:AddCol() )
         :cHeader          := "Segunda propiedad"
         :cSortOrder       := 'valor_segunda_propiedad'
         :bEditValue       := {|| ::getHashList():fieldGet( 'valor_segunda_propiedad' ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::sortColumn( oColumn ) }
      end with
    
      with object ( ::oColumnUnidades := ::oBrowse:AddCol() )
         :cHeader          := "Etiquetas"
         :cSortOrder       := 'total_unidades'
         :bEditValue       := {|| ::getHashList():fieldGet( 'total_unidades' ) }
         :cEditPicture     := "@E 99,999"
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::sortColumn( oColumn ) }
         :bOnPostEdit      := {|o,x| ::getHashList():fieldput( 'total_unidades', x ) }
      end with

      // Botones generales-------------------------------------------------------

      REDEFINE BUTTON ::oBtnAnterior ;          
         ID          20 ;
         OF          ::oDialog ;
         ACTION      ( ::Anterior() )

      REDEFINE BUTTON ::oBtnSiguiente ;         
         ID          30 ;
         OF          ::oDialog ;
         ACTION      ( ::Siguiente() )

      REDEFINE BUTTON ::oBtnCancel ;            
         ID          IDCANCEL ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:End() )

   ::oDialog:bStart  := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD startDialog()

   ::oController:loadDocuments()

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

         if empty( ::cListboxFile )

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

METHOD sortColumn( oColumn )

   ::oBrowse:selectColumnOrder( oColumn )

   if ( oColumn:cOrder == 'A' )
      ::getHashList():sort( { | x, y | x[ oColumn:nCreationOrder ] > y[ oColumn:nCreationOrder ] } )
   else 
      ::getHashList():sort( { | x, y | x[ oColumn:nCreationOrder ] < y[ oColumn:nCreationOrder ] } )
   end if 

   ::oBrowse:refresh()   

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD hashListFind()

   local cColumnOrder
   local uPatternSearch
   local oColumnOrder   := ::oBrowse:getColumnOrder()

   if empty( oColumnOrder )
      RETURN ( nil )
   end if 

   cColumnOrder         := oColumnOrder:cSortOrder 

   if empty( cColumnOrder )
      RETURN ( nil )
   end if 

   uPatternSearch       := alltrim( ::cGetSearch )

   if empty( uPatternSearch )
      RETURN ( nil )
   end if 

   do case
      case ( ::getHashList():fieldtype( cColumnOrder ) ) == "N"
         uPatternSearch := val( uPatternSearch )
      case ( ::getHashList():fieldtype( cColumnOrder ) ) == "C" .and. right( uPatternSearch, 1 ) != "*"
         uPatternSearch += "*"
   end case 

   ::getHashList():find( uPatternSearch, cColumnOrder, .t. )

   ::oBrowse:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD limpiarUnidades()

   aeval( ::oBrowse:aSelected,;
      {| nRecno | ::getHashList():goto( nRecno ),;
                  ::getHashList():fieldput( 'total_unidades', 0 ) } )

   ::oBrowse:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//
