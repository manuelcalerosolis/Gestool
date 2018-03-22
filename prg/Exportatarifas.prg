#include "FiveWin.ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "XBrowse.ch"

memvar oAlbCliT
memvar oAlbCliL
memvar oFacCliT
memvar oFacCliL
memvar oDbfArt
memvar oDbfCli

//---------------------------------------------------------------------------//

CLASS TExportaTarifas FROM TNewInfGen

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

   DATA oGetAncho
   DATA oGetExpresion
   DATA oSayExpresion

   DATA oAlbaran
   DATA lAlbaranes      INIT .t.
   DATA oFactura
   DATA lFacturas       INIT .t.

   DATA oTreeCampos

   DATA aTipoExpresion  INIT  { "Campo", "Expresión", "Constante" }
   DATA oTipoExpresion

   DATA aAlign          INIT  { "Izquierda", "Derecha" }
   DATA oAlign

   DATA aFieldAlbT      INIT aItmAlbCli()
   DATA aFieldAlbL      INIT aColAlbCli()
   DATA aFieldFacT      INIT aItmFacCli()
   DATA aFieldFacL      INIT aColFacCli()
   DATA aFieldArt       INIT aItmArt()
   DATA aFieldCli       INIT aItmCli()

   DATA lChangeDbf      INIT .f.

   DATA oAlbCliT
   DATA oAlbCliL

   DATA oFacCliT
   DATA oFacCliL

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

METHOD New( oMenuItem, oWndParent ) CLASS TExportaTarifas

   DEFAULT oMenuItem    := "01112"
   DEFAULT oWndParent   := GetWndFrame()

   ::nLevel             := nLevelUsr( oMenuItem )

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::oDbf               := nil

RETURN Self

//----------------------------------------------------------------------------//

METHOD Play( uParam ) CLASS TExportaTarifas

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

METHOD CreateTemporal()

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

METHOD OpenFiles() CLASS TExportaTarifas

   /*
   Creamos la Base de datos temporal-------------------------------------------
   */

   ::CreateTemporal()

   ::oDbf:Activate( .f., .f. )

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TExportaTarifas

   if ::oDbfRut != nil .and. ::oDbfRut:Used()
      ::oDbfRut:End()
   end if

   if ::oDbfCli != nil .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if ::oDbfArt != nil .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if ::oAlbCliT != nil .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if ::oAlbCliL != nil .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if ::oFacCliT != nil .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if ::oFacCliL != nil .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if ::oGrpCli != nil
      ::oGrpCli:End()
   end if

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oGrpCli      := nil
   ::oDbfRut      := nil
   ::oDbfCli      := nil
   ::oDbfArt      := nil
   ::oAlbCliT     := nil
   ::oAlbCliL     := nil
   ::oFacCliT     := nil
   ::oFacCliL     := nil
   ::oDbf         := nil

   /*
   Eliminamos la tabla temporal------------------------------------------------
   */

   dbfErase( ::cFileTmp )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TExportaTarifas

   ::lNewInforme  := .t.

   /*
   Montamos el array con los periodos para los informes------------------------
   */

   ::lCreaArrayPeriodos()

   DEFINE DIALOG ::oDlg RESOURCE "EXPTARIFA" TITLE "Exportación de tarifas" OF oWnd()

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

   REDEFINE CHECKBOX ::oAlbaran VAR ::lAlbaranes;
      ID       150 ;
      OF       ::oDlg

   REDEFINE CHECKBOX ::oFactura VAR ::lFacturas;
      ID       160 ;
      OF       ::oDlg

   /*
   Montamos los desde - hasta--------------------------------------------------
   */

   ::lGrupoGrupoCliente()

   ::lGrupoRuta()

   ::lGrupoCliente()

   ::lGrupoArticulo()

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

METHOD Activate() CLASS TExportaTarifas

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

METHOD InitDialog() CLASS TExportaTarifas

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

METHOD Detalle( nMode ) CLASS TExportaTarifas

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

