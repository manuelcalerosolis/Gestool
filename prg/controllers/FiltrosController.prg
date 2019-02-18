#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS FiltrosController FROM SQLBrowseController

   DATA oSaveDialogView

   DATA aDescriptions                  INIT  {}

   DATA aStructure                     INIT  {}

   DATA aFilter                        INIT  {}

   DATA cName                          INIT space( 240 )

   DATA hNexo                          INIT  {  ""    => "",;
                                                "Y"   => " AND ",;
                                                "O"   => " OR " }

   DATA hOperators                     INIT  {  "Igual"        => " == ",;
                                                "Distinto"     => " != ",;
                                                "Mayor"        => " > ",;
                                                "Menor"        => " < ",;
                                                "Mayor igual"  => " >= ",;
                                                "Menor igual"  => " <= ",;
                                                "Contenga"     => " LIKE " }

   DATA cScope                         INIT  'albaranes_venta'

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Edit() 

   METHOD saveFilter()

   METHOD emptyFilter()  

   METHOD appendFilter()

   METHOD deleteFilter()

   METHOD isFilterSelected()

   METHOD deleteLineFilter( nLine )    INLINE ( adel( ::aFilter, nLine, .t. ) )

   METHOD loadStructure( hColumns )

   METHOD getStructureKey( cText )

   METHOD getStructureType( cText )    INLINE ( ::getStructureKey( cText, "type" ) )
   
   METHOD getStructureField( cText )   INLINE ( ::getStructureKey( cText, "field" ) )

   METHOD getTexts()        

   METHOD gettingSelectSentence()

   METHOD existName()                  INLINE ( ::getModel():existName( ::cName, ::cScope ) )

   METHOD toSQL()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := FiltrosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := FiltrosView():New( self ), ), ::oDialogView )

   METHOD getSaveDialogView()          INLINE ( iif( empty( ::oSaveDialogView ), ::oSaveDialogView := SaveFiltrosView():New( self ), ), ::oSaveDialogView )

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLFiltrosModel():New( self ), ), ::oModel )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FiltrosController

   ::Super:New( oController )

   ::cTitle                            := "Filtros"

   ::cName                             := "filtros"
   
   ::hImage                            := {  "16" => "gc_funnel_16",;
                                             "32" => "gc_funnel_32",;
                                             "48" => "gc_funnel_48" }

   ::loadStructure( SQLTercerosModel():getColumns() )

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

   ::getBrowseView():setEvent( 'doubleClicking', {|| .f. } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FiltrosController

   if !empty( ::oModel )
      ::oModel:End() 
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End() 
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oSaveDialogView )
      ::oSaveDialogView:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS FiltrosController

RETURN ( ::getModel():setGeneralWhere( "tabla = " + quoted( ::cScope ) ) )

//---------------------------------------------------------------------------//

