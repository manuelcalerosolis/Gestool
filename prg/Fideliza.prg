#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

Function StartTFideliza()

   local oFideliza

   oFideliza      := TFideliza():New( cPatEmp(), cDriver(), oWnd(), "programa_de_fidelizacion" )

   if !Empty( oFideliza )
      oFideliza:Activate()
   end if

Return nil

//----------------------------------------------------------------------------//

CLASS TFideliza FROM TMasDet

   DATA  cMru                 INIT "gc_id_card_16"
   DATA  cBitmap              INIT clrTopArchivos
   DATA  aData                INIT {}

   DATA  oDetFideliza

   DATA  oImageList

   DATA  oTreeRango
   DATA  oBrwRango

   DATA  oDbfFam
   DATA  oDbfTip
   DATA  oDbfCat
   DATA  oDbfFab
   DATA  oDbfTem

   DATA  oChk
   DATA  lAll                 INIT .f.

   DATA  oBtnSelectAll
   DATA  oBtnSelectNone

   METHOD New()
   METHOD CreateInit( cPath )
   METHOD Create( cPath )

   METHOD OpenFiles( lExclusive )
   METHOD OpenService( lExclusive )

   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( oGet, nMode )

   METHOD InitResource()

   METHOD TreeChanged()
   METHOD TreeLostFocus()     VIRTUAL

   METHOD BrowseDblClick()

   METHOD ChkChanged()

   METHOD LoadFamilia()

   METHOD LoadTipo()

   METHOD LoadFabricante()

   METHOD LoadTemporada()

   METHOD SelectedToMemo()

   METHOD InPrograma( cCodigoArticulo, dFechaVenta, dbfArticulo )

   METHOD nPorcentajePrograma( nImporte )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()
   DEFAULT oWndParent   := GetWndFrame()

   ::cDriver            := cDriver

   if oMenuItem != nil .and. ::nLevel == nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := 1
   end if

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent

   ::bFirstKey          := {|| ::oDbf:cCodigo }

   ::oDetFideliza       := TDetFideliza():New( cPath, cDriver, Self )
   ::AddDetail( ::oDetFideliza )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD CreateInit( cPath, cDriver )

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath
   ::cDriver            := cDriver

   ::bFirstKey          := {|| ::oDbf:cCodigo }

   ::oDetFideliza       := TDetFideliza():New( cPath, cDriver, Self )
   ::addDetail( ::oDetFideliza )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Create( cPath, cDriver )

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath
   ::cDriver            := cDriver

   ::oDbf               := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::OpenDetails()

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de programas de fidelizaciones" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock         

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      lOpen             := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos de programas de fidelizaciones" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf      := nil
   end if

   ::CloseDetails()

   if ::oDbfFam != nil .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if ::oDbfTip != nil .and. ::oDbfTip:Used()
      ::oDbfTip:End()
   end if

   if ::oDbfCat != nil .and. ::oDbfCat:Used()
      ::oDbfCat:End()
   end if

   if ::oDbfFab != nil .and. ::oDbfFab:Used()
      ::oDbfFab:End()
   end if

   if ::oDbfTem != nil .and. ::oDbfTem:Used()
      ::oDbfTem:End()
   end if

