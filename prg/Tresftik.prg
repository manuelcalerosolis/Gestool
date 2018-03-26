#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION ResFamTikCli()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "cCodFam", "C", 16, 0, {|| "@!" },            "Cod.",           .t., "Código familia"              ,  5 } )
   aAdd( aCol, { "CNOMFAM", "C", 50, 0, {|| "@!" },            "Familia",        .t., "Familia"                     , 28 } )
   aAdd( aCol, { "NTOTUNI", "N", 19, 6, {|| MasUnd() },        "Tot. Und.",      .t., "Total unidades"              , 12 } )
   aAdd( aCol, { "NIMPART", "N", 19, 6, {|| oInf:cPicOut },    "Tot. Imp.",      .t., "Total importe"               , 12 } )
   aAdd( aCol, { "NIVAART", "N", 19, 6, {|| oInf:cPicOut },    cImp(),         .f., cImp()                      , 12 } )
   aAdd( aCol, { "NPREMED", "N", 19, 6, {|| oInf:cPicImp },    "Precio medio",   .f., "Precio medio"                , 12, .f. } )
   aAdd( aCol, { "NIMPCOM", "N", 19, 6, {|| oInf:cPicImp },    "Previsión",      .f., "Previsión"                   , 12 } )
   aAdd( aCol, { "NACUTOT", "N", 19, 6, {|| MasUnd() },        "Tot. Und. Acu.", .f., "Total unidades"              , 12 } )
   aAdd( aCol, { "NACUIMP", "N", 19, 6, {|| oInf:cPicOut },    "Tot. Imp. Acu.", .f., "Total importe acumulado"     , 12 } )
   aAdd( aCol, { "NIMPDES", "N", 19, 6, {|| oInf:cPicOut },    "Desviación",     .f., "Desviación"                  , 12 } )

   aAdd( aIdx, { "cCodFam", "cCodFam" } )

   oInf  := TResFamTik():New( "Informe resumido de ventas en tikets de clientes agrupado por familias", aCol, aIdx, "01056" )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TResFamTik FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
    
   DATA  aMes        AS ARRAY    INIT {.f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f. }
   DATA  lAno        AS LOGIC    INIT .f.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodFam", "C",  5, 0, {|| "@!" },         "Código",         .t., "Código familia"              ,  5  )
   ::AddField( "cNomFam", "C", 50, 0, {|| "@!" },         "Familia",        .t., "Familia"                     , 28  )
   ::AddField( "nTotUni", "N", 19, 6, {|| MasUnd() },     "Und.",           .t., "Unidades"                    , 12  )
   ::AddField( "nBasArt", "N", 19, 6, {|| ::cPicOut },    "Base",           .t., "Base"                        , 12  )
   ::AddField( "nIvaArt", "N", 19, 6, {|| ::cPicOut },    cImp(),         .f., cImp()                      , 12  )
   ::AddField( "nImpArt", "N", 19, 6, {|| ::cPicOut },    "Total",          .t., "Total"                       , 12  )
   ::AddField( "nPreMed", "N", 19, 6, {|| ::cPicImp },    "Precio medio",   .f., "Precio medio"                , 12  )
   ::AddField( "nImpCom", "N", 19, 6, {|| ::cPicImp },    "Previsión",      .f., "Previsión"                   , 12  )
   ::AddField( "nAcuTot", "N", 19, 6, {|| MasUnd() },     "Tot. Und. Acu.", .f., "Total unidades"              , 12  )
   ::AddField( "nAcuImp", "N", 19, 6, {|| ::cPicOut },    "Tot. Imp. Acu.", .f., "Total importe acumulado"     , 12  )
   ::AddField( "nImpDes", "N", 19, 6, {|| ::cPicOut },    "Desviación",     .f., "Desviación"                  , 12  )

   ::AddTmpIndex( "cCodFam", "cCodFam" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   /*
   Ficheros necesarios
   */

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"
   ::oTikCliL:SetOrder( "CCBATIL" )

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oTikCliT:End()
   ::oTikCliL:End()
   ::oDbfArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   local oEstado
   local cEstado := "Todos"

   if !::StdResource( "INF_GEN11A" )
      return .f.
   end if

   /*
   Monta familias
   */

   ::lDefFamInf( 110, 120, 130, 140 )

   /*
   Meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf(204)

   ::oDefResInf(202)

   ::oDefSalInf(201)

   REDEFINE CHECKBOX ::lExcMov  ID 203 OF ::oFld:aDialogs[1]

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

   REDEFINE COMBOBOX oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    { "Todos" } ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nImpLin
   local bValid   := {|| .t. }

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oDbfArt:GoTop()

   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:FAMILIA >= ::cFamOrg .AND. ::oDbfArt:FAMILIA <= ::cFamDes

         IF ::oTikCliL:Seek( ::oDbfArt:Codigo )

            WHILE ::oTikCliL:cCbaTil = ::oDbfArt:Codigo .AND. !::oTikCliL:Eof()

               /*
               Preguntamos si esta entre fechas
               */

               IF ::oTikCliT:Seek( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil )

                  if ( ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4" )            .AND.;
                     ::oTikCliT:DFECTik >= ::dIniInf                                         .AND.;
                     ::oTikCliT:DFECTik <= ::dFinInf                                         .AND.;
                     lChkSer( ::oTikCliT:cSerTik, ::aSer )                                   .AND.;
                     !( ::lExcCero .AND. ::oTikCliL:nPvpTil == 0 )

                     nImpLin              := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                     IF ::oDbf:Seek( ::oDbfArt:Familia )

                        ::oDbf:Load()

                        ::oDbf:nTotUni    += ::oTikCliL:nUntTil
                        ::oDbf:nImpArt    += nImpLin
                        ::oDbf:nIvaArt    += Round( nImpLin * ::oTikCliL:nIvaTil / 100, ::nDerOut )
                        ::oDbf:nImpDes    := ::oDbf:nImpArt - ::oDbf:NIMPCOM
                        ::oDbf:nPreMed    := ::oDbf:NIMPART / ::oDbf:nTotUni

                        ::oDbf:Save()

                     ELSE

                        ::oDbf:Append()

                        ::oDbf:cCodFam    := ::oDbfArt:Familia
                        ::oDbf:CNOMFAM    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                        ::oDbf:nTotUni    := ::oTikCliL:nUntTil
                        ::oDbf:NIMPART    := nImpLin
                        ::oDbf:NIMPCOM    := nPreFamilia( ::oDbfArt:FAMILIA, ::aMes, ::lAno, ::oDbfFam:cAlias )
                        ::oDbf:NIVAART    := Round( nImpLin * ::oTikCliL:nIvaTil / 100, ::nDerOut )
                        ::oDbf:NIMPDES    := ::oDbf:nTotUni - ::oDbf:NIMPCOM
                        ::oDbf:NPREMED    := ::oDbf:NIMPART / ::oDbf:nTotUni

                        ::oDbf:Save()

                     END IF

                     /*
                     Acumulado
                     */

                     IF ::oDbf:Seek( ::oDbfArt:Familia )

                        ::oDbf:Load()

                        ::oDbf:nAcuTot    += ::oTikCliL:nUntTil
                        ::oDbf:NACUIMP    += nImpLin

                        ::oDbf:Save()

                     else

                        ::oDbf:Append()

                        ::oDbf:cCodFam    := ::oDbfArt:Familia
                        ::oDbf:CNOMFAM    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                        ::oDbf:nAcuTot    := ::oTikCliL:nUntTil
                        ::oDbf:NACUIMP    := nImpLin

                        ::oDbf:Save()

                     end if

                  end if

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oDbfArt:Skip()
      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//