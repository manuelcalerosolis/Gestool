#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//----------------------------------------------------------------------------//

CLASS TSPECIALSEARCHARTICULO

   DATA nView

   DATA oDlg

   DATA oBotonBuscar
   DATA oBotonLimpiar
   DATA oBotonSalir

   DATA oGetArticulo
   DATA oGetTipo
   DATA oGetEstado
   DATA oGetCliente

   DATA cGetArticulo
   DATA cGetTipo
   DATA cGetEstado
   DATA cGetCliente

   DATA oBrwArticulo

   METHOD New

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD Resource()

   METHOD GetArrayNombres( dbf )

   METHOD SearchArticulos()

   METHOD DefaultSelect()

   METHOD cGetWhereSentencia()

   METHOD ReiniciaValores()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( oMenuItem, oWnd ) CLASS TSPECIALSEARCHARTICULO

   local nLevel

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

   // Ejecutamos el resource abriwndo los ficheros-----------------------------

   if ::OpenFiles()

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

   ::nView              := D():CreateView()

   D():EstadoArticulo( ::nView )

   D():TipoArticulos( ::nView )

   D():Articulos( ::nView )

   D():Clientes( ::nView )

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

METHOD Resource() CLASS TSPECIALSEARCHARTICULO

   local oBmp

   ::DefaultSelect()

   DEFINE DIALOG ::oDlg RESOURCE "Buscar_Avanzada" OF oWnd()

      REDEFINE BITMAP oBmp;
         RESOURCE "zoom_in_48" ;
         ID       500 ;
         OF       ::oDlg

      ::oGetArticulo    := TAutoGet():ReDefine( 100, { | u | iif( pcount() == 0, ::cGetArticulo, ::cGetArticulo := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetArticulo",, ::GetArrayNombres( D():Articulos( ::nView ), 1 ),, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, self )} )
      ::oGetTipo        := TAutoGet():ReDefine( 110, { | u | iif( pcount() == 0, ::cGetTipo, ::cGetTipo := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetTipo",, ::GetArrayNombres( D():TipoArticulos( ::nView ) ),, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )
      ::oGetEstado      := TAutoGet():ReDefine( 120, { | u | iif( pcount() == 0, ::cGetEstado, ::cGetEstado := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetEstado",, ::GetArrayNombres( D():EstadoArticulo( ::nView ) ),, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )
      ::oGetCliente     := TAutoGet():ReDefine( 130, { | u | iif( pcount() == 0, ::cGetCliente, ::cGetCliente := u ) }, ::oDlg,,,,,,,,, .f.,,, .f., .f.,,,,,,, "cGetCliente",, ::GetArrayNombres( D():Clientes( ::nView ) ),, 400, {|uDataSource, cData, Self| cfilter( uDataSource, cData, Self )} )

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
      ::oBrwArticulo:cName           := "Articulos.Busqueda avanzada"
      ::oBrwArticulo:lFooter         := .t.
      ::oBrwArticulo:lAutoSort       := .t.

      ::oBrwArticulo:CreateFromResource( 300 )

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Código"
         :bEditValue          := {|| SelectArticulo->Codigo }
         :nWidth              := 120
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Tipo artículo"
         :bEditValue          := {|| SelectArticulo->cNomTip }
         :nWidth              := 200
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Estado"
         :bEditValue          := {|| SelectArticulo->cNombre }
         :nWidth              := 120
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Disponibilidad"
         :bEditValue          := {|| if( SelectArticulo->nDisp == 1, "Disponible", "No disponible" ) }
         :nWidth              := 80
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Ubicación"
         :bEditValue          := {|| SelectArticulo->cDesUbi }
         :nWidth              := 150
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Número S.A.T."
         :bEditValue          := {|| SelectArticulo->cSerSat + "/" + AllTrim( Str( SelectArticulo->nNumSat ) ) + "/" + SelectArticulo->cSufSat }
         :nWidth              := 150
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Fecha"
         :bEditValue          := {|| SelectArticulo->dFecSat }
         :nWidth              := 150
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Cliente"
         :bEditValue          := {|| SelectArticulo->cCodCli }
         :nWidth              := 150
      end with

      with object ( ::oBrwArticulo:AddCol() )
         :cHeader             := "Cliente"
         :bEditValue          := {|| SelectArticulo->Titulo }
         :nWidth              := 150
      end with

      REDEFINE BUTTON ::oBotonSalir;
         ID          IDCANCEL ;
         OF          ::oDlg ;
         CANCEL ;
         ACTION      ( ::oDlg:end() )

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

   while !( dbf )->( Eof() )

      aAdd( aNombres, { ( dbf )->( fieldget( nPosNombre ) ), ( dbf )->( fieldget( nPosCodigo ) ) } )

      ( dbf )->( dbSkip() )

   end while

   ( dbf )->( dbGoTo( nRec ) )

Return aNombres

//---------------------------------------------------------------------------//

METHOD DefaultSelect() CLASS TSPECIALSEARCHARTICULO

   local cSentencia  := ""

   cSentencia        += "SELECT articulos.Codigo, "
   cSentencia        +=        "articulos.cDesUbi, "
   cSentencia        +=        "estadoSat.cNombre, "
   cSentencia        +=        "estadoSat.nDisp, "  
   cSentencia        +=        "tipoArticulo.cCodTip, "
   cSentencia        +=        "tipoArticulo.cNomTip, "
   cSentencia        +=        "lineasSat.dFecSat, "
   cSentencia        +=        "lineasSat.cSerSat, "
   cSentencia        +=        "lineasSat.nNumSat, "
   cSentencia        +=        "lineasSat.cSufSat, "
   cSentencia        +=        "lineasSat.cCodCli, "
   cSentencia        +=        "clientes.Titulo "
   cSentencia        += "FROM " + cPatEmp() + "Articulo articulos "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "EstadoSat estadoSat on articulos.cCodEst = estadoSat.cCodigo "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "TipArt tipoArticulo on articulos.cCodTip = tipoArticulo.cCodTip "
   cSentencia        += "LEFT JOIN ( SELECT cRef, Max(cCodCli) AS cCodCli, MAX(dFecSat) AS dFecSat, Max(cSerSat) AS cSerSat, Max(nNumSat) AS nNumSat, Max(cSufSat) AS cSufSat FROM " + cPatEmp() + "SatCliL GROUP BY cRef ) lineasSat on articulos.Codigo = lineasSat.cRef "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "Client clientes on clientes.cod = lineasSat.cCodCli "

   cSentencia        += "ORDER BY articulos.Codigo"

   if TDataCenter():ExecuteSqlStatement( cSentencia, "SelectArticulo" )
      
      SelectArticulo->( dbGoTop() )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD SearchArticulos() CLASS TSPECIALSEARCHARTICULO

   local cSentencia  := ""

   cSentencia        += "SELECT articulos.Codigo, "
   cSentencia        +=        "articulos.cDesUbi, "
   cSentencia        +=        "estadoSat.cNombre, "
   cSentencia        +=        "estadoSat.nDisp, "  
   cSentencia        +=        "tipoArticulo.cCodTip, "
   cSentencia        +=        "tipoArticulo.cNomTip, "
   cSentencia        +=        "lineasSat.dFecSat, "
   cSentencia        +=        "lineasSat.cSerSat, "
   cSentencia        +=        "lineasSat.nNumSat, "
   cSentencia        +=        "lineasSat.cSufSat, "
   cSentencia        +=        "lineasSat.cCodCli, "
   cSentencia        +=        "clientes.Titulo "
   cSentencia        += "FROM " + cPatEmp() + "Articulo articulos "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "EstadoSat estadoSat on articulos.cCodEst = estadoSat.cCodigo "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "TipArt tipoArticulo on articulos.cCodTip = tipoArticulo.cCodTip "
   cSentencia        += "LEFT JOIN ( SELECT cRef, Max(cCodCli) AS cCodCli, MAX(dFecSat) AS dFecSat, Max(cSerSat) AS cSerSat, Max(nNumSat) AS nNumSat, Max(cSufSat) AS cSufSat FROM " + cPatEmp() + "SatCliL GROUP BY cRef ) lineasSat on articulos.Codigo = lineasSat.cRef "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "Client clientes on clientes.cod = lineasSat.cCodCli "
   cSentencia        += ::cGetWhereSentencia()
   cSentencia        += " ORDER BY articulos.Codigo"

   if TDataCenter():ExecuteSqlStatement( cSentencia, "SelectArticulo" )
      
      ::oBrwArticulo:Refresh()

   end if

   ::ReiniciaValores()

Return ( self )

//---------------------------------------------------------------------------//

METHOD cGetWhereSentencia() CLASS TSPECIALSEARCHARTICULO

   local cSentencia  := ""

   if !Empty( ::cGetArticulo )
      cSentencia     += "articulos.Codigo='" + Padr( ::cGetArticulo, 18 ) + "'"
   end if

   if !Empty( ::cGetTipo )
      cSentencia     += if(!Empty( cSentencia ), " AND ", "" ) + "tipoArticulo.cNomTip='" + Padr( ::cGetTipo, 100 ) + "'"
   end if

   if !Empty( ::cGetEstado ) 
      cSentencia     += if(!Empty( cSentencia ), " AND ", "" ) + "estadoSat.cNombre='" + Padr( ::cGetEstado, 50 ) + "'"
   end if

   if !Empty( ::cGetCliente )
      cSentencia     += if(!Empty( cSentencia ), " AND ", "" ) + "clientes.Titulo='" + Padr( ::cGetCliente, 80 ) + "'" 
   end if

   if !Empty( cSentencia )
      cSentencia     := "WHERE " + cSentencia + space( 1 )
   end if

 Return ( cSentencia )

//---------------------------------------------------------------------------//

METHOD ReiniciaValores() CLASS TSPECIALSEARCHARTICULO

   ::cGetArticulo := Space( 200 )
   ::cGetTipo     := Space( 200 )
   ::cGetCliente  := Space( 200 )
   ::cGetEstado   := Space( 200 )

   ::oGetArticulo:Refresh()
   ::oGetTipo:Refresh()
   ::oGetCliente:Refresh()
   ::oGetEstado:Refresh()

Return ( self )

//---------------------------------------------------------------------------//

Function cFilter( uDataSource, cData, self )

   local aList       := {}

   aEval( uDataSource, {|x| iif( lower( cData ) $ lower( x[1] ), aadd( aList, x ), ) } )

RETURN aList

//---------------------------------------------------------------------------//