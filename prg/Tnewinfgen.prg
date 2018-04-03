#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"
#include "FastRepH.ch"

memvar dFechaInicio
memvar dFechaFin
memvar cGrupoFabricanteDesde
memvar cGrupoFabricanteHasta
memvar cGrupoArticuloDesde
memvar cGrupoArticuloHasta
memvar cGrupoMateriaPrimaDesde
memvar cGrupoMateriaPrimaHasta
memvar cGrupoClienteDesde
memvar cGrupoClienteHasta
memvar cGrupoRutaDesde
memvar cGrupoRutaHasta
memvar cGrupoAgenteDesde
memvar cGrupoAgenteHasta
memvar cGrupoProveedorDesde
memvar cGrupoProveedorHasta
memvar cGrupoTemporadaDesde
memvar cGrupoTemporadaHasta
memvar cGrupoCategoriaDesde
memvar cGrupoCategoriaHasta
memvar cGrupoEstadoArticuloDesde
memvar cGrupoEstadoArticuloHasta
memvar cGrupoFamiliaDesde
memvar cGrupoFamiliaHasta
memvar cGrupoTArticuloDesde
memvar cGrupoTArticuloHasta
memvar cGrupoAlmacenDesde
memvar cGrupoAlmacenHasta
memvar cGrupoCentroCosteDesde
memvar cGrupoCentroCosteHasta
memvar cGrupoGClienteDesde      
memvar cGrupoGClienteHasta      
memvar cGrupoGClienteNombreDesde
memvar cGrupoGClienteNombreHasta
memvar cGrupoArticuloNombreDesde
memvar cGrupoArticuloNombreHasta
memvar cGrupoClienteNombreDesde
memvar cGrupoClienteNombreHasta
memvar cGrupoTransportistaDesde
memvar cGrupoTransportistaHasta
memvar cGrupoTransportistaNombreDesde
memvar cGrupoTransportistaNombreHasta

//---------------------------------------------------------------------------//

CLASS TNewInfGen FROM TInfGen

   DATA lDefEstadoUno      INIT .f.
   DATA oEstadoUno
   DATA cEstadoUno         INIT ""
   DATA aEstadoUno         INIT {}

   DATA lDefEstadoDos      INIT .f.
   DATA oEstadoDos
   DATA cEstadoDos         INIT ""
   DATA aEstadoDos         INIT {}

   DATA lDefCondiciones    INIT .t.
   DATA oGrupoCondiciones
   DATA oTreeCondiciones

   DATA oTreeRango
   DATA oImageList

   DATA oDesde
   DATA cDesde             INIT ""
   DATA oSayDesde
   DATA cSayDesde          INIT ""

   DATA oHasta
   DATA cHasta             INIT ""
   DATA oSayHasta
   DATA cSayHasta          INIT ""

   DATA oTodos
   DATA lTodos             INIT .t.

   DATA oDesglosar
   DATA lDesglosar         INIT .f.
   DATA oLinImporteCero
   DATA lLinImporteCero    INIT .f.
   DATA oDocImporteCero
   DATA lDocImporteCero    INIT .f.

   DATA oTipOpera

   DATA oGrupoArticulo
   DATA oGrupoMateriaPrima
   DATA oGrupoCliente
   DATA oGrupoProveedor
   DATA oGrupoOperacion
   DATA oGrupoSeccion
   DATA oGrupoAlmacen
   DATA oGrupoAlmacenOrigen
   DATA oGrupoMaquina
   DATA oGrupoOperario
   DATA oGrupoFpago
   DATA oGrupoBanco
   DATA oGrupoAgente
   DATA oGrupoUsuario
   DATA oGrupoCaja
   DATA oGrupoCategoria
   DATA oGrupoTransportista
   DATA oGrupoGCliente
   DATA oGrupoGProveedor
   DATA oGrupoObra
   DATA oGrupoFamilia
   DATA oGrupoGFamilia
   DATA oGrupoTArticulo
   DATA oGrupoFabricante
   DATA oGrupoTOperacion
   DATA oGrupoEstadoArticulo
   DATA oGrupoRuta
   DATA oGrupoFacturas
   DATA oGrupoFacturasCompras
   DATA oGrupoTemporada
   DATA oGrupoIVA
   DATA oGrupoSerie
   DATA oGrupoNumero
   DATA oGrupoSufijo
   DATA oGrupoRemesas

   DATA oTipoExpediente
   DATA oGrupoTipoExpediente

   DATA oEntidad
   DATA oGrupoEntidad

   DATA oColaborador
   DATA oGrupoColaborador

   DATA oCuentasBancarias
   DATA oGrupoCuentasBancarias

   DATA oColNombre

   DATA oFastReport

   DATA oPeriodo
   DATA cPeriodo           INIT "Mes en curso"
   DATA aPeriodo           INIT {}

   DATA oFacCliT
   DATA oFacPrvT
   DATA oFacPrvP

   DATA  oHoraInicio
   DATA  cHoraInicio
   DATA  oHoraFin
   DATA  cHoraFin

   DATA  oDbfCentroCoste
   DATA  oGrupoCentroCoste

   METHOD NewResource()

   METHOD lGrupoArticulo( lInitGroup, lImp )

   METHOD lGrupoMateriaPrima( lInitGroup, lImp )

   METHOD lGrupoCliente( lInitGroup, lImp )

   METHOD lGrupoOperacion( lInitGroup, lImp )

   METHOD lGrupoSeccion( lInitGroup, lImp )

   METHOD lGrupoAlmacen( lInitGroup, lImp )

   METHOD lGrupoAlmacenOrigen( lInitGroup, lImp )

   METHOD lGrupoMaquina( lInitGroup, lImp )

   METHOD lGrupoOperario( lInitGroup, lImp )

   METHOD lGrupoFPago( lInitGroup, lImp )

   METHOD lGrupoBanco( lInitGroup, lImp )

   METHOD lGrupoAgente( lInitGroup, lImp )

   METHOD lGrupoUsuario( lInitGroup, lImp )

   METHOD lGrupoCaja( lInitGroup, lImp )

   METHOD lGrupoTransportista( lInitGroup, lImp )

   METHOD lGrupoGrupoCliente( lInitGroup, lImp )

   METHOD lGrupoGProveedor( lInitGroup, lImp )

   METHOD lGrupoObra( lInitGroup, lImp )

   METHOD lGrupoFamilia( lInitGroup, lImp )

   METHOD lGrupoGFamilia( lInitGroup, lImp )

   METHOD lGrupoCentroCoste( lInitGroup, lImp )

   METHOD lGrupoTipoArticulo( lInitGroup, lImp )

   METHOD lGrupoFabricante( lInitGroup, lImp )

   METHOD lGrupoTOperacion( lInitGroup, lImp )

   METHOD lGrupoProveedor( lInitGroup, lImp )

   METHOD lGrupoTipoExpediente( lInitGroup, lImp )

   METHOD lGrupoEntidad( lInitGroup, lImp )

   METHOD lGrupoColaborador( lInitGroup, lImp )

   METHOD lGrupoEstadoArticulo( lInitGroup, lImp )

   METHOD lGrupoRuta( lInitGroup, lImp )

   METHOD lGrupoFacturas( lInitGroup, lImp )

   METHOD lGrupoFacturasCompras( lInitGroup, lImp )

   METHOD lGrupoTemporada( lInitGroup, lImp )

   METHOD lGrupoCategoria( lInitGroup, lImp )

   METHOD lGrupoIva( lInitGroup, lImp )

   METHOD lGrupoEntidadesBancarias( lInitGroup, lImp )

   METHOD lGrupoSerie( lInitGroup, lImp )

   METHOD lGrupoNumero( lInitGroup, lImp )

   METHOD lGrupoSufijo( lInitGroup, lImp )

   METHOD lGrupoRemesas( lInitGroup, lImp )

   METHOD oDefEstados( nIdEstadoUno, nIdEstadoDos )

   METHOD oDefDesde( nIdDesde, nIdSayDesde )

   METHOD oDefHasta( nIdHasta, nIdSayHasta )

   METHOD oDefTodos( nIdTodos )

   METHOD HideCondiciones()

   METHOD ChangeRango()

   METHOD ChangeValor()

   METHOD SetValor()

   METHOD InitDialog()

   METHOD oDefDesglosar()

   METHOD oDefLinImporteCero()

   METHOD oDefDocImporteCero()

   METHOD lIgualCliente()

   METHOD lPeriodoInforme( nId, oDlg )

   METHOD lRecargaFecha()
   METHOD lHideFecha()
   METHOD lShowFecha()

   METHOD lCreaArrayPeriodos()

   METHOD FastReport()  VIRTUAL

   METHOD DataReport()  VIRTUAL

   METHOD oDefHoraInicio( nId, oDlg )

   METHOD oDefHoraFin( nId, oDlg )

   METHOD AddVariable()

   METHOD SaveReport()

   METHOD MoveReport()

   METHOD End()

   METHOD SetNombreDesdeGrupoCliente()
   METHOD SetNombreHastaGrupoCliente()

   METHOD SetNombreDesdeCliente()
   METHOD SetNombreHastaCliente()

   METHOD SetNombreDesdeArticulo()
   METHOD SetNombreHastaArticulo()

   METHOD SetNombreDesdeTransportista()
   METHOD SetNombreHastaTransportista()

END CLASS

//----------------------------------------------------------------------------//

METHOD NewResource( cFldRes ) CLASS TNewInfGen

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

   DEFAULT cFldRes   := "INF_GEN_01"

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
   Montamos el array con los periodos para los informes------------------------
   */

   ::lCreaArrayPeriodos()

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
   Creo las listas de imagenes para los trees nuevos---------------------------
   */

   ::oImageList            := TImageList():New( 16, 16 )
   ::oImageGroup           := TImageList():New( 16, 16 )

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
      ::lPeriodoInforme()
   end if

   /*
   ComboBox Estado-------------------------------------------------------------
   */

   ::oDefEstados()

   /*
   Tree de los rangos----------------------------------------------------------
   */

   ::oTreeRango                     := TTreeView():Redefine( 100, ::oFld:aDialogs[ 1 ] )
   ::oTreeRango:bChanged            := {|| ::ChangeRango() }
   ::oTreeRango:bLostFocus          := {|| ::ChangeValor() }

   /*
   Todos, Desde, Hasta y toman valores-----------------------------------------
   */

   ::oDefTodos()
   ::oDefDesde()
   ::oDefHasta()

   /*
   Definimos el tree de condiciones--------------------------------------------
   */

   REDEFINE GROUP ::oGrupoCondiciones ID 131 OF ::oFld:aDialogs[ 1 ] TRANSPARENT

   ::oTreeCondiciones               := TTreeView():Redefine( 130, ::oFld:aDialogs[1] )

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

