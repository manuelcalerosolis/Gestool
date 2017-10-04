#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDiaRentArticulo FROM TNewInfGen

   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT


   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc",     "C", 14, 0,  {|| "" },        "Documento",                  .f., "Número documento"          , 14, .f. )
   ::AddField( "cCodArt",     "C", 18, 0,  {|| "@!" },      "Código artículo",                  .f., "Código artículo"           , 14, .f. )
   ::AddField( "cNomArt",     "C",100, 0,  {|| "@!" },      "Artículo",                   .f., "Nombre artículo"           , 35, .f. )
   ::AddField( "nNumCaj",     "N", 16, 6,  {|| MasUnd() },  cNombreCajas(),               .f., cNombreCajas()              ,  8, .t. )
   ::AddField( "nUniDad",     "N", 16, 6,  {|| MasUnd() },  cNombreUnidades(),            .f., cNombreUnidades()           ,  8, .t. )
   ::AddField( "nNumUni",     "N", 16, 6,  {|| MasUnd() },  "Tot. " + cNombreUnidades(),  .t., "Total " + cNombreUnidades(), 14, .t. )
   ::AddField( "dFecMov",     "D",  8, 0,  {|| "@!" },      "Fecha",                      .t., "Fecha de ventas"           , 10, .t. )
   ::AddField( "nCostUni",    "N", 16, 6,  {|| ::cPicOut }, "Costo",                      .t., "Precio de costo"           ,  8, .t. )
   ::AddField( "nImpTot",     "N", 16, 6,  {|| ::cPicOut }, "Base",                       .t., "Base"                      ,  8, .t. )
   ::AddField( "nIvaTot",     "N", 19, 6,  {|| ::cPicOut }, cImp(),                     .t., cImp()                    ,  8, .t. )
   ::AddField( "nTotFin",     "N", 16, 6,  {|| ::cPicOut }, "Total",                      .t., "Total"                     , 10, .t. )
   ::AddField( "nRenTab",     "N", 16, 6,  {|| ::cPicOut }, "%Rent.",                     .f., "Rentabilidad"              , 10, .f. )
   ::AddField( "cCodFam",     "C", 16, 0,  {|| "@!" },      "Cod. fam.",                  .f., "Código familia"            , 10, .f. )
   ::AddField( "cNomFam",     "C", 40, 0,  {|| "@!" },      "Familia",                    .f., "Nombre familia"            , 14, .f. )
   ::AddField( "cCodCat",     "C",  3, 0,  {|| "@!" },      "Cod. cat.",                  .f., "Código categoria"          , 10, .f. )
   ::AddField( "cNomCat",     "C", 50, 0,  {|| "@!" },      "Categoria",                  .f., "Nombre categoria"          , 14, .f. )
   ::AddField( "cCodTmp",     "C",  5, 0,  {|| "@!" },      "Cod. tmp.",                  .f., "Código temporada"          , 10, .f. )
   ::AddField( "cNomTmp",     "C", 50, 0,  {|| "@!" },      "Temporada",                  .f., "Nombre temporada"          , 14, .f. )
   ::AddField( "cCodTArt",    "C",  3, 0,  {|| "@!" },      "Cod. tip.",                  .f., "Código tipo artículo"      , 10, .f. )
   ::AddField( "cNomTArt",    "C", 35, 0,  {|| "@!" },      "Tipo Art.",                  .f., "Tipo artículo"             , 14, .f. )
   ::AddField( "cCodFab",     "C",  3, 0,  {|| "@!" },      "Cod. fab.",                  .f., "Código fabricante"         , 10, .f. )
   ::AddField( "cNomFab",     "C", 35, 0,  {|| "@!" },      "Fabricante",                 .f., "Nombre fabricante"         , 14, .f. )

   ::AddTmpIndex( "cCodFec", "cCodArt + Dtos( dFecMov )" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaRentArticulo

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() )   FILE "TIKET.DBF"     VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() )   FILE "TIKEL.DBF"     VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() )   FILE "ALBCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() )   FILE "FACCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() )   FILE "FACRECT.DBF"   VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() )   FILE "FACRECL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaRentArticulo

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if
   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TDiaRentArticulo

   ::lNewInforme  := .t.

   if !::NewResource()
      return .f.
   end if

   if !::lGrupoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoFamilia( .t. )
      return .f.
   end if

   if !::lGrupoCategoria( .t. )
      return .f.
   end if

   if !::lGrupoTemporada( .t. )
      return .f.
   end if

   if !::lGrupoTipoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoFabricante( .t. )
      return .f.
   end if

   ::lDefCondiciones := .f.

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::CreateFilter( , ::oDbfArt )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TDiaRentArticulo

   local cExpLine
   local nTotUni
   local nTotImpUni
   local nCosUni
   local nTotCosUni
   local nImpDtoAtp

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*
   Cabeceras del documento-----------------------------------------------------
   */

   ::aHeader   := {  {|| Padr( "Fecha", 13 ) + ": " + Dtoc( Date() ) },;
                     {|| Padr( "Periodo", 13 ) + ": " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } }

   if !::oGrupoArticulo:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Artículo", 13 ) + ": " + AllTrim( ::oGrupoArticulo:Cargo:Desde ) + " > " + AllTrim( ::oGrupoArticulo:Cargo:Hasta ) } )
   end if

   if !::oGrupoFamilia:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Familia", 13 ) + ": " + AllTrim( ::oGrupoFamilia:Cargo:Desde ) + " > " + AllTrim( ::oGrupoFamilia:Cargo:Hasta ) } )
   end if

   /*
   Creo los filtros para luego utilizarlo en las tablas------------------------
   */

   cExpLine          := 'dFecha >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecha <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) .and. nFacturado < 3'

   if !::oGrupoArticulo:Cargo:Todos
      cExpLine       += ' .and. cRef >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cRef <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
   end if

   if !::oGrupoFamilia:Cargo:Todos
      cExpLine       += ' .and. cCodFam >= "' + ::oGrupoFamilia:Cargo:Desde + '" .and. cCodFam <= "' + ::oGrupoFamilia:Cargo:Hasta + '"'
   end if

   /*
   Recorro las lineas de albaranes---------------------------------------------
   */

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliL:GoTop()

   ::oMtrInf:cText            := "Albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliL:OrdKeyCount() )

   while !::lBreak .and. !::oAlbCliL:Eof()

      if ( ::oGrupoCategoria:Cargo:Todos  .or. ( oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "CCODCATE" ) >= ::oGrupoCategoria:Cargo:Desde .and. oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "CCODCATE" ) <= ::oGrupoCategoria:Cargo:Hasta ) ) .and.;
         ( ::oGrupoTemporada:Cargo:Todos  .or. ( oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "CCODTEMP" ) >= ::oGrupoTemporada:Cargo:Desde .and. oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "CCODTEMP" ) <= ::oGrupoTemporada:Cargo:Hasta ) ) .and.;
         ( ::oGrupoTArticulo:Cargo:Todos  .or. ( oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "CCODTIP"  ) >= ::oGrupoTArticulo:Cargo:Desde .and. oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "CCODTIP"  ) <= ::oGrupoTArticulo:Cargo:Hasta ) ) .and.;
         ( ::oGrupoFabricante:Cargo:Todos .or. ( oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "cCodFab"  ) >= ::oGrupoTArticulo:Cargo:Desde .and. oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "cCodFab"  ) <= ::oGrupoTArticulo:Cargo:Hasta ) )

         if !::oDbf:Seek( ::oAlbCliL:cRef + Dtos( ::oAlbCliL:dFecha ) )

            /*
            Calculo totales-------------------------------------------------------
            */

            nTotUni              := nTotNAlbCli( ::oAlbCliL:cAlias )
            nTotImpUni           := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
            nImpDtoAtp           := nDtoAtpAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

            if ::oAlbCliL:nCosDiv == 0
               nCosUni           := nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef )
               nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
            else
               nCosUni           := ::oAlbCliL:nCosDiv
               nTotCosUni        := ::oAlbCliL:nCosDiv * nTotUni
            end if

            ::oDbf:Append()

            ::oDbf:cNumDoc       := ::oAlbCliL:cSerAlb + "/" + Alltrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + ::oAlbCliL:cSufAlb
            ::oDbf:cCodArt       := ::oAlbCliL:cRef
            ::oDbf:cNomArt       := ::oAlbCliL:cDetalle
            ::oDbf:nNumCaj       := ::oAlbCliL:nCanEnt
            ::oDbf:nUniDad       := ::oAlbCliL:nUniCaja
            ::oDbf:nNumUni       := nTotUni
            ::oDbf:dFecMov       := ::oAlbCliL:dFecha
            ::oDbf:nImpTot       := ::oAlbCliL:nPreUnit
            ::oDbf:nIvaTot       := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
            ::oDbf:nTotFin       := nTotImpUni + ::oDbf:nIvaTot
            ::oDbf:nCostUni      := nCosUni
            ::oDbf:cCodFam       := ::oAlbCliL:cCodFam
            ::oDbf:cNomFam       := oRetFld( ::oAlbCliL:cCodFam, ::oDbfFam )
            ::oDbf:cCodCat       := oRetFld( ::oAlbCliL:cRef,  ::oDbfArt,        "CCODCATE"  )
            ::oDbf:cNomCat       := oRetFld( ::oDbf:cCodCat,   ::oDbfCat,        "cNombre"   )
            ::oDbf:cCodTmp       := oRetFld( ::oAlbCliL:cRef,  ::oDbfArt,        "CCODTEMP"  )
            ::oDbf:cNomTmp       := oRetFld( ::oDbf:cCodTmp,   ::oDbfTmp,        "cNombre"   )
            ::oDbf:cCodTArt      := oRetFld( ::oAlbCliL:cRef,  ::oDbfArt,        "CCODTIP"   )
            ::oDbf:cNomTArt      := oRetFld( ::oDbf:cCodTArt,  ::oTipArt:oDbf,   "cNomTip"   )
            ::oDbf:cCodFab       := oRetFld( ::oAlbCliL:cRef,  ::oDbfArt,        "cCodFab"   )
            ::oDbf:cNomFab       := oRetFld( ::oDbf:cCodFab,   ::oDbfFab:oDbf,   "cNomFab"   )

            if nTotUni != 0 .or. nCosUni != 0
               ::oDbf:nRenTab       := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
            else
               ::oDbf:nRenTab       := 0
            end if

            ::oDbf:Save()

         else

            nTotUni              := nTotNAlbCli( ::oAlbCliL:cAlias )
            nTotImpUni           := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
            nImpDtoAtp           := nDtoAtpAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

            if ::oAlbCliL:nCosDiv == 0
               nCosUni           := nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef )
               nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
            else
               nCosUni           := ::oAlbCliL:nCosDiv
               nTotCosUni        := ::oAlbCliL:nCosDiv * nTotUni
            end if

            ::oDbf:Load()
            ::oDbf:nNumCaj       += ::oAlbCliL:nCanEnt
            ::oDbf:nUniDad       += ::oAlbCliL:nUniCaja
            ::oDbf:nNumUni       += nTotUni
            ::oDbf:nIvaTot       += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
            ::oDbf:nTotFin       += nTotImpUni + nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

            if nTotUni != 0 .or. nCosUni != 0
               ::oDbf:nRenTab       := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
            else
               ::oDbf:nRenTab       := 0
            end if

            ::oDbf:Save()

         end if

      end if

   ::oAlbCliL:Skip()

   ::oMtrInf:AutoInc()

   end while

   /*
   Una vez terminado con la tabla elimino el filtro----------------------------
   */

   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

   /*
   Recorro las lineas de facturas rectificativas-------------------------------
   */

   cExpLine          := 'dFecha >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecha <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::oGrupoArticulo:Cargo:Todos
      cExpLine       += ' .and. cRef >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cRef <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
   end if

   if !::oGrupoFamilia:Cargo:Todos
      cExpLine       += ' .and. cCodFam >= "' + ::oGrupoFamilia:Cargo:Desde + '" .and. cCodFam <= "' + ::oGrupoFamilia:Cargo:Hasta + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecL:GoTop()

   ::oMtrInf:cText   := "Factura rectificativas"
   ::oMtrInf:SetTotal( ::oFacRecL:OrdKeyCount() )

   while !::lBreak .and. !::oFacRecL:Eof()

      if ( ::oGrupoCategoria:Cargo:Todos  .or. ( oRetFld( ::oFacRecL:cRef, ::oDbfArt, "CCODCATE" ) >= ::oGrupoCategoria:Cargo:Desde .and. oRetFld( ::oFacRecL:cRef, ::oDbfArt, "CCODCATE" ) <= ::oGrupoCategoria:Cargo:Hasta ) ) .and.;
         ( ::oGrupoTemporada:Cargo:Todos  .or. ( oRetFld( ::oFacRecL:cRef, ::oDbfArt, "CCODTEMP" ) >= ::oGrupoTemporada:Cargo:Desde .and. oRetFld( ::oFacRecL:cRef, ::oDbfArt, "CCODTEMP" ) <= ::oGrupoTemporada:Cargo:Hasta ) ) .and.;
         ( ::oGrupoTArticulo:Cargo:Todos  .or. ( oRetFld( ::oFacRecL:cRef, ::oDbfArt, "CCODTIP"  ) >= ::oGrupoTArticulo:Cargo:Desde .and. oRetFld( ::oFacRecL:cRef, ::oDbfArt, "CCODTIP"  ) <= ::oGrupoTArticulo:Cargo:Hasta ) ) .and.;
         ( ::oGrupoFabricante:Cargo:Todos .or. ( oRetFld( ::oFacRecL:cRef, ::oDbfArt, "cCodFab"  ) >= ::oGrupoTArticulo:Cargo:Desde .and. oRetFld( ::oFacRecL:cRef, ::oDbfArt, "cCodFab"  ) <= ::oGrupoTArticulo:Cargo:Hasta ) )

         if ::oFacRecL:dFecha >= ::dIniInf .and. ::oFacRecL:dFecha <= ::dFinInf

            if !::oDbf:Seek( ::oFacRecL:cRef + Dtos( ::oFacRecL:dFecha ) )

               nTotUni              := nTotNFacRec( ::oFacRecL:cAlias )
               nTotImpUni           := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
               nImpDtoAtp           := 0

               if ::oFacRecL:nCosDiv == 0
                  nCosUni           := nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef )
                  nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
               else
                  nCosUni           := ::oFacRecL:nCosDiv
                  nTotCosUni        := ::oFacRecL:nCosDiv * nTotUni
               end if

               ::oDbf:Append()

               ::oDbf:cNumDoc       := ::oFacRecL:cSerie + "/" + Alltrim( Str( ::oFacRecL:nNumFac ) ) + "/" + ::oFacRecL:cSufFac
               ::oDbf:cCodArt       := ::oFacRecL:cRef
               ::oDbf:cNomArt       := ::oFacRecL:cDetalle
               ::oDbf:nNumCaj       := ::oFacRecL:nCanEnt
               ::oDbf:nUnidad       := ::oFacRecL:nUniCaja
               ::oDbf:nNumUni       := nTotUni
               ::oDbf:dFecMov       := ::oFacRecL:dFecha
               ::oDbf:nImpTot       := ::oFacRecL:nPreUnit
               ::oDbf:nIvaTot       := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin       := nTotImpUni + ::oDbf:nIvaTot
               ::oDbf:nCostUni      := nCosUni
               ::oDbf:cCodFam       := ::oFacRecL:cCodFam
               ::oDbf:cNomFam       := oRetFld( ::oFacRecL:cCodFam, ::oDbfFam )
               ::oDbf:cCodCat       := oRetFld( ::oFacRecL:cRef,  ::oDbfArt,        "CCODCATE"  )
               ::oDbf:cNomCat       := oRetFld( ::oDbf:cCodCat,   ::oDbfCat,        "cNombre"   )
               ::oDbf:cCodTmp       := oRetFld( ::oFacRecL:cRef,  ::oDbfArt,        "CCODTEMP"  )
               ::oDbf:cNomTmp       := oRetFld( ::oDbf:cCodTmp,   ::oDbfTmp,        "cNombre"   )
               ::oDbf:cCodTArt      := oRetFld( ::oFacRecL:cRef,  ::oDbfArt,        "CCODTIP"   )
               ::oDbf:cNomTArt      := oRetFld( ::oDbf:cCodTArt,  ::oTipArt:oDbf,   "cNomTip"   )
               ::oDbf:cCodFab       := oRetFld( ::oFacRecL:cRef,  ::oDbfArt,        "cCodFab"   )
               ::oDbf:cNomFab       := oRetFld( ::oDbf:cCodFab,   ::oDbfFab:oDbf,   "cNomFab"   )

               if nTotUni != 0 .or. nCosUni != 0
                  ::oDbf:nRenTab    := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
               else
                  ::oDbf:nRenTab    := 0
               end if

               ::oDbf:Save()

            else

               nTotUni              := nTotNFacRec( ::oFacRecL:cAlias )
               nTotImpUni           := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
               nImpDtoAtp           := 0

               if ::oFacRecL:nCosDiv == 0
                  nCosUni           := nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef )
                  nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
               else
                  nCosUni           := ::oFacRecL:nCosDiv
                  nTotCosUni        := ::oFacRecL:nCosDiv * nTotUni
               end if

               ::oDbf:Load()
               ::oDbf:nNumCaj       += ::oFacRecL:nCanEnt
               ::oDbf:nUnidad       += ::oFacRecL:nUniCaja
               ::oDbf:nNumUni       += nTotUni
               ::oDbf:nIvaTot       += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin       += nTotImpUni + nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

               if nTotUni != 0 .or. nCosUni != 0
                  ::oDbf:nRenTab    := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
               else
                  ::oDbf:nRenTab    := 0
               end if

               ::oDbf:Save()

            end if

         end if

      end if

   ::oFacRecL:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   /*
   Recorro las lineas de facturas----------------------------------------------
   */

   cExpLine          := 'dFecha >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecha <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::oGrupoArticulo:Cargo:Todos
      cExpLine       += ' .and. cRef >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cRef <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
   end if

   if !::oGrupoFamilia:Cargo:Todos
      cExpLine       += ' .and. cCodFam >= "' + ::oGrupoFamilia:Cargo:Desde + '" .and. cCodFam <= "' + ::oGrupoFamilia:Cargo:Hasta + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliL:GoTop()
   ::oMtrInf:cText   := "Factura"
   ::oMtrInf:SetTotal( ::oFacCliL:OrdKeyCount() )

   while !::lBreak .and. !::oFacCliL:Eof()

      if ( ::oGrupoCategoria:Cargo:Todos  .or. ( oRetFld( ::oFacCliL:cRef, ::oDbfArt, "CCODCATE" ) >= ::oGrupoCategoria:Cargo:Desde .and. oRetFld( ::oFacCliL:cRef, ::oDbfArt, "CCODCATE" ) <= ::oGrupoCategoria:Cargo:Hasta ) ) .and.;
         ( ::oGrupoTemporada:Cargo:Todos  .or. ( oRetFld( ::oFacCliL:cRef, ::oDbfArt, "CCODTEMP" ) >= ::oGrupoTemporada:Cargo:Desde .and. oRetFld( ::oFacCliL:cRef, ::oDbfArt, "CCODTEMP" ) <= ::oGrupoTemporada:Cargo:Hasta ) ) .and.;
         ( ::oGrupoTArticulo:Cargo:Todos  .or. ( oRetFld( ::oFacCliL:cRef, ::oDbfArt, "CCODTIP"  ) >= ::oGrupoTArticulo:Cargo:Desde .and. oRetFld( ::oFacCliL:cRef, ::oDbfArt, "CCODTIP"  ) <= ::oGrupoTArticulo:Cargo:Hasta ) ) .and.;
         ( ::oGrupoFabricante:Cargo:Todos .or. ( oRetFld( ::oFacCliL:cRef, ::oDbfArt, "cCodFab"  ) >= ::oGrupoTArticulo:Cargo:Desde .and. oRetFld( ::oFacCliL:cRef, ::oDbfArt, "cCodFab"  ) <= ::oGrupoTArticulo:Cargo:Hasta ) )

         if ::oFacCliL:dFecha >= ::dIniInf .and. ::oFacCliL:dFecha <= ::dFinInf

            if !::oDbf:Seek( ::oFacCliL:cRef + Dtos( ::oFacCliL:dFecha ) )

               nTotUni              := nTotNFacCli( ::oFacCliL )
               nTotImpUni           := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
               nImpDtoAtp           := nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

               if ::oFacCliL:nCosDiv == 0
                  nCosUni           := nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef )
                  nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
               else
                  nCosUni           := ::oFacCliL:nCosDiv
                  nTotCosUni        := ::oFacCliL:nCosDiv * nTotUni
               end if

               ::oDbf:Append()

               ::oDbf:cNumDoc       := ::oFacCliL:cSerie + "/" + Alltrim( Str( ::oFacCliL:nNumFac ) ) + "/" + ::oFacCliL:cSufFac
               ::oDbf:cCodArt       := ::oFacCliL:cRef
               ::oDbf:cNomArt       := ::oFacCliL:cDetalle
               ::oDbf:nNumCaj       := ::oFacCliL:nCanEnt
               ::oDbf:nUnidad       := ::oFacCliL:nUniCaja
               ::oDbf:nNumUni       := nTotUni
               ::oDbf:dFecMov       := ::oFacCliL:dFecha
               ::oDbf:nImpTot       := ::oFacCliL:nPreUnit
               ::oDbf:nIvaTot       := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin       := nTotImpUni + ::oDbf:nIvaTot
               ::oDbf:nCostUni      := nCosUni
               ::oDbf:cCodFam       := ::oFacCliL:cCodFam
               ::oDbf:cNomFam       := oRetFld( ::oFacCliL:cCodFam, ::oDbfFam )
               ::oDbf:cCodCat       := oRetFld( ::oFacCliL:cRef, ::oDbfArt,      "CCODCATE"  )
               ::oDbf:cNomCat       := oRetFld( ::oDbf:cCodCat,  ::oDbfCat,      "cNombre"   )
               ::oDbf:cCodTmp       := oRetFld( ::oFacCliL:cRef, ::oDbfArt,      "CCODTEMP"  )
               ::oDbf:cNomTmp       := oRetFld( ::oDbf:cCodTmp,  ::oDbfTmp,      "cNombre"   )
               ::oDbf:cCodTArt      := oRetFld( ::oFacCliL:cRef, ::oDbfArt,      "CCODTIP"   )
               ::oDbf:cNomTArt      := oRetFld( ::oDbf:cCodTArt, ::oTipArt:oDbf, "cNomTip"   )
               ::oDbf:cCodFab       := oRetFld( ::oFacCliL:cRef, ::oDbfArt,      "cCodFab"   )
               ::oDbf:cNomFab       := oRetFld( ::oDbf:cCodFab,  ::oDbfFab:oDbf, "cNomFab"   )

               if nTotUni != 0 .or. nCosUni != 0
                  ::oDbf:nRenTab    := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
               else
                  ::oDbf:nRenTab    := 0
               end if

               ::oDbf:Save()

            else

               nTotUni              := nTotNFacCli( ::oFacCliL )
               nTotImpUni           := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
               nImpDtoAtp           := nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

               if ::oFacCliL:nCosDiv == 0
                  nCosUni           := nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef )
                  nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
               else
                  nCosUni           := ::oFacCliL:nCosDiv
                  nTotCosUni        := ::oFacCliL:nCosDiv * nTotUni
               end if

               ::oDbf:Load()
               ::oDbf:nNumCaj       += ::oFacCliL:nCanEnt
               ::oDbf:nUnidad       += ::oFacCliL:nUniCaja
               ::oDbf:nNumUni       += nTotUni
               ::oDbf:nIvaTot       += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin       += nTotImpUni + nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

               if nTotUni != 0 .or. nCosUni != 0
                  ::oDbf:nRenTab    := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
               else
                  ::oDbf:nRenTab    := 0
               end if

               ::oDbf:Save()

            end if

         end if

      end if

   ::oFacCliL:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*
   Recorro las lineas de tiket-------------------------------------------------
   */

   cExpLine          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   if !::oGrupoArticulo:Cargo:Todos
      cExpLine       := 'cCbaTil >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cCbaTil <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'

      if !::oGrupoFamilia:Cargo:Todos
         cExpLine    += ' .and. cCodFam >= "' + ::oGrupoFamilia:Cargo:Desde + '" .and. cCodFam <= "' + ::oGrupoFamilia:Cargo:Hasta + '"'
      end if

      ::oTikCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   else

      if !::oGrupoFamilia:Cargo:Todos
         cExpLine    := 'cCodFam >= "' + ::oGrupoFamilia:Cargo:Desde + '" .and. cCodFam <= "' + ::oGrupoFamilia:Cargo:Hasta + '"'
         ::oTikCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )
      end if

   end if

   ::oTikCliT:GoTop()
   ::oTikCliL:GoTop()

   ::oMtrInf:cText   := "Tiket"
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   while !::lBreak .and. !::oTikCliT:Eof()

      if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .and. !::oTikCliL:Eof()

            if ( ::oGrupoCategoria:Cargo:Todos  .or. ( oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "CCODCATE" ) >= ::oGrupoCategoria:Cargo:Desde .and. oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "CCODCATE" ) <= ::oGrupoCategoria:Cargo:Hasta ) ) .and.;
               ( ::oGrupoTemporada:Cargo:Todos  .or. ( oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "CCODTEMP" ) >= ::oGrupoTemporada:Cargo:Desde .and. oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "CCODTEMP" ) <= ::oGrupoTemporada:Cargo:Hasta ) ) .and.;
               ( ::oGrupoTArticulo:Cargo:Todos  .or. ( oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "CCODTIP"  ) >= ::oGrupoTArticulo:Cargo:Desde .and. oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "CCODTIP"  ) <= ::oGrupoTArticulo:Cargo:Hasta ) ) .and.;
               ( ::oGrupoFabricante:Cargo:Todos .or. ( oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "cCodFab"  ) >= ::oGrupoTArticulo:Cargo:Desde .and. oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "cCodFab"  ) <= ::oGrupoTArticulo:Cargo:Hasta ) )

               if !::oDbf:Seek( ::oTikCliL:cCbaTil + Dtos( ::oTikCliT:dFecTik ) )

                  nTotUni           := ::oTikCliL:nUntTil
                  nTotImpUni        := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil )
                  nImpDtoAtp        := 0

                  if ::oTikCliL:nCosDiv != 0
                     nCosUni           := ::oTikCliL:nCosDiv
                     nTotCosUni        := ::oTikCliL:nCosDiv * nTotUni
                  else
                     nCosUni           := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil )
                     nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
                  end if

                  ::oDbf:Append()

                  ::oDbf:cNumDoc       := ::oTikCliL:cSerTiL + "/" + Alltrim( ::oTikCliL:cNumTiL ) + "/" + ::oTikCliL:cSufTiL
                  ::oDbf:cCodArt       := ::oTikCliL:cCbaTil
                  ::oDbf:cNomArt       := ::oTikCliL:cNomTil
                  ::oDbf:nUnidad       := ::oTikCliL:nUntTil
                  ::oDbf:nNumUni       := nTotUni
                  ::oDbf:dFecMov       := ::oTikCliT:dFecTik
                  ::oDbf:nImpTot       := nTotImpUni / nTotUni
                  ::oDbf:nIvaTot       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin       := nTotImpUni + nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nCostUni      := nCosUni
                  ::oDbf:cCodFam       := ::oTikCliL:cCodFam
                  ::oDbf:cNomFam       := oRetFld( ::oTikCliL:cCodFam,  ::oDbfFam )
                  ::oDbf:cCodCat       := oRetFld( ::oTikCliL:cCbaTil,  ::oDbfArt,        "CCODCATE"  )
                  ::oDbf:cNomCat       := oRetFld( ::oDbf:cCodCat,      ::oDbfCat,        "cNombre"   )
                  ::oDbf:cCodTmp       := oRetFld( ::oTikCliL:cCbaTil,  ::oDbfArt,        "CCODTEMP"  )
                  ::oDbf:cNomTmp       := oRetFld( ::oDbf:cCodTmp,      ::oDbfTmp,        "cNombre"   )
                  ::oDbf:cCodTArt      := oRetFld( ::oTikCliL:cCbaTil,  ::oDbfArt,        "CCODTIP"   )
                  ::oDbf:cNomTArt      := oRetFld( ::oDbf:cCodTArt,     ::oTipArt:oDbf,   "cNomTip"   )
                  ::oDbf:cCodFab       := oRetFld( ::oTikCliL:cCbaTil,  ::oDbfArt,        "cCodFab"   )
                  ::oDbf:cNomFab       := oRetFld( ::oDbf:cCodFab,      ::oDbfFab:oDbf,   "cNomFab"   )

                  if nTotUni != 0 .or. nCosUni != 0
                     ::oDbf:nRenTab    := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
                  else
                     ::oDbf:nRenTab    := 0
                  end if

                  ::oDbf:Save()

               else

                  nTotUni              := ::oTikCliL:nUntTil
                  nTotImpUni           := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil )
                  nImpDtoAtp           := 0

                  if ::oTikCliL:nCosDiv != 0
                     nCosUni           := ::oTikCliL:nCosDiv
                     nTotCosUni        := ::oTikCliL:nCosDiv * nTotUni
                  else
                     nCosUni           := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil )
                     nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
                  end if

                  ::oDbf:Load()
                  ::oDbf:nUnidad       += ::oTikCliL:nUntTil
                  ::oDbf:nNumUni       += nTotUni
                  ::oDbf:nIvaTot       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin       += nTotImpUni + nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv )

                  if nTotUni != 0 .or. nCosUni != 0
                     ::oDbf:nRenTab       := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
                  else
                     ::oDbf:nRenTab    := 0
                  end if

                  ::oDbf:Save()

               end if

            end if

         ::oTikCliL:Skip()

         end while

      end if

   ::oTikCliT:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   if !::oGrupoArticulo:Cargo:Todos
      ::oTikCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ) )
   end if

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//