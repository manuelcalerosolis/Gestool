#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//----------------------------------------------------------------------------//

CLASS TSpecialSearchArticulo

   DATA nView

   DATA oDlg

   DATA oBotonBuscar
   DATA oBotonLimpiar
   DATA oBotonSalir

   DATA oGetArticulo
   DATA oGetTipo
   DATA oGetEstado
   DATA oGetCliente
   DATA oGetOperario
   DATA oGetRuta
   DATA oGetCodigoCliente

   DATA aArticulo             INIT {}
   DATA aTipo                 INIT {}
   DATA aEstado               INIT {}
   DATA aCliente              INIT {}
   DATA aOperario             INIT {}
   DATA aRuta                 INIT {}
   DATA aCodigoCliente        INIT {}

   DATA cGetArticulo
   DATA cGetTipo
   DATA cGetEstado
   DATA cGetCliente
   DATA cGetOperario
   DATA cGetRuta
   DATA cGetCodigoCliente

   DATA oFecIni
   DATA oFecFin
   DATA dFecIni
   DATA dFecFin

   DATA oPeriodo
   DATA cPeriodo              INIT "Todos"

   DATA oEstadoMaquina
   DATA aEstadoMaquina        INIT { "Disponibles", "No disponibles", "Todas" }
   DATA cEstadoMaquina        INIT "No disponibles"

   DATA hOrders               INIT {   "Código artículo" => "lineasSat.cRef",;
                                       "Contador"        => "lineasSat.nCntAct",;
                                       "S.A.T."          => "lineasSat.cSerSat, lineasSat.nNumSat, lineasSat.cSufSat",;
                                       "Fecha"           => "lineasSat.dFecSat",;
                                       "Código cliente"  => "cabecerasat.cCodCli",;
                                       "Nombre cliente"  => "cabecerasat.cNomCli",;
                                       "Operario"        => "cabecerasat.cCodOpe",;
                                       "Ruta"            => "cabecerasat.cCodRut" }
   DATA cOrderBy              INIT "lineasSat.cRef"

   DATA oExcObsoletos         INIT .t.
   DATA lExcObsoletos         INIT .t.

   DATA oBrwArticulo

   DATA Resolucion

   METHOD New()

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD Resource()

   METHOD GetArraySelectNombreClienteSAT()
   METHOD GetArraySelectCodigosCliente()
   METHOD GetArraySelectArticulo()
   METHOD GetArraySelectTipoArticulo()
   METHOD GetArraySelectEstadoArticulo()
   METHOD GetArraySelectOperarios()
   METHOD GetArraySelectRutas()

   METHOD GetCodigoTipoArticulo()
   METHOD GetCodigoEstadoArticulo()
   METHOD GetCodigoOperario()
   METHOD GetCodigoRuta()

   METHOD SelectArticulo()   
   METHOD SelectDefault()     INLINE ( ::SelectArticulo( .t. ) )

   METHOD cGetWhereSentencia()
   METHOD cGetOrderBy()

   METHOD refreshSearchArticulo( oCol )

   METHOD ReiniciaValores()

   METHOD aCreaArrayPeriodos()

   METHOD lRecargaFecha()

   METHOD cSelectResource()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( oMenuItem, oWnd ) CLASS TSpecialSearchArticulo

   local nLevel
   LOCAL lOpenFiles     := .f.

   DEFAULT  oMenuItem   := "01127"

   // Nivel de usuario---------------------------------------------------------

   nLevel            := nLevelUsr( oMenuItem )

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   // Cerramos todas las ventanas----------------------------------------------

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   ::Resolucion      := GetSysMetrics( 0 )

   // Ejecutamos el resource abriwndo los ficheros-----------------------------

   msgRun( "Abriendo ficheros y cargando valores iniciales.", "Espere por favor...", {|| lOpenfiles := ::OpenFiles() } )

   if lOpenFiles

      ::Resource()

      ::CloseFiles()

   end if

