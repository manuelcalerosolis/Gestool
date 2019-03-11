#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS FiltrosController FROM SQLBrowseController

   DATA oSaveDialogView

   DATA hConditions

   DATA aDescriptions                  INIT  {}

   DATA aStructure                     INIT  {}

   DATA aFilter                        INIT  {}

   DATA cName                          INIT space( 240 )

   DATA hNexo                          INIT  {  ""    => "",;
                                                "Y"   => " AND ",;
                                                "O"   => " OR " }

   DATA hOperators                     INIT  {  "Igual"        => " = ",;
                                                "Distinto"     => " != ",;
                                                "Mayor"        => " > ",;
                                                "Menor"        => " < ",;
                                                "Mayor igual"  => " >= ",;
                                                "Menor igual"  => " <= ",;
                                                "Contenga"     => " LIKE ",;
                                                "No contenga"  => " NOT LIKE " }

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getConditions()
      METHOD getNumerics()
      METHOD getChars()
      METHOD getDate()
      METHOD getLogical()

   METHOD Edit() 

   METHOD isEditWithOutStored()

   METHOD saveFilter()

   METHOD deleteFilter()

   METHOD isSelected()

   METHOD isLoad( cTable, cFilterName )

   METHOD getFilters()

   METHOD isEmptyFilter()

   METHOD deleteLineFilter( nLine )    INLINE ( adel( ::aFilter, nLine, .t. ) )

   METHOD getStructure( hColumns )
      METHOD addToStructure( hColumns )

   METHOD getStructureKey( cText )

   METHOD getStructureType( cText )    INLINE ( ::getStructureKey( cText, "type" ) )
   
   METHOD getStructureField( cText )   INLINE ( ::getStructureKey( cText, "field" ) )

   METHOD getStructureAlias( cText )   INLINE ( ::getStructureKey( cText, "alias" ) )

   METHOD getTexts()        

   METHOD gettingSelectSentence()

   METHOD getTableName()               INLINE ( ::oController:getModel():cTableName )

   METHOD existName()                  INLINE ( ::getModel():existName( ::cName, ::getTableName() ) )

   METHOD getHashType( cType )         INLINE ( hget( ::getConditions(), alltrim( cType ) ) )

   METHOD getConvertType( cType )      INLINE ( hget( ::getHashType( cType ), "convert" ) )

   METHOD convertType( uValue, cType ) 

   METHOD setName( cName )             INLINE ( ::cName := padr( cName, 240 ) )
   METHOD getName( cName )             INLINE ( alltrim( ::cName ) )

   METHOD appendFieldAndValue( cField, uValue ) 

   METHOD getText() 

   METHOD getWhere()

   METHOD getWhereAnd()                

   METHOD initFilter()                 INLINE ( ::aFilter := {} )

   METHOD defaultFilter()              INLINE ( aadd( ::aFilter,;
                                                {  "text"      => hget( afirst( ::getStructure() ), "text" ),;
                                                   "condition" => "Igual",;
                                                   "value"     => "0",;
                                                   "nexo"      => "" } ) )

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

   ::getModel():setEvent( 'gettingSelectSentence', {|| ::gettingSelectSentence() } )

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

RETURN ( ::getModel():setGeneralWhere( "tabla = " + quoted( ::getTableName() ) ) )

//---------------------------------------------------------------------------//

METHOD getFilters( cTableToFilter ) CLASS FiltrosController                

RETURN ( ::getModel():getFilters( ::getTableName() ) )

//---------------------------------------------------------------------------//

METHOD isEmptyFilter() CLASS FiltrosController                

   if empty( ::aFilter ) 
      RETURN ( .t. )
   end if 

   if ( len( ::aFilter ) == 1 ) .and. ( empty( hget( ::aFilter[ 1 ], "value" ) ) )
      RETURN ( .t. )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD getStructure() CLASS FiltrosController

   if empty( ::aStructure )

      ::addToStructure( ::oController:getModel():getColumns(), ::oController:getModel():cTableName )

      if !empty( ::oController:getModel():getRelationsModels() )

         aeval( ::oController:getModel():getRelationsModels(), {|oModel| ::addToStructure( oModel:getColumns(), oModel:cTableName ) } )

      end if 

   end if 

RETURN ( ::aStructure )

//---------------------------------------------------------------------------//

