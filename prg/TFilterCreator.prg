#include "FiveWin.Ch"
#include "Factu.ch"
#include "Font.ch"
#include "Report.ch"
#include "MesDbf.ch"
#include "DbInfo.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS TFilterCreator

	DATA cName 									INIT "Filtro de pruebas"
	DATA cType 									INIT FST_ART

	DATA hDescriptions						INIT { 	"Código" 	=> { "Codigo", 	"C" },;
																"Nombre"		=> { "Nombre", 	"C" },; 	
																"Importe"	=> { "Importe", 	"N" } }

	METHOD BuildFilter()
	METHOD LoadFilter( cFilterName )		VIRTUAL
	METHOD SaveFilter( cFilterName ) 	VIRTUAL
	METHOD DeleteFilter( cFilterName )	VIRTUAL

	METHOD SetExpresion( bExpresion )	INLINE ( ::bExpresion := bExpresion )
	METHOD GetExpresion( bExpresion )	INLINE ( ::bExpresion )

	METHOD SetFields( aFieldStructure ) 

	METHOD GetDescriptions() 				INLINE ( ::hDescriptions )
	METHOD GetFields() 						INLINE ( ::aFields )
	METHOD GetTypes()							INLINE ( ::aTypes )

END CLASS

METHOD BuildFilter() CLASS TFilterCreator

	local oFilterDialog 	:= TFilterDialog():New( Self )

	if !Empty( oFilterDialog )
		oFilterDialog:Show()
		::SetExpresion( oFilterDialog:bExpresion )
	end if 

RETURN ( Self )

METHOD SetFields( aFieldStructure ) CLASS TFilterCreator

	local oField

	::hDescriptions 		:= {=>}

   if !Empty( aFieldStructure )                              
   
      for each oField in aFieldStructure

         do case
         	case IsObject( oField )

            	if !Empty( oField:cComment ) .and. !( oField:lCalculate ) .and. !( oField:lHide )
   	            hSet( ::hDescriptions,  oField:cComment, { oField:cName, oField:cType } )
      	      end if

         	case IsArray( oFld )

            	if !Empty( oField[ 5 ] )
   	            hSet( ::hDescriptions,  oField[ 5 ], { oField[ 1 ], oField[ 2 ] } )
         	   end if

         end case

      next
   
   end if
	
RETURN ( Self )

//---------------------------------------------------------------------------//

CLASS TFilterDialog

	DATA oDlg 
	DATA oFld

	METHOD New( oFilterCreator )
	
	METHOD Dialog()
	METHOD InitDialog()
	METHOD ValidDialog()

END CLASS

METHOD New( oFilterCreator ) CLASS TFilterDialog

	::oFilterCreator 	:= oFilterCreator

RETURN ( Self )

METHOD Dialog() CLASS TFilterDialog

   local oBmp

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG ::oDlg RESOURCE "FastFiltros"

      REDEFINE FOLDER ::oFld ;
         ID       	100 ;
         OF       	::oDlg ;
         PROMPT   	"&Generador",;
                  	"&Almacenados";
         DIALOGS  	"FastFiltros_Definicion",;
                  	"FastFiltros_Almacenados"

      REDEFINE BITMAP oBmp ;
         ID       	500 ;
         RESOURCE 	"Funnel_48_alpha" ;
         TRANSPARENT ;
         OF       	::oDlg

      /*
      Clase para editar los filtros--------------------------------------------
      */

      ::oBrwFilter		:= TBrowseFilter():New( ::oFld:aDialogs[ 1 ], ::oFilterCreator )
      ::oBrwFilter:Activate()

      /*
      Browse de los filtros almacenados-------------------------------------------
      */
      
      ::oBrwAlmacenados	:= TBrowseAlmacenado():New( ::oFld:aDialogs[ 2 ], ::oFilterCreator )
      ::oBrwAlmacenados:Activate()

      /*
      Botones de los filtros almacenados---------------------------------------
      */

      REDEFINE BUTTON ;
         ID       	IDOK ;
         OF       	( ::oDlg );
         ACTION   	( ::ReturnFilter() )

      REDEFINE BUTTON ;
         ID       	IDCANCEL ;
         OF       	( ::oDlg );
         ACTION   	( ::oDlg:End() )

      ::oDlg:AddFastKey( VK_F5, {|| ::ReturnFilter() } )

   ::oDlg:Activate( , , , .t., , , {|| ::InitDialog() } )

   ::ValidDialog( oBmp )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InitDialog() CLASS TFilterDialog

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ValidDialog( oBmp ) CLASS TFilterDialog

   if ::oDlg:nResult != IDOK
      ::InitExpresion()
   end if

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
	
