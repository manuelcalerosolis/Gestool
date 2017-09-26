#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfAlm FROM TInfGen

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAlm",   "C",  3, 0, {|| "" },     "Cod.",              .t., "Código de almacen",                5, .f. )
   ::AddField( "cNomAlm",   "C", 20, 0, {|| "" },     "Nombre",            .t., "Nombre de almacen",               30, .f. )
   ::AddField( "cDirAlm",   "C", 50, 0, {|| "" },     "Dir.",              .t., "Domicilio de almacen",            15, .f. )
   ::AddField( "cPosAlm",   "C",  7, 0, {|| "" },     "C.P.",              .t., "Código postal de almacen",        15, .f. )
   ::AddField( "cPobAlm",   "C", 30, 0, {|| "" },     "Población",         .t., "Población de almacen",            15, .f. )
   ::AddField( "cProAlm",   "C", 20, 0, {|| "" },     "Provincia",         .t., "Provincia de almacen",            15, .f. )
   ::AddField( "cTfnAlm",   "C", 12, 0, {|| "" },     "Teléfono",          .f., "Teléfono de almacen",              6, .f. )
   ::AddField( "cFaxAlm",   "C", 12, 0, {|| "" },     "Fax",               .f., "Fax de almacen",                  15, .f. )
   ::AddField( "cPerAlm",   "C", 50, 0, {|| "" },     "Contacto",          .f., "Persona de contacto de almacen",  12, .f. )
   ::AddField( "cCodCli",   "C", 12, 0, {|| "" },     "Cliente",           .f., "Codigo del cliente",              12, .f. )
   ::AddField( "cUbiCa1",   "C",  5, 0, {|| "" },     "Cod. Ubi1",         .f., "Ubicación 1",                     12, .f. )
   ::AddField( "cNomUbi1",  "C",  5, 2, {|| "" },     "Nom. Ubi1",         .f., "Nombre ubicación 1",               6, .f. )
   ::AddField( "cUbiCa2",   "C",  5, 2, {|| "" },     "Cod. Ubi2",         .f., "Ubicación 2",                      6, .f. )
   ::AddField( "cNomUbi2",  "C", 30, 2, {|| "" },     "Nom. Ubi2",         .f., "Nombre ubicación 2",               6, .f. )
   ::AddField( "cUbiCa3",   "C", 30, 2, {|| "" },     "Cod. Ubi3",         .f., "Ubicación 3",                      6, .f. )
   ::AddField( "cNomUbi3",  "C", 30, 2, {|| "" },     "Nom. Ubi3",         .f., "Nombre ubicación 3",               6, .f. )

   ::AddTmpIndex ( "cCodAlm", "cCodAlm" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_ALM01" )
      return .f.
   end if

   /*
   Montamos los agentes
   */

   ::oDefAlmInf( 70, 80, 90, 100, 60 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfAlm:Lastrec() )

   ::CreateFilter( aItmAlm(), ::oDbfAlm:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Almacenes : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) } }

   ::oDbfAlm:OrdSetFocus( "CCODALM" )

   ::oDbfAlm:GoTop()
   while !::lBreak .and. !::oDbfAlm:Eof()

      if ( ::lAllAlm .or. ( ::oDbfAlm:cCodAlm >= ::cAlmOrg .AND. ::oDbfAlm:cCodAlm <= ::cAlmDes ) ) .and. ;
         ::EvalFilter()

         ::oDbf:Append()

         ::oDbf:cCodAlm     := ::oDbfAlm:cCodAlm
         ::oDbf:cNomAlm     := ::oDbfAlm:cNomAlm
         ::oDbf:cDirAlm     := ::oDbfAlm:cDirAlm
         ::oDbf:cPosAlm     := ::oDbfAlm:cPosAlm
         ::oDbf:cPobAlm     := ::oDbfAlm:cPobAlm
         ::oDbf:cProAlm     := ::oDbfAlm:cProAlm
         ::oDbf:cTfnAlm     := ::oDbfAlm:cTfnAlm
         ::oDbf:cFaxAlm     := ::oDbfAlm:cFaxAlm
         ::oDbf:cPerAlm     := ::oDbfAlm:cPerAlm
         ::oDbf:cCodCli     := ::oDbfAlm:cCodCli
         ::oDbf:cUbiCa1     := ::oDbfAlm:cUbiCa1
         ::oDbf:cNomUbi1    := ::oDbfAlm:cNomUbi1
         ::oDbf:cUbiCa2     := ::oDbfAlm:cUbiCa2
         ::oDbf:cNomUbi2    := ::oDbfAlm:cNomUbi2
         ::oDbf:cUbiCa3     := ::oDbfAlm:cUbiCa3
         ::oDbf:cNomUbi3    := ::oDbfAlm:cNomUbi3

         ::oDbf:Save()

      end if

      ::oDbfAlm:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfAlm:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//