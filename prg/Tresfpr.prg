#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION ResFamPreCli()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "cCodFam", "C", 16, 0, {|| "@!" },            "Cod.",           .t., "Código familia"              ,  5 } )
   aAdd( aCol, { "CNOMFAM", "C", 50, 0, {|| "@!" },            "Familia",        .t., "Familia"                     , 28 } )
   aAdd( aCol, { "NNUMCAJ", "N", 19, 6, {|| MasUnd() },        "Caj.",           .f., "Cajas"                       , 12 } )
   aAdd( aCol, { "NNUMUNI", "N", 19, 6, {|| MasUnd() },        "Und.",           .f., "Unidades"                    , 12 } )
   aAdd( aCol, { "NTOTUNI", "N", 19, 6, {|| MasUnd() },        "Tot. Und.",      .t., "Total unidades"              , 12 } )
   aAdd( aCol, { "NIMPART", "N", 19, 6, {|| oInf:cPicOut },    "Importe",        .t., "Importe"                     , 12 } )
   aAdd( aCol, { "NPREMED", "N", 19, 6, {|| oInf:cPicImp },    "Precio medio",   .f., "Precio medio"                , 12, .f. } )
   aAdd( aCol, { "NIMPCOM", "N", 19, 6, {|| oInf:cPicImp },    "Previsión",      .f., "Previsión"                   , 12 } )
   aAdd( aCol, { "NACUCAJ", "N", 19, 6, {|| MasUnd() },        "Caj. Acu.",      .f., "Total caja acumuladas"       , 12 } )
   aAdd( aCol, { "NACUUNI", "N", 19, 6, {|| MasUnd() },        "Und. Acu.",      .f., "Total unidades acumuladas"   , 12 } )
   aAdd( aCol, { "NACUTOT", "N", 19, 6, {|| MasUnd() },        "Tot. Und. Acu.", .f., "Total unidades"              , 12 } )
   aAdd( aCol, { "NACUIMP", "N", 19, 6, {|| oInf:cPicOut },    "Tot. Importe",   .f., "Total importe acumulado"     , 12 } )
   aAdd( aCol, { "NIMPDES", "N", 19, 6, {|| oInf:cPicOut },    "Desviación",     .f., "Desviación"                  , 12 } )

   aAdd( aIdx, { "cCodFam", "cCodFam" } )

   oInf  := TResFamPre():New( "Informe resumido de ventas en presupuestos de clientes agrupado por familias", aCol, aIdx, "01055" )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TResFamPre FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
    
   DATA  aMes        AS ARRAY    INIT {.f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f. }
   DATA  lAno        AS LOGIC    INIT .f.
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Aceptado", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   /*
   Ficheros necesarios
   */

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"
   ::oPreCliL:SetOrder( "CREF" )

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oPreCliT:End()
   ::oPreCliL:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN11A" )
      return .f.
   end if

   /*
   Monta familias
   */

   ::lDefFamInf( 110, 120, 130, 140 )

   ::oDefExcInf(204)

   ::oDefResInf(202)

   ::oDefSalInf(201)

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 1] ID 205 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 2] ID 206 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 3] ID 207 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 4] ID 208 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 5] ID 209 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 6] ID 210 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 7] ID 211 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 8] ID 212 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 9] ID 213 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[10] ID 214 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[11] ID 215 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[12] ID 216 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lAno     ID 217 OF ::oFld:aDialogs[1]

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