CLASS TBrowseFilter

	DATA oDlg

	DATA oBrwFilter

	DATA aFilter 										INIT {}
	DATA lSaveFilter 									INIT .t.

	DATA hDescriptions								INIT { 	"Código" 	=> { "Codigo", 	"C" },;
																		"Nombre"		=> { "Nombre", 	"C" },; 	
																		"Importe"	=> { "Importe", 	"N" } }



   DATA hNexo              						INIT 	{ 	"" 	=> "",;
   																	"Y" 	=> " .and. ",;
   																	"O" 	=> " .or. " }

   DATA hSimbolos          						INIT 	{ 	"Igual" 			=> " == ",;
                              					         "Distinto" 		=> " != ",;
                              					         "Mayor"			=> " > ",;
                              					         "Menor" 			=> " < ",;
                              					         "Mayor igual" 	=> " >= ",;
                              					         "Menor igual" 	=> " <= ",;
                              					         "Distinto" 		=>	" $ " }

   DATA hConditions 									INIT 	{ 	"Numerico" => 	{ 	"Igual",;
                              					         						"Distinto",;
					                              					         	"Mayor",;
               						             					         	"Menor",;
                              										         	"Mayor igual",;
                              					         						"Menor igual" },;
                              					      	"Caracter" => 	{ 	"Igual",;
                                       											"Distinto",;
                                       											"Contenga" },;
                              					      	"Fecha" => 		{  "Igual",;
						                              					         "Distinto",;
                  						            					         "Mayor",;
                              											         "Menor",;
						                              					         "Mayor igual",;
                  						            					         "Menor igual" },;
                  						        				"Logico" => 	{  "Igual",;
                                       											"Distinto" } }

	METHOD New( oDlg, oFilterCreator )

	METHOD SetDialog( oDlg ) 						INLINE ( ::oDlg := oDlg )

	METHOD SetDescriptions( hDescriptions ) 	INLINE ( ::hDescriptions := hDescriptions )
	METHOD SetFields( aFields )					INLINE ( ::aFields := aFields )
	METHOD SetTypes( aTypes )						INLINE ( ::aTypes := aTypes )

	METHOD Activate()

END CLASS
	
METHOD New( oDlg, oFilterCreator )

	::SetDialog( oDlg )

	::SetDescriptions( oFilterCreator:GetDescriptions() )
	::SetFields( oFilterCreator:GetFields() )
	::SetTypes( oFilterCreator:GetTypes() )

RETURN ( Self )

