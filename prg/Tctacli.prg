#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TICtaCli FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oOrden      AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "CCODCLI", "C", 12, 0, {|| "@!" },         "Código",                  .f., "Código cliente"          ,  8, .f. )
   ::AddField ( "CNOMCLI", "C", 50, 0, {|| "@!" },         "Cliente",                 .f., "Nombre cliente"          , 25, .f. )
   ::AddField ( "CDOCMOV", "C", 40, 0, {|| "@!" },         "Documento",               .t., "Documento"               , 40, .f. )
   ::AddField ( "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                   .t., "Fecha"                   , 12, .f. )
   ::AddField ( "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                     .f., "Nif"                     ,  8, .f. )
   ::AddField ( "CDOMCLI", "C", 35, 0, {|| "@!" },         "Domicilio",               .f., "Domicilio"               , 25, .f. )
   ::AddField ( "CPOBCLI", "C", 25, 0, {|| "@!" },         "Población",               .f., "Población"               , 20, .f. )
   ::AddField ( "CPROCLI", "C", 20, 0, {|| "@!" },         "Provincia",               .f., "Provincia"               , 20, .f. )
   ::AddField ( "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                      .f., "Cod. Postal"             , 20, .f. )
   ::AddField ( "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                     .f., "Teléfono"                ,  7, .f. )
   ::AddField ( "NTOTDEB", "N", 16, 3, {|| ::cPicOut },    "Facturado",               .t., "Facturado"               , 12, .t. )
   ::AddField ( "NTOTHAB", "N", 16, 3, {|| ::cPicOut },    "Cobrado",                 .t., "Cobrado"                 , 12, .t. )
   ::AddField ( "NTOTSAL", "N", 16, 3, {|| ::cPicOut },    "Saldo",                   .t., "Saldo"                   , 12, .f. )

   ::AddTmpIndex( "CCODCLI", "CCODCLI + DTOS( DFECMOV )" )
   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) }, {||"Total Cliente..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT     := TDataCenter():oFacCliT()  
   ::oFacCliT:OrdSetFocus( "dFecFac" )

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE  "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oAntCliT PATH ( cPatEmp() ) FILE  "AntCliT.DBF" VIA ( cDriver() ) SHARED INDEX "AntCliT.Cdx"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE  "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oFacCliT  := nil
   ::oFacCliL  := nil
   ::oFacCliP  := nil
   ::oAntCliT  := nil
   ::oDbfIva   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN16A" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   /*
   Montamos clientes
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Montamos agentes
   */

   if !::oDefAgeInf( 110, 120, 130, 140, 940 )
      return .f.
   end if

   ::oDefResInf()

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cCodCli
   local nSalAnt        := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()
   ::oFacCliT:GoTop()

   /*
   Nos movemos por las cabeceras de los facturas de clientes-------------------
	*/

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Agente  : " + if ( !Empty( ::cAgeOrg ),( ::cAgeOrg + " > " + ::cAgeDes ), "Ninguno" ) } }

   ::oFacCliT:Seek( ::dIniInf, .t. )

   WHILE ::oFacCliT:dFecFac <= ::dFinInf .and. !::lBreak .and. !::oFacCliT:Eof()

      /*
      Condiciones de liquidación, fechas, clientes, agentes y rutas------------
      */

      if ( ::lAllCli .or. ( ::oFacCliT:CCODCLI >= ::cCliOrg .AND. ::oFacCliT:CCODCLI <= ::cCliDes ) )   .AND.;
         ( ::lAgeAll .or. ( ::oFacCliT:CCODAGE >= ::cAgeOrg .AND. ::oFacCliT:CCODAGE <= ::cAgeDes ) )   .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Si cumple todas, empezamos a añadir
         */

         ::oDbf:Append()

         ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
         ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
         ::oDbf:DFECMOV := ::oFacCliT:DFECFAC
         ::oDbf:NTOTDEB := nTotFacCli( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, nil, ::cDivInf, .f. )
         ::oDbf:NTOTHAB := 0
         ::oDbf:CDOCMOV := "Factura " + lTrim ( ::oFacCliT:CSERIE ) + "/" + lTrim( Str( ::oFacCliT:NNUMFAC ) ) + "/" + lTrim( ::oFacCliT:CSUFFAC )

         /*
         Datos del cliente en cuestion
         */

         ::AddCliente( ::oFacCliT:CCODCLI, ::oFacCliT, .f. )

         ::oDbf:Save()

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   /*
   Recibos de clientes---------------------------------------------------------
   */

   ::oFacCliP:GoTop()
   WHILE !::lBreak .and. !::oFacCliP:Eof()

      /*
      Condiciones de liquidación, fechas, clientes, agentes y rutas------------
      */

      if ::oFacCliP:lCobrado                                                                          .AND.;
         ::oFacCliP:dEntrada >= ::dIniInf                                                              .AND.;
         ::oFacCliP:dEntrada <= ::dFinInf                                                             .AND.;
         ( ::lAllCli .or. ( ::oFacCliP:cCodCli >= ::cCliOrg .AND. ::oFacCliP:cCodCli <= ::cCliDes ) ) .AND.;
         lChkSer( ::oFacCliP:cSerie, ::aSer )

         /*
         Si cumple todas, empezamos a añadir-----------------------------------
         */

         ::oDbf:Append()

         ::oDbf:CCODCLI := ::oFacCliP:CCODCLI
         ::oDbf:CNOMCLI := RetClient( ::oFacCliP:CCODCLI, ::oDbfCli:cAlias )
         ::oDbf:DFECMOV := ::oFacCliP:dEntrada
         ::oDbf:NTOTDEB := 0
         ::oDbf:NTOTHAB := nTotRecCli( ::oFacCliP:cAlias, ::oDbfDiv:cAlias )
         ::oDbf:CDOCMOV := "Recibo " + lTrim ( ::oFacCliP:CSERIE ) + "/" + lTrim ( Str( ::oFacCliP:NNUMFAC ) ) + "/" + lTrim ( ::oFacCliP:CSUFFAC ) + "/" + lTrim ( Str( ::oFacCliP:nNumRec ) )

         ::oDbf:Save()

      end if

      ::oFacCliP:Skip()

      ::oMtrInf:AutoInc( ::oFacCliP:OrdKeyNo() )

   end while

   ::oMtrInf:SetTotal( ::oFacCliP:Lastrec() )

   // Esto es para crear los saldos--------------------------------------------

   ::oMtrInf:SetTotal( ::oDbf:Lastrec() )

   ::oDbf:GoTop()
   while !::lBreak .and. !::oDbf:eof()

      cCodCli        := ::oDbf:cCodCli
      nSalAnt        += ( ::oDbf:nTotDeb - ::oDbf:nTotHab )

      ::oDbf:Load()
      ::oDbf:nTotSal := nSalAnt
      ::oDbf:Save()

      ::oDbf:Skip()

      if ::oDbf:cCodCli != cCodCli
         nSalAnt     := 0
      end if

      ::oMtrInf:AutoInc( ::oDbf:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbf:Lastrec() )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//