#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDetLinAlq FROM TNewInfGen

   DATA  oAlqCliT    AS OBJECT
   DATA  oAlqCliL    AS OBJECT
   DATA  lLinImpCero AS LOGIC INIT .f.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodFpg", "C",  2, 0, {|| "@!" },        "Cod. pago",                  .f., "Pgo.",                         5, .f. )
   ::AddField( "cNomFpg", "C", 40, 0, {|| "@!" },        "Forma de pago",              .f., "Formas de pago",              40, .f. )
   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },        "Cod. agente",                .f., "Código agente",                5, .f. )
   ::AddField( "cNomAge", "C", 15, 0, {|| "@!" },        "Nom. agente",                .f., "Nombre agente",               40, .f. )
   ::AddField( "cApeAge", "C", 30, 0, {|| "@!" },        "Ape. agente",                .f., "Apellidos agente",            40, .f. )
   ::AddField( "cCodUsr", "C",  3, 0, {|| "@!" },        "Cod. usuario",               .f., "Código usuario",               5, .f. )
   ::AddField( "cNomUsr", "C", 30, 0, {|| "@!" },        "Nom. usuario",               .f., "Nombre usuario",              40, .f. )
   ::AddField( "cCodCaj", "C",  3, 0, {|| "@!" },        "Cod. caja",                  .f., "Código caja",                  5, .f. )
   ::AddField( "cNomCaj", "C", 30, 0, {|| "@!" },        "Nom. caja",                  .f., "Nombre caja",                 40, .f. )
   ::AddField( "cCodTrans","C", 3, 0, {|| "@!" },        "Cod. trans.",                .f., "C. transportista",             5, .f. )
   ::AddField( "cNomTrans","C",50, 0, {|| "@!" },        "Nom. trans.",                .f., "Transportista",               40, .f. )
   ::AddField( "cCodGCli","C",  4, 0, {|| "@!" },        "G. cliente",                 .f., "Grupo cliente",                5, .f. )
   ::AddField( "cNomGCli","C", 30, 0, {|| "@!" },        "G. cliente",                 .f., "Grupo cliente",               40, .f. )
   ::AddField( "cCodObra","C", 10, 0, {|| "@!" },        "Cod. dirección",                  .f., "Código dirección",                  5, .f. )
   ::AddField( "cNomObra","C", 50, 0, {|| "@!" },        "Nom. dirección",                  .f., "Nombre dirección",                 40, .f. )
   ::FldCliente()
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },        "Cod. fam.",                  .f., "Cod. familia",                 3, .f. )
   ::AddField( "cNomFam", "C", 40, 0, {|| "@!" },        "Familia",                    .f., "Nombre familia",              15, .f. )
   ::AddField( "cCodGFam","C",  3, 0, {|| "@!" },        "Grp. fam.",                  .f., "Cod. grp. familia",            3, .f. )
   ::AddField( "cNomGFam","C", 30, 0, {|| "@!" },        "Grupo fam.",                 .f., "Nombre grp. familia",         15, .f. )
   ::AddField( "cCodTArt","C",  3, 0, {|| "@!" },        "Tip. art.",                  .f., "Cod. tip. artículo",           3, .f. )
   ::AddField( "cNomTArt","C", 35, 0, {|| "@!" },        "Tipo. art.",                 .f., "Nombre tip. artículo",        15, .f. )
   ::AddField( "cCodAlm", "C",  3, 0, {|| "@!" },        "Alm",                        .f., "Cod. almacén",                 3, .f. )
   ::AddField( "cNomAlm", "C", 50, 0, {|| "@!" },        "Almacém",                    .f., "Nombre almacén",              15, .f. )
   ::FldArticulo( .f., .f. )
   ::AddField( "nNumCaj", "N", 16, 6, {|| MasUnd() },    cNombreCajas(),               .f., cNombreCajas(),                14, .t. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },    cNombreUnidades(),            .f., cNombreUnidades(),             14, .t. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },    "Tot. " + cNombreUnidades(),  .t., "Total " + cNombreUnidades(),  14, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },   "Precio",                     .t., "Precio",                      12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicImp },   "Pnt. ver.",                  .f., "Punto verde",                 10, .f. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp },   "Portes",                     .f., "Portes",                      10, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },   "Base",                       .t., "Base",                        12, .t. )
   ::AddField( "nIvaTot", "N", 19, 6, {|| ::cPicOut },   cImp(),                     .t., cImp(),                      12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },   "Total",                      .t., "Total",                       12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },    "Tot. peso",                  .f., "Total peso",                  12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },   "Pre. Kg.",                   .f., "Precio kilo",                 12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },    "Tot. volumen",               .f., "Total volumen",               12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },   "Pre. vol.",                  .f., "Precio volumen",              12, .f. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },        "Doc.",                       .t., "Documento",                   14, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },        "Fecha",                      .t., "Fecha",                       10, .f. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlqCliT PATH ( cPatEmp() ) FILE "ALQCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ALQCLIT.CDX"

   DATABASE NEW ::oAlqCliL PATH ( cPatEmp() ) FILE "ALQCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALQCLIL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlqCliT ) .and. ::oAlqCliT:Used()
      ::oAlqCliT:End()
   end if
   if !Empty( ::oAlqCliL ) .and. ::oAlqCliL:Used()
      ::oAlqCliL:End()
   end if

   ::oAlqCliT := nil
   ::oAlqCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   ::lNewInforme        := .t.

   if !::NewResource()
      return .f.
   end if

   /*
   Estado del documento--------------------------------------------------------
   */

   ::lDefEstadoUno      := .t.
   ::oEstadoUno:aItems  := { "Alquileres no facturados", "Alquileres facturados", "Todos los alquileres" }
   ::cEstadoUno         := "Todos los alquileres"

   /*
   Agregamos los desde - hasta-------------------------------------------------
   */

   if !::lGrupoGrupoCliente( .f. )
      return .f.
   end if

   if !::lGrupoCliente( .f. )
      return .f.
   end if

   if !::lGrupoObra( .f. )
      return .f.
   end if

   if !::lGrupoAgente( .f. )
      return .f.
   end if

   if !::lGrupoAlmacen( .f. )
      return .f.
   end if

   if !::lGrupoFPago( .f. )
      return .f.
   end if

   if !::lGrupoCaja( .f. )
      return .f.
   end if

   if !::lGrupoUsuario( .f. )
      return .f.
   end if

   if !::lGrupoTransportista( .f. )
      return .f.
   end if

   if !::lGrupoGFamilia( .f. )
      return .f.
   end if

   if !::lGrupoFamilia( .f. )
      return .f.
   end if

   if !::lGrupoTipoArticulo( .f. )
      return .f.
   end if

   if !::lGrupoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoAlmacen( .f. )
      return .f.
   end if

   /*
   Condiciones-----------------------------------------------------------------
   */

   ::lLinImporteCero := .t.

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oAlqCliT:Lastrec() )

   /*
   Cremos los filtros para el documento----------------------------------------
   */

   ::CreateFilter( aItmAlqCli(), ::oAlqCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Cabeceras del informe*/

   ::aHeader   := {  {|| Padr( "Fecha", 13 ) + ": " + Dtoc( Date() ) },;
                     {|| Padr( "Periodo", 13 ) + ": " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } }

   if !::oGrupoGCliente:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Grp. cliente", 13 ) + ": " + AllTrim( ::oGrupoGCliente:Cargo:Desde ) + " > " + AllTrim( ::oGrupoGCliente:Cargo:Hasta ) } )
   end if

   if !::oGrupoCliente:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Cliente", 13 ) + ": " + AllTrim( ::oGrupoCliente:Cargo:Desde ) + " > " + AllTrim( ::oGrupoCliente:Cargo:Hasta ) } )
   end if

   if ::oGrupoCliente:Cargo:Desde == ::oGrupoCliente:Cargo:Hasta .and. !::oGrupoObra:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Dirección", 13 ) + ": " + AllTrim( ::oGrupoObra:Cargo:Desde ) + " > " + AllTrim( ::oGrupoObra:Cargo:Hasta ) } )
   end if

   if !::oGrupoAgente:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Agente", 13 ) + ": " + AllTrim( ::oGrupoAgente:Cargo:Desde ) + " > " + AllTrim( ::oGrupoAgente:Cargo:Hasta ) } )
   end if

   if !::oGrupoFpago:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Forma de pago", 13 ) + ": " + AllTrim( ::oGrupoFPago:Cargo:Desde ) + " > " + AllTrim( ::oGrupoFPago:Cargo:Hasta ) } )
   end if

   if !::oGrupoCaja:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Caja", 13 ) + ": " + AllTrim( ::oGrupoCaja:Cargo:Desde ) + " > " + AllTrim( ::oGrupoCaja:Cargo:Hasta ) } )
   end if

   if !::oGrupoUsuario:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Usuario", 13 ) + ": " + AllTrim( ::oGrupoUsuario:Cargo:Desde ) + " > " + AllTrim( ::oGrupoUsuario:Cargo:Hasta ) } )
   end if

   if !::oGrupoTransportista:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Transportista", 13 ) + ": " + AllTrim( ::oGrupoTransportista:Cargo:Desde ) + " > " + AllTrim( ::oGrupoTransportista:Cargo:Hasta ) } )
   end if

   if !::oGrupoGFamilia:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Grp. familia", 13 ) + ": " + AllTrim( ::oGrupoGFamilia:Cargo:Desde ) + " > " + AllTrim( ::oGrupoGFamilia:Cargo:Hasta ) } )
   end if

   if !::oGrupoFamilia:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Familia", 13 ) + ": " + AllTrim( ::oGrupoFamilia:Cargo:Desde ) + " > " + AllTrim( ::oGrupoFamilia:Cargo:Hasta ) } )
   end if

   if !::oGrupoTArticulo:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Tip. artículo", 13 ) + ": " + AllTrim( ::oGrupoTArticulo:Cargo:Desde ) + " > " + AllTrim( ::oGrupoTArticulo:Cargo:Hasta ) } )
   end if

   if !::oGrupoArticulo:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Artículo", 13 ) + ": " + AllTrim( ::oGrupoArticulo:Cargo:Desde ) + " > " + AllTrim( ::oGrupoArticulo:Cargo:Hasta ) } )
   end if

   if !::oGrupoAlmacen:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Almacén", 13 ) + ": " + AllTrim( ::oGrupoAlmacen:Cargo:Desde ) + " > " + AllTrim( ::oGrupoAlmacen:Cargo:Hasta ) } )
   end if

   aAdd( ::aHeader, {|| Padr( "Estado", 13 ) + ": " + ::oEstadoUno:aItems[ ::oEstadoUno:nAt ] } )

   ::oAlqCliT:OrdSetFocus( "dFecAlq" )
   ::oAlqCliL:OrdSetFocus( "nNumAlq" )

   /*
   Filtro de la cabecera-------------------------------------------------------
   */

   do case
      case ::oEstadoUno:nAt == 1
         cExpHead    := 'nFacturado < 3 .and. dFecAlq >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlq <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstadoUno:nAt == 2
         cExpHead    := 'nFacturado == 3 .and. dFecAlq >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlq <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstadoUno:nAt == 3
         cExpHead    := 'dFecAlq >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlq <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::oGrupoGCliente:Cargo:Todos
      cExpHead       += ' .and. cCodGrp >= "' + Rtrim( ::oGrupoGCliente:Cargo:Desde ) + '" .and. cCodGrp <= "' + Rtrim( ::oGrupoGCliente:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoCliente:Cargo:Todos
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde ) + '" .and. cCodCli <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoObra:Cargo:Todos
      cExpHead       += ' .and. cCodObr >= "' + Rtrim( ::oGrupoObra:Cargo:Desde ) + '" .and. cCodObr <= "' + Rtrim( ::oGrupoObra:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoAgente:Cargo:Todos
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::oGrupoAgente:Cargo:Desde ) + '" .and. cCodAge <= "' + Rtrim( ::oGrupoAgente:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoAlmacen:Cargo:Todos
      cExpHead       += ' .and. cCodAlm >= "' + Rtrim( ::oGrupoAlmacen:Cargo:Desde ) + '" .and. cCodAlm <= "' + Rtrim( ::oGrupoAlmacen:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoFpago:Cargo:Todos
      cExpHead       += ' .and. cCodPago >= "' + Rtrim( ::oGrupoFPago:Cargo:Desde ) + '" .and. cCodPago <= "' + Rtrim( ::oGrupoFPago:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoCaja:Cargo:Todos
      cExpHead       += ' .and. cCodCaj >= "' + Rtrim( ::oGrupoCaja:Cargo:Desde ) + '" .and. cCodCaj <= "' + Rtrim( ::oGrupoCaja:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoUsuario:Cargo:Todos
      cExpHead       += ' .and. cCodUsr >= "' + Rtrim( ::oGrupoUsuario:Cargo:Desde ) + '" .and. cCodUsr <= "' + Rtrim( ::oGrupoUsuario:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoTransportista:Cargo:Todos
      cExpHead       += ' .and. cCodTrn >= "' + Rtrim( ::oGrupoTransportista:Cargo:Desde ) + '" .and. cCodTrn <= "' + Rtrim( ::oGrupoTransportista:Cargo:Hasta ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlqCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlqCliT:cFile ), ::oAlqCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlqCliT:OrdKeyCount() )

   /*
   Filtro de las lineas--------------------------------------------------------
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::oGrupoGFamilia:Cargo:Todos
      cExpLine       += ' .and. cGrpFam >= "' + ::oGrupoGFamilia:Cargo:Desde + '" .and. cGrpFam <= "' + ::oGrupoGFamilia:Cargo:Hasta + '"'
   end if

   if !::oGrupoFamilia:Cargo:Todos
      cExpLine       += ' .and. cCodFam >= "' + ::oGrupoFamilia:Cargo:Desde + '" .and. cCodFam <= "' + ::oGrupoFamilia:Cargo:Hasta + '"'
   end if

   if !::oGrupoTArticulo:Cargo:Todos
      cExpLine       += ' .and. cCodTip >= "' + ::oGrupoTArticulo:Cargo:Desde + '" .and. cCodTip <= "' + ::oGrupoTArticulo:Cargo:Hasta + '"'
   end if

   if !::oGrupoArticulo:Cargo:Todos
      cExpLine       += ' .and. cRef >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cRef <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
   end if

   if !::oGrupoAlmacen:Cargo:Todos
      cExpLine       += ' .and. cAlmLin >= "' + Rtrim( ::oGrupoAlmacen:Cargo:Desde ) + '" .and. cAlmLin <= "' + Rtrim( ::oGrupoAlmacen:Cargo:Hasta ) + '"'
   end if

   ::oAlqCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlqCliL:cFile ), ::oAlqCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   /*
   Tomamos las condiciones-----------------------------------------------------
   */

   //::lLinImpCero     := TvGetCheckState( ::oTreeCondiciones:hWnd, ::oLinImporteCero:hItem )
   
   ::lLinImpCero     := ::oTreeCondiciones:GetCheck( ::oLinImporteCero )

   /*
   Recorremos cabeceras y lineas, y informamos la ::oDbf-----------------------
   */

   ::oAlqCliT:GoTop()

   while !::lBreak .and. !::oAlqCliT:Eof()

      if lChkSer( ::oAlqCliT:cSerAlq, ::aSer )                                                                 .AND.;
         ::oAlqCliL:Seek( ::oAlqCliT:cSerAlq + Str( ::oAlqCliT:nNumAlq ) + ::oAlqCliT:cSufAlq )

         while ::oAlqCliT:cSerAlq + Str( ::oAlqCliT:nNumAlq ) + ::oAlqCliT:cSufAlq == ::oAlqCliL:cSerAlq + Str( ::oAlqCliL:nNumAlq ) + ::oAlqCliL:cSufAlq .AND. ! ::oAlqCliL:eof()

            if !( ::lLinImpCero .and. nImpLAlqCli( ::oAlqCliT:cAlias, ::oAlqCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

               ::oDbf:Append()

               ::oDbf:cCodFpg       := ::oAlqCliT:cCodPago
               ::oDbf:cNomFpg       := oRetFld( ::oAlqCliT:cCodPago, ::oDbfFpg )
               ::oDbf:cCodAge       := ::oAlqCliT:cCodAge
               ::oDbf:cNomAge       := oRetFld( ::oAlqCliT:cCodAge, ::oDbfAge, "CNBRAGE" )
               ::oDbf:cApeAge       := oRetFld( ::oAlqCliT:cCodAge, ::oDbfAge, "CAPEAGE" )
               ::oDbf:cCodUsr       := ::oAlqCliT:cCodUsr
               ::oDbf:cNomUsr       := oRetFld( ::oAlqCliT:cCodUsr, ::oDbfUsr )
               ::oDbf:cCodCaj       := ::oAlqCliT:cCodCaj
               ::oDbf:cNomCaj       := oRetFld( ::oAlqCliT:cCodCaj, ::oDbfCaj )
               ::oDbf:cCodTrans     := ::oAlqCliT:cCodTrn
               ::oDbf:cNomTrans     := oRetFld( ::oAlqCliT:cCodTrn, ::oDbfTrn:oDbf )
               ::oDbf:cCodGCli      := ::oAlqCliT:cCodGrp
               ::oDbf:cNomGCli      := oRetFld( ::oAlqCliT:cCodGrp, ::oGrpCli:oDbf )
               ::oDbf:cCodObra      := ::oAlqCliT:cCodObr
               ::oDbf:cNomObra      := oRetFld( ::oAlqCliT:cCodObr, ::oDbfObr )
               ::oDbf:cCodFam       := ::oAlqCliL:cCodFam
               ::oDbf:cNomFam       := oRetFld( ::oAlqCliL:cCodFam, ::oDbfFam )
               ::oDbf:cCodGFam      := ::oAlqCliL:cGrpFam
               ::oDbf:cNomGFam      := oRetFld( ::oAlqCliL:cGrpFam, ::oGruFam:oDbf )
               ::oDbf:cCodTArt      := ::oAlqCliL:cCodTip
               ::oDbf:cNomTArt      := oRetFld( ::oAlqCliL:cCodTip, ::oTipArt:oDbf )
               ::oDbf:cCodAlm       := ::oAlqCliL:cAlmLin
               ::oDbf:cNomAlm       := oRetFld( ::oAlqCliL:cAlmLin, ::oDbfAlm )
               ::AddCliente( ::oAlqCliT:cCodCli, ::oAlqCliT )
               ::AddArticulo( ::oAlqCliL:cRef, ::oDbfArt, ::oAlqCliL, .f. )
               ::oDbf:nNumCaj       := ::oAlqCliL:nCanEnt
               ::oDbf:nUniDad       := ::oAlqCliL:nUniCaja
               ::oDbf:nNumUni       := nTotNAlqCli( ::oAlqCliL )
               ::oDbf:nImpArt       := nTotUAlqCli( ::oAlqCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nPntVer       := nPntUAlqCli( ::oAlqCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTrn       := nTrnUAlqCli( ::oAlqCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTot       := nImpLAlqCli( ::oAlqCliT:cAlias, ::oAlqCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nIvaTot       := nIvaLAlqCli( ::oAlqCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot
               ::AcuPesVol( ::oAlqCliL:cRef, nTotNAlqCli( ::oAlqCliL ), ::oDbf:nImpTot, .f. )
               ::oDbf:cDocMov       := ::oAlqCliT:cSerAlq + "/" + AllTrim( Str( ::oAlqCliT:nNumAlq ) ) + "/" + ::oAlqCliT:cSufAlq
               ::oDbf:dFecMov       := ::oAlqCliT:dFecAlq

               ::oDbf:Save()

            end if

            ::oAlqCliL:Skip()

         end while

      end if

      ::oAlqCliT:Skip()

      ::oMtrInf:AutoInc( ::oAlqCliT:OrdKeyNo() )

   end while

   /*
   Destruimos los filtros------------------------------------------------------
   */

   ::oAlqCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlqCliT:cFile ) )

   ::oAlqCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlqCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oAlqCliT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//