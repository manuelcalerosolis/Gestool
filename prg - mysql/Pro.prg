#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "xbrowse.ch"

static oWndBrw 
static nView
static oMenu
static oDetMenu
static dbfProT
static dbfProL
static dbfTmpProL
static cTmpProLin
static oDetCamposExtra
static oLinDetCamposExtra
static nTipoActualizacionLineas  := EDIT_MODE
static bEdit                     := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode ) }
static bEdtDet                   := { |aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt | EdtDet( aTmp, aGet, dbf, oBrw, bWhen, bValid, nMode, cCodArt ) }

//----------------------------------------------------------------------------//
//Funciones del programa
//----------------------------------------------------------------------------//

FUNCTION Prop( oMenuItem, oWnd )

   local nLevel
   local oSnd

   DEFAULT  oMenuItem   := "01015"
   DEFAULT  oWnd        := oWnd()

   IF oWndBrw == NIL

      /*
      Obtenemos el nivel de acceso
      */

      nLevel            := nLevelUsr( oMenuItem )

      if nAnd( nLevel, 1 ) != 0
         msgStop( "Acceso no permitido." )
         return nil
      end if

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      /*
      Apertura de ficheros
      */

      if !OpenFiles()
         Return nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Propiedades de artículos", ProcName() )

   DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
      XBROWSE ;
      TITLE    "Propiedades de artículos" ;
      MRU      "gc_coathanger_16";
      PROMPT   "Código",;    
               "Nombre" ;
      BITMAP   clrTopArchivos ;
      ALIAS    ( dbfProT ) ;
      APPEND   ( WinAppRec( oWndBrw:oBrw, bEdit, dbfProT ) ) ;
      EDIT     ( WinEdtRec( oWndBrw:oBrw, bEdit, dbfProT ) ) ;
      DELETE   ( WinDelRec( oWndBrw:oBrw, dbfProT, {|| DeletePropiedades( ( dbfProT )->cCodPro ) } ) );
      DUPLICAT ( WinDupRec( oWndBrw:oBrw, bEdit, dbfProT ) ) ;
      LEVEL    nLevel ;
      OF       oWnd

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Envio"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfProT )->lSndDoc }
         :nWidth           := 20
         :SetCheck( { "gc_mail2_12", "Nil16" } )
         :AddResource( "gc_mail2_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Publicar"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfProT )->lPubInt }
         :nWidth           := 20
         :SetCheck( { "gc_earth_12", "Nil16" } )
         :AddResource( "gc_earth_16" )
      end with


      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPro"
         :bEditValue       := {|| ( dbfProT )->cCodPro }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesPro"
         :bEditValue       := {|| ( dbfProT )->cDesPro }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:CreateXFromCode()

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecAdd() );
         ON DROP  ( oWndBrw:RecDup() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP;
         HOTKEY   "A";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         MRU ;
         HOTKEY   "M";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfProT ) );
         TOOLTIP  "(Z)oom";
         MRU ;
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL oSnd RESOURCE "Lbl" GROUP OF oWndBrw ;
         NOBORDER ;
         MENU     This:Toggle() ;
         TOOLTIP  "En(v)iar" ;
         MESSAGE  "Seleccionar registros para ser enviados" ;
         ACTION   ChangelSndDoc() ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "SNDINT" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( ChangePublicar() );
         TOOLTIP  "P(u)blicar" ;
         HOTKEY   "U";
         LEVEL    ACC_EDIT


      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
         NOBORDER ;
         ACTION   ( oWndBrw:end() ) ;
         TOOLTIP  "(S)alir" ;
         HOTKEY   "S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   ELSE

      oWndBrw:SetFocus()

   END IF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfProT, oWndBrw, cPrp, cKey, nMode )

   local oDlg
   local oBrw

   if !( BeginTrans( aTmp, nMode, ( dbfProT )->cCodPro ) )
      Return .f.
   end if 

   DEFINE DIALOG oDlg RESOURCE "PROP" TITLE LblTitle( nMode ) + "propiedades"

      REDEFINE GET   aGet[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ] ;
         VAR         aTmp[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ] ;
         UPDATE ;
         ID          100 ;
         WHEN        ( nMode == APPD_MODE ) ;
         VALID       ( !Empty( aTmp[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ] ) .and. NotValid( aGet[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ], dbfProT ) ) ;
         PICTURE     "@!" ;
         OF          oDlg

      REDEFINE GET   aGet[ ( dbfProT )->( FieldPos( "cDesPro" ) ) ] ;
         VAR         aTmp[ ( dbfProT )->( FieldPos( "cDesPro" ) ) ] ;
         UPDATE ;
         ID          110 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      REDEFINE GET   aGet[ ( dbfProT )->( FieldPos( "cNomInt" ) ) ] ;
         VAR         aTmp[ ( dbfProT )->( FieldPos( "cNomInt" ) ) ] ;
         UPDATE ;
         ID          160 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfProT )->( FieldPos( "lPubInt" ) ) ] ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( ChangePublicar( aTmp ) ) ;
         OF       oDlg

      REDEFINE CHECKBOX aTmp[ ( dbfProT )->( FieldPos( "lColor" ) ) ] ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTmpProL
      oBrw:nMarqueeStyle   := 5

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodTbl"
         :bEditValue       := {|| ( dbfTmpProL )->cCodTbl }
         :nWidth           := 160
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesTbl"
         :bEditValue       := {|| ( dbfTmpProL )->cDesTbl }
         :nWidth           := 250
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Orden"
         :cSortOrder       := "nOrdTbl"
         :bEditValue       := {|| ( dbfTmpProL )->nOrdTbl }
         :cEditPicture     := "9999"
         :nWidth           := 50
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "CB"
         :cSortOrder       := "nBarTbl"
         :bEditValue       := {|| ( dbfTmpProL )->nBarTbl }
         :cEditPicture     := "9999"
         :nWidth           := 50
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Web"
         :cSortOrder       := "cCodWeb"
         :bEditValue       := {|| ( dbfTmpProL )->cCodWeb }
         :cEditPicture     := "9999"
         :nWidth           := 50
         :nDataStrAlign    := AL_RIGHT
         :nHeadStrAlign    := AL_RIGHT
         :lHide            := .t.
      end with

      oBrw:CreateFromResource( 120 )

      oBrw:bLDblClick      := {|| WinEdtRec( oBrw, bEdtDet, dbfTmpProL, aTmp ) } 
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      REDEFINE BUTTON;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrw, bEdtDet, dbfTmpProL, aTmp ) )

      REDEFINE BUTTON;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrw, bEdtDet, dbfTmpProL, aTmp ) )

      REDEFINE BUTTON;
         ID       502 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DeleteLinea( oBrw ) )

      REDEFINE BUTTON;
         ID       503 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( UpDet( oBrw ) )

      REDEFINE BUTTON;
         ID       504 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DownDet( oBrw ) )

      REDEFINE BUTTON;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE

         oDlg:AddFastKey( VK_F2, {|| WinAppRec( oBrw, bEdtDet, dbfTmpProL, aTmp ) } )
         oDlg:AddFastKey( VK_F3, {|| WinEdtRec( oBrw, bEdtDet, dbfTmpProL, aTmp ) } )
         oDlg:AddFastKey( VK_F4, {|| DelDet( oBrw ) } )
         oDlg:AddFastKey( VK_F5, {|| EndTrans( aTmp, aGet, nMode, oDlg ) } )

         if uFieldEmpresa( "lRealWeb" )
            oDlg:AddFastKey( VK_F6, {|| EndTrans( aTmp, aGet, nMode, oDlg, .t. ) } )
         end if

         oDlg:AddFastKey( VK_F9, {|| oDetCamposExtra:Play( space(1) ) } )

      end if

      oDlg:AddFastKey ( VK_F1, {|| ChmHelp( "Propiedades_de_articulos" ) } )

      oDlg:bStart := {|| StartEdtRec( aGet, cPrp, cKey ) }

   ACTIVATE DIALOG oDlg CENTER ;
      ON INIT ( EdtRecMenu( oDlg ) )

   if !Empty( oMenu )
      oMenu:end()
   end if

   KillTrans()
    
RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function StartEdtRec( aGet, cPrp, cKey )

   if !empty( cKey )
      dbseekinord( cKey, "cCodTbl", dbfTmpProL ) 
   end if

   aGet[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ]:SetFocus() 

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function UpDet( oBrw )

   local nRecno       := ( dbfTmpProL )->( Recno() )
   local nPosition    := ( dbfTmpProL )->nOrdTbl

   if nPosition > 1

      nPosition--

      ( dbfTmpProL )->( __dbLocate( {|| Field->nOrdTbl == nPosition } ) )
      if ( dbfTmpProL )->( Found() )
         ( dbfTmpProL )->nOrdTbl++
      endif

      ( dbfTmpProL )->( dbGoTo( nRecno ) )
      ( dbfTmpProL )->nOrdTbl--

   endif

   oBrw:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function DownDet( oBrw )

   local nRecno      := ( dbfTmpProL )->( Recno() )
   local nPosition      := ( dbfTmpProL )->nOrdTbl

   if nPosition < ( dbfTmpProL )->( LastRec() )

      nPosition++

      ( dbfTmpProL )->( __dbLocate( {|| Field->nOrdTbl == nPosition } ) )
      if ( dbfTmpProL )->( Found() )
         ( dbfTmpProL )->nOrdTbl--
      endif

      ( dbfTmpProL )->( dbGoTo( nRecno ) )
      ( dbfTmpProL )->nOrdTbl++

   endif

   oBrw:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION DeleteLinea( oBrw )

   nTipoActualizacionLineas  := DELE_MODE   

   DelDet( oBrw )

Return ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION BeginTrans( aTmp, nMode, cCodPro )

   local oError
   local oBlock
   local nOrdAnt
   local lCreate     := .t.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   cTmpProLin        := cGetNewFileName( cPatTmp() + "TmpProLin" )

   dbCreate( cTmpProLin, aSqlStruct( aItmPro() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cTmpProLin, cCheckArea( "TmpProLin", @dbfTmpProL ), .f. )

   if !( dbfTmpProL )->( neterr() )

      ( dbfTmpProL )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpProL )->( OrdCreate( cTmpProLin, "cCodTbl", "Field->cCodTbl", {|| Field->cCodTbl } ) )

      ( dbfTmpProL )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpProL )->( OrdCreate( cTmpProLin, "cDesTbl", "Field->cDesTbl", {|| Field->cDesTbl } ) )

      ( dbfTmpProL )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpProL )->( OrdCreate( cTmpProLin, "nOrdTbl", "Str( Field->nOrdTbl )", {|| Str( Field->nOrdTbl ) } ) )

      ( dbfTmpProL )->( OrdCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfTmpProL )->( OrdCreate( cTmpProLin, "nBarTbl", "Field->nBarTbl", {|| Field->nBarTbl } ) )

      ( dbfTmpProL )->( OrdSetFocus( "cCodTbl" ) )

      nOrdAnt        := ( dbfProL )->( OrdSetFocus( 1 ) )

      oLinDetCamposExtra:initArrayValue()

      if nMode != APPD_MODE .and. ( dbfProL )->( dbSeek( cCodPro ) )

         while ( dbfProL )->cCodPro == cCodPro .and. !( dbfProL )->( eof() )

            dbPass( dbfProL, dbfTmpProL, .t. )
            
            oLinDetCamposExtra:SetTemporalLines( ( dbfTmpProL )->cCodPro + ( dbfTmpProL )->cCodTbl, ( dbfTmpProL )->( OrdKeyNo() ), nMode )

            if empty( ( dbfTmpProL )->nOrdTbl )
               ( dbfTmpProL )->nOrdTbl := ( dbfTmpProL )->( Recno() )
            end if
         
           ( dbfProL )->( dbSkip() )
         
         end while

      end if

      ( dbfTmpProL )->( dbGoTop() )

      ( dbfProL )->( OrdSetFocus( nOrdAnt ) )
      ( dbfProL )->( dbGoTop() )

      oDetCamposExtra:SetTemporal( cCodPro, "", nMode )

   end if

   RECOVER USING oError

      lCreate        := .f.

      msgStop( "Imposible crear el fichero temporal" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreate )

