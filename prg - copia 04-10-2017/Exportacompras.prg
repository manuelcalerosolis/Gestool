#include "FiveWin.ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "XBrowse.ch"

memvar oFacPrvT
memvar oFacPrvL
memvar oDbfArt
memvar oDbfPrv
memvar cPirDiv

//---------------------------------------------------------------------------//

CLASS TExportaCompras FROM TNewInfGen

   DATA nLevel

   DATA cFileTmp        INIT Space( 1 )

   DATA oBrwLin
   DATA oBtnAdd
   DATA oBtnEdit
   DATA oBtnDel
   DATA oBtnUp
   DATA oBtnDown
   DATA oBtnSave
   DATA oBtnLoad

   DATA lSuprEspacios   INIT .t.

   DATA oGetAncho
   DATA oGetExpresion
   DATA oSayExpresion

   DATA oTreeCampos

   DATA aTipoExpresion  INIT  { "Campo", "Expresión", "Constante" }
   DATA oTipoExpresion

   DATA aAlign          INIT  { "Izquierda", "Derecha" }
   DATA oAlign

   DATA aFieldFacT      INIT aItmFacPrv()
   DATA aFieldFacL      INIT aColFacPrv()
   DATA aFieldArt       INIT aItmArt()
   DATA aFieldPrv       INIT aItmPrv()

   DATA lChangeDbf      INIT .f.

   DATA oFacPrvL

   DATA cTextoFinal     INIT ""

   METHOD New( oMenuItem, oWnd )

   METHOD CreateTemporal()

   METHOD Play()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD Activate()

   METHOD InitDialog()

   METHOD Detalle( nMode )

   METHOD EndDetalle( nMode )

   METHOD DelRegTemporal()

   METHOD SetDlgMode( lStart )

   METHOD lCargaTreeCampos()

   METHOD Cancelar()

   METHOD SaveConf()

   METHOD LoadConf()

   METHOD Exportacion()

   METHOD DblClickTree()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oMenuItem, oWndParent ) CLASS TExportaCompras

   DEFAULT oMenuItem    := "01112"
   DEFAULT oWndParent   := GetWndFrame()

   ::nLevel          := nLevelUsr( oMenuItem )

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::oDbf               := nil

RETURN Self

//----------------------------------------------------------------------------//

