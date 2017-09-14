#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS OAcuAPed FROM TPrvAlm

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oPedPrvT    AS OBJECT
   DATA  oPedPrvL    AS OBJECT
   DATA  oDbfArt     AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::AcuCreate()

   ::AddTmpIndex( "cCodAlm", "cCodAlm" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS OAcuAPed

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oPedPrvT PATH ( cPatEmp() ) FILE "PEDPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"

   DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) FILE "PEDPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS OAcuAPed

   if !Empty( ::oPedPrvT ) .and. ::oPedPrvT:Used()
      ::oPedPrvT:End()
   end if
   if !Empty( ::oPedPrvL ) .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if
   if !Empty( ::oDbfArt )  .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oPedPrvT := nil
   ::oPedPrvL := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS OAcuAPed

   if !::StdResource( "INFACUALM" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::oDefAlmInf( 70, 80, 90, 100, 700 )
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

METHOD lGenerate() CLASS OAcuAPed

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                           {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "Almacén : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) } }

   ::oPedPrvT:OrdSetFocus( "dFecPed" )
   ::oPedPrvL:OrdSetFocus( "nNumPed" )

   cExpHead          := 'dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ), ::oPedPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedPrvT:OrdKeyCount() )

   if !::lAllAlm
      cExpLine       := 'cAlmLin >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmLin <= "' + Rtrim( ::cAlmDes ) + '"'
   else
      cExpLine       := '.t.'
   end if

   ::oPedPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedPrvL:cFile ), ::oPedPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

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

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//