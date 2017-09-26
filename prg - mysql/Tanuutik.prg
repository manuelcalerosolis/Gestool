#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuUTik FROM TInfRut

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AnuRutFields()

   ::AddTmpIndex( "cCodRut", "cCodRut" )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli  PATH ( cPatCli() ) FILE "CLIENT.DBF"   VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oDbfCli  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFANURUTB" )
      return .f.
   end if

   /*
   Monta los años
   */

   ::oDefYea()

   /*
   Monta los rutas de manera automatica
   */

   if !::oDefRutInf( 70, 71, 80, 81, 900 )
      return .f.
   end if

   ::oDefExcInf()

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   ::CreateFilter( aItmTik(), ::oTikCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                        {|| "Año    : " + AllTrim( Str( ::nYeaInf ) ) },;
                        {|| "Rutas  : " + if( ::lAllRut, "Todas", AllTrim( ::cRutOrg )+ " > " + AllTrim( ::cRutDes ) ) } }

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   /*
   Cabeceras de tikets creamos el indice sobre la cabecera
   */

   if !::lAllRut
      cExpHead       := 'cCodRut >= "' + Rtrim( ::cRutOrg ) + '" .and. cCodRut <= "' + Rtrim( ::cRutDes ) + '"'
   else
      cExpHead       := '.t.'
   end if

   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if Year( ::oTikCliT:dFecTik ) == ::nYeaInf               .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. !::oTikCliL:eof()

               if !Empty( ::oTikCliL:cCbaTil )                 .AND.;
                  !( ::oTikCliL:lControl )                     .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nPvpTil == 0 )

                  if !::oDbf:Seek( ::oTikCliT:cCodRut )
                     ::oDbf:Blank()
                     ::oDbf:cCodRut    := ::oTikCliT:cCodRut
                     ::oDbf:cNomRut    := oRetFld( ::oDbf:cCodRut, ::oDbfRut )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oTikCliT:dFecTik, nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 ) )

                  ::nMediaMes( ::nYeaInf )

               end if

               if !Empty( ::oTikCliL:cComTil )                 .AND.;
                  !( ::oTikCliL:lControl )                     .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nPcmTil == 0 )

                  if !::oDbf:Seek( ::oTikCliT:cCodRut )
                     ::oDbf:Blank()
                     ::oDbf:cCodRut    := ::oTikCliT:cCodRut
                     ::oDbf:cNomRut    := oRetFld( ::oDbf:cCodRut, ::oDbfRut )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oTikCliT:dFecTik, nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 ) )

                  ::nMediaMes( ::nYeaInf )

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//