#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuRFacRec FROM TInfPArt

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::ArtAnuCreateFld()

   ::AddTmpIndex( "cCodArt", "cCodArt" )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oDbfCli  PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oDbfCli  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFGENARTB" )
      return .f.
   end if

   /*
   Monta los a�os
   */

   ::oDefYea()

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacRecT:Lastrec() )

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   ::CreateFilter( aItmFacRec(), ::oFacRecT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "A�o       : " + AllTrim( Str( ::nYeaInf ) ) },;
                     {|| "Art�culos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim (::cArtDes ) ) } }

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   WHILE !::lBreak .and. !::oFacRecT:Eof()

      if Year( ::oFacRecT:dFecFac ) == ::nYeaInf                                 .AND.;
         lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac

               if !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL ) == 0 )           .AND.;
                  !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0  )

                  if !::oDbf:Seek( ::oFacRecL:cRef )

                     ::oDbf:Blank()
                     ::oDbf:cCodArt := ::oFacRecL:cRef
                     ::oDbf:cNomArt := oRetFld( ::oFacRecL:cRef, ::oDbfArt )
                     ::oDbf:Insert()

                  end if

                  ::AddImporte( ::oFacRecT:dFecFac, nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                  ::nMediaMes( ::nYeaInf )

               end if

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//