#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Xbrowse.ch"

#define fldDescription                 1
#define fldCondition                   2
#define fldValue                       3
#define fldNexo                        4

#define posDescription                 1
#define posField                       2
#define posType                        3

//---------------------------------------------------------------------------//

CLASS FiltrosController FROM SQLBaseController

   DATA aFiltersName                         INIT {}

   DATA oFilterDialog
   DATA oFilterDatabase

   DATA aFilter                              INIT {}

   DATA aDescriptions                        INIT {}

   DATA cExpresionFilter
   DATA bExpresionFilter

   DATA aStructure                           INIT  {}

   DATA hNexo                                INIT  {  ""    => "",;
                                                      "Y"   => " AND ",;
                                                      "O"   => " OR " }

   DATA hConditions                          INIT  {  "Igual"        => " == ",;
                                                      "Distinto"     => " != ",;
                                                      "Mayor"        => " > ",;
                                                      "Menor"        => " < ",;
                                                      "Mayor igual"  => " >= ",;
                                                      "Menor igual"  => " <= ",;
                                                      "Contenga"     => " LIKE " }

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Activate() 

   METHOD loadStructure( hColumns )

   METHOD getStructureType( cText )

   METHOD getTexts()            

   METHOD getFilter() 

   METHOD appendFilter()

   //Construcciones tardias----------------------------------------------------

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := FiltrosView():New( self ), ), ::oDialogView )

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLFiltrosModel():New( self ), ), ::oModel )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FiltrosController

   ::Super:New( oController )

   ::cTitle                            := "Filtros"

   ::cName                             := "filtros"
   
   ::hImage                            := {  "16" => "gc_object_cube_16",;
                                             "32" => "gc_object_cube_32",;
                                             "48" => "gc_object_cube_48" }

   ::loadStructure( SQLTercerosModel():getColumns() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FiltrosController

   if !empty( ::oModel )
      ::oModel:End() 
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

RETURN ( ::Super:End() )

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

METHOD getStructureType( cText ) CLASS FiltrosController

   local nPos

   nPos  := ascan( ::aStructure, {|h| hget( h, "text" ) == cText } )

   if nPos != 0
      RETURN ( hget( ::aStructure[ nPos ], "type" ) )
   end if

RETURN ( '' )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS FiltrosController

   ::getDialogView():loadConditions()

   ::getDialogView():Activate()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getTexts()

   if !empty( ::aDescriptions )
      RETURN ( ::aDescriptions )
   end if 

   aeval( ::aStructure, {|h| aadd( ::aDescriptions, hget( h, "text" ) ) } )

RETURN ( ::aDescriptions )

//---------------------------------------------------------------------------//

METHOD getFilter() CLASS FiltrosController

   if empty( ::aFilter )
      ::appendFilter()
   end if 

RETURN ( ::aFilter )

//---------------------------------------------------------------------------//

METHOD appendFilter() CLASS FiltrosController

   aadd( ::aFilter,;
      {  "text"      => hget( ::aStructure[ 1 ], "text" ),;
         "condition" => "Igual",;
         "value"     => space( 100 ),;
         "nexo"      => "" } )

RETURN ( ::aFilter )

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

   METHOD loadConditions()   

   METHOD getFilter()                  INLINE ( ::oController:getFilter() )

   METHOD getStructure()               INLINE ( ::oController:aStructure )

   METHOD textOnPostEdit( o, uNewValue, nKey )

   METHOD nexoOnPostEdit( o, uNewValue, nKey )

   METHOD getHashType( cType )         INLINE ( hget( ::hConditions, alltrim( cType ) ) )

   METHOD getConditionsType( cType )   INLINE ( hget( ::getHashType( cType ), "conditions" ) )

   METHOD getConditionsCaracter()      INLINE ( ::getConditionsType( "VARCHAR" ) ) 

   METHOD getEditType( cType )         INLINE ( hget( ::getHashType( cType ), "edit" ) )

   METHOD getListType( cType )         INLINE ( hget( ::getHashType( cType ), "list" ) )

   METHOD getFilterLineText()          INLINE ( hget( ::oBrwFilter:aRow, "text" ) )

   METHOD setFilterLineText( uValue )  INLINE ( hset( ::oBrwFilter:aRow, "text", uValue ) )

   METHOD getFilterLineCondition()     INLINE ( hget( ::oBrwFilter:aRow, "condition" ) )

   METHOD setFilterLineCondition( uValue ) ;
                                       INLINE ( hset( ::oBrwFilter:aRow, "condition", uValue ) )

   METHOD getFilterLineValue()         INLINE ( hget( ::oBrwFilter:aRow, "value" ) )

   METHOD setFilterLineValue( uValue ) ;
                                       INLINE ( hset( ::oBrwFilter:aRow, "value", uValue ) )

   METHOD getFilterLineNexo()          INLINE ( hget( ::oBrwFilter:aRow, "nexo" ) )

   METHOD setFilterLineNexo( uValue )  INLINE ( hset( ::oBrwFilter:aRow, "nexo", uValue ) )

   METHOD getFilterLineType()          INLINE ( ::getStructureType( ::GetFilterLineBrowse( fldDescription ) ) )

   METHOD changeFilterLine()

   METHOD getStructureType( cText )

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
      PROMPT      "&Generador" ;
      DIALOGS     "FILTROS_DEFINICION"  

   ::oBrwFilter                  := IXBrowse():New( ::oFolder:aDialogs[ 1 ] )

   ::oBrwFilter:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwFilter:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwFilter:SetArray( ::getFilter(), , , .f. )

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
      :bEditValue                := {|| hget( ::oBrwFilter:aRow, "text" ) }
      :nEditType                 := EDIT_LISTBOX
      :aEditListTxt              := ::oController:getTexts() 
      :nWidth                    := 240
      :bOnPostEdit               := {|o,x,n| ::textOnPostEdit( o, x, n ) } 
   end with
   
   with object ( ::oColCondicion := ::oBrwFilter:AddCol() )
      :cHeader                   := "Condicion"
      :bEditValue                := {|| hget( ::oBrwFilter:aRow, "condition" ) }
      :nEditType                 := EDIT_LISTBOX
      :aEditListTxt              := ::getConditionsCaracter()
      :nWidth                    := 100
      :bOnPostEdit               := {|o,x,n| if( n != VK_ESCAPE, ::setFilterLineCondition( x ), ) } 
   end with

   with object ( ::oColValor := ::oBrwFilter:AddCol() )
      :cHeader                   := "Valor"
      :bEditValue                := {|| hget( ::oBrwFilter:aRow, "value" ) }
      :nEditType                 := EDIT_GET
      :nWidth                    := 200
      :bOnPostEdit               := {|o,x,n| if( n != VK_ESCAPE, ::setFilterLineValue( x ), ) } 
   end with

   with object ( ::oBrwFilter:AddCol() )
      :cHeader                   := "Nexo"
      :bEditValue                := {|| hget( ::oBrwFilter:aRow, "nexo" ) }
      :nEditType                 := EDIT_LISTBOX
      :aEditListTxt              := { "", "Y", "O" }
      :nWidth                    := 60
      :bOnPostEdit               := {|o,x,n| ::nexoOnPostEdit( o, x, n ) } 
   end with

   // Botones caja -------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::oDialog:end( IDOK ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   ::oDialog:bStart     := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS FiltrosView

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadConditions() CLASS FiltrosView

   local hNumerics   := {  "value"        => 0,;
                           "edit"         => EDIT_GET_BUTTON,;
                           "list"         => nil,;
                           "block"        => {| nRow, nCol, oBrw, nKey | msgStop( nRow ) },;
                           "conditions"   => { "Igual", "Distinto", "Mayor", "Menor", "Mayor igual", "Menor igual" } }

   local hChars      := {  "value"        => space( 100 ),;
                           "edit"         => EDIT_GET_BUTTON,;
                           "list"         => nil,;
                           "block"        => {|| nil },;
                           "conditions"   => { "Igual", "Distinto", "Contenga", "Mayor", "Menor", "Mayor igual", "Menor igual" } }     

   local hDate       := {  "value"        => getSysDate(),;
                           "edit"         => EDIT_GET_BUTTON,;
                           "list"         => nil,;
                           "conditions"   => { "Igual", "Distinto", "Mayor", "Menor", "Mayor igual", "Menor igual" } }     

   local hLogical    := {  "value"        => "Si",;
                           "edit"         => EDIT_GET_LISTBOX,;
                           "list"         => { "Si", "No" },;
                           "conditions"   => { "Igual", "Distinto" } }                                                          

   ::hConditions     := {  "DECIMAL"      => hNumerics,;
                           "INT"          => hNumerics,;
                           "INTEGER"      => hNumerics,;
                           "VARCHAR"      => hChars,;
                           "DATE"         => hDate,;
                           "TINYINT"      => hLogical }

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

   if ( ::oBrwFilter:nArrayAt ) == len( ::getFilter() ) .and. !empty( uNewValue )
      ::oController:appendFilter()
   end if 

RETURN ( ::oBrwFilter:Refresh() )

//---------------------------------------------------------------------------//

METHOD changeFilterLine() CLASS FiltrosView

   local cType                   := ::oController:getStructureType( ::getFilterLineText() )

   if !empty( cType )
      RETURN ( .t. )
   end if 
      
   ::oColCondicion:aEditListTxt  := ::getConditionsType( cType )
   
   ::oColValor:nEditType         := ::getEditType( cType )
   
   ::oColValor:aEditListTxt      := ::getListType( cType )
    

   ::oBrwFilter:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getStructureType( cText )  CLASS FiltrosView

   local nPos 
   local cType := ""
   
   nPos        := ascan( ::getStructure(), {|h| alltrim( upper( hget( h, "text" ) ) ) == alltrim( upper( cText ) ) } )
   if nPos != 0
      cType    := ::GetStructure()[ nPos, posType ]
   end if 

RETURN ( cType ) 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TFilterDialog

	DATA oDlg // classdata

	DATA oFld
   DATA oBmp

   DATA cTitle                         INIT "Generador de filtros"
   DATA cResource                      INIT "FastFiltros"
   DATA cIcon                          INIT "gc_funnel_48"

   DATA cFilterName                    INIT ""

	DATA oFilterCreator
   DATA oFilterDatabase

	DATA oBrwFilter	
	DATA oBrwAlmacenados

	METHOD New( oFilterCreator )
	
	METHOD Dialog()
   METHOD HeaderDialog()
   METHOD ReplaceDialog()              VIRTUAL
   METHOD FilterDialog()
   METHOD AlmacenadosDialog()   
   METHOD ActivateDialog( cFilterName )

   METHOD InitDialog( cFilterName )
   METHOD okDialog()
   METHOD endDialog()

   METHOD Save()     
   METHOD Load()          
   METHOD Delete()

   METHOD SetFilter( aArrayFilter )    INLINE ( ::oBrwFilter:SetFilter( aArrayFilter ) )

   METHOD TitleFilter()                INLINE Rtrim( ::oFilterDatabase:oDbf:cTexFlt )

   METHOD SetExpresion( cExpresion )   INLINE ( ::oFilterCreator:SetExpresion( cExpresion ) )   
   METHOD Ready()                      INLINE ( ::oFilterCreator:Ready() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oFilterCreator ) CLASS TFilterDialog

	::oFilterCreator    := oFilterCreator

   ::oFilterDatabase   := oFilterCreator:oFilterDatabase

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog( cFilterName ) CLASS TFilterDialog

   ::cFilterName        := cFilterName

   ::SetExpresion()

   ::HeaderDialog()

   ::FilterDialog()

   ::ReplaceDialog()
   
   ::AlmacenadosDialog()   

   ::ActivateDialog()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD HeaderDialog() CLASS TFilterDialog

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG     ::oDlg ;
      TITLE          ( ::cTitle ) ;
      RESOURCE       ( ::cResource ) ;

      REDEFINE FOLDER ::oFld ;
         ID          100 ;
         OF          ::oDlg ;
         PROMPT      "&Generador",;
                     "&Almacenados";
         DIALOGS     "FastFiltros_Definicion",;
                     "FastFiltros_Almacenados"

      REDEFINE BITMAP ::oBmp ;
         ID          500 ;
         RESOURCE    ( ::cIcon ) ;
         TRANSPARENT ;
         OF          ::oDlg

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FilterDialog() CLASS TFilterDialog

   local oError
   local oBlock

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE


      /*
      Clase para editar los filtros--------------------------------------------
      */

      REDEFINE BUTTON ;
         ID          110 ;
         OF          ( ::oFld:aDialogs[ 1 ] );
         ACTION      ( ::Save() )

      ::oBrwFilter      := TBrowseFilter():New( Self )

      ::oBrwFilter:SetStructure( ::oFilterCreator:GetStructure() )
      ::oBrwFilter:Activate()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AlmacenadosDialog() CLASS TFilterDialog

      /*
      Browse de los filtros almacenados-------------------------------------------
      */

      REDEFINE BUTTON ;
         ID          100 ;
         OF          ( ::oFld:aDialogs[ 2 ] );
         ACTION      ( ::Load( ::oFilterDatabase:oDbf:cFldFlt ) )

      REDEFINE BUTTON ;
         ID          110 ;
         OF          ( ::oFld:aDialogs[ 2 ] );
         ACTION      ( ::Delete() )
      
      ::oBrwAlmacenados := TBrowseAlmacenado():New( Self )
      
      ::oBrwAlmacenados:SetDatabase( ::oFilterDatabase:oDbf )
      ::oBrwAlmacenados:Activate()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActivateDialog() CLASS TFilterDialog

      /*
      Botones de los filtros almacenados---------------------------------------
      */

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ( ::oDlg );
         ACTION      ( ::okDialog() )

      REDEFINE BUTTON ;
         CANCEL ;
         ID          IDCANCEL ;
         OF          ( ::oDlg );
         ACTION      ( ::endDialog() )

      ::oDlg:AddFastKey( VK_F5, {|| ::okDialog() } )

   ::oDlg:Activate( , , , .t., , .t., {|| ::InitDialog() } )

   ::oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InitDialog() CLASS TFilterDialog

   if !Empty( ::cFilterName )   
      ::Load( ::cFilterName )
   end if          

   if !::Ready()
      ::oFld:aEnable := { .t., .f. }
   else 
      ::oBrwAlmacenados:GoTop()
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD endDialog() CLASS TFilterDialog

   ::oFilterCreator:QuitExpresion()
   
   ::oDlg:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD okDialog() CLASS TFilterDialog

   if ::oFilterCreator:BuildFilter( ::oBrwFilter:aFilter )
      ::oDlg:End( IDOK )
   end if          

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Save() CLASS TFilterDialog

   if ::oFilterCreator:BuildFilter( ::oBrwFilter:aFilter )
      ::oFilterDatabase:Save( ::cFilterName )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Delete() CLASS TFilterDialog

   if ::oFilterDatabase:Del()
      ::oBrwAlmacenados:Refresh()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Load() CLASS TFilterDialog

   local aArrayFilter   := ::oFilterDatabase:ArrayFilter( ::cFilterName ) 
      
   if !Empty( aArrayFilter )
      ::SetFilter( aArrayFilter )
   end if 
      
   ::oDlg:cTitle( ::cTitle + " [" + ::TitleFilter() + "]" )

   ::oFld:SetOption( 1 )

RETURN ( Self )

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS TReplaceDialog FROM TFilterDialog

   DATA cTitle                         INIT "Reemplazar campos"
   DATA cResource                      INIT "FastReplace"
   DATA cIcon                          INIT "gc_arrow_circle2_48"

   DATA oReplace
   DATA cReplace

   DATA oExpReplace
   DATA cExpReplace                    INIT Space( 100 )

   DATA lAllRecno                      INIT .f.

   METHOD getField( cDescription )     INLINE ( ::oFilterCreator:GetField( cDescription ) )

   METHOD setDatabaseToReplace( cDbf ) INLINE ( ::cDbfReplace := cDbf )

   // Dialogos

   METHOD replaceDialog()              
      METHOD validDialog()
      METHOD okDialog()

   METHOD dbfReplace()                 INLINE ( ::oFilterCreator:cDbfReplace )
   METHOD getExpresionFilter( )            INLINE ( ::oFilterCreator:bExpresionFilter )

END CLASS

//---------------------------------------------------------------------------//

METHOD ReplaceDialog() CLASS TReplaceDialog

   REDEFINE COMBOBOX ::oReplace ;
      VAR      ::cReplace ;
      ITEMS    ::oFilterCreator:getTexts();
      ID       80 ;
      OF       ::oDlg

   REDEFINE GET ::oExpReplace ;
      VAR      ::cExpReplace ;
      ID       90 ;
      OF       ::oDlg

   REDEFINE CHECKBOX ::lAllRecno ;
      ID       70 ;
      ON CHANGE( if( ::lAllRecno, ::oFld:Hide(), ::oFld:Show() ) );
      OF       ::oDlg

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ValidDialog()

   if Empty( ::cReplace )
      msgStop( "El campo a reemplazar esta vacio")
      RETURN ( .f. )
   end if

   if Empty( ::cExpReplace )
      msgStop( "La expresión a reemplazar esta vacia")
      RETURN ( .f. )
   end if

   if Empty( ::dbfReplace() )
      msgStop( "No hay bases de datos para reemplazar")
      RETURN ( .f. )
   end if          

   if !::oFilterCreator:BuildFilter( ::oBrwFilter:aFilter )
      RETURN ( .f. )
   end if          

RETURN .t.

//---------------------------------------------------------------------------//

METHOD okDialog() CLASS TReplaceDialog

   local nRpl     := 0
   local cGetVal
   local nOrdAnt
   local nDbfRec
   local nFldPos

   if !::ValidDialog()
      msgStop( "Salida por dialogo invalido." )
      Return .f.
   end if

   AutoMeterDialog( ::oDlg )
   
   SetTotalAutoMeterDialog( ( ::dbfReplace() )->( LastRec() ) )

   nDbfRec        := ( ::dbfReplace() )->( Recno() )
   nOrdAnt        := ( ::dbfReplace() )->( OrdSetFocus( 0 ) )
   nFldPos        := ( ::dbfReplace() )->( FieldPos( ::oFilterCreator:GetField( ::cReplace ) ) )

   if nFldPos != 0

      ( ::dbfReplace() )->( dbGoTop() )
      while !( ::dbfReplace() )->( eof() )

         cGetVal  := ( ::dbfReplace() )->( Eval( Compile( cGetValue( ::cExpReplace, ValType( ( ::dbfReplace() )->( FieldGet( nFldPos ) ) ) ) ) ) )

         if ::lAllRecno .or. ( ::dbfReplace() )->( Eval( ::getExpresionFilter( ) ) )
            
            if ( ::dbfReplace() )->( dbRLock() )
               ( ::dbfReplace() )->( FieldPut( nFldPos, cGetVal ) )
               ( ::dbfReplace() )->( dbUnLock() )        
            end if
            
            ++nRpl

         end if

         SetAutoMeterDialog( ( ::dbfReplace() )->( Recno() ) )

         ( ::dbfReplace() )->( dbSkip() )

      end while

   end if

   ( ::dbfReplace() )->( OrdSetFocus( nOrdAnt ) )
   ( ::dbfReplace() )->( dbGoTo( nDbfRec ) )

   msgInfo( "Total de registros reemplazados " + Str( nRpl ), "Proceso finalizado." )

   EndAutoMeterDialog( ::oDlg )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TBrowseFilter

   DATA aFilter                              INIT  {} 

   DATA oFilterDialog

	DATA oDlg

   DATA oEditMemo

	DATA oBrwFilter
	
	DATA oColCondicion
	DATA oColValor

   DATA bExpresionFilter

	DATA aFields 										INIT {}
	DATA aTypes 										INIT {}

	DATA lSaveFilter 									INIT .t.

	DATA aStructure									INIT { 	{	"Código",	"Codigo", 	"C" },;
																		{	"Nombre", 	"Nombre", 	"C" },; 	
																		{	"Importe",	"Importe", 	"N" },;
                                                      {  "Fecha",    "Fecha",    "D" },;
                                                      {  "Lógico",   "Logico",   "L" } }


	METHOD New( oDlg, oFilterCreator )

	METHOD SetDialog( oDlg ) 								INLINE ( ::oDlg := oDlg )

	METHOD SetStructure( aStructure ) 					INLINE ( ::aStructure := aStructure )
	METHOD GetStructure()									INLINE ( ::aStructure )
	METHOD GetStructurePos( nPos )						INLINE ( ::GetStructure()[ nPos ] )
	METHOD GetStructureType( cDescripcion )

	METHOD getTexts() 								INLINE ( ::oFilterDialog:oFilterCreator:getTexts() ) 
	METHOD getTextsPos( nPos ) 					INLINE ( ::getTexts()[ nPos ] )

	METHOD GetFields() 										INLINE ( if( Empty( ::aFields ), ( ::aFields := GetSubArray( ::aStructure, posField ) ), ), ::aFields )
	METHOD GetTypes()											INLINE ( if( Empty( ::aTypes ), ( ::aTypes := GetSubArray( ::aStructure, posType ) ), ), ::aTypes )

	METHOD GetHashType( cType ) 					      INLINE ( HGet( ::hConditions, cType ) )
   METHOD GetValueType( cType )                    INLINE ( HGet( ::GetHashType( cType ), "Value" ) )
   METHOD GetEditType( cType )                     INLINE ( HGet( ::GetHashType( cType ), "Edit" ) )
   METHOD GetListType( cType )                     INLINE ( HGet( ::GetHashType( cType ), "List" ) )
   METHOD GetConditionsType( cType )               INLINE ( HGet( ::GetHashType( cType ), "Conditions" ) )
   METHOD GetBlockType( cType )                    INLINE ( HGet( ::GetHashType( cType ), "Block" ) )

	METHOD GetConditionsCaracter() 						INLINE ( hget( ::GetHashType( "C" ), "Conditions" ) )
	METHOD GetConditionsCaracterPos( nPos ) 			INLINE ( ::GetConditionsCaracter()[ nPos ] )

	METHOD SetFilter( aFilter )
	METHOD SetFilterLine( nLine, nField )		
	METHOD SetFilterLineBrowse( nField, uValue )		INLINE ( ::SetFilterLine( ::oBrwFilter:nArrayAt, nField, uValue ) )

	METHOD GetFilter()
	METHOD GetFilterLine( nLine, nField )
	METHOD GetFilterLineBrowse( nField )				INLINE ( ::GetFilterLine( ::oBrwFilter:nArrayAt, nField ) )

   METHOD GetFilterTypeLineBrowse()                INLINE ( ::GetStructureType( ::GetFilterLineBrowse( fldDescription ) ) )

   METHOD AppendLine()                 				INLINE ( aAdd(::aFilter, { ::getTextsPos( 1 ), ::GetConditionsCaracterPos( 1 ), Space( 100 ), "" } ) )
   METHOD DeleteLine()
   METHOD InitLine()                               INLINE ( ::aFilter := {}, ::AppendLine(), ::oBrwFilter:SetArray( ::aFilter, , , .f. ) )
   METHOD ChangeLine()

	METHOD Activate()
	
	METHOD textOnPostEdit( o, x, n )

END CLASS
	
//---------------------------------------------------------------------------//

METHOD New( oFilterDialog ) CLASS TBrowseFilter

   ::oFilterDialog   := oFilterDialog
   
   ::oEditMemo       := EditMemo()

	::SetDialog( ::oFilterDialog:oFld:aDialogs[ 1 ] )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GetStructureType( cDescripcion )  CLASS TBrowseFilter

	local nPos 
	local cType := ""
	
	nPos 			:= aScan( ::GetStructure(), {|a| Alltrim( Upper( a[ posDescription ] ) ) == Alltrim( Upper( cDescripcion ) ) } )
	if nPos != 0
		cType 	:= ::GetStructure()[ nPos, posType ]
	end if 

RETURN ( cType ) 

//---------------------------------------------------------------------------//

METHOD SetFilter( aFilter ) CLASS TBrowseFilter

	if !Empty( aFilter )
		::aFilter 	:= aFilter
	end if

   if !Empty( ::oBrwFilter )
      ::oBrwFilter:SetArray( ::aFilter )
   end if 
		 
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetFilterLine( nLine, nField, uValue )  CLASS TBrowseFilter

	::aFilter[ nLine, nField ] := uValue

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GetFilter()  CLASS TBrowseFilter

   if empty( ::aFilter )
      ::AppendLine()
   end if 

RETURN ( ::aFilter )

//---------------------------------------------------------------------------//

METHOD GetFilterLine( nLine, nField )  CLASS TBrowseFilter

RETURN ( ::GetFilter()[ nLine, nField ] )

//---------------------------------------------------------------------------//

METHOD DeleteLine() CLASS TBrowseFilter

   local nLineasFilter  := len( ::aFilter )

   if ( nLineasFilter > 1 ) .and. ( ::oBrwFilter:nArrayAt <= nLineasFilter )
      aDel( ::aFilter, ::oBrwFilter:nArrayAt, .t. ) 
      ::oBrwFilter:Refresh()
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TBrowseFilter

   REDEFINE BUTTON ;
      ID       100 ;
      OF       ( ::oDlg );
      ACTION   ( ::InitLine() )

   REDEFINE BUTTON ;
      ID       120 ;
      OF       ( ::oDlg );
      ACTION   ( ::DeleteLine() )

   ::oBrwFilter                  := IXBrowse():New( ::oDlg )

   ::oBrwFilter:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwFilter:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwFilter:SetArray( ::GetFilter(), , , .f. )

   ::oBrwFilter:lHScroll         := .f.
   ::oBrwFilter:lVScroll         := .f.
   ::oBrwFilter:lRecordSelector  := .t.
   ::oBrwFilter:lFastEdit        := .t.

   ::oBrwFilter:nMarqueeStyle    := 3

   ::oBrwFilter:bChange          := {|| ::ChangeLine() }

   ::oBrwFilter:CreateFromResource( 200 )

   with object ( ::oBrwFilter:AddCol() )
      :cHeader                   := "Campo"
      :bEditValue                := {|| ::aFilter[ ::oBrwFilter:nArrayAt, fldDescription ] }
      :nEditType                 := EDIT_LISTBOX
      :aEditListTxt              := ::getTexts() 
      :nWidth                    := 240
      :bOnPostEdit               := {|o,x,n| ::DescriptionsOnPostEdit( o, x, n ) } 
   end with

   with object ( ::oColCondicion := ::oBrwFilter:AddCol() )
      :cHeader                   := "Condicion"
      :bEditValue                := {|| Padr( ::aFilter[ ::oBrwFilter:nArrayAt, fldCondition ], 100 ) }
      :nEditType                 := EDIT_LISTBOX
      :aEditListTxt              := ::GetConditionsCaracter()
      :nWidth                    := 100
      :bOnPostEdit               := {|o,x,n| If( n != VK_ESCAPE, ::SetFilterLineBrowse( fldCondition, x ), ) } 
   end with

   with object ( ::oColValor := ::oBrwFilter:AddCol() )
      :cHeader                   := "Valor"
      :bEditValue                := {|| ::aFilter[ ::oBrwFilter:nArrayAt, fldValue ] }
      :nEditType                 := EDIT_GET_BUTTON
      :nWidth                    := 200
      :bOnPostEdit               := {|o,x,n| If( n != VK_ESCAPE, ::SetFilterLineBrowse( fldValue, x ), ) } 
      :bEditBlock                := {|n,c,o| ::oEditMemo:Show( o ) }
   end with

   with object ( ::oBrwFilter:AddCol() )
      :cHeader                   := "Nexo"
      :bEditValue                := {|| ::aFilter[ ::oBrwFilter:nArrayAt, fldNexo ] }
      :nEditType                 := EDIT_LISTBOX
      :aEditListTxt              := { "", "Y", "O" }
      :nWidth                    := 60
      :bOnPostEdit               := {|o,x,n| ::nexoOnPostEdit( o, x, n ) } 
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD textOnPostEdit( o, uNewValue, nKey ) CLASS TBrowseFilter

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE )

      if !IsNil( uNewValue ) .and. ValType( uNewValue ) == "C"
         
         if ::GetFilterLineBrowse( fldDescription ) != uNewValue

            ::SetFilterLineBrowse( fldDescription, uNewValue )

            ::SetFilterLineBrowse( fldValue, ::GetValueType( ::GetFilterTypeLineBrowse() ) )

            ::ChangeLine()

         end if 

      end if

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD changeLine() CLASS TBrowseFilter

   local cType                   := ::getFilterTypeLineBrowse()

   if empty( cType )
      RETURN ( .t. )
   end if 

   ::oColCondicion:aEditListTxt  := ::getConditionsType( cType )

   ::oColValor:nEditType         := ::getEditType( cType )

   ::oColValor:aEditListTxt      := ::getListType( cType )

   ::oBrwFilter:Refresh()

