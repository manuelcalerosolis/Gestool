#include "FiveWin.Ch" 
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"

static lThouSep        := .f.
static cNumFormat      := 'A'
static lExcelInstl
static lCalcInstl
static nxlLangID, cxlTrue := "=(1=1)", cxlFalse := "=(1=0)", cxlSum, cxlSubTotal, lxlEnglish := .f., hLib

static oThis

//---------------------------------------------------------------------------//

Function setFastReportObject( self )

   oThis  := self

Return ( oThis )

//---------------------------------------------------------------------------//

Function getFastReportObject()

Return ( oThis )

//---------------------------------------------------------------------------//

CLASS TInfGen

   CLASSDATA aFont
   CLASSDATA acSizes
   CLASSDATA acEstilo
   CLASSDATA acFont

   DATA oDlg
   DATA oFld
   DATA oReport
   DATA oBmpImagen
   DATA cFileName
   DATA cFileIndx
   DATA nDevice
   DATA cTitle
   DATA cSubTitle
   DATA cAliasTitle
   DATA cFooter
   DATA aDbfTmp      INIT {}
   DATA cIndex
   DATA aStru        INIT {}
   DATA bRedefine
   DATA aCols        INIT {}
   DATA bFilter
   DATA uFrom
   DATA uTo
   DATA nSize        INIT 10
   DATA aOrd         INIT {}
   DATA cAlias
   DATA lOpenFiles   INIT .f.
   DATA aoCols       INIT {}
   DATA aoGroup      INIT {}
   DATA cHelp
   DATA lSave2Exit   INIT .t.
   DATA nYeaInf      INIT Year( Date() )
   DATA dIniInf      INIT CtoD( "01/01/" + Str( Year( Date() ) ) )
   DATA dFinInf      INIT Date()
   DATA oIniInf
   DATA oIniText
   DATA oFinInf
   DATA oFinText
   DATA oSer         INIT Array( 26 )
   DATA aSer         INIT Afill( Array( 26 ), .t. )
   DATA oBandera
   DATA oDivInf
   DATA cDivInf
   DATA cPicImp
   DATA cPicOut
   DATA nDecOut
   DATA cPicOut
   DATA nDecOut
   DATA nDerOut
   DATA cPicCom
   DATA cPicIn
   DATA nDecIn
   DATA nDerIn
   DATA cPicPnt
   DATA nDecPnt
   DATA nDerPnt
   DATA nValDiv      INIT 1
   DATA cAlmOrg
   DATA cAlmDes
   DATA lAgeAll      INIT .f.
   DATA lShadowLine  INIT .f.
   DATA cAgeOrg
   DATA cAgeDes
   DATA cRutOrg
   DATA cRutDes
   DATA cArtOrg
   DATA cArtDes
   DATA cCliOrg
   DATA cCliDes
   DATA cTmpOrg
   DATA cTmpDes
   DATA cTrnOrg
   DATA cTrnDes
   DATA cObrOrg
   DATA cCodEmp
   DATA cObrDes
   DATA oBmpDiv
   DATA oBrwCol

   DATA oOperacion
   DATA oSeccion
   DATA oOperario
   DATA oMaquina

   DATA oDbfDiv
   DATA cSupTitle
   DATA oMtrInf
   DATA nMtrInf      INIT 0
   DATA oDbf
   DATA oDbfMai
   DATA oDbfDet
   DATA oParent
   DATA oDetail
   DATA oDbfAlm
   DATA oDbfAlmacenOrigen 
   DATA oDbfAge
   DATA oDbfRut
   DATA oDbfArt
   DATA oDbfArticuloMateriaPrima
   DATA oArtImg
   DATA oArtKit
   DATA oArtCod
   DATA oDbfCli
   DATA oDbfTmp
   DATA oDbfPrv
   DATA oDbfObr
   DATA oDbfFpg
   DATA oGruFam
   DATA oDbfTur
   DATA oDbfTrn
   DATA oDbfCaj
   DATA oDbfRemCli
   DATA oResumen
   DATA lResumen     INIT .f.
   DATA lExcCero     INIT .t.
   DATA lExcImp      INIT .t.
   DATA lSalto       INIT .f.
   DATA cPrvOrg
   DATA cPrvDes
   DATA oDbfFam
   DATA oDbfCat
   DATA oDbfEstArt
   DATA oTipArt
   DATA oDbfFab
   DATA oDbfIva
   DATA oTipAct
   DATA oDbfEmp
   DATA cFamOrg
   DATA cFamDes
   DATA cTipOrg
   DATA cTipDes
   DATA cTipActOrg
   DATA cTipActDes
   DATA oBanco
   DATA oGrpCli
   DATA cGrpOrg
   DATA cGrpDes
   DATA lGrpAll      INIT .f.
   DATA oGrpPrv
   DATA cGrpPrvOrg
   DATA cGrpPrvDes
   DATA lGrpPrvAll   INIT .f.
   DATA lAllFab      INIT .f.
   DATA lAllPrv      INIT .f.
   DATA lAllCli      INIT .f.
   DATA lAllTmp      INIT .f.
   DATA lAllAlm      INIT .f.
   DATA lAllArt      INIT .f.
   DATA lAllGrp      INIT .f.
   DATA lAllFam      INIT .f.
   DATA lAllCat      INIT .f.
   DATA lAllFpg      INIT .f.
   DATA lAllTip      INIT .f.
   DATA lAllRut      INIT .f.
   DATA lAllTrn      INIT .f.
   DATA lAllUsr      INIT .f.
   DATA lAllCaj      INIT .f.
   DATA lAllTipAct   INIT .f.

   DATA cGruFamOrg
   DATA cGruFamDes
   DATA cTurOrg
   DATA cTurDes
   DATA cFpgDes
   DATA cFpgHas

   DATA oAlbPrvT
   DATA oAlbPrvL
   DATA oFacPrvT
   DATA oFacPrvL
   DATA oFacRecL
   DATA oFacRecT
   DATA oFacCliL
   DATA oFacCliT
   DATA oFacCliP
   DATA oAntCliT
   DATA oSatCliT
   DATA oSatCliL
   DATA oPreCliT
   DATA oPreCliL
   DATA oPedCliL
   DATA oPedCliT
   DATA oPedPrvL
   DATA oPedPrvT
   DATA oAlbCliL
   DATA oAlbCliT
   DATA oTikCliT
   DATA oTikCliL
   DATA oRctPrvT
   DATA oRctPrvL
   DATA oRemAgeT
   DATA oCnfFlt

   DATA aFields
   DATA aIniCli
   DATA aIniPrv

   DATA oBtnOriginal
   DATA oBtnFilter
   DATA oBtnAction
   DATA oBtnCancel
   DATA oBtnExportar
   DATA oBtnImportar
   DATA oBtnXml

   DATA aHeader
   DATA aFooter
   DATA lDefSerInf      INIT .t.
   DATA lDefFecInf      INIT .t.
   DATA lGrpFecInf      INIT .t.
   DATA lDefDivInf      INIT .t.
   DATA lDefTitInf      INIT .t.
   DATA lDefMetInf      INIT .t.
   DATA lDefGraph       INIT .f.
   DATA lCellView       INIT .t.
   DATA lShadow         INIT .t.
   DATA lBreak          INIT .f.
   DATA lNoCancel       INIT .f.
   DATA oDbfInf
   DATA oDbfFnt
   DATA oDbfGrp
   DATA nBmp
   DATA aIndex
   DATA lNoGroup        INIT .f.
   DATA oWndGraph
   DATA nEvery          INIT 1
   DATA oFilter
   DATA lFilterHeader   INIT .f.
   DATA xOthers
   DATA cPrinter
   DATA cImagen
   DATA nFilaImagen     INIT 0
   DATA nColumnaImagen  INIT 0
   DATA nAnchoImagen    INIT 0
   DATA nAltoImagen     INIT 0
   DATA cUsrOrg
   DATA cUsrDes
   DATA cCajOrg
   DATA cCajDes

   DATA oTreeGroups
   DATA oTreeSelectedGroups
   DATA oImageGroup

   DATA oOrientation
   DATA nOrientation    INIT 1
   DATA cOrientation    INIT ""
   DATA aOrientation    INIT { "Automática", "Vertical", "Horizontal" }

   DATA oCmbReport
   DATA cCmbReport
   DATA aCmbReport
   DATA aBmpReport
   DATA nCmbReport      INIT 1

   DATA nWidthPage      INIT 0
   DATA nLenPage        INIT 0

   DATA bForReport      INIT {|| .t. }
   DATA bStartGroup
   DATA bEndGroup
   DATA bPostGroup

   DATA bPreGenerate
   DATA bPostGenerate

   DATA lDefDesHas      INIT .f.

   DATA uDesInf         INIT ""
   DATA uHasInf         INIT ""

   DATA hFile

   DATA lAllObr         INIT .f.

   DATA lBig            INIT .f.
   DATA oBrwCondiciones
   DATA aCondiciones    INIT {}

   DATA aSelectionGroup INIT {}
   DATA aSelectedGroup  INIT {}
   DATA aInitGroup      INIT {}
   DATA aSelectionRango INIT {}

   DATA lNewInforme     INIT .f.

   DATA cPrefijoIndice  INIT ""

   DATA cEmptyIndex     INIT "cNumDoc"

   DATA uParam 

   DATA oBtnOptions

   DATA oTFastReportOptions

   METHOD New( cSubTitle, aFields, oMenuItem, oWnd ) CONSTRUCTOR

   METHOD Activate()

   METHOD lGenerate()

   METHOD Create()               VIRTUAL

   METHOD Reindexa()

   Method DefineConfigUser( cPath )

   Method DefineFont( cPath )

   Method DefineGroup( cPath )

   METHOD Play()

   METHOD Print( nDevice )

   METHOD StdResource()

   METHOD ChgIndex( oCmb )       INLINE ( ::cAlias )->( OrdSetFocus( oCmb:nAt ) )

   METHOD Redefine()             INLINE Eval( ::bRedefine, self )

   METHOD AddField( cNomCol, cTypCol, nSizCol, nDecCol, cPicCol, cHeaCol )

   METHOD AddTmpIndex( cName, cKey, cFor, bWhile, lUniq, lDes, cComment, bOption, nStep, lNoDel, lFocus )

   METHOD AddGroup( bGroup , bHeader, bFooter, bFont, lEject )

   METHOD DelGroup( nGroup )

   METHOD UpColumn( oBrw )

   METHOD DwColumn( oBrw )

   METHOD Default()

   METHOD Save()

   METHOD oDefYea( nId )

   METHOD oDefIniInf( nId )

   METHOD oDefFinInf( nId )

   METHOD oDefDivInf( nId, nIdBmp )

   METHOD oDefTitInf( nIdTitle, nIdSubTitle )

   METHOD oDefAlmInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllAlm, lInitGroup )

   METHOD oBrwAlmInf()

   METHOD oDefAgeInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, oDbfAge )

   METHOD oDefRutInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllRut )

   METHOD oDefTrnInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllTrn )

   METHOD oDefUsrInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllUsr )

   METHOD oDefCajInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllCaj )

   METHOD lDefArtInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllArt, lInitGroup )

   METHOD lIntArtInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllArt, dbfArticulo, dbfDiv, dbfArtKit, dbfIva )

   METHOD oDefPrvInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllPrv )

   METHOD lDefFamInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllFam )

   METHOD oDefTipInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllTip )

   METHOD oDefCliInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, oDbfCli )

   METHOD oDefTmpInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllArt )

   METHOD oDefFabInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllFab )

   METHOD AddTemporada( cCodTmp, oDbfTmp )

   METHOD oDefObrInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllObr )

   METHOD oDefTurInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, oDbfArt )

   METHOD oDefGrfInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllGrp )

   METHOD oDefFpgInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllFpg )

   METHOD oDefGrpCli( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAll, oDlg )

   METHOD oDefGrpPrv( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAll, oDlg )

   METHOD oDefTipActInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllAct )

   METHOD oDefMetInf( nId )

   METHOD oDefSerInf()

   METHOD oDefExcInf( nId )

   METHOD oDefExcImp( nId )

   METHOD oDefSalInf( nId )

   METHOD oDefResInf( nId )

   METHOD oDefEmpInf( nIdOrg, nIdSayOrg, oDlg )

   METHOD CreateColumn()

   METHOD OpenFiles()   VIRTUAL

   METHOD CloseFiles()  VIRTUAL

   METHOD End()

   METHOD lLoadDivisa()

   METHOD Destroy()     VIRTUAL

   METHOD PutOriginal()

   METHOD PrnTiket()

   METHOD FldCliente()

   METHOD FldPropiedades()

   METHOD AddArticulo()

   METHOD FldArticulo( lVisible, lPropiedades, lLote )

   METHOD FldDiario()

   METHOD FldDiaPrv()

   METHOD CreateFldAnu()

   METHOD GrupoAnuCreateFld()

   METHOD FamAnuCreateFld()

   METHOD TipAnuCreateFld()

   METHOD ArtAnuCreateFld()

   METHOD CliAnuCreateFld()

   METHOD AgeAnuCreateFld()

   METHOD CreateFldRut()

   METHOD AddCliente( cCodCli, oDbfDocT, lTiket )

   METHOD FldProveedor()

   METHOD AddProveedor( cCodPrv )

   METHOD AcuPesVol( cCodArt, nTotUni, nImporte )

   METHOD Grafico()

   METHOD Xml()

   METHOD AddImporte( dFecDoc, nImpDoc )

   METHOD nMediaMes( nAnno )

   METHOD SetMetInf( oDbf )

   METHOD RefMetInf( nPos )

   METHOD OpenData()

   METHOD CloseData()

   METHOD SyncAllDbf()

   METHOD CreateFilter( aTField, oDbf )

   METHOD DlgFilter()            INLINE ( if( !Empty( ::oFilter ), ::oFilter:Dialog(), ) )

   METHOD EvalFilter( oDbf )

   METHOD AplyFilter( oDbf )     INLINE ( if(   !Empty( ::oFilter ) .and. !Empty( ::oFilter:cExpresionFilter ),;
                                                ::oDbf:SetFilter( ::oFilter:cExpresionFilter ),;
                                                ::oDbf:SetFilter() ) )

   METHOD oDefDesHas()

   METHOD MakeVisor()

   METHOD GenReport( nOption )

   METHOD lValArt( cRef )        INLINE ( cRef >= ::cArtOrg .AND. cRef <= ::cArtDes )

   METHOD lValFam( cFam )        INLINE ( cFam >= ::cFamOrg .AND. cFam <= ::cFamDes  )

   METHOD lValGrpFam( cGrpFam )  INLINE ( cGrpFam >= ::cGrpFamOrg .AND. cGrpFam <= ::cGrpFamDes )

   METHOD Shadows()

   METHOD nTotAlbPrv( cCodArt )

   METHOD nTotFacPrv( cCodArt )

   METHOD nTotAlbCli( cCodArt )

   METHOD nTotFacCli( cCodArt )

   METHOD nTotTikCli( cCodArt )

   METHOD nStkTotal( cCodArt )

   METHOD AddSelectedGroup()

   METHOD DelSelectedGroup()

   Method UpSelectedGroup()

   Method DownSelectedGroup()

   METHOD ReLoadGroup()

   METHOD CreaGrupos()

   METHOD BtnDefectoGrupo()

   METHOD lSeekInAcumulado( cExpresion )

   METHOD SetValorGrupo( cNombre, cValor )

   METHOD oDbfOrdSetFocus( cTag )         INLINE ( ::oDbf:OrdSetFocus( cTag ) )

   METHOD oDbfSetFilter( cExp )           INLINE ( ( ::oDbf:nArea )->( dbsetfilter( c2Block( cExp ), cExp ) ) )

   METHOD oTiketSetFilter( cExp )         INLINE ( ( ::oTikCliT:nArea )->( dbsetfilter( c2Block( cExp ), cExp ) ) )
   METHOD oTiketQuitFilter()              INLINE ( ( ::oTikCliT:nArea )->( dbclearfilter() ) )

   METHOD oTiketLineaSetFilter( cExp )    INLINE ( ( ::oTikCliL:nArea )->( dbsetfilter( c2Block( cExp ), cExp ) ) )
   METHOD oTiketLineaQuitFilter()         INLINE ( ( ::oTikCliL:nArea )->( dbclearfilter() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cSubTitle, aFields, aIndex, oMenuItem, oWnd, cHelp, xOthers ) CLASS TInfGen

   local n
   local nLevel
   local cFileObject := substr( strtran( alltrim( str( seconds() ) ), ".", "" ), -6 )

   DEFAULT cSubTitle := Padr( "Generador de informes", 50 )
   DEFAULT aFields   := {}
   DEFAULT aIndex    := {}
   DEFAULT oMenuItem := "00000"
   DEFAULT oWnd      := oWnd()
   DEFAULT cHelp     := ""

   ::cSubTitle       := cSubTitle
   ::aFields         := aFields
   ::cHelp           := cHelp
   ::aHeader         := { {|| Padr( "Fecha", 13 ) + ": " + Dtoc( Date() ) + " - " + Time() } }
   ::aFooter         := { {|| "Página : " + str( ::oReport:nPage, 3 ) } }
   ::aIndex          := aEval( aIndex, {|a| aSize( a, 6 ) } )
   ::cTitle          := Padr( cCodEmp() + " - " + cNbrEmp(), 100 )
   ::cFooter         := Space( 100 )
   ::cDivInf         := cDivEmp()
   ::xOthers         := xOthers

   ::bStartGroup     := {|oGrp| ::oReport:NewLine() }
   ::bEndGroup       := {|| .t. }
   ::bPostGroup      := {|| .t. }

   ::aSelectionGroup := {}
   ::aSelectionRango := {}

   /*
   Inicialización de objetos---------------------------------------------------
   */

   ::aoCols                   := {}
   ::aoGroup                  := {}
   ::aInitGroup               := {}
   ::aSelectedGroup           := {}
   ::oDbf                     := nil
   ::oDbfAlm                  := nil
   ::oDbfAlmacenOrigen        := nil
   ::oDbfAge                  := nil
   ::oDbfArt                  := nil
   ::oDbfArticuloMateriaPrima := nil
   ::lDefGraph                := .f.
   ::lExcCero                 := .t.

	/*
   Preparamos los dispositivos de salida---------------------------------------
   */

   ::cCmbReport      := "Visualizar"
   ::aCmbReport      := {}
   ::aBmpReport      := {}

   aAdd( ::aCmbReport, "Visualizar" )
   aAdd( ::aBmpReport, "PREV116"    )

   aAdd( ::aCmbReport, "Imprimir"   )
   aAdd( ::aBmpReport, "gc_printer2_16"  )

   aAdd( ::aCmbReport, "Excel"      )
   aAdd( ::aBmpReport, "TABLE"      )

   aAdd( ::aCmbReport, "HTML"       )
   aAdd( ::aBmpReport, "gc_earth_16"   )

   aAdd( ::aCmbReport, "Adobe PDF"  )
   aAdd( ::aBmpReport, "DOCLOCK"    )

   ::cCmbReport            := "Visualizar"

   ::oTFastReportOptions   := TFastreportOptions():New()

   /*
   Creamos las bases de datos temporales---------------------------------------
   */

   ::cFileName             := cGetNewFileName( cPatTmp() + trimedSeconds(), "Dbf", .t. )  // ::ClassName()
   ::cFileIndx             := cGetNewFileName( cPatTmp() + trimedSeconds(), "Cdx", .t. )  // ::ClassName()

   if file( ::cFileName )
      fErase( ::cFileName )
   end if

   if file( ::cFileIndx )
      fErase( ::cFileIndx )
   end if

   ::oDbf                  := TDbf():New( ::cFileName, "InfMov", ( cLocalDriver() ), , ( cPatTmp() ) )

   for n := 1 to len( aFields )

      if len( aFields[n] ) < 10
         aSize( aFields[n], 10 )
      end if

      ::oDbf:AddField(     aFields[ n, 1 ],;
                           aFields[ n, 2 ],;
                           aFields[ n, 3 ],;
                           aFields[ n, 4 ],;
                           aFields[ n, 5 ],;
                           aFields[ n, 7 ],;
                           nil,;
                           nil,;
                           aFields[ n, 6 ],;
                           aFields[ n, 8 ],;
                           if( aFields[ n, 9 ] == nil, aFields[ n, 3 ] + aFields[ n, 4 ], aFields[ n, 9 ] ) )

   next

   /*
   Bitmap---------------------------------------------------------------------
   */

   ::nBmp               := LoadBitmap( 0, 32760 )

   /*
   Apertura de ficheros externos-----------------------------------------------
   */

   ::lOpenFiles         := ::OpenFiles()

   if ValType( ::lOpenFiles ) != "L"
      ::lOpenFiles      := .t.
   end if

   setFastReportObject( self )

RETURN Self

//----------------------------------------------------------------------------//

METHOD End() CLASS TInfGen

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

   if ::oDbfArticuloMateriaPrima != nil .and. ::oDbfArticuloMateriaPrima:Used()
      ::oDbfArticuloMateriaPrima:End()
   end if

   if ::oDbfAlm != nil .and. ::oDbfAlm:Used()
      ::oDbfAlm:End()
   end if

   if ::oDbfAlmacenOrigen != nil .and. ::oDbfAlmacenOrigen:Used()
      ::oDbfAlmacenOrigen:End()
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

   if ::oDbfEstArt != nil .and. ::oDbfEstArt:Used()
      ::oDbfEstArt:End()
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

   if ::oDbfCat != nil .and. ::oDbfCat:Used()
      ::oDbfCat:End()
   end if

   if ::oDbfRemCli != nil .and. ::oDbfRemCli:Used()
      ::oDbfRemCli:End()
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
      ::oGrpCli := nil
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

   if file( ::cFileName )
      fErase( ::cFileName )
   end if

   if file( ::cFileIndx )
      fErase( ::cFileIndx )
   end if

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

METHOD StdResource( cFldRes ) CLASS TInfGen

   local n
   local oCellView
   local oImagen
   local oShadow
   local aoFont      := { , , }
   local aoSizes     := { , , }
   local aoEstilo    := { , , }
   local aSizes      := { "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   local aEstilo     := { "Normal", "Cursiva", "Negrita", "Negrita Cursiva" }
   local aPad        := { "Izquierda", "Derecha" }
   local oPrinter

   DEFAULT cFldRes   := "INF_GEN01"

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
   Indices --------------------------------------------------------------------
   */

   for n := 1 to len( ::aIndex )

      ::oDbf:AddTmpIndex(  ::aIndex[n,1],;
                           ::cFileIndx,;
                           ::aIndex[n,2],;
                           ::aIndex[n,3],;
                           ::aIndex[n,4],;
                           ::aIndex[n,5],;
                           ::aIndex[n,6],;
                           ,;
                           ,;
                           ,;
                           ,;
                           .t. )
   next

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   if !::lBig
      DEFINE DIALOG ::oDlg RESOURCE "INF_GEN" TITLE ::cSubTitle
   else
      DEFINE DIALOG ::oDlg RESOURCE "INF_GENBIG" TITLE ::cSubTitle
   end if

   /*
   Define de los Folders
   ------------------------------------------------------------------------
   */

   if !::lNewInforme
      ::oFld := TFolder():ReDefine( 400, {"I&nforme", "&Columnas", "A&pariencia" }, { cFldRes, "INF_GEN_COL", "INF_GEN_PRN" }, ::oDlg )
   else
      ::oFld := TFolder():ReDefine( 400, {"I&nforme", "A&grupar...", "&Columnas", "A&pariencia" }, { cFldRes, "INF_GEN_AGRUPA", "INF_GEN_COL", "INF_GEN_PRN" }, ::oDlg )
   end if

   /*
   Creamos las columnas
   */

   ::CreateColumn()

   /*
   Aplicamos los valores segun se han archivado--------------------------------
   */

   ::Default()

   /*
   Desde hasta para reportes automaticos--------------------------------------
   */

   if ::lDefDesHas
      ::oDefDesHas()
   end if

   /*
   Fechas----------------------------------------------------------------------
   */

   if ::lDefFecInf
      ::oDefIniInf()
      ::oDefFinInf()
   end if

   /*
   Divisas---------------------------------------------------------------------
   */

   if ::lDefDivInf
      ::oDefDivInf()
   end if

   /*
   Titulos---------------------------------------------------------------------
   */

   if ::lDefTitInf
      ::oDefTitInf()
   end if

   /*
   Progreso--------------------------------------------------------------------
   */

   if ::lDefMetInf
      ::oDefMetInf()
   end if

   /*
   Series----------------------------------------------------------------------
   */

   if ::lDefSerInf
      ::oDefSerInf()
   end if

   /*
   Caja de diálogo para agrupamientos__________________________________________
   */

   if ::lNewInforme

   ::oTreeGroups           := TTreeView():Redefine( 100, ::oFld:aDialogs[2]  )
   ::oTreeGroups:bLDblClick:= {|| ::AddSelectedGroup() }

   ::oTreeSelectedGroups   := TTreeView():Redefine( 110, ::oFld:aDialogs[2]  )

   REDEFINE BUTTON ;
      ID       120 ;
      OF       ::oFld:aDialogs[2] ;
      ACTION   ( ::AddSelectedGroup() )

   REDEFINE BUTTON ;
      ID       130 ;
      OF       ::oFld:aDialogs[2] ;
      ACTION   ( ::DelSelectedGroup() )

   REDEFINE BUTTON ;
      ID       140 ;
      OF       ::oFld:aDialogs[2] ;
      ACTION   ( ::UpSelectedGroup() )

   REDEFINE BUTTON ;
      ID       150 ;
      OF       ::oFld:aDialogs[2] ;
      ACTION   ( ::DownSelectedGroup() )

   REDEFINE BUTTON ;
      ID       160 ;
      OF       ::oFld:aDialogs[2] ;
      ACTION   ( ::BtnDefectoGrupo() )

   end if

   /*
   Caja de dialogo comun-------------------------------------------------------
   */

   ::oBrwCol                        := IXBrowse():New( if( ::lNewInforme, ::oFld:aDialogs[3], ::oFld:aDialogs[2] ) )

   ::oBrwCol:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwCol:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwCol:SetArray( ::aoCols, , , .f. )

   ::oBrwCol:nMarqueeStyle          := 5
   ::oBrwCol:lHScroll               := .f.

   ::oBrwCol:bLDblClick := {|| ::aoCols[ ::oBrwCol:nArrayAt ]:lEditCol(), ::oBrwCol:Refresh() }
   ::oBrwCol:bRClicked  := {| nRow, nCol | ::oBrwCol:LButtonDown( nRow, nCol ), ::aoCols[ ::oBrwCol:nArrayAt ]:Toogle(), ::oBrwCol:Refresh() }

   ::oBrwCol:CreateFromResource( 200 )

   with object ( ::oBrwCol:AddCol() )
      :cHeader          := "Se.Seleccionada"
      :bStrData         := {|| "" }
      :bEditValue       := {|| ::aoCols[ ::oBrwCol:nArrayAt ]:lSelect }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwCol:AddCol() )
      :cHeader          := "Columna"
      :bStrData         := {|| ::aoCols[ ::oBrwCol:nArrayAt ]:cDescrip }
      :nWidth           := 140
   end with

   with object ( ::oBrwCol:AddCol() )
      :cHeader          := "Título"
      :bStrData         := {|| ::aoCols[ ::oBrwCol:nArrayAt ]:cTitle }
      :nWidth           := 140
   end with

   with object ( ::oBrwCol:AddCol() )
      :cHeader          := "Alineación"
      :bStrData         := {|| aPad[ Max( ::aoCols[ ::oBrwCol:nArrayAt ]:nPad, 1 ) ] }
      :nWidth           := 70
   end with

   with object ( ::oBrwCol:AddCol() )
      :cHeader          := "To.Totalizada"
      :bStrData         := {|| "" }
      :bEditValue       := {|| ::aoCols[ ::oBrwCol:nArrayAt ]:lTotal }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwCol:AddCol() )
      :cHeader          := "Sp.Separación"
      :bStrData         := {|| "" }
      :bEditValue       := {|| ::aoCols[ ::oBrwCol:nArrayAt ]:lSeparador }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwCol:AddCol() )
      :cHeader          := "So.Sombra"
      :bStrData         := {|| "" }
      :bEditValue       := {|| ::aoCols[ ::oBrwCol:nArrayAt ]:lSombra }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   REDEFINE BUTTON ;
      ID       538 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[3], ::oFld:aDialogs[2] ) ;
      ACTION   ::UpColumn()

   REDEFINE BUTTON ;
      ID       539 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[3], ::oFld:aDialogs[2] ) ;
      ACTION   ::DwColumn()

   REDEFINE BUTTON ;
      ID       514 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[3], ::oFld:aDialogs[2] ) ;
      ACTION   ( ::aoCols[ ::oBrwCol:nArrayAt ]:Select(), ::oBrwCol:SetFocus(), ::oBrwCol:Refresh() )

   REDEFINE BUTTON ;
      ID       540 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[3], ::oFld:aDialogs[2] ) ;
      ACTION   ( ::aoCols[ ::oBrwCol:nArrayAt ]:UnSelect(), ::oBrwCol:SetFocus(), ::oBrwCol:Refresh() )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[3], ::oFld:aDialogs[2] ) ;
      ACTION   ( ::aoCols[ ::oBrwCol:nArrayAt ]:lEditCol(), ::oBrwCol:Refresh() )

   REDEFINE BUTTON ::oBtnOriginal ;
      ID       517;
      OF       if( ::lNewInforme, ::oFld:aDialogs[3], ::oFld:aDialogs[2] ) ;
      ACTION   ( ::PutOriginal() )

   /*
   Fuentes---------------------------------------------------------------------
   */

   REDEFINE COMBOBOX aoFont[1] VAR ::acFont[1] ;
      ID       210 ;
      ITEMS    ::aFont ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE COMBOBOX aoSizes[1] VAR ::acSizes[1] ;
      ID       220 ;
      ITEMS    aSizes ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE COMBOBOX aoEstilo[1] VAR ::acEstilo[1] ;
      ID       230 ;
      ITEMS    aEstilo ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE COMBOBOX aoFont[2] VAR ::acFont[2] ;
      ID       240 ;
      ITEMS    ::aFont ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE COMBOBOX aoSizes[2] VAR ::acSizes[2] ;
      ID       250 ;
      ITEMS    aSizes ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE COMBOBOX aoEstilo[2] VAR ::acEstilo[2] ;
      ID       260 ;
      ITEMS    aEstilo ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE COMBOBOX aoFont[3] VAR ::acFont[3] ;
      ID       270 ;
      ITEMS    ::aFont ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE COMBOBOX aoSizes[3] VAR ::acSizes[3] ;
      ID       280 ;
      ITEMS    aSizes ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE COMBOBOX aoEstilo[3] VAR ::acEstilo[3] ;
      ID       290 ;
      ITEMS    aEstilo ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE CHECKBOX oCellView VAR ::lCellView;
      ID       300 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE CHECKBOX oShadow VAR ::lShadow;
      ID       310 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE GET ::nLenPage ;
		SPINNER ;
      PICTURE  "@E 9999.99" ;
      ID       320 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE GET ::nWidthPage ;
		SPINNER ;
      PICTURE  "@E 9999.99" ;
      ID       330 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE COMBOBOX ::oOrientation VAR ::cOrientation ;
      ID       ( 420);
      ITEMS    ::aOrientation ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   /*
   Imagen----------------------------------------------------------------------
   */

   REDEFINE GET oImagen VAR ::cImagen ;
      ID       340 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   oImagen:cBmp   := "Folder"
   oImagen:bHelp  := {|| oImagen:cText( cGetFile( "*.bmp", "Selección de imagen" ) ), oImagen:lValid() }
   oImagen:bValid := {|| if( !Empty( Rtrim( ::cImagen ) ), ::oBmpImagen:LoadBmp( Rtrim( ::cImagen ) ), ), .t. }

   REDEFINE BITMAP ::oBmpImagen ;
      ID       400 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] ) ;
      FILE     ::cImagen

   REDEFINE GET ::nFilaImagen ;
		SPINNER ;
      PICTURE  "@E 9999.99" ;
      ID       360 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE GET ::nColumnaImagen ;
      SPINNER ;
      PICTURE  "@E 9999.99" ;
      ID       370 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE GET ::nAnchoImagen ;
		SPINNER ;
      PICTURE  "@E 9999.99" ;
      ID       380 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   REDEFINE GET ::nAltoImagen ;
		SPINNER ;
      PICTURE  "@E 9999.99" ;
      ID       390 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   /*
   Impresoras------------------------------------------------------------------
   */

   REDEFINE GET oPrinter VAR ::cPrinter;
         WHEN     ( .f. ) ;
         ID       350 ;
         OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   TBtnBmp():ReDefine( 351, "gc_printer2_check_16",,,,,{|| PrinterPreferences( oPrinter ) }, if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] ), .f., , .f.,  )

   /*
   Footer----------------------------------------------------------------------
   */

   REDEFINE GET ::cFooter ;
      ID       410 ;
      OF       if( ::lNewInforme, ::oFld:aDialogs[4], ::oFld:aDialogs[3] )

   /*
   Botones---------------------------------------------------------------------
   */

   REDEFINE BUTTON ::oBtnFilter ;
      ID       510 ;
      OF       ::oDlg ;
      ACTION   ( ::DlgFilter(), if( !Empty( ::oFilter:bExpresionFilter ), SetWindowText( ::oBtnFilter:hWnd, "Filtro activo" ), SetWindowText( ::oBtnFilter:hWnd, "Filtrar" ) ) )

   /*
   REDEFINE BUTTON ::oBtnData ;
      ID       520 ;
      OF       ::oDlg ;
      ACTION   ( ::GenReport( 4 ) )

   REDEFINE BUTTON ::oBtnPreview ;
      ID       530;
      OF       ::oDlg ;
      ACTION   ( ::GenReport( 1 ) )

   REDEFINE BUTTON ::oBtnPrint ;
      ID       540;
      OF       ::oDlg ;
      ACTION   ( ::GenReport( 2 ) )

   REDEFINE BUTTON ::oBtnHtml ;
      ID       IDOK ;
      OF       ::oDlg ;
      ACTION   ( ::GenReport( 3 ) )
   */

   REDEFINE BUTTON ::oBtnAction ;
      ID       560 ;
      OF       ::oDlg ;
      ACTION   ( ::GenReport() )

   REDEFINE COMBOBOX ::oCmbReport ;
      VAR      ::cCmbReport;
      ID       600;
      OF       ::oDlg ;
      ITEMS    ::aCmbReport ;
      BITMAPS  ::aBmpReport

   REDEFINE BUTTON ::oBtnCancel;
      ID       570;
      OF       ::oDlg ;
      CANCEL ;
      ACTION   ( ::lBreak := .t., ::End() )