METHOD DblClickTree( nMode, oDlg ) CLASS TExportaTarifas

   local oSelect   := ::oTreeCampos:GetItem()

   if Len( oSelect:aItems ) != 0
      oSelect:Expand()
   else
      ::EndDetalle( nMode, oDlg )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD EndDetalle( nMode, oDlg ) CLASS TExportaTarifas

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

      if Empty( cFieldSelect )                              .or.;
         AllTrim( cFieldSelect ) == "Albaranes"             .or.;
         AllTrim( cFieldSelect ) == "Lineas de albaranes"   .or.;
         AllTrim( cFieldSelect ) == "Facturas"              .or.;
         AllTrim( cFieldSelect ) == "Lineas de facturas"    .or.;
         AllTrim( cFieldSelect ) == "Artículos"             .or.;
         AllTrim( cFieldSelect ) == "Clientes"
         msgStop( "Tiene que seleccionar un campo." )
         ::oTreeCampos:SetFocus()
         Return .f.
      end if

      /*
      Cargamos los datos de los campos en la tabla-----------------------------
      */

      do case
         case ( nPos := aScan( ::aFieldAlbT, {|a| a[5] == cFieldSelect } ) ) != 0

            ::oDbf:cCampo   := ::aFieldAlbT[ nPos, 1 ]
            ::oDbf:cDescrip := cFieldSelect
            ::oDbf:cTabla   := "Cabecera albaran"

         case ( nPos := aScan( ::aFieldAlbL, {|a| a[5] == cFieldSelect } ) ) != 0

            ::oDbf:cCampo   := ::aFieldAlbL[ nPos, 1 ]
            ::oDbf:cDescrip := cFieldSelect
            ::oDbf:cTabla   := "Lineas albaran"

         case ( nPos := aScan( ::aFieldFacT, {|a| a[5] == cFieldSelect } ) ) != 0

            ::oDbf:cCampo   := ::aFieldFacT[ nPos, 1 ]
            ::oDbf:cDescrip := cFieldSelect
            ::oDbf:cTabla   := "Cabecera factura"

         case ( nPos := aScan( ::aFieldFacL, {|a| a[5] == cFieldSelect } ) ) != 0

            ::oDbf:cCampo   := ::aFieldFacL[ nPos, 1 ]
            ::oDbf:cDescrip := cFieldSelect
            ::oDbf:cTabla   := "Lineas factura"   

         case ( nPos := aScan( ::aFieldArt, {|a| a[5] == cFieldSelect } ) ) != 0

            ::oDbf:cCampo   := ::aFieldArt[ nPos, 1 ]
            ::oDbf:cDescrip := cFieldSelect
            ::oDbf:cTabla   := "Artículos"

         case ( nPos := aScan( ::aFieldCli, {|a| a[5] == cFieldSelect } ) ) != 0

            ::oDbf:cCampo   := ::aFieldCli[ nPos, 1 ]
            ::oDbf:cDescrip := cFieldSelect
            ::oDbf:cTabla   := "Clientes"

      end case

   end if

   if ::oDbf:nAlign < 1
      ::oDbf:Align          := 1
   end if

   oDlg:End( IDOK )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD SetDlgMode( lStart ) CLASS TExportaTarifas

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

METHOD DelRegTemporal() CLASS TExportaTarifas

   ::lChangeDbf   := .t.

   WinDelRec( , ::oDbf:cAlias )

   ::oBrwLin:Refresh()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD lCargaTreeCampos() CLASS TExportaTarifas

   local oTree
   local aField

   if ::oTreeCampos != nil

      ::oTreeCampos:DeleteAll()

      /*
      Cargamos clientes en el tree---------------------------------------------
      */

      oTree    := ::oTreeCampos:Add( "Clientes" , 0 )

      for each aField in ::aFieldCli
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

      /*
      Cargamos cabeceras de albaranes en el tree-------------------------------
      */

      oTree    := ::oTreeCampos:Add( "Albaranes" , 0 )

      for each aField in ::aFieldAlbT
         if !Empty( aField[ 5 ] )
            oTree:Add( aField[ 5 ], 1 )
         end if
      next

      /*
      Cargamos lineas de albaranes en el tree----------------------------------
      */

      oTree    := ::oTreeCampos:Add( "Lineas de albaranes" , 0 )

      for each aField in ::aFieldAlbL
         if !Empty( aField[ 5 ] )
            oTree:Add( aField[ 5 ], 1 )
         end if
      next

      ::oTreeCampos:Refresh()

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD SaveConf() CLASS TExportaTarifas

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

METHOD LoadConf() CLASS TExportaTarifas

   local cGetFile    := cGetFile( "*.zip", "Selección de fichero" )
   local aFiles      := {}
   local cNameFile

   if Empty( cGetFile )
      Return .f.
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

