#include "HbXml.ch"
#include "TDbfDbf.ch"
#include "fivewin.ch"

//---------------------------------------------------------------------------//

static dbfArticulo     
static dbfProv        
static dbfIva         
static dbfFam         
static dbfFamPrv      
static dbfArtPrv      
static oStock         
static dbfTMov        
static dbfTarPreT     
static dbfTarPreL     
static dbfTarPreS     
static dbfOfe         
static dbfImg         
static dbfDiv         
static dbfArtVta      
static oBandera       
static dbfAlmT        
static dbfArtKit      
static dbfArtLbl      
static dbfTblPro      
static dbfPro         
static dbfCodebar     
static oTankes        
static oTipArt        
static oCatalogo      
static oNewImp        
static oFraPub        
static dbfDoc         
static dbfFlt         
static dbfCategoria   
static dbfTemporada   
static dbfAlbPrvL     
static dbfFacPrvL     
static dbfAlbCliL     
static dbfFacCliL     
static dbfFacRecL     
static dbfTikCliL     
static dbfProLin      
static dbfProMat      
static dbfHisMov      
static dbfAlbPrvT     
static dbfAlbCliT     
static dbfPedPrvL     
static dbfPedCliL     
static dbfUbicaT      
static dbfUbicaL      
static dbfRctPrvL   

static hFile
static cFile      

//---------------------------------------------------------------------------//

Function Luncher()

   local oDlg, oMeter, oText, oBtn, oFont
   local nVal     := 0
   local cMsg     := "Proceso de exportacion a fichero"
   local cTitle   := "Espere por favor..."

   cFile          := "c:\" + Dtos( date() ) + Strtran( Time(), ":", "" ) + ".txt"

   DEFINE FONT oFont NAME GetSysFont() SIZE 0, -8

   DEFINE DIALOG oDlg FROM 5, 5 TO 13, 45 TITLE cTitle FONT oFont

   @ 0.2, 0.5  SAY oText VAR cMsg SIZE 130, 20 OF oDlg

   @ 2.2,   0.5  METER oMeter VAR nVal TOTAL 10 SIZE 150, 2 OF oDlg

   oDlg:bStart = { || ExportaStock( oMeter, oText, oDlg ) }

   ACTIVATE DIALOG oDlg CENTERED

   oFont:End()

   ferase( cFile )

Return nil

//---------------------------------------------------------------------------//

Function ExportaStock( oMeter, oText, oDlg )

   local oInt
   local oFtp
   local nTotStockAct   

   if lOpenFiles()

      if File( cFile )
         fErase( cFile )
      end if 

      hFile       := fCreate( cFile )

      ( dbfArticulo )->( ordsetfocus( "lPubInt" ) )
      ( dbfArticulo )->( dbGoTop() )

      if !empty(oMeter)
         oMeter:setTotal( ( dbfArticulo )->( ordkeyCount() ) )
      end if

      while !( dbfArticulo )->( eof() )

         if ( dbfArticulo )->lPubInt

            nTotStockAct   := oStock:nTotStockAct( ( dbfArticulo )->Codigo, "006             " )

            if !empty( oText )
               oText:setText( alltrim( ( dbfArticulo )->Codigo ) + space(1) + alltrim( ( dbfArticulo )->Nombre ) )
            end if

            fWrite( hFile, AllTrim( ( dbfArticulo )->Codigo ) + ";" + ;
                           AllTrim( Trans( nTotStockAct, "@E 999,999,999" ) ) + ";" + ;
                           AllTrim( Trans( ( dbfArticulo )->pVenta5, "@E 999,999,999.999" ) ) + ";" + ;
                           AllTrim( Trans( ( dbfArticulo )->pCosto, "@E 999,999,999.999" ) ) + ;
                           Chr( 13 ) + Chr( 10 ) )

         end if

         ( dbfArticulo )->( dbSkip() )

         if !empty(oMeter)
            oMeter:set( ( dbfArticulo )->( ordkeyno() ) )
         end if

      end while

      fClose( hFile )

      CloseFiles()

      // Subimos el fichero al ftp---------------------------------------------

      if !empty( oText )
         oText:setText( "Subimos el fichero resultante al Ftp" )
      end if

      oFtp         := TFtpCurl():New( 'demonio', 'passdemon1', 'ftp.ayives.com', 21 )
      oFtp:setPassive( .f. )

      if !oFtp:CreateConexion()
         msgWait( "Imposible crear la conexión", "Error", 1 )
         return .f.
      end if   

      if File( cFile )
         oFtp:createFile( cFile )
      end if

      if !empty( oFTP )
         oFTP:endConexion()
      end if

      if !empty( oText )
         oText:setText( "Fichero subido" )
      end if

   end if 

   oDlg:End()

