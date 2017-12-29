#include "FiveWin.Ch"
#include "Factu.ch"

/*
Hay que crear los campos extra necesarios para este script---------------------
*/

Function InfoCentroCoste( cCentroCoste )                  
         
   TInfCentroCoste():New( cCentroCoste )

Return nil

//---------------------------------------------------------------------------//  

CLASS TInfCentroCoste

   DATA oDialog
   DATA cCodigoCentroCoste

   METHOD New()

   METHOD SetResources()      INLINE ( SetResources( fullcurdir() + "Script\CentroCoste\InfoCentroCoste.dll" ) )

   METHOD FreeResources()     INLINE ( FreeResources() )

   METHOD Resource()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cCentroCoste ) CLASS TInfCentroCoste

   ::cCodigoCentroCoste       := cCentroCoste

   ::SetResources()

   ::Resource()  

   ::FreeResources()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Resource() CLASS TInfCentroCoste

   DEFINE DIALOG ::oDialog RESOURCE "CentroCoste" 

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:End( IDOK ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:End() )

      ::oDialog:AddFastKey( VK_F5, {|| ::oDialog:End( IDOK ) } )

   ACTIVATE DIALOG ::oDialog CENTER

Return ( .t. )

//---------------------------------------------------------------------------//