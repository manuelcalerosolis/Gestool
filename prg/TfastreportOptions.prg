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
      METHOD setColPicture( uValue )      INLINE ( ::oColumnValue:cEditPicture   := uValue )
      METHOD setColListTxt( aValue )      INLINE ( ::oColumnValue:aEditListTxt   := aValue )
      METHOD columnPosEdit( o, x, n )

   	METHOD ChangeBrowse()

END CLASS
//--------------------------------------------------------------------------//

METHOD New() CLASS TFastReportOptions

   ::hOptions           := {  "Estado"                =>  { "Todos", "Finalizado", "No finalizado" },;
                              "Excluir importe cero"  => .f.,;
                              "Excluir unidades cero" => .f. }

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
      :bEditValue       := {|| hb_hValueAt( ::hOptions, ::oBrw:nArrayAt ) }
      :bStrData         := {|| hb_hValueAt( ::hOptions, ::oBrw:nArrayAt ) }
      :bOnPostEdit      := {|o,x,n| ::columnPosEdit( o, x, n ) }
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

   local valueColumn    := hb_hValueAt( ::hOptions, ::oBrw:nArrayAt )
   local valtypeColumn  := valtype( valueColumn )

   msgAlert( valtypeColumn )

   do case
      case valtypeColumn == 'A'
         
         debug( valueColumn, "valueColumn" )
         msgAlert( valueColumn[ 1 ], "valueColumn1" )

         ::setColType( EDIT_LISTBOX )
         ::setColListTxt( valueColumn ) 
         ::setColValue( valueColumn[ 1 ] )
         ::setColPicture( "" )

   end case

/*
   ::hFormatoColumnas      := {  "1" => {||  ::setColType( EDIT_GET ) ,;
                                             ::setColPicture( "" ) } ,;
                                 "2" => {||  ::setColType( EDIT_GET ) ,;
                                             ::setColPicture( NumPict( hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "longitud" ) + hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "decimales" ) - 1, hGet( ::aCamposExtra[ ::oBrw:nArrayAt ], "decimales" ), , .t. ) ) } ,;
                                 "3" => {||  ::setColType( EDIT_GET ) ,;
                                             ::setColPicture( "" ) } ,;
                                 "4" => {||  ::setColType( EDIT_LISTBOX ),;
                                             ::setColListTxt( { "si", "no" } ),;
                                             ::setColPicture( "" ) } ,;
*/


   // Eval( hGet( ::hOptions, AllTrim( Str( hGet( ::hOptions[ ::oBrw:nArrayAt ], "tipo" ) ) ) ) )

   // ::oCol:bOnPostEdit            := {|o,x,n| hSet( ::hOptions[ ::oBrw:nArrayAt ], "valor", x ) }

Return ( Self )

METHOD columnPosEdit( oColumn, uValue, n )

   msgAlert( uValue )

Return ( .t. )



