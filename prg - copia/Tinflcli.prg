#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfLCli FROM TInfGen

   DATA   oDbfCli     AS OBJECT

   METHOD Create()

   METHOD lResource( cFld )

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfLCli

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfLCLi

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   ::oDbfCli   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTypDoc",   "C", 25, 0, {|| "" },         "Tip. Doc.",     .t., "Tipo de documento",     25, .f. )
   ::AddField( "dFecDoc",   "D",  8, 0, {|| "" },         "Fecha",         .t., "Fecha",                 12, .f. )
   ::AddField( "cNumDoc",   "C", 12, 0, {|| "" },         "Num. Doc",      .t., "Número de documento",   12, .f. )
   ::AddField( "cCodCli",   "C", 25, 0, {|| "" },         "Cod.Cli.",      .f., "Código Cliente",        15, .f. )
   ::AddField( "cNomCli",   "C", 50, 0, {|| "" },         "Nombre",        .f., "Nombre",                40, .f. )
   ::AddField( "cAlmDoc",   "C",  3, 0, {|| "" },         "Alm.",          .t., "Almacén",                5, .f. )
   ::AddField( "nImpDoc",   "N", 16, 6, {|| ::cPicImp },  "Importe",       .t., "Importe",               16, .t. )
   ::AddField( "cDivisa",   "C", 10, 0, {|| "" },         "Div.",          .f., "Divisa",                 5, .f. )

   ::AddTmpIndex ( "dFecDoc", "dFecDoc" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_CLIL" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   do case
      case  ::xOthers[2] == "Todos"
         ::dIniInf   := CtoD( "01/01/2000" )
         ::dFinInf   := CtoD( "31/12/2020" )
      case  Val( ::xOthers[2]) == Year( GetSysDate() )
         ::dIniInf   := CtoD( "01/01/" + Str( Year( GetSysDate() ) ) )
         ::dFinInf   := GetSysDate()
      otherwise
         ::dIniInf   := CtoD( "01/01/" + ::xOthers[2] )
         ::dFinInf   := CtoD( "31/12/" + ::xOthers[2] )
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::xOthers[1]:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::xOthers[1]:GoTop()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Cliente : " + AllTrim( ::xOthers[1]:Cargo ) + " - " + RetClient( ::xOthers[1]:Cargo, ::oDbfCli ) } }

   while !::xOthers[1]:Eof()

      if ::xOthers[1]:dFecDoc >= ::dIniInf                                                               .AND.;
         ::xOthers[1]:dFecDoc <= ::dFinInf                                                               .AND.;
         lChkSer( left( ::xOthers[1]:cNumDoc, 1 ) , ::aSer )

         ::oDbf:Append()
         ::oDbf:cTypDoc  := cTextoDocumento( ::xOthers[1]:nTypDoc )
         ::oDbf:dFecDoc  := ::xOthers[1]:dFecDoc
         ::oDbf:cNumDoc  := cMaskNumDoc( ::xOthers[1] )
         ::oDbf:cCodCli  := ::xOthers[1]:cCodCli
         ::oDbf:cNomCli  := ::xOthers[1]:cNomCli
         ::oDbf:cAlmDoc  := ::xOthers[1]:cAlmDoc
         ::oDbf:nImpDoc  := ::xOthers[1]:nImpDoc
         ::oDbf:cDivisa  := ::xOthers[1]:cDivisa

         ::oDbf:Save()

      end if

      ::xOthers[1]:Skip()

      ::oMtrInf:AutoInc( ::xOthers[1]:OrdKeyNo() )

   end do

   ::oMtrInf:AutoInc( ::xOthers[1]:LastRec() )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//