#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS AjustableView FROM SQLBaseView

   DATA oExplorerBar

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   local oBmp
   local oBtnAceptar

   DEFINE DIALOG     ::oDialog ;
      TITLE          "Configuraciones" ;
      RESOURCE       "AJUSTES"

      REDEFINE BITMAP oBmp ;
         ID          500 ;
         RESOURCE    "gc_wrench_48" ;
         TRANSPARENT ;
         OF          ::oDialog

      REDEFINE EXPLORERBAR ::oExplorerBar ;
         ID          100 ;
         OF          ::oDialog

      ::oExplorerBar:nBottomColor  := RGB( 255, 255, 255 )
      ::oExplorerBar:nTopColor     := RGB( 255, 255, 255 )

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

      ::oDialog:bStart        := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   oBmp:End()

RETURN ( ::oDialog:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD StartActivate()

   local oPanel
   local cName       := "test"   

   oPanel            := ::oExplorerBar:AddPanel( "One" )
   oPanel:nClrHover  := RGB( 0, 0, 0 )
   oPanel:nClrText   := RGB( 0, 0, 0 )
   oPanel:SetColor( nRGB( 255, 255, 255 ), nRGB( 255, 255, 255 ) )

   @ 34, 10 SAY "This a say" OF oPanel PIXEL COLOR RGB( 0,0,0), RGB(255,255,255)
   @ 34, 120 GET cName SIZE 200, 18 OF oPanel PIXEL

   @ 64, 10 SAY "This a say" OF oPanel PIXEL COLOR RGB( 0,0,0), RGB(255,255,255)
   @ 64, 120 GET cName SIZE 200, 18 OF oPanel PIXEL

RETURN ( self )

//--------------------------------------------------------------------------//

METHOD ChangeBrowse()

   eval( hget( ::hFormatoColumnas, hget( ::oExplorerBar:aArrayData[ ::oExplorerBar:nArrayAt ], "tipo" ) ) )

   ::oCol:bOnPostEdit            := {|o,x,n| hset( ::oExplorerBar:aArrayData[ ::oExplorerBar:nArrayAt ], "valor", x ) }

RETURN ( self )

//--------------------------------------------------------------------------//
