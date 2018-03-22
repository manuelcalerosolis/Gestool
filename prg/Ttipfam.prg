#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TTipFam FROM TInfGen

   DATA  lAllCli        AS LOGIC       INIT .f.
   DATA  lAllTip        AS LOGIC       INIT .f.
   DATA  lExcCero       AS LOGIC       INIT .f.
   DATA  oFacCliT       AS OBJECT
   DATA  oFacCliL       AS OBJECT
   DATA  oEstado        AS OBJECT
   DATA  aEstado        AS ARRAY       INIT  { "Pendiente", "Liquidada", "Todas" }
   DATA  oCmbAnio       AS OBJECT
   DATA  aCmbAnio       AS ARRAY       INIT  { "Todos", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020" }
   DATA  cCmbAnio       AS CHARACTER   INIT "Todos"
   DATA  lImporteMinimo AS LOGIC       INIT .f.
   DATA  nImporteMinimo AS NUMERIC     INIT 0

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD lAppLine()

   METHOD Cabecera()

   METHOD Suma()

   METHOD Acumula()

   //METHOD IncluyeCero()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodRut", "C",  4, 0, {|| "@!" },          "Ruta",         .f., "Código ruta",                4  )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },          "Cod. cli.",    .f., "Código cliente",            12  )
   ::AddField( "cCodTip", "C",  4, 0, {|| "@!" },          "Cod. ",        .t., "Código tipo",                5  )
   ::AddField( "cNomTip", "C", 35, 0, {|| "@!" },          "Tipo artículo",.t., "Tipo de artículo",          35  )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },          "Nombre",       .f., "Nombre cliente",            35  )
   ::AddField( "nNumCaj", "N", 19, 6, {|| MasUnd() },      "Caj.",         .f., "Cajas",                     12  )
   ::AddField( "nNumUnd", "N", 19, 6, {|| MasUnd() },      "Und.",         .f., "Unidades",                  12  )
   ::AddField( "nUndCaj", "N", 19, 6, {|| MasUnd() },      "Tot. und.",    .t., "Total unidades",            12  )
   ::AddField( "nAcuImp", "N", 19, 6, {|| ::cPicOut },     "Imp.",         .t., "Importe",                   12  )
   ::AddField( "nAcuCaj", "N", 19, 6, {|| MasUnd() },      "Caj. acu.",    .f., "Cajas acumuladas" ,         12  )
   ::AddField( "nAcuUnd", "N", 19, 6, {|| MasUnd() },      "Und. acu.",    .t., "Unidades acumuladas" ,      12  )
   ::AddField( "nAcuUxc", "N", 19, 6, {|| MasUnd() },      "Tot. acu.",    .f., "Total unidades acumuladas", 12  )
   ::AddField( "nAcuPes", "N", 19, 6, {|| MasUnd() },      "Pes. acu.",    .f., "Total peso acumulado",      12  )
   ::AddField( "nTotMov", "N", 19, 6, {|| ::cPicOut },     "Imp. acu.",    .t., "Importe acumulado" ,        12  )
   ::AddField( "nComAge", "N", 19, 6, {|| ::cPicOut },     "Com. age.",    .t., "Comisión agente",           12  )

   ::AddTmpIndex( "cCodRut", "cCodRut + cCodCli + cCodTip" )

   ::AddGroup( {|| ::oDbf:cCodRut }, {|| "Ruta : " + Rtrim( ::oDbf:cCodRut ) + "-" + Rtrim( oRetFld( ::oDbf:cCodRut, ::oDbfRut ) ) }, {|| "Total Ruta... " } )
   ::AddGroup( {|| ::oDbf:cCodRut + ::oDbf:cCodCli }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) }, {|| "Total cliente... " } )

   ::bForReport   := {|| if( ::lImporteMinimo, ::oDbf:nAcuImp >= ::nImporteMinimo, .t. ) }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT     := TDataCenter():oFacCliT()   
   ::oFacCliT:OrdSetFocus( "cCodCli" )

   DATABASE NEW ::oFacCliL    PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfArt     PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

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
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado  := "Todas"

   if !::StdResource( "INF_GEN21B" )
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

   if !::oDefTipInf( 150, 160, 170, 180, 500 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::SetMetInf( ::oFacCliT )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lImporteMinimo ;
      ID       215 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::nImporteMinimo ;
      ID       210 ;
      WHEN     ::lImporteMinimo ;
      SPINNER ;
      PICTURE  ::cPicOut ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oCmbAnio VAR ::cCmbAnio ;
      ITEMS    ::aCmbAnio ;
      ID       300 ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmCli(), ::oDbfCli:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate()

   local cExpHead := ""
   local bValid   := {|| .t. }

   ::oDlg:Disable()
   ::oBtnCancel:Enable()

   ::oMtrInf:SetTotal( ::oDbfCli:Lastrec() )

   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf )    + " > " + Dtoc( ::dFinInf )    },;
                     {|| "Rutas    : " + if( ::lAllRut, "Todas", AllTrim( ::cRutOrg ) + " > " + AllTrim( ::cRutDes ) ) },;
                     {|| "Clientes : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                     {|| "Tip. Art.: " + if( ::lAllTip, "Todos", AllTrim( ::cTipOrg ) + " > " + AllTrim( ::cTipDes ) ) },;
                     {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] },;
                     {|| "Ejercicio: " + ::aCmbAnio[ ::oCmbAnio:nAt ] },;
                     {|| if( ::lImporteMinimo, "Imp. Min.: " + AllTrim ( Trans( ::nImporteMinimo , MasUnd() ) ), "" ) } }


   ::oDbfCli:OrdSetFocus( "COD" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfCli:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfCli:cFile ), ::oDbfCli:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oDbfCli:GoTop()

   while !::lBreak .and. !::oDbfCli:Eof()

      if ( ::lAllRut .or. ( ::oDbfCli:cCodRut >= ::cRutOrg .and. ::oDbfCli:cCodRut <= ::cRutDes  ) ) .and.;
         ( ::lAllCli .or. ( ::oDbfCli:Cod >= ::cCliOrg .and. ::oDbfCli:Cod <= ::cCliDes ) )

      if ::lAllCli
         ::oDbf:Append()
         ::oDbf:Blank()
         ::oDbf:cCodRut := ::oDbfCli:cCodRut
         ::oDbf:cCodCli := ::oDbfCli:Cod
         ::oDbf:cNomCli := ::oDbfCli:Titulo
         ::oDbf:Save()
      end if

      /*
      Buscamos el cliente en las cabeceras - si lo encontramos . . .
      */

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

            ::lAppLine( ::oFacCliT:dFecFac >= ::dIniInf .and. ::oFacCliT:dFecFac <= ::dFinInf )

         end if

         ::oFacCliT:Skip()

         end while

      end if

      end if

      ::oDbfCli:Skip()

      ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

   end while

   ::oDbfCli:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfCli:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfCli:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD lAppLine( lSuma )

   /*
   Nos posicionamos en las líneas del documento para ver las unidades de los artículos
   */

   if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

      while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and. !::oFacCliL:eof()

         if ::oDbfArt:Seek( ::oFacCliL:cRef )

            if ( ::lAllTip .or. ( ::oDbfArt:cCodTip >= ::cTipOrg .and. ::oDbfArt:cCodTip <= ::cTipDes ) ) .and. ;
               !::oFacCliL:lTotLin                                                                        .and. ;
               !::oFacCliL:lControl

               /*
               Cumple todas y añadimos
               */

               if !::oDbf:Seek( ::oFacCliT:cCodRut + ::oFacCliT:cCodCli + ::oDbfArt:cCodTip )

                  ::oDbf:Append()
                  ::oDbf:Blank()

                  ::Cabecera()

                  if lSuma
                     ::Suma()
                  end if

                  if ( ::cCmbAnio == "Todos" .or. Val( ::cCmbAnio ) == Year( ::oFacCliT:dFecFac ) )
                     ::Acumula()
                  end if

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  if lSuma
                     ::Suma()
                  end if

                  if ( ::cCmbAnio == "Todos" .or. Val( ::cCmbAnio ) == Year( ::oFacCliT:dFecFac ) )
                     ::Acumula()
                  end if

                  ::oDbf:Save()

               end if

            end if

         end if

         ::oFacCliL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Cabecera()

   ::oDbf:cCodRut := ::oFacCliT:cCodRut
   ::oDbf:cCodCli := ::oFacCliT:cCodCli
   ::oDbf:cCodTip := ::oDbfArt:cCodTip
   ::oDbf:cNomTip := oRetFld( ::oDbf:cCodTip, ::oTipArt:oDbf )
   ::oDbf:cNomCli := ::oFacCliT:cNomcli

