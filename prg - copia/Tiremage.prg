#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION InfRemAge( oRemAge, oFacCliP, oClientes, oAgentes, oDiv )

   local oInf
   local aCol  := {}
   local aIdx  := {}

   oRemAge:GetStatus()

   aAdd( aCol, { "NNUMCOB", "N",  9, 0, {|| "@!" },         "Número",         .f., "Número del cobro",       9 } )
   aAdd( aCol, { "CSUFCOB", "C",  2, 0, {|| "@!" },         "Suf.",           .f., "Sufijo del cobro",       2 } )
   aAdd( aCol, { "CCODAGE", "C",  3, 0, {|| "@!" },         "Age.",           .f., "Código agente",          6 } )
   aAdd( aCol, { "CNOMAGE", "C", 40, 0, {|| "@!" },         "Agente",         .f., "Nombre agente",         20 } )
   aAdd( aCol, { "CNUMREC", "C", 18, 0, {|| "@!" },         "Recibo",         .t., "Recibo",                18 } )
   aAdd( aCol, { "DFECREC", "D",  8, 0, {|| "" },           "Fecha",          .t., "Fecha",                 10 } )
   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "" },           "Cod. Cli.",      .t., "Código de cliente",     10 } )
   aAdd( aCol, { "CNOMCLI", "C", 40, 0, {|| "" },           "Nom. Cli.",      .t., "Nombre de cliente",     36 } )
   aAdd( aCol, { "NIMPREC", "N", 19, 6, {|| oInf:cPicOut }, "Importe",        .t., "Importe",               12 } )

   aAdd( aIdx, { "NNUMCOB", "Str( NNUMCOB ) + CSUFCOB" } )

   oInf           := TInfRemAge():New( "Remesas de agentes", aCol, aIdx, "01044" )

   oInf:oRemAge   := oRemAge
   oInf:oFacCliP  := oFacCliP
   oInf:oClientes := oClientes
   oInf:oAgentes  := oAgentes
   oInf:oDiv      := oDiv

   oInf:AddGroup( {|| Str( oInf:oDbf:nNumCob ) + oInf:oDbf:cSufCob }, {|| "Remesas : " + Rtrim( Str( oInf:oDbf:nNumCob ) ) + "/" + oInf:oDbf:cSufCob + " Agente: " + oInf:oDbf:cNomAge }, {|| "Total cobro..." } )

   oInf:Resource()

   oInf:Activate()

   oInf:End()

   oRemAge:SetStatus()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfRemAge FROM TInfGen

   DATA  nCobDes
   DATA  nCobHas
   DATA  cSufDes
   DATA  cSufHas
   DATA  oRemAge
   DATA  oFacCliP
   DATA  oClientes
   DATA  oAgentes
   DATA  oDiv

   METHOD OpenFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   ::nCobDes      := ::oRemAge:nNumCob
   ::nCobHas      := ::oRemAge:nNumCob
   ::cSufDes      := ::oRemAge:cSufCob
   ::cSufHas      := ::oRemAge:cSufCob

   ::lDefFecInf   := .f.
   ::lDefDivInf   := .f.
   ::lDefSerInf   := .f.

   if !::StdResource( "INF_GENORDCAR" )
      return .f.
   end if

   ::lLoadDivisa()

   /*
	Llamada a la funcion que activa la caja de dialogo
	*/

   REDEFINE GET ::nCobDes ;
      PICTURE  "999999999" ;
      ID       100 ;
      SPINNER ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::cSufDes ;
      ID       110 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::nCobHas ;
      PICTURE  "999999999" ;
      ID       120 ;
      SPINNER ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::cSufHas ;
      ID       130 ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha : " + Dtoc( Date() ) },;
                     {|| "Rango : " + Alltrim( Str( ::nCobDes ) + "/" + ::cSufDes ) + " > " + Alltrim( Str( ::nCobHas ) + "/" + ::cSufHas ) } }

   if ::oRemAge:Seek( Str( ::nCobDes ) + ::cSufDes )

      while Str( ::oRemAge:nNumCob ) + ::oRemAge:cSufCob <= Str( ::nCobHas ) + ::cSufHas .and. !::oRemAge:eof()

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliP:Seek( Str( ::oRemAge:nNumCob ) + ::oRemAge:cSufCob )

            while Str( ::oFacCliP:nNumCob ) + ::oFacCliP:cSufCob == Str( ::oRemAge:nNumCob ) + ::oRemAge:cSufCob .and. !::oFacCliP:eof()

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:nNumCob    := ::oFacCliP:nNumCob
               ::oDbf:cSufCob    := ::oFacCliP:cSufCob
               ::oDbf:cCodAge    := ::oRemAge:cCodAge
               ::oDbf:cNomAge    := ::oRemAge:cNomAge
               ::oDbf:cNumRec    := ::oFacCliP:cSerie + "/" + Str( ::oFacCliP:nNumFac ) + "/" + ::oFacCliP:cSufFac + "-" + Str( ::oFacCliP:nNumRec )
               ::oDbf:dFecRec    := ::oFacCliP:dPreCob
               ::oDbf:cCodCli    := ::oFacCliP:cCodCli
               ::oDbf:cNomCli    := RetClient( ::oFacCliP:cCodCli, ::oClientes )
               ::oDbf:nImpRec    := nTotRecCli( ::oFacCliP, ::oDiv:cAlias, cDivEmp() )

               ::oDbf:Save()

               ::oFacCliP:Skip()

            end while

         end if

         ::oRemAge:Skip()
         ::oMtrInf:AutoInc( ::oRemAge:OrdKeyNo() )

      end while

   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//