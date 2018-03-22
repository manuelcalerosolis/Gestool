#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS OAcuFFac FROM TPrvFam

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  oDbfIva     AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::AcuCreate()

   ::AddTmpIndex( "cCodFam", "cCodFam" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS OAcuFFac

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE "FACPRVP.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS OAcuFFac

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oFacPrvP := nil
   ::oDbfArt  := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS OAcuFFac

   if !::StdResource( "INFACUFAM" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefFamInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

   ::oDefExcInf()

   ::CreateFilter( aItmFacPrv(), ::oFacPrvT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS OAcuFFac

   local cExpHead    := ""
   local cExpLine    := ""
   local aTot        := {}

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                           {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "Familia : " + if( ::lAllFam, "Todas", AllTrim ( ::cFamOrg ) + " > " + AllTrim ( ::cFamDes ) ) } }

   ::oFacPrvT:OrdSetFocus( "dFecFac" )
   ::oFacPrvL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   if !::lAllFam
      cExpLine       := 'cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   else
      cExpLine       := '.t.'
   end if

   ::oFacPrvL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvL:cFile ), ::oFacPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvT:lFacGas .and. ::lAllFam

            aTot              := aTotFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, ::cDivInf )

            if !::oDbf:Seek( Space( 8 ) )

               ::oDbf:Append()

               ::oDbf:cCodFam    := Space( 8 )
               ::oDbf:cNomFam    := Space( 50 )
               ::oDbf:nNumUni    := 1
               ::oDbf:nImpArt    := aTot[1]
               ::oDbf:nImpTot    := aTot[1]
               ::oDbf:nIvaTot    := aTot[2]
               ::oDbf:nTotFin    := aTot[4]

               ::oDbf:Save()

            else

               ::oDbf:Load()

               ::oDbf:nNumUni    += 1
               ::oDbf:nImpArt    += aTot[1]
               ::oDbf:nImpTot    += aTot[1]
               ::oDbf:nIvaTot    += aTot[2]
               ::oDbf:nTotFin    += aTot[4]

               ::oDbf:Save()

            end if

         else

            if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

               while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:eof()

                  if !( ::lExcCero .AND. nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                     ::AddFac( .t. )

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

   ::oFacPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ) )

   ::oFacPrvL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvL:cFile ) )

   ::IncluyeCero()

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//