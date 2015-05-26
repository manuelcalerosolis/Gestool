#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TCliDiFa()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Cli",                       .f., "Cod. Cliente",                8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nom",                       .f., "Nombre Cliente",             25 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },         "Fac",                       .t., "Factura",                    14 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                       8 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                        12 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },         "Dom",                       .f., "Domicilio",                  20 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },         "Pob",                       .f., "Población",                  25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },         "Prov",                      .f., "Provincia",                  20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",                 7 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                   12 } )
   aAdd( aCol, { "NTOTNET", "N", 16, 6, {|| oInf:cPicOut  },"Neto",                      .t., "Neto",                       12 } )
   aAdd( aCol, { "NTOTIVA", "N", 16, 6, {|| oInf:cPicOut  },cImp(),                      .t., cImp(),                        12 } )
   aAdd( aCol, { "NTOTREQ", "N", 16, 3, {|| oInf:cPicOut  },"Rec",                       .t., "Rec",                        12 } )
   aAdd( aCol, { "NTOTPNT", "N", 16, 6, {|| oInf:cPicOut }, "P.V.",                      .t., "Punto verde",                12 } )
   aAdd( aCol, { "NTOTDOC", "N", 16, 6, {|| oInf:cPicOut }, "Total",                     .t., "Total",                      12 } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| oInf:cPicOut }, "Com.Age.",                  .t., "Comisión Agente",            12 } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                     .f., "Tipo de Venta",              20 } )

   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )

   oInf  := TCliDiInf():New( "Informe detallado de facturas de clientes ordenado por numero de factura", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli },                     {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) } )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TCliDiInf FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  oDbfCli     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Liquidada", "Todas" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TCliDiInf

  local oBlock
  local oError
  local lOpen := .t.

    /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()
   ::oFacCliT:SetOrder( "DFECFAC" )

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oDbfTvta  PATH ( cPatDat() ) FILE "TVTA.DBF"    VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TCliDiInf

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oDbfTvta:End()
   ::oDbfCli:End()
   ::oDbfIva:End()
   ::oFacCliP:End()
   ::oAntCliT:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TCliDiInf

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN05" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   ::oDefCliInf( 70, 80, 90, 100 )

   /*
   Monta los clientes de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TCliDiInf

   local aTotFac
   local bValid   := {|| .t. }

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oFacCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

	/*
   Nos movemos por las cabeceras de los albaranes a clientes
	*/
   WHILE !::oFacCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oFacCliT:DFECFAC >= ::dIniInf                                                    .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                    .AND.;
         ::oFacCliT:CCODCLI >= ::cCliOrg                                                    .AND.;
         ::oFacCliT:CCODCLI <= ::cCliDes                                                    .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

         aTotFac              := aTotFacCli (::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, cDivEmp() )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

            if !::oDbf:Seek( ::oFacCliT:CCODCLI )

               ::oDbf:Append()

               ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
               ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
               ::oDbf:DFECMOV := ::oFacCliT:DFECFAC

               ::oDbf:NTOTNET := aTotFac[1]
               ::oDbf:NTOTIVA := aTotFac[2]
               ::oDbf:NTOTREQ := aTotFac[3]
               ::oDbf:nComAge := ::oFacCliL:nComAge
               ::oDbf:NTOTDOC := aTotFac[4]
               ::oDbf:NTOTPNT := aTotFac[5]
               ::oDbf:CDOCMOV := ::oFacCliT:CSERIE + "/" + Str( ::oFacCliT:NNUMFAC ) + "/" + ::oFacCliT:CSUFFAC

               ::oDbfTvta:Seek (::oFacCliL:cTipMov)
               ::oDbf:cTipVen    := ::oDbfTvta:cDesMov

               if ::oDbfCli:Seek ( ::oFacCliT:CCODCLI )

                  ::oDbf:CNIFCLI := ::oDbfCli:Nif
                  ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
                  ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
                  ::oDbf:CPROCLI := ::oDbfCli:Provincia
                  ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
                  ::oDbf:CTLFCLI := ::oDbfCli:Telefono

               end if

               ::oDbf:Save()

            else

               ::oDbf:Load()

               ::oDbf:NTOTNET += aTotFac[1]
               ::oDbf:NTOTIVA += aTotFac[2]
               ::oDbf:NTOTREQ += aTotFac[3]
               ::oDbf:NTOTDOC += aTotFac[4]
               ::oDbf:NTOTPNT += aTotFac[5]

               ::oDbf:Save()

            end if

      end if

      ::oMtrInf:AutoInc()

      ::oFacCliT:Skip()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//