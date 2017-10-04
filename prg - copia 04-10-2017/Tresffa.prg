#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION ResFamFacCli()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "cCodFam", "C", 16, 0, {|| "@!" },            "Cod.",           .t., "Código familia"              ,  5 } )
   aAdd( aCol, { "CNOMFAM", "C", 50, 0, {|| "@!" },            "Familia",        .t., "Familia"                     , 28 } )
   aAdd( aCol, { "NNUMCAJ", "N", 19, 6, {|| MasUnd() },        "Caj.",           .f., "Cajas"                       , 12 } )
   aAdd( aCol, { "NNUMUNI", "N", 19, 6, {|| MasUnd() },        "Und.",           .f., "Unidades"                    , 12 } )
   aAdd( aCol, { "NTOTUNI", "N", 19, 6, {|| MasUnd() },        "Tot. Und.",      .t., "Total unidades"              , 12 } )
   aAdd( aCol, { "NIMPART", "N", 19, 6, {|| oInf:cPicOut },    "Importe",        .t., "Importe"                     , 12 } )
   aAdd( aCol, { "NIVAART", "N", 19, 6, {|| oInf:cPicOut },    cImp(),         .f., cImp()                      , 12 } )
   aAdd( aCol, { "NPREMED", "N", 19, 6, {|| oInf:cPicImp },    "Precio medio",   .f., "Precio medio"                , 12,  .f. } )
   aAdd( aCol, { "NIMPCOM", "N", 19, 6, {|| oInf:cPicOut },    "Previsión",      .f., "Previsión"                   , 12 } )
   aAdd( aCol, { "NACUCAJ", "N", 19, 6, {|| MasUnd() },        "Caj. Acu.",      .f., "Total caja acumuladas"       , 12 } )
   aAdd( aCol, { "NACUUNI", "N", 19, 6, {|| MasUnd() },        "Und. Acu.",      .f., "Total unidades acumuladas"   , 12 } )
   aAdd( aCol, { "NACUTOT", "N", 19, 6, {|| MasUnd() },        "Tot. Und. Acu.", .f., "Total unidades"              , 12 } )
   aAdd( aCol, { "NACUIMP", "N", 19, 6, {|| oInf:cPicOut },    "Tot. importe",   .f., "Total importe acumulado"     , 12 } )
   aAdd( aCol, { "NIMPDES", "N", 19, 6, {|| oInf:cPicOut },    "Desviación",     .f., "Desviación"                  , 12 } )

   aAdd( aIdx, { "cCodFam", "cCodFam" } )

   oInf        := TInfResFfa():New( "Informe resumido de ventas en facturas de clientes agrupado por familias", aCol, aIdx, "01056" )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfResFfa FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
    
   DATA  aMes        AS ARRAY    INIT {.f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f. }
   DATA  lAno        AS LOGIC    INIT .f.
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Cobrada", "Todas" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfResFfa

   /*
   Ficheros necesarios
   */

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:SetOrder( "CREF" )

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfResFfa

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oDbfArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfResFfa

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN11A" )
      return .f.
   end if

   /* Monta familias */

   ::lDefFamInf( 110, 120, 130, 140 )

   /* Meter */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

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

   REDEFINE CHECKBOX ::lAno;
      ID       217 ;
      OF       ::oFld:aDialogs[1]

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

METHOD lGenerate() CLASS TInfResFfa

   local bValid   := {|| .t. }

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oDbfArt:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:FAMILIA >= ::cFamOrg .AND. ::oDbfArt:FAMILIA <= ::cFamDes

         IF ::oFacCliL:Seek( ::oDbfArt:Codigo )

            WHILE ::oFacCliL:CREF = ::oDbfArt:Codigo .AND. !::oFacCliL:Eof()

               /*
               Preguntamos si esta entre fechas
               */

               IF ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac )

                  IF lChkSer( ::oFacCliT:CSERIE, ::aSer )                                    .AND.;
                     Eval( bValid )                                                          .AND.;
                     !( ::lExcCero .AND. ::oFacCliL:NPREDDIV == 0 )

                    /*
                    Comparativa entre fechas
                    */

                     IF ::oFacCliT:DFECFAC >= ::dIniInf .AND. ::oFacCliT:DFECFAC <= ::dFinInf

                        IF ::oDbf:Seek( ::oDbfArt:Familia )

                           ::oDbf:Load()

                           ::oDbf:nNumCaj    += ::oFacCliL:NCANENT
                           ::oDbf:nNumUni    += ::oFacCliL:nUniCaja
                           ::oDbf:nTotUni    += nTotNFacCli( ::oFacCliL )
                           ::oDbf:nImpArt    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                           ::oDbf:nIvaArt    += Round( ::oDbf:nImpArt * ::oFacCliL:NIVA / 100, ::nDerOut )
                           ::oDbf:nImpCom    := nPreFamilia( ::oDbfArt:FAMILIA, ::aMes, ::lAno, ::oDbfFam:cAlias )
                           ::oDbf:nImpDes    := ::oDbf:NNUMUNI - ::oDbf:NIMPCOM
                           ::oDbf:nPreMed    := ::oDbf:NIMPART / ::oDbf:NNUMUNI

                           ::oDbf:Save()

                        ELSE

                           ::oDbf:Append()
                           ::oDbf:Blank()

                           ::oDbf:cCodFam    := ::oDbfArt:Familia
                           ::oDbf:cNomFam    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                           ::oDbf:nNumCaj    := ::oFacCliL:NCANENT
                           ::oDbf:nNumUni    := ::oFacCliL:nUniCaja
                           ::oDbf:nTotUni    := nTotNFacCli( ::oFacCliL )
                           ::oDbf:nImpArt    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                           ::oDbf:nImpCom    := nPreFamilia( ::oDbfArt:FAMILIA, ::aMes, ::lAno, ::oDbfFam:cAlias )
                           ::oDbf:nIvaArt    := Round( ::oDbf:nImpArt * ::oFacCliL:NIVA / 100, ::nDerOut )
                           ::oDbf:nImpDes    := ::oDbf:NNUMUNI - ::oDbf:NIMPCOM
                           ::oDbf:nPreMed    := ::oDbf:NIMPART / ::oDbf:NNUMUNI

                           ::oDbf:Save()

                        END IF

                     END IF

                     /*
                     Acumulado----------------------------------------------
                     */

                     IF ::oDbf:Seek( ::oDbfArt:Familia )

                        ::oDbf:Load()

                        ::oDbf:NACUCAJ    += ::oFacCliL:nCanEnt
                        ::oDbf:NACUUNI    += ::oFacCliL:NUNICAJA
                        ::oDbf:nAcuTot    += nTotNFacCli( ::oFacCliL )
                        ::oDbf:NACUIMP    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                        ::oDbf:Save()

                     ELSE

                        ::oDbf:Append()
                        ::oDbf:Blank()

                        ::oDbf:cCodFam    := ::oDbfArt:Familia
                        ::oDbf:CNOMFAM    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                        ::oDbf:NACUCAJ    := ::oFacCliL:nCanEnt
                        ::oDbf:NACUUNI    := ::oFacCliL:NUNICAJA
                        ::oDbf:nAcuTot    := nTotNFacCli( ::oFacCliL )
                        ::oDbf:NACUIMP    := nTotLFacCli( ::oFacCliL:cAlias, ::nDerOut, ::nValDiv )

                        ::oDbf:Save()

                     END IF

                  END IF

               END IF

               ::oFacCliL:Skip()

            END WHILE

         END IF

      END IF

      ::oDbfArt:Skip()
      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   END WHILE

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//