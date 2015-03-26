#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TGrpPre()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODGRP", "C",  4, 0, {|| "@!" },             "Cod. Cli.",    .f., "Codigo Cliente"  } )
   aAdd( aCol, { "CNOMGRP", "C", 30, 0, {|| "@!" },             "Nom. Cli.",    .f., "Nombre Cliente"  } )
   aAdd( aCol, { "CCODFAM", "C", 16, 0, {|| "@!" },             "Cod. Fam.",    .f., "Codigo Familia"  } )
   aAdd( aCol, { "CNOMFAM", "C", 30, 0, {|| "@!" },             "Familia",      .f., "Familia"         } )
   aAdd( aCol, { "NNUMCAJ", "N", 13, 6, {|| MasUnd() },         "Cajas",        .t., "Cajas"           } )
   aAdd( aCol, { "NUNIDAD", "N", 13, 6, {|| MasUnd() },         "Unds.",        .t., "Unidades"        } )
   aAdd( aCol, { "NNUMUND", "N", 13, 6, {|| MasUnd() },         "Unds x Cajas", .t., "Unidades x Cajas"} )
   aAdd( aCol, { "NIMPART", "N", 13, 6, {|| oInf:cPicOut },     "Importe",      .t., "Importe"         } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| MasUnd() },         "Com. Age.",    .t., "Comision Agente" } )


   aAdd( aIdx, { "CCODGRP", "CCODGRP" } )

   oInf  := TInfMovPre():New( "Movimientos de familias por grupos de clientes en presupuestos", aCol, aIdx, "01059" )

   oInf:AddGroup( {|| oInf:oDbf:cCodGrp },                     {|| "Grupo Cliente  : " + Rtrim( oInf:oDbf:cCodGrp ) + "-" + oRetFld( oInf:oDbf:cCodGrp, oInf:oDbfCli ) }, {||"Total Grupo Cliente..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TMovGrpPre FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  nEstado     AS NUMERIC  INIT 1

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfMovPre

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oPreCliT  := TDataCenter():oPreCliT()
   ::oPreCliT:SetOrder( "CCODCLI" )

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )


//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfMovPre

   if !Empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if

   if !Empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfMovPre

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

   ::oDefSalInf(200)

   REDEFINE RADIO ::nEstado ;
      ID       218, 219, 220 ;
      OF       ::oFld:aDialogs[1]


RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfMovPre

   local bValid   := {|| .t. }
   local fam

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oPreCliT:GoTop():Load()

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   do case
      case ::nEstado == 1
         bValid   := {|| !::oPreCliT:lEstado }
      case ::nEstado == 2
         bValid   := {|| ::oPreCliT:lEstado }
      case ::nEstado == 3
         bValid   := {|| .t. }
   end case

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

         ::oPreCliL:load()

         WHILE (::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE) == (::oPreCliL:CSERPRE + Str( ::oPreCliL:NNUMPRE ) + ::oPreCliL:CSUFPRE) .AND. !::oPreCliL:eof()

               fam := retFamArt( ::oPreCliL:CREF, ::odbfArt:cAlias )

               IF        ( fam >= ::cFamOrg .AND. fam <= ::cFamDes )                      .AND. ;
                        !( ::lExcCero .AND. ::oPreCliL:NPREUNIT == 0  )

                  IF !::oDbf:Seek( ::oPreCliT:CCODCLI + fam  )

                     ::oDbf:Append()

                     ::oDbf:CCODFAM := fam
                     ::oDbf:CCODCLI := ::oPreCliT:CCODCLI
                     ::oDbf:CNOMCLI := ::oPreCliT:CNOMCLI
                     ::oDbf:NNUMCAJ := ::oPreCliL:NCANENT
                     ::oDbf:NUNIDAD := ::oPreCliL:NUNICAJA
                     ::oDbf:NNUMUND := NotCaja( ::oPreCliL:NCANENT ) * ::oPreCliL:NUNICAJA
                     ::oDbf:NIMPART := nTotLPreCli( ::oPreCliL:cAlias, ::nDerOut, ::nValDiv )
                     ::oDbf:NCOMAGE := ::oPreCliL:NCOMAGE
                     ::oDbf:Save()

                  ELSE

                     ::oDbf:NNUMCAJ += ::oPreCliL:NCANENT
                     ::oDbf:NUNIDAD += ::oPreCliL:NUNICAJA
                     ::oDbf:NNUMUND += NotCaja( ::oPreCliL:NCANENT ) * ::oPreCliL:NUNICAJA
                     ::oDbf:NIMPART += nTotLPreCli( ::oPreCliL:cAlias, ::nDerOut, ::nValDiv )
                     ::oDbf:NCOMAGE += ::oPreCliL:NCOMAGE
                     ::oDbf:Save()

                    END IF

            END IF

            ::oPreCliL:Skip():Load()
            ::oMtrInf:AutoInc()

         END WHILE

         END IF

      END IF

      ::oPreCliT:Skip():Load()

   END WHILE

    ::oDlg:Enable()

   RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//