METHOD Activate()

   REDEFINE BUTTON ;
      ID       100 ;
      OF       ( oDlg );
      ACTION   ( ::CleanFilter() )

   REDEFINE BUTTON ;
      ID       120 ;
      OF       ( oDlg );
      ACTION   ( ::DeleteLine() )

   if ::lSaveFilter

   REDEFINE BUTTON ;
      ID       110 ;
      OF       ( oDlg );
      ACTION   ( ::SaveFilter() )

   end if 

   /*
   Browse de los rangos----------------------------------------------------------
   */

   ::oBrwFilter                  := TXBrowse():New( oDlg )

   ::oBrwFilter:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwFilter:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwFilter:SetArray( ::aFilter, , , .f. )

   ::oBrwFilter:lHScroll         := .f.
   ::oBrwFilter:lVScroll         := .f.
   ::oBrwFilter:lRecordSelector  := .t.
   ::oBrwFilter:lFastEdit        := .t.

   ::oBrwFilter:nFreeze          := 4
   ::oBrwFilter:nMarqueeStyle    := 3

   ::oBrwFilter:bChange          := {|| ::DescriptionsOnPostEdit() }

   ::oBrwFilter:CreateFromResource( 200 )

   with object ( ::oBrwFilter:AddCol() )
      :cHeader          := "Campo"
      :bEditValue       := {|| ::aFilter[ ::oBrwFilter:nArrayAt, 1 ] }
      :nEditType        := EDIT_LISTBOX
      :aEditListTxt     := ::hDescriptions
      :nWidth           := 240
      :bOnPostEdit      := {|o,x,n| ::DescriptionsOnPostEdit( o, x, n ) } 
   end with

   with object ( ::oColCondicion := ::oBrwFilter:AddCol() )
      :cHeader          := "Condicion"
      :bEditValue       := {|| ::aFilter[ ::oBrwFilter:nArrayAt, 2 ] }
      :nEditType        := EDIT_LISTBOX
      :aEditListTxt     := ::hConditions[ "Caracter" ]
      :nWidth           := 100
      :bOnPostEdit      := {|o,x,n| If( n != VK_ESCAPE, ::aFilter[ ::oBrwFilter:nArrayAt, 2 ] := x, ) } 
   end with

   with object ( ::oColValor := ::oBrwFilter:AddCol() )
      :cHeader          := "Valor"
      :bEditValue       := {|| ::aFilter[ ::oBrwFilter:nArrayAt, 3 ] }
      :nEditType        := EDIT_GET
      :nWidth           := 200
      :bOnPostEdit      := {|o,x,n| If( n != VK_ESCAPE, ::aFilter[ ::oBrwFilter:nArrayAt, 3 ] := x, ) } 
   end with

   with object ( ::oBrwFilter:AddCol() )
      :cHeader          := "Nexo"
      :bEditValue       := {|| ::aFilter[ ::oBrwFilter:nArrayAt, 4 ] }
      :nEditType        := EDIT_LISTBOX
      :aEditListTxt     := hGetKeys( ::hNexo )
      :nWidth           := 60
      :bOnPostEdit      := {|o,x,n| ::NexoOnPostEdit( o, x, n ) } 
   end with

RETURN ( Self )


METHOD NexoOnPostEdit( o, x, n ) 

   local nAt               := ::oBrwFilter:nArrayAt

   if IsNum( n ) .and. ( n != VK_ESCAPE )

      if !Empty( x )
      
         ::aFilter[ nAt, 4 ]  := x

         if ( nAt ) == len( ::aFilter ) 
            ::AppendLine()
         end if 

         ::oBrwFilter:Refresh()

      end if 

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DescriptionsOnPostEdit( o, x, n )

   local nPos
   local lCambio                          := .f.
   local nAt                              := ::oBrwFilter:nArrayAt

   if IsNum( n ) .and. ( n != VK_ESCAPE )

      if !IsNil( x )
         if ::aFilter[ nAt, 1 ] != x
            ::aFilter[ nAt, 1 ]           := x
            lCambio                       := .t.
         end if 
      end if

      nPos                                := aScan( ::aTblMask, ::aFilter[ nAt, 1 ] )
      if nPos != 0

         do case
            case ::aTblType[ nPos ] == "C"

               ::oColCondicion:aEditListTxt     := ::aTblConditionCaracter

               ::oColValor:nEditType            := EDIT_GET              

               if Empty( ::aFilter[ nAt, 3 ] ) .or. lCambio
                  ::aFilter[ nAt, 3 ]           := Space( 100 )
               end if 

            case ::aTblType[ nPos ] == "N"

               ::oColCondicion:aEditListTxt   := ::aTblConditionNumerico

               ::oColValor:nEditType            := EDIT_GET              

               if Empty( ::aFilter[ nAt, 3 ] ) .or. lCambio
                  ::aFilter[ nAt, 3 ]           := 0
               end if 

            case ::aTblType[ nPos ] == "D"
               
               ::oColCondicion:aEditListTxt   := ::aTblConditionFecha

               ::oColValor:nEditType            := EDIT_DATE       
               
               if Empty( ::aFilter[ nAt, 3 ] ) .or. lCambio
                  ::aFilter[ nAt, 3 ]           := Date()
               end if 
               
            case ::aTblType[ nPos ] == "L"

               ::oColCondicion:aEditListTxt   := ::aTblConditionLogico

               ::oColValor:aEditListTxt         := { "Si", "No" }

               ::oColValor:nEditType            := EDIT_GET_LISTBOX

               if Empty( ::aFilter[ nAt, 3 ] ) .or. lCambio
                  ::aFilter[ nAt, 3 ]           := "Si"
               end if 

            otherwise

               ::oColCondicion:aEditListTxt     := ::aTblCondition

         end case 

         ::oBrwFilter:Refresh()

      end if

   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//









