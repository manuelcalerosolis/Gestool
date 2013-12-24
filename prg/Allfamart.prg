#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TAllFamArt()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODFAM", "C", 16, 0, {|| "@!" },          "Cod. familia",  .f., "Cod. familia"    ,  5 } )
   aAdd( aCol, { "CNOMFAM", "C", 50, 0, {|| "@!" },          "Familia",       .f., "Familia"         , 25 } )
   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },          "Cod. artículo", .t., "Codigo artículo" , 14 } )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },          "Descripción",   .t., "Descripción"     , 25 } )
   aAdd( aCol, { "NUNTENT", "N", 16, 6, {|| MasUnd() },      "Unidades",      .t., "Unidades"        , 10 } )
   aAdd( aCol, { "NPREDIV", "N", 16, 6, {|| oInf:cPicOut },  "Precio",        .t., "Precio artículo" , 10 } )
   aAdd( aCol, { "NIVATIL", "N", 16, 6, {|| oInf:cPicOut },  "%IVA",          .t., "%" + cImp()         ,  8 } )
   aAdd( aCol, { "NTOTUNI", "N", 16, 6, {|| oInf:cPicOut },  "Total",         .t., "Total vendido"   , 10 } )

   aAdd( aIdx, { "CCODFAM", "CCODFAM + CCODART" } )

   oInf        := TAFamArt():New( "Informe resumido de ventas de artículos agrupados por familias", aCol, aIdx, "01047" )

   oInf:AddGroup( {|| oInf:oDbf:cCodFam }, {|| "Familia : " + Rtrim( oInf:oDbf:cCodFam ) + "-" + oRetFld( oInf:oDbf:cCodFam, oInf:oDbfFam ) }, {||"Total familia..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TAFamArt FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oTikeT      AS OBJECT
   DATA  oTikeL      AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikeT PATH ( cPatEmp() ) CLASS "TIKETT" FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikeL PATH ( cPatEmp() ) CLASS "TIKETL" FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) CLASS "ARTICULO" FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) CLASS "ALBCLIL" FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) CLASS "FACCLIL" FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oTikeT != NIL
      ::oTikeT:End()
   end if

   if ::oTikeL != NIL
      ::oTikeL:End()
   end if

   if ::oFacCliT != NIL
      ::oFacCliT:End()
   end if

   if ::oFacCliL != NIL
      ::oFacCliL:End()
   end if

   if ::oAlbCliT != NIL
      ::oAlbCliT:End()
   end if

   if ::oAlbCliL != NIL
      ::oAlbCliL:End()
   end if

   ::oTikeT := NIL
   ::oTikeL := NIL
   ::oFacCliT := NIL
   ::oFacCliL := NIL
   ::oAlbCliT := NIL
   ::oAlbCliL := NIL

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INF_GEN18" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   ::lDefFamInf( 110, 120, 130, 140 )

   /*
   Excluir si cero
   */

   ::oDefExcInf()

   ::oDefResInf()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cCodFam
   local nLasTik  := ::oTikeT:Lastrec()
   local nLasAlb  := ::oAlbCliT:Lastrec()
   local nLasFac  := ::oFacCliT:Lastrec()
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oTikeT:GoTop()

   ::oMtrInf:SetTotal( nLasTik )

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia : " + ::cFamOrg       + " > " + ::cFamDes       } }

   /*
    Recorremos tikets
   */

   while !::oTikeT:Eof()

      if ::oTikeT:dFecTik >= ::dIniInf .and. ::oTikeT:dFecTik <= ::dFinInf

         if ::oTikeL:Seek( ::oTikeT:cSerTik + ::oTikeT:cNumTik + ::oTikeT:cSufTik )

            while ::oTikeL:cSerTil + ::oTikeL:cNumTil + ::oTikeL:cSufTil == ::oTikeT:cSerTik + ::oTikeT:cNumTik + ::oTikeT:cSufTik .and.;
                  !::oTikeL:eof()

               cCodFam := cCodFam( ::oTikeL:cCbaTil, ::oDbfArt )

               if cCodFam >= ::cFamOrg                             .and.;
                  cCodFam <= ::cFamDes                             .and.;
                  ::oTikeL:nCtlStk == 1                              .and.;
                  if( ::lExcCero, ::oTikeL:nUntTil != 0, .t. )

                  if ::oDbf:Seek( cCodFam + ::oTikeL:cCbaTil )

                     ::oDbf:Load()
                     ::oDbf:NUNTENT += if( ::oTikeT:cTipTik == "4", - ::oTikeL:nUntTil, ::oTikeL:nUntTil )
                     ::oDbf:NTOTUNI += if( ::oTikeT:cTipTik == "4", - ::oTikeL:nUntTil, ::oTikeL:nUntTil ) * ::oTikeL:nPvpTil
                     ::oDbf:NPREDIV := ::oTikeL:nPvpTil
                     ::oDbf:nIvaTil := ::oTikeL:nIvaTil
                     ::oDbf:Save()

                  else

                     ::oDbf:Append()
                     ::oDbf:CCODFAM := cCodFam
                     ::oDbf:CNOMFAM := cNomFam( cCodFam, ::oDbfFam )
                     ::oDbf:CCODART := ::oTikeL:cCbaTil
                     ::oDbf:CNOMART := ::oTikeL:cNomTil
                     ::oDbf:NUNTENT := if( ::oTikeT:cTipTik == "4", - ::oTikeL:nUntTil, ::oTikeL:nUntTil )
                     ::oDbf:NTOTUNI := if( ::oTikeT:cTipTik == "4", - ::oTikeL:nUntTil, ::oTikeL:nUntTil ) * ::oTikeL:nPvpTil
                     ::oDbf:NPREDIV := ::oDbf:nTotUni / ::oDbf:nUntEnt
                     ::oDbf:nIvaTil := ::oTikeL:nIvaTil
                     ::oDbf:Save()

                   end if

               end if

               ::oTikeL:Skip()

         ::oMtrInf:AutoInc()

      end while

   /*
    Recorremos albaranes
   */

   ::oAlbCliT:GoTop()

   while !::oAlbCliT:Eof()

      if ::oAlbCliT:dFecAlb >= ::dIniInf .and. ::oAlbCliT:dFecAlb <= ::dFinInf

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb )+ ::oAlbCliT:cSufAlb )

            while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb )+ ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and.;
                  !::oAlbCliL:eof()

               cCodFam := cCodFam( ::oAlbCliL:cRef, ::oDbfArt )

               if cCodFam >= ::cFamOrg                             .and.;
                  cCodFam <= ::cFamDes                             .and.;
                  ::oAlbCliL:nCtlStk == 1                            .and.;
                  if( ::lExcCero,( NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUnicaja )!= 0, .t. )

                  if ::oDbf:Seek( cCodFam + ::oAlbCliL:cRef )

                     ::oDbf:Load()
                     ::oDbf:NUNTENT += NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUnicaja
                     ::oDbf:NTOTUNI += NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUnicaja * ::oAlbCliL:nPreUnit
                     ::oDbf:NPREDIV := ::oDbf:nTotUni / ::oDbf:nUntEnt
                     ::oDbf:nIvaTil := ::oAlbCliL:nIva
                     ::oDbf:Save()

                  else

                     ::oDbf:Append()
                     ::oDbf:CCODFAM := cCodFam
                     ::oDbf:CNOMFAM := cNomFam( cCodFam, ::oDbfFam )
                     ::oDbf:CCODART := ::oAlbCliL:cRef
                     ::oDbf:CNOMART := ::oAlbCliL:cDetalle
                     ::oDbf:NUNTENT := NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUnicaja
                     ::oDbf:NTOTUNI := NotCaja( ::oAlbCliL:nCanEnt ) * ::oAlbCliL:nUnicaja * ::oAlbCliL:nPreUnit
                     ::oDbf:NPREDIV := ::oDbf:nTotUni / ::oDbf:nUntEnt
                     ::oDbf:nIvaAlb := ::oAlbCliL:nIva
                     ::oDbf:Save()

                   end if

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
    Recorremos facturas
   */

   ::oFacCliT:GoTop()

   while !::oFacCliT:Eof()

      if ::oFacCliT:dFecFac >= ::dIniInf .and. ::oFacCliT:dFecFac <= ::dFinInf

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac )+ ::oFacCliT:cSufFac )

            while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac )+ ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and.;
                  !::oFacCliL:eof()

               cCodFam := cCodFam( ::oFacCliL:cRef, ::oDbfArt )

               if cCodFam >= ::cFamOrg                             .and.;
                  cCodFam <= ::cFamDes                             .and.;
                  ::oFacCliL:nCtlStk == 1                            .and.;
                  if( ::lExcCero,( NotCaja( ::oFacCliL:nCanEnt ) * ::oFacCliL:nUnicaja )!= 0, .t. )

                  if ::oDbf:Seek( cCodFam + ::oFacCliL:cRef )

                     ::oDbf:Load()
                     ::oDbf:NUNTENT += NotCaja( ::oFacCliL:nCanEnt ) * ::oFacCliL:nUnicaja
                     ::oDbf:NTOTUNI += NotCaja( ::oFacCliL:nCanEnt ) * ::oFacCliL:nUnicaja * ::oFacCliL:nPreUnit
                     ::oDbf:NPREDIV := ::oDbf:nTotUni / ::oDbf:nUntEnt
                     ::oDbf:nIvaTil := ::oFacCliL:nIva
                     ::oDbf:Save()

                  else

                     ::oDbf:Append()
                     ::oDbf:CCODFAM := cCodFam
                     ::oDbf:CNOMFAM := cNomFam( cCodFam, ::oDbfFam )
                     ::oDbf:CCODART := ::oFacCliL:cRef
                     ::oDbf:CNOMART := ::oFacCliL:cDetalle
                     ::oDbf:NUNTENT := NotCaja( ::oFacCliL:nCanEnt ) * ::oFacCliL:nUnicaja
                     ::oDbf:NTOTUNI := NotCaja( ::oFacCliL:nCanEnt ) * ::oFacCliL:nUnicaja * ::oFacCliL:nPreUnit
                     ::oDbf:NPREDIV := ::oDbf:nTotUni / ::oDbf:nUntEnt
                     ::oDbf:nIvaFac := ::oFacCliL:nIva
                     ::oDbf:Save()

                   end if

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//