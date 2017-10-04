#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION ResFamAlbCli()

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
   aAdd( aCol, { "NPREMED", "N", 19, 6, {|| oInf:cPicImp },    "Precio medio",   .f., "Precio medio"                , 12, .f. } )
   aAdd( aCol, { "NIMPCOM", "N", 19, 6, {|| oInf:cPicImp },    "Previsión",      .f., "Previsión"                   , 12 } )
   aAdd( aCol, { "NACUCAJ", "N", 19, 6, {|| MasUnd() },        "Caj. Acu.",      .f., "Total caja acumuladas"       , 12 } )
   aAdd( aCol, { "NACUUNI", "N", 19, 6, {|| MasUnd() },        "Und. Acu.",      .f., "Total unidades acumuladas"   , 12 } )
   aAdd( aCol, { "NACUTOT", "N", 19, 6, {|| MasUnd() },        "Tot. Und. Acu.", .f., "Total unidades"              , 12 } )
   aAdd( aCol, { "NACUIMP", "N", 19, 6, {|| oInf:cPicOut },    "Tot. Importe",   .f., "Total importe acumulado"     , 12 } )
   aAdd( aCol, { "NIMPDES", "N", 19, 6, {|| oInf:cPicOut },    "Desviación",     .f., "Desviación"                  , 12 } )

   aAdd( aIdx, { "cCodFam", "cCodFam" } )

   oInf  := TInfResFal():New( "Informe resumido de ventas en albaranes de clientes agrupado por familias", aCol, aIdx, "01057" )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfResFal FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
    
   DATA  aMes        AS ARRAY    INIT {.f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f. }
   DATA  lAno        AS LOGIC    INIT .f.
   DATA  aEstado     AS ARRAY    INIT { "No facturado", "Facturado", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfResFal

   /*
   Ficheros necesarios
   */

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
   ::oAlbCliL:SetOrder( "CREF" )

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfResFal

   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oDbfArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfResFal

   local cEstado := "Todos"

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

METHOD lGenerate() CLASS TInfResFal

   local cAlb
   local bValid   := {|| .t. }

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oDbfArt:GoTop()

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dIniInf ) },;
                     {|| "Familia: " + ::cFamOrg       + " > " + ::cFamDes },;
                     {|| "Estado : " + ::aEstado[ ::oEstado:nAt ] } }

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 2
         bValid   := {|| lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case


   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:FAMILIA >= ::cFamOrg .AND. ::oDbfArt:FAMILIA <= ::cFamDes

         IF ::oAlbCliL:Seek( ::oDbfArt:Codigo )

            WHILE ::oAlbCliL:CREF = ::oDbfArt:Codigo .AND. !::oAlbCliL:Eof()

               /*
               Preguntamos si esta entre fechas
               */

               IF ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb )

                  IF Eval( bValid )                                                          .AND.;
                     lChkSer( ::oAlbCliT:CSERALB, ::aSer )                                   .AND.;
                     !( ::lExcCero .AND. ::oAlbCliL:NPREDDIV == 0 )

                     /*
                     Comparativa entre fechas
                     */

                        IF ::oAlbCliT:DFECALB >= ::dIniInf .AND. ::oAlbCliT:DFECALB <= ::dFinInf

                           IF ::oDbf:Seek( ::oDbfArt:Familia )

                              ::oDbf:Load()

                              ::oDbf:NNUMCAJ    += ::oAlbCliL:NCANENT
                              ::oDbf:NNUMUNI    += ::oAlbCliL:nUniCaja
                              ::oDbf:NTOTUNI    += nTotNAlbCli( ::oAlbCliL )
                              ::oDbf:NIMPART    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                              ::oDbf:NIVAART    += Round( ::oDbf:nImpArt * ::oAlbCliL:NIVA / 100, ::nDerOut )
                              ::oDbf:NIMPCOM    := nPreFamilia( ::oDbfArt:FAMILIA, ::aMes, ::lAno, ::oDbfFam:cAlias )
                              ::oDbf:NIMPDES    := ::oDbf:NNUMUNI - ::oDbf:NIMPCOM
                              ::oDbf:NPREMED    := ::oDbf:NIMPART / ::oDbf:NNUMUNI

                              ::oDbf:Save()

                           ELSE

                              ::oDbf:Append()

                              ::oDbf:cCodFam    := ::oDbfArt:Familia
                              ::oDbf:CNOMFAM    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                              ::oDbf:NNUMCAJ    := ::oAlbCliL:NCANENT
                              ::oDbf:NNUMUNI    := ::oAlbCliL:nUniCaja
                              ::oDbf:NTOTUNI    := nTotNAlbCli( ::oAlbCliL )
                              ::oDbf:NIMPART    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                              ::oDbf:NIMPCOM    := nPreFamilia( ::oDbfArt:FAMILIA, ::aMes, ::lAno, ::oDbfFam:cAlias )
                              ::oDbf:NIVAART    := Round( ::oDbf:nImpArt * ::oAlbCliL:NIVA / 100, ::nDerOut )
                              ::oDbf:NIMPDES    := ::oDbf:NNUMUNI - ::oDbf:NIMPCOM
                              ::oDbf:NPREMED    := ::oDbf:NIMPART / ::oDbf:NNUMUNI

                              ::oDbf:Save()

                           END IF

                        END IF
                        /*
                        Acumulado
                        */

                        IF ::oDbf:Seek( ::oDbfArt:Familia )

                           ::oDbf:Load ()

                           ::oDbf:NACUCAJ    += ::oAlbCliL:nCanEnt
                           ::oDbf:NACUUNI    += ::oAlbCliL:nUniCaja
                           ::oDbf:nAcuTot    += nTotNAlbCli( ::oAlbCliL )
                           ::oDbf:NACUIMP    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                           ::oDbf:Save()

                        ELSE

                           ::oDbf:Append()

                           ::oDbf:cCodFam    := ::oDbfArt:Familia
                           ::oDbf:CNOMFAM    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                           ::oDbf:NACUCAJ    := ::oAlbCliL:nCanEnt
                           ::oDbf:NACUUNI    := ::oAlbCliL:nUniCaja
                           ::oDbf:nAcuTot    := nTotNAlbCli( ::oAlbCliL )
                           ::oDbf:NACUIMP    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                           ::oDbf:Save()

                        END IF

                     END IF

                  END IF
                  ::oAlbCliL:Skip()

               END WHILE

         END IF

      END IF

      ::oDbfArt:Skip()
      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   END WHILE

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//