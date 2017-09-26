#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRutFam FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
    
   DATA  oGrupBox    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" } ;

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD Activate()

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodRut", "C",  4, 0, {|| "@!" },          "Ruta",      .f., "Código ruta",                4  )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },          "Cli.",      .f., "Código cliente",             8  )
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },          "Cod.",      .t., "Código grupo de familia",    5  )
   ::AddField( "cNomGrf", "C", 35, 0, {|| "@!" },          "Gru. fam.", .t., "Nombre grupo de familia",   25  )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },          "Nombre",    .f., "Nombre cliente",            25  )
   ::AddField( "nNumCaj", "N", 19, 6, {|| MasUnd() },      "Caj.",      .f., "Cajas",                     12  )
   ::AddField( "nNumUnd", "N", 19, 6, {|| MasUnd() },      "Und.",      .t., "Unidades",                  12  )
   ::AddField( "nUndCaj", "N", 19, 6, {|| MasUnd() },      "Tot. und.", .f., "Total unidades",            12  )
   ::AddField( "nTotPes", "N", 19, 6, {|| MasUnd() },      "Tot. pes.", .f., "Total peso",                12  )
   ::AddField( "nComAge", "N", 19, 6, {|| oInf:cPicOut  }, "Com. age.", .f., "Comisión agente",           12  )
   ::AddField( "nAcuImp", "N", 19, 6, {|| oInf:cPicOut  }, "Imp.",      .t., "Importe",                   12  )
   ::AddField( "nAcuCaj", "N", 19, 6, {|| MasUnd() },      "Caj. acu.", .f., "Cajas acumuladas" ,         12  )
   ::AddField( "nAcuUnd", "N", 19, 6, {|| MasUnd() },      "Und. acu.", .t., "Unidades acumuladas" ,      12  )
   ::AddField( "nAcuUxc", "N", 19, 6, {|| MasUnd() },      "Tot. acu.", .f., "Total unidades acumuladas", 12  )
   ::AddField( "nAcuPes", "N", 19, 6, {|| MasUnd() },      "Pes. acu.", .f., "Total peso acumulado",      12  )
   ::AddField( "nTotMov", "N", 19, 6, {|| oInf:cPicOut },  "Imp. acu.", .t., "Importe" ,                  12  )

   ::AddTmpIndex( "CCODRUT", "CCODRUT + CCODCLI + CCODFAM" )

   ::AddGroup( {|| ::oDbf:cCodRut }, {|| "Ruta  : " + Rtrim( ::oDbf:cCodRut ) + "-" + oRetFld( ::oDbf:cCodRut, ::oDbfRut ) } , {|| "Total Ruta... "   } )
   ::AddGroup( {|| ::oDbf:cCodRut + ::oDbf:cCodCli }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) }, {|| "Total Cliente... " } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   /*
   Ficheros necesarios
   */

   ::oFacCliT := TDataCenter():oFacCliT()
   ::oFacCliT:OrdSetFocus( "CCODCLI" )

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfFam PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oFacCliT:End()
   ::oFacCliL:End()
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   local cEstado := "Todas"
   local cGrupBox

   if !::StdResource( "INF_GEN21A" )
      return .f.
   end if

   /*
   Monta las rutas de manera automatica
   */

   ::oDefRutInf( 70, 80, 90, 100 )

   /*
   Monta los clientes de manera automatica
   */

   ::oDefCliInf( 110, 120, 130, 140 )

   /*
   Monta los grupo de familias de manera automatica
   */

   ::oDefGrfInf( 150, 160, 170, 180 )

   /*
   Damos valor al meter
   */

   ::SetMetInf( ::oDbfCli )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GROUP ::oGrupBox VAR cGrupBox ;
      ID       888 ;
      TRANSPARENT ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TInfGen

   ::oDlg:bStart  := {|| ::oGrupBox:SetText( "Grupos de Familias" ) }

   ACTIVATE DIALOG ::oDlg CENTER

