#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS oAnuOFac FROM TPrvPgo

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

   ::AnuPgoFields()

   ::AddTmpIndex( "cCodPgo", "cCodPgo" )

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

   local cEstado  := "Todas"

   if !::StdResource( "INFANUPGO" )
      return .f.
   end if

   /*
   Monta los años
   */

   ::oDefYea()

   /*
   Monta formas de pago
   */

   if !::oDefFpgInf( 70, 80, 90, 100, 920 )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

   ::oDefExcInf()

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

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Año     : " + AllTrim( Str( ::nYeaInf ) ) },;
                     {|| "F. pago : " + if( ::lAllFpg, "Todos", AllTrim( ::cFpgDes ) + " > " + AllTrim( ::cFpgHas ) ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oFacPrvT:OrdSetFocus( "dFecFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada'
      case ::oEstado:nAt == 3
         cExpHead    := '.t.'
   end case

   if !::lAllFpg
      cExpHead       += ' .and. cCodPgo >= "' + ::cFpgDes + '" .and. cCodPgo <= "' + ::cFpgHas + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if Year( ::oFacPrvT:dFecFac ) == ::nYeaInf                                                        .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvT:lFacGas

            aTot              := aTotFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, ::cDivInf )

            if !::oDbf:Seek( ::oFacPrvT:cCodPago )
               ::oDbf:Blank()
               ::oDbf:cCodPgo := ::oFacPrvT:cCodPago
               ::oDbf:cNomPgo := cNbrFPago( ::oFacPrvT:cCodPago, ::oDbfFpg )
               ::oDbf:Insert()
            end if

            ::AddImporte( ::oFacPrvT:dFecFac, aTot[1] )

         else

            if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

               while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:eof()

                  if !( ::lExcCero .AND. nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                     if !::oDbf:Seek( ::oFacPrvT:cCodPago )
                        ::oDbf:Blank()
                        ::oDbf:cCodPgo := ::oFacPrvT:cCodPago
                        ::oDbf:cNomPgo := cNbrFPago( ::oFacPrvT:cCodPago, ::oDbfFpg )
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

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//