METHOD addToStructure( hColumns, cTableName ) CLASS FiltrosController

   heval( hColumns,;
      {|k,v| if( hhaskey( v, "text" ),; 
         aadd( ::aStructure,;
            {  "field"  => k,;
               "alias"  => cTableName,;
               "type"   => if(   at( " ", hget( v, "create" ) ) != 0,;
                                 left( hget( v, "create" ), at( " ", hget( v, "create" ) ) - 1 ),;
                                 hget( v, "create" ) ),;
               "text"   => hget( v, "text" ) } ), ) } )

RETURN ( ::aStructure )

//---------------------------------------------------------------------------//

METHOD getStructureKey( cText, cKeyTo, cKeyFrom ) CLASS FiltrosController

   local nPos

   DEFAULT cKeyTo    := "type"
   DEFAULT cKeyFrom  := "text"

   nPos              := ascan( ::getStructure(), {|h| hget( h, cKeyFrom ) == alltrim( cText ) } )

   if nPos != 0
      RETURN ( hget( ::getStructure()[ nPos ], cKeyTo ) )
   end if

RETURN ( '' )

//---------------------------------------------------------------------------//

METHOD getNumerics() CLASS FiltrosController

RETURN ( {  "value"        => 0,;
            "edit"         => EDIT_GET,;
            "list"         => nil,;
            "block"        => {|| nil },;
            "convert"      => {| value | alltrim( value ) },;
            "conditions"   => { "Igual", "Distinto", "Mayor", "Menor", "Mayor igual", "Menor igual" } } )

//---------------------------------------------------------------------------//

METHOD getChars() CLASS FiltrosController

RETURN ( {  "value"        => space( 100 ),;
            "edit"         => EDIT_GET,;
            "list"         => nil,;
            "block"        => {|| nil },;
            "convert"      => {| value | quoted( value ) },;
            "conditions"   => { "Igual", "Distinto", "Contenga", "No contenga", "Mayor", "Menor", "Mayor igual", "Menor igual" } } )

//---------------------------------------------------------------------------//

METHOD getDate() CLASS FiltrosController

RETURN ( {  "value"        => getSysDate(),;
            "edit"         => EDIT_GET,;
            "list"         => nil,;
            "convert"      => {| value | quoted( hb_dtoc( value, 'yyyy-mm-dd' ) ) },;
            "conditions"   => { "Igual", "Distinto", "Mayor", "Menor", "Mayor igual", "Menor igual" } } )    

//---------------------------------------------------------------------------//

METHOD getLogical() CLASS FiltrosController

RETURN ( {  "value"        => "Si",;
            "edit"         => EDIT_GET_LISTBOX,;
            "list"         => { "Si", "No" },;
            "convert"      => {| value | if( value, "1", "0" ) },;
            "conditions"   => { "Igual", "Distinto" } } )    

//---------------------------------------------------------------------------//

METHOD getConditions() CLASS FiltrosController

   if empty( ::hConditions )

      ::hConditions  := {  "DECIMAL"      => ::getNumerics(),;
                           "INT"          => ::getNumerics(),;
                           "FLOAT"        => ::getNumerics(),;
                           "INTEGER"      => ::getNumerics(),;
                           "VARCHAR"      => ::getChars(),;
                           "ENUM"         => ::getChars(),;
                           "DATE"         => ::getDate(),;
                           "DATETIME"     => ::getDate(),;
                           "TINYINT"      => ::getLogical() }

   end if 

RETURN ( ::hConditions )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS FiltrosController

   if empty( ::aFilter )
      ::defaultFilter()
   end if 

RETURN ( ::getDialogView():Activate() )

//---------------------------------------------------------------------------//

METHOD isEditWithOutStored() CLASS FiltrosController

   if empty( ::aFilter )
      ::defaultFilter()
   end if 

RETURN ( ::getDialogView():ActivateWithOutStored() == IDOK )

//---------------------------------------------------------------------------//

