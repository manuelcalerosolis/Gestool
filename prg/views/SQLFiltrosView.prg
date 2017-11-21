#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Font.ch"
#include "Report.ch"
#include "MesDbf.ch"
#include "DbInfo.ch"
#include "Xbrowse.ch"

#define fldDescription                 1
#define fldCondition                   2
#define fldValue                       3
#define fldNexo                        4

#define posDescription                 1
#define posField                       2
#define posType                        3

//---------------------------------------------------------------------------//

CLASS SQLFilterView

   DATA oController

   DATA oDialog

   DATA oBmp

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

      REDEFINE BITMAP ::oBmp ;
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

   ::oBmp:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

