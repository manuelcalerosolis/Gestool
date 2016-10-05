#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"

#define OFN_PATHMUSTEXIST            0x00000800
#define OFN_NOCHANGEDIR              0x00000008
#define OFN_ALLOWMULTISELECT         0x00000200
#define OFN_EXPLORER                 0x00080000     // new look commdlg
#define OFN_LONGNAMES                0x00200000     // force long names for 3.x modules
#define OFN_ENABLESIZING             0x00800000
#define _ICG_LINE_LEN_               211

static nView
static nNumAlb

//----------------------------------------------------------------------------//

Function IcgMotor( nVie )

   local oDlg
   local aFichero
   local oInforme
   local oBrwFichero
   local oTreeImportacion
   local oImageImportacion

   aFichero                         := {}
   cInforme                         := ""
   lIncidencia                      := .f.
   nView                            := nVie

   DEFINE DIALOG oDlg RESOURCE "ImportarICG"

      /*
      Browse de ficheros a importar--------------------------------------------
      */

      oBrwFichero                   := IXBrowse():New( oDlg )

      oBrwFichero:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwFichero:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwFichero:SetArray( aFichero, , , .f. )

      oBrwFichero:nMarqueeStyle     := 5

      oBrwFichero:lHScroll          := .f.

      oBrwFichero:CreateFromResource( 220 )

      oBrwFichero:bLDblClick        := {|| ShellExecute( oDlg:hWnd, "open", Rtrim( aFichero[ oBrwFichero:nArrayAt ] ) ) }

      with object ( oBrwFichero:AddCol() )
         :cHeader          := "Fichero"
         :bEditValue       := {|| aFichero[ oBrwFichero:nArrayAt ] }
         :nWidth           := 460
      end with

      REDEFINE BUTTON ;
         ID       200 ;
         OF       oDlg ;
         ACTION   ( AddFicheroICG( aFichero, oBrwFichero ) )

      REDEFINE BUTTON ;
         ID       210 ;
         OF       oDlg ;
         ACTION   ( DelFicheroICG( aFichero, oBrwFichero ) )

      /*
      Tree de importación------------------------------------------------------
      */

      REDEFINE GET oInforme VAR cInforme ;
         MEMO ;
         ID       230;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( IcgAlbPrv( aFichero, oDlg, oInforme ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| IcgAlbPrv( aFichero, oDlg, oInforme ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION IcgAlbPrv( aFichero, oDlg, oInforme )

   local nBytes
   local aTotAlb
   local cSerDoc
   local nNumDoc
   local cSufDoc
   local dFecDoc
   local cRefLin
   local cDesLin
   local nUntLin
   local nPvpLin
   local nDtoLin
   local cFilEdm
   local hFilEdm
   local cBuffer
   local cInformeToShow
   local hashDatabaseList  := {=>}

   cInforme                := ""

   /*
   Obtenemos la fecha del albaran----------------------------------------------
   */

   for each cFilEdm in aFichero

      if file( cFilEdm )

         cInforme          += "Importando el fichero " + cFilEdm + CRLF 
         cInforme          += CRLF

         /*
         Abrimos las bases de datos--------------------------------------------------
         */

         hFilEdm           := fOpen( cFilEdm )

         fSeek( hFilEdm, 0, 0 )

         SysRefresh()

         cBuffer           := Space( _ICG_LINE_LEN_ )
         nBytes            := fRead( hFilEdm, @cBuffer, _ICG_LINE_LEN_ )

         cSerDoc           := SubStr( cBuffer,  9, 1 )
         nNumDoc           := SubStr( cBuffer, 11, 8 )
         cSufDoc           := SubStr( cBuffer,  9, 2 )
         dFecDoc           := SubStr( cBuffer, 20, 8 )

         IcgCabAlbPrv( cSerDoc, nNumDoc, cSufDoc, dFecDoc )

         cBuffer           := Space( _ICG_LINE_LEN_ )

         nBytes            := fRead( hFilEdm, @cBuffer, _ICG_LINE_LEN_ )

         cBuffer           := Space( _ICG_LINE_LEN_ )

         while ( nBytes    := fRead( hFilEdm, @cBuffer, _ICG_LINE_LEN_ ) ) == _ICG_LINE_LEN_

            cBuffer        := Alltrim( cBuffer )

            cDesLin        := Upper( AllTrim( SubStr( cBuffer, 21, 36 ) ) )

            nUntLin        := SubStr( cBuffer, 57, 5 )

            if At( "-", nUntLin ) != 0
               nUntLin     := StrTran( nUntLin, "-", "" )
               nUntLin     := Val( nUntLin ) * -1
            else
               nUntLin     := Val( nUntLin )
            end if

            nPvpLin        := Val( SubStr( cBuffer, 63, 7 ) )

            nDtoLin        := val( strtran( substr( cBuffer, 71, 7 ), ",", "." ) )

            if ( nDtoLin >= 100 )

               cRefLin     := Alltrim( SubStr( cBuffer, 87, 8 ) )

               // Desplazamiento por los melones de Andel----------------------

               fRead( hFilEdm, @cBuffer, 1 )

            else

               cRefLin     := Alltrim( SubStr( cBuffer, 87, 8 ) )

            end if

            if Left( cDesLin, 1 ) != "*"
               IcgDetAlbPrv( cSerDoc, cSufDoc, cDesLin, nUntLin, nPvpLin, nDtoLin, cRefLin )
            end if

            SysRefresh()

            cBuffer        := Space( _ICG_LINE_LEN_ )

         end while

         fClose( hFilEdm )

         // Recalculo del total------------------------------------------------

         if dbLock( D():AlbaranesProveedores( nView ) )

            aTotAlb                 := aTotAlbPrv( ( D():AlbaranesProveedores( nView ) )->cSerAlb + Str( ( D():AlbaranesProveedores( nView ) )->nNumAlb ) + ( D():AlbaranesProveedores( nView ) )->cSufAlb, D():AlbaranesProveedores( nView ), D():AlbaranesProveedoresLineas( nView ), D():TiposIva( nView ), D():Divisas( nView ), ( D():AlbaranesProveedores( nView ) )->cDivAlb )

            ( D():AlbaranesProveedores( nView ) )->nTotNet := aTotAlb[ 1 ]
            ( D():AlbaranesProveedores( nView ) )->nTotIva := aTotAlb[ 2 ]
            ( D():AlbaranesProveedores( nView ) )->nTotReq := aTotAlb[ 3 ]
            ( D():AlbaranesProveedores( nView ) )->nTotAlb := aTotAlb[ 4 ]

            ( D():AlbaranesProveedores( nView ) )->( dbUnLock() )

         end if

      else

         if !Empty( cFilEdm )
            cInforme                   += "No existe el fichero " + cFilEdm + CRLF
         end if

      end if

   next

   oInforme:cText( cInforme )

   if lIncidencia

      /*
      Envío de  mail al usuario----------------------------------------------
      */

      cInformeToShow                   := strtran( cInforme, CRLF, "</p>",  )

      hSet( hashDatabaseList, "mail", "josecarlos@icgmotor.com" )
      hSet( hashDatabaseList, "subject", "Indicencias en albaranes de proveedor" )
      hSet( hashDatabaseList, "message", Rtrim( cInformeToShow ) )

      with object TSendMail():New()
         
         if :buildMailerObject()

            :sendMail( hashDatabaseList )

         end if 

      end with

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function AddFicheroICG( aFichero, oBrwFichero )

   local i
   local cFile
   local aFile
   local nFlag    := nOr( OFN_PATHMUSTEXIST, OFN_NOCHANGEDIR, OFN_ALLOWMULTISELECT, OFN_EXPLORER, OFN_LONGNAMES )

   cFile          := cGetFile( "All | *.*", "Seleccione los ficheros a importar", "*.*" , , .f., .t., nFlag )
   cFile          := Left( cFile, At( Chr( 0 ) + Chr( 0 ), cFile ) - 1 )

   if !Empty( cFile ) //.or. Valtype( cFile ) == "N"

      cFile       := StrTran( cFile, Chr( 0 ), "," )
      aFile       := hb_aTokens( cFile, "," )

      if Len( aFile ) > 1

         for i := 2 to Len( aFile )
            aFile[ i ] := aFile[ 1 ] + "\" + aFile[ i ]
         next

         aDel( aFile, 1, .t. )

      endif

      if IsArray( aFile )

         for i := 1 to Len( aFile )
            aAdd( aFichero, aFile[ i ] ) // if( SubStr( aFile[ i ], 4, 1 ) == "\", aFileDisc( aFile[i] ) + "\" + aFileName( aFile[ i ] ), aFile[ i ] ) )
         next

      else

         aAdd( aFichero, aFile )

      endif

   end if

   oBrwFichero:Refresh()

RETURN ( aFichero )

//---------------------------------------------------------------------------//

Static Function DelFicheroICG( aFichero, oBrwFichero )

   aDel( aFichero, oBrwFichero:nArrayAt, .t. )

   oBrwFichero:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function IcgCabAlbPrv( cSerDoc, nNumDoc, cSufDoc, dFecDoc )

   local lApp
   local cCodPrv                 := Replicate( "0", RetNumCodPrvEmp() )

   if dbSeekInOrd( cSerDoc + nNumDoc + cSufDoc, "cSuAlb", D():AlbaranesProveedores( nView ) )

      lApp                       := .f.
      cSerDoc                    := ( D():AlbaranesProveedores( nView ) )->cSerAlb
      nNumAlb                    := ( D():AlbaranesProveedores( nView ) )->nNumAlb
      cSufDoc                    := ( D():AlbaranesProveedores( nView ) )->cSufAlb

      while ( D():AlbaranesProveedoresLineas( nView ) )->( dbSeek( cSerDoc + Str( nNumAlb ) + cSufDoc ) )
         if dbLock( D():AlbaranesProveedoresLineas( nView ) )
            ( D():AlbaranesProveedoresLineas( nView ) )->( dbDelete() )
            ( D():AlbaranesProveedoresLineas( nView ) )->( dbUnLock() )
         end if
      end while

   else

      lApp                       := .t.
      nNumAlb                    := nNewDoc( cSerDoc, D():AlbaranesProveedores( nView ), "nAlbPrv", , D():Contadores( nView ) )

   end if

   if lApp
      dbAppe( D():AlbaranesProveedores( nView ) )
   else
      dbLock( D():AlbaranesProveedores( nView ) )
   end if

      ( D():AlbaranesProveedores( nView ) )->cSerAlb    := cSerDoc
      ( D():AlbaranesProveedores( nView ) )->nNumAlb    := nNumAlb
      ( D():AlbaranesProveedores( nView ) )->cSufAlb    := cSufDoc
      ( D():AlbaranesProveedores( nView ) )->dFecAlb    := Stod( dFecDoc )
      ( D():AlbaranesProveedores( nView ) )->cCodAlm    := oUser():cAlmacen()
      ( D():AlbaranesProveedores( nView ) )->cDivAlb    := cDivEmp()
      ( D():AlbaranesProveedores( nView ) )->nVdvAlb    := nChgDiv( cDivEmp(), D():Divisas( nView ) )
      ( D():AlbaranesProveedores( nView ) )->cSuAlb     := cSerDoc + nNumDoc + cSufDoc
      ( D():AlbaranesProveedores( nView ) )->cCodUsr    := cCurUsr()
      ( D():AlbaranesProveedores( nView ) )->cCodDlg    := oUser():cDelegacion()
      ( D():AlbaranesProveedores( nView ) )->cCodCaj    := oUser():cCaja()
      ( D():AlbaranesProveedores( nView ) )->cTurAlb    := cCurSesion()
      ( D():AlbaranesProveedores( nView ) )->lFacturado := .f.
      ( D():AlbaranesProveedores( nView ) )->nFacturado := 1

      ( D():AlbaranesProveedores( nView ) )->cCodPrv    := cCodPrv

      if ( D():Proveedores( nView ) )->( dbSeek( cCodPrv ) )
         ( D():AlbaranesProveedores( nView ) )->cNomPrv := ( D():Proveedores( nView ) )->Titulo
         ( D():AlbaranesProveedores( nView ) )->cDirPrv := ( D():Proveedores( nView ) )->Domicilio
         ( D():AlbaranesProveedores( nView ) )->cPobPrv := ( D():Proveedores( nView ) )->Poblacion
         ( D():AlbaranesProveedores( nView ) )->cProPrv := ( D():Proveedores( nView ) )->Provincia
         ( D():AlbaranesProveedores( nView ) )->cPosPrv := ( D():Proveedores( nView ) )->CodPostal
         ( D():AlbaranesProveedores( nView ) )->cDniPrv := ( D():Proveedores( nView ) )->Nif
      end if

   ( D():AlbaranesProveedores( nView ) )->( dbUnlock() )

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function IcgDetAlbPrv( cSerDoc, cSufDoc, cDesLin, nUntLin, nPvpLin, nDtoLin, cRefLin )

   if !dbSeekInOrd( cRefLin, "Codigo", D():Articulos( nView ) )

      cInforme                += "Articulo " + cRefLin + ", " + cDesLin + " no existe en la base de datos" + CRLF 
      cInforme                += CRLF 
      lIncidencia             := .t.
   else 
      if ( Round( ( D():Articulos( nView ) )->pCosto, 2 ) != ( Round( ( nPvpLin ) - ( nPvpLin * nDtoLin / 100 ), 2 ) ) )
         cInforme             += "Articulo " + cRefLin + ", " + cDesLin + " ha variado su precio de costo," + CRLF
         cInforme             += Space( 4 ) + "Familia " + ( D():Articulos( nView ) )->Familia + ", " + alltrim( retFamilia( ( D():Articulos( nView ) )->Familia, D():Familias( nView ) ) )
         cInforme             += Space( 4 ) + "Precio nuevo " + alltrim( str( round( ( nPvpLin ) - ( nPvpLin * nDtoLin / 100 ), 2 ) ) ) 
         cInforme             += Space( 4 ) + "Precio anterior " + alltrim( str( round( ( D():Articulos( nView ) )->pCosto, 2 ) ) ) + CRLF 
         cInforme             += CRLF 
         lIncidencia          := .t.
      end if
   end if

   ( D():AlbaranesProveedoresLineas( nView ) )->( dbAppend() )
   ( D():AlbaranesProveedoresLineas( nView ) )->cSerAlb    := cSerDoc
   ( D():AlbaranesProveedoresLineas( nView ) )->nNumAlb    := nNumAlb
   ( D():AlbaranesProveedoresLineas( nView ) )->cSufAlb    := cSufDoc
   ( D():AlbaranesProveedoresLineas( nView ) )->cAlmLin    := oUser():cAlmacen()
   ( D():AlbaranesProveedoresLineas( nView ) )->cRef       := cRefLin
   ( D():AlbaranesProveedoresLineas( nView ) )->cDetalle   := cDesLin
   ( D():AlbaranesProveedoresLineas( nView ) )->mLngDes    := cDesLin
   ( D():AlbaranesProveedoresLineas( nView ) )->nUniCaja   := nUntLin
   ( D():AlbaranesProveedoresLineas( nView ) )->nPreDiv    := nPvpLin
   ( D():AlbaranesProveedoresLineas( nView ) )->nDtoLin    := nDtoLin
   ( D():AlbaranesProveedoresLineas( nView ) )->nIva       := nIva( D():TiposIva( nView ), "G" )
   ( D():AlbaranesProveedoresLineas( nView ) )->lFacturado := .f.

   ( D():AlbaranesProveedoresLineas( nView ) )->( dbUnlock() )

RETURN ( nil )

//---------------------------------------------------------------------------//
