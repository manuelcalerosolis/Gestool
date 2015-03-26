#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfRut FROM TInfGen

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodRut",       "C",  4, 0, {|| "" },     "Cod.",             .t., "Código de la ruta",          5, .f. )
   ::AddField( "cDesRut",       "C", 30, 0, {|| "" },     "Ruta",             .t., "Nombre de la ruta",         30, .f. )

   ::AddTmpIndex ( "cCodRut", "cCodRut" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_RUT01" )
      return .f.
   end if

   /*
   Montamos los agentes
   */

   ::oDefRutInf( 70, 80, 90, 100, 60 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfRut:Lastrec() )

   ::CreateFilter( aItmRut(), ::oDbfRut:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha : " + Dtoc( Date() ) },;
                        {|| "Rutas : " + if( ::lAllRut, "Todos", AllTrim( ::cRutOrg ) + " > " + AllTrim( ::cRutDes ) ) } }

   ::oDbfRut:OrdSetFocus( "CCODRUT" )

   ::oDbfRut:GoTop()

   while !::lBreak .and. !::oDbfRut:Eof()

      if ( ::lAllRut .or. ( ::oDbfRut:cCodRut >= ::cRutOrg .AND. ::oDbfRut:cCodRut <= ::cRutDes ) ) .and.;
         ::EvalFilter()

         ::oDbf:Append()
         ::oDbf:cCodRut     := ::oDbfRut:cCodRut
         ::oDbf:cDesRut     := ::oDbfRut:cDesRut
         ::oDbf:Save()

      end if

      ::oDbfRut:Skip()

      ::oMtrInf:AutoInc( ::oDbfRut:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbfRut:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//