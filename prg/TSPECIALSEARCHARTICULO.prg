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

   DATA aArticulo             INIT {}
   DATA aTipo                 INIT {}
   DATA aEstado               INIT {}
   DATA aCliente              INIT {}
   DATA aOperario             INIT {}
   DATA aRuta                 INIT {}

   DATA cGetArticulo
   DATA cGetTipo
   DATA cGetEstado
   DATA cGetCliente
   DATA cGetOperario
   DATA cGetRuta

   DATA oFecIni
   DATA oFecFin
   DATA dFecIni
   DATA dFecFin

   DATA oPeriodo
   DATA cPeriodo              INIT "Todos"

   DATA oEstadoMaquina
   DATA aEstadoMaquina        INIT { "Disponibles", "No disponibles", "Todas" }
   DATA cEstadoMaquina        INIT "No disponibles"

   DATA hOrders               INIT {   "Código artículo" => "articulos.Codigo",;
                                       "Contador"        => "lineasSat.nCntAct",;
                                       "S.A.T."          => "lineasSat.cSerSat, lineasSat.nNumSat, lineasSat.cSufSat",;
                                       "Fecha"           => "lineasSat.dFecSat",;
                                       "Código cliente"  => "cabecerasat.cCodCli",;
                                       "Nombre cliente"  => "cabecerasat.cNomCli",;
                                       "Operario"        => "operario.cNomTra",;
                                       "Rtua"            => "ruta.cDesRut" }
   DATA cOrderBy              INIT "articulos.Codigo"

   DATA oBrwArticulo

   DATA Resolucion

   METHOD New()

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD Resource()

   METHOD GetArrayNombres( dbf )
   METHOD GetArraySelectNombreClienteSAT()
   METHOD GetArraySelectArticulo()

   METHOD SearchArticulos()

   METHOD DefaultSelect()

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

      ::GetArraySelectNombreClienteSAT()
      ::GetArraySelectArticulo()

      ::aTipo           := ::GetArrayNombres( D():TipoArticulos( ::nView ) )
      ::aEstado         := ::GetArrayNombres( D():EstadoArticulo( ::nView ) )
      ::aOperario       := ::GetArrayNombres( D():Operarios( ::nView ) )
      ::aRuta           := ::GetArrayNombres( D():Ruta( ::nView ) )

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

   ::DefaultSelect()

   DEFINE DIALOG ::oDlg RESOURCE ::cSelectResource() OF oWnd()

      REDEFINE BITMAP oBmp;
         RESOURCE "zoom_in_48" ;
         ID       500 ;
         TRANSPARENT ;
         OF       ::oDlg 

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

      ::oGetArticulo := TAutoGet():ReDefine( 100, { | u | iif( pcount() == 0, ::cGetArticulo, ::cGetArticulo := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetArticulo",, ::aArticulo,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, self )} )
      ::oGetTipo     := TAutoGet():ReDefine( 110, { | u | iif( pcount() == 0, ::cGetTipo, ::cGetTipo := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetTipo",, ::aTipo,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )
      ::oGetEstado   := TAutoGet():ReDefine( 120, { | u | iif( pcount() == 0, ::cGetEstado, ::cGetEstado := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetEstado",, ::aEstado,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )
      ::oGetCliente  := TAutoGet():ReDefine( 130, { | u | iif( pcount() == 0, ::cGetCliente, ::cGetCliente := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetCliente",, ::aCliente,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )
      ::oGetOperario := TAutoGet():ReDefine( 140, { | u | iif( pcount() == 0, ::cGetOperario, ::cGetOperario := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetOperario",, ::aOperario,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )
      ::oGetRuta     := TAutoGet():ReDefine( 190, { | u | iif( pcount() == 0, ::cGetRuta, ::cGetRuta := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetRuta",, ::aRuta,, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )

      REDEFINE BUTTON ::oBotonBuscar ;
         ID          200 ;
         OF          ::oDlg ;
         CANCEL ;
         ACTION      ( ::SearchArticulos() ) 

      REDEFINE BUTTON ::oBotonLimpiar ;
         ID          210 ;
         OF          ::oDlg ;
         CANCEL ;
         ACTION      ( ::ReiniciaValores(), ::DefaultSelect(), ::oBrwArticulo:Refresh() )

      ::oBrwArticulo                 := IXBrowse():New( ::oDlg )

      ::oBrwArticulo:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwArticulo:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwArticulo:cAlias          := "SelectArticulo"

      ::oBrwArticulo:nMarqueeStyle   := 6
      ::oBrwArticulo:cName           := "Articulos.Busquedaavanzada"
      ::oBrwArticulo:lFooter         := .t.
      ::oBrwArticulo:lAutoSort       := .t.
      ::oBrwArticulo:nRowHeight      := 20

      ::oBrwArticulo:CreateFromResource( 300 )

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Añadir artículo"
         :bStrData            := {|| "" }
         :bOnPostEdit         := {|| .t. }
         :bEditBlock          := {|| AppArticulo(), ::ReiniciaValores(), ::DefaultSelect(), ::oBrwArticulo:Refresh() }
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
         :bEditBlock          := {|| EdtArticulo( SelectArticulo->Codigo ), ::ReiniciaValores(), ::DefaultSelect(), ::oBrwArticulo:Refresh() }
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
         :bEditBlock          := {|| TSpecialInfoArticulo():Run( SelectArticulo->Codigo, SelectArticulo->Nombre ) }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "Cube_Yellow_16" )
      end with

      with object ( ::oBrwArticulo:AddCol() ) 
         :cHeader             := "Código artículo"
         :bEditValue          := {|| SelectArticulo->Codigo }
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
         :bEditValue          := {|| SelectArticulo->cNomTip }
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
         :bEditBlock          := {|| AppSatCli( SelectArticulo->cCodCli, SelectArticulo->Codigo ), ::ReiniciaValores(), ::DefaultSelect(), ::oBrwArticulo:Refresh() }
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
         :bEditBlock          := {|| EdtSatCli( SelectArticulo->cSerSat + str( SelectArticulo->nNumSat, 9 ) + SelectArticulo->cSufSat ), ::ReiniciaValores(), ::DefaultSelect(), ::oBrwArticulo:Refresh() }
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
         :bEditBlock          := {|| TSpecialInfoCliente():Run( SelectArticulo->cCodCli, SelectArticulo->cNomCli, SelectArticulo->Codigo ) }
         :nEditType           := 5
         :nWidth              := 20
         :nHeadBmpNo          := 1
         :nBtnBmp             := 1
         :nHeadBmpAlign       := 1
         :AddResource( "User1_16" )
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Nombre cliente"
         :bEditValue          := {|| SelectArticulo->cNomCli }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 150
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Operario"
         :bEditValue          := {|| SelectArticulo->cNomTra }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 170
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Ruta"
         :bEditValue          := {|| SelectArticulo->cDesRut }
         :bLClickHeader       := {| nMRow, nMCol, nFlags, oCol | ::refreshSearchArticulo( oCol ) }         
         :nWidth              := 150
      end with

      ::oBrwArticulo:bLDblClick      := {|| EdtArticulo( SelectArticulo->Codigo ), ::ReiniciaValores(), ::DefaultSelect(), ::oBrwArticulo:Refresh() }

      REDEFINE BUTTON ::oBotonSalir;
         ID          IDCANCEL ;
         OF          ::oDlg ;
         CANCEL ;
         ACTION      ( ::oDlg:end() )

      ::oDlg:AddFastKey( VK_F2, {|| AppArticulo(), ::ReiniciaValores(), ::DefaultSelect(), ::oBrwArticulo:Refresh() } )   
      ::oDlg:AddFastKey( VK_F3, {|| EdtArticulo( SelectArticulo->Codigo ), ::ReiniciaValores(), ::DefaultSelect(), ::oBrwArticulo:Refresh() } )   
      ::oDlg:AddFastKey( VK_F4, {|| ::ReiniciaValores(), ::DefaultSelect(), ::oBrwArticulo:Refresh() } )   
      ::oDlg:AddFastKey( VK_F5, {|| ::SearchArticulos() } )   

      ::oDlg:bStart     := {|| ::oBrwArticulo:Load(), ::lRecargaFecha() }

   ACTIVATE DIALOG ::oDlg CENTER

   if !Empty( oBmp )
      oBmp:End()
   end if
  
RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD GetArrayNombres( dbf, nPosNombre, nPosCodigo ) CLASS TSPECIALSEARCHARTICULO

   local nRec           := ( dbf )->( Recno() )
   local aNombres       := {}

   DEFAULT nPosNombre   := 2
   DEFAULT nPosCodigo   := 1

   ( dbf )->( dbGoTop() )

   while !( dbf )->( eof() )
      aAdd( aNombres, { ( dbf )->( fieldget( nPosNombre ) ), ( dbf )->( fieldget( nPosCodigo ) ) } )
      ( dbf )->( dbSkip() )
   end while

   ( dbf )->( dbGoTo( nRec ) )

Return aNombres

//---------------------------------------------------------------------------//

METHOD GetArraySelectNombreClienteSAT( dbf, nPosNombre, nPosCodigo ) CLASS TSPECIALSEARCHARTICULO

   ::aCliente       := {}

   if TDataCenter():ExecuteSqlStatement( "SELECT cCodCli, cNomCli FROM " + cPatEmp() + "SatCliT GROUP BY cCodCli, cNomCli", "SelectArticulo" )
      SelectArticulo->( dbeval( {|| aAdd( ::aCliente, { SelectArticulo->cNomCli, SelectArticulo->cCodCli } ) } ) )
   end if

Return ::aCliente

//---------------------------------------------------------------------------//

METHOD GetArraySelectArticulo() CLASS TSPECIALSEARCHARTICULO

   ::aArticulo       := {}

   if TDataCenter():ExecuteSqlStatement( "SELECT Codigo, Nombre FROM " + cPatEmp() + "Articulo GROUP BY Codigo, Nombre", "SelectArticulo" )
      SelectArticulo->( dbeval( {|| aAdd( ::aArticulo, { SelectArticulo->Nombre, SelectArticulo->Codigo } ) } ) )
   end if

Return ( ::aArticulo )

//---------------------------------------------------------------------------//

METHOD DefaultSelect() CLASS TSPECIALSEARCHARTICULO

   local nSec        := seconds()
   local cSentencia  := ""

   cSentencia        += "SELECT articulos.Codigo, "
   cSentencia        +=        "articulos.Nombre, "
   cSentencia        +=        "articulos.cDesUbi, "
   cSentencia        +=        "estadoSat.cNombre, "
   cSentencia        +=        "estadoSat.nDisp, "  
   cSentencia        +=        "tipoArticulo.cCodTip, "
   cSentencia        +=        "tipoArticulo.cNomTip, "
   cSentencia        +=        "lineasSat.dFecSat, "
   cSentencia        +=        "lineasSat.cSerSat, "
   cSentencia        +=        "lineasSat.nNumSat, "
   cSentencia        +=        "lineasSat.cSufSat, "
   cSentencia        +=        "lineasSat.nCntAct, "
   cSentencia        +=        "cabeceraSat.cCodOpe, "
   cSentencia        +=        "cabeceraSat.cCodCli, "
   cSentencia        +=        "cabeceraSat.cNomCli, "
   cSentencia        +=        "cabeceraSat.cCodRut, "
   cSentencia        +=        "operario.cNomTra, "
   cSentencia        +=        "ruta.cDesRut "
   cSentencia        += "FROM " + cPatEmp() + "Articulo articulos "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "TipArt tipoArticulo on articulos.cCodTip = tipoArticulo.cCodTip "
<<<<<<< HEAD
   cSentencia        += "LEFT JOIN " + cPatEmp() + "SatCliL lineasSat on dFecSat = ( SELECT MAX( dFecSat ) FROM " + cPatEmp() + "SatCliL WHERE cRef = articulos.Codigo ) AND cRef = articulos.Codigo "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "SatCliT cabeceraSat on lineasSat.cSerSat = cabeceraSat.cSerSat AND lineasSat.nNumSat = cabeceraSat.nNumSat AND lineasSat.cSufSat = cabeceraSat.cSufSat "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "OpeT operario on cabeceraSat.cCodOpe = operario.cCodTra "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "Ruta ruta on cabeceraSat.cCodRut = ruta.cCodRut "
   cSentencia        += "WHERE EstadoSat.nDisp = 2 "
=======
   cSentencia        += "LEFT JOIN " + cPatEmp() + "SatCliL lineasSat on dFecSat=(SELECT MAX(dFecSat) FROM " + cPatEmp() + "SatCliL WHERE cRef=articulos.Codigo ) AND cRef = articulos.Codigo "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "SatCliT cabecerasat on lineasSat.cSerSat = cabecerasat.cSerSat AND lineasSat.nNumSat = cabecerasat.nNumSat AND lineasSat.cSufSat = cabecerasat.cSufSat "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "EstadoSat estadoSat on cabeceraSat.cCodEst = estadoSat.cCodigo "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "OpeT operario on cabecerasat.cCodOpe = operario.cCodTra "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "Ruta ruta on cabecerasat.cCodRut = ruta.cCodRut "
   cSentencia        += "WHERE EstadoSat.nDisp=2 "
>>>>>>> origin/master
   cSentencia        += ::cGetOrderBy()

   logWrite( cSentencia )

   if TDataCenter():ExecuteSqlStatement( cSentencia, "SelectArticulo" )
      SelectArticulo->( dbGoTop() )
   end if

   msgAlert( seconds() - nSec )

Return ( self )

//---------------------------------------------------------------------------//

METHOD SearchArticulos() CLASS TSPECIALSEARCHARTICULO

   local cSentencia  := ""

   /*cSentencia        += "SELECT articulos.Codigo, "
   cSentencia        +=        "articulos.Nombre, "
   cSentencia        +=        "articulos.cDesUbi, "
   cSentencia        +=        "estadoSat.cNombre, "
   cSentencia        +=        "estadoSat.nDisp, "
   cSentencia        +=        "tipoArticulo.cCodTip, "
   cSentencia        +=        "tipoArticulo.cNomTip, "
   cSentencia        +=        "lineasSat.dFecSat, "
   cSentencia        +=        "lineasSat.cSerSat, "
   cSentencia        +=        "lineasSat.nNumSat, "
   cSentencia        +=        "lineasSat.cSufSat, "
   cSentencia        +=        "lineasSat.nCntAct, "
   cSentencia        +=        "cabecerasat.cCodOpe, "
   cSentencia        +=        "cabecerasat.cCodCli, "
   cSentencia        +=        "cabecerasat.cNomCli, "
   cSentencia        +=        "cabecerasat.cCodRut, "
   cSentencia        +=        "operario.cNomTra, "
   cSentencia        +=        "ruta.cDesRut "
   cSentencia        += "FROM " + cPatEmp() + "Articulo articulos "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "EstadoSat estadoSat on articulos.cCodEst = estadoSat.cCodigo "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "TipArt tipoArticulo on articulos.cCodTip = tipoArticulo.cCodTip "
   cSentencia        += "LEFT JOIN ( SELECT cRef, Max( nCntAct ) AS nCntAct, MAX(dFecSat) AS dFecSat, Max(cSerSat) AS cSerSat, Max(nNumSat) AS nNumSat, Max(cSufSat) AS cSufSat FROM " + cPatEmp() + "SatCliL GROUP BY cRef ) lineasSat on articulos.Codigo = lineasSat.cRef "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "SatCliT cabecerasat on lineasSat.cSerSat = cabecerasat.cSerSat AND lineasSat.nNumSat = cabecerasat.nNumSat AND lineasSat.cSufSat = cabecerasat.cSufSat "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "OpeT operario on cabecerasat.cCodOpe = operario.cCodTra "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "Ruta ruta on cabecerasat.cCodRut = ruta.cCodRut "
   cSentencia        += ::cGetWhereSentencia()
   cSentencia        += ::cGetOrderBy()*/

   cSentencia        += "SELECT articulos.Codigo, "
   cSentencia        +=        "articulos.Nombre, "
   cSentencia        +=        "articulos.cDesUbi, "
   cSentencia        +=        "estadoSat.cNombre, "
   cSentencia        +=        "estadoSat.nDisp, "
   cSentencia        +=        "tipoArticulo.cCodTip, "
   cSentencia        +=        "tipoArticulo.cNomTip, "
   cSentencia        +=        "lineasSat.dFecSat, "
   cSentencia        +=        "lineasSat.cSerSat, "
   cSentencia        +=        "lineasSat.nNumSat, "
   cSentencia        +=        "lineasSat.cSufSat, "
   cSentencia        +=        "lineasSat.nCntAct, "
   cSentencia        +=        "cabecerasat.cCodOpe, "
   cSentencia        +=        "cabecerasat.cCodCli, "
   cSentencia        +=        "cabecerasat.cNomCli, "
   cSentencia        +=        "cabecerasat.cCodRut, "
   cSentencia        +=        "operario.cNomTra, "
   cSentencia        +=        "ruta.cDesRut "
   cSentencia        += "FROM " + cPatEmp() + "Articulo articulos "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "TipArt tipoArticulo on articulos.cCodTip = tipoArticulo.cCodTip "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "SatCliL lineasSat on dFecSat=(SELECT MAX(dFecSat) FROM " + cPatEmp() + "SatCliL WHERE cRef=articulos.Codigo ) AND cRef = articulos.Codigo "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "SatCliT cabecerasat on lineasSat.cSerSat = cabecerasat.cSerSat AND lineasSat.nNumSat = cabecerasat.nNumSat AND lineasSat.cSufSat = cabecerasat.cSufSat "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "EstadoSat estadoSat on cabeceraSat.cCodEst = estadoSat.cCodigo "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "OpeT operario on cabecerasat.cCodOpe = operario.cCodTra "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "Ruta ruta on cabecerasat.cCodRut = ruta.cCodRut "
   cSentencia        += ::cGetWhereSentencia()
   cSentencia        += ::cGetOrderBy()

   if TDataCenter():ExecuteSqlStatement( cSentencia, "SelectArticulo" ) 
      ::oBrwArticulo:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD refreshSearchArticulo( oCol ) CLASS TSPECIALSEARCHARTICULO

   if hhaskey( ::hOrders, oCol:cHeader )
      
      ::cOrderBy              := hget( ::hOrders, oCol:cHeader )

      ::oBrwArticulo:cOrders  := ' '
      oCol:cOrder             := 'A'

      ::searchArticulos()

   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD cGetWhereSentencia() CLASS TSPECIALSEARCHARTICULO

   local cSentencia  := ""

   if !Empty( ::cGetArticulo )
      cSentencia     += "articulos.Codigo='" + Padr( ::cGetArticulo, 18 ) + "'"
   end if

   if !Empty( ::cGetTipo )
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "tipoArticulo.cNomTip='" + Padr( ::cGetTipo, 100 ) + "'"
   end if

   if !Empty( ::cGetEstado ) 
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "estadoSat.cNombre='" + Padr( ::cGetEstado, 50 ) + "'"
   end if

   if !Empty( ::cGetCliente )
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "cabecerasat.cNomCli='" + Padr( ::cGetCliente, 80 ) + "'" 
   end if

   if !Empty( ::dFecIni ) .and. !Empty( ::dFecFin ) .and. ( ( ::dFecIni != CtoD( "01/01/2000" ) ) .or. ( ::dFecFin != CtoD( "31/12/3000" ) ) )
      cSentencia  += if( !Empty( cSentencia ), " AND ", "" ) + "lineasSat.dFecSat>='" + dtoc( ::dFecIni ) + "'" 
      cSentencia  += if( !Empty( cSentencia ), " AND ", "" ) + "lineasSat.dFecSat<='" + dtoc( ::dFecFin ) + "'" 
   end if

   if ::oEstadoMaquina:nAt != 3
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "EstadoSat.nDisp=" + AllTrim( Str( ::oEstadoMaquina:nAt ) )
   end if

   if !Empty( ::cGetOperario )
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "operario.cNomTra='" + Padr( ::cGetOperario, 35 ) + "'" 
   end if

   if !Empty( ::cGetRuta )
      cSentencia     += if( !Empty( cSentencia ), " AND ", "" ) + "ruta.cDesRut='" + Padr( ::cGetRuta, 30 ) + "'" 
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
      cSentencia     := "ORDER BY articulos.Codigo"
   end if

Return ( cSentencia )

//---------------------------------------------------------------------------//

METHOD ReiniciaValores() CLASS TSPECIALSEARCHARTICULO

   ::cGetArticulo    := Space( 200 )
   ::cGetTipo        := Space( 200 )
   ::cGetCliente     := Space( 200 )
   ::cGetEstado      := Space( 200 )
   ::cGetOperario    := Space( 200 )
   ::cGetRuta        := Space( 200 )

   ::oGetArticulo:Refresh()
   ::oGetTipo:Refresh()
   ::oGetCliente:Refresh()
   ::oGetEstado:Refresh()
   ::oGetOperario:Refresh()
   ::oGetRuta:Refresh()

   ::cPeriodo        := "Todos"
   ::oPeriodo:Refresh()

   ::cEstadoMaquina  := "Todas"
   ::oEstadoMaquina:Refresh()

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