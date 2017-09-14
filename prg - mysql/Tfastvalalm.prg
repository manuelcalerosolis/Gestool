#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"
#include "FastRepH.ch"

memvar oGrupoFabricanteDesde
memvar oGrupoFabricanteHasta
memvar oGrupoFabricanteTextDesde
memvar oGrupoFabricanteTextHasta

//---------------------------------------------------------------------------//

CLASS TFastValoracionAlmacen FROM TNewInfGen

   DATA  aInitGroup

   DATA  oBrwRango

   DATA  oOfficeBar

   DATA  nDias

   DATA  nUnidadesTiempo INIT 1
   DATA  oUnidadesTiempo
   DATA  cUnidadesTiempo INIT "Semana(s)"
   DATA  aUnidadesTiempo INIT { "Dia(s)", "Semana(s)", "Mes(es)", "Año(s)" }

   DATA  oColDesde
   DATA  oColHasta

   METHOD Create()

   METHOD Default()     VIRTUAL

   METHOD NewResource( cFldRes )

   METHOD lResource( cFld )

   METHOD InitDialog()

   METHOD Activate()

   METHOD Play( uParam )

   METHOD EditValueTextDesde()   INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:HelpDesde ) )
   METHOD EditValueTextHasta()   INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:HelpHasta ) )
   METHOD EditTextDesde()        INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:TextDesde ) )
   METHOD EditTextHasta()        INLINE ( Eval( ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:TextHasta ) )

   METHOD End()

   METHOD OpenData( cPath, lExclusive )

   METHOD CloseData()

   METHOD BrowseDblClick( lAllSelected )

   METHOD lGenerate()

   METHOD GenReport( nOption )

   Method SaveReport()

   Method cExpresionFilter()

   METHOD DataReport()

   Method AddVariable()

   METHOD CloseData()

   METHOD SyncAllDbf()

   METHOD DefineReport( cPath )

   METHOD FastReport( nDevice )

   Method DesignReport()

END CLASS

//----------------------------------------------------------------------------//