METHOD Play( uParam ) CLASS TExportaCompras

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   if ::OpenFiles()

      if ::lResource()
         ::Activate()
      end if

   end if

   ::CloseFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateTemporal() CLASS TExportaCompras

   ::cFileTmp       := cGetNewFileName( cPatTmp() + "TExp" )

   DEFINE DATABASE ::oDbf FILE ( ::cFileTmp ) CLASS "TExp" ALIAS "TExp" PATH ( cPatTmp() ) VIA ( cLocalDriver() ) COMMENT "Exportación"

      FIELD NAME "NTIPO"      TYPE "N" LEN   1  DEC 0  COMMENT "Tipo"         OF ::oDbf
      FIELD NAME "CCAMPO"     TYPE "C" LEN  25  DEC 0  COMMENT "Campo"        OF ::oDbf
      FIELD NAME "CDESCRIP"   TYPE "C" LEN 100  DEC 0  COMMENT "Nombre"       OF ::oDbf
      FIELD NAME "CTABLA"     TYPE "C" LEN  25  DEC 0  COMMENT "Alias"        OF ::oDbf
      FIELD NAME "MEXPRE"     TYPE "M" LEN  10  DEC 0  COMMENT "Expresion"    OF ::oDbf
      FIELD NAME "NANCHO"     TYPE "N" LEN   5  DEC 0  COMMENT "Ancho"        OF ::oDbf
      FIELD NAME "NALIGN"     TYPE "N" LEN   1  DEC 0  COMMENT "Alineación"   OF ::oDbf

      INDEX TO ( ::cFileTmp ) TAG ( Str( ::oDbf:Recno() ) ) ON ( Str( ::oDbf:Recno() ) ) COMMENT "Orden" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ::oDbf

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TExportaCompras

   /*
   Creamos la Base de datos temporal-------------------------------------------
   */

   ::CreateTemporal()

   ::oDbf:Activate( .f., .f. )

   DATABASE NEW ::oFacPrvL       PATH ( cPatEmp() ) FILE "FACPRVL.DBF"     VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oDbfDiv        PATH ( cPatDat() ) FILE "DIVISAS.DBF"     VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TExportaCompras

   if ::oDbfRut != nil .and. ::oDbfRut:Used()
      ::oDbfRut:End()
   end if

   if ::oDbfPrv != nil .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if

   if ::oDbfArt != nil .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if ::oFacPrvT != nil .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if ::oFacPrvL != nil .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   if ::oGrpPrv != nil
      ::oGrpPrv:End()
   end if

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oGrpPrv      := nil
   ::oDbfRut      := nil
   ::oDbfPrv      := nil
   ::oDbfArt      := nil
   ::oFacPrvT     := nil
   ::oFacPrvL     := nil
   ::oDbf         := nil
   ::oDbfDiv      := nil

   /*
   Eliminamos la tabla temporal------------------------------------------------
   */

   dbfErase( ::cFileTmp )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TExportaCompras

   ::lNewInforme  := .t.

   /*
   Montamos el array con los periodos para los informes------------------------
   */

   ::lCreaArrayPeriodos()

   DEFINE DIALOG ::oDlg RESOURCE "EXPCOMPRAS" TITLE "Exportación de compras" OF oWnd()

   /*
   Fechas----------------------------------------------------------------------
   */

   ::oDefIniInf( 1110, ::oDlg )

   ::oDefFinInf( 1120, ::oDlg )

   ::lPeriodoInforme( 220, ::oDlg )

   /*
   Tree para montar los desde - hasta------------------------------------------
   */

   ::oImageList                     := TImageList():New( 16, 16 )
   ::oTreeRango                     := TTreeView():Redefine( 100, ::oDlg )
   ::oTreeRango:bChanged            := {|| ::ChangeRango() }
   ::oTreeRango:bLostFocus          := {|| ::ChangeValor() }

   ::oDefTodos( 140, ::oDlg )
   ::oDefDesde( 110, 111, ::oDlg )
   ::oDefHasta( 120, 121, ::oDlg )

   /*
   Montamos los desde - hasta--------------------------------------------------
   */

   ::lGrupoGProveedor()

   ::lGrupoProveedor()

   ::lGrupoArticulo()

   ::lGrupoFacturasCompras()

   /*
   Check para queitar los espacios en blanco-----------------------------------
   */

   REDEFINE CHECKBOX ::lSuprEspacios ;
      ID       150 ;
      OF       ::oDlg

   /*
   Series----------------------------------------------------------------------
   */

   ::oDefSerInf( ::oDlg )

   /*
   Browse para la configuracion del ascii--------------------------------------
   */

   ::oBrwLin                  := IXBrowse():New( ::oDlg )

   ::oBrwLin:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwLin:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oDbf:SetBrowse( ::oBrwLin )

   ::oBrwLin:nMarqueeStyle    := 5
   ::oBrwLin:lHScroll         := .f.

   ::oBrwLin:bLDblClick       := {|| ::Detalle( EDIT_MODE ) }

   ::oBrwLin:CreateFromResource( 400 )

   with object ( ::oBrwLin:AddCol() )
      :cHeader                := "Tipo"
      :bEditValue             := {|| ::aTipoExpresion[ Max( ::oDbf:FieldGetByName( "nTipo" ), 1 ) ] }
      :nWidth                 := 90
   end with

   with object ( ::oBrwLin:AddCol() )
      :cHeader                := "Expresión"
      :bEditValue             := {|| if( ::oDbf:FieldGetByName( "nTipo" ) > 1, ::oDbf:FieldGetByName( "mExpre" ), ::oDbf:FieldGetByName( "cDescrip" ) ) }
      :nWidth                 := 230
   end with

   with object ( ::oBrwLin:AddCol() )
      :cHeader                := "Alineación"
      :bEditValue             := {|| ::aAlign[ Max( ::oDbf:FieldGetByName( "nAlign" ), 1 ) ] }
      :nWidth                 := 80
   end with

   with object ( ::oBrwLin:AddCol() )
      :cHeader                := "Ancho"
      :bEditValue             := {|| ::oDbf:FieldGetByName( "nAncho" ) }
      :nWidth                 := 60
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
   end with

   /*
   Botones para acciones del browse--------------------------------------------
   */

   REDEFINE BUTTON ::oBtnAdd ;
      ID       410 ;
      OF       ::oDlg ;
      ACTION   ( ::Detalle( APPD_MODE ) )

   REDEFINE BUTTON ::oBtnEdit ;
      ID       420 ;
      OF       ::oDlg ;
      ACTION   ( ::Detalle( EDIT_MODE ) )

   REDEFINE BUTTON ::oBtnDel ;
      ID       430 ;
      OF       ::oDlg ;
      ACTION   ( ::DelRegTemporal() )

   REDEFINE BUTTON ::oBtnUp ;
      ID       440 ;
      OF       ::oDlg ;
      ACTION   ( DbSwapUp( ::oDbf:cAlias, ::oBrwLin ) )

   REDEFINE BUTTON ::oBtnDown ;
      ID       450 ;
      OF       ::oDlg ;
      ACTION   ( DbSwapDown( ::oDbf:cAlias, ::oBrwLin ) )

   REDEFINE BUTTON ::oBtnSave ;
      ID       460 ;
      OF       ::oDlg ;
      ACTION   ( ::SaveConf() )

   REDEFINE BUTTON ::oBtnLoad ;
      ID       470 ;
      OF       ::oDlg ;
      ACTION   ( ::LoadConf() )

   /*
   Meter-----------------------------------------------------------------------
   */

   ::oDefMetInf( 1160, ::oDlg )

   ::oMtrInf:nClrText   := rgb( 128,255,0 )
   ::oMtrInf:nClrBar    := rgb( 128,255,0 )
   ::oMtrInf:nClrBText  := rgb( 128,255,0 )

   /*
   Botones generales-----------------------------------------------------------
   */

   REDEFINE BUTTON ::oBtnAction ;
      ID       500 ;
      OF       ::oDlg ;
      ACTION   ( ::Exportacion() )

   REDEFINE BUTTON ::oBtnCancel;
      ID       550;
      OF       ::oDlg ;
      CANCEL ;
      ACTION   ( ::Cancelar() )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TExportaCompras

   local lActivate

   if !Empty( ::oDlg )

      ::oDlg:AddFastKey( VK_F2, {|| ::Detalle( APPD_MODE ) } )
      ::oDlg:AddFastKey( VK_F3, {|| ::Detalle( EDIT_MODE ) } )
      ::oDlg:AddFastKey( VK_F4, {|| ::DelRegTemporal() } )
      ::oDlg:AddFastKey( VK_F5, {|| ::Exportacion() } )

      if ::lNewInforme
         ::oDlg:bStart  := {|| ::InitDialog(), ::lRecargaFecha() }
      end if

      ::oDlg:Activate( , , , .t. )

      lActivate         := ( ::oDlg:nResult == IDOK )

   end if

