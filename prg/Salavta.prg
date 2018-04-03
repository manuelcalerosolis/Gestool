#include "FiveWin.Ch"

#include "Factu.ch" 
#include "MesDbf.ch"

#define stateMesaLibre                    1
#define stateMesaOcupada                  2

//----------------------------------------------------------------------------//

CLASS TSalaVenta FROM TMasDet

   DATA  cMru     INIT "gc_cup_16"
   DATA  cBitmap  INIT "WebTopBlack"

   CLASSDATA aResource  AS ARRAY          INIT  {  "GC_BEER_BOTTLE_16"     ,;
                                                   "GC_BEER_GLASS_16"      ,;
                                                   "GC_WINE_BOTTLE_16"     ,;
                                                   "GC_WINE_GLASS_16"      ,;
                                                   "GC_COCKTAIL2_16"       ,;
                                                   "GC_LEMONADE_GLASS_16"  ,;
                                                   "GC_COCKTAIL_16"        ,;
                                                   "GC_ICE_CREAM2_16"      ,;
                                                   "GC_GOLDFISH_16"        ,;
                                                   "GC_PIG_16"             }

   CLASSDATA aBigResource  AS ARRAY       INIT {   "GC_BEER_BOTTLE_32"     ,;
                                                   "GC_BEER_GLASS_32"      ,;
                                                   "GC_WINE_BOTTLE_32"     ,;
                                                   "GC_WINE_GLASS_32"      ,;
                                                   "GC_COCKTAIL2_32"       ,;
                                                   "GC_LEMONADE_GLASS_32"  ,;
                                                   "GC_COCKTAIL_32"        ,;
                                                   "GC_ICE_CREAM2_32"      ,;
                                                   "GC_GOLDFISH_32"        ,;
                                                   "GC_PIG_32"             }

   CLASSDATA aImagen    AS ARRAY          INIT {   "Botella cerveza"    ,;
                                                   "Cerveza barril"     ,;
                                                   "Botella de tinto"   ,;
                                                   "Copa de tinto"      ,;
                                                   "Copa de blanco"     ,;
                                                   "Vaso de limonada"   ,;
                                                   "Cocktail"           ,;
                                                   "Helado"             ,;
                                                   "Pescado"            ,;
                                                   "Carne"              }

   DATA aPrecio         AS ARRAY          INIT {   uFieldEmpresa( "cTxtTar1", "Precio 1" ),;
                                                   uFieldEmpresa( "cTxtTar2", "Precio 2" ),;
                                                   uFieldEmpresa( "cTxtTar3", "Precio 3" ),;
                                                   uFieldEmpresa( "cTxtTar4", "Precio 4" ),;
                                                   uFieldEmpresa( "cTxtTar5", "Precio 5" ),;
                                                   uFieldEmpresa( "cTxtTar6", "Precio 6" ),;
                                                   "Precio por defecto" }

   CLASSDATA oDlgSalaVenta

   CLASSDATA aSalas        AS ARRAY    INIT {}
   CLASSDATA aTikets       AS ARRAY    INIT {}
   CLASSDATA oGenerico
   CLASSDATA oLlevar 

   DATA oSalon

   DATA lMinimize          AS LOGIC    INIT .f.
   DATA lPuntosVenta
   DATA cInitialSala

   DATA oDetSalaVta        AS OBJECT    

   DATA nTarifa            AS NUMERIC  INIT  1

   DATA cSelectedSala
   DATA cSelectedPunto
   DATA oSelectedPunto
   DATA nSelectedPrecio    AS NUMERIC  INIT  1
   DATA nSelectedCombinado AS NUMERIC  INIT  2
   DATA cSelectedTiket

   DATA cSelectedImagen
   DATA cSelectedTexto

   DATA cTikT
   DATA cTikL
   DATA cDiv

   Method New( cPath, oWndParent, oMenuItem )
   Method Create( cPath )
   Method End()

   Method OpenFiles( lExclusive )
   Method OpenService( lExclusive )
     
   Method CloseFiles()
   Method CloseService()
   
   Method DefineFiles()

   Method Resource( nMode )

   Method lPreSave( nMode )

   Method Dialog()
   Method InitDialog( oImgUsr, oLstUsr )
   Method SelectDialog( nOpt, oDlg, oLstSala )

   Method Tikets()
   Method InitTikets( oImgUsr, oLstUsr )
   Method SelectTikets( nOpt, oDlg, oLstSala )

   Method Reset( oBtnTarifa )

   Method ConfigButton( oBtnTarifa )

   Method cTextoPunto( sSala, sPunto )
   Method cTextoGenerico( sPunto )
   Method cTextoTiket( sSala, sPunto )
   Method nStatePunto( sPunto )
   Method nImagenPunto( sPunto, n )
   Method nImagenTiket( sSala, sPunto, n )

   Method lCambiaPunto( cTiket ) INLINE ( !Empty( ::cSelectedTiket ) .and. ( cTiket != ::cSelectedTiket ) )

   Method cSelectedTicket()      INLINE ( ::cSelectedTiket )

   Method SetSelected( aTmp )
   Method SetSelectedImagen()
   Method SetSelectedTexto()

   Method SetGenerico( sPunto )
   Method SetLlevar( sPunto )

   Method lLlevar()              INLINE ( Empty( ::cSelectedSala ) .and. AllTrim( ::cSelectedPunto ) == "Llevar" )
   Method lGeneric()             INLINE ( !::lNotGeneric() )
   Method lNotGeneric()          INLINE ( !Empty( ::cSelectedSala ) .and. !Empty( ::cSelectedPunto ) )

   METHOD cImagen()              INLINE ( ::aImagen[ Min( Max( ::oDbf:nImagen, 1 ), len( ::aImagen ) ) ] )
   METHOD cPrecio()              INLINE ( ::aPrecio[ Min( Max( ::oDbf:nPrecio, 1 ), len( ::aPrecio ) ) ] )
   METHOD cPrecioCombinado()     INLINE ( ::aPrecio[ Min( Max( ::oDbf:nPreCmb, 1 ), len( ::aPrecio ) ) ] )
   METHOD cResource()            INLINE ( ::aResource[ Min( Max( ::oDbf:nImagen, 1 ), len( ::aResource ) ) ] )
   METHOD cBigResource()         INLINE ( ::aBigResource[ Min( Max( ::oDbf:nImagen, 1 ), len( ::aBigResource ) ) ] )

   METHOD cTextoPrecio( nPrecio )

   Method GetSelectedTexto()

   Method SetSalaVta( aTmp, dbfTikT )

   Method Selector( oBtnTarifa, lPuntosPendientes, lLlevar )

   Method Sala( oBtnTarifa, lPuntosPendientes )
   Method BuildSala()
   Method InitSala()

   Method SetPunto( sPunto )

   Method cSelected()            INLINE ( if( !Empty( ::cSelectedSala ), ::cSelectedSala + ::cSelectedPunto, Space( 3 ) + ::cSelectedPunto ) )
   Method cTextoSala()

   Method SetTicket( sPunto )

