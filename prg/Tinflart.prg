#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfLArt FROM TInfGen

   DATA   oDbfArt     AS OBJECT

   METHOD Create()

   METHod lResource( cFld )

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfLArt

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfLArt

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oDbfArt   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTypDoc",   "C", 25, 0, {|| "" },         "Tip. Doc.",     .t., "Tipo de documento",     25, .f. )
   ::AddField( "dFecDoc",   "D",  8, 0, {|| "" },         "Fecha",         .t., "Fecha",                 12, .f. )
   ::AddField( "cNumDoc",   "C", 12, 0, {|| "" },         "Num. Doc",      .t., "Número de documento",   12, .f. )
   ::AddField( "cCodDoc",   "C", 12, 0, {|| "" },         "Código",        .f., "Código",                12, .f. )
   ::AddField( "cNomDoc",   "C", 50, 0, {|| "" },         "Nombre",        .t., "Nombre",                40, .f. )
   ::AddField( "cAlmDoc",   "C",  3, 0, {|| "" },         "Alm.",          .t., "Almacén",                5, .f. )
   ::AddField( "nUndDoc",   "N", 16, 6, {|| MasUnd() },   "Unidades",      .t., "Unidades",              12, .t. )
   ::AddField( "nDtoDoc",   "N", 16, 6, {|| "" },         "Descuento",     .t., "Descuento",             16, .f. )
   ::AddField( "nImpDoc",   "N", 16, 6, {|| ::cPicImp },  "Importe",       .t., "Importe",               16, .t. )
   ::AddField( "nTotDoc",   "N", 16, 6, {|| ::cPicImp },  "Total",         .t., "Total",                 16, .t. )

   ::AddTmpIndex ( "dFecDoc", "dFecDoc" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_ARTL" )
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
   Monta los clientes de manera automatica
   */

   if !::oDefCliInf( 110, 120, 130, 140, , 160 )
      return .f.
   end if

   /*
   Monta los Proveedores de manera automatica
   */

   if !::oDefPrvInf( 70, 80, 90, 100, 150 )
      return .f.
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

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) } }

   ::xOthers[1]:GoTop()

   WHILE !::xOthers[1]:Eof()

      if ::xOthers[1]:dFecDoc >= ::dIniInf                                                                  .AND.;
         ::xOthers[1]:dFecDoc <= ::dFinInf                                                                  .AND.;
         ( ::lAllCli .or. ( ::xOthers[1]:cCodDoc >= ::cCliOrg .AND. ::xOthers[1]:cCodDoc <= ::cCliDes ) )   .AND.;
         ( ::lAllPrv .or. ( ::xOthers[1]:cCodDoc >= ::cPrvOrg .AND. ::xOthers[1]:cCodDoc <= ::cPrvDes ) )   .AND.;
         lChkSer( left( ::xOthers[1]:cNumDoc, 1 ) , ::aSer )

         ::oDbf:Append()

         ::oDbf:cTypDoc  := cTextDocument( ::xOthers[1]:nTypDoc )
         ::oDbf:dFecDoc  := ::xOthers[1]:dFecDoc
         ::oDbf:cNumDoc  := cMaskNumDoc( ::xOthers[1] )
         ::oDbf:cCodDoc  := ::xOthers[1]:cCodDoc
         ::oDbf:cNomDoc  := ::xOthers[1]:cNomDoc
         ::oDbf:cAlmDoc  := ::xOthers[1]:cAlmDoc
         ::oDbf:nUndDoc  := ::xOthers[1]:nUndDoc
         ::oDbf:nDtoDoc  := ::xOthers[1]:nDtoDoc
         ::oDbf:nImpDoc  := ::xOthers[1]:nImpDoc
         ::oDbf:nTotDoc  := ::xOthers[1]:nTotDoc

         ::oDbf:Save()

      end if

      ::xOthers[1]:Skip()

      ::oMtrInf:AutoInc( ::xOthers[1]:OrdKeyNo() )

   END DO

   ::oMtrInf:AutoInc( ::xOthers[1]:LastRec() )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//