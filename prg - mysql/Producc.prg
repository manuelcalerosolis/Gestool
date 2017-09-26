#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"
#include "FastRepH.ch"

memvar oDbf
memvar cDbf
memvar oDbfCol
memvar cDbfCol
memvar oDbfAlm
memvar cDbfAlm
memvar oDbfSec
memvar cDbfSec
memvar cPouDivPro
memvar cDetPro
memvar cDetMat
memvar cDetHPer
memvar cDetMaq
memvar nPagina
memvar lEnd
memvar cTiempoEmp
memvar nProd
memvar nMat
memvar nPer
memvar nMaq
memvar nParte

static oThis

//---------------------------------------------------------------------------//

Function StartTProduccion( cDriver )

   local oProduccion := TProduccion():New( cPatEmp(), cDriver(), oWnd(), "04008" )

   if !Empty( oProduccion )
      oProduccion:Activate( cDriver )
   end if

Return nil

//---------------------------------------------------------------------------//

CLASS TProduccion FROM TMasDet

   CLASSDATA hDefinition

   DATA cMru                 INIT "gc_document_text_worker_16"

   DATA oDlg
   DATA oFld

   DATA oArt
   DATA oAlm
   DATA oAlbPrvT
   DATA oAlbPrvL
   DATA oAlbPrvS
   DATA oFacPrvT
   DATA oFacPrvL
   DATA oFacPrvS
   DATA oRctPrvL
   DATA oRctPrvS
   DATA oAlbCliT
   DATA oAlbCliL
   DATA oAlbCliS
   DATA oFacCliT
   DATA oFacCliL
   DATA oFacCliS
   DATA oFacRecT
   DATA oFacRecL
   DATA oFacRecS
   DATA oTikCliT
   DATA oTikCliL
   DATA oTikCliS

   DATA oHisMov

   DATA oGrupoFamilia
   DATA oTipoArticulo

   DATA oStock
   DATA oPro
   DATA oTblPro
   DATA oFam
   DATA oKitArt
   DATA oDbfDoc
   DATA oDbfCount
   DATA oDbfEmp
   DATA oTemporada 
   DATA oFabricante
   DATA oCategoria

   DATA oDetProduccion
   DATA oDetSeriesProduccion
   DATA oDetMaterial
   DATA oDetSeriesMaterial
   DATA oDetHoras
   DATA oDetHorasPersonal
   DATA oDetPersonal
   DATA oDetMaquina

   DATA oOperario
   DATA oSeccion
   DATA oOperacion
   DATA oMaquina
   DATA oHoras

   DATA oGetTotalUnidades
   DATA nGetTotalUnidades    INIT  0

   DATA cTmpEmp
   DATA cTiempoEmpleado      INIT  0

   DATA oTotProducido
   DATA oTotMaterias
   DATA oTotPersonal
   DATA oTotMaquinaria

   DATA oTotParte

   DATA cOldCodSec           INIT ""
   DATA cOldCodOpe           INIT ""
   DATA dOldFecIni           INIT Ctod( "" )
   DATA dOldFecFin           INIT Ctod( "" )
   DATA cOldHorIni           INIT ""
   DATA cOldHorFin           INIT ""

   DATA aCal
   DATA cTime

   DATA cFileName

   DATA bModeAppend

   /*
   Datas para el asistente de etiquetas----------------------------------------
   */

   DATA oDlgLbl
   DATA oFldLbl

   DATA oBtnListado
   DATA oBtnAnterior
   DATA oBtnSiguiente
   DATA oBtnCancel

   DATA oBrwMaterialProducido
   DATA oBrwMateriaPrima
   DATA oBrwPersonal 
   DATA oBrwMaquinaria

   Data oSerieInicio
   Data cSerieInicio

   Data oSerieFin
   Data cSerieFin

   Data nDocumentoInicio
   Data nDocumentoFin

   Data cSufijoInicio
   Data cSufijoFin

   Data oFormatoLabel
   Data cFormatoLabel

   Data nFilaInicio
   Data nColumnaInicio

   Data nCantidadLabels
   Data nUnidadesLabels

   Data oMtrLabel
   Data nMtrLabel

   Data lErrorOnCreate

   Data oBtnListado
   Data oBtnSiguiente
   Data oBtnAnterior
   Data oBtnCancel

   Data aSearch
   DATA nRecno

   Data cFileTmpLabel
   Data cAreaTmpLabel

   Data cFileTemporalLabel
   Data cAreaTemporalLabel

   Data oBrwLabel

   METHOD New( cPath, cDriver, oWndParent, oMenuItem )
   METHOD Create( cPath, oWndParent )  INLINE ( ::New( cPath, oWndParent ) )

   METHOD Activate( cDriver )

   METHOD OpenFiles( lExclusive )
   METHOD OpenService( lExclusive )

   METHOD CloseFiles()
   METHOD CloseService()

   METHOD DefineFiles()
   METHOD DefineHash()

   METHOD Resource( nMode, aDatosAnterior )
   METHOD StarResource( oFecIni )   

   METHOD Save( oGetAlm, oGetSec, oGetOpe, oHorFin, nMode, oDlg )

   METHOD nTotUnidades()               INLINE ( NotCaja( ::oDbf:nCajArt ) * ::oDbf:nUndArt )
   METHOD lTotUnidades()               INLINE ( ::oGetTotalUnidades:cText( Round( ::nTotUnidades(), ::nDouDiv ) ), .t. )

   METHOD LoaArticulo( oGetArticulo, oGetNombre )

   METHOD GetNewCount()

   METHOD lTiempoEmpleado( oTmpEmp )

   METHOD lRecargaPersonal( oCodSec )

   METHOD GenParte( nDevice, cCaption, cCodDoc, cPrinter )
   METHOD lGenParte( oBrw, oBtn, nDevice )
   METHOD bGenParte( nDevice, cTitle, cCodDoc )
   METHOD nGenParte( nDevice, cTitle, cCodDoc, cPrinter, nCopy )

   METHOD PrepareDataReport()
   METHOD RestoreDataReport()
   METHOD DefineCalculate()

   METHOD PrnSerie()
   METHOD StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden )

   METHOD RecSiguente( oBrw )
   
   METHOD getDocumentToday()
   METHOD isgetDocumentToday()            INLINE ( !Empty( ::getDocumentToday() ) )

   METHOD AppendDocumentToday()           INLINE ( if( !::isgetDocumentToday(), ::Append(), ::EditDocumentToday() ) )
   METHOD EditDocumentToday()

   METHOD AppendMateriaPrima()
   METHOD AppendElaborado()
   METHOD runModeAppend()

   METHOD modeMateriaPrima()
   METHOD modeElaborado()

   METHOD getIniSeccion()                 INLINE GetPvProfString( "PRODUCCION", "Seccion", "", cIniAplication() )
   METHOD getIniOperacion()               INLINE GetPvProfString( "PRODUCCION", "Operacion", "", cIniAplication() )

   METHOD CargaPersonalAnterior( aDatosAnterior )

   METHOD nTotalProducido( cDocumento, oDbf )
   METHOD nTotalUnidadesProducido( cDocumento, oDbf )

   METHOD nTotalMaterial( cDocumento, oDbf )
   METHOD nHorasPersonal( cDocumento )
   METHOD nTotalPersonal( cDocumento, oDbfPers, oDbfHorasPers )
   METHOD nTotalMaquina( cDocumento, oDbf )
   METHOD nTotalOperario( cDocOpe )
   METHOD nTotalVolumen( cDocumento )

   METHOD nTotalParte()       INLINE ( ::oDetMaterial:nTotal( ::oDetMaterial:oDbfVir ) +;
                                       ::oDetPersonal:nTotal( ::oDetPersonal:oDbfVir, ::oDetHorasPersonal:oDbfVir ) +;
                                       ::oDetMaquina:nTotal( ::oDetMaquina:oDbfVir ) ) 
   // ::oDetProduccion:nTotal( ::oDetProduccion:oDbfVir ) +;

   METHOD CalculaCostes()     

   METHOD DataReport( oFr )
   METHOD VariableReport( oFr )
   METHOD DesignReportProducc( oFr, dbfDoc )
   METHOD PrintReportProducc( nDevice, nCopies, cPrinter, dbfDoc )

   /*
   Métodos para la impresión de etiquetas--------------------------------------
   */

   METHOD CreateAsistenteEtiquetas()
   METHOD EndAsistenteEtiquetas()
   METHOD InitLabel()
   METHOD lCreateAuxiliar()
   METHOD DestroyAuxiliar()
   METHOD BotonAnterior()
   METHOD BotonSiguiente()
   METHOD LoadAuxiliar()
   METHOD DefineAuxiliar()
   METHOD PutLabel()
   METHOD SelectAllLabels()
   METHOD AddLabel()
   METHOD DelLabel()
   METHOD EditLabel()
   METHOD SelectColumn( oCombo )
   METHOD DesignLabelProducc()
   METHOD lPrintLabels()
   METHOD lPrepareDataReportLbl()
   METHOD RestoreDataReportLbl()
   METHOD PrepareTemporalLbl()
   METHOD DataLabel()
   METHOD LoadAuxiliarDesign()

   /*
   Metodos para actualizar el stock de prestashop------------------------------
   */

   Method ActualizaStockWeb( cNumDoc )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem )

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := GetWndFrame()
   DEFAULT cDriver         := cDriver()

   ::cDriver               := cDriver

   if !Empty( oMenuItem )

      if ::nLevel == nil
         ::nLevel          := nLevelUsr( oMenuItem )
      else
         ::nLevel          := 0
      end if

      if nAnd( ::nLevel, 1 ) != 0
         msgStop( "Acceso no permitido." )
         return nil
      end if

   end if

   ::cPath                 := cPath
   ::oWndParent            := oWndParent

   ::cTipoDocumento        := PAR_PRO

   ::bFirstKey             := {|| ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd }

   ::oOperario             := TOperarios():Create()
   ::oOperacion            := TOperacion():CreateInit()
   ::oMaquina              := TMaquina():CreateInit()
   ::oSeccion              := TSeccion():Create()
   ::oHoras                := THoras():Create()

   ::oDetHoras             := TDetHoras():New( cPath, Self )

   ::oDetProduccion        := TDetProduccion():New( cPath, Self )
   ::AddDetail( ::oDetProduccion )

   ::oDetSeriesProduccion  := TDetSeriesProduccion():New( cPath, Self )
   ::AddDetail( ::oDetSeriesProduccion )

   ::oDetMaterial          := TDetMaterial():New( cPath, Self )
   ::AddDetail( ::oDetMaterial )

   ::oDetSeriesMaterial    := TDetSeriesMaterial():New( cPath, Self )
   ::AddDetail( ::oDetSeriesMaterial )

   ::oDetPersonal          := TDetPersonal():New( cPath, cDriver, Self )
   ::AddDetail( ::oDetPersonal )

   ::oDetHorasPersonal     := TDetHorasPersonal():New( cPath, cDriver, Self )
   ::AddDetail( ::oDetHorasPersonal )

   ::oDetMaquina           := TDetMaquina():New( cPath, Self )
   ::AddDetail( ::oDetMaquina )

   ::oStock                := TStock():Create( cPatEmp() )

   ::oGrupoFamilia         := TGrpFam():Create( cPatArt() )

   ::oTipoArticulo         := TTipArt():Create( cPatArt() )

   ::oFabricante           := TFabricantes():Create( cPatArt() )

   /*::bOnPostAppend         := {|| ::ActualizaStockWeb( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd ) }
   ::bOnPostEdit           := {|| ::ActualizaStockWeb( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd ) }*/

   oThis                   := Self 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate( cDriver )

   local oImp
   local oPrv
   local oPdf
   local oScript

   DEFAULT cDriver   := cDriver()

   ::cDriver         := cDriver

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if !::OpenFiles()
      return nil
   end if

   DEFINE SHELL ::oWndBrw FROM 2, 10 TO 18, 70 ;
      XBROWSE ;
      TITLE    "Partes de producción" ;
      PROMPT   "Número",;
               "Fecha inicio",;
               "Operación",;
               "Sección",;
               "Almacén" ;
      MRU      "gc_document_text_worker_16";
      BITMAP   clrTopProduccion ;
      ALIAS    ( ::oDbf ) ;
      APPEND   ::Append() ;
      EDIT     ::Edit() ;
      DELETE   ::Del() ;
      DUPLICAT ::Dup() ;
      OF       ::oWndParent

      // Columnas ---------------------------------------------------------------

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Número"
         :cSortOrder       := "cNumOrd"
         :bEditValue       := {|| ::oDbf:FieldGetByName( "cSerOrd" ) + "/" + AllTrim( Str( ::oDbf:FieldGetByName( "nNumOrd" ) ) ) + "/" + ::oDbf:FieldGetByName( "cSufOrd" ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Fecha inicio"
         :cSortOrder       := "dFecOrd"
         :bEditValue       := {|| Dtoc( ::oDbf:FieldGetByName( "dFecOrd" ) ) + "-" + Trans( ::oDbf:FieldGetByName( "cHorIni" ), "@R 99:99:99" ) }
         :nWidth           := 110
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Fecha fin"
         :bEditValue       := {|| Dtoc( ::oDbf:FieldGetByName( "dFecFin" ) ) + "-" + Trans( ::oDbf:FieldGetByName( "cHorFin" ), "@R 99:99:99" ) }
         :nWidth           := 110
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Operación"
         :cSortOrder       := "cCodOpe"
         :bEditValue       := {|| AllTrim( ::oDbf:FieldGetByName( "cCodOpe" ) ) + " - " + oRetFld( ::oDbf:FieldGetByName( "cCodOpe" ), ::oOperacion:oDbf ) }
         :nWidth           := 250
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Sección"
         :cSortOrder       := "cCodSec"
         :bEditValue       := {|| AllTrim( ::oDbf:FieldGetByName( "cCodSec" ) ) + " - " + oRetFld( ::oDbf:FieldGetByName( "cCodSec" ), ::oSeccion:oDbf ) }
         :nWidth           := 250
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( ::oWndBrw:AddXCol() )
         :cHeader          := "Almacén"
         :cSortOrder       := "cAlmOrd"
         :bEditValue       := {|| AllTrim( ::oDbf:FieldGetByName( "cAlmOrd" ) ) + " - " + oRetFld( ::oDbf:FieldGetByName( "cAlmOrd" ), ::oAlm ) }
         :nWidth           := 250
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oWndBrw:ClickOnHeader( oCol ) }
      end with

      ::oWndBrw:CreateXFromCode()

   DEFINE BTNSHELL RESOURCE "BUS" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:SearchSetFocus() ) ;
      TOOLTIP  "(B)uscar" ;
      HOTKEY   "B";

      ::oWndBrw:AddSeaBar()

   DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecAdd() );
      ON DROP  ( ::oWndBrw:RecAdd() );
      TOOLTIP  "(A)ñadir";
      BEGIN GROUP ;
      HOTKEY   "A" ;
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "DUP" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecDup() );
      ON DROP  ( ::oWndBrw:RecDup() );
      TOOLTIP  "(D)uplicar";
      BEGIN GROUP ;
      HOTKEY   "D" ;
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::RecSiguente( ::oWndBrw ) );
      TOOLTIP  "Si(g)uente";
      HOTKEY   "G";
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::AppendElaborado() );
      TOOLTIP  "Añadir elaborado";
      HOTKEY   "1" ;
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::AppendMateriaPrima() );
      TOOLTIP  "Añadir materia prima";
      HOTKEY   "2" ;
      LEVEL    ACC_APPD

   DEFINE BTNSHELL RESOURCE "EDIT" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecEdit() );
      TOOLTIP  "(M)odificar";
      HOTKEY   "M" ;
      LEVEL    ACC_EDIT

   DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::Zoom() );
      TOOLTIP  "(Z)oom";
      HOTKEY   "Z" ;
      LEVEL    ACC_ZOOM

   DEFINE BTNSHELL RESOURCE "DEL" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecDel() );
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   DEFINE BTNSHELL oImp RESOURCE "IMP" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::nGenParte( IS_PRINTER ) ) ;
      TOOLTIP  "(I)mprimir";
      HOTKEY   "I";
      LEVEL    ACC_IMPR

      ::lGenParte( ::oWndBrw:oBrw, oImp, IS_PRINTER )

   DEFINE BTNSHELL RESOURCE "GC_PRINTER2_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::PrnSerie() ) ;
      TOOLTIP  "Imp(r)imir series";
      HOTKEY   "R";
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL oPrv RESOURCE "PREV1" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::GenParte( IS_SCREEN ) ) ;
      TOOLTIP  "(P)revisualizar";
      HOTKEY   "P";
      LEVEL    ACC_IMPR

      ::lGenParte( ::oWndBrw:oBrw, oPrv, IS_SCREEN )

   DEFINE BTNSHELL oPdf RESOURCE "DOCLOCK" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::GenParte( IS_PDF ) ) ;
      TOOLTIP  "Pd(f)";
      HOTKEY   "F";
      LEVEL    ACC_IMPR

      ::lGenParte( ::oWndBrw:oBrw, oPdf, IS_PDF )

   DEFINE BTNSHELL RESOURCE "gc_document_empty_chart_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( runFastGallery( "Produccion" ) ) ;
      TOOLTIP  "Rep(o)rting";
      HOTKEY   "O" ;
      LEVEL    ACC_IMPR

   DEFINE BTNSHELL RESOURCE "gc_portable_barcode_scanner_" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::CreateAsistenteEtiquetas() ) ;
      TOOLTIP  "Eti(q)uetas" ;
      HOTKEY   "Q";
      LEVEL    ACC_IMPR   

   DEFINE BTNSHELL oScript RESOURCE "gc_folder_document_" GROUP OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( oScript:Expand() ) ;
      TOOLTIP  "Scripts" ;

      ImportScript( ::oWndBrw, oScript, "Produccion", Self ) 

   DEFINE BTNSHELL RESOURCE "END" GROUP OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:end() ) ;
      TOOLTIP  "(S)alir" ;
      HOTKEY   "S"

   if ::cHtmlHelp != nil
      ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
   end if

   ACTIVATE WINDOW ::oWndBrw VALID ( ::CloseFiles() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT  lExclusive  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !lExclusive )

   ::OpenDetails()

   DATABASE NEW ::oArt        PATH ( cPatArt() )   FILE "ARTICULO.DBF"  VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oAlm        PATH ( cPatAlm() )   FILE "ALMACEN.DBF"   VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

   DATABASE NEW ::oFam        PATH ( cPatArt() )   FILE "FAMILIAS.DBF"  VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oAlbPrvT    PATH ( cPatEmp() )   FILE "ALBPROVT.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"
   
   DATABASE NEW ::oAlbPrvL    PATH ( cPatEmp() )   FILE "ALBPROVL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"
   ::oAlbPrvL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oAlbPrvS    PATH ( cPatEmp() )   FILE "ALBPRVS.DBF"   VIA ( cDriver() ) SHARED INDEX "ALBPRVS.CDX"

   DATABASE NEW ::oFacPrvT    PATH ( cPatEmp() )   FILE "FACPRVT.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"
   
   DATABASE NEW ::oFacPrvL    PATH ( cPatEmp() )   FILE "FACPRVL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"
   ::oFacPrvL:OrdSetFocus( "cRef" )
   
   DATABASE NEW ::oFacPrvS    PATH ( cPatEmp() )   FILE "FacPrvS.DBF"   VIA ( cDriver() ) SHARED INDEX "FacPrvS.CDX"

   DATABASE NEW ::oRctPrvL    PATH ( cPatEmp() )   FILE "RctPrvL.DBF"   VIA ( cDriver() ) SHARED INDEX "RctPrvL.CDX"
   ::oRctPrvL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oRctPrvS    PATH ( cPatEmp() )   FILE "RctPrvS.DBF"   VIA ( cDriver() ) SHARED INDEX "RctPrvS.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()
   DATABASE NEW ::oAlbCliL    PATH ( cPatEmp() )   FILE "AlbCliL.DBF"   VIA ( cDriver() ) SHARED INDEX "AlbCliL.CDX"
   DATABASE NEW ::oAlbCliS    PATH ( cPatEmp() )   FILE "AlbCliS.DBF"   VIA ( cDriver() ) SHARED INDEX "AlbCliS.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()
   DATABASE NEW ::oFacCliL    PATH ( cPatEmp() )   FILE "FacCliL.DBF"   VIA ( cDriver() ) SHARED INDEX "FacCliL.CDX"
   DATABASE NEW ::oFacCliS    PATH ( cPatEmp() )   FILE "FacCliS.DBF"   VIA ( cDriver() ) SHARED INDEX "FacCliS.CDX"

   DATABASE NEW ::oFacRecT    PATH ( cPatEmp() )   FILE "FacRecT.DBF"   VIA ( cDriver() ) SHARED INDEX "FacRecT.CDX"
   DATABASE NEW ::oFacRecL    PATH ( cPatEmp() )   FILE "FacRecL.DBF"   VIA ( cDriver() ) SHARED INDEX "FacRecL.CDX"
   DATABASE NEW ::oFacRecS    PATH ( cPatEmp() )   FILE "FacRecS.DBF"   VIA ( cDriver() ) SHARED INDEX "FacRecS.CDX"

   DATABASE NEW ::oTikCliT    PATH ( cPatEmp() )   FILE "TikeT.DBF"     VIA ( cDriver() ) SHARED INDEX  "TikeT.CDX"
   DATABASE NEW ::oTikCliL    PATH ( cPatEmp() )   FILE "TikeL.DBF"     VIA ( cDriver() ) SHARED INDEX  "TikeL.CDX"
   DATABASE NEW ::oTikCliS    PATH ( cPatEmp() )   FILE "TikeS.DBF"     VIA ( cDriver() ) SHARED INDEX  "TikeS.CDX"

   DATABASE NEW ::oTblPro     PATH ( cPatArt() )   FILE "TblPro.DBF"    VIA ( cDriver() ) SHARED INDEX "TblPro.CDX"

   DATABASE NEW ::oPro        PATH ( cPatArt() )   FILE "Pro.DBF"       VIA ( cDriver() ) SHARED INDEX "Pro.CDX"

   DATABASE NEW ::oKitArt     PATH ( cPatArt() )   FILE "ARTKIT.DBF"    VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   DATABASE NEW ::oDbfDoc     PATH ( cPatEmp() )   FILE "RDOCUMEN.DBF"  VIA ( cDriver() ) SHARED INDEX "RDOCUMEN.CDX"
   ::oDbfDoc:OrdSetFocus( "cTipo" )

   DATABASE NEW ::oDbfCount   PATH ( cPatEmp() )   FILE "NCOUNT.DBF"    VIA ( cDriver() ) SHARED INDEX "NCOUNT.CDX"

   DATABASE NEW ::oDbfEmp     PATH ( cPatDat() )   FILE "EMPRESA.DBF"   VIA ( cDriver() ) SHARED INDEX "EMPRESA.CDX"

   DATABASE NEW ::oHisMov     PATH ( cPatEmp() )   FILE "HISMOV.DBF"    VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

   DATABASE NEW ::oTemporada  PATH ( cPatEmp() )   FILE "Temporadas.Dbf" VIA ( cDriver() ) SHARED INDEX "Temporadas.Cdx"

   DATABASE NEW ::oCategoria  PATH ( cPatEmp() )   FILE "Categorias.Dbf" VIA ( cDriver() ) SHARED INDEX "Categorias.Cdx"

   if !::oGrupoFamilia:OpenFiles()
      lOpen          := .f.
   end if

   if !::oTipoArticulo:OpenFiles()
      lOpen          := .f.
   end if

   if !::oFabricante:OpenFiles()
      lOpen          := .f.
   end if 

   if !::oDetHoras:OpenFiles()
      lOpen          := .f.
   end if

   if !::oOperario:OpenFiles()
      lOpen          := .f.
   end if

   if !::oSeccion:OpenFiles()
      lOpen          := .f.
   end if

   if !::oOperacion:OpenFiles()
      lOpen          := .f.
   end if

   if !::oMaquina:OpenFiles()
      lOpen          := .f.
   end if

   if !::oHoras:OpenFiles()
      lOpen          := .f.
   end if

   if !::oStock:lOpenFiles()
      lOpen          := .f.
   end if

   RECOVER USING oError

      lOpen          := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseService()

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf   := nil

   ::CloseDetails()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::CloseDetails()

   if ::oArt != nil .and. ::oArt:Used()
      ::oArt:End()
   end if

   if ::oAlm != nil .and. ::oAlm:Used()
      ::oAlm:End()
   end if

   if ::oAlbPrvT != nil .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if ::oAlbPrvL != nil .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if ::oAlbPrvS != nil .and. ::oAlbPrvS:Used()
      ::oAlbPrvS:End()
   end if

   if ::oFacPrvT != nil .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if ::oFacPrvL != nil .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if ::oFacPrvS != nil .and. ::oFacPrvS:Used()
      ::oFacPrvs:End()
   end if

   if ::oRctPrvL != nil .and. ::oRctPrvL:Used()
      ::oRctPrvL:End()
   end if

   if ::oRctPrvS != nil .and. ::oRctPrvS:Used()
      ::oRctPrvS:End()
   end if

   if ::oAlbCliT != nil .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if ::oAlbCliL != nil .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if ::oAlbCliS != nil .and. ::oAlbCliS:Used()
      ::oAlbCliS:End()
   end if

   if ::oFacCliT != nil .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if ::oFacCliL != nil .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if ::oFacCliS != nil .and. ::oFacCliS:Used()
      ::oFacClis:End()
   end if

   if ::oFacRecT != nil .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if

   if ::oFacRecL != nil .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if ::oFacRecS != nil .and. ::oFacRecS:Used()
      ::oFacRecs:End()
   end if

   if ::oTikCliT != nil .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

   if ::oTikCliL != nil .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if ::oTikCliS != nil .and. ::oTikCliS:Used()
      ::oTikClis:End()
   end if

   if ::oFam != nil .and. ::oFam:Used()
      ::oFam:End()
   end if

   if ::oTblPro != nil .and. ::oTblPro:Used()
      ::oTblPro:End()
   end if

   if ::oPro != nil .and. ::oPro:Used()
      ::oPro:End()
   end if

   if ::oKitArt != nil .and. ::oKitArt:Used()
      ::oKitArt:End()
   end if

   if ::oDbfDoc != nil .and. ::oDbfDoc:Used()
      ::oDbfDoc:End()
   end if

   if ::oDbfCount != nil .and. ::oDbfCount:Used()
      ::oDbfCount:End()
   end if

   if ::oDbfEmp != nil .and. ::oDbfEmp:Used()
      ::oDbfEmp:End()
   end if

   if ::oHisMov != nil .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   if ::oTemporada != nil .and. ::oTemporada:Used()
      ::oTemporada:End()
   end if

   if ::oDetHoras != nil
      ::oDetHoras:End()
      ::oDetHoras    := nil
   end if

   if ::oDetPersonal != nil
      ::oDetPersonal:End()
      ::oDetPersonal := nil
   end if

   if ::oOperario != nil
      ::oOperario:End()
      ::oOperario    := nil
   end if

   if ::oSeccion != nil
      ::oSeccion:End()
      ::oSeccion     := nil
   end if

   if ::oOperacion != nil
      ::oOperacion:End()
      ::oOperacion   := nil
   end if

   if ::oMaquina != nil
      ::oMaquina:End()
      ::oMaquina     := nil
   end if

   if ::oHoras != nil
      ::oHoras:End()
      ::oHoras       := nil
   end if

   if !Empty( ::oGrupoFamilia )
      ::oGrupoFamilia:End()
   end if

   if !Empty( ::oTipoArticulo )
      ::oTipoArticulo:End()
   end if

   if !Empty( ::oFabricante )
      ::oFabricante:End()
   end if


   if !Empty( ::oStock )
      ::oStock:end()
      ::oStock       := nil
   end if

   if !Empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   ::oDbfDiv   := nil

   ::oFam      := nil
   ::oTblPro   := nil
   ::oPro      := nil
   ::oKitArt   := nil
   ::oDbfDoc   := nil
   ::oDbfCount := nil
   ::oDbfEmp   := nil
   ::oHisMov   := nil

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "ProCab.Dbf" CLASS "ProCab" ALIAS "ProCab" PATH ( cPath ) VIA ( cDriver ) COMMENT "Partes de producción"

      FIELD NAME "cSerOrd" TYPE "C" LEN 01  DEC 0 COMMENT "Serie"                                  OF ::oDbf
      FIELD NAME "nNumOrd" TYPE "N" LEN 09  DEC 0 COMMENT "Número"                                 OF ::oDbf
      FIELD NAME "cSufOrd" TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo"                                 OF ::oDbf

      FIELD CALCULATE NAME "iNumOrd"   LEN  12 DEC  0 COMMENT "" ; 
         VAL ( ::oDbf:cSerOrd + str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd ) HIDE                      OF ::oDbf

      FIELD NAME "dFecOrd" TYPE "D" LEN 08  DEC 0 COMMENT "Fecha inicio"                           OF ::oDbf
      FIELD NAME "dFecFin" TYPE "D" LEN 08  DEC 0 COMMENT "Fecha fin"                              OF ::oDbf
      FIELD NAME "cCodDiv" TYPE "C" LEN 03  DEC 0 COMMENT "Divisa"                                 OF ::oDbf
      FIELD NAME "nVdvDiv" TYPE "N" LEN 16  DEC 6 COMMENT "Valor divisa"                           OF ::oDbf
      FIELD NAME "cAlmOrd" TYPE "C" LEN 16  DEC 0 COMMENT "Almacén destino"                        OF ::oDbf
      FIELD NAME "cCodSec" TYPE "C" LEN 03  DEC 0 COMMENT "Sección"                                OF ::oDbf
      FIELD NAME "cHorIni" TYPE "C" LEN 06  DEC 0 COMMENT "Hora de inicio" PICTURE "@R 99:99:99"   OF ::oDbf
      FIELD NAME "cHorFin" TYPE "C" LEN 06  DEC 0 COMMENT "Hora de fin"    PICTURE "@R 99:99:99"   OF ::oDbf
      FIELD NAME "cCodOpe" TYPE "C" LEN 03  DEC 0 COMMENT "Operación"                              OF ::oDbf
      FIELD NAME "cAlmOrg" TYPE "C" LEN 16  DEC 0 COMMENT "Almacén Origen"                         OF ::oDbf
      FIELD NAME "lRecCos" TYPE "L" LEN 01  DEC 0 COMMENT "Recalcula"      HIDE                    OF ::oDbf

      INDEX TO "ProCab.Cdx" TAG "cNumOrd" ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd"                     COMMENT "Número"        NODELETED OF ::oDbf
      INDEX TO "ProCab.Cdx" TAG "dFecOrd" ON "dtos( dFecOrd ) + cHorIni"                                 COMMENT "Fecha inicio"  NODELETED OF ::oDbf
      INDEX TO "ProCab.Cdx" TAG "cCodOpe" ON "cCodOpe"                                                   COMMENT "Operación"     NODELETED OF ::oDbf
      INDEX TO "ProCab.Cdx" TAG "cCodSec" ON "cCodSec"                                                   COMMENT "Sección"       NODELETED OF ::oDbf
      INDEX TO "ProCab.Cdx" TAG "cAlmOrd" ON "cAlmOrd"                                                   COMMENT "Almacén"       NODELETED OF ::oDbf
      INDEX TO "ProCab.Cdx" TAG "iNumOrd" ON "'30' + cSerOrd + Str( nNumOrd, 9 ) + space( 1 ) + cSufOrd" COMMENT ""              NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD DefineHash()

   ::hDefinition  := {;
      "Table"          => "Procab",;
      "ExtensionTable" => "Dbf",;
      "Path"           => cPatEmp(),;
      "Comment"        => "Partes de producción",;
      "Fields"         => {;
         "cSerOrd" => { "Type" => "C", "Len" => 01, "Decimals" => 0, "Comment" => "Serie",            "Validate" => "Required" },;
         "nNumOrd" => { "Type" => "N", "Len" => 09, "Decimals" => 0, "Comment" => "Número",           "Validate" => "Required" },;
         "cSufOrd" => { "Type" => "C", "Len" => 02, "Decimals" => 0, "Comment" => "Sufijo",           "Validate" => "Required" },;
         "dFecOrd" => { "Type" => "D", "Len" => 08, "Decimals" => 0, "Comment" => "Fecha inicio",     "Validate" => "Required" },;
         "dFecFin" => { "Type" => "D", "Len" => 08, "Decimals" => 0, "Comment" => "Fecha fin",        "Validate" => "Required" },;
         "cCodDiv" => { "Type" => "C", "Len" => 03, "Decimals" => 0, "Comment" => "Divisa",           "Validate" => "Required" },;
         "nVdvDiv" => { "Type" => "N", "Len" => 16, "Decimals" => 6, "Comment" => "Valor divisa",     "Validate" => "Required" },;
         "cAlmOrd" => { "Type" => "C", "Len" => 16, "Decimals" => 0, "Comment" => "Almacén destino",  "Validate" => "Required" },;
         "cCodSec" => { "Type" => "C", "Len" => 03, "Decimals" => 0, "Comment" => "Sección",          "Validate" => "Required" },;
         "cHorIni" => { "Type" => "C", "Len" => 06, "Decimals" => 0, "Comment" => "Hora de inicio",   "Validate" => "Required", "Picture" => "@R 99:99:99" },;
         "cHorFin" => { "Type" => "C", "Len" => 06, "Decimals" => 0, "Comment" => "Hora de fin",      "Validate" => "Required", "Picture" => "@R 99:99:99" },;
         "cCodOpe" => { "Type" => "C", "Len" => 03, "Decimals" => 0, "Comment" => "Operación",        "Validate" => "Required" },;
         "cAlmOrg" => { "Type" => "C", "Len" => 16, "Decimals" => 0, "Comment" => "Almacén Origen",   "Validate" => "" };
      },;
      "Index"          => "Porcab",;
      "ExtensionIndex" => "Cdx",;
      "Tags"           => {;
         "cNumOrd" => { "Expresion" => "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd", "Comment" => "Número" },;
         "dFecOrd" => { "Expresion" => "dFecOrd", "Comment" => "Fecha inicio" },;
         "cCodOpe" => { "Expresion" => "cCodOpe", "Comment" => "Operación"    },;
         "cCodSec" => { "Expresion" => "cCodSec", "Comment" => "Sección"      },;
         "cAlmOrd" => { "Expresion" => "cAlmOrd", "Comment" => "Almacén"      };
      };
   }