METHOD NewResource( cFldRes ) CLASS TFastValoracionAlmacen

   local n
   local o

   DEFAULT cFldRes   := "FastReportInfGen"

   /*
   Apertura de los fiche de configuración--------------------------------------
   */

   if !::OpenData()
      Return .f.
   end if

   /*
   Apertura del fichero temporal-----------------------------------------------
   */

   ::oDbf:Activate( .f., .f. )

   /*
   Montamos el array con los periodos para los informes------------------------
   */

   ::lCreaArrayPeriodos()

   /*
   Aplicamos los valores segun se han archivado--------------------------------
   */

   ::Default()

   ::lDefDivInf   := .f.
   ::lDefSerInf   := .f.

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG ::oDlg RESOURCE "FastReport" TITLE ::cSubTitle

   /*
   Fechas----------------------------------------------------------------------
   */

   if ::lDefFecInf
      ::oDefIniInf( 1110, ::oDlg )
      ::oDefFinInf( 1120, ::oDlg )
      ::lPeriodoInforme( 220, ::oDlg )
   end if

   /*
   Carga controles-------------------------------------------------------------
   */

   if !::lGrupoAlmacen( .t. )
      return .f.
   end if

   if !::lGrupoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoGFamilia( .t. )
      return .f.
   end if

   if !::lGrupoFamilia( .t. )
      return .f.
   end if

   if !::lGrupoTipoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoCategoria( .t. )
      return .f.
   end if

   if !::lGrupoTemporada( .t. )
      return .f.
   end if

   if !::lGrupoFabricante( .t. )
      return .f.
   end if

   /*
   Browse de los rangos----------------------------------------------------------
   */

   ::oBrwRango                      := IXBrowse():New( ::oDlg )

   ::oBrwRango:bClrSel              := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwRango:bClrSelFocus         := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwRango:SetArray( ::aInitGroup, , , .f. )

   ::oBrwRango:lHScroll             := .f.
   ::oBrwRango:lVScroll             := .f.
   ::oBrwRango:lRecordSelector      := .t.
   ::oBrwRango:lFastEdit            := .t.

   ::oBrwRango:nFreeze              := 1
   ::oBrwRango:nMarqueeStyle        := 3
   ::oBrwRango:nColSel              := 3

   ::oBrwRango:CreateFromResource( 310 )

   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bStrData      := {|| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Nombre }
      :bBmpData      := {|| ::oBrwRango:nArrayAt }
      :nWidth        := 90
      for each o in ::aInitGroup
         :AddResource( o:Cargo:cBitmap )
      next
   end with

   with object ( ::oBrwRango:AddCol() )
      :cHeader       := "Todos"
      :bStrData      := {|| "" }
      :bEditValue    := {|| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Todos }
      :nWidth        := 30
      :bLDClickData  := {|| ::BrowseDblClick() }
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oColDesde := ::oBrwRango:AddCol() )
      :cHeader       := "Desde"
      :bEditValue    := {|| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Desde }
      :bOnPostEdit   := {|o,x| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Desde := x }
      :bEditBlock    := {|| ::EditValueTextDesde() }
      :nEditType     := 5
      :nWidth        := 100
      :nBtnBmp       := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bEditValue    := {|| ::EditTextDesde() }
      :nEditType     := 0
      :nWidth        := 160
   end with

   with object ( ::oColHasta := ::oBrwRango:AddCol() )
      :cHeader       := "Hasta"
      :bEditValue    := {|| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Hasta }
      :bOnPostEdit   := {|o,x| ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Hasta := x }
      :bEditBlock    := {|| ::EditValueTextHasta() }
      :nEditType     := 5
      :nWidth        := 100
      :nBtnBmp       := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bEditValue    := {|| ::EditTextHasta() }
      :nEditType     := 0
      :nWidth        := 160
   end with

   /*
   Definimos el tree de condiciones--------------------------------------------
   */

   REDEFINE GROUP ::oGrupoCondiciones ID 131 OF ::oDlg TRANSPARENT

   /*
   Divisas---------------------------------------------------------------------
   */

   if ::lDefDivInf
      ::oDefDivInf( 1130, 1131, ::oDlg )
   end if

   /*
   Series----------------------------------------------------------------------
   */

   if ::lDefSerInf
      ::oDefSerInf( ::oDlg )
   end if

   /*
   Progreso--------------------------------------------------------------------
   */

   if ::lDefMetInf
      ::oDefMetInf( 1160, ::oDlg )
   end if

RETURN .t.

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastValoracionAlmacen

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   if !::NewResource()
      return .f.
   end if

   REDEFINE GET ::nUnidadesTiempo ;
      SPINNER  MIN 0 MAX 999 ;
      PICTURE  "@E 999" ;
      ID       320 ;
      OF       ::oDlg

   REDEFINE COMBOBOX ::oUnidadesTiempo ;
      VAR      ::cUnidadesTiempo ;
      ID       330 ;
      ITEMS    ::aUnidadesTiempo ;
      OF       ::oDlg

RETURN .t.

//---------------------------------------------------------------------------//