RETURN .t.

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TInfGen

   local lActivate

   if !Empty( ::oTreeGroups )
      ::oFld:aDialogs[2]:AddFastKey( VK_F2, {|| ::AddSelectedGroup() } )
      ::oFld:aDialogs[2]:AddFastKey( VK_F4, {|| ::DelSelectedGroup() } )
   end if

   if !Empty( ::oDlg )

      ::oDlg:AddFastKey( VK_F5, {|| ::GenReport() } )

      if ::lNewInforme
         ::oDlg:bStart  := {|| ::InitDialog(), ::lRecargaFecha() }
      end if

      ::oDlg:Activate( , , , .t. )

      lActivate         := ( ::oDlg:nResult == IDOK )

   end if

RETURN ( lActivate )

//----------------------------------------------------------------------------//

Static Function lRetFld( uSearch, Alias, oSay, nFld )

   local lReturn  := .t.

   DEFAULT nFld   := 2

   if valtype( uSearch ) == "C"
      uSearch     := Upper( uSearch )
   end if

   if ( Alias )->( dbSeek( uSearch ) )
      oSay:cText( ( Alias )->( fieldGet( nFld ) ) )
   else
      msgStop( "Registro no encontrado" )
      lReturn     := .f.
   end if

Return lReturn

//----------------------------------------------------------------------------//
//
// Genera el infome
//

METHOD Print( nDevice ) CLASS TInfGen

   local n
   local nFor
   local oCol
   local aFnt     := {}
   local oRptWnd
   local oDevice

   ::oDbf:GoTop()

   for n := 1 to len( ::acFont )
      aAdd( aFnt, TFont():New( Rtrim( ::acFont[ n ] ), 0, Val( ::acSizes[ n ] ),,( "Negrita" $ ::acEstilo[ n ] ),,,,( "Cursiva" $ ::acEstilo[ n ] ),,,,,,, ) )
   next

   if !Empty( ::oFilter ) .and. !Empty( ::oFilter:cExpresionFilter )
      aAdd( ::aHeader, {|| Padr( "Filtro", 13 ) + ": " + cValToChar( ::oFilter:cExpresionFilter ) } )
   end if

   if !Empty( ::cFooter )
      aSize( ::aFooter, Len( ::aFooter ) + 1 )
      aIns( ::aFooter, 1 )
      ::aFooter[ 1 ]    := {|| RTrim( ::cFooter ) }
   end if

   do case
   case nDevice == 1

      /*
      if !Empty( ::cPrinter )
         oDevice  := TPrinter():New( Rtrim( ::cTitle ), .f., .t., Rtrim( ::cPrinter ) )
      end if
      */

      ::oReport   := RptBegin({ {|| Rtrim( ::cTitle ) }, {|| Rtrim( ::cAliasTitle ) } },;          //aTitle   ,;
                              ::aHeader ,;                                                         //aHead    ,;
                              ::aFooter,;                                                          //aFoot    ,;
                              aFnt,;                                                               //aFont    ,;
                              {},;                                                                 //aPen     ,;
                              .f.,;                                                                //lSummary ,;
                              nil,;                                                                //cRptfile ,;
                              nil,;                                                                //cResName ,;
                              .f.,;                                                                //lPrint   ,;
                              .t.,;                                                                //lScreen  ,;
                              nil,;                                                                //cFile    ,;
                              oDevice,;                                                            //oDevice  ,;
                              Rtrim( ::cTitle ),;                                                  //cName    ,;
                              "CENTERED",;                                                         //cTFmt    ,;
                              "LEFT",;                                                             //cHFmt    ,;
                              "CENTERED" )                                                         //cFFmt)

   case nDevice == 2
      /*
      if !Empty( ::cPrinter )
         oDevice  := TPrinter():New( Rtrim( ::cTitle ), .f., .f., Rtrim( ::cPrinter ) )
      end if
      */
      ::oReport   := RptBegin({ {|| Rtrim( ::cTitle ) }, {|| Rtrim( ::cAliasTitle ) } },;          //aTitle   ,;
                              ::aHeader ,;                                                         //aHead    ,;
                              ::aFooter,;                                                          //aFoot    ,;
                              aFnt,;                                                               //aFont    ,;
                              {},;                                                                 //aPen     ,;
                              .f.,;                                                                //lSummary ,;
                              nil,;                                                                //cRptfile ,;
                              nil,;                                                                //cResName ,;
                              .t.,;                                                                //lPrint   ,;
                              .f.,;                                                                //lScreen  ,;
                              nil,;                                                                //cFile    ,;
                              oDevice,;                                                            //oDevice  ,;
                              Rtrim( ::cTitle ),;                                                  //cName    ,;
                              "CENTERED",;                                                         //cTFmt    ,;
                              "LEFT",;                                                             //cHFmt    ,;
                              "CENTERED" )                                                         //cFFmt)                cRptfile ,;

   case nDevice == 5

      ::oReport   := RptBegin({ {|| Rtrim( ::cTitle ) }, {|| Rtrim( ::cAliasTitle ) } },;          //aTitle   ,;
                              ::aHeader ,;                                                         //aHead    ,;
                              ::aFooter,;                                                          //aFoot    ,;
                              aFnt,;                                                               //aFont    ,;
                              {},;                                                                 //aPen     ,;
                              .f.,;                                                                //lSummary ,;
                              nil,;                                                                //cRptfile ,;
                              nil,;                                                                //cResName ,;
                              .f.,;                                                                //lPrint   ,;
                              .t.,;                                                                //lScreen  ,;
                              nil,;                                                                //cFile    ,;
                              oDevice,;                                                            //oDevice  ,;
                              Rtrim( ::cTitle ),;                                                  //cName    ,;
                              "CENTERED",;                                                         //cTFmt    ,;
                              "LEFT",;                                                             //cHFmt    ,;
                              "CENTERED" )                                                         //cFFmt)                cRptfile ,;

   case nDevice == 3

      DEFINE DIALOG oRptWnd TITLE Rtrim( ::cTitle ) RESOURCE "PREVIEW_PROC"

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oRptWnd ;
         ACTION   ( ::lBreak := .t. ) ;
         WHEN     ( !::lNoCancel )

      oRptWnd:bStart := {|| ::Xml(), oRptWnd:End()}

      ACTIVATE DIALOG oRptWnd CENTER

      GoWeb( cPatTmp() + "Report.Xls" )

   case nDevice == 4

      oDevice     := TRCcs():New( cPatHtml() + "Rep" )

      ::oReport   := RptBegin({ {|| Rtrim( ::cTitle ) }, {|| Rtrim( ::cAliasTitle ) } },;            //aTitle   ,;
                              ::aHeader ,;                                                         //aHead    ,;
                              ::aFooter,;                                                          //aFoot    ,;
                              aFnt,;                                                               //aFont    ,;
                              {},;                                                                 //aPen     ,;
                              .f.,;                                                                //lSummary ,;
                              nil,;                                                                //cRptfile ,;
                              nil,;                                                                //cResName ,;
                              .f.,;                                                                //lPrint   ,;
                              .f.,;                                                                //lScreen  ,;
                              nil,;                                                                //cFile    ,;
                              oDevice,;                                                            //oDevice  ,;
                              Rtrim( ::cTitle ),;                                                  //cName    ,;
                              "CENTERED",;                                                         //cTFmt    ,;
                              "LEFT",;                                                             //cHFmt    ,;
                              "CENTERED" )                                                         //cFFmt)                cRptfile ,;

   end case

   if ( nDevice != 3 )

      for nFor := 1 to len( ::aoCols )

         if ::aoCols[ nFor ] != nil .and. ::aoCols[ nFor ]:lSelect

            oCol  := RptAddColumn(  { bHeaders( nFor, Self ) } ,;       // aTitle
                                    ,;                                  // nCol
                                    { bFlds( nFor, Self ) } ,;          // aData
                                    ::aoCols[ nFor ]:nSize ,;           // nSize ::aColSizes[ nFor ]
                                    { cPicture( nFor, Self ) } ,;       // aPicture
                                    ::aoCols[ nFor ]:bFont ,;           // uFont
                                    ::aoCols[ nFor ]:lTotal ,;          // lTotal
                                    nil ,;                              // bTotalExpr
                                    nil ,;                              // cColFmt
                                    ::aoCols[ nFor ]:lSombra ,;         // lShadow
                                    ::aoCols[ nFor ]:lSeparador ,;      // lGrid
                                    nil )                               // nPen)

            if ::aoCols[ nFor ]:Cargo != nil
               oCol:Cargo  := ::aoCols[ nFor ]:Cargo
            end if

         end if

      next

      if !::lNoGroup

         for nFor := 1 to len( ::aoGroup )

            RptAddGroup( ::aoGroup[ nFor ]:bGroup,;
                         ::aoGroup[ nFor ]:bHeader,;
                         ::aoGroup[ nFor ]:bFooter,;
                         ::aoGroup[ nFor ]:bHeadFont,;
                         ::aoGroup[ nFor ]:lEject )
         next

      end if

      END REPORT

      if !Empty( ::oReport ) .and. ::oReport:lCreated

         ::oReport:SetTxtColor( CLR_HBLUE, 3 )

         ::oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS)
         ::oReport:Margin( 0, RPT_LEFT, RPT_CMETERS)

         ::oReport:lSummary         := if( ::lResumen != nil, ::lResumen, .f. )
         ::oReport:bSkip            := {|| ::oDbf:Skip( 1 ) }

         if !Empty( ::nWidthPage ) .and. !Empty( ::nLenPage )
            ::oReport:oDevice:SetSize( ::nLenPage * 100, ::nWidthPage * 100 )
         end if

         ::oReport:oDevice:lPrvModal   := .t.

         do case
            case ::oOrientation:nAt == 1
               ::oReport:lAutoLand  := .t.
               ::oReport:lIsNarrow  := .f.

            case ::oOrientation:nAt == 2
               ::oReport:lAutoLand  := .f.
               ::oReport:lIsNarrow  := .f.

            case ::oOrientation:nAt == 3
               ::oReport:lAutoLand  := .f.
               ::oReport:lIsNarrow  := .t.

         end case

         if ::lShadow
            ::oReport:lShadow       := .t.
            ::oReport:bStartRecord  := {|| ::Shadows() }
            ::oReport:bEndRecord    := {|| ( aEval( ::oReport:aColumns, {|o| o:lShadow  := .f. } ) ) }
         end if

         if !Empty( ::cImagen )
            ::oReport:bStartPage    := {|| ::oReport:SayBitmap( ::nFilaImagen, ::nColumnaImagen, Rtrim( ::cImagen ), ::nAnchoImagen, ::nAltoImagen, RPT_CMETERS ) }
         end if

         if ::lCellView
            ::oReport:CellView()
         end if

      end if

      if !Empty( ::oReport )
         ::oReport:Activate( ::bForReport, {|| !::oDbf:eof() }, , , , , ::bStartGroup, ::bEndGroup, , , , , , ::bPostGroup )
      end if

   end if

   aEval( aFnt, {|oFnt| oFnt:end() } )

   //::aoGroup   := {}

   if nDevice == 4
      ::MakeVisor()
   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Shadows()

   local n
   local lValor   := !::lShadowLine

   for n := 1 to Len( ::oReport:aColumns )
      ::oReport:aColumns[ n ]:lShadow  := lValor
   next

   ::lShadowLine  := lValor

RETURN NIL

//---------------------------------------------------------------------------//

static function bHeaders( nFor, Self )

return {|| ::aoCols[ nFor ]:cTitle }

//----------------------------------------------------------------------------//

static function bFlds( nFor, Self )

return ( ::aoCols[ nFor ]:bFld ) // {|| msginfo( nFor ), nFor } ) //(

//----------------------------------------------------------------------------//

static function cPicture( nFor, Self )

   if valType( ::aoCols[ nFor ]:bPict ) == "C"
      return ::aoCols[ nFor ]:bPict
   end if

return ( Eval( ::aoCols[ nFor ]:bPict ) )

//----------------------------------------------------------------------------//

METHOD UpColumn() CLASS TInfGen

   local nPos  := ::oBrwCol:nArrayAt

   if nPos <= len( ::aoCols ) .and. nPos > 1

      SwapUpArray( ::aoCols, nPos )

      ::oBrwCol:GoUp()
      ::oBrwCol:Refresh()
      ::oBrwCol:SetFocus()

   end if

return nil

//----------------------------------------------------------------------------//

METHOD DwColumn() CLASS TInfGen

   local nPos  := ::oBrwCol:nArrayAt

   if nPos < len( ::aoCols ) .and. nPos > 0

      SwapDwArray( ::aoCols, nPos )

      ::oBrwCol:GoDown()
      ::oBrwCol:Refresh()
      ::oBrwCol:SetFocus()

   end if

return nil

//----------------------------------------------------------------------------//
//
// Este metodo compara los valores con el fichero ini
//

METHOD Default() CLASS TInfGen

   local n        := 0
   local nPos
   local nCols    := len( ::aoCols )
   local atCols   := Array( nCols )

   ::cSupTitle    := Padr( cCodEmp() + " - " + cNbrEmp(), 50 )

   /*
   Orden de las columnas-------------------------------------------------------
   */

   if ::oDbfInf:Seek( Auth():Codigo() + ::cSubTitle )

      while Rtrim( Auth():Codigo() + ::cSubTitle ) == Rtrim( ::oDbfInf:cCodUse + ::oDbfInf:cNomInf ) .and. !::oDbfInf:eof()

         ++n

         nPos                       := ::oDbfInf:nPosInf

         if nPos <= nCols .and. n <= nCols
            atCols[ n ]             := ::aoCols[ nPos ]
            atCols[ n ]:lSelect     := ::oDbfInf:lSelInf
            atCols[ n ]:cTitle      := Rtrim( ::oDbfInf:cTitInf )
            atCols[ n ]:nSize       := ::oDbfInf:nSizInf
            atCols[ n ]:nPad        := if( ::oDbfInf:lAlnInf, 2, 1 )
            atCols[ n ]:lTotal      := ::oDbfInf:lTotInf
            atCols[ n ]:lSombra     := ::oDbfInf:lSomInf
            atCols[ n ]:lSeparador  := ::oDbfInf:lSepInf
         end if

         ::oDbfInf:Skip()

      end while

      if nCols == n
         ::aoCols                   := atCols
      end if

   end if

   /*
   Cargamos las fuentes del informe--------------------------------------------
   */

   if ::oDbfFnt:Seek( Auth():Codigo() + ::cSubTitle )
      ::acFont  [ 1 ]            := ::oDbfFnt:cFntIn1
      ::acSizes [ 1 ]            := Str( ::oDbfFnt:nSizIn1, 3 )
      ::acEstilo[ 1 ]            := ::oDbfFnt:cStyIn1
      ::acFont  [ 2 ]            := ::oDbfFnt:cFntIn2
      ::acSizes [ 2 ]            := Str( ::oDbfFnt:nSizIn2, 3 )
      ::acEstilo[ 2 ]            := ::oDbfFnt:cStyIn2
      ::acFont  [ 3 ]            := ::oDbfFnt:cFntIn3
      ::acSizes [ 3 ]            := Str( ::oDbfFnt:nSizIn3, 3 )
      ::acEstilo[ 3 ]            := ::oDbfFnt:cStyIn3
      ::lCellView                := ::oDbfFnt:lCelVie
      ::lShadow                  := ::oDbfFnt:lShadow
      ::nWidthPage               := ::oDbfFnt:nWidPag
      ::nLenPage                 := ::oDbfFnt:nLenPag
      ::cPrinter                 := PrnGetName()
      ::cImagen                  := ::oDbfFnt:cImgInf
      ::nFilaImagen              := ::oDbfFnt:nRowImg
      ::nColumnaImagen           := ::oDbfFnt:nColImg
      ::nAnchoImagen             := ::oDbfFnt:nWidImg
      ::nAltoImagen              := ::oDbfFnt:nHeiImg
      ::nCmbReport               := ::oDbfFnt:nDisInf
      ::nOrientation             := ::oDbfFnt:nOrnInf
      ::cAliasTitle              := ::oDbfFnt:cAliInf
   end if

   if Empty( ::nCmbReport )
      ::nCmbReport               := 1
   end if

   if Empty( ::nOrientation )
      ::nOrientation             := 1
   end if

   ::cCmbReport                  := ::aCmbReport[ Min( Max( ::nCmbReport, 1 ), len( ::aCmbReport ) ) ]
   ::cOrientation                := ::aOrientation[ Min( Max( ::nOrientation, 1 ), len( ::aOrientation ) ) ]

   if Empty( ::cAliasTitle )
      ::cAliasTitle              := Padr( ::cSubTitle, 100 )
   else
      ::cAliasTitle              := Padr( ::cAliasTitle, 100 )
   end if

Return nil

//----------------------------------------------------------------------------//

