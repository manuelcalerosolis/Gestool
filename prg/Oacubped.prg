#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS OAcuBPed FROM TPrvInf

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oPedPrvT    AS OBJECT
   DATA  oPedPrvL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  oDbfArt     AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AcuCreate()

   ::AddTmpIndex( "cCodPrv", "cCodPrv" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oPedPrvT PATH ( cPatEmp() ) FILE "PEDPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"

   DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) FILE "PEDPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPedPrvT ) .and. ::oPedPrvT:Used()
      ::oPedPrvT:End()
   end if
   if !Empty( ::oPedPrvL ) .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oPedPrvT := nil
   ::oPedPrvL := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFACUPRV" )
      return .f.
   end if

   /*
   Monta los Prventes de manera automatica
   */

   if !::oDefPrvInf( 70, 80, 90, 100, 900 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPedPrvT:Lastrec() )

   ::oDefExcInf()

   ::CreateFilter( aItmPedPrv(), ::oPedPrvT:cAlias )

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

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Proveedor : " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim (::cPrvDes ) ) } }

   ::oPedPrvT:OrdSetFocus( "dFecPed" )

   cExpHead          := 'dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + ::cPrvOrg + '" .and. cCodPrv <= "' + ::cPrvDes + '"'
   end if

   if !Empty( ::oFilter:cExpFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpFilter
   end if

   ::oPedPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ), ::oPedPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedPrvT:OrdKeyCount() )

   ::oPedPrvT:GoTop()

   while !::lBreak .and. !::oPedPrvT:Eof()

      if lChkSer( ::oPedPrvT:cSerPed, ::aSer )

         if ::oPedPrvL:Seek( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed )

            while ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed == ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed .AND. ! ::oPedPrvL:eof()

               if !( ::lExcCero .AND. nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  ::AddPed( .t. )

               end if

            ::oPedPrvL:Skip()

            end while

         end if

      end if

      ::oPedPrvT:Skip()

      ::oMtrInf:AutoInc( ::oPedPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oPedPrvT:Lastrec() )

   ::oPedPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ) )

   ::oPedPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedPrvL:cFile ) )

   ::IncluyeCero()

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//