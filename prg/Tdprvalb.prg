#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDiaPAlb FROM TPrvInf

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "No facturados", "Facturados", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

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

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT  PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL  PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

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
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oDbfPrv  := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INFDIAPRV" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   if !::oDefPrvInf( 70, 80, 90, 100, 900 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbPrvT:Lastrec() )

   ::oDefExcInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmAlbPrv(), ::oAlbPrvT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local aTotTmp  := {}

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Proveedor : " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim( ::cPrvDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'nFacturado == 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + ::cPrvOrg + '" .and. cCodPrv <= "' + ::cPrvDes + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )

   ::oAlbPrvT:GoTop()

   while !::lBreak .and. !::oAlbPrvT:Eof()

      if lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::AddProveedor( ::oAlbPrvT:cCodPrv )
         ::oDbf:dFecMov := ::oAlbPrvT:dFecAlb

         aTotTmp        := aTotAlbPrv( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, nil, ::cDivInf )

         ::oDbf:nTotNet := aTotTmp[1]
         ::oDbf:nTotIva := aTotTmp[2]
         ::oDbf:nTotReq := aTotTmp[3]
         ::oDbf:nTotDoc := aTotTmp[4]
         ::oDbf:cDocMov := AllTrim ( ::oAlbPrvT:cSerAlb ) + "/" + AllTrim ( Str( ::oAlbPrvT:nNumAlb ) ) + "/" + AllTrim ( ::oAlbPrvT:cSufAlb )

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

      ::oAlbPrvT:Skip()

   end while

   ::oMtrInf:AutoInc( ::oAlbPrvT:LastRec() )

   ::oAlbPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbPrvT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//