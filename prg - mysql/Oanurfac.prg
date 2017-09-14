#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS oAnuRFac FROM TPrvArt

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendientes", "Cobradas", "Todas" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AnuArtFields()

   ::AddTmpIndex( "cCodArt", "cCodArt" )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE "FACPRVP.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oFacPrvP := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todas"

   if !::StdResource( "INFGENART" )
      return .f.
   end if

   ::oDefYea()

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmFacPrv(), ::oFacPrvT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""
   local aTot     := {}

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + AllTrim( Str( ::nYeaInf ) ) },;
                     {|| "Artículo  : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) } }

   ::oFacPrvT:OrdSetFocus( "dFecFac" )
   ::oFacPrvL:OrdSetFocus( "nNumFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada'
      case ::oEstado:nAt == 3
         cExpHead    := '.t.'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   if !::lAllArt
      cExpLine       += 'cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   else
      cExpLine       := '.t.'
   end if

   ::oFacPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ), ::oFacPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if Year( ::oFacPrvT:dFecFac ) == ::nYeaInf                                            .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvT:lFacGas .and. ::lAllArt

            aTot              := aTotFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, ::cDivInf )

            if !::oDbf:Seek( Space( 18 ) )
               ::oDbf:Blank()
               ::oDbf:cCodArt := Space( 18 )
               ::oDbf:cNomArt := Space( 100 )
               ::oDbf:Insert()
            end if

            ::AddImporte( ::oFacPrvT:dFecFac, aTot[1] )

         else

            if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

               while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:eof()

                  if !( ::lExcCero .AND. nTotNFacPrv( ::oFacPrvL ) == 0 ) .AND.;
                     !( ::lExcImp .AND. nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                     if !::oDbf:Seek( ::oFacPrvL:cRef )
                        ::oDbf:Blank()
                        ::oDbf:cCodArt := ::oFacPrvL:cRef
                        ::oDbf:cNomArt := oRetFld( ::oFacPrvL:cRef, ::oDbfArt )
                        ::oDbf:Insert()
                     end if

                     ::AddImporte( ::oFacPrvT:dFecFac, nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                  end if

                  ::oFacPrvL:Skip()

               end while

            end if

         end if

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacPrvT:Lastrec() )

   ::oFacPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ) )

   ::oFacPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ) )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//