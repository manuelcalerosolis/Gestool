#include "HbXml.ch"
#include "TDbfDbf.ch" 


//---------------------------------------------------------------------------//

static dbfArticulo    
static dbfProv        
static dbfCatalogo    
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
static dbfTImp     

static hFile
static cFile      

//---------------------------------------------------------------------------//

Function Luncher()

msgStop( "dentro del script" )

Return nil

//---------------------------------------------------------------------------//

Function ExportaStock()

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

      while !( dbfArticulo )->( eof() )

         //msgWait( Str( ( dbfArticulo )->( ordKeyNo() ) ) + " de " + Str( ( dbfArticulo )->( ordkeyCount() ) ), "Exportando", .1 )

         if ( dbfArticulo )->lPubInt

            nTotStockAct   := oStock:nTotStockAct( ( dbfArticulo )->Codigo ) // , "006" )

            fWrite( hFile, AllTrim( ( dbfArticulo )->Codigo ) + ";" + ;
                           AllTrim( Trans( nTotStockAct, "@E 999,999,999" ) ) + ";" + ;
                           AllTrim( Trans( ( dbfArticulo )->pVenta5, "@E 999,999,999.999" ) ) + ;
                           Chr( 13 ) + Chr( 10 ) )

         end if

         ( dbfArticulo )->( dbSkip() )

      end while

      fClose( hFile )

      CloseFiles()

msgStop( "En ejecucuiion" )


      // Subimos el fichero al ftp---------------------------------------------
/*
      oInt           := TInternet():New()
      oFtp           := TFtp():New( "ftp.ayives.com", oInt, "demonio", "passdemon1", .f. )

      if Empty( oFtp )
         msgWait( "Imposible crear la conexión", "Error", 1 )
         return .f.
      end if

      if Empty( oFtp:hFTP )
         msgWait( "Imposible conectar con el servidor", "Error", 1 )
         return .f.
      endif

      if File( cFile )
         TFtpFile():New( cFile, oFtp ):PutFile()
      end if
*/
   end if 

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

      dbUseArea( .T., ( cDriver() ), ( cPatGrp() + "CATALOGO.DBF" ), ( cCheckArea( "CATALOGO", @dbfCatalogo ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatGrp() + "CATALOGO.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

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

      dbUseArea( .T., ( cDriver() ), ( cPatDat() + "TIPIMP.DBF" ), ( cCheckArea( "TIPIMP", @dbfTImp ) ), if(.T. .OR. .F., !.F., NIL), .F.,, )
      if !lAIS() ; ordListAdd( ( cPatDat() + "TIPIMP.CDX" ) ) ; else ; ordSetFocus( 1 ) ; end

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

   if dbfCatalogo <> nil
      ( dbfCatalogo )->( dbCloseArea() )
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

   if dbfTImp <> nil
      ( dbfTImp )->( dbCloseArea() )
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
   dbfTImp        := nil

   lOpenFiles     := .F.

RETURN ( .T. )

//---------------------------------------------------------------------------//