END CLASS

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oCmbImagen
   local cCmbImagen     := ::cImagen()
   local oCmbPrecio
   local cCmbPrecio
   local oCmbPreCmb
   local cCmbPreCmb
   local oBrwDetSalaVta

   if nMode == APPD_MODE
      cCmbPrecio        := ::aPrecio[ Min( Max( uFieldEmpresa( "NPRETPRO" ), 1 ), len( ::aPrecio ) ) ]
      cCmbPreCmb        := ::aPrecio[ Min( Max( uFieldEmpresa( "NPRETCMB" ), 1 ), len( ::aPrecio ) ) ]
   else
      cCmbPrecio        := ::cPrecio()
      cCmbPreCmb        := ::cPrecioCombinado()
   end if

   DEFINE DIALOG oDlg RESOURCE "SalaVentas" TITLE LblTitle( nMode ) + "sala de ventas"

      REDEFINE GET oGet VAR ::oDbf:cCodigo;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDescrip ; 
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE COMBOBOX oCmbImagen VAR cCmbImagen ;
         ID       120;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ::aImagen ;
         BITMAPS  ::aResource

      REDEFINE COMBOBOX oCmbPrecio VAR cCmbPrecio ;
         ID       130;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ::aPrecio

      REDEFINE COMBOBOX oCmbPreCmb VAR cCmbPreCmb ;
         ID       140;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ::aPrecio

      REDEFINE CHECKBOX ::oDbf:lComensal ;
         ID       150 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( Msginfo( ::oDetSalaVta:oDbfVir, "Sala de ventas" ), ::oSalon:Design( ::oDetSalaVta:oDbfVir, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( nMode, oCmbImagen, oCmbPrecio, oCmbPreCmb ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F3, {|| ::oSalon:Design( ::oDetSalaVta:oDbfVir, oDlg ) } )
         oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( nMode, oCmbImagen, oCmbPrecio, oCmbPreCmb ), oDlg:end( IDOK ), ) } )
      end if

      oDlg:bStart := { || oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lPreSave( nMode, oCmbImagen, oCmbPrecio, oCmbPreCmb )

   msgStop( ::oDbf:lComensal, "lPresave" )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ::oDbf:SeekInOrd( ::oDbf:cCodigo, "cCodigo" )
         msgStop( "Código ya existe " + Rtrim( ::oDbf:cCodigo ) )
         Return .f.
      end if

   end if

   if Empty( ::oDbf:cDescrip )
      msgStop( "La descripción de la sala no puede estar vacía." )
      Return .f.
   end if

   ::oDbf:nImagen := oCmbImagen:nAt
   ::oDbf:nPrecio := oCmbPrecio:nAt
   ::oDbf:nPreCmb := oCmbPreCmb:nAt

Return .t.

//--------------------------------------------------------------------------//

Method Dialog( oBtnTarifa, lPuntosLibres )

   local oDlg
   local oImgSala
   local oLstSala

   DEFAULT lPuntosLibres   := .f.

   DEFINE DIALOG oDlg RESOURCE "SelectSalaVta"

      oImgSala             := TImageList():New( 44, 44 )

      oLstSala             := TListView():Redefine( 100, oDlg )
      oLstSala:nOption     := 0
      oLstSala:bAction     := {| nOpt | ::SelectDialog( nOpt, oDlg, oBtnTarifa, lPuntosLibres ) }

      REDEFINE BUTTONBMP ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( ::InitSala(), oDlg:end() );
         BITMAP   "gc_cup_48" ;

      REDEFINE BUTTONBMP ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( ::InitSala(), oDlg:end() );
         BITMAP   "gc_delete_48" ;

   oDlg:Activate( , , , .t., , , {|| ::InitDialog( oImgSala, oLstSala, lPuntosLibres ) } )

Return ( Self )

//--------------------------------------------------------------------------//

Method InitDialog( oImgSala, oLstSala, lPuntosLibres )

   local n                 := 0
   local sSala
   local sPunto
   local cPunto

   DEFAULT lPuntosLibres   := .f.

   oLstSala:SetImageList( oImgSala )

   oLstSala:EnableGroupView()

   for each sSala in ::aSalas

      oImgSala:AddMasked( TBitmap():Define( sSala:cImagen ), Rgb( 255, 0, 255 ) )

      oLstSala:InsertGroup( n, sSala:cDescripcion )

      for each sPunto in sSala:aPunto

         if lPuntosLibres

            oLstSala:InsertItemGroup( ::nImagenPunto( sPunto, n ), ::cTextoPunto( sPunto ), n )

         else

            oLstSala:InsertItemGroup( ::nImagenPunto( sPunto, n ), ::cTextoPunto( sPunto ), n )

         end if

      next

      n++

   next

Return ( Self )

//---------------------------------------------------------------------------//

Method SelectDialog( nOpt, oDlg, oBtnTarifa, lPuntosLibres )

   local sSala
   local sPunto

   DEFAULT lPuntosLibres         := .f.

   for each sSala in ::aSalas

      for each sPunto in sSala:aPunto

         if sPunto:nNumero == nOpt

            ::oSelectedPunto     := sPunto

            /*
            Vamos a ver si en esta ubicacion hay tickets-----------------------
            */

            if dbSeekInOrd( sPunto:cPunto(), "cCodSal", ::cTikT )

               if lPuntosLibres
                  msgStop( "El punto de venta esta actualmente ocupado." )
                  Return ( Self )
               end if

               ::SetSelected( ::cTikT, sPunto )

            else

               ::SetSelected( nil, sPunto )

            end if

            oDlg:End()

         end if

      next

   next

Return ( Self )

//---------------------------------------------------------------------------//

Method Tikets( oBtnTarifa, oBtnRenombrar )

   local oDlg
   local oImgSala
   local oLstSala

   DEFINE DIALOG oDlg RESOURCE "SelectTickets"

      oImgSala          := TImageList():New( 46, 46 )

      oLstSala          := TListView():Redefine( 100, oDlg )
      oLstSala:nOption  := 0
      oLstSala:bAction  := {| nOpt | ::SelectTikets( nOpt, oDlg, oBtnTarifa, oBtnRenombrar ) }

      REDEFINE BUTTONBMP ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() );
         BITMAP   "gc_delete_48" ;

   oDlg:Activate( , , , .t., , , {|| ::InitTikets( oImgSala, oLstSala ) } )

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Method InitTikets( oImgSala, oLstSala )

   local n           := 0
   local nOrd
   local sSala
   local sPunto
   local nLastGroup

   /*
   Cargamos los datos en una tabla --------------------------------------------
   */

   ::aTikets         := {}

   oLstSala:SetImageList( oImgSala )

   oLstSala:EnableGroupView()

   do case
      case ( IsNil( ::lPuntosVenta ) )

         oImgSala:AddMasked( TBitmap():Define( "gc_cup_48" ), Rgb( 255, 0, 255 ) )

         oLstSala:InsertGroup( 0, "Tickets pendientes" )

         nOrd     := ( ::cTikT )->( OrdSetFocus( "cCodSal" ) )

         ( ::cTikT )->( dbGoTop() )
         while !( ::cTikT )->( Eof() )

            sPunto      := sPunto():New( n++, ::cTikT, sSala )

            oLstSala:InsertItemGroup( 0, ::cTextoTiket( sPunto ), 0 )

            aAdd( ::aTikets, sPunto )

            ( ::cTikT )->( dbSkip() )

         end while

         ( ::cTikT )->( OrdSetFocus( nOrd ) )

      case ( IsFalse( ::lPuntosVenta ) )

         /*
         Orden actual----------------------------------------------------------------
         */

         nOrd     := ( ::cTikT )->( OrdSetFocus( "cCodSal" ) )

         /*
         Recorremos todas las salas--------------------------------------------------
         */

         for each sSala in ::aSalas

            oImgSala:AddMasked( TBitmap():Define( sSala:cImagen ),      Rgb( 255, 0, 255 ) )

            oLstSala:InsertGroup( hb_EnumIndex() - 1, sSala:cDescripcion )

            /*
            Buscamos si hay tikets pendientes en esta sala---------------------------
            */

            if ( ::cTikT )->( dbSeek( sSala:cCodigo ) )

               while ( ::cTikT )->cCodSala == sSala:cCodigo .and. !( ::cTikT )->( eof() )

                  sPunto   := sPunto():New( n++, ::cTikT, sSala )

                  oLstSala:InsertItemGroup( ::nImagenTiket( sSala, sPunto, hb_EnumIndex() - 1 ), ::cTextoTiket( sPunto ), hb_EnumIndex() - 1 )

                  aAdd( ::aTikets, sPunto )

                  ( ::cTikT )->( dbSkip() )

               end while

            end if

         next

         ( ::cTikT )->( OrdSetFocus( nOrd ) )

      case ( IsTrue( ::lPuntosVenta ) )

         /*
         Orden actual----------------------------------------------------------
         */

         nOrd     := ( ::cTikT )->( OrdSetFocus( "cCodSal" ) )

         /*
         Recorremos todas las salas--------------------------------------------------
         */

         for each sSala in ::aSalas

            oImgSala:AddMasked( TBitmap():Define( sSala:cImagen ),      Rgb( 255, 0, 255 ) )

            oLstSala:InsertGroup( hb_EnumIndex() - 1, sSala:cDescripcion )

            /*
            Buscamos si hay tikets pendientes en esta sala---------------------------
            */

            if ( ::cTikT )->( dbSeek( sSala:cCodigo ) )

               while ( ::cTikT )->cCodSala == sSala:cCodigo .and. !( ::cTikT )->( eof() )

                  if !Empty( ( ::cTikT )->cPntVenta )

                     sPunto   := sPunto():New( n++, ::cTikT, sSala )

                     oLstSala:InsertItemGroup( ::nImagenPunto( sPunto, hb_EnumIndex() - 1 ), ::cTextoPunto( sPunto ), hb_EnumIndex() - 1 )

                     aAdd( ::aTikets, sPunto )

                  end if

                  ( ::cTikT )->( dbSkip() )

               end while

            end if

            nLastGroup  := hb_EnumIndex()

         next

         /*
         Buscamos si hay tikets pendientes en la sala generica-----------------
         */

         oImgSala:AddMasked( TBitmap():Define( "gc_cup_48" ), Rgb( 255, 0, 255 ) )

         oLstSala:InsertGroup( nLastGroup, "General" )

         ( ::cTikT )->( dbGoTop() )

         while !( ::cTikT )->( eof() )

            if Empty( ( ::cTikT )->cPntVenta )

               sPunto   := sPunto():New( n++, ::cTikT )

               oLstSala:InsertItemGroup( ( nLastGroup * 2 ), ::cTextoGenerico( sPunto ), nLastGroup )

               aAdd( ::aTikets, sPunto )

            end if

            ( ::cTikT )->( dbSkip() )

         end while

         ( ::cTikT )->( OrdSetFocus( nOrd ) )

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Method SelectTikets( nOpt, oDlg, oBtnTarifa, oBtnRenombrar )

   local sPunto            := ::aTikets[ Min( Max( nOpt, 1 ), len( ::aTikets ) ) ]

   ::cSelectedSala         := sPunto:cSala()
   ::nSelectedPrecio       := sPunto:nPrecio()
   ::cSelectedTiket        := sPunto:cTiket()
   ::cSelectedImagen       := sPunto:cImagen()
   ::cSelectedTexto        := sPunto:cTextoPunto()
   ::cSelectedPunto        := sPunto:cPuntoVenta()
   ::oSelectedPunto        := sPunto

   ::ConfigButton( oBtnTarifa, oBtnRenombrar )

   oDlg:End( IDOK )