METHOD loadStructure( hColumns ) CLASS FiltrosController

   heval( hColumns,;
      {|k,v| if( hhaskey( v, "text" ),; 
         aadd( ::aStructure,;
            {  "field"  => k,;
               "type"   => left( hget( v, "create" ), at( " ", hget( v, "create" ) ) - 1 ),;
               "text"   => hget( v, "text" ) } ), ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getStructureKey( cText, cKey ) CLASS FiltrosController

   local nPos

   DEFAULT cKey   := "type"

   nPos           := ascan( ::aStructure, {|h| hget( h, "text" ) == cText } )

   if nPos != 0
      RETURN ( hget( ::aStructure[ nPos ], cKey ) )
   end if

RETURN ( '' )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS FiltrosController

   ::emptyFilter()

   ::getDialogView():Activate()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD SaveFilter() CLASS FiltrosController

   local cFilter 

   ::cName        := space( 240 )

   if !( ::getSaveDialogView():Activate() )
      RETURN ( nil )
   end if 

   cFilter        := fw_valtoexp( ::aFilter )

   if empty( cFilter ) 
      RETURN ( nil )
   end if 

   if ::getModel():insertBuffer( { "tabla" => ::cScope, "nombre" => ::cName, "filtro" => cFilter } ) != 0

      successAlert( "Filtro guardado correctamente" )

      ::refreshRowSet()

      ::refreshBrowseView()

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isFilterSelected() CLASS FiltrosController

   local nId
   local hBuffer

   nId            := ::getBrowseView():getRowSet():fieldGet( 'id' )

   if empty( nId )
      RETURN ( .f. )
   end if 

   hBuffer        := ::getModel():loadCurrentBuffer( nId )

   if !empty( hBuffer )
      ::aFilter   := ( &( hget( hBuffer, "filtro" ) ) )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD deleteFilter() CLASS FiltrosController

   ::getModel():deleteSelection( ::getRowSet():idFromRecno( ::getBrowseView():getBrowseSelected() ) )

   ::refreshRowSet()

   ::refreshBrowseView()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD emptyFilter() CLASS FiltrosController

   ::aFilter      := {}

RETURN ( ::appendFilter() )

//---------------------------------------------------------------------------//

METHOD appendFilter() CLASS FiltrosController

   aadd( ::aFilter,;
      {  "text"      => hget( ::aStructure[ 1 ], "text" ),;
         "condition" => "Igual",;
         "value"     => space( 100 ),;
         "nexo"      => "" } )

RETURN ( ::aFilter )

//---------------------------------------------------------------------------//

METHOD getTexts() CLASS FiltrosController

   if !empty( ::aDescriptions )
      RETURN ( ::aDescriptions )
   end if 

   aeval( ::aStructure, {|h| aadd( ::aDescriptions, hget( h, "text" ) ) } )

RETURN ( ::aDescriptions ) 

//---------------------------------------------------------------------------//

METHOD toSQL() CLASS FiltrosController

   local cSql     
   local hFilter
   
   cSql     := ""

   if empty( ::aFilter )
      RETURN ( nil )
   end if 

   for each hFilter in ::aFilter 
      cSql  += ::getStructureField( hget( hFilter, "text" ) )
      cSql  += hget( ::hOperators, hget( hFilter, "condition" ) )
      cSql  += quoted( hget( hFilter, "value" ) )
      cSql  += hget( ::hNexo, hget( hFilter, "nexo" ) )
   next

RETURN ( cSql ) 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FiltrosView FROM SQLBaseView

   DATA oBrwFilter

   DATA oColCondicion

   DATA oColValor

   DATA oEditMemo    

   DATA hConditions

   METHOD Activate()

   METHOD StartActivate()

   METHOD getConditions()   

   METHOD getFilter()                  INLINE ( ::oController:aFilter )
   
   METHOD getFilterLine()              INLINE ( ::getFilter()[ ::oBrwFilter:nArrayAt ] )

   METHOD getStructure()               INLINE ( ::oController:aStructure )

   METHOD deleteLineFilter()

   METHOD textOnPostEdit( o, uNewValue, nKey )

   METHOD nexoOnPostEdit( o, uNewValue, nKey )

   METHOD getHashType( cType )         INLINE ( hget( ::getConditions(), alltrim( cType ) ) )

   METHOD getConditionsType( cType )   INLINE ( hget( ::getHashType( cType ), "conditions" ) )
   
   METHOD getEditType( cType )         INLINE ( hget( ::getHashType( cType ), "edit" ) )

   METHOD getListType( cType )         INLINE ( hget( ::getHashType( cType ), "list" ) )

   METHOD getConditionsCaracter()      INLINE ( ::getConditionsType( "VARCHAR" ) ) 

   METHOD getFilterLineText()          INLINE ( hget( ::getFilterLine(), "text" ) )

   METHOD setFilterLineText( uValue )  INLINE ( hset( ::getFilterLine(), "text", uValue ) )

   METHOD getFilterLineCondition()     INLINE ( hget( ::getFilterLine(), "condition" ) )

   METHOD setFilterLineCondition( uValue ) ;
                                       INLINE ( hset( ::getFilterLine(), "condition", uValue ) )

   METHOD getFilterLineValue()         INLINE ( hget( ::getFilterLine(), "value" ) )

   METHOD setFilterLineValue( uValue ) ;
                                       INLINE ( hset( ::getFilterLine(), "value", uValue ) )

   METHOD getFilterLineNexo()          INLINE ( hget( ::getFilterLine(), "nexo" ) )

   METHOD setFilterLineNexo( uValue )  INLINE ( hset( ::getFilterLine(), "nexo", uValue ) )

   METHOD changeFilterLine()

   METHOD saveFilter()                 INLINE ( ::oController:SaveFilter() )

   METHOD selectFilter()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS FiltrosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM" ;
      TITLE       "Filtros"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Filtros" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&Generador",;
                  "&Almacenados" ;
      DIALOGS     "FILTROS_DEFINICION",;
                  "FILTROS_DEFINICION"  

   TBtnBmp():ReDefine( 501, "new16", , , , , {|| ::oController:emptyFilter(), ::oBrwFilter:goTop() }, ::oFolder:aDialogs[ 1 ], .f., , .f., "Inicializar filtro" )

   TBtnBmp():ReDefine( 502, "del16", , , , , {|| ::deleteLineFilter() }, ::oFolder:aDialogs[ 1 ], .f., , .f., "Eliminar línea" )

   TBtnBmp():ReDefine( 503, "gc_floppy_disk_16", , , , , {|| ::saveFilter() }, ::oFolder:aDialogs[ 1 ], .f., , .f., "Guardar filtro" )

   ::oBrwFilter                  := IXBrowse():New( ::oFolder:aDialogs[ 1 ] )

   ::oBrwFilter:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwFilter:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwFilter:nDataType        := DATATYPE_ARRAY

   ::oBrwFilter:SetArray( ::oController:aFilter, , , .f. )

   ::oBrwFilter:lHScroll         := .f.
   ::oBrwFilter:lVScroll         := .f.
   ::oBrwFilter:lRecordSelector  := .t.
   ::oBrwFilter:lFastEdit        := .t.

   ::oBrwFilter:nMarqueeStyle    := 3
   ::oBrwFilter:nRowHeight       := 20

   ::oBrwFilter:bChange          := {|| ::changeFilterLine() }

   ::oBrwFilter:CreateFromResource( 200 )

   with object ( ::oBrwFilter:AddCol() )
      :cHeader                   := "Campo"
      :bEditValue                := {|| hget( ::oController:aFilter[ ::oBrwFilter:nArrayAt ], "text" ) }
      :nEditType                 := EDIT_LISTBOX
      :aEditListTxt              := ::oController:getTexts() 
      :nWidth                    := 240
      :bOnPostEdit               := {|o,x,n| ::textOnPostEdit( o, x, n ) } 
   end with
   
   with object ( ::oColCondicion := ::oBrwFilter:AddCol() )
      :cHeader                   := "Condicion"
      :bEditValue                := {|| hget( ::oController:aFilter[ ::oBrwFilter:nArrayAt ], "condition" ) }
      :nEditType                 := EDIT_LISTBOX
      :aEditListTxt              := ::getConditionsCaracter()
      :nWidth                    := 100
      :bOnPostEdit               := {|o,x,n| if( n != VK_ESCAPE, ::setFilterLineCondition( x ), ) } 
   end with

   with object ( ::oColValor := ::oBrwFilter:AddCol() )
      :cHeader                   := "Valor"
      :bEditValue                := {|| hget( ::oController:aFilter[ ::oBrwFilter:nArrayAt ], "value" ) }
      :nEditType                 := EDIT_GET
      :nWidth                    := 200
      :bOnPostEdit               := {|o,x,n| if( n != VK_ESCAPE, ::setFilterLineValue( x ), ) } 
   end with

   with object ( ::oBrwFilter:AddCol() )
      :cHeader                   := "Nexo"
      :bEditValue                := {|| hget( ::oController:aFilter[ ::oBrwFilter:nArrayAt ], "nexo" ) }
      :nEditType                 := EDIT_LISTBOX
      :aEditListTxt              := { "", "Y", "O" }
      :nWidth                    := 60
      :bOnPostEdit               := {|o,x,n| ::nexoOnPostEdit( o, x, n ) } 
   end with

   // Filtros almacenados -----------------------------------------------------

   TBtnBmp():ReDefine( 501, "new16", , , , , {|| ::SelectFilter() }, ::oFolder:aDialogs[ 2 ], .f., , .f., "Seleccionar filtro" )

   TBtnBmp():ReDefine( 502, "del16", , , , , {|| ::oController:deleteFilter() }, ::oFolder:aDialogs[ 2 ], .f., , .f., "Eliminar filtro" )

   TBtnBmp():ReDefine( 503, "Refresh16", , , , , {|| ::oController:refreshRowSet(), ::oController:refreshBrowseView() }, ::oFolder:aDialogs[ 2 ], .f., , .f., "Refrescar" )

   ::oController:Activate( 200, ::oFolder:aDialogs[2] )

   // Botones caja -------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::oDialog:end( IDOK ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oController:toSQL(), ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   ::oDialog:bStart     := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS FiltrosView

   ::changeFilterLine()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteLineFilter( nLine ) CLASS FiltrosView

   local nLenFilter  

   DEFAULT nLine     := ::oBrwFilter:nArrayAt

   nLenFilter        := len( ::oController:aFilter )

   if ( nLenFilter > 1 ) .and. ( nLine <= nLenFilter )
      ::oController:deleteLineFilter( nLine )
   end if 

   ::oBrwFilter:goUp()

   ::oBrwFilter:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getConditions() CLASS FiltrosView

   local hDate
   local hChars
   local hLogical
   local hNumerics   

   if empty( ::hConditions )

      hNumerics      := {  "value"        => 0,;
                           "edit"         => EDIT_GET_BUTTON,;
                           "list"         => nil,;
                           "block"        => {|| nil },;
                           "conditions"   => { "Igual", "Distinto", "Mayor", "Menor", "Mayor igual", "Menor igual" } }

      hChars         := {  "value"        => space( 100 ),;
                           "edit"         => EDIT_GET_BUTTON,;
                           "list"         => nil,;
                           "block"        => {|| nil },;
                           "conditions"   => { "Igual", "Distinto", "Contenga", "Mayor", "Menor", "Mayor igual", "Menor igual" } }     

      hDate          := {  "value"        => getSysDate(),;
                           "edit"         => EDIT_GET_BUTTON,;
                           "list"         => nil,;
                           "conditions"   => { "Igual", "Distinto", "Mayor", "Menor", "Mayor igual", "Menor igual" } }     

      hLogical       := {  "value"        => "Si",;
                           "edit"         => EDIT_GET_LISTBOX,;
                           "list"         => { "Si", "No" },;
                           "conditions"   => { "Igual", "Distinto" } }                                                          

      ::hConditions  := {  "DECIMAL"      => hNumerics,;
                           "INT"          => hNumerics,;
                           "INTEGER"      => hNumerics,;
                           "VARCHAR"      => hChars,;
                           "DATE"         => hDate,;
                           "TINYINT"      => hLogical }

   end if 

RETURN ( ::hConditions )

//---------------------------------------------------------------------------//

METHOD textOnPostEdit( o, uNewValue, nKey ) CLASS FiltrosView

   if !( hb_isnumeric( nKey ) .and. ( nKey != VK_ESCAPE ) )
      RETURN ( .t. )
   end if 

   if !( hb_ischar( uNewValue ) )
      RETURN ( .t. )
   end if 

   if ::getFilterLineText() != uNewValue

      ::setFilterLineText( uNewValue )

      // ::SetFilterLineBrowse( fldValue, ::GetValueType( ::GetFilterTypeLineBrowse() ) )

      ::changeFilterLine()

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD nexoOnPostEdit( o, uNewValue, nKey ) CLASS FiltrosView

   if !( hb_isnumeric( nKey ) .and. ( nKey != VK_ESCAPE ) )
      RETURN ( .t. )
   end if 

   if !( hb_ischar( uNewValue ) )
      RETURN ( .t. )
   end if

   ::setFilterLineNexo( uNewValue )

   if ( ::oBrwFilter:nArrayAt ) == len( ::oController:aFilter ) .and. !empty( uNewValue )
      ::oController:appendFilter()
   end if 

RETURN ( ::oBrwFilter:Refresh() )

//---------------------------------------------------------------------------//

METHOD changeFilterLine() CLASS FiltrosView

   local cType                   := ::oController:getStructureType( ::getFilterLineText() )

   if empty( cType )
      RETURN ( .t. )
   end if 

   ::oColCondicion:aEditListTxt  := ::getConditionsType( cType )
   
   ::oColValor:nEditType         := ::getEditType( cType )
   
   ::oColValor:aEditListTxt      := ::getListType( cType )

   ::oBrwFilter:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD selectFilter() CLASS FiltrosView

   if ::oController:isFilterSelected()

      ::oBrwFilter:setArray( ::oController:aFilter, , , .f. )

      ::oBrwFilter:goTop()

      ::oBrwFilter:Refresh() 

      ::oFolder:setOption( 1 )         
      
      successAlert( "El filtro se cargo correctamente" )   

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SaveFiltrosView FROM SQLBaseView

   METHOD Activate()
      METHOD validActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS SaveFiltrosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "NOMBRE_FILTRO" ;
      TITLE       "Guardar filtro"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_floppy_disk_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Introduzca el nombre del filtro" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:cName ;
      ID          100 ;
      OF          ::oDialog

   // Botones caja -------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::validActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::validActivate(), ) }
   
   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD validActivate() CLASS SaveFiltrosView

   if empty( ::oController:cName )
      ::oController:getSaveDialogView():showMessage( "El nombre del filtro no puede estar vacio." )
      RETURN ( .f. )
   end if 

   if ::oController:existName()
      ::showMessage( "El nombre del filtro ya existe." )
      RETURN ( .f. )
   end if 
  
   ::oDialog:end( IDOK )

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FiltrosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS FiltrosBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "nombre"
      :cHeader             := "Nombre"
      :nWidth              := 480
      :bEditValue          := {|| ::getRowSet():fieldGet( "nombre" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