METHOD SaveFilter() CLASS FiltrosController

   local cFilter 

   ::setName( ::getText() )

   if !( ::getSaveDialogView():Activate() )
      RETURN ( nil )
   end if 

   cFilter        := fw_valtoexp( ::aFilter )

   if empty( cFilter ) 
      RETURN ( nil )
   end if 

   if ::getModel():insertOnDuplicate( { "tabla" => ::getTableName(), "nombre" => ::cName, "filtro" => cFilter } ) != 0

      successAlert( "Filtro guardado correctamente" )

      ::refreshRowSet()

      ::refreshBrowseView()

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isSelected() CLASS FiltrosController

   local nId
   local cFilter

   nId            := ::getBrowseView():getRowSet():fieldGet( 'id' )

   if empty( nId )
      RETURN ( .f. )
   end if 

   cFilter        := ::getModel():getField( "filtro", "id", nId ) 

   if !empty( cFilter )
      ::aFilter   := ( &( cFilter ) )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isLoad( cTable, cFilterName ) CLASS FiltrosController

   local cFilter

   cFilter     := ::getModel():getFieldWhere( "filtro", { "tabla" => cTable, "nombre" => cFilterName } )

   if empty( cFilter )
      RETURN ( .f. )
   end if 

   ::aFilter   := ( &( cFilter ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD deleteFilter() CLASS FiltrosController

   ::getModel():deleteSelection( ::getRowSet():idFromRecno( ::getBrowseView():getBrowseSelected() ) )

   ::refreshRowSet()

   ::refreshBrowseView()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD appendFieldAndValue( cText, uValue ) CLASS FiltrosController

   if empty( cText )
      RETURN ( ::aFilter )
   end if 

   cText    := ::getStructureKey( cText, "text", "field" )
   if empty( cText )
      RETURN ( ::aFilter )
   end if 

   if ascan( ::aFilter, {|hFilter| hget( hFilter, "text" ) == cText } ) != 0
      RETURN ( ::aFilter )
   end if 

   aeval( ::aFilter, {|hFilter| hset( hFilter, "nexo", "Y" ) } )

   aadd( ::aFilter,;
      {  "text"      => cText,;
         "condition" => "Igual",;
         "value"     => uValue,;
         "nexo"      => "" } )

RETURN ( ::aFilter )

//---------------------------------------------------------------------------//

METHOD getTexts() CLASS FiltrosController

   if !empty( ::aDescriptions )
      RETURN ( ::aDescriptions )
   end if 

   aeval( ::getStructure(), {|h| aadd( ::aDescriptions, hget( h, "text" ) ) } )

RETURN ( ::aDescriptions ) 

//---------------------------------------------------------------------------//

METHOD convertType( uValue, cType ) CLASS FiltrosController

RETURN ( eval( ::getConvertType( cType ), uValue ) )

//---------------------------------------------------------------------------//

METHOD getWhere() CLASS FiltrosController

   local cSql     
   local hFilter
   
   if ::isEmptyFilter( ::aFilter )
      RETURN ( "" )
   end if 

   cSql     := " ( "

   for each hFilter in ::aFilter 
      cSql  += ::getStructureAlias( hget( hFilter, "text" ) ) + "." + ::getStructureField( hget( hFilter, "text" ) )
      cSql  += hget( ::hOperators, hget( hFilter, "condition" ) )
      cSql  += ::convertType( hget( hFilter, "value" ), ::getStructureType( hget( hFilter, "text" ) ) )
      cSql  += hget( ::hNexo, hget( hFilter, "nexo" ) )
   next

   cSql     += " ) "

RETURN ( cSql ) 

//---------------------------------------------------------------------------//

METHOD getText() CLASS FiltrosController

   local cText     
   
   if ::isEmptyFilter( ::aFilter )
      RETURN ( "" )
   end if 

   cText    := hget( afirst( ::aFilter ), "text" ) + space( 1 )
   cText    += hget( afirst( ::aFilter ), "condition" ) + space( 1 )
   cText    += cvaltostr( ( hget( afirst( ::aFilter ), "value" ) ) )

RETURN ( cText ) 

//---------------------------------------------------------------------------//

METHOD getWhereAnd()

   local cWhere   := ::getWhere()

   if empty( cWhere )
      RETURN ( cWhere )
   end if 

RETURN ( " AND " + cWhere )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FiltrosView FROM SQLBaseView

   DATA oBrwFilter

   DATA oColCondicion

   DATA oColValue

   DATA lShowStored                    INIT .t.    

   METHOD Activate()

   METHOD ActivateWithOutStored()      INLINE ( ::lShowStored := .f., ::Activate() )

   METHOD StartActivate()

   METHOD storedActivate()

   METHOD getFilter()                  INLINE ( ::oController:aFilter )

   METHOD getConditions()              INLINE ( ::oController:getConditions() )
   
   METHOD getFilterLine()              INLINE ( ::getFilter()[ ::oBrwFilter:nArrayAt ] )

   METHOD getStructure()               INLINE ( ::oController:getStructure() )

   METHOD deleteLineFilter()

   METHOD textOnPostEdit( o, uNewValue, nKey )

   METHOD nexoOnPostEdit( o, uNewValue, nKey )

   METHOD getHashType( cType )         INLINE ( hget( ::getConditions(), alltrim( cType ) ) )

   METHOD getConditionsType( cType )   INLINE ( hget( ::getHashType( cType ), "conditions" ) )

   METHOD getValueType( cType )        INLINE ( hget( ::getHashType( cType ), "value" ) )
   
   METHOD getEditType( cType )         INLINE ( hget( ::getHashType( cType ), "edit" ) )

   METHOD getListType( cType )         INLINE ( hget( ::getHashType( cType ), "list" ) )

   METHOD getConvertType( cType )      INLINE ( hget( ::getHashType( cType ), "convert" ) )

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

   METHOD getViewPrompt()              INLINE ( if( ::lShowStored, { "&Generador", "&Almacenados" }, { "&Generador" } ) )
   
   METHOD getViewDialogs()             INLINE ( if( ::lShowStored, { "FILTROS_DEFINICION", "FILTROS_DEFINICION" }, { "FILTROS_DEFINICION" } ) )
   
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

   ::oFolder      := TFolder():ReDefine( 500, ::getViewPrompt(), ::getViewDialogs(), ::oDialog, , , , , .f., )

   TBtnBmp():ReDefine( 501, "gc_broom_16", , , , , {|| ::oController:initFilter(), ::oBrwFilter:goTop() }, ::oFolder:aDialogs[ 1 ], .f., , .f., "Inicializar filtro" )

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

   with object ( ::oColValue := ::oBrwFilter:AddCol() )
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
   
   // Caja de filtros almacenados ---------------------------------------------

   ::storedActivate()

   // Botones caja ------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::oDialog:end( IDOK ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oController:initFilter(), ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   ::oDialog:bStart     := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD storedActivate() CLASS FiltrosView

   if !( ::lShowStored )
      RETURN ( nil )
   end if 

   TBtnBmp():ReDefine( 501, "gc_mouse_pointer_16", , , , , {|| ::SelectFilter() }, ::oFolder:aDialogs[ 2 ], .f., , .f., "Seleccionar filtro" )

   TBtnBmp():ReDefine( 502, "del16", , , , , {|| ::oController:deleteFilter() }, ::oFolder:aDialogs[ 2 ], .f., , .f., "Eliminar filtro" )

   TBtnBmp():ReDefine( 503, "Refresh16", , , , , {|| ::oController:refreshRowSet(), ::oController:refreshBrowseView() }, ::oFolder:aDialogs[ 2 ], .f., , .f., "Refrescar" )

   ::oController:Activate( 200, ::oFolder:aDialogs[ 2 ] )

   ::oController:getBrowseView():setLDblClick( {|| ::SelectFilter() } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS FiltrosView

   if empty( ::getFilter() ) 
      ::oController:initFilter()
   end if 

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

METHOD textOnPostEdit( o, uNewValue, nKey ) CLASS FiltrosView

   if !( hb_isnumeric( nKey ) .and. ( nKey != VK_ESCAPE ) )
      RETURN ( .t. )
   end if 

   if !( hb_ischar( uNewValue ) )
      RETURN ( .t. )
   end if 

   if ::getFilterLineText() != uNewValue

      ::setFilterLineText( uNewValue )

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
      
      sysrefresh()
      
      ::oController:defaultFilter()

   end if 

RETURN ( ::oBrwFilter:Refresh() )

//---------------------------------------------------------------------------//

METHOD changeFilterLine() CLASS FiltrosView

   local cType                   := ::oController:getStructureType( ::getFilterLineText() )

   if empty( cType )
      RETURN ( .t. )
   end if 

   ::oColCondicion:aEditListTxt  := ::getConditionsType( cType )
   
   ::setFilterLineValue( ::getValueType( cType ) )

   ::oColValue:nEditType         := ::getEditType( cType )

   ::oColValue:aEditListTxt      := ::getListType( cType )

   ::oBrwFilter:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD selectFilter() CLASS FiltrosView

   if ::oController:isSelected()

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

   if empty( ::oController:getName() )
      ::showMessage( "El nombre del filtro no puede estar vacio." )
      RETURN ( .f. )
   end if 

   if ::oController:existName() .and. !( msgYesNo( "El nombre del filtro ya existe", "¿Desea sobreescbirlo?" ) )
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
