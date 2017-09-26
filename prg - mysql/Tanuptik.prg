#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuPTik FROM TInfTrn

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

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) }
   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli  PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INFANUTRNB" )
      return .f.
   end if

   /*
   Monta los años
   */

   ::oDefYea()

   /*
   Monta los rutas de manera automatica
   */

   ::oDefRutInf( 70, 71, 80, 81 )

   ::oDefExcInf()

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nPreDiv

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oTikCliT:GoTop()

   while ! ::oTikCliT:Eof()

      if ( ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4" )   .AND.;
         Year( ::oTikCliT:dFecTik ) == ::nYeaInf                        .AND.;
         ::oTikCliT:cCodRut >= ::cRutOrg                                .AND.;
         ::oTikCliT:cCodRut <= ::cRutDes                                .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. !::oTikCliL:eof()

               if !Empty( ::oTikCliL:cCbaTil )                 .AND.;
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

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//