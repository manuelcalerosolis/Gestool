#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TMovPre()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },             "Cod. Cli.",    .t.,  "Codigo Cliente",   8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },             "Nom. Cli.",    .t.,  "Nombre Cliente",  25 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },             "Nif",          .f.,  "Nif",              9 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },             "Domicilio",    .f.,  "Domicilio",       25 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },             "Población",    .f.,  "Población",       25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },             "Provincia",    .f.,  "Provincia",       20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },             "Cod. Postal",  .f.,  "Cod. Postal",      7 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },             "Telefono",     .f.,  "Telefono",        12 } )
   aAdd( aCol, { "CCODFAM", "C", 16, 0, {|| "@!" },             "Cod. Fam.",    .f.,  "Codigo Familia",   5 } )
   aAdd( aCol, { "CNOMFAM", "C", 30, 0, {|| "@!" },             "Familia",      .f.,  "Familia",         15 } )
   aAdd( aCol, { "NNUMCAJ", "N", 13, 6, {|| MasUnd() },         "Cajas",        .t.,  "Cajas",            8 } )
   aAdd( aCol, { "NUNIDAD", "N", 13, 6, {|| MasUnd() },         "Unds.",        .t.,  "Unidades",         8 } )
   aAdd( aCol, { "NNUMUND", "N", 13, 6, {|| MasUnd() },         "Unds x Cajas", .t.,  "Unidades x Cajas", 8 } )
   aAdd( aCol, { "NIMPART", "N", 13, 6, {|| oInf:cPicOut },     "Neto",         .t.,  "Base Imponible",  10 } )
   aAdd( aCol, { "NTOTIMP", "N", 13, 6, {|| oInf:cPicOut },     "Importe",      .t.,  "Importe",         10 } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| oInf:cPicOut },     "Com. Age.",    .t.,  "Comision Agente", 10 } )

   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )

   oInf  := TMovPreInf():New( "Informe detallado presupuestos en presupuestos de clientes agrupada por clientes", aCol, aIdx, "01059" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli },                     {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) }, {||"Total Cliente..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TMovPreInf FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Aceptado", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TMovPreInf

   /*
   Ficheros necesarios
   */

   ::oPreCliT  := TDataCenter():oPreCliT()
   ::oPreCliT:SetOrder( "CCODCLI" )

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TMovPreInf

   ::oPreCliT:End()
   ::oPreCliL:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TMovPreInf

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN12" )
      return .f.
   end if

   /* Monta Clientes */

   ::oDefCliInf( 70, 80, 90, 100 )

   /* Monta familias */

   ::lDefFamInf( 110, 120, 130, 140 )

   /* Meter */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf(202)

   ::oDefResInf(201)

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

METHOD lGenerate() CLASS TMovPreInf

   local cFam
   local bValid   := {|| .t. }

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oPreCliT:GoTop()

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oPreCliT:lEstado }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPreCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Familia : " + ::cFamOrg       + " > " + ::cFamDes       },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ]                   } }

   WHILE ! ::oPreCliT:Eof()

      IF Eval ( bValid )                                                                 .AND.;
         ::oPreCliT:DFECPRE >= ::dIniInf                                                 .AND.;
         ::oPreCliT:DFECPRE <= ::dFinInf                                                 .AND.;
         ::oPreCliT:CCODCLI >= ::cCliOrg                                                 .AND.;
         ::oPreCliT:CCODCLI <= ::cCliDes                                                 .AND.;
         lChkSer( ::oPreCliT:CSERPRE, ::aSer )

         /*
         Lineas de detalle
         */

        IF ::oPreCliL:Seek( ::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE )

            WHILE (::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE) == (::oPreCliL:CSERPRE + Str( ::oPreCliL:NNUMPRE ) + ::oPreCliL:CSUFPRE) .AND. !::oPreCliL:eof()

               cFam  := retFamArt( ::oPreCliL:CREF, ::odbfArt:cAlias )

               IF ( cFam >= ::cFamOrg .AND. cFam <= ::cFamDes )                      .AND. ;
                  !( ::lExcCero .AND. ::oPreCliL:NPREUNIT == 0  )

                  IF !::oDbf:Seek( ::oPreCliT:CCODCLI + cFam  )

                     ::oDbf:Append()

                     ::oDbf:CCODFAM := cFam
                     ::oDbf:CCODCLI := ::oPreCliT:CCODCLI
                     ::oDbf:CNOMCLI := ::oPreCliT:CNOMCLI
                     ::oDbf:NNUMCAJ := ::oPreCliL:NCANENT
                     ::oDbf:NUNIDAD := ::oPreCliL:NUNICAJA
                     ::oDbf:NNUMUND := NotCaja( ::oPreCliL:NCANENT ) * ::oPreCliL:NUNICAJA
                     ::oDbf:NIMPART := nTotLPreCli( ::oPreCliL:cAlias, ::nDerOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NTOTIMP := nTotLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NCOMAGE := ::oPreCliL:NCOMAGE

                     IF ::oDbfCli:Seek ( ::oPreCliT:CCODCLI )

                        ::oDbf:CNIFCLI := ::oDbfCli:Nif
                        ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
                        ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
                        ::oDbf:CPROCLI := ::oDbfCli:Provincia
                        ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
                        ::oDbf:CTLFCLI := ::oDbfCli:Telefono

                     END IF

                     ::oDbf:Save()

                  ELSE

                     ::oDbf:Load()

                     ::oDbf:NNUMCAJ += ::oPreCliL:NCANENT
                     ::oDbf:NUNIDAD += ::oPreCliL:NUNICAJA
                     ::oDbf:NNUMUND += NotCaja( ::oPreCliL:NCANENT ) * ::oPreCliL:NUNICAJA
                     ::oDbf:NIMPART += nTotLPreCli( ::oPreCliL:cAlias, ::nDerOut, ::nDerOut, , , ::nValDiv )
                     ::oDbf:NTOTIMP += nTotLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, , , ::nValDiv )
                     ::oDbf:NCOMAGE += ::oPreCliL:NCOMAGE

                     ::oDbf:Save()

                    END IF

               END IF

               ::oPreCliL:Skip()

            END WHILE

         END IF

      END IF

      ::oPreCliT:Skip()
      ::oMtrInf:AutoInc()

   END WHILE

    ::oDlg:Enable()

   RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//