RETURN ( lActivate )

//---------------------------------------------------------------------------//

METHOD InitDialog() CLASS TExportaCompras

   local n

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Detalle( nMode ) CLASS TExportaCompras

   local oDlg

   do case
      case nMode == APPD_MODE

         ::oDbf:Blank()

         ::oDbf:nTipo   := 1
         ::oDbf:nAncho  := 1
         ::oDbf:nAlign  := 1

      case nMode == EDIT_MODE

         if ::oDbf:RecCount() == 0
            Return .f.
         end if

         ::oDbf:Load()

   end if

   ::lChangeDbf         := .t.

   DEFINE DIALOG oDlg RESOURCE "LEXPTARIFA" TITLE "Exportación de tarifas"

   REDEFINE COMBOBOX ::oTipoExpresion VAR ::oDbf:nTipo ;
      ID          100 ;
      ITEMS       ::aTipoExpresion ;
      OF          oDlg

      ::oTipoExpresion:bChange   := { || ::SetDlgMode( .f. ) }

   REDEFINE GET ::oGetAncho VAR ::oDbf:nAncho ;
      ID          110 ;
      SPINNER;
      PICTURE     "99999";
      OF          oDlg

   ::oTreeCampos                 := TTreeView():Redefine( 120, oDlg )
   ::oTreeCampos:bLDblClick      := {|| ::DblClickTree( nMode, oDlg ) }

   REDEFINE GET ::oGetExpresion VAR ::oDbf:mExpre MEMO ;
      ID          130 ;
      OF          oDlg

   REDEFINE SAY ::oSayExpresion ;
         ID       131 ;
         OF       oDlg

   REDEFINE COMBOBOX ::oAlign VAR ::oDbf:nAlign ;
      ID          140 ;
      ITEMS       ::aAlign ;
      OF          oDlg

   REDEFINE BUTTON ;
      ID          500 ;
      OF          oDlg ;
      ACTION      ( ::EndDetalle( nMode, oDlg ) )

   REDEFINE BUTTON ::oBtnCancel;
      ID          550;
      OF          oDlg ;
      CANCEL ;
      ACTION   ( oDlg:End() )

   oDlg:bStart := {|| ::SetDlgMode( .t.) }

   oDlg:AddFastKey( VK_F5, {|| ::EndDetalle( nMode, oDlg ) } )

   ACTIVATE DIALOG oDlg CENTER

   /*
   Guardamos los resultados finales en la tabla y refrescamos el browse--------
   */

   if oDlg:nResult == IDOK

      do case
         case nMode == APPD_MODE
            ::oDbf:Insert()

         case nMode == EDIT_MODE
            ::oDbf:Save()
      end case

   else
      ::oDbf:Cancel()
   end if

   ::oBrwLin:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DblClickTree( nMode, oDlg ) CLASS TExportaCompras

   local oSelect   := ::oTreeCampos:GetSelected()

   if Len( oSelect:aItems ) != 0
      oSelect:Expand()
   else
      ::EndDetalle( nMode, oDlg )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD EndDetalle( nMode, oDlg ) CLASS TExportaCompras

   local cFieldSelect   := ""
   local nPos

   if ::oDbf:nAncho < 1
      msgStop( "El ancho del campo tiene que ser mayor que 1." )
      ::oGetAncho:SetFocus()
      Return .f.
   end if

   if ::oDbf:nTipo != 1

      if Empty( ::oDbf:mExpre )
         msgStop( "La expresión no puede estar vacía." )
         ::oGetExpresion:SetFocus()
         Return .f.
      end if

   else

      cFieldSelect   := ::oTreeCampos:GetSelText()

      if Empty( cFieldSelect )                                 .or.;
         AllTrim( cFieldSelect ) == "Facturas"                 .or.;
         AllTrim( cFieldSelect ) == "Lineas de facturas"       .or.;
         AllTrim( cFieldSelect ) == "Artículos"                .or.;
         AllTrim( cFieldSelect ) == "Proveedores"
         msgStop( "Tiene que seleccionar un campo." )
         ::oTreeCampos:SetFocus()
         Return .f.
      end if

      /*
      Cargamos los datos de los campos en la tabla-----------------------------
      */

      do case
         case ( nPos := aScan( ::aFieldFacT, {|a| a[5] == cFieldSelect } ) ) != 0

            ::oDbf:cCampo   := ::aFieldFacT[ nPos, 1 ]
            ::oDbf:cDescrip := cFieldSelect
            ::oDbf:cTabla   := "Cabecera"

         case ( nPos := aScan( ::aFieldFacL, {|a| a[5] == cFieldSelect } ) ) != 0

            ::oDbf:cCampo   := ::aFieldFacL[ nPos, 1 ]
            ::oDbf:cDescrip := cFieldSelect
            ::oDbf:cTabla   := "Lineas"

         case ( nPos := aScan( ::aFieldArt, {|a| a[5] == cFieldSelect } ) ) != 0

            ::oDbf:cCampo   := ::aFieldArt[ nPos, 1 ]
            ::oDbf:cDescrip := cFieldSelect
            ::oDbf:cTabla   := "Artículos"

         case ( nPos := aScan( ::aFieldPrv, {|a| a[5] == cFieldSelect } ) ) != 0

            ::oDbf:cCampo   := ::aFieldPrv[ nPos, 1 ]
            ::oDbf:cDescrip := cFieldSelect
            ::oDbf:cTabla   := "Proveedores"

      end case

   end if

   if ::oDbf:nAlign < 1
      ::oDbf:Align          := 1
   end if

   oDlg:End( IDOK )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD SetDlgMode( lStart ) CLASS TExportaCompras

   DEFAULT lStart := .f.

   do case
      case ::oDbf:nTipo <= 1
         ::oGetExpresion:Hide()
         ::oTreeCampos:Show()
         ::oSayExpresion:SetText( "Campo" )
         ::lCargaTreeCampos()

      case ::oDbf:nTipo == 2
         ::oGetExpresion:Show()
         ::oTreeCampos:Hide()
         ::oSayExpresion:SetText( "Expresión" )

      case ::oDbf:nTipo == 3
         ::oGetExpresion:Show()
         ::oTreeCampos:Hide()
         ::oSayExpresion:SetText( "Constante" )

   end case

   /*
   Limpiamos la expresión cuando cambiamos el combo----------------------------
   */

   if !lStart
      ::oGetExpresion:cText( "" )
   end if


