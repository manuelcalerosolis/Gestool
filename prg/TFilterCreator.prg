#include "FiveWin.Ch"
#include "Factu.ch"
#include "Font.ch"
#include "Report.ch"
#include "MesDbf.ch"
#include "DbInfo.ch"
#include "Xbrowse.ch"

#define fldDescription						1
#define fldCondition 						2
#define fldValue 								3
#define fldNexo 								4

#define posDescription						1
#define posField 								2
#define posType 								3

//---------------------------------------------------------------------------//

CLASS TFilterCreator

   DATA oTShell

   DATA aFiltersName                         INIT {}

   DATA oFilterDialog
   DATA oFilterDatabase

   DATA aFilter                              INIT {}

   DATA aDescriptions                        INIT {}

   DATA cExpresionFilter
   DATA bExpresionFilter

	DATA cName 									      INIT "Filtro de pruebas"
	DATA cType 									      INIT ""

   DATA aStructure                           INIT {}

   DATA hNexo                                INIT  {  ""    => "",;
                                                      "Y"   => " .and. ",;
                                                      "O"   => " .or. " }

   DATA hConditions                          INIT  {  "Igual"        => " == ",;
                                                      "Distinto"     => " != ",;
                                                      "Mayor"        => " > ",;
                                                      "Menor"        => " < ",;
                                                      "Mayor igual"  => " >= ",;
                                                      "Menor igual"  => " <= ",;
                                                      "Contenga"     => " $ " }

	METHOD New()
   METHOD Init( oTShell )

   METHOD AddFilter()                        INLINE ( ::oFilterDialog:Dialog() )
   METHOD EditFilter( cFilterName )          INLINE ( ::oFilterDialog:Dialog( cFilterName ) ) 

   METHOD Dialog()                           INLINE ( ::oFilterDialog:Dialog() )

   METHOD Ready()                            INLINE ( !Empty( ::cType ) .and. !Empty( ::oFilterDatabase ) )

   METHOD FiltersName()
   METHOD SetFiltersName( aFilter )          INLINE ( ::aFiltersName := aFilter )
   METHOD GetFiltersName( )                  INLINE ( ::aFiltersName )

   METHOD ExpresionFilter( cFilterName )     INLINE ( ::oFilterDatabase:ExpresionFilter( cFilterName ) ) 
   METHOD ArrayFilter( cFilterName )         INLINE ( ::oFilterDatabase:ArrayFilter( cFilterName ) )

   METHOD BuildFilter( aFilter )
   METHOD BuildExpresion( cExpresionFilter )

	METHOD SetExpresion( bExpresion )	      INLINE ( ::bExpresionFilter := bExpresion )
	METHOD GetExpresion()	                  INLINE ( ::bExpresionFilter )

   METHOD SetTextExpresion( cExpresion )     INLINE ( ::cExpresionFilter := cExpresion )
   METHOD GetTextExpresion()                 INLINE ( ::cExpresionFilter )

   METHOD QuitExpresion()                    INLINE ( ::cExpresionFilter := "", ::bExpresionFilter := nil )

	METHOD SetFields( aFieldStructure ) 
   METHOD SetDatabase( oDatabase )           

	METHOD GetStructure() 					      INLINE ( ::aStructure )

   METHOD SetFilter( aFilter )               INLINE ( ::aFilter := aFilter )

	METHOD GetDescriptions() 				      INLINE ( if( Empty( ::aDescriptions ), ( ::aDescriptions := GetSubArray( ::aStructure, posDescription ) ), ), ::aDescriptions ) 
	METHOD GetFields() 						      INLINE ( if( Empty( ::aFields ), ( ::aFields := GetSubArray( ::aStructure, posField ) ), ), ::aFields )
	METHOD GetTypes()							      INLINE ( if( Empty( ::aTypes ), ( ::aTypes := GetSubArray( ::aStructure, posType ) ), ), ::aTypes )

   METHOD ScanStructure( cDescription, nPos )

   METHOD GetField( cDescription )           INLINE ( ::ScanStructure( cDescription, posField ) )
   METHOD GetType( cDescription )            INLINE ( ::ScanStructure( cDescription, posType ) )
   METHOD GetCondition( cCondition )         INLINE ( HGet( ::hConditions, cCondition ) )
   METHOD GetNexo( cNexo )                   INLINE ( HGet( ::hNexo, cNexo ) )

   METHOD SetFilterType( cType )             INLINE ( ::cType := cType, if( !Empty( ::oFilterDatabase ) .and. !Empty( cType ), ::oFilterDatabase:SetScope( cType ), ) )
   METHOD GetFilterType()                    INLINE ( ::cType )

   METHOD SetFilterDatabase( oDbf )          INLINE ( ::oFilterDatabase:SetDbf( oDbf ) )

   METHOD KillFilter()                       VIRTUAL

   METHOD End()                              INLINE ( ::oFilterDatabase:CloseFiles() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( ) CLASS TFilterCreator

   ::oFilterDatabase    := TFilterDatabase():New( Self )

   ::oFilterDatabase:OpenFiles()
   ::oFilterDatabase:SetScope( ::GetFilterType() )

   ::oFilterDialog       := TFilterDialog():New( Self )
   ::oFilterDialog:Dialog()

   ::oFilterDatabase:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Init( oTShell ) CLASS TFilterCreator

   ::oTShell            := oTShell

   ::oFilterDatabase    := TFilterDatabase():New( Self )
   ::oFilterDatabase:OpenFiles()

   ::oFilterDialog      := TFilterDialog():New( Self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetFields( aFieldStructure ) CLASS TFilterCreator

	local aField

	::aStructure        := {}

   for each aField in aFieldStructure

        if !Empty( aField[ 5 ] )
         aAdd( ::aStructure, { aField[ 5 ], aField[ 1 ], aField[ 2 ] } )
     	end if

   next
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetDatabase( oDatabase ) CLASS TFilterCreator

   local oField

   ::aStructure        := {}

   for each oField in oDatabase:aTField

      if !Empty( oField:cComment ) .and. !( oField:lCalculate ) .and. !( oField:lHide )
         aAdd( ::aStructure, { oField:cComment, oField:cName, oField:cType } )
      end if

   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ScanStructure( cDescription, nPos )

   local n
   local cValue   := ""

   n              := aScan( ::aStructure, {|a| a[ posDescription ] == cDescription } )
   if n != 0
      cValue      := ::aStructure[ n, nPos ]
   end if

RETURN ( cValue )

//---------------------------------------------------------------------------//

METHOD BuildFilter( aFilter ) CLASS TFilterCreator

   local a
   local cCondition

   if Empty( aFilter )
      RETURN .f.
   end if 

   CursorWait()

   ::SetTextExpresion( "" )

   ::SetFilter( aFilter )

   for each a in aFilter

      cCondition              := ::GetCondition( a[ fldCondition ] )

      if cCondition == " $ "
         ::cExpresionFilter   += cGetValue( a[ fldValue ], ::GetType( a[ fldDescription ] ) ) + cCondition + ::GetField( a[ fldDescription ] )  
      else
         ::cExpresionFilter   += ::GetField( a[ fldDescription ] ) + cCondition + cGetValue( a[ fldValue ], ::GetType( a[ fldDescription ] ) )
      end if 

      ::cExpresionFilter      += ::GetNexo( a[ fldNexo ] )

   next 

   ::BuildExpresion( ::cExpresionFilter )

   CursorWE()

RETURN ( ::bExpresionFilter != nil )

//---------------------------------------------------------------------------//

METHOD BuildExpresion( cExpresionFilter )

   ::bExpresionFilter         := Compile( cExpresionFilter )

   if Empty( ::bExpresionFilter )
      msgStop( "Expresión erronea " + cExpresionFilter, "Error!" )
   end if

RETURN ( ::bExpresionFilter != nil )

//---------------------------------------------------------------------------//

METHOD FiltersName() CLASS TFilterCreator

   ::SetFiltersName( ::oFilterDatabase:FiltersName() )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TReplaceCreator FROM TFilterCreator

   DATA cDbfReplace

   METHOD New()

   METHOD Init()

   METHOD SetDatabaseToReplace( cDbf )    INLINE ( ::cDbfReplace := cDbf )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TReplaceCreator

   ::oFilterDatabase   := TFilterDatabase():New( Self )

   ::oFilterDatabase:OpenFiles()
   ::oFilterDatabase:SetScope( ::GetFilterType() )

   ::oFilterDialog     := TReplaceDialog():New( Self )
   ::oFilterDialog:Dialog()

   ::oFilterDatabase:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Init( oTShell ) CLASS TReplaceCreator

   ::oTShell            := oTShell

   ::oFilterDatabase    := TFilterDatabase():New( Self )

   ::oFilterDatabase:OpenFiles()

   ::oFilterDialog      := TReplaceDialog():New( Self )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TFilterDialog

	CLASSDATA oDlg 

	DATA oFld
   DATA oBmp

   DATA cTitle                         INIT "Generador de filtros"
   DATA cResource                      INIT "FastFiltros"
   DATA cIcon                          INIT "Funnel_48_alpha" // Replace2_48_alpha

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
   METHOD QuitDialog()
   METHOD EndDialog()

   METHOD Save()     
   METHOD Load()          
   METHOD Delete()

   METHOD SetFilter( aArrayFilter )    INLINE ( ::oBrwFilter:SetFilter( aArrayFilter ) )
   METHOD GetFilter()                  INLINE ( ::oBrwFilter:aFilter )

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

   ::SetExpresion()

   ::HeaderDialog()

   ::FilterDialog()

   ::ReplaceDialog()
   
   ::AlmacenadosDialog()   

   ::ActivateDialog( cFilterName )

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

METHOD ActivateDialog( cFilterName ) CLASS TFilterDialog

      /*
      Botones de los filtros almacenados---------------------------------------
      */

      REDEFINE BUTTON ;
         ID          3 ;
         OF          ( ::oDlg );
         ACTION      ( ::QuitDialog() )

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ( ::oDlg );
         ACTION      ( ::EndDialog() )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ( ::oDlg );
         ACTION      ( ::oDlg:End() )

      ::oDlg:AddFastKey( VK_F5, {|| ::EndDialog() } )

   ::oDlg:Activate( , , , .t., , .t., {|| ::InitDialog( cFilterName ) } )

   ::oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InitDialog( cFilterName ) CLASS TFilterDialog

   if !Empty( cFilterName )   
      ::Load( cFilterName )
   end if          

   if !::Ready()
      ::oFld:aEnable := { .t., .f. }
   else 
      ::oBrwAlmacenados:GoTop()
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD QuitDialog() CLASS TFilterDialog

   ::oFilterCreator:QuitExpresion()
   
   ::oDlg:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EndDialog() CLASS TFilterDialog

   if ::oFilterCreator:BuildFilter( ::oBrwFilter:aFilter )
      ::oDlg:End( IDOK )
   end if          

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Save() CLASS TFilterDialog

   if ::oFilterCreator:BuildFilter( ::oBrwFilter:aFilter )
      ::oFilterDatabase:Save()
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Delete() CLASS TFilterDialog

   if ::oFilterDatabase:Del()
      ::oBrwAlmacenados:Refresh()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Load( cFilterName ) CLASS TFilterDialog

   local aArrayFilter   := ::oFilterDatabase:ArrayFilter( cFilterName ) 
      
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
   DATA cIcon                          INIT "Replace2_48_alpha"

   DATA oReplace
   DATA cReplace

   DATA oExpReplace
   DATA cExpReplace                    INIT Space( 100 )

   DATA lAllRecno                      INIT .f.

   METHOD GetField( cDescription )     INLINE ( ::oFilterCreator:GetField( cDescription ) )

   METHOD SetDatabaseToReplace( cDbf ) INLINE ( ::cDbfReplace := cDbf )

   METHOD ReplaceDialog()              

   METHOD ValidDialog()
   METHOD EndDialog()

   METHOD DbfReplace()                 INLINE ( ::oFilterCreator:cDbfReplace )
   METHOD ExpresionFilter()            INLINE ( ::oFilterCreator:bExpresionFilter )

END CLASS

//---------------------------------------------------------------------------//

METHOD ReplaceDialog() CLASS TReplaceDialog

   REDEFINE COMBOBOX ::oReplace VAR ::cReplace ;
      ITEMS    ::oFilterCreator:GetDescriptions();
      ID       80 ;
      OF       ::oDlg

   REDEFINE GET ::oExpReplace VAR ::cExpReplace ;
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

   if Empty( ::DbfReplace() )
      msgStop( "No hay bases de datos para reemplazar")
      RETURN ( .f. )
   end if          

   if !::oFilterCreator:BuildFilter( ::oBrwFilter:aFilter )
      RETURN ( .f. )
   end if          

RETURN .t.

//---------------------------------------------------------------------------//

METHOD EndDialog() CLASS TReplaceDialog

   local nRpl     := 0
   local cGetVal
   local nOrdAnt
   local nDbfRec
   local nFldPos

   if !::ValidDialog()
      RETURN .f.
   end if

   AutoMeterDialog( ::oDlg )
   
   SetTotalAutoMeterDialog( ( ::DbfReplace() )->( LastRec() ) )

   nDbfRec        := ( ::DbfReplace() )->( Recno() )
   nOrdAnt        := ( ::DbfReplace() )->( OrdSetFocus( 0 ) )
   nFldPos        := ( ::DbfReplace() )->( FieldPos( ::oFilterCreator:GetField( ::cReplace ) ) )

   if nFldPos != 0

      ( ::DbfReplace() )->( dbGoTop() )
      while !( ::DbfReplace() )->( eof() )

         cGetVal  := ( ::DbfReplace() )->( Eval( Compile( cGetValue( ::cExpReplace, ValType( ( ::DbfReplace() )->( FieldGet( nFldPos ) ) ) ) ) ) )

         if ::lAllRecno .or. ( ::DbfReplace() )->( Eval( ::ExpresionFilter() ) )
            
            if ( ::DbfReplace() )->( dbRLock() )
               ( ::DbfReplace() )->( FieldPut( nFldPos, cGetVal ) )
               ( ::DbfReplace() )->( dbUnLock() )
            end if
            
            ++nRpl

         end if

         SetAutoMeterDialog( ( ::DbfReplace() )->( Recno() ) )

         ( ::DbfReplace() )->( dbSkip() )

      end while

   end if

   ( ::DbfReplace() )->( OrdSetFocus( nOrdAnt ) )
   ( ::DbfReplace() )->( dbGoTo( nDbfRec ) )

   msgInfo( "Total de registros reemplazados " + Str( nRpl ), "Proceso finalizado." )

   EndAutoMeterDialog()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TBrowseFilter

   CLASSDATA aFilter                         INIT {}

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

   DATA hConditions 									INIT 	{ 	"N" 	=> {  "Value"        => 0,;
                                                                  "Edit"         => EDIT_GET_BUTTON,;
                                                                  "List"         => nil,;
                                                                  "Block"        => {| nRow, nCol, oBrw, nKey | msgStop( nRow ) },;
                                                                  "Conditions"   => { "Igual",;
                                                					         				   "Distinto",;
					                                                 					     	   "Mayor",;
               						                              					     	   "Menor",;
                              								                   		     	   "Mayor igual",;
                                                					         				   "Menor igual" } },;
                              					      	"C" 	=> {  "Value"        => Space( 100 ),;
                                                                  "Edit"         => EDIT_GET_BUTTON,;
                                                                  "List"         => nil,;
                                                                  "Block"        => {|| nil },;
                                                                  "Conditions"   => { 	"Igual",;
                                       									                     "Distinto",;
                                       									                     "Contenga" } },;
                              					      	"D"	=> {  "Value"        => GetSysDate(),;
                                                                  "Edit"         => EDIT_GET_BUTTON,;
                                                                  "List"         => nil,;
                                                                  "Conditions"   => {  "Igual",;
						                              					                        "Distinto",;
                  						            					                        "Mayor",;
                              											                        "Menor",;
						                              					                        "Mayor igual",;
                  						            					                        "Menor igual" } },;
                  						        				"L" 	=> {  "Value"        => "Si",;
                                                                  "Edit"         => EDIT_GET_LISTBOX,;
                                                                  "List"         => { "Si", "No" },;
                                                                  "Conditions"   => {  "Igual",;
                                       									                     "Distinto" } } }

	METHOD New( oDlg, oFilterCreator )

	METHOD SetDialog( oDlg ) 								INLINE ( ::oDlg := oDlg )

	METHOD SetStructure( aStructure ) 					INLINE ( ::aStructure := aStructure )
	METHOD GetStructure()									INLINE ( ::aStructure )
	METHOD GetStructurePos( nPos )						INLINE ( ::GetStructure()[ nPos ] )
	METHOD GetStructureType( cDescripcion )

	METHOD GetDescriptions() 								INLINE ( ::oFilterDialog:oFilterCreator:GetDescriptions() ) 
	METHOD GetDescriptionsPos( nPos ) 					INLINE ( ::GetDescriptions()[ nPos ] )

	METHOD GetFields() 										INLINE ( if( Empty( ::aFields ), ( ::aFields := GetSubArray( ::aStructure, posField ) ), ), ::aFields )
	METHOD GetTypes()											INLINE ( if( Empty( ::aTypes ), ( ::aTypes := GetSubArray( ::aStructure, posType ) ), ), ::aTypes )

	METHOD GetHashType( cType ) 					      INLINE ( HGet( ::hConditions, cType ) )
   METHOD GetValueType( cType )                    INLINE ( HGet( ::GetHashType( cType ), "Value" ) )
   METHOD GetEditType( cType )                     INLINE ( HGet( ::GetHashType( cType ), "Edit" ) )
   METHOD GetListType( cType )                     INLINE ( HGet( ::GetHashType( cType ), "List" ) )
   METHOD GetConditionsType( cType )               INLINE ( HGet( ::GetHashType( cType ), "Conditions" ) )
   METHOD GetBlockType( cType )                    INLINE ( HGet( ::GetHashType( cType ), "Block" ) )

	METHOD GetConditionsCaracter() 						INLINE ( HGet( ::GetHashType( "C" ), "Conditions" ) )
	METHOD GetConditionsCaracterPos( nPos ) 			INLINE ( ::GetConditionsCaracter()[ nPos ] )

	METHOD SetFilter( aFilter )
	METHOD SetFilterLine( nLine, nField )		
	METHOD SetFilterLineBrowse( nField, uValue )		INLINE ( ::SetFilterLine( ::oBrwFilter:nArrayAt, nField, uValue ) )

	METHOD GetFilter()
	METHOD GetFilterLine( nLine, nField )
	METHOD GetFilterLineBrowse( nField )				INLINE ( ::GetFilterLine( ::oBrwFilter:nArrayAt, nField ) )

   METHOD GetFilterTypeLineBrowse()                INLINE ( ::GetStructureType( ::GetFilterLineBrowse( fldDescription ) ) )

   METHOD AppendLine()                 				INLINE ( aAdd(::aFilter, { ::GetDescriptionsPos( 1 ), ::GetConditionsCaracterPos( 1 ), Space( 100 ), "" } ) )
   METHOD DeleteLine()
   METHOD InitLine()                               INLINE ( ::aFilter := {}, ::AppendLine(), ::oBrwFilter:SetArray( ::aFilter, , , .f. ) )
   METHOD ChangeLine()

	METHOD Activate()
	
	METHOD DescriptionsOnPostEdit( o, x, n )
	METHOD NexoOnPostEdit( o, x, n )

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

   if Empty( ::aFilter )
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

   ::oBrwFilter                  := TXBrowse():New( ::oDlg )

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
      :aEditListTxt              := ::GetDescriptions() 
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
      :bOnPostEdit               := {|o,x,n| ::NexoOnPostEdit( o, x, n ) } 
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DescriptionsOnPostEdit( o, uNewValue, n ) CLASS TBrowseFilter

   if IsNum( n ) .and. ( n != VK_ESCAPE )

      if !IsNil( uNewValue )
         
         if ::GetFilterLineBrowse( fldDescription ) != uNewValue

            ::SetFilterLineBrowse( fldDescription, uNewValue )

            ::SetFilterLineBrowse( fldValue, ::GetValueType( ::GetFilterTypeLineBrowse() ) )

            ::ChangeLine()

         end if 

      end if

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD NexoOnPostEdit( o, uValue, n ) CLASS TBrowseFilter

   if IsNum( n ) .and. ( n != VK_ESCAPE )

      ::SetFilterLineBrowse( fldNexo, uValue )
         
      if ( ::oBrwFilter:nArrayAt ) == len( ::aFilter ) .and. !Empty( uValue )
         ::AppendLine()
      end if 

      ::oBrwFilter:Refresh()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ChangeLine() CLASS TBrowseFilter

   local cType                      := ::GetFilterTypeLineBrowse()

   if !Empty( cType )
      ::oColCondicion:aEditListTxt  := ::GetConditionsType( cType )
      ::oColValor:nEditType         := ::GetEditType( cType )
      ::oColValor:aEditListTxt      := ::GetListType( cType )
   end if 

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

   ::oBrwAlmacenados                   := TXBrowse():New( ::oDlg )
   
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
   
CLASS TFilterDatabase FROM TMant

   DATA  cType
   DATA  oFilterCreator  

   DATA  cFilterName                   INIT Space( 100 )
   DATA  lDefault                      INIT .f.
   DATA  lAllUser                      INIT .t.

   METHOD New() 
   METHOD End()                        INLINE ( ::CloseFiles() )

   METHOD DefineFiles()
   METHOD OpenFiles( lExclusive )

   METHOD SetScope( uScope )

   METHOD Save()
   METHOD Delete()                     INLINE ( ::oDbf:Delete() )

   METHOD Dialog()
   METHOD lValidDialog() 

   METHOD SeekFullKey( cFilterName )

   METHOD SerializeFilter()
   METHOD UnSerializeFilter()

   METHOD FiltersName()

   METHOD ExpresionFilter( cFilterName )
   METHOD ArrayFilter( cFilterName )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oFilterCreator ) CLASS TFilterDatabase

   ::oFilterCreator  := oFilterCreator

RETURN ( Self )   

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TFilterDatabase

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT lExclusive  := .f.
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )   
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError )  )

      ::CloseFiles()
      
      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TFilterDatabase

   local oDbf

   DEFAULT cPath        := cPatDat()
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE oDbf FILE "CnfFlt.Dbf" CLASS "CnfFlt" ALIAS "CnfFlt" PATH ( cPath ) VIA ( cDriver ) COMMENT "Filtros"

      FIELD NAME "cTipDoc" TYPE "C" LEN   2 DEC 0 COMMENT "Tipo de documento"             OF oDbf
      FIELD NAME "cCodUsr" TYPE "C" LEN   3 DEC 0 COMMENT "Usuario"                       OF oDbf
      FIELD NAME "cTexFlt" TYPE "C" LEN 100 DEC 0 COMMENT "Descripción"                   OF oDbf
      FIELD NAME "cFldFlt" TYPE "M" LEN  10 DEC 0 COMMENT "Texto largo de la nota"        OF oDbf
      FIELD NAME "cExpFlt" TYPE "M" LEN  10 DEC 0 COMMENT "Expresión del filtro"          OF oDbf
      FIELD NAME "lDefFlt" TYPE "L" LEN   1 DEC 0 COMMENT "Lógico de filtro por defecto"  OF oDbf

      INDEX TO "CnfFlt.Cdx" TAG "cTipDoc" ON "cTipDoc + Upper( cTexFlt )" COMMENT "Código" NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD SetScope( uScope )

   ::oDbf:SetScope( uScope, uScope ) 
   ::oDbf:GoTop()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SerializeFilter( aFilter ) CLASS TFilterDatabase

   local cLineFilter
   local aLineFilter
   local cSerializeFilter  := ""

   for each aLineFilter in aFilter
      for each cLineFilter in aLineFilter
         cSerializeFilter  += Alltrim( cValToChar( cLineFilter ) ) + ","
      next
   next

