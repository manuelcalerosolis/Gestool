#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TMovPed()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },             "Cod. Cli.",    .t., "Codigo Cliente",    8  } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },             "Nom. Cli.",    .t., "Nombre Cliente",   25  } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },             "Nif",          .f.,  "Nif",              9  } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },             "Domicilio",    .f.,  "Domicilio",       25  } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },             "Población",    .f.,  "Población",       25  } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },             "Provincia",    .f.,  "Provincia",       20  } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },             "Cod. Postal",  .f.,  "Cod. Postal",      7  } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },             "Telefono",     .f.,  "Telefono",        12  } )
   aAdd( aCol, { "CCODFAM", "C", 16, 0, {|| "@!" },             "Cod. fam.",    .f., "Codigo Familia",    5  } )
   aAdd( aCol, { "CNOMFAM", "C", 30, 0, {|| "@!" },             "Familia",      .f., "Familia",          15  } )
   aAdd( aCol, { "NNUMCAJ", "N", 13, 6, {|| MasUnd() },         "Cajas",        .t., "Cajas",             8  } )
   aAdd( aCol, { "NUNIDAD", "N", 13, 6, {|| MasUnd() },         "Unds.",        .t., "Unidades",          8  } )
   aAdd( aCol, { "NNUMUND", "N", 13, 6, {|| MasUnd() },         "Unds x Cajas", .t., "Unidades x Cajas",  8  } )
   aAdd( aCol, { "NIMPART", "N", 13, 6, {|| oInf:cPicOut },     "Neto",         .t.,  "Base Imponible",  10  } )
   aAdd( aCol, { "NTOTIMP", "N", 13, 6, {|| oInf:cPicOut },     "Importe",      .t.,  "Importe",         10  } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| MasUnd() },         "Com. Age.",    .t., "Comision Agente",  10  } )


   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )

   oInf  := TIMovPed():New( "Informe detallado realizados en pedidos de clientes agrupada por clientes", aCol, aIdx, "01060" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli },                     {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) }, {||"Total Cliente..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TIMovPed FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY  INIT  { "Pendiente", "Parcialmente", "Entregado", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TIMovPed

   /*
   Ficheros necesarios
   */

   ::oPedCliT := TDataCenter():oPedCliT()
   ::oPedCliT:SetOrder( "CCODCLI" )

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TIMovPed

   ::oPedCliT:End()
   ::oPedCliL:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TIMovPed

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN12" )
      return .f.
   end if

   /* Monta familias */

   ::oDefCliInf( 70, 80, 90, 100 )

   /* Monta familias */

   ::lDefFamInf( 110, 120, 130, 140 )

   /* Meter */

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

   ::oDefExcInf(202)

   ::oDefResInf(201)

   REDEFINE COMBOBOX ::oEstado;
      VAR      cEstado;
      ID       218 ;
      ITEMS    ::aEstado;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TIMovPed

   local bValid   := {|| .t. }
   local fam

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oPedCliT:GoTop()

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| ::oPedCliT:nEstado == 1 }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPedCliT:nEstado == 2 }
      case ::oEstado:nAt == 3
         bValid   := {|| ::oPedCliT:nEstado == 3 }
      case ::oEstado:nAt == 4
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Familia : " + ::cFamOrg       + " > " + ::cFamDes       },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ]                   } }

   WHILE ! ::oPedCliT:Eof()

      IF Eval ( bValid )                                                                 .AND.;
         ::oPedCliT:DFECPED >= ::dIniInf                                                 .AND.;
         ::oPedCliT:DFECPED <= ::dFinInf                                                 .AND.;
         ::oPedCliT:CCODCLI >= ::cCliOrg                                                 .AND.;
         ::oPedCliT:CCODCLI <= ::cCliDes                                                 .AND.;
         lChkSer( ::oPedCliT:CSERPED, ::aSer )

         /*
         Lineas de detalle
         */

        IF ::oPedCliL:Seek( ::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED )

         WHILE (::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED) == (::oPedCliL:CSERPED + Str( ::oPedCliL:NNUMPED ) + ::oPedCliL:CSUFPED) .AND. !::oPedCliL:eof()

               fam := retFamArt( ::oPedCliL:CREF, ::odbfArt:cAlias )

               IF        ( fam >= ::cFamOrg .AND. fam <= ::cFamDes )                      .AND. ;
                        !( ::lExcCero .AND. ::oPedCliL:NPREUNIT == 0  )

                  IF !::oDbf:Seek( ::oPedCliT:CCODCLI + fam  )

                     ::oDbf:Append()

                     ::oDbf:CCODFAM := fam
                     ::oDbf:CCODCLI := ::oPedCliT:CCODCLI
                     ::oDbf:CNOMCLI := ::oPedCliT:CNOMCLI
                     ::oDbf:NNUMCAJ := ::oPedCliL:NCANENT
                     ::oDbf:NUNIDAD := ::oPedCliL:NUNICAJA
                     ::oDbf:NNUMUND := NotCaja( ::oPedCliL:NCANENT ) * ::oPedCliL:NUNICAJA
                     ::oDbf:NIMPART := nTotLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NTOTIMP := nTotLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NCOMAGE := ::oPedCliL:NCOMAGE

                     IF ::oDbfCli:Seek ( ::oPedCliT:CCODCLI )

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

                     ::oDbf:NNUMCAJ += ::oPedCliL:NCANENT
                     ::oDbf:NUNIDAD += ::oPedCliL:NUNICAJA
                     ::oDbf:NNUMUND += NotCaja( ::oPedCliL:NCANENT ) * ::oPedCliL:NUNICAJA
                     ::oDbf:NIMPART += nTotLPedCli( ::oPedCliL:cAlias, ::nDerOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NTOTIMP += nTotLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NCOMAGE += ::oPedCliL:NCOMAGE

                     ::oDbf:Save()

                  END IF

            END IF

            ::oPedCliL:Skip()

           END WHILE

         END IF

      END IF

      ::oPedCliT:Skip()
      ::oMtrInf:AutoInc()

   END WHILE

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//