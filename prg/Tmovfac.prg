#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TMovFac()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },             "Cod. Cli.",    .t., "Codigo Cliente",    8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },             "Nom. Cli.",    .t., "Nombre Cliente",   25 } )
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
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| MasUnd() },         "Com. Age.",    .t.,  "Comision Agente", 10 } )


   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )

   oInf  := TMovFacInf():New( "Informe detallado realizados en facturas de clientes agrupada por clientes", aCol, aIdx, "01062" )

   //oInf:AddGroup( {|| oInf:oDbf:cCodCli },                     {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) }, {||"Total Cliente..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TMovFacInf FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TMovFacInf

   /*
   Ficheros necesarios
   */

   ::oFacCliT := TDataCenter():oFacCliT()
   ::oFacCliT:SetOrder( "CCODCLI" )

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TMovFacInf

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oDbfArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TMovFacInf

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN12" )
      return .f.
   end if

   /* Monta familias */

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

METHOD lGenerate() CLASS TMovFacInf

   local bValid   := {|| .t. }
   local fam

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oFacCliT:GoTop()

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Familia : " + ::cFamOrg       + " > " + ::cFamDes       },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ]                   } }

   WHILE ! ::oFacCliT:Eof()

      IF Eval( bValid )                                                                  .AND.;
         ::oFacCliT:DFECFAC >= ::dIniInf                                                 .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                 .AND.;
         ::oFacCliT:CCODCLI >= ::cCliOrg                                                 .AND.;
         ::oFacCliT:CCODCLI <= ::cCliDes                                                 .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Lineas de detalle
         */

         IF ::oFacCliL:Seek( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

         WHILE (::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC) == (::oFacCliL:CSERIE + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC) .AND. !::oFacCliL:eof()

               fam := retFamArt( ::oFacCliL:CREF, ::odbfArt:cAlias )

               IF        ( fam >= ::cFamOrg .AND. fam <= ::cFamDes )                      .AND. ;
                        !( ::lExcCero .AND. ::oFacCliL:NPREUNIT == 0  )                       .AND. ;
                        !::oFacCliL:LCONTROL                                                  .AND. ;
                        !::oFacCliL:LTOTLIN


                  IF !::oDbf:Seek( ::oFacCliT:CCODCLI + fam  )

                     ::oDbf:Append()

                     ::oDbf:CCODFAM := fam
                     ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
                     ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
                     ::oDbf:NNUMCAJ := ::oFacCliL:NCANENT
                     ::oDbf:NUNIDAD := ::oFacCliL:NUNICAJA
                     ::oDbf:NNUMUND := NotCaja( ::oFacCliL:NCANENT ) * ::oFacCliL:NUNICAJA
                     ::oDbf:NIMPART := nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NTOTIMP := nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NCOMAGE := ::oFacCliL:NCOMAGE

                     IF ::oDbfCli:Seek ( ::oFacCliT:CCODCLI )

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

                     ::oDbf:NNUMCAJ += ::oFacCliL:NCANENT
                     ::oDbf:NUNIDAD += ::oFacCliL:NUNICAJA
                     ::oDbf:NNUMUND += NotCaja( ::oFacCliL:NCANENT ) * ::oFacCliL:NUNICAJA
                     ::oDbf:NIMPART += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NTOTIMP := nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NCOMAGE += ::oFacCliL:NCOMAGE

                     ::oDbf:Save()

                  END IF

            END IF

            ::oFacCliL:Skip()

            END WHILE

         END IF

      END IF

      ::oFacCliT:Skip()
      ::oMtrInf:AutoInc()


   END WHILE

    ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//