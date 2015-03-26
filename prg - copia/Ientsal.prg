#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS IEntSal FROM TInfGen

   DATA  oDbfEnt   AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "dFecEnt",  "D",  8, 0, {|| "" },   "Fecha",       .t., "Fecha",         12, .f. )
   ::AddField( "cTipEnt",  "C", 20, 0, {|| "" },   "Tipo",        .t., "Tipo",          15, .f. )
   ::AddField( "cDesEnt",  "C", 50, 0, {|| "" },   "Descripción", .t., "Descripción",   50, .f. )
   ::AddField( "nImpEnt",  "N", 16, 6, {|| "" },   "Importe",     .t., "Importe",       16, .f. )

   ::AddTmpIndex ( "dFecEnt", "dFecEnt" )

   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfEnt PATH ( cPatEmp() )   FILE "ENTSAL.DBF"   VIA ( cDriver() ) SHARED INDEX "ENTSAL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfEnt ) .and. ::oDbfEnt:Used()
      ::oDbfEnt:End()
   end if

   ::oDbfEnt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_ENT01" )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oDbfEnt:Lastrec() )

   ::CreateFilter( aItmEntSal(), ::oDbfEnt:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } }

   ::oDbfEnt:OrdSetFocus( "DFECENT" )

   ::oDbfEnt:GoTop()
   while !::lBreak .and. !::oDbfEnt:Eof()

      if ::oDbfEnt:dFecEnt >= ::dIniInf .and. ::oDbfEnt:dFecEnt <= ::dFinInf .and. ::EvalFilter()

         ::oDbf:Append()

         ::oDbf:dFecEnt  := ::oDbfEnt:dFecEnt
         if ::oDbfEnt:nTipEnt == 1
            ::oDbf:cTipEnt  := "Entrada"
         else
            ::oDbf:cTipEnt  := "Salida"
         end if
         ::oDbf:cDesEnt  := ::oDbfEnt:cDesEnt
         ::oDbf:nImpEnt  := ::oDbfEnt:nImpEnt

         ::oDbf:Save()

      end if

      ::oDbfEnt:Skip()

      ::oMtrInf:AutoInc( ::oDbfEnt:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbfEnt:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//