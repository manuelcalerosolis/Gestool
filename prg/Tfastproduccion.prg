#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"
// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastProduccion FROM TFastReportInfGen
   
   DATA cType                             INIT "PRODUCCION"

   DATA oParteProduccion   
   DATA oMaterialProducido   
   DATA oMateriasPrimas
   DATA oPersonal   
   DATA oHorasPersonal
   DATA oMaquinasCostes   
   DATA oMaquinasParte   
   DATA oFamArt 
   DATA oTarPreL  
   
   DATA cExpresionHeader

   DATA lApplyFilters                     INIT .t.

   METHOD lResource( cFld )

   METHOD Create()
   METHOD lGenerate()
   METHOD lValidRegister()
   METHOD lValidAlmacenOrigen()
   METHOD lValidAlmacenDestino()
   METHOD lValidMaterialProducido()
   METHOD lValidMateriaPrima()
   METHOD lValidOperario()
   METHOD lValidMaquinaria()

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD DataReport( oFr )
   METHOD AddVariable()

   METHOD StartDialog()
   METHOD BuildTree()

   METHOD AddParteProducccion()

   METHOD getFilterMaterialProducido()
   METHOD getFilterMateriaPrima()

   METHOD putFilter()
   METHOD ClearFilter()

   METHOD getPrecioTarifa( cCodTar, cCodArt )

   METHOD setFilterOperationId()   INLINE ( if( ::lApplyFilters,;
                                                 ::cExpresionHeader  += ' .and. ( Field->cCodOpe >= "' + ::oGrupoOperacion:Cargo:Desde + '" .and. Field->cCodOpe <= "' + ::oGrupoOperacion:Cargo:Hasta + '" )', ) )
   
   METHOD setFilterSectionId()         INLINE ( if( ::lApplyFilters,;
                                                 ::cExpresionHeader  += ' .and. ( Field->cCodSec >= "' + ::oGrupoSeccion:Cargo:Desde + '" .and. Field->cCodSec <= "' + ::oGrupoSeccion:Cargo:Hasta + '" )', ) )
   

