#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS OAnuTCom FROM TPrvTip

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oDbfIva     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AnuTipFields()

   ::AddTmpIndex( "cCodTip", "cCodTip" )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

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

   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oDbfArt  := nil
   ::oFacPrvP := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "RETIPTIK" )
      return .f.
   end if

   ::CreateFilter( aItmCompras(), { ::oAlbPrvT, ::oFacPrvT }, .t. )

   /*
   Monta los años
   */

   ::oDefYea()

   /* Monta tipo de artículos */

   if !::oDefTipInf( 70, 80, 90, 100, 910 )
      return .f.
   end if

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local aTot     := {}

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                        {|| "Año    : " + AllTrim( Str( ::nYeaInf ) ) },;
                        {|| "Tipos  : " + if( ::lAllTip, "Todos", AllTrim( ::cTipOrg ) + " > " + AllTrim( ::cTipDes ) ) } }

   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )

   cExpHead          := '!lFacturado'

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )

   ::oAlbPrvT:GoTop()

   while !::lBreak .and. !::oAlbPrvT:Eof()

      if Year( ::oAlbPrvT:dFecAlb ) == ::nYeaInf               .AND.;
         lChkSer( ::oAlbPrvT:CSERALB, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:CSERALB + Str( ::oAlbPrvT:NNUMALB ) + ::oAlbPrvT:CSUFALB )

            while ::oAlbPrvT:CSERALB + Str( ::oAlbPrvT:NNUMALB ) + ::oAlbPrvT:CSUFALB == ::oAlbPrvL:CSERALB + Str( ::oAlbPrvL:NNUMALB ) + ::oAlbPrvL:CSUFALB .AND. ! ::oAlbPrvL:eof()

               if ( ::lAllTip .or. ( oRetFld( ::oAlbPrvL:cRef, ::oDbfArt , "cCodTip") >= ::cTipOrg .AND. oRetFld( ::oAlbPrvL:cRef, ::oDbfArt , "cCodTip") <= ::cTipDes ) ) .AND.;
                  !( ::lExcCero .AND. nTotNAlbPrv( ::oAlbPrvL ) == 0 )  .AND.;
                  !( ::lExcImp .AND. nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( oRetFld( ::oAlbPrvL:cRef, ::oDbfArt , "cCodTip") + ::oAlbPrvL:cRef )
                     ::oDbf:Blank()
                     ::oDbf:cCodTip := oRetFld( ::oAlbPrvL:cRef, ::oDbfArt , "cCodTip")
                     ::oDbf:cNomTip := oRetFld( oRetFld( ::oAlbPrvL:cRef, ::oDbfArt , "cCodTip"), ::oTipArt:oDbf, "cNomTip" )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oAlbPrvT:dFecAlb, nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               ::oAlbPrvL:Skip()

            end while

         end if

      end if

      ::oAlbPrvT:Skip()

      ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

   end while

   ::oAlbPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbPrvT:cFile ) )

   /*Facturas*/

   ::oFacPrvT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas"
   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if Year( ::oFacPrvT:dFecFac ) == ::nYeaInf               .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvT:lFacGas .and. ::lAllTip

            aTot              := aTotFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, ::cDivInf )

            if !::oDbf:Seek( Space( 3 ) )
               ::oDbf:Blank()
               ::oDbf:cCodTip := Space( 3 )
               ::oDbf:cNomTip := Space( 50 )
               ::oDbf:Insert()
            end if

            ::AddImporte( ::oFacPrvT:dFecFac, aTot[1] )

         else

            if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:NNUMFAC ) + ::oFacPrvT:CSUFFAC )

               while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:NNUMFAC ) + ::oFacPrvT:CSUFFAC == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:NNUMFAC ) + ::oFacPrvL:CSUFFAC .AND. ! ::oFacPrvL:eof()

                  if ( ::lAllTip .or. ( oRetFld( ::oFacPrvL:cRef, ::oDbfArt , "cCodTip") >= ::cTipOrg .AND. oRetFld( ::oFacPrvL:cRef, ::oDbfArt , "cCodTip") <= ::cTipDes ) ) .AND.;
                     !( ::lExcCero .AND. nTotNFacPrv( ::oFacPrvL ) == 0 )  .AND.;
                     !( ::lExcImp .AND. nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                     if !::oDbf:Seek( oRetFld( ::oFacPrvL:cRef, ::oDbfArt , "cCodTip") + ::oFacPrvL:cRef )
                        ::oDbf:Blank()
                        ::oDbf:cCodTip := oRetFld( ::oFacPrvL:cRef, ::oDbfArt , "cCodTip")
                        ::oDbf:cNomTip := oRetFld( oRetFld( ::oFacPrvL:cRef, ::oDbfArt , "cCodTip"), ::oTipArt:oDbf, "cNomTip" )
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

   ::oFacPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ) )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//