METHOD Save() CLASS TInfGen

   local n
   local nCols
   local cCurUsr        := Auth():Codigo()

   if !Empty( ::oDbfInf ) .and. ::oDbfInf:Used()

      if !Empty( ::oMtrInf )
         ::oMtrInf:cText   := "Guardando configuración"
      end if

      while ::oDbfInf:Seek( cCurUsr + ::cSubTitle )
         ::oDbfInf:Delete( .f. )
      end while

      nCols             := len( ::aoCols )

      if !Empty( ::oMtrInf )
         ::oMtrInf:SetTotal( nCols )
      end if

      /*
      Guardamos las columnas---------------------------------------------------
      */

      for n := 1 to nCols

         if ::aoCols[ n ] != nil

            ::oDbfInf:Append()

            ::oDbfInf:cCodUse := cCurUsr
            ::oDbfInf:cNomInf := ::cSubTitle
            ::oDbfInf:lSelInf := ::aoCols[ n ]:lSelect
            ::oDbfInf:cTitInf := ::aoCols[ n ]:cTitle
            ::oDbfInf:nPosInf := ::aoCols[ n ]:nPos
            ::oDbfInf:nSizInf := ::aoCols[ n ]:nSize
            ::oDbfInf:lTotInf := ::aoCols[ n ]:lTotal
            ::oDbfInf:lSomInf := ::aoCols[ n ]:lSombra
            ::oDbfInf:lSepInf := ::aoCols[ n ]:lSeparador
            ::oDbfInf:lAlnInf := ( ::aoCols[ n ]:nPad == 2 )

            ::oDbfInf:Save()

         end if

         if !Empty( ::oMtrInf )
            ::oMtrInf:AutoInc( n )
         end if

      next

      if !Empty( ::oMtrInf )
         ::oMtrInf:SetTotal( nCols )
      end if

   end if

   /*
   Archivamos las fuentes del informe------------------------------------------
   */

   if !Empty( ::oDbfFnt ) .and. ::oDbfFnt:Used()

      while ::oDbfFnt:Seek( cCurUsr + ::cSubTitle )
         ::oDbfFnt:Delete( .f. )
      end while

      ::oDbfFnt:Append()

      ::oDbfFnt:cCodUse := cCurUsr
      ::oDbfFnt:cNomInf := ::cSubTitle
      ::oDbfFnt:cFntIn1 := ::acFont[ 1 ]
      ::oDbfFnt:nSizIn1 := Val( ::acSizes [ 1 ] )
      ::oDbfFnt:cStyIn1 := ::acEstilo[ 1 ]
      ::oDbfFnt:cFntIn2 := ::acFont[ 2 ]
      ::oDbfFnt:nSizIn2 := Val( ::acSizes [ 2 ] )
      ::oDbfFnt:cStyIn2 := ::acEstilo[ 2 ]
      ::oDbfFnt:cFntIn3 := ::acFont[ 3 ]
      ::oDbfFnt:nSizIn3 := Val( ::acSizes [ 3 ] )
      ::oDbfFnt:cStyIn3 := ::acEstilo[ 3 ]
      ::oDbfFnt:lCelVie := ::lCellView
      ::oDbfFnt:lShadow := ::lShadow
      ::oDbfFnt:nWidPag := ::nWidthPage
      ::oDbfFnt:nLenPag := ::nLenPage
      ::oDbfFnt:cImgInf := ::cImagen
      ::oDbfFnt:nRowImg := ::nFilaImagen
      ::oDbfFnt:nColImg := ::nColumnaImagen
      ::oDbfFnt:nWidImg := ::nAnchoImagen
      ::oDbfFnt:nHeiImg := ::nAltoImagen
      ::oDbfFnt:nDisInf := ::oCmbReport:nAt
      ::oDbfFnt:nOrnInf := ::oOrientation:nAt
      ::oDbfFnt:cAliInf := ::cAliasTitle

      ::oDbfFnt:Save()

   end if

   /*
   Archivamos las columnas del informe-----------------------------------------
   */

   if !Empty( ::oDbfGrp ) .and. ::oDbfGrp:Used()

      while ::oDbfGrp:Seek( cCurUsr + ::cSubTitle )
         ::oDbfGrp:Delete( .f. )
      end while

      nCols             := len( ::aSelectedGroup )

      for n := 1 to nCols

         ::oDbfGrp:Append()

         ::oDbfGrp:cCodUse := cCurUsr
         ::oDbfGrp:cNomInf := ::cSubTitle
         ::oDbfGrp:cNomGrp := ::aSelectedGroup[ n ]:Cargo:Nombre

         ::oDbfGrp:Save()

      next

   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD oDefYea( nId ) CLASS TInfGen

   local oGet

   DEFAULT nId := 1110

   REDEFINE GET oGet VAR ::nYeaInf;
		SPINNER ;
      ID       nId ;
      OF       ::oFld:aDialogs[1]

RETURN ( oGet )

//----------------------------------------------------------------------------//

METHOD oDefIniInf( nId, oDlg, nIdSay ) CLASS TInfGen

   //local oGet
   local oGroup

   DEFAULT nId       := 1110
   DEFAULT oDlg      := ::oFld:aDialogs[1]

   REDEFINE GET      ::oIniInf ;
      VAR            ::dIniInf ;
		SPINNER ;
      ID             nId ;
      OF             oDlg

   ::oIniInf:bHelp   := {|| ::oIniInf:cText( Calendario( ::dIniInf ) ) }

   if IsNum( nIdSay )

   REDEFINE SAY      ::oIniText ;
      PROMPT         "Desde" ;
      ID             nIdSay ;
      OF             oDlg

   end if

   if ::lGrpFecInf

      oGroup         := TRGroup():New( {|| ::oDbf:dFecMov }, {|| "Fecha : " + Dtoc( ::oDbf:dFecMov ) }, {|| "Total fecha..." }, {|| 3 }, ::lSalto )

      oGroup:Cargo            := TItemGroup()
      oGroup:Cargo:Nombre     := "Fecha"
      oGroup:Cargo:Expresion  := "Dtos( dFecMov )"

      aAdd( ::aSelectionGroup, oGroup )

      if ::oImageGroup != nil
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_calendar_16" ), Rgb( 255, 0, 255 ) )
         oGroup:Cargo:Imagen     := len( ::oImageGroup:aBitmaps ) -1
      end if

   end if

RETURN ( ::oIniInf )

//---------------------------------------------------------------------------//

METHOD oDefFinInf( nId, oDlg, nIdSay ) CLASS TInfGen

   //local oGet

   DEFAULT nId       := 1120
   DEFAULT oDlg      := ::oFld:aDialogs[1]

   REDEFINE GET      ::oFinInf ;
      VAR            ::dFinInf ;
		SPINNER ;
      ID             nId ;
      OF             oDlg

   ::oFinInf:bHelp   := {|| ::oFinInf:cText( Calendario( ::dFinInf ) ) }

   if IsNum( nIdSay )

   REDEFINE SAY   ::oFinText ;
      PROMPT      "Hasta" ;
      ID          nIdSay ;
      OF          oDlg

   end if

RETURN ( ::oFinInf )

//---------------------------------------------------------------------------//

