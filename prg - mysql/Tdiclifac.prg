#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TDCliPre()

   local oInf
   local aCol  := {}
   local aIdx  := {}


   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Cli",                       .f., "Cod. Cliente",             } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nom",                       .f., "Nombre Cliente",           } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },         "Pre",                       .t., "Presupuesto",              } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                    } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                      } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },         "Dom",                       .f., "Domicilio",                } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },         "Pob",                       .f., "Población",                } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },         "Prov",                      .f., "Provincia",                } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",              } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                 } )
   aAdd( aCol, { "NTOTNET", "N", 16, 6, {|| oInf:cPicOut  },"Neto",                      .f., "Neto",                     } )
   aAdd( aCol, { "NTOTIVA", "N", 16, 6, {|| oInf:cPicOut  },cImp(),                       .t., cImp()                       } )
   aAdd( aCol, { "NTOTREQ", "N", 16, 3, {|| oInf:cPicOut  },"Rec",                       .f., "Rec"                       } )
   aAdd( aCol, { "NTOTDOC", "N", 16, 6, {|| oInf:cPicOut }, "Total",                     .t., "Total",                    } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| oInf:cPicOut }, "Com. Age",                  .t., "Comisión Agente",          } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                     .f., "Tipo de Venta"             } )

   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )

   oInf  := TMovCPre():New( "Detalle de presupuestos de clientes", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli },                     {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) } )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TDiaCPre FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  oDbfCli     AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCPre

  local oBlock
  local oError
  local lOpen := .t.

  /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL  PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfPago  PATH ( cPatEmp() ) FILE "FPAGO.DBF"  VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaCPre

   if !Empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if

   if !Empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:End()
   end if

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TDiaCPre

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN04" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   ::oDefCliInf( 70, 80, 90, 100 )

   /*
   Monta los clientes de manera automatica
   */

   ::lDefArtInf( 150, 160, 170, 180 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   ::oDefExcInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    { "Pendiente", "Aceptado", "Todos" } ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaCPre

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oPreCliT:GoTop():Load()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oPreCliT:lEstado }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPreCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

	/*
   Nos movemos por las cabeceras de los albaranes a clientes
	*/

   WHILE ! ::oPreCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oPreCliT:DFECPRE >= ::dIniInf                                                    .AND.;
         ::oPreCliT:DFECPRE <= ::dFinInf                                                    .AND.;
         ::oPreCliT:CCODCLI >= ::cCliOrg                                                    .AND.;
         ::oPreCliT:CCODCLI <= ::cCliDes                                                    .AND.;
         lChkSer( ::oPreCliT:CSERPRE, ::aSer )

          /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oPreCliL:Seek( ::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE )

            ::oPreCliL:load()

            while ::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE == ::oPreCliL:CSERPRE + Str( ::oPreCliL:NNUMPRE ) + ::oPreCliL:CSUFPRE .AND. ! ::oPreCliL:eof()

               if ::oPreCliL:CREF >= ::cArtOrg                 .AND.;
                  ::oPreCliL:CREF <= ::cArtDes                 .AND.;
                  !( ::lExcCero .AND. ::oPreCliL:NPREUNIT == 0 )

                  ::oDbf:Append()

                  ::oDbf:CCODCLI := ::oPreCliT:CCODCLI
                  ::oDbf:CNOMCLI := ::oPreCliT:CNOMCLI
                  ::oDbf:DFECMOV := ::oPreCliT:DFECPRE

                  ::oDbf:NTOTNET := aTotPreCli (::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE, ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[1]
                  ::oDbf:NTOTIVA := aTotPreCli (::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE, ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[2]
                  ::oDbf:NTOTREC := aTotPreCli (::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE, ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[3]
                  ::oDbf:nComAge := ::oPreCliL:nComAge
                  ::oDbf:NTOTDOC := aTotPreCli (::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE, ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())[4]
                  ::oDbf:CDOCMOV := ::oPreCliL:CSERPRE + "/" + Str( ::oPreCliL:NNUMPRE ) + "/" + ::oPreCliL:CSUFPRE

                  IF ::oDbfCli:Seek ( ::oPreCliT:CCODCLI )
                     ::oDbfCli:Load()

                     ::oDbf:CNIFCLI := ::oDbfCli:Nif
                     ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
                     ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
                     ::oDbf:CPROCLI := ::oDbfCli:Provincia
                     ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
                     ::oDbf:CTLFCLI := ::oDbfCli:Telefono

                   END IF

                  ::oDbf:Save()

               end if

               ::oPreCliL:Skip()

            end while

         end if

      end if

      ::oPreCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//