//---------------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, nMode, oDlg, lActualizaWeb )

   local oError
   local oBlock
   local nOrdAnt
   local cCodPrp

   DEFAULT lActualizaWeb   := .f.

   // Controla que no metan una propiedad con el código o el nombre en blanco

   if nMode == APPD_MODE

      if Empty( aTmp[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ] )
         MsgStop( "Código no puede estar vacío" )
         aGet[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ]:SetFocus()
         return nil
      end if

      if dbSeekInOrd( aTmp[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ], "CCODPRO", dbfProT )
         MsgStop( "Código ya existe " + Rtrim( aTmp[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ] ) )
         return nil
      end if

   end if

   if Empty( aTmp[ ( dbfProT )->( FieldPos( "cDesPro" ) ) ] )
      msgStop( "Nombre no puede estar vacío" )
      aGet[ ( dbfProT )->( FieldPos( "cDesPro" ) ) ]:SetFocus()
      return nil
   end if

   /*
   Pongo la marca de envio a verdadero
   */
   
   cCodPrp     := aTmp[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ]

   aTmp[ ( dbfProT )->( FieldPos( "lSndDoc" ) ) ]   := .t.

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      BeginTransaction()

      nOrdAnt  := ( dbfProL )->( OrdSetFocus( 2 ) )

      while ( dbfProL )->( dbSeek( aTmp[ ( dbfProL )->( FieldPos( "cCodPro" ) ) ] ) ) .and. !( dbfProL )->( eof() )
         if dbLock( dbfProL )
            ( dbfProL )->( dbDelete() )
            ( dbfProL )->( dbUnLock() )
         end if
      end while

      ( dbfProL )->( OrdSetFocus( nOrdAnt ) )
      ( dbfProL )->( dbGoTop() )

      ( dbfTmpProL )->( dbGoTop() )
      while !( dbfTmpProL )->( eof() )
         dbPass( dbfTmpProL, dbfProL, .t., aTmp[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ] )
         oLinDetCamposExtra:saveExtraField( ( dbfTmpProL )->cCodPro + ( dbfTmpProL )->cCodTbl, ( dbfTmpProL )->( OrdKeyNo() ) )
         ( dbfTmpProL )->( dbSkip() )
      end while

      oDetCamposExtra:saveExtraField( aTmp[ ( dbfProT )->( FieldPos( "cCodPro" ) ) ], "" )

      WinGather( aTmp, aGet, dbfProT, nil, nMode )

      /*
      Actualizamos los datos de la web para tiempo real------------------------
      */

      Actualizaweb( cCodPrp, lActualizaweb )

      /*
      Termina la transación----------------------------------------------------
      */

      CommitTransaction()

   RECOVER USING oError

      RollBackTransaction()
      msgStop( "Imposible completar la transacción" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION KillTrans()

   if !Empty( dbfTmpProL ) .and. ( dbfTmpProL )->( Used() )
      ( dbfTmpProL )->( dbCloseArea() )
   end if

   dbfTmpProL  := nil

   dbfErase( cTmpProLin )

RETURN nil

//---------------------------------------------------------------------------//

Static Function EdtRecMenu( oDlg )

   MENU oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra para propiedades" ;
               RESOURCE "GC_FORM_PLUS2_16" ;
               ACTION   ( oDetCamposExtra:Play( Space(1) ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//---------------------------------------------------------------------------//

static Function menuEdtDet( oDlg, nIdLin )

   MENU oDetMenu

      MENUITEM    "&1. Rotor  " ;
         RESOURCE "Rotor16"

         MENU

            MENUITEM    "&1. Campos extra [F9]";
               MESSAGE  "Mostramos y rellenamos los campos extra" ;
               RESOURCE "GC_FORM_PLUS2_16" ;
               ACTION   ( oLinDetCamposExtra:Play( nIdLin ) )

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oDetMenu )

Return ( oDetMenu )

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtDet( aTmp, aGet, dbf, oBrw, aTmpPro, bValid, nMode, cCodArt )

   local oDlg

   nTipoActualizacionLineas  := nMode

   if nMode == APPD_MODE
      aTmp[ ( dbfProL )->( FieldPos( "nOrdTbl" ) ) ]  := ( dbfTmpProL )->( LastRec() ) + 1
      oLinDetCamposExtra:setTemporalAppend()
   end if

   DEFINE DIALOG oDlg RESOURCE "PRODET" TITLE LblTitle( nMode ) + "propiedad"

      REDEFINE GET aGet[ ( dbfProL )->( FieldPos( "cCodTbl" ) ) ];
         VAR      aTmp[ ( dbfProL )->( FieldPos( "cCodTbl" ) ) ];
         ID       100 ;
         VALID    ( !Empty( aTmp[ ( dbfTmpProL )->( FieldPos( "cCodTbl" ) ) ] ) );
         WHEN     ( nMode == APPD_MODE ) ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfProL )->( FieldPos( "cDesTbl" ) ) ];
         VAR      aTmp[ ( dbfProL )->( FieldPos( "cDesTbl" ) ) ];
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfProL )->( FieldPos( "nOrdTbl" ) ) ];
         VAR      aTmp[ ( dbfProL )->( FieldPos( "nOrdTbl" ) ) ];
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "9999" ;
         SPINNER ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfProL )->( FieldPos( "nBarTbl" ) ) ];
         VAR      aTmp[ ( dbfProL )->( FieldPos( "nBarTbl" ) ) ];
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "9999" ;
         OF       oDlg

      REDEFINE GET aGet[ ( dbfProL )->( FieldPos( "nColor" ) ) ];
         VAR      aTmp[ ( dbfProL )->( FieldPos( "nColor" ) ) ];
         ID       200 ;
         COLOR    if( aTmpPro[ ( dbfProT )->( FieldPos( "lColor" ) ) ], aTmp[ ( dbfProL )->( FieldPos( "nColor" ) ) ], CLR_GET ), if( aTmpPro[ ( dbfProT )->( FieldPos( "lColor" ) ) ], aTmp[ ( dbfProL )->( FieldPos( "nColor" ) ) ], CLR_GET ) ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE .and. aTmpPro[ ( dbfProT )->( FieldPos( "lColor" ) ) ] ) ;
         ON HELP  (  aTmp[ ( dbfProL )->( FieldPos( "nColor" ) ) ]  := ChooseColor(),;
                     aGet[ ( dbfProL )->( FieldPos( "nColor" ) ) ]:SetColor( aTmp[ ( dbfProL )->( FieldPos( "nColor" ) ) ], aTmp[ ( dbfProL )->( FieldPos( "nColor" ) ) ] ),;
                     aGet[ ( dbfProL )->( FieldPos( "nColor" ) ) ]:Refresh() ) ;
         OF       oDlg

      REDEFINE BUTTON;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( SaveEdtDet( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpProL ) )

      REDEFINE BUTTON;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
         OF       oDlg ;
         ACTION   ( ChmHelp( "Propiedades_de_articulos" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| SaveEdtDet( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpProL ) } )
      oDlg:AddFastKey( VK_F9, {|| oLinDetCamposExtra:Play( if( nMode == APPD_MODE, "", Str( ( dbfTmpProL )->( OrdKeyNo() ) ) ) ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER ;
      ON INIT ( menuEdtDet( oDlg, if( nMode == APPD_MODE, "", Str( ( dbfTmpProL )->( OrdKeyNo() ) ) ) ) )

   if !Empty( oDetMenu )
      oDetMenu:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function SaveEdtDet( aTmp, aGet, oBrw, oDlg, nMode, dbfTmpProL )

   local nRec
   local lErr     := .f.

   nRec           := ( dbfTmpProL )->( Recno() )

   if nMode == APPD_MODE

      if Empty( aTmp[ ( dbfTmpProL )->( FieldPos( "cCodTbl" ) ) ] )
         MsgStop( "Código de la propiedad no puede estar vacio" )
         lErr     := .t.
      end if

      if dbSeekInOrd( aTmp[ ( dbfTmpProL )->( FieldPos( "cCodTbl" ) ) ], "cCodTbl", dbfTmpProL )
         MsgStop( "Código de la propiedad ya existe" )
         lErr     := .t.
      end if

   end if

   if ( nMode == APPD_MODE .or. ( dbfTmpProL )->nBarTbl != aTmp[ ( dbfTmpProL )->( FieldPos( "nBarTbl" ) ) ] ) .and.;
      !Empty( aTmp[ ( dbfTmpProL )->( FieldPos( "nBarTbl" ) ) ] )                                              .and.;
      dbSeekInOrd( aTmp[ ( dbfTmpProL )->( FieldPos( "nBarTbl" ) ) ], "nBarTbl", dbfTmpProL )
         MsgStop( "Número para código de barras ya existe" )
         lErr     := .t.
   end if

   ( dbfTmpProL )->( dbGoTo( nRec ) )

   if !lErr
      WinGather( aTmp, aGet, dbfTmpProL, oBrw, nMode )
      oDlg:end( IDOK )
   end if

   if nMode == APPD_MODE
      oLinDetCamposExtra:SaveTemporalAppend( ( dbfTmpProL )->( OrdKeyNo() ) )
   end if

Return nil

//--------------------------------------------------------------------------//

FUNCTION cProp( oGet, oSay )

   local oBlock
   local oError
   local dbfPro
   local lValid   := .f.
   local cCodPrp  := oGet:VarGet()

   if Empty( cCodPrp )

      if !Empty( oSay )
         oSay:SetText( Space( 3 ) )
      end if

      return .t.

   end if

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED   ALIAS ( cCheckArea( "PRO", @dbfPro ) )
   SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

   if ( dbfPro )->( dbSeek( cCodPrp ) )

      if !Empty( oSay )
         oSay:SetText( ( dbfPro )->cDesPro )
      end if

      lValid      := .t.

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

   CLOSE ( dbfPro )

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION brwProp( oGet, oSay )

   local oDlg
   local oBrw
   local oGetNbr
   local cGetNbr
   local oCbxOrd
   local cCbxOrd
   local nOrd     := GetBrwOpt( "BrwProp" )
   local aCbxOrd  := { "Código", "Nombre" }
   local nLevel   := nLevelUsr( "01015" )

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   if !OpenFiles()
      Return ( .f. )
   end if

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar propiedad"

      REDEFINE GET oGetNbr VAR cGetNbr ;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfProT ) );
         VALID    ( OrdClearScope( oBrw, dbfProT ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfProT
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Propiedades"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodPro"
         :bEditValue       := {|| ( dbfProT )->cCodPro }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesPro"
         :bEditValue       := {|| ( dbfProT )->cDesPro }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_APPD ) != 0 ) ;
         ACTION   ( WinAppRec( oBrw, bEdit, dbfProT ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( nAnd( nLevel, ACC_EDIT ) != 0 ) ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfProT ) )

      oBrw:bLDblClick            := {|| oDlg:end( IDOK ) }

      oDlg:AddFastKey( VK_F2,       {|| if( nAnd( nLevel, ACC_APPD ) != 0, WinAppRec( oBrw, bEdit, dbfProT ), ) } )
      oDlg:AddFastKey( VK_F3,       {|| if( nAnd( nLevel, ACC_EDIT ) != 0, WinEdtRec( oBrw, bEdit, dbfProT ), ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

      oDlg:bStart := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   DestroyFastFilter( dbfProT )

   SetBrwOpt( "BrwProp", ( dbfProT )->( OrdNumber() ) )

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfProT )->cCodPro )

      if ValType( oSay ) == "O"
         oSay:SetText( ( dbfProT )->cDesPro )
      end if

   end if

   oGet:SetFocus()

   CloseFiles()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Static Function DeletePropiedades( cCodPro )

   local nOrdAnt  := ( dbfProL )->( OrdSetFocus( "nOrdPro" ) )

   ( dbfProL )->( dbGoTop() )

   if ( dbfProL )->( dbSeek( cCodPro ) )
      while ( dbfProL )->cCodPro == cCodPro .and. !( dbfProL )->( eof() )
         if dbLock( dbfProL )
            ( dbfProL )->( dbDelete() )
            ( dbfProL )->( dbUnLock() )
         end if
         ( dbfProL )->( dbSkip() )
      end while
   end if

   ( dbfProL )->( OrdSetFocus( nOrdAnt ) )
   ( dbfProL )->( dbGoTop() )

Return .t.

//---------------------------------------------------------------------------//

Static Function DelDet( oBrwLineas )

   dbDelRec( oBrwLineas, dbfTmpProL )

Return .t.

//---------------------------------------------------------------------------//

function lIsProp1( cCodArt, dbfFamilia, dbfArticulo )

   local lIsPro   := .f.

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      lIsPro      := Empty( ( dbfArticulo )->cCodPrp1 )
   end if

return ( lIsPro )

//---------------------------------------------------------------------------//

function lIsProp2( cCodArt, dbfFamilia, dbfArticulo )

   local lIsPro   := .f.

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      lIsPro      := Empty( ( dbfArticulo )->cCodPrp2 )
   end if

return ( lIsPro )

//---------------------------------------------------------------------------//

Function cBarPrp( cCodPrp, cValPrp, dbfTblPro )

   local cBarPro  := ""

   if dbSeekInOrd( cCodPrp + cValPrp, "cCodPro", dbfTblPro )
      cBarPro     := alltrim( ( dbfTblPro )->nBarTbl )
   end if

return ( cBarPro )

//---------------------------------------------------------------------------//

function lEmptyProp( cCodPrp, dbfTblPro )

   local lEmptyProp  := .t.

   if !Empty( cCodPrp ) .and. dbSeekInOrd( cCodPrp, "nOrdPro", dbfTblPro ) 
      lEmptyProp     := .f.
   end if

return ( lEmptyProp )

//---------------------------------------------------------------------------//

Function cCodPrp( cCodPrp, nBarPrp, dbfTblPro )

   local cBarPro  := Space( 10 )

   if dbSeekInOrd( cCodPrp + nBarPrp, "nBarPro", dbfTblPro )
      cBarPro     := ( dbfTblPro )->cCodTbl
   else
      if dbSeekInOrd( cCodPrp + nBarPrp, "cCodPro", dbfTblPro )
         cBarPro  := ( dbfTblPro )->cCodTbl
      end if
   end if

return ( cBarPro )

//---------------------------------------------------------------------------//

Function aSeekProp( cCodBar, cCodPr1, cCodPr2, dbfArticulo, dbfTblPro )

   local n
   local cCodArt     := cCodBar

   if dbSeekInOrd( padr( cCodBar, 18 ), "Codigo", dbfArticulo ) .or. ;
      dbSeekInOrd( upper( padr( cCodBar, 18 ) ), "Codigo", dbfArticulo )

      Return ( .t. )

   else

      n              := at( ".", cCodBar )

      if n != 0

         cCodArt     := substr( cCodBar, 1, n - 1 )
         cCodBar     := substr( cCodBar, n + 1 )

         n           := at( ".", cCodBar )

         if n != 0
            cCodPr1  := substr( cCodBar, 1, n - 1 )
            cCodPr2  := substr( cCodBar, n + 1 )
         else
            cCodPr1  := rtrim( cCodBar )
         end if

      end if

      if ( dbfArticulo )->( dbSeek( cCodArt ) )

         cCodBar     := ( dbfArticulo )->Codigo
         cCodPr1     := padr( cCodPr1, 20 )
         cCodPr2     := padr( cCodPr2, 20 )

         Return ( .t. )

      end if

   end if

Return ( .f. )

//---------------------------------------------------------------------------//
//
// Carga el precio de venta en funcion de sus propiedades
//

Function LoaPrePro( cCodArt, cCodPr1, cValPr1, cCodPr2, cValPr2, nTarPre, lIvaInc, aGet, dbfArtDiv, dbfTarPreL, cCodTar )

   local nPrePro  := nPrePro( cCodArt, cCodPr1, cValPr1, cCodPr2, cValPr2, nTarPre, lIvaInc, dbfArtDiv, dbfTarPreL, cCodTar )

   if nPrePro != 0
      aGet:cText( nPrePro )
   end if

return .t.

//---------------------------------------------------------------------------//

// Carga el precio de compra en funcion de sus propiedades
//

Function LoaComPro( cCodArt, cCodPr1, cValPr1, cCodPr2, cValPr2, aGet, dbfArtCom )

   local nPrePro  := nComPro( cCodArt, cCodPr1, cValPr1, cCodPr2, cValPr2, dbfArtCom )

   if nPrePro != 0
      aGet:cText( nPrePro )
   end if

return .t.

//---------------------------------------------------------------------------//

Function LoadPropertiesTable( cCodArt, nPrecioCosto, cCodPr1, cCodPr2, oGetUnidades, oGetPre, oBrw, nView )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function bGenEditText( aTblPrp, oBrwPrp, n )

Return ( {|| aTblPrp[ oBrwPrp:nArrayAt, n ]:cText } )

//--------------------------------------------------------------------------//

Static Function bGenEditValue( aTblPrp, oBrwPrp, n )

Return ( {|| aTblPrp[ oBrwPrp:nArrayAt, n ]:Value } )

//--------------------------------------------------------------------------//

Static Function bGenRGBValue( aTblPrp, oBrwPrp, n )

Return ( {|| { nRGB( 0, 0, 0), aTblPrp[ oBrwPrp:nArrayAt, n ]:nRgb } } )

//--------------------------------------------------------------------------//

Static Function aPropertiesTable( oBrw, nTotalCol )

   local n
   local nAt
   local aRow        := {}

   nAt               := oBrw:nAt

   if nAt == 0
      Return ( aRow )
   end if 

   for n := 1 to nTotalCol
      if oBrw:Cargo[ nAt, n ]:Value == nil
         aAdd( aRow, oBrw:Cargo[ nAt, n ]:cText )
      else
         aAdd( aRow, Trans( oBrw:Cargo[ nAt, n ]:Value, MasUnd() ) )
      end if
   next

Return ( aRow )

//---------------------------------------------------------------------------//

Static Function EditPropertiesTable( oBrw )

   local nRow     := oBrw:nAt
   local nCol     := oBrw:nColAct
   local uVar     := oBrw:Cargo[ nRow, nCol ]:Value

   if nCol <= 1
      return .f.
   end if

   if oBrw:lEditCol( nCol, @uVar, MasUnd() )
      oBrw:Cargo[ nRow, nCol ]:Value   := uVar
      oBrw:Refresh()
   end if

RETURN .t.

//--------------------------------------------------------------------------//

Static Function PutPropertiesTable( oBrw, oGet )

   local nRow
   local nCol
   local uVar

   if !Empty( oBrw ) .and. !Empty( oBrw:Cargo )

      nRow        := oBrw:nAt
      nCol        := oBrw:nColAct
      uVar        := oBrw:Cargo[ nRow, nCol ]:nPrecioCompra

      if !Empty( oGet )
         oGet:cText( uVar )
      end if

   end if

RETURN .t.

//--------------------------------------------------------------------------//

Static Function validPropertiesTable( oBrw, oGet )

   local nRow
   local nCol
   local uVar
   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      nRow        := oBrw:nAt
      nCol        := oBrw:nColAct
      uVar        := oGet:VarGet()

      if IsArray( oBrw:Cargo )
         oBrw:Cargo[ nRow, nCol ]:nPrecioCompra := uVar
      end if

   RECOVER

      msgStop( "Imposible asignar valor a la celda." )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN .t.

//--------------------------------------------------------------------------//

Static Function KeyPropertiesTable( nKey, oBrw )

   local nVar     := 0
   local nRow     := oBrw:nAt
   local nCol     := oBrw:nColAct
   local uVar     := Val( Chr( nKey ) )

   if nCol <= 1
      return .f.
   end if

   if oBrw:lEditCol( nCol, @nVar, MasUnd(), , , , , , , , {|oGet| oGet:KeyChar( nKey ) } )
      oBrw:Cargo[ nRow, nCol ]:Value   := nVar
      oBrw:GoDown()
      oBrw:Refresh()
   end if

Return .t.

//--------------------------------------------------------------------------//

Static Function aPropertiesFooter( oBrw, nTotalRow, nTotalCol, oGet )

   local n
   local i
   local nTot  := 0
   local aRow  := AFill( Array( nTotalCol ), 0 )

   for n := 1 to nTotalCol
      for i := 1 to nTotalRow
         if oBrw:Cargo[ i, n ]:Value == nil
            aRow[ n ]   := "Total"
         else
            aRow[ n ]   += oBrw:Cargo[ i, n ]:Value
         end if
      next
   next

   for n := 1 to nTotalCol
      if ValType( aRow[ n ] ) == "N"
         nTot           += aRow[ n ]
         aRow[ n ]      := Trans( aRow[ n ], MasUnd() )
      end if
   next

   if oGet != nil
      oGet:cText( nTot )
   end if

Return ( aRow )

//---------------------------------------------------------------------------//

Static Function bPostEditProperties( oCol, xVal, nKey, oBrw, oGetUnidades )

   oBrw:Cargo[ oBrw:nArrayAt, oCol:Cargo ]:Value := xVal 

   nTotalProperties( oBrw, oGetUnidades )

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function nTotalProperties( oBrw, oGet )

   local aRow  
   local aCol
   local nTot  := 0

   for each aRow in oBrw:Cargo
      for each aCol in aRow
         if isNum( aCol:Value )
            nTot  += aCol:Value 
         end if
      next
   next 

   if !empty( oGet )
      oGet:cText( nTot )
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//


Function SearchProperty( oGetIra, oBrwPrp )

   local n
   local nPos
   local cHeader  := ""
   local cColumn  := ""
   local cGetIra  := Rtrim( oGetIra:cText() )

   nPos           := At( ":", cGetIra )
   if nPos != 0
      cHeader     := Left( cGetIra, nPos - 1)
      cColumn     := SubStr( cGetIra, nPos + 1 )
   else
      cHeader     := cGetIra
   end if

   if !Empty( cColumn )
      for n := 1 to len( oBrwPrp:Cargo )
         if Rtrim( Upper( oBrwPrp:Cargo[ n, 1 ]:cText ) ) == Rtrim( Upper( cColumn ) )
            oBrwPrp:nAt := n
         end if
      next
   end if

   if !Empty( cHeader )
      nPos        := aScan( oBrwPrp:aHeaders, {| cH | Rtrim( Upper( cH ) ) == Rtrim( Upper( cHeader ) ) } )
      if nPos != 0
         oBrwPrp:GoToCol( nPos )
      end if
   end if

   oBrwPrp:Refresh()
   oBrwPrp:SetFocus()

Return nil

//---------------------------------------------------------------------------//

CLASS TPropertiesItems

   DATA  cText
   DATA  cCodigo
   DATA  cCodigoPropiedad1
   DATA  cCodigoPropiedad2
   DATA  cValorPropiedad1
   DATA  cValorPropiedad2
   DATA  nPrecioCompra
   DATA  lColor             
   DATA  nRgb               
   DATA  cHead

   DATA  Value

   Method New()

   Method PrecioCompra()

   Method ToString()

   Method FromString()
   Method getHead()     INLINE ( rtrim( ::cHead ) )

END CLASS

//---------------------------------------------------------------------------//

Method New() CLASS TPropertiesItems

   ::cText              := ""
   ::cCodigo            := ""
   ::cHead              := ""
   ::Value              := nil
   ::cCodigoPropiedad1  := Space( 20 )
   ::cCodigoPropiedad2  := Space( 20 )
   ::cValorPropiedad1   := Space( 40 )
   ::cValorPropiedad2   := Space( 40 )
   ::lColor             := .f.
   ::nRgb               := 0
   ::nPrecioCompra      := 0

Return ( Self )

//---------------------------------------------------------------------------//

Method PrecioCompra( nPrecioCosto, dbfArtCom ) CLASS TPropertiesItems

   ::nPrecioCompra      := nComPro( ::cCodigo, ::cCodigoPropiedad1, ::cValorPropiedad1, ::cCodigoPropiedad2, ::cValorPropiedad2, dbfArtCom )

   if ::nPrecioCompra == 0
      ::nPrecioCompra   := nPrecioCosto
   end if

Return ( ::nPrecioCompra )

//---------------------------------------------------------------------------//

Method ToString() CLASS TPropertiesItems

   local cString  := ""

   cString        += "cText : "              + Rtrim( cValToChar( ::cText ) )               + ","
   cString        += "cHead : "              + Rtrim( cValToChar( ::cHead ) )               + ","
   cString        += "Value : "              + Rtrim( cValToChar( ::Value ) )               + ","
   cString        += "cCodigo : "            + Rtrim( cValToChar( ::cCodigo ) )             + ","
   cString        += "cCodigoPropiedad1 : "  + Rtrim( cValToChar( ::cCodigoPropiedad1 ) )   + ","
   cString        += "cCodigoPropiedad2 : "  + Rtrim( cValToChar( ::cCodigoPropiedad2 ) )   + ","
   cString        += "cValorPropiedad1 : "   + Rtrim( cValToChar( ::cValorPropiedad1 ) )    + ","
   cString        += "cValorPropiedad2 : "   + Rtrim( cValToChar( ::cValorPropiedad2 ) )    + ","
   cString        += "nPrecioCompra : "      + Rtrim( cValToChar( ::nPrecioCompra ) )       + ";"

Return ( cString )

//---------------------------------------------------------------------------//

Method FromString( cString ) CLASS TPropertiesItems

   local aTokens        := hb_aTokens( cString, "," )

   ::cText              := aTokens[ 1 ]
   ::cHead              := aTokens[ 2 ]

   if Val( aTokens[ 3 ] ) != 0
      ::Value           := Val( aTokens[ 3 ] )
   else
      ::Value           := nil
   end if

   ::cCodigo            := aTokens[ 4 ]
   ::cCodigoPropiedad1  := aTokens[ 5 ]
   ::cCodigoPropiedad2  := aTokens[ 6 ]
   ::cValorPropiedad1   := aTokens[ 7 ]
   ::cValorPropiedad2   := aTokens[ 8 ]
   ::nPrecioCompra      := Val( aTokens[ 9 ] )

Return ( Self )

//---------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//----------------------------------------------------------------------------//

FUNCTION lPrpAct( cVal, oSay, cPrp, dbfTblPro )

   local lRet     := .f.

   if Empty( cPrp )
      return .t.
   end if

   /*
   Es para cuando no hay valores poder meter valores libres.
   */

   if !dbSeekInOrd( cPrp, "CPRO", dbfTblPro )
      Return .t.
   end if

   if ValType( cVal ) == "O"
      cVal        := cVal:VarGet()
   end if

   /*
   Caso especial para todas las propiedades
   */

   if Rtrim( cVal ) == "*"
      if oSay != nil
         oSay:SetText( "Todos" )
      end if
      return .t.
   end if

   if dbSeekInOrd( cPrp + cVal, "cCodPro", dbfTblPro ) .or. dbSeekInOrd( Upper( cPrp + cVal ), "cCodPro", dbfTblPro )

      if oSay != nil
         oSay:SetText( ( dbfTblPro )->cDesTbl )
      end if

      lRet        := .t.

   else

      if oSay != nil
         oSay:SetText( "" )
      end if

      if !Empty( cVal )
         MsgStop( "Valor de la propiedad " + Rtrim( cVal ) + " no encontrado." )
      end if

   end if

RETURN ( lRet )

//---------------------------------------------------------------------------//

FUNCTION brwPrpAct( oGet, oSay, cPrp )

   local oDlg
   local oBrw
   local lRet        := .f.
   local oBlock
   local oError
   local cTitle      := ""
   local oGetNbr
   local cGetNbr
   local oCbxOrd
   local cCbxOrd     := "Código"
   local aCbxOrd     := { "Código", "Nombre" }
   local cTmpBrw
   local nOrdTmp
   local oSayText
   local cSayText    := "Propiedades"
   local dbfTmpBrw

   if Empty( cPrp )
      MsgStop( "No hay propiedades seleccionadas para este artículo." )
      Return .f.
   end if

   if !OpenFiles()
      Return .f.
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   // Titulo del dialogo-------------------------------------------------------

   cTitle            := "Seleccionar propiedad : " + retProp( cPrp, dbfProT )

   // Creacion de una dbf temporal---------------------------------------------

   cTmpBrw           := cGetNewFileName( cPatTmp() + "TmpBrw" )

   dbCreate( cTmpBrw, aSqlStruct( aItmTmpBrw() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpBrw, cCheckArea( "TmpBrw", @dbfTmpBrw ), .f. )

   if !( dbfTmpBrw )->( neterr() )

      ( dbfTmpBrw )->( OrdCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTmpBrw )->( OrdCreate( cTmpBrw, "cCodTbl", "cCodTbl", {|| Field->cCodTbl } ) )

      ( dbfTmpBrw )->( OrdCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfTmpBrw )->( OrdCreate( cTmpBrw, "cDesTbl", "cDesTbl", {|| Field->cDesTbl } ) )

   end if

   nOrdTmp           := ( dbfProL )->( OrdSetFocus( "nOrdPro" ) )

   ( dbfProL )->( dbGoTop() )

   if ( dbfProL )->( dbSeek( cPrp ) )

      while ( dbfProL )->cCodPro == cPrp .and. !( dbfProL )->( eof() )

         if dbAppe( dbfTmpBrw )
            ( dbfTmpBrw )->cCodTbl  := ( dbfProL )->cCodTbl
            ( dbfTmpBrw )->cDesTbl  := ( dbfProL )->cDesTbl
            ( dbfTmpBrw )->( dbUnLock() )
         end if

         ( dbfProL )->( dbSkip() )

      end while

   end if

   ( dbfTmpBrw )->( dbGoTop() )

   ( dbfProL )->( OrdSetFocus( nOrdTmp ) )
   ( dbfProL )->( dbGoTop() )

   // Mostramos el dialogo-----------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE cTitle

      REDEFINE GET oGetNbr VAR cGetNbr ;
         ID                104 ;
         ON CHANGE         autoSeek( nKey, nFlags, Self, oBrw, dbfTmpBrw ) ;
         BITMAP            "FIND" ;
         OF                oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR               cCbxOrd ;
         ID                102 ;
         ITEMS             aCbxOrd ;
         ON CHANGE         ( ( dbfTmpBrw )->( OrdSetFocus( oCbxOrd:nAt ) ), ( dbfTmpBrw )->( dbGoTop() ), oBrw:Refresh(), oGetNbr:SetFocus(), oCbxOrd:Refresh() ) ;
         OF                oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTmpBrw

      oBrw:nMarqueeStyle   := 5
      oBrw:lHScroll        := .t.

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodTbl"
         :bEditValue       := {|| ( dbfTmpBrw )->cCodTbl }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), eval( oCbxOrd:bChange ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesTbl"
         :bEditValue       := {|| ( dbfTmpBrw )->cDesTbl }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), eval( oCbxOrd:bChange ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     .f. ;
         ACTION   nil

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     .f. ;
         ACTION   nil

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if ( oDlg:nResult == IDOK )

      oGet:cText( ( dbfTmpBrw )->cCodTbl )

      if isObject( oSay )
         oSay:SetText( ( dbfTmpBrw )->cDesTbl )
      end if

      lRet        := .t.

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible mostrar tablas de propiedades" )

   END SEQUENCE
   ErrorBlock( oBlock )

   CloseFiles()

   if !Empty( dbfTmpBrw ) .and. ( dbfTmpBrw )->( Used() )
      ( dbfTmpBrw )->( dbCloseArea() )
   end if

   dbfTmpBrw      := nil

   dbfErase( cTmpBrw )

RETURN ( lRet )

//---------------------------------------------------------------------------//

FUNCTION brwPropiedadActual( oGet, oSay, cPrp )

   local oDlg
   local oBrw
   local lRet        := .f.
   local cKey        := ""       
   local oBlock
   local oError
   local cTitle      := ""
   local oGetNbr
   local cGetNbr
   local oCbxOrd
   local cCbxOrd     := "Código"
   local aCbxOrd     := { "Código", "Nombre" }

   if Empty( cPrp )
      MsgStop( "No hay propiedades seleccionadas para este artículo." )
      Return .f.
   end if

   if !OpenFiles()
      Return .f.
   end if

   // Es para cuando no hay valores poder meter valores libres

   if !dbSeekInOrd( cPrp, "CPRO", dbfProL )
      MsgStop( "No existen valores para esta propiedad" )
      Return .t.
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   // Titulo del dialogo-------------------------------------------------------

   if !Empty( oGet )
      cKey           := oGet:varget()
   end if

   cTitle            := "Seleccionar propiedad : " + retProp( cPrp, dbfProT )

   // Creacion de una dbf temporal---------------------------------------------

   ( dbfProL )->( ordScope( 0, cPrp ) )
   ( dbfProL )->( ordScope( 1, cPrp ) )
   ( dbfProL )->( dbGoTop() )

   // Posicionamiento----------------------------------------------------------

   ( dbfProL )->( dbseek( alltrim( cPrp + cKey ), .t. ) )

   // Mostramos el dialogo-----------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE cTitle

      REDEFINE GET oGetNbr ;
         VAR         cGetNbr ;
         ID       	104 ;
         ON CHANGE 	autoSeek( nKey, nFlags, Self, oBrw, dbfProL, nil, cPrp ) ;
         VALID       ( ( dbfProL )->( ordScope( 0, cPrp ) ), ( dbfProL )->( ordScope( 1, cPrp ) ) ) ;
         BITMAP   	"FIND" ;
         OF       	oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      	cCbxOrd ;
         ID       	102 ;
         ITEMS    	aCbxOrd ;
         ON CHANGE   ( ( dbfProL )->( OrdSetFocus( oCbxOrd:nAt ) ), ( dbfProL )->( dbGoTop() ), oBrw:Refresh(), oGetNbr:SetFocus(), oCbxOrd:Refresh() ) ;
         OF       	oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfProL

      oBrw:nMarqueeStyle   := 5
      oBrw:lHScroll        := .t.

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodTbl"
         :bEditValue       := {|| ( dbfProL )->cCodTbl }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), eval( oCbxOrd:bChange ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDesTbl"
         :bEditValue       := {|| ( dbfProL )->cDesTbl }
         :nWidth           := 280
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ), eval( oCbxOrd:bChange ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         ACTION   ( WinEdtRec( oBrw, bEdit, dbfProT, cPrp, cKey ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F3,       {|| WinEdtRec( oBrw, bEdit, dbfProT, cPrp, cKey ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if ( oDlg:nResult == IDOK )

      if !Empty( oGet )
         oGet:cText( ( dbfProL )->cCodTbl )
      end if

      if IsObject( oSay )
         oSay:SetText( ( dbfProL )->cDesTbl )
      end if

      if Empty( oGet )
         lRet        := ( dbfProL )->cCodTbl
      else
         lRet        := .t.
      end if

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible mostrar tablas de propiedades" )

   END SEQUENCE
   ErrorBlock( oBlock )

   CloseFiles()

RETURN ( lRet )

//---------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles()

   local lOpen                         := .t.
   local oBlock                        := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      nView                            := D():CreateView()

      USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @dbfProT ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE

      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @dbfProL ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE

      oDetCamposExtra                  := TDetCamposExtra():New()
      oDetCamposExtra:OpenFiles()
      oDetCamposExtra:SetTipoDocumento( "Propiedades" )
      oDetCamposExtra:setbId( {|| D():PropiedadesId( nView ) } )

      oLinDetCamposExtra               := TDetCamposExtra():New()
      oLinDetCamposExtra:OpenFiles()
      oLinDetCamposExtra:setTipoDocumento( "Lineas de propiedades" )
      oLinDetCamposExtra:setbId( {|| D():PropiedadesLineasId( nView ) } )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )

      CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles()

   if dbfProT != nil
      ( dbfProT )->( dbCloseArea() )
   end if

   if dbfProL != nil
      ( dbfProL )->( dbCloseArea() )
   end if

   if !empty( oDetCamposExtra )
      oDetCamposExtra:CloseFiles()
   end if

   if !Empty( oLinDetCamposExtra )
      oLinDetCamposExtra:CloseFiles()
      oLinDetCamposExtra:End()
   end if

   D():DeleteView( nView )

   dbfProT              := nil
   dbfProL              := nil
   oDetCamposExtra      := nil
   oLinDetCamposExtra   := nil
   oWndBrw              := nil

RETURN .T.

//----------------------------------------------------------------------------//

Static Function aItmTmpBrw()

   local aBase := {}

   aAdd( aBase, { "CCODTBL",  "C", 40, 0, "Código de línea de propiedadades"   } )
   aAdd( aBase, { "CDESTBL",  "C", 30, 0, "Nombre de línea de propiedadades"   } )

return ( aBase )

//---------------------------------------------------------------------------//

FUNCTION retProp( cCodPrp, dbfPro )

   local oBlock
   local oError
   local lClo     := .f.
   local cPrp     := ""

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfPro )
      USE ( cPatArt() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED   ALIAS ( cCheckArea( "PRO", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "PRO.CDX" ) ADDITIVE
      lClo        := .t.
   end if

   if ValType( dbfPro ) == "O"
      if dbfPro:Seek( cCodPrp )
         cPrp     := dbfPro:cDesPro
      end if
   else
      if ( dbfPro )->( dbSeek( cCodPrp ) )
         cPrp     := ( dbfPro )->cDesPro
      end if
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClo
      CLOSE ( dbfPro )
   end if

RETURN ( cPrp )

//---------------------------------------------------------------------------//

Function IsPro()

   if !lExistTable( cPatArt() + "PRO.Dbf" ) .or.;
      !lExistTable( cPatArt() + "TBLPRO.Dbf" )
      mkPro( cPatArt() )
   end if

   if !lExistIndex( cPatArt() + "PRO.Cdx" ) .or.;
      !lExistIndex( cPatArt() + "TBLPRO.Cdx" )
      rxPro( cPatArt() )
   end if

Return ( .t. )

//----------------------------------------------------------------------------//

Function mkPro( cPath, lAppend, cPathOld, oMeter )

   local cDbf

   DEFAULT cPath     := cPatArt()
   DEFAULT lAppend   := .F.

   if !lExistTable( cPath + "Pro.Dbf" )
      dbCreate( cPath + "Pro.Dbf", aSqlStruct( aPro() ), cDriver() )
   end if 

   if lAppend .and. !Empty( cPathOld ) .and. lExistTable( cPathOld + "Pro.Dbf" )

      dbUseArea( .t., cDriver(), cPath + "Pro.Dbf", cCheckArea( "Pro", @cDbf ), .f. )

      if !( cDbf )->( neterr() )
         ( cDbf )->( __dbApp( cPathOld + "Pro.Dbf" ) )
         ( cDbf )->( dbCloseArea() )
      end if

   end if

   if !lExistTable( cPath + "TblPro.Dbf" )
      dbCreate( cPath + "TblPro.Dbf", aSqlStruct( aItmPro() ), cDriver() )
   end if 

   if lAppend .and. !Empty( cPathOld ) .and. lExistTable( cPathOld + "TblPro.Dbf" )

      dbUseArea( .t., cDriver(), cPath + "TblPro.Dbf", cCheckArea( "Pro", @cDbf ), .f. )

      if !( cDbf )->( neterr() )
         ( cDbf )->( __dbApp( cPathOld + "TblPro.Dbf" ) )
         ( cDbf )->( dbCloseArea() )
      end if

   end if

   rxPro( cPath, oMeter )

Return nil

//--------------------------------------------------------------------------//

Function rxPro( cPath, oMeter )

   local dbfPro

   DEFAULT cPath  := cPatArt()

   if !lExistTable( cPath + "PRO.DBF" ) .or. !lExistTable( cPath + "TblPro.Dbf" )
      mkPro( cPath )
   end if

   if lExistIndex( cPath + "PRO.CDX" )
      fErase( cPath + "PRO.CDX" )
   end if

   if lExistIndex( cPath + "TBLPRO.CDX" )
      fErase( cPath + "TBLPRO.CDX" )
   end if

   if lExistTable( cPath + "PRO.DBF" )

      dbUseArea( .t., cDriver(), cPath + "PRO.DBF", cCheckArea( "PRO", @dbfPro ), .f. )

      if !( dbfPro )->( neterr() )
         ( dbfPro )->( __dbPack() )

         ( dbfPro )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfPro )->( ordCreate( cPath + "PRO.CDX", "CCODPRO", "Field->CCODPRO", {|| Field->CCODPRO } ) )

         ( dbfPro )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfPro )->( ordCreate( cPath + "PRO.CDX", "CDESPRO", "Field->CDESPRO", {|| Field->CDESPRO } ) )

         ( dbfPro )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
         ( dbfPro )->( ordCreate( cPath + "PRO.CDX", "CCODWEB", "Str( Field->cCodWeb, 11 )", {|| Str( Field->cCodWeb, 11 ) } ) )

         ( dbfPro )->( dbCloseArea() )
      else
         msgStop( "Imposible abrir en modo exclusivo la tabla de propiedades" ) 
      end if

      dbUseArea( .t., cDriver(), cPath + "TBLPRO.DBF", cCheckArea( "TBLPRO", @dbfPro ), .f. )

      if !( dbfPro )->( neterr() )
         ( dbfPro )->( __dbPack() )

         ( dbfPro )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( dbfPro )->( ordCreate( cPath + "TBLPRO.CDX", "cCodPro", "upper( Field->cCodPro ) + upper( Field->cCodTbl )", {|| upper( Field->cCodPro ) + upper(  Field->cCodTbl ) } ) )

         ( dbfPro )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( dbfPro )->( ordCreate( cPath + "TBLPRO.CDX", "nOrdPro", "upper( Field->cCodPro ) + Str( Field->nOrdTbl )", {|| upper( Field->cCodPro ) + Str( Field->nOrdTbl ) } ) )

         ( dbfPro )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( dbfPro )->( ordCreate( cPath + "TBLPRO.CDX", "NBARPRO", "upper( Field->cCodPro ) + Field->nBarTbl", {|| upper( Field->cCodPro ) + Field->nBarTbl } ) )

         ( dbfPro )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( dbfPro )->( ordCreate( cPath + "TBLPRO.CDX", "CPRO", "upper( Field->cCodPro )", {|| upper( Field->cCodPro ) } ) )

         ( dbfPro )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( dbfPro )->( ordCreate( cPath + "TBLPRO.CDX", "CCODDES", "upper( Field->cCodPro ) + upper( Field->cDesTbl )", {|| upper( Field->cCodPro ) + upper( Field->cDesTbl ) } ) )

         ( dbfPro )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( dbfPro )->( ordCreate( cPath + "TBLPRO.CDX", "CCODWEB", "Str( Field->cCodWeb, 11 )", {|| Str( Field->cCodWeb, 11 ) } ) )

         ( dbfPro )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
         ( dbfPro )->( ordCreate( cPath + "TBLPRO.CDX", "CCODTBL", "Field->cCodTbl", {|| Field->cCodTbl } ) )

         ( dbfPro )->( dbCloseArea() )
      else
         msgStop( "Imposible abrir en modo exclusivo la tabla de lineas de propiedades" )
      end if

   end if

RETURN NIL

//--------------------------------------------------------------------------//

Static Function aPro()

   local aBase := {}

   aAdd( aBase, { "cCodPro",   "C", 20, 0, "Código de la propiedad"                 } )
   aAdd( aBase, { "cDesPro",   "C", 30, 0, "Nombre de la propiedad"                 } )
   aAdd( aBase, { "cCodWeb",   "N", 11, 0, "Código de la propiedad en la web"       } )
   aAdd( aBase, { "lPubInt",   "L",  1, 0, "Lógico de propiedad en la web"          } )
   aAdd( aBase, { "lSndDoc",   "L",  1, 0, "Lógico de propiedad para envio"         } )
   aAdd( aBase, { "cNomInt",   "C", 50, 0, "Nombre de la propiedad en la web"       } )
   aAdd( aBase, { "lColor",    "L",  1, 0, "Lógico tipo color"                      } )

return ( aBase )

//---------------------------------------------------------------------------//

Function aItmPro()

   local aBase := {}

   aAdd( aBase, { "cCodPro",   "C", 20, 0, "Código propiedad"                       } )
   aAdd( aBase, { "cCodTbl",   "C", 40, 0, "Código de línea de propiedad"           } )
   aAdd( aBase, { "cDesTbl",   "C", 30, 0, "Nombre de línea de propiedad"           } )
   aAdd( aBase, { "nOrdTbl",   "N",  4, 0, "Número de orden para codigos de barras" } )
   aAdd( aBase, { "nBarTbl",   "C",  4, 0, "Código para codigos de barras"          } )
   aAdd( aBase, { "cCodWeb",   "N", 11, 0, "Código del producto en la web"          } )
   aAdd( aBase, { "nColor",    "N", 10, 0, "Código de color"                        } )

return ( aBase )

//---------------------------------------------------------------------------//

Function nCosPro( cCodArt, cCodPr1, cValPr1, cCodPr2, cValPr2, dbfArtDiv )

   local nPrecioCosto        := 0

   if ( dbfArtDiv )->( dbSeek( cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 ) )
      nPrecioCosto           := ( dbfArtDiv )->nPreCom
   end if

Return ( nPrecioCosto )

//---------------------------------------------------------------------------//

Function nPreAlq( cCodArt, nTarPre, lIvaInc, dbfArtDiv )

   local  nPreAlq       := 0

   if ( dbfArtDiv )->( dbSeek( cCodArt ) )

      do case
         case nTarPre == 1
            nPreAlq  := if( lIvaInc, ( dbfArtDiv )->pAlqIva1, ( dbfArtDiv )->pAlq1 )
         case nTarPre == 2
            nPreAlq  := if( lIvaInc, ( dbfArtDiv )->pAlqIva2, ( dbfArtDiv )->pAlq2 )
         case nTarPre == 3
            nPreAlq  := if( lIvaInc, ( dbfArtDiv )->pAlqIva3, ( dbfArtDiv )->pAlq3 )
         case nTarPre == 4
            nPreAlq  := if( lIvaInc, ( dbfArtDiv )->pAlqIva4, ( dbfArtDiv )->pAlq4 )
         case nTarPre == 5
            nPreAlq  := if( lIvaInc, ( dbfArtDiv )->pAlqIva5, ( dbfArtDiv )->pAlq5 )
         case nTarPre == 6
            nPreAlq  := if( lIvaInc, ( dbfArtDiv )->pAlqIva6, ( dbfArtDiv )->pAlq6 )
      end case

   end if

Return ( nPreAlq )

//---------------------------------------------------------------------------//

Function nPrecioPorPorpiedades( cCodigoArticulo, cCodPr1, cValPr1, cCodPr2, cValPr2, dbfArtDiv, nTarPre, lIvaInc )

   local nOrden
   local nRecno
   local nPreVta        := 0

   DEFAULT nTarPre      := 1
   DEFAULT lIvaInc      := .t.

   nOrden               := ( dbfArtDiv )->( ordsetfocus() )
   nRecno               := ( dbfArtDiv )->( recno() )

   cCodigoArticulo      := padr( cCodigoArticulo, 18 )
   cCodPr1              := padr( cCodPr1, 20 )
   cValPr1              := padr( cValPr1, 20 )
   cCodPr2              := padr( cCodPr2, 20 )
   cValPr2              := padr( cValPr2, 20 )

   if dbSeekInOrd( cCodigoArticulo + cCodPr1 + cCodPr2 + cValPr1 + cValPr2, "cCodArt", dbfArtDiv )

      do case
         case nTarPre <= 1
            nPreVta     := if( lIvaInc, ( dbfArtDiv )->nPreIva1, ( dbfArtDiv )->nPreVta1 )
         case nTarPre == 2
            nPreVta     := if( lIvaInc, ( dbfArtDiv )->nPreIva2, ( dbfArtDiv )->nPreVta2 )
         case nTarPre == 3
            nPreVta     := if( lIvaInc, ( dbfArtDiv )->nPreIva3, ( dbfArtDiv )->nPreVta3 )
         case nTarPre == 4
            nPreVta     := if( lIvaInc, ( dbfArtDiv )->nPreIva4, ( dbfArtDiv )->nPreVta4 )
         case nTarPre == 5
            nPreVta     := if( lIvaInc, ( dbfArtDiv )->nPreIva5, ( dbfArtDiv )->nPreVta5 )
         case nTarPre == 6
            nPreVta     := if( lIvaInc, ( dbfArtDiv )->nPreIva6, ( dbfArtDiv )->nPreVta6 )
      end case

   end if

   ( dbfArtDiv )->( ordsetfocus( nOrden ) )
   ( dbfArtDiv )->( dbgoto( nRecno) )

Return ( nPreVta )

//---------------------------------------------------------------------------//

Function nPrePro( cCodArt, cCodPr1, cValPr1, cCodPr2, cValPr2, nTarPre, lIvaInc, dbfArtDiv, dbfTarPreL, cCodTar )

   local nPreVta     := 0

   DEFAULT nTarPre   := 1
   DEFAULT lIvaInc   := .t.

   if empty( cCodTar )
      nPreVta        := nPrecioPorPorpiedades( cCodArt, cCodPr1, cValPr1, cCodPr2, cValPr2, dbfArtDiv, nTarPre, lIvaInc )
   else
      if !empty( dbfTarPreL )
         nPreVta     := retPrcTar( cCodArt, cCodTar, cCodPr1, cCodPr2, cValPr1, cValPr2, dbfTarPreL, nTarPre )
      end if
   end if

Return ( nPreVta )

//---------------------------------------------------------------------------//

FUNCTION retValProp( cCodPrp, dbfPro )

   local oBlock
   local oError
   local lClo        := .f.
   local cPrp        := ""

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfPro )
      USE ( cPatArt() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED   ALIAS ( cCheckArea( "PROTBL", @dbfPro ) )
      SET ADSINDEX TO ( cPatArt() + "TBLPRO.CDX" ) ADDITIVE
      lClo           := .t.
   end if

   do case
      case isObject( dbfPro ) 
         if dbfPro:Seek( cCodPrp )
            cPrp     := dbfPro:cDesTbl
         end if
      case isChar( dbfPro )
         if ( dbfPro )->( dbSeek( cCodPrp ) )
            cPrp     := ( dbfPro )->cDesTbl
         end if
   end case 

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClo
      CLOSE ( dbfPro )
   end if

RETURN ( cCodPrp ) // cPrp )

//---------------------------------------------------------------------------//

FUNCTION cNombrePropiedad( cCodigoPropiedad, cValorPropiedad, dbfPro )

   local oBlock
   local oError
   local cNombrePropiedad

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if isObject( dbfPro )
      if dbfPro:Seek( cCodigoPropiedad + cValorPropiedad )
         cNombrePropiedad     := dbfPro:cDesTbl
      end if
   else
      if ( dbfPro )->( dbSeek( cCodigoPropiedad + cValorPropiedad ) )
         cNombrePropiedad     := ( dbfPro )->cDesTbl
      end if
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( cNombrePropiedad )

//---------------------------------------------------------------------------//

Static Function ChangelSndDoc( aTmp )

   local nRec

   for each nRec in ( oWndBrw:oBrw:aSelected )

      ( dbfProT )->( dbGoTo( nRec ) )

      if ( dbfProT )->( dbRLock() )
         ( dbfProT )->lSndDoc    := !( dbfProT )->lSndDoc
         ( dbfProT )->( dbCommit() )
         ( dbfProT )->( dbUnLock() )
      end if

   next

   oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

Static Function ChangePublicar( aTmp )

   local nRec

   if Empty( aTmp )

      for each nRec in ( oWndBrw:oBrw:aSelected )

         ( dbfProT )->( dbGoTo( nRec ) )

         if ( dbfProT )->( dbRLock() )
            ( dbfProT )->lPubInt   := !( dbfProT )->lPubInt
            ( dbfProT )->lSndDoc   := ( dbfProT )->lPubInt
            ( dbfProT )->( dbCommit() )
            ( dbfProT )->( dbUnLock() )
         end if

      next

      oWndBrw:Refresh()

   end if

Return nil


//---------------------------------------------------------------------------//

Function nComPro( cCodArt, cCodPr1, cValPr1, cCodPr2, cValPr2, dbfArtCom )

   local nPreCom  := 0

   if !empty( cValPr1 ) .or. !empty( cValPr2 )
      if ( dbfArtCom )->( dbSeek( cCodArt + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 ) )
         nPreCom     := ( dbfArtCom )->nPreCom
      end if
   end if 

Return ( nPreCom ) 

//---------------------------------------------------------------------------//

#ifndef __PDA__

FUNCTION brwSelectPropiedad( cPrp, cVal )

   local oDlg
   local oBrw
   local aVal 
   local aData       := {}
   local oBlock
   local oError

   if Empty( cPrp )
      MsgStop( "No hay propiedades seleccionadas para este artículo." )
      Return .f.
   end if

   if !OpenFiles()
      Return .f.
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   aVal              := hb_atokens( cVal, "," )

   // Creacion de array--------------------------------------------------------

   ( dbfProL )->( OrdSetFocus( "nOrdPro" ) )

   if ( dbfProL )->( dbSeek( cPrp ) )

      while ( dbfProL )->cCodPro == cPrp .and. !( dbfProL )->( eof() )

         aAdd( aData, { aScan( aVal, {|a| Alltrim( ( dbfProL )->cCodTbl ) == a } ) != 0, ( dbfProL )->cCodTbl, ( dbfProL )->cDesTbl } )

         ( dbfProL )->( dbSkip() )

      end while

   end if

   // Mostramos el dialogo-----------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "SelectPropiedad"  TITLE "Seleccionar propiedad : " + retProp( cPrp, dbfProT )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( SelectPropiedadDblClick( oBrw, aData ) )

      REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         ACTION   ( SelectPropiedadDblClick( oBrw, aData, .t. ) )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       oDlg ;
         ACTION   ( SelectPropiedadDblClick( oBrw, aData, .f. ) )

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:SetArray( aData )

      oBrw:nMarqueeStyle   := 5
      oBrw:lHScroll        := .t.

      oBrw:bLDblClick      := {|| SelectPropiedadDblClick( oBrw, aData ) }

      oBrw:CreateFromResource( 100 )

      with object ( oBrw:aCols[ 1 ] )
         :cHeader       := "Sel."
         :bEditValue    := {|| aData[ oBrw:nArrayAt, 1 ] }
         :nWidth        := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrw:aCols[ 2 ] )
         :cHeader       := "Código"
         :bEditValue    := {|| aData[ oBrw:nArrayAt, 2 ] }
         :nWidth        := 180
      end with

      with object ( oBrw:aCols[ 3 ] )
         :cHeader       := "Nombre"
         :bEditValue    := {|| aData[ oBrw:nArrayAt, 3 ] }
         :nWidth        := 280
      end with

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if ( oDlg:nResult == IDOK )
      cVal        := SelectedPropiedadToMemo( aData )
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible mostrar tablas de propiedades" )

   END SEQUENCE
   ErrorBlock( oBlock )

   CloseFiles()

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function SelectPropiedadDblClick( oBrw, aData, lAllSelected )

   if !Empty( aData )

      do case
         case IsNil( lAllSelected )

            aData[ oBrw:nArrayAt, 1 ]  := !aData[ oBrw:nArrayAt, 1 ]

         case IsTrue( lAllSelected )

            aEval( aData, {|a| a[ 1 ] := .t. } )

         case IsFalse( lAllSelected )

            aEval( aData, {|a| a[ 1 ] := .f. } )

      end case


   end if

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function SelectedPropiedadToMemo( aData )

   local cMemo := ""

   aEval( aData, {|aItem| if( aItem[ 1 ], cMemo += Rtrim( aItem[ 2 ] ) + ",", ) } )

Return ( cMemo )

//---------------------------------------------------------------------------//

Static Function Actualizaweb( cCodPrp, lActualizaweb )

   if lActualizaWeb .and. uFieldEmpresa( "lRealWeb" )

      if lPubPrp()

         with object ( TComercio():New() )    
            :ActualizaPropiedadesPrestashop( cCodPrp, nTipoActualizacionLineas )
         end with  

      end if   

   end if   

Return .t.

//---------------------------------------------------------------------------//

Static Function lPubPrp()

   local lPub  := .f.

   if ( dbfProT )->lPubInt
      lPub     := .t.
   else
      if ( dbfProT )->cCodWeb != 0
         lPub  := .t.
      end if
   end if

Return lPub

//---------------------------------------------------------------------------//

Function hidePropertiesTable( oBrw )

   if !empty( oBrw )
      oBrw:Hide()
      oBrw:Cargo                 := nil
   end if 

Return ( nil )   

//---------------------------------------------------------------------------//

Function setPropertiesTable( cCodArt, cCodPr1, cCodPr2, nPrecioCosto, oGetUnidades, oBrw, nView )

   local n
   local a
   local o
   local nRow                    := 1
   local nCol                    := 1
   local nTotalRow               := 0
   local nTotalCol               := 0
   local aSizesTable             := {}
   local aHeadersTable           := {}
   local aJustifyTable           := {}
   local hValorPropiedad
   local aPropertiesTable        := {}
   local aPropiedadesArticulo1   
   local aPropiedadesArticulo2   

   aPropiedadesArticulo1         := aPropiedadesArticulo1( cCodArt, nView ) 
   nTotalRow                     := len( aPropiedadesArticulo1 )
   if nTotalRow != 0
      aPropiedadesArticulo2      := aPropiedadesArticulo2( cCodArt, nView ) 
   else 
      aPropiedadesArticulo1      := aPropiedadesGeneral( cCodPr1, nView )
      nTotalRow                  := len( aPropiedadesArticulo1 )
      if nTotalRow != 0
         aPropiedadesArticulo2   := aPropiedadesGeneral( cCodPr2, nView )
      else
         Return nil
      end if 
   end if

   // Montamos los array con las propiedades-----------------------------------

   if len( aPropiedadesArticulo2 ) == 0
      nTotalCol                  := 2
   else
      nTotalCol                  := len( aPropiedadesArticulo2 ) + 1
   end if

   aPropertiesTable              := array( nTotalRow, nTotalCol )

   if ( D():Propiedades( nView ) )->( dbSeek( cCodPr1 ) )
      aadd( aHeadersTable, ( D():Propiedades( nView ) )->cDesPro )
      aadd( aSizesTable, 60 )
      aadd( aJustifyTable, .f. )
   end if

   for each hValorPropiedad in aPropiedadesArticulo1

      aPropertiesTable[ nRow, nCol ]                        := TPropertiesItems():New()
      aPropertiesTable[ nRow, nCol ]:cCodigo                := cCodArt
      aPropertiesTable[ nRow, nCol ]:cHead                  := hValorPropiedad[ "TipoPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:cText                  := hValorPropiedad[ "CabeceraPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:cCodigoPropiedad1      := hValorPropiedad[ "CodigoPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:cValorPropiedad1       := hValorPropiedad[ "ValorPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:lColor                 := hValorPropiedad[ "ColorPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:nRgb                   := hValorPropiedad[ "RgbPropiedad" ]

      nRow++
   
   next

   if !empty( cCodPr2 ) .and. !empty( aPropiedadesArticulo2 )

      for each hValorPropiedad in aPropiedadesArticulo2

         nCol++

         aadd( aHeadersTable, hValorPropiedad[ "CabeceraPropiedad" ] )
         aadd( aSizesTable, 60 )
         aadd( aJustifyTable, .t. )

         for n := 1 to nTotalRow
            aPropertiesTable[ n, nCol ]                     := TPropertiesItems():New()
            aPropertiesTable[ n, nCol ]:Value               := 0
            aPropertiesTable[ n, nCol ]:cHead               := hValorPropiedad[ "CabeceraPropiedad" ]
            aPropertiesTable[ n, nCol ]:cCodigo             := cCodArt
            aPropertiesTable[ n, nCol ]:cCodigoPropiedad1   := aPropertiesTable[ n, 1 ]:cCodigoPropiedad1
            aPropertiesTable[ n, nCol ]:cValorPropiedad1    := aPropertiesTable[ n, 1 ]:cValorPropiedad1
            aPropertiesTable[ n, nCol ]:cCodigoPropiedad2   := hValorPropiedad[ "CodigoPropiedad" ]
            aPropertiesTable[ n, nCol ]:cValorPropiedad2    := hValorPropiedad[ "ValorPropiedad" ]
            aPropertiesTable[ n, nCol ]:lColor              := aPropertiesTable[ n, 1 ]:lColor
            aPropertiesTable[ n, nCol ]:nRgb                := aPropertiesTable[ n, 1 ]:nRgb
         next

      next

   else

      nCol++

      aAdd( aHeadersTable, "Unidades" )
      aAdd( aSizesTable,   60 )
      aAdd( aJustifyTable, .t. )

      for n := 1 to nTotalRow
         aPropertiesTable[ n, nCol ]                        := TPropertiesItems():New()
         aPropertiesTable[ n, nCol ]:Value                  := 0
         aPropertiesTable[ n, nCol ]:cHead                  := "Unidades"
         aPropertiesTable[ n, nCol ]:cCodigo                := cCodArt
         aPropertiesTable[ n, nCol ]:cCodigoPropiedad1      := aPropertiesTable[ n, 1 ]:cCodigoPropiedad1
         aPropertiesTable[ n, nCol ]:cValorPropiedad1       := aPropertiesTable[ n, 1 ]:cValorPropiedad1
         aPropertiesTable[ n, nCol ]:cCodigoPropiedad2      := Space( 20 )
         aPropertiesTable[ n, nCol ]:cValorPropiedad2       := Space( 40 )
         aPropertiesTable[ n, nCol ]:lColor                 := aPropertiesTable[ n, 1 ]:lColor
         aPropertiesTable[ n, nCol ]:nRgb                   := aPropertiesTable[ n, 1 ]:nRgb
      next

   end if

   // Calculo de precios-------------------------------------------------------

   for each a in aPropertiesTable
      for each o in a
         if IsObject( o )
            o:PrecioCompra( nPrecioCosto, D():ArticuloPrecioPropiedades( nView ) )
         end if
      next
   next

   // Asignamos la informacion al browse---------------------------------------

   if !empty( oBrw ) 

      oBrw:aCols                 := {}
      oBrw:Cargo                 := aPropertiesTable   
      oBrw:nFreeze               := 1
      
      oBrw:SetArray( aPropertiesTable, .f., 0, .f. )

      for n := 1 to len( aPropertiesTable[ 1 ] )

         if isNil( aPropertiesTable[ oBrw:nArrayAt, n ]:Value )

            // Columna del titulo de la propiedad------------------------------

            with object ( oBrw:AddCol() )
               :Adjust()
               :cHeader          := aPropertiesTable[ oBrw:nArrayAt, n ]:cHead
               :bEditValue       := bGenEditText( aPropertiesTable, oBrw, n )
               :nWidth           := 100
               :bFooter          := {|| "Total" }
            end with

            // Columna del color de la propiedad

            if aPropertiesTable[ oBrw:nArrayAt, n ]:lColor

               with object ( oBrw:AddCol() )
                  :Adjust()
                  :cHeader       := "Color"
                  :nWidth        := 40
                  :bFooter       := {|| "" }
                  :bStrData      := {|| "" }
                  :nWidth        := 16
                  :bClrStd       := bGenRGBValue( aPropertiesTable, oBrw, n )
                  :bClrSel       := bGenRGBValue( aPropertiesTable, oBrw, n )
                  :bClrSelFocus  := bGenRGBValue( aPropertiesTable, oBrw, n )
               end with
               
               oBrw:nFreeze++
               oBrw:nColOffset++

            end if 

         else

            with object ( oBrw:AddCol() )
               :Adjust()
               :cHeader          := aPropertiesTable[ oBrw:nArrayAt, n ]:cHead
               :bEditValue       := bGenEditValue( aPropertiesTable, oBrw, n )
               :cEditPicture     := MasUnd()
               :nWidth           := 50
               :setAlign( AL_RIGHT )
               :nFooterType      := AGGR_SUM
               :nEditType        := EDIT_GET
               :nHeadStrAlign    := AL_RIGHT
               :bOnPostEdit      := {| oCol, xVal, nKey | bPostEditProperties( oCol, xVal, nKey, oBrw, oGetUnidades ) }
               :nFootStyle       := :defStyle( AL_RIGHT, .t. )               
               :Cargo            := n
            end with

         end if

      next
         
      oBrw:aCols[ 1 ]:Hide()
      oBrw:Adjust()

      oBrw:nColSel               := oBrw:nFreeze + 1

      oBrw:nRowHeight            := 20
      oBrw:nHeaderHeight         := 20
      oBrw:nFooterHeight         := 20

      oBrw:Show()
      
   end if

Return ( aPropertiesTable )

//---------------------------------------------------------------------------//

Function setValuesPropertiesTable( dbfLines, oBrw )

   local oProperties
   local aProperties

   for each aProperties in ( oBrw:Cargo )
      
      for each oProperties in aProperties

         if alltrim( oProperties:cCodigoPropiedad1 ) == alltrim( ( dbfLines )->cCodPr1 )  .and.;
            alltrim( oProperties:cValorPropiedad1 ) == alltrim( ( dbfLines )->cValPr1 )   .and.;
            alltrim( oProperties:cCodigoPropiedad2 ) == alltrim( ( dbfLines )->cCodPr2 )  .and.;
            alltrim( oProperties:cValorPropiedad2 ) == alltrim( ( dbfLines )->cValPr2 )  

            oProperties:Value := ( dbfLines )->nUniCaja

         end if 
      
      next 
   
   next 

Return ( nil )

//---------------------------------------------------------------------------//

Function aPropiedadesArticulo1( cCodigoArticulo, nView )

Return ( aPropiedadesArticulo( cCodigoArticulo, nView, "cCodPr1", "cValPr1" ) )

//---------------------------------------------------------------------------//

Function aPropiedadesArticulo2( cCodigoArticulo, nView )

Return ( aPropiedadesArticulo( cCodigoArticulo, nView, "cCodPr2", "cValPr2" ) )

//---------------------------------------------------------------------------//

Function aPropiedadesArticulo( cCodigoArticulo, nView, cFieldCodigo, cValueCodigo )

   local aValores    := {}

   cCodigoArticulo   := rtrim( cCodigoArticulo )

   D():getInitStatus( "ArtDiv", nView )

   if ( D():ArticuloPrecioPropiedades( nView ) )->( dbSeek( cCodigoArticulo ) )

      while rtrim( ( D():ArticuloPrecioPropiedades( nView ) )->cCodArt ) == cCodigoArticulo .and. !( D():ArticuloPrecioPropiedades( nView ) )->( eof() )

         if !isValoresPorpiedad( aValores, nView, cFieldCodigo, cValueCodigo )
            addValoresPorpiedad( aValores, nView, cCodigoArticulo, cFieldCodigo, cValueCodigo )
         end if 

         ( D():ArticuloPrecioPropiedades( nView ) )->( dbskip() )

      end while

   end if 

   // asort( aValores, , , {|x,y| val( x[ "ValorPropiedad" ] ) < val( y[ "ValorPropiedad" ] ) } )

   asort( aValores, , , {|x,y| x[ "OrdenPropiedad" ] < y[ "OrdenPropiedad" ] } )

   D():setStatus( "ArtDiv", nView )

Return ( aValores )

//---------------------------------------------------------------------------//

Static Function isValoresPorpiedad( aValores, nView, cFieldCodigo, cValueCodigo )

Return ( ascan( aValores, {| hash | rtrim( hash[ "CodigoPropiedad" ] ) == rtrim( ( D():ArticuloPrecioPropiedades( nView ) )->( fieldGetByName( cFieldCodigo ) ) ) .and. rtrim( hash[ "ValorPropiedad" ] ) == rtrim( ( D():ArticuloPrecioPropiedades( nView ) )->( fieldGetByName( cValueCodigo ) ) ) } ) != 0 )

//---------------------------------------------------------------------------//

Static Function addValoresPorpiedad( aValores, nView, cCodigoArticulo, cFieldCodigo, cValueCodigo )

   local hPropiedad   
   local cCodigoPropiedad  := ( D():ArticuloPrecioPropiedades( nView ) )->( fieldGetByName( cFieldCodigo ) )
   local cValorPropiedad   := ( D():ArticuloPrecioPropiedades( nView ) )->( fieldGetByName( cValueCodigo ) )

   hPropiedad  := {  "CodigoPropiedad"    => rtrim( cCodigoPropiedad ),;
                     "ValorPropiedad"     => rtrim( cValorPropiedad ),;
                     "TipoPropiedad"      => rtrim( retFld( cCodigoPropiedad, D():Propiedades( nView ), "cDesPro" ) ),;
                     "ColorPropiedad"     => retFld( cCodigoPropiedad, D():Propiedades( nView ), "lColor" ),;
                     "CabeceraPropiedad"  => rtrim( retFld( cCodigoPropiedad + cValorPropiedad, D():PropiedadesLineas( nView ), "cDesTbl" ) ),;
                     "RgbPropiedad"       => retFld( cCodigoPropiedad + cValorPropiedad, D():PropiedadesLineas( nView ), "nColor" ),;
                     "OrdenPropiedad"     => retFld( cCodigoPropiedad + cValorPropiedad, D():PropiedadesLineas( nView ), "nOrdTbl" ) }

Return ( aadd( aValores, hPropiedad ) )

//---------------------------------------------------------------------------//

Function aPropiedadesGeneral( cCodigoPropiedad, nView )

   local aPropiedades    := {}

   D():getInitStatus( "TblPro", nView )
   ( D():Get( "TblPro", nView ) )->( ordsetfocus( "nOrdPro" ) )

   if ( D():PropiedadesLineas( nView ) )->( dbSeek( cCodigoPropiedad ) )

      while ( D():PropiedadesLineas( nView ) )->cCodPro == cCodigoPropiedad .and. !( D():PropiedadesLineas( nView ) )->( eof() )

         addPropiedades( aPropiedades, nView, cCodigoPropiedad )

         ( D():PropiedadesLineas( nView ) )->( dbskip() )

      end while

   end if 

   D():setStatus( "TblPro", nView )

Return ( aPropiedades )

//---------------------------------------------------------------------------//

Static Function addPropiedades( aPropiedades, nView, cCodigoPropiedad )

   local hPropiedad   
   local cValorPropiedad   := ( D():PropiedadesLineas( nView ) )->cCodTbl

   hPropiedad  := {  "CodigoPropiedad"    => rtrim( cCodigoPropiedad ),;
                     "ValorPropiedad"     => rtrim( cValorPropiedad ),;
                     "TipoPropiedad"      => rtrim( retFld( cCodigoPropiedad, D():Propiedades( nView ), "cDesPro" ) ),;
                     "ColorPropiedad"     => retFld( cCodigoPropiedad, D():Propiedades( nView ), "lColor" ),;
                     "CabeceraPropiedad"  => rtrim( retFld( cCodigoPropiedad + cValorPropiedad, D():PropiedadesLineas( nView ), "cDesTbl" ) ),;
                     "RgbPropiedad"       => retFld( cCodigoPropiedad + cValorPropiedad, D():PropiedadesLineas( nView ), "nColor" ) }

Return ( aadd( aPropiedades, hPropiedad ) )

//---------------------------------------------------------------------------//

FUNCTION nombrePropiedad( cCodigoPropiedad, cValorPropiedad, nView )

   local cNombrePropiedad  := ""

   if D():gotoIdPropiedadesLineas( cCodigoPropiedad + cValorPropiedad, nView ) 
      cNombrePropiedad     := ( D():PropiedadesLineas( nView ) )->cDesTbl
   end if

RETURN ( cNombrePropiedad )

//---------------------------------------------------------------------------//

CLASS TPropiedadesSenderReciver FROM TSenderReciverItem

   Method CreateData()

   Method RestoreData()

   Method SendData()

   Method ReciveData()

   Method Process()

   Method CleanRelation( cCodArt )

END CLASS

//----------------------------------------------------------------------------//

Method CreateData()

   local oBlock
   local oError
   local tmpProT
   local tmpProL
   local lSnd        := .f.
   local cFileName   := ::getFileNameToSend( "Pro" )

   if !OpenFiles( .f. )
      return nil
   end if

   ::oSender:SetText( 'Seleccionando propiedades' )

   /*
   Creamos todas las bases de datos relacionadas con Articulos
   */

   mkPro( cPatSnd() )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatSnd() + "PRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @tmpProT ) )
   SET ADSINDEX TO ( cPatSnd() + "PRO.CDX" ) ADDITIVE

   USE ( cPatSnd() + "TBLPRO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @tmpProL ) )
   SET ADSINDEX TO ( cPatSnd() + "TBLPRO.CDX" ) ADDITIVE

   if !empty( ::oSender:oMtr )
      ::oSender:oMtr:nTotal := ( dbfProT )->( lastrec() )
   end if

   ( dbfProT )->( dbGoTop() )
   while !( dbfProT )->( eof() )

      if ( dbfProT )->lSndDoc

         ::oSender:SetText( alltrim( ( dbfProT )->cCodPro ) + "; " + alltrim( ( dbfProT )->cDesPro ) )
         
         lSnd     := .t.

         dbPass( dbfProT, tmpProT, .t. )

         /*
         lineas de propiedades-------------------------------------------------
         */

         if ( dbfProL )->( dbSeek( ( dbfProT )->cCodPro ) )
            while ( dbfProL )->cCodPro == ( dbfProT )->cCodPro .and. !( dbfProL )->( eof() )
               dbPass( dbfProL, tmpProL, .t. )
               ( dbfProL )->( dbSkip() )
            end while
         end if

      end if

      ( dbfProT )->( dbSkip() )

      if !empty( ::oSender:oMtr )
         ::oSender:oMtr:Set( ( dbfProT )->( ordkeyno() ) )
      end if

      SysRefresh()

   end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de propiedades" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( tmpProT )
   CLOSE ( tmpProL )

   CloseFiles()

   /*
   Comprimir los archivos------------------------------------------------------
   */

   if lSnd

      ::oSender:SetText( "Comprimiendo propiedades : " + cFileName )

      if ::oSender:lZipData( cFileName )
         ::oSender:SetText( "Ficheros comprimidos" )
      else
         ::oSender:SetText( "ERROR al crear fichero comprimido" )
      end if

   else

      ::oSender:SetText( "No hay propiedades para enviar" )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method RestoreData()

   local oBlock
   local oError
   local dbfProT
   local dbfProL

   if !( ::lSuccesfullSend )
      return nil
   end if

   if !OpenFiles( .f. )
      return nil
   end if

   /*
   Sintuacion despues del envio---------------------------------------------
   */

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      while !( dbfProT )->( Eof() )

         if ( dbfProT )->lSndDoc .and. ( dbfProT )->( dbRLock() )
            ( dbfProT )->lSndDoc   := .f.
            ( dbfProT )->( dbRUnlock() )
         end if

         ( dbfProT )->( dbSkip() )

      end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de propiedades" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CloseFiles()

Return ( Self )

//---------------------------------------------------------------------------//

Method SendData()

   local cFileName   := ::getFileNameToSend( "Pro" )

   if !file( cPatOut() + cFileName )
      Return ( Self )
   end if 

   if ::oSender:SendFiles( cPatOut() + cFileName, cFileName )
      ::IncNumberToSend()
      ::lSuccesfullSend := .t.
      ::oSender:SetText( "Ficheros de propiedades enviados " + cFileName )
   else
      ::oSender:SetText( "ERROR fichero de propiedades no enviado" )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method ReciveData()

   local cExt
   local aExt

   if ::oSender:lServer
      aExt              := aRetDlgEmp()
   else
      aExt              := { "All" }
   end if

   ::oSender:SetText( "Recibiendo propiedades" )

   for each cExt in aExt 
      ::oSender:GetFiles( "Pro*." + cExt, cPatIn() )
   next

   ::oSender:SetText( "Propiedades recibidas" )

Return ( Self )

//---------------------------------------------------------------------------//

Method Process()

   local cFile
   local aFiles
   local tmpProT
   local tmpProL
   local oBlock
   local oError

   /*
   Procesamos los ficheros recibidos-------------------------------------------
   */

   aFiles                     := Directory( cPatIn() + "Pro*.*" )

   for each cFile in aFiles 

      oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      /*
      Descomprimimos el fichero recibido------------------------------------
      */

      if ::oSender:lUnZipData( cPatIn() + cFile[ 1 ] )

         if lExistTable( cPatSnd() + "Pro.Dbf", cLocalDriver() )     .and. ;
            lExistTable( cPatSnd() + "TblPro.Dbf", cLocalDriver() )  .and. ;
            OpenFiles( .f. )

            USE ( cPatSnd() + "Pro.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PRO", @tmpProT ) )
            SET ADSINDEX TO ( cPatSnd() + "Pro.Cdx" ) ADDITIVE

            USE ( cPatSnd() + "TblPro.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBLPRO", @tmpProL ) )
            SET ADSINDEX TO ( cPatSnd() + "TblPro.Cdx" ) ADDITIVE

            ::oSender:SetText( "Total de registros recibidos " + alltrim( str( ( tmpProT )->( lastrec() ) ) ) )

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpProT )->( lastrec() )
            end if

            ( tmpProT )->( ordsetfocus( 0 ) )
            ( tmpProT )->( dbgotop() )
            while !( tmpProT )->( eof() )

               if ( dbfProT )->( dbSeek( ( tmpProT )->cCodTbl ) )

                  if !::oSender:lServer
                     
                     ::cleanRelation( ( tmpProT )->cCodTbl )
                     
                     dbPass( tmpProT, dbfProT )

                     /*if dbLock( dbfProT )
                        ( dbfProT )->lSndDoc := .f.
                        ( dbfProT )->( dbUnLock() )
                     end if*/

                     ::oSender:SetText( "Reemplazado : " + alltrim( ( dbfProT )->cCodPro ) + "; " + alltrim( ( dbfProT )->cDesPro ) )

                  else

                     ::oSender:SetText( "Desestimado : " + alltrim( ( dbfProT )->cCodPro ) + "; " + alltrim( ( dbfProT )->cDesPro ) )

                  end if

               else

                  ::CleanRelation( ( tmpProT )->cCodTbl )

                  dbPass( tmpProT, dbfProT, .t. )

                  /*if dbLock( dbfProT )
                     ( dbfProT )->lSndDoc := .f.
                     ( dbfProT )->( dbUnLock() )
                  end if*/

                  ::oSender:SetText( "Añadido : " + alltrim( ( dbfProT )->cCodPro ) + "; " + alltrim( ( dbfProT )->cDesPro ) )
                  
               end if

               ( tmpProT )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpProT )->( OrdKeyNo() ) )
               end if

               SysRefresh()

            end while

            if !Empty( ::oSender:oMtr )
               ::oSender:oMtr:nTotal := ( tmpProL )->( LastRec() )
            end if

            ( tmpProL )->( ordsetfocus( 0 ) )
            ( tmpProL )->( dbgotop() )

            while !( tmpProL )->( eof() )

               if ( dbfProL )->( dbSeek( ( tmpProL )->cCodArt ) )
                  if !::oSender:lServer
                     dbPass( tmpProL, dbfProL )
                  end if
               else
                  dbPass( tmpProL, dbfProL, .t. )
               end if

               ( tmpProL )->( dbSkip() )

               if !Empty( ::oSender:oMtr )
                  ::oSender:oMtr:Set( ( tmpProL )->( recno() ) )
               end if

               SysRefresh()

            end while

            CLOSE ( tmpProT )
            CLOSE ( tmpProL )

            CloseFiles()

            ::oSender:AppendFileRecive( cFile[ 1 ] )

         else

            ::oSender:SetText( "Faltan ficheros" )

            if !lExistTable( cPatSnd() + "Pro.Dbf"   )
               ::oSender:SetText( "Falta" + cPatSnd() + "Pro.Dbf" )
            end if

            if !lExistTable( cPatSnd() + "TblPro.Dbf"    )
               ::oSender:SetText( "Falta" + cPatSnd() + "TblPro.Dbf" )
            end if

         end if

      else

         ::oSender:SetText( "Error en el fichero comprimido" )

      end if

      RECOVER USING oError

         CLOSE ( tmpProT )
         CLOSE ( tmpProL )

         ::oSender:SetText( "Error procesando fichero " + cFile[ 1 ] )
         ::oSender:SetText( ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   next

Return ( Self )

//---------------------------------------------------------------------------//

Method CleanRelation( idPropiedad )

   while ( dbfProL )->( dbSeek( idPropiedad ) )
      dbDel( dbfProL )
   end while

   SysRefresh()

Return ( Self )

//---------------------------------------------------------------------------//
