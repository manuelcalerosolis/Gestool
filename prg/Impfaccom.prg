/* Importación de datos de factucont */

#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

CLASS TImpFacCom

   DATA oDlg

   DATA aLgcIndices
   DATA aChkIndices
   DATA aMtrIndices
   DATA aNumIndices
   DATA oDbfArtGst
   DATA oDbfCliGst
   DATA oDbfArtFac
   DATA oDbfCliFac
   DATA oDbfFamGst
   DATA oDbfPrvGst
   DATA oDbfPrvFac
   DATA oDbfArtPrv
   DATA oDbfCliBnc
   DATA oDbfAlbTGst
   DATA oDbfAlbLGst
   DATA oDbfAlbTFac
   DATA oDbfAlbLFac
   DATA oDbfFacTGst
   DATA oDbfFacLGst
   DATA oDbfFacPGst
   DATA oDbfFacTFac
   DATA oDbfAntTGst
   DATA oDbfFacPrvTFac
   DATA oDbfFacPrvTGst
   DATA oDbfFacPrvLGst
   DATA oDbfFacPrvPGst
   DATA cPathFac
   DATA oDbfIva
   DATA oDbfPgo
   DATA oDbfDiv

   METHOD New()

   METHOD OpenFiles()

   METHOD CloseFiles()

END CLASS

//---------------------------------------------------------------------------//
/*Abrimos los ficheros*/