ENDCLASS

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastProduccion

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   ::cSubTitle       := "Informe de producción"

   ::cTipoInforme    := "Producción"
   ::cBmpInforme     := "gc_worker2_64" 

   if !::NewResource()  
      return .f.
   end if

   /*
   Carga controles-------------------------------------------------------------
   */

   if !::lGrupoOperacion( .t. )
      return .f.
   end if
   
   if !::lGrupoTOperacion( .t. )
      return .f.
   end if

   if !::lGrupoSeccion( .t. )
      return .f.
   end if

   if !::lGrupoAlmacenOrigen( .t. )
      return .f.
   end if

   if !::lGrupoAlmacen( .t. )
      return .f.
   else 
      ::oGrupoAlmacen:Cargo:Nombre     := "Almacén destino"
   end if

   if !::lGrupoArticulo( .t. )
      return .f.
   else
      ::oGrupoArticulo:Cargo:Nombre    := "Material producido"
   end if

   if !::lGrupoMateriaPrima( .t. )
      return .f.
   end if

   if !::lGrupoFamilia( .t. )
      return .f.
   end if

   if !::lGrupoGFamilia( .t. )
      return .f.
   end if
   
   if !::lGrupoTipoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoTemporada( .t. )
      return .f.
   end if

   if !::lGrupoOperario( .t. )
      return .t.
   end if

   if !::lGrupoMaquina( .t. )
      return .f.
   end if

   if !::lGrupoSerie( .t. )
      return .f.
   end if

   ::oFilter      := TFilterCreator():Init()
   if !Empty( ::oFilter )
      ::oFilter:SetDatabase( ::oDbf )
      //::oFilter:SetFilterType( FST_PRO )
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TFastProduccion

   local lOpen    := .t.
   local oBlock
   local oError

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
   ::lApplyFilters   := lAIS()

   ::nView           := D():CreateView( ::cDriver )
   
      DATABASE NEW ::oParteProduccion     PATH ( cPatEmp() ) CLASS "PROCAB"      FILE "PROCAB.DBF"    VIA ( cDriver() ) SHARED INDEX "PROCAB.CDX"
      DATABASE NEW ::oMaterialProducido   PATH ( cPatEmp() ) CLASS "PROLIN"      FILE "PROLIN.DBF"    VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"
      DATABASE NEW ::oMateriasPrimas      PATH ( cPatEmp() ) CLASS "PROMAT"      FILE "PROMAT.DBF"    VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"
      DATABASE NEW ::oPersonal            PATH ( cPatEmp() ) CLASS "PROPER"      FILE "PROPER.DBF"    VIA ( cDriver() ) SHARED INDEX "PROPER.CDX"
      DATABASE NEW ::oHorasPersonal       PATH ( cPatEmp() ) CLASS "HORASPERS"   FILE "PROHPER.DBF"   VIA ( cDriver() ) SHARED INDEX "PROHPER.CDX"
      DATABASE NEW ::oMaquinasCostes      PATH ( cPatEmp() ) CLASS "MAQCOSL"     FILE "MAQCOSL.DBF"   VIA ( cDriver() ) SHARED INDEX "MAQCOSL.CDX"
      DATABASE NEW ::oMaquinasParte       PATH ( cPatEmp() ) CLASS "PROMAQ"      FILE "PROMAQ.DBF"    VIA ( cDriver() ) SHARED INDEX "PROMAQ.CDX"
      DATABASE NEW ::oTarPreL             PATH ( cPatEmp() ) CLASS "TARPREL"     FILE "TARPREL.DBF"   VIA ( cDriver() ) SHARED INDEX "TARPREL.CDX"

      ::oCnfFlt   := TDataCenter():oCnfFlt()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de producción" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TFastProduccion

   if !Empty( ::oParteProduccion ) .and. ( ::oParteProduccion:Used() )
      ::oParteProduccion:end()
   end if

   if !Empty( ::oMaterialProducido ) .and. ( ::oMaterialProducido:Used() )
      ::oMaterialProducido:end()
   end if

   if !Empty( ::oMateriasPrimas ) .and. ( ::oMateriasPrimas:Used() )
      ::oMateriasPrimas:end()
   end if

   if !Empty( ::oPersonal ) .and. ( ::oPersonal:Used() )
      ::oPersonal:end()
   end if

   if !Empty( ::oHorasPersonal ) .and. ( ::oHorasPersonal:Used() )
      ::oHorasPersonal:end()
   end if

   if !Empty( ::oMaquinasCostes ) .and. ( ::oMaquinasCostes:Used() )
      ::oMaquinasCostes:end()
   end if

   if !Empty( ::oMaquinasParte ) .and. ( ::oMaquinasParte:Used() )
      ::oMaquinasParte:end()
   end if

   if !Empty( ::oCnfFlt ) .and. ( ::oCnfFlt:Used() )
      ::oCnfFlt:end()
   end if

   if !Empty( ::oTarPreL ) .and. ( ::oTarPreL:Used() )
      ::oTarPreL:end()
   end if

   if !Empty( ::nView )
      D():DeleteView( ::nView )
   end if

   ::nView     := nil

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( uParam ) CLASS TFastProduccion

   ::AddField( "cSerDoc",     "C",  1, 0, {|| "" },   "Serie del documento"                     )
   ::AddField( "cNumDoc",     "C",  9, 0, {|| "" },   "Número del documento"                    )
   ::AddField( "cSufDoc",     "C",  2, 0, {|| "" },   "Delegación del documento"                )
   ::AddField( "cIdeDoc",     "C", 27, 0, {|| "" },   "Identificador del documento"             )

   ::AddField( "nAnoDoc",     "N",  4, 0, {|| "" },   "Año del documento"                       )
   ::AddField( "nMesDoc",     "N",  2, 0, {|| "" },   "Mes del documento"                       )
   ::AddField( "dFecIniDoc",  "D",  8, 0, {|| "" },   "Fecha inicio del documento"              )
   ::AddField( "dFecFinDoc",  "D",  8, 0, {|| "" },   "Fecha fin del documento"                 )

   ::AddField( "cCodOpe",     "C",  3, 0, {|| "" },   "Operación"                               )
   ::AddField( "cTipOpe", )
   ::AddField( "cCodSec",     "C",  3, 0, {|| "" },   "Sección"                                 )
   ::AddField( "cCodAlmDes",  "C", 16, 0, {|| "" },   "Almacen destino"                         ) 
   ::AddField( "cCodAlmOrg",  "C", 16, 0, {|| "" },   "Almacen origen"                          ) 

   ::AddField( "nTotPrd",     "N", 16, 6, {|| "" },   "Total producido"                         )
   ::AddField( "nUndPrd",     "N", 16, 6, {|| "" },   "Total unidades producidas"               )
   ::AddField( "nTotMat",     "N", 16, 6, {|| "" },   "Total materias primas"                   )
   ::AddField( "nTotPer",     "N", 16, 6, {|| "" },   "Total horas personal"                    )
   ::AddField( "nTotMaq",     "N", 16, 6, {|| "" },   "Total maquinaria"                        )

   ::AddTmpIndex( "cNumDoc", "cSerDoc + cNumDoc + cSufDoc" )

RETURN ( self )

//---------------------------------------------------------------------------//

