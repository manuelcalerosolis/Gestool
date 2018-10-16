#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS ConfiguracionesView FROM SQLBaseView

   DATA oBrw

   DATA oCol
   
   DATA oDialog

   DATA comboDocumentCounter

   DATA getDocumentCounter

   DATA hFormatoColumnas

   METHOD New( oController )

   METHOD changeDocumentCounter()               INLINE ( .t. )

   METHOD Activate()

   METHOD changeBrowse()

   METHOD setColType( uValue )                  INLINE ( ::oCol:nEditType := uValue )

   METHOD setColPicture( uValue )               INLINE ( ::oCol:cEditPicture := uValue )

   METHOD setColListTxt( aValue )               INLINE ( ::oCol:aEditListTxt := aValue )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController        := oController

   ::hFormatoColumnas   := {  "C"   => {||   ::setColType( EDIT_GET ) ,;
                                             ::setColPicture( "" ) } ,;
                              "N"   => {||   ::setColType( EDIT_GET ) ,;
                                             ::setColPicture( "999999999" ) } ,;
                              "D"   => {||   ::setColType( EDIT_GET ) ,;
                                             ::setColPicture( "@DT" ) } ,;
                              "L"   => {||   ::setColType( EDIT_LISTBOX ),;
                                             ::setColListTxt( { "si", "no" } ),;
                                             ::setColPicture( "" ) },;
                              "B"   => {||   ::setColType( EDIT_LISTBOX ),;
                                             ::setColListTxt( hGet( ::oBrw:aArrayData[ ::oBrw:nArrayAt ], "lista" ) ),;
                                             ::setColPicture( "" ) } }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG        ::oDialog ;
      TITLE             "Configuraciones" ;
      RESOURCE          "CONFIGURACIONES"

      REDEFINE BITMAP   ;
         ID             500 ;
         RESOURCE       "gc_wrench_48" ;
         TRANSPARENT ;
         OF             ::oDialog

      ::oBrw                  := IXBrowse():New( ::oDialog )

      ::oBrw:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrw:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrw:SetArray( ::oController:getItems(), , , .f. )

      ::oBrw:nMarqueeStyle    := MARQSTYLE_HIGHLCELL
      ::oBrw:lRecordSelector  := .f.
      ::oBrw:lHScroll         := .f.
      ::oBrw:lFastEdit        := .t.

      ::oBrw:bChange          := {|| ::changeBrowse() }

      ::oBrw:CreateFromResource( 100 )

      with object ( ::oBrw:AddCol() )
         :cHeader             := "Propiedad"
         :bStrData            := {|| capitalize( hget( ::oBrw:aArrayData[ ::oBrw:nArrayAt ], "texto" ) ) }
         :nWidth              := 250
      end with

      ::oCol                  := ::oBrw:AddCol()
      ::oCol:cHeader          := "Valor"
      ::oCol:bEditValue       := {|| hGet( ::oBrw:aArrayData[ ::oBrw:nArrayAt ], "valor" ) }
      ::oCol:bStrData         := {|| hGet( ::oBrw:aArrayData[ ::oBrw:nArrayAt ], "valor" ) }
      ::oCol:nWidth           := 300

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

      ::oDialog:bStart        := {|| ::changeBrowse() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD changeBrowse()

   eval( hget( ::hFormatoColumnas, hget( ::oBrw:aArrayData[ ::oBrw:nArrayAt ], "tipo" ) ) )

   ::oCol:bOnPostEdit         := {|o,x,n| hset( ::oBrw:aArrayData[ ::oBrw:nArrayAt ], "valor", x ) }

RETURN ( nil )

//--------------------------------------------------------------------------//
