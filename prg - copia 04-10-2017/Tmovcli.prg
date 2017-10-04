#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TMovClf()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },             "Cod. Cli.",    .t., "Codigo Cliente",     8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },             "Nom. Cli.",    .t., "Nombre Cliente",    25 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },             "Nif",          .f.,  "Nif",               9 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },             "Domicilio",    .f.,  "Domicilio",        25 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },             "Población",    .f.,  "Población",        25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },             "Provincia",    .f.,  "Provincia",        20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },             "Cod. Postal",  .f.,  "Cod. Postal",       7 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },             "Telefono",     .f.,  "Telefono",         12 } )
   aAdd( aCol, { "CCODFAM", "C", 16, 0, {|| "@!" },             "Cod. Fam.",    .f.,  "Codigo Familia",    5 } )
   aAdd( aCol, { "CNOMFAM", "C", 30, 0, {|| "@!" },             "Familia",      .f.,  "Familia",          15 } )
   aAdd( aCol, { "NNUMCAJ", "N", 13, 6, {|| MasUnd() },         "Cajas",        .t.,  "Cajas",             8 } )
   aAdd( aCol, { "NUNIDAD", "N", 13, 6, {|| MasUnd() },         "Unds.",        .t.,  "Unidades",          8 } )
   aAdd( aCol, { "NNUMUND", "N", 13, 6, {|| MasUnd() },         "Unds x Cajas", .t.,  "Unidades x Cajas",  8 } )
   aAdd( aCol, { "NIMPART", "N", 13, 6, {|| oInf:cPicOut },     "Neto",         .t.,  "Base Imponible",   10 } )
   aAdd( aCol, { "NTOTIMP", "N", 13, 6, {|| oInf:cPicOut },     "Importe",      .t.,  "Importe",          10 } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| MasUnd() },         "Com. Age.",    .t.,  "Comision Agente",  10 } )


   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )

   oInf  := TMovClFInf():New( "Informe detallado realizados en albaranes de clientes agrupada por clientes", aCol, aIdx, "01061" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli },                     {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) }, {||"Total Cliente..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TMovClFInf FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "No facturado", "Facturado", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TMovClFInf

   /*
   Ficheros necesarios
   */

   ::oAlbCliT := TDataCenter():oAlbCliT()
   ::oAlbCliT:SetOrder( "CCODCLI" )

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TMovClFInf

   ::oAlbCliT:End()
   ::oAlbCliL:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TMovClFInf

   local cEstado := "Todos"

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

METHOD lGenerate() CLASS TMovClFInf

   local bValid   := {|| .t. }
   local fam

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oAlbCliT:GoTop()

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 2
         bValid   := {|| lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Familia : " + ::cFamOrg       + " > " + ::cFamDes       },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ]                   } }

   WHILE ! ::oAlbCliT:Eof()

      IF Eval( bValid )                                                                  .AND.;
         ::oAlbCliT:DFECALB >= ::dIniInf                                                 .AND.;
         ::oAlbCliT:DFECALB <= ::dFinInf                                                 .AND.;
         ::oAlbCliT:CCODCLI >= ::cCliOrg                                                 .AND.;
         ::oAlbCliT:CCODCLI <= ::cCliDes                                                 .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )

         /*
         Lineas de detalle
         */

        IF ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

         WHILE (::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB) == (::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB) .AND. !::oAlbCliL:eof()

               fam := retFamArt( ::oAlbCliL:CREF, ::odbfArt:cAlias )

               IF        ( fam >= ::cFamOrg .AND. fam <= ::cFamDes )                      .AND. ;
                        !( ::lExcCero .AND. ::oAlbFacCliL:NPREUNIT == 0  )



                  IF !::oDbf:Seek( ::oAlbCliT:CCODCLI + fam  )

                     ::oDbf:Append()

                     ::oDbf:CCODFAM := fam
                     ::oDbf:CCODCLI := ::oAlbCliT:CCODCLI
                     ::oDbf:CNOMCLI := ::oAlbCliT:CNOMCLI
                     ::oDbf:NNUMCAJ := ::oAlbCliL:NCANENT
                     ::oDbf:NUNIDAD := ::oAlbCliL:NUNICAJA
                     ::oDbf:NNUMUND := NotCaja( ::oAlbCliL:NCANENT ) * ::oAlbCliL:NUNICAJA
                     ::oDbf:NIMPART := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NTOTIMP := nTotLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NCOMAGE := ::oAlbCliL:NCOMAGE

                     IF ::oDbfCli:Seek ( ::oAlbCliT:CCODCLI )

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

                     ::oDbf:NNUMCAJ += ::oAlbCliL:NCANENT
                     ::oDbf:NUNIDAD += ::oAlbCliL:NUNICAJA
                     ::oDbf:NNUMUND += NotCaja( ::oAlbCliL:NCANENT ) * ::oAlbCliL:NUNICAJA
                     ::oDbf:NIMPART += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NTOTIMP += nTotLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:NCOMAGE += ::oAlbCliL:NCOMAGE

                     ::oDbf:Save()

                  END IF

            END IF

            ::oAlbCliL:Skip()

         END WHILE

         END IF

      END IF

      ::oAlbCliT:Skip()
      ::oMtrInf:AutoInc()

   END WHILE

    ::oDlg:Enable()

   RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//