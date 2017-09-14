#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDiaPPed FROM TPrvInf

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oPedPrvT    AS OBJECT
   DATA  oPedPrvL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcilamente", "Entregado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   if ::xOthers

      ::AddField ( "CCODPRV", "C", 12, 0, {|| "@!" },         "Código",               .f., "Cod. proveedor",         8 )
      ::AddField ( "CNOMPRV", "C", 50, 0, {|| "@!" },         "Proveedor",            .f., "Nombre proveedor",      25 )
      ::DiaFields()

      ::AddTmpIndex( "cCodPrv", "cCodPrv" )
      ::AddGroup( {|| ::oDbf:cCodPrv }, {|| "Proveedor  : " + Rtrim( ::oDbf:cCodPrv ) + "-" + oRetFld( ::oDbf:cCodPrv, ::oDbfPrv ) } )

   else

      ::AddField ( "CCODPRV", "C", 12, 0, {|| "@!" },         "Código",               .t., "Cod. proveedor",         8 )
      ::AddField ( "CNOMPRV", "C", 50, 0, {|| "@!" },         "Proveedor",            .t., "Nombre proveedor",      25 )
      ::DiaFields()

      ::AddTmpIndex( "dFecMov", "dFecMov" )

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaPPed

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oPedPrvT  PATH ( cPatEmp() ) FILE "PEDPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"

   DATABASE NEW ::oPedPrvL  PATH ( cPatEmp() ) FILE "PEDPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaPPed

   if !Empty( ::oPedPrvT ) .and. ::oPedPrvT:Used()
      ::oPedPrvT:End()
   end if
   if !Empty( ::oPedPrvL ) .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if
   if !Empty( ::oDbfPrv ) .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oPedPrvT  := nil
   ::oPedPrvL  := nil
   ::oDbfPrv   := nil
   ::oDbfIva   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TDiaPPed

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN05A" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   ::oDefPrvInf( 70, 80, 90, 100 )

   /*
   Monta los clientes de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPedPrvT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPedPrv(), ::oPedPrvT:cAlias )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaPPed

   local cExpHead := ""
   local aTotTmp  := {}

   ::oDlg:Disable()
   :oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Proveedor : " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim( ::cPrvDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPedPrvT:OrdSetFocus( "dFecPed" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'nEstado == 1 .and. dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'nEstado == 2 .and. dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'nEstado == 3 .and. dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 4
         cExpHead    := 'dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
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

      if lChkSer( ::oPedPrvT:cSerPed, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::AddProveedor( ::oPedPrvT:cCodPrv )
         ::oDbf:dFecMov := ::oPedPrvT:dFecPed

         aTotTmp        := aTotPedPrv( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed, ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, nil, ::cDivInf )

         ::oDbf:nTotNet := aTotTmp[1]
         ::oDbf:nTotIva := aTotTmp[2]
         ::oDbf:nTotReq := aTotTmp[3]
         ::oDbf:nTotDoc := aTotTmp[4]
         ::oDbf:cDocMov := AllTrim ( ::oPedPrvT:cSerPed ) + "/" + AllTrim ( Str( ::oPedPrvT:nNumPed ) ) + "/" + AllTrim ( ::oPedPrvT:cSufPed )

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc( ::oPedPrvT:OrdKeyNo() )

      ::oPedPrvT:Skip()

   end while

   ::oMtrInf:AutoInc( ::oPedPrvT:LastRec() )

   ::oPedPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedPrvT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//