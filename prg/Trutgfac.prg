#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRutGrpFam FROM TInfGen

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

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD Suma()

   METHOD Acumula()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODRUT", "C",  4, 0, {|| "@!" },          "Ruta",         .f.,        "Código ruta",                4  )
   ::AddField( "CNOMRUT", "C", 30, 0, {|| "@!" },          "Nombre ruta",  .f.,        "Nombre ruta",               30  )
   ::AddField( "CCODCLI", "C", 12, 0, {|| "@!" },          "Cli.",         .f.,        "Código cliente",             8  )
   ::AddField( "CCODFAM", "C", 16, 0, {|| "@!" },          "Cod.",         .t.,        "Código grupo de familia",    5  )
   ::AddField( "CNOMGRF", "C", 35, 0, {|| "@!" },          "Gru. Fam.",    .t.,        "Nombre grupo de familia",   25  )
   ::AddField( "CNOMCLI", "C", 50, 0, {|| "@!" },          "Nombre",       .f.,        "Nombre cliente",            25  )
   ::AddField( "NNUMCAJ", "N", 19, 6, {|| MasUnd() },      "Caj.",         lUseCaj(),  "Cajas",                     12  )
   ::AddField( "NNUMUND", "N", 19, 6, {|| MasUnd() },      "Und.",         .t.,        "Unidades",                  12  )
   ::AddField( "NUNDCAJ", "N", 19, 6, {|| MasUnd() },      "Tot. Und.",    lUseCaj(),  "Unidades por caja",         12  )
   ::AddField( "NCOMAGE", "N", 19, 6, {|| ::cPicOut },     "Com. Age.",    .f.,        "Comisión agente",           12  )
   ::AddField( "NACUIMP", "N", 19, 6, {|| ::cPicOut },     "Imp.",         .t.,        "Importe",                   12  )
   ::AddField( "NACUCAJ", "N", 19, 6, {|| MasUnd() },      "Caj. Acu.",    lUseCaj(),  "Cajas acumuladas" ,         12  )
   ::AddField( "NACUUND", "N", 19, 6, {|| MasUnd() },      "Und. Acu.",    .t.,        "Unidades acumuladas" ,      12  )
   ::AddField( "NACUUXC", "N", 19, 6, {|| MasUnd() },      "Tot. Acu.",    lUseCaj(),  "Acumulado cajas x unidades",12  )
   ::AddField( "NTOTMOV", "N", 19, 6, {|| ::cPicOut },     "Imp. Acu.",    .t.,        "Importe" ,                  12  )

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

   DATABASE NEW ::oDbfFam PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
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
    
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if
   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
    
   ::oDbfArt  := nil
   ::oDbfFam  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todas"
   local cGrupBox

   if !::StdResource( "INFGEN21B" )
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

   if !::oDefGrFInf( 150, 160, 170, 180, 500 )
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

   ::CreateFilter( aItmCli(), ::oDbfCli:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//

/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cGruFam
   local bValid   := {|| .t. }
   local lExcCero := .f.

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

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf )         + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Rutas   : " + AllTrim( ::cRutOrg )      + " > " + AllTrim( ::cRutDes ) },;
                        {|| "Clientes: " + AllTrim( ::cCliOrg )      + " > " + AllTrim( ::cCliDes ) },;
                        {|| "Grp. Fam: " + AllTrim( ::cGruFamOrg )   + " > " + AllTrim( ::cGruFamDes )},;
                        {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oDbfCli:OrdSetFocus( "COD" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfCli:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfCli:cFile ), ::oDbfCli:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oDbfCli:GoTop()

   while !::lBreak .and. !::oDbfCli:Eof()

   if ( ::lAllCli .or. ( ::oDbfCli:Cod >= ::cCliOrg .and. ::oDbfCli:Cod <= ::cCliDes ) )

      if ::oFacCliT:Seek( ::oDbfCli:Cod )

         while ::oDbfCli:Cod == ::oFacCliT:cCodCli .and. !::oFacCliT:eof()

         /*
         Comprobamos que cumple las condiciones
         */

         if ( ::lAllRut .or. ( ::oFacCliT:cCodRut >= ::cRutOrg .and. ::oFacCliT:cCodRut <= ::cRutDes ) ) .and.;
            ( ::lAllCli .or. ( ::oFacCliT:cCodCli >= ::cCliOrg .and. ::oFacCliT:cCodCli <= ::cCliDes ) ) .and.;
            lChkSer( ::oFacCliT:cSerie, ::aSer )                                                         .and.;
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

                     cGruFam  := cGruFam( cCodFam( ::oFacCliL:cRef, ::oDbfArt ), ::oDbfFam )

                     if !Empty( cGruFam )         .and. ;
                        ( ::lAllGrp .or. ( cGruFam >= ::cGruFamOrg .and. cGruFam <= ::cGruFamDes ) ) .and. ;
                        !::oFacCliL:lTotLin                                                          .and. ;
                        !::oFacCliL:lControl

                     /*
                     Cumple todas y añadimos
                     */

                     if !::oDbf:Seek( ::oFacCliT:cCodRut + ::oFacCliT:cCodCli + cGruFam )

                        ::oDbf:Append()
                        ::oDbf:Blank()

                        ::oDbf:cCodRut := ::oFacCliT:cCodRut
                        ::oDbf:cNomRut := oRetFld( ::oFacCliT:cCodRut, ::oDbfRut )
                        ::oDbf:cCodCli := ::oFacCliT:cCodCli
                        ::oDbf:cCodFam := cGruFam( cCodFam( ::oFacCliL:cRef, ::oDbfArt ), ::oDbfFam )
                        ::oDbf:cNomGrF := retGruFam( cGruFam( cCodFam( ::oFacCliL:cRef, ::oDbfArt ), ::oDbfFam ), ::oGruFam )
                        ::oDbf:cNomCli := ::oFacCliT:cNomcli
                        ::Suma()
                        ::Acumula()

                        ::oDbf:Save()

                     else

                        ::oDbf:Load()

                        ::Suma()
                        ::Acumula()

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
                        ( ::lAllGrp .or. ( cGruFam >= ::cGruFamOrg .and. cGruFam <= ::cGruFamDes ) ) .and. ;
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
                           ::Acumula()

                           ::oDbf:Save()

                        else

                           /*
                           Si está acumulamos
                           */

                           ::oDbf:Load()
                           ::Acumula()
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

METHOD Suma()

   ::oDbf:nNumCaj += ::oFacCliL:nCanEnt
   ::oDbf:nNumUnd += ::oFacCliL:nUniCaja
   ::oDbf:nUndCaj += nTotNFacCli( ::oFacCliL )
   ::oDbf:nComAge += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
   ::oDbf:nAcuImp += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Acumula()

   ::oDbf:nAcuCaj += ::oFacCliL:nCanEnt
   ::oDbf:nAcuUnd += ::oFacCliL:nUniCaja
   ::oDbf:nAcuUxc += nTotNFacCli( ::oFacCliL )
   ::oDbf:nTotMov += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

RETURN ( Self )

//---------------------------------------------------------------------------//