RETURN ( ::hDefinition )

//---------------------------------------------------------------------------//

METHOD Resource( nMode, aDatosAnterior )

   local oGetSer
   local oGetAlm
   local oSayAlm
   local cSayAlm
   local oGetSec
   local oSaySec
   local cSaySec
   local oFntTot              := TFont():New( "Arial", 8, 26, .F., .T. )
   local oHorIni
   local oHorFin
   local oTmpEmp
   local oFecIni
   local oFecFin
   local oGetOpe
   local oSayOpe
   local cSayOpe
   local oAlmOrg
   local oSayOrg
   local cSayOrg
   local oBmpGeneral
   local oBtnAdelante
   local oBtnAtras
   local oRecCos

   if nMode == APPD_MODE

      if !Empty( cDefSer() )
         ::oDbf:cSerOrd    := cDefSer()
      else
         ::oDbf:cSerOrd    := "A"
      end if

      ::oDbf:cAlmOrd       := oUser():cAlmacen()
      ::oDbf:cAlmOrg       := oUser():cAlmacen()
      ::oDbf:cCodDiv       := cDivEmp()
      ::oDbf:nVdvDiv       := nChgDiv( cDivEmp() )

      if aDatosAnterior != nil
         ::oDbf:dFecOrd    := aDatosAnterior[2]
         ::oDbf:dFecFin    := aDatosAnterior[2]
         ::oDbf:cHorIni    := aDatosAnterior[3]
         ::oDbf:cHorFin    := aDatosAnterior[3]
         ::oDbf:cCodSec    := aDatosAnterior[4]
         ::CargaPersonalAnterior( aDatosAnterior )
      else
         ::oDbf:dFecOrd    := GetSysDate()
         ::oDbf:dFecFin    := GetSysDate()
         ::oDbf:cHorIni    := getHoraInicioEmpresa()
         ::oDbf:cHorFin    := GetSysTime()
      end if

      if Empty( ::oDbf:cCodSec )
         ::oDbf:cCodSec    := ::getIniSeccion()
      end if

      if Empty( ::oDbf:cCodOpe )
         ::oDbf:cCodOpe    := ::getIniOperacion()
      end if

      //SubStr( Time(), 1, 2 ) + SubStr( Time(), 4, 2 )

      ::oDbf:lRecCos       := uFieldEmpresa( "lRecCostes" )

   end if

   ::cOldCodSec            := ::oDbf:cCodSec
   ::cOldCodOpe            := ::oDbf:cCodOpe
   ::dOldFecIni            := ::oDbf:dFecOrd
   ::dOldFecFin            := ::oDbf:dFecFin
   ::cOldHorIni            := ::oDbf:cHorIni
   ::cOldHorFin            := ::oDbf:cHorFin

   ::lTiempoEmpleado()

   ::lLoadDivisa( ::oDbf:cCodDiv )

   cSayOrg                 := RetAlmacen( ::oDbf:cAlmOrg, ::oAlm )
   cSayAlm                 := RetAlmacen( ::oDbf:cAlmOrd, ::oAlm )
   cSaySec                 := oRetFld( ::oDbf:cCodSec, ::oSeccion:oDbf )
   cSayOpe                 := oRetFld( ::oDbf:cCodOpe, ::oOperacion:oDbf )

   ::oDetProduccion:oDbfVir:GetStatus()
   ::oDetProduccion:oDbfVir:OrdSetFocus( "nNumLin" )

   ::oDetMaterial:oDbfVir:GetStatus()
   ::oDetMaterial:oDbfVir:OrdSetFocus( "nNumLin" )

   ::oDetPersonal:oDbfVir:GetStatus()
   ::oDetPersonal:oDbfVir:OrdSetFocus( "nNumLin" )

   ::oDetMaquina:oDbfVir:GetStatus()
   ::oDetMaquina:oDbfVir:OrdSetFocus( "nNumLin" )

   DEFINE DIALOG ::oDlg RESOURCE "Produccion" TITLE LblTitle( nMode ) + "parte de producción"

      REDEFINE FOLDER ::oFld;
         ID       400 ;
			OF 		::oDlg ;
         PROMPT   "&Producción",;
                  "&Materias primas",;
                  "P&ersonal",;
                  "Maquinaria" ;
         DIALOGS  "Produccion_1",;
                  "Produccion_2",;
                  "Produccion_3",;
                  "Produccion_4"

      /*
      Operaciones--------------------------------------------------------------
      */

      REDEFINE GET oGetOpe VAR ::oDbf:cCodOpe ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
			OF 		::oFld:aDialogs[1]

         oGetOpe:bHelp     := {|| ::oOperacion:Buscar( oGetOpe ), ::lRecargaPersonal( , oGetOpe ) }
         oGetOpe:bValid    := {|| ::oOperacion:Existe( oGetOpe, oSayOpe, "cDesOpe", .t., .t., "0" ), ::lRecargaPersonal( , oGetOpe ) }

      REDEFINE GET oSayOpe VAR cSayOpe ;
         ID       220 ;
         WHEN     .f. ;
         OF       ::oFld:aDialogs[1]

      /*
      Código de almacén origen-------------------------------------------------
      */

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_document_text_worker_48" ;
        TRANSPARENT ;
        OF       ::oFld:aDialogs[1]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_object_cube_48" ;
        TRANSPARENT ;
        OF       ::oFld:aDialogs[2]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_worker2_48" ;
        TRANSPARENT ;
        OF       ::oFld:aDialogs[3]

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_industrial_robot_48" ;
        TRANSPARENT ;
        OF       ::oFld:aDialogs[4]

      REDEFINE GET oAlmOrg VAR ::oDbf:cAlmOrg ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( oAlmOrg, ::oAlm, oSayOrg ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( oAlmOrg, oSayOrg ) ) ;
			OF 		::oFld:aDialogs[1]

      REDEFINE GET oSayOrg VAR cSayOrg ;
         ID       231 ;
         WHEN     .f. ;
         OF       ::oFld:aDialogs[1]

      /*
      Código de almacén destino------------------------------------------------
      */

      REDEFINE GET oGetAlm VAR ::oDbf:cAlmOrd ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cAlmacen( oGetAlm, ::oAlm, oSayAlm ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( oGetAlm, oSayAlm ) ) ;
			OF 		::oFld:aDialogs[1]

      REDEFINE GET oSayAlm VAR cSayAlm ;
         ID       151 ;
         WHEN     .f. ;
         OF       ::oFld:aDialogs[1]

      /*
      Código de la sección-----------------------------------------------------
      */

      REDEFINE GET oGetSec VAR ::oDbf:cCodSec ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
			OF 		::oFld:aDialogs[1]

         oGetSec:bHelp     := {|| ::oSeccion:Buscar( oGetSec ), ::lRecargaPersonal( oGetSec ) }
         oGetSec:bValid    := {|| ::oSeccion:Existe( oGetSec, oSaySec, "cDesSec", .t., .t., "0" ), ::lRecargaPersonal( oGetSec ) }

      REDEFINE GET oSaySec VAR cSaySec ;
         ID       161 ;
         WHEN     .f. ;
         OF       ::oFld:aDialogs[1]

      /*
      Divisas------------------------------------------------------------------
      */

      ::oDefDiv( 140, 141, 142, ::oFld:aDialogs[1], nMode )

      /*
      Serie numero y sufijo del documento--------------------------------------
      */

      REDEFINE GET oGetSer VAR ::oDbf:cSerOrd ;
         ID       100 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( UpSerie( oGetSer ) );
         ON DOWN  ( DwSerie( oGetSer ) );
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE );
         VALID    ( ::oDbf:cSerOrd >= "A" .and. ::oDbf:cSerOrd <= "Z" ) ;
			OF 		::oFld:aDialogs[1]

      REDEFINE GET ::oDbf:nNumOrd ;
			ID 		110 ;
			PICTURE 	"999999999" ;
         WHEN     ( .f. );
			OF 		::oFld:aDialogs[1]

      REDEFINE GET ::oDbf:cSufOrd ;
         ID       120 ;
         PICTURE  "@!" ;
         WHEN     ( .f. );
			OF 		::oFld:aDialogs[1]

      /*
      Fecha y horas del documento----------------------------------------------
      */

      REDEFINE GET oFecIni VAR ::oDbf:dFecOrd ;
			ID 		130 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[1]

      oFecIni:bValid    := {|| ::lTiempoEmpleado( oTmpEmp ), ::lRecargaPersonal( , , oFecIni ) }
      oFecIni:bChange   := {|| ::lTiempoEmpleado( oTmpEmp ) }

      REDEFINE GET oFecFin VAR ::oDbf:dFecFin ;
         ID       131 ;
			SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[1]

      oFecFin:bValid    := {|| ::lTiempoEmpleado( oTmpEmp ), ::lRecargaPersonal( , , , oFecFin ) }
      oFecFin:bChange   := {|| ::lTiempoEmpleado( oTmpEmp ) }

      REDEFINE CHECKBOX oRecCos VAR ::oDbf:lRecCos ;
         ID       300 ;   
         OF       ::oFld:aDialogs[1]   

      /*
      Hora inicio, hora fin, tiempo empleado-----------------------------------
      */

      REDEFINE GET oHorIni ; 
         VAR      ::oDbf:cHorIni ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         ON UP    ( UpTime( oHorIni ) );
         ON DOWN  ( DwTime( oHorIni ) );
         ID       170 ;
         OF       ::oFld:aDialogs[1]

         oHorIni:bValid    := {|| if( validHourMinutes( oHorIni ), ::lTiempoEmpleado( oTmpEmp ), ), ::lRecargaPersonal( , , , , oHorIni ) }
         oHorIni:bChange   := {|| ::lTiempoEmpleado( oTmpEmp ) }

      REDEFINE GET oHorFin ;
         VAR      ::oDbf:cHorFin ;
         PICTURE  "@R 99:99:99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         SPINNER ;
         ON UP    ( UpTime( oHorFin ) );
         ON DOWN  ( DwTime( oHorFin ) );
         ID       180 ;
         OF       ::oFld:aDialogs[1]

         oHorFin:bValid    := {|| if( validHourMinutes( oHorFin ), ::lTiempoEmpleado( oTmpEmp ), ), ::lRecargaPersonal( , , , , , oHorFin ) }
         oHorFin:bChange   := {|| ::lTiempoEmpleado( oTmpEmp ) }

      REDEFINE GET oTmpEmp ;
         VAR      ::cTmpEmp ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       190 ;
         OF       ::oFld:aDialogs[1]

      /*
      Material producido-------------------------------------------------------
      */

		REDEFINE BUTTON ;
			ID 		500 ;
         OF       ::oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetProduccion:Append( ::oBrwMaterialProducido ), ::oBrwMaterialProducido:MakeTotals(), ::oBrwMaterialProducido:Refresh(), ::oBrwMateriaPrima:Refresh(), ::oTotProducido:Refresh(), ::oTotParte:Refresh() )

		REDEFINE BUTTON ;
			ID 		501 ;
         OF       ::oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetProduccion:Edit( ::oBrwMaterialProducido ), ::oBrwMaterialProducido:MakeTotals(), ::oBrwMaterialProducido:Refresh(), ::oBrwMateriaPrima:Refresh(), ::oTotProducido:Refresh(), ::oTotParte:Refresh() )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       ::oFld:aDialogs[1] ;
         ACTION   ( ::oDetProduccion:Zoom() )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       ::oFld:aDialogs[1] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetProduccion:Del( ::oBrwMaterialProducido, ::oBrwMateriaPrima ), ::oBrwMaterialProducido:MakeTotals(), ::oBrwMateriaPrima:Refresh(), ::oTotProducido:Refresh(), ::oTotParte:Refresh() )

      /*
      Browse de materiales--------------------------------------------------------
      */

      ::oBrwMaterialProducido                := IXBrowse():New( ::oFld:aDialogs[1] )

      ::oBrwMaterialProducido:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwMaterialProducido:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oDetProduccion:oDbfVir:SetBrowse( ::oBrwMaterialProducido ) 

      ::oBrwMaterialProducido:nMarqueeStyle  := 6
      ::oBrwMaterialProducido:cName          := "Lineas de partes de producción"
      ::oBrwMaterialProducido:lFooter        := .t.

      ::oBrwMaterialProducido:CreateFromResource( 200 )
      ::oBrwMaterialProducido:MakeTotals()

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := "Número"
         :bStrData         := {|| Trans( ::oDetProduccion:oDbfVir:FieldGetByName( "nNumLin" ), "9999" ) }
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := "Código"
         :bStrData         := {|| ::oDetProduccion:oDbfVir:FieldGetByName( "cCodArt" ) }
         :nWidth           := 80
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := "Nombre"
         :bStrData         := {|| ::oDetProduccion:oDbfVir:FieldGetByName( "cNomArt" ) }
         :nWidth           := 400
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := "Lote"
         :bStrData         := {|| ::oDetProduccion:oDbfVir:FieldGetByName( "cLote" ) }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := "Almacén"
         :bStrData         := {|| ::oDetProduccion:oDbfVir:FieldGetByName( "cAlmOrd" ) }
         :nWidth           := 55
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := "Volumen"
         :bStrData         := {|| ::oDetProduccion:oDbfVir:FieldGetByName( "nVolumen" ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := getConfigTraslation( "Grupo familia" )
         :bStrData         := {|| AllTrim( ::oDetProduccion:oDbfVir:FieldGetByName( "cGrpFam" ) ) + Space( 1 ) + oRetFld( ::oDetProduccion:oDbfVir:FieldGetByName( "cGrpFam" ), ::oGrupoFamilia:oDbf )  }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := getConfigTraslation( "Familia" )
         :bStrData         := {|| AllTrim( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodFam" ) ) + Space( 1 ) + oRetFld( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodFam" ), ::oFam ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := getConfigTraslation( "Tipo" )
         :bStrData         := {|| AllTrim( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodTip" ) ) + Space( 1 ) + oRetFld( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodTip" ), ::oTipoArticulo:oDbf ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := getConfigTraslation( "Categoría" )
         :bStrData         := {|| AllTrim( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodCat" ) ) + Space( 1 ) + oRetFld( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodCat" ), ::oCategoria ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := getConfigTraslation( "Temporada" )
         :bStrData         := {|| AllTrim( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodTmp" ) ) + Space( 1 ) + oRetFld( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodTmp" ), ::oTemporada ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := getConfigTraslation( "Fabricante" )
         :bStrData         := {|| AllTrim( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodFab" ) ) + Space( 1 ) + oRetFld( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodFab" ), ::oFabricante:oDbf ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := getConfigTraslation( "Operación" )
         :bStrData         := {|| AllTrim( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodOpe" ) ) + Space( 1 ) + oRetFld( ::oDetProduccion:oDbfVir:FieldGetByName( "cCodOpe" ), ::oOperacion:oDbf ) } 
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := "Total unidades"
         :bEditValue       := {|| ::oDetProduccion:nUnidades( ::oDetProduccion:oDbfVir ) }
         :cEditPicture     := ::cPicUnd 
         :nWidth           := 82
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :nFootStrAlign    := AL_RIGHT
         :nFooterType      := AGGR_SUM         
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := "Precio"
         :bStrData         := {|| Trans( ::oDetProduccion:oDbfVir:FieldGetByName( "nImpOrd" ), ::cPouDiv ) }
         :nWidth           := 85
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( ::oBrwMaterialProducido:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ::oDetProduccion:nPrecio( ::oDetProduccion:oDbfVir ) }
         :cEditPicture     := ::cPorDiv
         :nWidth           := 85
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :nFootStrAlign    := AL_RIGHT
         :nFooterType      := AGGR_SUM         
      end with

      if nMode != ZOOM_MODE
         ::oBrwMaterialProducido:bLDblClick   := {|| ::oDetProduccion:Edit( ::oBrwMaterialProducido ), ::oTotProducido:Refresh(), ::oBrwMaterialProducido:Refresh() }
      else
         ::oBrwMaterialProducido:bLDblClick   := {|| ::oDetProduccion:Zoom(), ::oBrwMaterialProducido:Refresh() }
      end if

      /*
      Materias Primas----------------------------------------------------------
      */

      REDEFINE BUTTON ;
			ID 		500 ;
         OF       ::oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetMaterial:Append( ::oBrwMateriaPrima ), ::oBrwMateriaPrima:MakeTotals(), ::oTotMaterias:Refresh() )

		REDEFINE BUTTON ;
			ID 		501 ;
         OF       ::oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetMaterial:Edit( ::oBrwMateriaPrima ), ::oBrwMateriaPrima:MakeTotals(), ::oTotMaterias:Refresh() )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       ::oFld:aDialogs[2] ;
         ACTION   ( ::oDetMaterial:Zoom() )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       ::oFld:aDialogs[2] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetMaterial:Del( ::oBrwMateriaPrima ), ::oBrwMateriaPrima:MakeTotals(), ::oTotMaterias:Refresh() )

      ::oBrwMateriaPrima                  := IXBrowse():New( ::oFld:aDialogs[ 2 ] )

      ::oBrwMateriaPrima:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwMateriaPrima:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oDetMaterial:oDbfVir:SetBrowse( ::oBrwMateriaPrima )

      ::oBrwMateriaPrima:nMarqueeStyle    := 6
      ::oBrwMateriaPrima:cName            := "Materias primas produccion"

      ::oBrwMateriaPrima:bLDblClick       := { || ::oDetMaterial:Edit( ::oBrwMateriaPrima ), ::oTotMaterias:Refresh() }
      ::oBrwMateriaPrima:lFooter          := .t.

      ::oBrwMateriaPrima:CreateFromResource( 200 )
      ::oBrwMateriaPrima:MakeTotals()

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := "Número"
         :bStrData         := {|| Trans( ::oDetMaterial:oDbfVir:FieldGetByName( "nNumLin" ), "9999" ) }
         :nWidth           := 60
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := "Código"
         :bStrData         := {|| ::oDetMaterial:oDbfVir:FieldGetByName( "cCodArt" ) }
         :nWidth           := 85
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := "Nombre"
         :bStrData         := {|| ::oDetMaterial:oDbfVir:FieldGetByName( "cNomArt" ) }
         :nWidth           := 395
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := "Almacén"
         :bStrData         := {|| ::oDetMaterial:oDbfVir:FieldGetByName( "cAlmOrd" ) }
         :nWidth           := 60
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := "Volumen"
         :bStrData         := {|| ::oDetMaterial:oDbfVir:FieldGetByName( "nVolumen" ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := getConfigTraslation( "Grupo familia" )
         :bStrData         := {|| AllTrim( ::oDetMaterial:oDbfVir:FieldGetByName( "cGrpFam" ) ) + Space( 1 ) + oRetFld( ::oDetMaterial:oDbfVir:FieldGetByName( "cGrpFam" ), ::oGrupoFamilia:oDbf ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := getConfigTraslation( "Familia" )
         :bStrData         := {|| AllTrim( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodFam" ) ) + Space( 1 ) + oRetFld( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodFam" ), ::oFam ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := getConfigTraslation( "Tipo" )
         :bStrData         := {|| AllTrim( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodTip" ) ) + Space( 1 ) + oRetFld( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodTip" ), ::oTipoArticulo:oDbf ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := getConfigTraslation( "Categoría" )
         :bStrData         := {|| AllTrim( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodCat" ) ) + Space( 1 ) + oRetFld( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodCat" ), ::oCategoria ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := getConfigTraslation( "Temporada" )
         :bStrData         := {|| AllTrim( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodTmp" ) ) + Space( 1 ) + oRetFld( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodTmp" ), ::oTemporada ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := getConfigTraslation( "Fabricante" )
         :bStrData         := {|| AllTrim( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodFab" ) ) + Space( 1 ) + oRetFld( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodFab" ), ::oFabricante:oDbf ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := getConfigTraslation( "Operación" )
         :bStrData         := {|| AllTrim( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodOpe" ) ) + Space( 1 ) + oRetFld( ::oDetMaterial:oDbfVir:FieldGetByName( "cCodOpe" ), ::oOperacion:oDbf ) }
         :nWidth           := 55
         :lHide            := .t.
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := "Lote"
         :bStrData         := {|| ::oDetMaterial:oDbfVir:FieldGetByName( "cLote" ) }
         :nWidth           := 60
         :lHide            := .t.
      end with 

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := "Total unidades"
         :bEditValue       := {|| ::oDetMaterial:nUnidades( ::oDetMaterial:oDbfVir ) }
         :cEditPicture     := ::cPicUnd 
         :nWidth           := 80
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :nFootStrAlign    := AL_RIGHT
         :nFooterType      := AGGR_SUM         
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := "Precio"
         :bStrData         := {|| Trans( ::oDetMaterial:oDbfVir:nImpOrd, ::cPouDiv ) }
         :nWidth           := 85
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( ::oBrwMateriaPrima:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ::oDetMaterial:nPrecio( ::oDetMaterial:oDbfVir ) }
         :cEditPicture     := ::cPorDiv
         :nWidth           := 85
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :nFootStrAlign    := AL_RIGHT
         :nFooterType      := AGGR_SUM            
      end with

      /*
      Personal-----------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       500 ;
         OF       ::oFld:aDialogs[3] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetPersonal:Append( ::oBrwPersonal ), ::oBrwPersonal:MakeTotals(), ::oTotPersonal:Refresh() )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       ::oFld:aDialogs[3] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetPersonal:Edit( ::oBrwPersonal ), ::oBrwPersonal:MakeTotals(), ::oTotPersonal:Refresh() )

		REDEFINE BUTTON ;
         ID       502 ;
         OF       ::oFld:aDialogs[3] ;
         ACTION   ( ::oDetPersonal:Zoom(), ::oBrwPersonal:Refresh() )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       ::oFld:aDialogs[3] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetPersonal:Del( ::oBrwPersonal ), ::oBrwPersonal:MakeTotals(), ::oTotPersonal:Refresh() )

      ::oBrwPersonal                := IXBrowse():New( ::oFld:aDialogs[3] )

      ::oBrwPersonal:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwPersonal:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwPersonal:cName          := "Personal produccion"

      ::oDetPersonal:oDbfVir:SetBrowse( ::oBrwPersonal )

      ::oBrwPersonal:nMarqueeStyle  := 5

      ::oBrwPersonal:bLDblClick     := {|| ::oDetPersonal:Edit( ::oBrwPersonal ), ::oTotPersonal:Refresh() }
      ::oBrwPersonal:lFooter        := .t.

      ::oBrwPersonal:CreateFromResource( 200 )
      ::oBrwPersonal:MakeTotals()

      with object ( ::oBrwPersonal:AddCol() )
         :cHeader          := "Personal"
         :bStrData         := {|| Rtrim( ::oDetPersonal:oDbfVir:FieldGetByName( "cCodTra" ) ) + " - " + oRetFld( ::oDetPersonal:oDbfVir:FieldGetByName( "cCodTra" ), ::oOperario:oDbf ) }
         :nWidth           := 325
      end with

      with object ( ::oBrwPersonal:AddCol() )
         :cHeader          := "Operación"
         :bStrData         := {|| ::oDetPersonal:oDbfVir:FieldGetByName( "cCodOpe" ) + " - " + oRetFld( ::oDetPersonal:oDbfVir:FieldGetByName( "cCodOpe" ), ::oOperacion:oDbf ) }
         :nWidth           := 325
      end with

      with object ( ::oBrwPersonal:AddCol() )
         :cHeader          := "Tiempo empleado"
         :bEditValue       := {|| ::oDetPersonal:nHorasTrabajador( ::oDetPersonal:oDbfVir:cKeyTra, ::oDetHorasPersonal:oDbfVir ) }
         :cEditPicture     := "@E 99.99"
         :nWidth           := 110
      end with

      with object ( ::oBrwPersonal:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ::oDetPersonal:nTotalTrabajador( ::oDetPersonal:oDbfVir:cKeyTra, ::oDetHorasPersonal:oDbfVir ) }
         :cEditPicture     := ::cPorDiv
         :nWidth           := 90
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :nFootStrAlign    := AL_RIGHT
         :nFooterType      := AGGR_SUM            
      end with

      /*
      Maquinaria---------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       500 ;
         OF       ::oFld:aDialogs[4] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetMaquina:Append( ::oBrwMaquinaria ), ::oBrwMaquinaria:MakeTotals(), ::oTotMaquinaria:Refresh() )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       ::oFld:aDialogs[4] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetMaquina:Edit( ::oBrwMaquinaria ), ::oBrwMaquinaria:MakeTotals(), ::oTotMaquinaria:Refresh() )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       ::oFld:aDialogs[4] ;
         ACTION   ( ::oDetMaquina:Zoom() )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       ::oFld:aDialogs[4] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetMaquina:Del( ::oBrwMaquinaria ), ::oBrwMaquinaria:MakeTotals(), ::oTotMaquinaria:Refresh() )

      ::oBrwMaquinaria                 := IXBrowse():New( ::oFld:aDialogs[4] )

      ::oBrwMaquinaria:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwMaquinaria:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwMaquinaria:cName           := "Maquinaria produccion"

      ::oDetMaquina:oDbfVir:SetBrowse( ::oBrwMaquinaria ) 

      ::oBrwMaquinaria:nMarqueeStyle   := 5

      ::oBrwMaquinaria:bLDblClick      := {|| ::oDetMaquina:Edit( ::oBrwMaquinaria ), ::oTotMaquinaria:Refresh() }
      ::oBrwMaquinaria:lFooter         := .t.

      ::oBrwMaquinaria:CreateFromResource( 200 )
      ::oBrwMaquinaria:MakeTotals()

      with object ( ::oBrwMaquinaria:AddCol() )
         :cHeader             := "Maquina"
         :bStrData            := {|| Rtrim( ::oDetMaquina:oDbfVir:FieldGetByName( "cCodMaq" ) ) + " - " + oRetFld( ::oDetMaquina:oDbfVir:FieldGetByName( "cCodMaq" ), ::oMaquina:oDbf ) }
         :nWidth              := 645
      end with

      with object ( ::oBrwMaquinaria:AddCol() )
         :cHeader             := "Tiempo empleado"
         :bStrData            := {|| cTiempo( ::oDetMaquina:oDbfVir:FieldGetByName( "dFecIni" ), ::oDetMaquina:oDbfVir:FieldGetByName( "dFecFin" ), ::oDetMaquina:oDbfVir:FieldGetByName( "cIniMaq" ), ::oDetMaquina:oDbfVir:FieldGetByName( "cFinMaq" ) ) }
         :nWidth              := 120
      end with

      with object ( ::oBrwMaquinaria:AddCol() )
         :cHeader             := "Total"
         :bEditValue          := {|| ::oDetMaquina:nTotCosto( ::oDetMaquina:oDbfVir ) }
         :cEditPicture        := ::cPorDiv
         :nWidth              := 90
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
         :nFooterType         := AGGR_SUM            
      end with

      /*
      Totales------------------------------------------------------------------
      */

      REDEFINE SAY ::oTotProducido ;
         PROMPT   ( ::oDetProduccion:nTotal( ::oDetProduccion:oDbfVir ) ) ;
         PICTURE  ( ::cPorDiv ) ;
         ID       810 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE SAY ::oTotMaterias   ;
         PROMPT   ( ::oDetMaterial:nTotal( ::oDetMaterial:oDbfVir ) );
         PICTURE  ( ::cPorDiv ) ;
         ID       811 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE SAY ::oTotPersonal   ;
         PROMPT   ( ::oDetPersonal:nTotal( ::oDetPersonal:oDbfVir, ::oDetHorasPersonal:oDbfVir )  ) ;
         PICTURE  ( ::cPorDiv ) ;
         ID       812 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE SAY ::oTotMaquinaria ;
         PROMPT   ( ::oDetMaquina:nTotal( ::oDetMaquina:oDbfVir ) ) ;
         PICTURE  ( ::cPorDiv ) ;
         ID       813 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE SAY ::oTotParte ;
         PROMPT   ( ::nTotalParte() ) ;
         PICTURE  ( ::cPorDiv ) ;
         ID       814 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE BUTTON oBtnAtras ;
         ID       4 ;
         OF       ::oDlg ;
         ACTION   ( if( ::oFld:nOption > 1, ::oFld:SetOption( ::oFld:nOption - 1 ), ) )

      REDEFINE BUTTON oBtnAdelante ;
         ID       5 ;
         OF       ::oDlg ;
         ACTION   ( if( ::oFld:nOption < Len( ::oFld:aDialogs ), ::oFld:SetOption( ::oFld:nOption + 1 ), ) ) 

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		::oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::Save( oGetAlm, oGetSec, oGetOpe, oHorFin, nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		::oDlg ;
         ACTION   ( ::oDlg:end() )

      if nMode != ZOOM_MODE
         ::oFld:aDialogs[1]:AddFastKey( VK_F2, {|| ::oDetProduccion:Append( ::oBrwMaterialProducido ), ::oBrwMaterialProducido:MakeTotals(), ::oTotProducido:Refresh() } )
         ::oFld:aDialogs[1]:AddFastKey( VK_F3, {|| ::oDetProduccion:Edit( ::oBrwMaterialProducido ), ::oBrwMaterialProducido:MakeTotals(), ::oTotProducido:Refresh() } )
         ::oFld:aDialogs[1]:AddFastKey( VK_F4, {|| ::oDetProduccion:Del( ::oBrwMaterialProducido, ::oBrwMaterialProducido:MakeTotals(), ::oBrwMateriaPrima ) } )
         
         ::oFld:aDialogs[2]:AddFastKey( VK_F2, {|| ::oDetMaterial:Append( ::oBrwMateriaPrima ), ::oBrwMateriaPrima:MakeTotals(), ::oTotMaterias:Refresh() } )
         ::oFld:aDialogs[2]:AddFastKey( VK_F3, {|| ::oDetMaterial:Edit( ::oBrwMateriaPrima ), ::oBrwMateriaPrima:MakeTotals(), ::oTotMaterias:Refresh() } )
         ::oFld:aDialogs[2]:AddFastKey( VK_F4, {|| ::oDetMaterial:Del( ::oBrwMateriaPrima ), ::oBrwMateriaPrima:MakeTotals(), ::oTotMaterias:Refresh() } )
         
         ::oFld:aDialogs[3]:AddFastKey( VK_F2, {|| ::oDetPersonal:Append( ::oBrwPersonal ), ::oBrwPersonal:MakeTotals(), ::oTotPersonal:Refresh() } )
         ::oFld:aDialogs[3]:AddFastKey( VK_F3, {|| ::oDetPersonal:Edit( ::oBrwPersonal ), ::oBrwPersonal:MakeTotals(), ::oTotPersonal:Refresh() } )
         ::oFld:aDialogs[3]:AddFastKey( VK_F4, {|| ::oDetPersonal:Del( ::oBrwPersonal ), ::oBrwPersonal:MakeTotals(), ::oTotPersonal:Refresh() } )
         
         ::oFld:aDialogs[4]:AddFastKey( VK_F2, {|| ::oDetMaquina:Append( ::oBrwMaquinaria ), ::oBrwMaquinaria:MakeTotals(), ::oTotMaquinaria:Refresh() } )
         ::oFld:aDialogs[4]:AddFastKey( VK_F3, {|| ::oDetMaquina:Edit( ::oBrwMaquinaria ), ::oBrwMaquinaria:MakeTotals(), ::oTotMaquinaria:Refresh() } )
         ::oFld:aDialogs[4]:AddFastKey( VK_F4, {|| ::oDetMaquina:Del( ::oBrwMaquinaria ), ::oBrwMaquinaria:MakeTotals(), ::oTotMaquinaria:Refresh() } )

         ::oDlg:AddFastKey( VK_F5, {|| ::Save( oGetAlm, oGetSec, oGetOpe, oHorFin, nMode ) } )
      end if

      ::oDlg:AddFastKey( VK_F7, {|| oBtnAtras:Click() } )
      ::oDlg:AddFastKey( VK_F8, {|| oBtnAdelante:Click() } )

      ::oDlg:bStart := {|| ::StarResource( oFecIni ) }

   ACTIVATE DIALOG ::oDlg CENTER

   oFntTot:End()

   oBmpGeneral:End()

   ::oDetProduccion:oDbfVir:SetStatus()
   ::oDetMaterial:oDbfVir:SetStatus()
   ::oDetPersonal:oDbfVir:SetStatus()
   ::oDetMaquina:oDbfVir:SetStatus()

   ::oBrwMaterialProducido:CloseData()
   ::oBrwMateriaPrima:CloseData()
   ::oBrwPersonal:CloseData()
   ::oBrwMaquinaria:CloseData()

RETURN ( ::oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD StarResource( oFecIni )

   ::oBrwMaterialProducido:MakeTotals()
   ::oBrwMateriaPrima:MakeTotals()
   ::oBrwPersonal:MakeTotals()
   ::oBrwMaquinaria:MakeTotals()

   ::oBrwMaterialProducido:Load()
   ::oBrwMateriaPrima:Load()
   ::oBrwPersonal:Load()
   ::oBrwMaquinaria:Load()

   oFecIni:SetFocus()

   ::runModeAppend()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD runModeAppend() CLASS TProduccion

   if !Empty( ::bModeAppend )
      eval( ::bModeAppend )
   end if

   ::bModeAppend     := nil

Return .t.

//---------------------------------------------------------------------------//

METHOD Save( oGetAlm, oGetSec, oGetOpe, oHorFin, nMode )

   if Empty( ::oDbf:cAlmOrd )
      MsgStop( "Tiene que seleccionar un almacén." )
      ::oFld:SetOption( 1 )
      oGetAlm:SetFocus()
      Return nil
   end if

   if Empty( ::oDbf:cCodSec )
      MsgStop( "Tiene que seleccionar una sección." )
      ::oFld:SetOption( 1 )
      oGetSec:SetFocus()
      Return nil
   end if

   if Empty( ::oDbf:cCodOpe )
      MsgStop( "Tiene que seleccionar una operación." )
      ::oFld:SetOption( 1 )
      oGetOpe:SetFocus()
      Return nil
   end if

   if ::oDbf:dFecFin < ::oDbf:dFecOrd
      MsgStop( "La fecha de fin no puede ser menor que la fecha de inicio." )
      ::oFld:SetOption( 1 )
      oHorFin:SetFocus()
      Return nil
   end if

   ::oDlg:Disable()

   if ::oDbf:lRecCos
      ::CalculaCostes()
   end if   

   ::oDlg:Enable()
   ::oDlg:End( IDOK )

Return ( .t. )

//--------------------------------------------------------------------------//

METHOD LoaArticulo( oGetArticulo, oGetNombre )

   local cCodArt     := oGetArticulo:VarGet()

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      end if

      return .t.

   else

      /*
      Primero buscamos por codigos de barra
      */

      ::oArt:ordSetFocus( "CodeBar" )

      if ::oArt:Seek( cCodArt )
         cCodArt     := ::oArt:Codigo
      end if

      ::oArt:ordSetFocus( "Codigo" )

      /*
      Ahora buscamos por el codigo interno
      */

      if ::oArt:Seek( cCodArt ) .or. ::oArt:Seek( Upper( cCodArt ) )

         cCodArt     := ::oArt:Codigo

         oGetNombre:cText( ::oArt:Nombre )

         if ::oArt:nCajEnt != 0
            ::oDbf:nCajArt := ::oArt:nCajEnt
         end if

         if ::oArt:nUniCaja != 0
            ::oDbf:nUndArt := ::oArt:nUniCaja
         end if

         return .t.

      else

         MsgStop( "Artículo no encontrado" )
         return .f.

      end if

   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD GetNewCount()

   ::oDbf:nNumOrd       := nNewDoc( ::oDbf:cSerOrd, ::oDbf:nArea, "nParPrd", , ::oDbfCount:cAlias )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lTiempoEmpleado( oTmpEmp )

   ::cTiempoEmpleado    := nTiempoEntreFechas( ::oDbf:dFecOrd, ::oDbf:dFecFin, ::oDbf:cHorIni, ::oDbf:cHorFin )
   ::cTmpEmp            := cFormatoDDHHMM( ::cTiempoEmpleado )

   if oTmpEmp != nil
      oTmpEmp:cText( ::cTmpEmp )
      oTmpEmp:Refresh()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lRecargaPersonal( oCodSec, oCodOpe, oFecIni, oFecFin, oHorIni, oHorFin )

   local nOrdAnt     := ::oOperario:oDbf:OrdSetFocus( "cCodSec" )
   local nOrdAntHora := ::oDetHoras:oDbf:OrdSetFocus( "cCodTra" )
   local nOrdAntMaq  := ::oMaquina:oDbf:OrdSetFocus( "cCodSec" )
   local cCodSec     := ""
   local cCodOpe     := ""
   local dFecIni     := Ctod( "" )
   local dFecFin     := Ctod( "" )
   local cHorIni     := ""
   local cHorFin     := ""

   /*
   Comprobamos el valor que nos han cambiado y tomamos su nuevo valor
   */

   if oCodSec != nil
      cCodSec        := oCodSec:VarGet()
   end if

   if oCodOpe != nil
      cCodOpe        := oCodOpe:VarGet()
   end if

   if oFecIni != nil
      dFecIni        := oFecIni:VarGet()
   end if

   if oFecFin != nil
      dFecFin        := oFecFin:VarGet()
   end if

   if oHorIni != nil
      cHorIni        := oHorIni:VarGet()
   end if

   if oHorFin != nil
      cHorFin        := oHorFin:VarGet()
   end if

   /*Cambios en la seccion*/

   if !Empty( cCodSec ) .and. ::cOldCodSec != cCodSec

      /*
      Borramos los registros que tenemos---------------------------------------
      */

      ::oDetPersonal:oDbfVir:Zap()
      ::oDetHorasPersonal:oDbfVir:Zap()
      ::oDetMaquina:oDbfVir:Zap()

      /*
      Metemos automáticamente los operarios------------------------------------
      */

      if ::oOperario:oDbf:Seek( ::oDbf:cCodSec )

         while ::oOperario:oDbf:cCodSec == ::oDbf:cCodSec .and. !::oOperario:oDbf:Eof()

            ::oDetPersonal:oDbfVir:Append()

            ::oDetPersonal:oDbfVir:cCodTra      := ::oOperario:oDbf:cCodTra
            ::oDetPersonal:oDbfVir:cCodSec      := ::oDbf:cCodSec
            ::oDetPersonal:oDbfVir:cCodOpe      := ::oDbf:cCodOpe
            ::oDetPersonal:oDbfVir:dFecIni      := ::oDbf:dFecOrd
            ::oDetPersonal:oDbfVir:dFecFin      := ::oDbf:dFecFin
            ::oDetPersonal:oDbfVir:cHorIni      := ::oDbf:cHorIni
            ::oDetPersonal:oDbfVir:cHorFin      := ::oDbf:cHorFin

            ::oDetPersonal:oDbfVir:Save()

            ::oDetHoras:oDbf:GoTop()

            if ::oDetHoras:oDbf:Seek( ::oOperario:oDbf:cCodTra )

               while ::oDetHoras:oDbf:cCodTra == ::oOperario:oDbf:cCodTra .and. !::oDetHoras:oDbf:Eof()

                  if ::oDetHoras:oDbf:lDefHor

                     ::oDetHorasPersonal:oDbfVir:Append()

                     ::oDetHorasPersonal:oDbfVir:cCodTra := ::oOperario:oDbf:cCodTra
                     ::oDetHorasPersonal:oDbfVir:cCodHra := ::oDetHoras:oDbf:cCodHra
                     ::oDetHorasPersonal:oDbfVir:nCosHra := ::oDetHoras:oDbf:nCosHra
                     ::oDetHorasPersonal:oDbfVir:nNumHra := ::cTiempoEmpleado

                     ::oDetHorasPersonal:oDbfVir:Save()

                  end if

                  ::oDetHoras:oDbf:Skip()

               end while

            end if

            ::oOperario:oDbf:Skip()

         end while

      end if

      /*
      Metemos automáticamente la maquinaria-------------------------------------
      */

      if ::oMaquina:oDbf:Seek( ::oDbf:cCodSec )

         while ::oMaquina:oDbf:cCodSec == ::oDbf:cCodSec .and. !::oMaquina:oDbf:Eof()

            ::oDetMaquina:oDbfVir:Append()

            ::oDetMaquina:oDbfVir:cCodSec   := ::oDbf:cCodSec
            ::oDetMaquina:oDbfVir:cCodMaq   := ::oMaquina:oDbf:cCodMaq
            ::oDetMaquina:oDbfVir:dFecIni   := ::oDbf:dFecOrd
            ::oDetMaquina:oDbfVir:dFecFin   := ::oDbf:dFecFin
            ::oDetMaquina:oDbfVir:cIniMaq   := ::oDbf:cHorIni
            ::oDetMaquina:oDbfVir:cFinMaq   := ::oDbf:cHorFin
            ::oDetMaquina:oDbfVir:nCosHra   := ::oMaquina:nTotalCosteHora( ::oMaquina:oDbf:cCodMaq )
            ::oDetMaquina:oDbfVir:nTotHra   := ::cTiempoEmpleado

            ::oDetMaquina:oDbfVir:Save()

            ::oMaquina:oDbf:Skip()

         end while

      end if

      ::cOldCodSec   := cCodSec

   end if

   /*
   Cambios en la operacion-----------------------------------------------------
   */

   if !Empty( cCodOpe ) .and. ::cOldCodOpe != cCodOpe

      ::oDetPersonal:oDbfVir:GoTop()

      while !::oDetPersonal:oDbfVir:Eof()
         ::oDetPersonal:oDbfVir:FieldPutByName( "cCodOpe", cCodOpe )
         ::oDetPersonal:oDbfVir:Skip()
      end while

      ::cOldCodOpe   := cCodOpe

   end if

   /*
   Cambios en la fecha de inicio-----------------------------------------------
   */

   if !Empty( dFecIni ) .and. ::dOldFecIni != dFecIni

      /*
      Personal-----------------------------------------------------------------
      */

      ::oDetPersonal:oDbfVir:GoTop()

      while !::oDetPersonal:oDbfVir:Eof()
         ::oDetPersonal:oDbfVir:FieldPutByName( "dFecIni", dFecIni )
         ::oDetPersonal:oDbfVir:Skip()
      end while

      /*
      Horas personal------------------------------------------------------------
      */

      ::oDetHorasPersonal:oDbfVir:GoTop()

      while !::oDetHorasPersonal:oDbfVir:Eof()
         ::oDetHorasPersonal:oDbfVir:FieldPutByName( "nNumHra", ::cTiempoEmpleado )
         ::oDetHorasPersonal:oDbfVir:Skip()
      end while
      
      /*
      Maquinaria---------------------------------------------------------------
      */

      ::oDetMaquina:oDbfVir:GoTop()
      while !::oDetMaquina:oDbfVir:Eof()
         ::oDetMaquina:oDbfVir:FieldPutByName( "dFecIni", dFecIni )
         ::oDetMaquina:oDbfVir:FieldPutByName( "nTotHra", ::cTiempoEmpleado )
         ::oDetMaquina:oDbfVir:Skip()
      end while

      ::dOldFecIni   := dFecIni

   end if

   /*Cambios en la fecha de fin*/

   if !Empty( dFecFin ) .and. ::dOldFecFin != dFecFin

      /*
      Personal
      */

      ::oDetPersonal:oDbfVir:GoTop()

      while !::oDetPersonal:oDbfVir:Eof()
         ::oDetPersonal:oDbfVir:FieldPutByName( "dFecFin", dFecFin )
         ::oDetPersonal:oDbfVir:Skip()
      end while

      /*
      Horas personal
      */

      ::oDetHorasPersonal:oDbfVir:GoTop()

      while !::oDetHorasPersonal:oDbfVir:Eof()
         ::oDetHorasPersonal:oDbfVir:FieldPutByName( "nNumHra", ::cTiempoEmpleado )
         ::oDetHorasPersonal:oDbfVir:Skip()
      end while

      /*
      Maquinaria
      */

      ::oDetMaquina:oDbfVir:GoTop()

      while !::oDetMaquina:oDbfVir:Eof()
         ::oDetMaquina:oDbfVir:FieldPutByName( "dFecFin", dFecFin )
         ::oDetMaquina:oDbfVir:FieldPutByName( "nTotHra", ::cTiempoEmpleado )
         ::oDetMaquina:oDbfVir:Skip()
      end while

      ::dOldFecFin   := dFecFin

   end if

   /*
   Cambios en la hora de inicio
   */

   if !Empty( cHorIni ) .and. ::cOldHorIni != cHorIni

      /*
      Personal
      */

      ::oDetPersonal:oDbfVir:GoTop()

      while !::oDetPersonal:oDbfVir:Eof()
         ::oDetPersonal:oDbfVir:FieldPutByName( "cHorIni", cHorIni )
         ::oDetPersonal:oDbfVir:Skip()
      end while

      /*
      Horas personal
      */

      ::oDetHorasPersonal:oDbfVir:GoTop()

      while !::oDetHorasPersonal:oDbfVir:Eof()
         ::oDetHorasPersonal:oDbfVir:FieldPutByName( "nNumHra", ::cTiempoEmpleado )
         ::oDetHorasPersonal:oDbfVir:Skip()
      end while

      /*
      Maquinaria
      */

      ::oDetMaquina:oDbfVir:GoTop()

      while !::oDetMaquina:oDbfVir:Eof()
         ::oDetMaquina:oDbfVir:FieldPutByName( "cIniMaq", cHorIni )
         ::oDetMaquina:oDbfVir:FieldPutByName( "nTotHra", ::cTiempoEmpleado )
         ::oDetMaquina:oDbfVir:Skip()
      end while

      ::cOldHorIni   := cHorIni

   end if

   /*
   Cambios en la hora de fin---------------------------------------------------
   */

   if !Empty( cHorFin ) .and. ::cOldHorFin != cHorFin

      /*
      Personal-----------------------------------------------------------------
      */

      ::oDetPersonal:oDbfVir:GoTop()

      while !::oDetPersonal:oDbfVir:Eof()
         ::oDetPersonal:oDbfVir:FieldPutByName( "cHorFin", cHorFin )
         ::oDetPersonal:oDbfVir:Skip()
      end while

      /*
      Horas personal-----------------------------------------------------------
      */

      ::oDetHorasPersonal:oDbfVir:GoTop()

      while !::oDetHorasPersonal:oDbfVir:Eof()
         ::oDetHorasPersonal:oDbfVir:FieldPutByName( "nNumHra", ::cTiempoEmpleado )
         ::oDetHorasPersonal:oDbfVir:Skip()
      end while

      /*
      Maquinaria
      */

      ::oDetMaquina:oDbfVir:GoTop()

      while !::oDetMaquina:oDbfVir:Eof()
         ::oDetMaquina:oDbfVir:FieldPutByName( "cFinMaq", cHorFin )
         ::oDetMaquina:oDbfVir:FieldPutByName( "nTotHra", ::cTiempoEmpleado )
         ::oDetMaquina:oDbfVir:Skip()
      end while

      ::cOldHorFin   := cHorFin

   end if

   ::oDetHoras:oDbf:OrdSetFocus( nOrdAntHora )
   ::oOperario:oDbf:OrdSetFocus( nOrdAnt )
   ::oMaquina:oDbf:OrdSetFocus( nOrdAntMaq )

   ::oDetPersonal:oDbfVir:GoTop()
   ::oDetHorasPersonal:oDbfVir:GoTop()
   ::oDetMaquina:oDbfVir:GoTop()

   ::oTotPersonal:Refresh()
   ::oTotMaquinaria:Refresh()

   if !Empty( ::oBrwPersonal )
      ::oBrwPersonal:Refresh()
   end if

   if !Empty( ::oBrwMaquinaria )
      ::oBrwMaquinaria:Refresh()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD GenParte( nDevice, cCaption, cCodDoc, cPrinter, nCopies )

   local oInf
   local oDevice
   local cNumeroParte

   DEFAULT nDevice      := IS_PRINTER
   DEFAULT cCaption     := "Imprimiendo parte de producción"
   DEFAULT cCodDoc      := cFormatoDocumento( ::oDbf:cSerOrd, "NPARPRD", ::oDbfCount:cAlias )
   DEFAULT nCopies      := nCopiasDocumento( ::oDbf:cSerOrd, "NPARPRD", ::oDbfCount:cAlias )

   if ::oDbf:Lastrec() == 0
      Return nil
   end if

   if Empty( cCodDoc )
      cCodDoc           := if( ::oDbf:cSerOrd == "A", "POA", "POB" )
   end if

   if !lExisteDocumento( cCodDoc, ::oDbfDoc:cAlias )
      return nil
   end if

   cNumeroParte            := ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd

   ::PrepareDataReport( cNumeroParte )

   ::oDbf:GetStatus( .t. )
   ::oDbf:Seek( cNumeroParte )

   if lVisualDocumento( cCodDoc, ::oDbfDoc:cAlias )

      public cTiempoEmp    := cTiempo( ::oDbf:dFecOrd, ::oDbf:dFecFin, ::oDbf:cHorIni, ::oDbf:cHorFin )
      public nProd         := nTotProd( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, ::oDetProduccion:oDbf:cAlias )
      public nMat          := nTotMat( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, ::oDetMaterial:oDbf:cAlias )
      public nPer          := nTotPer( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, ::oDetHorasPersonal:oDbf:cAlias )
      public nMaq          := nTotMaq( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, ::oDetMaquina:oDbf:cAlias )
      public nParte        := nTotParte( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, ::oDetProduccion:oDbf:cAlias, ::oDetMaterial:oDbf:cAlias, ::oDetHorasPersonal:oDbf:cAlias, ::oDetMaquina:oDbf:cAlias )

      ::PrintReportProducc( nDevice, nCopies, cPrinter, ::oDbfDoc:cAlias )

   else 

      msgStop( "El documento no es de formato visual." )

   end if

   ::RestoreDataReport()

   ::oDbf:SetStatus()

RETURN ( NIL )

//---------------------------------------------------------------------------//

METHOD lGenParte( oBrw, oBtn, nDevice )

   local bAction

   DEFAULT nDevice   := IS_PRINTER

   if !::oDbfDoc:Seek( "PO" )

      DEFINE BTNSHELL RESOURCE "GC_DOCUMENT_WHITE_" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( msgStop( "No hay documentos predefinidos" ) );
         TOOLTIP  "No hay documentos" ;
         HOTKEY   "N";
         FROM     oBtn ;
         CLOSED ;
         LEVEL    ACC_EDIT

   else

      while ::oDbfDoc:cTipo == "PO" .AND. !::oDbfDoc:eof()

         bAction  := ::bGenParte( nDevice, "Imprimiendo parte de producción", ::oDbfDoc:Codigo )

         ::oWndBrw:NewAt( "gc_document_white_", , , bAction, Rtrim( ::oDbfDoc:cDescrip ) , , , , , oBtn )

         ::oDbfDoc:Skip()

      end do

   end if

RETURN nil

//---------------------------------------------------------------------------//

METHOD bGenParte( nDevice, cTitle, cCodDoc )

   local bGen
   local nDev        := by( nDevice )
   local cTit        := by( cTitle    )
   local cCod        := by( cCodDoc   )

   bGen              := {|| ::GenParte( nDev, cTit, cCod ) }

RETURN ( bGen )

//---------------------------------------------------------------------------//

METHOD PrepareDataReport( cNumeroParte )

   ::oDetHorasPersonal:oDbf:ordSetFocus( "cNumTra" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD RestoreDataReport()

   ::oDetHorasPersonal:oDbf:ordSetFocus( "cNumOrd" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD PrnSerie()

	local oDlg
   local oFmtDoc
   local cFmtDoc     := cSelPrimerDoc( "PO" )
   local oSayFmt
   local cSayFmt
   local oSerIni
   local oSerFin
   local nRecno      := ::oDbf:Recno()
   local nOrdAnt     := ::oDbf:OrdSetFocus( "cNumOrd" )
   local cSerIni     := ::oDbf:cSerOrd
   local cSerFin     := ::oDbf:cSerOrd
   local nDocIni     := ::oDbf:nNumOrd
   local nDocFin     := ::oDbf:nNumOrd
   local cSufIni     := ::oDbf:cSufOrd
   local cSufFin     := ::oDbf:cSufOrd
   local oPrinter
   local cPrinter    := PrnGetName()
   local lCopiasPre  := .t.
   local lInvOrden   := .f.
   local oNumCop
   local nNumCop     := nCopiasDocumento( ::oDbf:cSerOrd, "nParPrd", ::oDbfCount:cAlias )

   DEFAULT cPrinter  := PrnGetName()

   cSayFmt           := cNombreDoc( cFmtDoc )

   DEFINE DIALOG oDlg RESOURCE "IMPSERDOC" TITLE "Imprimir series de partes de producción"

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      VALID    ( cSerIni >= "A" .AND. cSerIni <= "Z"  );
      OF       oDlg

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      VALID    ( cSerFin >= "A" .AND. cSerFin <= "Z"  );
      OF       oDlg

   REDEFINE GET nDocIni;
      ID       120 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET nDocFin;
      ID       130 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      OF       oDlg

   REDEFINE GET cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
      OF       oDlg

   REDEFINE CHECKBOX lInvOrden ;
      ID       500 ;
      OF       oDlg

   REDEFINE CHECKBOX lCopiasPre ;
      ID       170 ;
      OF       oDlg

   REDEFINE GET oNumCop VAR nNumCop;
      ID       180 ;
      WHEN     !lCopiasPre ;
      VALID    nNumCop > 0 ;
		PICTURE 	"999999999" ;
      SPINNER ;
      MIN      1 ;
      MAX      99999 ;
      OF       oDlg

   REDEFINE GET oFmtDoc VAR cFmtDoc ;
      ID       90 ;
      COLOR    CLR_GET ;
      VALID    ( cDocumento( oFmtDoc, oSayFmt, ::oDbfDoc:cAlias ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwDocumento( oFmtDoc, oSayFmt, "PO" ) ) ;
      OF       oDlg

   REDEFINE GET oSayFmt VAR cSayFmt ;
      ID       91 ;
      WHEN     ( .f. );
      COLOR    CLR_GET ;
      OF       oDlg

   TBtnBmp():ReDefine( 92, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( cFmtDoc ) }, oDlg, .f., , .f.,  )

   REDEFINE GET oPrinter VAR cPrinter;
      WHEN     ( .f. ) ;
      ID       160 ;
      OF       oDlg

   TBtnBmp():ReDefine( 161, "gc_printer2_check_16",,,,,{|| PrinterPreferences( oPrinter ) }, oDlg, .f., , .f.,  )

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   (  ::StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden ),;
                  oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      ACTION   ( oDlg:end() )

   oDlg:bStart := { || oSerIni:SetFocus() }

   oDlg:AddFastKey( VK_F5, {|| ::StartPrint( SubStr( cFmtDoc, 1, 3 ), cSerIni + Str( nDocIni, 9 ) + cSufIni, cSerFin + Str( nDocFin, 9 ) + cSufFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden ), oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   ::oDbf:GoTo( nRecNo )
   ::oDbf:OrdSetFocus( nOrdAnt )

RETURN NIL

//--------------------------------------------------------------------------//

METHOD StartPrint( cFmtDoc, cDocIni, cDocFin, oDlg, cPrinter, lCopiasPre, nNumCop, lInvOrden )

   oDlg:disable()

   if !lInvOrden

      ::oDbf:Seek( cDocIni, .t. )

      while ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd >= cDocIni .AND. ;
            ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd <= cDocFin

         if lCopiasPre

            ::nGenParte( IS_PRINTER, "Imprimiendo documento : " + ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, cFmtDoc, cPrinter, nCopiasDocumento( ::oDbf:cSerOrd, "NPARPRD", ::oDbfCount:cAlias ) )

         else

            ::nGenParte( IS_PRINTER, "Imprimiendo documento : " + ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, cFmtDoc, cPrinter, nNumCop )

         end if

         ::oDbf:Skip( 1 )

      end do

   else

      ::oDbf:Seek( cDocFin )

      while ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd >= cDocIni .and.;
            ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd <= cDocFin .and.;
            !::oDbf:Bof()

         if lCopiasPre

            ::nGenParte( IS_PRINTER, "Imprimiendo documento : " + ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, cFmtDoc, cPrinter, nCopiasDocumento( ::oDbf:cSerOrd, "NPARPRD", ::oDbfCount:cAlias ) )

         else

            ::nGenParte( IS_PRINTER, "Imprimiendo documento : " + ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, cFmtDoc, cPrinter, nNumCop )

         end if

         ::oDbf:Skip( -1 )

      end while

   end if

   oDlg:enable()

RETURN NIL

//---------------------------------------------------------------------------//

METHOD nGenParte( nDevice, cTitle, cCodDoc, cPrinter, nCopy )

   local nImpYet     := 1

   DEFAULT nDevice   := IS_PRINTER
   DEFAULT nCopy     := nCopiasDocumento( , "NPARPRD", ::oDbfCount:cAlias )

   nCopy             := Max( nCopy, 1 )

   while nImpYet <= nCopy
      ::GenParte( nDevice, cTitle, cCodDoc, cPrinter )
      nImpYet++
   end while

return nil

//---------------------------------------------------------------------------//

METHOD DefineCalculate()

   ::aCal  := {}

   aAdd( ::aCal, { "cTiempo( (cDbf)->dFecOrd, (cDbf)->dFecFin, (cDbf)->cHorIni, (cDbf)->cHorFin )",   "C", 50, 0, "Tiempo empleado",      "",           "" } )
   aAdd( ::aCal, { "nTotProd( (cDbf)->cSerOrd + Str((cDbf)->nNumOrd) + (cDbf)->cSufOrd, cDetPro )",   "N", 16, 6, "Total producido",      "cPouDivPro", "" } )
   aAdd( ::aCal, { "nTotMat( (cDbf)->cSerOrd + Str((cDbf)->nNumOrd) + (cDbf)->cSufOrd, cDetMat )",    "N", 16, 6, "Total materias primas","cPouDivPro", "" } )
   aAdd( ::aCal, { "nTotPer( (cDbf)->cSerOrd + Str((cDbf)->nNumOrd) + (cDbf)->cSufOrd, cDetHPer )",   "N", 16, 6, "Total personal",       "cPouDivPro", "" } )
   aAdd( ::aCal, { "nTotMaq( (cDbf)->cSerOrd + Str((cDbf)->nNumOrd) + (cDbf)->cSufOrd, cDetMaq )",    "N", 16, 6, "Total maquinaria",     "cPouDivPro", "" } )
   aAdd( ::aCal, { "nTotParte((cDbf)->cSerOrd + Str((cDbf)->nNumOrd) + (cDbf)->cSufOrd,cDetPro,cDetMat,cDethPer,cDetMaq)", "N", 16, 6, "Total Parte",     "cPouDivPro", "" } )

RETURN ( ::aCal )

//---------------------------------------------------------------------------//

METHOD RecSiguente( oBrw )

   local lAppend
   local lTrigger
   local aAnterior   := { ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, ::oDbf:dFecFin, ::oDbf:cHorFin, ::oDbf:cCodSec }

   if( ::oWndBrw != nil, ::oWndBrw:Maximize(), )

   if ::bOnPreAppend != nil
      lTrigger       := Eval( ::bOnPreAppend, Self )
      if Valtype( lTrigger ) == "L" .and. !lTrigger
         return .f.
      end if
   end if

   ::oDbf:Blank()
   ::oDbf:SetDefault()

   ::LoadDetails( .f. )

   lAppend           := ::Resource( 1, aAnterior )

   if lAppend

      ::GetNewCount()

      ::oDbf:Insert()

      ::SaveDetails( APPD_MODE )

      if( ::oWndBrw != nil, ::oWndBrw:Refresh(), )

   else

      ::oDbf:Cancel()

      if( ::oWndBrw != nil, ::oWndBrw:Refresh(), )

   end if

   ::CancelDetails()

   if ::bOnPostAppend != nil
      Eval( ::bOnPostAppend, Self )
   end if

   oBrw:Refresh()

RETURN ( lAppend )

//---------------------------------------------------------------------------//

METHOD EditDocumentToday( oBrw ) CLASS TProduccion

   ::oDbf:GetStatus()
   ::oDbf:OrdSetFocus( "cNumOrd" )

   if ::oDbf:Seek( ::getDocumentToday() )
      ::Edit()
   else
      MsgStop( "No se ha podido editar el documento" )
   end if

   ::oDbf:SetStatus()

Return .t.

//---------------------------------------------------------------------------//

METHOD getDocumentToday() CLASS TProduccion

   local documentToday     := ""
   
   ::oDbf:GetStatus()
   ::oDbf:OrdSetFocus( "dFecOrd" )

   if ::oDbf:Seek( dtos( GetSysDate() ) )
      documentToday        := ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd
   end if

   ::oDbf:SetStatus()

Return ( documentToday )

//---------------------------------------------------------------------------//

METHOD AppendMateriaPrima() CLASS TProduccion

   ::bModeAppend   := {|| ::modeMateriaPrima() }

   ::AppendDocumentToday()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD AppendElaborado() CLASS TProduccion

   ::bModeAppend   := {|| ::modeElaborado() }

   ::AppendDocumentToday()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD modeMateriaPrima() CLASS TProduccion

   ::oFld:SetOption( 2 )

   ::oDetMaterial:Append( ::oBrwMateriaPrima )
   ::oBrwMateriaPrima:MakeTotals()
   ::oTotMaterias:Refresh()

Return .t.

//---------------------------------------------------------------------------//

METHOD modeElaborado() CLASS TProduccion

   ::oDetProduccion:Append( ::oBrwMaterialProducido )
   ::oBrwMaterialProducido:MakeTotals()
   ::oTotProducido:Refresh()

Return .t.

//---------------------------------------------------------------------------//

METHOD CargaPersonalAnterior( aDatosAnterior )

   local nOrdAnt     := ::oDetHorasPersonal:oDbf:OrdSetFocus( "cNumOrd" )

   /*Pasamos el personal*/

   ::oDetPersonal:oDbf:GoTop()

   if ::oDetPersonal:oDbf:Seek( aDatosAnterior[1] )

      while ::oDetPersonal:oDbf:cSerOrd + Str( ::oDetPersonal:oDbf:nNumOrd ) + ::oDetPersonal:oDbf:cSufOrd == aDatosAnterior[1] .and.;
            !::oDetPersonal:oDbf:Eof()

         ::oDetPersonal:oDbfVir:Append()

         ::oDetPersonal:oDbfVir:cCodTra   := ::oDetPersonal:oDbf:cCodTra
         ::oDetPersonal:oDbfVir:cCodSec   := ::oDbf:cCodSec
         ::oDetPersonal:oDbfVir:cCodOpe   := ::oDbf:cCodOpe
         ::oDetPersonal:oDbfVir:dFecIni   := ::oDbf:dFecOrd
         ::oDetPersonal:oDbfVir:dFecFin   := ::oDbf:dFecFin
         ::oDetPersonal:oDbfVir:cHorIni   := ::oDbf:cHorIni
         ::oDetPersonal:oDbfVir:cHorFin   := ::oDbf:cHorFin

         ::oDetPersonal:oDbfVir:Save()

         ::oDetPersonal:oDbf:Skip()

      end while

   end if

   /*Pasamos las horas de personal*/

   ::oDetHorasPersonal:oDbf:GoTop()

   if ::oDetHorasPersonal:oDbf:Seek( aDatosAnterior[1] )

      while ::oDetHorasPersonal:oDbf:cSerOrd + Str( ::oDetHorasPersonal:oDbf:nNumOrd ) + ::oDetHorasPersonal:oDbf:cSufOrd == aDatosAnterior[1] .and.;
            !::oDetHorasPersonal:oDbf:Eof()

         ::oDetHorasPersonal:oDbfVir:Append()

         ::oDetHorasPersonal:oDbfVir:cCodTra    :=  ::oDetHorasPersonal:oDbf:cCodTra
         ::oDetHorasPersonal:oDbfVir:cCodHra    :=  ::oDetHorasPersonal:oDbf:cCodHra
         ::oDetHorasPersonal:oDbfVir:nNumHra    :=  nTiempoEntreFechas( ::oDbf:dFecOrd, ::oDbf:dFecFin, ::oDbf:cHorIni, ::oDbf:cHorFin )
         ::oDetHorasPersonal:oDbfVir:nCosHra    :=  ::oDetHorasPersonal:oDbf:nCosHra

         ::oDetHorasPersonal:oDbfVir:Save()

         ::oDetHorasPersonal:oDbf:Skip()

      end while

   end if

   /*Pasamos las maquinarias*/

   ::oDetMaquina:oDbf:GoTop()

   if ::oDetMaquina:oDbf:Seek( aDatosAnterior[1] )

      while ::oDetMaquina:oDbf:cSerOrd + Str( ::oDetMaquina:oDbf:nNumOrd ) + ::oDetMaquina:oDbf:cSufOrd == aDatosAnterior[1] .and.;
            !::oDetMaquina:oDbf:Eof()

         ::oDetMaquina:oDbfVir:Append()

         ::oDetMaquina:oDbfVir:cCodSec    := ::oDbf:cCodSec
         ::oDetMaquina:oDbfVir:cCodMaq    := ::oDetMaquina:oDbf:cCodMaq
         ::oDetMaquina:oDbfVir:dFecIni    := ::oDbf:dFecOrd
         ::oDetMaquina:oDbfVir:dFecFin    := ::oDbf:dFecFin
         ::oDetMaquina:oDbfVir:cIniMaq    := ::oDbf:cHorIni
         ::oDetMaquina:oDbfVir:cFinMaq    := ::oDbf:cHorFin
         ::oDetMaquina:oDbfVir:nCosHra    := ::oDetMaquina:oDbf:nCosHra
         ::oDetMaquina:oDbfVir:nTotHra    := nTiempoEntreFechas( ::oDbf:dFecOrd, ::oDbf:dFecFin, ::oDbf:cHorIni, ::oDbf:cHorFin )

         ::oDetMaquina:oDbfVir:Save()

         ::oDetMaquina:oDbf:Skip()

      end while

   end if

   ::oDetHorasPersonal:oDbf:OrdSetFocus( nOrdAnt )

   ::oDetPersonal:oDbfVir:GoTop()
   ::oDetHorasPersonal:oDbfVir:GoTop()
   ::oDetMaquina:oDbfVir:GoTop()

RETURN( Self )

//---------------------------------------------------------------------------//
/*
Devuelve el total producido----------------------------------------------------
*/

function nTotProd( cNumParte, cDetPro )

   local nTotal := 0

   if ( cDetPro )->( dbSeek( cNumParte ) )

      while ( cDetPro )->cSerOrd + Str( ( cDetPro )->nNumOrd ) + ( cDetPro )->cSufOrd == cNumParte .and. !( cDetPro )->( Eof() )

         nTotal += ( NotCaja( ( cDetPro )->nCajOrd ) * ( cDetPro )->nUndOrd ) * ( cDetPro )->nImpOrd

         ( cDetPro )->( dbSkip() )

      end while

   end if

RETURN nTotal

//---------------------------------------------------------------------------//
/*
Devuelve el total materias primas----------------------------------------------
*/

function nTotMat( cNumParte, cDetMat )

   local nTotal := 0

   ( cDetMat )->( dbGoTop() )

   if ( cDetMat )->( dbSeek( cNumParte ) )

      while ( cDetMat )->cSerOrd + Str( ( cDetMat )->nNumOrd ) + ( cDetMat )->cSufOrd == cNumParte .and. !( cDetMat )->( Eof() )

         nTotal += ( NotCaja( ( cDetMat )->nCajOrd ) * ( cDetMat )->nUndOrd ) * ( cDetMat )->nImpOrd

         ( cDetMat )->( dbSkip() )

      end while

   end if

RETURN nTotal

//---------------------------------------------------------------------------//
/*
Devuelve el total de personal--------------------------------------------------
*/

function nTotPer( cNumParte, cDetHPer )

   local nTotal   := 0

   ( cDetHPer )->( dbGoTop() )

   if ( cDetHPer )->( dbSeek( cNumParte ) )

      while ( cDetHPer )->cSerOrd + Str( ( cDetHPer )->nNumOrd ) + ( cDetHPer )->cSufOrd == cNumParte .and. !( cDetHPer )->( Eof() )

         nTotal += ( cDetHPer )->nNumHra * ( cDetHPer )->nCosHra

         ( cDetHPer )->( dbSkip() )

      end while

   end if


Return nTotal

//---------------------------------------------------------------------------//
/*
Devuelve el total maquinas-----------------------------------------------------
*/

function nTotMaq( cNumParte, cDetMaq )

   local nTotal := 0

   ( cDetMaq )->( dbGoTop() )

   if ( cDetMaq )->( dbSeek( cNumParte ) )

      while ( cDetMaq )->cSerOrd + Str( ( cDetMaq )->nNumOrd ) + ( cDetMaq )->cSufOrd == cNumParte .and. !( cDetMaq )->( Eof() )

         nTotal += ( cDetMaq )->nTotHra * ( cDetMaq )->nCosHra

         ( cDetMaq )->( dbSkip() )

      end while

   end if

RETURN nTotal

//---------------------------------------------------------------------------//
/*
Devuelve el total del parte de producción--------------------------------------
*/

function nTotParte( cNumParte, cDetPro, cDetMat, cDetHPer, cDetMaq )

   local nToTal := 0

   nTotal   += nTotProd( cNumParte, cDetPro )
   nTotal   += nTotMat( cNumParte, cDetMat )
   nTotal   += nTotPer( cNumParte, cDetHPer )
   nTotal   += nTotMaq( cNumParte, cDetMaq )

RETURN nTotal

//---------------------------------------------------------------------------//

Function cNombreTipo( cCodTipo )

   local cNombreTipo := ""

   do case
      case cCodTipo == "PR"
         cNombreTipo := "Artículos producidos"
      case cCodTipo == "MP"
         cNombreTipo := "Materias primas"
      case cCodTipo == "OP"
         cNombreTipo := "Operarios"
      case cCodTipo == "MQ"
         cNombreTipo := "Maquinaria"
   end case

RETURN ( cNombreTipo )

//---------------------------------------------------------------------------//

Function cTiempo( dFecIni, dFecFin, cHorIni, cHorFin )

Return cFormatoDDHHMM( nTiempoEntreFechas( dFecIni, dFecFin, cHorIni, cHorFin ) )

//---------------------------------------------------------------------------//

METHOD nTotalProducido( cDocumento, oDbf )

   local nTotal   := 0
   local nRec
   local nOrdAnt

   DEFAULT oDbf   := ::oDetProduccion:oDbf 

   nRec           := oDbf:Recno()
   nOrdAnt        := oDbf:OrdSetFocus( "cNumOrd" )

   if oDbf:Seek( cDocumento )

      while oDbf:cSerOrd + Str( oDbf:nNumOrd ) + oDbf:cSufOrd == cDocumento .and. !oDbf:Eof()

         nTotal   += ( NotCaja( oDbf:nCajOrd ) * oDbf:nUndOrd ) * oDbf:nImpOrd

         oDbf:Skip()

      end while

   end while

   oDbf:OrdSetFocus( nOrdAnt )
   oDbf:GoTo( nRec )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotalUnidadesProducido( cDocumento, oDbf )

   local nTotal   := 0
   local nRec     
   local nOrdAnt  

   DEFAULT oDbf   := ::oDetProduccion:oDbf

   nRec           := oDbf:Recno()
   nOrdAnt        := oDbf:OrdSetFocus( "cNumOrd" )

   if oDbf:Seek( cDocumento )

      while oDbf:cSerOrd + Str( oDbf:nNumOrd ) + oDbf:cSufOrd == cDocumento .and. !oDbf:Eof()

         nTotal   += TDetProduccion():nUnidades( oDbf ) // ( NotCaja( oDbf:nCajOrd ) * oDbf:nUndOrd )

         oDbf:Skip()

      end while

   end while

   oDbf:OrdSetFocus( nOrdAnt )
   oDbf:GoTo( nRec )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotalMaterial( cDocumento, oDbf )

   local nTotal   := 0
   local nRec     
   local nOrdAnt 

   DEFAULT oDbf   :=  ::oDetMaterial:oDbf 

   nRec     := oDbf:Recno()
   nOrdAnt  := oDbf:OrdSetFocus( "cNumOrd" )

   if oDbf:Seek( cDocumento )

      while oDbf:cSerOrd + Str( oDbf:nNumOrd ) + oDbf:cSufOrd == cDocumento .and. !oDbf:Eof()

         nTotal   += ( NotCaja( oDbf:nCajOrd ) * oDbf:nUndOrd ) * oDbf:nImpOrd

        oDbf:Skip()

      end while

   end if 

   oDbf:OrdSetFocus( nOrdAnt )
   oDbf:GoTo( nRec )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nHorasPersonal( cDocumento )

   local nTotal   := 0
   local nRec     := ::oDetPersonal:oDbf:Recno()
   local nOrdAnt  := ::oDetPersonal:oDbf:OrdSetFocus( "cNumOrd" )
   local nRecLin  := ::oDetHorasPersonal:oDbf:Recno()
   local nOrdLin  := ::oDetHorasPersonal:oDbf:OrdSetFocus( "cNumOrd" )

   ::oDetPersonal:oDbf:GoTop()
   ::oDetHorasPersonal:oDbf:GoTop()

   if ::oDetPersonal:oDbf:Seek( cDocumento )

      while ::oDetPersonal:oDbf:cSerOrd + Str( ::oDetPersonal:oDbf:nNumOrd ) + ::oDetPersonal:oDbf:cSufOrd == cDocumento .and. !::oDetPersonal:oDbf:Eof()

         if ::oDetHorasPersonal:oDbf:Seek( ::oDetPersonal:oDbf:cSerOrd + Str( ::oDetPersonal:oDbf:nNumOrd ) + ::oDetPersonal:oDbf:cSufOrd + ::oDetPersonal:oDbf:cCodTra )

            while ::oDetPersonal:oDbf:cSerOrd + Str( ::oDetPersonal:oDbf:nNumOrd ) + ::oDetPersonal:oDbf:cSufOrd + ::oDetPersonal:oDbf:cCodTra == ::oDetHorasPersonal:oDbf:cSerOrd + Str( ::oDetHorasPersonal:oDbf:nNumOrd ) + ::oDetHorasPersonal:oDbf:cSufOrd + ::oDetHorasPersonal:oDbf:cCodTra .and. ;
                  !::oDetHorasPersonal:oDbf:Eof()

               nTotal   += ::oDetHorasPersonal:oDbf:nNumHra 

               ::oDetHorasPersonal:oDbf:Skip()

            end while

         end if

         ::oDetPersonal:oDbf:Skip()

      end while

   end if

   ::oDetHorasPersonal:oDbf:OrdSetFocus( nOrdLin )
   ::oDetHorasPersonal:oDbf:GoTo( nRecLin )
   ::oDetPersonal:oDbf:OrdSetFocus( nOrdAnt )
   ::oDetPersonal:oDbf:GoTo( nRec )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotalPersonal( cDocumento, oDbfPers, oDbfHorasPers )

   local nTotal            := 0
   local nRec    
   local nOrdAnt 
   local nRecLin 
   local nOrdLin 

   DEFAULT oDbfPers        := ::oDetPersonal:oDbf
   DEFAULT oDbfHorasPers   := ::oDetHorasPersonal:oDbf

   nRec                    := oDbfPers:Recno()
   nOrdAnt                 := oDbfPers:OrdSetFocus( "cNumOrd" )
   nRecLin                 := oDbfHorasPers:Recno()
   nOrdLin                 := oDbfHorasPers:OrdSetFocus( "cNumTra" )

   oDbfPers:GoTop()
   oDbfHorasPers:GoTop()

   if oDbfPers:Seek( cDocumento )

      while oDbfPers:cSerOrd + Str( oDbfPers:nNumOrd ) + oDbfPers:cSufOrd == cDocumento .and. !oDbfPers:Eof()

         if oDbfHorasPers:Seek( oDbfPers:cSerOrd + Str( oDbfPers:nNumOrd ) + oDbfPers:cSufOrd + oDbfPers:cCodTra )

            while oDbfHorasPers:cSerOrd + Str( oDbfHorasPers:nNumOrd ) + oDbfHorasPers:cSufOrd + oDbfHorasPers:cCodTra == oDbfPers:cSerOrd + Str( oDbfPers:nNumOrd ) + oDbfPers:cSufOrd + oDbfPers:cCodTra .and. ;
                  !oDbfHorasPers:Eof()

               nTotal   += oDbfHorasPers:nNumHra * oDbfHorasPers:nCosHra

               oDbfHorasPers:Skip()

            end while

         end if

         oDbfPers:Skip()

      end while

   end if

   oDbfHorasPers:OrdSetFocus( nOrdLin )
   oDbfHorasPers:GoTo( nRecLin )
   oDbfPers:OrdSetFocus( nOrdAnt )
   oDbfPers:GoTo( nRec )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotalMaquina( cDocumento, oDbf )

   local nTotal   := 0
   local nRec     
   local nOrdAnt  

   DEFAULT oDbf   := ::oDetMaquina:oDbf

   nRec           := oDbf:Recno()
   nOrdAnt        := oDbf:OrdSetFocus( "cNumOrd" )

   if oDbf:Seek( cDocumento )

      while oDbf:cSerOrd + Str( oDbf:nNumOrd ) + oDbf:cSufOrd == cDocumento.and. !oDbf:Eof()

         nTotal   += oDbf:nTotHra * oDbf:nCosHra

         oDbf:Skip()

      end while

   end if 

   oDbf:OrdSetFocus( nOrdAnt )
   oDbf:GoTo( nRec )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotalOperario( cDocOpe )

   local nTotal   := 0
   local nRec     := ::oDetHorasPersonal:oDbf:Recno()
   local nOrdAnt  := ::oDetHorasPersonal:oDbf:OrdSetFocus( "cNumOrd" )

   if ::oDetHorasPersonal:oDbf:Seek( cDocOpe )

      while ::oDetHorasPersonal:oDbf:cSerOrd + Str( ::oDetHorasPersonal:oDbf:nNumOrd ) + ::oDetHorasPersonal:oDbf:cSufOrd + ::oDetHorasPersonal:oDbf:cCodTra == cDocOpe .and. !::oDetHorasPersonal:oDbf:Eof()

         nTotal   += ::oDetHorasPersonal:oDbf:nNumHra * ::oDetHorasPersonal:oDbf:nCosHra

         ::oDetHorasPersonal:oDbf:Skip()

      end while

   end if

   ::oDetHorasPersonal:oDbf:OrdSetFocus( nOrdAnt )
   ::oDetHorasPersonal:oDbf:GoTo( nRec )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotalVolumen( cDocumento )

   local nTotal   := 0
   local nRec     := ::oDetProduccion:oDbf:Recno()
   local nOrdAnt  := ::oDetProduccion:oDbf:OrdSetFocus( "cNumOrd" )

   if ::oDetProduccion:oDbf:Seek( cDocumento )

      while ::oDetProduccion:oDbf:cSerOrd + Str( ::oDetProduccion:oDbf:nNumOrd ) + ::oDetProduccion:oDbf:cSufOrd == cDocumento .and.;
            !::oDetProduccion:oDbf:Eof()

         nTotal   += ( NotCaja( ::oDetProduccion:oDbf:nCajOrd ) * ::oDetProduccion:oDbf:nUndOrd ) * ::oDetProduccion:oDbf:nVolumen

         ::oDetProduccion:oDbf:Skip()

      end while

   end if

   ::oDetProduccion:oDbf:OrdSetFocus( nOrdAnt )
   ::oDetProduccion:oDbf:GoTo( nRec )

RETURN ( nTotal )

//---------------------------------------------------------------------------//
/*
Funcion para editar un parte desde fuera de la clase
*/

function EditProduccion( cNumParte, oBrw )

   local oProduccion

   oProduccion    :=  TProduccion():New( cPatEmp() )

   if oProduccion:OpenFiles()

      if oProduccion:oDbf:SeekInOrd( cNumParte, "cNumOrd" )

         oProduccion:Edit( oBrw )

      end if

      oProduccion:CloseFiles()

   end if

   if oProduccion != nil
      oProduccion:End()
   end if

return .t.

//---------------------------------------------------------------------------//
/*funcion para hacer zoom un parte desde fuera de la clase*/

function ZoomProduccion( cNumParte, oBrw )

   local oProduccion

   oProduccion    :=  TProduccion():New( cPatEmp() )

   if oProduccion:OpenFiles()

      if oProduccion:oDbf:SeekInOrd( cNumParte, "cNumOrd" )

         oProduccion:Zoom( oBrw )

      end if

      oProduccion:CloseFiles()

   end if

   if oProduccion != nil
      oProduccion:End()
   end if

return .t.

//---------------------------------------------------------------------------//
/*funcion para eliminar un parte desde fuera de la clase*/

function DelProduccion( cNumParte, oBrw )

   local oProduccion

   oProduccion    :=  TProduccion():New( cPatEmp() )

   if oProduccion:OpenFiles()

      if oProduccion:oDbf:SeekInOrd( cNumParte, "cNumOrd" )

         oProduccion:Del()

      end if

      oProduccion:CloseFiles()

   end if

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

   if oProduccion != nil
      oProduccion:End()
   end if

return .t.

//---------------------------------------------------------------------------//
/*funcion para imprimir un parte desde fuera de la clase*/

function PrnProduccion( cNumParte )

   local oProduccion

   oProduccion    :=  TProduccion():New( cPatEmp() )

   if oProduccion:OpenFiles()

      if oProduccion:oDbf:SeekInOrd( cNumParte, "cNumOrd" )

         oProduccion:GenParte( IS_PRINTER )

      end if

      oProduccion:CloseFiles()

   end if

   if oProduccion != nil
      oProduccion:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*
funcion para visualizar un parte desde fuera de la clase
*/

function VisProduccion( cNumParte )

   local oProduccion

   oProduccion    :=  TProduccion():New( cPatEmp() )

   if oProduccion:OpenFiles()

      if oProduccion:oDbf:SeekInOrd( cNumParte, "cNumOrd" )

         oProduccion:GenParte( IS_SCREEN )

      end if

      oProduccion:CloseFiles()

   end if

   if oProduccion != nil
      oProduccion:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CalculaCostes()     

   local nCoste      := 0

   nCoste            := ::nTotalParte() / ::oDetProduccion:nTotalUnidades( ::oDetProduccion:oDbfVir )
   nCoste            := Round( nCoste, ::nDouDiv )

   ::oDetProduccion:oDbfVir:GetStatus()
   ::oDetProduccion:oDbfVir:GoTop()

   while ( !::oDetProduccion:oDbfVir:Eof() )
      ::oDetProduccion:oDbfVir:FieldPutByName( "nImpOrd", nCoste )
      ::oDetProduccion:oDbfVir:Skip()
   end while

   ::oDetProduccion:oDbfVir:GetStatus()

RETURN ( nCoste )

//---------------------------------------------------------------------------//

METHOD DataReport( oFr )

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Producción", ::oDbf:nArea, .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Producción", cObjectsToReport( ::oDbf ) )

   oFr:SetWorkArea(     "Lineas de material producido", ::oDetProduccion:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de material producido", cObjectsToReport( ::oDetProduccion:oDbf ) )

   oFr:SetWorkArea(     "Lineas de materias primas", ::oDetMaterial:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de materias primas", cObjectsToReport( ::oDetMaterial:oDbf ) )

   oFr:SetWorkArea(     "Lineas de personal", ::oDetPersonal:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de personal", cObjectsToReport( ::oDetPersonal:oDbf ) )

   oFr:SetWorkArea(     "Lineas de horas de personal", ::oDetHorasPersonal:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de horas de personal", cObjectsToReport( ::oDetHorasPersonal:oDbf ) )

   oFr:SetWorkArea(     "Lineas de maquinaria", ::oDetMaquina:oDbf:nArea )
   oFr:SetFieldAliases( "Lineas de maquinaria", cObjectsToReport( ::oDetMaquina:oDbf ) )

   oFr:SetWorkArea(     "Empresa", ::oDbfEmp:nArea )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Almacenes", ::oAlm:nArea )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Sección", ::oSeccion:oDbf:nArea )
   oFr:SetFieldAliases( "Sección", cObjectsToReport( ::oSeccion:oDbf ) )

   oFr:SetWorkArea(     "Operación", ::oOperacion:oDbf:nArea )
   oFr:SetFieldAliases( "Operación", cObjectsToReport( ::oOperacion:oDbf ) )

   oFr:SetWorkArea(     "Operarios", ::oOperario:oDbf:nArea )
   oFr:SetFieldAliases( "Operarios", cObjectsToReport( ::oOperario:oDbf ) )

   oFr:SetWorkArea(     "Tipos.Lineas de material producido", ::oTipoArticulo:oDbf:nArea )
   oFr:SetFieldAliases( "Tipos.Lineas de material producido", cObjectsToReport( ::oTipoArticulo:oDbf ) )

   oFr:SetWorkArea(     "Tipos.Lineas de materias primas", ::oTipoArticulo:oDbf:nArea )
   oFr:SetFieldAliases( "Tipos.Lineas de materias primas", cObjectsToReport( ::oTipoArticulo:oDbf ) )

   oFr:SetWorkArea(     "Artículos.Lineas de material producido", ::oArt:nArea )
   oFr:SetFieldAliases( "Artículos.Lineas de material producido", cItemsToReport( aItmArt() ) )

   oFr:SetWorkArea(     "Artículos.Lineas de materias primas", ::oArt:nArea )
   oFr:SetFieldAliases( "Artículos.Lineas de materias primas", cItemsToReport( aItmArt() ) )

   /*
   Relaciones------------------------------------------------------------------
   */

   oFr:SetMasterDetail( "Producción", "Lineas de material producido",      {|| ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd } )
   oFr:SetMasterDetail( "Producción", "Lineas de materias primas",         {|| ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd } )
   oFr:SetMasterDetail( "Producción", "Lineas de personal",                {|| ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd } )
   oFr:SetMasterDetail( "Producción", "Lineas de maquinaria",              {|| ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd } )
   oFr:SetMasterDetail( "Producción", "Lineas de producción",              {|| ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd } )

   oFr:SetMasterDetail( "Producción", "Empresa",                              {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Producción", "Almacenes",                            {|| ::oDbf:cAlmOrd } )
   oFr:SetMasterDetail( "Producción", "Sección",                              {|| ::oDbf:cCodSec } )
   oFr:SetMasterDetail( "Producción", "Operación",                            {|| ::oDbf:cCodOpe } )
   
   oFr:SetMasterDetail( "Lineas de material producido", "Artículos.Lineas de material producido",  {|| ::oDetProduccion:oDbf:cCodArt } )  
   oFr:SetMasterDetail( "Lineas de material producido", "Tipos.Lineas de material producido",      {|| ::oDetProduccion:oDbf:cCodTip } )  

   oFr:SetMasterDetail( "Lineas de materias primas", "Artículos.Lineas de materias primas",        {|| ::oDetMaterial:oDbf:cCodArt } )
   oFr:SetMasterDetail( "Lineas de materias primas", "Tipos.Lineas de materias primas",            {|| ::oDetMaterial:oDbf:cCodTip } )

   oFr:SetMasterDetail( "Lineas de personal", "Operarios",                    {|| ::oDetPersonal:oDbf:cCodTra } )

   oFr:SetMasterDetail( "Lineas de personal", "Lineas de horas de personal",  {|| ::oDetPersonal:oDbf:cSerOrd + Str( ::oDetPersonal:oDbf:nNumOrd ) + ::oDetPersonal:oDbf:cSufOrd + ::oDetPersonal:oDbf:cCodTra } )

   /*
   Sincronizaciones------------------------------------------------------------
   */

   oFr:SetResyncPair(   "Producción", "Lineas de material producido" )
   oFr:SetResyncPair(   "Producción", "Lineas de materias primas" )
   oFr:SetResyncPair(   "Producción", "Lineas de personal" )
   oFr:SetResyncPair(   "Producción", "Lineas de maquinaria" )
   oFr:SetResyncPair(   "Producción", "Lineas de producción" )
   oFr:SetResyncPair(   "Producción", "Empresa" )
   oFr:SetResyncPair(   "Producción", "Almacenes" )
   oFr:SetResyncPair(   "Producción", "Sección" )
   oFr:SetResyncPair(   "Producción", "Operación" )

   oFr:SetResyncPair(   "Lineas de material producido", "Artículos.Lineas de material producido" )  
   oFr:SetResyncPair(   "Lineas de material producido", "Tipos.Lineas de material producido" )  

   oFr:SetResyncPair(   "Lineas de materias primas", "Artículos.Lineas de materias primas" )
   oFr:SetResyncPair(   "Lineas de materias primas", "Tipos.Lineas de material producido" )

   oFr:SetResyncPair(   "Lineas de personal", "Operarios" )

   oFr:SetResyncPair(   "Lineas de personal", "Lineas de horas de personal" )

Return nil

//---------------------------------------------------------------------------//

METHOD VariableReport( oFr )

   oFr:DeleteCategory(  "Producción" )

   /*
   Creación de variables----------------------------------------------------
   */

   oFr:AddVariable(     "Producción",   "Tiempo empleado",          "GetHbVar('cTiempoEmp')" )
   oFr:AddVariable(     "Producción",   "Total producido",          "GetHbVar('nProd')" )
   oFr:AddVariable(     "Producción",   "Total materias primas",    "GetHbVar('nMat')" )
   oFr:AddVariable(     "Producción",   "Total personal",           "GetHbVar('nPer')" )
   oFr:AddVariable(     "Producción",   "Total maquinaria",         "GetHbVar('nMaq')" )
   oFr:AddVariable(     "Producción",   "Total parte de trabajo",   "GetHbVar('nParte')" )

Return nil

//---------------------------------------------------------------------------//

METHOD DesignReportProducc( oFr, dbfDoc )

   if ::OpenFiles()

      public cTiempoEmp    := cTiempo( ::oDbf:dFecOrd, ::oDbf:dFecFin, ::oDbf:cHorIni, ::oDbf:cHorFin )
      public nProd         := nTotProd( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, ::oDetProduccion:oDbf:cAlias )
      public nMat          := nTotMat( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, ::oDetMaterial:oDbf:cAlias )
      public nPer          := nTotPer( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, ::oDetHorasPersonal:oDbf:cAlias )
      public nMaq          := nTotMaq( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, ::oDetMaquina:oDbf:cAlias )
      public nParte        := nTotParte( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd, ::oDetProduccion:oDbf:cAlias, ::oDetMaterial:oDbf:cAlias, ::oDetHorasPersonal:oDbf:cAlias, ::oDetMaquina:oDbf:cAlias )

      ::PrepareDataReport()

      /*
      Zona de datos------------------------------------------------------------
      */
    

      ::DataReport( oFr )

      /*
      Paginas y bandas---------------------------------------------------------
      */

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFr:SetProperty(     "Report",            "ScriptLanguage", "PascalScript" )

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "CabeceraDocumento", "MainPage", frxPageHeader )
         oFr:SetProperty(     "CabeceraDocumento", "Top", 0 )
         oFr:SetProperty(     "CabeceraDocumento", "Height", 200 )

         oFr:AddBand(         "MasterData",  "MainPage", frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top", 200 )
         oFr:SetProperty(     "MasterData",  "Height", 0 )
         oFr:SetProperty(     "MasterData",  "StartNewPage", .t. )
         oFr:SetObjProperty(  "MasterData",  "DataSet", "Producción" )

         oFr:AddBand(         "DetalleColumnas",   "MainPage", frxDetailData  )
         oFr:SetProperty(     "DetalleColumnas",   "Top", 230 )
         oFr:SetProperty(     "DetalleColumnas",   "Height", 28 )
         oFr:SetObjProperty(  "DetalleColumnas",   "DataSet", "Lineas de producción" )
         oFr:SetProperty(     "DetalleColumnas",   "OnMasterDetail", "DetalleOnMasterDetail" )

         oFr:AddBand(         "PieDocumento",      "MainPage", frxPageFooter )
         oFr:SetProperty(     "PieDocumento",      "Top", 930 )
         oFr:SetProperty(     "PieDocumento",      "Height", 110 )

      end if

      /*
      Zona de variables--------------------------------------------------------
      */

      ::VariableReport( oFr )

      /*
      Diseño de report---------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el diseñador----------------------------------------------------
      */

      oFr:DestroyFr()

      /*
      Cierra ficheros----------------------------------------------------------
      */

      ::RestoreDataReport()

      ::CloseFiles()

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD PrintReportProducc( nDevice, nCopies, cPrinter, dbfDoc )

   local oFr

   DEFAULT nDevice      := IS_SCREEN
   DEFAULT nCopies      := 1
   DEFAULT cPrinter     := PrnGetName()

   SysRefresh()

   oFr                  := frReportManager():New()

   oFr:LoadLangRes(     "Spanish.Xml" )

   oFr:SetIcon( 1 )

   oFr:SetTitle(        "Diseñador de documentos" )

   /*
   Manejador de eventos--------------------------------------------------------
   */

   oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

   /*
   Zona de datos---------------------------------------------------------------
   */

   ::oDetMaterial:oDbf:GetStatus()
   ::oDetMaterial:oDbf:OrdSetFocus( "cCodTip" )

   ::DataReport( oFr )

   /*
   Cargar el informe-----------------------------------------------------------
   */

   if !Empty( ( dbfDoc )->mReport )

      oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      /*
      Zona de variables--------------------------------------------------------
      */

      ::VariableReport( oFr )

      /*
      Preparar el report-------------------------------------------------------
      */

      oFr:PrepareReport()

      /*
      Imprimir el informe------------------------------------------------------
      */

      do case
         case nDevice == IS_SCREEN
            oFr:ShowPreparedReport()

         case nDevice == IS_PRINTER
            oFr:PrintOptions:SetPrinter( cPrinter )
            oFr:PrintOptions:SetCopies( nCopies )
            oFr:PrintOptions:SetShowDialog( .f. )
            oFr:Print()

         case nDevice == IS_PDF
            oFr:SetProperty(  "PDFExport", "EmbeddedFonts",    .t. )
            oFr:SetProperty(  "PDFExport", "PrintOptimized",   .t. )
            oFr:SetProperty(  "PDFExport", "Outline",          .t. )
            oFr:DoExport(     "PDFExport" )

      end case

   end if

   ::oDetMaterial:oDbf:SetStatus()

   /*
   Destruye el diseñador-------------------------------------------------------
   */

   oFr:DestroyFr()

Return .t.

//---------------------------------------------------------------------------//

Function AppProduccion()

   local oProduccion

   oProduccion           := TProduccion():New( cPatEmp() )

   if oProduccion:OpenFiles()

      oProduccion:Append()

      oProduccion:CloseFiles()

   end if

   if oProduccion != nil
      oProduccion:End()
   end if

return .t.

//---------------------------------------------------------------------------//
/*
Métodos para imprimir etiquetas desde------------------------------------------
*/
//---------------------------------------------------------------------------//
   
METHOD InitLabel() CLASS TProduccion

   local oError
   local oBlock

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nRecno             := ::oDbf:Recno()

      ::cSerieInicio       := ::oDbf:cSerOrd
      ::cSerieFin          := ::oDbf:cSerOrd

      if Empty( ::cSerieInicio )
         ::cSerieInicio    := "A"
      end if   

      if Empty( ::cSerieFin )
         ::cSerieFin       := "A"
      end if

      ::nDocumentoInicio   := ::oDbf:nNumOrd
      ::nDocumentoFin      := ::oDbf:nNumOrd

      ::cSufijoInicio      := ::oDbf:cSufOrd
      ::cSufijoFin         := ::oDbf:cSufOrd

      ::cFormatoLabel      := GetPvProfString( "Etiquetas", "Produccion", Space( 3 ), cPatEmp() + "Empresa.Ini" )
      
      if len( ::cFormatoLabel ) < 3
         ::cFormatoLabel   := Space( 3 )
      end if

      ::nMtrLabel          := 0

      ::nFilaInicio        := 1
      ::nColumnaInicio     := 1

      ::nCantidadLabels    := 1
      ::nUnidadesLabels    := 1

      ::aSearch            := { "Código", "Nombre" }

      ::lErrorOnCreate     := .f.

   RECOVER USING oError

      ::lErrorOnCreate     := .t.

      msgStop( "Error en la creación de generador de etiquetas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

Return ( Self )

//--------------------------------------------------------------------------//

Method CreateAsistenteEtiquetas() CLASS TProduccion

   local oBtnPrp
   local oBtnMod
   local oBtnZoo
   local oGetOrd
   local cGetOrd     := Space( 100 )
   local oCbxOrd
   local cCbxOrd     := "Código"
   local aCbxOrd     := { "Código", "Nombre" }

   /*
   Cargamos valores por defecto------------------------------------------------
   */

   ::InitLabel()

   if !::lErrorOnCreate .and. ::lCreateAuxiliar()

      DEFINE DIALOG ::oDlgLbl RESOURCE "SelectLabels_0"

         REDEFINE PAGES ::oFldLbl ;
            ID       10;
            OF       ::oDlgLbl ;
            DIALOGS  "SelectLabels_1",;
                     "SelectLabels_2"
         
         /*
         Bitmap-------------------------------------------------------------------
         */

         REDEFINE BITMAP ;
            RESOURCE "gc_portable_barcode_scanner_48" ;
            ID       500 ;
            TRANSPARENT ;
            OF       ::oDlgLbl ;

         REDEFINE GET ::oSerieInicio VAR ::cSerieInicio ;
            ID       100 ;
            PICTURE  "@!" ;
            SPINNER ;
            ON UP    ( UpSerie( ::oSerieInicio ) );
            ON DOWN  ( DwSerie( ::oSerieInicio ) );
            VALID    ( ::cSerieInicio >= "A" .and. ::cSerieInicio <= "Z" );
            UPDATE ;
            OF       ::oFldLbl:aDialogs[ 1 ]

         REDEFINE GET ::oSerieFin VAR ::cSerieFin ;
            ID       110 ;
            PICTURE  "@!" ;
            SPINNER ;
            ON UP    ( UpSerie( ::oSerieFin ) );
            ON DOWN  ( DwSerie( ::oSerieFin ) );
            VALID    ( ::cSerieFin >= "A" .and. ::cSerieFin <= "Z" );
            UPDATE ;
            OF       ::oFldLbl:aDialogs[ 1 ]

         REDEFINE GET ::nDocumentoInicio ;
            ID       120 ;
            PICTURE  "999999999" ;
            SPINNER ;
            OF       ::oFldLbl:aDialogs[ 1 ]

         REDEFINE GET ::nDocumentoFin ;
            ID       130 ;
            PICTURE  "999999999" ;
            SPINNER ;
            OF       ::oFldLbl:aDialogs[ 1 ]

         REDEFINE GET ::cSufijoInicio ;
            ID       140 ;
            PICTURE  "##" ;
            OF       ::oFldLbl:aDialogs[ 1 ]

         REDEFINE GET ::cSufijoFin ;
            ID       150 ;
            PICTURE  "##" ;
            OF       ::oFldLbl:aDialogs[ 1 ]

         REDEFINE GET ::nFilaInicio ;
            ID       180 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFldLbl:aDialogs[ 1 ]

         REDEFINE GET ::nColumnaInicio ;
            ID       190 ;
            PICTURE  "999" ;
            SPINNER ;
            OF       ::oFldLbl:aDialogs[ 1 ]

         REDEFINE GET ::oFormatoLabel VAR ::cFormatoLabel ;
            ID       160 ;
            IDTEXT   161 ;
            BITMAP   "LUPA" ;
            OF       ::oFldLbl:aDialogs[ 1 ]

            ::oFormatoLabel:bValid  := {|| cDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, ::oDbfDoc:cAlias, "LP" ) }
            ::oFormatoLabel:bHelp   := {|| BrwDocumento( ::oFormatoLabel, ::oFormatoLabel:oHelpText, "LP" ) }

         TBtnBmp():ReDefine( 220, "gc_document_text_pencil_12",,,,, {|| EdtDocumento( ::cFormatoLabel ) }, ::oFldLbl:aDialogs[ 1 ], .f., , .f., "Modificar formato de etiquetas" )

         REDEFINE RADIO ::nCantidadLabels ;
            ID       200, 201 ;
            OF       ::oFldLbl:aDialogs[ 1 ]

         REDEFINE GET ::nUnidadesLabels ;
            ID       210 ;
            PICTURE  "99999" ;
            SPINNER ;
            MIN      1 ;
            MAX      99999 ;
            WHEN     ( ::nCantidadLabels == 2 ) ;
            OF       ::oFldLbl:aDialogs[ 1 ]

         /*
         Segunda caja de dialogo--------------------------------------------------
         */

         REDEFINE GET oGetOrd ;
            VAR      cGetOrd ;
            ID       200 ;
            BITMAP   "FIND" ;
            OF       ::oFldLbl:aDialogs[ 2 ]

         oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwLabel, ::cAreaTmpLabel ) }
         oGetOrd:bValid    := {|| ::cAreaTmpLabel:OrdScope( 0, nil ), ::cAreaTmpLabel:OrdScope( 1, nil ), ::oBrwLabel:Refresh(), .t. }

         REDEFINE COMBOBOX oCbxOrd ;
            VAR      cCbxOrd ;
            ID       210 ;
            ITEMS    aCbxOrd ;
            OF       ::oFldLbl:aDialogs[ 2 ]

         oCbxOrd:bChange   := {|| ::SelectColumn( oCbxOrd ) }

         REDEFINE BUTTON ;
            ID       100 ;
            OF       ::oFldLbl:aDialogs[ 2 ] ;
            ACTION   ( ::PutLabel() )

         REDEFINE BUTTON ;
            ID       110 ;
            OF       ::oFldLbl:aDialogs[ 2 ] ;
            ACTION   ( ::SelectAllLabels( .t. ) )

         REDEFINE BUTTON ;
            ID       120 ;
            OF       ::oFldLbl:aDialogs[ 2 ] ;
            ACTION   ( ::SelectAllLabels( .f. ) )

         REDEFINE BUTTON ;
            ID       130 ;
            OF       ::oFldLbl:aDialogs[ 2 ] ;
            ACTION   ( ::AddLabel() )

         REDEFINE BUTTON ;
            ID       140 ;
            OF       ::oFldLbl:aDialogs[ 2 ] ;
            ACTION   ( ::DelLabel() )

         REDEFINE BUTTON ;
            ID       150 ;
            OF       ::oFldLbl:aDialogs[ 2 ] ;
            ACTION   ( ::EditLabel() )

         REDEFINE BUTTON oBtnPrp ;
            ID       220 ;
            OF       ::oFldLbl:aDialogs[ 2 ] ;
            ACTION   ( nil )

         REDEFINE BUTTON oBtnMod;
            ID       160 ;
            OF       ::oFldLbl:aDialogs[ 2 ] ;
            ACTION   ( nil )

         REDEFINE BUTTON oBtnZoo;
            ID       165 ;
            OF       ::oFldLbl:aDialogs[ 2 ] ;
            ACTION   ( nil )

         ::oBrwLabel                 := IXBrowse():New( ::oFldLbl:aDialogs[ 2 ] )

         ::cAreaTmpLabel:SetBrowse( ::oBrwLabel ) 

         ::oBrwLabel:nMarqueeStyle   := 5
         ::oBrwLabel:nColSel         := 2

         ::oBrwLabel:lHScroll        := .f.

         ::oBrwLabel:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         ::oBrwLabel:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
         ::oBrwLabel:bLDblClick      := {|| ::PutLabel() }

         ::oBrwLabel:CreateFromResource( 180 )

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Sl. Seleccionada"
            :bEditValue       := {|| ::cAreaTmpLabel:lLabel }
            :nWidth           := 20
            :SetCheck( { "Sel16", "Nil16" } )
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Código"
            :bEditValue       := {|| ::cAreaTmpLabel:cCodigo }
            :nWidth           := 80
            :cSortOrder       := "cRef"
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Nombre"
            :bEditValue       := {|| ::cAreaTmpLabel:cNombre }
            :nWidth           := 250
            :cSortOrder       := "cDetalle"
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Prp. 1"
            :bEditValue       := {|| ::cAreaTmpLabel:cValPr1 }
            :nWidth           := 40
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "Prp. 2"
            :bEditValue       := {|| ::cAreaTmpLabel:cValPr2 }
            :nWidth           := 40
         end with

         with object ( ::oBrwLabel:AddCol() )
            :cHeader          := "N. etiquetas"
            :bEditValue       := {|| ::cAreaTmpLabel:nLabel }
            :cEditPicture     := "@E 99,999"
            :nWidth           := 80
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nEditType        := 1
            :bOnPostEdit      := {|o,x| ::cAreaTmpLabel:nLabel := x, ::oBrwLabel:Refresh() }
         end with

   REDEFINE APOLOMETER ::oMtrLabel ;
            VAR      ::nMtrLabel ;
            PROMPT   "" ;
            ID       190 ;
            OF       ::oFldLbl:aDialogs[ 2 ] ;
            TOTAL    ::cAreaTmpLabel:Lastrec()

         ::oMtrLabel:nClrText   := rgb( 128,255,0 )
         ::oMtrLabel:nClrBar    := rgb( 128,255,0 )
         ::oMtrLabel:nClrBText  := rgb( 128,255,0 )

         /*
         Botones generales--------------------------------------------------------
         */

         REDEFINE BUTTON ::oBtnListado ;          // Boton anterior
            ID       40 ;
            OF       ::oDlgLbl ;
            ACTION   ( ::BotonAnterior() )

         REDEFINE BUTTON ::oBtnAnterior ;          // Boton anterior
            ID       20 ;
            OF       ::oDlgLbl ;
            ACTION   ( ::BotonAnterior() )

         REDEFINE BUTTON ::oBtnSiguiente ;         // Boton de Siguiente
            ID       30 ;
            OF       ::oDlgLbl ;
            ACTION   ( ::BotonSiguiente() )

         REDEFINE BUTTON ::oBtnCancel ;            // Boton de Siguiente
            ID       IDCANCEL ;
            OF       ::oDlgLbl ;
            ACTION   ( ::oDlgLbl:End() )

      ::oDlgLbl:bStart  := {|| ::oBtnListado:Hide(), ::oBtnAnterior:Hide(), ::oFormatoLabel:lValid(), oBtnMod:Hide(), oBtnZoo:Hide(), oBtnPrp:Hide() }

      ACTIVATE DIALOG ::oDlgLbl CENTER

      ::EndAsistenteEtiquetas()

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method EndAsistenteEtiquetas() CLASS TProduccion

   ::DestroyAuxiliar()

   WritePProString( "Etiquetas", "Produccion", ::cFormatoLabel, cPatEmp() + "Empresa.Ini" )

Return ( Self )

//---------------------------------------------------------------------------//

Method BotonAnterior() CLASS TProduccion

   ::oFldLbl:GoPrev()

   ::oBtnAnterior:Hide()

   SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonSiguiente() CLASS TProduccion

   do case
      case ::oFldLbl:nOption == 1

         if Empty( ::cFormatoLabel )

            MsgStop( "Debe cumplimentar un formato de etiquetas" )

         else

            ::LoadAuxiliar()

            ::oFldLbl:GoNext()
            ::oBtnAnterior:Show()
            SetWindowText( ::oBtnSiguiente:hWnd, "&Terminar" )

         end if

      case ::oFldLbl:nOption == 2

         if ::lPrintLabels( ::oDbfDoc:cAlias )

            SetWindowText( ::oBtnCancel:hWnd, "&Cerrar" )

         end if

   end case

Return ( Self )

//--------------------------------------------------------------------------//

Method lCreateAuxiliar() CLASS TProduccion

   local oBlock
   local oError
   local lCreateAuxiliar   := .t.

   /*oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE*/

   /*
   Creo y activo la base de datos temporal-------------------------------------
   */

   if Empty( ::cAreaTmpLabel )
      ::DefineAuxiliar()
   end if

   ::cAreaTmpLabel:Activate( .f., .f. )

   /*
   Cargo los valores en la base se datos temporal------------------------------
   */

   ::LoadAuxiliar() 

   /*RECOVER USING oError

      lCreateAuxiliar      := .f.

      MsgStop( 'Imposible crear fichero temporal' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )*/

Return ( lCreateAuxiliar )

//--------------------------------------------------------------------------//

METHOD DefineAuxiliar()

   ::cFileTmpLabel      := cGetNewFileName( cPatTmp() + "AuxLbl" )

   DEFINE DATABASE ::cAreaTmpLabel FILE ( ::cFileTmpLabel ) CLASS "AuxLbl" ALIAS "AuxLbl" PATH ( cPatTmp() ) VIA ( cLocalDriver() )COMMENT "material producido"

      FIELD NAME "cSerOrd"    TYPE "C" LEN  01  DEC 0 COMMENT "Serie"                                    OF ::cAreaTmpLabel
      FIELD NAME "nNumOrd"    TYPE "N" LEN  09  DEC 0 COMMENT "Número"                                   OF ::cAreaTmpLabel
      FIELD NAME "cSufOrd"    TYPE "C" LEN  02  DEC 0 COMMENT "Sufijo"                                   OF ::cAreaTmpLabel
      FIELD NAME "cCodigo"    TYPE "C" LEN  18  DEC 0 COMMENT "Código"                                   OF ::cAreaTmpLabel
      FIELD NAME "cNombre"    TYPE "C" LEN 100  DEC 0 COMMENT "Nombre"                                   OF ::cAreaTmpLabel
      FIELD NAME "cTxtSer"    TYPE "M" LEN  10  DEC 0 COMMENT "Series"                                   OF ::cAreaTmpLabel
      FIELD NAME "cCodAlm"    TYPE "C" LEN  16  DEC 0 COMMENT "Almacén"                                  OF ::cAreaTmpLabel
      FIELD NAME "cCodSec"    TYPE "C" LEN  03  DEC 0 COMMENT "Sección"                                  OF ::cAreaTmpLabel
      FIELD NAME "cCodOpe"    TYPE "C" LEN  03  DEC 0 COMMENT "Operación"                                OF ::cAreaTmpLabel
      FIELD NAME "dFecIni"    TYPE "D" LEN  08  DEC 0 COMMENT "Fecha inicio"                             OF ::cAreaTmpLabel
      FIELD NAME "dFecFin"    TYPE "D" LEN  08  DEC 0 COMMENT "Fecha fin"                                OF ::cAreaTmpLabel
      FIELD NAME "cHorIni"    TYPE "C" LEN  06  DEC 0 COMMENT "Hora de inicio" PICTURE "@R 99:99:99"        OF ::cAreaTmpLabel
      FIELD NAME "cHorFin"    TYPE "C" LEN  06  DEC 0 COMMENT "Hora de fin"    PICTURE "@R 99:99:99"        OF ::cAreaTmpLabel
      FIELD NAME "nCajas"     TYPE "N" LEN  16  DEC 6 COMMENT "Cajas"                                    OF ::cAreaTmpLabel
      FIELD NAME "nUnidades"  TYPE "N" LEN  16  DEC 6 COMMENT "Unidades"                                 OF ::cAreaTmpLabel
      FIELD NAME "nUndHra"    TYPE "N" LEN  16  DEC 6 COMMENT "Tot. und/hra"                             OF ::cAreaTmpLabel
      FIELD NAME "nImporte"   TYPE "N" LEN  16  DEC 6 COMMENT "Importe"                                  OF ::cAreaTmpLabel
      FIELD NAME "nTotLin"    TYPE "N" LEN  16  DEC 6 COMMENT "Total línea"                              OF ::cAreaTmpLabel
      FIELD NAME "nPeso"      TYPE "N" LEN  16  DEC 6 COMMENT "Peso del artículo"                        OF ::cAreaTmpLabel
      FIELD NAME "cUndPes"    TYPE "C" LEN  02  DEC 0 COMMENT "Unidad del peso"                          OF ::cAreaTmpLabel
      FIELD NAME "nVolumen"   TYPE "N" LEN  16  DEC 6 COMMENT "Volumen del artículo"                     OF ::cAreaTmpLabel
      FIELD NAME "cUndVol"    TYPE "C" LEN  02  DEC 0 COMMENT "Unidad del volumen"                       OF ::cAreaTmpLabel
      FIELD NAME "cCodPr1"    TYPE "C" LEN  20  DEC 0 COMMENT "Código de primera propiedad"              OF ::cAreaTmpLabel
      FIELD NAME "cCodPr2"    TYPE "C" LEN  20  DEC 0 COMMENT "Código de segunda propiedad"              OF ::cAreaTmpLabel
      FIELD NAME "cValPr1"    TYPE "C" LEN  20  DEC 0 COMMENT "Valor de primera propiedad"               OF ::cAreaTmpLabel
      FIELD NAME "cValPr2"    TYPE "C" LEN  20  DEC 0 COMMENT "Valor de segunda propiedad"               OF ::cAreaTmpLabel
      FIELD NAME "lLote"      TYPE "L" LEN  01  DEC 0 COMMENT "Lógico lote"                              OF ::cAreaTmpLabel
      FIELD NAME "cLote"      TYPE "C" LEN  14  DEC 0 COMMENT "Lote"                                     OF ::cAreaTmpLabel
      FIELD NAME "dFecCad"    TYPE "D" LEN  08  DEC 0 COMMENT "Fecha caducidad"                          OF ::cAreaTmpLabel
      FIELD NAME "lLabel"     TYPE "L" LEN   1  DEC 0 COMMENT "Lógico para marca de etiquetas"           OF ::cAreaTmpLabel
      FIELD NAME "nLabel"     TYPE "N" LEN   6  DEC 0 COMMENT "Unidades de etiquetas a imprimir"         OF ::cAreaTmpLabel

      INDEX TO ( ::cFileTmpLabel ) TAG "cNumOrd" ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd"   COMMENT "Número"    NODELETED OF ::cAreaTmpLabel

   END DATABASE ::cAreaTmpLabel

RETURN ( ::cAreaTmpLabel )

//---------------------------------------------------------------------------//

Method DestroyAuxiliar() CLASS TProduccion

   if !Empty( ::cAreaTmpLabel ) .and. ::cAreaTmpLabel:Used()
      ::cAreaTmpLabel:End()
   end if

   dbfErase( ::cFileTmpLabel )

   ::cAreaTmpLabel := nil

Return ( nil )

//--------------------------------------------------------------------------//

Method LoadAuxiliar() CLASS TProduccion

   local nRecPr         := ::oDetProduccion:oDbf:Recno()
   local nOrdPR         := ::oDetProduccion:oDbf:OrdSetFocus( "cNumOrd" )

   /*
   Limpiamos la base de datos temporal-----------------------------------------
   */

   ::cAreaTmpLabel:Zap()

   /*
   Metemos las líneas con los materiales producidos----------------------------
   */

   ::oDetProduccion:oDbf:GoTop()

   if ::oDetProduccion:oDbf:Seek( ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio )

      while ::oDetProduccion:oDbf:cSerOrd + Str( ::oDetProduccion:oDbf:nNumOrd ) + ::oDetProduccion:oDbf:cSufOrd >= ::cSerieInicio + Str( ::nDocumentoInicio, 9 ) + ::cSufijoInicio .and.;
            ::oDetProduccion:oDbf:cSerOrd + Str( ::oDetProduccion:oDbf:nNumOrd ) + ::oDetProduccion:oDbf:cSufOrd >= ::cSerieFin + Str( ::nDocumentoFin, 9 ) + ::cSufijoFin .and.;
            !::oDetProduccion:oDbf:Eof()

         if !Empty( ::oDetProduccion:oDbf:cCodArt )

            ::cAreaTmpLabel:Append()

            ::cAreaTmpLabel:cSerOrd     := ::oDbf:cSerOrd
            ::cAreaTmpLabel:nNumOrd     := ::oDbf:nNumOrd
            ::cAreaTmpLabel:cSufOrd     := ::oDbf:cSufOrd
            ::cAreaTmpLabel:cCodigo     := ::oDetProduccion:oDbf:cCodArt
            ::cAreaTmpLabel:cNombre     := ::oDetProduccion:oDbf:cNomArt
            ::cAreaTmpLabel:cTxtSer     := SerialDescrip( ::oDetProduccion:oDbf:cSerOrd + Str( ::oDetProduccion:oDbf:nNumOrd ) + ::oDetProduccion:oDbf:cSufOrd + Str( ::oDetProduccion:oDbf:nNumLin ), ::oDetSeriesProduccion:oDbf:cAlias )
            ::cAreaTmpLabel:cCodAlm     := ::oDetProduccion:oDbf:cAlmOrd
            ::cAreaTmpLabel:cCodSec     := Space(3)
            ::cAreaTmpLabel:cCodOpe     := Space(3)
            ::cAreaTmpLabel:dFecIni     := ::oDbf:dFecOrd
            ::cAreaTmpLabel:dFecFin     := ::oDbf:dFecFin
            ::cAreaTmpLabel:cHorIni     := ::oDbf:cHorIni
            ::cAreaTmpLabel:cHorFin     := ::oDbf:cHorFin
            ::cAreaTmpLabel:nCajas      := ::oDetProduccion:oDbf:nCajOrd
            ::cAreaTmpLabel:nUnidades   := ::oDetProduccion:oDbf:nUndOrd
            ::cAreaTmpLabel:nUndHra     := ::oDetProduccion:oDbf:nCajOrd * ::oDetProduccion:oDbf:nUndOrd
            ::cAreaTmpLabel:nImporte    := ::oDetProduccion:oDbf:nImpOrd
            ::cAreaTmpLabel:nTotLin     := ::oDetProduccion:oDbf:nCajOrd * ::oDetProduccion:oDbf:nUndOrd * ::oDetProduccion:oDbf:nImpOrd
            ::cAreaTmpLabel:nPeso       := ::oDetProduccion:oDbf:nPeso
            ::cAreaTmpLabel:cUndPes     := ::oDetProduccion:oDbf:cUndPes
            ::cAreaTmpLabel:nVolumen    := ::oDetProduccion:oDbf:nVolumen
            ::cAreaTmpLabel:cUndVol     := ::oDetProduccion:oDbf:cUndVol
            ::cAreaTmpLabel:cCodPr1     := ::oDetProduccion:oDbf:cCodPr1
            ::cAreaTmpLabel:cCodPr2     := ::oDetProduccion:oDbf:cCodPr2
            ::cAreaTmpLabel:cValPr1     := ::oDetProduccion:oDbf:cValPr1
            ::cAreaTmpLabel:cValPr2     := ::oDetProduccion:oDbf:cValPr2
            ::cAreaTmpLabel:lLote       := ::oDetProduccion:oDbf:lLote
            ::cAreaTmpLabel:cLote       := ::oDetProduccion:oDbf:cLote
            ::cAreaTmpLabel:dFecCad     := ::oDetProduccion:oDbf:dFecCad 
            ::cAreaTmpLabel:lLabel      := .t.

            if ::nCantidadLabels == 1
               ::cAreaTmpLabel:nLabel   := ::oDetProduccion:oDbf:nCajOrd * ::oDetProduccion:oDbf:nUndOrd
            else
               ::cAreaTmpLabel:nLabel   := ::nUnidadesLabels
            end if

            ::cAreaTmpLabel:Save()

         end if   

         ::oDetProduccion:oDbf:Skip()

      end while

   end if

   ::oDetProduccion:oDbf:OrdSetFocus( nOrdPR )
   ::oDetProduccion:oDbf:Goto( nRecPr )
   
   ::cAreaTmpLabel:GoTop()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD PutLabel() CLASS TProduccion

   ::cAreaTmpLabel:lLabel   := !::cAreaTmpLabel:lLabel

   ::oBrwLabel:Refresh()
   ::oBrwLabel:Select()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelectAllLabels( lSelect ) CLASS TProduccion

   local n        := 0
   local nRecno   := ::cAreaTmpLabel:Recno()

   CursorWait()

   ::cAreaTmpLabel:GoTop()
   while !::cAreaTmpLabel:Eof()

      ::cAreaTmpLabel:lLabel := lSelect

      ::cAreaTmpLabel:Skip()

      ::oMtrLabel:Set( ++n )

   end while

   ::cAreaTmpLabel:GoTo( nRecno )

   ::oBrwLabel:Refresh()

   ::oMtrLabel:Set( 0 )
   ::oMtrLabel:Refresh()

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD AddLabel() CLASS TProduccion

   ::cAreaTmpLabel:nLabel++

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD DelLabel() CLASS TProduccion

   if ::cAreaTmpLabel:nLabel > 1
      ::cAreaTmpLabel:nLabel--
   end if

   ::oBrwLabel:Refresh()
   ::oBrwLabel:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD EditLabel() CLASS TProduccion

   ::oBrwLabel:aCols[ 6 ]:Edit()

Return ( Self )

//---------------------------------------------------------------------------//

Method SelectColumn( oCombo ) CLASS TProduccion

   local oCol
   local cOrd                    := oCombo:VarGet()

   if ::oBrwLabel != nil

      with object ::oBrwLabel

         for each oCol in :aCols

            if Equal( cOrd, oCol:cHeader )
               oCol:cOrder       := "A"
               oCol:SetOrder()
            else
               oCol:cOrder       := " "
            end if

         next

      end with

      ::oBrwLabel:Refresh()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DesignLabelProducc( oFr, dbfDoc ) CLASS TProduccion

   local oLabel   := ::InitLabel()

   if !oLabel:lErrorOnCreate .and. ::lPrepareDataReportLbl( .t. )

      /*
      Zona de datos---------------------------------------------------------
      */

      ::DataLabel( oFr, .f. )

      /*
      Paginas y bandas------------------------------------------------------
      */

      if !Empty( ( dbfDoc )->mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

      else

         oFr:AddPage(         "MainPage" )

         oFr:AddBand(         "MasterData",  "MainPage",       frxMasterData )
         oFr:SetProperty(     "MasterData",  "Top",            200 )
         oFr:SetProperty(     "MasterData",  "Height",         100 )
         oFr:SetObjProperty(  "MasterData",  "DataSet",        "Lineas de producción" )

      end if

      /*
      Diseño de report------------------------------------------------------
      */

      oFr:DesignReport()

      /*
      Destruye el diseñador-------------------------------------------------
      */

      oFr:DestroyFr()

      /*
      Cierra ficheros-------------------------------------------------------
      */

      ::RestoreDataReportLbl()

      oLabel:End()

   else

      Return .f.

   end if

Return .t.

//---------------------------------------------------------------------------//

Method lPrintLabels( dbfDoc ) CLASS TProduccion

   local oFr

   local nCopies      := 1
   local nDevice      := IS_SCREEN
   local cPrinter     := PrnGetName()

   if ::lPrepareDataReportLbl()

      SysRefresh()

      oFr             := frReportManager():New()

      oFr:LoadLangRes(     "Spanish.Xml" )

      oFr:SetIcon( 1 )

      oFr:SetTitle(        "Diseñador de documentos" )

      /*
      Manejador de eventos--------------------------------------------------------
      */

      oFr:SetEventHandler( "Designer", "OnSaveReport", {|| oFr:SaveToBlob( ( dbfDoc )->( Select() ), "mReport" ) } )

      /*
      Zona de datos---------------------------------------------------------------
      */

      ::DataLabel( oFr, .t. )

      /*
      Cargar el informe-----------------------------------------------------------
      */

      if !Empty( ::oDbfDoc:mReport )

         oFr:LoadFromBlob( ( dbfDoc )->( Select() ), "mReport")

         /*
         Zona de variables--------------------------------------------------------
         */

         ::PrepareTemporalLbl( oFr )

         /*
         Preparar el report-------------------------------------------------------
         */

         oFr:PrepareReport()

         /*
         Imprimir el informe------------------------------------------------------
         */

         do case
            case nDevice == IS_SCREEN
               oFr:ShowPreparedReport()

            case nDevice == IS_PRINTER
               oFr:PrintOptions:SetPrinter( cPrinter )
               oFr:PrintOptions:SetCopies( nCopies )
               oFr:PrintOptions:SetShowDialog( .f. )
               oFr:Print()

            case nDevice == IS_PDF
               oFr:DoExport( "PDFExport" )

         end case

      end if

      /*
      Destruye el diseñador-------------------------------------------------------
      */

      oFr:DestroyFr()

      ::RestoreDataReportLbl()

   end if

Return .t.

//---------------------------------------------------------------------------//

Method lPrepareDataReportLbl( lDesign ) CLASS TProduccion

   local n
   local nRec
   local oBlock
   local oError
   local nBlancos
   local lPrepareDataReport   := .t.

   DEFAULT lDesign         := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !lDesign
      nRec                 := ::cAreaTmpLabel:Recno()
   end if

   ::cFileTemporalLabel    := cGetNewFileName( cPatTmp() + "AuxTmpLbl" )

   DEFINE DATABASE ::cAreaTemporalLabel FILE ( ::cFileTemporalLabel ) CLASS "AuxTmpLbl" ALIAS "AuxTmpLbl" PATH ( cPatTmp() ) VIA ( cLocalDriver() )COMMENT "material producido"

      FIELD NAME "cSerOrd"    TYPE "C" LEN  01  DEC 0 COMMENT "Serie"                                    OF ::cAreaTemporalLabel
      FIELD NAME "nNumOrd"    TYPE "N" LEN  09  DEC 0 COMMENT "Número"                                   OF ::cAreaTemporalLabel
      FIELD NAME "cSufOrd"    TYPE "C" LEN  02  DEC 0 COMMENT "Sufijo"                                   OF ::cAreaTemporalLabel
      FIELD NAME "cCodigo"    TYPE "C" LEN  18  DEC 0 COMMENT "Código"                                   OF ::cAreaTemporalLabel
      FIELD NAME "cNombre"    TYPE "C" LEN 100  DEC 0 COMMENT "Nombre"                                   OF ::cAreaTemporalLabel
      FIELD NAME "cTxtSer"    TYPE "M" LEN  10  DEC 0 COMMENT "Series"                                   OF ::cAreaTemporalLabel
      FIELD NAME "cCodAlm"    TYPE "C" LEN  16  DEC 0 COMMENT "Almacén"                                  OF ::cAreaTemporalLabel
      FIELD NAME "cCodSec"    TYPE "C" LEN  03  DEC 0 COMMENT "Sección"                                  OF ::cAreaTemporalLabel
      FIELD NAME "cCodOpe"    TYPE "C" LEN  03  DEC 0 COMMENT "Operación"                                OF ::cAreaTemporalLabel
      FIELD NAME "dFecIni"    TYPE "D" LEN  08  DEC 0 COMMENT "Fecha inicio"                             OF ::cAreaTemporalLabel
      FIELD NAME "dFecFin"    TYPE "D" LEN  08  DEC 0 COMMENT "Fecha fin"                                OF ::cAreaTemporalLabel
      FIELD NAME "cHorIni"    TYPE "C" LEN  06  DEC 0 COMMENT "Hora de inicio" PICTURE "@R 99:99:99"        OF ::cAreaTemporalLabel
      FIELD NAME "cHorFin"    TYPE "C" LEN  06  DEC 0 COMMENT "Hora de fin"    PICTURE "@R 99:99:99"        OF ::cAreaTemporalLabel
      FIELD NAME "nCajas"     TYPE "N" LEN  16  DEC 6 COMMENT "Cajas"                                    OF ::cAreaTemporalLabel
      FIELD NAME "nUnidades"  TYPE "N" LEN  16  DEC 6 COMMENT "Unidades"                                 OF ::cAreaTemporalLabel
      FIELD NAME "nUndHra"    TYPE "N" LEN  16  DEC 6 COMMENT "Tot. und/hra"                             OF ::cAreaTemporalLabel
      FIELD NAME "nImporte"   TYPE "N" LEN  16  DEC 6 COMMENT "Importe"                                  OF ::cAreaTemporalLabel
      FIELD NAME "nTotLin"    TYPE "N" LEN  16  DEC 6 COMMENT "Total línea"                              OF ::cAreaTemporalLabel
      FIELD NAME "nPeso"      TYPE "N" LEN  16  DEC 6 COMMENT "Peso del artículo"                        OF ::cAreaTemporalLabel
      FIELD NAME "cUndPes"    TYPE "C" LEN  02  DEC 0 COMMENT "Unidad del peso"                          OF ::cAreaTemporalLabel
      FIELD NAME "nVolumen"   TYPE "N" LEN  16  DEC 6 COMMENT "Volumen del artículo"                     OF ::cAreaTemporalLabel
      FIELD NAME "cUndVol"    TYPE "C" LEN  02  DEC 0 COMMENT "Unidad del volumen"                       OF ::cAreaTemporalLabel
      FIELD NAME "cCodPr1"    TYPE "C" LEN  20  DEC 0 COMMENT "Código de primera propiedad"              OF ::cAreaTemporalLabel
      FIELD NAME "cCodPr2"    TYPE "C" LEN  20  DEC 0 COMMENT "Código de segunda propiedad"              OF ::cAreaTemporalLabel
      FIELD NAME "cValPr1"    TYPE "C" LEN  20  DEC 0 COMMENT "Valor de primera propiedad"               OF ::cAreaTemporalLabel
      FIELD NAME "cValPr2"    TYPE "C" LEN  20  DEC 0 COMMENT "Valor de segunda propiedad"               OF ::cAreaTemporalLabel
      FIELD NAME "lLote"      TYPE "L" LEN  01  DEC 0 COMMENT "Lógico lote"                              OF ::cAreaTemporalLabel
      FIELD NAME "cLote"      TYPE "C" LEN  14  DEC 0 COMMENT "Lote"                                     OF ::cAreaTemporalLabel
      FIELD NAME "dFecCad"    TYPE "D" LEN  08  DEC 0 COMMENT "Fecha caducidad"                          OF ::cAreaTemporalLabel
      FIELD NAME "lLabel"     TYPE "L" LEN   1  DEC 0 COMMENT "Lógico para marca de etiquetas"           OF ::cAreaTemporalLabel
      FIELD NAME "nLabel"     TYPE "N" LEN   6  DEC 0 COMMENT "Unidades de etiquetas a imprimir"         OF ::cAreaTemporalLabel

      INDEX TO ( ::cFileTemporalLabel ) TAG "cNumOrd" ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd"   COMMENT "Número"    NODELETED OF ::cAreaTemporalLabel

   END DATABASE ::cAreaTemporalLabel

   ::cAreaTemporalLabel:Activate( .f., .f. )

   /*
   Pasamos los datos de una temporal a otra------------------------------------
   */

   if !lDesign

      ::cAreaTmpLabel:GoTop()
      while !::cAreaTmpLabel:Eof()

         if ::cAreaTmpLabel:lLabel
            for n := 1 to ::cAreaTmpLabel:nLabel
               dbPass( ::cAreaTmpLabel:cAlias, ::cAreaTemporalLabel:cAlias, .t. )
            next
         end if

         ::cAreaTmpLabel:Skip()

      end while

      ::cAreaTemporalLabel:GoTop()

      ::cAreaTmpLabel:GoTo( nRec )

   else

      ::LoadAuxiliarDesign()

   end if   

   RECOVER USING oError

      lPrepareDataReport      := .f.

      MsgStop( 'Imposible crear un fichero temporal de materiales producidos' + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lPrepareDataReport )

//---------------------------------------------------------------------------//

Method RestoreDataReportLbl() CLASS TProduccion

   if !Empty( ::cAreaTemporalLabel ) .and. ::cAreaTemporalLabel:Used()
      ::cAreaTemporalLabel:End()
   end if

   dbfErase( ::cFileTemporalLabel )

   ::cAreaTemporalLabel := nil

   SysRefresh()

Return ( .t. )

//---------------------------------------------------------------------------//

Method PrepareTemporalLbl( oFr ) CLASS TProduccion

   local n
   local nBlancos       := 0
   local nPaperHeight   := oFr:GetProperty( "MainPage", "PaperHeight" ) * fr01cm
   local nHeight        := oFr:GetProperty( "MasterData", "Height" )
   local nColumns       := oFr:GetProperty( "MainPage", "Columns" )
   local nItemsInColumn := 0

   if !Empty( nPaperHeight ) .and. !Empty( nHeight ) .and. !Empty( nColumns )

      nItemsInColumn    := int( nPaperHeight / nHeight )

      nBlancos          := ( ::nColumnaInicio - 1 ) * nItemsInColumn
      nBlancos          += ( ::nFilaInicio - 1 )

   end if 

   for n := 1 to nBlancos
      dbPass( dbBlankRec( ::cAreaTemporalLabel:cAlias ), ::cAreaTemporalLabel:cAlias, .t. )
   next

   ::cAreaTemporalLabel:GoTop()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD DataLabel( oFr, lTemporal ) CLASS TProduccion

   /*
   Zona de datos------------------------------------------------------------
   */

   oFr:ClearDataSets()

   oFr:SetWorkArea(     "Lineas de producción", ::cAreaTemporalLabel:nArea )
   oFr:SetFieldAliases( "Lineas de producción", cObjectsToReport( ::cAreaTemporalLabel ) )

   oFr:SetWorkArea(     "Producción", ::oDbf:nArea, .f., { FR_RB_CURRENT, FR_RB_CURRENT, 0 } )
   oFr:SetFieldAliases( "Producción", cObjectsToReport( ::oDbf ) )

   oFr:SetWorkArea(     "Empresa", ::oDbfEmp:nArea )
   oFr:SetFieldAliases( "Empresa", cItemsToReport( aItmEmp() ) )

   oFr:SetWorkArea(     "Almacenes", ::oAlm:nArea )
   oFr:SetFieldAliases( "Almacenes", cItemsToReport( aItmAlm() ) )

   oFr:SetWorkArea(     "Sección", ::oSeccion:oDbf:nArea )
   oFr:SetFieldAliases( "Sección", cObjectsToReport( ::oSeccion:oDbf ) )

   oFr:SetWorkArea(     "Operación", ::oOperacion:oDbf:nArea )
   oFr:SetFieldAliases( "Operación", cObjectsToReport( ::oOperacion:oDbf ) )

   oFr:SetWorkArea(     "Artículos", ::oArt:nArea )
   oFr:SetFieldAliases( "Artículos", cItemsToReport( aItmArt() ) )   
   
   oFr:SetMasterDetail( "Lineas de producción", "Producción", {|| ::cAreaTemporalLabel:cSerOrd + Str( ::cAreaTemporalLabel:nNumOrd ) + ::cAreaTemporalLabel:cSufOrd } )
   oFr:SetMasterDetail( "Lineas de producción", "Empresa",    {|| cCodigoEmpresaEnUso() } )
   oFr:SetMasterDetail( "Lineas de producción", "Almacenes",  {|| ::cAreaTemporalLabel:cCodAlm } )
   oFr:SetMasterDetail( "Lineas de producción", "Sección",    {|| ::cAreaTemporalLabel:cCodSec } )
   oFr:SetMasterDetail( "Lineas de producción", "Operación",  {|| ::cAreaTemporalLabel:cCodOpe } )
   oFr:SetMasterDetail( "Lineas de producción", "Artículos",  {|| ::cAreaTemporalLabel:cCodigo } )


   oFr:SetResyncPair(   "Lineas de producción", "Producción" )
   oFr:SetResyncPair(   "Lineas de producción", "Empresa" )
   oFr:SetResyncPair(   "Lineas de producción", "Almacenes" )
   oFr:SetResyncPair(   "Lineas de producción", "Sección" )
   oFr:SetResyncPair(   "Lineas de producción", "Operación" )
   oFr:SetResyncPair(   "Lineas de producción", "Artículos" )

Return nil

//---------------------------------------------------------------------------//

Method LoadAuxiliarDesign() CLASS TProduccion

   local nRecPr         := ::oDetProduccion:oDbf:Recno()
   local nOrdPR         := ::oDetProduccion:oDbf:OrdSetFocus( "cNumOrd" )

   /*
   Limpiamos la base de datos temporal-----------------------------------------
   */

   ::cAreaTemporalLabel:Zap()

   /*
   Metemos las líneas con los materiales producidos----------------------------
   */

   ::oDetProduccion:oDbf:GoTop()

   if ::oDetProduccion:oDbf:Seek( ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd, 9 ) + ::oDbf:cSufOrd )

      while ::oDetProduccion:oDbf:cSerOrd + Str( ::oDetProduccion:oDbf:nNumOrd ) + ::oDetProduccion:oDbf:cSufOrd >= ::oDbf:cSerOrd + Str( ::oDbf:nNumOrd, 9 ) + ::oDbf:cSufOrd .and. !::oDetProduccion:oDbf:Eof()

         if !Empty( ::oDetProduccion:oDbf:cCodArt )

            ::cAreaTemporalLabel:Append()

            ::cAreaTemporalLabel:cSerOrd     := ::oDbf:cSerOrd
            ::cAreaTemporalLabel:nNumOrd     := ::oDbf:nNumOrd
            ::cAreaTemporalLabel:cSufOrd     := ::oDbf:cSufOrd
            ::cAreaTemporalLabel:cCodigo     := ::oDetProduccion:oDbf:cCodArt
            ::cAreaTemporalLabel:cNombre     := ::oDetProduccion:oDbf:cNomArt
            ::cAreaTemporalLabel:cTxtSer     := SerialDescrip( ::oDetProduccion:oDbf:cSerOrd + Str( ::oDetProduccion:oDbf:nNumOrd ) + ::oDetProduccion:oDbf:cSufOrd + Str( ::oDetProduccion:oDbf:nNumLin ), ::oDetSeriesProduccion:oDbf:cAlias )
            ::cAreaTemporalLabel:cCodAlm     := ::oDetProduccion:oDbf:cAlmOrd
            ::cAreaTemporalLabel:cCodSec     := Space(3)
            ::cAreaTemporalLabel:cCodOpe     := Space(3)
            ::cAreaTemporalLabel:dFecIni     := ::oDbf:dFecOrd
            ::cAreaTemporalLabel:dFecFin     := ::oDbf:dFecFin
            ::cAreaTemporalLabel:cHorIni     := ::oDbf:cHorIni
            ::cAreaTemporalLabel:cHorFin     := ::oDbf:cHorFin
            ::cAreaTemporalLabel:nCajas      := ::oDetProduccion:oDbf:nCajOrd
            ::cAreaTemporalLabel:nUnidades   := ::oDetProduccion:oDbf:nUndOrd
            ::cAreaTemporalLabel:nUndHra     := ::oDetProduccion:oDbf:nCajOrd * ::oDetProduccion:oDbf:nUndOrd
            ::cAreaTemporalLabel:nImporte    := ::oDetProduccion:oDbf:nImpOrd
            ::cAreaTemporalLabel:nTotLin     := ::oDetProduccion:oDbf:nCajOrd * ::oDetProduccion:oDbf:nUndOrd * ::oDetProduccion:oDbf:nImpOrd
            ::cAreaTemporalLabel:nPeso       := ::oDetProduccion:oDbf:nPeso
            ::cAreaTemporalLabel:cUndPes     := ::oDetProduccion:oDbf:cUndPes
            ::cAreaTemporalLabel:nVolumen    := ::oDetProduccion:oDbf:nVolumen
            ::cAreaTemporalLabel:cUndVol     := ::oDetProduccion:oDbf:cUndVol
            ::cAreaTemporalLabel:cCodPr1     := ::oDetProduccion:oDbf:cCodPr1
            ::cAreaTemporalLabel:cCodPr2     := ::oDetProduccion:oDbf:cCodPr2
            ::cAreaTemporalLabel:cValPr1     := ::oDetProduccion:oDbf:cValPr1
            ::cAreaTemporalLabel:cValPr2     := ::oDetProduccion:oDbf:cValPr2
            ::cAreaTemporalLabel:lLote       := ::oDetProduccion:oDbf:lLote
            ::cAreaTemporalLabel:cLote       := ::oDetProduccion:oDbf:cLote
            ::cAreaTemporalLabel:dFecCad     := ::oDetProduccion:oDbf:dFecCad
            ::cAreaTemporalLabel:lLabel      := .t.
            ::cAreaTemporalLabel:nLabel      := ::oDetProduccion:oDbf:nCajOrd * ::oDetProduccion:oDbf:nUndOrd

            ::cAreaTemporalLabel:Save()

         end if   

         ::oDetProduccion:oDbf:Skip()

      end while

   end if

   ::oDetProduccion:oDbf:OrdSetFocus( nOrdPR )
   ::oDetProduccion:oDbf:Goto( nRecPr )
   
   ::cAreaTemporalLabel:GoTop()

Return ( Self )

//---------------------------------------------------------------------------//

Method ActualizaStockWeb( cNumDoc ) CLASS TProduccion

   local nRec
   local nOrdAnt

   if uFieldEmpresa( "lRealWeb" )

      /*
      Materiales producidos----------------------------------------------------
      */

      nRec     := ::oDetProduccion:oDbf:Recno()
      nOrdAnt  := ::oDetProduccion:oDbf:OrdSetFocus( "cNumOrd" )

      with object ( TComercio():New())

         if ::oDetProduccion:oDbf:Seek( cNumDoc )

            while ::oDetProduccion:oDbf:cSerOrd + Str( ::oDetProduccion:oDbf:nNumOrd ) + ::oDetProduccion:oDbf:cSufOrd == cNumDoc .and. !::oDetProduccion:oDbf:Eof()

               if oRetfld( ::oDetProduccion:oDbf:cCodArt, ::oArt, "lPubInt", "Codigo" )

                  :ActualizaStockProductsPrestashop( ::oDetProduccion:oDbf:cCodArt, ::oDetProduccion:oDbf:cCodPr1, ::oDetProduccion:oDbf:cCodPr2, ::oDetProduccion:oDbf:cValPr1, ::oDetProduccion:oDbf:cValPr2 )

               end if

               ::oDetProduccion:oDbf:Skip()

            end while

        end if
        
      end with

      ::oDetProduccion:oDbf:OrdSetFocus( nOrdAnt )
      ::oDetProduccion:oDbf:GoTo( nRec )

      /*
      Materiales consumidos----------------------------------------------------
      */

      nRec     := ::oDetMaterial:oDbf:Recno()
      nOrdAnt  := ::oDetMaterial:oDbf:OrdSetFocus( "cNumOrd" )

      with object ( TComercio():New())

         if ::oDetMaterial:oDbf:Seek( cNumDoc )

            while ::oDetMaterial:oDbf:cSerOrd + Str( ::oDetMaterial:oDbf:nNumOrd ) + ::oDetMaterial:oDbf:cSufOrd == cNumDoc .and. !::oDetMaterial:oDbf:Eof()

               if oRetfld( ::oDetMaterial:oDbf:cCodArt, ::oArt, "lPubInt", "Codigo" )

                  :ActualizaStockProductsPrestashop( ::oDetMaterial:oDbf:cCodArt, ::oDetMaterial:oDbf:cCodPr1, ::oDetMaterial:oDbf:cCodPr2, ::oDetMaterial:oDbf:cValPr1, ::oDetMaterial:oDbf:cValPr2 )

               end if

               ::oDetMaterial:oDbf:Skip()

            end while

        end if
        
      end with

      ::oDetMaterial:oDbf:OrdSetFocus( nOrdAnt )
      ::oDetMaterial:oDbf:GoTo( nRec )
   
   end if 

Return .f.   

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDetalleArticulos FROM TDet

   DATA  oGetGrupoFamilia
   DATA  oGetFamilia
   DATA  oGetTipo
   DATA  oGetFabricante
   DATA  oGetTemporada
   DATA  oGetCatalogo
   DATA  oGetOperacion

   DATA oClasificacionArticulo

   METHOD CommunFields( oDbf )

   METHOD LoadPropiedadesArticulos( oDlg )

   METHOD LoadCommunFields()

END CLASS

//---------------------------------------------------------------------------//

METHOD CommunFields( oDbf ) CLASS TDetalleArticulos

   FIELD NAME "cGrpFam"    TYPE "C" LEN  3  DEC 0 COMMENT "Código del grupo de familia"   HIDE        OF oDbf       
   FIELD NAME "cCodFam"    TYPE "C" LEN 16  DEC 0 COMMENT "Código de la familia"          HIDE        OF oDbf       
   FIELD NAME "cCodTip"    TYPE "C" LEN  4  DEC 0 COMMENT "Código del tipo"               HIDE        OF oDbf        
   FIELD NAME "cCodCat"    TYPE "C" LEN 10  DEC 0 COMMENT "Código de categoría"           HIDE        OF oDbf       
   FIELD NAME "cCodTmp"    TYPE "C" LEN 10  DEC 0 COMMENT "Código de la temporada"        HIDE        OF oDbf       
   FIELD NAME "cCodFab"    TYPE "C" LEN  3  DEC 0 COMMENT "Código del fabricante"         HIDE        OF oDbf       
   FIELD NAME "cCodOpe"    TYPE "C" LEN  3  DEC 0 COMMENT "Código de operación"           HIDE        OF oDbf       

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadPropiedadesArticulos( oDlg, nMode ) CLASS TDetalleArticulos

      REDEFINE GET ::oGetGrupoFamilia VAR ::oDbfVir:cGrpFam ;
         ID       ( 100 ) ;
         IDTEXT   ( 101 ) ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oGetGrupoFamilia:bValid := {|| ::oParent:oGrupoFamilia:Existe( ::oGetGrupoFamilia, ::oGetGrupoFamilia:oHelpText ) }
      ::oGetGrupoFamilia:bHelp  := {|| ::oParent:oGrupoFamilia:Buscar( ::oGetGrupoFamilia ) }
      ::oGetGrupoFamilia:lValid()

      REDEFINE GET ::oGetFamilia VAR ::oDbfVir:cCodFam ;
         ID       ( 110 ) ;
         IDTEXT   ( 111 ) ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oGetFamilia:bValid := {|| ::oGetFamilia:oHelpText:cText( oRetFld( ::oDbfVir:cCodFam, ::oParent:oFam ) ) }
      ::oGetFamilia:bHelp  := {|| BrwFamilia( ::oGetFamilia, ::oGetFamilia:oHelpText ) }
      ::oGetFamilia:lValid()

      REDEFINE GET ::oGetTipo VAR ::oDbfVir:cCodTip ;
         ID       ( 120 ) ;
         IDTEXT   ( 121 ) ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oGetTipo:bValid := {|| ::oParent:oTipoArticulo:Existe( ::oGetTipo, ::oGetTipo:oHelpText ) }
      ::oGetTipo:bHelp  := {|| ::oParent:oTipoArticulo:Buscar( ::oGetTipo ) }
      ::oGetTipo:lValid()

      REDEFINE GET ::oGetCatalogo VAR ::oDbfVir:cCodCat ;
         ID       ( 130 ) ;
         IDTEXT   ( 131 ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oGetCatalogo:bValid := {|| ::oGetCatalogo:oHelpText:cText( oRetFld( ::oDbfVir:cCodCat, ::oParent:oCategoria ) ) }
      ::oGetCatalogo:bHelp  := {|| BrwCategoria( ::oGetCatalogo, ::oGetCatalogo:oHelpText ) }
      ::oGetCatalogo:lValid()

      REDEFINE SAY ;
         PROMPT   getConfigTraslation( "Temporada" );
         ID       505 ;
         OF       oDlg

      REDEFINE GET ::oGetTemporada VAR ::oDbfVir:cCodTmp ;
         ID       ( 140 ) ;
         IDTEXT   ( 141 ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oGetTemporada:bValid := {|| ::oGetTemporada:oHelpText:cText( oRetFld( ::oDbfVir:cCodTmp, ::oParent:oTemporada ) ) }
      ::oGetTemporada:bHelp  := {|| BrwTemporada( ::oGetTemporada, ::oGetTemporada:oHelpText ) }
      ::oGetTemporada:lValid()

      REDEFINE GET ::oGetFabricante VAR ::oDbfVir:cCodFab ;
         ID       ( 150 ) ;
         IDTEXT   ( 151 ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oGetFabricante:bValid := {|| ::oParent:oFabricante:Existe( ::oGetFabricante, ::oGetFabricante:oHelpText ) }
      ::oGetFabricante:bHelp  := {|| ::oParent:oFabricante:Buscar( ::oGetFabricante ) }
      ::oGetFabricante:lValid()

      REDEFINE GET ::oGetOperacion VAR ::oDbfVir:cCodOpe ;
         ID       ( 160 ) ;
         IDTEXT   ( 161 ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oGetOperacion:bValid := {|| ::oParent:oOperacion:Existe( ::oGetOperacion, ::oGetOperacion:oHelpText, "cDesOpe", .t., .t., "0" ) }
      ::oGetOperacion:bHelp  := {|| ::oParent:oOperacion:Buscar( ::oGetOperacion ) }
      ::oGetOperacion:lValid()

      /*
      Clasificación -----------------------------------------------------------
      */

      ::oClasificacionArticulo   := ClasificacionTipoArticulo():New( 200, oDlg )
      ::oClasificacionArticulo:SetMode( nMode )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadCommunFields() CLASS TDetalleArticulos

   ::oGetGrupoFamilia:cText( cGruFam( ::oParent:oArt:Familia, ::oParent:oFam ) )
   ::oGetGrupoFamilia:lValid()

   ::oGetFamilia:cText( ::oParent:oArt:Familia )
   ::oGetFamilia:lValid()

   ::oGetTipo:cText( ::oParent:oArt:cCodTip )
   ::oGetTipo:lValid()

   ::oGetTemporada:cText( ::oParent:oArt:cCodTemp )
   ::oGetTemporada:lValid()

   ::oGetFabricante:cText( ::oParent:oArt:cCodFab )
   ::oGetFabricante:lValid()

   ::oClasificacionArticulo:SetNumber( ::oParent:oTipoArticulo:nTipo( ::oParent:oArt:cCodTip ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

Function oProduccion( cMsg, u1, u2, u3, u4, u5, u6, u7, u8, u9, u10 )

   local uReturn  := ""

   if !Empty( oThis ) .and. !Empty( cMsg )
      uReturn     := ApoloSender( oThis, cMsg, u1, u2, u3, u4, u5, u6, u7, u8, u9, u10 )
   end if

Return ( uReturn )

//--------------------------------------------------------------------------//

