#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS oAnuBPed FROM TPrvInf

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedPrvT    AS OBJECT
   DATA  oPedPrvL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcilamente", "Entregado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AnuPrvFields()

   ::AddTmpIndex( "cCodPrv", "cCodPrv" )

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INFANUPRV" )
      return .f.
   end if

   /*
   Monta los años
   */

   ::oDefYea()

   /* Monta clientes  */

   if !::oDefPrvInf( 110, 120, 130, 140, 900 )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oPedPrvT:Lastrec() )

   ::oDefExcInf( 204 )

   ::oDefSalInf( 201 )

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

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

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Año       : " + AllTrim( Str( ::nYeaInf ) ) },;
                     {|| "Proveedor : " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim( ::cPrvDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

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

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + ::cPrvOrg + '" .and. cCodPrv <= "' + ::cPrvDes + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ), ::oPedPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedPrvT:OrdKeyCount() )

   ::oPedPrvT:GoTop()

   while !::lBreak .and. !::oPedPrvT:Eof()

      if Year( ::oPedPrvT:dFecPed ) == ::nYeaInf                                                      .AND.;
         lChkSer( ::oPedPrvT:cSerPed, ::aSer )

         if ::oPedPrvL:Seek( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed )

            while ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed == ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed .AND. ! ::oPedPrvL:eof()

               if !( ::lExcCero .AND. nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oPedPrvT:cCodPrv )
                     ::oDbf:Blank()
                     ::oDbf:cCodPrv := ::oPedPrvT:cCodPrv
                     ::oDbf:cNomPrv := oRetFld( ::oPedPrvT:cCodPrv, ::oDbfPrv )
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

   ::oPedPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ) )

   ::oPedPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedPrvL:cFile ) )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//