Method lValidRegister( cCodigoProveedor ) CLASS TFastProduccion

   if lChkSer( ::oDbf:cSerDoc, ::aSer )  .and.;
      ( ::oDbf:cCodOpe >= ::oGrupoOperacion:Cargo:Desde     .and. ::oDbf:cCodOpe <= ::oGrupoOperacion:Cargo:Hasta )  .and.;
      ( ::oDbf:cCodSec >= ::oGrupoSeccion:Cargo:Desde       .and. ::oDbf:cCodSec <= ::oGrupoSeccion:Cargo:Hasta )    .and.;
      ( ::lValidAlmacenOrigen() )                           .and.;
      ( ::lValidAlmacenDestino() )                          .and.;
      ( ( ::lValidMaterialProducido() )                     .or.;
      ( ::lValidMateriaPrima() ) )                          .and.;
      ( ::lValidOperario() )                                .and.;
      ( ::lValidMaquinaria() )
      Return .t.

   end if

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD lValidAlmacenOrigen()
   
   local lValid   := .f.

   if ::oGrupoAlmacenOrigen:Cargo:Desde == Space( __LENALMACENES__ ) .and. ::oGrupoAlmacenOrigen:Cargo:Hasta == Replicate( "Z", __LENALMACENES__ )
      RETURN .t.
   end if

   if ::oMateriasPrimas:Seek( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd )
      while ( ::oMateriasPrimas:cSerOrd + Str( ::oMateriasPrimas:nNumOrd, 9 ) + ::oMateriasPrimas:cSufOrd ) == ( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd ) .and. ;
         !::oMateriasPrimas:Eof()
         if ::oMateriasPrimas:cAlmOrd >= ::oGrupoAlmacenOrigen:Cargo:Desde .and. ::oMateriasPrimas:cAlmOrd <= ::oGrupoAlmacenOrigen:Cargo:Hasta
            lValid := .t.
         end if
         ::oMateriasPrimas:Skip()
      end while
   end if

RETURN ( lValid )

//---------------------------------------------------------------------------//

METHOD lValidAlmacenDestino()
   
   local lValid   := .f.

   if ::oGrupoAlmacen:Cargo:Desde == Space( __LENALMACENES__ ) .and. ::oGrupoAlmacen:Cargo:Hasta == Replicate( "Z", __LENALMACENES__ )
      RETURN .t.
   end if

   if ::oMaterialProducido:Seek( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd )
      while ( ::oMaterialProducido:cSerOrd + Str( ::oMaterialProducido:nNumOrd, 9 ) + ::oMaterialProducido:cSufOrd ) == ( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd ) .and. ;
         !::oMaterialProducido:Eof()
         if ::oMaterialProducido:cAlmOrd >= ::oGrupoAlmacen:Cargo:Desde .and. ::oMaterialProducido:cAlmOrd <= ::oGrupoAlmacen:Cargo:Hasta
            lValid := .t.
         end if
         ::oMaterialProducido:Skip()
      end while
   end if 

RETURN ( lValid )

//---------------------------------------------------------------------------//

METHOD lValidMaterialProducido()
   
   local lValid   := .f.

   if ::oMaterialProducido:Seek( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd )

      while ( ::oMaterialProducido:cSerOrd + Str( ::oMaterialProducido:nNumOrd, 9 ) + ::oMaterialProducido:cSufOrd ) == ( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd ) .and. ;
         !::oMaterialProducido:Eof()

         if (  ( ::oGrupoArticulo:Cargo:Desde == Space( __LENARTICULOS__ ) .and. ::oGrupoArticulo:Cargo:Hasta == Replicate( "Z", __LENARTICULOS__ ) ) .or.;
               ( ::oMaterialProducido:cCodArt >= ::oGrupoArticulo:Cargo:Desde .and. ::oMaterialProducido:cCodArt <= ::oGrupoArticulo:Cargo:Hasta ) ) .and.;
            (  ( ::oGrupoTemporada:Cargo:Desde == Space( __LENTEMPORADAS__ ) .and. ::oGrupoTemporada:Cargo:Hasta == Replicate( "Z", __LENTEMPORADAS__ ) ) .or.;
               ( ::oMaterialProducido:cCodTmp >= ::oGrupoTemporada:Cargo:Desde .and. ::oMaterialProducido:cCodTmp <= ::oGrupoTemporada:Cargo:Hasta ) ) .and.;
            (  ( ::oGrupoFamilia:Cargo:Desde == Space( __LENFAMILIAS__ ) .and. ::oGrupoFamilia:Cargo:Hasta == Replicate( "Z", __LENFAMILIAS__ ) ) .or.;
               ( ::oMaterialProducido:cCodFam >= ::oGrupoFamilia:Cargo:Desde .and. ::oMaterialProducido:cCodFam <= ::oGrupoFamilia:Cargo:Hasta ) ) .and.;
            (  ( ::oGrupoGFamilia:Cargo:Desde == Space( __LENGRUPOSFAMILIAS__ ) .and. ::oGrupoGFamilia:Cargo:Hasta == Replicate( "Z", __LENGRUPOSFAMILIAS__ ) ) .or.;
               ( ::oMaterialProducido:cGrpFam >= ::oGrupoGFamilia:Cargo:Desde .and. ::oMaterialProducido:cGrpFam <= ::oGrupoGFamilia:Cargo:Hasta ) ) .and.;
            (  ( ::oGrupoTArticulo:Cargo:Desde == Space( __LENTIPOSARTICULOS__ ) .and. ::oGrupoTArticulo:Cargo:Hasta == Replicate( "Z", __LENTIPOSARTICULOS__ ) ) .or.;
               ( ::oMaterialProducido:cCodTip >= ::oGrupoTArticulo:Cargo:Desde .and. ::oMaterialProducido:cCodTip <= ::oGrupoTArticulo:Cargo:Hasta ) )

            lValid := .t.

         end if

         ::oMaterialProducido:Skip()

      end while

   end if 