METHOD InitDialog() CLASS TFastValoracionAlmacen

   local oGrupo
   local oCarpeta

   ::oOfficeBar            := TDotNetBar():New( 0, 0, 1020, 115, ::oDlg, 1 )
   ::oOfficeBar:lPaintAll  := .f.
   ::oOfficeBar:lDisenio   := .f.

   ::oOfficeBar:SetStyle( 1 )

      oCarpeta             := TCarpeta():New( ::oOfficeBar, "Informe" )

      oGrupo               := TDotNetGroup():New( oCarpeta, 306, "Impresión", .f. )
                              TDotNetButton():New( 60, oGrupo, "gc_monitor_32",             "Visualizar",  1, {|| ::GenReport( IS_SCREEN ) }, , , .f., .f., .f. )
                              TDotNetButton():New( 60, oGrupo, "gc_printer2_32",            "Imprimir",    2, {|| ::GenReport( IS_PRINTER ) }, , , .f., .f., .f. )
                              TDotNetButton():New( 60, oGrupo, "gc_table_selection_row_32", "Excel",       3, {|| ::GenReport( IS_EXCEL ) }, , , .f., .f., .f. )
                              TDotNetButton():New( 60, oGrupo, "gc_document_text_lock_32",  "Pdf",         4, {|| ::GenReport( IS_PDF ) }, , , .f., .f., .f. )
                              TDotNetButton():New( 60, oGrupo, "gc_earth_32",             "HTML",        5, {|| ::GenReport( IS_HTML ) }, , , .f., .f., .f. )

      oGrupo               := TDotNetGroup():New( oCarpeta, 126, "Útiles", .f. )
                              TDotNetButton():New( 60, oGrupo, "gc_set_square_pencil_32",  "Diseñar",     1, {|| ::DesignReport() }, , , .f., .f., .f. )
                              TDotNetButton():New( 60, oGrupo, "gc_funnel_32",            "Filtrar",     2, {|| ::DlgFilter() }, , , .f., .f., .f. )

      oGrupo               := TDotNetGroup():New( oCarpeta, 66, "Salida", .f. )

      ::oBtnCancel         := TDotNetButton():New( 60, oGrupo, "End32",                "Salir",       1, {|| ::lBreak := .t., ::End() }, , , .f., .f., .f. )

      ::oDlg:oBottom       := ::oOfficeBar

   ::HideCondiciones()

   /*
   Cargamos las condiciones en oTreeCondiciones--------------------------------
   */

   SysRefresh()

   if ::lDesglosar
      ::oDefDesglosar()
   end if

   if ::lLinImporteCero
      ::oDefLinImporteCero()
   end if

   if ::lDocImporteCero
      ::oDefDocImporteCero()
   end if

   /*
   Nos posicionamos en el informe----------------------------------------------
   */

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create() CLASS TFastValoracionAlmacen

   ::AddField( "cCodArt",     "C", 18, 0, {|| "@!" }, "Codigo artículo", .f., "Código artículo", 14, .f. )

   ::AddTmpIndex( "cCodArt", "cCodArt" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TFastValoracionAlmacen

   local lActivate      := .f.

   if !Empty( ::oDlg )

      ::oDlg:AddFastKey( VK_F5, {|| ::GenReport( 1 ) } )

      ::oDlg:bStart     := {|| ::InitDialog(), ::lRecargaFecha() }

      ::oDlg:Activate( , , , .t. )

      lActivate         := ( ::oDlg:nResult == IDOK )

   end if

RETURN ( lActivate )

//----------------------------------------------------------------------------//

METHOD Play( uParam ) CLASS TFastValoracionAlmacen

   ::Create( uParam )

   if ::lOpenFiles
      if ::lResource()
         ::Activate()
      end if
   end if

   ::End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BrowseDblClick( lAllSelected ) CLASS TFastValoracionAlmacen

   ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Todos   := !::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Todos

   if ::aInitGroup[ ::oBrwRango:nArrayAt ]:Cargo:Todos
      ::oColDesde:nEditType     := 0
      ::oColHasta:nEditType     := 0
   else
      ::oColDesde:nEditType     := 5
      ::oColHasta:nEditType     := 5
   end if

   ::oBrwRango:Refresh()

Return ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TFastValoracionAlmacen

   if ::lSave2Exit .and. ::lOpenFiles
      ::Save()
   end if

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:end()
   end if

   if ::oBmpDiv != nil
      ::oBmpDiv:end()
   end if

   if ::oBandera != nil
      ::oBandera:end()
   end if

   ::CloseData()

   /*
   LLamamos al metodo virtual
   */

   ::CloseFiles()

   if ::oDbfArt != nil .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if ::oDbfAlm != nil .and. ::oDbfAlm:Used()
      ::oDbfAlm:End()
   end if

   if ::oDbfAge != nil .and. ::oDbfAge:Used()
      ::oDbfAge:End()
   end if

   if ::oDbfFam != nil .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if ::oDbfCat != nil .and. ::oDbfCat:Used()
      ::oDbfCat:End()
   end if

   if ::oDbfPrv != nil .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if

   if ::oDbfCli != nil .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if ::oDbfTmp != nil .and. ::oDbfTmp:Used()
      ::oDbfTmp:End()
   end if

   if ::oDbfEmp != nil .and. ::oDbfEmp:Used()
      ::oDbfEmp:End()
   end if

   if ::oGruFam != nil
      ::oGruFam:End()
   end if

   if ::oDbfFpg != nil .and. ::oDbfFpg:Used()
      ::oDbfFpg:End()
   end if

   if ::oDbfTur != nil .and. ::oDbfTur:Used()
      ::oDbfTur:End()
   end if

   if ::oTipArt != nil
      ::oTipArt:End()
   end if

   if ::oDbfFab != nil
      ::oDbfFab:End()
   end if

   if ::oGrpCli != nil
      ::oGrpCli:End()
   end if

   if ::oGrpPrv != nil
      ::oGrpPrv:End()
   end if

   if ::oDbfTrn != nil
      ::oDbfTrn:End()
   end if

   if ::oSeccion != nil
      ::oSeccion:End()
   end if

   if ::oOperacion != nil
      ::oOperacion:End()
   end if

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:Zap()
      ::oDbf:End()
   end if

   ::oDbf      := nil

   /*
   Eliminamos los temporales---------------------------------------------------
   */

   dbDrop( ::cFileName, ::cFileIndx, cLocalDriver() )

   if !Empty( ::nBmp )
      DeleteObject( ::nBmp )
   end if

   if !Empty( ::oBmpImagen )
      ::oBmpImagen:End()
   end if

   if !Empty( ::oDlg )
      ::oDlg:End()
   end if

   Self        := nil

Return .t.

//----------------------------------------------------------------------------//

METHOD GenReport( nOption ) CLASS TFastValoracionAlmacen

   local oDlg

   ::lBreak             := .f.

   ::oBtnCancel:bAction := {|| ::lBreak := .t. }

   if Valtype( ::bPreGenerate ) == "B"
      Eval( ::bPreGenerate )
   end if

   if ::lGenerate()

      if !::lBreak

          DEFINE DIALOG oDlg ;
               FROM     0,0 ;
               TO       4, 30 ;
               TITLE    "Generando informe" ;
               STYLE    DS_MODALFRAME

         oDlg:bStart    := { || ::FastReport( nOption ), oDlg:End(), SysRefresh() }
         oDlg:cMsg      := "Por favor espere..."

         ACTIVATE DIALOG oDlg ;
            CENTER ;
            ON PAINT oDlg:Say( 11, 0, xPadC( oDlg:cMsg, ( oDlg:nRight - oDlg:nLeft ) ), , , , .t. )

      end if

   else

      if !::lBreak
         msgStop( "No hay registros en las condiciones solictadas" )
      end if

   end if

   if Valtype( ::bPostGenerate ) == "B"
      Eval( ::bPostGenerate )
   end if

   ::oBtnCancel:bAction := {|| ::lBreak := .t., ::End() }

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD lGenerate() CLASS TFastValoracionAlmacen

   local cExpHead := ""

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oMtrInf:SetTotal( ::oDbfArt:LastRec() )

   ::oMtrInf:cText      := "Procesando artículos"

   /*
   Calculo del numero de dias
   */

   ::nDias              := 0

   do case
      case ::cUnidadesTiempo == "Dia(s)"
         ::nDias        := ::nUnidadesTiempo
      case ::cUnidadesTiempo == "Semana(s)"
         ::nDias        := ::nUnidadesTiempo * 7
      case ::cUnidadesTiempo == "Mes(es)"
         ::nDias        := ::nUnidadesTiempo * 30
      case ::cUnidadesTiempo == "Año(s)"
         ::nDias        := ::nUnidadesTiempo * 365

   end case

   cExpHead             := ::cExpresionFilter()

   ?cExpHead

   ::oDbfArt:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   /*
   Recorremos artículos
   */

   ::oDbfArt:GoTop()
   while !::oDbfArt:Eof() .and. !::lBreak

      if ::lValidRegister()

         ::oDbf:Append()
         ::oDbf:cCodArt := ::oDbfArt:Codigo
         ::oDbf:Save()

      end if

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfArt:LastRec() )

   ::oDbfArt:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