RETURN ( cSerializeFilter )

//----------------------------------------------------------------------------//

METHOD UnSerializeFilter( cFilterSerialized ) CLASS TFilterDatabase

   local cFilter
   local aFilter
   local aSerializedFilter

   DEFAULT cFilterSerialized  := ::oDbf:cFldFlt

   aSerializedFilter          := hb_ATokens( cFilterSerialized, "," )

   aFilter                    := { {} }

   for each cFilter in aSerializedFilter
      
      aAdd( aTail( aFilter ), cFilter )

      if ( mod( hb_EnumIndex(), 4 ) == 0 )
         aAdd( aFilter, {} )
      end if 

   next 
   
   aSize( aFilter, len( aFilter ) - 1 )
   
RETURN ( aFilter )

//----------------------------------------------------------------------------//

METHOD Save() CLASS TFilterDatabase

   if ::Dialog()

      if !Empty( ::cFilterName ) .and. ::SeekFullKey( ::cFilterName )
         ::oDbf:Delete()
      end if 

      ::oDbf:Blank()
      ::oDbf:cTipDoc    := ::oFilterCreator:GetFilterType()
      ::oDbf:cTexFlt    := ::cFilterName
      ::oDbf:cExpFlt    := ::oFilterCreator:cExpresionFilter
      ::oDbf:lDefFlt    := ::lDefault
      ::oDbf:cFldFlt    := ::SerializeFilter( ::oFilterCreator:aFilter )
      ::oDbf:Insert()

   end if 
   
RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog() CLASS TFilterDatabase

   local oDlg

   ::cFilterName  := Padr( ::cFilterName, 100 )

   DEFINE DIALOG oDlg RESOURCE "Nombre_Filtro"

   REDEFINE GET ::cFilterName ;
      ID          100 ;
      PICTURE     "@!" ;
      OF          oDlg

   REDEFINE CHECKBOX ::lDefault ;
      ID          110 ;
      OF          oDlg

   REDEFINE CHECKBOX ::lAllUser ;
      WHEN        ( oUser():lAdministrador() );
      ID          120 ;
      OF          oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      ACTION      ( ::lValidDialog( oDlg ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      ACTION      ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::lValidDialog( oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lValidDialog( oDlg ) CLASS TFilterDatabase

   if Empty( ::cFilterName )
      
      MsgStop( "El nombre del filtro no puede estar vacio" )

      RETURN ( .f. )

   else
      
      oDlg:End( IDOK )

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD FiltersName( cFilterType ) CLASS TFilterDatabase

   local aFilter        := {} 
   
   DEFAULT cFilterType  := ::oFilterCreator:GetFilterType()

   if ::oDbf:Seek( cFilterType )
      while ( ::oDbf:cTipDoc == cFilterType ) .and. !( ::oDbf:Eof() )
         aAdd( aFilter, ::oDbf:cTexFlt )
         ::oDbf:Skip()
      end while
   end if 

RETURN ( aFilter )

//---------------------------------------------------------------------------//

METHOD ExpresionFilter( cFilterName ) CLASS TFilterDatabase

   local cFilterExpresion  := ""

   if ::SeekFullKey( cFilterName )
      cFilterExpresion     := ::oDbf:cExpFlt
   end if 

RETURN ( cFilterExpresion )

//---------------------------------------------------------------------------//

METHOD ArrayFilter( cFilterName ) CLASS TFilterDatabase
   
   local aArrayFilter      := nil

   if ::SeekFullKey( cFilterName )
      aArrayFilter         := ::UnSerializeFilter()
   end if 

RETURN ( aArrayFilter )

//---------------------------------------------------------------------------//

METHOD SeekFullKey( cFilterName ) CLASS TFilterDatabase
   
   if !Empty( cFilterName )
      RETURN ( ::oDbf:Seek( ::oFilterCreator:GetFilterType() + cFilterName ) )
   end if

RETURN .t.

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