Return ( Self )

//---------------------------------------------------------------------------//

Method ConfigButton( oBtnTarifa, oBtnRenombrar )

   do case
      case ( IsNil( ::lPuntosVenta ) )

         oBtnRenombrar:Hide()

      case IsFalse( ::lPuntosVenta )

         if Empty( ::cSelectedImagen )
            oBtnTarifa:cBmp( "gc_cup_32" )
         else
            oBtnTarifa:cBmp( ::cSelectedImagen )
         end if

         if Empty( ::cSelectedTexto )
            oBtnTarifa:cCaption( "General" )
         else
            oBtnTarifa:cCaption( ::cSelectedTexto )
         end if

         oBtnRenombrar:Hide()

      case IsTrue( ::lPuntosVenta )

         if Empty( ::cSelectedImagen )
            oBtnTarifa:cBmp( "gc_cup_32" )
         else
            oBtnTarifa:cBmp( ::cSelectedImagen )
         end if

         if Empty( ::cSelectedTexto )
            oBtnTarifa:cCaption( "General" )
         else
            oBtnTarifa:cCaption( ::cSelectedTexto )
         end if

         oBtnRenombrar:Show()

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Method Reset( oBtnTarifa )

   if !Empty( oBtnTarifa )
      oBtnTarifa:cBmp( "gc_cup_48" )
      oBtnTarifa:cCaption( "General" )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method nImagenTiket( sSala, sPunto, n )

   local nRecno
   local nImagen        := ( ( ( n + 1 ) * 2 ) - 2 )

   if !Empty( ::cTikT ) .and. !Empty( ::cTikL )

      nRecno            := ( ::cTikT )->( Recno() )

      if !Empty( sPunto:cTiket() )
         if ( dbSeekInOrd( sPunto:cTiket(), "cNumTik", ::cTikT ) .and. !( ::cTikT )->lAbierto )
            ++nImagen
         end if
      end if

      ( ::cTikT )->( dbGoTo( nRecno ) )

   end if

