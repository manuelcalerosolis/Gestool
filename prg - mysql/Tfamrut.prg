#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TFamRut FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" } ;

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodRut", "C",  4, 0, {|| "@!" },          "Ruta",      .f.,       "Código ruta",                4  )
   ::AddField( "cNomRut", "C", 30, 0, {|| "@!" },          "Nom. Ruta", .f.,       "Nombre ruta",               40  )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },          "Cli.",      .f.,       "Código cliente",             8  )
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },          "Cod.",      .t.,       "Código familia",             5  )
   ::AddField( "cNomFam", "C", 35, 0, {|| "@!" },          "Familia",   .t.,       "Nombre familia",            25  )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },          "Nombre",    .f.,       "Nombre cliente",            25  )
   ::AddField( "nNumCaj", "N", 19, 6, {|| MasUnd() },      "Caj.",      lUseCaj(), "Cajas",                     12  )
   ::AddField( "nNumUnd", "N", 19, 6, {|| MasUnd() },      "Und.",      .t.,       "Unidades",                  12  )
   ::AddField( "nUndCaj", "N", 19, 6, {|| MasUnd() },      "Tot. Und.", lUseCaj(), "Unidades por caja",         12  )
   ::AddField( "nComAge", "N", 19, 6, {|| ::cPicOut },     "Com. Age.", .f.,       "Comisión agente",           12  )
   ::AddField( "nAcuImp", "N", 19, 6, {|| ::cPicOut },     "Imp.",      .t.,       "Importe",                   12  )
   ::AddField( "nAcuCaj", "N", 19, 6, {|| MasUnd() },      "Caj. Acu.", lUseCaj(), "Cajas acumuladas" ,         12  )
   ::AddField( "nAcuUnd", "N", 19, 6, {|| MasUnd() },      "Und. Acu.", .t.,       "Unidades acumuladas" ,      12  )
   ::AddField( "nAcuUxc", "N", 19, 6, {|| MasUnd() },      "Tot. Acu.", lUseCaj(), "Acumulado cajas x unidades",12  )
   ::AddField( "nTotMov", "N", 19, 6, {|| ::cPicOut },     "Imp. Acu.", .t.,       "Importe" ,                  12  )

   ::AddTmpIndex( "CCODRUT", "CCODRUT + CCODCLI + CCODFAM" )

   ::AddGroup( {|| ::oDbf:cCodRut }, {|| "Ruta  : " + Rtrim( ::oDbf:cCodRut ) + "-" + oRetFld( ::oDbf:cCodRut, ::oDbfRut ) } , {|| "Total Ruta... "   } )
   ::AddGroup( {|| ::oDbf:cCodRut + ::oDbf:cCodCli }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) }, {|| "Total Cliente... " } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()
   ::oFacCliT:OrdSetFocus( "CCODCLI" )

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen)

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todas"

   if !::StdResource( "INFGEN21C" )
      return .f.
   end if

   /*
   Monta las rutas de manera automatica
   */

   if !::oDefRutInf( 70, 80, 90, 100, 900 )
      return .f.
   end if

   /*
   Monta los clientes de manera automatica
   */

   if !::oDefCliInf( 110, 120, 130, 140, , 600 )
      return .f.
   end if

   /*
   Monta los grupo de familias de manera automatica
   */

   if !::lDefFamInf( 150, 160, 170, 180, 500 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::SetMetInf( ::oDbfCli )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::Createfilter( aItmCli(), ::oDbfCli:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bValid   := {|| .t. }
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
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
                     {|| "Periodo : " + Dtoc( ::dIniInf )            + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Rutas   : " + AllTrim( ::cRutOrg )         + " > " + AllTrim( ::cRutDes ) },;
                     {|| "Clientes: " + AllTrim( ::cCliOrg )         + " > " + AllTrim( ::cCliDes ) },;
                     {|| "Familias: " + AllTrim( ::cFamOrg )         + " > " + AllTrim( ::cFamDes ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oDbfCli:OrdSetFocus( "COD" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfCli:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfCli:cFile ), ::oDbfCli:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   /*
   Nos movemos por los clientes porque tefesa quiere que le digamos aquellos que no consumen
   */

   ::oDbfCli:GoTop()
   while !::lBreak .and. !::oDbfCli:Eof()

      if ( ::lAllCli .or. ( ::oDbfCli:Cod >= ::cCliOrg .and. ::oDbfCli:Cod <= ::cCliDes ) )

      /*
      Buscamos el cliente en las cabeceras - si lo encontramos . . .
      */

         if ::oFacCliT:Seek( ::oDbfCli:Cod )

            while ::oDbfCli:Cod == ::oFacCliT:cCodCli .and. !::oFacCliT:eof()

            /*
            Comprobamos que cumple las condiciones
            */

            if ( ::lAllRut .or. ( ::oFacCliT:cCodRut >= ::cRutOrg .and. ::oFacCliT:cCodRut <= ::cRutDes ) ) .and.;
               lChkSer( ::oFacCliT:cSerie, ::aSer )                                                         .and.;
               Eval( bValid )

               if ( ::oFacCliT:dFecFac >= ::dIniInf .and. ::oFacCliT:dFecFac <= ::dFinInf )

                  if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

                     while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and. !::oFacCliL:eof()

                        if !Empty( ::oFacCliL:cCodFam )                                                                 .and.;
                           ( ::lAllFam .or. ( ::oFacCliL:cCodFam >= ::cFamOrg .and. ::oFacCliL:cCodFam <= ::cFamDes ) ) .and.;
                           !::oFacCliL:lTotLin                                                                          .and.;
                           !::oFacCliL:lControl

                           /*
                           Cumple todas y añadimos
                           */

                           if !::oDbf:Seek( ::oFacCliT:cCodRut + ::oFacCliT:cCodCli + ::oFacCliL:cCodFam )

                              ::oDbf:Append()
                              ::oDbf:Blank()

                              ::oDbf:cCodRut := ::oFacCliT:cCodRut
                              ::oDbf:cNomRut := oRetFld( ::oFacCliT:cCodRut, ::oDbfRut )
                              ::oDbf:cCodCli := ::oFacCliT:cCodCli
                              ::oDbf:cCodFam := ::oFacCliL:cCodFam
                              ::oDbf:cNomFam := cNomFam( ::oFacCliL:cCodFam, ::oDbfFam )
                              ::oDbf:cNomCli := ::oFacCliT:cNomcli
                              ::oDbf:nNumCaj := ::oFacCliL:nCanEnt
                              ::oDbf:nNumUnd := ::oFacCliL:nUniCaja
                              ::oDbf:nUndCaj := nTotNFacCli( ::oFacCliL )
                              ::oDbf:nComAge := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv  )
                              ::oDbf:nAcuImp := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f. )
                              ::oDbf:nAcuCaj := ::oFacCliL:nCanEnt
                              ::oDbf:nAcuUnd := ::oFacCliL:nUniCaja
                              ::oDbf:nAcuUxc := nTotNFacCli( ::oFacCliL )
                              ::oDbf:nTotMov := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f. )

                              ::oDbf:Save()

                           else

                              ::oDbf:Load()

                              ::oDbf:nNumCaj += ::oFacCliL:nCanEnt
                              ::oDbf:nNumUnd += ::oFacCliL:nUniCaja
                              ::oDbf:nUndCaj += nTotNFacCli( ::oFacCliL )
                              ::oDbf:nComAge += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                              ::oDbf:nAcuImp += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f. )
                              ::oDbf:nAcuCaj += ::oFacCliL:nCanEnt
                              ::oDbf:nAcuUnd += ::oFacCliL:nUniCaja
                              ::oDbf:nAcuUxc += nTotNFacCli( ::oFacCliL )
                              ::oDbf:nTotMov += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f. )

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

                        if !Empty( ::oFacCliL:cCodFam )                                                                 .and. ;
                           ( ::lAllFam .or. ( ::oFacCliL:cCodFam >= ::cFamOrg .and. ::oFacCliL:cCodFam <= ::cFamDes ) ) .and. ;
                           !::oFacCliL:lTotLin                                                                          .and. ;
                           !::oFacCliL:lControl

                           /*
                           Si no está añadimos solo el acumulado
                           */

                           if !::oDbf:Seek( ::oFacCliT:cCodRut + ::oFacCliT:cCodCli + ::oFacCliL:cCodFam )

                              ::oDbf:Append()
                              ::oDbf:Blank()

                              ::oDbf:cCodRut := ::oFacCliT:cCodRut
                              ::oDbf:cCodCli := ::oFacCliT:cCodCli
                              ::oDbf:cCodFam := ::oFacCliL:cCodFam
                              ::oDbf:cNomFam := cNomFam( ::oFacCliL:cCodFam, ::oDbfFam )
                              ::oDbf:cNomCli := ::oFacCliT:cNomcli
                              ::oDbf:nAcuCaj += ::oFacCliL:nCanEnt
                              ::oDbf:nAcuUnd += ::oFacCliL:nUniCaja
                              ::oDbf:nAcuUxc += nTotNFacCli( ::oFacCliL )
                              ::oDbf:nTotMov += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f. )

                              ::oDbf:Save()

                           else

                              /*
                              Si está acumulamos
                              */

                              ::oDbf:Load()

                              ::oDbf:nAcuCaj += ::oFacCliL:nCanEnt
                              ::oDbf:nAcuUnd += ::oFacCliL:nUniCaja
                              ::oDbf:nAcuUxc += nTotNFacCli( ::oFacCliL )
                              ::oDbf:nTotMov += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f. )

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

      end if

      ::oDbfCli:Skip()

      ::RefMetInf( ::oDbfCli:OrdKeyNo() )

   end while

   ::oDbfCli:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfCli:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfCli:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//