RETURN .t.

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE ::oDbf FILE "Fideliza.Dbf" CLASS "Fideliza" ALIAS "Fideliza" PATH ( cPath ) VIA ( cDriver ) COMMENT "Fidelización"

      FIELD NAME "cCodigo"    TYPE "C" LEN 03  DEC 0 COMMENT "Código"      COLSIZE 60     OF ::oDbf
      FIELD NAME "cDescrip"   TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"      COLSIZE 400    OF ::oDbf
      FIELD NAME "dInicio"    TYPE "D" LEN 08  DEC 0 COMMENT "Inicio"      COLSIZE 80     OF ::oDbf
      FIELD NAME "dFin"       TYPE "D" LEN 08  DEC 0 COMMENT "Fin"         COLSIZE 80     OF ::oDbf
      FIELD NAME "mFamilia"   TYPE "M" LEN 10  DEC 0 COMMENT "Familia"     HIDE           OF ::oDbf
      FIELD NAME "mTipo"      TYPE "M" LEN 10  DEC 0 COMMENT "Tipo"        HIDE           OF ::oDbf
      FIELD NAME "mFabricant" TYPE "M" LEN 10  DEC 0 COMMENT "Fabricante"  HIDE           OF ::oDbf
      FIELD NAME "mTemporada" TYPE "M" LEN 10  DEC 0 COMMENT "Temporada"   HIDE           OF ::oDbf
      FIELD NAME "lFamilia"   TYPE "L" LEN 01  DEC 0 COMMENT ""            HIDE           OF ::oDbf
      FIELD NAME "lTipo"      TYPE "L" LEN 01  DEC 0 COMMENT ""            HIDE           OF ::oDbf
      FIELD NAME "lFabricant" TYPE "L" LEN 01  DEC 0 COMMENT ""            HIDE           OF ::oDbf
      FIELD NAME "lTemporada" TYPE "L" LEN 01  DEC 0 COMMENT ""            HIDE           OF ::oDbf

      INDEX TO "Fideliza.Cdx" TAG "cCodigo"     ON "cCodigo"   COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "Fideliza.Cdx" TAG "cDescrip"    ON "cDescrip"  COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oBrwLineas
   local oGetSec
   local oGetHor
   local oBmpGeneral

   DEFINE DIALOG oDlg RESOURCE "Fideliza" TITLE LblTitle( nMode ) + "programa de fidelización"

      REDEFINE BITMAP oBmpGeneral ;
        ID       990 ;
        RESOURCE "gc_id_card_48" ;
        TRANSPARENT ;
        OF       oDlg

      REDEFINE GET oGet VAR ::oDbf:cCodigo ;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDescrip ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:dInicio ;
         ID       130 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       oDlg

      REDEFINE GET ::oDbf:dFin;
         ID       140 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       oDlg

      /*
      Tree de los rangos----------------------------------------------------------
      */

      ::oImageList                  := TImageList():New( 16, 16 )

      ::oTreeRango                  := TTreeView():Redefine( 300, oDlg )
      ::oTreeRango:bChanged         := {|| ::TreeChanged() }
      ::oTreeRango:bLostFocus       := {|| ::TreeLostFocus() }

      /*
      Browse de los rangos----------------------------------------------------------
      */

      ::oBrwRango                   := IXBrowse():New( oDlg )

      ::oBrwRango:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwRango:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwRango:SetArray( ::aData, , , .f. )

      ::oBrwRango:lHScroll          := .f.
      ::oBrwRango:lVScroll          := .f.
      ::oBrwRango:nMarqueeStyle     := 5
      ::oBrwRango:lRecordSelector   := .t.

      ::oBrwRango:bLDblClick        := {|| ::BrowseDblClick() }

      ::oBrwRango:CreateFromResource( 310 )

      with object ( ::oBrwRango:AddCol() )
         :cHeader       := "Sel."
         :bEditValue    := {|| ::aData[ ::oBrwRango:nArrayAt, 1 ] }
         :nWidth        := 25
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( ::oBrwRango:AddCol() )
         :cHeader       := "Código"
         :bEditValue    := {|| ::aData[ ::oBrwRango:nArrayAt, 2 ] }
         :nWidth        := 100
      end with

      with object ( ::oBrwRango:AddCol() )
         :cHeader       := "Nombre"
         :bEditValue    := {|| ::aData[ ::oBrwRango:nArrayAt, 3 ] }
         :nWidth        := 300
      end with

      REDEFINE BUTTON ::oBtnSelectAll ;
         ID       320 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::BrowseDblClick( .t. ) )

      REDEFINE BUTTON ::oBtnSelectNone ;
         ID       330 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::BrowseDblClick( .f. ) )

      REDEFINE CHECKBOX ::oChk ;
         VAR      ::lAll ;
         ID       340 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg ;

      ::oChk:bChange := {|| ::ChkChanged() }

      /*
      Costes de maquinaria-----------------------------------------------------
      */

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetFideliza:Append( oBrwLineas ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetFideliza:Edit( oBrwLineas ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oDlg ;
         ACTION   ( ::oDetFideliza:Zoom() )

      REDEFINE BUTTON ;
         ID       503 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDetFideliza:Del( oBrwLineas ) )

      oBrwLineas                    := IXBrowse():New( oDlg )

      oBrwLineas:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLineas:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oDetFideliza:oDbfVir:SetBrowse( oBrwLineas )

      oBrwLineas:nMarqueeStyle      := 5

      oBrwLineas:bLDblClick         := { || ::oDetFideliza:Edit( oBrwLineas ) }

      oBrwLineas:CreateFromResource( 200 )

      with object ( oBrwLineas:AddCol() )
         :cHeader                   := "Naturaleza"
         :bStrData                  := {|| if( ::oDetFideliza:oDbfVir:nImpUni == 1, "Importe > " + Alltrim( Trans( ::oDetFideliza:oDbfVir:nImporte, cPouDiv() ) ), "Unidades > " + Alltrim( Trans( ::oDetFideliza:oDbfVir:nUnidades, MasUnd() ) ) ) }
         :nWidth                    := 580
      end with

      with object ( oBrwLineas:AddCol() )
         :cHeader                   := "% Descuento"
         :bStrData                  := {|| ::oDetFideliza:oDbfVir:nPorcen }
         :cEditPicture              := "@E 999.99"
         :nWidth                    := 130
         :nDataStrAlign             := 1
         :nHeadStrAlign             := 1
      end with

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( oGet, nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( MsgInfo( "Ayuda no definida" ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F2, {|| ::oDetFideliza:Append( oBrwLineas ) } )
         oDlg:AddFastKey( VK_F3, {|| ::oDetFideliza:Edit( oBrwLineas ) } )
         oDlg:AddFastKey( VK_F4, {|| ::oDetFideliza:Del( oBrwLineas ) } )
         oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( oGet, nMode ), oDlg:end( IDOK ), ) } )
      end if

      oDlg:bStart := {|| ::InitResource() }

	ACTIVATE DIALOG oDlg	CENTER

   oBmpGeneral:End()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( oGet, nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( ::oDbf:cCodigo )
         MsgStop( "Código del programa no puede estar vacío." )
         return .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodigo, "cCodigo" )
         msgStop( "Código del programa ya existe." )
         return .f.
      end if

   end if

   if Empty( ::oDbf:cDescrip )
      MsgStop( "La descripción del programa no puede estar vacio." )
      return .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD InitResource()

   ::oTreeRango:Add( "Familias",    0 )
   ::oTreeRango:Add( "Tipos",       1 )
   ::oTreeRango:Add( "Fabricantes", 2 )
   ::oTreeRango:Add( getConfigTraslation( "Temporadas" ),  4 )

   ::oImageList:AddMasked( TBitmap():Define( "gc_cubes_16" ), Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "gc_objects_16" ), Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "gc_photographic_filters_16" ), Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "gc_bolt_16" ), Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "gc_cloud_sun_16" ), Rgb( 255, 0, 255 ) )

   ::oTreeRango:SetImagelist( ::oImageList )

   ::LoadFamilia()

   ::ChkChanged()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD TreeChanged()

   local oItemSelect := ::oTreeRango:GetSelected()

   if oItemSelect != nil .and. oItemSelect:ClassName() == "TTVITEM"

      ::aData        := {}

      do case
         case oItemSelect:cPrompt == "Familias"
            ::LoadFamilia()
         case oItemSelect:cPrompt == "Tipos"
            ::LoadTipo()
         case oItemSelect:cPrompt == "Fabricantes"
            ::LoadFabricante()
         case oItemSelect:cPrompt == getConfigTraslation( "Temporadas" )
            ::LoadTemporada()
      end case

      if !Empty( ::oBrwRango )
         ::oBrwRango:aArrayData  := ::aData
         ::oBrwRango:GoTop()
         ::oBrwRango:Refresh()
      end if

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD BrowseDblClick( lAllSelected )

   local oItemSelect
   local cItemSelect             := "Familias"

   if !Empty( ::aData )

      oItemSelect                := ::oTreeRango:GetSelected()

      if oItemSelect != nil .and. oItemSelect:ClassName() == "TTVITEM"
         cItemSelect             := oItemSelect:cPrompt
      end if

      do case
         case IsNil( lAllSelected )

            ::aData[ ::oBrwRango:nArrayAt, 1 ]  := !::aData[ ::oBrwRango:nArrayAt, 1 ]

         case IsTrue( lAllSelected )

            aEval( ::aData, {|a| a[ 1 ] := .t. } )

         case IsFalse( lAllSelected )

            aEval( ::aData, {|a| a[ 1 ] := .f. } )

      end case

      do case
         case cItemSelect == "Familias"
            ::oDbf:mFamilia      := ::SelectedToMemo()
         case cItemSelect == "Tipos"
            ::oDbf:mTipo         := ::SelectedToMemo()
         case cItemSelect == "Fabricantes"
            ::oDbf:mFabricant    := ::SelectedToMemo()
         case cItemSelect == getConfigTraslation( "Temporadas" )
            ::oDbf:mTemporada    := ::SelectedToMemo()
      end case

   end if

   if !Empty( ::oBrwRango )
      ::oBrwRango:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD ChkChanged()

   local oItemSelect
   local cItemSelect             := "Familias"

   if !Empty( ::aData )

      oItemSelect                := ::oTreeRango:GetSelected()

      if oItemSelect != nil .and. oItemSelect:ClassName() == "TTVITEM"
         cItemSelect             := oItemSelect:cPrompt
      end if

      do case
         case cItemSelect == "Familias"
            ::oDbf:lFamilia      := ::lAll
         case cItemSelect == "Tipos"
            ::oDbf:lTipo         := ::lAll
         case cItemSelect == "Fabricantes"
            ::oDbf:lFabricant    := ::lAll
         case cItemSelect == getConfigTraslation( "Temporadas" )
            ::oDbf:lTemporada    := ::lAll
      end case

      if ::lAll
         ::oBrwRango:Hide()
         ::oBtnSelectAll:Hide()
         ::oBtnSelectNone:Hide()
      else
         ::oBrwRango:Show()
         ::oBtnSelectAll:Show()
         ::oBtnSelectNone:Show()
      end if

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD LoadFamilia()

   local aFamilia := hb_ATokens( Alltrim( ::oDbf:mFamilia ), "," )

   if ::oDbfFam == nil .or. !::oDbfFam:Used()
      DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"
   end if

   ::oDbfFam:GoTop()
   do while ! ::oDbfFam:Eof()
      aAdd( ::aData, { aScan( aFamilia, Alltrim( ::oDbfFam:cCodFam ) ) != 0, ::oDbfFam:cCodFam, ::oDbfFam:cNomFam } )
      ::oDbfFam:Skip()
   end while

   if !Empty( ::oChk )
      ::oChk:Click( ::oDbf:lFamilia )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD LoadTipo()

   local aTipo := hb_ATokens( Alltrim( ::oDbf:mTipo ) )

   if ::oDbfTip == nil .or. !::oDbfTip:Used()
      DATABASE NEW ::oDbfTip PATH ( cPatEmp() ) FILE "TipArt.Dbf" VIA ( cDriver() ) SHARED INDEX "TipArt.Cdx"
   end if

   ::oDbfTip:GoTop()
   do while ! ::oDbfTip:Eof()
      aAdd( ::aData, { aScan( aTipo, Alltrim( ::oDbfTip:cCodTip ) ) != 0, ::oDbfTip:cCodTip, ::oDbfTip:cNomTip } )
      ::oDbfTip:Skip()
   end while

   ::oChk:Click( ::oDbf:lTipo )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD LoadFabricante()

   local aFabricante := hb_ATokens( Alltrim( ::oDbf:mFabricant ) )

   if ::oDbfFab == nil .or. !::oDbfFab:Used()
      DATABASE NEW ::oDbfFab PATH ( cPatEmp() ) FILE "Fabric.Dbf" VIA ( cDriver() ) ALIAS "FABRIC" SHARED INDEX "Fabric.Cdx"
   end if

   ::oDbfFab:GoTop()
   do while ! ::oDbfFab:Eof()
      aAdd( ::aData, { aScan( aFabricante, Alltrim( ::oDbfFab:cCodFab ) ) != 0, ::oDbfFab:cCodFab, ::oDbfFab:cNomFab } )
      ::oDbfFab:Skip()
   end while

   ::oChk:Click( ::oDbf:lFabricant )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD LoadTemporada()

   local aTemporada  := hb_ATokens( Alltrim( ::oDbf:mTemporada ) )

   if ::oDbfTem == nil .or. !::oDbfTem:Used()
      DATABASE NEW ::oDbfTem PATH ( cPatEmp() ) FILE "Temporadas.Dbf" VIA ( cDriver() ) SHARED INDEX "Temporadas.Cdx"
   end if

   ::oDbfTem:GoTop()
   do while ! ::oDbfTem:Eof()
      aAdd( ::aData, { aScan( aTemporada, Alltrim( ::oDbfTem:cCodigo ) ) != 0, ::oDbfTem:cCodigo, ::oDbfTem:cNombre } )
      ::oDbfTem:Skip()
   end while

   ::oChk:Click( ::oDbf:lTemporada )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SelectedToMemo()

   local cMemo := ""

   aEval( ::aData, {|aItem| if( aItem[ 1 ], cMemo += Rtrim( aItem[ 2 ] ) + ",", ) } )