RETURN ( nImagen )

//---------------------------------------------------------------------------//

Method nStatePunto( sPunto )

   local nRecno
   local nImagen        := 1

   if !Empty( ::cTikT ) .and. !Empty( ::cTikL )

      nRecno            := ( ::cTikT )->( Recno() )

      if !Empty( sPunto:cPunto() ) .and. !Empty( sPunto:cPuntoVenta )

         if ( dbSeekInOrd( sPunto:cPunto(), "cCodSal", ::cTikT ) .and. ( ::cTikT )->lAbierto )
            ++nImagen
         end if

      end if

      ( ::cTikT )->( dbGoTo( nRecno ) )

   end if

RETURN ( nImagen )

//---------------------------------------------------------------------------//

Method nImagenPunto( sPunto, n )

   local nRecno
   local nImagen        := ( ( ( n + 1 ) * 2 ) - 2 )

   if !Empty( ::cTikT ) .and. !Empty( ::cTikL )

      nRecno            := ( ::cTikT )->( Recno() )

      if !Empty( sPunto:cPunto() )
         if (  dbSeekInOrd( sPunto:cPunto(), "cCodSal", ::cTikT ) .and. !( ::cTikT )->lAbierto )
            ++nImagen
         end if
      end if

      ( ::cTikT )->( dbGoTo( nRecno ) )

   end if

RETURN ( nImagen )

//---------------------------------------------------------------------------//

Method cTextoTiket( sPunto )

   local nRecno
   local cTextoPunto

   cTextoPunto          := sPunto:cTextoPunto()

   if !Empty( ::cTikT ) .and. !Empty( ::cTikL )

      nRecno            := ( ::cTikT )->( Recno() )

      if ( dbSeekInOrd( sPunto:cTiket(), "cNumTik", ::cTikT ) .and. !( ::cTikT )->lPgdTik )
         cTextoPunto    += CRLF
         cTextoPunto    += "[ Total : " + Ltrim( nTotTik( ( ::cTikT )->cSerTik + ( ::cTikT )->cNumTik + ( ::cTikT )->cSufTik, ::cTikT, ::cTikL, ::cDiv, , , .t. ) ) + " ]"
      end if

      ( ::cTikT )->( dbGoTo( nRecno ) )

   end if

RETURN ( cTextoPunto )

//---------------------------------------------------------------------------//

Method cTextoPunto( sPunto )

   local nRecno
   local cTextoPunto

   DEFAULT sPunto       := ::oSelectedPunto

   cTextoPunto          := sPunto:cTextoPunto()

   if !Empty( ::cTikT ) .and. !Empty( ::cTikL )

      nRecno            := ( ::cTikT )->( Recno() )

      if ( dbSeekInOrd( sPunto:cPunto(), "cCodSal", ::cTikT ) .and. !( ::cTikT )->lPgdTik )

         if !Empty( ( ::cTikT )->cAliasTik )
            cTextoPunto := Upper( Rtrim( ( ::cTikT )->cAliasTik ) )
         end if

         cTextoPunto    += CRLF
         cTextoPunto    += "[ Total : " + Ltrim( nTotTik( ( ::cTikT )->cSerTik + ( ::cTikT )->cNumTik + ( ::cTikT )->cSufTik, ::cTikT, ::cTikL, ::cDiv, , , .t. ) ) + " ]"

      end if

      ( ::cTikT )->( dbGoTo( nRecno ) )

   end if

RETURN ( cTextoPunto )

//---------------------------------------------------------------------------//

Method cTextoGenerico( sPunto )

   local nRecno
   local cTextoPunto

   DEFAULT sPunto       := ::oSelectedPunto

   cTextoPunto          := "General"

   if !Empty( ::cTikT ) .and. !Empty( ::cTikL )

      nRecno            := ( ::cTikT )->( Recno() )

      if ( dbSeekInOrd( sPunto:cTiket(), "cNumTik", ::cTikT ) .and. !( ::cTikT )->lPgdTik )

         if !Empty( ( ::cTikT )->cAliasTik )
            cTextoPunto := Upper( Rtrim( ( ::cTikT )->cAliasTik ) )
         end if

         cTextoPunto    += CRLF
         cTextoPunto    += "[ Total : " + Ltrim( nTotTik( ( ::cTikT )->cSerTik + ( ::cTikT )->cNumTik + ( ::cTikT )->cSufTik, ::cTikT, ::cTikL, ::cDiv, , , .t. ) ) + " ]"

      end if

      ( ::cTikT )->( dbGoTo( nRecno ) )

   end if

RETURN ( cTextoPunto )

