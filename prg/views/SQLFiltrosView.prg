#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLFilterView FROM SQLBaseView

   DATA oName

   DATA oMemo

   METHOD New( oController ) 
   
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) 

   ::oController     := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "SQL_FILTER_VIEW" 

      REDEFINE BITMAP ::oBitmap ;
         ID          500 ;
         RESOURCE    ( "gc_funnel_48" ) ;
         TRANSPARENT ;
         OF          ::oDialog

      REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
         MEMO ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         VALID       ( ::oController:validate( "nombre" ) ) ;
         ID          100 ;
         OF          ::oDialog 

      REDEFINE GET   ::oController:oModel:hBuffer[ "filtro" ] ;
         MEMO ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         VALID       ( ::oController:validate( "filtro" ) ) ;
         ID          110 ;
         OF          ::oDialog 

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ::oDialog ;
         ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:end() )

      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCustomFilterView FROM SQLBaseView

   DATA oValue
   DATA cValue                   INIT space( 200 )

   DATA oText
   DATA cText                    INIT ""   

   METHOD New( oController ) 
   
   METHOD Activate()

   METHOD setValue( cValue )     INLINE ( ::cValue := padr( cValue, 200 ) )
   METHOD getValue()             INLINE ( ::cValue )

   METHOD setText( cText )       INLINE ( ::cText := cText )
   METHOD getText()              INLINE ( ::cText )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) 

   ::oController     := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "SQL_FILTER_CUSTOM" 

      REDEFINE BITMAP ::oBitmap ;
         ID          800 ;
         RESOURCE    ( "gc_funnel_48" ) ;
         TRANSPARENT ;
         OF          ::oDialog

      REDEFINE SAY   ::oText ;
         VAR         ::cText ;
         ID          100 ;
         OF          ::oDialog

      REDEFINE GET   ::oValue ;
         VAR         ::cValue ;
         VALID       ( !empty( ::cValue ) ) ;
         ID          110 ;
         OF          ::oDialog 

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:end( IDOK ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:end() )

      ::oDialog:AddFastKey( VK_F5, {|| ::oDialog:end( IDOK ) } )

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:End()

RETURN ( ::oDialog:nResult == IDOK )

//---------------------------------------------------------------------------//