Method cExpresionFilter() CLASS TFastValoracionAlmacen

   local cExpresion  := ".t."

   if !::oGrupoArticulo:Cargo:Todos
      cExpresion       += ' .and. Codigo >= "' + Rtrim( ::oGrupoArticulo:Cargo:Desde ) + '" .and. Codigo <= "' + Rtrim( ::oGrupoArticulo:Cargo:Hasta ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpresion       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   /*if ( ::oGrupoArticulo:Cargo:Todos .or. ( ::oDbfArt:Codigo >= ::oGrupoArticulo:Cargo:Desde .and. ::oDbfArt:Codigo <= ::oGrupoArticulo:Cargo:Hasta ) )         .and.;
      ( ::oGrupoFamilia:Cargo:Todos .or. ( ::oDbfArt:Familia >= ::oGrupoFamilia:Cargo:Desde .and. ::oDbfArt:Familia <= ::oGrupoFamilia:Cargo:Hasta ) )          .and.;
      ( ::oGrupoTArticulo:Cargo:Todos .or. ( ::oDbfArt:cCodTip >= ::oGrupoTArticulo:Cargo:Desde .and. ::oDbfArt:cCodTip <= ::oGrupoTArticulo:Cargo:Hasta ) )    .and.;
      ( ::oGrupoCategoria:Cargo:Todos .or. ( ::oDbfArt:cCodCate >= ::oGrupoCategoria:Cargo:Desde .and. ::oDbfArt:cCodCate <= ::oGrupoCategoria:Cargo:Hasta ) )  .and.;
      ( ::oGrupoTemporada:Cargo:Todos .or. ( ::oDbfArt:cCodTemp >= ::oGrupoTemporada:Cargo:Desde .and. ::oDbfArt:cCodTemp <= ::oGrupoTemporada:Cargo:Hasta ) )  .and.;
      ( ::oGrupoFabricante:Cargo:Todos .or. ( ::oDbfArt:cCodFab >= ::oGrupoFabricante:Cargo:Desde .and. ::oDbfArt:cCodFab <= ::oGrupoFabricante:Cargo:Hasta ) ) .and.;
      ( !Empty( ::oDbfArt:dFecVta ) .and. Empty( ::oDbfArt:dFinVta ) .and. ( ::oDbfArt:dFecVta + ::nDias < Date() ) )

      return .t.

   end if*/

RETURN ( cExpresion )

//---------------------------------------------------------------------------//

METHOD DataReport( oFr ) CLASS TFastValoracionAlmacen

   /*
   Zona de detalle-------------------------------------------------------------
   */

   ::oFastReport:SetWorkArea(       "Informe", ::oDbf:nArea )
   ::oFastReport:SetFieldAliases(   "Informe", cObjectsToReport( ::oDbf ) )

   /*
   Zona de datos---------------------------------------------------------------
   */

   ::oFastReport:SetWorkArea(       "Empresa", ::oDbfEmp:nArea )
   ::oFastReport:SetFieldAliases(   "Empresa", cItemsToReport( aItmEmp() ) )

   ::oFastReport:SetWorkArea(       "Artículos", ::oDbfArt:nArea )
   ::oFastReport:SetFieldAliases(   "Artículos", cItemsToReport( aItmArt() ) )

   ::oFastReport:SetWorkArea(       "Familias", ::oDbfFam:nArea )
   ::oFastReport:SetFieldAliases(   "Familias", cItemsToReport( aItmFam() ) )

   ::oFastReport:SetWorkArea(       "Tipo artículos", ::oTipArt:Select() )
   ::oFastReport:SetFieldAliases(   "Tipo artículos", cObjectsToReport( ::oTipArt:oDbf ) )

   ::oFastReport:SetWorkArea(       "Categorias", ::oDbfCat:nArea )
   ::oFastReport:SetFieldAliases(   "Categorias", cItemsToReport( aItmCategoria() ) )

   ::oFastReport:SetWorkArea(       "Temporadas", ::oDbfTmp:nArea )
   ::oFastReport:SetFieldAliases(   "Temporadas", cItemsToReport( aItmTemporada() ) )

   ::oFastReport:SetWorkArea(       "Fabricantes", ::oDbfFab:Select() )
   ::oFastReport:SetFieldAliases(   "Fabricantes", cObjectsToReport( ::oDbfFab:oDbf ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Artículos",       {|| ::oDbf:cCodArt } )
   ::oFastReport:SetMasterDetail(   "Informe", "Empresa",         {|| cCodEmp() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Familias",        {|| ::oDbfArt:Familia } )
   ::oFastReport:SetMasterDetail(   "Informe", "Tipo artículos",  {|| ::oDbfArt:cCodTip } )
   ::oFastReport:SetMasterDetail(   "Informe", "Categorias",      {|| ::oDbfArt:cCodCat } )
   ::oFastReport:SetMasterDetail(   "Informe", "Temporadas",      {|| ::oDbfArt:cCodTemp } )
   ::oFastReport:SetMasterDetail(   "Informe", "Fabricantes",     {|| ::oDbfArt:cCodFab } )

   ::oFastReport:SetResyncPair(     "Informe", "Artículos" )
   ::oFastReport:SetResyncPair(     "Informe", "Empresa" )
   ::oFastReport:SetResyncPair(     "Informe", "Familias" )
   ::oFastReport:SetResyncPair(     "Informe", "Tipo artículos" )
   ::oFastReport:SetResyncPair(     "Informe", "Categorias" )
   ::oFastReport:SetResyncPair(     "Informe", "Temporadas" )
   ::oFastReport:SetResyncPair(     "Informe", "Fabricantes" )

   ::AddVariable()

Return ( Self )

//----------------------------------------------------------------------------//

Method AddVariable() CLASS TFastValoracionAlmacen

   ::oFastReport:DeleteCategory( "Informe" )

   if !Empty( ::oGrupofabricante )
      ::oFastReport:AddVariable(    "Informe", "Código de fabricante desde",  "'" + ::oGrupoFabricante:Cargo:Desde               + "'" )
      ::oFastReport:AddVariable(    "Informe", "Código de fabricante hasta",  "'" + ::oGrupoFabricante:Cargo:Hasta               + "'" )
      ::oFastReport:AddVariable(    "Informe", "Texto de fabricante desde",   "'" + Eval( ::oGrupoFabricante:Cargo:TextDesde )   + "'" )
      ::oFastReport:AddVariable(    "Informe", "Texto de fabricante hasta",   "'" + Eval( ::oGrupoFabricante:Cargo:TextHasta )   + "'" )
      ::oFastReport:AddVariable(    "Informe", "Todos los fabricantes",       "'" + cValToChar( ::oGrupoFabricante:Cargo:Todos ) + "'" )
   end if


Return ( Self )

//----------------------------------------------------------------------------//

METHOD OpenData( cPath, lExclusive ) CLASS TFastValoracionAlmacen

   local lOpen          := .t.
   local oBlock

   DEFAULT cPath        := cPatEmp()
   DEFAULT lExclusive   := .f.


   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DATABASE NEW ::oDbfEmp PATH ( cPatDat() ) FILE "Empresa.Dbf" VIA ( cDriver() ) SHARED INDEX "Empresa.Cdx"

      if Empty( ::oDbfInf )
         ::oDbfInf      := ::DefineReport( cPath )
      end if

      /*
      Apertura de los fiche de configuración--------------------------------------
      */

      ::oDbfInf:Activate( .f., !( lExclusive ) )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseData() CLASS TFastValoracionAlmacen

   if ::oDbfEmp != nil .and. ::oDbfEmp:Used()
      ::oDbfEmp:end()
   end if

   if ::oDbfInf != nil .and. ::oDbfInf:Used()
      ::oDbfInf:end()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SyncAllDbf() CLASS TFastValoracionAlmacen

   ::OpenData( cPatEmp(), .t. )

   lCheckDbf( ::oDbfInf )

   ::CloseData()

RETURN ( Self )

//---------------------------------------------------------------------------//

Method DefineReport( cPath ) CLASS TFastValoracionAlmacen

   DEFAULT cPath        := cPatEmp()

   DEFINE DATABASE ::oDbfInf FILE "FstInf.Dbf" CLASS "FstCfg" PATH ( cPath ) VIA ( cDriver() ) COMMENT "Configuracion de usuarios"

      FIELD NAME "cCodUse" TYPE "C" LEN   3  DEC 0 COMMENT "Código usuario"            OF ::oDbfInf
      FIELD NAME "cNomInf" TYPE "C" LEN 100  DEC 0 COMMENT "Nombre del informe"        OF ::oDbfInf
      FIELD NAME "mOrgInf" TYPE "M" LEN  10  DEC 0 COMMENT "Configuración original"    OF ::oDbfInf
      FIELD NAME "mModInf" TYPE "M" LEN  10  DEC 0 COMMENT "Configuración modificada"  OF ::oDbfInf

      INDEX TO "FstInf.Cdx" TAG "cCodUse" ON "cCodUse + Upper( cNomInf )" NODELETED COMMENT "Código"   OF ::oDbfInf

   END DATABASE ::oDbfInf

Return ( ::oDbfInf )

//--------------------------------------------------------------------------//

Method FastReport( nDevice ) CLASS TFastValoracionAlmacen

   CursorWait()

   ::oFastReport                    := frReportManager():new()

   ::oFastReport:LoadLangRes(       "Spanish.Xml" )

   ::oFastReport:SetIcon( 1 )

   ::oFastReport:SetTitle(          "Diseñador de documentos" )

   ::oFastReport:SetEventHandler(   "Designer", "OnSaveReport", {|| ::SaveReport() } )

   ::oFastReport:ClearDataSets()

   ::DataReport()

   if ::oDbfInf:Seek( cCurUsr() + Upper( ::cSubTitle ) ) .and. !Empty( ::oDbfInf:mOrgInf )

      ::oFastReport:LoadFromBlob(   ::oDbfInf:nArea, "mOrgInf" )

      /*
      Preparar el report-------------------------------------------------------
      */

      ::oFastReport:PrepareReport()

      /*
      Imprimir el informe------------------------------------------------------
      */

      do case
         case nDevice == IS_SCREEN
            ::oFastReport:ShowPreparedReport()

         case nDevice == IS_PRINTER
            ::oFastReport:PrintOptions:SetCopies( 1 )
            ::oFastReport:PrintOptions:SetShowDialog( .f. )
            ::oFastReport:Print()

         case nDevice == IS_PDF
            ::oFastReport:SetProperty( "PDFExport", "DefaultPath",      cPatTmp() )
            ::oFastReport:SetProperty( "PDFExport", "FileName",         "Informe" + cCurUsr() + ".pdf" )
            ::oFastReport:SetProperty( "PDFExport", "ShowDialog",       .f. )
            ::oFastReport:SetProperty( "PDFExport", "OpenAfterExport",  .t. )
            ::oFastReport:DoExport(    "PDFExport" )

         case nDevice == IS_HTML
            ::oFastReport:SetProperty( "HTMLExport", "ShowDialog",      .f. )
            ::oFastReport:SetProperty( "HTMLExport", "DefaultPath",     cPatTmp() )
            ::oFastReport:SetProperty( "HTMLExport", "FileName",        "Informe" + cCurUsr() + ".html" )
            ::oFastReport:DoExport(    "HTMLExport" )

         case nDevice == IS_EXCEL
            ::oFastReport:SetProperty( "XLSExport", "DefaultPath",      cPatTmp() )
            ::oFastReport:SetProperty( "XLSExport", "FileName",         "Informe" + cCurUsr() + ".xls" )
            ::oFastReport:DoExport(    "XLSExport" )

      end case

   end if

   CursorWE()

   if !Empty( ::oFastReport )
      ::oFastReport:DestroyFR()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method DesignReport() CLASS TFastValoracionAlmacen

   ::oFastReport                    := frReportManager():new()

   ::oFastReport:LoadLangRes(       "Spanish.Xml" )

   ::oFastReport:SetIcon( 1 )

   ::oFastReport:SetTitle(          "Diseñador de documentos" )

   ::oFastReport:SetEventHandler(   "Designer", "OnSaveReport", {|| ::SaveReport() } )

   ::oFastReport:ClearDataSets()

   ::DataReport()

   if ::oDbfInf:Seek( cCurUsr() + Upper( ::cSubTitle ) ) .and. !Empty( ::oDbfInf:mOrgInf )

      ::oFastReport:LoadFromBlob(   ::oDbfInf:nArea, "mOrgInf" )

   else

      ::oFastReport:AddPage(        "MainPage" )

      ::oFastReport:AddBand(        "CabeceraDocumento", "MainPage", frxPageHeader )
      ::oFastReport:SetProperty(    "CabeceraDocumento", "Top", 0 )
      ::oFastReport:SetProperty(    "CabeceraDocumento", "Height", 200 )

      ::oFastReport:AddBand(        "MasterData",  "MainPage", frxMasterData )
      ::oFastReport:SetProperty(    "MasterData",  "Top", 200 )
      ::oFastReport:SetProperty(    "MasterData",  "Height", 100 )
      ::oFastReport:SetProperty(    "MasterData",  "StartNewPage", .t. )
      ::oFastReport:SetObjProperty( "MasterData",  "DataSet", "Informe" )

      ::oFastReport:AddBand(        "DetalleColumnas",   "MainPage", frxDetailData  )
      ::oFastReport:SetProperty(    "DetalleColumnas",   "Top", 230 )
      ::oFastReport:SetProperty(    "DetalleColumnas",   "Height", 28 )
      ::oFastReport:SetObjProperty( "DetalleColumnas",   "DataSet", "Informe" )

   end if

   ::oFastReport:PreviewOptions:SetMaximized( .t. )

   ::oFastReport:SetTabTreeExpanded( FR_tvAll, .f. )

   ::oFastReport:DesignReport()

   if !Empty( ::oFastReport )
      ::oFastReport:DestroyFR()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method SaveReport() CLASS TFastValoracionAlmacen

   if ::oDbfInf:Seek( cCurUsr() + Upper( ::cSubTitle ) )
      ::oDbfInf:Load()
      ::oDbfInf:cCodUse := cCurUsr()
      ::oDbfInf:cNomInf := ::cSubTitle
      ::oDbfInf:Save()
   else
      ::oDbfInf:Append()
      ::oDbfInf:cCodUse := cCurUsr()
      ::oDbfInf:cNomInf := ::cSubTitle
      ::oDbfInf:Save()
   end if

RETURN ( ::oFastReport:SaveToBlob( ::oDbfInf:nArea, "mOrgInf" ) )

//---------------------------------------------------------------------------//

Function MyManualReport( Self )

   ::oFastReport:SetDefaultFontProperty( "Name", "Times New Roman" )
   ::oFastReport:SetDefaultFontProperty( "Size", 16 )

   ::oFastReport:LineAt( 30, 200, 100, 100 )
   ::oFastReport:MemoAt( "<-- It's a some line ...", 200, 250, 350, 50 )

   ::oFastReport:MemoAt( "<-- It's a some picture ...", 350, 420, 320, 50 )

   ::oFastReport:NewPage()

   ::oFastReport:MemoAt( "It's a second page..................", 30, 30, 100, 1000 )

Return nil