METHOD oDefDivInf( nId, nIdBmp, oDlg ) CLASS TInfGen

   local This     := Self

   DEFAULT nId    := 1130
   DEFAULT nIdBmp := 1131
   DEFAULT oDlg   := ::oFld:aDialogs[1]

   DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   ::oBandera     := TBandera():New()

   REDEFINE GET ::oDivInf VAR ::cDivInf ;
		PICTURE     "@!";
      ID          nId ;
      BITMAP      "LUPA" ;
      VALID       ( ::lLoadDivisa() ) ;
      ON HELP     ( BrwDiv( This:oDivInf, This:oBmpDiv, nil, This:oDbfDiv:cAlias, This:oBandera ), This:lLoadDivisa() );
      OF          oDlg

   REDEFINE BITMAP ::oBmpDiv ;
      RESOURCE    "BAN_EURO" ;
      ID          nIdBmp ;
      OF          oDlg

   ::lLoadDivisa()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD oDefTitInf( nIdTitle, nIdSubTitle ) CLASS TInfGen

   DEFAULT nIdTitle     := 1140
   DEFAULT nIdSubTitle  := 1150

   REDEFINE GET ::cTitle ;
      ID       nIdTitle ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::cAliasTitle ;
      ID       nIdSubTitle ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD oDefPrvInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllPrv ) CLASS TInfGen

   local oPrvDesde
   local oPrvHasta
   local oSayPrvDes
   local cSayPrvDes
   local oSayPrvHas
   local cSayPrvHas
   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DEFAULT nIdOrg    := 100
   DEFAULT nIdSayOrg := 101
   DEFAULT nIdDes    := 110
   DEFAULT nIdSayDes := 111

   DATABASE NEW ::oDbfPrv PATH ( cPatEmp() ) FILE "PROVEE.DBF" VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cPrvOrg   := dbFirst ( ::oDbfPrv, 1 )
   ::cPrvDes   := dbLast  ( ::oDbfPrv, 1 )
   cSayPrvDes  := dbFirst ( ::oDbfPrv, 2 )
   cSayPrvHas  := dbLast  ( ::oDbfPrv, 2 )

   if !Empty( nIdAllPrv )
   ::lAllPrv      := .t.
   REDEFINE CHECKBOX ::lAllPrv ;
      ID       ( nIdAllPrv ) ;
      OF       ::oFld:aDialogs[1]
   else
      ::lAllPrv   := .f.
   end if

   REDEFINE GET oPrvDesde VAR ::cPrvOrg;
      ID       ( nIdOrg );
      WHEN     ( !::lAllPrv );
      VALID    cProvee( oPrvDesde, ::oDbfPrv:cAlias, oSayPrvDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwProvee( oPrvDesde, oSayPrvDes ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayPrvDes VAR cSayPrvDes ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oPrvHasta VAR ::cPrvDes ;
      ID       ( nIdDes );
      WHEN     ( !::lAllPrv );
      VALID    cProvee( oPrvHasta, ::oDbfPrv:cAlias, oSayPrvHas ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwProvee( oPrvHasta, oSayPrvHas ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayPrvHas VAR cSayPrvHas ;
      ID       ( nIdSayDes );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfPrv )
         ::oDbfPrv:End()
      end if
      lOpen          := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD oDefMetInf( nId, oDlg ) CLASS TInfGen

   DEFAULT nId    := 1160
   DEFAULT oDlg   := ::oFld:aDialogs[1]

 REDEFINE APOLOMETER ::oMtrInf ;
      VAR         ::nMtrInf ;
		PROMPT	   "Procesando" ;
      ID          nId;
      TOTAL       100 ;
      OF          oDlg

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD oDefSerInf( oDlg ) CLASS TInfGen

   DEFAULT oDlg   := ::oFld:aDialogs[1]

   TWebBtn():Redefine(1170,,,,, {|This| ( aEval( ::oSer, {|o| Eval( o:bSetGet, .T. ), o:refresh() } ) ) }, oDlg,,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ) ):SetTransparent()

   TWebBtn():Redefine(1180,,,,, {|This| ( aEval( ::oSer, {|o| Eval( o:bSetGet, .F. ), o:refresh() } ) ) }, oDlg,,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ) ):SetTransparent()

   REDEFINE CHECKBOX ::oSer[  1 ] VAR ::aSer[  1 ] ID 1190 OF oDlg //A
   REDEFINE CHECKBOX ::oSer[  2 ] VAR ::aSer[  2 ] ID 1200 OF oDlg //B
   REDEFINE CHECKBOX ::oSer[  3 ] VAR ::aSer[  3 ] ID 1210 OF oDlg //C
   REDEFINE CHECKBOX ::oSer[  4 ] VAR ::aSer[  4 ] ID 1220 OF oDlg //D
   REDEFINE CHECKBOX ::oSer[  5 ] VAR ::aSer[  5 ] ID 1230 OF oDlg //E
   REDEFINE CHECKBOX ::oSer[  6 ] VAR ::aSer[  6 ] ID 1240 OF oDlg //F
   REDEFINE CHECKBOX ::oSer[  7 ] VAR ::aSer[  7 ] ID 1250 OF oDlg //G
   REDEFINE CHECKBOX ::oSer[  8 ] VAR ::aSer[  8 ] ID 1260 OF oDlg //H
   REDEFINE CHECKBOX ::oSer[  9 ] VAR ::aSer[  9 ] ID 1270 OF oDlg //I
   REDEFINE CHECKBOX ::oSer[ 10 ] VAR ::aSer[ 10 ] ID 1280 OF oDlg //J
   REDEFINE CHECKBOX ::oSer[ 11 ] VAR ::aSer[ 11 ] ID 1290 OF oDlg //K
   REDEFINE CHECKBOX ::oSer[ 12 ] VAR ::aSer[ 12 ] ID 1300 OF oDlg //L
   REDEFINE CHECKBOX ::oSer[ 13 ] VAR ::aSer[ 13 ] ID 1310 OF oDlg //M
   REDEFINE CHECKBOX ::oSer[ 14 ] VAR ::aSer[ 14 ] ID 1320 OF oDlg //N
   REDEFINE CHECKBOX ::oSer[ 15 ] VAR ::aSer[ 15 ] ID 1330 OF oDlg //O
   REDEFINE CHECKBOX ::oSer[ 16 ] VAR ::aSer[ 16 ] ID 1340 OF oDlg //P
   REDEFINE CHECKBOX ::oSer[ 17 ] VAR ::aSer[ 17 ] ID 1350 OF oDlg //Q
   REDEFINE CHECKBOX ::oSer[ 18 ] VAR ::aSer[ 18 ] ID 1360 OF oDlg //R
   REDEFINE CHECKBOX ::oSer[ 19 ] VAR ::aSer[ 19 ] ID 1370 OF oDlg //S
   REDEFINE CHECKBOX ::oSer[ 20 ] VAR ::aSer[ 20 ] ID 1380 OF oDlg //T
   REDEFINE CHECKBOX ::oSer[ 21 ] VAR ::aSer[ 21 ] ID 1390 OF oDlg //U
   REDEFINE CHECKBOX ::oSer[ 22 ] VAR ::aSer[ 22 ] ID 1400 OF oDlg //V
   REDEFINE CHECKBOX ::oSer[ 23 ] VAR ::aSer[ 23 ] ID 1410 OF oDlg //W
   REDEFINE CHECKBOX ::oSer[ 24 ] VAR ::aSer[ 24 ] ID 1420 OF oDlg //X
   REDEFINE CHECKBOX ::oSer[ 25 ] VAR ::aSer[ 25 ] ID 1430 OF oDlg //Y
   REDEFINE CHECKBOX ::oSer[ 26 ] VAR ::aSer[ 26 ] ID 1440 OF oDlg //Z

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddField( cNomCol, cType, nSize, nDec, bPicCol, cHeaCol, lSelect, cComment, nColSize, lTotal, bFont, bStartTotal ) CLASS TInfGen

   DEFAULT cNomCol   := "NomCol"
   DEFAULT cType     := "C"
   DEFAULT nSize     := 10
   DEFAULT nDec      := 0
   DEFAULT bPicCol   := {|| "@!" }
   DEFAULT cHeaCol   := "Nombre"
   DEFAULT lSelect   := .f.
   DEFAULT nColSize  := ( nSize + nDec )
   DEFAULT lTotal    := ( cType == "N" )
   DEFAULT bFont     := {|| 2 }

   aAdd( ::aFields, { cNomCol, cType, nSize, nDec, bPicCol, cHeaCol, lSelect, cComment, nColSize, lTotal, bFont, bStartTotal } )

   ::oDbf:AddField( cNomCol, cType, nSize, nDec, bPicCol, lSelect, nil, nil, cHeaCol, cComment, nColSize )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddTmpIndex( cName, cKey, cFor, bWhile, lUniq, lDes ) CLASS TInfGen

   DEFAULT cName  := "cIndex"
   DEFAULT cKey   := "cIndex"

   aAdd( ::aIndex, { cName, cKey, cFor, bWhile, lUniq, lDes } )

return ( self )

//---------------------------------------------------------------------------//

METHOD CreateColumn() CLASS TInfGen

   local n
   local oCol
   local bFld
   local cTitCol
   local bPict
   local lSelect
   local nAlign
   local lTotal
   local lSepLin
   local lSombra
   local nSize
   local cComment
   local Cargo
   local bFont

   /*
   Cargamos las fuentes--------------------------------------------------------
   */

   ::aFont     := aGetFont()
   ::acSizes   := { "10", "10", "10", "40", "60", "70" }
   ::acEstilo  := { "Normal", "Normal", "Negrita", "Normal", "Normal", "Normal" }
   ::acFont    := { "Courier New", "Courier New", "Courier New", "UPCHeightA", "Code 39", "Code128B" }
   ::aoCols    := {}

   /*
   Creamos todas las columnas--------------------------------------------------
   */

   for n := 1 to len( ::aFields )

      bFld     := gfBlock( ::aFields[ n, 1 ], ::oDbf:nArea )
      cTitCol  := if( ValType( ::aFields[ n, 6 ] ) == "B", Eval( ::aFields[ n, 6 ] ), ::aFields[ n, 6 ] )
      bPict    := ::aFields[ n, 5 ]
      lSelect  := ::aFields[ n, 7 ]
      nAlign   := if( ::aFields[ n, 2 ] != "N", 1, 2 )
      lTotal   := if( ::aFields[ n, 10 ] == nil, ::aFields[ n, 2 ] == "N", ::aFields[ n, 10 ] )
      lSepLin  := .f.
      lSombra  := .f.
      nSize    := if( len( ::aFields[n] ) < 9, ::aFields[ n, 3 ] + ::aFields[ n, 4 ], ::aFields[ n, 9 ] )
      cComment := if( ValType( ::aFields[ n, 8 ] ) == "B", Eval( ::aFields[ n, 8 ] ), ::aFields[ n, 8 ] )
      bFont    := if( len( ::aFields[n] ) >= 11, ::aFields[ n, 11 ], {|| 2 } )

      oCol     := TInfCols():New(   bFld,;
                                    cTitCol,;
                                    bPict,;
                                    lSelect,;
                                    nAlign,;
                                    lTotal,;
                                    lSepLin,;
                                    lSombra,;
                                    n,;
                                    nSize,;
                                    cComment,;
                                    bFont,;
                                    Cargo,;
                                    Self )

      if len( ::aFields[n] ) >= 12
         oCol:bStartTotal  := ::aFields[ n, 12 ]
      end if

      aAdd( ::aoCols, oCol )

   next

RETURN NIL

//----------------------------------------------------------------------------//

METHOD AddGroup( bGroup , bHeader, bFooter, bFont, lEject ) CLASS TInfGen

   local oGrp

   DEFAULT bGroup    := {|| ""}
   DEFAULT bHeader   := {|| ""}
   DEFAULT bFooter   := {|| "Total..."}
   DEFAULT bFont     := {|| 3 }
   DEFAULT lEject    := ::lSalto

   oGrp              := TRGroup():New( bGroup, bHeader, bFooter, bFont, lEject )

   aAdd( ::aoGroup, oGrp )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD DelGroup( nGroup )

   DEFAULT nGroup := len( ::aoGroup )

   aDel( ::aoGroup, nGroup )
   aSize( ::aoGroup, len( ::aoGroup ) - 1 )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD lDefArtInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllArt, lInitGroup ) CLASS TInfGen

   local oGroup
   local oArtOrg
   local oArtDes
   local oSayArtOrg
   local oSayArtDes
   local cSayArtOrg
   local cSayArtDes
   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT nIdOrg       := 70
   DEFAULT nIdSayOrg    := 71
   DEFAULT nIdDes       := 80
   DEFAULT nIdSayDes    := 81

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ::oDbfArt == nil .or. !::oDbfArt:Used()
      DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"
   end if

   /*
	Obtenemos los valores del primer y ultimo codigo
	*/

   ::cArtOrg   := dbFirst( ::oDbfArt, 1 )
   ::cArtDes   := dbLast(  ::oDbfArt, 1 )
   cSayArtOrg  := dbFirst( ::oDbfArt, 2 )
   cSayArtDes  := dbLast(  ::oDbfArt, 2 )

   if !Empty( nIdAllArt )

   ::lAllArt   := .t.

   REDEFINE CHECKBOX ::lAllArt ;
      ID       ( nIdAllArt ) ;
      OF       ::oFld:aDialogs[1]

   else

   ::lAllArt   := .f.

   end if

   REDEFINE GET oArtOrg VAR ::cArtOrg;
      ID       ( nIdOrg ) ;
      WHEN     ( !::lAllArt );
      VALID    cArticulo( oArtOrg, ::oDbfArt:cAlias, oSayArtOrg );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArtOrg, oSayArtOrg, , .f. );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayArtOrg VAR cSayArtOrg ;
		WHEN 		.F.;
      ID       ( nIdSayOrg ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oArtDes VAR ::cArtDes;
      ID       ( nIdDes ) ;
      WHEN     ( !::lAllArt );
      VALID    cArticulo( oArtDes, ::oDbfArt:cAlias, oSayArtDes );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oArtDes, oSayArtDes, , .f. );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayArtDes VAR cSayArtDes ;
		WHEN 		.F.;
      ID       ( nIdSayDes ) ;
      OF       ::oFld:aDialogs[1]

   if lInitGroup != nil

      oGroup         := TRGroup():New( {|| ::oDbf:cCodArt }, {|| "Artículo : " + AllTrim( ::oDbf:cCodArt ) + " - " + AllTRim( ::oDbf:cNomArt ) }, {|| "Total artículo..." }, {|| 3 }, ::lSalto )

      oGroup:Cargo            := TItemGroup()
      oGroup:Cargo:Nombre     := "Artículo"
      oGroup:Cargo:Expresion  := "cCodArt"

      aAdd( ::aSelectionGroup, oGroup )

      if lInitGroup
         aAdd( ::aInitGroup, oGroup )
      end if

   end if

   aAdd( ::aHeader, {|| Padr( "Artículos", 12 ) + ": " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) } )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfArt )
         ::oDbfArt:End()
      end if

      lOpen          := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD lIntArtInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllArt, dbfArticulo, dbfDiv, dbfArtKit, dbfIva ) CLASS TInfGen

   local oArtOrg
   local oArtDes
   local oSayArtOrg
   local oSayArtDes
   local cSayArtOrg
   local cSayArtDes
   local oError
   local oBlock
   local lOpen       := .t.

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
	Obtenemos los valores del primer y ultimo codigo
	*/

   ::cArtOrg         := dbFirst( dbfArticulo, 1 )
   ::cArtDes         := dbLast(  dbfArticulo, 1 )
   cSayArtOrg        := dbFirst( dbfArticulo, 2 )
   cSayArtDes        := dbLast(  dbfArticulo, 2 )

   if !Empty( nIdAllArt )

      ::lAllArt      := .t.

      REDEFINE CHECKBOX ::lAllArt ;
         ID    ( nIdAllArt ) ;
         OF    ::oFld:aDialogs[1]

   else

      ::lAllArt      := .f.

   end if

   REDEFINE GET oArtOrg VAR ::cArtOrg;
      ID       ( nIdOrg ) ;
      WHEN     ( !::lAllArt );
      VALID    cArticulo( oArtOrg, dbfArticulo, oSayArtOrg );
      BITMAP   "LUPA" ;
      ON HELP  BrwSelArticulo( oArtOrg, oSayArtOrg, , .f., .f., .f. );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayArtOrg VAR cSayArtOrg ;
      WHEN     .f.;
      ID       ( nIdSayOrg ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oArtDes VAR ::cArtDes;
      ID       ( nIdDes ) ;
      WHEN     ( !::lAllArt );
      VALID    cArticulo( oArtDes, dbfArticulo, oSayArtDes );
      BITMAP   "LUPA" ;
      ON HELP  BrwSelArticulo( oArtDes, oSayArtDes, , .f., .f., .f. );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayArtDes VAR cSayArtDes ;
      WHEN     .f.;
      ID       ( nIdSayDes ) ;
      OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      lOpen          := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD lLoadDivisa() CLASS TInfGen

   local lRet

   if Empty( ::oDbfDiv ) .or. !::oDbfDiv:Used()
      DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"
   end if

   if ::oDbfDiv:Seek( ::cDivInf )

      ::cPicImp            := RetPic( ::oDbfDiv:nNouDiv, ::oDbfDiv:nDouDiv )
      ::cPicOut            := RetPic( ::oDbfDiv:nNouDiv, ::oDbfDiv:nRouDiv )
      ::nDecOut            := ::oDbfDiv:nDouDiv
      ::nDerOut            := ::oDbfDiv:nRouDiv
      ::cPicCom            := RetPic( ::oDbfDiv:nNinDiv, ::oDbfDiv:nDinDiv )
      ::cPicIn             := cPinDiv( ::cDivInf, ::oDbfDiv:cAlias )
      ::nDecIn             := ::oDbfDiv:nDinDiv
      ::nDerIn             := ::oDbfDiv:nRinDiv
      ::cPicPnt            := RetPic( ::oDbfDiv:nNpvDiv, ::oDbfDiv:nDpvDiv )
      ::nDecPnt            := ::oDbfDiv:nDpvDiv
      ::nDerPnt            := ::oDbfDiv:nRpvDiv
      ::nValDiv            := nDiv2Div( cDivEmp(), ::cDivInf, ::oDbfDiv:cAlias )

      lRet                 := .t.

   else

      MsgStop( "Divisa no encontrada " + ::cDivInf )
      lRet                 := .f.

   end if

return ( lRet )

//----------------------------------------------------------------------------//

METHOD oDefExcInf( nId ) CLASS TInfGen

   DEFAULT nId := 200

   REDEFINE CHECKBOX ::lExcCero ;
      ID       ( nId );
      OF       ::oFld:aDialogs[1]

RETURN NIL

//----------------------------------------------------------------------------//

METHOD oDefExcImp( nId ) CLASS TInfGen

   DEFAULT nId := 210

   REDEFINE CHECKBOX ::lExcImp ;
      ID       ( nId );
      OF       ::oFld:aDialogs[1]

RETURN NIL

//----------------------------------------------------------------------------//

METHOD oDefSalInf( nId ) CLASS TInfGen

   DEFAULT nId := 250

   REDEFINE CHECKBOX ::lSalto ;
      ID       ( nId );
      OF       ::oFld:aDialogs[1]

RETURN NIL

//----------------------------------------------------------------------------//

METHOD oDefResInf( nId ) CLASS TInfGen

   DEFAULT nId := 190

   REDEFINE CHECKBOX ::oResumen VAR ::lResumen ;
      ID       ( nId );
      OF       ::oFld:aDialogs[1]

RETURN NIL

//----------------------------------------------------------------------------//

static function gfBlock( cName, nArea )

return ( fieldWBlock( cName, nArea ) )

//----------------------------------------------------------------------------//

METHOD oDefAlmInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllAlm, lInitGroup ) CLASS TInfGen

   local oGroup
   local oAlmOrg
   local oAlmDes
   local oSayAlmOrg
   local cSayAlmOrg
   local oSayAlmDes
   local cSayAlmDes
   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfAlm PATH ( cPatEmp() ) FILE "ALMACEN.DBF" VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cAlmOrg         := dbFirst( ::oDbfAlm, 1 )
   ::cAlmDes         := dbLast( ::oDbfAlm, 1 )
   cSayAlmOrg        := dbFirst( ::oDbfAlm, 2 )
   cSayAlmDes        := dbLast( ::oDbfAlm, 2 )

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   if !Empty( nIdAllAlm )

   ::lAllAlm         := .t.

   REDEFINE CHECKBOX ::lAllAlm ;
      ID       ( nIdAllAlm ) ;
      OF       ::oFld:aDialogs[1]

   else

      ::lAllAlm      := .f.

   end if

   REDEFINE GET oAlmOrg VAR ::cAlmOrg;
      ID       ( nIdOrg );
      WHEN     ( !::lAllAlm );
      VALID    cAlmacen( oAlmOrg, ::oDbfAlm:cAlias, oSayAlmOrg ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmOrg, oSayAlmOrg ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayAlmOrg VAR cSayAlmOrg ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oAlmDes VAR ::cAlmDes;
      ID       ( nIdDes );
      WHEN     ( !::lAllAlm );
      VALID    cAlmacen( oAlmDes, ::oDbfAlm:cAlias, oSayAlmDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmDes, oSayAlmDes ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayAlmDes VAR cSayAlmDes ;
      WHEN     .f.;
      ID       ( nIdSayDes );
      OF       ::oFld:aDialogs[1]

   if lInitGroup != nil

      oGroup         := TRGroup():New( {|| ::oDbf:cCodAlm }, {|| "Almacén : " + AllTrim( ::oDbf:cCodAlm ) + " - " + AllTrim( ::oDbf:cNomAlm ) }, {|| "Total almacén..." }, {|| 3 }, ::lSalto )

      oGroup:Cargo            := TItemGroup()
      oGroup:Cargo:Nombre     := "Almacén"
      oGroup:Cargo:Expresion  := "cCodAlm"

      aAdd( ::aSelectionGroup, oGroup )

      if lInitGroup
         aAdd( ::aInitGroup, oGroup )
      end if

   end if

   aAdd( ::aHeader, {|| Padr( "Almacenes", 12 ) + ": " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) } )

   RECOVER

      msgStop( "Imposible las bases de datos de almacenes" )

      if !Empty( ::oDbfAlm )
         ::oDbfAlm:End()
      end if

      lOpen    := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//
// Método que rellena el browse de los nuevos informenes con el desde hasta almacén

METHOD oBrwAlmInf() CLASS TInfGen

   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   //Empezamos secuencia para control de errores

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfAlm PATH ( cPatEmp() ) FILE "ALMACEN.DBF" VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

   //Añadimos una nueva línea el el browse

   aAdd( ::aCondiciones, { "Almacén", .t., dbFirst( ::oDbfAlm, 1 ), dbFirst( ::oDbfAlm, 2 ),;
                           dbLast(  ::oDbfAlm, 1 ), dbLast(  ::oDbfAlm, 2 ) } )

   //Terminamos secuencia para control de errores

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfAlm )
         ::oDbfAlm:End()
      end if

      lOpen          := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD oDefAgeInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAll ) CLASS TInfGen

   local oAgeOrg
   local oAgeDes
   local oSayAgeOrg
   local cSayAgeOrg
   local oSayAgeDes
   local cSayAgeDes
   local This        := Self
   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfAge PATH ( cPatEmp() ) FILE "AGENTES.DBF" VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cAgeOrg         := dbFirst( ::oDbfAge, 1 )
   ::cAgeDes         := dbLast(  ::oDbfAge, 1 )
   cSayAgeOrg        := RTrim( dbFirst( ::oDbfAge, 2 ) ) + ", " + dbFirst( ::oDbfAge, 3 )
   cSayAgeDes        := RTrim( dbLast(  ::oDbfAge, 2 ) ) + ", " + dbLast( ::oDbfAge, 3 )

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   if nIdAll != nil
      ::lAgeAll      := .t.
   end if

   REDEFINE GET oAgeOrg VAR ::cAgeOrg;
      ID       ( nIdOrg );
      WHEN     ( ValType( ::lAgeAll ) == "L" .and. !::lAgeAll ) ;
      VALID    cAgentes( oAgeOrg, This:oDbfAge:cAlias, oSayAgeOrg ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAgentes( oAgeOrg, oSayAgeOrg ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayAgeOrg VAR cSayAgeOrg ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oAgeDes VAR ::cAgeDes;
      ID       ( nIdDes );
      WHEN     ( ValType( ::lAgeAll ) == "L" .and. !::lAgeAll ) ;
      VALID    cAgentes( oAgeDes, This:oDbfAge:cAlias, oSayAgeDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAgentes( oAgeDes, oSayAgeDes ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayAgeDes VAR cSayAgeDes ;
      WHEN     .f.;
      ID       ( nIdSayDes );
      OF       ::oFld:aDialogs[1]

   if nIdAll != nil

   REDEFINE CHECKBOX ::lAgeAll;
      ID       ( nIdAll ) ;
      OF       ::oFld:aDialogs[1]

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfAge )
         ::oDbfAge:End()
      end if
      lOpen          := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lDefFamInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllFam ) CLASS TInfGen

   local oFamDes
   local oFamHas
   local oSayFamDes
   local cSayFamDes
   local oSayFamHas
   local cSayFamHas
   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   if ::oDbfFam == nil .or. !::oDbfFam:Used()
      DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"
   end if

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cFamOrg         := dbFirst( ::oDbfFam, 1 )
   ::cFamDes         := dbLast ( ::oDbfFam, 1 )
   cSayFamDes        := dbFirst( ::oDbfFam, 2 )
   cSayFamHas        := dbLast ( ::oDbfFam, 2 )

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   if !Empty( nIdAllFam )

      ::lAllFam      := .t.

      REDEFINE CHECKBOX ::lAllFam ;
         ID       ( nIdAllFam ) ;
         OF       ::oFld:aDialogs[1]

   else

         ::lAllFam   := .f.

   end if

   REDEFINE GET oFamDes VAR ::cFamOrg;
      ID       ( nIdOrg );
      WHEN     ( !::lAllFam );
      VALID    cFamilia( oFamDes, ::oDbfFam:cAlias, oSayFamDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwFamilia( oFamDes, oSayFamDes ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayFamDes VAR cSayFamDes ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oFamHas VAR ::cFamDes;
      ID       ( nIdDes );
      WHEN     ( !::lAllFam );
      VALID    cFamilia( oFamHas, ::oDbfFam:cAlias, oSayFamHas ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwFamilia( oFamHas, oSayFamHas ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayFamHas VAR cSayFamHas ;
      WHEN     .f.;
      ID       ( nIdSayDes );
      OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oDbfFam )
         ::oDbfFam:End()
      end if
      lOpen          := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD oDefFpgInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllFpg ) CLASS TInfGen

   local oFpgDes
   local oFpgHas
   local oSayFpgDes
   local cSayFpgDes
   local oSayFpgHas
   local cSayFpgHas
   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfFpg PATH ( cPatEmp() ) FILE "FPago.Dbf" VIA ( cDriver() ) SHARED INDEX "FPago.Cdx"

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cFpgDes         := dbFirst( ::oDbfFpg, 1 )
   ::cFpgHas         := dbLast ( ::oDbfFpg, 1 )
   cSayFpgDes        := dbFirst( ::oDbfFpg, 2 )
   cSayFpgHas        := dbLast ( ::oDbfFpg, 2 )

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   if !Empty( nIdAllFpg )
   ::lAllFpg      := .t.
   REDEFINE CHECKBOX ::lAllFpg ;
      ID       ( nIdAllFpg ) ;
      OF       ::oFld:aDialogs[1]
   else
      ::lAllFpg   := .f.
   end if

   REDEFINE GET oFpgDes VAR ::cFpgDes ;
      ID       ( nIdOrg );
      WHEN     ( !::lAllFpg );
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]
      oFpgDes:bHelp  := {|| BrwFPago( oFpgDes, oSayFpgDes ) }
      oFpgDes:bValid := {|| cFpago( oFpgDes, ::oDbfFpg:cAlias, oSayFpgDes ) }

   REDEFINE GET oSayFpgDes VAR cSayFpgDes ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oFpgHas VAR ::cFpgHas;
      ID       ( nIdDes );
      WHEN     ( !::lAllFpg );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]
      oFpgHas:bHelp  := {|| BrwFPago( oFpgHas, oSayFpgHas ) }
      oFpgHas:bValid := {|| cFpago( oFpgHas, ::oDbfFpg:cAlias, oSayFpgHas ) }

   REDEFINE GET oSayFpgHas VAR cSayFpgHas ;
      WHEN     .f.;
      ID       ( nIdSayDes );
      OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oDbfFpg )
         ::oDbfFpg:End()
      end if
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD oDefTipInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllTip ) CLASS TInfGen

   local oTipOrg
   local oTipDes
   local oSayTipDes
   local cSayTipDes
   local oSayTipOrg
   local cSayTipOrg
   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oTipArt         :=  TTipArt():New( cPatEmp(), cDriver() )
   ::oTipArt:OpenFiles()

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cTipOrg         := dbFirst( ::oTipArt:oDbf, 1 )
   ::cTipDes         := dbLast ( ::oTipArt:oDbf, 1 )
   cSayTipOrg        := dbFirst( ::oTipArt:oDbf, 2 )
   cSayTipDes        := dbLast ( ::oTipArt:oDbf, 2 )

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   if !Empty( nIdAllTip )
   ::lAllTip      := .t.
   REDEFINE CHECKBOX ::lAllTip ;
      ID       ( nIdAllTip ) ;
      OF       ::oFld:aDialogs[1]
   else
      ::lAllTip   := .f.
   end if

   REDEFINE GET oTipOrg VAR ::cTipOrg;
      ID       ( nIdOrg );
      WHEN     ( !::lAllTip );
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

      oTipOrg:bValid := {|| ::oTipArt:Existe( oTipOrg, oSayTipOrg ) }
      oTipOrg:bHelp  := {|| ::oTipArt:Buscar( oTipOrg ) }

   REDEFINE GET oSayTipOrg VAR cSayTipOrg ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipDes VAR ::cTipDes;
      ID       ( nIdDes );
      WHEN     ( !::lAllTip );
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

      oTipDes:bValid := {|| ::oTipArt:Existe( oTipDes, oSayTipDes ) }
      oTipDes:bHelp  := {|| ::oTipArt:Buscar( oTipDes ) }

   REDEFINE GET oSayTipDes VAR cSayTipDes ;
      ID       ( nIdSayDes );
      WHEN     .f.;
      OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oTipArt )
         ::oTipArt:End()
      end if
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD oDefFabInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllFab ) CLASS TInfGen

   local oFabOrg
   local oFabDes
   local oSayFabDes
   local cSayFabDes
   local oSayFabOrg
   local cSayFabOrg
   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oDbfFab         :=  TFabricantes():New( cPatEmp() )
   ::oDbfFab:OpenFiles()

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cFabOrg         := dbFirst( ::oDbfFab:oDbf, 1 )
   ::cFabDes         := dbLast ( ::oDbfFab:oDbf, 1 )
   cSayFabOrg        := dbFirst( ::oDbfFab:oDbf, 2 )
   cSayFabDes        := dbLast ( ::oDbfFab:oDbf, 2 )

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   if !Empty( nIdAllFab )
   ::lAllFab      := .t.
   REDEFINE CHECKBOX ::lAllFab ;
      ID       ( nIdAllFab ) ;
      OF       ::oFld:aDialogs[1]
   else
      ::lAllFab   := .f.
   end if

   REDEFINE GET oFabOrg VAR ::cFabOrg;
      ID       ( nIdOrg );
      WHEN     ( !::lAllFab );
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

      oFabOrg:bValid := {|| ::oDbfFab:Existe( oFabOrg, oSayFabOrg ) }
      oFabOrg:bHelp  := {|| ::oDbfFab:Buscar( oFabOrg ) }

   REDEFINE GET oSayFabOrg VAR cSayFabOrg ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oFabDes VAR ::cFabDes;
      ID       ( nIdDes );
      WHEN     ( !::lAllFab );
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

      oFabDes:bValid := {|| ::oDbfFab:Existe( oFabDes, oSayFabDes ) }
      oFabDes:bHelp  := {|| ::oDbfFab:Buscar( oFabDes ) }

   REDEFINE GET oSayFabDes VAR cSayFabDes ;
      ID       ( nIdSayDes );
      WHEN     .f.;
      OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oDbfFab )
         ::oDbfFab:End()
      end if
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD oDefTipActInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllAct ) CLASS TInfGen

   local oTipOrg
   local oTipDes
   local oSayTipDes
   local cSayTipDes
   local oSayTipOrg
   local cSayTipOrg
   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oTipAct         :=  TActuaciones():New( cPatEmp() )
   ::oTipAct:OpenFiles()

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cTipActOrg      := dbFirst( ::oTipAct:oDbf, 1 )
   ::cTipActDes      := dbLast ( ::oTipAct:oDbf, 1 )
   cSayTipOrg        := dbFirst( ::oTipAct:oDbf, 2 )
   cSayTipDes        := dbLast ( ::oTipAct:oDbf, 2 )

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   if !Empty( nIdAllAct )
   ::lAllTipAct      := .t.
   REDEFINE CHECKBOX ::lAllTipAct ;
      ID       ( nIdAllAct ) ;
      OF       ::oFld:aDialogs[1]
   else
      ::lAllTipAct   := .f.
   end if

   REDEFINE GET oTipOrg VAR ::cTipActOrg ;
      ID       ( nIdOrg );
      WHEN     ( !::lAllTipAct );
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

      oTipOrg:bValid := {|| ::oTipAct:Existe( oTipOrg, oSayTipOrg ) }
      oTipOrg:bHelp  := {|| ::oTipAct:Buscar( oTipOrg ) }

   REDEFINE GET oSayTipOrg VAR cSayTipOrg ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipDes VAR ::cTipActDes;
      ID       ( nIdDes );
      WHEN     ( !::lAllTipAct );
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

      oTipDes:bValid := {|| ::oTipAct:Existe( oTipDes, oSayTipDes ) }
      oTipDes:bHelp  := {|| ::oTipAct:Buscar( oTipDes ) }

   REDEFINE GET oSayTipDes VAR cSayTipDes ;
      ID       ( nIdSayDes );
      WHEN     .f.;
      OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oTipAct )
         ::oTipAct:End()
      end if
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD oDefGrpCli( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdGrp, oDlg ) CLASS TInfGen

   local oGrpOrg
   local oGrpDes
   local oSayGrpDes
   local cSayGrpDes
   local oSayGrpOrg
   local cSayGrpOrg
   local lOpen

   ::oGrpCli         :=  TGrpCli():Create( cPatEmp() )

   if ::oGrpCli:OpenFiles()

      /*
      Si nos pasan la BD montamos los valores
      */

      ::cGrpOrg         := dbFirst( ::oGrpCli:oDbf, 1 )
      ::cGrpDes         := dbLast ( ::oGrpCli:oDbf, 1 )
      cSayGrpOrg        := dbFirst( ::oGrpCli:oDbf, 2 )
      cSayGrpDes        := dbLast ( ::oGrpCli:oDbf, 2 )

      DEFAULT nIdOrg    := 70
      DEFAULT nIdSayOrg := 71
      DEFAULT nIdDes    := 80
      DEFAULT nIdSayDes := 81
      DEFAULT nIdGrp    := 90

      REDEFINE GET oGrpOrg VAR ::cGrpOrg;
         ID       ( nIdOrg );
         WHEN     ( !::lGrpAll );
         BITMAP   "LUPA" ;
         OF       ::oFld:aDialogs[1]

         oGrpOrg:bValid := {|| ::oGrpCli:Existe( oGrpOrg, oSayGrpOrg ) }
         oGrpOrg:bHelp  := {|| ::oGrpCli:Buscar( oGrpOrg ) }

      REDEFINE GET oSayGrpOrg VAR cSayGrpOrg ;
         ID       ( nIdSayOrg );
         WHEN     .f.;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET oGrpDes VAR ::cGrpDes;
         ID       ( nIdDes );
         WHEN     ( !::lGrpAll );
         BITMAP   "LUPA" ;
         OF       ::oFld:aDialogs[1]

         oGrpDes:bValid := {|| ::oGrpCli:Existe( oGrpDes, oSayGrpDes ) }
         oGrpDes:bHelp  := {|| ::oGrpCli:Buscar( oGrpDes ) }

      REDEFINE GET oSayGrpDes VAR cSayGrpDes ;
         ID       ( nIdSayDes );
         WHEN     .f.;
         OF       ::oFld:aDialogs[1]

      if !Empty( nIdGrp )

         ::lGrpAll      := .t.
         REDEFINE CHECKBOX ::lGrpAll ;
            ID       ( nIdGrp ) ;
            OF       ::oFld:aDialogs[1]
      else
         ::lGrpAll   := .f.
      end if

      lOpen := .t.

   else
      lOpen := .f.
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD oDefGrpPrv( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdGrp, oDlg ) CLASS TInfGen

   local oGrpPrvOrg
   local oGrpPrvDes
   local oSayGrpPrvDes
   local cSayGrpPrvDes
   local oSayGrpPrvOrg
   local cSayGrpPrvOrg
   local lOpen

   DEFAULT oDlg      := ::oFld:aDialogs[1]

   ::oGrpPrv         :=  TGrpPrv():Create( cPatEmp() )
   if ::oGrpPrv:OpenFiles()

      /*
      Si nos pasan la BD montamos los valores
      */

      ::cGrpPrvOrg         := dbFirst( ::oGrpPrv:oDbf, 1 )
      ::cGrpPrvDes         := dbLast ( ::oGrpPrv:oDbf, 1 )
      cSayGrpPrvOrg        := dbFirst( ::oGrpPrv:oDbf, 2 )
      cSayGrpPrvDes        := dbLast ( ::oGrpPrv:oDbf, 2 )

      DEFAULT nIdOrg    := 70
      DEFAULT nIdSayOrg := 71
      DEFAULT nIdDes    := 80
      DEFAULT nIdSayDes := 81
      DEFAULT nIdGrp    := 90

      REDEFINE GET oGrpPrvOrg VAR ::cGrpPrvOrg;
         ID       ( nIdOrg );
         WHEN     ( !::lGrpPrvAll );
         BITMAP   "LUPA" ;
         OF       oDlg

         oGrpPrvOrg:bValid := {|| ::oGrpPrv:Existe( oGrpPrvOrg, oSayGrpPrvOrg ) }
         oGrpPrvOrg:bHelp  := {|| ::oGrpPrv:Buscar( oGrpPrvOrg ) }

      REDEFINE GET oSayGrpPrvOrg VAR cSayGrpPrvOrg ;
         ID       ( nIdSayOrg );
         WHEN     .f.;
         OF       oDlg

      REDEFINE GET oGrpPrvDes VAR ::cGrpPrvDes;
         ID       ( nIdDes );
         WHEN     ( !::lGrpPrvAll );
         BITMAP   "LUPA" ;
         OF       oDlg

         oGrpPrvDes:bValid := {|| ::oGrpPrv:Existe( oGrpPrvDes, oSayGrpPrvDes ) }
         oGrpPrvDes:bHelp  := {|| ::oGrpPrv:Buscar( oGrpPrvDes ) }

      REDEFINE GET oSayGrpPrvDes VAR cSayGrpPrvDes ;
         ID       ( nIdSayDes );
         WHEN     .f.;
         OF       oDlg

      if !Empty( nIdGrp )

         ::lGrpPrvAll      := .t.
         REDEFINE CHECKBOX ::lGrpPrvAll ;
            ID       ( nIdGrp ) ;
            OF       oDlg
      else
         ::lGrpAll   := .f.
      end if

      lOpen := .t.

   else
      lOpen := .f.
   end if

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD oDefEmpInf( nId, nIdSay, oDlg ) CLASS TInfGen

   local oCodEmp
   local oNomEmp
   local cNomEmp
   local This        := Self

   DEFAULT nId       := 90
   DEFAULT nIdSay    := 91
   DEFAULT oDlg      := ::oFld:aDialogs[1]

   DATABASE NEW ::oDbfEmp PATH ( cPatDat() ) FILE "EMPRESA.DBF" VIA ( cDriver() ) SHARED INDEX "EMPRESA.CDX"

   ::cCodEmp         := ::oDbfEmp:CodEmp
   cNomEmp           := ::oDbfEmp:cNombre

   REDEFINE GET oCodEmp VAR ::cCodEmp;
      ID       ( nId ) ;
      VALID    ( cEmpresa( oCodEmp, This:oDbfEmp:cAlias, oNomEmp ) ) ;
      BITMAP   "LUPA";
      ON HELP  ( BrwEmpresa( oCodEmp, This:oDbfEmp:cAlias, oNomEmp ) ) ;
      OF       oDlg

   REDEFINE GET oNomEmp VAR cNomEmp ;
      WHEN     .f.;
      ID       ( nIdSay ) ;
      OF       oDlg


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD oDefCliInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, oDlg, nIdAllCli ) CLASS TInfGen

   local oCliOrg
   local oCliDes
   local oSayCliOrg
   local oSayCliDes
   local cSayCliOrg
   local cSayCliDes
   local lOpen       := .t.
   local oError
   local oBlock

   DEFAULT nIdOrg    :=  70
   DEFAULT nIdSayOrg :=  71
   DEFAULT nIdDes    :=  80
   DEFAULT nIdSayDes :=  81
   DEFAULT oDlg      := ::oFld:aDialogs[1]

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DATABASE NEW ::oDbfCli PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   /*
   Obtenemos los valores del primer y último codigo
	*/

   ::cCliOrg         := dbFirst( ::oDbfCli, 1 )
   ::cCliDes         := dbLast(  ::oDbfCli, 1 )
   cSayCliOrg        := dbFirst( ::oDbfCli, 2 )
   cSayCliDes        := dbLast(  ::oDbfCli, 2 )

   if !Empty( nIdAllCli )
   ::lAllCli         := .t.
   REDEFINE CHECKBOX ::lAllCli ;
      ID       ( nIdAllCli ) ;
      OF       oDlg
   else
      ::lAllCli      := .f.
   end if

   REDEFINE GET oCliOrg VAR ::cCliOrg;
      ID       ( nIdOrg ) ;
      WHEN     ( !::lAllCli );
      VALID    cClient( oCliOrg, ::oDbfCli:cAlias, oSayCliOrg );
      BITMAP   "LUPA" ;
      OF       oDlg
   oCliOrg:bHelp     := {|| BrwCli( oCliOrg, oSayCliOrg, ::oDbfCli:cAlias ) }

   REDEFINE GET oSayCliOrg VAR cSayCliOrg ;
      WHEN     .f.;
      ID       ( nIdSayOrg ) ;
      OF       oDlg

   REDEFINE GET oCliDes VAR ::cCliDes;
      ID       ( nIdDes ) ;
      WHEN     ( !::lAllCli );
      VALID    cClient( oCliDes, ::oDbfCli:cAlias, oSayCliDes );
      BITMAP   "LUPA" ;
      OF       oDlg
   oCliDes:bHelp     := {|| BrwCli( oCliDes, oSayCliDes, ::oDbfCli:cAlias ) }

   REDEFINE GET oSayCliDes VAR cSayCliDes ;
      WHEN     .f.;
      ID       ( nIdSayDes ) ;
      OF       oDlg

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oDbfCli )
         ::oDbfCli:End()
      end if
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD oDefTmpInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, oDlg, nIdAllTmp ) CLASS TInfGen

   local oTmpOrg
   local oTmpDes
   local oSayTmpOrg
   local oSayTmpDes
   local cSayTmpOrg
   local cSayTmpDes
   local lOpen       := .t.
   local oError
   local oBlock

   DEFAULT nIdOrg    :=  70
   DEFAULT nIdSayOrg :=  71
   DEFAULT nIdDes    :=  80
   DEFAULT nIdSayDes :=  81
   DEFAULT oDlg      := ::oFld:aDialogs[1]

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DATABASE NEW ::oDbfTmp PATH ( cPatEmp() ) FILE "Temporadas.DBF" VIA ( cDriver() ) SHARED INDEX "Temporadas.CDX"

   /*
   Obtenemos los valores del primer y último codigo
	*/

   ::cTmpOrg         := dbFirst( ::oDbfTmp, 1 )
   ::cTmpDes         := dbLast(  ::oDbfTmp, 1 )
   cSayTmpOrg        := dbFirst( ::oDbfTmp, 2 )
   cSayTmpDes        := dbLast(  ::oDbfTmp, 2 )

   if !Empty( nIdAllTmp )

   ::lAllTmp      := .t.

   REDEFINE CHECKBOX ::lAllTmp ;
      ID       ( nIdAllTmp ) ;
      OF       ::oFld:aDialogs[1]

   else

      ::lAllTmp   := .f.

   end if


   REDEFINE GET oTmpOrg VAR ::cTmpOrg;
      ID       ( nIdOrg ) ;
      WHEN     ( !::lAllTmp );
      VALID    cTemporada( oTmpOrg, ::oDbfTmp:cAlias, oSayTmpOrg );
      BITMAP   "LUPA" ;
      OF       oDlg
   oTmpOrg:bHelp     := {|| BrwTemporada( oTmpOrg, oSayTmpOrg, ::oDbfTmp:cAlias ) }

   REDEFINE GET oSayTmpOrg VAR cSayTmpOrg ;
      WHEN     .f.;
      ID       ( nIdSayOrg ) ;
      OF       oDlg

   REDEFINE GET oTmpDes VAR ::cTmpDes;
      ID       ( nIdDes ) ;
      WHEN     ( !::lAllTmp );
      VALID    cTemporada( oTmpDes, ::oDbfTmp:cAlias, oSayTmpDes );
      BITMAP   "LUPA" ;
      OF       oDlg
   oTmpDes:bHelp     := {|| BrwTemporada( oTmpDes, oSayTmpDes, ::oDbfTmp:cAlias ) }

   REDEFINE GET oSayTmpDes VAR cSayTmpDes ;
      WHEN     .f.;
      ID       ( nIdSayDes ) ;
      OF       oDlg

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oDbfTmp )
         ::oDbfTmp:End()
      end if
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//-----------------------------------------------------------------------------