//---------------------------------------------------------------------------//

METHOD cTextoPrecio( nPrecio )

   DEFAULT nPrecio   := ::nSelectedPrecio

   if !IsNum( nPrecio )
      nPrecio        := 1
   end if

Return ( ::aPrecio[ Min( Max( nPrecio, 1 ), len( ::aPrecio ) ) ] )

//---------------------------------------------------------------------------//

Method SetSelectedImagen()

   local nScan

   if Empty( ::aSalas )
      Return ( Self )
   end if

   do case
      case IsFalse( ::lPuntosVenta )

         ::cSelectedImagen       := ::aSalas[ Min( Max( ::nSelectedPrecio, 1 ), len( ::aSalas ) ) ]:cImagen

      case IsTrue( ::lPuntosVenta )

         if Empty( ::cSelectedImagen )
            nScan                := aScan( ::aSalas, {|o| o:cCodigo == ::cSelectedSala } )
            if nScan != 0
               ::cSelectedImagen := ::aSalas[ nScan ]:cImagen
            end if
         end if

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Method SetSelectedTexto()

   local nScan

   if Empty( ::aSalas )
      Return ( Self )
   end if

   do case
      case IsFalse( ::lPuntosVenta )

         ::cSelectedTexto     := Rtrim( ::aSalas[ Min( Max( ::nSelectedPrecio, 1 ), len( ::aSalas ) ) ]:cDescripcion )

      case IsTrue( ::lPuntosVenta )

         /*if Empty( ::cSelectedPunto )
            ::cSelectedPunto  := "General"
         end if*/

         ::cSelectedTexto     := Rtrim( ::cSelectedPunto )

   end case

Return ( Self )

//---------------------------------------------------------------------------//

Method SetGenerico( sPunto )

   ::cSelectedSala               := ""
   ::cSelectedPunto              := "General"
   ::nSelectedPrecio             := sPunto:nPrecio
   ::nSelectedCombinado          := sPunto:nPreCmb
   ::cSelectedImagen             := sPunto:cImagen
   ::cSelectedTiket              := sPunto:cTiket()
   ::cSelectedTexto              := sPunto:cTextoPunto()

   ::SetSelectedImagen()
   ::SetSelectedTexto()

Return ( Self )

//---------------------------------------------------------------------------//

Method SetLlevar( sPunto )

   ::cSelectedSala               := ""
   ::cSelectedPunto              := "Llevar"
   ::nSelectedPrecio             := sPunto:nPrecio
   ::nSelectedCombinado          := sPunto:nPreCmb
   ::cSelectedImagen             := sPunto:cImagen
   ::cSelectedTiket              := sPunto:cTiket()
   ::cSelectedTexto              := sPunto:cTextoPunto()

   ::SetSelectedImagen()
   ::SetSelectedTexto()

Return ( Self )

//---------------------------------------------------------------------------//

Method SetSelected( uTmp, sPunto )

   if Empty( sPunto )
      if !Empty( ::oSelectedPunto )
         sPunto               := ::oSelectedPunto
      else
         sPunto               := sPunto():Generico()
      end if
   end if

   do case
      case IsChar( uTmp )

         sPunto:cSerie           := ( ::cTikT )->cSerTik
         sPunto:cNumero          := ( ::cTikT )->cNumTik
         sPunto:cSufijo          := ( ::cTikT )->cSufTik
         sPunto:cAlias           := ( ::cTikT )->cAliasTik

         if !Empty( ( ::cTikT )->nTarifa )
            sPunto:nPrecio       := ( ::cTikT )->nTarifa
         end if
         if !Empty( ( ::cTikT )->cCodSala )
            sPunto:cCodigoSala   := ( ::cTikT )->cCodSala
         end if
         if !Empty( ( ::cTikT )->cPntVenta )
            sPunto:cPuntoVenta   := ( ::cTikT )->cPntVenta
         end if

      case IsArray( uTmp )

         sPunto:cSerie           := uTmp[ ( ::cTikT )->( FieldPos( "cSerTik"   ) ) ]
         sPunto:cNumero          := uTmp[ ( ::cTikT )->( FieldPos( "cNumTik"   ) ) ]
         sPunto:cSufijo          := uTmp[ ( ::cTikT )->( FieldPos( "cSufTik"   ) ) ]
         sPunto:cAlias           := uTmp[ ( ::cTikT )->( FieldPos( "cAliasTik" ) ) ]

         if !Empty( uTmp[ ( ::cTikT )->( FieldPos( "nTarifa" ) ) ] )
            sPunto:nPrecio       := uTmp[ ( ::cTikT )->( FieldPos( "nTarifa"   ) ) ]
         end if
         if !Empty( uTmp[ ( ::cTikT )->( FieldPos( "cCodSala" ) ) ] )
            sPunto:cCodigoSala   := uTmp[ ( ::cTikT )->( FieldPos( "cCodSala"  ) ) ]
         end if
         if !Empty( uTmp[ ( ::cTikT )->( FieldPos( "cPntVenta" ) ) ] )
            sPunto:cPuntoVenta   := uTmp[ ( ::cTikT )->( FieldPos( "cPntVenta" ) ) ]
         end if

   end case

   /*
   Rellenamos los datos-----------------------------------------------
   */

   ::cSelectedSala               := sPunto:cSala
   ::cSelectedPunto              := sPunto:cPuntoVenta
   ::nSelectedPrecio             := sPunto:nPrecio
   ::nSelectedCombinado          := sPunto:nPreCmb
   ::cSelectedImagen             := sPunto:cImagen
   ::cSelectedTiket              := sPunto:cTiket()
   ::cSelectedTexto              := sPunto:cTextoPunto()
   ::oSelectedPunto              := sPunto

   ::SetSelectedImagen()
   ::SetSelectedTexto()

Return ( Self )

//---------------------------------------------------------------------------//

Method GetSelectedTexto( lExtend )

   local nRecno
   local cTextoPunto    := Rtrim( ::cSelectedPunto )

   DEFAULT lExtend      := .f.

   /*if !Empty( ::cTikT )

      nRecno            := ( ::cTikT )->( Recno() )

      if dbSeekInOrd( ::cSelectedTiket, "cNumTik", ::cTikT )

         if !Empty( ( ::cTikT )->cAliasTik )
            if lExtend
               cTextoPunto += "-"
               cTextoPunto += Upper( Rtrim( ( ::cTikT )->cAliasTik ) )
            else
               cTextoPunto := Upper( Rtrim( ( ::cTikT )->cAliasTik ) )
            end if
         end if

      end if

      ( ::cTikT )->( dbGoTo( nRecno ) )

   end if*/