Return ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION lOpenFiles( lExt, cPath )

   local oError
   local oBlock

   CursorWait()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oMsgText( "Abriendo ficheros artículos" )

      lOpenFiles  := .t.

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "ARTICULO.DBF" ), ( cCheckArea( "ARTICULO", @dbfArticulo ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "ARTICULO.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "ArtCodebar.Dbf" ), ( cCheckArea( "CODEBAR", @dbfCodebar ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "ArtCodebar.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "PROVART.DBF" ), ( cCheckArea( "PROVART", @dbfArtPrv ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "PROVART.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatPrv() + "PROVEE.DBF" ), ( cCheckArea( "PROVEE", @dbfProv ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatPrv() + "PROVEE.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "CATEGORIAS.DBF" ), ( cCheckArea( "CATEGORIA", @dbfCategoria ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "CATEGORIAS.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "Temporadas.Dbf" ), ( cCheckArea( "TEMPORADA", @dbfTemporada ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "Temporadas.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatDat() + "TIVA.DBF" ), ( cCheckArea( "TIVA", @dbfIva ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatDat() + "TIVA.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "FAMILIAS.DBF" ), ( cCheckArea( "FAMILIAS", @dbfFam ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "FAMILIAS.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "FamPrv.Dbf" ), ( cCheckArea( "FAMPRV", @dbfFamPrv ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "FamPrv.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatDat() + "TMOV.DBF" ), ( cCheckArea( "TMOV", @dbfTMov ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatDat() + "TMOV.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "TARPRET.DBF" ), ( cCheckArea( "TARPRET", @dbfTarPreT ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "TARPRET.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "TARPREL.DBF" ), ( cCheckArea( "TARPREL", @dbfTarPreL ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "TARPREL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "CCODART" )

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "TARPRES.DBF" ), ( cCheckArea( "TARPRES", @dbfTarPreS ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "TARPRES.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "OFERTA.DBF" ), ( cCheckArea( "OFERTA", @dbfOfe ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "OFERTA.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "ARTDIV.DBF" ), ( cCheckArea( "ARTDIV", @dbfArtVta ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "ARTDIV.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "ArtLbl.Dbf" ), ( cCheckArea( "ArtLbl", @dbfArtLbl ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "ArtLbl.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "ArtImg.Dbf" ), ( cCheckArea( "ArtImg", @dbfImg ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "ArtImg.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatDat() + "DIVISAS.DBF" ), ( cCheckArea( "DIVISAS", @dbfDiv ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatDat() + "DIVISAS.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatAlm() + "ALMACEN.DBF" ), ( cCheckArea( "ALMACEN", @dbfAlmT ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatAlm() + "ALMACEN.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "ARTKIT.DBF" ), ( cCheckArea( "ARTTIK", @dbfArtKit ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "ARTKIT.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "PRO.DBF" ), ( cCheckArea( "PRO", @dbfPro ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "PRO.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatArt() + "TBLPRO.DBF" ), ( cCheckArea( "TBLPRO", @dbfTblPro ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatArt() + "TBLPRO.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "RDOCUMEN.DBF" ), ( cCheckArea( "RDOCUMEN", @dbfDoc ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "RDOCUMEN.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "CTIPO" )

      dbUseArea( .T., ( cDriver() ), ( cPatDat() + "CNFFLT.DBF" ), ( cCheckArea( "CNFFLT", @dbfFlt ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatDat() + "CNFFLT.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "ALBPROVL.DBF" ), ( cCheckArea( "ALBPROVL", @dbfAlbPrvL ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
     if !lAIS() ; ordListAdd( ( cPatEmp() + "ALBPROVL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "cStkFast" )

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "FACPRVL.DBF" ), ( cCheckArea( "FACPRVL", @dbfFacPrvL ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "FACPRVL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "cRef" )

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "RctPrvL.DBF" ), ( cCheckArea( "RctPrvL", @dbfRctPrvL ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "RctPrvL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "cRef" )

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "ALBCLIL.DBF" ), ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "ALBCLIL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "cStkFast" )

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "FACCLIL.DBF" ), ( cCheckArea( "FACCLIL", @dbfFacCliL ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "FACCLIL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "cRef" )

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "FacRecL.DBF" ), ( cCheckArea( "FacRecL", @dbfFacRecL ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "FacRecL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "cRef" )

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "TIKEL.DBF" ), ( cCheckArea( "TIKEL", @dbfTikCliL ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "TIKEL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "CSTKFAST" )

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "PROLIN.DBF" ), ( cCheckArea( "PROLIN", @dbfProLin ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "PROLIN.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "cCodArt" )

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "PROMAT.DBF" ), ( cCheckArea( "PROMAT", @dbfProMat ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "PROMAT.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "cCodArt" )

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "HISMOV.DBF" ), ( cCheckArea( "HISMOV", @dbfHisMov ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "HISMOV.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "cRefMov" )

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "ALBPROVT.DBF" ), ( cCheckArea( "AlbPrvT", @dbfAlbPrvT ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "ALBPROVT.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "ALBCLIT.DBF" ), ( cCheckArea( "AlbCliT", @dbfAlbCliT ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "ALBCLIT.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "PEDPROVL.DBF" ), ( cCheckArea( "PedPrvL", @dbfPedPrvL ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "PEDPROVL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "cRef" )

      dbUseArea( .T., ( cDriver() ), ( cPatEmp() + "PEDCLIL.DBF" ), ( cCheckArea( "PedCliL", @dbfPedCliL ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatEmp() + "PEDCLIL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end
      ordSetFocus( "cRef" )

      dbUseArea( .T., ( cDriver() ), ( cPatAlm() + "UBICAT.DBF" ), ( cCheckArea( "UBICAT", @dbfUbicaT ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatAlm() + "UBICAT.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .T., ( cDriver() ), ( cPatAlm() + "UBICAL.DBF" ), ( cCheckArea( "UBICAL", @dbfUbicaL ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatAlm() + "UBICAL.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

      oStock               := TStock():Create( cPatGrp() )

      if !oStock:lOpenFiles()
         lOpenFiles        := .F.
      end if 

   RECOVER USING oError

      lOpenFiles           := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de artículos" )

   end

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end

   CursorWE()

RETURN ( lOpenFiles )

//---------------------------------------------------------------------------//

STATIC FUNCTION CloseFiles( )

   if dbfArticulo <> nil
      ( dbfArticulo )->( dbCloseArea() )
   end

   if dbfProv <> nil
      ( dbfProv )->( dbCloseArea() )
   end

   if dbfCategoria <> nil
      ( dbfCategoria )->( dbCloseArea() )
   end

   if dbfTemporada <> nil
      ( dbfTemporada )->( dbCloseArea() )
   end

   if dbfIva <> nil
      ( dbfIva )->( dbCloseArea() )
   end

   if dbfFam <> nil
      ( dbfFam )->( dbCloseArea() )
   end

   if dbfFamPrv <> nil
      ( dbfFamPrv )->( dbCloseArea() )
   end

   if dbfTMov <> nil
      ( dbfTMov )->( dbCloseArea() )
   end

   if dbfArtPrv <> nil
      ( dbfArtPrv )->( dbCloseArea() )
   end

   if dbfArtLbl <> nil
      ( dbfArtLbl )->( dbCloseArea() )
   end

   if dbfTarPreT <> nil
      ( dbfTarPreT )->( dbCloseArea() )
   end

   if dbfTarPreL <> nil
      ( dbfTarPreL )->( dbCloseArea() )
   end

   if dbfTarPreS <> nil
      ( dbfTarPreS )->( dbCloseArea() )
   end

   if dbfOfe <> nil
      ( dbfOfe )->( dbCloseArea() )
   end

   if dbfImg <> nil
      ( dbfImg )->( dbCloseArea() )
   end

   if dbfDiv <> nil
      ( dbfDiv )->( dbCloseArea() )
   end

   if dbfArtVta <> nil
      ( dbfArtVta )->( dbCloseArea() )
   end

   if dbfAlmT <> nil
      ( dbfAlmT )->( dbCloseArea() )
   end

   if dbfArtKit <> nil
      ( dbfArtKit )->( dbCloseArea() )
   end

   if dbfTblPro <> nil
      ( dbfTblPro )->( dbCloseArea() )
   end

   if dbfPro <> nil
      ( dbfPro )->( dbCloseArea() )
   end

   if dbfCodebar <> nil
      ( dbfCodebar )->( dbCloseArea() )
   end

   if dbfAlbPrvL <> nil
      ( dbfAlbPrvL )->( dbCloseArea() )
   end

   if dbfFacPrvL <> nil
      ( dbfFacPrvL )->( dbCloseArea() )
   end

   if dbfRctPrvL <> nil
      ( dbfRctPrvL )->( dbCloseArea() )
   end

   if dbfAlbCliL <> nil
      ( dbfAlbCliL )->( dbCloseArea() )
   end

   if dbfFacCliL <> nil
      ( dbfFacCliL )->( dbCloseArea() )
   end

   if dbfFacRecL <> nil
      ( dbfFacRecL )->( dbCloseArea() )
   end

   if dbfTikCliL <> nil
      ( dbfTikCliL )->( dbCloseArea() )
   end

   if dbfProLin <> nil
      ( dbfProLin )->( dbCloseArea() )
   end

   if dbfProMat <> nil
      ( dbfProMat )->( dbCloseArea() )
   end

   if dbfHisMov <> nil
      ( dbfHisMov )->( dbCloseArea() )
   end

   if dbfAlbPrvT <> nil
      ( dbfAlbPrvT )->( dbCloseArea() )
   end

   if dbfAlbCliT <> nil
      ( dbfAlbCliT )->( dbCloseArea() )
   end

   if dbfPedPrvL <> nil
      ( dbfPedPrvL )->( dbCloseArea() )
   end

   if dbfPedCliL <> nil
      ( dbfPedCliL )->( dbCloseArea() )
   end

   if dbfUbicaT <> nil
      ( dbfUbicaT )->( dbCloseArea() )
   end

   if dbfUbicaL <> nil
      ( dbfUbicaL )->( dbCloseArea() )
   end

   if !Empty( oStock )
      oStock:end()
   end

   dbfArticulo    := nil
   dbfProv        := nil
   dbfCatalogo    := nil
   dbfIva         := nil
   dbfFam         := nil
   dbfFamPrv      := nil
   dbfArtPrv      := nil
   oStock         := nil
   dbfTMov        := nil
   dbfTarPreT     := nil
   dbfTarPreL     := nil
   dbfTarPreS     := nil
   dbfOfe         := nil
   dbfImg         := nil
   dbfDiv         := nil
   dbfArtVta      := nil
   oBandera       := nil
   dbfAlmT        := nil
   dbfArtKit      := nil
   dbfArtLbl      := nil
   dbfTblPro      := nil
   dbfPro         := nil
   dbfCodebar     := nil
   oTankes        := nil
   oTipArt        := nil
   oCatalogo      := nil
   oNewImp        := nil
   oFraPub        := nil
   dbfDoc         := nil
   dbfFlt         := nil
   dbfCategoria   := nil
   dbfTemporada   := nil
   dbfAlbPrvL     := nil
   dbfFacPrvL     := nil
   dbfAlbCliL     := nil
   dbfFacCliL     := nil
   dbfFacRecL     := nil
   dbfTikCliL     := nil
   dbfProLin      := nil
   dbfProMat      := nil
   dbfHisMov      := nil
   dbfAlbPrvT     := nil
   dbfAlbCliT     := nil
   dbfPedPrvL     := nil
   dbfPedCliL     := nil
   dbfUbicaT      := nil
   dbfUbicaL      := nil

   lOpenFiles     := .F.

RETURN ( .T. )

//---------------------------------------------------------------------------//