METHOD oDefGrfInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllGrp ) CLASS TInfGen

   local oGruFamOrg
   local oGruFamDes
   local oSayGrFOrg
   local cSayGrFOrg
   local oSayGrFDes
   local cSayGrFDes
   local oThis
   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oGruFam      := TGrpFam():Create( cPatEmp(), "GRPFAM" )
   ::oGruFam:OpenFiles()

   oThis          := ::oGruFam

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cGruFamOrg   := dbFirst( ::oGruFam:oDbf, 1 )
   ::cGruFamDes   := dbLast ( ::oGruFam:oDbf, 1 )
   cSayGrFOrg     := dbFirst( ::oGruFam:oDbf, 2 )
   cSayGrFDes     := dbLast ( ::oGruFam:oDbf, 2 )

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   if !Empty( nIdAllGrp )
   ::lAllGrp      := .t.
   REDEFINE CHECKBOX ::lAllGrp ;
      ID       ( nIdAllGrp ) ;
      OF       ::oFld:aDialogs[1]
   else
      ::lAllGrp   := .f.
   end if

   REDEFINE GET oGruFamOrg VAR ::cGruFamOrg;
      ID       ( nIdOrg );
      WHEN     ( !::lAllGrp );
      VALID    oThis:Existe( oGruFamOrg, oSayGrfOrg ) ;
      BITMAP   "LUPA" ;
      ON HELP  oThis:Buscar( oGruFamOrg ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayGrFOrg VAR cSayGrFOrg ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oGruFamDes VAR ::cGruFamDes;
      ID       ( nIdDes );
      WHEN     ( !::lAllGrp );
      VALID    oThis:Existe( oGruFamDes, oSayGrfDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  oThis:Buscar( oGruFamDes ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayGrFDes VAR cSayGrFDes ;
      WHEN     .f.;
      ID       ( nIdSayDes );
      OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oGruFam )
         ::oGruFam:End()
      end if
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD oDefTurInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes ) CLASS TInfGen

   local oTurOrg
   local oTurDes
   local oSayTurOrg
   local cSayTurOrg
   local oSayTurDes
   local cSayTurDes

   ::oDbfTur      := TTurno():New( "Turno", "TURNO", cPatEmp() )
   ::oDbfTur:OpenFiles()

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cTurOrg      := dbFirst( ::oDbfTur:oDbf, 1 )
   ::cTurDes      := dbLast ( ::oDbfTur:oDbf, 1 )
   cSayTurOrg     := dbFirst( ::oDbfTur:oDbf, 2 )
   cSayTurDes     := dbLast ( ::oDbfTur:oDbf, 2 )

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   REDEFINE GET oTurOrg VAR ::cTurOrg;
      ID       ( nIdOrg );
      BITMAP   "LUPA" ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   oTurOrg:bValid := {|| ::oDbfTur:Existe( oTurOrg, oSayTurOrg ) }
   oTurOrg:bHelp  := {|| ::oDbfTur:Buscar( oTurOrg ) }

   REDEFINE GET oSayTurOrg VAR cSayTurOrg ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTurDes VAR ::cTurDes;
      ID       ( nIdDes );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   oTurDes:bValid := {|| ::oDbfTur:Existe( oTurDes, oSayTurDes ) }
   oTurDes:bHelp  := {|| ::oDbfTur:Buscar( oTurDes ) }

   REDEFINE GET oTurDes VAR cSayTurDes ;
      WHEN     .f.;
      ID       ( nIdSayDes );
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD oDefObrInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllObr ) CLASS TInfGen

   local oObrOrg
   local oObrDes
   local oSayObrOrg
   local oSayObrDes
   local cSayObrOrg
   local cSayObrDes
   local oThis       := Self
   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   DATABASE NEW ::oDbfObr PATH ( cPatEmp() ) FILE "OBRAST.DBF" VIA ( cDriver() ) SHARED INDEX "OBRAST.CDX"

   /*
	Obtenemos los valores del primer y ultimo codigo
	*/

   ::cObrOrg   := Space( 3 )
   ::cObrDes   := Space( 3 )
   cSayObrOrg  := ""
   cSayObrDes  := ""

   if nIdAllObr != nil

      ::lAllObr := .t.

      REDEFINE CHECKBOX ::lAllObr;
         ID    ( nIdAllObr );
         OF    ::oFld:aDialogs[1]

   end if

   REDEFINE GET oObrOrg VAR ::cObrOrg;
      ID       ( nIdOrg ) ;
      VALID    cObras( oObrOrg, oSayObrOrg, oThis:cCliOrg, oThis:oDbfObr:cAlias );
      WHEN     ( ::cCliOrg == ::cCliDes .and. !::lAllObr );
      BITMAP   "LUPA" ;
      ON HELP  BrwObras( oObrOrg, oSayObrOrg, oThis:cCliOrg, oThis:oDbfObr:cAlias );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayObrOrg VAR cSayObrOrg ;
      WHEN     .f.;
      ID       ( nIdSayOrg ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oObrDes VAR ::cObrDes;
      ID       ( nIdDes ) ;
      VALID    cObras( oObrDes, oSayObrDes, oThis:cCliOrg, oThis:oDbfObr:cAlias );
      WHEN     ( ::cCliOrg == ::cCliDes .and. !::lAllObr );
      BITMAP   "LUPA" ;
      ON HELP  BrwObras( oObrDes, oSayObrDes, oThis:cCliOrg, oThis:oDbfObr:cAlias );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayObrDes VAR cSayObrDes ;
      WHEN     .f.;
      ID       ( nIdSayDes ) ;
      OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oDbfObr )
         ::oDbfObr:End()
      end if
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD oDefRutInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllRut ) CLASS TInfGen

   local oRutOrg
   local oRutDes
   local oSayRutOrg
   local cSayRutOrg
   local oSayRutDes
   local cSayRutDes
   local This     := Self
   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfRut PATH ( cPatEmp() ) FILE "RUTA.DBF" VIA ( cDriver() ) SHARED INDEX "RUTA.CDX"

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cRutOrg         := dbFirst( ::oDbfRut, 1 )
   ::cRutDes         := dbLast( ::oDbfRut, 1 )
   cSayRutOrg        := RTrim( dbFirst( ::oDbfRut, 2 ) )
   cSayRutDes        := RTrim( dbLast(  ::oDbfRut, 2 ) )

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   if !Empty( nIdAllRut )
   ::lAllRut      := .t.
   REDEFINE CHECKBOX ::lAllRut ;
      ID       ( nIdAllRut ) ;
      OF       ::oFld:aDialogs[1]
   else
      ::lAllRut   := .f.
   end if

   REDEFINE GET oRutOrg VAR ::cRutOrg;
      ID       ( nIdOrg );
      WHEN     ( !::lAllRut );
      VALID    cRuta( oRutOrg, This:oDbfRut:cAlias, oSayRutOrg ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwRuta( oRutOrg, This:oDbfRut:cAlias, oSayRutOrg ) ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayRutOrg VAR cSayRutOrg ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oRutDes VAR ::cRutDes;
      ID       ( nIdDes );
      WHEN     ( !::lAllRut );
      VALID    cRuta( oRutDes, This:oDbfRut:cAlias, oSayRutDes ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwRuta( oRutDes, This:oDbfRut:cAlias, oSayRutDes ) ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayRutDes VAR cSayRutDes ;
      WHEN     .f.;
      ID       ( nIdSayDes );
      OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oDbfRut )
         ::oDbfRut:End()
      end if
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD oDefUsrInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllUsr ) CLASS TInfGen

   local oUsrOrg
   local oUsrDes
   local oSayUsrOrg
   local cSayUsrOrg
   local oSayUsrDes
   local cSayUsrDes
   local lOpen       := .t.

   ::lAllUsr         := .t.
   ::cUsrOrg         := ""
   ::cUsrDes         := ""
   cSayUsrOrg        := ""
   cSayUsrDes        := ""

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   if !Empty( nIdAllUsr )

      REDEFINE CHECKBOX ::lAllUsr ;
         ID       ( nIdAllUsr ) ;
         WHEN     ( .f. ) ;
         OF       ::oFld:aDialogs[1]

   end if

   REDEFINE GET oUsrOrg VAR ::cUsrOrg;
      ID       ( nIdOrg );
      WHEN     ( !::lAllUsr );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayUsrOrg VAR cSayUsrOrg ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oUsrDes VAR ::cUsrDes;
      ID       ( nIdDes );
      WHEN     ( !::lAllUsr );
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayUsrDes VAR cSayUsrDes ;
      WHEN     .f.;
      ID       ( nIdSayDes );
      OF       ::oFld:aDialogs[1]

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD oDefCajInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllCaj ) CLASS TInfGen

   local oCajOrg
   local oCajDes
   local oSayCajOrg
   local cSayCajOrg
   local oSayCajDes
   local cSayCajDes
   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfCaj PATH ( cPatDat() ) FILE "Cajas.Dbf" VIA ( cDriver() ) SHARED INDEX "Cajas.Cdx"

      /*
      Si nos pasan la BD montamos los valores
      */

      ::cCajOrg         := dbFirst( ::oDbfCaj, 1 )
      ::cCajDes         := dbLast( ::oDbfCaj, 1 )
      cSayCajOrg        := RTrim( dbFirst( ::oDbfCaj, 2 ) )
      cSayCajDes        := RTrim( dbLast( ::oDbfCaj, 2 ) )

      DEFAULT nIdOrg    := 70
      DEFAULT nIdSayOrg := 71
      DEFAULT nIdDes    := 80
      DEFAULT nIdSayDes := 81

      if !Empty( nIdAllCaj )

         ::lAllCaj      := .t.
         REDEFINE CHECKBOX ::lAllCaj ;
            ID       ( nIdAllCaj ) ;
            OF       ::oFld:aDialogs[1]

      else

         ::lAllCaj      := .f.

      end if

      REDEFINE GET oCajOrg VAR ::cCajOrg;
         ID       ( nIdOrg );
         WHEN     ( !::lAllCaj );
         VALID    cCajas( oCajOrg, ::oDbfCaj:cAlias, oSayCajOrg ) ;
         BITMAP   "LUPA" ;
         OF       ::oFld:aDialogs[1]

      oCajOrg:bHelp  := {|| BrwCajas( oCajOrg, oSayCajOrg ) }

      REDEFINE GET oSayCajOrg VAR cSayCajOrg ;
         ID       ( nIdSayOrg );
         WHEN     .f.;
         COLOR    CLR_GET ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET oCajDes VAR ::cCajDes;
         ID       ( nIdDes );
         WHEN     ( !::lAllCaj );
         VALID    cCajas( oCajDes, ::oDbfCaj:cAlias, oSayCajDes ) ;
         BITMAP   "LUPA" ;
         OF       ::oFld:aDialogs[1]

      oCajDes:bHelp  := {|| BrwCajas( oCajDes, oSayCajDes ) }

      REDEFINE GET oSayCajDes VAR cSayCajDes ;
         WHEN     .f.;
         ID       ( nIdSayDes );
         OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oDbfCaj )
         ::oDbfCaj:End()
      end if
      lOpen       := .f.

      return lOpen

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD oDefTrnInf( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, nIdAllTrn ) CLASS TInfGen

   local oTrnOrg
   local oTrnDes
   local oSayTrnOrg
   local cSayTrnOrg
   local oSayTrnDes
   local cSayTrnDes
   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oDbfTrn         := TTrans():Create( cPatEmp(), "Transport" )
   ::oDbfTrn:OpenFiles()

   /*
   Si nos pasan la BD montamos los valores
   */

   ::cTrnOrg         := dbFirst( ::oDbfTrn:oDbf, 1 )
   ::cTrnDes         := dbLast( ::oDbfTrn:oDbf, 1 )
   cSayTrnOrg        := RTrim( dbFirst( ::oDbfTrn:oDbf, 2 ) )
   cSayTrnDes        := RTrim( dbLast( ::oDbfTrn:oDbf, 2 ) )

   DEFAULT nIdOrg    := 70
   DEFAULT nIdSayOrg := 71
   DEFAULT nIdDes    := 80
   DEFAULT nIdSayDes := 81

   if !Empty( nIdAllTrn )
   ::lAllTrn      := .t.
   REDEFINE CHECKBOX ::lAllTrn ;
      ID       ( nIdAllTrn ) ;
      OF       ::oFld:aDialogs[1]
   else
      ::lAllTrn   := .f.
   end if

   REDEFINE GET oTrnOrg VAR ::cTrnOrg;
      ID       ( nIdOrg );
      WHEN     ( !::lAllTrn );
      BITMAP   "LUPA" ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oTrnOrg:bHelp     := {|| ::oDbfTrn:Buscar( oTrnOrg ) }
      oTrnOrg:bValid    := {|| ::oDbfTrn:Existe( oTrnOrg, oSayTrnOrg, "cNomTrn" ) }

   REDEFINE GET oSayTrnOrg VAR cSayTrnOrg ;
      ID       ( nIdSayOrg );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTrnDes VAR ::cTrnDes;
      ID       ( nIdDes );
      WHEN     ( !::lAllTrn );
      BITMAP   "LUPA" ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oTrnDes:bHelp     := {|| ::oDbfTrn:Buscar( oTrnDes ) }
      oTrnDes:bValid    := {|| ::oDbfTrn:Existe( oTrnDes, oSayTrnDes, "cNomTrn" ) }

   REDEFINE GET oSayTrnDes VAR cSayTrnDes ;
      WHEN     .f.;
      ID       ( nIdSayDes );
      OF       ::oFld:aDialogs[1]

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty ( ::oDbfTrn )
         ::oDbfTrn:End()
      end if
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD PutOriginal()

   ::CreateColumn()

   ::oBrwCol:SetArray( ::aoCols )
   ::oBrwCol:Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD PrnTiket()

return ( Self )

//---------------------------------------------------------------------------//

METHOD FldCliente()

   ::AddField( "cCodCli", "C", 12, 0,  {|| "@!" },         "Cód. cli.",                 .t., "Código cliente",              8 )
   ::AddField( "cNomCli", "C", 50, 0,  {|| "@!" },         "Cliente",                   .t., "Nombre cliente",             30 )
   ::AddField( "cNifCli", "C", 15, 0,  {|| "@!" },         "Nif",                       .f., "Nif",                        12 )
   ::AddField( "cDomCli", "C", 35, 0,  {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  20 )
   ::AddField( "cPobCli", "C", 25, 0,  {|| "@!" },         "Población",                 .f., "Población",                  25 )
   ::AddField( "cProCli", "C", 20, 0,  {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 )
   ::AddField( "cCdpCli", "C",  7, 0,  {|| "@!" },         "Cod. pos.",                 .f., "Código postal",               7 )
   ::AddField( "cTlfCli", "C", 12, 0,  {|| "@!" },         "Teléfono",                  .f., "Teléfono",                   12 )
   ::AddField( "cObrCli", "C", 10, 0,  {|| "@!" },         "Dirección",                      .f., "Código dirección",                12 )
   ::AddField( "cNbrEst", "C", 35, 0,  {|| "@!" },         "Establecimiento",           .f., "Nombre establecimiento",     50 )

RETURN nil

//---------------------------------------------------------------------------//

METHOD FldPropiedades()

   ::AddField( "cCodPr1", "C", 20, 0, {|| "@!" },        "Cod. prp. 1",       .f., "Código propiedad 1",        6, .f. )
   ::AddField( "cNomPr1", "C", 35, 0, {|| "@!" },        "Nom. prp. 1",       .f., "Nombre propiedad 1",       20, .f. )
   ::AddField( "cValPr1", "C", 20, 0, {|| "@!" },        "Val. prp. 1",       .f., "Valor propiedad 1",         6, .f. )
   ::AddField( "cNomVl1", "C", 30, 0, {|| "@!" },        "Nom. val. prp. 1",  .f., "Nombre valor propiedad 1", 20, .f. )
   ::AddField( "cCodPr2", "C", 20, 0, {|| "@!" },        "Cod. prp. 2",       .f., "Código propiedad 2",        6, .f. )
   ::AddField( "cNomPr2", "C", 35, 0, {|| "@!" },        "Nom. prp. 2",       .f., "Nombre propiedad 2",       20, .f. )
   ::AddField( "cValPr2", "C", 20, 0, {|| "@!" },        "Val. prp. 2",       .f., "Valor propiedad 2",         6, .f. )
   ::AddField( "cNomVl2", "C", 30, 0, {|| "@!" },        "Nom. val. prp. 2",  .f., "Nombre valor propiedad 2", 20, .f. )

RETURN nil

//---------------------------------------------------------------------------//

METHOD FldArticulo( lVisible, lPropiedades, lLote )

   DEFAULT lVisible     := .f.
   DEFAULT lPropiedades := .t.
   DEFAULT lLote        := .t.

   ::AddField( "cCodArt",  "C", 18, 0, {|| "@!" },                "Cod. artículo",     lVisible, "Código del artículo",       14, .f. )
   ::AddField( "cNomArt",  "C",100, 0, {|| "@!" },                "Descripción",       lVisible, "Nombre del artículo",       35, .f. )

   if lPropiedades

      ::AddField( "cCodPr1",  "C", 20, 0, {|| "@!" },                "Cod. prp. 1",       .f., "Código propiedad 1",              6, .f. )
      ::AddField( "cNomPr1",  "C", 35, 0, {|| "@!" },                "Nom. prp. 1",       .f., "Nombre propiedad 1",             20, .f. )
      ::AddField( "cValPr1",  "C", 20, 0, {|| "@!" },                "Val. prp. 1",       .f., "Valor propiedad 1",               6, .f. )
      ::AddField( "cNomVl1",  "C", 30, 0, {|| "@!" },                "Nom. val. prp. 1",  .f., "Nombre valor propiedad 1",       20, .f. )
      ::AddField( "cCodPr2",  "C", 20, 0, {|| "@!" },                "Cod. prp. 2",       .f., "Código propiedad 2",              6, .f. )
      ::AddField( "cNomPr2",  "C", 35, 0, {|| "@!" },                "Nom. prp. 2",       .f., "Nombre propiedad 2",             20, .f. )
      ::AddField( "cValPr2",  "C", 20, 0, {|| "@!" },                "Val. prp. 2",       .f., "Valor propiedad 2",               6, .f. )
      ::AddField( "cNomVl2",  "C", 30, 0, {|| "@!" },                "Nom. val. prp. 2",  .f., "Nombre valor propiedad 2",       20, .f. )

   end if

   if lLote

      ::AddField( "cLote",    "C", 14, 0, {|| "@!" },                "Lote",              .f., "Número de lote",                 10, .f. )

   end if

   ::AddField( "nMinimo",  "N", 15, 6, {|| "@!" },                "Stk. mínimo",       .f., "Número de stock mínimo",         20, .f. )
   ::AddField( "nMaximo",  "N", 15, 6, {|| "@!" },                "Stk. máximo",       .f., "Número de stock maximo",         20, .f. )
   ::AddField( "nPesoKg",  "N", 16, 6, {|| "@E 999,999.999999" }, "Peso artículo",     .f., "Peso del artículo",              20, .f. )
   ::AddField( "cUnidad",  "C",  2, 0, {|| "@!" },                "Unidad peso",       .f., "Unidad de medición del peso",    20, .f. )
   ::AddField( "nVolumen", "N", 16, 6, {|| "@E 999,999.999999" }, "Vol. artículo",     .f., "Volumen del artículo",           20, .f. )
   ::AddField( "cVolumen", "C",  2, 0, {|| "@!" },                "Unidad vol.",       .f., "Unidad de medición del volumen", 20, .f. )
   ::AddField( "nLngArt",  "N", 16, 6, {|| "@E 999,999.999999" }, "Largo art.",        .f., "Largo del artículo",             20, .f. )
   ::AddField( "nAltArt",  "N", 16, 6, {|| "@E 999,999.999999" }, "Alto art.",         .f., "Alto del artículo",              20, .f. )
   ::AddField( "nAncArt",  "N", 16, 6, {|| "@E 999,999.999999" }, "Ancho art.",        .f., "Ancho del artículo",             20, .f. )
   ::AddField( "cUndDim",  "C",  2, 0, {|| "@!" },                "Und. longitud",     .f., "Unidad de las longitudes",       20, .f. )
   ::AddField( "nLngCaj",  "N", 16, 6, {|| "@E 999,999.999999" }, "Largo caja",        .f., "Largo del la caja",              20, .f. )
   ::AddField( "nAltCaj",  "N", 16, 6, {|| "@E 999,999.999999" }, "Alto caja",         .f., "Alto de la caja",                20, .f. )
   ::AddField( "nAncCaj",  "N", 16, 6, {|| "@E 999,999.999999" }, "Ancho caja",        .f., "Ancho de la caja",               20, .f. )
   ::AddField( "nPesCaj",  "N", 16, 6, {|| "@E 999,999.999999" }, "Peso caja",         .f., "Peso de la caja",                20, .f. )
   ::AddField( "nVolCaj",  "N", 16, 6, {|| "@E 999,999.999999" }, "Vol. caja",         .f., "Volumen de la caja",             20, .f. )
   ::AddField( "nCajPlt",  "N", 16, 6, {|| "@E 999,999.999999" }, "Cajas/Palet",       .f., "Número de cajas por palets",     20, .f. )
   ::AddField( "nBasPlt",  "N", 16, 6, {|| "@E 999,999.999999" }, "Base palet",        .f., "Base del palet",                 20, .f. )
   ::AddField( "nAltPlt",  "N", 16, 6, {|| "@E 999,999.999999" }, "Altura Palet",      .f., "Altura del palet",               20, .f. )

Return nil

//---------------------------------------------------------------------------//

METHOD AddArticulo( cCodArt, oDbfArt, oDbfLin, lPrp, lLote )

   local oError
   local oBlock
   local lOpen    := .f.

   DEFAULT lPrp   := .t.
   DEFAULT lLote  := .t.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if oDbfArt == nil
      DATABASE NEW oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"
      lOpen       := .t.
   end if

   if oDbfArt:Seek( cCodArt )
      ::oDbf:cCodArt    := cCodArt
      ::oDbf:cNomArt    := oDbfArt:Nombre
      ::oDbf:nMinimo    := oDbfArt:nMinimo
      ::oDbf:nMaximo    := oDbfArt:nMaximo
      ::oDbf:nPesoKg    := oDbfArt:nPesoKg
      ::oDbf:cUnidad    := oDbfArt:cUnidad
      ::oDbf:nVolumen   := oDbfArt:nVolumen
      ::oDbf:cVolumen   := oDbfArt:cVolumen
      ::oDbf:nLngArt    := oDbfArt:nLngArt
      ::oDbf:nAltArt    := oDbfArt:nAltArt
      ::oDbf:nAncArt    := oDbfArt:nAncArt
      ::oDbf:cUndDim    := oDbfArt:cUndDim
      ::oDbf:nLngCaj    := oDbfArt:nLngCaj
      ::oDbf:nAltCaj    := oDbfArt:nAltCaj
      ::oDbf:nAncCaj    := oDbfArt:nAncCaj
      ::oDbf:nPesCaj    := oDbfArt:nPesCaj
      ::oDbf:nVolCaj    := oDbfArt:nVolCaj
      ::oDbf:nCajPlt    := oDbfArt:nCajPlt
      ::oDbf:nBasPlt    := oDbfArt:nBasPlt
      ::oDbf:nAltPlt    := oDbfArt:nAltPlt
   end if

   if oDbfLin != nil

      if lPrp

         ::oDbf:cCodPr1 := oDbfLin:cCodPr1
         ::oDbf:cNomPr1 := retProp( oDbfLin:cCodPr1 )
         ::oDbf:cValPr1 := oDbfLin:cValPr1
         ::oDbf:cNomVl1 := retValProp( oDbfLin:cCodPr1 + oDbfLin:cValPr1 )
         ::oDbf:cCodPr2 := oDbfLin:cCodPr2
         ::oDbf:cNomPr2 := retProp( oDbfLin:cCodPr2 )
         ::oDbf:cValPr2 := oDbfLin:cValPr2
         ::oDbf:cNomVl2 := retValProp( oDbfLin:cCodPr2 + oDbfLin:cValPr2 )

      end if

      if lLote

         ::oDbf:cLote   := oDbfLin:cLote

      end if

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if lOpen
         oDbfArt:End()
      end if

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD FldDiario( lTiket )

   DEFAULT lTiket := .f.

   if lTiket
   ::AddField( "cDocMov", "C", 14, 0, {|| "@R #/##########/##" }, "Doc.",     .t., "Documento",     14 )
   else
   ::AddField( "cDocMov", "C", 14, 0, {|| "@R #/#########/##" },  "Doc.",     .t., "Documento",     14 )
   end if
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },                 "Fecha",    .t., "Fecha",         10 )
   ::FldCliente()
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut },            "Neto",     .t., "Neto",          10, .t. )
   ::AddField( "nTotPnt", "N", 16, 6, {|| ::cPicPnt },            "P.V.",     .f., "Punto verde",   10, .t. )
   ::AddField( "nTotTrn", "N", 16, 6, {|| ::cPicOut },            "Transp.",  .f., "Transporte",    10, .t. )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut },            cImp(),      .t., cImp(),           10, .t. )
   ::AddField( "nTotReq", "N", 16, 3, {|| ::cPicOut },            "Rec",      .t., "Rec",           10, .t. )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },            "Total",    .t., "Total",         10, .t. )
   ::AddField( "cTipVen", "C", 20, 0, {|| "@!" },                 "Venta",    .f., "Tipo de venta", 20 )