RETURN ( Self )

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
   ::oDbf:nAcuPes += nTotNFacCli( ::oFacCliL ) * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
   ::oDbf:nTotMov += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

RETURN ( Self )

//---------------------------------------------------------------------------//

//METHOD IncluyeCero()

   /*
   Repaso de todas los tipos de artículos--------------------------------------
   */

  /* ::oDbfRut:GoTop()
   while !::oDbfRut:Eof()

      if ( ::lAllRut .or. ( ::oDbfRut:cCodRut >= ::cRutOrg .AND. ::oDbfRut:cCodRut <= ::cRutDes ) )

      ::oDbfCli:GoTop()
      while !::oDbfCli:Eof()

         if ( ::lAllCli .or. ( ::oDbfCli:Cod >= ::cCliOrg .AND. ::oDbfCli:Cod <= ::cCliDes ) )

         ::oTipArt:oDbf:GoTop()
         while !::oTipArt:oDbf:Eof()

            if ( ::lAllTip .or. ( ::oTipArt:oDbf:cCodTip >= ::cTipOrg   .AND. ::oTipArt:oDbf:cCodTip <= ::cTipDes ) ) .AND.;
               !::oDbf:Seek( ::oDbfRut:cCodRut + ::oDbfCli:Cod + ::oTipArt:oDbf:cCodTip )

               ::oDbf:Append()
               ::oDbf:Blank()
               ::oDbf:cCodTip    := ::oTipArt:oDbf:cCodTip
               ::oDbf:cNomTip    := ::oTipArt:oDbf:cNomTip
               ::oDbf:cCodRut    := ::oDbfRut:cCodRut
               ::oDbf:cCodCli    := ::oDbfCli:Cod
               ::oDbf:cNomCli    := ::oDbfCli:Titulo
               ::oDbf:Save()

            end if

            ::oTipArt:oDbf:Skip()

         end while

         end if

         ::oDbfCli:Skip()

      end while

      end if

   ::oDbfRut:Skip()

   end while

RETURN nil*/

//---------------------------------------------------------------------------//