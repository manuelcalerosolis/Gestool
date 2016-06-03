#include "FiveWin.ch"  
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"

// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastreportOptions 

	DATA hOptions 				INIT {=>}

   DATA oDlg
   DATA oBrw
	
   DATA oColumnValue

	METHOD New()   			CONSTRUCTOR
	METHOD setOptions()
	METHOD getOptions()

	METHOD Dialog()
      METHOD setColValue( uValue )        INLINE ( ::oColumnValue:Value          := uValue )
      METHOD setColType( uValue )         INLINE ( ::oColumnValue:nEditType      := uValue )
      METHOD setColEditListBound( uValue) INLINE ( ::oColumnValue:aEditListBound := uValue )
      METHOD setColPicture( uValue )      INLINE ( ::oColumnValue:cEditPicture   := uValue )
      METHOD setColListTxt( aValue )      INLINE ( ::oColumnValue:aEditListTxt   := aValue )
      METHOD columnPosEdit( o, x, n )

   	METHOD ChangeBrowse()

END CLASS
//--------------------------------------------------------------------------//

METHOD New() CLASS TFastReportOptions

   ::hOptions           := {  "Estado"                => {  "Values" => { "Todos", "Finalizado", "No finalizado" },;
                                                            "Value"  => "Todos" },;
                              "Excluir importe cero"  => {  "Values" => .f.,;
                                                            "Value"  => .f. },;
                              "Excluir unidades cero" => {  "Values" => .f.,;
                                                            "Value"  => .f. } }

Return ( self )

//---------------------------------------------------------------------------//

METHOD setOptions( hOptions ) CLASS TFastReportOptions

   ::hOptions 		:= hOptions

RETURN ( ::hOptions )

//---------------------------------------------------------------------------//

METHOD getOptions( key ) CLASS TFastReportOptions
		
	local cValor

	if hhaskey( ::hOptions, key ) 
      cValor         := hget( ::hOptions, key ) 
   end if 

RETURN ( cValor )

//---------------------------------------------------------------------------//

METHOD Dialog() CLASS TFastReportOptions
   
   local oCol

   DEFINE DIALOG ::oDlg RESOURCE "OPTIONSREPORT"

   ::oBrw                        := IXBrowse():New( ::oDlg )

   ::oBrw:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrw:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrw:SetArray( ::hOptions, , , .f. )

   ::oBrw:nMarqueeStyle          := MARQSTYLE_HIGHLCELL
   ::oBrw:lRecordSelector        := .f.
   ::oBrw:lHScroll               := .f.
   ::oBrw:lFastEdit              := .t.

   ::oBrw:bChange                := {|| ::ChangeBrowse() }

   ::oBrw:CreateFromResource( 100 )

   with object ( ::oBrw:AddCol() )
      :cHeader          := "Campo"
      :bStrData         := {|| hb_hKeyAt( ::hOptions, ::oBrw:nArrayAt ) }
      :nWidth           := 250
   end with

   with object ( ::oColumnValue := ::oBrw:AddCol() )
      :cHeader          := "Valor"
      :bEditValue       := {|| hget( hb_hValueAt( ::hOptions, ::oBrw:nArrayAt ), "Value" ) }
      :bStrData         := {|| hget( hb_hValueAt( ::hOptions, ::oBrw:nArrayAt ), "Value" ) }
      :bOnPostEdit      := {|o,x| ::columnPosEdit( o, x ) }
      :nWidth           := 300
   end with 

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		::oDlg ;
      ACTION   ( ::oDlg:end( IDOK ) )

 	REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		::oDlg ;
      CANCEL ;
		ACTION 	( ::oDlg:end() )

   ::oDlg:AddFastKey( VK_F5, {|| ::oDlg:end( IDOK ) } )

   ::oDlg:bStart        := {|| ::ChangeBrowse() }

   ACTIVATE DIALOG ::oDlg CENTER

Return ( ::oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD ChangeBrowse() CLASS TFastReportOptions

   local valuesColumn   := hget( hb_hValueAt( ::hOptions, ::oBrw:nArrayAt ), "Values" )
   local valueColumn    := hget( hb_hValueAt( ::hOptions, ::oBrw:nArrayAt ), "Value" )
   local valtypeColumn  := valtype( valuesColumn )

   do case
      case valtypeColumn == 'A'
         
         ::setColType( EDIT_LISTBOX )
         ::setColListTxt( valuesColumn ) 
         ::setColEditListBound( valuesColumn )

      case valtypeColumn == 'L'

         ::setColType( EDIT_LISTBOX )
         ::setColListTxt( { "Si", "No" } )
         ::setColEditListBound( { .t., .f. } )

   end case

Return ( Self )

//--------------------------------------------------------------------------//

METHOD columnPosEdit( oColumn, uValue ) CLASS TFastReportOptions

   hset( hb_hValueAt( ::hOptions, ::oBrw:nArrayAt ), "Value", uValue )

Return ( .t. )

//--------------------------------------------------------------------------//


