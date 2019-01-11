#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDetAlq FROM TNewInfGen

   DATA  oAlqCliT    AS OBJECT
   DATA  oAlqCliL    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  lDocImpCero AS LOGIC INIT .f.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAlm",  "C", 16, 0, {|| "@!" },  "Cod. almacén",      .f., "Cod. almacén",        5, .f. )
   ::AddField( "cNomAlm",  "C", 50, 0, {|| "@!" },  "Almacém",           .f., "Nombre almacén",     40, .f. )
   ::AddField( "cCodFpg",  "C",  2, 0, {|| "@!" },  "Cod. pago",         .f., "Pgo.",                5, .f. )
   ::AddField( "cNomFpg",  "C", 40, 0, {|| "@!" },  "Forma de pago",     .f., "Formas de pago",     40, .f. )
   ::AddField( "cCodAge",  "C",  3, 0, {|| "@!" },  "Cod. agente",       .f., "Código agente",       5, .f. )
   ::AddField( "cNomAge",  "C", 15, 0, {|| "@!" },  "Nom. agente",       .f., "Nombre agente",      40, .f. )
   ::AddField( "cApeAge",  "C", 30, 0, {|| "@!" },  "Ape. agente",       .f., "Apellidos agente",   40, .f. )
   ::AddField( "cCodUsr",  "C",  3, 0, {|| "@!" },  "Cod. usuario",      .f., "Código usuario",      5, .f. )
   ::AddField( "cNomUsr",  "C", 30, 0, {|| "@!" },  "Nom. usuario",      .f., "Nombre usuario",     40, .f. )
   ::AddField( "cCodCaj",  "C",  3, 0, {|| "@!" },  "Cod. caja",         .f., "Código caja",         5, .f. )
   ::AddField( "cNomCaj",  "C", 30, 0, {|| "@!" },  "Nom. caja",         .f., "Nombre caja",        40, .f. )
   ::AddField( "cCodTrans","C",  3, 0, {|| "@!" },  "Cod. trans.",       .f., "C. transportista",    5, .f. )
   ::AddField( "cNomTrans","C", 50, 0, {|| "@!" },  "Nom. trans.",       .f., "Transportista",      40, .f. )
   ::AddField( "cCodGCli", "C",  4, 0, {|| "@!" },  "G. cliente",        .f., "Grupo cliente",       5, .f. )
   ::AddField( "cNomGCli", "C", 30, 0, {|| "@!" },  "G. cliente",        .f., "Grupo cliente",      40, .f. )
   ::AddField( "cCodObra", "C", 10, 0, {|| "@!" },  "Cod. dirección",         .f., "Código dirección",         5, .f. )
   ::AddField( "cNomObra", "C", 50, 0, {|| "@!" },  "Nom. dirección",         .f., "Nombre dirección",        40, .f. )
   ::FldDiario()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlqCliT PATH ( cPatEmp() ) FILE "ALQCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ALQCLIT.CDX"

   DATABASE NEW ::oAlqCliL PATH ( cPatEmp() ) FILE "ALQCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALQCLIL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

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

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oAlqCliT := nil
   ::oAlqCliL := nil
   ::oDbfIva := nil

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

   /*
   Condiciones-----------------------------------------------------------------
   */

   ::lDocImporteCero := .t.

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

   local aTotTmp  := {}
   local cExpHead := ""

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

   if !::oGrupoAlmacen:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Almacén", 13 ) + ": " + AllTrim( ::oGrupoAlmacen:Cargo:Desde ) + " > " + AllTrim( ::oGrupoAlmacen:Cargo:Hasta ) } )
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

   aAdd( ::aHeader, {|| Padr( "Estado", 13 ) + ": " + ::oEstadoUno:aItems[ ::oEstadoUno:nAt ] } )

   ::oAlqCliT:OrdSetFocus( "dFecAlq" )

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
   Tomamos las condiciones-----------------------------------------------------
   */

   // ::lDocImpCero     := TvGetCheckState( ::oTreeCondiciones:hWnd, ::oDocImporteCero:hItem )
   ::lDocImpCero     := ::oTreeCondiciones:GetCheck( ::oDocImporteCero )

   /*
   Recorremos cabeceras y lineas, y informamos la ::oDbf-----------------------
   */

   ::oAlqCliT:GoTop()

   while !::lBreak .and. !::oAlqCliT:Eof()

      if lChkSer( ::oAlqCliT:cSerAlq, ::aSer )

         aTotTmp           := aTotAlqCli( ::oAlqCliT:cSerAlq + Str( ::oAlqCliT:nNumAlq ) + ::oAlqCliT:cSufAlq, ::oAlqCliT:cAlias, ::oAlqCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf  )

         if !( ::lDocImpCero .and. aTotTmp[1] == 0 )

            ::oDbf:Append()

            ::oDbf:cCodAlm    := ::oAlqCliT:cCodAlm
            ::oDbf:cNomAlm    := oRetFld( ::oAlqCliT:cCodAlm, ::oDbfAlm )
            ::oDbf:cCodFpg    := ::oAlqCliT:cCodPago
            ::oDbf:cNomFpg    := oRetFld( ::oAlqCliT:cCodPago, ::oDbfFpg )
            ::oDbf:cCodAge    := ::oAlqCliT:cCodAge
            ::oDbf:cNomAge    := oRetFld( ::oAlqCliT:cCodAge, ::oDbfAge, "CNBRAGE" )
            ::oDbf:cApeAge    := oRetFld( ::oAlqCliT:cCodAge, ::oDbfAge, "CAPEAGE" )
            ::oDbf:cCodUsr    := ::oAlqCliT:cCodUsr
            ::oDbf:cNomUsr    := oRetFld( ::oAlqCliT:cCodUsr, ::oDbfUsr )
            ::oDbf:cCodCaj    := ::oAlqCliT:cCodCaj
            ::oDbf:cNomCaj    := oRetFld( ::oAlqCliT:cCodCaj, ::oDbfCaj )
            ::oDbf:cCodTrans  := ::oAlqCliT:cCodTrn
            ::oDbf:cNomTrans  := oRetFld( ::oAlqCliT:cCodTrn, ::oDbfTrn:oDbf )
            ::oDbf:cCodGCli   := ::oAlqCliT:cCodGrp
            ::oDbf:cNomGCli   := oRetFld( ::oAlqCliT:cCodGrp, ::oGrpCli:oDbf )
            ::oDbf:cCodObra   := ::oAlqCliT:cCodObr
            ::oDbf:cNomObra   := oRetFld( ::oAlqCliT:cCodObr, ::oDbfObr )
            ::oDbf:cDocMov    := ::oAlqCliT:cSerAlq + "/" + AllTrim( Str( ::oAlqCliT:nNumAlq ) ) + "/" + ::oAlqCliT:cSufAlq
            ::oDbf:dFecMov    := ::oAlqCliT:dFecAlq
            ::AddCliente( ::oAlqCliT:cCodCli, ::oAlqCliT )
            ::oDbf:nTotNet    := aTotTmp[1]
            ::oDbf:nTotPnt    := aTotTmp[6]
            ::oDbf:nTotTrn    := aTotTmp[5]
            ::oDbf:nTotIva    := aTotTmp[2]
            ::oDbf:nTotReq    := aTotTmp[3]
            ::oDbf:nTotDoc    := aTotTmp[4]
            ::oDbf:cTipVen    := "Alquiler"

            ::oDbf:Save()

         end if

      end if

      ::oAlqCliT:Skip()

      ::oMtrInf:AutoInc( ::oAlqCliT:OrdKeyNo() )

   end while

   /*
   Destruimos los filtros------------------------------------------------------
   */

   ::oAlqCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlqCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oAlqCliT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//