RETURN nil

//----------------------------------------------------------------------------//

METHOD FldDiaPrv()

   ::AddField( "cCodPrv", "C", 12, 0, {|| "@!" },         "Prv.",                      .t., "Cod. Proveedor",             9 )
   ::AddField( "cNomPrv", "C", 50, 0, {|| "@!" },         "Proveedor",                 .t., "Nombre Proveedor",          35 )
   ::AddField( "cNifPrv", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                       15 )
   ::AddField( "cDomPrv", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio",                 35 )
   ::AddField( "cPobPrv", "C", 25, 0, {|| "@!" },         "Población",                 .f., "Población",                 25 )
   ::AddField( "cProPrv", "C", 20, 0, {|| "@!" },         "Provincia",                 .f., "Provincia",                 20 )
   ::AddField( "cCdpPrv", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",                7 )
   ::AddField( "cTlfPrv", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                  12 )
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut  },   "Neto",                      .t., "Neto",                      10 )
   ::AddField( "nTotPnt", "N", 16, 6, {|| ::cPicPnt },    "P.V.",                      .t., "Punto Verde",               10 )
   ::AddField( "nTotTrn", "N", 16, 6, {|| ::cPicOut },    "Transp.",                   .t., "Transporte",                10 )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut  },   cImp(),                       .t., cImp(),                       10 )
   ::AddField( "nTotReq", "N", 16, 3, {|| ::cPicOut  },   "Rec",                       .f., "Rec",                       10 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },    "Total",                     .t., "Total",                     10 )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },         "Doc.",                      .t., "Documento",                 14 )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                     14 )

RETURN nil

//----------------------------------------------------------------------------//

METHOD CreateFldAnu()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },         "Cod. articulo",           .f., "Cod. Artículo",           14 )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },         "Artículo",                .f., "Nom. Artículo",           20 )
   ::AddField( "cCodAlm", "C", 16, 0, {|| "@!" },         "Alm",                     .t., "Cod. almacén",             3 )
   ::AddField( "cNomAlm", "C", 50, 0, {|| "@!" },         "Almacém",                 .t., "Nombre almacén",          15 )
   ::AddField( "nImpEne", "N", 16, 6, {|| ::cPicOut },    "Ene",                     .t., "Enero",                   12 )
   ::AddField( "nImpFeb", "N", 16, 6, {|| ::cPicOut },    "Feb",                     .t., "Febrero",                 12 )
   ::AddField( "nImpMar", "N", 16, 6, {|| ::cPicOut },    "Mar",                     .t., "Marzo",                   12 )
   ::AddField( "nImpAbr", "N", 16, 6, {|| ::cPicOut },    "Abr",                     .t., "Abril",                   12 )
   ::AddField( "nImpMay", "N", 16, 6, {|| ::cPicOut },    "May",                     .t., "Mayo",                    12 )
   ::AddField( "nImpJun", "N", 16, 6, {|| ::cPicOut },    "Jun",                     .t., "Junio",                   12 )
   ::AddField( "nImpJul", "N", 16, 6, {|| ::cPicOut },    "Jul",                     .t., "Julio",                   12 )
   ::AddField( "nImpAgo", "N", 16, 6, {|| ::cPicOut },    "Ago",                     .t., "Agosto",                  12 )
   ::AddField( "nImpSep", "N", 16, 6, {|| ::cPicOut },    "Sep",                     .t., "Septiembre",              12 )
   ::AddField( "nImpOct", "N", 16, 6, {|| ::cPicOut },    "Oct",                     .t., "Octubre",                 12 )
   ::AddField( "nImpNov", "N", 16, 6, {|| ::cPicOut },    "Nov",                     .t., "Noviembre",               12 )
   ::AddField( "nImpDic", "N", 16, 6, {|| ::cPicOut },    "Dic",                     .t., "Diciembre",               12 )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },    "Tot",                     .t., "Total",                   12 )
   ::AddField( "nMedia",  "N", 16, 6, {|| ::cPicOut },    "Media",                   .t., "Media",                   12 )

RETURN nil

//----------------------------------------------------------------------------//

METHOD GrupoAnuCreateFld()

   ::AddField ( "CCODART", "C", 18, 0, {|| "@!" },         "Cod. articulo",    .f., "Cod. Artículo",             14 )
   ::AddField ( "CNOMART", "C",100, 0, {|| "@!" },         "Artículo",         .f., "Nom. Artículo",             20 )
   ::AddField ( "CGRPFAM", "C",  5, 0, {|| "@!" },         "Cod. Grp.",        .t., "Codigo grupo familia",       8 )
   ::AddField ( "CNOMGRP", "C", 20, 0, {|| "@!" },         "Grupo",            .t., "Nom. grupo",                20 )
   ::AddField ( "NIMPENE", "N", 16, 6, {|| ::cPicOut },    "Ene",              .t., "Enero",                     12 )
   ::AddField ( "NIMPFEB", "N", 16, 6, {|| ::cPicOut },    "Feb",              .t., "Febrero",                   12 )
   ::AddField ( "NIMPMAR", "N", 16, 6, {|| ::cPicOut },    "Mar",              .t., "Marzo",                     12 )
   ::AddField ( "NIMPABR", "N", 16, 6, {|| ::cPicOut },    "Abr",              .t., "Abril",                     12 )
   ::AddField ( "NIMPMAY", "N", 16, 6, {|| ::cPicOut },    "May",              .t., "Mayo",                      12 )
   ::AddField ( "NIMPJUN", "N", 16, 6, {|| ::cPicOut },    "Jun",              .t., "Junio",                     12 )
   ::AddField ( "NIMPJUL", "N", 16, 6, {|| ::cPicOut },    "Jul",              .t., "Julio",                     12 )
   ::AddField ( "NIMPAGO", "N", 16, 6, {|| ::cPicOut },    "Ago",              .t., "Agosto",                    12 )
   ::AddField ( "NIMPSEP", "N", 16, 6, {|| ::cPicOut },    "Sep",              .t., "Septiembre",                12 )
   ::AddField ( "NIMPOCT", "N", 16, 6, {|| ::cPicOut },    "Oct",              .t., "Octubre",                   12 )
   ::AddField ( "NIMPNOV", "N", 16, 6, {|| ::cPicOut },    "Nov",              .t., "Noviembre",                 12 )
   ::AddField ( "NIMPDIC", "N", 16, 6, {|| ::cPicOut },    "Dic",              .t., "Diciembre",                 12 )
   ::AddField ( "NIMPTOT", "N", 16, 6, {|| ::cPicOut },    "Tot",              .t., "Total",                     12 )
   ::AddField ( "nMedia",  "N", 16, 6, {|| ::cPicOut },    "Media",            .t., "Media",                     12 )

RETURN nil

//----------------------------------------------------------------------------//

METHOD FamAnuCreateFld()

   ::AddField ( "cCodFam", "C", 16, 0, {|| "@!" },         "Cod.fam.",         .t., "Cod. familia",               5 )
   ::AddField ( "cNomFam", "C", 40, 0, {|| "@!" },         "Família",          .t., "Nom. família",              40 )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },         "Código artículo",        .f., "Cod. artículo",             14 )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },         "Artículo",         .f., "Nom. artículo",             20 )
   ::AddField ( "nImpEne", "N", 16, 6, {|| ::cPicOut },    "Ene",              .t., "Enero",                     12 )
   ::AddField ( "nImpFeb", "N", 16, 6, {|| ::cPicOut },    "Feb",              .t., "Febrero",                   12 )
   ::AddField ( "nImpMar", "N", 16, 6, {|| ::cPicOut },    "Mar",              .t., "Marzo",                     12 )
   ::AddField ( "nImpAbr", "N", 16, 6, {|| ::cPicOut },    "Abr",              .t., "Abril",                     12 )
   ::AddField ( "nImpMay", "N", 16, 6, {|| ::cPicOut },    "May",              .t., "Mayo",                      12 )
   ::AddField ( "nImpJun", "N", 16, 6, {|| ::cPicOut },    "Jun",              .t., "Junio",                     12 )
   ::AddField ( "nImpJul", "N", 16, 6, {|| ::cPicOut },    "Jul",              .t., "Julio",                     12 )
   ::AddField ( "nImpAgo", "N", 16, 6, {|| ::cPicOut },    "Ago",              .t., "Agosto",                    12 )
   ::AddField ( "nImpSep", "N", 16, 6, {|| ::cPicOut },    "Sep",              .t., "Septiembre",                12 )
   ::AddField ( "nImpOct", "N", 16, 6, {|| ::cPicOut },    "Oct",              .t., "Octubre",                   12 )
   ::AddField ( "nImpNov", "N", 16, 6, {|| ::cPicOut },    "Nov",              .t., "Noviembre",                 12 )
   ::AddField ( "nImpDic", "N", 16, 6, {|| ::cPicOut },    "Dic",              .t., "Diciembre",                 12 )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },    "Tot",              .t., "Total",                     12 )
   ::AddField ( "nMedia",  "N", 16, 6, {|| ::cPicOut },    "Media",            .t., "Media",                     12 )

RETURN nil

//----------------------------------------------------------------------------//

METHOD TipAnuCreateFld()

   ::AddField ( "cCodTip", "C",  3, 0, {|| "@!" },         "Cod.",             .t., "Código tipo",                3 )
   ::AddField ( "cNomTip", "C", 50, 0, {|| "@!" },         "Tipo",             .t., "Tipo de artículo",          28 )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },         "Cod. articulo",    .f., "Cod. Artículo",             14 )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },         "Artículo",         .f., "Nom. Artículo",             20 )
   ::AddField ( "nImpEne", "N", 16, 6, {|| ::cPicOut },    "Ene",              .t., "Enero",                     12 )
   ::AddField ( "nImpFeb", "N", 16, 6, {|| ::cPicOut },    "Feb",              .t., "Febrero",                   12 )
   ::AddField ( "nImpMar", "N", 16, 6, {|| ::cPicOut },    "Mar",              .t., "Marzo",                     12 )
   ::AddField ( "nImpAbr", "N", 16, 6, {|| ::cPicOut },    "Abr",              .t., "Abril",                     12 )
   ::AddField ( "nImpMay", "N", 16, 6, {|| ::cPicOut },    "May",              .t., "Mayo",                      12 )
   ::AddField ( "nImpJun", "N", 16, 6, {|| ::cPicOut },    "Jun",              .t., "Junio",                     12 )
   ::AddField ( "nImpJul", "N", 16, 6, {|| ::cPicOut },    "Jul",              .t., "Julio",                     12 )
   ::AddField ( "nImpAgo", "N", 16, 6, {|| ::cPicOut },    "Ago",              .t., "Agosto",                    12 )
   ::AddField ( "nImpSep", "N", 16, 6, {|| ::cPicOut },    "Sep",              .t., "Septiembre",                12 )
   ::AddField ( "nImpOct", "N", 16, 6, {|| ::cPicOut },    "Oct",              .t., "Octubre",                   12 )
   ::AddField ( "nImpNov", "N", 16, 6, {|| ::cPicOut },    "Nov",              .t., "Noviembre",                 12 )
   ::AddField ( "nImpDic", "N", 16, 6, {|| ::cPicOut },    "Dic",              .t., "Diciembre",                 12 )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },    "Tot",              .t., "Total",                     12 )
   ::AddField ( "nMedia",  "N", 16, 6, {|| ::cPicOut },    "Media",            .t., "Media",                     12 )

RETURN nil

//----------------------------------------------------------------------------//

METHOD ArtAnuCreateFld()

   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },         "Cod. articulo",    .t., "Cod. Artículo",             14 )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },         "Artículo",         .t., "Nom. Artículo",             20 )
   ::AddField ( "nImpEne", "N", 16, 6, {|| ::cPicOut },    "Ene",              .t., "Enero",                     12 )
   ::AddField ( "nImpFeb", "N", 16, 6, {|| ::cPicOut },    "Feb",              .t., "Febrero",                   12 )
   ::AddField ( "nImpMar", "N", 16, 6, {|| ::cPicOut },    "Mar",              .t., "Marzo",                     12 )
   ::AddField ( "nImpAbr", "N", 16, 6, {|| ::cPicOut },    "Abr",              .t., "Abril",                     12 )
   ::AddField ( "nImpMay", "N", 16, 6, {|| ::cPicOut },    "May",              .t., "Mayo",                      12 )
   ::AddField ( "nImpJun", "N", 16, 6, {|| ::cPicOut },    "Jun",              .t., "Junio",                     12 )
   ::AddField ( "nImpJul", "N", 16, 6, {|| ::cPicOut },    "Jul",              .t., "Julio",                     12 )
   ::AddField ( "nImpAgo", "N", 16, 6, {|| ::cPicOut },    "Ago",              .t., "Agosto",                    12 )
   ::AddField ( "nImpSep", "N", 16, 6, {|| ::cPicOut },    "Sep",              .t., "Septiembre",                12 )
   ::AddField ( "nImpOct", "N", 16, 6, {|| ::cPicOut },    "Oct",              .t., "Octubre",                   12 )
   ::AddField ( "nImpNov", "N", 16, 6, {|| ::cPicOut },    "Nov",              .t., "Noviembre",                 12 )
   ::AddField ( "nImpDic", "N", 16, 6, {|| ::cPicOut },    "Dic",              .t., "Diciembre",                 12 )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },    "Tot",              .t., "Total",                     12 )
   ::AddField ( "nMedia",  "N", 16, 6, {|| ::cPicOut },    "Media",            .t., "Media",                     12 )

RETURN nil

//----------------------------------------------------------------------------//

METHOD CliAnuCreateFld()

   ::FldCliente()
   ::AddField ( "nImpEne", "N", 16, 6, {|| ::cPicOut },    "Ene",              .t., "Enero",                     12 )
   ::AddField ( "nImpFeb", "N", 16, 6, {|| ::cPicOut },    "Feb",              .t., "Febrero",                   12 )
   ::AddField ( "nImpMar", "N", 16, 6, {|| ::cPicOut },    "Mar",              .t., "Marzo",                     12 )
   ::AddField ( "nImpAbr", "N", 16, 6, {|| ::cPicOut },    "Abr",              .t., "Abril",                     12 )
   ::AddField ( "nImpMay", "N", 16, 6, {|| ::cPicOut },    "May",              .t., "Mayo",                      12 )
   ::AddField ( "nImpJun", "N", 16, 6, {|| ::cPicOut },    "Jun",              .t., "Junio",                     12 )
   ::AddField ( "nImpJul", "N", 16, 6, {|| ::cPicOut },    "Jul",              .t., "Julio",                     12 )
   ::AddField ( "nImpAgo", "N", 16, 6, {|| ::cPicOut },    "Ago",              .t., "Agosto",                    12 )
   ::AddField ( "nImpSep", "N", 16, 6, {|| ::cPicOut },    "Sep",              .t., "Septiembre",                12 )
   ::AddField ( "nImpOct", "N", 16, 6, {|| ::cPicOut },    "Oct",              .t., "Octubre",                   12 )
   ::AddField ( "nImpNov", "N", 16, 6, {|| ::cPicOut },    "Nov",              .t., "Noviembre",                 12 )
   ::AddField ( "nImpDic", "N", 16, 6, {|| ::cPicOut },    "Dic",              .t., "Diciembre",                 12 )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },    "Tot",              .t., "Total",                     12 )
   ::AddField ( "nMedia",  "N", 16, 6, {|| ::cPicOut },    "Media",            .t., "Media",                     12 )

RETURN nil

//----------------------------------------------------------------------------//

METHOD AgeAnuCreateFld()

   ::AddField ( "cCodAge", "C",  3, 0, {|| "@!" },         "Cod. Age. ",       .t., "Código agente",     3 )
   ::AddField ( "cNomAge", "C", 50, 0, {|| "@!" },         "Agente",           .t., "Nombre agente",    28 )
   ::AddField ( "nImpEne", "N", 16, 6, {|| ::cPicOut },    "Ene",              .t., "Enero",            12 )
   ::AddField ( "nImpFeb", "N", 16, 6, {|| ::cPicOut },    "Feb",              .t., "Febrero",          12 )
   ::AddField ( "nImpMar", "N", 16, 6, {|| ::cPicOut },    "Mar",              .t., "Marzo",            12 )
   ::AddField ( "nImpAbr", "N", 16, 6, {|| ::cPicOut },    "Abr",              .t., "Abril",            12 )
   ::AddField ( "nImpMay", "N", 16, 6, {|| ::cPicOut },    "May",              .t., "Mayo",             12 )
   ::AddField ( "nImpJun", "N", 16, 6, {|| ::cPicOut },    "Jun",              .t., "Junio",            12 )
   ::AddField ( "nImpJul", "N", 16, 6, {|| ::cPicOut },    "Jul",              .t., "Julio",            12 )
   ::AddField ( "nImpAgo", "N", 16, 6, {|| ::cPicOut },    "Ago",              .t., "Agosto",           12 )
   ::AddField ( "nImpSep", "N", 16, 6, {|| ::cPicOut },    "Sep",              .t., "Septiembre",       12 )
   ::AddField ( "nImpOct", "N", 16, 6, {|| ::cPicOut },    "Oct",              .t., "Octubre",          12 )
   ::AddField ( "nImpNov", "N", 16, 6, {|| ::cPicOut },    "Nov",              .t., "Noviembre",        12 )
   ::AddField ( "nImpDic", "N", 16, 6, {|| ::cPicOut },    "Dic",              .t., "Diciembre",        12 )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },    "Tot",              .t., "Total",            12 )
   ::AddField ( "nMedia",  "N", 16, 6, {|| ::cPicOut },    "Media",            .t., "Media",            12 )

RETURN nil

//----------------------------------------------------------------------------//

METHOD CreateFldRut()

   ::AddField( "CCODRUT", "C",  4, 0, {|| "@!" },          "Ruta",      .f.,        "Código ruta",                4  )
   ::AddField( "CCODCLI", "C", 12, 0, {|| "@!" },          "Cli.",      .f.,        "Código cliente",             8  )
   ::AddField( "CCODFAM", "C", 16, 0, {|| "@!" },          "Cod.",      .t.,        "Código grupo de familia",    5  )
   ::AddField( "CNOMGRF", "C", 35, 0, {|| "@!" },          "Gru. Fam.", .t.,        "Nombre grupo de familia",   25  )
   ::AddField( "CNOMCLI", "C", 50, 0, {|| "@!" },          "Nombre",    .f.,        "Nombre cliente",            25  )
   ::AddField( "NNUMCAJ", "N", 19, 6, {|| MasUnd() },      "Caj.",      lUseCaj(),  "Cajas",                     12  )
   ::AddField( "NNUMUND", "N", 19, 6, {|| MasUnd() },      "Und.",      .t.,        "Unidades",                  12  )
   ::AddField( "NUNDCAJ", "N", 19, 6, {|| MasUnd() },      "Tot. Und.", lUseCaj(),  "Unidades por caja",         12  )
   ::AddField( "NCOMAGE", "N", 19, 6, {|| ::cPicOut },     "Com. Age.", .f.,        "Comisión agente",           12  )
   ::AddField( "NACUIMP", "N", 19, 6, {|| ::cPicOut },     "Imp.",      .t.,        "Importe",                   12  )
   ::AddField( "NACUCAJ", "N", 19, 6, {|| MasUnd() },      "Caj. Acu.", lUseCaj(),  "Cajas acumuladas" ,         12  )
   ::AddField( "NACUUND", "N", 19, 6, {|| MasUnd() },      "Und. Acu.", .t.,        "Unidades acumuladas" ,      12  )
   ::AddField( "NACUUXC", "N", 19, 6, {|| MasUnd() },      "Tot. Acu.", lUseCaj(),  "Acumulado cajas x unidades",12  )
   ::AddField( "NTOTMOV", "N", 19, 6, {|| ::cPicOut },     "Imp. Acu.", .t.,        "Importe" ,                  12  )

RETURN nil

//----------------------------------------------------------------------------//

