#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS ConfiguracionesView FROM SQLBaseView

   DATA oBrw

   DATA oCol
   
   DATA oDialog

   DATA aItemSelected

   DATA comboDocumentCounter

   DATA getDocumentCounter

   DATA hFormatoColumnas

   DATA aItems                                  INIT {}

   METHOD New( oController )

   METHOD changeDocumentCounter()               INLINE ( .t. )

   METHOD Activate()

   METHOD StartActivate()

   METHOD ChangeBrowse()

   METHOD setItems( aItems )                    INLINE ( ::aItems := aItems )
   METHOD getItems()                            INLINE ( ::aItems )

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

   local oBmp
   local oBtnAceptar

   DEFINE DIALOG        ::oDialog ;
      TITLE             "Configuraciones" ;
      RESOURCE          "CONFIGURACIONES"

      REDEFINE BITMAP   oBmp ;
         ID             500 ;
         RESOURCE       "gc_wrench_48" ;
         TRANSPARENT ;
         OF             ::oDialog

      ::oBrw                  := IXBrowse():New( ::oDialog )

      ::oBrw:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrw:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrw:SetArray( ::getItems(), , , .f. )

      ::oBrw:nMarqueeStyle    := MARQSTYLE_HIGHLCELL
      ::oBrw:lRecordSelector  := .f.
      ::oBrw:lHScroll         := .f.
      ::oBrw:lFastEdit        := .t.

      ::oBrw:bChange          := {|| ::ChangeBrowse() }

      ::oBrw:CreateFromResource( 100 )

      with object ( ::oBrw:AddCol() )
         :cHeader             := "Propiedad"
         :bStrData            := {|| capitalize( hget( ::oBrw:aArrayData[ ::oBrw:nArrayAt ], "clave" ) ) }
         :nWidth              := 250
      end with

      ::oCol                  := ::oBrw:AddCol()
      ::oCol:cHeader          := "Valor"
      ::oCol:bEditValue       := {|| hGet( ::oBrw:aArrayData[ ::oBrw:nArrayAt ], "valor" ) }
      ::oCol:bStrData         := {|| hGet( ::oBrw:aArrayData[ ::oBrw:nArrayAt ], "valor" ) }
      ::oCol:nWidth           := 300

   REDEFINE BUTTON   oBtnAceptar ;
      ID             IDOK ;
      OF             ::oDialog ;
      ACTION         ( ::oDialog:End( IDOK ) )

   REDEFINE BUTTON  ;
      ID             IDCANCEL ;
      OF             ::oDialog ;
      CANCEL ;
      ACTION         ( ::oDialog:End( IDCANCEL ) )

      ::oDialog:AddFastKey( VK_F5, {|| oBtnAceptar:Click() } )

      ::oDialog:bStart        := {|| ::ChangeBrowse() }

   ACTIVATE DIALOG ::oDialog CENTER

   oBmp:End()

RETURN ( ::oDialog:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD StartActivate()

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD ChangeBrowse()

   eval( hget( ::hFormatoColumnas, hget( ::oBrw:aArrayData[ ::oBrw:nArrayAt ], "tipo" ) ) )

   ::oCol:bOnPostEdit            := {|o,x,n| hset( ::oBrw:aArrayData[ ::oBrw:nArrayAt ], "valor", x ) }

RETURN ( nil )

//--------------------------------------------------------------------------//