RETURN ( .t. )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TBrowseAlmacenado

   DATA  oFilterDialog

   DATA  oDlg
   DATA  oDbf

   DATA  oBrwAlmacenados

	METHOD New( oDlg, oFilterCreator ) 
	METHOD Activate() 						

   METHOD SetDialog( oDlg )                     INLINE ( ::oDlg := oDlg )
   METHOD SetDatabase( oDbf )                   INLINE ( ::oDbf := oDbf )

   METHOD GoTop()                               INLINE ( if( !Empty( ::oBrwAlmacenados ), ( ::oBrwAlmacenados:GoTop() ), ) )
   METHOD Refresh()                             INLINE ( if( !Empty( ::oBrwAlmacenados ), ( ::oBrwAlmacenados:Refresh() ), ) )

END CLASS
	
//---------------------------------------------------------------------------//

METHOD New( oFilterDialog ) CLASS TBrowseAlmacenado

   ::oFilterDialog   := oFilterDialog

   ::SetDialog( ::oFilterDialog:oFld:aDialogs[ 2 ] )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   ::oBrwAlmacenados                   := IXBrowse():New( ::oDlg )
   
   ::oBrwAlmacenados:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwAlmacenados:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   
   ::oBrwAlmacenados:nMarqueeStyle     := 5
   
   ::oBrwAlmacenados:lHScroll          := .f.
   ::oBrwAlmacenados:lVScroll          := .t.
   ::oBrwAlmacenados:lRecordSelector   := .t.
   
   ::oDbf:SetBrowse( ::oBrwAlmacenados )

   ::oBrwAlmacenados:bLDblClick        := {|| ::oFilterDialog:Load() }
   
   ::oBrwAlmacenados:CreateFromResource( 200 )
   
   with object ( ::oBrwAlmacenados:AddCol() )
      :cHeader                         := "Filtro"
      :bEditValue                      := {|| ::oDbf:FieldGetByName( "cTexFlt" ) }
      :nWidth                          := 600
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EditMemo

   DATA oDlg
   DATA oMemo 
   DATA cMemo

   METHOD SetMemo( oSender )  INLINE ( ::cMemo := oSender:VarGet() )
   METHOD Show()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Show( oSender ) CLASS EditMemo

   ::SetMemo( oSender )

   DEFINE DIALOG ::oDlg RESOURCE "EditMemo"

      REDEFINE GET   ::oMemo ;
         VAR         ::cMemo ;
         MEMO ;
         ID          100 ;
         OF          ::oDlg 

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ::oDlg ;
         ACTION      ( ::oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDlg ;
         ACTION      ( ::oDlg:end() )

      ::oDlg:AddFastKey( VK_F5, {|| ::oDlg:end( IDOK ) } )

   ACTIVATE DIALOG ::oDlg CENTER

   if ( ::oDlg:nResult == IDOK )
      oSender:VarPut( ::cMemo ) 
   end if

RETURN ( nil )

//----------------------------------------------------------------------------//