Return ( cMemo )

//---------------------------------------------------------------------------//

METHOD InPrograma( cCodigoArticulo, dFechaVenta, dbfArticulo )

   if IsObject( dbfArticulo )
      dbfArticulo    := dbfArticulo:cAlias
   end if

   /*
   Comprobamos que exista el articulo------------------------------------------
   */

   if dbSeekInOrd( cCodigoArticulo, "Codigo", dbfArticulo )

      ::oDbf:GoTop()
      while !::oDbf:Eof()

         /*
         Comprobamos si esta en fecha------------------------------------------
         */

         if ( dFechaVenta >= ::oDbf:dInicio  .or. Empty( ::oDbf:dInicio ) ) .and. ;
            ( dFechaVenta <= ::oDbf:dFin     .or. Empty( ::oDbf:dFin ) )

            /*
            Comprobamos si cumple las condiciones------------------------------
            */

            if ( Empty( ( dbfArticulo )->Familia ) .or. ::oDbf:lFamilia    .or. lScanInMemo( ( dbfArticulo )->Familia, ::oDbf:mFamilia   ) ) .and.;
               ( Empty( ( dbfArticulo )->cCodTip ) .or. ::oDbf:lTipo       .or. lScanInMemo( ( dbfArticulo )->cCodTip, ::oDbf:mTipo      ) ) .and.;
               ( Empty( ( dbfArticulo )->cCodFab ) .or. ::oDbf:lFabricant  .or. lScanInMemo( ( dbfArticulo )->cCodFab, ::oDbf:mFabricant ) ) .and.;
               ( Empty( ( dbfArticulo )->cCodTemp) .or. ::oDbf:lTemporada  .or. lScanInMemo( ( dbfArticulo )->cCodTemp,::oDbf:mTemporada ) )

               return .t.

            end if

         end if

         ::oDbf:Skip()

      end while

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD nPorcentajePrograma( nImporte )

   local nPorcentaje             := 0

   /*
   Comprobamos que exista el articulo------------------------------------------
   */

   ::oDbf:GoTop()
   while !::oDbf:Eof()

      if ::oDetFideliza:oDbf:Seek( ::oDbf:cCodigo )

         while ::oDetFideliza:oDbf:cCodigo == ::oDbf:cCodigo .and. !::oDetFideliza:oDbf:Eof()

            if ::oDetFideliza:oDbf:nImpUni == 1 .and. ::oDetFideliza:oDbf:nImporte <= abs( nImporte )

               if ::oDetFideliza:oDbf:nPorcen > nPorcentaje

                  nPorcentaje    := ::oDetFideliza:oDbf:nPorcen

               end if

            end if

            ::oDetFideliza:oDbf:Skip()

         end while

      end if

      ::oDbf:Skip()

   end while

Return ( nPorcentaje )

//---------------------------------------------------------------------------//

Function lScanInMemo( cString, mString )

Return ( aScan( hb_ATokens( Alltrim( mString ), "," ), Alltrim( cString ) ) != 0 )

//---------------------------------------------------------------------------//