METHOD lGenerate()

   local cPre
   local bValid   := {|| .t. }

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oDbfArt:GoTop()

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia: " + ::cFamOrg       + " > " + ::cFamDes },;
                     {|| "Estado : " + ::aEstado[ ::oEstado:nAt ] } }

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oPreCliT:lEstado }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPreCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   /*
   Meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:FAMILIA >= ::cFamOrg .AND. ::oDbfArt:FAMILIA <= ::cFamDes

         IF ::oPreCliL:Seek( ::oDbfArt:Codigo )

            WHILE ::oPreCliL:CREF = ::oDbfArt:Codigo .AND. !::oPreCliL:Eof()

               cPre := ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre

                  IF ::oPreCliT:Seek( cPre )

                     IF lChkSer( ::oPreCliT:CSERPRE, ::aSer )                                .AND.;
                        Eval( bValid )                                                       .AND.;
                        !( ::lExcCero .AND. ::oPreCliL:NPREDIV == 0 )

                        /*
                        Comparativa entre fechas
                        */

                        IF ::oPreCliT:DFECPRE >= ::dIniInf .AND. ::oPreCliT:DFECPRE <= ::dFinInf

                           IF ::oDbf:Seek( ::oDbfArt:Familia )
                              ::oDbf:Load()

                              ::oDbf:nNumCaj    += ::oPreCliL:NCANPRE
                              ::oDbf:nNumUni    += ::oPreCliL:NUNICAJA
                              ::oDbf:nTotUni    += nTotNPreCli( ::oPreCliL )
                              ::oDbf:nImpArt    += nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDerOut, ::nDerOut, ::nValDiv )
                              ::oDbf:nImpCom    := nPreFamilia( ::oDbfArt:FAMILIA, ::aMes, ::lAno, ::oDbfFam:cAlias )
                              ::oDbf:nImpDes    := ::oDbf:NNUMUNI - ::oDbf:NIMPCOM
                              ::oDbf:nPreMed    := ::oDbf:NIMPART / ::oDbf:NNUMUNI

                              ::oDbf:Save()

                           ELSE

                              ::oDbf:Append()

                              ::oDbf:cCodFam    := ::oDbfArt:Familia
                              ::oDbf:cNomFam    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                              ::oDbf:nNumCaj    := ::oPreCliL:NCANPRE
                              ::oDbf:nNumUni    := ::oPreCliL:NUNICAJA
                              ::oDbf:nTotUni    := nTotNPreCli( ::oPreCliL )
                              ::oDbf:nImpArt    := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDerOut, ::nDerOut, ::nValDiv )
                              ::oDbf:nImpCom    := nPreFamilia( ::oDbfArt:FAMILIA, ::aMes, ::lAno, ::oDbfFam:cAlias )
                              ::oDbf:nImpDes    := ::oDbf:NNUMUNI - ::oDbf:NIMPCOM
                              ::oDbf:nPreMed    := ::oDbf:NIMPART / ::oDbf:NNUMUNI

                              ::oDbf:Save()

                           END IF

                        END IF
                        /*
                        Acumulado
                        */

                        IF ::oDbf:Seek( ::oDbfArt:Familia )

                           ::oDbf:Load ()

                           ::oDbf:nAcuCaj    += ::oPreCliL:nCanPre
                           ::oDbf:nAcuUni    += ::oPreCliL:nUniCaja
                           ::oDbf:nAcuTot    += nTotNPreCli( ::oPreCliL )
                           ::oDbf:nAcuImp    += nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDerOut, ::nDerOut, ::nValDiv )

                           ::oDbf:Save()

                        ELSE

                           ::oDbf:Append()

                           ::oDbf:cCodFam    := ::oDbfArt:Familia
                           ::oDbf:cNomFam    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                           ::oDbf:nAcuCaj    := ::oPreCliL:nCanPre
                           ::oDbf:nAcuUni    := ::oPreCliL:nUniCaja
                           ::oDbf:nAcuTot    := nTotNPreCli( ::oPreCliL )
                           ::oDbf:nAcuImp    := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDerOut, ::nDerOut, ::nValDiv )

                           ::oDbf:Save()

                        END IF

                     END IF

                     END IF

                  ::oPreCliL:Skip()

               END WHILE

         END IF

      END IF

      ::oDbfArt:Skip()
      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   END WHILE

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//