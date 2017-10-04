#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TICtaPrv FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  oOrden      AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacPrvP    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodPrv", "C", 12, 0, {|| "@!" },      "Código",                  .f., "Cod. proveedor"          ,  8, .f. )
   ::AddField ( "cNomPrv", "C", 50, 0, {|| "@!" },      "Proveedor",               .f., "Nombre proveedor"        , 25, .f. )
   ::AddField ( "cDocMov", "C", 40, 0, {|| "@!" },      "Documento",               .t., "Documento"               , 40, .f. )
   ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },      "Fecha",                   .t., "Fecha"                   , 14, .f. )
   ::AddField ( "cNifPrv", "C", 15, 0, {|| "@!" },      "Nif",                     .f., "Nif"                     ,  8, .f. )
   ::AddField ( "cDomPrv", "C", 35, 0, {|| "@!" },      "Domicilio",               .f., "Domicilio"               , 25, .f. )
   ::AddField ( "cPobPrv", "C", 25, 0, {|| "@!" },      "Población",               .f., "Población"               , 20, .f. )
   ::AddField ( "cProPrv", "C", 20, 0, {|| "@!" },      "Provincia",               .f., "Provincia"               , 20, .f. )
   ::AddField ( "cCdpPrv", "C",  7, 0, {|| "@!" },      "CP",                      .f., "Cod. Postal"             , 20, .f. )
   ::AddField ( "cTlfPrv", "C", 12, 0, {|| "@!" },      "Tlf",                     .f., "Teléfono"                ,  7, .f. )
   ::AddField ( "nTotDeb", "N", 16, 3, {|| ::cPicIn },  "Facturado",               .t., "Total facturado"         , 12, .t. )
   ::AddField ( "nTotHab", "N", 16, 3, {|| ::cPicIn },  "Pagado",                  .t., "Total pagado"            , 12, .t. )
   ::AddField ( "nTotSal", "N", 16, 3, {|| ::cPicIn },  "Saldo",                   .t., "Saldo"                   , 12, .f. )

   ::AddTmpIndex ( "cCodPrv", "cCodPrv + DTOS( DFECMOV )" )
   ::AddGroup( {|| ::oDbf:cCodPrv }, {|| "Proveedor : " + Rtrim( ::oDbf:cCodPrv ) + "-" + oRetFld( ::oDbf:cCodPrv, ::oDbfPrv ) }, {||"Total proveedor..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE  "FacPrvT.DBF" VIA ( cDriver() ) SHARED INDEX "FacPrvT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE  "FacPrvL.DBF" VIA ( cDriver() ) SHARED INDEX "FacPrvL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE  "FacPrvP.DBF" VIA ( cDriver() ) SHARED INDEX "FacPrvP.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE  "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

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

   if !::StdResource( "INF_GEN16B" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   /*
   Montamos Proveedores
   */

   if !::oDefPrvInf( 70, 80, 90, 100, 900 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nSalAnt        := 0
   local cCodPrv        := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()


   ::oFacPrvT:GoTop()

   ::aHeader   := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Proveedor: " + AllTrim ( ::cPrvOrg ) + " > " + AllTrim ( ::cPrvDes ) } }

   WHILE !::lBreak .and. !::oFacPrvT:Eof()

      /*
      Condiciones de liquidación, fechas, Prventes, agentes y rutas------------
      */

      if ::oFacPrvT:dFecFac >= ::dIniInf                                                              .AND.;
         ::oFacPrvT:dFecFac <= ::dFinInf                                                              .AND.;
         ( ::lAllPrv .or. ( ::oFacPrvT:cCodPrv >= ::cPrvOrg .AND. ::oFacPrvT:cCodPrv <= ::cPrvDes ) ) .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         /*
         Si cumple todas, empezamos a añadir
         */

         ::oDbf:Append()

         ::oDbf:cCodPrv := ::oFacPrvT:cCodPrv
         ::oDbf:cNomPrv := ::oFacPrvT:cNomPrv
         ::oDbf:dFecMov := ::oFacPrvT:dFecFac
         ::oDbf:nTotDeb := nTotFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, nil, ::cDivInf, .f. )
         ::oDbf:nTotHab := 0
         ::oDbf:cDocMov := "Factura " + lTrim ( ::oFacPrvT:cSerFac ) + "/" + lTrim ( Str( ::oFacPrvT:NNUMFAC ) ) + "/" + lTrim ( ::oFacPrvT:CSUFFAC )

         /*
         Datos del Prvente en cuestion
         */

         ::AddProveedor( ::oFacPrvT:cCodPrv )

         ::oDbf:Save()

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   /*
   Recibos de Proveedores------------------------------------------------------
   */

   ::oFacPrvP:GoTop()
   WHILE !::lBreak .and. !::oFacPrvP:Eof()

      cCodPrv  := cCodFacPrv( ::oFacPrvP:cSerFac + Str( ::oFacPrvP:nNumFac ) + ::oFacPrvP:cSufFac, ::oFacPrvT )

      /*
      Condiciones de liquidación, fechas, Prventes, agentes y rutas------------
      */

      if ::oFacPrvP:lCobrado                                                                 .AND.;
         ::oFacPrvP:dEntrada >= ::dIniInf                                                    .AND.;
         ::oFacPrvP:dEntrada <= ::dFinInf                                                    .AND.;
         cCodPrv >= ::cPrvOrg                                                                .AND.;
         cCodPrv <= ::cPrvDes                                                                .AND.;
         lChkSer( ::oFacPrvP:cSerFac, ::aSer )

         /*
         Si cumple todas, empezamos a añadir-----------------------------------
         */

         ::oDbf:Append()

         ::oDbf:cCodPrv := cCodPrv
         ::oDbf:cNomPrv := RetProvee( cCodPrv, ::oDbfPrv:cAlias )
         ::oDbf:dFecMov := ::oFacPrvP:dEntrada
         ::oDbf:nTotDeb := 0
         ::oDbf:nTotHab := nTotRecPrv( ::oFacPrvP:cAlias, ::oDbfDiv:cAlias )
         ::oDbf:cDocMov := "Recibo " + lTrim ( ::oFacPrvP:cSerFac ) + "/" + lTrim ( Str( ::oFacPrvP:nNumFac ) ) + "/" + lTrim ( ::oFacPrvP:cSufFac ) + "/" + lTrim ( Str( ::oFacPrvP:nNumRec ) )

         /*
         Datos del Prvente en cuestion-----------------------------------------
         */

         ::AddProveedor( cCodPrv )

         ::oDbf:Save()

      end if

      ::oFacPrvP:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   // Esto es para crear los saldos--------------------------------------------

   ::oMtrInf:SetTotal( ::oDbf:Lastrec() )

   ::oDbf:GoTop()
   while !::lBreak .and. !::oDbf:eof()

      cCodPrv        := ::oDbf:cCodPrv
      nSalAnt        += ( ::oDbf:nTotDeb - ::oDbf:nTotHab )

      ::oDbf:Load()
      ::oDbf:nTotSal := nSalAnt
      ::oDbf:Save()

      ::oDbf:Skip()

      if ::oDbf:cCodPrv != cCodPrv
         nSalAnt     := 0
      end if

      ::oMtrInf:AutoInc( ::oDbf:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbf:Lastrec() )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//