METHOD OpenFiles()

   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   if Empty( ::cPathFac )
      MsgStop( "Ruta de factucont ® está vacía" )
      return .f.
   end if

   if Right( ::cPathFac, 1 ) != "\"
      ::cPathFac  += "\"
   end if

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfIva PATH ( cPatDat() )  FILE "TIVA.DBF" VIA ( cDriver() )CLASS cImp() INDEX "TIVA.CDX"
   DATABASE NEW ::oDbfDiv PATH ( cPatDat() )  FILE "DIVISAS.DBF" VIA ( cDriver() )CLASS cImp() INDEX "DIVISAS.CDX"
   DATABASE NEW ::oDbfPgo PATH ( cPatGrp() )  FILE "FPAGO.DBF" VIA ( cDriver() )CLASS cImp() INDEX "FPAGO.CDX"

   if !File( ::cPathFac + "PROVEEDO.DBF" )
      ::aChkIndices[ 1 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de proveedores", ::cPathFac + "PROVEEDO.DBF" )
   else
      DATABASE NEW ::oDbfPrvGst PATH ( cPatPrv() )  FILE "PROVEE.DBF" VIA ( cDriver() )CLASS "PRVGST" INDEX "PROVEE.CDX"
      DATABASE NEW ::oDbfPrvFac PATH ( ::cPathFac ) FILE "PROVEEDO.DBF" VIA ( cDriver() )CLASS "PRVFAC"
   end if

   if !File( ::cPathFac + "CLIENTE.DBF" )
      ::aChkIndices[ 2 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de clientes", ::cPathFac + "CLIENTES.DBF" )
   else
      DATABASE NEW ::oDbfCliBnc PATH ( cPatCli() )  FILE "CLIBNC.DBF"   VIA ( cDriver() )CLASS "CLIBNCGST"  INDEX "CLIBNC.CDX"
      DATABASE NEW ::oDbfCliGst PATH ( cPatCli() )  FILE "CLIENT.DBF"   VIA ( cDriver() )CLASS "CLIGST"  INDEX "CLIENT.CDX"
      DATABASE NEW ::oDbfCliFac PATH ( ::cPathFac ) FILE "CLIENTE.DBF"  VIA ( cDriver() )CLASS "CLIFAC"
   end if

   if !File( ::cPathFac + "Articulo.DBF" )      
      ::aChkIndices[ 3 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de artículos", ::cPathFac + "ARTICULO.DBF" )
   else
      DATABASE NEW ::oDbfArtPrv PATH ( cPatArt() )  FILE "PROVART.DBF" VIA ( cDriver() )CLASS "ARTPRVGST" INDEX "PROVART.CDX"
      DATABASE NEW ::oDbfFamGst PATH ( cPatArt() )  FILE "FAMILIAS.DBF" VIA ( cDriver() )CLASS "FAMGST" INDEX "FAMILIAS.CDX"
      ::oDbfFamGst:OrdSetFocus( "CNOMFAM" )
      DATABASE NEW ::oDbfArtGst PATH ( cPatArt() )  FILE "ARTICULO.DBF" VIA ( cDriver() )CLASS "ARTGST" INDEX "ARTICULO.CDX"
      DATABASE NEW ::oDbfArtFac PATH ( ::cPathFac ) FILE "ARTICULO.DBF" VIA ( cDriver() )CLASS "ARTFAC"
   end if

//Comprobamos si existe el fichero donde se guardan las líneas de todos los documentos

   if !File( ::cPathFac + "CONTENI1.DBF" )
      ::aChkIndices[ 4 ]:Click( .f. ):Refresh()
      ::aChkIndices[ 5 ]:Click( .f. ):Refresh()
      ::aChkIndices[ 6 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de detalle de líneas", ::cPathFac + "CONTENI1.DBF" )
   else

      DATABASE NEW ::oDbfAlbLFac PATH ( ::cPathFac ) FILE "CONTENI1.DBF"   VIA ( cDriver() )CLASS "ALBLFAC"

      if !File( ::cPathFac + "ALBARAN1.DBF" )
         ::aChkIndices[ 4 ]:Click( .f. ):Refresh()
         msgStop( "No existe fichero de albaranes", ::cPathFac + "ALBARAN1.DBF" )
      else
         DATABASE NEW ::oDbfAlbTGst PATH ( cPatEmp() )  FILE "ALBCLIT.DBF"    VIA ( cDriver() )CLASS "ALBTGST"  INDEX "ALBCLIT.CDX"
         DATABASE NEW ::oDbfAlbTFac PATH ( ::cPathFac ) FILE "ALBARAN1.DBF"   VIA ( cDriver() )CLASS "ALBTFAC"
         DATABASE NEW ::oDbfAlbLGst PATH ( cPatEmp() )  FILE "ALBCLIL.DBF"    VIA ( cDriver() )CLASS "ALBLGST"  INDEX "ALBCLIL.CDX"
      end if 

      if !File( ::cPathFac + "INGRESO1.DBF" )
         ::aChkIndices[ 5 ]:Click( .f. ):Refresh()
         msgStop( "No existe fichero de facturas de clientes", ::cPathFac + "INGRESO1.DBF" )
      else
         DATABASE NEW ::oDbfFacTGst PATH ( cPatEmp() )  FILE "FACCLIT.DBF"    VIA ( cDriver() )CLASS "FACTGST"  INDEX "FACCLIT.CDX"
         DATABASE NEW ::oDbfFacTFac PATH ( ::cPathFac ) FILE "INGRESO1.DBF"   VIA ( cDriver() )CLASS "FACTFAC"
         DATABASE NEW ::oDbfFacLGst PATH ( cPatEmp() )  FILE "FACCLIL.DBF"    VIA ( cDriver() )CLASS "FACLGST"  INDEX "FACCLIL.CDX"
         DATABASE NEW ::oDbfFacPGst PATH ( cPatEmp() )  FILE "FACCLIP.DBF"    VIA ( cDriver() )CLASS "FACPGST"  INDEX "FACCLIP.CDX"
         DATABASE NEW ::oDbfAntTGst PATH ( cPatEmp() )  FILE "ANTCLIT.DBF"    VIA ( cDriver() )CLASS "ANTTGST"  INDEX "ANTCLIT.CDX"
      end if 

      if !File( ::cPathFac + "GASTOS1.DBF" )
         ::aChkIndices[ 6 ]:Click( .f. ):Refresh()
         msgStop( "No existe fichero de facturas de proveedores ", ::cPathFac + "GASTOS1.DBF" )
      else
         DATABASE NEW ::oDbfFacPrvTGst PATH ( cPatEmp() )    FILE "FACPRVT.DBF"  VIA ( cDriver() )CLASS "FACPRVTGST" INDEX "FACPRVT.CDX"
         DATABASE NEW ::oDbfFacPrvTFac PATH ( ::CPathFac() ) FILE "GASTOS1.DBF"  VIA ( cDriver() )CLASS "FACPRVTFAC"
         DATABASE NEW ::oDbfFacPrvLGst PATH ( cPatEmp() )    FILE "FACPRVL.DBF"  VIA ( cDriver() )CLASS "FACPRVLGST" INDEX "FACPRVL.CDX"
         DATABASE NEW ::oDbfFacPrvPGst PATH ( cPatEmp() )    FILE "FACPRVP.DBF"  VIA ( cDriver() )CLASS "FACPRVPGST" INDEX "FACPRVP.CDX"
      end if 

   end if

/*

   if !File( ::cPathFac + "ALBARAN1.DBF" ) .or. !File( ::cPathFac + "INGRESO1.DBF" ) .or. !File( ::cPathFac + "CONTENI1.DBF" )
      ::aChkIndices[ 4 ]:Click( .f. ):Refresh()
      ::aChkIndices[ 5 ]:Click( .f. ):Refresh()

      msgStop( "No existe fichero de albaranes", ::cPathFac + "ALBARAN1.DBF, ni" + ::cPathFac + "CONTENI1.DBF" )
   else
      DATABASE NEW ::oDbfAlbTGst PATH ( cPatEmp() )  FILE "ALBCLIT.DBF"    VIA ( cDriver() )CLASS "ALBTGST"  INDEX "ALBCLIT.CDX"
      DATABASE NEW ::oDbfAlbTFac PATH ( ::cPathFac ) FILE "ALBARAN1.DBF"   VIA ( cDriver() )CLASS "ALBTFAC"
      DATABASE NEW ::oDbfAlbLGst PATH ( cPatEmp() )  FILE "ALBCLIL.DBF"    VIA ( cDriver() )CLASS "ALBLGST"  INDEX "ALBCLIL.CDX"
      DATABASE NEW ::oDbfAlbLFac PATH ( ::cPathFac ) FILE "CONTENI1.DBF"   VIA ( cDriver() )CLASS "ALBLFAC"
      DATABASE NEW ::oDbfFacTGst PATH ( cPatEmp() )  FILE "FACCLIT.DBF"    VIA ( cDriver() )CLASS "FACTGST"  INDEX "FACCLIT.CDX"
      DATABASE NEW ::oDbfFacTFac PATH ( ::cPathFac ) FILE "INGRESO1.DBF"   VIA ( cDriver() )CLASS "FACTFAC"
      DATABASE NEW ::oDbfFacLGst PATH ( cPatEmp() )  FILE "FACCLIL.DBF"    VIA ( cDriver() )CLASS "FACLGST"  INDEX "FACCLIL.CDX"
      DATABASE NEW ::oDbfFacPGst PATH ( cPatEmp() )  FILE "FACCLIP.DBF"    VIA ( cDriver() )CLASS "FACPGST"  INDEX "FACCLIP.CDX"
      DATABASE NEW ::oDbfAntTGst PATH ( cPatEmp() )  FILE "ANTCLIT.DBF"    VIA ( cDriver() )CLASS "ANTTGST"  INDEX "ANTCLIT.CDX"
   end if

   if !File( ::cPathFac + "GASTOS1.DBF" ) .or. !File( ::cPathFac + "CONTENI1.DBF" )
      ::aChkIndices[ 6 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de facturas de proveedores", ::cPathFac + "GASTOS1.DBF, ni " + ::cPathFac + "CONTENI1.DBF" )
   else
      DATABASE NEW ::oDbfFacPrvTGst PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() )CLASS "FACPRVTGST" INDEX "FACPRVT.CDX"
      DATABASE NEW ::oDbfFacPrvTFac PATH ( CPatEmp() ) FILE "GASTOS1.DBF"  VIA ( cDriver() )CLASS "FACPRVTFAC"
      DATABASE NEW ::oDbfFacPrvLGst PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() )CLASS "FACPRVLGST" INDEX "FACPRVT.CDX"
      DATABASE NEW ::oDbfFacPrvLFac PATH ( cPatEmp() ) FILE "CONTENI1.DBF" VIA ( cDriver() )CLASS "FACPRVLFAC" 
      DATABASE NEW ::oDbfFacPrvPGst PATH ( cPatEmp() ) FILE "FACPRVP.DBF"  VIA ( cDriver() )CLASS "FACPRVPGST" INDEX "FACPRVP.CDX"
   end if

*/

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

// ----------------------------------------------------------------------------- //
/*Cerramos ficheros*/

METHOD CloseFiles()

   if !Empty( ::oDbfIva )
      ::oDbfIva:End()
   else
      ::oDbfIva := nil
   end if

   if !Empty( ::oDbfArtGst )
      ::oDbfArtGst:End()
   else
      ::oDbfArtGst := nil
   end if

   if !Empty( ::oDbfArtFac )
      ::oDbfArtFac:End()
   else
      ::oDbfArtFac := nil
   end if

   if !Empty( ::oDbfCliGst )
      ::oDbfCliGst:End()
   else
      ::oDbfCliGst := nil
   end if

   if !Empty( ::oDbfCliFac )
      ::oDbfCliFac:End()
   else
      ::oDbfCliFac := nil
   end if

   if !Empty( ::oDbfFamGst )
      ::oDbfFamGst:End()
   else
      ::oDbfFamGst := nil
   end if

   if !Empty( ::oDbfPrvGst )
      ::oDbfPrvGst:End()
   else
      ::oDbfPrvGst := nil
   end if

   if !Empty( ::oDbfPrvFac )
      ::oDbfPrvFac:End()
   else
      ::oDbfPrvFac := nil
   end if

   if !Empty( ::oDbfArtPrv )
      ::oDbfArtPrv:End()
   else
      ::oDbfArtPrv := nil
   end if

   if !Empty( ::oDbfCliBnc )
      ::oDbfCliBnc:End()
   else
      ::oDbfCliBnc := nil
   end if

   if !Empty( ::oDbfAlbTGst )
      ::oDbfAlbTGst:End()
   else
      ::oDbfAlbTGst := nil
   end if

   if !Empty( ::oDbfAlbTFac )
      ::oDbfAlbTFac:End()
   else
      ::oDbfAlbTFac := nil
   end if

   if !Empty( ::oDbfAlbLGst )
      ::oDbfAlbLGst:End()
   else
      ::oDbfAlbLGst := nil
   end if

   if !Empty( ::oDbfAlbLFac )
      ::oDbfAlbLFac:End()
   else
      ::oDbfAlbLFac := nil
   end if

   if !Empty( ::oDbfFacTGst )
      ::oDbfFacTGst:End()
   else
      ::oDbfFacTGst := nil
   end if

   if !Empty( ::oDbfFacLGst )
      ::oDbfFacLGst:End()
   else
      ::oDbfFacLGst := nil
   end if

   if !Empty( ::oDbfFacTFac )
      ::oDbfFacTFac:End()
   else
      ::oDbfFacTFac := nil
   end if

   if !Empty( ::oDbfFacPGst )
      ::oDbfFacPGst:End()
   else
      ::oDbfFacPGst := nil
   end if

   if !Empty( ::oDbfAntTGst )
      ::oDbfAntTGst:End()
   else
      ::oDbfAntTGst := nil
   end if

   if !Empty( ::oDbfPgo )
      ::oDbfPgo:End()
   else
      ::oDbfPgo := nil
   end if

   if !Empty( ::oDbfDiv )
      ::oDbfDiv:End()
   else
      ::oDbfDiv := nil
   end if

   if !Empty( ::oDbfFacPrvTGst )
      ::oDbfFacPrvTGst:End()
   else
      ::oDbfFacPrvTGst := nil
   end if

   if !Empty( ::oDbfFacPrvTFac )
      ::oDbfFacPrvTFac:End()
   else 
      ::oDbfFacPrvTFac := nil
   end if 

   if !Empty( ::oDbfFacPrvLGst )
      ::oDbfFacPrvLGst:End()
   else
      ::oDbfFacPrvLGst := nil 
   end if 

   if !Empty( ::odbfFacPrvPGst )
      ::oDbfFacPrvPGst:End()
   else
      ::oDbfFacPrvPGst := nil 
   end if 

RETURN .T.

// ----------------------------------------------------------------------------- //
/*Constructor para el método*/

METHOD New()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*Funcion que llama a la clase*/

FUNCTION ImpFacCom( oMenuItem, oWnd )

   local oImpFacCom
   local nLevel   := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return ( nil )
   end if

   oImpFacCom     := TImpFacCom():New():Resource()

RETURN nil
//---------------------------------------------------------------------------//