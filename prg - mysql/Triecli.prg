#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION InfRieCli()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Código",                  .f., "Código cliente"          ,  8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },         "Cliente",                 .f., "Nombre cliente"          , 25 } )
   aAdd( aCol, { "CDOCMOV", "C", 40, 0, {|| "@!" },         "Documento",               .t., "Documento"               , 40 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                   .t., "Fecha"                   , 14 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                     .f., "Nif"                     ,  8 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },         "Domicilio",               .f., "Domicilio"               , 25 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },         "Población",               .f., "Población"               , 20 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },         "Provincia",               .f., "Provincia"               , 20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                      .f., "Cod. Postal"             , 20 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                     .f., "Teléfono"                ,  7 } )
   aAdd( aCol, { "NTOTDEB", "N", 16, 3, {|| oInf:cPicOut }, "Facturado",               .t., "Total facturado"         , 10 } )
   aAdd( aCol, { "NTOTHAB", "N", 16, 3, {|| oInf:cPicOut }, "Cobrado",                 .t., "Total Cobrado"           , 10 } )

   aAdd( aIdx, { "CCODCLI", "CCODCLI + DTOS( DFECMOV )" } )

   oInf  := TRieCli():New( "Informe detallado del estado de cuentas de cliente", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli }, {|| "Cliente : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) }, {||"Total Cliente..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TRieCli FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oOrden      AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
    
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   /*
   Ficheros necesarios
   */

   ::oFacCliT  := TDataCenter():oFacCliT() 

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE  "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE  "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oAntCliT PATH ( cPatEmp() ) FILE  "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oFacCliP:End()
   ::oDbfIva:End()
   ::oAntCliT:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   local cOrden := "Cliente"

   if !::StdResource( "INF_GEN16A" )
      return .f.
   end if

   /*
   Montamos clientes
   */

   ::oDefCliInf( 70, 80, 90, 100 )

   /*
   Montamos agentes
   */

   ::oDefAgeInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bValid         := {|| .t. }
   local lExcCero       := .f.
   local nTotalPagado   := 0

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oFacCliT:GoTop()

   /*
   Nos movemos por las cabeceras de los facturas de clientes-------------------
	*/

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Agente  : " + if ( !Empty( ::cAgeOrg ),( ::cAgeOrg + " > " + ::cAgeDes ), "Ninguno" ) } }

   WHILE !::oFacCliT:Eof()

      /*
      Condiciones de liquidación, fechas, clientes, agentes y rutas------------
      */

      if ::oFacCliT:DFECFAC >= ::dIniInf                                                    .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                    .AND.;
         ::oFacCliT:CCODCLI >= ::cCliOrg                                                    .AND.;
         ::oFacCliT:CCODCLI <= ::cCliDes                                                    .AND.;
         if ( !Empty( ::cAgeOrg ),;
            ( ::oFacCliT:CCODAGE >= ::cAgeOrg .AND. ::oFacCliT:CCODAGE <= ::cAgeDes ),;
            .t. )                                                                           .AND.;
         if ( !Empty( ::cRutOrg ),;
            ( ::oFacCliT:CCODRUT >= ::cRutOrg .AND. ::oFacCliT:CCODRUT <= ::cRutDes ),;
            .t. )                                                                           .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Si cumple todas, empezamos a añadir
         */

         ::oDbf:Append()

         ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
         ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
         ::oDbf:DFECMOV := ::oFacCliT:DFECFAC
         ::oDbf:NTOTDEB := nTotFacCli( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )
         ::oDbf:NTOTHAB := 0
         ::oDbf:CDOCMOV := "Factura " + ::oFacCliT:CSERIE + "/" + Str( ::oFacCliT:NNUMFAC ) + "/" + ::oFacCliT:CSUFFAC

         /*
         Datos del cliente en cuestion
         */

         ::AddCliente( ::oFacCliT:CCODCLI, ::oFacCliT, .f. )

         ::oDbf:Save()

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Recibos de clientes---------------------------------------------------------
   */

   ::oFacCliP:GoTop()
   WHILE !::oFacCliP:Eof()

      /*
      Condiciones de liquidación, fechas, clientes, agentes y rutas------------
      */

      if ::oFacCliP:lCobrado                                                                .AND.;
         ::oFacCliP:dEntrada >= ::dIniInf                                                   .AND.;
         ::oFacCliP:dEntrada <= ::dFinInf                                                   .AND.;
         ::oFacCliP:cCodCli >= ::cCliOrg                                                    .AND.;
         ::oFacCliP:cCodCli <= ::cCliDes                                                    .AND.;
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
         ::oDbf:CDOCMOV := "Recibo " + ::oFacCliP:CSERIE + "/" + Str( ::oFacCliP:NNUMFAC ) + "/" + ::oFacCliP:CSUFFAC + "/" + Str( ::oFacCliP:nNumRec )

         /*
         Datos del cliente en cuestion-------------------------------------------
         */

         ::AddCliente( ::oFacCliP:cCodCli, ::oFacCliP, .f. )

         ::oDbf:Save()

      end if

      ::oFacCliP:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//