METHOD AddCliente( cCodCli, oDbfDocT, lTiket )

   local oError
   local oBlock

   DEFAULT lTiket := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if ::oDbfCli == nil
         DATABASE NEW ::oDbfCli PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"
      end if

      ::oDbf:cCodCli    := cCodCli
      ::oDbf:cNifCli    := oDbfDocT:cDniCli

      if lTiket
         ::oDbf:cNomCli := oDbfDocT:cNomTik
      else
         ::oDbf:cNomCli := oDbfDocT:cNomCli
      end if

      ::oDbf:cDomCli    := oDbfDocT:cDirCli
      ::oDbf:cPobCli    := oDbfDocT:cPobCli
      ::oDbf:cProCli    := oDbfDocT:cPrvCli
      ::oDbf:cCdpCli    := oDbfDocT:cPosCli

      if oDbfDocT:FieldPos( "cCodObr" ) != 0 .and. ::oDbf:FieldPos( "cObrCli" ) != 0
         ::oDbf:cObrCli := oDbfDocT:cCodObr
      end if

      if ::oDbfCli:Seek ( cCodCli )

         if Empty( ::oDbf:cNifCli )
            ::oDbf:cNifCli := ::oDbfCli:Nif
         end if

         if Empty( ::oDbf:cNomCli )
            ::oDbf:cNomCli := ::oDbfCli:Titulo
         end if

         if Empty( ::oDbf:cDomCli )
            ::oDbf:cDomCli := ::oDbfCli:Domicilio
         end if

         if Empty( ::oDbf:cPobCli )
            ::oDbf:cPobCli := ::oDbfCli:Poblacion
         end if

         if Empty( ::oDbf:cProCli )
            ::oDbf:cProCli := ::oDbfCli:Provincia
         end if

         if Empty( ::oDbf:cCdpCli )
            ::oDbf:cCdpCli := ::oDbfCli:CodPostal
         end if

         ::oDbf:cTlfCli := ::oDbfCli:Telefono

         if ::oDbf:FieldPos( "cNbrEst" ) != 0
            ::oDbf:cNbrEst := ::oDbfCli:NbrEst
         end if

      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      ::oDbf:cNifCli    := ""

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddTemporada( cCodTmp, oDbfTmp )

   local oError
   local oBlock

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if ::oDbfTmp == nil
         DATABASE NEW ::oDbfTmp PATH ( cPatEmp() ) FILE "Temporadas.DBF" VIA ( cDriver() ) SHARED INDEX "Temporadas.CDX"
      end if

      ::oDbf:cCodTmp    := cCodTmp
      ::oDbf:cNomTmp    := oDbfTmp:cNombre

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      ::oDbf:cNifCli    := ""

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FldProveedor()

   ::AddField( "cCodPrv", "C", 12, 0, {|| "@!" },         "Prv.",                      .t., "Cod. Proveedor",              9 )
   ::AddField( "cNomPrv", "C", 50, 0, {|| "@!" },         "Proveedor",                 .t., "Nombre Proveedor",           35 )
   ::AddField( "cNifPrv", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                        15 )
   ::AddField( "cDomPrv", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  35 )
   ::AddField( "cPobPrv", "C", 25, 0, {|| "@!" },         "Población",                 .f., "Población",                  25 )
   ::AddField( "cProPrv", "C", 20, 0, {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 )
   ::AddField( "cCdpPrv", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",                 7 )
   ::AddField( "cTlfPrv", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                   12 )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddProveedor( cCodPrv )

   if ::oDbfPrv == nil
      DATABASE NEW ::oDbfPrv PATH ( cPatEmp() ) FILE "PROVEE.DBF" VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"
   end if

   if ::oDbfPrv:Seek ( cCodPrv )

      ::oDbf:cCodPrv := cCodPrv
      ::oDbf:cNifPrv := ::oDbfPrv:Nif
      ::oDbf:cNomPrv := ::oDbfPrv:Titulo
      ::oDbf:cDomPrv := ::oDbfPrv:Domicilio
      ::oDbf:cPobPrv := ::oDbfPrv:Poblacion
      ::oDbf:cProPrv := ::oDbfPrv:Provincia
      ::oDbf:cCdpPrv := ::oDbfPrv:CodPostal
      ::oDbf:cTlfPrv := ::oDbfPrv:Telefono

   end if

RETURN nil

//---------------------------------------------------------------------------//

METHOD AcuPesVol( cCodArt, nTotUni, nImporte, lAcumula )

   DEFAULT lAcumula     := .f.

   if lAcumula
      ::oDbf:nTotPes    += nTotUni * oRetFld( cCodArt, ::oDbfArt, "nPesoKg"  )
      ::oDbf:nTotVol    += nTotUni * oRetFld( cCodArt, ::oDbfArt, "nVolumen" )
   else
      ::oDbf:nTotPes    := nTotUni * oRetFld( cCodArt, ::oDbfArt, "nPesoKg"  )
      ::oDbf:nTotVol    := nTotUni * oRetFld( cCodArt, ::oDbfArt, "nVolumen" )
   end if

   ::oDbf:nPreKgr       := if( ::oDbf:nTotPes != 0, Div( nImporte, ::oDbf:nTotPes ), 0 )
   ::oDbf:nPreVol       := if( ::oDbf:nTotVol != 0, Div( nImporte, ::oDbf:nTotVol ), 0 )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Grafico()

return ( Self )

//---------------------------------------------------------------------------//

METHOD AddImporte( dFecDoc, nImpDoc )

   ::oDbf:Load()

   do case
      case Month( dFecDoc ) == 1
         ::oDbf:nImpEne += nImpDoc
      case Month( dFecDoc ) == 2
         ::oDbf:nImpFeb += nImpDoc
      case Month( dFecDoc ) == 3
         ::oDbf:nImpMar += nImpDoc
      case Month( dFecDoc ) == 4
         ::oDbf:nImpAbr += nImpDoc
      case Month( dFecDoc ) == 5
         ::oDbf:nImpMay += nImpDoc
      case Month( dFecDoc ) == 6
         ::oDbf:nImpJun += nImpDoc
      case Month( dFecDoc ) == 7
         ::oDbf:nImpJul += nImpDoc
      case Month( dFecDoc ) == 8
         ::oDbf:nImpAgo += nImpDoc
      case Month( dFecDoc ) == 9
         ::oDbf:nImpSep += nImpDoc
      case Month( dFecDoc ) == 10
         ::oDbf:nImpOct += nImpDoc
      case Month( dFecDoc ) == 11
         ::oDbf:nImpNov += nImpDoc
      case Month( dFecDoc ) == 12
         ::oDbf:nImpDic += nImpDoc
   end case

   ::oDbf:nImpTot       += nImpDoc

   ::oDbf:Save()

return nil

//---------------------------------------------------------------------------//

METHOD nMediaMes( nAnno )

   local nTotal   := 0
   local nMes     := Month( GetSysDate() ) -1

   do case
      case nMes == 1
         nTotal :=  ::oDbf:nImpEne
      case nMes == 2
         nTotal :=  ::oDbf:nImpEne + ::oDbf:nImpFeb
      case nMes == 3
         nTotal :=  ::oDbf:nImpEne + ::oDbf:nImpFeb + ::oDbf:nImpMar
      case nMes == 4
         nTotal :=  ::oDbf:nImpEne + ::oDbf:nImpFeb + ::oDbf:nImpMar + ::oDbf:nImpAbr
      case nMes == 5
         nTotal :=  ::oDbf:nImpEne + ::oDbf:nImpFeb + ::oDbf:nImpMar + ::oDbf:nImpAbr + ::oDbf:nImpMay
      case nMes == 6
         nTotal :=  ::oDbf:nImpEne + ::oDbf:nImpFeb + ::oDbf:nImpMar + ::oDbf:nImpAbr + ::oDbf:nImpMay + ::oDbf:nImpJun
      case nMes == 7
         nTotal :=  ::oDbf:nImpEne + ::oDbf:nImpFeb + ::oDbf:nImpMar + ::oDbf:nImpAbr + ::oDbf:nImpMay + ::oDbf:nImpJun + ::oDbf:nImpJul
      case nMes == 8
         nTotal :=  ::oDbf:nImpEne + ::oDbf:nImpFeb + ::oDbf:nImpMar + ::oDbf:nImpAbr + ::oDbf:nImpMay + ::oDbf:nImpJun + ::oDbf:nImpJul + ::oDbf:nImpAgo
      case nMes == 9
         nTotal :=  ::oDbf:nImpEne + ::oDbf:nImpFeb + ::oDbf:nImpMar + ::oDbf:nImpAbr + ::oDbf:nImpMay + ::oDbf:nImpJun + ::oDbf:nImpJul + ::oDbf:nImpAgo + ::oDbf:nImpSep
      case nMes == 10
         nTotal :=  ::oDbf:nImpEne + ::oDbf:nImpFeb + ::oDbf:nImpMar + ::oDbf:nImpAbr + ::oDbf:nImpMay + ::oDbf:nImpJun + ::oDbf:nImpJul + ::oDbf:nImpAgo + ::oDbf:nImpSep + ::oDbf:nImpOct
      case nMes == 11
         nTotal :=  ::oDbf:nImpEne + ::oDbf:nImpFeb + ::oDbf:nImpMar + ::oDbf:nImpAbr + ::oDbf:nImpMay + ::oDbf:nImpJun + ::oDbf:nImpJul + ::oDbf:nImpAgo + ::oDbf:nImpSep + ::oDbf:nImpOct + ::oDbf:nImpNov
   end case


   if nAnno < Year( GetSysDate() )

      ::oDbf:Load()
      ::oDbf:nMedia     := ::oDbf:nImpTot / 12
      ::oDbf:Save()

   else

      if ( nMes ) == 0
         ::oDbf:Load()
         ::oDbf:nMedia     := 0
         ::oDbf:Save()
      else
         ::oDbf:Load()
         ::oDbf:nMedia     := nTotal / nMes
         ::oDbf:Save()
      end if

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

Method SetMetInf( oDbf ) CLASS TInfGen

   if ::oMtrInf != nil
      ::oMtrInf:SetTotal( oDbf:Lastrec() )
      ::nEvery := Int( oDbf:Lastrec() / 10 )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method RefMetInf( nPos ) CLASS TInfGen

   // .and. nPos % ::nEvery == 0

   if ::oMtrInf != nil
      ::oMtrInf:AutoInc( nPos )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Function aGetFont()

#ifdef __HARBOUR__

   local hDC      := GetDC( 0 )
   local aFonts   := GetFontNames( hDC )
   ReleaseDC( 0, hDC )

#else

   Local aFonts   := {}

   EnumFonts( { | cName | aAdd( aFonts, cName ) } )

#endif

   if Empty( aFonts )
      msgStop( "Error getting font names" )
   else
      aSort( aFonts,,, { |x, y| upper( x ) < upper( y ) } )
   endif

Return aFonts

//---------------------------------------------------------------------------//

METHOD OpenData( cPath, lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT cPath        := cPatEmp()
   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbfInf )
         ::oDbfInf      := ::DefineConfigUser( cPath )
      end if

      if Empty( ::oDbfFnt )
         ::oDbfFnt      := ::DefineFont( cPath )
      end if

      if Empty( ::oDbfGrp )
         ::oDbfGrp      := ::DefineGroup( cPath )
      end if

      /*
      Apertura de los fiche de configuración--------------------------------------
      */

      ::oDbfInf:Activate( .f., !( lExclusive ) )

      ::oDbfFnt:Activate( .f., !( lExclusive ) )

      ::oDbfGrp:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseData()

   if ::oDbfInf != nil .and. ::oDbfInf:Used()
      ::oDbfInf:end()
   end if

   if ::oDbfFnt != nil .and. ::oDbfFnt:Used()
      ::oDbfFnt:end()
   end if

   if ::oDbfGrp != nil .and. ::oDbfGrp:Used()
      ::oDbfGrp:end()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SyncAllDbf()

   ::OpenData( cPatEmp(), .t. )

   lCheckDbf( ::oDbfInf )
   lCheckDbf( ::oDbfFnt )
   lCheckDbf( ::oDbfGrp )

   ::CloseData()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateFilter( aTField, oDbf, lMultyExpresion )

   DEFAULT lMultyExpresion       := .f.

   ::oFilter                     := TFilterCreator():Init() 
   
   do case
      case !Empty( aTField )
         ::oFilter:SetFields( aTField )

      case !Empty( oDbf )
         ::oFilter:SetDatabase( oDbf )
   end case 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD EvalFilter( oDbf )

   local lFilter  := .t.

   DEFAULT oDbf   := ::oDbfMai

   if !Empty( ::oFilter ) .and. !Empty( ::oFilter:bExpresionFilter )

      if IsObject( oDbf ) .and. ( oDbf:Used() )
         
         lFilter  := ( oDbf:nArea )->( Eval( ::oFilter:bExpresionFilter ) )
      
      end if 

   end if

RETURN ( lFilter )

//---------------------------------------------------------------------------//

METHOD lGenerate()

   local n
   local nFldPos
   local uFldVal

   if Empty( ::oParent )
      return .f.
   end if

   if Empty( ::oDbfMai )
      return .f.
   end if

   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                        {|| "Código : " + AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) } }

   /*
   Vamos a ver si trae detalle cabecera----------------------------------------
   */

   if Empty( ::oDbfDet )

      ::SetMetInf( ::oDbfMai )
      ::oDbfMai:GetStatus()

      ::oDbfMai:GoTop()
      while !::oDbfMai:Eof()

      if ::oDbfMai:OrdKeyVal() >= ::cArtOrg .and. ::oDbfMai:OrdKeyVal() <= ::cArtDes .and. ::EvalFilter( ::oDbfMai )

         ::oDbf:Append()

         for n := 1 to ::oDbf:FieldCount

            nFldPos  := ::oDbfMai:FieldPos( ::oDbf:FieldName( n ) )
            uFldVal  := ::oDbfMai:FieldGetName( ::oDbf:FieldName( n ) )

            ::oDbf:FieldPut( nFldPos, uFldVal )

         next

         ::RefMetInf( ::oDbfMai:OrdKeyNo() )

      end if

      ::oDbfMai:Skip()

      end while

      ::RefMetInf( ::oDbfMai:LastRec() )

      ::oDbfMai:SetStatus()

   else

      ::SetMetInf( ::oDbfMai )

      ::oDbfMai:GetStatus()
      ::oDbfDet:GetStatus()

      ::oDbfMai:GoTop()
      while !::oDbfMai:Eof()

      if ::oDbfMai:OrdKeyVal() >= ::cArtOrg .and. ::oDbfMai:OrdKeyVal() <= ::cArtDes

         if ::oDbfDet:Seek( ::oDbfMai:OrdKeyVal() )

            while ::oDbfDet:OrdKeyVal() == ::oDbfMai:OrdKeyVal() .and. !::oDbfDet:Eof()

               ::oDbf:Append()

               for n := 1 to ::oDbf:FieldCount

                  nFldPos  := ::oDbfDet:FieldPos( ::oDbf:FieldName( n ) )
                  uFldVal  := ::oDbfDet:FieldGetName( ::oDbf:FieldName( n ) )

                  ::oDbf:FieldPut( nFldPos, uFldVal )

               next

               ::oDbfDet:Skip()

           end while

        end if

      end if

      ::RefMetInf( ::oDbfMai:OrdKeyNo() )

      ::oDbfMai:Skip()

      end while

      ::RefMetInf( ::oDbfMai:LastRec() )

      ::oDbfMai:SetStatus()
      ::oDbfDet:SetStatus()

   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD oDefDesHas( nIdOrg, nIdSayOrg, nIdDes, nIdSayDes, oDlg ) CLASS TInfGen

   local oArtOrg
   local oArtDes
   local oSayArtOrg
   local oSayArtDes
   local cSayArtOrg
   local cSayArtDes

   DEFAULT nIdOrg    := 1110
   DEFAULT nIdSayOrg := 1111
   DEFAULT nIdDes    := 1120
   DEFAULT nIdSayDes := 1121
   DEFAULT oDlg      := ::oFld:aDialogs[1]

   ::oDbfMai:GoBottom()
   ::cArtDes         := ::oDbfMai:OrdkeyVal()
   cSayArtDes        := ::oDbfMai:FieldGet( 2 )

   ::oDbfMai:GoTop()
   ::cArtOrg         := ::oDbfMai:OrdkeyVal()
   cSayArtOrg        := ::oDbfMai:FieldGet( 2 )

   REDEFINE GET oArtOrg VAR ::cArtOrg;
      ID       ( nIdOrg ) ;
      BITMAP   "LUPA" ;
      OF       oDlg

      oArtOrg:bHelp  := {|| ::oParent:Buscar( oArtOrg ) }
      oArtOrg:bValid := {|| ::oParent:lValid( oArtOrg, oSayArtOrg ) }

   REDEFINE GET oSayArtOrg VAR cSayArtOrg ;
      WHEN     .f.;
      ID       ( nIdSayOrg ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oArtDes VAR ::cArtDes;
      ID       ( nIdDes ) ;
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

      oArtDes:bHelp  := {|| ::oParent:Buscar( oArtDes ) }
      oArtDes:bValid := {|| ::oParent:lValid( oArtDes, oSayArtDes ) }

   REDEFINE GET oSayArtDes VAR cSayArtDes ;
      WHEN     .f.;
      ID       ( nIdSayDes ) ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD MakeVisor()

   if file( cPatHtml() + "Visor.htm" )
      fErase( cPatHtml() + "Visor.htm" )
   end if

   ::hFile    := fCreate( cPatHtml() + "Visor.htm" )

   fWrite( ::hFile,  "<HTML>"                                              + CRLF )
   fWrite( ::hFile,  "<HEAD>"                                              + CRLF )
   fWrite( ::hFile,  "<TITLE>Visor de informes</TITLE>"                    + CRLF )
   fWrite( ::hFile,  "<script LANGUAGE='JavaScript'>"                      + CRLF )
   fWrite( ::hFile,  "var cPage = 'REP';"                                  + CRLF )
   fWrite( ::hFile,  "var nPaginas = " + Str( ::oReport:nPage, 4 ) + ";"   + CRLF )
   fWrite( ::hFile,  "var nPagina = 1;"                                    + CRLF )

   fWrite( ::hFile,  "function cGetPageName( nPagina )"                    + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "var cPageName = cPage;"                              + CRLF )
   fWrite( ::hFile,  "var cPagina = new String( nPagina );"                + CRLF )
   fWrite( ::hFile,  "var nLen = ( cPageName.length + cPagina.length )"    + CRLF )
   fWrite( ::hFile,  ""                                                    + CRLF )
   fWrite( ::hFile,  "for( var i = 0; i < ( 8 - nLen ); i ++ )"            + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "cPageName = cPageName + '0';"                        + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "cPageName = cPageName + cPagina + '.htm';"           + CRLF )
   fWrite( ::hFile,  "return cPageName;"                                   + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  ""                                                    + CRLF )
   fWrite( ::hFile,  "function MovePage( nModo, nNewPagina )"              + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "switch( nModo )"                                     + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "case 1:"                                             + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "nPagina = 1;"                                        + CRLF )
   fWrite( ::hFile,  "break;"                                              + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "case 2:"                                             + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "nPagina --;"                                         + CRLF )
   fWrite( ::hFile,  "if( nPagina < 1 )"                                   + CRLF )
   fWrite( ::hFile,  "nPagina = 1;"                                        + CRLF )
   fWrite( ::hFile,  "break;"                                              + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "case 3:"                                             + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "nPagina ++;"                                         + CRLF )
   fWrite( ::hFile,  "if( nPagina > nPaginas )"                            + CRLF )
   fWrite( ::hFile,  "nPagina = nPaginas;"                                 + CRLF )
   fWrite( ::hFile,  "break;"                                              + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "case 4:"                                             + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "nPagina = nPaginas;"                                 + CRLF )
   fWrite( ::hFile,  "break;"                                              + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "case 5:"                                             + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "if( nNewPagina > 0 && nNewPagina <= nPaginas )"      + CRLF )
   fWrite( ::hFile,  "nPagina = nNewPagina;"                               + CRLF )
   fWrite( ::hFile,  "break;"                                              + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )

   fWrite( ::hFile,  "cPageName = cGetPageName( nPagina );"                + CRLF )
   fWrite( ::hFile,  "document.frames.DATOS.location = cPageName;"         + CRLF )
   fWrite( ::hFile,  "DisplayPages();"                                     + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  ""                                                    + CRLF )

   fWrite( ::hFile,  "function DisplayPages()"                             + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "PAGINA.innerText = 'Página ' + nPagina + ' de ' + nPaginas;"  + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )

   fWrite( ::hFile,  "function Zoom(inc)"                                  + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "var oSel = document.all.zoomPorcentaje;"             + CRLF )
   fWrite( ::hFile,  "var newZoom = parseInt(document.all.DivPagina.style.zoom) + parseInt(inc);"  + CRLF )
   fWrite( ::hFile,  ""                                                    + CRLF )
   fWrite( ::hFile,  "if (newZoom < 0 )"                                   + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "alert('El porcentaje no puede ser menos que cero.')" + CRLF )
   fWrite( ::hFile,  "return;"                                             + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  ""                                                    + CRLF )
   fWrite( ::hFile,  "document.all.DivPagina.style.zoom = newZoom+'%';"    + CRLF )
   fWrite( ::hFile,  "document.all.zoomPorcentaje.options.add"             + CRLF )
   fWrite( ::hFile,  "if (newZoom != 100 && newZoom != 75 && newZoom != 50 && newZoom != 25)" + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "var oOption;"                                        + CRLF )
   fWrite( ::hFile,  "if (typeof(document.all.SelActual) == 'undefined')"  + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "oOption = document.createElement('OPTION');"         + CRLF )
   fWrite( ::hFile,  "oOption.id = 'SelActual';"                           + CRLF )
   fWrite( ::hFile,  "oSel.options.add(oOption);"                          + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "else"                                                + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "oOption = document.all.SelActual;"                   + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "oOption.innerText = newZoom+'%';"                    + CRLF )
   fWrite( ::hFile,  "oOption.selected = true;"                            + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "else"                                                + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "for(var i=0;i<oSel.options.length;i++)"              + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "var impuestosl = parseInt(oSel.options(i).innerText);"     + CRLF )
   fWrite( ::hFile,  "if (newZoom == impuestosl)"                                + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "oSel.options(i).selected = true;"                    + CRLF )
   fWrite( ::hFile,  "break;"                                              + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )

   fWrite( ::hFile,  "function Zoom2(oSel)"                                + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "var newZoom = oSel.options[oSel.selectedIndex].innerText;" + CRLF )
   fWrite( ::hFile,  "document.all.DivPagina.style.zoom=newZoom;"          + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  ""                                                    + CRLF )
   fWrite( ::hFile,  "function BrowserCheck()"                             + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "var b = navigator.appName"                           + CRLF )
   fWrite( ::hFile,  "if (b=='Netscape')"                                  + CRLF )
   fWrite( ::hFile,  "this.b = 'ns'"                                       + CRLF )
   fWrite( ::hFile,  "else"                                                + CRLF )
   fWrite( ::hFile,  "if (b=='Microsoft Internet Explorer')"               + CRLF )
   fWrite( ::hFile,  "this.b = 'ie'"                                       + CRLF )
   fWrite( ::hFile,  "else"                                                + CRLF )
   fWrite( ::hFile,  "this.b = b"                                          + CRLF )
   fWrite( ::hFile,  ""                                                    + CRLF )
   fWrite( ::hFile,  "this.version = navigator.appVersion"                 + CRLF )
   fWrite( ::hFile,  "this.v = parseInt(this.version)"                     + CRLF )
   fWrite( ::hFile,  "this.ns = (this.b=='ns' && this.v>=4)"               + CRLF )
   fWrite( ::hFile,  "this.ns4 = (this.b=='ns' && this.v==4)"              + CRLF )
   fWrite( ::hFile,  "this.ns5 = (this.b=='ns' && this.v==5)"              + CRLF )
   fWrite( ::hFile,  "this.ie = (this.b=='ie' && this.v>=4)"               + CRLF )
   fWrite( ::hFile,  "this.ie4 = (this.version.indexOf('MSIE 4')>0)"       + CRLF )
   fWrite( ::hFile,  "this.ie5 = (this.version.indexOf('MSIE 5')>0)"       + CRLF )
   fWrite( ::hFile,  "this.ie55 = (this.version.indexOf('MSIE 5.5')>0)"    + CRLF )
   fWrite( ::hFile,  "this.ie6 = (this.version.indexOf('MSIE 6')>0 )"      + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  ""                                                    + CRLF )

   fWrite( ::hFile,  "function window.onload()"                            + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "BrowserCheck();"                                     + CRLF )
   fWrite( ::hFile,  "if( ! ( this.ie55 || this.ie6 ) )"                   + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "document.all.ListBoxZoom.style.visibility = 'hidden'"+ CRLF )
   fWrite( ::hFile,  "document.all.zoomPorcentaje.style.visibility = 'hidden'"   + CRLF )
   fWrite( ::hFile,  "document.all.ButtonZoomPlus.style.visibility = 'hidden'"   + CRLF )
   fWrite( ::hFile,  "document.all.ButtonZoomMinus.style.visibility = 'hidden'"  + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "DisplayPages();"                                     + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "function LaunchApolo()"                              + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "window.open( 'http://www.apolosoftware.com' );"      + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "function window.onbeforeprint()"                     + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "document.all.todo.style.display='none';"             + CRLF )
   fWrite( ::hFile,  "document.all.gruposp.style.display='none';"          + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "function window.onafterprint()"                      + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "document.all.gruposp.style.display='block';"         + CRLF )
   fWrite( ::hFile,  "document.all.todo.style.display='block';"            + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )

   fWrite( ::hFile,  "</SCRIPT>"                                           + CRLF )
   fWrite( ::hFile,  "<STYLE TYPE='text/css'>"                             + CRLF )
   fWrite( ::hFile,  ".ButtonStyle"                                        + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "font-family: 'MS Sans Serif';"                       + CRLF )
   fWrite( ::hFile,  "font-size:xx-small;"                                 + CRLF )
   fWrite( ::hFile,  "font-weight:lighter;"                                + CRLF )
   fWrite( ::hFile,  "color:black;"                                        + CRLF )
   fWrite( ::hFile,  "cursor:hand;"                                        + CRLF )
   fWrite( ::hFile,  "padding: 1px 3px 1px 3px;"                           + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  ".DEFAULT"                                            + CRLF )
   fWrite( ::hFile,  "{"                                                   + CRLF )
   fWrite( ::hFile,  "font-family:MS Sans Serif;"                          + CRLF )
   fWrite( ::hFile,  "font-size:9;"                                        + CRLF )
   fWrite( ::hFile,  "font-weight:normal;"                                 + CRLF )
   fWrite( ::hFile,  "font-style:normal;"                                  + CRLF )
   fWrite( ::hFile,  "}"                                                   + CRLF )
   fWrite( ::hFile,  "</STYLE>"                                            + CRLF )
   fWrite( ::hFile,  "</HEAD>"                                             + CRLF )
   fWrite( ::hFile,  "<BODY BGCOLOR='#EDEFEA'>"                            + CRLF )
   fWrite( ::hFile,  "<DIV ID='todo'>"                                     + CRLF )
   fWrite( ::hFile,  "<TABLE BORDER='0' ALIGN='CENTER' ID='botones'>"      + CRLF )
   fWrite( ::hFile,  "<TR>"                                                + CRLF )
   fWrite( ::hFile,  "<TD ID='ButtonFirst' ALIGN='left' STYLE='display:'><INPUT CLASS='ButtonStyle' TYPE='Button' VALUE=' Primera ' ONCLICK='JavaScript:MovePage( 1 )'></TD>" + CRLF )
   fWrite( ::hFile,  "<TD ID='ButtonPrev' ALIGN='left' STYLE='display:'><INPUT CLASS='ButtonStyle' TYPE='Button' VALUE=' Anterior ' ONCLICK='JavaScript:MovePage( 2 )'></TD>" + CRLF )
   fWrite( ::hFile,  "<TD ID='ButtonNext' ALIGN='left' STYLE='display:'><INPUT CLASS='ButtonStyle' TYPE='Button' VALUE=' Siguiente ' ONCLICK='JavaScript:MovePage( 3 )'></TD>"+ CRLF )
   fWrite( ::hFile,  "<TD ID='ButtonLast' ALIGN='left' STYLE='display:'><INPUT CLASS='ButtonStyle' TYPE='Button' VALUE=' Ultima ' ONCLICK='JavaScript:MovePage( 4 )'></TD>"   + CRLF )
   fWrite( ::hFile,  "<TD ID='ButtonZoomPlus' ALIGN='left' STYLE='display:'><INPUT CLASS='ButtonStyle' TYPE='Button' VALUE=' Zoom + ' ONCLICK='Zoom(+10)'></TD>"              + CRLF )
   fWrite( ::hFile,  "<TD ID='ButtonZoomMinus' ALIGN='left' STYLE='display:'><INPUT CLASS='ButtonStyle' TYPE='Button' VALUE=' Zoom - ' ONCLICK='Zoom(-10)'></TD>"             + CRLF )
   fWrite( ::hFile,  "<TD ID='ListBoxZoom'>"                               + CRLF )
   fWrite( ::hFile,  "<SELECT ID='zoomPorcentaje' ONCHANGE='Zoom2(zoomPorcentaje);'>"  + CRLF )
   fWrite( ::hFile,  "<OPTION VALUE='100%'>100%</OPTION>"                  + CRLF )
   fWrite( ::hFile,  "<OPTION VALUE='75%'>75%</OPTION>"                    + CRLF )
   fWrite( ::hFile,  "<OPTION VALUE='50%'>50%</OPTION>"                    + CRLF )
   fWrite( ::hFile,  "<OPTION VALUE='25%'>25%</OPTION>"                    + CRLF )
   fWrite( ::hFile,  "</SELECT>"                                           + CRLF )
   fWrite( ::hFile,  "</TD>"                                               + CRLF )
   fWrite( ::hFile,  "</TR>"                                               + CRLF )
   fWrite( ::hFile,  "<TR>"                                                + CRLF )
   fWrite( ::hFile,  "<TD ALIGN='left' ><P CLASS='DEFAULT' ID='PAGINA'></P></TD>"   + CRLF )
   fWrite( ::hFile,  "<TD>&nbsp;</TD>"                                     + CRLF )
   fWrite( ::hFile,  "<TD COLSPAN='5' ALIGN='left'>"                       + CRLF )
   fWrite( ::hFile,  "<P CLASS='DEFAULT'>"                                 + CRLF )
   fWrite( ::hFile,  "Ir a Página&nbsp;&nbsp;&nbsp;&nbsp;"                 + CRLF )
   fWrite( ::hFile,  "<INPUT CLASS='DEFAULT' TYPE='text' NAME='GOTOPAGE' VALUE='1' SIZE='5' >"  + CRLF )
   fWrite( ::hFile,  "&nbsp;&nbsp;"                                        + CRLF )
   fWrite( ::hFile,  "<INPUT CLASS='ButtonStyle' TYPE='Button' VALUE=' Ir ' ONCLICK='JavaScript:MovePage( 5, GOTOPAGE.value )'>"  + CRLF )
   fWrite( ::hFile,  "</P>"                                                + CRLF )
   fWrite( ::hFile,  "</TD>"                                               + CRLF )
   fWrite( ::hFile,  "<TD COLSPAN='2'></TD>"                               + CRLF )
   fWrite( ::hFile,  "</TR>"                                               + CRLF )
   fWrite( ::hFile,  "</TABLE>"                                            + CRLF )
   fWrite( ::hFile,  "<CENTER>"                                            + CRLF )
   fWrite( ::hFile,  ""                                                    + CRLF )
   fWrite( ::hFile,  "<BR>"                                                + CRLF )
   fWrite( ::hFile,  "</DIV>"                                              + CRLF )
   fWrite( ::hFile,  "<DIV ID='DivPagina' style='zoom=100%'>"              + CRLF )
   fWrite( ::hFile,  "<IFRAME SRC='REP00001.htm' NAME='DATOS' ID='DATOS' STYLE='overflow-x: hidden;' width='100%' height='400' marginwidth='1' marginheight='1' border='0' frameborder='0' align='center'>" + CRLF )
   fWrite( ::hFile,  "</IFRAME>"                                           + CRLF )
   fWrite( ::hFile,  "</DIV>"                                              + CRLF )
   fWrite( ::hFile,  "</CENTER>"                                           + CRLF )
   fWrite( ::hFile,  "<P CLASS='DEFAULT' ALIGN='center' id='apolo'>"       + CRLF )
   fWrite( ::hFile,  "<A HREF='Javascript:LaunchApolo()'>http://www.apolosoftware.com</A>"   + CRLF )
   fWrite( ::hFile,  "</P>"                                                + CRLF )
   fWrite( ::hFile,  "</BODY>"                                             + CRLF )
   fWrite( ::hFile,  "</HTML>"                                             + CRLF )

   fClose( ::hFile )

   ::hFile := 0

   if File( cPatHtml() + "Visor.Htm" )
      GoWeb( cPatHtml() + "Visor.Htm" )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GenReport( nOption )

   DEFAULT nOption      := ::oCmbReport:nAt

   ::lBreak             := .f.
   ::oBtnCancel:bAction := {|| ::lBreak := .t. }

   ::oFld:SetOption( 1 )

   if Valtype( ::bPreGenerate ) == "B"
      Eval( ::bPreGenerate )
   end if

   ::CreaGrupos()

   if ::lGenerate()
      if !::lBreak
         ::Print( nOption )
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

//---------------------------------------------------------------------------//

METHOD Xml() // Excel()

   local oCol
   local nFor
   local nRow
   local nCol
   local oBook
   local cType
   local uValue
   local oExcel
   local oSheet

   nRow                    := 0
   nCol                    := 0
   oExcel                  := ExcelObj()

   if Empty( oExcel )
      Return Self
   end if

   oExcel:ScreenUpdating   := .f.
   oBook                   := oExcel:WorkBooks:Add()
   oSheet                  := oExcel:ActiveSheet

   /*
   Cabeceras-------------------------------------------------------------------
   */

   ++nRow

   for each oCol in ::aoCols

      if oCol != nil .and. oCol:lSelect

         oSheet:Cells( nRow, ++nCol ):Value                 := oCol:cTitle
         oExcel:Cells( nRow, nCol ):Borders( 3 ):LineStyle  := 1
         oExcel:Cells( nRow, nCol ):Borders( 9 ):LineStyle  := 1
         oExcel:Cells( nRow, nCol ):Borders( 3 ):Weight     := -4138
         oExcel:Cells( nRow, nCol ):Borders( 9 ):Weight     := -4138
         oSheet:Cells( nRow, nCol ):Font:Bold               := .t.

         cType                                              := Valtype( Eval( oCol:bFld ) )

         do case
            case cType == "N"
               oSheet:Columns( nCol ):NumberFormat          := Clp2xlNumPic( Eval( oCol:bPict ) )
               oSheet:Columns( nCol ):HorizontalAlignment   := - 4152

            case cType == "D"

               //oSheet:Columns( nCol ):NumberFormat          := Lower( Set( _SET_DATEFORMAT ) )
               oSheet:Columns( nCol ):HorizontalAlignment   := - 4152

            case cType == "C"
               oSheet:Columns( nCol ):NumberFormat          := "@"
               oSheet:Columns( nCol ):HorizontalAlignment   := - 4131

         end case

         oSheet:Columns( nCol ):ColumnWidth                 := oCol:nSize // / 7.5

      end if

   next

   /*
   Cuerpo----------------------------------------------------------------------
   */

   ::oDbf:GoTop()
   while !::lBreak .and. !::oDbf:eof()

      ++nRow

      nCol                 := 0

      for each oCol in ::aoCols
         if oCol != nil .and. oCol:lSelect

            uValue         := Eval( oCol:bFld )

            if ( ValType( uValue ) $ 'DT' ) .and. !Empty( uValue )// .and. ( Year( uValue ) < 1900 )
               uValue      := DToC( uValue )
            endif

            if uValue != nil
               oSheet:Cells( nRow, ++nCol ):Value  := uValue
            end if

         end if
      next

      ::oDbf:Skip()

   end while

   /*
   Anchos automaticos----------------------------------------------------------
   */

   nCol                    := 0

   for each oCol in ::aoCols

      if oCol != nil .and. oCol:lSelect

         oSheet:Columns( ++nCol ):AutoFit()

         oExcel:Cells( nRow, nCol ):Borders( 9 ):LineStyle  := 1
         oExcel:Cells( nRow, nCol ):Borders( 9 ):Weight     := -4138

      end if

   next

   /*
   Presentacion----------------------------------------------------------------
   */

   oSheet:Cells( 1, 1 ):Select()

   oExcel:ActiveWindow:SplitRow     := 1
   oExcel:ActiveWindow:FreezePanes  := .t.

   oExcel:ScreenUpdating            := .t.
   oExcel:Visible                   := .t.

   ShowWindow( oExcel:hWnd, 3 )

   BringWindowToTop( oExcel:hWnd )

RETURN ( Self )

//---------------------------------------------------------------------------//


METHOD nTotAlbPrv( cCodArt )

   local nTotal   := 0
   local nOrden   := ::oAlbPrvL:OrdSetFocus( "cRef" )

   if ::oAlbPrvL:Seek( cCodArt )

      while ::oAlbPrvL:cRef == cCodArt .and. !::oAlbPrvL:Eof()

         if ::oAlbPrvT:Seek( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb ) .AND.;
            !::oAlbPrvT:lFacturado                                                                 .AND.;
            ::oAlbPrvT:dFecAlb >= ::dIniInf                                                        .AND.;
            ::oAlbPrvT:dFecAlb <= ::dFinInf

            nTotal += nTotNAlbPrv( ::oAlbPrvL )

         end if

         ::oAlbPrvL:Skip()

      end while

   end if

   ::oAlbPrvL:OrdSetFocus( nOrden )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotFacPrv( cCodArt )

   local nTotal   := 0
   local nOrden   := ::oFacPrvL:OrdSetFocus( "cRef" )

   if ::oFacPrvL:Seek( cCodArt )

      while ::oFacPrvL:cRef == cCodArt .and. !::oFacPrvL:Eof()

         if ::oFacPrvT:Seek( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac ) .AND.;
            ::oFacPrvT:dFecFac >= ::dIniInf                                                        .AND.;
            ::oFacPrvT:dFecFac <= ::dFinInf

            nTotal += nTotNFacPrv( ::oFacPrvL )

         end if

         ::oFacPrvL:Skip()

      end while

   end if

   ::oFacPrvL:OrdSetFocus( nOrden )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotAlbCli( cCodArt )

   local nTotal   := 0
   local nOrden   := ::oAlbCliL:OrdSetFocus( "cRef" )

   if ::oAlbCliL:Seek( cCodArt )

      while ::oAlbCliL:cRef == cCodArt .and. !::oAlbCliL:Eof()

         if ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb ) .AND.;
            !lFacturado( ::oAlbCliT )                                                              .AND.;
            ::oAlbCliT:dFecAlb >= ::dIniInf                                                        .AND.;
            ::oAlbCliT:dFecAlb <= ::dFinInf

            nTotal += nTotNAlbCli( ::oAlbCliL )

         end if

         ::oAlbCliL:Skip()

      end while

   end if

   ::oAlbCliL:OrdSetFocus( nOrden )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotFacCli( cCodArt )

   local nTotal   := 0
   local nOrden   := ::oFacCliL:OrdSetFocus( "cRef" )

   if ::oFacCliL:Seek( cCodArt )

      while ::oFacCliL:cRef == cCodArt .and. !::oFacCliL:Eof()

         if ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac ) .AND.;
            ::oFacCliT:dFecFac >= ::dIniInf                                                       .AND.;
            ::oFacCliT:dFecFac <= ::dFinInf

            nTotal += nTotNFacCli( ::oFacCliL )

         end if

         ::oFacCliL:Skip()

      end while

   end if

   ::oFacCliL:OrdSetFocus( nOrden )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotTikCli( cCodArt )

   local nTotal   := 0
   local nOrden   := ::oTikCliL:OrdSetFocus( "cCbaTil" )

   if ::oTikCliL:Seek( cCodArt )
      while ::oTikCliL:cCbaTil == cCodArt .and. !::oTikCliL:Eof()

         if ::oTikCliT:Seek( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil ) .AND.;
            ::oTikCliT:dFecTik >= ::dIniInf                                                 .AND.;
            ::oTikCliT:dFecTik <= ::dFinInf

            nTotal += ::oTikCliL:nUntTil

         end if

         ::oTikCliL:Skip()

      end while

   end if

   ::oTikCliT:OrdSetFocus( "cComTil" )

   if ::oTikCliL:Seek( cCodArt )

      while ::oTikCliL:cComTil == cCodArt .and. !::oTikCliL:Eof()

         if ::oTikCliT:Seek( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil ) .AND.;
            ::oTikCliT:dFecTik >= ::dIniInf                                                 .AND.;
            ::oTikCliT:dFecTik <= ::dFinInf

            nTotal += ::oTikCliL:nUntTil

         end if

         ::oTikCliL:Skip()

      end while

   end if

   ::oTikCliL:OrdSetFocus( nOrden )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nStkTotal( cCodArt )

   local nStkTotal   := 0

   DEFAULT cCodArt   := ::oReport:aGroups[ 1 ]:cValue

   nStkTotal         += ::nTotAlbPrv( cCodArt )
   nStkTotal         += ::nTotFacPrv( cCodArt )

   nStkTotal         -= ::nTotAlbCli( cCodArt )
   nStkTotal         -= ::nTotFacCli( cCodArt )
   nStkTotal         -= ::nTotTikCli( cCodArt )