Return ( cTextoPunto )

//---------------------------------------------------------------------------//

Method SetSalaVta( aTmp, dbfTikT )

   DEFAULT dbfTikT   := ::cTikT

   if Empty( aTmp[ ( dbfTikT )->( FieldPos( "cCodSala" ) ) ] )

      do case
         case Empty( aTmp[ ( dbfTikT )->( FieldPos( "cPntVenta" ) ) ] )
             ::SetPunto( sPunto():New( , dbfTikT ) )

         case AllTrim( aTmp[ ( dbfTikT )->( FieldPos( "cPntVenta" ) ) ] ) == "General"
             ::SetGenerico( sPunto():Generico( dbfTikT ) )

         case AllTrim( aTmp[ ( dbfTikT )->( FieldPos( "cPntVenta" ) ) ] ) == "Llevar"
             ::SetLlevar( sPunto():Llevar( dbfTikT ) )

         end case

   else

      ::SetPunto( sPunto():New( , dbfTikT ) )

   end if

return .t.

//---------------------------------------------------------------------------//

Method SetPunto( sPunto )

   if !Empty( sPunto )

      ::oSelectedPunto                 := sPunto

      /*
      Rellenamos los datos-----------------------------------------------
      */

      ::cSelectedSala                  := ::oSelectedPunto:cSala
      ::cSelectedPunto                 := ::oSelectedPunto:cPuntoVenta
      ::nSelectedPrecio                := ::oSelectedPunto:nPrecio

      ::nSelectedCombinado             := ::oSelectedPunto:nPreCmb
      ::cSelectedImagen                := ::oSelectedPunto:cImagen

      ::cSelectedTiket                 := ::oSelectedPunto:cTiket()
      ::cSelectedTexto                 := ::oSelectedPunto:cTextoPunto()

      ::SetSelectedImagen()
      ::SetSelectedTexto()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method cTextoSala( cSala )

   local nScan
   local cTextoSala  := ""

   DEFAULT cSala     := ::cSelectedSala

   nScan             := aScan( ::aSalas, {|o| o:cCodigo == cSala } )
   if nScan != 0
      cTextoSala     := Rtrim( ::aSalas[ nScan ]:cDescripcion )
   end if

Return ( cTextoSala )

//---------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem )

   DEFAULT oWndParent      := GetWndFrame()

   if oMenuItem != nil .and. ::nLevel == nil
      ::nLevel             := Auth():Level( oMenuItem )
   else
      ::nLevel             := 0
   end if

   ::Create( cPath, cDriver )

   ::oWndParent            := oWndParent

   ::bFirstKey             := {|| :: oDbf:cCodigo }

   ::nSelectedPrecio       := Max( uFieldEmpresa( "nPreTPro" ), 1 )
   ::nSelectedCombinado    := Max( uFieldEmpresa( "nPreTCmb" ), 1 )

   ::oSalon                := TSalon():New()

   ::oDetSalaVta           := TDetSalaVta():New( cPath, cDriver, Self )
   ::AddDetail( ::oDetSalaVta )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath, cDriver )

   DEFAULT cPath           := cPatEmp()
   DEFAULT cDriver         := cDriver()

   ::cPath                 := cPath
   ::cDriver               := cDriver

RETURN ( Self )

//---------------------------------------------------------------------------//

Method Selector( oBtnTarifa, lPuntosPendientes, lLlevar, dbfTikT )

   local lSelector         := .t.

   DEFAULT dbfTikT         := ::cTikT

   if ::oSalon:Selector( Self, lPuntosPendientes, lLlevar, dbfTikT )

      if !Empty( ::oSalon:oSelectedPunto )

         if ::oSalon:oSelectedPunto:lGenerico()

            ::SetGenerico( ::oSalon:oSelectedPunto )

         else

            /*
            Vamos a ver si en esta ubicacion hay tickets-----------------------------
            */

            if !Empty( ::oSalon:oSelectedPunto:cTiket() ) .and. dbSeekInOrd( ::oSalon:oSelectedPunto:cTiket(), "cNumTik", ::cTikT )
               ::SetTicket( ::oSalon:oSelectedPunto )
            else
               ::SetPunto( ::oSalon:oSelectedPunto )
            end if

         end if

      else

         lSelector         := .f.

      end if

   else

      lSelector            := .f.

   end if

Return ( lSelector )

//---------------------------------------------------------------------------//
//
// Han seleccionado un ticket
//

Method SetTicket( sPunto )

   if !Empty( sPunto )

      ::oSelectedPunto                 := sPunto

      ::oSelectedPunto:cSerie          := ( ::cTikT )->cSerTik
      ::oSelectedPunto:cNumero         := ( ::cTikT )->cNumTik
      ::oSelectedPunto:cSufijo         := ( ::cTikT )->cSufTik
      ::oSelectedPunto:cAlias          := ( ::cTikT )->cAliasTik

      if !Empty( ( ::cTikT )->nTarifa )
         ::oSelectedPunto:nPrecio      := ( ::cTikT )->nTarifa
      end if
      if !Empty( ( ::cTikT )->cCodSala )
         ::oSelectedPunto:cCodigoSala  := ( ::cTikT )->cCodSala
      end if
      if !Empty( ( ::cTikT )->cPntVenta )
         ::oSelectedPunto:cPuntoVenta  := ( ::cTikT )->cPntVenta
      end if

      /*
      Rellenamos los datos-----------------------------------------------
      */

      ::cSelectedSala                  := ::oSelectedPunto:cSala
      ::cSelectedPunto                 := ::oSelectedPunto:cPuntoVenta
      ::nSelectedPrecio                := ::oSelectedPunto:nPrecio

      ::nSelectedCombinado             := ::oSelectedPunto:nPreCmb
      ::cSelectedImagen                := ::oSelectedPunto:cImagen
      ::cSelectedTiket                 := ::oSelectedPunto:cTiket()
      ::cSelectedTexto                 := ::oSelectedPunto:cTextoPunto()

      ::SetSelectedImagen()
      ::SetSelectedTexto()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method Sala( lPuntosPendientes, lLlevar )

   do case
      case IsTrue( ::lPuntosVenta )

         Return ( ::Selector( lPuntosPendientes, lLlevar ) )

      case IsFalse( ::lPuntosVenta )

         ++::nTarifa

         if ::nTarifa > len( ::aSalas )
            ::nTarifa         := 1
         end if

         ::cSelectedTiket     := ""
         ::cSelectedPunto     := ""
         ::oSelectedPunto     := nil
         ::cSelectedSala      := ::aSalas[ ::nTarifa ]:cCodigo
         ::nSelectedPrecio    := ::aSalas[ ::nTarifa ]:nPrecio
         ::nSelectedCombinado := ::aSalas[ ::nTarifa ]:nPreCmb
         ::cSelectedImagen    := ::aSalas[ ::nTarifa ]:cImagen
         ::cSelectedTexto     := ::aSalas[ ::nTarifa ]:cDescripcion

   end case