Return .t.

//----------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TSPECIALSEARCHARTICULO

   local oBlock
   local oError
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():EstadoArticulo( ::nView )

      D():TipoArticulos( ::nView )

      D():Articulos( ::nView )

      D():Clientes( ::nView )

      D():Operarios( ::nView )

      D():SatClientes( ::nView )

      D():Ruta( ::nView )

      ::GetArraySelectCodigosCliente()
      ::GetArraySelectNombreClienteSAT()
      ::GetArraySelectArticulo()
      ::GetArraySelectTipoArticulo()
      ::GetArraySelectEstadoArticulo()
      ::GetArraySelectOperarios()
      ::GetArraySelectRutas()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de números de serie" )

      ::CloseFiles()

      lOpenFiles        := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpenfiles )

//----------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TSPECIALSEARCHARTICULO

   D():DeleteView( ::nView )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD cSelectResource() CLASS TSPECIALSEARCHARTICULO

   if ::Resolucion == 1024
      Return "Buscar_Avanzada1024"
   end if

Return ( "Buscar_Avanzada" )

//----------------------------------------------------------------------------//

METHOD Resource() CLASS TSPECIALSEARCHARTICULO

   local oBmp

   DEFINE DIALOG ::oDlg RESOURCE ::cSelectResource() OF oWnd()

      REDEFINE BITMAP oBmp;
         RESOURCE    "gc_zoom_in_48" ;
         ID          500 ;
         TRANSPARENT ;
         OF          ::oDlg

      REDEFINE COMBOBOX ::oEstadoMaquina ;
         VAR         ::cEstadoMaquina ;
         ID          180 ;
         ITEMS       ::aEstadoMaquina() ;
         OF          ::oDlg

      REDEFINE COMBOBOX ::oPeriodo ;
         VAR         ::cPeriodo ;
         ID          150 ;
         ITEMS       ::aCreaArrayPeriodos() ;
         OF          ::oDlg

         ::oPeriodo:bCHange   := {|| ::lRecargaFecha() }

      REDEFINE GET ::oFecIni VAR ::dFecIni;
         ID          160 ;
         SPINNER ;
         OF          ::oDlg

      REDEFINE GET ::oFecFin VAR ::dFecFin;
         ID          170 ;
         SPINNER ;
         OF          ::oDlg

      REDEFINE CHECKBOX ::oExcObsoletos VAR ::lExcObsoletos ;
         ID       310 ;
         OF       ::oDlg

      ::oGetArticulo       := TAutoGet():ReDefine( 100, { | u | iif( pcount() == 0, ::cGetArticulo, ::cGetArticulo := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetArticulo",, ::aArticulo,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, self )} )
      ::oGetTipo           := TAutoGet():ReDefine( 110, { | u | iif( pcount() == 0, ::cGetTipo, ::cGetTipo := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetTipo",, ::aTipo,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )
      ::oGetEstado         := TAutoGet():ReDefine( 120, { | u | iif( pcount() == 0, ::cGetEstado, ::cGetEstado := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetEstado",, ::aEstado,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )
      ::oGetCodigoCliente  := TAutoGet():ReDefine( 320, { | u | iif( pcount() == 0, ::cGetCodigoCliente, ::cGetCodigoCliente := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetCodigoCliente",, ::aCodigoCliente,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )
      ::oGetCliente        := TAutoGet():ReDefine( 130, { | u | iif( pcount() == 0, ::cGetCliente, ::cGetCliente := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetCliente",, ::aCliente,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )
      ::oGetOperario       := TAutoGet():ReDefine( 140, { | u | iif( pcount() == 0, ::cGetOperario, ::cGetOperario := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetOperario",, ::aOperario,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )
      ::oGetRuta           := TAutoGet():ReDefine( 190, { | u | iif( pcount() == 0, ::cGetRuta, ::cGetRuta := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetRuta",, ::aRuta,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )

      REDEFINE BUTTON ::oBotonBuscar ;
         ID          200 ;
         OF          ::oDlg ;
         CANCEL ;
         ACTION      ( ::SelectArticulo() ) 

      REDEFINE BUTTON ::oBotonLimpiar ;
         ID          210 ;
         OF          ::oDlg ;
         CANCEL ;
         ACTION      ( ::ReiniciaValores(), ::SelectDefault(), ::oBrwArticulo:Refresh() )

      ::oBrwArticulo                 := IXBrowse():New( ::oDlg )

      ::oBrwArticulo:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwArticulo:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwArticulo:cAlias          := "SelectArticulo"

      ::oBrwArticulo:nMarqueeStyle   := 6
      ::oBrwArticulo:cName           := "Articulos.Busquedaavanzada"
      ::oBrwArticulo:lFooter         := .t.
      ::oBrwArticulo:lAutoSort       := .t.
      ::oBrwArticulo:nRowHeight      := 20

      //::oBrwArticulo:bDragBegin      := {| nRow, nCol, nKeyFlags| MsgInfo( "bDragBegin" ) }
      //::oBrwArticulo:bLButtonDown    := {| nRow, nCol, nFlags | ::oBrwArticulo:DragBegin( nRow, nCol ) }
      //::oBrwArticulo:bLButtonUp      := {| nRow, nCol, nFlags, self |  }
      //::oBrwArticulo:bDropOver       := {| uDropInfo, nRow, nCol, nKeyFlags| MsgInfo( "bDropOver" ), MsgInfo( nRow, "nRow" ), MsgInfo( nCol, "nCol" ) }

      ::oBrwArticulo:CreateFromResource( 300 )

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Añadir artículo"
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| AppArticulo(), ::oBrwArticulo:Refresh() }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "NEW16" )
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Modificar artículo"
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| EdtArticulo( SelectArticulo->cRef ), ::oBrwArticulo:Refresh() }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "EDIT16" )
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Info artículo"
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| TSpecialInfoArticulo():Run( SelectArticulo->cRef, SelectArticulo->cDetalle ) }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "gc_object_cube_16" )
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader          := "Obsoleto"
         :bEditValue       := {|| SelectArticulo->lObs }
         :nWidth           := 20
         :nHeadBmpNo       := 1
         :SetCheck( { "DEL16", "Nil16" } )
      end with

      with object ( ::oBrwArticulo:AddCol() ) 
         :cHeader             := "Código artículo"
         :bEditValue          := {|| SelectArticulo->cRef }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 120
      end with

      with object ( ::oBrwArticulo:AddCol() ) 
         :cHeader             := "Contador"
         :bEditValue          := {|| if( !Empty( SelectArticulo->nCntAct ), Trans( SelectArticulo->nCntAct, "999999999999" ), "" ) }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 120
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :lHide               := .t.
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Tipo artículo"
         :bEditValue          := {|| SelectArticulo->cCodTip + " - " + retFld( SelectArticulo->cCodTip, D():TipoArticulos( ::nView ) ) }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 220
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Estado"
         :bEditValue          := {|| SelectArticulo->cNombre }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 110
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Disponibilidad"
         :bEditValue          := {|| iif( SelectArticulo->nDisp == 1, "Disponible", "No disponible" ) }
         :nWidth              := 80
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Ubicación"
         :bEditValue          := {|| SelectArticulo->cDesUbi }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 150
         :lHide               := .t.
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Añadir S.A.T."
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| AppSatCli( SelectArticulo->cCodCli, SelectArticulo->cRef ), ::oBrwArticulo:Refresh() }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "NEW16" )
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Modificar S.A.T."
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| EdtSatCli( SelectArticulo->cSerSat + str( SelectArticulo->nNumSat, 9 ) + SelectArticulo->cSufSat ), ::oBrwArticulo:Refresh() }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "EDIT16" )
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "S.A.T."
         :bEditValue          := {|| iif( !empty( SelectArticulo->cSerSat ),;
                                          SelectArticulo->cSerSat + "/" + alltrim( str( SelectArticulo->nNumSat ) ) + "/" + SelectArticulo->cSufSat,;
                                          "" ) }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 90
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| SelectArticulo->dFecSat }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 75
         :nDataStrAlign       := 3
         :nHeadStrAlign       := 3
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Código cliente"
         :bEditValue          := {|| SelectArticulo->cCodCli }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 150
         :lHide               := .t.
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Informe cliente"
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| TSpecialInfoCliente():Run( SelectArticulo->cCodCli, SelectArticulo->cNomCli, SelectArticulo->cRef ) }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "gc_user_16" )
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Nombre cliente"
         :bEditValue          := {|| SelectArticulo->cNomCli }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 150
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Operario"
         :bEditValue          := {|| SelectArticulo->cCodOpe + " - " + retFld( SelectArticulo->cCodOpe, D():Operarios( ::nView ) ) }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 170
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Ruta"
         :bEditValue          := {|| SelectArticulo->cCodRut + " - " + retFld( SelectArticulo->cCodRut, D():Ruta( ::nView ) ) }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 150
      end with

      ::oBrwArticulo:bLDblClick      := {|| EdtArticulo( SelectArticulo->cRef ), ::oBrwArticulo:Refresh() }

      REDEFINE BUTTON ::oBotonSalir;
         ID          IDCANCEL ;
         OF          ::oDlg ;
         CANCEL ;
         ACTION      ( ::oDlg:end() )

      ::oDlg:AddFastKey( VK_F2, {|| AppArticulo(), ::ReiniciaValores(), ::SelectDefault(), ::oBrwArticulo:Refresh() } )   
      ::oDlg:AddFastKey( VK_F3, {|| EdtArticulo( SelectArticulo->Codigo ), ::ReiniciaValores(), ::SelectDefault(), ::oBrwArticulo:Refresh() } )   
      ::oDlg:AddFastKey( VK_F4, {|| ::ReiniciaValores(), ::SelectDefault(), ::oBrwArticulo:Refresh() } )   
      ::oDlg:AddFastKey( VK_F5, {|| ::SelectArticulo() } )

      ::oDlg:bStart  := {|| ::lRecargaFecha() }

      //::oBrwArticulo:Load(),

   ACTIVATE DIALOG ::oDlg CENTER

   if !Empty( oBmp )
      oBmp:End()
   end if
  
RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD GetArraySelectNombreClienteSAT( dbf, nPosNombre, nPosCodigo ) CLASS TSPECIALSEARCHARTICULO

   ::aCliente       := {}

   if TDataCenter():ExecuteSqlStatement( "SELECT cCodCli, cNomCli FROM " + cPatEmp() + "SatCliT GROUP BY cCodCli, cNomCli", "SelectArticulo" )
      SelectArticulo->( dbeval( {|| aAdd( ::aCliente, { SelectArticulo->cNomCli, SelectArticulo->cCodCli } ) } ) )
   end if

Return ::aCliente

//---------------------------------------------------------------------------//

METHOD GetArraySelectCodigosCliente( dbf, nPosNombre, nPosCodigo ) CLASS TSPECIALSEARCHARTICULO

   ::aCodigoCliente       := {}

   if TDataCenter():ExecuteSqlStatement( "SELECT Cod FROM " + cPatEmp() + "Client", "SelectArticulo" )
      SelectArticulo->( dbeval( {|| aAdd( ::aCodigoCliente, { SelectArticulo->Cod, SelectArticulo->Cod } ) } ) )
   end if

Return ::aCodigoCliente

//---------------------------------------------------------------------------//

METHOD GetArraySelectArticulo() CLASS TSPECIALSEARCHARTICULO

   ::aArticulo       := {}

   if TDataCenter():ExecuteSqlStatement( "SELECT Codigo FROM " + cPatEmp() + "Articulo GROUP BY Codigo", "SelectArticulo" )
      SelectArticulo->( dbeval( {|| aAdd( ::aArticulo, { SelectArticulo->Codigo, SelectArticulo->Codigo } ) } ) )
   end if

Return ( ::aArticulo )

//---------------------------------------------------------------------------//

METHOD GetArraySelectTipoArticulo() CLASS TSPECIALSEARCHARTICULO

   ::aTipo           := {}

   if TDataCenter():ExecuteSqlStatement( "SELECT cCodTip, cNomTip FROM " + cPatEmp() + "TipArt GROUP BY cCodTip, cNomTip", "SelectArticulo" )
      SelectArticulo->( dbeval( {|| aAdd( ::aTipo, { SelectArticulo->cNomTip, SelectArticulo->cCodTip } ) } ) )
   end if

Return ( ::aTipo )

//---------------------------------------------------------------------------//

METHOD GetArraySelectEstadoArticulo() CLASS TSPECIALSEARCHARTICULO

   ::aEstado       := {}

   if TDataCenter():ExecuteSqlStatement( "SELECT cCodigo, cNombre FROM " + cPatEmp() + "EstadoSat GROUP BY cCodigo, cNombre", "SelectArticulo" )
      SelectArticulo->( dbeval( {|| aAdd( ::aEstado, { SelectArticulo->cNombre, SelectArticulo->cCodigo } ) } ) )
   end if

Return ( ::aEstado )

//---------------------------------------------------------------------------//

METHOD GetArraySelectOperarios() CLASS TSPECIALSEARCHARTICULO

   ::aOperario       := {}

   if TDataCenter():ExecuteSqlStatement( "SELECT cCodTra, cNomTra FROM " + cPatEmp() + "OpeT GROUP BY cCodTra, cNomTra", "SelectArticulo" )
      SelectArticulo->( dbeval( {|| aAdd( ::aOperario, { SelectArticulo->cNomTra, SelectArticulo->cCodTra } ) } ) )
   end if

Return ( ::aOperario )

//---------------------------------------------------------------------------//

METHOD GetArraySelectRutas() CLASS TSPECIALSEARCHARTICULO

   ::aRuta       := {}

   if TDataCenter():ExecuteSqlStatement( "SELECT cCodRut, cDesRut FROM " + cPatEmp() + "Ruta GROUP BY cCodRut, cDesRut", "SelectArticulo" )
      SelectArticulo->( dbeval( {|| aAdd( ::aRuta, { SelectArticulo->cDesRut, SelectArticulo->cCodRut } ) } ) )
   end if

Return ( ::aRuta )

//---------------------------------------------------------------------------//

METHOD GetCodigoTipoArticulo( cNombre ) CLASS TSPECIALSEARCHARTICULO

   local nPos
   local cCodigo  := ""

   if Len( ::aTipo ) == 0 .or. Empty( cNombre )
      Return cCodigo
   end if

   nPos           := AScan( ::aTipo, { | a | AllTrim( a[ 1 ] ) == AllTrim( cNombre ) } )
   if nPos != 0
      cCodigo     := ::aTipo[ nPos, 2 ]
   end if

Return ( cCodigo )

//---------------------------------------------------------------------------//

METHOD GetCodigoEstadoArticulo( cNombre ) CLASS TSPECIALSEARCHARTICULO
   
   local nPos
   local cCodigo  := ""

   if Len( ::aEstado ) == 0 .or. Empty( cNombre )
      Return cCodigo
   end if

   nPos           := AScan( ::aEstado, { | a | AllTrim( a[ 1 ] ) == AllTrim( cNombre ) } )
   if nPos != 0
      cCodigo     := ::aEstado[ nPos, 2 ]
   end if

Return ( cCodigo )

//---------------------------------------------------------------------------//

METHOD GetCodigoOperario( cNombre ) CLASS TSPECIALSEARCHARTICULO

   local nPos
   local cCodigo  := ""

   if Len( ::aOperario ) == 0 .or. Empty( cNombre )
      Return cCodigo
   end if

   nPos           := AScan( ::aOperario, { | a | AllTrim( a[ 1 ] ) == AllTrim( cNombre ) } )
   if nPos != 0
      cCodigo     := ::aOperario[ nPos, 2 ]
   end if

Return ( cCodigo )

//---------------------------------------------------------------------------//

METHOD GetCodigoRuta( cNombre ) CLASS TSPECIALSEARCHARTICULO
   
   local nPos
   local cCodigo  := ""

   if Len( ::aRuta ) == 0 .or. Empty( cNombre )
      Return cCodigo
   end if

   nPos           := AScan( ::aRuta, { | a | AllTrim( a[ 1 ] ) == AllTrim( cNombre ) } )
   if nPos != 0
      cCodigo     := ::aRuta[ nPos, 2 ]
   end if

Return ( cCodigo )

//---------------------------------------------------------------------------//

METHOD SelectArticulo( lDefault ) CLASS TSPECIALSEARCHARTICULO

   local cSentencia  := ""

   DEFAULT lDefault  := .f.

   cSentencia        += "SELECT lineasSat.cSerSat, "
   cSentencia        +=        "lineasSat.nNumSat, "
   cSentencia        +=        "lineasSat.cSufSat, "
   cSentencia        +=        "lineasSat.cCodCli, "
   cSentencia        +=        "lineasSat.cRef, "
   cSentencia        +=        "lineasSat.cDetalle, "
   cSentencia        +=        "lineasSat.dFecSat, "
   cSentencia        +=        "lineasSat.nCntAct, "
   cSentencia        +=        "lineasSat.cCodTip, "
   cSentencia        +=        "lineasSat.ROWID, "
   cSentencia        +=        "cabeceraSat.cNomCli,"
   cSentencia        +=        "cabeceraSat.cCodOpe, "
   cSentencia        +=        "cabeceraSat.cCodRut, "
   cSentencia        +=        "cabeceraSat.cCodEst, "
   cSentencia        +=        "estadoSat.cNombre, "
   cSentencia        +=        "estadoSat.nDisp, "
   cSentencia        +=        "articulos.lObs "
   cSentencia        += "FROM " + cPatEmp() + "SatCliL lineasSat "
   cSentencia        += "JOIN ( SELECT cREF, Max( dFecSat ) AS dFecSat FROM " + cPatEmp() + "SatCliL GROUP BY cRef ) AS lineasSatFecha "
   cSentencia        += "ON lineasSatFecha.cRef = lineasSat.cRef and lineasSatFecha.dFecSat = lineasSat.dFecSat "
   cSentencia        += "INNER JOIN " + cPatEmp() + "SatCliT cabeceraSat "
   cSentencia        += "ON lineasSat.cSerSat = cabeceraSat.cSerSat and lineasSat.nNumSat = cabeceraSat.nNumSat and lineasSat.cSufSat = cabeceraSat.cSufSat "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "EstadoSat estadoSat on cabeceraSat.cCodEst = estadoSat.cCodigo "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "Articulo articulos on lineasSat.cRef = articulos.Codigo "
   cSentencia        += ::cGetWhereSentencia( lDefault )
   cSentencia        += ::cGetOrderBy()

   LogWrite( cSentencia )

   if TDataCenter():ExecuteSqlStatement( cSentencia, "SelectArticulo" )
      SelectArticulo->( dbGoTop() )
   end if

   if !Empty( ::oBrwArticulo )
      ::oBrwArticulo:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD refreshSearchArticulo( oCol ) CLASS TSPECIALSEARCHARTICULO

   if hhaskey( ::hOrders, oCol:cHeader )
      
      ::cOrderBy              := hget( ::hOrders, oCol:cHeader )

      ::oBrwArticulo:cOrders  := ' '
      oCol:cOrder             := 'A'

      ::SelectArticulo()

   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD cGetWhereSentencia( lDefault ) CLASS TSPECIALSEARCHARTICULO

   local cSentencia  := ""
   
   DEFAULT lDefault  := .f.

   if lDefault
      //cSentencia     := "WHERE lineasSat.cRef IS NOT NULL AND lineasSat.lControl=false AND lineasSat.lTotLin=false AND EstadoSat.nDisp = 9 "
      cSentencia     := "WHERE lineasSat.ROWID = '0' "
      RETURN ( cSentencia )
   END IF

   cSentencia        := "lineasSat.cRef IS NOT NULL AND lineasSat.lControl=false AND lineasSat.lTotLin=false "

   if !Empty( ::cGetArticulo )
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "lineasSat.cRef='" + Padr( ::cGetArticulo, 18 ) + "'"
   end if

   if !Empty( ::cGetTipo )
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "lineasSat.cCodTip='" + ::GetCodigoTipoArticulo( ::cGetTipo ) + "'"
   end if

   if !Empty( ::cGetEstado ) 
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "cabeceraSat.cCodEst='" + ::GetCodigoEstadoArticulo( ::cGetEstado ) + "'"
   end if

   if !Empty( ::cGetCodigoCliente )
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "cabeceraSat.cCodCli='" + Padr( ::cGetCodigoCliente, 12 ) + "'" 
   end if

   if !Empty( ::cGetCliente )
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "cabeceraSat.cNomCli='" + Padr( ::cGetCliente, 80 ) + "'" 
   end if

   if !Empty( ::dFecIni ) .and. !Empty( ::dFecFin ) .and. ( ( ::dFecIni != CtoD( "01/01/2000" ) ) .or. ( ::dFecFin != CtoD( "31/12/3000" ) ) )
      cSentencia  += if( !Empty( cSentencia ), " AND ", "" ) + "lineasSat.dFecSat>='" + dtoc( ::dFecIni ) + "'" 
      cSentencia  += if( !Empty( cSentencia ), " AND ", "" ) + "lineasSat.dFecSat<='" + dtoc( ::dFecFin ) + "'" 
   end if

   if ::oEstadoMaquina:nAt != 3
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "EstadoSat.nDisp=" + AllTrim( Str( ::oEstadoMaquina:nAt ) )
   end if

   if !Empty( ::cGetOperario )
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "cabeceraSat.cCodOpe='" + ::GetCodigoOperario( ::cGetOperario ) + "'" 
   end if

   if !Empty( ::cGetRuta )
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "cabeceraSat.cCodRut='" + ::GetCodigoRuta( ::cGetRuta ) + "'" 
   end if

   if ::lExcObsoletos
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "NOT articulos.lobs" 
   end if

   if !Empty( cSentencia )
      cSentencia     := "WHERE " + cSentencia + space( 1 )
   end if

 Return ( cSentencia )

//---------------------------------------------------------------------------//

METHOD cGetOrderBy() CLASS TSPECIALSEARCHARTICULO

   local cSentencia  := ""

   if !empty( ::cOrderBy )
      cSentencia     := "ORDER BY " + ::cOrderBy 
   else 
      cSentencia     := "ORDER BY lineasSatFecha.cRef"
   end if

Return ( cSentencia )

//---------------------------------------------------------------------------//

METHOD ReiniciaValores() CLASS TSPECIALSEARCHARTICULO

   ::cGetArticulo       := Space( 200 )
   ::cGetTipo           := Space( 200 )
   ::cGetCliente        := Space( 200 )
   ::cGetCodigoCliente  := Space( 200 )
   ::cGetEstado         := Space( 200 )
   ::cGetOperario       := Space( 200 )
   ::cGetRuta           := Space( 200 )

   ::oGetArticulo:Refresh()
   ::oGetTipo:Refresh()
   ::oGetCodigoCliente:Refresh()
   ::oGetCliente:Refresh()
   ::oGetEstado:Refresh()
   ::oGetOperario:Refresh()
   ::oGetRuta:Refresh()

   ::cPeriodo        := "Todos"
   ::oPeriodo:Refresh()

   ::cEstadoMaquina  := "Todas"
   ::oEstadoMaquina:Refresh()

   ::lExcObsoletos   := .t.
   ::oExcObsoletos:Refresh()

   ::lRecargaFecha()

Return ( self )

//---------------------------------------------------------------------------//

METHOD aCreaArrayPeriodos() CLASS TSPECIALSEARCHARTICULO

   local aPeriodo := {}

   aAdd( aPeriodo, "Hoy" )

   aAdd( aPeriodo, "Ayer" )

   aAdd( aPeriodo, "Mes en curso" )

   aAdd( aPeriodo, "Mes anterior" )

   do case
      case Month( GetSysDate() ) <= 3
         aAdd( aPeriodo, "Primer trimestre" )

      case Month( GetSysDate() ) > 3 .and. Month( GetSysDate() ) <= 6
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )

      case Month( GetSysDate() ) > 6 .and. Month( GetSysDate() ) <= 9
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )
         aAdd( aPeriodo, "Tercer trimestre" )

      case Month( GetSysDate() ) > 9 .and. Month( GetSysDate() ) <= 12
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )
         aAdd( aPeriodo, "Tercer trimestre" )
         aAdd( aPeriodo, "Cuatro trimestre" )

   end case

   aAdd( aPeriodo, "Doce últimos meses" )

   aAdd( aPeriodo, "Año en curso" )

   aAdd( aPeriodo, "Año anterior" )

   aAdd( aPeriodo, "Todos" )

Return ( aPeriodo )

//---------------------------------------------------------------------------//

METHOD lRecargaFecha() CLASS TSPECIALSEARCHARTICULO

   do case
      case ::cPeriodo == "Hoy"

         ::oFecIni:cText( GetSysDate() )
         ::oFecFin:cText( GetSysDate() )

      case ::cPeriodo == "Ayer"

         ::oFecIni:cText( GetSysDate() -1 )
         ::oFecFin:cText( GetSysDate() -1 )

      case ::cPeriodo == "Mes en curso"

         ::oFecIni:cText( CtoD( "01/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( GetSysDate() )

      case ::cPeriodo == "Mes anterior"

         ::oFecIni:cText( BoM( AddMonth( GetSysDate(), -1 ) ) )
         ::oFecFin:cText( EoM( AddMonth( GetSysDate(), -1 ) ) )

      case ::cPeriodo == "Primer trimestre"
         
         ::oFecIni:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "31/03/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Segundo trimestre"

         ::oFecIni:cText( CtoD( "01/04/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "30/06/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Tercer trimestre"

         ::oFecIni:cText( CtoD( "01/07/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "30/09/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Cuatro trimestre"

         ::oFecIni:cText( CtoD( "01/10/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Doce últimos meses"

         ::oFecIni:cText( CtoD( Str( Day( GetSysDate() ) ) + "/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) -1 ) ) )
         ::oFecFin:cText( GetSysDate() )

      case ::cPeriodo == "Año en curso"

         ::oFecIni:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Año anterior"

         ::oFecIni:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) - 1 ) ) )
         ::oFecFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) - 1 ) ) )
      
      case ::cPeriodo == "Todos"

         ::oFecIni:cText( CtoD( "01/01/2000" ) ) 
         ::oFecFin:cText( CtoD( "31/12/3000" ) )

   end case

   ::oFecIni:Refresh()
   ::oFecFin:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

Function cFilter( uDataSource, cData, self )

   local aList       := {}

   aEval( uDataSource, {|x| iif( lower( cData ) $ lower( x[1] ), aadd( aList, x ), ) } )

RETURN aList

//---------------------------------------------------------------------------//