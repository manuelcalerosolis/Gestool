#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfCobAge FROM TInfGen

   DATA  nAgeDes
   DATA  nAgeHas
   DATA  cSufDes
   DATA  cSufHas
   DATA  oCobAgeT
   DATA  oCobAgeL
   DATA  oFacCliT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumLiq", "C", 12, 0, {|| "@!" },        "Liquidación",      .f., "Número de la liquidación",    10 )
   ::AddField( "dFecLiq", "D",  8, 0, {|| "@!" },        "Fecha",            .f., "Fecha liquidación",            8 )
   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },        "Cod. Age.",        .f., "Código agente",               20 )
   ::AddField( "cNomAge", "C", 30, 0, {|| "@!" },        "Agente",           .f., "Nombre agente",               20 )
   ::AddField( "cTipo",   "C", 14, 0, {|| "@!" },        "Tipo",             .t., "Tipo de factura",             20 )
   ::AddField( "cNumFac", "C", 14, 0, {|| "@!" },        "Factura",          .t., "Número de factura",           20 )
   ::AddField( "dFecFac", "D",  8, 0, {|| "@!" },        "Fecha",            .t., "Fecha de la factura",         10 )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },        "Cod. Cli.",        .f., "Código de cliente",           10 )
   ::AddField( "cNomCli", "C", 80, 0, {|| "@!" },        "Cliente",          .t., "Nombre del cliente",          50 )
   ::AddField( "nTotBas", "N", 16, 6, {|| ::cPicOut },   "Base",             .t., "Base comisionable",           12 )
   ::AddField( "nPorCom", "N", 16, 6, {|| "@E 999.99" }, "% Com.",           .t., "Porcentaje de comisión",      12 )
   ::AddField( "nTotCom", "N", 16, 6, {|| ::cPicOut },   "Total",            .t., "Total comisión",              12 )

   ::AddTmpIndex( "cNumLiq", "cNumLiq + cNumFac" )

   ::AddGroup( {|| ::oDbf:cNumLiq }, {|| "Liquidación : " + AllTrim( ::oDbf:cNumLiq ) + " Fecha: " + Dtoc( ::oDbf:dFecLiq ) + " Agente: " + AllTrim( ::oDbf:cCodAge ) + " - " + AllTrim( ::oDbf:cNomAge ) }, {|| "Total liquidación..." } )

   ::oCobAgeT  := ::xOthers[ 1 ]
   ::oCobAgeL  := ::xOthers[ 2 ]

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfDiv  PATH ( cPatDat() ) FILE "DIVISAS.DBF"  VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   ::oFacCliT     := TDataCenter():oFacCliT()

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   ::oDbfDiv  := nil
   ::oFacCliT := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   ::nAgeDes      := dbFirst ( ::oCobAgeT, 2 )
   ::nAgeHas      := dbLast  ( ::oCobAgeT, 2 )
   ::cSufDes      := dbFirst ( ::oCobAgeT, 3 )
   ::cSufHas      := dbLast  ( ::oCobAgeT, 3 )

   ::lDefDivInf   := .f.
   ::lDefSerInf   := .f.

   if !::StdResource( "INF_GENCOBAGE" )
      return .f.
   end if

   ::lLoadDivisa()

   /*
	Llamada a la funcion que activa la caja de dialogo
	*/

   REDEFINE GET ::nAgeDes ;
      PICTURE  "999999999" ;
      ID       100 ;
      SPINNER ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::cSufDes ;
      ID       110 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::nAgeHas ;
      PICTURE  "999999999" ;
      ID       120 ;
      SPINNER ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::cSufHas ;
      ID       130 ;
      OF       ::oFld:aDialogs[1]

   if !::oDefAgeInf( 140, 141, 150, 151, 160 )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oCobAgeT:Lastrec() )

   ::CreateFilter( , ::oCobAgeT )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nKlgEnt  := 0
   local cExpHead := ""

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                           {|| "Rango   : " + Alltrim( Str( ::nAgeDes ) ) + "/" + AllTrim( ::cSufDes ) + " > " + Alltrim( Str( ::nAgeHas ) ) + "/" + Alltrim( ::cSufHas ) } ,;
                           {|| "Agentes : " + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ) } }

   ::oCobAgeT:OrdSetFocus( "nNumCob" )
   ::oCobAgeL:OrdSetFocus( "nNumCob" )

   cExpHead          := 'dFecCob >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecCob <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += '.and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ::oFilter:cExpresionFilter
   end if

   ::oCobAgeT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oCobAgeT:cFile ), ::oCobAgeT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   if ::oCobAgeT:Seek( Str( ::nAgeDes ) + ::cSufDes )

      while Str( ::oCobAgeT:nNumCob ) + ::oCobAgeT:cSufCob <= Str( ::nAgeHas ) + ::cSufHas .and. !::oCobAgeT:eof()

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oCobAgeL:Seek( Str( ::oCobAgeT:nNumCob ) + ::oCobAgeT:cSufCob )

            while Str( ::oCobAgeT:nNumCob ) + ::oCobAgeT:cSufCob == Str( ::oCobAgeL:nNumCob ) + ::oCobAgeL:cSufCob .and.;
               !::oCobAgeL:Eof()

               ::oDbf:Append()

               ::oDbf:cNumLiq    := AllTrim( Str( ::oCobAgeT:nNumCob ) ) + "/" + ::oCobAgeT:cSufCob
               ::oDbf:dFecLiq    := ::oCobAgeT:dFecCob
               ::oDbf:cCodAge    := ::oCobAgeT:cCodAge
               ::oDbf:cNomAge    := cNbrAgent( ::oCobAgeT:cCodAge, ::oDbfAge:cAlias )
               ::oDbf:cTipo      := if( ::oCobAgeL:lFacRec, "Rectificativa", "Factura" )
               ::oDbf:cNumFac    := ::oCobAgeL:cSerFac + "/" + AllTrim( Str( ::oCobAgeL:nNumFac ) )+ "/" + ::oCobAgeL:cSufFac
               ::oDbf:dFecFac    := ::oCobAgeL:dFecFac
               ::oDbf:cCodCli    := ::oCobAgeL:cCodCli
               ::oDbf:cNomCli    := oRetFld( Padr( ::oCobAgeL:cCodCli, 12 ), ::oFacCliT, "cNomCli", "CCODCLI" )
               ::oDbf:nTotBas    := ::oCobAgeL:nImpCom
               ::oDbf:nPorCom    := ::oCobAgeL:nComAge
               ::oDbf:nTotCom    := ( ::oCobAgeL:nImpCom * ::oCobAgeL:nComAge / 100 )

               ::oDbf:Save()

               ::oCobAgeL:Skip()

            end  while

         end if

         ::oCobAgeT:Skip()

         ::oMtrInf:AutoInc( ::oCobAgeT:OrdKeyNo() )

      end while

   end if

   ::oCobAgeT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oCobAgeT:cFile ) )

   ::oMtrInf:AutoInc( ::oCobAgeT:LastRec() )

   ::oCobAgeT:SetStatus()

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//