RETURN ( lValid )

//---------------------------------------------------------------------------//

METHOD lValidMateriaPrima()
   
   local lValid   := .f.

   if ::oMateriasPrimas:Seek( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd )

      while ( ::oMateriasPrimas:cSerOrd + Str( ::oMateriasPrimas:nNumOrd, 9 ) + ::oMateriasPrimas:cSufOrd ) == ( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd ) .and. ;
         !::oMateriasPrimas:Eof()

         if (  ( ::oGrupoMateriaPrima:Cargo:Desde == Space( __LENARTICULOS__ ) .and. ::oGrupoMateriaPrima:Cargo:Hasta == Replicate( "Z", __LENARTICULOS__ ) ) .or.;
               ( ::oMateriasPrimas:cCodArt >= ::oGrupoMateriaPrima:Cargo:Desde .and. ::oMateriasPrimas:cCodArt <= ::oGrupoMateriaPrima:Cargo:Hasta ) ) .and.;
            (  ( ::oGrupoTemporada:Cargo:Desde == Space( __LENTEMPORADAS__ ) .and. ::oGrupoTemporada:Cargo:Hasta == Replicate( "Z", __LENTEMPORADAS__ ) ) .or.;
               ( ::oMateriasPrimas:cCodTmp >= ::oGrupoTemporada:Cargo:Desde .and. ::oMateriasPrimas:cCodTmp <= ::oGrupoTemporada:Cargo:Hasta ) ) .and.;
            (  ( ::oGrupoFamilia:Cargo:Desde == Space( __LENFAMILIAS__ ) .and. ::oGrupoFamilia:Cargo:Hasta == Replicate( "Z", __LENFAMILIAS__ ) ) .or.;
               ( ::oMateriasPrimas:cCodFam >= ::oGrupoFamilia:Cargo:Desde .and. ::oMateriasPrimas:cCodFam <= ::oGrupoFamilia:Cargo:Hasta ) ) .and.;
            (  ( ::oGrupoGFamilia:Cargo:Desde == Space( __LENGRUPOSFAMILIAS__ ) .and. ::oGrupoGFamilia:Cargo:Hasta == Replicate( "Z", __LENGRUPOSFAMILIAS__ ) ) .or.;
               ( ::oMateriasPrimas:cGrpFam >= ::oGrupoGFamilia:Cargo:Desde .and. ::oMateriasPrimas:cGrpFam <= ::oGrupoGFamilia:Cargo:Hasta ) ) .and.;
            (  ( ::oGrupoTArticulo:Cargo:Desde == Space( __LENTIPOSARTICULOS__ ) .and. ::oGrupoTArticulo:Cargo:Hasta == Replicate( "Z", __LENTIPOSARTICULOS__ ) ) .or.;
               ( ::oMateriasPrimas:cCodTip >= ::oGrupoTArticulo:Cargo:Desde .and. ::oMateriasPrimas:cCodTip <= ::oGrupoTArticulo:Cargo:Hasta ) )

            lValid := .t.

         end if

         ::oMateriasPrimas:Skip()

      end while

   end if 

RETURN ( lValid )

//---------------------------------------------------------------------------//

METHOD lValidOperario()

   local lValid := .f.

   if ::oGrupoOperario:Cargo:Desde == Space( __LENOPERARIOS__ ) .and. ::oGrupoOperario:Cargo:Hasta == Replicate( "Z", __LENOPERARIOS__ )
      RETURN .t.
   end if 

   if ::oPersonal:Seek( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd )
      while ( ::oPersonal:cSerOrd + Str( ::oPersonal:nNumOrd, 9 ) + ::oPersonal:cSufOrd ) == ( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd ) .and. ;
         !::oPersonal:Eof()
         if ::oPersonal:cCodTra >= ::oGrupoOperario:Cargo:Desde .and. ::oPersonal:cCodTra <= ::oGrupoOperario:Cargo:Hasta
            lValid := .t.
         end if 
         ::oPersonal:Skip()
      end while
   end if 

RETURN ( lValid )

//---------------------------------------------------------------------------//

METHOD lValidMaquinaria

   local lValid := .f.

   if ::oGrupoMaquina:Cargo:Desde == Space( __LENMAQUINAS__ ) .and. ::oGrupoMaquina:Cargo:Hasta == Replicate( "Z", __LENMAQUINAS__ )
      RETURN .t.
   end if 

   if ::oMaquinasParte:Seek( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd )
      while ( ::oMaquinasParte:cSerOrd + Str( ::oMaquinasParte:nNumOrd,9 ) + ::oMaquinasParte:cSufOrd ) == ( ::oParteProduccion:cSerOrd + Str( ::oParteProduccion:nNumOrd, 9 ) + ::oParteProduccion:cSufOrd ) .and.;
         !::oMaquinasParte:Eof()
         if ::oMaquinasParte:cCodMaq >= ::oGrupoMaquina:Cargo:Desde .and. ::oMaquinasParte:cCodMaq <= ::oGrupoMaquina:Cargo:Hasta
            lValid := .t.
         end if 
         ::oMaquinasParte:Skip()
      end while
   end if 