METHOD Cancelar() CLASS TExportaTarifas

   if ::lChangeDbf            .and.;
      ::oDbf:RecCount() != 0  .and.;
      ApoloMsgNoYes(  "¿ Desea guardar los cambios en la configuración de la exportación ?", "Elija una opción" )

      ::SaveConf()

   end if

   ::oDlg:End()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD Exportacion() CLASS TExportaTarifas

   local nHand
   local cExpHead    := ""
   local cExpLine    := ""
   local cGetFile
   local uField
   local lFirstLine  := .t.
   local lErrorBlock := .f.

   public oAlbCliT   := ::oAlbCliT
   public oAlbCliL   := ::oAlbCliL
   public oFacCliT   := ::oFacCliT
   public oFacCliL   := ::oFacCliL
   public oDbfArt    := ::oDbfArt
   public oDbfCli    := ::oDbfCli

   if ::oDbf:RecCount() == 0
      MsgStop( "Tiene que cargar una configuración" )
      return .f.
   end if

   cGetFile          := cGetFile( "*.txt", "Selección de fichero" )

   if Empty( cGetFile )
      return .f.
   end if

   /*
   Reiniciamos la variable global----------------------------------------------
   */

   ::cTextoFinal     := ""

   if ::lAlbaranes

      /*
      Filtramos las tablas por los desde - hasta ---------------------------------
      */

      ::oAlbCliT:OrdSetFocus( "dFecAlb" )
      ::oAlbCliL:OrdSetFocus( "nNumAlb" )
      ::oDbfArt:OrdSetFocus( "Codigo" )

      cExpHead          := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

      if !::oGrupoRuta:Cargo:Todos
         cExpHead       += ' .and. cCodRut >= "' + Rtrim( ::oGrupoRuta:Cargo:Desde ) + '" .and. cCodRut <= "' + Rtrim( ::oGrupoRuta:Cargo:Hasta ) + '"'
      end if

      if !::oGrupoCliente:Cargo:Todos
         cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde ) + '" .and. cCodCli <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
      end if

      ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

      cExpLine          := '!lTotLin .and. !lControl'

      if !::oGrupoArticulo:Cargo:Todos
         cExpLine       += ' .and. cRef >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cRef <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
      end if

      ::oAlbCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

      ::oAlbCliT:GoTop()

      while !::oAlbCliT:Eof()

         if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )                                         .and.;
            ( ::oGrupoGCliente:Cargo:Todos                                                .or.;
            ( cGruCli( ::oAlbCliT:cCodCli, ::oDbfCli ) >= ::oGrupoGCliente:Cargo:Desde    .and.;
            cGruCli( ::oAlbCliT:cCodCli, ::oDbfCli ) <= ::oGrupoGCliente:Cargo:Hasta ) )

            if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

               while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .and. !::oAlbCliL:eof()

                  if ::oDbfArt:Seek( ::oAlbCliL:cRef )

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
                                 case AllTrim( ::oDbf:cTabla )  == "Cabecera albaran"

                                    if ::oDbf:nAlign <= 1

                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oAlbCliT:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    elseif ::oDbf:nAlign == 2

                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oAlbCliT:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    end if

                                 case AllTrim( ::oDbf:cTabla ) == "Lineas albaran"

                                    if ::oDbf:nAlign <= 1

                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oAlbCliL:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    elseif ::oDbf:nAlign == 2

                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oAlbCliL:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    end if

                                 case AllTrim( ::oDbf:cTabla ) == "Artículos"

                                    if ::oDbf:nAlign <= 1

                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oDbfArt:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    elseif ::oDbf:nAlign == 2

                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oDbfArt:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    end if

                                 case AllTrim( ::oDbf:cTabla ) == "Clientes"

                                    if ::oDbf:nAlign <= 1

                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oDbfCli:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    elseif ::oDbf:nAlign == 2

                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oDbfCli:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

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

                                 ::cTextoFinal        += Padr( AllTrim( cValToText( uField ) ), ::oDbf:nAncho )

                              elseif ::oDbf:nAlign == 2

                                 ::cTextoFinal        += Padl( AllTrim( cValToText( uField ) ), ::oDbf:nAncho )

                              end if

                           /*
                           Constante-------------------------------------------------
                           */

                           case ::oDbf:nTipo >= 3

                              if ::oDbf:nAlign <= 1

                                 ::cTextoFinal        += Padr( AllTrim( ::oDbf:mExpre ), ::oDbf:nAncho )

                              elseif ::oDbf:nAlign == 2

                                 ::cTextoFinal        += Padl( AllTrim( ::oDbf:mExpre ), ::oDbf:nAncho )

                              end if

                        end case

                        ::oDbf:Skip()

                     end while

                     ::cTextoFinal                 += CRLF

                     lFirstLine                    := .f.

                  end if

                  ::oAlbCliL:Skip()

               end while

            end if

         end if

         ::oAlbCliT:Skip()

         ::oMtrInf:AutoInc()

      end while

      ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

      /*
      Destruimos los filtros creados----------------------------------------------
      */

      ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )

      ::oAlbCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ) )

   end if   

   if ::lFacturas

      /*
      Filtramos las tablas por los desde - hasta ---------------------------------
      */

      ::oFacCliT:OrdSetFocus( "dFecFac" )
      ::oFacCliL:OrdSetFocus( "nNumFac" )
      ::oDbfArt:OrdSetFocus( "Codigo" )

      cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

      if !::oGrupoRuta:Cargo:Todos
         cExpHead       += ' .and. cCodRut >= "' + Rtrim( ::oGrupoRuta:Cargo:Desde ) + '" .and. cCodRut <= "' + Rtrim( ::oGrupoRuta:Cargo:Hasta ) + '"'
      end if

      if !::oGrupoCliente:Cargo:Todos
         cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde ) + '" .and. cCodCli <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
      end if

      ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

      cExpLine          := '!lTotLin .and. !lControl'

      if !::oGrupoArticulo:Cargo:Todos
         cExpLine       += ' .and. cRef >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cRef <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
      end if

      ::oFacCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

      ::oFacCliT:GoTop()

      while !::oFacCliT:Eof()

         if lChkSer( ::oFacCliT:cSerie, ::aSer )                                          .and.;
            ( ::oGrupoGCliente:Cargo:Todos                                                .or.;
            ( cGruCli( ::oFacCliT:cCodCli, ::oDbfCli ) >= ::oGrupoGCliente:Cargo:Desde    .and.;
            cGruCli( ::oFacCliT:cCodCli, ::oDbfCli ) <= ::oGrupoGCliente:Cargo:Hasta ) )

            if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

               while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .and. !::oFacCliL:eof()

                  if ::oDbfArt:Seek( ::oFacCliL:cRef )

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
                                 case AllTrim( ::oDbf:cTabla )  == "Cabecera factura"

                                    if ::oDbf:nAlign <= 1

                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oFacCliT:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    elseif ::oDbf:nAlign == 2

                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oFacCliT:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    end if

                                 case AllTrim( ::oDbf:cTabla ) == "Lineas factura"

                                    if ::oDbf:nAlign <= 1

                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oFacCliL:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    elseif ::oDbf:nAlign == 2

                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oFacCliL:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    end if

                                 case AllTrim( ::oDbf:cTabla ) == "Artículos"

                                    if ::oDbf:nAlign <= 1

                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oDbfArt:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    elseif ::oDbf:nAlign == 2

                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oDbfArt:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    end if

                                 case AllTrim( ::oDbf:cTabla ) == "Clientes"

                                    if ::oDbf:nAlign <= 1

                                       ::cTextoFinal     += Padr( AllTrim( cValToText( ::oDbfCli:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

                                    elseif ::oDbf:nAlign == 2

                                       ::cTextoFinal     += Padl( AllTrim( cValToText( ::oDbfCli:FieldGetByName( AllTrim( ::oDbf:cCampo ) ) ) ), ::oDbf:nAncho )

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

                                 ::cTextoFinal        += Padr( AllTrim( cValToText( uField ) ), ::oDbf:nAncho )

                              elseif ::oDbf:nAlign == 2

                                 ::cTextoFinal        += Padl( AllTrim( cValToText( uField ) ), ::oDbf:nAncho )

                              end if

                           /*
                           Constante-------------------------------------------------
                           */

                           case ::oDbf:nTipo >= 3

                              if ::oDbf:nAlign <= 1

                                 ::cTextoFinal        += Padr( AllTrim( ::oDbf:mExpre ), ::oDbf:nAncho )

                              elseif ::oDbf:nAlign == 2

                                 ::cTextoFinal        += Padl( AllTrim( ::oDbf:mExpre ), ::oDbf:nAncho )

                              end if

                        end if

                        ::oDbf:Skip()

                     end while

                     ::cTextoFinal                 += CRLF

                     lFirstLine                    := .f.

                  end if

                  ::oFacCliL:Skip()

               end while

            end if

         end if

         ::oFacCliT:Skip()

         ::oMtrInf:AutoInc()

      end while

      ::oMtrInf:AutoInc( ::oFacCliT:Lastrec() )

      /*
      Destruimos los filtros creados----------------------------------------------
      */

      ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

      ::oFacCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ) )

   end if   

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

      if ApoloMsgNoYes( "Proceso de exportación realizado con éxito" + CRLF + ;
                   "¿ Desea abrir el fichero resultante ?", "Elija una opción." )
         ShellExecute( 0, "open", cGetFile, , , 1 )
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