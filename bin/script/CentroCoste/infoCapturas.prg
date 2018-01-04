#include "FiveWin.Ch"
#include "Factu.ch"

/*
Hay que crear los campos extra necesarios para este script---------------------
*/

Function InfoCapturas( cCentroCoste )                  
         
   TInfCapturas():New( cCentroCoste )

Return nil

//---------------------------------------------------------------------------//  

CLASS TInfCapturas

   DATA oDialog

   DATA oCodigoCentroCoste
   DATA cCodigoCentroCoste

   DATA oNombreCentroCoste
   DATA cNombreCentroCoste

   METHOD New()

   METHOD SetResources()      INLINE ( SetResources( fullcurdir() + "Script\CentroCoste\InfoCapturas.dll" ) )

   METHOD FreeResources()     INLINE ( FreeResources() )

   METHOD LoadCentroCoste( cCentroCoste )

   METHOD Resource()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cCentroCoste ) CLASS TInfCapturas

   ::LoadCentroCoste( cCentroCoste )

   ::SetResources()

   ::Resource()  

   ::FreeResources()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD LoadCentroCoste( cCentroCoste ) CLASS TInfCapturas

   local cStm  := ""
   local cSql  := "SELECT * " + ;
                     "FROM " + cPatDat() + "CCoste " + ;
                     "WHERE cCodigo = " + quoted( cCentroCoste  )

   logwrite( cSql )
   msginfo( cSql )


   if ::ExecuteSqlStatement( cSql, @cStm )
      browse( cStm )
   end if 

   ::cCodigoCentroCoste       := cCentroCoste
   
   ::cNombreCentroCoste       := ( cStm )->cNombre

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Resource() CLASS TInfCapturas

   DEFINE DIALOG ::oDialog RESOURCE "CentroCoste" 

      REDEFINE GET   ::oCodigoCentroCoste ;
         VAR         ::cCodigoCentroCoste ;
         ID          100 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oNombreCentroCoste ;
         VAR         ::cNombreCentroCoste ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog








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