RETURN ( nStkTotal )

//---------------------------------------------------------------------------//

METHOD Play( uParam )

   ::Create( uParam )

   if ::lOpenFiles
      if ::lResource()
         ::Activate()
      end if
   end if

   ::End()

RETURN ( Self )

//---------------------------------------------------------------------------//

Method AddSelectedGroup()

   local oItemSelect := ::oTreeGroups:GetSelected()

   if oItemSelect != nil .and. oItemSelect:ClassName() == "TTVITEM"

      if aScan( ::aSelectedGroup, {|a| a:Cargo:Nombre == oItemSelect:cPrompt } ) == 0

         aAdd( ::aSelectedGroup, oItemSelect:Cargo )

         ::ReLoadGroup()

      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method DelSelectedGroup()

   local nPos
   local oItemSelect := ::oTreeSelectedGroups:GetSelected()

   if oItemSelect != nil .and. oItemSelect:ClassName() == "TTVITEM"

      nPos  := aScan( ::aSelectedGroup, {|a| a:Cargo:Nombre == oItemSelect:cPrompt } )
      if nPos != 0

         aDel( ::aSelectedGroup, nPos )
         aSize( ::aSelectedGroup, Len( ::aSelectedGroup ) - 1 )

         ::ReloadGroup()

      end if

   end if

   ::oTreeSelectedGroups:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

Method ReLoadGroup()

   local n
   local oTree

   ::oTreeSelectedGroups:DeleteAll()

   for n := 1 to len( ::aSelectedGroup )
      if Empty( oTree )
         oTree := ::oTreeSelectedGroups:Add( ::aSelectedGroup[ n ]:Cargo:Nombre, ::aSelectedGroup[ n ]:Cargo:Imagen, ::aSelectedGroup[ n ] )
      else
         oTree := oTree:Add( ::aSelectedGroup[ n ]:Cargo:Nombre, ::aSelectedGroup[ n ]:Cargo:Imagen, ::aSelectedGroup[ n ] )
      end if
   next

   ::oTreeSelectedGroups:ExpandAll()

Return ( Self )

//---------------------------------------------------------------------------//

Method UpSelectedGroup()

   local nPos
   local oItemSelect := ::oTreeSelectedGroups:GetSelected()

   if oItemSelect != nil .and. oItemSelect:ClassName() == "TTVITEM"

      nPos  := aScan( ::aSelectedGroup, {|a| a:Cargo:Nombre == oItemSelect:cPrompt } )
      if nPos != 0
         SwapUpArray( ::aSelectedGroup, nPos )
         ::ReLoadGroup()
      end if

   end if

   ::oTreeSelectedGroups:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

Method DownSelectedGroup()

   local nPos
   local oItemSelect := ::oTreeSelectedGroups:GetSelected()

   if oItemSelect != nil .and. oItemSelect:ClassName() == "TTVITEM"

      nPos  := aScan( ::aSelectedGroup, {|a| a:Cargo:Nombre == oItemSelect:cPrompt } )
      if nPos != 0
         SwapDwArray( ::aSelectedGroup, nPos )
         ::ReLoadGroup()
      end if

   end if

   ::oTreeSelectedGroups:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreaGrupos()

   local i
   local cExpIndex   := ""

   if ::lNewInforme
      ::aoGroup      := {}
   end if

   for i := 1 to len( ::aSelectedGroup )
      if i == len( ::aSelectedGroup )
         cExpIndex      += ::aSelectedGroup[ i ]:Cargo:Expresion
      else
         cExpIndex      += ::aSelectedGroup[ i ]:Cargo:Expresion + " + "
      end if
   next

   if !Empty( ::cPrefijoIndice )
      if !Empty( cExpIndex )
         cExpIndex      += " + " + ::cPrefijoIndice
      else
         cExpIndex      := ::cPrefijoIndice
      end if
   end if

   if Empty( cExpIndex ) .and. ::lNewInforme
      cExpIndex         := ::cEmptyIndex
   end if

   if !Empty( cExpIndex )
      ::oDbf:AddTmpIndex( "Grupos", ::cFileIndx, ( cExpIndex ), , , , , , , , , .t. )
   end if

   for i := 1 to len( ::aSelectedGroup )
      if IsTrue( ::aSelectedGroup[ i ]:Cargo:lImprimir )
         aAdd( ::aoGroup, ::aSelectedGroup[ i ] )
      end if
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD BtnDefectoGrupo()

   ::aSelectedGroup  := {}

   if !Empty( ::aInitGroup )
      aEval( ::aInitGroup, {| oGroup | aAdd( ::aSelectedGroup, oGroup ) } )
   end if

   ::ReLoadGroup()

   ::oTreeSelectedGroups:SetFocus()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lSeekInAcumulado( cExpresion )

   local i
   local cSeek          := ""

   DEFAULT cExpresion   := ""

   for i := 1 to len( ::aSelectedGroup )
      cSeek             += ::aSelectedGroup[ i ]:Cargo:Valor
   next

   cSeek                += cExpresion

Return ( ::oDbf:Seek( cSeek ) )

//---------------------------------------------------------------------------//

METHOD SetValorGrupo( cNombre, cValor )

   local nPos  := aScan( ::aSelectedGroup, { |a| a:Cargo:Nombre == cNombre } )

   if nPos != 0
      ::aSelectedGroup[ nPos ]:Cargo:Valor := cValor
   end if

Return( Self )

//---------------------------------------------------------------------------//

METHOD Reindexa( cPath )

   if Empty( ::oDbfInf )
      ::oDbfInf      := ::DefineConfigUser( cPath )
   end if
   ::oDbfInf:IdxFDel()
   ::oDbfInf:Activate( .f., .t., .f. )
   ::oDbfInf:Pack()
   ::oDbfInf:End()

   if Empty( ::oDbfFnt )
      ::oDbfFnt      := ::DefineFont( cPath )
   end if
   ::oDbfFnt:IdxFDel()
   ::oDbfFnt:Activate( .f., .t., .f. )
   ::oDbfFnt:Pack()
   ::oDbfFnt:End()

   if Empty( ::oDbfGrp )
      ::oDbfGrp      := ::DefineGroup( cPath )
   end if
   ::oDbfGrp:IdxFDel()
   ::oDbfGrp:Activate( .f., .t., .f. )
   ::oDbfGrp:Pack()
   ::oDbfGrp:End()

RETURN ( Self )

//--------------------------------------------------------------------------//

Method DefineConfigUser( cPath )

   DEFAULT cPath        := cPatEmp()

   DEFINE DATABASE ::oDbfInf FILE "CfgInf.Dbf" CLASS "InfCfg" PATH ( cPath ) VIA ( cDriver() ) COMMENT "Configuracion de usuarios"

      FIELD NAME "cCodUse" TYPE "C" LEN  3  DEC 0 COMMENT "Código usuario"          OF ::oDbfInf
      FIELD NAME "cNomInf" TYPE "C" LEN 100 DEC 0 COMMENT "Nombre del informe"      OF ::oDbfInf
      FIELD NAME "lSelInf" TYPE "L" LEN  1  DEC 0 COMMENT "Selección de columna"    OF ::oDbfInf
      FIELD NAME "cTitInf" TYPE "C" LEN 30  DEC 0 COMMENT "Titulo del informe"      OF ::oDbfInf
      FIELD NAME "nPosInf" TYPE "N" LEN 10  DEC 0 COMMENT "Posición de la columna"  OF ::oDbfInf
      FIELD NAME "nSizInf" TYPE "N" LEN 10  DEC 0 COMMENT "Tamaño de la columna"    OF ::oDbfInf
      FIELD NAME "lAlnInf" TYPE "L" LEN  1  DEC 0 COMMENT "Alineación columna"      OF ::oDbfInf
      FIELD NAME "lTotInf" TYPE "L" LEN  1  DEC 0 COMMENT "Columna totalizada"      OF ::oDbfInf
      FIELD NAME "lSomInf" TYPE "L" LEN  1  DEC 0 COMMENT "Columna sombreada"       OF ::oDbfInf
      FIELD NAME "lSepInf" TYPE "L" LEN  1  DEC 0 COMMENT "Separación del informe"  OF ::oDbfInf

      INDEX TO "CfgInf.Cdx" TAG "cCodUse" ON "cCodUse + cNomInf" NODELETED COMMENT "Código"   OF ::oDbfInf

   END DATABASE ::oDbfInf

Return ( ::oDbfInf )

//--------------------------------------------------------------------------//

Method DefineFont( cPath )

   DEFAULT cPath        := cPatEmp()

   DEFINE DATABASE ::oDbfFnt FILE "CfgFnt.Dbf" CLASS "FntCfg" PATH ( cPath ) VIA ( cDriver() )

      FIELD NAME "cCodUse" TYPE "C" LEN  3  DEC 0 COMMENT "Código usuario"          OF ::oDbfFnt
      FIELD NAME "cNomInf" TYPE "C" LEN 50  DEC 0 COMMENT "Nombre del informe"      OF ::oDbfFnt
      FIELD NAME "cFntIn1" TYPE "C" LEN 20  DEC 0 COMMENT "Nombre de la fuente 1"   OF ::oDbfFnt
      FIELD NAME "nSizIn1" TYPE "N" LEN  3  DEC 0 COMMENT "Tamaño del informe 1"    OF ::oDbfFnt
      FIELD NAME "cStyIn1" TYPE "C" LEN 20  DEC 0 COMMENT "Estilo del informe 1"    OF ::oDbfFnt
      FIELD NAME "cFntIn2" TYPE "C" LEN 20  DEC 0 COMMENT "Nombre de la fuente 2"   OF ::oDbfFnt
      FIELD NAME "nSizIn2" TYPE "N" LEN  3  DEC 0 COMMENT "Tamaño del informe 2"    OF ::oDbfFnt
      FIELD NAME "cStyIn2" TYPE "C" LEN 20  DEC 0 COMMENT "Estilo del informe 2"    OF ::oDbfFnt
      FIELD NAME "cFntIn3" TYPE "C" LEN 30  DEC 0 COMMENT "Nombre de la fuente 3"   OF ::oDbfFnt
      FIELD NAME "nSizIn3" TYPE "N" LEN  3  DEC 0 COMMENT "Tamaño del informe 3"    OF ::oDbfFnt
      FIELD NAME "cStyIn3" TYPE "C" LEN 30  DEC 0 COMMENT "Estilo del informe 3"    OF ::oDbfFnt
      FIELD NAME "lCelVie" TYPE "L" LEN  1  DEC 0 COMMENT "Visualizar en celdas"    OF ::oDbfFnt
      FIELD NAME "lShadow" TYPE "L" LEN  1  DEC 0 COMMENT "Visualizar con sombreado"OF ::oDbfFnt
      FIELD NAME "nWidPag" TYPE "N" LEN 16  DEC 6 COMMENT "Ancho de documento"      OF ::oDbfFnt
      FIELD NAME "nLenPag" TYPE "N" LEN 16  DEC 6 COMMENT "Longitud de decumento"   OF ::oDbfFnt
      FIELD NAME "cPrnInf" TYPE "C" LEN 100 DEC 0 COMMENT "Impresora"               OF ::oDbfFnt
      FIELD NAME "cImgInf" TYPE "C" LEN 250 DEC 0 COMMENT "Imagen"                  OF ::oDbfFnt
      FIELD NAME "nRowImg" TYPE "N" LEN  9  DEC 2 COMMENT "Fila de la imagen"       OF ::oDbfFnt
      FIELD NAME "nColImg" TYPE "N" LEN  9  DEC 2 COMMENT "Columna de la imagen"    OF ::oDbfFnt
      FIELD NAME "nWidImg" TYPE "N" LEN  9  DEC 2 COMMENT "Ancho de la imagen"      OF ::oDbfFnt
      FIELD NAME "nHeiImg" TYPE "N" LEN  9  DEC 2 COMMENT "Alto de la imagen"       OF ::oDbfFnt
      FIELD NAME "nDisInf" TYPE "N" LEN  1  DEC 0 COMMENT "Dispositivo de salida"   OF ::oDbfFnt
      FIELD NAME "nOrnInf" TYPE "N" LEN  1  DEC 0 COMMENT "Orientación del informe" OF ::oDbfFnt
      FIELD NAME "cAliInf" TYPE "C" LEN 100 DEC 0 COMMENT "Alias del informe"       OF ::oDbfFnt

      INDEX TO "CfgFnt.Cdx" TAG "cCodUse" ON "cCodUse + cNomInf" NODELETED COMMENT "Código" OF ::oDbfFnt

   END DATABASE ::oDbfFnt

Return ( ::oDbfFnt )

//--------------------------------------------------------------------------//

Method DefineGroup( cPath )

   DEFAULT cPath        := cPatEmp()

   DEFINE DATABASE ::oDbfGrp FILE "CfgGrp.Dbf" CLASS "GrpCfg" PATH ( cPath ) VIA ( cDriver() )

      FIELD NAME "cCodUse" TYPE "C" LEN  3  DEC 0 COMMENT "Código usuario"          OF ::oDbfGrp
      FIELD NAME "cNomInf" TYPE "C" LEN 100 DEC 0 COMMENT "Nombre del informe"      OF ::oDbfGrp
      FIELD NAME "cNomGrp" TYPE "C" LEN 50  DEC 0 COMMENT "Nombre del grupo"        OF ::oDbfGrp

      INDEX TO "CfgGrp.Cdx" TAG "cCodUse" ON "cCodUse + cNomInf" NODELETED COMMENT "Código" OF ::oDbfGrp

   END DATABASE ::oDbfGrp

Return ( ::oDbfGrp )

//--------------------------------------------------------------------------//

Function clp2xlnumpic( cPic )

   local cFormat, aPic, c, lEnglish := lxlEnglish

   if cPic == nil
      cFormat  := If( lThouSep, If( lEnglish, "#,##0", "#.##0" ), "0" )
   else
      cPic     := StrTran( cPic, "#", "9" )
      aPic     := HB_ATokens( cPic, " " )

      cFormat  := ""
      for each c in aPic
         if Left( c, 1 ) == "@"
/*
            if 'E' $ c
               lEnglish := .f.
            endif
*/
         else
            if "9" $ c
               if Left( c, 1 ) == '$'
                  cFormat  += '$'
               endif
               cFormat  += If( lThouSep .or. ",9" $ cPic, If( lEnglish, "#,##0", "#.##0" ), "0" )
               if ".9" $ c
                  cFormat  += If( lEnglish, ".", "," )
                  cFormat  += StrTran( SubStr( c, At( ".", c ) + 1 ), "9", "0" )

               endif
               cFormat  += " "
            else
               cFormat  += ( '"' + c + '" ' )
            endif
         endif
      next
   endif

return Trim( cFormat )

//------------------------------------------------------------------//

Function oTInfGen( cMsg, u1, u2, u3, u4, u5, u6, u7, u8, u9, u10 )

   local uReturn  := ""

   if !Empty( oThis ) .and. !Empty( cMsg )
      uReturn     := apoloSender( oThis, cMsg, u1, u2, u3, u4, u5, u6, u7, u8, u9, u10 )
   end if

Return ( uReturn )

//--------------------------------------------------------------------------//

