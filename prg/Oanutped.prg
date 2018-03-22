#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS oAnuTPed FROM TPrvTip

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedPrvT    AS OBJECT
   DATA  oPedPrvL    AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcilamente", "Entregado", "Todos" }

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

   if !Empty( ::oDbfArt )  .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oPedPrvT := nil
   ::oPedPrvL := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INFGENTIP" )
      return .f.
   end if

   /*
   Monta los años
   */

   ::oDefYea()

   /* Monta tipo de artículos */

   if !::oDefTipInf( 70, 80, 90, 100, 910 )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oPedPrvT:Lastrec() )

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

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

   ::aHeader      := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                        {|| "Año    : " + AllTrim( Str( ::nYeaInf ) ) },;
                        {|| "Tipos  : " + if( ::lAllTip, "Todos", AllTrim( ::cTipOrg ) + " > " + AllTrim( ::cTipDes ) ) },;
                        {|| "Estado : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPedPrvT:OrdSetFocus( "dFecPed" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'nEstado == 1'
      case ::oEstado:nAt == 2
         cExpHead    := 'nEstado == 2'
      case ::oEstado:nAt == 3
         cExpHead    := 'nEstado == 3'
      case ::oEstado:nAt == 4
         cExpHead    := '.t.'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedPrvT:cFile ), ::oPedPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedPrvT:OrdKeyCount() )

   ::oPedPrvT:GoTop()

   while !::lBreak .and. !::oPedPrvT:Eof()

      If Year( ::oPedPrvT:dFecPed ) == ::nYeaInf                                            .AND.;
         lChkSer( ::oPedPrvT:cSerPed, ::aSer )

         if ::oPedPrvL:Seek( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed )

            while ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed == ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed .AND. ! ::oPedPrvL:eof()

               if ( oRetFld( ::oPedPrvL:cRef, ::oDbfArt , "cCodTip") >= ::cTipOrg .AND. oRetFld( ::oPedPrvL:cRef, ::oDbfArt , "cCodTip") <= ::cTipDes ) .AND.;
                  !( ::lExcCero .AND. nTotNPedPrv( ::oPedPrvL ) == 0 )  .AND.;
                  !( ::lExcImp .AND. nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( oRetFld( ::oPedPrvL:cRef, ::oDbfArt , "cCodTip") )
                     ::oDbf:Blank()
                     ::oDbf:cCodTip := oRetFld( ::oPedPrvL:cRef, ::oDbfArt , "cCodTip")
                     ::oDbf:cNomTip := oRetFld( oRetFld( ::oPedPrvL:cRef, ::oDbfArt , "cCodTip"), ::oTipArt:oDbf, "cNomTip" )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oPedPrvT:dFecPed, nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               ::oPedPrvL:Skip()

            end while

         end if

      end if

      ::oPedPrvT:Skip()

      ::oMtrInf:AutoInc( ::oPedPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oPedPrvT:Lastrec() )

   ::oPedPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedPrvT:cFile ) )

   ::oPedPrvL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedPrvL:cFile ) )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//