RETURN ( lValid )

//---------------------------------------------------------------------------//

METHOD AddParteProducccion() CLASS TFastProduccion
   local sTot
   local oError
   local oBlock
      
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oParteProduccion:OrdSetFocus( "dFecOrd" )
   
   // filtros para la cabecera------------------------------------------------
   
      ::cExpresionHeader          := 'dFecFin >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      ::cExpresionHeader          += ' .and. cSerOrd >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. cSerOrd <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'
      
      ::setFilterOperationId()
      
      ::setFilterSectionId()

   // Procesando partes de producción-----------------------------------------
   
      ::oMtrInf:cText   := "Procesando partes de producción"

      ::oParteProduccion:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oParteProduccion:cFile ), ::oParteProduccion:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oParteProduccion:OrdKeyCount() )

      ::oParteProduccion:GoTop()
      while !::lBreak .and. !::oParteProduccion:Eof()

         ::oDbf:Blank()

         ::oDbf:cSerDoc    := ::oParteProduccion:cSerOrd
         ::oDbf:cNumDoc    := Str( ::oParteProduccion:nNumOrd )
         ::oDbf:cSufDoc    := ::oParteProduccion:cSufOrd

         ::oDbf:nAnoDoc    := Year( ::oParteProduccion:dFecOrd )
         ::oDbf:nMesDoc    := Month( ::oParteProduccion:dFecOrd )
         ::oDbf:dFecIniDoc := ::oParteProduccion:dFecOrd
         ::oDbf:dFecFinDoc := ::oParteProduccion:dFecFin 

         ::oDbf:cCodOpe    := ::oParteProduccion:cCodOpe
         ::oDbf:cCodSec    := ::oParteProduccion:cCodSec
         ::oDbf:cCodAlmDes := ::oParteProduccion:cAlmOrd
         ::oDbf:cCodAlmOrg := ::oParteProduccion:cAlmOrg

         ::oDbf:nTotPrd    := TProduccion():nTotalProducido( ::oParteProduccion:cSerOrd + Str(::oParteProduccion:nNumOrd ) + ::oParteProduccion:cSufOrd, ::oMaterialProducido )
         ::oDbf:nUndPrd    := TProduccion():nTotalUnidadesProducido( ::oParteProduccion:cSerOrd + Str(::oParteProduccion:nNumOrd ) + ::oParteProduccion:cSufOrd, ::oMaterialProducido )

         ::oDbf:nTotMat    := TProduccion():nTotalMaterial( ::oParteProduccion:cSerOrd + Str(::oParteProduccion:nNumOrd ) + ::oParteProduccion:cSufOrd, ::oMateriasPrimas )
         ::oDbf:nTotPer    := TProduccion():nTotalPersonal( ::oParteProduccion:cSerOrd + Str(::oParteProduccion:nNumOrd ) + ::oParteProduccion:cSufOrd, ::oPersonal, ::oHorasPersonal )
         ::oDbf:nTotMaq    := TProduccion():nTotalMaquina( ::oParteProduccion:cSerOrd + Str(::oParteProduccion:nNumOrd ) + ::oParteProduccion:cSufOrd, ::oMaquinasParte )

         /*
         Añadimos un nuevo registro--------------------------------------------
         */

         if ::lValidRegister()
            ::oDbf:Insert()
         else
            ::oDbf:Cancel()
         end if

         ::oParteProduccion:Skip()

         ::oMtrInf:AutoInc()

      end while

      ::oParteProduccion:IdxDelete( cCurUsr(), GetFileNoExt( ::oParteProduccion:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir partes de producción" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::oMtrInf:SetTotal( ::oDbf:OrdKeyCount() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS TFastProduccion

   ::CreateTreeImageList()

   ::BuildTree()

 RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildTree( oTree, lLoadFile ) CLASS TFastProduccion

   local aReports

   DEFAULT oTree     := ::oTreeReporting
   DEFAULT lLoadFile := .t.

   aReports          := {  {  "Title" => "Partes de producción", "Image" => 14, "Type" => "Partes de producción", "Directory" => "Producción\Partes de producción", "File" => "Partes de producción.fr3"  } }

   ::BuildNode( aReports, oTree, lLoadFile )

   //oTree:ExpandAll()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DataReport( oFr ) CLASS TFastProduccion

   /*
   Zona de detalle-------------------------------------------------------------
   */

   ::oFastReport:SetWorkArea(       "Informe",                                ::oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Informe",                                cObjectsToReport( ::oDbf ) )

   /*
   Zona de datos---------------------------------------------------------------
   */

   ::oFastReport:SetWorkArea(       "Empresa",                                ::oDbfEmp:nArea )
   ::oFastReport:SetFieldAliases(   "Empresa",                                cItemsToReport( aItmEmp() ) )

   ::oFastReport:SetWorkArea(       "Operación",                              ::oOperacion:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Operación",                              cObjectsToReport( TOperacion():DefineFiles()  )  )

   ::oFastReport:SetWorkArea(       "Tipo operación",                         ::oTipOpera:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Tipo operación",                         cObjectsToReport( TTipOpera():DefineFiles()  )  )

   ::oFastReport:SetWorkArea(       "Sección",                                ::oSeccion:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Sección",                                cObjectsToReport( TSeccion():DefineFiles()  )  )

   ::oFastReport:SetWorkArea(       "Lineas de material producido",           ::oMaterialProducido:nArea )
   ::oFastReport:SetFieldAliases(   "Lineas de material producido",           cObjectsToReport( TDetProduccion():DefineFiles()  ) )

   ::oFastReport:SetWorkArea(       "Lineas de materias primas",              ::oMateriasPrimas:nArea )
   ::oFastReport:SetFieldAliases(   "Lineas de materias primas",              cObjectsToReport( TDetMaterial():DefineFiles()  ) )

   ::oFastReport:SetWorkArea(       "Lineas de personal",                     ::oPersonal:nArea )
   ::oFastReport:SetFieldAliases(   "Lineas de personal",                     cObjectsToReport( TDetPersonal():DefineFiles() ) )

   ::oFastReport:SetWorkArea(       "Lineas de horas de personal",            ::oHorasPersonal:nArea )
   ::oFastReport:SetFieldAliases(   "Lineas de horas de personal",            cObjectsToReport( TDetHorasPersonal():DefineFiles()  ) )

   ::oFastReport:SetWorkArea(       "Lineas de maquinaria",                   ::oMaquinasParte:nArea )
   ::oFastReport:SetFieldAliases(   "Lineas de maquinaria",                   cObjectsToReport( TDetMaquina():DefineFiles()  ) )

   ::oFastReport:SetWorkArea(       "Operarios.Lineas de personal",           ::oOperario:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Operarios.Lineas de personal",           cObjectsToReport( TOperarios():DefineFiles() ) )

   ::oFastReport:SetWorkArea(       "Operarios.Lineas de horas de personal",  ::oOperario:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Operarios.Lineas de horas de personal",  cObjectsToReport( TOperarios():DefineFiles() ) )

   ::oFastReport:SetWorkArea(       "Articulos.Material producido",           ::oDbfArt:nArea )
   ::oFastReport:SetFieldAliases(   "Articulos.Material producido",           cItemsToReport( aItmArt() ) )

   ::oFastReport:SetWorkArea(       "Articulos.Materias primas",              ::oDbfArticuloMateriaPrima:nArea )
   ::oFastReport:SetFieldAliases(   "Articulos.Materias primas",              cItemsToReport( aItmArt() ) )

   ::oFastReport:SetWorkArea(       "Almacen",                                ::oDbfAlm:nArea )
   ::oFastReport:SetFieldAliases(   "Almacen",                                cItemsToReport( aItmAlm()  )  )

   ::oFastReport:SetWorkArea(       "Maquinaria",                             ::oMaquina:oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Maquinaria",                             cObjectsToReport( TMaquina():DefineFiles()  )  )
  
   /*
   Relaciones------------------------------------------------------------------
   */

   ::oFastReport:SetMasterDetail(   "Informe",                       "Empresa",                                {|| cCodEmp() } )
   ::oFastReport:SetMasterDetail(   "Informe",                       "Operación",                              {|| ::oDbf:cCodOpe } )
   ::oFastReport:SetMasterDetail(   "Informe",                       "Seccion",                                {|| ::oDbf:cCodSec } )
   ::oFastReport:SetMasterDetail(   "Informe",                       "Lineas de material producido",           {|| ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc } )
   ::oFastReport:SetMasterDetail(   "Informe",                       "Lineas de materias primas",              {|| ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc } )
   ::oFastReport:SetMasterDetail(   "Informe",                       "Lineas de personal",                     {|| ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc } )
   ::oFastReport:SetMasterDetail(   "Informe",                       "Lineas de horas de personal",            {|| ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc } )
   ::oFastReport:SetMasterDetail(   "Informe",                       "Lineas de costo de maquinaria",          {|| ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc } )

   ::oFastReport:SetMasterDetail(   "Operación",                     "Tipo operación",                         {|| ::oOperacion:oDbf:cTipOpe } )

   ::oFastReport:SetMasterDetail(   "Lineas de material producido",  "Articulos.Material producido",           {|| ::oMaterialProducido:cCodArt } )
   ::oFastReport:SetMasterDetail(   "Lineas de materias primas",     "Articulos.Materias primas",              {|| ::oMateriasPrimas:cCodArt } )

   ::oFastReport:SetMasterDetail(   "Lineas de personal",            "Operarios.Lineas de personal",           {|| ::oPersonal:cCodTra } )
   ::oFastReport:SetMasterDetail(   "Lineas de horas de personal",   "Operarios.Lineas de horas de personal",  {|| ::oHorasPersonal:cCodTra } )
   
   ::oFastReport:SetMasterDetail(   "Lineas de maquinaria",          "Maquinaria",                             {|| ::oMaquinasParte:cCodMaq } )

   ::oFastReport:SetResyncPair(     "Informe",                       "Empresa" )
   ::oFastReport:SetResyncPair(     "Informe",                       "Operación" )
   ::oFastReport:SetResyncPair(     "Informe",                       "Seccion" )
   ::oFastReport:SetResyncPair(     "Informe",                       "Lineas de material producido" )
   ::oFastReport:SetResyncPair(     "Informe",                       "Lineas de materias primas" )
   ::oFastReport:SetResyncPair(     "Informe",                       "Lineas de personal" )
   ::oFastReport:SetResyncPair(     "Informe",                       "Lineas de costo de maquinaria" )

   ::oFastReport:SetResyncPair(     "Operación",                     "Tipo operación" )

   ::oFastReport:SetResyncPair(     "Lineas de material producido",  "Articulos.Material producido" )
   ::oFastReport:SetResyncPair(     "Lineas de materias primas",     "Articulos.Materias primas" )

   ::oFastReport:SetResyncPair(     "Lineas de personal",            "Operarios.Lineas de personal" )
   ::oFastReport:SetResyncPair(     "Lineas de horas de personal",   "Operarios.Lineas de horas de personal" )

   ::oFastReport:SetResyncPair(     "Lineas de maquinaria",          "Maquinaria" )

   //--------------------------------------------------------------------------

   ::AddVariable()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariable() CLASS TFastProduccion 

   /*
   Tablas en funcion del tipo de informe---------------------------------------
   */
   // al tener solo un tipo de de informe no necesitamos el case
   
   ::AddVariableLineasParteProduccion()

Return ( ::Super:AddVariable() )

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TFastProduccion

   ::putFilter()

   ::oDbf:Zap()

   /*
   Recorremos los partes de produccion-----------------------------------------
   */

   ::AddParteProducccion()

   ::oDbf:SetFilter( ::oFilter:cExpresionFilter )

   ::oDbf:GoTop()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD getFilterMaterialProducido() CLASS TFastProduccion

   local cExpresionFilter  := ""

   if ::oGrupoArticulo:Cargo:Desde != Space( __LENARTICULOS__ ) .or. ::oGrupoArticulo:Cargo:Hasta != Replicate( "Z", __LENARTICULOS__ )
   
      cExpresionFilter     += "Field->cCodArt >= '" + AllTrim( ::oGrupoArticulo:Cargo:Desde ) + "' .and. Field->cCodArt <= '" + AllTrim( ::oGrupoArticulo:Cargo:Hasta ) + "'"
   
   end if

   if ::oGrupoTemporada:Cargo:Desde != Space( __LENTEMPORADAS__ ) .or. ::oGrupoTemporada:Cargo:Hasta != Replicate( "Z", __LENTEMPORADAS__ )
      
      if !Empty( cExpresionFilter )
         cExpresionFilter  += " .and. "
      end if

      cExpresionFilter     += "Field->cCodTmp >= '" + AllTrim( ::oGrupoTemporada:Cargo:Desde ) + "' .and. Field->cCodTmp <= '" + AllTrim( ::oGrupoTemporada:Cargo:Hasta ) + "'"

   end if

   if ::oGrupoFamilia:Cargo:Desde != Space( __LENFAMILIAS__ ) .or. ::oGrupoFamilia:Cargo:Hasta != Replicate( "Z", __LENFAMILIAS__ )
      
      if !Empty( cExpresionFilter )
         cExpresionFilter  += " .and. "
      end if

      cExpresionFilter     += "Field->cCodFam >= '" + AllTrim( ::oGrupoFamilia:Cargo:Desde ) + "' .and. Field->cCodFam <= '" + AllTrim( ::oGrupoFamilia:Cargo:Hasta ) + "'"

   end if

   if ::oGrupoGFamilia:Cargo:Desde != Space( __LENGRUPOSFAMILIAS__ ) .or. ::oGrupoGFamilia:Cargo:Hasta != Replicate( "Z", __LENGRUPOSFAMILIAS__ )
      
      if !Empty( cExpresionFilter )
         cExpresionFilter  += " .and. "
      end if

      cExpresionFilter     += "Field->cGrpFam >= '" + AllTrim( ::oGrupoGFamilia:Cargo:Desde ) + "' .and. Field->cGrpFam <= '" + AllTrim( ::oGrupoGFamilia:Cargo:Hasta ) + "'"

   end if

   if ::oGrupoTArticulo:Cargo:Desde != Space( __LENTIPOSARTICULOS__ ) .or. ::oGrupoTArticulo:Cargo:Hasta != Replicate( "Z", __LENTIPOSARTICULOS__ )
      
      if !Empty( cExpresionFilter )
         cExpresionFilter  += " .and. "
      end if

      cExpresionFilter     += "Field->cCodTip >= '" + AllTrim( ::oGrupoTArticulo:Cargo:Desde ) + "' .and. Field->cCodTip <= '" + AllTrim( ::oGrupoTArticulo:Cargo:Hasta ) + "'"

   end if

Return ( cExpresionFilter )

//---------------------------------------------------------------------------//

METHOD getFilterMateriaPrima() CLASS TFastProduccion

   local cExpresionFilter  := ""

   if ::oGrupoMateriaPrima:Cargo:Desde != Space( __LENARTICULOS__ ) .or. ::oGrupoMateriaPrima:Cargo:Hasta != Replicate( "Z", __LENARTICULOS__ )
      cExpresionFilter     += "Field->cCodArt >= '" + AllTrim( ::oGrupoMateriaPrima:Cargo:Desde ) + "' .and. Field->cCodArt <= '" + AllTrim( ::oGrupoMateriaPrima:Cargo:Hasta ) + "' "
   end if

   if ::oGrupoTemporada:Cargo:Desde != Space( __LENTEMPORADAS__ ) .or. ::oGrupoTemporada:Cargo:Hasta != Replicate( "Z", __LENTEMPORADAS__ )
      
      if !Empty( cExpresionFilter )
         cExpresionFilter  += " .and. "
      end if

      cExpresionFilter     += "Field->cCodTmp >= '" + AllTrim( ::oGrupoTemporada:Cargo:Desde ) + "' .and. Field->cCodTmp <= '" + AllTrim( ::oGrupoTemporada:Cargo:Hasta ) + "'"

   end if

   if ::oGrupoFamilia:Cargo:Desde != Space( __LENFAMILIAS__ ) .or. ::oGrupoFamilia:Cargo:Hasta != Replicate( "Z", __LENFAMILIAS__ )
      
      if !Empty( cExpresionFilter )
         cExpresionFilter  += " .and. "
      end if

      cExpresionFilter     += "Field->cCodFam >= '" + AllTrim( ::oGrupoFamilia:Cargo:Desde ) + "' .and. Field->cCodFam <= '" + AllTrim( ::oGrupoFamilia:Cargo:Hasta ) + "'"

   end if

   if ::oGrupoGFamilia:Cargo:Desde != Space( __LENGRUPOSFAMILIAS__ ) .or. ::oGrupoGFamilia:Cargo:Hasta != Replicate( "Z", __LENGRUPOSFAMILIAS__ )
      
      if !Empty( cExpresionFilter )
         cExpresionFilter  += " .and. "
      end if

      cExpresionFilter     += "Field->cGrpFam >= '" + AllTrim( ::oGrupoGFamilia:Cargo:Desde ) + "' .and. Field->cGrpFam <= '" + AllTrim( ::oGrupoGFamilia:Cargo:Hasta ) + "'"

   end if

   if ::oGrupoTArticulo:Cargo:Desde != Space( __LENTIPOSARTICULOS__ ) .or. ::oGrupoTArticulo:Cargo:Hasta != Replicate( "Z", __LENTIPOSARTICULOS__ )
      
      if !Empty( cExpresionFilter )
         cExpresionFilter  += " .and. "
      end if

      cExpresionFilter     += "Field->cCodTip >= '" + AllTrim( ::oGrupoTArticulo:Cargo:Desde ) + "' .and. Field->cCodTip <= '" + AllTrim( ::oGrupoTArticulo:Cargo:Hasta ) + "'"

   end if

Return ( cExpresionFilter )

//---------------------------------------------------------------------------//

METHOD putFilter() CLASS TFastProduccion

   ::clearFilter()

   ( ::oMaterialProducido:nArea )->( dbSetFilter( bChar2Block( ::getFilterMaterialProducido() ), ::getFilterMaterialProducido() ) )
   ( ::oMaterialProducido:nArea )->( dbGoTop() )

   ( ::oMateriasPrimas:nArea )->( dbSetFilter( bChar2Block( ::getFilterMateriaPrima() ), ::getFilterMateriaPrima() ) )
   ( ::oMateriasPrimas:nArea )->( dbGoTop() )

Return .t.

//---------------------------------------------------------------------------//

METHOD clearFilter() CLASS TFastProduccion

   ( ::oMaterialProducido:nArea )->( dbClearFilter() )

   ( ::oMateriasPrimas:nArea )->( dbClearFilter() )

Return .t.

//---------------------------------------------------------------------------//

METHOD getPrecioTarifa( cCodTar, cCodArt ) CLASS TFastProduccion

   local nRec
   local nOrdAnt
   local nPrecio  := 0

   nRec           := ::oTarPreL:Recno()
   nOrdAnt        := ::oTarPreL:OrdSetFocus( "cCodArt" )

   if ::oTarPreL:Seek( cCodTar + cCodArt )
      nPrecio     := ::oTarPreL:nPrcTar1
   end if

   ::oTarPreL:OrdSetFocus( nOrdAnt )
   ::oTarPreL:GoTo( nRec )

Return ( nPrecio )

//---------------------------------------------------------------------------//