Return ( .t. )

//---------------------------------------------------------------------------//

Method BuildSala()

   local n                    := 0
   local sSala

   ::aSalas                   := {}
   ::lPuntosVenta             := nil
   ::cInitialSala             := nil

   ::lPuntosVenta             := .f.

   ::oDbf:GoTop()
   while !::oDbf:Eof()

      if Empty( ::cInitialSala )
         ::cInitialSala       := ::oDbf:cCodigo
      end if

      sSala                   := sSala():New( ::oDbf, ::cBigResource() )

      if ::oDetSalaVta:oDbf:Seek( ::oDbf:cCodigo )

         while ::oDetSalaVta:oDbf:cCodigo == ::oDbf:cCodigo .and. !::oDetSalaVta:oDbf:Eof()

            if !::lPuntosVenta
               ::lPuntosVenta := .t.
            end if

            sSala:AddPunto( n++, ::oDetSalaVta:oDbf, ::cTikT )

            ::oDetSalaVta:oDbf:Skip()

         end while

      end if

      aAdd( ::aSalas, sSala )

      ::oDbf:Skip()

   end while

   /*
   Punto generico--------------------------------------------------------------
   */

   ::oGenerico             := sPunto():Generico()

   /*
   Punto para llevar-----------------------------------------------------------
   */

   ::oLlevar               := sPunto():Llevar()

   /*
   Valores por defecto---------------------------------------------------------
   */

   ::InitSala()

RETURN ( nil )

//---------------------------------------------------------------------------//

Method InitSala()

   do case
      case ( IsTrue( ::lPuntosVenta ) )

         ::nSelectedPrecio       := Max( uFieldEmpresa( "nPreTPro" ), 1 )
         ::nSelectedCombinado    := Max( uFieldEmpresa( "nPreTCmb" ), 1 )
         ::cSelectedSala         := ""
         ::cSelectedTiket        := ""
         ::cSelectedImagen       := ""
         ::cSelectedTexto        := ""
         ::cSelectedPunto        := ""
         ::oSelectedPunto        := nil

      case ( IsFalse( ::lPuntosVenta ) )

         if len( ::aSalas ) > 0
            ::cSelectedSala      := ::aSalas[ 1 ]:cCodigo
            ::nSelectedPrecio    := ::aSalas[ 1 ]:nPrecio
            ::nSelectedCombinado := ::aSalas[ 1 ]:nPreCmb
            ::cSelectedImagen    := ::aSalas[ 1 ]:cImagen
            ::cSelectedTexto     := ::aSalas[ 1 ]:cDescripcion
            ::cSelectedTiket     := ""
            ::cSelectedPunto     := ""
            ::oSelectedPunto     := nil
         end if

   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::OpenDetails()

   RECOVER

      lOpen             := .f.

      ::CloseFiles()
      
      msgStop( "Imposible abrir todas las bases de datos de las salas de ventas." )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if Valtype( ::oDbfDet ) == "A"
      aSend( ::oDbfDet, "End()" )
   end if

   if Valtype( ::oDbfDet ) == "O"
      ::oDbfDet:End()
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      lOpen             := .f.

      ::CloseFiles()
      
      msgStop( "Imposible abrir todas las bases de datos de las salas de ventas." )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseService()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf               := nil 

RETURN ( .t. )

//----------------------------------------------------------------------------//


METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE TABLE ::oDbf FILE "SalaVta.Dbf" CLASS "SalaVta" ALIAS "SalaVta" PATH ( cPath ) VIA ( cDriver ) COMMENT "Sala de ventas"

      FIELD NAME "cCodigo"       TYPE "C" LEN  3  DEC 0 COMMENT "Código"            DEFAULT Space( 3 )   COLSIZE 100    OF ::oDbf
      FIELD NAME "cDescrip"      TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"            DEFAULT Space( 35 )  COLSIZE 400    OF ::oDbf
      FIELD NAME "lSala"         TYPE "L" LEN  1  DEC 0 COMMENT "Sala"              HIDE                                OF ::oDbf
      FIELD NAME "cSala"         TYPE "C" LEN  3  DEC 0 COMMENT "Código sala"       HIDE                                OF ::oDbf
      FIELD NAME "nPrecio"       TYPE "N" LEN  1  DEC 0 COMMENT "Precios sala"      HIDE                                OF ::oDbf
      FIELD NAME "nImagen"       TYPE "N" LEN  2  DEC 0 COMMENT "Imagen"            HIDE                                OF ::oDbf
      FIELD NAME "nPreCmb"       TYPE "N" LEN  1  DEC 0 COMMENT "Precio Combinado"  HIDE                                OF ::oDbf
      FIELD NAME "lComensal"     TYPE "L" LEN  1  DEC 0 COMMENT "Solicitar comensales"    HIDE                          OF ::oDbf

      INDEX TO "SalaVta.Cdx" TAG "cCodigo"      ON "cCodigo"      COMMENT "Código" NODELETED                            OF ::oDbf
      INDEX TO "SalaVta.Cdx" TAG "cDescrip"     ON "cDescrip"     COMMENT "Nombre" NODELETED                            OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

Method End()

   if !Empty( ::oSalon )
      ::oSalon:End()
   end if

   ::oSalon    := nil