METHOD lGrupoArticulo( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lImp         := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ::oDbfArt == nil .or. !::oDbfArt:Used()
      DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"
   end if

   ::oGrupoArticulo                    := TRGroup():New( {|| ::oDbf:cCodArt }, {|| "Artículo : " + AllTrim( ::oDbf:cCodArt ) + " - " + AllTRim( ::oDbf:cNomArt ) }, {|| "Total artículo..." }, {|| 3 }, ::lSalto )

   ::oGrupoArticulo:Cargo              := TItemGroup()
   ::oGrupoArticulo:Cargo:Nombre       := "Artículo"
   ::oGrupoArticulo:Cargo:Expresion    := "cCodArt"
   ::oGrupoArticulo:Cargo:Todos        := .t.
   ::oGrupoArticulo:Cargo:Desde        := Space( 18 )          // dbFirst( ::oDbfArt, 1 )
   ::oGrupoArticulo:Cargo:Hasta        := Replicate( "Z", 18 ) // dbLast( ::oDbfArt, 1 )
   ::oGrupoArticulo:Cargo:cPicDesde    := Replicate( "#", 18 )
   ::oGrupoArticulo:Cargo:cPicHasta    := Replicate( "#", 18 )
   ::oGrupoArticulo:Cargo:TextDesde    := {|| ::SetNombreDesdeArticulo() }
   ::oGrupoArticulo:Cargo:TextHasta    := {|| ::SetNombreHastaArticulo() }
   ::oGrupoArticulo:Cargo:HelpDesde    := {|| BrwArticulo( ::oDesde, ::oSayDesde, , .f. ) }
   ::oGrupoArticulo:Cargo:HelpHasta    := {|| BrwArticulo( ::oHasta, ::oSayHasta, , .f. ) }
   ::oGrupoArticulo:Cargo:ValidDesde   := {|oGet| if( cArticulo( if( !empty( oGet ), oGet, ::oDesde ), ::oDbfArt:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoArticulo:Cargo:ValidHasta   := {|oGet| if( cArticulo( if( !empty( oGet ), oGet, ::oHasta ), ::oDbfArt:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoArticulo:Cargo:lImprimir    := lImp
   ::oGrupoArticulo:Cargo:cBitmap      := "gc_object_cube_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_object_cube_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoArticulo )

      if !Empty( ::oImageGroup )

         ::oImageGroup:AddMasked( TBitmap():Define( "gc_object_cube_16" ), Rgb( 255, 0, 255 ) )

         ::oGrupoArticulo:Cargo:Imagen := len( ::oImageGroup:aBitmaps ) - 1

      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoArticulo:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoArticulo )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoArticulo )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfArt )
         ::oDbfArt:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoMateriaPrima( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lImp         := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ::oDbfArticuloMateriaPrima == nil .or. !::oDbfArticuloMateriaPrima:Used()
      DATABASE NEW ::oDbfArticuloMateriaPrima PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"
   end if

   ::oGrupoMateriaPrima                    := TRGroup():New( {|| ::oDbf:cCodArt }, {|| "Materia prima : " + AllTrim( ::oDbf:cCodArt ) + " - " + AllTRim( ::oDbf:cNomArt ) }, {|| "Total artículo..." }, {|| 3 }, ::lSalto )

   ::oGrupoMateriaPrima:Cargo              := TItemGroup()
   ::oGrupoMateriaPrima:Cargo:Nombre       := "Materia prima"
   ::oGrupoMateriaPrima:Cargo:Expresion    := "cCodArt"
   ::oGrupoMateriaPrima:Cargo:Todos        := .t.
   ::oGrupoMateriaPrima:Cargo:Desde        := Space( 18 )          // dbFirst( ::oDbfArticuloMateriaPrima, 1 )
   ::oGrupoMateriaPrima:Cargo:Hasta        := Replicate( "Z", 18 ) // dbLast( ::oDbfArticuloMateriaPrima, 1 )
   ::oGrupoMateriaPrima:Cargo:cPicDesde    := Replicate( "#", 18 )
   ::oGrupoMateriaPrima:Cargo:cPicHasta    := Replicate( "#", 18 )
   ::oGrupoMateriaPrima:Cargo:TextDesde    := {|| oRetFld( ::oGrupoMateriaPrima:Cargo:Desde, ::oDbfArticuloMateriaPrima, "Nombre", "Codigo" ) }
   ::oGrupoMateriaPrima:Cargo:TextHasta    := {|| oRetFld( ::oGrupoMateriaPrima:Cargo:Hasta, ::oDbfArticuloMateriaPrima, "Nombre", "Codigo" ) }
   ::oGrupoMateriaPrima:Cargo:HelpDesde    := {|| BrwArticulo( ::oDesde, ::oSayDesde, , .f. ) }
   ::oGrupoMateriaPrima:Cargo:HelpHasta    := {|| BrwArticulo( ::oHasta, ::oSayHasta, , .f. ) }
   ::oGrupoMateriaPrima:Cargo:ValidDesde   := {|oGet| if( cArticulo( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfArticuloMateriaPrima:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoMateriaPrima:Cargo:ValidHasta   := {|oGet| if( cArticulo( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfArticuloMateriaPrima:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoMateriaPrima:Cargo:lImprimir    := lImp
   ::oGrupoMateriaPrima:Cargo:cBitmap      := "gc_object_cube_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_object_cube_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoMateriaPrima )

      if !Empty( ::oImageGroup )

         ::oImageGroup:AddMasked( TBitmap():Define( "gc_object_cube_16" ), Rgb( 255, 0, 255 ) )

         ::oGrupoMateriaPrima:Cargo:Imagen := len( ::oImageGroup:aBitmaps ) - 1

      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoMateriaPrima:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoMateriaPrima )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoMateriaPrima )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfArticuloMateriaPrima )
         ::oDbfArticuloMateriaPrima:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoCliente( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfCli == nil .or. !::oDbfCli:Used()
      DATABASE NEW ::oDbfCli PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"
   end if

   ::oGrupoCliente                  := TRGroup():New( {|| ::oDbf:cCodCli }, {|| "Cliente : " + AllTrim( ::oDbf:cCodCli ) + " - " + AllTRim( ::oDbf:cNomCli ) }, {|| "Total cliente : " + ::oDbf:cCodCli }, {|| 3 }, ::lSalto )

   ::oGrupoCliente:Cargo            := TItemGroup()
   ::oGrupoCliente:Cargo:Nombre     := "Cliente"
   ::oGrupoCliente:Cargo:Expresion  := "cCodCli"
   ::oGrupoCliente:Cargo:Todos      := .t.
   ::oGrupoCliente:Cargo:Desde      := Space( RetNumCodCliEmp() )          // dbFirst( ::oDbfCli, 1 )
   ::oGrupoCliente:Cargo:Hasta      := Replicate( "Z", RetNumCodCliEmp() ) // dbLast( ::oDbfCli, 1 )
   ::oGrupoCliente:Cargo:cPicDesde  := Replicate( "X", RetNumCodCliEmp() )
   ::oGrupoCliente:Cargo:cPicHasta  := Replicate( "X", RetNumCodCliEmp() )
   ::oGrupoCliente:Cargo:HelpDesde  := {|| BrwCli( ::oDesde, ::oSayDesde, ::oDbfCli:cAlias ) }
   ::oGrupoCliente:Cargo:HelpHasta  := {|| BrwCli( ::oHasta, ::oSayHasta, ::oDbfCli:cAlias ) }
   ::oGrupoCliente:Cargo:TextDesde  := {|| ::SetNombreDesdeCliente() }
   ::oGrupoCliente:Cargo:TextHasta  := {|| ::SetNombreHastaCliente() }
   ::oGrupoCliente:Cargo:ValidDesde := {|oGet| if( cClient( if( !Empty( oGet ), oGet, ::oDesde ), , ::oDbfCli:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoCliente:Cargo:ValidHasta := {|oGet| if( cClient( if( !Empty( oGet ), oGet, ::oHasta ), , ::oDbfCli:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoCliente:Cargo:lImprimir  := lImp
   ::oGrupoCliente:Cargo:cBitmap    := "gc_user_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoCliente:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoCliente )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoCliente:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoCliente:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoCliente:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoCliente )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoCliente )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfCli )
         ::oDbfCli:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoProveedor( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfPrv == nil .or. !::oDbfPrv:Used()
      DATABASE NEW ::oDbfPrv PATH ( cPatEmp() ) FILE "PROVEE.DBF" VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"
   end if

   ::oGrupoProveedor                  := TRGroup():New( {|| ::oDbf:cCodPrv }, {|| "Proveedor : " + AllTrim( ::oDbf:cCodPrv ) + " - " + AllTRim( ::oDbf:cNomPrv ) }, {|| "Total proveedor..." }, {|| 3 }, ::lSalto )

   ::oGrupoProveedor:Cargo            := TItemGroup()
   ::oGrupoProveedor:Cargo:Nombre     := "Proveedor"
   ::oGrupoProveedor:Cargo:Expresion  := "cCodPrv"
   ::oGrupoProveedor:Cargo:Todos      := .t.
   ::oGrupoProveedor:Cargo:Desde      := Space( RetNumCodPrvEmp() )           // dbFirst( ::oDbfPrv, 1 )
   ::oGrupoProveedor:Cargo:Hasta      := Replicate( "Z", RetNumCodPrvEmp() )  // dbLast( ::oDbfPrv, 1 )
   ::oGrupoProveedor:Cargo:cPicDesde  := Replicate( "X", RetNumCodPrvEmp() )
   ::oGrupoProveedor:Cargo:cPicHasta  := Replicate( "X", RetNumCodPrvEmp() )
   ::oGrupoProveedor:Cargo:TextDesde  := {|| oRetFld( ::oGrupoProveedor:Cargo:Desde, ::oDbfPrv, "Titulo", "Cod" ) }
   ::oGrupoProveedor:Cargo:TextHasta  := {|| oRetFld( ::oGrupoProveedor:Cargo:Hasta, ::oDbfPrv, "Titulo", "Cod" ) }
   ::oGrupoProveedor:Cargo:HelpDesde  := {|| BrwPrv( ::oDesde, , ::oDbfPrv:cAlias ) }
   ::oGrupoProveedor:Cargo:HelpHasta  := {|| BrwPrv( ::oHasta, , ::oDbfPrv:cAlias) }
   ::oGrupoProveedor:Cargo:ValidDesde := {|oGet| if( cProvee( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfPrv:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoProveedor:Cargo:ValidHasta := {|oGet| if( cProvee( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfPrv:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoProveedor:Cargo:lImprimir  := lImp
   ::oGrupoProveedor:Cargo:cBitmap     := "gc_businessman_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoProveedor:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoProveedor )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoProveedor:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoProveedor:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoProveedor:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoProveedor )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoProveedor )

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

METHOD lGrupoOperacion( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oOperacion         :=  TOperacion():CreateInit( cPatEmp() )
   ::oOperacion:Openfiles()

   ::oGrupoOperacion                  := TRGroup():New( {|| ::oDbf:cCodOpe }, {|| "Operación : " + AllTrim( ::oDbf:cCodOpe ) + " - " + AllTRim( ::oDbf:cNomOpe ) }, {|| "Total operación..." }, {|| 3 }, ::lSalto )

   ::oGrupoOperacion:Cargo            := TItemGroup()
   ::oGrupoOperacion:Cargo:Nombre     := "Operación"
   ::oGrupoOperacion:Cargo:Expresion  := "cCodOpe"
   ::oGrupoOperacion:Cargo:Todos      := .t.
   ::oGrupoOperacion:Cargo:Desde      := Space( 3 )            // dbFirst( ::oOperacion:oDbf, 1 )
   ::oGrupoOperacion:Cargo:Hasta      := Replicate( "Z", 3 )   // dbLast( ::oOperacion:oDbf, 1 )
   ::oGrupoOperacion:Cargo:cPicDesde  := "@!"
   ::oGrupoOperacion:Cargo:cPicHasta  := "@!"
   ::oGrupoOperacion:Cargo:TextDesde  := {|| oRetFld( ::oGrupoOperacion:Cargo:Desde, ::oOperacion:oDbf, "cDesOpe", "cCodOpe" ) }
   ::oGrupoOperacion:Cargo:TextHasta  := {|| oRetFld( ::oGrupoOperacion:Cargo:Hasta, ::oOperacion:oDbf, "cDesOpe", "cCodOpe" ) }
   ::oGrupoOperacion:Cargo:HelpDesde  := {|| ::oOperacion:Buscar( ::oDesde ) }
   ::oGrupoOperacion:Cargo:HelpHasta  := {|| ::oOperacion:Buscar( ::oHasta ) }
   ::oGrupoOperacion:Cargo:ValidDesde := {|oGet| if( ::oOperacion:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cDesOpe", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoOperacion:Cargo:ValidHasta := {|oGet| if( ::oOperacion:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cDesOpe", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoOperacion:Cargo:lImprimir  := lImp
   ::oGrupoOperacion:Cargo:cBitmap     := "gc_worker2_hammer_16"


   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_worker2_hammer_16" ), Rgb( 255, 0, 255 ) )
   end if   

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoOperacion )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_worker2_hammer_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoOperacion:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoOperacion:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoOperacion )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoOperacion )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oOperacion )
         ::oOperacion:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoTOperacion( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oTipOpera                         := TTipOpera():Create( cPatEmp() )
   ::oTipOpera:Openfiles()

   ::oGrupoTOperacion                  := TRGroup():New( {|| ::oDbf:cCodTOpe }, {|| "Tip. operación: " + AllTrim( ::oDbf:cCodTOpe ) + " - " + AllTRim( ::oDbf:cNomTOpe ) }, {|| "Total tip. operación: " + AllTrim( ::oDbf:cCodTOpe ) }, {|| 3 }, ::lSalto )

   ::oGrupoTOperacion:Cargo            := TItemGroup()
   ::oGrupoTOperacion:Cargo:Nombre     := "Tipo operación"
   ::oGrupoTOperacion:Cargo:Expresion  := "cCodTOpe"
   ::oGrupoTOperacion:Cargo:Todos      := .t.
   ::oGrupoTOperacion:Cargo:Desde      := Space( 3 )           // dbFirst( ::oTipOpera:oDbf, 1 )
   ::oGrupoTOperacion:Cargo:Hasta      := Replicate( "Z", 3 )  // dbLast( ::oTipOpera:oDbf, 1 )
   ::oGrupoTOperacion:Cargo:cPicDesde  := "@!"
   ::oGrupoTOperacion:Cargo:cPicHasta  := "@!"
   ::oGrupoTOperacion:Cargo:TextDesde  := {|| oRetFld( ::oGrupoTOperacion:Cargo:Desde, ::oTipOpera:oDbf, "cDesTip", "cCodTip" ) }
   ::oGrupoTOperacion:Cargo:TextHasta  := {|| oRetFld( ::oGrupoTOperacion:Cargo:Hasta, ::oTipOpera:oDbf, "cDesTip", "cCodTip" ) }
   ::oGrupoTOperacion:Cargo:HelpDesde  := {|| ::oTipOpera:Buscar( ::oDesde ) }
   ::oGrupoTOperacion:Cargo:HelpHasta  := {|| ::oTipOpera:Buscar( ::oHasta ) }
   ::oGrupoTOperacion:Cargo:ValidDesde := {|oGet| if( ::oTipOpera:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cDesTip", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoTOperacion:Cargo:ValidHasta := {|oGet| if( ::oTipOpera:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cDesTip", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoTOperacion:Cargo:lImprimir  := lImp
   ::oGrupoTOperacion:Cargo:cBitmap    := "gc_folder_open_worker_16" 

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_folder_open_worker_16" ), Rgb( 255, 0, 255 ) )
   end if   

   if lInitGroup != nil


      aAdd( ::aSelectionGroup, ::oGrupoTOperacion )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_folder_open_worker_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoTOperacion:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) - 1
      end if   

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoTOperacion:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoTOperacion )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoTOperacion )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oTipOpera )
         ::oTipOpera:End()
      end if

      lOpen                            := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoSeccion( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oSeccion                       := TSeccion():Create( cPatEmp() )
   ::oSeccion:Openfiles()

   ::oGrupoSeccion                  := TRGroup():New( {|| ::oDbf:cCodSec }, {|| "Sección : " + ::oDbf:cCodSec + " - " + ::oDbf:cNomSec }, {|| "Total sección : " + ::oDbf:cCodSec }, {|| 3 }, ::lSalto )

   ::oGrupoSeccion:Cargo            := TItemGroup()
   ::oGrupoSeccion:Cargo:Nombre     := "Sección"
   ::oGrupoSeccion:Cargo:Expresion  := "cCodSec"
   ::oGrupoSeccion:Cargo:Todos      := .t.
   ::oGrupoSeccion:Cargo:Desde      := Space( 3 )           // dbFirst( ::oSeccion:oDbf, 1 )
   ::oGrupoSeccion:Cargo:Hasta      := Replicate( "Z", 3 )  // dbLast( ::oSeccion:oDbf, 1 )
   ::oGrupoSeccion:Cargo:cPicDesde  := "@!"
   ::oGrupoSeccion:Cargo:cPicHasta  := "@!"
   ::oGrupoSeccion:Cargo:TextDesde  := {|| oRetFld( ::oGrupoSeccion:Cargo:Desde, ::oSeccion:oDbf, "cDesSec", "cCodSec" ) }
   ::oGrupoSeccion:Cargo:TextHasta  := {|| oRetFld( ::oGrupoSeccion:Cargo:Hasta, ::oSeccion:oDbf, "cDesSec", "cCodSec" ) }
   ::oGrupoSeccion:Cargo:HelpDesde  := {|| ::oSeccion:Buscar( ::oDesde ) }
   ::oGrupoSeccion:Cargo:HelpHasta  := {|| ::oSeccion:Buscar( ::oHasta ) }
   ::oGrupoSeccion:Cargo:ValidDesde := {|oGet| if( ::oSeccion:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cDesSec", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoSeccion:Cargo:ValidHasta := {|oGet| if( ::oSeccion:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cDesSec", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoSeccion:Cargo:lImprimir  := lImp
   ::oGrupoSeccion:Cargo:cBitmap    := "gc_worker_group_16"


   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_worker_group_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoSeccion )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_worker_group_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoSeccion:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if   

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoSeccion:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoSeccion )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoSeccion )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oSeccion )
         ::oSeccion:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoAlmacen( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfAlm == nil .or. !::oDbfAlm:Used()
      DATABASE NEW ::oDbfAlm PATH ( cPatEmp() ) FILE "ALMACEN.DBF" VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"
   end if

   ::oGrupoAlmacen                  := TRGroup():New( {|| ::oDbf:cCodAlm }, {|| "Almacén : " + AllTrim( ::oDbf:cCodAlm ) + " - " + AllTrim( ::oDbf:cNomAlm ) }, {|| "Total almacén : " + ::oDbf:cCodAlm }, {|| 3 }, ::lSalto )

   ::oGrupoAlmacen:Cargo            := TItemGroup()
   ::oGrupoAlmacen:Cargo:Nombre     := "Almacén"
   ::oGrupoAlmacen:Cargo:Expresion  := "cCodAlm"
   ::oGrupoAlmacen:Cargo:Todos      := .t.
   ::oGrupoAlmacen:Cargo:Desde      := Space( 16 )           // dbFirst( ::oDbfAlm, 1 )
   ::oGrupoAlmacen:Cargo:Hasta      := Replicate( "Z", 16 )  // dbLast( ::oDbfAlm, 1 )
   ::oGrupoAlmacen:Cargo:cPicDesde  := Replicate( "#", 16 )
   ::oGrupoAlmacen:Cargo:cPicHasta  := Replicate( "#", 16 )
   ::oGrupoAlmacen:Cargo:TextDesde  := {|| oRetFld( ::oGrupoAlmacen:Cargo:Desde, ::oDbfAlm, "cNomAlm", "cCodAlm" ) }
   ::oGrupoAlmacen:Cargo:TextHasta  := {|| oRetFld( ::oGrupoAlmacen:Cargo:Hasta, ::oDbfAlm, "cNomAlm", "cCodAlm" ) }
   ::oGrupoAlmacen:Cargo:HelpDesde  := {|| BrwAlmacen( ::oDesde, ::oSayDesde ) }
   ::oGrupoAlmacen:Cargo:HelpHasta  := {|| BrwAlmacen( ::oHasta, ::oSayHasta ) }
   ::oGrupoAlmacen:Cargo:ValidDesde := {|oGet| if( cAlmacen( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfAlm:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoAlmacen:Cargo:ValidHasta := {|oGet| if( cAlmacen( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfAlm:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoAlmacen:Cargo:lImprimir  := lImp
   ::oGrupoAlmacen:Cargo:cBitmap    := "gc_package_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_package_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoAlmacen )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_package_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoAlmacen:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoAlmacen:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoAlmacen )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoAlmacen )

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

METHOD lGrupoAlmacenOrigen( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfAlmacenOrigen == nil .or. !::oDbfAlmacenOrigen:Used()
      DATABASE NEW ::oDbfAlmacenOrigen PATH ( cPatEmp() ) FILE "ALMACEN.DBF" VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"
   end if

   ::oGrupoAlmacenOrigen                  := TRGroup():New( {|| ::oDbf:cCodAlm }, {|| "Almacén origen: " + AllTrim( ::oDbf:cCodAlm ) + " - " + AllTrim( ::oDbf:cNomAlm ) }, {|| "Total almacén : " + ::oDbf:cCodAlm }, {|| 3 }, ::lSalto )

   ::oGrupoAlmacenOrigen:Cargo            := TItemGroup()
   ::oGrupoAlmacenOrigen:Cargo:Nombre     := "Almacén origen"
   ::oGrupoAlmacenOrigen:Cargo:Expresion  := "cCodAlm"
   ::oGrupoAlmacenOrigen:Cargo:Todos      := .t.
   ::oGrupoAlmacenOrigen:Cargo:Desde      := Space( 16 )           // dbFirst( ::oDbfAlmacenOrigen, 1 )
   ::oGrupoAlmacenOrigen:Cargo:Hasta      := Replicate( "Z", 16 )  // dbLast( ::oDbfAlmacenOrigen, 1 )
   ::oGrupoAlmacenOrigen:Cargo:cPicDesde  := Replicate( "#", 16 )
   ::oGrupoAlmacenOrigen:Cargo:cPicHasta  := Replicate( "#", 16 )
   ::oGrupoAlmacenOrigen:Cargo:TextDesde  := {|| oRetFld( ::oGrupoAlmacenOrigen:Cargo:Desde, ::oDbfAlmacenOrigen, "cNomAlm", "cCodAlm" ) }
   ::oGrupoAlmacenOrigen:Cargo:TextHasta  := {|| oRetFld( ::oGrupoAlmacenOrigen:Cargo:Hasta, ::oDbfAlmacenOrigen, "cNomAlm", "cCodAlm" ) }
   ::oGrupoAlmacenOrigen:Cargo:HelpDesde  := {|| BrwAlmacen( ::oDesde, ::oSayDesde ) }
   ::oGrupoAlmacenOrigen:Cargo:HelpHasta  := {|| BrwAlmacen( ::oHasta, ::oSayHasta ) }
   ::oGrupoAlmacenOrigen:Cargo:ValidDesde := {|oGet| if( cAlmacen( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfAlmacenOrigen:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoAlmacenOrigen:Cargo:ValidHasta := {|oGet| if( cAlmacen( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfAlmacenOrigen:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoAlmacenOrigen:Cargo:lImprimir  := lImp
   ::oGrupoAlmacenOrigen:Cargo:cBitmap    := "gc_package_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_package_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoAlmacenOrigen )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_package_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoAlmacenOrigen:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoAlmacenOrigen:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoAlmacenOrigen )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoAlmacenOrigen )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfAlmacenOrigen )
         ::oDbfAlmacenOrigen:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoMaquina( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oMaquina           :=  TMaquina():CreateInit( cPatEmp() )
   ::oMaquina:Openfiles()

   ::oGrupoMaquina                  := TRGroup():New( {|| ::oDbf:cCodMaq }, {|| "Máquina : " + ::oDbf:cCodMaq + " - " + ::oDbf:cNomMaq }, {|| "Total máquina : " + ::oDbf:cCodMaq }, {|| 3 }, ::lSalto )

   ::oGrupoMaquina:Cargo            := TItemGroup()
   ::oGrupoMaquina:Cargo:Nombre     := "Maquina"
   ::oGrupoMaquina:Cargo:Expresion  := "cCodMaq"
   ::oGrupoMaquina:Cargo:Todos      := .t.
   ::oGrupoMaquina:Cargo:Desde      := Space( 3 )           // dbFirst( ::oMaquina:oDbf, 1 )
   ::oGrupoMaquina:Cargo:Hasta      := Replicate( "Z", 3 )  // dbLast( ::oMaquina:oDbf, 1 )
   ::oGrupoMaquina:Cargo:cPicDesde  := "@!"
   ::oGrupoMaquina:Cargo:cPicHasta  := "@!"
   ::oGrupoMaquina:Cargo:TextDesde  := {|| oRetFld( ::oGrupoMaquina:Cargo:Desde, ::oMaquina:oDbf, "cDesMaq", "cCodMaq" ) }
   ::oGrupoMaquina:Cargo:TextHasta  := {|| oRetFld( ::oGrupoMaquina:Cargo:Hasta, ::oMaquina:oDbf, "cDesMaq", "cCodMaq" ) }
   ::oGrupoMaquina:Cargo:HelpDesde  := {|| ::oMaquina:Buscar( ::oDesde ) }
   ::oGrupoMaquina:Cargo:HelpHasta  := {|| ::oMaquina:Buscar( ::oHasta ) }
   ::oGrupoMaquina:Cargo:ValidDesde := {|oGet| if( ::oMaquina:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cDesMaq", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoMaquina:Cargo:ValidHasta := {|oGet| if( ::oMaquina:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cDesMaq", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoMaquina:Cargo:lImprimir  := lImp
   ::oGrupoMaquina:Cargo:cBitmap    := "gc_industrial_robot_16"

   if !Empty( ::oImageList )   
      ::oImageList:AddMasked( TBitmap():Define( "gc_industrial_robot_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoMaquina )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_industrial_robot_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoMaquina:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if   

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoMaquina:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoMaquina )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoMaquina )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oMaquina )
         ::oMaquina:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoOperario( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oOperario                       := TOperarios():Create( cPatEmp() )
   ::oOperario:Openfiles()

   ::oGrupoOperario                  := TRGroup():New( {|| ::oDbf:cCodTra }, {|| "Operario : " + ::oDbf:cCodTra + " - " + ::oDbf:cNomTra }, {|| "Total operario : " + ::oDbf:cCodTra }, {|| 3 }, ::lSalto )

   ::oGrupoOperario:Cargo            := TItemGroup()
   ::oGrupoOperario:Cargo:Nombre     := "Operario"
   ::oGrupoOperario:Cargo:Expresion  := "cCodTra"
   ::oGrupoOperario:Cargo:Todos      := .t.
   ::oGrupoOperario:Cargo:Desde      := Space( 5 )          // dbFirst( ::oOperario:oDbf, 1 )
   ::oGrupoOperario:Cargo:Hasta      := Replicate( "Z", 5 ) // dbLast( ::oOperario:oDbf, 1 )
   ::oGrupoOperario:Cargo:cPicDesde  := "@!"
   ::oGrupoOperario:Cargo:cPicHasta  := "@!"
   ::oGrupoOperario:Cargo:TextDesde  := {|| oRetFld( ::oGrupoOperario:Cargo:Desde, ::oOperario:oDbf, "cNomTra", "cCodTra" ) }
   ::oGrupoOperario:Cargo:TextHasta  := {|| oRetFld( ::oGrupoOperario:Cargo:Hasta, ::oOperario:oDbf, "cNomTra", "cCodTra" ) }
   ::oGrupoOperario:Cargo:HelpDesde  := {|| ::oOperario:Buscar( ::oDesde ) }
   ::oGrupoOperario:Cargo:HelpHasta  := {|| ::oOperario:Buscar( ::oHasta ) }
   ::oGrupoOperario:Cargo:ValidDesde := {|oGet| if( ::oOperario:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cNomTra", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoOperario:Cargo:ValidHasta := {|oGet| if( ::oOperario:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cNomTra", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoOperario:Cargo:lImprimir  := lImp
   ::oGrupoOperario:Cargo:cBitmap    := "gc_worker2_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_worker2_16" ), Rgb( 255, 0, 255 ) )
   end if   

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoOperario )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_worker2_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoOperario:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if   

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoOperario:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoOperario )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoOperario )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oOperario )
         ::oOperario:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoFPago( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lImp         := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if empty( ::oDbfFpg ) .or. !::oDbfFpg:Used()
         DATABASE NEW ::oDbfFpg PATH ( cPatEmp() ) FILE "FPago.Dbf" VIA ( cDriver() ) SHARED INDEX "FPago.Cdx"
      end if

      ::oGrupoFpago                   := TRGroup():New( {|| ::oDbf:cCodFpg }, {|| "F. pago : " + AllTrim( ::oDbf:cCodFpg ) + " - " + AllTRim( ::oDbf:cNomFpg ) }, {|| "Total forma de pago : " + ::oDbf:cCodFpg }, {|| 3 }, ::lSalto )

      ::oGrupoFpago:Cargo             := TItemGroup()
      ::oGrupoFpago:Cargo:Nombre      := "Forma pago"
      ::oGrupoFpago:Cargo:Expresion   := "cCodFpg"
      ::oGrupoFpago:Cargo:Todos       := .t.
      ::oGrupoFpago:Cargo:Desde       := Space( 2 )          // dbFirst( ::oDbfFpg, 1 )
      ::oGrupoFpago:Cargo:Hasta       := Replicate( "Z", 2 ) // dbLast( ::oDbfFpg, 1 )
      ::oGrupoFpago:Cargo:cPicDesde   := "@!"
      ::oGrupoFpago:Cargo:cPicHasta   := "@!"
      ::oGrupoFpago:Cargo:TextDesde   := {|| oRetFld( ::oGrupoFpago:Cargo:Desde, ::oDbfFpg, "cDesPago", "cCodPago" ) }
      ::oGrupoFpago:Cargo:TextHasta   := {|| oRetFld( ::oGrupoFpago:Cargo:Hasta, ::oDbfFpg, "cDesPago", "cCodPago" ) }
      ::oGrupoFpago:Cargo:HelpDesde   := {|| BrwFPago( ::oDesde, ::oSayDesde ) }
      ::oGrupoFpago:Cargo:HelpHasta   := {|| BrwFPago( ::oHasta, ::oSayHasta ) }
      ::oGrupoFpago:Cargo:ValidDesde  := {|oGet| if( cFpago( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfFpg:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
      ::oGrupoFpago:Cargo:ValidHasta  := {|oGet| if( cFpago( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfFpg:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
      ::oGrupoFPago:Cargo:lImprimir   := lImp
      ::oGrupoFPago:Cargo:cBitmap     := "gc_credit_cards_16"

      if !Empty( ::oImageList )
         ::oImageList:AddMasked( TBitmap():Define( ::oGrupoFPago:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
      end if

      if lInitGroup != nil

         aAdd( ::aSelectionGroup, ::oGrupoFpago )

         if !Empty( ::oImageGroup )
            ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoFPago:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
            ::oGrupoFpago:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
         end if

         if lInitGroup
            if !Empty( ::oColNombre )
               ::oColNombre:AddResource( ::oGrupoFPago:Cargo:cBitmap )
            end if
            aAdd( ::aInitGroup, ::oGrupoFpago )
         end if

      end if

      aAdd( ::aSelectionRango, ::oGrupoFpago )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfFpg )
         ::oDbfFpg:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoBanco( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oBanco             := TBancos():Create( cPatEmp() )
   ::oBanco:OpenFiles()

   ::oGrupoBanco                    := TRGroup():New( {|| ::oDbf:cCodBnc }, {|| "Banco : " + AllTrim( ::oDbf:cCodBnc ) + " - " + AllTRim( ::oDbf:cNomBnc ) }, {|| "Total banco : " + ::oDbf:cCodBnc }, {|| 3 }, ::lSalto )

   ::oGrupoBanco:Cargo              := TItemGroup()
   ::oGrupoBanco:Cargo:Nombre       := "Banco"
   ::oGrupoBanco:Cargo:Expresion    := "cCodBnc"
   ::oGrupoBanco:Cargo:Todos        := .t.
   ::oGrupoBanco:Cargo:Desde        := Space( 4 )           // dbFirst( ::oBanco:oDbf, 1 )
   ::oGrupoBanco:Cargo:Hasta        := Replicate( "Z", 4 )  // dbLast( ::oBanco:oDbf, 1 )
   ::oGrupoBanco:Cargo:cPicDesde    := "@!"
   ::oGrupoBanco:Cargo:cPicHasta    := "@!"
   ::oGrupoBanco:Cargo:HelpDesde    := {|| ::oBanco:Buscar( ::oDesde ) }
   ::oGrupoBanco:Cargo:HelpHasta    := {|| ::oBanco:Buscar( ::oHasta ) }
   ::oGrupoBanco:Cargo:ValidDesde   := {|oGet| if( ::oBanco:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cNomBnc", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoBanco:Cargo:ValidHasta   := {|oGet| if( ::oBanco:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cNomBnc", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoBanco:Cargo:lImprimir    := lImp

   ::oImageList:AddMasked( TBitmap():Define( "gc_office_building2_16" ), Rgb( 255, 0, 255 ) )

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoBanco )

      ::oImageGroup:AddMasked( TBitmap():Define( "gc_office_building2_16" ), Rgb( 255, 0, 255 ) )

      ::oGrupoBanco:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoBanco:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoBanco )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoBanco )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::Banco )
         ::oBanco:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoAgente( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lImp         := .t.

   oBlock               :=  ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   if ::oDbfAge == nil .or. !::oDbfAge:Used()
      DATABASE NEW ::oDbfAge PATH ( cPatEmp() ) FILE "AGENTES.DBF" VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"
   end if

    ::oGrupoAgente                  := TRGroup():New( {|| ::oDbf:cCodAge }, {|| "Agente : " + AllTrim( ::oDbf:cCodAge ) + " - " + AllTrim( ::oDbf:cApeAge ) + "," + AllTRim( ::oDbf:cNomAge ) }, {|| "Total agente : " + ::oDbf:cCodAge }, {|| 3 }, ::lSalto )

   ::oGrupoAgente:Cargo            := TItemGroup()
   ::oGrupoAgente:Cargo:Nombre     := "Agente"
   ::oGrupoAgente:Cargo:Expresion  := "cCodAge"
   ::oGrupoAgente:Cargo:Todos      := .t.
   ::oGrupoAgente:Cargo:Desde      := Space( 3 )            // dbFirst( ::oDbfAge, 1 )
   ::oGrupoAgente:Cargo:Hasta      := Replicate( "Z", 3 )   // dbLast( ::oDbfAge, 1 )
   ::oGrupoAgente:Cargo:cPicDesde  := "@!"
   ::oGrupoAgente:Cargo:cPicHasta  := "@!"
   ::oGrupoAgente:Cargo:TextDesde  := {|| oRetFld( ::oGrupoAgente:Cargo:Desde, ::oDbfAge, "cNbrAge", "cCodAge" ) }
   ::oGrupoAgente:Cargo:TextHasta  := {|| oRetFld( ::oGrupoAgente:Cargo:Hasta, ::oDbfAge, "cNbrAge", "cCodAge" ) }
   ::oGrupoAgente:Cargo:HelpDesde  := {|| BrwAgentes( ::oDesde, ::oSayDesde ) }
   ::oGrupoAgente:Cargo:HelpHasta  := {|| BrwAgentes( ::oHasta, ::oSayHasta ) }
   ::oGrupoAgente:Cargo:ValidDesde := {|oGet| if( cAgentes( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfAge:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoAgente:Cargo:ValidHasta := {|oGet| if( cAgentes( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfAge:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoAgente:Cargo:lImprimir  := lImp
   ::oGrupoAgente:Cargo:cBitmap    := "gc_businessman2_16"

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoAgente )

      if !Empty( ::oImageGroup )

         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoAgente:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )

         ::oGrupoAgente:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) - 1

      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoAgente:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoAgente )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoAgente )

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

METHOD lGrupoUsuario( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfUsr == nil .or. !::oDbfUsr:Used()
      DATABASE NEW ::oDbfUsr PATH ( cPatDat() ) FILE "USERS.DBF" VIA ( cDriver() ) SHARED INDEX "USERS.CDX"
   end if

   ::oGrupoUsuario                  := TRGroup():New( {|| ::oDbf:cCodUsr }, {|| "Usuario : " + AllTrim( ::oDbf:cCodUsr ) + " - " + AllTRim( ::oDbf:cNomUsr ) }, {|| "Total usuario : " + ::oDbf:cCodUsr }, {|| 3 }, ::lSalto )

   ::oGrupoUsuario:Cargo            := TItemGroup()
   ::oGrupoUsuario:Cargo:Nombre     := "Usuario"
   ::oGrupoUsuario:Cargo:Expresion  := "cCodUsr"
   ::oGrupoUsuario:Cargo:Todos      := .t.
   ::oGrupoUsuario:Cargo:Desde      := Space( 3 )            //dbFirst( ::oDbfUsr, 1 )
   ::oGrupoUsuario:Cargo:Hasta      := Replicate( "Z", 3 )   //dbLast( ::oDbfUsr, 1 )
   ::oGrupoUsuario:Cargo:cPicDesde  := "@!"
   ::oGrupoUsuario:Cargo:cPicHasta  := "@!"

   ::oGrupoUsuario:Cargo:TextDesde  := {|| oRetFld( ::oGrupoUsuario:Cargo:Desde, ::oDbfUsr, "CNBRUSE", "CCODUSE" ) }
   ::oGrupoUsuario:Cargo:TextHasta  := {|| oRetFld( ::oGrupoUsuario:Cargo:Hasta, ::oDbfUsr, "CNBRUSE", "CCODUSE" ) }

   ::oGrupoUsuario:Cargo:HelpDesde  := {|| BrwUser( ::oDesde, ::oDbfUsr:cAlias, ::oSayDesde, .f., .f., .f. ) }
   ::oGrupoUsuario:Cargo:HelpHasta  := {|| BrwUser( ::oHasta, ::oDbfUsr:cAlias, ::oSayHasta, .f., .f., .f. ) }

   ::oGrupoUsuario:Cargo:ValidDesde := {|oGet| if( cUser( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfUsr:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoUsuario:Cargo:ValidHasta := {|oGet| if( cUser( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfUsr:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }

   ::oGrupoUsuario:Cargo:lImprimir  := lImp
   ::oGrupoUsuario:Cargo:cBitmap    := "gc_businesspeople_16"

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoUsuario )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_businesspeople_16" ), Rgb( 255, 0, 255 ) )

         ::oGrupoUsuario:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1

      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoUsuario:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoUsuario )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoUsuario )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfUsr )
         ::oDbfUsr:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoCaja( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfCaj == nil .or. !::oDbfCaj:Used()
      DATABASE NEW ::oDbfCaj PATH ( cPatDat() ) FILE "CAJAS.DBF" VIA ( cDriver() ) SHARED INDEX "CAJAS.CDX"
   end if

   ::oGrupoCaja                  := TRGroup():New( {|| ::oDbf:cCodCaj }, {|| "Caja : " + AllTrim( ::oDbf:cCodCaj ) + " - " + AllTRim( ::oDbf:cNomCaj ) }, {|| "Total caja : " + ::oDbf:cCodCaj }, {|| 3 }, ::lSalto )

   ::oGrupoCaja:Cargo            := TItemGroup()
   ::oGrupoCaja:Cargo:Nombre     := "Caja"
   ::oGrupoCaja:Cargo:Expresion  := "cCodCaj"
   ::oGrupoCaja:Cargo:Todos      := .t.
   ::oGrupoCaja:Cargo:Desde      := Space( 3 )            //dbFirst( ::oDbfCaj, 1 )
   ::oGrupoCaja:Cargo:Hasta      := Replicate( "Z", 3 )   //dbLast( ::oDbfCaj, 1 )
   ::oGrupoCaja:Cargo:cPicDesde  := "@!"
   ::oGrupoCaja:Cargo:cPicHasta  := "@!"
   ::oGrupoCaja:Cargo:HelpDesde  := {|| BrwCajas( ::oDesde, ::oSayDesde ) }
   ::oGrupoCaja:Cargo:HelpHasta  := {|| BrwCajas( ::oHasta, ::oSayHasta ) }
   ::oGrupoCaja:Cargo:ValidDesde := {|oGet| if( cCajas( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfCaj:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoCaja:Cargo:ValidHasta := {|oGet| if( cCajas( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfCaj:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoCaja:Cargo:lImprimir  := lImp

   ::oImageList:AddMasked( TBitmap():Define( "gc_cash_register_16" ), Rgb( 255, 0, 255 ) )

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoCaja )

      ::oImageGroup:AddMasked( TBitmap():Define( "gc_cash_register_16" ), Rgb( 255, 0, 255 ) )

      ::oGrupoCaja:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoCaja:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoCaja )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoCaja )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfCaj )
         ::oDbfCaj:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoTransportista( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oDbfTrn            := TTrans():Create( cPatEmp(), "Transport" )
   ::oDbfTrn:OpenFiles()

   ::oGrupoTransportista                  := TRGroup():New( {|| ::oDbf:cCodTrans }, {|| "Transportista : " + AllTrim( ::oDbf:cCodTrans ) + " - " + AllTRim( ::oDbf:cNomTrans ) }, {|| "Total transportista : " + ::oDbf:cCodTrans }, {|| 3 }, ::lSalto )

   ::oGrupoTransportista:Cargo            := TItemGroup()
   ::oGrupoTransportista:Cargo:Nombre     := "Transportista"
   ::oGrupoTransportista:Cargo:Expresion  := "cCodTrans"
   ::oGrupoTransportista:Cargo:Todos      := .t.
   ::oGrupoTransportista:Cargo:Desde      := Space( 9 )            // dbFirst( ::oDbfTrn:oDbf, 1 )
   ::oGrupoTransportista:Cargo:Hasta      := Replicate( "Z", 9 )   // dbLast( ::oDbfTrn:oDbf, 1 )
   ::oGrupoTransportista:Cargo:cPicDesde  := "@!"
   ::oGrupoTransportista:Cargo:cPicHasta  := "@!"
   ::oGrupoTransportista:Cargo:HelpDesde  := {|| ::oDbfTrn:Buscar( ::oDesde ) }
   ::oGrupoTransportista:Cargo:HelpHasta  := {|| ::oDbfTrn:Buscar( ::oHasta ) }
   ::oGrupoTransportista:Cargo:TextDesde  := {|| ::SetNombreDesdeTransportista() }
   ::oGrupoTransportista:Cargo:TextHasta  := {|| ::SetNombreHastaTransportista() }
   ::oGrupoTransportista:Cargo:ValidDesde := {|oGet| if( ::oDbfTrn:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cNomTrn" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoTransportista:Cargo:ValidHasta := {|oGet| if( ::oDbfTrn:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cNomTrn" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoTransportista:Cargo:lImprimir  := lImp
   ::oGrupoTransportista:Cargo:cBitmap    := "gc_small_truck_16"

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoTransportista )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_small_truck_16" ), Rgb( 255, 0, 255 ) )

         ::oGrupoTransportista:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoTransportista:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoTransportista )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoTransportista )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos de transportista' )

      if !Empty( ::oDbfTrn )
         ::oDbfTrn:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoGrupoCliente( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lImp         := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if empty(::oGrpCli)
      ::oGrpCli                      := TGrpCli():Create( cPatEmp() )
      ::oGrpCli:OpenService()
   end if 

   ::oGrupoGCliente                  := TRGroup():New( {|| ::oDbf:cCodGCli }, {|| "Grp. cliente : " + AllTrim( ::oDbf:cCodGCli ) + " - " + AllTRim( ::oDbf:cNomGCli ) }, {|| "Total grp. cliente : " + ::oDbf:cCodGCli }, {|| 3 }, ::lSalto )

   ::oGrupoGCliente:Cargo            := TItemGroup()
   ::oGrupoGCliente:Cargo:Nombre     := "Grp. cliente"
   ::oGrupoGCliente:Cargo:Expresion  := "cCodGCli"
   ::oGrupoGCliente:Cargo:Todos      := .t.
   ::oGrupoGCliente:Cargo:Desde      := Space( 4 )            // dbFirst( ::oGrpCli:oDbf, 1 )
   ::oGrupoGCliente:Cargo:Hasta      := Replicate( "Z", 4 )   // dbLast( ::oGrpCli:oDbf, 1 )
   ::oGrupoGCliente:Cargo:cPicDesde  := "@!"
   ::oGrupoGCliente:Cargo:cPicHasta  := "@!"
   ::oGrupoGCliente:Cargo:HelpDesde  := {|| ::oGrpCli:Buscar( ::oDesde ) }
   ::oGrupoGCliente:Cargo:HelpHasta  := {|| ::oGrpCli:Buscar( ::oHasta ) }
   ::oGrupoGCliente:Cargo:TextDesde  := {|| ::SetNombreDesdeGrupoCliente() }
   ::oGrupoGCliente:Cargo:TextHasta  := {|| ::SetNombreHastaGrupoCliente() }
   ::oGrupoGCliente:Cargo:ValidDesde := {|oGet| if( ::oGrpCli:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cNomGrp", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoGCliente:Cargo:ValidHasta := {|oGet| if( ::oGrpCli:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cNomGrp", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoGCliente:Cargo:lImprimir  := lImp
   ::oGrupoGCliente:Cargo:cBitmap    := "gc_users3_16"

   ::oGrupoGCliente:Cargo:bValidMayorIgual := {|uVal, uDesde| ::oGrpCli:IsPadreMayor( uVal, uDesde ) }
   ::oGrupoGCliente:Cargo:bValidMenorIgual := {|uVal, uHasta| ::oGrpCli:IsPadreMenor( uVal, uHasta ) }

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoGCliente:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoGCliente )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoGCliente:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoGCliente:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoGCliente:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoGCliente )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoGCliente )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oGrpCli )
         ::oGrpCli:CloseService()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoGProveedor( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oGrpPrv            := TGrpPrv():Create( cPatEmp() )
   ::oGrpPrv:OpenFiles()

   ::oGrupoGProveedor                  := TRGroup():New( {|| ::oDbf:cCodGPrv }, {|| "Grp. proveedor : " + AllTrim( ::oDbf:cCodGPrv ) + " - " + AllTRim( ::oDbf:cNomGPrv ) }, {|| "Total grp. proveedor : " + ::oDbf:cCodGPrv }, {|| 3 }, ::lSalto )

   ::oGrupoGProveedor:Cargo            := TItemGroup()
   ::oGrupoGProveedor:Cargo:Nombre     := "Grp. proveedor"
   ::oGrupoGProveedor:Cargo:Expresion  := "cCodGPrv"
   ::oGrupoGProveedor:Cargo:Todos      := .t.
   ::oGrupoGProveedor:Cargo:Desde      := Space( 4 )            // dbFirst( ::oGrpPrv:oDbf, 1 )
   ::oGrupoGProveedor:Cargo:Hasta      := Replicate( "Z", 4 )   // dbLast( ::oGrpPrv:oDbf, 1 )
   ::oGrupoGProveedor:Cargo:cPicDesde  := Replicate( "X", RetNumCodPrvEmp() )
   ::oGrupoGProveedor:Cargo:cPicHasta  := Replicate( "X", RetNumCodPrvEmp() )
   ::oGrupoGProveedor:Cargo:TextDesde  := {|| oRetFld( ::oGrupoGProveedor:Cargo:Desde, ::oGrpPrv:oDbf, "cNomGrp", "cCodGrp" ) }
   ::oGrupoGProveedor:Cargo:TextHasta  := {|| oRetFld( ::oGrupoGProveedor:Cargo:Hasta, ::oGrpPrv:oDbf, "cNomGrp", "cCodGrp" ) }
   ::oGrupoGProveedor:Cargo:HelpDesde  := {|| ::oGrpPrv:Buscar( ::oDesde ) }
   ::oGrupoGProveedor:Cargo:HelpHasta  := {|| ::oGrpPrv:Buscar( ::oHasta ) }
   ::oGrupoGProveedor:Cargo:ValidDesde := {|oGet| if( ::oGrpPrv:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cNomGrp", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoGProveedor:Cargo:ValidHasta := {|oGet| if( ::oGrpPrv:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cNomGrp", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoGProveedor:Cargo:lImprimir  := lImp
   ::oGrupoGProveedor:Cargo:cBitmap     := "gc_businessmen2_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoGProveedor:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoGProveedor )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoGProveedor:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoGProveedor:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoGProveedor:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoGProveedor )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoGProveedor )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oGrpPrv )
         ::oGrpPrv:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoObra( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfObr == nil .or. !::oDbfObr:Used()
      DATABASE NEW ::oDbfObr PATH ( cPatEmp() ) FILE "OBRAST.DBF" VIA ( cDriver() ) SHARED INDEX "OBRAST.CDX"
   end if

   ::oGrupoObra                  := TRGroup():New( {|| ::oDbf:cCodObra }, {|| "Obra : " + AllTrim( ::oDbf:cCodObra ) + " - " + AllTRim( ::oDbf:cNomObra ) }, {|| "Total obra : " + ::oDbf:cCodObra }, {|| 3 }, ::lSalto )

   ::oGrupoObra:Cargo            := TItemGroup()
   ::oGrupoObra:Cargo:Nombre     := "Dirección"
   ::oGrupoObra:Cargo:Expresion  := "cCodObra"
   ::oGrupoObra:Cargo:Todos      := .t.
   ::oGrupoObra:Cargo:Desde      := Space( 10 )
   ::oGrupoObra:Cargo:Hasta      := Replicate( "Z", 10 )
   ::oGrupoObra:Cargo:cPicDesde  := "@!"
   ::oGrupoObra:Cargo:cPicHasta  := "@!"
   ::oGrupoObra:Cargo:HelpDesde  := {|| BrwObras( ::oDesde, ::oSayDesde, ::oGrupoCliente:Cargo:Desde, ::oDbfObr:cAlias ) }
   ::oGrupoObra:Cargo:HelpHasta  := {|| BrwObras( ::oHasta, ::oSayHasta, ::oGrupoCliente:Cargo:Desde, ::oDbfObr:cAlias ) }
   ::oGrupoObra:Cargo:ValidDesde := {|oGet| if( cObras( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, ::oGrupoCliente:Cargo:Desde, ::oDbfObr:cAlias ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoObra:Cargo:ValidHasta := {|oGet| if( cObras( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, ::oGrupoCliente:Cargo:Desde, ::oDbfObr:cAlias ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoObra:Cargo:bCondition := {|| ::lIgualCliente() }
   ::oGrupoObra:Cargo:lImprimir  := lImp

   ::oImageList:AddMasked( TBitmap():Define( "User1_Hammer_16" ), Rgb( 255, 0, 255 ) )

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoObra )

      ::oImageGroup:AddMasked( TBitmap():Define( "User1_Hammer_16" ), Rgb( 255, 0, 255 ) )

      ::oGrupoObra:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoObra:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoObra )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoObra )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfObr )
         ::oGrpObr:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoFamilia( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfFam == nil .or. !::oDbfFam:Used()
      DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"
   end if

   ::oGrupoFamilia                    := TRGroup():New( {|| ::oDbf:cCodFam }, {|| "Familia : " + AllTrim( ::oDbf:cCodFam ) + " - " + AllTRim( ::oDbf:cNomFam ) }, {|| "Total familia : " + ::oDbf:cCodFam }, {|| 3 }, ::lSalto )

   ::oGrupoFamilia:Cargo              := TItemGroup()
   ::oGrupoFamilia:Cargo:Nombre       := "Familia"
   ::oGrupoFamilia:Cargo:Expresion    := "cCodFam"
   ::oGrupoFamilia:Cargo:Todos        := .t.
   ::oGrupoFamilia:Cargo:Desde        := Space( 16 )           // dbFirst( ::oDbfFam, 1 )
   ::oGrupoFamilia:Cargo:Hasta        := Replicate( "Z", 16 )  // dbLast( ::oDbfFam, 1 )
   ::oGrupoFamilia:Cargo:cPicDesde    := "@!"
   ::oGrupoFamilia:Cargo:cPicHasta    := "@!"
   ::oGrupoFamilia:Cargo:HelpDesde    := {|| BrwFamilia( ::oDesde, ::oSayDesde ) }
   ::oGrupoFamilia:Cargo:HelpHasta    := {|| BrwFamilia( ::oHasta, ::oSayHasta ) }
   ::oGrupoFamilia:Cargo:TextDesde    := {|| oRetFld( ::oGrupoFamilia:Cargo:Desde, ::oDbfFam, "cNomFam", "cCodFam" ) }
   ::oGrupoFamilia:Cargo:TextHasta    := {|| oRetFld( ::oGrupoFamilia:Cargo:Hasta, ::oDbfFam, "cNomFam", "cCodFam" ) }
   ::oGrupoFamilia:Cargo:ValidDesde   := {|oGet| if( cFamilia( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfFam:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoFamilia:Cargo:ValidHasta   := {|oGet| if( cFamilia( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfFam:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoFamilia:Cargo:lImprimir    := lImp
   ::oGrupoFamilia:Cargo:cBitmap      := "gc_cubes_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoFamilia:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoFamilia )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoFamilia:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoFamilia:Cargo:Imagen := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoFamilia:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoFamilia )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoFamilia )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfFam )
         ::oDbfFam:End()
      end if

      lOpen                            := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoGFamilia( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oGruFam            := TGrpFam():Create( cPatEmp(), "GRPFAM" )
   ::oGruFam:OpenFiles()

   ::oGrupoGFamilia                  := TRGroup():New( {|| ::oDbf:cCodGFam }, {|| "Grp. familia : " + AllTrim( ::oDbf:cCodGFam ) + " - " + AllTRim( ::oDbf:cNomGFam ) }, {|| "Total grp. familia : " + ::oDbf:cCodGFam }, {|| 3 }, ::lSalto )

   ::oGrupoGFamilia:Cargo            := TItemGroup()
   ::oGrupoGFamilia:Cargo:Nombre     := "Grp. familia"
   ::oGrupoGFamilia:Cargo:Expresion  := "cCodGFam"
   ::oGrupoGFamilia:Cargo:Todos      := .t.
   ::oGrupoGFamilia:Cargo:Desde      := Space( 3 )            // dbFirst( ::oGruFam:oDbf, 1 )
   ::oGrupoGFamilia:Cargo:Hasta      := Replicate( "Z", 3 )   // dbLast( ::oGruFam:oDbf, 1 )
   ::oGrupoGFamilia:Cargo:cPicDesde  := "@!"
   ::oGrupoGFamilia:Cargo:cPicHasta  := "@!"
   ::oGrupoGFamilia:Cargo:HelpDesde  := {|| ::oGruFam:Buscar( ::oDesde ) }
   ::oGrupoGFamilia:Cargo:HelpHasta  := {|| ::oGruFam:Buscar( ::oHasta ) }
   ::oGrupoGFamilia:Cargo:TextDesde  := {|| oRetFld( ::oGrupoGFamilia:Cargo:Desde, ::oGruFam:oDbf, "cNomGrp", "cCodGrp" ) }
   ::oGrupoGFamilia:Cargo:TextHasta  := {|| oRetFld( ::oGrupoGFamilia:Cargo:Hasta, ::oGruFam:oDbf, "cNomGrp", "cCodGrp" ) }
   ::oGrupoGFamilia:Cargo:ValidDesde := {|oGet| if( ::oGruFam:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cNomGrp", .t. ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoGFamilia:Cargo:ValidHasta := {|oGet| if( ::oGruFam:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cNomGrp", .t. ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoGFamilia:Cargo:lImprimir  := lImp
   ::oGrupoGFamilia:Cargo:cBitmap    := "gc_folder_cubes_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_folder_cubes_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoGFamilia )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_folder_cubes_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoGFamilia:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoGFamilia:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoGFamilia )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoGFamilia )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oGruFam )
         ::oGruFam:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoCentroCoste( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT lImp         := .t.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oDbfCentroCoste := TCentroCoste():New( cPatDat() )
   ::oDbfCentroCoste:OpenFiles()

   ::oGrupoCentroCoste                    := TRGroup():New( {|| ::oDbf:cCtrCoste }, {|| "Centro de coste : " + AllTrim( ::oDbf:cCtrCoste ) }, {|| "Total Centro de coste : " + ::oDbf:cCtrCoste }, {|| 3 }, ::lSalto )

   ::oGrupoCentroCoste:Cargo              := TItemGroup()
   ::oGrupoCentroCoste:Cargo:Nombre       := "Ctr. de coste"
   ::oGrupoCentroCoste:Cargo:Expresion    := "cCodigo"
   ::oGrupoCentroCoste:Cargo:Todos        := .t.
   ::oGrupoCentroCoste:Cargo:Desde        := Space( 16 )           // dbFirst( ::oDbfCentroCoste, 1 )
   ::oGrupoCentroCoste:Cargo:Hasta        := Replicate( "Z", 16 )  // dbLast( ::oDbfCentroCoste, 1 )
   ::oGrupoCentroCoste:Cargo:cPicDesde    := "@!"
   ::oGrupoCentroCoste:Cargo:cPicHasta    := "@!"
   ::oGrupoCentroCoste:Cargo:HelpDesde    := {|| ::oDbfCentroCoste:Buscar( ::oDesde ) }
   ::oGrupoCentroCoste:Cargo:HelpHasta    := {|| ::oDbfCentroCoste:Buscar( ::oHasta ) }
   ::oGrupoCentroCoste:Cargo:TextDesde    := {|| oRetFld( ::oGrupoCentroCoste:Cargo:Desde, ::oDbfCentroCoste:oDbf, "cNombre", "cCodigo" ) }
   ::oGrupoCentroCoste:Cargo:TextHasta    := {|| oRetFld( ::oGrupoCentroCoste:Cargo:Hasta, ::oDbfCentroCoste:oDbf, "cNombre", "cCodigo" ) }
   ::oGrupoCentroCoste:Cargo:ValidDesde   := {|oGet| if( ::oDbfCentroCoste:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cNombre" ), ( ::ChangeValor(), .t. ), .f. )  }
   ::oGrupoCentroCoste:Cargo:ValidHasta   := {|oGet| if( ::oDbfCentroCoste:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cNombre" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoCentroCoste:Cargo:lImprimir    := lImp
   ::oGrupoCentroCoste:Cargo:cBitmap      := "gc_folder_open_money_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoCentroCoste:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoCentroCoste )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoCentroCoste:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoCentroCoste:Cargo:Imagen := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoCentroCoste:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoCentroCoste )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoCentroCoste )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfCentroCoste )
         ::oDbfCentroCoste:End()
      end if

      lOpen                            := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoTipoArticulo( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oTipArt            := TTipArt():New( cPatEmp(), cDriver() )
   ::oTipArt:OpenFiles()

   ::oGrupoTArticulo                  := TRGroup():New( {|| ::oDbf:cCodTArt }, {|| "Tip. artículo : " + AllTrim( ::oDbf:cCodTArt ) + " - " + AllTRim( ::oDbf:cNomTArt ) }, {|| "Total tip. artículo : " + ::oDbf:cCodTArt }, {|| 3 }, ::lSalto )

   ::oGrupoTArticulo:Cargo            := TItemGroup()
   ::oGrupoTArticulo:Cargo:Nombre     := "Tipo artículo"
   ::oGrupoTArticulo:Cargo:Expresion  := "cCodTArt"
   ::oGrupoTArticulo:Cargo:Todos      := .t.
   ::oGrupoTArticulo:Cargo:Desde      := Space( 4 )            // dbFirst( ::oTipArt:oDbf, 1 )
   ::oGrupoTArticulo:Cargo:Hasta      := Replicate( "Z", 4 )   // dbLast( ::oTipArt:oDbf, 1 )
   ::oGrupoTArticulo:Cargo:cPicDesde  := "@!"
   ::oGrupoTArticulo:Cargo:cPicHasta  := "@!"
   ::oGrupoTArticulo:Cargo:HelpDesde  := {|| ::oTipArt:Buscar( ::oDesde ) }
   ::oGrupoTArticulo:Cargo:HelpHasta  := {|| ::oTipArt:Buscar( ::oHasta ) }
   ::oGrupoTArticulo:Cargo:TextDesde  := {|| oRetFld( ::oGrupoTArticulo:Cargo:Desde, ::oTipArt:oDbf, "cNomTip", "cCodTip" ) }
   ::oGrupoTArticulo:Cargo:TextHasta  := {|| oRetFld( ::oGrupoTArticulo:Cargo:Hasta, ::oTipArt:oDbf, "cNomTip", "cCodTip" ) }
   ::oGrupoTArticulo:Cargo:ValidDesde := {|oGet| if( ::oTipArt:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cNomTip", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoTArticulo:Cargo:ValidHasta := {|oGet| if( ::oTipArt:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cNomTip", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoTArticulo:Cargo:lImprimir  := lImp
   ::oGrupoTArticulo:Cargo:cBitmap    := "gc_objects_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_objects_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoTArticulo )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_objects_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoTArticulo:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) - 1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoTArticulo:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoTArticulo )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoTArticulo )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oTipArt )
         ::oTipArt:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoFabricante( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oDbfFab            := TFabricantes():New( cPatEmp() )
   ::oDbfFab:OpenFiles()

   ::oGrupoFabricante                  := TRGroup():New( {|| ::oDbf:cCodFab }, {|| "Fabricante : " + AllTrim( ::oDbf:cCodFab ) + " - " + AllTRim( ::oDbf:cNomFab ) }, {|| "Total fabricante : " + ::oDbf:cCodFab }, {|| 3 }, ::lSalto )

   ::oGrupoFabricante:Cargo            := TItemGroup()
   ::oGrupoFabricante:Cargo:Nombre     := "Fabricante"
   ::oGrupoFabricante:Cargo:Expresion  := "cCodFab"
   ::oGrupoFabricante:Cargo:Todos      := .t.
   ::oGrupoFabricante:Cargo:Desde      := Space( 3 )            // dbFirst( ::oDbfFab:oDbf, 1 )
   ::oGrupoFabricante:Cargo:Hasta      := Replicate( "Z", 3 )   // dbLast( ::oDbfFab:oDbf, 1 )
   ::oGrupoFabricante:Cargo:cPicDesde  := "@!"
   ::oGrupoFabricante:Cargo:cPicHasta  := "@!"
   ::oGrupoFabricante:Cargo:HelpDesde  := {|| ::oDbfFab:Buscar( ::oDesde ) }
   ::oGrupoFabricante:Cargo:HelpHasta  := {|| ::oDbfFab:Buscar( ::oHasta ) }
   ::oGrupoFabricante:Cargo:TextDesde  := {|| oRetFld( ::oGrupoFabricante:Cargo:Desde, ::oDbfFab:oDbf, "cNomFab", "cCodFab" ) }
   ::oGrupoFabricante:Cargo:TextHasta  := {|| oRetFld( ::oGrupoFabricante:Cargo:Hasta, ::oDbfFab:oDbf, "cNomFab", "cCodFab" ) }
   ::oGrupoFabricante:Cargo:ValidDesde := {|oGet| if( ::oDbfFab:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cNomFab", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoFabricante:Cargo:ValidHasta := {|oGet| if( ::oDbfFab:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cNomFab", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoFabricante:Cargo:lImprimir  := lImp
   ::oGrupoFabricante:Cargo:cBitmap    := "gc_bolt_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoFabricante:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoFabricante )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoFabricante:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoFabricante:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) - 1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoFabricante:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoFabricante )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoFabricante )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfFab )
         ::oDbfFab:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoTipoExpediente( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oTipoExpediente    := TTipoExpediente():Create( cPatEmp() )
   ::oTipoExpediente:OpenFiles()

   ::oGrupoTipoExpediente                    := TRGroup():New( {|| ::oDbf:cCodTip }, {|| "Tipo expediente : " + AllTrim( ::oDbf:cCodTip ) + " - " + AllTRim( ::oDbf:cNomTip ) }, {|| "Total tipo expediente..." }, {|| 3 }, ::lSalto )

   ::oGrupoTipoExpediente:Cargo              := TItemGroup()
   ::oGrupoTipoExpediente:Cargo:Nombre       := "Tipo expediente"
   ::oGrupoTipoExpediente:Cargo:Expresion    := "cCodTip"
   ::oGrupoTipoExpediente:Cargo:Todos        := .t.
   ::oGrupoTipoExpediente:Cargo:Desde        := Space( 3 )            // dbFirst( ::oTipoExpediente:oDbf, 1 )
   ::oGrupoTipoExpediente:Cargo:Hasta        := Replicate( "Z", 3 )   // dbLast( ::oTipoExpediente:oDbf, 1 )
   ::oGrupoTipoExpediente:Cargo:cPicDesde    := "@!"
   ::oGrupoTipoExpediente:Cargo:cPicHasta    := "@!"
   ::oGrupoTipoExpediente:Cargo:HelpDesde    := {|| ::oTipoExpediente:Buscar( ::oDesde ) }
   ::oGrupoTipoExpediente:Cargo:HelpHasta    := {|| ::oTipoExpediente:Buscar( ::oHasta ) }
   ::oGrupoTipoExpediente:Cargo:ValidDesde   := {|oGet| if( ::oTipoExpediente:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cNomTip", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoTipoExpediente:Cargo:ValidHasta   := {|oGet| if( ::oTipoExpediente:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cNomTip", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoTipoExpediente:Cargo:lImprimir    := lImp

   ::oImageList:AddMasked( TBitmap():Define( "gc_folders_16" ), Rgb( 255, 0, 255 ) )

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoTipoExpediente )

      ::oImageGroup:AddMasked( TBitmap():Define( "gc_folders_16" ), Rgb( 255, 0, 255 ) )

      ::oGrupoTipoExpediente:Cargo:Imagen    := len( ::oImageGroup:aBitmaps ) - 1

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoTipoExpediente:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoTipoExpediente )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoTipoExpediente )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oTipoExpediente )
         ::oTipoExpediente:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoEntidad( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oEntidad           := TEntidades():Create( cPatEmp() )
   ::oEntidad:OpenFiles()

   ::oGrupoEntidad                    := TRGroup():New( {|| ::oDbf:cCodEnt }, {|| "Entidad : " + AllTrim( ::oDbf:cCodEnt ) + " - " + AllTrim( ::oDbf:cDesEnt ) }, {|| "Total entidad..." }, {|| 3 }, ::lSalto )

   ::oGrupoEntidad:Cargo              := TItemGroup()
   ::oGrupoEntidad:Cargo:Nombre       := "Entidad"
   ::oGrupoEntidad:Cargo:Expresion    := "cCodEnt"
   ::oGrupoEntidad:Cargo:Todos        := .t.
   ::oGrupoEntidad:Cargo:Desde        := Space( 3 )            // dbFirst( ::oEntidad:oDbf, 1 )
   ::oGrupoEntidad:Cargo:Hasta        := Replicate( "Z", 3 )   // dbLast( ::oEntidad:oDbf, 1 )
   ::oGrupoEntidad:Cargo:cPicDesde    := "@!"
   ::oGrupoEntidad:Cargo:cPicHasta    := "@!"
   ::oGrupoEntidad:Cargo:HelpDesde    := {|| ::oEntidad:Buscar( ::oDesde ) }
   ::oGrupoEntidad:Cargo:HelpHasta    := {|| ::oEntidad:Buscar( ::oHasta ) }
   ::oGrupoEntidad:Cargo:ValidDesde   := {|oGet| if( ::oEntidad:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cDesEnt", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoEntidad:Cargo:ValidHasta   := {|oGet| if( ::oEntidad:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cDesEnt", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoEntidad:Cargo:lImprimir    := lImp

   ::oImageList:AddMasked( TBitmap():Define( "gc_office_building2_16" ), Rgb( 255, 0, 255 ) )

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoEntidad )

      ::oImageGroup:AddMasked( TBitmap():Define( "gc_office_building2_16" ), Rgb( 255, 0, 255 ) )

      ::oGrupoEntidad:Cargo:Imagen    := len( ::oImageGroup:aBitmaps ) - 1

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoEntidad:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoEntidad )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoEntidad )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oEntidad )
         ::oEntidad:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoColaborador( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oColaborador       := TColaboradores():Create( cPatEmp() )
   ::oColaborador:OpenFiles()

   ::oGrupoColaborador                    := TRGroup():New( {|| ::oDbf:cCodCol }, {|| "Colaborador : " + AllTrim( ::oDbf:cCodCol ) + " - " + AllTrim( ::oDbf:cDesCol ) }, {|| "Total Colaborador..." }, {|| 3 }, ::lSalto )

   ::oGrupoColaborador:Cargo              := TItemGroup()
   ::oGrupoColaborador:Cargo:Nombre       := "Colaborador"
   ::oGrupoColaborador:Cargo:Expresion    := "cCodCol"
   ::oGrupoColaborador:Cargo:Todos        := .t.
   ::oGrupoColaborador:Cargo:Desde        := Space( 3 )            // dbFirst( ::oColaborador:oDbf, 1 )
   ::oGrupoColaborador:Cargo:Hasta        := Replicate( "Z", 3 )   // dbLast( ::oColaborador:oDbf, 1 )
   ::oGrupoColaborador:Cargo:cPicDesde    := "@!"
   ::oGrupoColaborador:Cargo:cPicHasta    := "@!"
   ::oGrupoColaborador:Cargo:HelpDesde    := {|| ::oColaborador:Buscar( ::oDesde ) }
   ::oGrupoColaborador:Cargo:HelpHasta    := {|| ::oColaborador:Buscar( ::oHasta ) }
   ::oGrupoColaborador:Cargo:ValidDesde   := {|oGet| if( ::oColaborador:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cDesCol", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoColaborador:Cargo:ValidHasta   := {|oGet| if( ::oColaborador:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cDesCol", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoColaborador:Cargo:lImprimir    := lImp

   ::oImageList:AddMasked( TBitmap():Define( "gc_businessman2_16" ), Rgb( 255, 0, 255 ) )

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoColaborador )

      ::oImageGroup:AddMasked( TBitmap():Define( "gc_businessman2_16" ), Rgb( 255, 0, 255 ) )

      ::oGrupoColaborador:Cargo:Imagen    := len( ::oImageGroup:aBitmaps ) - 1

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoColaborador:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoColaborador )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoColaborador )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oColaborador )
         ::oColaborador:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoEstadoArticulo( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lImp         := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ::oDbfEstArt == nil .or. !::oDbfEstArt:Used()
      DATABASE NEW ::oDbfEstArt PATH ( cPatEmp() ) FILE "ESTADOSAT.DBF" VIA ( cDriver() ) SHARED INDEX "ESTADOSAT.CDX"
   end if

   ::oGrupoEstadoArticulo                   := TRGroup():New( {|| ::oDbf:cCodEst }, {|| "Estado : " + AllTrim( ::oDbf:cCodEst ) + " - " + AllTRim( ::oDbf:cNomEst ) }, {|| "Total estado : " + ::oDbf:cCodEst }, {|| 3 }, ::lSalto )

   ::oGrupoEstadoArticulo:Cargo             := TItemGroup()
   ::oGrupoEstadoArticulo:Cargo:Nombre      := "Estado"
   ::oGrupoEstadoArticulo:Cargo:Expresion   := "cCodEst"
   ::oGrupoEstadoArticulo:Cargo:Todos       := .t.
   ::oGrupoEstadoArticulo:Cargo:Desde       := Space( 3 )
   ::oGrupoEstadoArticulo:Cargo:Hasta       := Replicate( "Z", 3 )
   ::oGrupoEstadoArticulo:Cargo:cPicDesde   := "@!"
   ::oGrupoEstadoArticulo:Cargo:cPicHasta   := "@!"
   ::oGrupoEstadoArticulo:Cargo:HelpDesde   := {|| BrwEstadoArticulo( ::oDesde, ::oSayDesde ) }
   ::oGrupoEstadoArticulo:Cargo:HelpHasta   := {|| BrwEstadoArticulo( ::oHasta, ::oSayHasta ) }
   ::oGrupoEstadoArticulo:Cargo:TextDesde   := {|| oRetFld( ::oGrupoEstadoArticulo:Cargo:Desde, ::oDbfEstArt, "cNombre", "Codigo" ) }
   ::oGrupoEstadoArticulo:Cargo:TextHasta   := {|| oRetFld( ::oGrupoEstadoArticulo:Cargo:Hasta, ::oDbfEstArt, "cNombre", "Codigo" ) }
   ::oGrupoEstadoArticulo:Cargo:ValidDesde  := {|oGet| if( cEstadoArticulo( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfEstArt:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoEstadoArticulo:Cargo:ValidHasta  := {|oGet| if( cEstadoArticulo( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfEstArt:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoEstadoArticulo:Cargo:lImprimir   := lImp
   ::oGrupoEstadoArticulo:Cargo:cBitmap     := "gc_bookmarks_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_bookmarks_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoEstadoArticulo )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_bookmarks_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoEstadoArticulo:Cargo:Imagen   := len( ::oImageGroup:aBitmaps ) - 1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoEstadoArticulo:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoEstadoArticulo )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoEstadoArticulo )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfEstArt )
         ::oDbfEstArt:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoRuta( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lImp         := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   if ::oDbfRut == nil .or. !::oDbfRut:Used()
      DATABASE NEW ::oDbfRut PATH ( cPatEmp() ) FILE "RUTA.DBF" VIA ( cDriver() ) SHARED INDEX "RUTA.CDX"
   end if

   ::oGrupoRuta                  := TRGroup():New( {|| ::oDbf:cCodRut }, {|| "Ruta : " + AllTrim( ::oDbf:cCodRut ) + " - " + AllTRim( ::oDbf:cNomRut ) }, {|| "Total ruta..." }, {|| 3 }, ::lSalto )

   ::oGrupoRuta:Cargo            := TItemGroup()
   ::oGrupoRuta:Cargo:Nombre     := "Ruta"
   ::oGrupoRuta:Cargo:Expresion  := "cCodRut"
   ::oGrupoRuta:Cargo:Todos      := .t.
   ::oGrupoRuta:Cargo:Desde      := Space( 4 )            // dbFirst( ::oDbfRut, 1 )
   ::oGrupoRuta:Cargo:Hasta      := Replicate( "Z", 4 )   // dbLast( ::oDbfRut, 1 )
   ::oGrupoRuta:Cargo:cPicDesde  := "@!"
   ::oGrupoRuta:Cargo:cPicHasta  := "@!"
   ::oGrupoRuta:Cargo:TextDesde  := {|| oRetFld( ::oGrupoRuta:Cargo:Desde, ::oDbfRut, "CDESRUT", "CCODRUT" ) }
   ::oGrupoRuta:Cargo:TextHasta  := {|| oRetFld( ::oGrupoRuta:Cargo:Hasta, ::oDbfRut, "CDESRUT", "CCODRUT" ) }
   ::oGrupoRuta:Cargo:HelpDesde  := {|| BrwRuta( ::oDesde, ::oDbfRut:cAlias, ::oSayDesde ) }
   ::oGrupoRuta:Cargo:HelpHasta  := {|| BrwRuta( ::oHasta, ::oDbfRut:cAlias, ::oSayHasta ) }
   ::oGrupoRuta:Cargo:ValidDesde := {|oGet| if( cRuta( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfRut:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoRuta:Cargo:ValidHasta := {|oGet| if( cRuta( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfRut:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoRuta:Cargo:lImprimir  := lImp

   ::oGrupoRuta:Cargo:cBitmap   := "gc_signpost2_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_signpost2_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoRuta )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_signpost2_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoRuta:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoRuta:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoRuta )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoRuta )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfRut )
         ::oDbfRut:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoFacturasCompras( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   local cDesde
   local cHasta

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oFacPrvT == nil .or. !::oFacCliT:Used()
      DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"
      ::oFacPrvT:OrdSetFocus( "nNumFac" )
   end if

   /*
   Cojemos el código de la última factura--------------------------------------
   */

   ::oFacPrvT:GoBottom()
   cHasta               := ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac

   /*
   Cojemos el código de la primera factura y dejamos la tabla al principio-----
   */

   ::oFacPrvT:GoTop()
   cDesde               := ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac

   ::oGrupoFacturasCompras                  := TRGroup():New( {|| ::oDbf:cFactura }, {|| "Factura : " + AllTrim( ::oDbf:cFactura ) }, {|| "Total factura..." }, {|| 3 }, ::lSalto )

   ::oGrupoFacturasCompras:Cargo            := TItemGroup()
   ::oGrupoFacturasCompras:Cargo:Nombre     := "Factura"
   ::oGrupoFacturasCompras:Cargo:Expresion  := "cFactura"
   ::oGrupoFacturasCompras:Cargo:Todos      := .t.
   ::oGrupoFacturasCompras:Cargo:Desde      := cDesde
   ::oGrupoFacturasCompras:Cargo:Hasta      := cHasta
   ::oGrupoFacturasCompras:Cargo:cPicDesde  := "@R A/999999999/##"
   ::oGrupoFacturasCompras:Cargo:cPicHasta  := "@R A/999999999/##"
   ::oGrupoFacturasCompras:Cargo:HelpDesde  := {|| BrowseInformesFacPrv( ::oDesde, ::oSayDesde ) }
   ::oGrupoFacturasCompras:Cargo:HelpHasta  := {|| BrowseInformesFacPrv( ::oHasta, ::oSayHasta ) }
   ::oGrupoFacturasCompras:Cargo:ValidDesde := {|oGet| if( lValidInformeFacPrv( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoFacturasCompras:Cargo:ValidHasta := {|oGet| if( lValidInformeFacPrv( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoFacturasCompras:Cargo:lImprimir  := lImp

   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_businessman_16" ), Rgb( 255, 0, 255 ) )

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoFacturasCompras )

      ::oImageGroup:AddMasked( TBitmap():Define( "gc_document_text_businessman_16" ), Rgb( 255, 0, 255 ) )

      ::oGrupoFacturas:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoFacturasCompra:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoFacturasCompras )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoFacturasCompras )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oFacPrvT )
         ::oFacPrvT:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoFacturas( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   local cDesde
   local cHasta

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oFacCliT == nil .or. !::oFacCliT:Used()
      ::oFacCliT        := TDataCenter():oFacCliT()
      ::oFacCliT:OrdSetFocus( "nNumFac" )
   end if

   /*
   Cojemos el código de la última factura--------------------------------------
   */

   ::oFacCliT:GoBottom()
   cHasta               := ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac

   /*
   Cojemos el código de la primera factura y dejamos la tabla al principio-----
   */

   ::oFacCliT:GoTop()
   cDesde               := ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac


   ::oGrupoFacturas                  := TRGroup():New( {|| ::oDbf:cFactura }, {|| "Factura : " + AllTrim( ::oDbf:cFactura ) }, {|| "Total factura..." }, {|| 3 }, ::lSalto )

   ::oGrupoFacturas:Cargo            := TItemGroup()
   ::oGrupoFacturas:Cargo:Nombre     := "Factura"
   ::oGrupoFacturas:Cargo:Expresion  := "cFactura"
   ::oGrupoFacturas:Cargo:Todos      := .t.
   ::oGrupoFacturas:Cargo:Desde      := cDesde
   ::oGrupoFacturas:Cargo:Hasta      := cHasta
   ::oGrupoFacturas:Cargo:cPicDesde  := "@R A/999999999/##"
   ::oGrupoFacturas:Cargo:cPicHasta  := "@R A/999999999/##"
   ::oGrupoFacturas:Cargo:HelpDesde  := {|| BrowseInformesFacCli( ::oDesde, ::oSayDesde ) }
   ::oGrupoFacturas:Cargo:HelpHasta  := {|| BrowseInformesFacCli( ::oHasta, ::oSayHasta ) }
   ::oGrupoFacturas:Cargo:ValidDesde := {|oGet| if( lValidInformeFacCli( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoFacturas:Cargo:ValidHasta := {|oGet| if( lValidInformeFacCli( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoFacturas:Cargo:lImprimir  := lImp

   ::oImageList:AddMasked( TBitmap():Define( "gc_document_text_businessman_16" ), Rgb( 255, 0, 255 ) )

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoFacturas )

      ::oImageGroup:AddMasked( TBitmap():Define( "gc_document_text_businessman_16" ), Rgb( 255, 0, 255 ) )

      ::oGrupoFacturas:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) -1

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoFacturas:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoFacturas )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoFacturas )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oFacCliT )
         ::oFacCliT:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoTemporada( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfTmp == nil .or. !::oDbfTmp:Used()
      DATABASE NEW ::oDbfTmp PATH ( cPatEmp() ) FILE "Temporadas.DBF" VIA ( cDriver() ) SHARED INDEX "Temporadas.Cdx"
   end if

   ::oGrupoTemporada                   := TRGroup():New( {|| ::oDbf:cCodTmp }, {|| "Temporada : " + AllTrim( ::oDbf:cCodTmp ) + " - " + AllTRim( ::oDbf:cNomTmp ) }, {|| "Total temporada..." }, {|| 3 }, ::lSalto )

   ::oGrupoTemporada:Cargo             := TItemGroup()
   ::oGrupoTemporada:Cargo:Nombre      := getConfigTraslation( "Temporada" )
   ::oGrupoTemporada:Cargo:Expresion   := "cCodTmp"
   ::oGrupoTemporada:Cargo:Todos       := .t.
   ::oGrupoTemporada:Cargo:Desde       := Space( 10 )            // dbFirst( ::oDbfCat, 1 )
   ::oGrupoTemporada:Cargo:Hasta       := Replicate( "Z", 10 )   // dbLast( ::oDbfCat, 1 )
   ::oGrupoTemporada:Cargo:cPicDesde   := "@!"
   ::oGrupoTemporada:Cargo:cPicHasta   := "@!"
   ::oGrupoTemporada:Cargo:TextDesde   := {|| oRetFld( ::oGrupoTemporada:Cargo:Desde, ::oDbfTmp, "cNombre", "Codigo", .t. ) }
   ::oGrupoTemporada:Cargo:TextHasta   := {|| oRetFld( ::oGrupoTemporada:Cargo:Hasta, ::oDbfTmp, "cNombre", "Codigo", .t. ) }
   ::oGrupoTemporada:Cargo:HelpDesde   := {|| BrwTemporada( ::oDesde, ::oSayDesde, , .f. ) }
   ::oGrupoTemporada:Cargo:HelpHasta   := {|| BrwTemporada( ::oHasta, ::oSayHasta, , .f. ) }
   ::oGrupoTemporada:Cargo:ValidDesde  := {|oGet| if( cTemporada( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfTmp:cAlias, ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoTemporada:Cargo:ValidHasta  := {|oGet| if( cTemporada( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfTmp:cAlias, ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoTemporada:Cargo:lImprimir   := lImp
   ::oGrupoTemporada:Cargo:cBitmap     := "gc_cloud_sun_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_cloud_sun_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoTemporada )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_cloud_sun_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoTemporada:Cargo:Imagen    := len( ::oImageGroup:aBitmaps ) - 1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoTemporada:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoTemporada )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoTemporada )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfTmp )
         ::oDbfTmp:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoCategoria( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfCat == nil .or. !::oDbfCat:Used()
      DATABASE NEW ::oDbfCat PATH ( cPatEmp() ) FILE "Categorias.DBF" VIA ( cDriver() ) SHARED INDEX "Categorias.Cdx"
   end if

   ::oGrupoCategoria                   := TRGroup():New( {|| ::oDbf:cCodCate }, {|| "Categoría : " + AllTrim( ::oDbf:cCodCate ) }, {|| "Total categoría..." }, {|| 3 }, ::lSalto )

   ::oGrupoCategoria:Cargo             := TItemGroup()
   ::oGrupoCategoria:Cargo:Nombre      := "Categoría"
   ::oGrupoCategoria:Cargo:Expresion   := "cCodCate"
   ::oGrupoCategoria:Cargo:Todos       := .t.
   ::oGrupoCategoria:Cargo:Desde       := Space( 10 )
   ::oGrupoCategoria:Cargo:Hasta       := Replicate( "Z", 10 )
   ::oGrupoCategoria:Cargo:cPicDesde   := "@!"
   ::oGrupoCategoria:Cargo:cPicHasta   := "@!"
   ::oGrupoCategoria:Cargo:TextDesde   := {|| oRetFld( ::oGrupoCategoria:Cargo:Desde, ::oDbfCat, "cNombre", "Codigo", .t. ) }
   ::oGrupoCategoria:Cargo:TextHasta   := {|| oRetFld( ::oGrupoCategoria:Cargo:Hasta, ::oDbfCat, "cNombre", "Codigo", .t. ) }
   ::oGrupoCategoria:Cargo:HelpDesde   := {|| BrwCategoria( ::oDesde, ::oSayDesde, , .f. ) }
   ::oGrupoCategoria:Cargo:HelpHasta   := {|| BrwCategoria( ::oHasta, ::oSayHasta, , .f. ) }
   ::oGrupoCategoria:Cargo:ValidDesde  := {|oGet| if( cCategoria( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoCategoria:Cargo:ValidHasta  := {|oGet| if( cCategoria( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoCategoria:Cargo:lImprimir   := lImp
   ::oGrupoCategoria:Cargo:cBitmap     := "gc_photographic_filters_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_photographic_filters_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoCategoria )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_photographic_filters_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoCategoria:Cargo:Imagen    := len( ::oImageGroup:aBitmaps ) - 1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoCategoria:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoCategoria )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoCategoria )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfCat )
         ::oDbfTmp:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoIva( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfIva == nil .or. !::oDbfIva:Used()
      DATABASE NEW ::oDbfIva PATH ( cPatDat() ) FILE "TIva.Dbf" VIA ( cDriver() ) SHARED INDEX "TIva.Cdx"
   end if

   ::oGrupoIva                  := TRGroup():New( {|| ::oDbf:cCodIva }, {|| "Impuesto : " + AllTrim( ::oDbf:cCodIva ) }, {|| "Total " + cImp() + " : " + ::oDbf:cCodIva }, {|| 3 }, ::lSalto )

   ::oGrupoIva:Cargo            := TItemGroup()
   ::oGrupoIva:Cargo:Nombre     := "Impuesto"
   ::oGrupoIva:Cargo:Expresion  := "cCodIva"
   ::oGrupoIva:Cargo:Todos      := .t.
   ::oGrupoIva:Cargo:Desde      := Space( 1 )            // dbFirst( ::oDbfIva:oDbf, 1 )
   ::oGrupoIva:Cargo:Hasta      := Replicate( "Z", 1 )   // dbLast( ::oDbfIva:oDbf, 1 )
   ::oGrupoIva:Cargo:cPicDesde  := "@!"
   ::oGrupoIva:Cargo:cPicHasta  := "@!"
   ::oGrupoIva:Cargo:HelpDesde  := {|| BrwIva( ::oDesde, ::oDbfIva:cAlias ) }
   ::oGrupoIva:Cargo:HelpHasta  := {|| BrwIva( ::oHasta, ::oDbfIva:cAlias ) }
   ::oGrupoIva:Cargo:TextDesde  := {|| oRetFld( ::oGrupoIva:Cargo:Desde, ::oDbfIva, "DescIva", "Tipo" ) }
   ::oGrupoIva:Cargo:TextHasta  := {|| oRetFld( ::oGrupoIva:Cargo:Hasta, ::oDbfIva, "DescIva", "Tipo" ) }
   ::oGrupoIva:Cargo:ValidDesde := {|oGet| if( cTIva( if( !Empty( oGet ), oGet, ::oDesde ), ::oDbfIva:cAlias ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoIva:Cargo:ValidHasta := {|oGet| if( cTIva( if( !Empty( oGet ), oGet, ::oHasta ), ::oDbfIva:cAlias ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoIva:Cargo:lImprimir  := lImp
   ::oGrupoIva:Cargo:cBitmap    := "gc_moneybag_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoIva:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoIva )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoIva:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoIva:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) - 1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoIva:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoIva )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoIva )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oDbfIva )
         ::oDbfIva:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoEntidadesBancarias( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lImp         := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oCuentasBancarias  := TCuentasBancarias():Create( cPatEmp() )
   ::oCuentasBancarias:OpenFiles()

   ::oGrupoCuentasBancarias                    := TRGroup():New( {|| ::oDbf:cCodBnc }, {|| "Cuenta bancaria : " + AllTrim( ::oDbf:cCodBnc ) + " - " + AllTrim( ::oDbf:cNomBnc ) }, {|| "Total cuenta bancaria..." }, {|| 3 }, ::lSalto )

   ::oGrupoCuentasBancarias:Cargo              := TItemGroup()
   ::oGrupoCuentasBancarias:Cargo:Nombre       := "Cta. bancaria"
   ::oGrupoCuentasBancarias:Cargo:Expresion    := "cCodBnc"
   ::oGrupoCuentasBancarias:Cargo:Todos        := .t.
   ::oGrupoCuentasBancarias:Cargo:Desde        := Space( 3 )            // dbFirst( ::oCuentasBancarias:oDbf, 1 )
   ::oGrupoCuentasBancarias:Cargo:Hasta        := Replicate( "Z", 3 )   // dbLast( ::oCuentasBancarias:oDbf, 1 )
   ::oGrupoCuentasBancarias:Cargo:cPicDesde    := "@!"
   ::oGrupoCuentasBancarias:Cargo:cPicHasta    := "@!"
   ::oGrupoCuentasBancarias:Cargo:HelpDesde    := {|| ::oCuentasBancarias:Buscar( ::oDesde ) }
   ::oGrupoCuentasBancarias:Cargo:HelpHasta    := {|| ::oCuentasBancarias:Buscar( ::oHasta ) }
   ::oGrupoCuentasBancarias:Cargo:TextDesde    := {|| oRetFld( ::oGrupoCuentasBancarias:Cargo:Desde, ::oCuentasBancarias:oDbf, "cNomBnc", "cCodBnc" ) }
   ::oGrupoCuentasBancarias:Cargo:TextHasta    := {|| oRetFld( ::oGrupoCuentasBancarias:Cargo:Hasta, ::oCuentasBancarias:oDbf, "cNomBnc", "cCodBnc" ) }
   ::oGrupoCuentasBancarias:Cargo:ValidDesde   := {|oGet| if( ::oCuentasBancarias:Existe( if( !Empty( oGet ), oGet, ::oDesde ), ::oSayDesde, "cNomBnc", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoCuentasBancarias:Cargo:ValidHasta   := {|oGet| if( ::oCuentasBancarias:Existe( if( !Empty( oGet ), oGet, ::oHasta ), ::oSayHasta, "cNomBnc", .t., .t., "0" ), ( ::ChangeValor(), .t. ), .f. ) }
   ::oGrupoCuentasBancarias:Cargo:lImprimir    := lImp
   ::oGrupoCuentasBancarias:Cargo:cBitmap      := "gc_office_building2_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoCuentasBancarias:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoCuentasBancarias )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoCuentasBancarias:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoCuentasBancarias:Cargo:Imagen := len( ::oImageGroup:aBitmaps ) - 1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoCuentasBancarias:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoCuentasBancarias )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoCuentasBancarias )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !Empty( ::oCuentasBancarias )
         ::oCuentasBancarias:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoNumero( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oGrupoNumero                 := TRGroup():New( {|| ::oDbf:cNumDoc }, {|| "Número : "  }, {|| "Total número : " + ::oDbf:cNumDoc }, {|| 3 }, ::lSalto )

   ::oGrupoNumero:Cargo            := TItemGroup()
   ::oGrupoNumero:Cargo:Nombre     := "Número"
   ::oGrupoNumero:Cargo:Expresion  := "cNumDoc"
   ::oGrupoNumero:Cargo:Todos      := .t.
   ::oGrupoNumero:Cargo:Desde      := Space( 10 )
   ::oGrupoNumero:Cargo:Hasta      := "9999999999"
   ::oGrupoNumero:Cargo:cPicDesde  := "9999999999"
   ::oGrupoNumero:Cargo:cPicHasta  := "9999999999"
   ::oGrupoNumero:Cargo:HelpDesde  := {|| nil }
   ::oGrupoNumero:Cargo:HelpHasta  := {|| nil }
   ::oGrupoNumero:Cargo:TextDesde  := {|| "" }
   ::oGrupoNumero:Cargo:TextHasta  := {|| "" }
   ::oGrupoNumero:Cargo:ValidDesde := {| oGet | if( oGet:VarGet() >= "0" , .t., ( msgStop( "No existe numeración negativa" ), .f. ) ) }
   ::oGrupoNumero:Cargo:ValidHasta := {| oGet | if( oGet:VarGet() >= "0" , .t., ( msgStop( "No existe numeración negativa" ), .f. ) ) }
   ::oGrupoNumero:Cargo:lImprimir  := lImp
   ::oGrupoNumero:Cargo:cBitmap    := "gc_keyboard_key_n_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoNumero:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoNumero )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoNumero:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoNumero:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) - 1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoNumero:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoNumero )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoNumero )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoSerie( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oGrupoSerie                  := TRGroup():New( {|| ::oDbf:cSerDoc }, {|| "Serie : "  }, {|| "Total serie : " + ::oDbf:cSerDoc }, {|| 3 }, ::lSalto )

   ::oGrupoSerie:Cargo            := TItemGroup()
   ::oGrupoSerie:Cargo:Nombre     := "Serie"
   ::oGrupoSerie:Cargo:Expresion  := "cSerDoc"
   ::oGrupoSerie:Cargo:Todos      := .t.
   ::oGrupoSerie:Cargo:Desde      := "A"
   ::oGrupoSerie:Cargo:Hasta      := "Z"
   ::oGrupoSerie:Cargo:cPicDesde  := "@!"
   ::oGrupoSerie:Cargo:cPicHasta  := "@!"
   ::oGrupoSerie:Cargo:HelpDesde  := {|| nil }
   ::oGrupoSerie:Cargo:HelpHasta  := {|| nil }
   ::oGrupoSerie:Cargo:TextDesde  := {|| "" }
   ::oGrupoSerie:Cargo:TextHasta  := {|| "" }
   ::oGrupoSerie:Cargo:ValidDesde := {| oGet | if( oGet:VarGet() >= "A" .and. oGet:VarGet() <= "Z", .t., ( msgStop( "Las series desde deben de estar comprendidas entre la A y la Z" ), .f. ) ) }
   ::oGrupoSerie:Cargo:ValidHasta := {| oGet | if( oGet:VarGet() >= "A" .and. oGet:VarGet() <= "Z", .t., ( msgStop( "Las series hasta deben de estar comprendidas entre la A y la Z" ), .f. ) ) }
   ::oGrupoSerie:Cargo:lImprimir  := lImp
   ::oGrupoSerie:Cargo:cBitmap    := "gc_sort_az_descending_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoSerie:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoSerie )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoSerie:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoSerie:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) - 1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoSerie:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoSerie )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoSerie )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoSufijo( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   ::oGrupoSufijo                  := TRGroup():New( {|| ::oDbf:cSufDoc }, {|| "Delegación : "  }, {|| "Total delegación : " + ::oDbf:cSufDoc }, {|| 3 }, ::lSalto )

   ::oGrupoSufijo:Cargo            := TItemGroup()
   ::oGrupoSufijo:Cargo:Nombre     := "Delegación"
   ::oGrupoSufijo:Cargo:Expresion  := "cSufDoc"
   ::oGrupoSufijo:Cargo:Todos      := .t.
   ::oGrupoSufijo:Cargo:Desde      := Space( 2 )
   ::oGrupoSufijo:Cargo:Hasta      := "ZZ"
   ::oGrupoSufijo:Cargo:cPicDesde  := "@!"
   ::oGrupoSufijo:Cargo:cPicHasta  := "@!"
   ::oGrupoSufijo:Cargo:HelpDesde  := {|| nil }
   ::oGrupoSufijo:Cargo:HelpHasta  := {|| nil }
   ::oGrupoSufijo:Cargo:TextDesde  := {|| "" }
   ::oGrupoSufijo:Cargo:TextHasta  := {|| "" }
   ::oGrupoSufijo:Cargo:ValidDesde := {|| .t. }
   ::oGrupoSufijo:Cargo:ValidHasta := {|| .t. }
   ::oGrupoSufijo:Cargo:lImprimir  := lImp
   ::oGrupoSufijo:Cargo:cBitmap    := "gc_bags_16"

   if !Empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( ::oGrupoSufijo:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoSufijo )

      if !Empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( ::oGrupoSufijo:Cargo:cBitmap ), Rgb( 255, 0, 255 ) )
         ::oGrupoSufijo:Cargo:Imagen  := len( ::oImageGroup:aBitmaps ) - 1
      end if

      if lInitGroup
         if !Empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoSufijo:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoSufijo )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoSufijo )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD lGrupoRemesas( lInitGroup, lImp ) CLASS TNewInfGen

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lImp         := .t.

   BEGIN SEQUENCE

   if ::oDbfRemCli == nil .or. !::oDbfRemCli:Used()
      DATABASE NEW ::oDbfRemCli PATH ( cPatEmp() ) FILE "RemCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "RemCliT.Cdx"
   end if

   ::oGrupoRemesas                   := TRGroup():New( {|| ::oDbf:cCodTmp }, {|| "Remesas : " + alltrim( str( ::oDbf:nNumRem ) ) + " - " + alltrim( ::oDbf:cSufRem ) }, {|| "Total remesa..." }, {|| 3  }, ::lSalto )

   ::oGrupoRemesas:Cargo             := TItemGroup()
   ::oGrupoRemesas:Cargo:Nombre      := getConfigTraslation( "Remesas" )
   ::oGrupoRemesas:Cargo:Expresion   := "nNumRem"
   ::oGrupoRemesas:Cargo:Todos       := .t.

   ::oDbfRemCli:GoTop()
   ::oGrupoRemesas:Cargo:Desde       := ::oDbfRemCli:nNumRem

   ::oDbfRemCli:GoBottom()
   ::oGrupoRemesas:Cargo:Hasta       := ::oDbfRemCli:nNumRem
   
   ::oGrupoRemesas:Cargo:cPicDesde   := "999999999" 
   ::oGrupoRemesas:Cargo:cPicHasta   := "999999999" 
   ::oGrupoRemesas:Cargo:HelpDesde   := {|| nil }
   ::oGrupoRemesas:Cargo:HelpHasta   := {|| nil }
   ::oGrupoRemesas:Cargo:ValidDesde  := {|oGet| lValidRemesaCliente( oGet, ::oDbfRemCli ) }
   ::oGrupoRemesas:Cargo:ValidHasta  := {|oGet| lValidRemesaCliente( oGet, ::oDbfRemCli ) }
   ::oGrupoRemesas:Cargo:lImprimir   := lImp
   ::oGrupoRemesas:Cargo:cBitmap     := "gc_briefcase2_document_16"

   if !empty( ::oImageList )
      ::oImageList:AddMasked( TBitmap():Define( "gc_briefcase2_document_16" ), Rgb( 255, 0, 255 ) )
   end if

   if lInitGroup != nil

      aAdd( ::aSelectionGroup, ::oGrupoRemesas )

      if !empty( ::oImageGroup )
         ::oImageGroup:AddMasked( TBitmap():Define( "gc_briefcase2_document_16" ), Rgb( 255, 0, 255 ) )
         ::oGrupoRemesas:Cargo:Imagen    := len( ::oImageGroup:aBitmaps ) - 1
      end if

      if lInitGroup
         if !empty( ::oColNombre )
            ::oColNombre:AddResource( ::oGrupoRemesas:Cargo:cBitmap )
         end if
         aAdd( ::aInitGroup, ::oGrupoRemesas )
      end if

   end if

   aAdd( ::aSelectionRango, ::oGrupoRemesas )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )

      if !empty( ::oDbfRemCli )
         ::oDbfRemCli:End()
      end if

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD oDefEstados( nIdEstadoUno, nIdEstadoDos, oDlg ) CLASS TNewInfGen

   DEFAULT nIdEstadoUno := 218
   DEFAULT nIdEstadoDos := 219
   DEFAULT oDlg         := ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstadoUno ;
      VAR      ::cEstadoUno ;
      ID       nIdEstadoUno ;
      ITEMS    ::aEstadoUno ;
      OF       oDlg

   REDEFINE COMBOBOX ::oEstadoDos ;
      VAR      ::cEstadoDos ;
      ID       nIdEstadoDos ;
      ITEMS    ::aEstadoDos ;
      OF       oDlg

Return( Self )

//---------------------------------------------------------------------------//

METHOD HideCondiciones() CLASS TNewInfGen

   if !::lDefEstadoUno .and. ValType( ::oEstadoUno ) == "O"
      ::oEstadoUno:Hide()
   end if

   if !::lDefEstadoDos .and. ValType( ::oEstadoDos ) == "O"
      ::oEstadoDos:Hide()
   end if

   if !::lDefCondiciones .and. Valtype( ::oTreeCondiciones ) == "O"
      ::oTreeCondiciones:Hide()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD oDefDesde( nIdDesde, nIdSayDesde, oDlg ) CLASS TNewInfGen

   DEFAULT nIdDesde     := 110
   DEFAULT nIdSayDesde  := 111
   DEFAULT oDlg         := ::oFld:aDialogs[1]

   REDEFINE GET ::oDesde VAR ::cDesde ;
      ID       ( nIdDesde );
      BITMAP   "LUPA" ;
      WHEN     ( !::lTodos );
      OF       oDlg

   REDEFINE GET ::oSayDesde VAR ::cSayDesde ;
      WHEN     .f.;
      ID       ( nIdSayDesde ) ;
      OF       oDlg

Return ( Self )

//---------------------------------------------------------------------------//

METHOD oDefHasta( nIdHasta, nIdSayHasta, oDlg ) CLASS TNewInfGen

   DEFAULT nIdHasta     := 120
   DEFAULT nIdSayHasta  := 121
   DEFAULT oDlg         := ::oFld:aDialogs[1]

   REDEFINE GET ::oHasta VAR ::cHasta ;
      ID       ( nIdHasta );
      BITMAP   "LUPA" ;
      WHEN     ( !::lTodos );
      OF       oDlg

   REDEFINE GET ::oSayHasta VAR ::cSayHasta ;
      WHEN     .f.;
      ID       ( nIdSayHasta );
      OF       oDlg

Return ( Self )

//---------------------------------------------------------------------------//

METHOD oDefTodos( nIdTodos, oDlg ) CLASS TNewInfGen

   DEFAULT nIdTodos     := 140
   DEFAULT oDlg         := ::oFld:aDialogs[1]

   REDEFINE CHECKBOX    ::oTodos ;
      VAR               ::lTodos ;
      ID                ( nIdTodos ) ;
      ON CHANGE         ( ::ChangeValor() );
      OF                oDlg

return ( self )

//---------------------------------------------------------------------------//

METHOD ChangeRango() CLASS TNewInfGen

   local oItemSelect

   if Empty( ::oTreeRango )
      Return ( Self )
   end if 

   oItemSelect          := ::oTreeRango:GetSelected()

   if oItemSelect != nil .and. oItemSelect:ClassName() == "TTVITEM"

      ::lTodos          := ( oItemSelect:Cargo:Cargo:Todos )
      ::cDesde          := ( oItemSelect:Cargo:Cargo:Desde )
      ::cHasta          := ( oItemSelect:Cargo:Cargo:Hasta )

      if !Empty( oItemSelect:Cargo:Cargo:bCondition )

         if !Eval( oItemSelect:Cargo:Cargo:bCondition )

            ::oTodos:Disable()
            ::oDesde:Disable()
            ::oHasta:Disable()

         else

            ::oTodos:Enable()
            ::oDesde:Enable()
            ::oHasta:Enable()

         end if

         ::oDesde:bHelp    := oItemSelect:Cargo:Cargo:HelpDesde
         ::oDesde:bValid   := oItemSelect:Cargo:Cargo:ValidDesde

         ::oHasta:bHelp    := oItemSelect:Cargo:Cargo:HelpHasta
         ::oHasta:bValid   := oItemSelect:Cargo:Cargo:ValidHasta

      else

         ::oTodos:Enable()

         ::oDesde:bHelp             := oItemSelect:Cargo:Cargo:HelpDesde
         ::oDesde:bValid            := oItemSelect:Cargo:Cargo:ValidDesde
         ::oDesde:oGet:Picture      := oItemSelect:Cargo:Cargo:cPicDesde

         ::oHasta:bHelp             := oItemSelect:Cargo:Cargo:HelpHasta
         ::oHasta:bValid            := oItemSelect:Cargo:Cargo:ValidHasta
         ::oHasta:oGet:Picture      := oItemSelect:Cargo:Cargo:cPicHasta

      end if

      ::oTodos:Click( ::lTodos )

      ::oDesde:cText( ::cDesde )
      ::oHasta:cText( ::cHasta )

      ::oDesde:lValid()
      ::oHasta:lValid()

   end if
   
Return( Self )

//---------------------------------------------------------------------------//

METHOD setValor() CLASS TNewInfGen

Return ( self )

//---------------------------------------------------------------------------//

METHOD ChangeValor() CLASS TNewInfGen

   local oItemSelect

   if Empty( ::oTreeRango )
      Return ( self )
   end if 

   oItemSelect       := ::oTreeRango:GetSelected()

   if oItemSelect != nil .and. oItemSelect:ClassName() == "TTVITEM"
      oItemSelect:Cargo:Cargo:Todos  := ::lTodos
      oItemSelect:Cargo:Cargo:Desde  := ::oDesde:VarGet()
      oItemSelect:Cargo:Cargo:Hasta  := ::oHasta:VarGet()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD InitDialog() CLASS TNewInfGen

   local n
   local nPos

   ::HideCondiciones()

   if !Empty( ::aSelectionRango )

      for n := 1 to len( ::aSelectionRango )
         with object ( ::oTreeRango:Add( ::aSelectionRango[ n ]:Cargo:Nombre, n - 1 ) )
            :Cargo := ::aSelectionRango[ n ]
         end with
      next

      /*
      Cargamos el desde hasta con los valores del primer item------------------
      */

      if len( ::oTreeRango:aItems ) > 0
         ::oTreeRango:Select( ::oTreeRango:aItems[ 1 ] )
         ::ChangeRango()
      end if

   end if

   ::oTreeRango:SetImagelist( ::oImageList )

   if !Empty( ::oTreeGroups )
      ::oTreeGroups:SetImagelist( ::oImageGroup )
   end if

   if !Empty( ::oTreeSelectedGroups )
      ::oTreeSelectedGroups:SetImagelist( ::oImageGroup )
   end if

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
   Grupos----------------------------------------------------------------------
   */

   if !Empty( ::aSelectionGroup )
      for n := 1 to len( ::aSelectionGroup )
         with object ( ::oTreeGroups:Add( ::aSelectionGroup[ n ]:Cargo:Nombre, n - 1 ) )
            :Cargo := ::aSelectionGroup[ n ]
         end with
      next
   end if

   if ::oDbfGrp:Seek( Auth():Codigo() + ::cSubTitle )

      while Rtrim( Auth():Codigo() + ::cSubTitle ) == Rtrim( ::oDbfGrp:cCodUse + ::oDbfGrp:cNomInf ) .and. !::oDbfGrp:eof()

         nPos     := aScan( ::aSelectionGroup, {|o| Rtrim( o:Cargo:Nombre ) == Rtrim( ::oDbfGrp:cNomGrp ) } )
         if nPos  != 0
            aAdd( ::aSelectedGroup, ::aSelectionGroup[ nPos ] )
         end if

         ::oDbfGrp:Skip()

      end while

   else

      if !Empty( ::aInitGroup )
         aEval( ::aInitGroup, {| oGroup | aAdd( ::aSelectedGroup, oGroup ) } )
      end if

   end if

   ::ReLoadGroup()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD oDefDesglosar() CLASS TNewInfGen

   ::oDesglosar      := ::oTreeCondiciones:Add( "Desglosar por propiedades y lotes", 0 )

   // TvSetCheckState( ::oTreeCondiciones:hWnd, ::oDesglosar:hItem, .f. )

   ::oTreeCondiciones:SetCheck( ::oDesglosar, .f. ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD oDefLinImporteCero() CLASS TNewInfGen

   ::oLinImporteCero    := ::oTreeCondiciones:Add( "Excluir líneas con importe 0", 0 )

   // TvSetCheckState( ::oTreeCondiciones:hWnd, ::oLinImporteCero:hItem, .t. )

   ::oTreeCondiciones:SetCheck( ::oLinImporteCero, .t. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD oDefDocImporteCero() CLASS TNewInfGen

   ::oDocImporteCero    := ::oTreeCondiciones:Add( "Excluir documentos con importe 0", 0 )

   // TvSetCheckState( ::oTreeCondiciones:hWnd, ::oDocImporteCero:hItem, .t. )

   ::oTreeCondiciones:SetCheck( ::oDocImporteCero, .t. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lIgualCliente()

RETURN ( ::oGrupoCliente:Cargo:Desde == ::oGrupoCliente:Cargo:Hasta )

//---------------------------------------------------------------------------//

METHOD lPeriodoInforme( nId, oDlg ) CLASS TNewInfGen

   DEFAULT nId    := 220
   DEFAULT oDlg   := ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oPeriodo ;
      VAR         ::cPeriodo ;
      ID          nId ;
      ITEMS       ::aPeriodo ;
      OF          oDlg

   ::oPeriodo:bChange   := {|| ::lRecargaFecha() }

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lRecargaFecha() CLASS TNewInfGen

	if empty( ::oIniInf ) .or. empty( ::oFinInf )
		return ( .t. )
	end if

   do case
      case ::cPeriodo == "Hoy"

         ::oIniInf:cText( GetSysDate() )
         ::oFinInf:cText( GetSysDate() )

      case ::cPeriodo == "Ayer"

         ::oIniInf:cText( GetSysDate() -1 )
         ::oFinInf:cText( GetSysDate() -1 )

      case ::cPeriodo == "Mes en curso"

         ::oIniInf:cText( CtoD( "01/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( GetSysDate() )

      case ::cPeriodo == "Mes anterior"

         ::oIniInf:cText( BoM( addMonth( GetSysDate(), -1 ) ) ) 
         ::oFinInf:cText( EoM( addMonth( GetSysDate(), -1 ) ) )

      case ::cPeriodo == "Primer trimestre"

         ::oIniInf:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( CtoD( "31/03/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Segundo trimestre"

         ::oIniInf:cText( CtoD( "01/04/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( CtoD( "30/06/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Tercer trimestre"

         ::oIniInf:cText( CtoD( "01/07/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( CtoD( "30/09/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Cuatro trimestre"

         ::oIniInf:cText( CtoD( "01/10/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Doce últimos meses"

         ::oIniInf:cText( CtoD( Str( Day( GetSysDate() ) ) + "/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) -1 ) ) )
         ::oFinInf:cText( GetSysDate() )

      case ::cPeriodo == "Año en curso"

         ::oIniInf:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Año anterior"

         ::oIniInf:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) - 1 ) ) )
         ::oFinInf:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) - 1 ) ) )

   end case

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lCreaArrayPeriodos() CLASS TNewInfGen

   aAdd( ::aPeriodo, "Hoy" )

   aAdd( ::aPeriodo, "Ayer" )

   aAdd( ::aPeriodo, "Mes en curso" )

   aAdd( ::aPeriodo, "Mes anterior" )

   do case
      case Month( GetSysDate() ) <= 3
         aAdd( ::aPeriodo, "Primer trimestre" )

      case Month( GetSysDate() ) > 3 .and. Month( GetSysDate() ) <= 6
         aAdd( ::aPeriodo, "Primer trimestre" )
         aAdd( ::aPeriodo, "Segundo trimestre" )

      case Month( GetSysDate() ) > 6 .and. Month( GetSysDate() ) <= 9
         aAdd( ::aPeriodo, "Primer trimestre" )
         aAdd( ::aPeriodo, "Segundo trimestre" )
         aAdd( ::aPeriodo, "Tercer trimestre" )

      case Month( GetSysDate() ) > 9 .and. Month( GetSysDate() ) <= 12
         aAdd( ::aPeriodo, "Primer trimestre" )
         aAdd( ::aPeriodo, "Segundo trimestre" )
         aAdd( ::aPeriodo, "Tercer trimestre" )
         aAdd( ::aPeriodo, "Cuatro trimestre" )

   end case

   aAdd( ::aPeriodo, "Doce últimos meses" )

   aAdd( ::aPeriodo, "Año en curso" )

   aAdd( ::aPeriodo, "Año anterior" )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD oDefHoraInicio( nId, oDlg ) CLASS TNewInfGen

   DEFAULT nId       := 1111
   DEFAULT oDlg      := ::oFld:aDialogs[1]

   if Empty( ::cHoraInicio )
      ::cHoraInicio  := uFieldEmpresa( "cIniJor" )
   end if

   REDEFINE GET      ::oHoraInicio ;
      VAR            ::cHoraInicio ;
      PICTURE  "@R 99:99" ;
      SPINNER ;
      ON UP          ( UpTime( ::oHoraInicio ) );
      ON DOWN        ( DwTime( ::oHoraInicio ) );
      VALID          ( validHourMinutes( ::oHoraInicio, .t. ) );
      ID             nId ;
      OF             oDlg

RETURN ( ::oHoraInicio )

//---------------------------------------------------------------------------//

METHOD oDefHoraFin( nId, oDlg ) CLASS TNewInfGen

   DEFAULT nId    := 1121
   DEFAULT oDlg   := ::oFld:aDialogs[1]

   if Empty( ::cHoraFin )
      ::cHoraFin  := "2359"
   end if

   REDEFINE GET   ::oHoraFin ;
      VAR         ::cHoraFin ;
      PICTURE     "@R 99:99" ;
      SPINNER ;
      ON UP       ( UpTime( ::oHoraFin ) );
      ON DOWN     ( DwTime( ::oHoraFin ) );
      VALID       ( validHourMinutes( ::oHoraFin, .t. ) );
      ID          nId ;
      OF          oDlg

RETURN ( ::oHoraFin )

//---------------------------------------------------------------------------//

Method AddVariable() CLASS TNewInfGen

   public dFechaInicio                 := Dtos( ::dIniInf )
   public dFechaFin                    := Dtos( ::dFinInf )

   ::oFastReport:AddVariable(          "Informe",  "Desde fecha",                   "GetHbVar('dFechaInicio')" )
   ::oFastReport:AddVariable(          "Informe",  "Hasta fecha",                   "GetHbVar('dFechaFin')" )

   if !Empty( ::oGrupoFabricante )
      public cGrupoFabricanteDesde     := ::oGrupoFabricante:Cargo:Desde
      public cGrupoFabricanteHasta     := ::oGrupoFabricante:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de fabricante",     "GetHbVar('cGrupoFabricanteDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de fabricante",     "GetHbVar('cGrupoFabricanteHasta')" )
   end if

   if !Empty( ::oGrupoArticulo )
      public cGrupoArticuloDesde       := ::oGrupoArticulo:Cargo:Desde
      public cGrupoArticuloHasta       := ::oGrupoArticulo:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de artículo",       "GetHbVar('cGrupoArticuloDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de artículo",       "GetHbVar('cGrupoArticuloHasta')" )
      ::oFastReport:AddVariable(       "Informe", "Desde nombre de artículo",       "GetHbVar('cGrupoArticuloNombreDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta nombre de artículo",       "GetHbVar('cGrupoArticuloNombreHasta')" )
   end if

   if !Empty( ::oGrupoMateriaPrima )
      public cGrupoMateriaPrimaDesde   := ::oGrupoMateriaPrima:Cargo:Desde
      public cGrupoMateriaPrimaHasta   := ::oGrupoMateriaPrima:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de materia prima",  "GetHbVar('cGrupoMateriaPrimaDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de materia prima",  "GetHbVar('cGrupoMateriaPrimaHasta')" )
   end if

   if !Empty( ::oGrupoCliente )
      public cGrupoClienteDesde        := ::oGrupoCliente:Cargo:Desde
      public cGrupoClienteHasta        := ::oGrupoCliente:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de cliente",        "GetHbVar('cGrupoClienteDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de cliente",        "GetHbVar('cGrupoClienteHasta')" )
      ::oFastReport:AddVariable(       "Informe", "Desde nombre de cliente",        "GetHbVar('cGrupoClienteNombreDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta nombre de cliente",        "GetHbVar('cGrupoClienteNombreHasta')" )
   end if

   if !Empty( ::oGrupoProveedor )

      public cGrupoProveedorDesde      := ::oGrupoProveedor:Cargo:Desde
      public cGrupoProveedorHasta      := ::oGrupoProveedor:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de proveedor",      "GetHbVar('cGrupoProveedorDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de proveedor",      "GetHbVar('cGrupoProveedorHasta')" )

   end if

   if !Empty( ::oGrupoOperacion )
   end if

   if !Empty( ::oGrupoSeccion )
   end if

   if !Empty( ::oGrupoAlmacen )

      public cGrupoAlmacenDesde        := ::oGrupoAlmacen:Cargo:Desde
      public cGrupoAlmacenHasta        := ::oGrupoAlmacen:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde almacen",                  "GetHbVar('cGrupoAlmacenDesde')")
      ::oFastReport:AddVariable(       "Informe", "Hasta almacen",                  "GetHbVar('cGrupoAlmacenHasta')")

   end if

   if !Empty( ::oGrupoMaquina )
   end if

   if !Empty( ::oGrupoOperario )
   end if

   if !Empty( ::oGrupoFpago )
   end if

   if !Empty( ::oGrupoBanco )
   end if

   if !Empty( ::oGrupoAgente )

      public cGrupoAgenteDesde         := ::oGrupoAgente:Cargo:Desde
      public cGrupoAgenteHasta         := ::oGrupoAgente:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de agente",  "GetHbVar('cGrupoAgenteDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de agente",  "GetHbVar('cGrupoAgenteHasta')" )

   end if

   if !Empty( ::oGrupoUsuario )
   end if

   if !Empty( ::oGrupoCaja )
   end if

   if !Empty( ::oGrupoTransportista )

      public cGrupoTransportistaDesde  := ::oGrupoTransportista:Cargo:Desde
      public cGrupoTransportistaHasta  := ::oGrupoTransportista:Cargo:Hasta
      
      ::oFastReport:AddVariable(       "Informe", "Desde código transportista",        "GetHbVar('cGrupoTransportistaDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código transportista",        "GetHbVar('cGrupoTransportistaHasta')" )

      ::oFastReport:AddVariable(       "Informe", "Desde nombre transportista",        "GetHbVar('cGrupoTransportistaNombreDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta nombre transportista",        "GetHbVar('cGrupoTransportistaNombreHasta')" )

   end if

   if !Empty( ::oGrupoGCliente )

      public cGrupoGClienteDesde        := ::oGrupoGCliente:Cargo:Desde
      public cGrupoGClienteHasta        := ::oGrupoGCliente:Cargo:Hasta
      
      ::oFastReport:AddVariable(       "Informe", "Desde código grupo de cliente",        "GetHbVar('cGrupoGClienteDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código grupo de cliente",        "GetHbVar('cGrupoGClienteHasta')" )

      ::oFastReport:AddVariable(       "Informe", "Desde nombre grupo de cliente",        "GetHbVar('cGrupoGClienteNombreDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta nombre grupo de cliente",        "GetHbVar('cGrupoGClienteNombreHasta')" )

   end if

   if !Empty( ::oGrupoGProveedor )
   end if

   if !Empty( ::oGrupoObra )
   end if

   if !Empty( ::oGrupoFamilia )

      public cGrupoFamiliaDesde           := ::oGrupoFamilia:Cargo:Desde
      public cGrupoFamiliaHasta           := ::oGrupoFamilia:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de familia",  "GetHbVar('cGrupoFamiliaDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de familia",  "GetHbVar('cGrupoFamiliaHasta')" )

   end if

   if !Empty( ::oGrupoGFamilia )
   end if

   if !Empty( ::oGrupoTArticulo )

      public cGrupoTArticuloDesde           := ::oGrupoTArticulo:Cargo:Desde
      public cGrupoTArticuloHasta           := ::oGrupoTArticulo:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de tipo de artículo",  "GetHbVar('cGrupoTArticuloDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de tipo de artículo",  "GetHbVar('cGrupoTArticuloHasta')" )

   end if

   if !Empty( ::oGrupoCentroCoste )

      public cGrupoCentroCosteDesde          := ::oGrupoCentroCoste:Cargo:Desde
      public cGrupoCentroCosteHasta          := ::oGrupoCentroCoste:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de centro de coste",  "GetHbVar('cGrupoCentroCosteDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de centro de coste",  "GetHbVar('cGrupoCentroCosteHasta')" )

   end if

   if !Empty( ::oGrupoFabricante )
   end if

   if !Empty( ::oGrupoTOperacion )
   end if

   if !Empty( ::oGrupoEstadoArticulo )

      public cGrupoEstadoArticuloDesde           := ::oGrupoEstadoArticulo:Cargo:Desde
      public cGrupoEstadoArticuloHasta           := ::oGrupoEstadoArticulo:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de estado artículo",  "GetHbVar('cGrupoEstadoArticuloDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de estado artículo",  "GetHbVar('cGrupoEstadoArticuloHasta')" )

   end if

   if !Empty( ::oGrupoRuta )

      public cGrupoRutaDesde           := ::oGrupoRuta:Cargo:Desde
      public cGrupoRutaHasta           := ::oGrupoRuta:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de ruta",  "GetHbVar('cGrupoRutaDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de ruta",  "GetHbVar('cGrupoRutaHasta')" )

   end if

   if !Empty( ::oGrupoFacturas )
   end if

   if !Empty( ::oGrupoFacturasCompras )
   end if

   if !Empty( ::oGrupoTemporada )
      public cGrupoTemporadaDesde           := ::oGrupoTemporada:Cargo:Desde
      public cGrupoTemporadaHasta           := ::oGrupoTemporada:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de temporada",  "GetHbVar('cGrupoTemporadaDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de temporada",  "GetHbVar('cGrupoTemporadaHasta')" )
   end if

   if !Empty( ::oGrupoCategoria )
      public cGrupoCategoriaDesde           := ::oGrupoCategoria:Cargo:Desde
      public cGrupoCategoriaHasta           := ::oGrupoCategoria:Cargo:Hasta

      ::oFastReport:AddVariable(       "Informe", "Desde código de categoría",  "GetHbVar('cGrupoCategoriaDesde')" )
      ::oFastReport:AddVariable(       "Informe", "Hasta código de Categoría",  "GetHbVar('cGrupoCategoriaHasta')" )
   end if

   if !Empty( ::oGrupoIVA )
   end if
   
   if !Empty( ::oGrupoSerie )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method SaveReport() CLASS TNewInfGen

   if ::oDbfInf:Seek( Auth():Codigo() + Upper( ::cSubTitle ) )
      ::oDbfInf:Load()
      ::oDbfInf:cCodUse := Auth():Codigo()
      ::oDbfInf:cNomInf := ::cSubTitle
      ::oDbfInf:Save()
   else
      ::oDbfInf:Append()
      ::oDbfInf:cCodUse := Auth():Codigo()
      ::oDbfInf:cNomInf := ::cSubTitle
      ::oDbfInf:Save()
   end if

RETURN ( ::oFastReport:SaveToBlob( ::oDbfInf:nArea, "mModInf" ) )

//---------------------------------------------------------------------------//

Method MoveReport() CLASS TNewInfGen

   if ::oDbfInf:Seek( Auth():Codigo() + Upper( ::cSubTitle ) )

      ::oDbfInf:Load()

      ::oDbfInf:mOrgInf := ::oDbfInf:mModInf
      ::oDbfInf:Save()

      msgInfo( "El informe ha sido movido al original" )

   else

      msgStop( Auth():Codigo() + Upper( ::cSubTitle ), "No encontrado" )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lHideFecha() CLASS TNewInfGen

   ::oPeriodo:Hide()

   ::oIniInf:Hide()
   ::oFinInf:Hide()

   if IsObject( ::oIniText )
      ::oIniText:Hide()
   end if

   if IsObject( ::oFinText )
      ::oFinText:Hide()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lShowFecha() CLASS TNewInfGen

   ::oPeriodo:Show()

   ::oIniInf:Show()
   ::oFinInf:Show()

   if IsObject( ::oIniText )
      ::oIniText:Show()
   end if

   if IsObject( ::oFinText )
      ::oFinText:Show()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TNewInfGen

   ::Super:End()

   if ::oGrpCli != nil
      ::oGrpCli:CloseService()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetNombreDesdeGrupoCliente() CLASS TNewInfGen
   
   if !Empty( ::oGrupoGCliente:Cargo:Desde )
      public cGrupoGClienteNombreDesde  := oRetFld( ::oGrupoGCliente:Cargo:Desde, ::oGrpCli:oDbf, "CNOMGRP", "CCODGRP" )
   else
      public cGrupoGClienteNombreDesde  := ""
   end if

Return ( cGrupoGClienteNombreDesde )

//---------------------------------------------------------------------------//

METHOD SetNombreHastaGrupoCliente() CLASS TNewInfGen

   if !Empty( ::oGrupoGCliente:Cargo:Hasta )
      public cGrupoGClienteNombreHasta  := oRetFld( ::oGrupoGCliente:Cargo:Hasta, ::oGrpCli:oDbf, "CNOMGRP", "CCODGRP" )
   else
      public cGrupoGClienteNombreHasta  := ""
   end if

Return ( cGrupoGClienteNombreHasta )

//---------------------------------------------------------------------------//

METHOD SetNombreDesdeCliente() CLASS TNewInfGen
   
   if !Empty( ::oGrupoCliente:Cargo:Desde )
      public cGrupoClienteNombreDesde  := oRetFld( ::oGrupoCliente:Cargo:Desde, ::oDbfCli, "TITULO", "COD" )
   else
      public cGrupoClienteNombreDesde  := ""
   end if

Return ( cGrupoClienteNombreDesde )

//---------------------------------------------------------------------------//

METHOD SetNombreHastaCliente() CLASS TNewInfGen

   if !Empty( ::oGrupoCliente:Cargo:Hasta )
      public cGrupoClienteNombreHasta  := oRetFld( ::oGrupoCliente:Cargo:Hasta, ::oDbfCli, "TITULO", "COD" )
   else
      public cGrupoClienteNombreHasta  := ""
   end if

Return ( cGrupoClienteNombreHasta )

//---------------------------------------------------------------------------//

METHOD SetNombreDesdeArticulo() CLASS TNewInfGen
   
   if !Empty( ::oGrupoArticulo:Cargo:Desde )
      public cGrupoArticuloNombreDesde  := oRetFld( ::oGrupoArticulo:Cargo:Desde, ::oDbfArt, "Nombre", "Codigo" )
   else
      public cGrupoArticuloNombreDesde  := ""
   end if

Return ( cGrupoArticuloNombreDesde )

//---------------------------------------------------------------------------//

METHOD SetNombreHastaArticulo() CLASS TNewInfGen

   if !Empty( ::oGrupoArticulo:Cargo:Hasta )
      public cGrupoArticuloNombreHasta  := oRetFld( ::oGrupoArticulo:Cargo:Hasta, ::oDbfArt, "Nombre", "Codigo" )
   else
      public cGrupoArticuloNombreHasta  := ""
   end if

Return ( cGrupoArticuloNombreHasta )

//---------------------------------------------------------------------------//

METHOD SetNombreDesdeTransportista() CLASS TNewInfGen
   
   if !Empty( ::oGrupoTransportista:Cargo:Desde )
      public cGrupoTransportistaNombreDesde  := oRetFld( ::oGrupoTransportista:Cargo:Desde, ::oDbfTrn:oDbf, "cNomTrn", "cCodTrn" )
   else
      public cGrupoTransportistaNombreDesde  := ""
   end if

Return ( cGrupoTransportistaNombreDesde )

//---------------------------------------------------------------------------//

METHOD SetNombreHastaTransportista() CLASS TNewInfGen

   if !Empty( ::oGrupoTransportista:Cargo:Hasta )
      public cGrupoTransportistaNombreHasta  := oRetFld( ::oGrupoTransportista:Cargo:Hasta, ::oDbfTrn:oDbf, "cNomTrn", "cCodTrn" )
   else
      public cGrupoTransportistaNombreHasta  := ""
   end if

Return ( cGrupoTransportistaNombreHasta )

//---------------------------------------------------------------------------//