#include "FiveWin.ch"  
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"

// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastreportOptions 

	DATA hOptions 				INIT {=>}
	DATA aOptions				INIT {}
	DATA oBrw
	DATA oDlg

	METHOD New()   			CONSTRUCTOR
	METHOD setOptions()
	METHOD getOptions()
	METHOD Dialog()
	METHOD ChangeBrowse()

END CLASS
//--------------------------------------------------------------------------//

METHOD New() CLASS TFastReportOptions

	::hOptions				:= {  "Estado"                =>  { "Todos", "Finalizado", "No finalizado" },;
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

   msgalert( hb_valtoexp( ::aOptions ), "hOptions" ) 
   msgalert( valtype( ::aOptions ), "hOptions" ) 

   ::oBrw                        := IXBrowse():New( ::oDlg )

   ::oBrw:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrw:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   //::oBrw:SetArray( ::hOptions, , , .f. )

   ::oBrw:nMarqueeStyle          := MARQSTYLE_HIGHLCELL
   ::oBrw:lRecordSelector        := .f.
   ::oBrw:lHScroll               := .f.
   ::oBrw:lFastEdit              := .t.

   ::oBrw:bChange                := {|| msgalert( "bchangue" ) }//::ChangeBrowse() }

   ::oBrw:CreateFromResource( 100 )

   with object ( ::oBrw:AddCol() )
      :cHeader          := "Campo"
      :bStrData         := {|| "Nombre del campo" }//AllTrim( hGet( ::hOptions[ ::oBrw:nArrayAt ], "descripción" ) ) + if( hGet( ::hOptions[ ::oBrw:nArrayAt ], "lrequerido" ), " *", "" ) }
      :nWidth           := 250
   end with

   with object ( oCol := ::oBrw:AddCol() )
      :cHeader          := "Valor"
      :bEditValue       := {|| "Valor del campo" }//hGet( ::hOptions[ ::oBrw:nArrayAt ], "valor" ) }
      :bStrData         := {|| "Valor del campo" }//hGet( ::hOptions[ ::oBrw:nArrayAt ], "valor" ) }
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

  // ::oDlg:bStart        := {|| ::ChangeBrowse() }

   ACTIVATE DIALOG ::oDlg CENTER

Return ( ::oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD ChangeBrowse() CLASS TFastReportOptions

   Eval( hGet( ::hOptions, AllTrim( Str( hGet( ::hOptions[ ::oBrw:nArrayAt ], "tipo" ) ) ) ) )

   ::oCol:bOnPostEdit            := {|o,x,n| hSet( ::hOptions[ ::oBrw:nArrayAt ], "valor", x ) }

Return ( Self )