Return ( .t. )

//---------------------------------------------------------------------------//

METHOD DelRegTemporal() CLASS TExportaCompras

   ::lChangeDbf   := .t.

   WinDelRec( , ::oDbf:cAlias )

   ::oBrwLin:Refresh()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD lCargaTreeCampos() CLASS TExportaCompras

   local oTree
   local aField

   if ::oTreeCampos != nil

      ::oTreeCampos:DeleteAll()

      /*
      Cargamos proveedores en el tree---------------------------------------------
      */

      oTree    := ::oTreeCampos:Add( "Proveedores" , 0 )

      for each aField in ::aFieldPrv
         if !Empty( aField[ 5 ] )
            oTree:Add( aField[ 5 ], 1 )
         end if
      next

      /*
      Cargamos artículos en el tree--------------------------------------------
      */

      oTree    := ::oTreeCampos:Add( "Artículos" , 0 )

      for each aField in ::aFieldArt
         if !Empty( aField[ 5 ] )
            oTree:Add( aField[ 5 ], 1 )
         end if
      next

      /*
      Cargamos cabeceras de facturas en el tree--------------------------------
      */

      oTree    := ::oTreeCampos:Add( "Facturas" , 0 )

      for each aField in ::aFieldFacT
         if !Empty( aField[ 5 ] )
            oTree:Add( aField[ 5 ], 1 )
         end if
      next

      /*
      Cargamos lineas de facturas en el tree-----------------------------------
      */

      oTree    := ::oTreeCampos:Add( "Lineas de facturas" , 0 )

      for each aField in ::aFieldFacL
         if !Empty( aField[ 5 ] )
            oTree:Add( aField[ 5 ], 1 )
         end if
      next

      ::oTreeCampos:Refresh()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD SaveConf() CLASS TExportaCompras

   local cGetFile
   local nHandle
   local aDir          := {}

   if ::oDbf:RecCount() == 0
      Return .f.
   end if

   cGetFile      := cGetFile( "*.zip", "Seleccione el nombre del fichero a guardar" )

   if Empty( cGetFile )
      Return .f.
   end if

   nHandle := fCreate( cGetFile )
   if nHandle != -1

      if fClose( nHandle ) .and. ( fErase( cGetFile ) == 0 )

         aDir     := Directory( ::cFileTmp + ".*" )

         ::oDbf:Close()

         hb_SetDiskZip( {|| nil } )
         aEval( aDir, { | cName, nIndex | hb_ZipFile( cGetFile, cPatTmp() + cName[ 1 ], 9 ) } )
         hb_gcAll()

         ::oDbf:ReActivate()

         msgInfo( "Documento exportado satisfactoriamente" )

      else

         MsgStop( "Error en la unidad" )

      end if

   else

      MsgStop( "Ruta no válida" )

   end if

   ::oBrwLin:Refresh()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD LoadConf( cGetFile ) CLASS TExportaCompras

   local aFiles      := {}
   local cNameFile

   if Empty( cGetFile )

      cGetFile    := cGetFile( "*.zip", "Selección de fichero" )

      if Empty( cGetFile )
         Return .f.
      end if

   end if

   /*
   Comprobamos que exista el Zip-----------------------------------------------
   */

   if !file( cGetFile )
      MsgStop( "El fichero " + cGetFile + " no existe." )
      Return .f.
   end if

   /*
   Descomprimimos los ficheros cEmpTmp-----------------------------------------
   */

   aFiles            := Hb_GetFilesInZip( cGetFile )

   if !Hb_UnZipFile( cGetFile, , , , cEmpTmp(), aFiles )
      MsgStop( "No se ha descomprimido el fichero " + cGetFile, "Error" )
      Return .f.
   end if

   hb_gcAll()

   /*
   Tomamos el nombre de la tabla para despues utilizarlo-----------------------
   */

   cNameFile         := Left( aFiles[ 1 ], At( ".", aFiles[ 1 ] ) - 1 )

   /*
   Pasamos los valores de una tabla a otra-------------------------------------
   */

   ::oDbf:Zap()
   ::oDbf:AppendFrom( cEmpTmp() + cNameFile + ".Dbf" )
   ::oDbf:ReindexAll()
   ::oDbf:GoTop()

   ::oBrwLin:Refresh()

   /*
   Borramos los ficheros que hemos descomprimidos anteriormente----------------
   */

   EraseFilesInDirectory(cEmpTmp(), cNameFile + ".*" )

   ::lChangeDbf      := .f.

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD Cancelar() CLASS TExportaCompras

   if ::lChangeDbf            .and.;
      ::oDbf:RecCount() != 0  .and.;
      ApoloMsgNoYes(  "¿ Desea guardar los cambios en la configuración de la exportación ?", "Elija una opción" )

      ::SaveConf()

   end if

   ::oDlg:End()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD Exportacion( cGetFile, lOpenResult ) CLASS TExportaCompras

   local nHand
   local cExpHead       := ""
   local cExpLine       := ""
   local uField
   local lFirstLine     := .t.
   local lErrorBlock    := .f.

   DEFAULT lOpenResult  := .t.

   public oFacPrvT      := ::oFacPrvT
   public oFacPrvL      := ::oFacPrvL
   public oDbfArt       := ::oDbfArt
   public oDbfPrv       := ::oDbfPrv
   public cPirDiv       := cPirDiv( cDivEmp(), ::oDbfDiv )

   if ::oDbf:RecCount() == 0
      MsgStop( "Tiene que cargar una configuración" )
      return .f.
   end if

   if Empty( cGetFile )

      cGetFile          := cGetFile( "*.txt", "Selección de fichero" )

   end if

   /*
   Reiniciamos la variable global----------------------------------------------
   */

   ::cTextoFinal     := ""

   /*
   Filtramos las tablas por los desde - hasta ---------------------------------
   */

   ::oFacPrvT:OrdSetFocus( "dFecFac" )
   ::oFacPrvL:OrdSetFocus( "nNumFac" )
   ::oDbfArt:OrdSetFocus( "Codigo" )

   cExpHead          := 'lSndDoc .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::oGrupoFacturasCompras:Cargo:Todos
      cExpHead       += ' .and. cSerFac + Str( nNumFac ) + cSufFac >= "' + ::oGrupoFacturasCompras:Cargo:Desde + '" .and. cSerFac + Str( nNumFac ) + cSufFac <= "' + ::oGrupoFacturasCompras:Cargo:Hasta + '"'
   end if

   if !::oGrupoProveedor:Cargo:Todos
      cExpHead       += ' .and. cCodPrv >= "' + Rtrim( ::oGrupoProveedor:Cargo:Desde ) + '" .and. cCodPrv <= "' + Rtrim( ::oGrupoProveedor:Cargo:Hasta ) + '"'
   end if

   ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   cExpLine          := '!lControl'

   if !::oGrupoArticulo:Cargo:Todos
      cExpLine       += ' .and. cRef >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cRef <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
   end if

   ::oFacPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ), ::oFacPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacPrvT:GoTop()

    while !::oFacPrvT:Eof()

      if lChkSer( ::oFacPrvT:cSerFac, ::aSer )                                                     .and.;
         ( ::oGrupoGProveedor:Cargo:Todos                                                          .or.;
         ( oRetFld( ::oFacPrvT:cCodPrv, ::oDbfPrv, "CCODGRP" ) >= ::oGrupoGProveedor:Cargo:Desde   .and.;
           oRetFld( ::oFacPrvT:cCodPrv, ::oDbfPrv, "CCODGRP" ) <= ::oGrupoGProveedor:Cargo:Hasta ) )

         if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

            while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .and. !::oFacPrvL:eof()

               if ::oDbfArt:Seek( ::oFacPrvL:cRef )

                  ::oDbf:GoTop()

                  while !::oDbf:Eof()

                     /*
                     Montando el texto para el fichero----------------------------
                     */

                     do case

                        /*
                        Campo de la tabla-----------------------------------------
                        */

                        case ::oDbf:nTipo <= 1

                           do case
                              case AllTrim( ::oDbf:cTabla )  == "Cabecera"

                                 if ::oDbf:nAlign <= 1

                                    if ::lSuprEspacios
                                       ::cTextoFinal     += AllTrim( cValToText( ::oFacPrvT:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) )
                                    else
                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oFacPrvT:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) ), ::oDbf:nAncho )
                                    end fi

                                 elseif ::oDbf:nAlign == 2

                                    if ::lSuprEspacios
                                       ::cTextoFinal     += AllTrim( cValToText( ::oFacPrvT:FieldGetByName( AllTrim( ::oDbf:cCampo ), .t. ) ) )
                                    else
                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oFacPrvT:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) ), ::oDbf:nAncho )
                                    end if

                                 end if

                              case AllTrim( ::oDbf:cTabla ) == "Lineas"

                                 if ::oDbf:nAlign <= 1

                                    if ::lSuprEspacios
                                       ::cTextoFinal     += AllTrim( cValToText( ::oFacPrvL:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) )
                                    else
                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oFacPrvL:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) ), ::oDbf:nAncho )
                                    end if

                                 elseif ::oDbf:nAlign == 2

                                    if ::lSuprEspacios
                                       ::cTextoFinal     += AllTrim( cValToText( ::oFacPrvL:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) )
                                    else
                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oFacPrvL:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) ), ::oDbf:nAncho )
                                    end if

                                 end if

                              case AllTrim( ::oDbf:cTabla ) == "Artículos"
                                 
                                 if ::oDbf:nAlign <= 1

                                    if ::lSuprEspacios
                                       ::cTextoFinal     += AllTrim( cValToText( ::oDbfArt:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) )
                                    else
                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oDbfArt:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) ), ::oDbf:nAncho )
                                    end if

                                 elseif ::oDbf:nAlign == 2

                                    if ::lSuprEspacios
                                       ::cTextoFinal     += AllTrim( cValToText( ::oDbfArt:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) )
                                    else
                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oDbfArt:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) ), ::oDbf:nAncho )
                                    end if

                                 end if

                              case AllTrim( ::oDbf:cTabla ) == "Proveedores"

                                 if ::oDbf:nAlign <= 1

                                    if ::lSuprEspacios
                                       ::cTextoFinal     += AllTrim( cValToText( ::oDbfPrv:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) )
                                    else
                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oDbfPrv:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) ), ::oDbf:nAncho )
                                    end if

                                 elseif ::oDbf:nAlign == 2

                                    if ::lSuprEspacios
                                       ::cTextoFinal     += AllTrim( cValToText( ::oDbfPrv:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) )
                                    else
                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oDbfPrv:FieldGetByName( AllTrim( ::oDbf:cCampo ) ), .t. ) ), ::oDbf:nAncho )
                                    end if

                                 end if

                           end case

                        /*
                        Expresion-------------------------------------------------
                        */

                        case ::oDbf:nTipo == 2

                           uField               := bCheck2Block( AllTrim( ::oDbf:mExpre ), lFirstLine )

                           if uField != nil
                              uField            := Eval( uField )
                           else
                              lErrorBlock       := .t.
                           end if

                           if ::oDbf:nAlign <= 1

                              if ::lSuprEspacios
                                 ::cTextoFinal        += AllTrim( cValToText( uField, .t. ) )
                              else
                                 ::cTextoFinal        += Padr( AllTrim( cValToText( uField, .t. ) ), ::oDbf:nAncho )
                              end if

                           elseif ::oDbf:nAlign == 2

                              if ::lSuprEspacios
                                 ::cTextoFinal        += AllTrim( cValToText( uField, .t. ) )
                              else
                                 ::cTextoFinal        += Padl( AllTrim( cValToText( uField, .t. ) ), ::oDbf:nAncho )
                              end if

                           end if

                        /*
                        Constante-------------------------------------------------
                        */

                        case ::oDbf:nTipo >= 3

                           if ::oDbf:nAlign <= 1

                              if ::lSuprEspacios
                                 ::cTextoFinal        += AllTrim( ::oDbf:mExpre )
                              else
                                 ::cTextoFinal        += Padr( AllTrim( ::oDbf:mExpre ), ::oDbf:nAncho )
                              end if

                           elseif ::oDbf:nAlign == 2

                              if ::lSuprEspacios
                                 ::cTextoFinal        += AllTrim( ::oDbf:mExpre )
                              else
                                 ::cTextoFinal        += Padl( AllTrim( ::oDbf:mExpre ), ::oDbf:nAncho )
                              end if

                           end if

                     end if

                     ::oDbf:Skip()

                  end while

                  ::cTextoFinal                 += CRLF

                  lFirstLine                    := .f.

               end if

               ::oFacPrvL:Skip()

            end while

         end if

         /*
         Quitamos la marca para envio------------------------------------------
         */

         ::oFacPrvT:FieldPutByName( "lSndDoc", .f. )

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacPrvT:Lastrec() )

   /*
   Destruimos los filtros creados----------------------------------------------
   */

   ::oFacPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ) )

   ::oFacPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ) )

   if !lErrorBlock

      /*
      Guardamos la el texto en el fichero txt-------------------------------------
      */

      fErase( cGetFile )
      nHand       := fCreate( cGetFile )
      fWrite( nHand, ::cTextoFinal )
      fClose( nHand )

      /*
      Damos la posibilidad de abrir el fichero resultante-------------------------
      */

      if lOpenResult

         if ApoloMsgNoYes( "Proceso de exportación realizado con éxito" + CRLF + ;
                      "¿ Desea abrir el fichero resultante ?", "Elija una opción." )
            ShellExecute( 0, "open", cGetFile, , , 1 )
         end if

      end if

   else

      MsgStop( "Error en el proceso de exportación" )

   end if

   /*
   Refrescamos el browse-------------------------------------------------------
   */

   ::oDbf:GoTop()
   ::oBrwLin:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//