Return ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDetSalaVta FROM TDet

   DATA cDriver

   METHOD Create( cPath )

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   Method CloseFiles()

   METHOD DefineFiles()

   METHOD Resource( nMode, lLiteral )

   METHOD SaveDetails()

   METHOD lPresave( oGetCod, nMode )

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName ) CLASS TDetSalaVta

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "SlaPnt"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Puntos de venta en sala"

      FIELD NAME "cCodigo"    TYPE "C" LEN  3   DEC 0 COMMENT "Código"                          HIDE        OF oDbf
      FIELD NAME "cDescrip"   TYPE "C" LEN  35  DEC 0 COMMENT "Descripción de punto de venta"   COLSIZE 200 OF oDbf
      FIELD NAME "nTipo"      TYPE "N" LEN  2   DEC 0 COMMENT "Tipo de objeto"                  HIDE        OF oDbf
      FIELD NAME "nFila"      TYPE "N" LEN  6   DEC 0 COMMENT "Fila del objeto"                 HIDE        OF oDbf
      FIELD NAME "nColumna"   TYPE "N" LEN  6   DEC 0 COMMENT "Columna del objeto"              HIDE        OF oDbf

      INDEX TO ( cFileName ) TAG "Codigo"    ON "cCodigo"   NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "Descrip"   ON "cDescrip"  NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodDes"   ON "cCodigo + cDescrip"  NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf      := nil
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( cPath, cDriver ) CLASS TDetSalaVta

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath
   ::cDriver            := cDriver

   ::bOnPreSaveDetail   := {|| MsgInfo( "Antes del SaveDetail" ), ::SaveDetails(), MsgInfo( "Después del SaveDetail" ) }

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TDetSalaVta

   local lOpen          := .t.
   local oBlock

   DEFAULT  lExclusive  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::oDbf            := ::DefineFiles( cPath )
   end if

   ::oDbf:Activate( .f., !lExclusive )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de puntos de venta" )
      ::CloseFiles()
      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetSalaVta

   local oDlg
   local oGetDescrip

   if nMode == APPD_MODE
      ::oDbfVir:cDescrip   := Alltrim( ::oParent:oDbf:cDescrip ) + Space( 1 ) + Alltrim( Str( ::oDbfVir:Lastrec() + 1 ) )
   end if

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LSalaVentas" TITLE LblTitle( nMode ) + "puntos de venta"

      /*
      Código de maquinaria-----------------------------------------------------
      */

      REDEFINE GET oGetDescrip VAR ::oDbfVir:cDescrip ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( if( ::lPresave( oGetDescrip, nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( MsgInfo( "Ayuda no definida" ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| if( ::lPresave( oGetDescrip, nMode ), oDlg:end( IDOK ), ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD SaveDetails() CLASS TDetSalaVta

   ::oDbfVir:cCodigo := ::oParent:oDbf:cCodigo

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lPreSave( oGetDescrip, nMode ) CLASS TDetSalaVta

   local lOk   := .t.

   if nMode == APPD_MODE

      ::oDbfVir:GetStatus()

      if ::oDbfVir:SeekInOrd( ::oDbfVir:cDescrip, "cDescrip" )
         msgStop( "Descripción ya existe" )
         oGetDescrip:SetFocus()
         lOk   := .f.
      end if

      ::oDbfVir:SetStatus()

   end if

Return ( lOk )

//---------------------------------------------------------------------------//

FUNCTION cSalaVta( oGet, dbfSalaVta, oGet2 )

   local oBlock
   local oError
   local lClose   := .f.
   local lValid   := .f.
   local xValor   := oGet:VarGet()

   if Empty( xValor ) .or. ( xValor == Replicate( "Z", 3 ) )
      if( oGet2 != nil, oGet2:cText( "" ), )
      return .t.
   else
      xValor   := RJustObj( oGet, "0" )
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfSalaVta == nil
      USE ( cPatEmp() + "SALAVTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SALAVTA", @dbfSalaVta ) )
      SET ADSINDEX TO ( cPatEmp() + "SALAVTA.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   do case
      case Valtype( dbfSalaVta ) == "C"

         if ( dbfSalaVta )->( dbSeek( xValor ) )
            oGet:cText( ( dbfSalaVta )->cCodigo )
            if( oGet2 != nil, oGet2:cText( ( dbfSalaVta )->cDescrip ), )
            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Sala de venta no encontrada" )
         end if

      case Valtype( dbfSalaVta ) == "O"

         if dbfSalaVta:Seek( xValor )
            oGet:cText( dbfSalaVta:cCodigo )

            if oGet2 != nil
               oGet2:cText( dbfSalaVta:cDescrip )
            end if

            lValid   := .t.
         else
            oGet:Refresh()
            msgStop( "Sala de venta no encontrada" )
         end if

   end case

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de almacenes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfSalaVta )
   end if

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION BrwSalaVta( dbfSalaVta, oGet, oGet2 )

   local oDlg
   local oBrw
   local oBtn
   local oGet1
   local cGet1
   local nOrdAnt        := 1
   local oCbxOrd
   local aCbxOrd        := { "Código", "Nombre" }
   local cCbxOrd

   nOrdAnt              := Min( Max( nOrdAnt, 1 ), len( aCbxOrd ) )
   cCbxOrd              := aCbxOrd[ nOrdAnt ]

   nOrdAnt              := ( dbfSalaVta )->( OrdSetFocus( nOrdAnt ) )

   ( dbfSalaVta )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY"      TITLE "Seleccionar Sala de ventas"

      REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfSalaVta ) );
         VALID    ( OrdClearScope( oBrw, dbfSalaVta ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfSalaVta )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus(), oCbxOrd:Refresh() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfSalaVta

      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Salas de ventas"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodigo"
         :bEditValue       := {|| ( dbfSalaVta )->cCodigo }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cDescrip"
         :bEditValue       := {|| ( dbfSalaVta )->cDescrip }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      WHEN     ( .f. );
      ACTION   ( nil )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       oDlg ;
      WHEN     ( .f. );
      ACTION   ( nil )

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

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfSalaVta )->cCodigo )
      oGet:lValid()

      if ValType( oGet2 ) == "O"
         oGet2:cText( ( dbfSalaVta )->cDescrip )
      end if

   end if

   DestroyFastFilter( dbfSalaVta )

   SetBrwOpt( "BrwSalaVta", ( dbfSalaVta )->( OrdNumber() ) )

   oGet:SetFocus()

Return ( .t. )

//---------------------------------------------------------------------------//