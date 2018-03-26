#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TRFFacInf FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" } ;

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "CCODRUT", "C",  4, 0, {|| "@!" },          "Ruta",           .f., "Codigo ruta",                 4 )
   ::AddField ( "CCODCLI", "C", 12, 0, {|| "@!" },          "Cli.",           .f., "Codigo cliente",              8 )
   ::AddField ( "CCODFAM", "C", 16, 0, {|| "@!" },          "Fam.",           .t., "Codigo familia",              5 )
   ::AddField ( "CNOMFAM", "C", 30, 0, {|| "@!" },          "Nom. Fam.",      .t., "Nombre familia",             25 )
   ::AddField ( "CNOMCLI", "C", 50, 0, {|| "@!" },          "Nom.",           .f., "Nombre cliente",             25 )
   ::AddField ( "DFECMOV", "D",  8, 0, {|| "@!" },          "Ult. Venta",     .f., "Ultima venta",                8 )
   ::AddField ( "NNUMCAJ", "N", 16, 6, {|| MasUnd() },      "Caj.",           .f., "Cajas",                       8 )
   ::AddField ( "NNUMUND", "N", 16, 6, {|| MasUnd() },      "Und.",           .f., "Unidades",                    8 )
   ::AddField ( "NUNDCAJ", "N", 16, 6, {|| MasUnd() },      "Und x Caj.",     .t., "Unidades por caja",           8 )
   ::AddField ( "NCOMAGE", "N", 16, 6, {|| ::cPicOut  },    "Com. Age.",      .f., "Comisión agente",             8 )
   ::AddField ( "NACUIMP", "N", 16, 6, {|| ::cPicOut  },    "Imp. Acu.",      .f., "Importe acumulado",          10 )
   ::AddField ( "NACUCAJ", "N", 16, 6, {|| MasUnd() },      "Caj. Acu.",      .f., "Cajas acumuladas" ,           8 )
   ::AddField ( "NACUUND", "N", 16, 6, {|| MasUnd() },      "Und. Acu.",      .f., "Unidades acumuladas" ,        8 )
   ::AddField ( "NACUUXC", "N", 16, 6, {|| MasUnd() },      "UxC. Acu.",      .t., "Acumulado Cajas x Unidades",  8 )
   ::AddField ( "NTOTMOV", "N", 16, 6, {|| ::cPicOut },     "Total",          .t., "Total" ,                     10 )

   ::AddTmpIndex( "CCODRUT", "CCODRUT + CCODCLI + CCODFAM" )

   ::AddGroup( {|| ::oDbf:cCodRut },                  {|| "Ruta  : " + Rtrim( ::oDbf:cCodRut ) + "-" + oRetFld( ::oDbf:cCodRut, ::oDbfRut ) } , {|| "Total Ruta... "   } )
   ::AddGroup( {|| ::oDbf:cCodRut + ::oDbf:cCodCli }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) }, {|| "Total Cliente... " } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE


   ::oFacCliT := TDataCenter():oFacCliT()
   ::oFacCliT:OrdSetFocus( "CCODCLI" )

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"
   ::oFacRecT:OrdSetFocus( "CCODCLI" )

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

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
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
    

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
    

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
   Monta las familias de manera automatica
   */

   if !::lDefFamInf( 150, 160, 170, 180, 500 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfCli:Lastrec() )

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
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Rutas   : " + AllTrim( ::cRutOrg  )      + " > " + AllTrim( ::cRutDes ) },;
                     {|| "Clientes: " + AllTrim( ::cCliOrg  )      + " > " + AllTrim( ::cCliDes ) },;
                     {|| "Familias: " + AllTrim( ::cFamOrg )     + " > " + AllTrim( ::cFamDes ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }


    /*
   comenzamos con las rectificativas
   */
   ::oDbfCli:OrdSetFocus( "COD" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfCli:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfCli:cFile ), ::oDbfCli:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oDbfCli:GoTop()

   while !::lBreak .and. !::oDbfCli:Eof()
   if ( ::lAllCli .or. ( ::oDbfCli:Cod >= ::cCliOrg .and. ::oDbfCli:Cod <= ::cCliDes ) )

   /*
   Buscamos el cliente en las cabeceras - si lo encontramos . . .
   */

      if ::oFacRecT:Seek( ::oDbfCli:Cod )

      while ::oDbfCli:Cod == ::oFacRecT:cCodCli .and. !::oFacRecT:eof()

          /*
          Comprobamos que cumple las condiciones
          */

          if ( ::lAllRut .or. ( ::oFacRecT:cCodRut >= ::cRutOrg .and. ::oFacCliT:cCodRut <= ::cRutDes ) ) .and.;
             ( ::lAllCli .or. ( ::oFacRecT:cCodCli >= ::cCliOrg .and. ::oFacRecT:cCodCli <= ::cCliDes ) ) .and.;
             lChkSer( ::oFacRecT:cSerie, ::aSer )                                                         .and.;
             Eval( bValid )

             /*
             Nos posicionamos en las líneas del documento para ver las unidades de los artículos
             */

             if ::oFacRecL:Seek( ::oFacCliT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

                /*
                Comprobamos condiciones de fechas para el acumulado
                */

                     if ::oFacRecT:dFecFac >= ::dIniInf .and. ::oFacRecT:dFecFac <= ::dFinInf

                      while ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac == ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac .and. !::oFacRecL:eof()

                         if ( ::lAllFam .or. ( cCodFam( ::oFacRecL:cRef, ::oDbfArt ) >= ::cFamOrg .and. cCodFam( ::oFacRecL:cRef, ::oDbfArt ) <= ::cFamDes ) )

                            /*
                            Cumple todas y añadimos
                            */

                            if !::oDbf:Seek( ::oFacRecT:cCodRut + ::oFacRecT:cCodCli + cCodFam( ::oFacRecL:cRef, ::oDbfArt ) )

                               ::oDbf:Append()

                               ::oDbf:cCodRut := ::oFacRecT:cCodRut
                               ::oDbf:cCodCli := ::oFacRecT:cCodCli
                               ::oDbf:cCodFam := cCodFam( ::oFacRecL:cRef, ::oDbfArt )
                               ::oDbf:cNomFam := RetFamilia ( cCodFam( ::oFacRecL:cRef, ::oDbfArt ), ::oDbfFam:cAlias )
                               ::oDbf:cNomCli := ::oFacRecT:cNomcli
                               ::oDbf:dFecMov := ::oFacRecT:dFecFac
                               ::oDbf:nNumCaj := ::oFacRecL:nCanEnt
                               ::oDbf:nNumUnd := ::oFacRecL:nUniCaja
                               ::oDbf:nUndCaj := NotCaja( ::oFacRecL:nCanEnt ) * ::oFacRecL:nUniCaja
                               ::oDbf:nComAge := nComLFacCli( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                               ::oDbf:nAcuImp := ::oFacRecL:nPreUnit
                               ::oDbf:nAcuCaj := ::oFacRecL:nCanEnt
                               ::oDbf:nAcuUnd := ::oFacRecL:nUniCaja
                               ::oDbf:nAcuUxc := NotCaja( ::oFacRecL:nCanEnt ) * ::oFacRecL:nUniCaja
                               ::oDbf:nTotMov := nImpLFacCli( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                               ::oDbf:Save()

                            else

                               ::oDbf:Load()

                               ::oDbf:nNumCaj += ::oFacRecL:nCanEnt
                               ::oDbf:nNumUnd += ::oFacRecL:nUniCaja
                               ::oDbf:nUndCaj += NotCaja( ::oFacRecL:nCanEnt ) * ::oFacRecL:nUniCaja
                               ::oDbf:nComAge += nComLFacCli( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                               ::oDbf:nAcuImp += ::oFacRecL:nPreUnit
                               ::oDbf:nAcuCaj += ::oFacRecL:nCanEnt
                               ::oDbf:nAcuUnd += ::oFacRecL:nUniCaja
                               ::oDbf:nAcuUxc += NotCaja( ::oFacRecL:nCanEnt ) * ::oFacRecL:nUniCaja
                               ::oDbf:nTotMov += nImpLFacCli( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                               ::oDbf:Save()

                            end if

                         end if

                         ::oFacRecL:Skip()

                      end while

                  else

                     /*
                     no cumple fechas, sólo acumulamos
                     */

                     while ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac == ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac .and. !::oFacRecL:eof()

                        if  !::oDbf:Seek( ::oFacRecT:cCodRut + ::oFacRecT:cCodCli + cCodFam( ::oFacRecL:cRef, ::oDbfArt ) )

                           ::oDbf:Append()

                           ::oDbf:cCodRut := ::oFacRecT:cCodRut
                           ::oDbf:cCodCli := ::oFacRecT:cCodCli
                           ::oDbf:cCodFam := cCodFam( ::oFacRecL:cRef, ::oDbfArt )
                           ::oDbf:cNomFam := RetFamilia ( cCodFam( ::oFacRecL:cRef, ::oDbfArt ), ::oDbfFam:cAlias )
                           ::oDbf:cNomCli := ::oFacRecT:cNomcli
                           ::oDbf:dFecMov := ::oFacRecT:dFecFac
                           ::oDbf:nNumCaj := 0
                           ::oDbf:nNumUnd := 0
                           ::oDbf:nUndCaj := 0
                           ::oDbf:nComAge := 0
                           ::oDbf:nAcuImp += ::oFacRecL:nPreUnit
                           ::oDbf:nAcuCaj += ::oFacRecL:nCanEnt
                           ::oDbf:nAcuUnd += ::oFacRecL:nUniCaja
                           ::oDbf:nAcuUxc += NotCaja( ::oFacRecL:nCanEnt ) * ::oFacRecL:nUniCaja
                           ::oDbf:nTotMov += nImpLFacCli( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                           ::oDbf:Save()

                        else

                           ::oDbf:Load()

                           ::oDbf:nAcuImp += ::oFacRecL:nPreUnit
                           ::oDbf:nAcuCaj += ::oFacRecL:nCanEnt
                           ::oDbf:nAcuUnd += ::oFacRecL:nUniCaja
                           ::oDbf:nAcuUxc += NotCaja( ::oFacRecL:nCanEnt ) * ::oFacRecL:nUniCaja
                           ::oDbf:nTotMov += nImpLFacCli( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                           ::oDbf:Save()

                        end if

                        ::oFacRecL:Skip()

                     end while

                  end if

               end if

            end if

         ::oFacRecT:Skip()

      end while

      end if

      end if

      ::oDbfCli:Skip()

      ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

   end while

   ::oDbfCli:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfCli:cFile ) )
   ::oMtrInf:AutoInc( ::oDbfCli:LastRec() )


    ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//