RETURN ( ::oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cGruFam
   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Rutas   : " + AllTrim( ::cRutOrg )        + " > " + AllTrim( ::cRutDes ) },;
                     {|| "Clientes: " + AllTrim( ::cCliOrg )        + " > " + AllTrim( ::cCliDes ) },;
                     {|| "Grp. Fam: " + AllTrim( ::cGruFamOrg )     + " > " + AllTrim( ::cGruFamDes )},;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por los clientes porque tefesa quiere que le digamos aquellos que no consumen
   */

   ::oDbfCli:Seek( ::cCliOrg, .t. )
   while ::oDbfCli:Cod <= ::cCliDes .and. !::oDbfCli:Eof()

   /*
   Buscamos el cliente en las cabeceras - si lo encontramos . . .
   */

      if ::oFacCliT:Seek( ::oDbfCli:Cod )

         while ::oDbfCli:Cod == ::oFacCliT:cCodCli .and. !::oFacCliT:eof()

         /*
         Comprobamos que cumple las condiciones
         */

         if ::oFacCliT:cCodRut >= ::cRutOrg        .and.;
            ::oFacCliT:cCodRut <= ::cRutDes        .and.;
            ::oFacCliT:cCodCli >= ::cCliOrg        .and.;
            ::oFacCliT:cCodCli <= ::cCliDes        .and.;
            lChkSer( ::oFacCliT:cSerie, ::aSer )   .and.;
            Eval( bValid )

            /*
            Comprobamos condiciones de fechas para el acumulado
            */

            if ::oFacCliT:dFecFac >= ::dIniInf     .and.;
               ::oFacCliT:dFecFac <= ::dFinInf

               /*
               Nos posicionamos en las líneas del documento para ver las unidades de los artículos
               */

               if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

                  while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and. !::oFacCliL:eof()

                     cGruFam := cGruFam( cCodFam( ::oFacCliL:cRef, ::oDbfArt ), ::oDbfFam )

                     if !Empty( cGruFam )         .and. ;
                        cGruFam >= ::cGruFamOrg   .and. ;
                        cGruFam <= ::cGruFamDes   .and. ;
                        !::oFacCliL:lTotLin       .and. ;
                        !::oFacCliL:lControl

                     /*
                     Cumple todas y añadimos
                     */

                     if !::oDbf:Seek( ::oFacCliT:cCodRut + ::oFacCliT:cCodCli + cGruFam )

                        ::oDbf:Append()
                        ::oDbf:Blank()

                        ::oDbf:cCodRut := ::oFacCliT:cCodRut
                        ::oDbf:cCodCli := ::oFacCliT:cCodCli
                        ::oDbf:cCodFam := cGruFam( cCodFam( ::oFacCliL:cRef, ::oDbfArt ), ::oDbfFam )
                        ::oDbf:cNomGrf := retGruFam( cGruFam( cCodFam( ::oFacCliL:cRef, ::oDbfArt ), ::oDbfFam ), ::oGruFam )
                        ::oDbf:cNomCli := ::oFacCliT:cNomcli
                        ::oDbf:nNumCaj := ::oFacCliL:nCanEnt
                        ::oDbf:nNumUnd := ::oFacCliL:nUniCaja
                        ::oDbf:nUndCaj := nTotNFacCli( ::oFacCliL )
                        ::oDbf:nTotPes := nTotNFacCli( ::oFacCliL ) * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
                        ::oDbf:nComAge := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv  )
                        ::oDbf:nAcuImp := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                        ::oDbf:nAcuCaj := ::oFacCliL:nCanEnt
                        ::oDbf:nAcuUnd := ::oFacCliL:nUniCaja
                        ::oDbf:nAcuUxc := nTotNFacCli( ::oFacCliL )
                        ::oDbf:nAcuPes := nTotNFacCli( ::oFacCliL ) * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
                        ::oDbf:nTotMov := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                        ::oDbf:Save()

                     else

                        ::oDbf:Load()

                        ::oDbf:nNumCaj += ::oFacCliL:nCanEnt
                        ::oDbf:nNumUnd += ::oFacCliL:nUniCaja
                        ::oDbf:nUndCaj += nTotNFacCli( ::oFacCliL )
                        ::oDbf:nComAge += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nAcuImp += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                        ::oDbf:nAcuCaj += ::oFacCliL:nCanEnt
                        ::oDbf:nAcuUnd += ::oFacCliL:nUniCaja
                        ::oDbf:nAcuUxc += nTotNFacCli( ::oFacCliL )
                        ::oDbf:nTotMov += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                        ::oDbf:Save()

                     end if

                  end if

                  ::oFacCliL:Skip()

                  end while

               end if

            else

               /*
               no cumple fechas, sólo acumulamos
               */

               if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

                  while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and. !::oFacCliL:eof()

                     /*
                     Comprobamos los grupos de familias
                     */

                     cGruFam := cGruFam( cCodFam( ::oFacCliL:cRef, ::oDbfArt ), ::oDbfFam )

                     if !Empty( cGruFam )         .and. ;
                        cGruFam >= ::cGruFamOrg   .and. ;
                        cGruFam <= ::cGruFamDes   .and. ;
                        !::oFacCliL:lTotLin       .and. ;
                        !::oFacCliL:lControl

                        /*
                        Si no está añadimos solo el acumulado
                        */

                        if !::oDbf:Seek( ::oFacCliT:cCodRut + ::oFacCliT:cCodCli + cGruFam )

                           ::oDbf:Append()
                           ::oDbf:Blank()

                           ::oDbf:cCodRut := ::oFacCliT:cCodRut
                           ::oDbf:cCodCli := ::oFacCliT:cCodCli
                           ::oDbf:cCodFam := cGruFam( cCodFam( ::oFacCliL:cRef, ::oDbfArt ), ::oDbfFam )
                           ::oDbf:cNomGrF := retGruFam( ( cGruFam( cCodFam( ::oFacCliL:cRef, ::oDbfArt ), ::oDbfFam ) ), ::oGruFam )
                           ::oDbf:cNomCli := ::oFacCliT:cNomcli
                           ::oDbf:nAcuCaj := ::oFacCliL:nCanEnt
                           ::oDbf:nAcuUnd := ::oFacCliL:nUniCaja
                           ::oDbf:nAcuUxc := nTotNFacCli( ::oFacCliL )
                           ::oDbf:nAcuPes := nTotNFacCli( ::oFacCliL ) * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
                           ::oDbf:nTotMov := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                           ::oDbf:Save()

                        else

                           /*
                           Si está acumulamos
                           */

                           ::oDbf:Load()

                           ::oDbf:nAcuCaj += ::oFacCliL:nCanEnt
                           ::oDbf:nAcuUnd += ::oFacCliL:nUniCaja
                           ::oDbf:nAcuUxc += nTotNFacCli( ::oFacCliL )
                           ::oDbf:nAcuPes += nTotNFacCli( ::oFacCliL ) * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
                           ::oDbf:nTotMov += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                           ::oDbf:Save()

                        end if

                     end if

                     ::oFacCliL:Skip()

                  end while

               end if

            end if

         end if

         ::oFacCliT:Skip()

         end while

      end if

      ::oDbfCli:Skip()

      ::RefMetInf( ::oDbfCli:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbfCli:LastRec() )
   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

FUNCTION cGruFam( cCodFam, oDbfFam )

   local cCodGrf  := ""

   if oDbfFam:Seek( cCodFam )
      cCodGrf     := oDbfFam:cCodGrp
   end if

RETURN ( cCodGrf )

//---------------------------------------------------------------------------//

FUNCTION retGruFam( cCodGrf, oDbfGrf )

   local cNombre  := ""

   if oDbfGrf:oDbf:Seek( cCodGrf )
      cNombre     := oDbfGrf:oDbf:cNomGrp
   end if

RETURN ( cNombre )

//---------------------------------------------------------------------------//