/*
Importación de datos de factuplus clientes, y artículos.
*/

#include "FiveWin.Ch"
#include "Factu.ch"
#include "MesDbf.ch"

CLASS TImpFactu

   DATA oDlg

   DATA aLgcIndices
   DATA aChkIndices
   DATA aMtrIndices
   DATA aNumIndices

   DATA oDbfArtGst
   DATA oDbfArtFac
   DATA oDbfArCFac
   DATA oDbfCliGst
   DATA oDbfCliFac
   DATA oDbfGrpCliGst
   DATA oDbfGrpCliFac
   DATA oDbfPrvGst
   DATA oDbfPrvFac
   DATA oDbfFamGst
   DATA oDbfFamFac
   DATA oDbfGrpGst
   DATA oDbfGrpFac
   DATA oDbfIvaGst
   DATA oDbfIvaFac
   DATA oDbfFpgGst
   DATA oDbfFpgFac
   DATA oDbfFacIGst
   DATA oDbfFacCFac
   DATA oDbfRemGst
   DATA oDbfRemFac
   DATA oDbfCtaRemGst
   DATA oDbfCtaRemFac
   DATA oDbfPreTGst
   DATA oDbfPreTFac
   DATA oDbfPreLGst
   DATA oDbfPreLFac
   DATA oDbfPedTGst
   DATA oDbfPedTFac
   DATA oDbfPedLGst
   DATA oDbfPedLFac
   DATA oDbfAlbTGst
   DATA oDbfAlbTFac
   DATA oDbfAlbLGst
   DATA oDbfAlbLFac
   DATA oDbfFacTGst
   DATA oDbfFacTFac
   DATA oDbfFacLGst
   DATA oDbfFacLFac
   DATA oDbfFacRecTGst
   DATA oDbfFacRecLGst
   DATA oDbfFacPGst
   DATA oDbfFacDFac
   DATA oDbfProvFac
   DATA oDbfTikTGst
   DATA oDbfTikLGst
   DATA oDbfTikTFac
   DATA oDbfTikLFac
   DATA oDbfHisTFac
   DATA oDbfHisLFac
   DATA oDbfFapIGst
   DATA oDbfFapCFac
   DATA oDbfTrnFac
   DATA oDbfTrnGst
   DATA oDbfObrGst
   DATA oDbfObrFac
   DATA oDbfAgeGst
   DATA oDbfAgeFac
   DATA oDbfAlmGst
   DATA oDbfAlmFac
   DATA oDbfTikPGst
   DATA oDbfRecFac
   DATA oDbfMovTGst
   DATA oDbfMovTFac
   DATA oDbfMovLGst
   DATA oDbfMovLFac
   DATA oDbfAtpGst
   DATA oDbfAtpFac
   DATA oDbfPepTGst
   DATA oDbfPepTFac
   DATA oDbfPepLGst
   DATA oDbfPepLFac
   DATA oDbfAlpTGst
   DATA oDbfAlpTFac
   DATA oDbfAlpLGst
   DATA oDbfAlpLFac
   DATA oDbfFapTGst
   DATA oDbfFapTFac
   DATA oDbfFapLGst
   DATA oDbfFapLFac
   DATA oDbfFapPGst
   DATA oDbfFapPFac
   DATA oDbfCliCom
   DATA oDbfCnt
   DATA oDbfDiv
   DATA cPathFac
   DATA cPathMov      INIT "C:\ARCHIV~1\AZUDSO~1\UTILID~1\Datos\TBLS04\"

   METHOD New()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource()

   METHOD Importar()

   METHOD SelectChk( lSet )

END CLASS

//---------------------------------------------------------------------------//

/*
Abrimos los ficheros
*/

METHOD OpenFiles()

   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   if Empty( ::cPathFac )
      MsgStop( "Ruta de factuplus ® esta vacia" )
      return .f.
   end if

   if Right( ::cPathFac, 1 ) != "\"
      ::cPathFac  += "\"
   end if

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfCnt PATH ( cPatEmp() ) FILE "nCount.Dbf"    VIA ( cDriver() )CLASS "Count"    SHARED INDEX "nCount.Cdx"

   if !File( ::cPathFac + "Articulo.dbf" ) .or. !File( ::cPathFac + "Artcom.dbf" )
      ::aChkIndices[ 1 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de articulos", ::cPathFac + "ARTICULO.DBF" )
   else
      DATABASE NEW ::oDbfArtGst PATH ( cPatArt() )  FILE "ARTICULO.DBF" VIA ( cDriver() )CLASS "ARTGST" SHARED INDEX "ARTICULO.CDX"
      DATABASE NEW ::oDbfArtFac PATH ( ::cPathFac ) FILE "ARTICULO.DBF" VIA ( cDriver() )CLASS "ARTFAC"
      DATABASE NEW ::oDbfArcFac PATH ( ::cPathFac ) FILE "ARTCOM.DBF"   VIA ( cDriver() )CLASS "ARTCOM"
   end if

   if !File( ::cPathFac + "FAMILIAS.DBF" )
      ::aChkIndices[ 2 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de familias", ::cPathFac + "FAMILIAS.DBF" )
   else
      DATABASE NEW ::oDbfFamGst PATH ( cPatArt() )  FILE "FAMILIAS.DBF" VIA ( cDriver() )CLASS "FAMGST" SHARED INDEX "FAMILIAS.CDX"
      DATABASE NEW ::oDbfFamFac PATH ( ::cPathFac ) FILE "FAMILIAS.DBF" VIA ( cDriver() )CLASS "FAMFAC"
   end if

   if !File( ::cPathFac + "GRP_VENT.DBF" )
      ::aChkIndices[ 3 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de grupos de ventas", ::cPathFac + "GRP_VENT.DBF" )
   else
      DATABASE NEW ::oDbfGrpGst PATH ( cPatEmp() )  FILE "GRPVENT.DBF"  VIA ( cDriver() )CLASS "GRPGST" SHARED INDEX "GRPVENT.CDX"
      DATABASE NEW ::oDbfGrpFac PATH ( ::cPathFac ) FILE "GRP_VENT.DBF" VIA ( cDriver() )CLASS "GRPFAC"
   end if

   if !File( ::cPathFac + "IVAS.DBF" )
      ::aChkIndices[ 4 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de tipos de " + cImp(), ::cPathFac + "IVAS.DBF" )
   else
      DATABASE NEW ::oDbfIvaGst PATH ( cPatDat() )  FILE "TIVA.DBF"     VIA ( cDriver() )CLASS "IVAGST" SHARED INDEX "TIVA.CDX"
      DATABASE NEW ::oDbfIvaFac PATH ( ::cPathFac ) FILE "IVAS.DBF"     VIA ( cDriver() )CLASS "IVAFAC"
   end if

   if !File( ::cPathFac + "GRUPCLI.DBF" )
      ::aChkIndices[ 18 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de grupos de clientes", ::cPathFac + "GRUPCLI.DBF" )
   else
      DATABASE NEW ::oDbfGrpCliGst PATH ( cPatCli() )  FILE "GRPCLI.DBF"   VIA ( cDriver() )CLASS "GRPCLIGST"  SHARED INDEX "GRPCLI.CDX"
      DATABASE NEW ::oDbfGrpCliFac PATH ( ::cPathFac ) FILE "GRUPCLI.DBF"  VIA ( cDriver() )CLASS "GRPCLIFAC"
   end if

   if !File( ::cPathFac + "CLIENTES.DBF" ) .or. !File( ::cPathFac + "DIRCLI.DBF" ) .or. !File( ::cPathFac + "PROVINC.DBF" ) .or. !File( ::cPathFac + "ATIPICAS.DBF" )
      ::aChkIndices[ 5 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de clientes ni direcciones", ::cPathFac + "CLIENTES.DBF" + ::cPathFac + "DIRCLI.DBF" )
   else
      DATABASE NEW ::oDbfCliGst PATH ( cPatCli() )  FILE "CLIENT.DBF"   VIA ( cDriver() )CLASS "CLIGST"  SHARED INDEX "CLIENT.CDX"
      DATABASE NEW ::oDbfObrGst PATH ( cPatCli() )  FILE "OBRAST.DBF"   VIA ( cDriver() )CLASS "OBRGST"  SHARED INDEX "OBRAST.CDX"
      DATABASE NEW ::oDbfAtpGst PATH ( cPatCli() )  FILE "CLIATP.DBF"   VIA ( cDriver() )CLASS "ATPGST"  SHARED INDEX "CLIATP.CDX"
      DATABASE NEW ::oDbfCliFac PATH ( ::cPathFac ) FILE "CLIENTES.DBF" VIA ( cDriver() )CLASS "CLIFAC"
      DATABASE NEW ::oDbfObrFac PATH ( ::cPathFac ) FILE "DIRCLI.DBF"   VIA ( cDriver() )CLASS "OBRFAC"
      DATABASE NEW ::oDbfAtpFac PATH ( ::cPathFac ) FILE "ATIPICAS.DBF" VIA ( cDriver() )CLASS "ATPFAC"
      DATABASE NEW ::oDbfProvFac PATH ( ::cPathFac ) FILE "PROVINC.DBF"  VIA ( cDriver() )CLASS "PROVFAC" SHARED INDEX "PROVINC.CDX"
      DATABASE NEW ::oDbfCliCom PATH ( ::cPathFac ) FILE "ClienteC.Dbf" VIA ( cDriver() )CLASS "ClienteC" SHARED INDEX "ClienteC.Cdx"
   end if

   if !File( ::cPathFac + "FPAGO.DBF" )
      ::aChkIndices[ 6 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de formas de pago", ::cPathFac + "FPAGO.DBF" )
   else
      DATABASE NEW ::oDbfFpgGst PATH ( cPatGrp() )  FILE "FPAGO.DBF"    VIA ( cDriver() )CLASS "FPGGST" SHARED INDEX "FPAGO.CDX"
      DATABASE NEW ::oDbfFpgFac PATH ( ::cPathFac ) FILE "FPAGO.DBF"    VIA ( cDriver() )CLASS "FPGFAC"
   end if

   if !File( ::cPathFac + "REMESAS.DBF" ) .or. !File( ::cPathFac + "CTA_REM.DBF" )
      ::aChkIndices[ 19 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de remesas" )
   else
      DATABASE NEW ::oDbfRemGst     PATH ( cPatEmp() )  FILE "REMCLIT.DBF"    VIA ( cDriver() )CLASS "REMGST"     SHARED INDEX "REMCLIT.CDX"
      DATABASE NEW ::oDbfRemFac     PATH ( ::cPathFac ) FILE "REMESAS.DBF"    VIA ( cDriver() )CLASS "REMFAC"
      DATABASE NEW ::oDbfCtaRemGst  PATH ( cPatEmp() )  FILE "CTAREM.DBF"     VIA ( cDriver() )CLASS "CTAREMGST"  SHARED INDEX "CTAREM.CDX"
      DATABASE NEW ::oDbfCtaRemFac  PATH ( ::cPathFac ) FILE "CTA_REM.DBF"    VIA ( cDriver() )CLASS "CTAREMFAC"
   end if

   if !File( ::cPathFac + "PROVEEDO.DBF" )
      ::aChkIndices[ 7 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de proveedores", ::cPathFac + "PROVEEDO.DBF" )
   else
      DATABASE NEW ::oDbfPrvGst PATH ( cPatPrv() )  FILE "PROVEE.DBF"   VIA ( cDriver() )CLASS "PRVGST" SHARED INDEX "PROVEE.CDX"
      DATABASE NEW ::oDbfPrvFac PATH ( ::cPathFac ) FILE "PROVEEDO.DBF" VIA ( cDriver() )CLASS "PRVFAC"
   end if

   if !File( ::cPathFac + "AGENTES.DBF" )
      ::aChkIndices[ 11 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de agentes", ::cPathFac + "AGENTES.DBF" )
   else
      DATABASE NEW ::oDbfAgeGst PATH ( cPatCli() )    FILE "AGENTES.DBF"   VIA ( cDriver() )CLASS "AGEGST" SHARED INDEX "AGENTES.CDX"
      DATABASE NEW ::oDbfAgeFac PATH ( ::cPathFac ) FILE "AGENTES.DBF"   VIA ( cDriver() )CLASS "AGEFAC"
   end if

   if !File( ::cPathFac + "ALMACEN.DBF" )
      ::aChkIndices[ 12 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de almacenes", ::cPathFac + "ALMACEN.DBF" )
   else
      DATABASE NEW ::oDbfAlmGst PATH ( cPatAlm() )    FILE "ALMACEN.DBF"   VIA ( cDriver() )CLASS "ALMGST" SHARED INDEX "ALMACEN.CDX"
      DATABASE NEW ::oDbfAlmFac PATH ( ::cPathFac ) FILE "ALMACEN.DBF"   VIA ( cDriver() )CLASS "ALMFAC"
   end if

   if !File( ::cPathFac + "PRECLIT.DBF" ) .or.  !File( ::cPathFac + "PRECLIL.DBF" )
      ::aChkIndices[ 20 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de presupuestos", ::cPathFac + "PRECLIT.DBF, ni " + ::cPathFac + "PRECLIL.DBF" )
   else
      DATABASE NEW ::oDbfPreTGst PATH ( cPatEmp() )  FILE "PRECLIT.DBF"   VIA ( cDriver() )CLASS "PRETGST"  SHARED INDEX "PRECLIT.CDX"
      DATABASE NEW ::oDbfPreTFac PATH ( ::cPathFac ) FILE "PRECLIT.DBF"   VIA ( cDriver() )CLASS "PRETFAC"
      DATABASE NEW ::oDbfPreLGst PATH ( cPatEmp() )  FILE "PRECLIL.DBF"   VIA ( cDriver() )CLASS "PRELGST"  SHARED INDEX "PRECLIL.CDX"
      DATABASE NEW ::oDbfPreLFac PATH ( ::cPathFac ) FILE "PRECLIL.DBF"   VIA ( cDriver() )CLASS "PRELFAC"
   end if   

   if !File( ::cPathFac + "PEDCLIT.DBF" ) .or.  !File( ::cPathFac + "PEDCLIL.DBF" )
      ::aChkIndices[ 21 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de pedidos", ::cPathFac + "PEDCLIT.DBF, ni " + ::cPathFac + "PEDCLIL.DBF" )
   else
      DATABASE NEW ::oDbfPedTGst PATH ( cPatEmp() )  FILE "PEDCLIT.DBF"   VIA ( cDriver() )CLASS "PEDTGST"  SHARED INDEX "PEDCLIT.CDX"
      DATABASE NEW ::oDbfPedTFac PATH ( ::cPathFac ) FILE "PEDCLIT.DBF"   VIA ( cDriver() )CLASS "PEDTFAC"
      DATABASE NEW ::oDbfPedLGst PATH ( cPatEmp() )  FILE "PEDCLIL.DBF"   VIA ( cDriver() )CLASS "PEDLGST"  SHARED INDEX "PEDCLIL.CDX"
      DATABASE NEW ::oDbfPedLFac PATH ( ::cPathFac ) FILE "PEDCLIL.DBF"   VIA ( cDriver() )CLASS "PEDLFAC"
   end if   

   if !File( ::cPathFac + "ALBCLIT.DBF" ) .or.  !File( ::cPathFac + "ALBCLIL.DBF" )
      ::aChkIndices[ 8 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de Albaranes", ::cPathFac + "ALBCLIT.DBF, ni " + ::cPathFac + "ALBCLIL.DBF" )
   else
      DATABASE NEW ::oDbfAlbTGst PATH ( cPatEmp() )  FILE "ALBCLIT.DBF"   VIA ( cDriver() )CLASS "ALBTGST"  SHARED INDEX "ALBCLIT.CDX"
      DATABASE NEW ::oDbfAlbTFac PATH ( ::cPathFac ) FILE "ALBCLIT.DBF"   VIA ( cDriver() )CLASS "ALBTFAC"
      DATABASE NEW ::oDbfAlbLGst PATH ( cPatEmp() )  FILE "ALBCLIL.DBF"   VIA ( cDriver() )CLASS "ALBLGST"  SHARED INDEX "ALBCLIL.CDX"
      DATABASE NEW ::oDbfAlbLFac PATH ( ::cPathFac ) FILE "ALBCLIL.DBF"   VIA ( cDriver() )CLASS "ALBLFAC"
   end if

   if !File( ::cPathFac + "FACCLIT.DBF" ) .or.  !File( ::cPathFac + "FACCLIL.DBF" ) .or. !File( ::cPathFac + "RECIBOS.DBF" ) .or. !File( ::cPathFac + "FACCLID.DBF" )
      ::aChkIndices[ 9 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de Facturas", ::cPathFac + "FACCLIT.DBF, ni " + ::cPathFac + "FACCLIL.DBF" )
   else
      DATABASE NEW ::oDbfFacTGst    PATH ( cPatEmp() )   FILE "FACCLIT.DBF"   VIA ( cDriver() )CLASS "FACTGST" SHARED INDEX "FACCLIT.CDX"
      DATABASE NEW ::oDbfFacTFac    PATH ( ::cPathFac )  FILE "FACCLIT.DBF"   VIA ( cDriver() )CLASS "FACTFAC"
      DATABASE NEW ::oDbfFacLGst    PATH ( cPatEmp() )   FILE "FACCLIL.DBF"   VIA ( cDriver() )CLASS "FACLGST" SHARED INDEX "FACCLIL.CDX"
      DATABASE NEW ::oDbfFacLFac    PATH ( ::cPathFac )  FILE "FACCLIL.DBF"   VIA ( cDriver() )CLASS "FACLFAC"
      DATABASE NEW ::oDbfFacPGst    PATH ( cPatEmp() )   FILE "FACCLIP.DBF"   VIA ( cDriver() )CLASS "FACPGST" SHARED INDEX "FACCLIP.CDX"
      DATABASE NEW ::oDbfRecFac     PATH ( ::cPathFac )  FILE "RECIBOS.DBF"   VIA ( cDriver() )CLASS "RECFAC"
      DATABASE NEW ::oDbfFacDFac    PATH ( ::cPathFac )  FILE "FACCLID.DBF"   VIA ( cDriver() )CLASS "FACDFAC" SHARED INDEX "FACCLID.CDX"
      DATABASE NEW ::oDbfFacRecTGst PATH ( cPatEmp() )   FILE "FACRECT.DBF"   VIA ( cDriver() )CLASS "FACRECT" SHARED INDEX "FACRECT.CDX"
      DATABASE NEW ::oDbfFacRecLGst PATH ( cPatEmp() )   FILE "FACRECL.DBF"   VIA ( cDriver() )CLASS "FACRECL" SHARED INDEX "FACRECL.CDX"
      DATABASE NEW ::oDbfFacIGst    PATH ( cPatEmp() )   FILE "FACCLII.DBF"   VIA ( cDriver() )CLASS "INCGST"  SHARED INDEX "FACCLII.CDX"
      DATABASE NEW ::oDbfFacCFac    PATH ( ::cPathFac )  FILE "FACCLIC.DBF"   VIA ( cDriver() )CLASS "INCFAC" 
   end if

   if !File( ::cPathFac + "TICKETT.DBF" ) .or.  !File( ::cPathFac + "TICKETL.DBF" )
      ::aChkIndices[ 10 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de Tikets", ::cPathFac + "TICKETT.DBF, ni " + ::cPathFac + "TICKETL.DBF" )
   else
      DATABASE NEW ::oDbfTikTGst PATH ( cPatEmp() )  FILE "TIKET.DBF"     VIA ( cDriver() )CLASS "TIKTGST"  SHARED INDEX "TIKET.CDX"
      DATABASE NEW ::oDbfTikTFac PATH ( ::cPathFac ) FILE "TICKETT.DBF"   VIA ( cDriver() )CLASS "TIKTFAC"
      DATABASE NEW ::oDbfHisTFac PATH ( ::cPathFac ) FILE "HTICKETT.DBF"  VIA ( cDriver() )CLASS "HTIKTFAC"
      DATABASE NEW ::oDbfTikLGst PATH ( cPatEmp() )  FILE "TIKEL.DBF"     VIA ( cDriver() )CLASS "TIKLGST"  SHARED INDEX "TIKEL.CDX"
      DATABASE NEW ::oDbfTikLFac PATH ( ::cPathFac ) FILE "TICKETL.DBF"   VIA ( cDriver() )CLASS "TIKLFAC"
      DATABASE NEW ::oDbfHisLFac PATH ( ::cPathFac ) FILE "HTICKETL.DBF"  VIA ( cDriver() )CLASS "HTIKLFAC"
      DATABASE NEW ::oDbfTikPGst PATH ( cPatEmp() )  FILE "TIKEP.DBF"     VIA ( cDriver() )CLASS "TIKPGST"  SHARED INDEX "TIKEP.CDX"
   end if

   if !File( ::cPathMov + "TRASALMC.DBF" )
      ::aChkIndices[ 13 ]:Click( .f. ):Refresh()
   else
      DATABASE NEW ::oDbfMovTGst PATH ( cPatEmp() )  FILE "REMMOVT.DBF"   VIA ( cDriver() )CLASS "MOVTGST"  SHARED INDEX "REMMOVT.CDX"
      DATABASE NEW ::oDbfMovTFac PATH ( ::cPathMov ) FILE "TRASALMC.DBF"  VIA ( cDriver() )CLASS "MOVTFAC"
   end if

   if !File( ::cPathMov + "TRASALML.DBF" )
      ::aChkIndices[ 13 ]:Click( .f. ):Refresh()
   else
      DATABASE NEW ::oDbfMovLGst PATH ( cPatEmp() )  FILE "HISMOV.DBF"    VIA ( cDriver() )CLASS "MOVLGST"  SHARED INDEX "HISMOV.CDX"
      DATABASE NEW ::oDbfMovLFac PATH ( ::cPathMov ) FILE "TRASALML.DBF"  VIA ( cDriver() )CLASS "MOVLFAC"
   end if

   if !File( ::cPathFac + "Transpor.Dbf" )
      ::aChkIndices[ 14 ]:Click( .f. ):Refresh()
      msgStop( "No existe fichero de transportistas", ::cPathFac + "Transpor.Dbf" )
   else
      DATABASE NEW ::oDbfTrnGst PATH ( cPatGrp() )  FILE "Transpor.Dbf"    VIA ( cDriver() )CLASS "TRNGST"  SHARED INDEX "Transpor.Cdx"
      DATABASE NEW ::oDbfTrnFac PATH ( ::cPathFac ) FILE "Transpor.Dbf"    VIA ( cDriver() )CLASS "TRNFAC"
   end if

   

   if !File( ::cPathFac + "PEDPROT.DBF" ) .or.  !File( ::cPathFac + "PEDPROL.DBF" )
      ::aChkIndices[ 22 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de pedidos de proveedor", ::cPathFac + "PEDPROT.DBF, ni " + ::cPathFac + "PEDPROL.DBF" )
   else
      DATABASE NEW ::oDbfPepTGst PATH ( cPatEmp() )  FILE "PEDPROVT.DBF"  VIA ( cDriver() )CLASS "PEPTGST"  SHARED INDEX "PEDPROVT.CDX"
      DATABASE NEW ::oDbfPepTFac PATH ( ::cPathFac ) FILE "PEDPROT.DBF"   VIA ( cDriver() )CLASS "PEPTFAC"
      DATABASE NEW ::oDbfPepLGst PATH ( cPatEmp() )  FILE "PEDPROVL.DBF"  VIA ( cDriver() )CLASS "PEPLGST"  SHARED INDEX "PEDPROVL.CDX"
      DATABASE NEW ::oDbfPepLFac PATH ( ::cPathFac ) FILE "PEDPROL.DBF"   VIA ( cDriver() )CLASS "PEPLFAC"
   end if

   if !File( ::cPathFac + "ALBPROT.DBF" ) .or.  !File( ::cPathFac + "ALBPROL.DBF" )
      ::aChkIndices[ 15 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de Albaranes de proveedor", ::cPathFac + "ALBPROT.DBF, ni " + ::cPathFac + "ALBPROL.DBF" )
   else
      DATABASE NEW ::oDbfAlpTGst PATH ( cPatEmp() )  FILE "ALBPROVT.DBF"  VIA ( cDriver() )CLASS "ALPTGST"  SHARED INDEX "ALBPROVT.CDX"
      DATABASE NEW ::oDbfAlpTFac PATH ( ::cPathFac ) FILE "ALBPROT.DBF"   VIA ( cDriver() )CLASS "ALPTFAC"
      DATABASE NEW ::oDbfAlpLGst PATH ( cPatEmp() )  FILE "ALBPROVL.DBF"  VIA ( cDriver() )CLASS "ALPLGST"  SHARED INDEX "ALBPROVL.CDX"
      DATABASE NEW ::oDbfAlpLFac PATH ( ::cPathFac ) FILE "ALBPROL.DBF"   VIA ( cDriver() )CLASS "ALPLFAC"
   end if

   if !File( ::cPathFac + "FACPROT.DBF" ) .or.  !File( ::cPathFac + "FACPROL.DBF" ) .or.  !File( ::cPathFac + "RECIBOSP.DBF" )
      ::aChkIndices[ 16 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de Facturas de proveedor", ::cPathFac + "FACPROT.DBF, ni " + ::cPathFac + "FACPROL.DBF" )
   else
      DATABASE NEW ::oDbfFapTGst PATH ( cPatEmp() )  FILE "FACPRVT.DBF"  VIA ( cDriver() )CLASS "FAPTGST"  SHARED INDEX "FACPRVT.CDX"
      DATABASE NEW ::oDbfFapTFac PATH ( ::cPathFac ) FILE "FACPROT.DBF"  VIA ( cDriver() )CLASS "FAPTFAC"
      DATABASE NEW ::oDbfFapLGst PATH ( cPatEmp() )  FILE "FACPRVL.DBF"  VIA ( cDriver() )CLASS "FAPLGST"  SHARED INDEX "FACPRVL.CDX"
      DATABASE NEW ::oDbfFapLFac PATH ( ::cPathFac ) FILE "FACPROL.DBF"  VIA ( cDriver() )CLASS "FAPLFAC"
      DATABASE NEW ::oDbfFapPGst PATH ( cPatEmp() )  FILE "FACPRVP.DBF"  VIA ( cDriver() )CLASS "FAPPGST"  SHARED INDEX "FACPRVP.CDX"
      DATABASE NEW ::oDbfFapPFac PATH ( ::cPathFac ) FILE "RECIBOSP.DBF" VIA ( cDriver() )CLASS "FAPPFAC"
      DATABASE NEW ::oDbfFapIGst PATH ( cPatEmp() )  FILE "FACPRVI.DBF"   VIA ( cDriver() )CLASS "INCGSTP" SHARED INDEX "FACPRVI.CDX"
      DATABASE NEW ::oDbfFapCFac PATH ( ::cPathFac ) FILE "FACPROC.DBF"   VIA ( cDriver() )CLASS "INCFACP"  

   end if

   DATABASE NEW ::oDbfDiv PATH ( cPatDat() )  FILE "DIVISAS.DBF"  VIA ( cDriver() )CLASS "DIVISAS"  SHARED INDEX "DIVISAS.CDX"

   if !File( ::cPathFac + "FACCLIT.DBF" ) .or.  !File( ::cPathFac + "FACCLIL.DBF" ) .or. !File( ::cPathFac + "RECIBOS.DBF" ) .or. !File( ::cPathFac + "FACCLID.DBF" )
      ::aChkIndices[ 17 ]:Click( .f. ):Refresh()
      msgStop( "No existen ficheros de facturas de clientes", ::cPathFac + "FACCLIT.DBF, ni " + ::cPathFac + "FACCLIL.DBF" )
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

// ----------------------------------------------------------------------------- //

/*
Cerramos ficheros
*/

METHOD CloseFiles()

   if !Empty( ::oDbfCnt )
      ::oDbfCnt:End()
   else
      ::oDbfCnt      := nil
   end if

   if !Empty( ::oDbfArtGst )
      ::oDbfArtGst:End()
   else
      ::oDbfArtGst   := nil
   end if

   if !Empty( ::oDbfArtFac )
      ::oDbfArtFac:End()
   else
      ::oDbfArtFac := nil
   end if

   if !Empty( ::oDbfArCFac )
      ::oDbfArCFac:End()
   else
      ::oDbfArCFac := nil
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

   if !Empty( ::oDbfGrpCliGst )
      ::oDbfGrpCliGst:End()
   else
      ::oDbfGrpCliGst := nil
   end if

   if !Empty( ::oDbfGrpCliFac )
      ::oDbfGrpCliFac:End()
   else
      ::oDbfGrpCliFac := nil
   end if

   if !Empty( ::oDbfCliCom )
      ::oDbfCliCom:End()
   else
      ::oDbfCliCom := nil
   end if

   if !Empty( ::oDbfFamGst )
      ::oDbfFamGst:End()
   else
      ::oDbfFamGst := nil
   end if

   if !Empty( ::oDbfFamFac )
      ::oDbfFamFac:End()
   else
      ::oDbfFamFac := nil
   end if

   if !Empty( ::oDbfGrpGst )
      ::oDbfGrpGst:End()
   else
      ::oDbfGrpGst := nil
   end if

   if !Empty( ::oDbfGrpFac )
      ::oDbfGrpFac:End()
   else
      ::oDbfGrpFac := nil
   end if

   if !Empty( ::oDbfIvaGst )
      ::oDbfIvaGst:End()
   else
      ::oDbfIvaGst := nil
   end if

   if !Empty( ::oDbfIvaFac )
      ::oDbfIvaFac:End()
   else
      ::oDbfIvaFac := nil
   end if

   if !Empty( ::oDbfFpgGst )
      ::oDbfFpgGst:End()
   else
      ::oDbfFpgGst := nil
   end if

   if !Empty( ::oDbfFpgFac )
      ::oDbfFpgFac:End()
   else
      ::oDbfFpgFac := nil
   end if

   if !Empty( ::oDbfRemGst )
      ::oDbfRemGst:End()
   else
      ::oDbfRemGst := nil
   end if

   if !Empty( ::oDbfRemFac )
      ::oDbfRemFac:End()
   else
      ::oDbfRemFac := nil
   end if

   if !Empty( ::oDbfCtaRemGst )
      ::oDbfCtaRemGst:End()
   else
      ::oDbfCtaRemGst := nil
   end if

   if !Empty( ::oDbfCtaRemFac )
      ::oDbfCtaRemFac:End()
   else
      ::oDbfCtaRemFac := nil
   end if

   if !Empty( ::oDbfPrvGst )
      ::oDbfPrvGst:End()
   else
      ::oDbfPrvGst := nil
   end if

   if !Empty( ::oDbfProvFac )
      ::oDbfProvFac:End()
   else
      ::oDbfProvFac := nil
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

   if !Empty( ::oDbfFacTFac )
      ::oDbfFacTFac:End()
   else
      ::oDbfFacTFac := nil
   end if

   if !Empty( ::oDbfFacLGst )
      ::oDbfFacLGst:End()
   else
      ::oDbfFacLGst := nil
   end if

   if !Empty( ::oDbfFacLFac )
      ::oDbfFacLFac:End()
   else
      ::oDbfFacLFac := nil
   end if

   if !Empty( ::oDbfFacRecTGst )
      ::oDbfFacRecTGst:End()
   else
      ::oDbfFacRecTGst := nil
   end if

   if !Empty( ::oDbfFacRecLGst )
      ::oDbfFacRecLGst:End()
   else
      ::oDbfFacRecLGst := nil
   end if

   if !Empty( ::oDbfFacPGst )
      ::oDbfFacPGst:End()
   else
      ::oDbfFacPGst := nil
   end if

   if !Empty( ::oDbfPrvFac )
      ::oDbfPrvFac:End()
   else
      ::oDbfPrvFac := nil
   end if

   if !Empty( ::oDbfRecFac )
      ::oDbfRecFac:End()
   else
      ::oDbfRecFac := nil
   end if

   if !Empty( ::oDbfFacDFac )
      ::oDbfFacDFac:End()
   else
      ::oDbfFacDFac := nil
   end if

   if !Empty( ::oDbfTikTGst )
      ::oDbfTikTGst:End()
   else
      ::oDbfTikTGst := nil
   end if

   if !Empty( ::oDbfTikTFac )
      ::oDbfTikTFac:End()
   end if

   ::oDbfTikTFac  := nil

   if !Empty( ::oDbfHisTFac )
      ::oDbfHisTFac:End()
   end if

   ::oDbfHisTFac  := nil

   if !Empty( ::oDbfTikLGst )
      ::oDbfTikLGst:End()
   else
      ::oDbfTikLGst := nil
   end if

   if !Empty( ::oDbfTikLFac )
      ::oDbfTikLFac:End()
   else
      ::oDbfTikLFac := nil
   end if

   if !Empty( ::oDbfHisLFac )
      ::oDbfHisLFac:End()
   end if

   ::oDbfHisLFac  := nil

   if !Empty( ::oDbfTikPGst )
      ::oDbfTikPGst:End()
   else
      ::oDbfTikPGst := nil
   end if

   if !Empty( ::oDbfObrGst )
      ::oDbfObrGst:End()
   else
      ::oDbfObrGst := nil
   end if

   if !Empty( ::oDbfObrFac )
      ::oDbfObrFac:End()
   else
      ::oDbfObrFac := nil
   end if

   if !Empty( ::oDbfAgeGst )
      ::oDbfAgeGst:End()
   else
      ::oDbfAgeGst := nil
   end if

   if !Empty( ::oDbfAgeFac )
      ::oDbfAgeFac:End()
   else
      ::oDbfAgeFac := nil
   end if

   if !Empty( ::oDbfAlmGst )
      ::oDbfAlmGst:End()
   else
      ::oDbfAlmGst := nil
   end if

   if !Empty( ::oDbfAlmFac )
      ::oDbfAlmFac:End()
   else
      ::oDbfAlmFac := nil
   end if

   if !Empty( ::oDbfMovTGst )
      ::oDbfMovTGst:End()
   else
      ::oDbfMovTGst := nil
   end if

   if !Empty( ::oDbfMovTFac )
      ::oDbfMovTFac:End()
   else
      ::oDbfMovTFac := nil
   end if

   if !Empty( ::oDbfMovLGst )
      ::oDbfMovLGst:End()
   else
      ::oDbfMovLGst := nil
   end if

   if !Empty( ::oDbfMovLFac )
      ::oDbfMovLFac:End()
   else
      ::oDbfMovLFac := nil
   end if

   if !Empty( ::oDbfAtpGst )
      ::oDbfAtpGst:End()
   else
      ::oDbfAtpGst := nil
   end if

   if !Empty( ::oDbfAtpFac )
      ::oDbfAtpFac:End()
   else
      ::oDbfAtpFac   := nil
   end if

   if !Empty( ::oDbfTrnGst )
      ::oDbfTrnGst:End()
   else
      ::oDbfTrnGst   := nil
   end if

   if !Empty( ::oDbfTrnFac )
      ::oDbfTrnFac:End()
   else
      ::oDbfTrnFac   := nil
   end if

   if !Empty( ::oDbfAlpTGst )
      ::oDbfAlpTGst:End()
   else
      ::oDbfAlpTGst := nil
   end if

   if !Empty( ::oDbfAlpTFac )
      ::oDbfAlpTFac:End()
   else
      ::oDbfAlpTFac := nil
   end if

   if !Empty( ::oDbfAlpLGst )
      ::oDbfAlpLGst:End()
   else
      ::oDbfAlpLGst := nil
   end if

   if !Empty( ::oDbfAlpLFac )
      ::oDbfAlpLFac:End()
   else
      ::oDbfAlpLFac := nil
   end if

   if !Empty( ::oDbfFapTGst )
      ::oDbfFapTGst:End()
   else
      ::oDbfFapTGst := nil
   end if

   if !Empty( ::oDbfFapTFac )
      ::oDbfFapTFac:End()
   else
      ::oDbfFapTFac := nil
   end if

   if !Empty( ::oDbfFapLGst )
      ::oDbfFapLGst:End()
   else
      ::oDbfFapLGst := nil
   end if

   if !Empty( ::oDbfFapLFac )
      ::oDbfFapLFac:End()
   else
      ::oDbfFapLFac := nil
   end if

   if !Empty( ::oDbfFapPGst )
      ::oDbfFapPGst:End()
   else
      ::oDbfFapPGst := nil
   end if

   if !Empty( ::oDbfFapPFac )
      ::oDbfFapPFac:End()
   else
      ::oDbfFapPFac := nil
   end if

   if !Empty( ::oDbfFacCFac )
      ::oDbfFacCFac:End()
   else
      ::oDbfFacCFac := nil
   end if

   if !Empty( ::oDbfFacIGst )
      ::oDbfFacIGst:End()
   else
      ::oDbfFacIGst := nil
   end if

   if !Empty( ::oDbfFapCFac )
      ::oDbfFapCFac:End()
   else
      ::oDbfFapCFac := nil
   end if

   if !Empty( ::oDbfFapIGst )
      ::oDbfFapIGst:End()
   else
      ::oDbfFapIGst := nil
   end if

   if !Empty( ::oDbfPreTGst )
      ::oDbfPreTGst:End()
   else
      ::oDbfPreTGst := nil
   end if

   if !Empty( ::oDbfPreTFac )
      ::oDbfPreTFac:End()
   else
      ::oDbfPreTFac := nil
   end if

   if !Empty( ::oDbfPreLGst )
      ::oDbfPreLGst:End()
   else
      ::oDbfPreLGst := nil
   end if

   if !Empty( ::oDbfPreLFac )
      ::oDbfPreLFac:End()
   else
      ::oDbfPreLFac := nil
   end if

   if !Empty( ::oDbfPedTGst )
      ::oDbfPedTGst:End()
   else
      ::oDbfPedTGst := nil
   end if

   if !Empty( ::oDbfPedTFac )
      ::oDbfPedTFac:End()
   else
      ::oDbfPedTFac := nil
   end if

   if !Empty( ::oDbfPedLGst )
      ::oDbfPedLGst:End()
   else
      ::oDbfPedLGst := nil
   end if

   if !Empty( ::oDbfPedLFac )
      ::oDbfPedLFac:End()
   else
      ::oDbfPedLFac := nil
   end if

   if !Empty( ::oDbfPepTGst )
      ::oDbfPepTGst:End()
   else
      ::oDbfPepTGst := nil
   end if

   if !Empty( ::oDbfPepTFac )
      ::oDbfPepTFac:End()
   else
      ::oDbfPepTFac := nil
   end if

   if !Empty( ::oDbfPepLGst )
      ::oDbfPepLGst:End()
   else
      ::oDbfPepLGst := nil
   end if

   if !Empty( ::oDbfPepLFac )
      ::oDbfPepLFac:End()
   else
      ::oDbfPepLFac := nil
   end if

   if !Empty( ::oDbfDiv )
      ::oDbfDiv:End()
   end if

   ::oDbfDiv         := nil

RETURN .T.

// ----------------------------------------------------------------------------- //

METHOD New()

   ::cPathFac     := Space( 100 )

   ::aLgcIndices  := Afill( Array( 22 ), .t. )
   ::aChkIndices  := Array( 22 )
   ::aMtrIndices  := Array( 22 )
   ::aNumIndices  := Afill( Array( 22 ), 0 )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource()

   local oBmp
   local oGet

   if nUsrInUse() > 1
      msgStop( "Hay más de un usuario conectado a la aplicación", "Atención" )
      return nil
   end if

   if oWnd() != nil
      oWnd():CloseAll()
   end if

   DEFINE DIALOG ::oDlg RESOURCE "IMPFACPLUS" OF oWnd()

      REDEFINE GET oGet VAR ::cPathFac ID 100 BITMAP "FOLDER" ON HELP ( oGet:cText( Padr( cGetDir32( "Seleccione destino" ), 100 ) ) ) OF ::oDlg

      REDEFINE BITMAP oBmp RESOURCE "ImportarFacturaplus" ID 600 OF ::oDlg

      REDEFINE CHECKBOX ::aChkIndices[ 1 ]   VAR ::aLgcIndices[ 1 ]  ID 110 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 2 ]   VAR ::aLgcIndices[ 2 ]  ID 120 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 3 ]   VAR ::aLgcIndices[ 3 ]  ID 130 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 4 ]   VAR ::aLgcIndices[ 4 ]  ID 140 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 5 ]   VAR ::aLgcIndices[ 5 ]  ID 150 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 6 ]   VAR ::aLgcIndices[ 6 ]  ID 160 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 7 ]   VAR ::aLgcIndices[ 7 ]  ID 170 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 8 ]   VAR ::aLgcIndices[ 8 ]  ID 180 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 9 ]   VAR ::aLgcIndices[ 9 ]  ID 190 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 10 ]  VAR ::aLgcIndices[ 10 ] ID 200 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 11 ]  VAR ::aLgcIndices[ 11 ] ID 220 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 12 ]  VAR ::aLgcIndices[ 12 ] ID 210 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 13 ]  VAR ::aLgcIndices[ 13 ] ID 230 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 14 ]  VAR ::aLgcIndices[ 14 ] ID 240 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 15 ]  VAR ::aLgcIndices[ 15 ] ID 250 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 16 ]  VAR ::aLgcIndices[ 16 ] ID 260 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 17 ]  VAR ::aLgcIndices[ 17 ] ID 270 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 18 ]  VAR ::aLgcIndices[ 18 ] ID 280 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 19 ]  VAR ::aLgcIndices[ 19 ] ID 290 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 20 ]  VAR ::aLgcIndices[ 20 ] ID 300 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 21 ]  VAR ::aLgcIndices[ 21 ] ID 310 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 22 ]  VAR ::aLgcIndices[ 22 ] ID 320 OF ::oDlg

      REDEFINE METER ::aMtrIndices[ 1 ]      VAR ::aNumIndices[ 1 ]  ID 111 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 2 ]      VAR ::aNumIndices[ 2 ]  ID 121 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 3 ]      VAR ::aNumIndices[ 3 ]  ID 131 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 4 ]      VAR ::aNumIndices[ 4 ]  ID 141 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 5 ]      VAR ::aNumIndices[ 5 ]  ID 151 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 6 ]      VAR ::aNumIndices[ 6 ]  ID 161 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 7 ]      VAR ::aNumIndices[ 7 ]  ID 171 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 8 ]      VAR ::aNumIndices[ 8 ]  ID 181 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 9 ]      VAR ::aNumIndices[ 9 ]  ID 191 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 10 ]     VAR ::aNumIndices[ 10 ] ID 201 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 11 ]     VAR ::aNumIndices[ 11 ] ID 221 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 12 ]     VAR ::aNumIndices[ 12 ] ID 211 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 13 ]     VAR ::aNumIndices[ 13 ] ID 231 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 14 ]     VAR ::aNumIndices[ 14 ] ID 241 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 15 ]     VAR ::aNumIndices[ 15 ] ID 251 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 16 ]     VAR ::aNumIndices[ 16 ] ID 261 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 17 ]     VAR ::aNumIndices[ 17 ] ID 271 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 18 ]     VAR ::aNumIndices[ 18 ] ID 281 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 19 ]     VAR ::aNumIndices[ 19 ] ID 291 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 20 ]     VAR ::aNumIndices[ 20 ] ID 301 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 21 ]     VAR ::aNumIndices[ 21 ] ID 311 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )
      REDEFINE METER ::aMtrIndices[ 22 ]     VAR ::aNumIndices[ 22 ] ID 321 OF ::oDlg BARCOLOR Rgb( 128,255,0 ) , Rgb( 255,255,255 )

      REDEFINE BUTTON ID 500        OF ::oDlg ACTION ( ::SelectChk( .t. ) )
      REDEFINE BUTTON ID 501        OF ::oDlg ACTION ( ::SelectChk( .f. ) )

      REDEFINE BUTTON ID IDOK       OF ::oDlg ACTION ( ::Importar() )
      REDEFINE BUTTON ID IDCANCEL   OF ::oDlg ACTION ( ::oDlg:end() )
      REDEFINE BUTTON ID 998        OF ::oDlg ACTION ( ChmHelp( "ImportarFactuplus" ) )

   ::oDlg:AddFastKey( VK_F1, {|| ChmHelp( "ImportarFactuplus" ) } )
   ::oDlg:AddFastKey( VK_F5, {|| ::Importar() } )

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Importar()

   local n                    := 0
   local cCodCli              := ""
   local cNotas               := ""
   local nCounter             := 1
   local cControl             := ""
   local aTemporalLineas      := {}
   local oTemporal
   local aLinea
   local aTotFac              := {}
   local aTotAlb              := {}
   local cComentarioArticulo  := ""
   local nRegIva              := 1

   ::cPathFac                 := AllTrim( ::cPathFac )

   if ::OpenFiles()

      ::oDlg:Disable()

      if ::aLgcIndices[ 1 ]

         /*
         Empezamos el trasbase de artculos
         */

         ::aMtrIndices[ 1 ]:SetTotal( ::oDbfArtFac:LastRec() )

         ::oDbfArtFac:GoTop()
         while !( ::oDbfArtFac:eof() )

            while ::oDbfArtGst:Seek( ::oDbfArtFac:cRef )
               ::oDbfArtGst:Delete( .f. )
            end if

            cComentarioArticulo     := ""

            ::oDbfArtGst:Append()

            ::oDbfArtGst:Codigo     := ::oDbfArtFac:cRef
            ::oDbfArtGst:Nombre     := ::oDbfArtFac:cDetalle
            ::oDbfArtGst:pCosto     := ::oDbfArtFac:nCosteProm
            ::oDbfArtGst:Benef1     := ::oDbfArtFac:nBenefPvp
            ::oDbfArtGst:Benef2     := ::oDbfArtFac:nBenefMay
            ::oDbfArtGst:pVenta1    := ::oDbfArtFac:nPvp
            ::oDbfArtGst:pVtaIva1   := ::oDbfArtFac:nPConIva
            ::oDbfArtGst:pVenta3    := ::oDbfArtFac:nPvp - ( ::oDbfArtFac:nPvp * ::oDbfArtFac:nDto1 / 100 )
            ::oDbfArtGst:pVtaIva3   := ::oDbfArtFac:nPConIva - ( ::oDbfArtFac:nPConIva * ::oDbfArtFac:nDto1 / 100 )
            ::oDbfArtGst:pVenta5    := ::oDbfArtFac:nPreMayor
            ::oDbfArtGst:pVtaIva5   := ::oDbfArtFac:nPMConIva
            ::oDbfArtGst:nMinimo    := ::oDbfArtFac:nStockMin
            ::oDbfArtGst:TipoIva    := ::oDbfArtFac:cTipoIva
            ::oDbfArtGst:Familia    := ::oDbfArtFac:cCodFAm
            ::oDbfArtGst:GrpVent    := ::oDbfArtFac:cGrpConta
            ::oDbfArtGst:cOdeBar    := ::oDbfArtFac:cCodeBar
            ::oDbfArtGst:nTipBar    := ::oDbfArtFac:nTipoCode
            ::oDbfArtGst:nLabel     := ::oDbfArtFac:nEtiquetas
            ::oDbfArtGst:nCtlStock  := 1
            ::oDbfArtGst:lSelPre    := ::oDbfArtFac:lSelect
            ::oDbfArtGst:nSelPre    := ::oDbfArtFac:nUnidades
            ::oDbfArtGst:nPesoKg    := ::oDbfArtFac:nTara
            ::oDbfArtGst:cImagen    := ::oDbfArtFac:cImagen
            ::oDbfArtGst:lKitArt    := ::oDbfArtFac:lKit
            ::oDbfArtGst:cPrvHab    := ::oDbfArtFac:cCodPro

            /*
            ----------------------------------------------------------------------
            Metemos los comentarios de los artículos------------------------------
            ----------------------------------------------------------------------
            */

            ::oDbfArCFac:GoTop()

            while !::oDbfArCFac:Eof()

               if ::oDbfArtFac:cRef == ::oDbfArCFac:cRef

                  cComentarioArticulo  += AllTrim( ::oDbfArCFac:cComent )

               end if   

               ::oDbfArCFac:Skip()

            end while

            ::oDbfArtGst:mComEnt    := cComentarioArticulo

            ::oDbfArtGst:Save()

            ::aMtrIndices[ 1 ]:Set( ::oDbfArtFac:Recno() )

            ::oDbfArtFac:Skip()

         end while

      end if

      /*
      Trasbase de familias
      */

      if ::aLgcIndices[ 2 ]

         ::aMtrIndices[ 2 ]:SetTotal( ::oDbfFamFac:LastRec() )

         ::oDbfFamFac:GoTop()
         while !( ::oDbfFamFac:eof() )

            while ::oDbfFamGst:Seek( ::oDbfFamFac:cCodFam )
               ::oDbfFamGst:Delete( .f. )
            end if

            ::oDbfFamGst:Append()

            ::oDbfFamGst:cCodFam    := ::oDbfFamFac:cCodFam
            ::oDbfFamGst:cNomFam    := ::oDbfFamFac:cNomFam
            ::oDbfFamGst:cCodPrp1   := ::oDbfFamFac:cCodProp1
            ::oDbfFamGst:cCodPrp2   := ::oDbfFamFac:cCodProp2

            ::oDbfFamGst:Save()

            ::aMtrIndices[ 2 ]:Set( ::oDbfFamFac:Recno() )

            ::oDbfFamFac:Skip()

         end while

      end if

      /*
      Trasbase de grupos de ventas
      */

      if ::aLgcIndices[ 3 ]

         ::aMtrIndices[ 3 ]:SetTotal( ::oDbfGrpFac:LastRec() )

         ::oDbfGrpFac:GoTop()
         while !( ::oDbfGrpFac:eof() )

            while ::oDbfGrpGst:Seek( ::oDbfGrpFac:cGrpConta )
               ::oDbfGrpGst:Delete( .f. )
            end if

            ::oDbfGrpGst:Append()

            ::oDbfGrpGst:cGrpConta  := ::oDbfGrpFac:cGrpConta
            ::oDbfGrpGst:cGrpNom    := ::oDbfGrpFac:cGrpNom

            ::oDbfGrpGst:Save()

            ::aMtrIndices[ 3 ]:Set( ::oDbfGrpFac:Recno() )

            ::oDbfGrpFac:Skip()

         end while

      end if

      /*
      Trasbase de tipos de IVA-------------------------------------------------
      */

      if ::aLgcIndices[ 4 ]

         ::aMtrIndices[ 4 ]:SetTotal( ::oDbfIvaFac:LastRec() )

         ::oDbfIvaFac:GoTop()
         while !( ::oDbfIvaFac:eof() )

            while ::oDbfIvaGst:Seek( ::oDbfIvaFac:cTipoIva )
               ::oDbfIvaGst:Delete( .f. )
            end while

            ::oDbfIvaGst:Append()

            ::oDbfIvaGst:Tipo       := ::oDbfIvaFac:cTipoIva
            ::oDbfIvaGst:DescIva    := ::oDbfIvaFac:cDetIva
            ::oDbfIvaGst:TpIva      := ::oDbfIvaFac:nPorcIva
            ::oDbfIvaGst:nRecEq     := ::oDbfIvaFac:nPorcReq

            ::oDbfIvaGst:Save()

            ::aMtrIndices[ 4 ]:Set( ::oDbfIvaFac:Recno() )

            ::oDbfIvaFac:Skip()

         end while

      end if

      /*
      Trasbase de grupos clientes----------------------------------------------
      */

      if ::aLgcIndices[ 18 ]

         ::aMtrIndices[ 18 ]:SetTotal( ::oDbfGrpCliFac:LastRec() )

         ::oDbfGrpCliFac:GoTop()
         while !( ::oDbfGrpCliFac:eof() )

            while ::oDbfGrpCliGst:Seek( Padl( AllTrim( ::oDbfGrpCliFac:cCodigo), 4, "0" ) )
               ::oDbfGrpCliGst:Delete( .f. )
            end while

            ::oDbfGrpCliGst:Append()

            ::oDbfGrpCliGst:cCodGrp    := Padl( AllTrim( ::oDbfGrpCliFac:cCodigo ), 4, "0" )
            ::oDbfGrpCliGst:cNomGrp    := ::oDbfGrpCliFac:cDescrip

            ::oDbfGrpCliGst:Save()

            ::aMtrIndices[ 18 ]:Set( ::oDbfGrpCliFac:Recno() )

            ::oDbfGrpCliFac:Skip()

         end while

      end if

      /*
      Trasbase de clientes-----------------------------------------------------
      */

      if ::aLgcIndices[ 5 ]

         ::aMtrIndices[ 5 ]:SetTotal( ::oDbfCliFac:LastRec() )

         ::oDbfCliFac:GoTop()
         while !( ::oDbfCliFac:eof() )

            cCodCli  := SpecialPadr( ::oDbfCliFac:cCodCli, "0", RetNumCodCliEmp() )

            while ::oDbfCliGst:Seek( cCodCli )
               ::oDbfCliGst:Delete( .f. )
            end if

            ::oDbfCliGst:Append()

            cControl               := cDgtControl( ::oDbfCliFac:cEntidad, ::oDbfCliFac:cAgencia, Space( 2 ), ::oDbfCliFac:cCuenta )

            ::oDbfCliGst:Cod       := cCodCli
            ::oDbfCliGst:Titulo    := ::oDbfCliFac:cNomCli
            ::oDbfCliGst:Nif       := ::oDbfCliFac:cDniCif
            ::oDbfCliGst:Domicilio := ::oDbfCliFac:cDirCli
            ::oDbfCliGst:Poblacion := ::oDbfCliFac:cPobCli
            if ::oDbfProvFac:Seek( ::oDbfCliFac:cCodProv )
               ::oDbfCliGst:Provincia := ::oDbfProvFac:cNomProv
            end if
            ::oDbfCliGst:CodPostal := ::oDbfCliFac:cPtlCli
            ::oDbfCliGst:Telefono  := ::oDbfCliFac:cTfO1Cli
            ::oDbfCliGst:Fax       := ::oDbfCliFac:cFaxCli
            ::oDbfCliGst:NbrEst    := ::oDbfCliFac:cNomCom
            ::oDbfCliGst:DiaPago   := ::oDbfCliFac:nDia1Pago
            ::oDbfCliGst:DiaPago2  := ::oDbfCliFac:nDia2Pago
            ::oDbfCliGst:Banco     := ::oDbfCliFac:cNbrBco
            ::oDbfCliGst:DirBanco  := ::oDbfCliFac:cDirBco
            ::oDbfCliGst:PobBanco  := ::oDbfCliFac:cPobBco
            ::oDbfCliGst:cProBanco := ::oDbfCliFac:cProvBco
            ::oDbfCliGst:Cuenta    := ::oDbfCliFac:cEntidad + ::oDbfCliFac:cAgencia + cControl + ::oDbfCliFac:cCuenta
            ::oDbfCliGst:CodPago   := ::oDbfCliFac:cCodPAgo
            ::oDbfCliGst:nDpp       := ::oDbfCliFac:nDpp
            ::oDbfCliGst:Riesgo     := ::oDbfCliFac:nRiesgo
            ::oDbfCliGst:CopiasF    := ::oDbfCliFac:nCopFac
            ::oDbfCliGst:Serie      := ::oDbfCliFac:cSerieFact
            ::oDbfCliGst:nRegIva    := ::oDbfCliFac:nIva
            ::oDbfCliGst:lReq       := ::oDbfCliFac:lReq
            ::oDbfCliGst:SubCta     := ::oDbfCliFac:cSubCta
            ::oDbfCliGst:CtaVenta   := ::oDbfCliFac:cCtaVtas
            ::oDbfCliGst:cAgente    := ::oDbfCliFac:cCodAge
            ::oDbfCliGst:lBlqCli    := .f.

            if Val( ::oDbfCliFac:cCodCli ) >= 10000 .and. Val( ::oDbfCliFac:cCodCli ) <= 99999
               ::oDbfCliGst:lChgPre := .f.
            else
               ::oDbfCliGst:lChgPre := .t.
            end if

            if ::oDbfCliFac:FieldPos( "lBloqueado" ) != 0
               if ::oDbfCliFac:lBloqueado
                  ::oDbfCliGst:lChgPre    := .f.
               end if
            end if

            do case
               case ::oDbfCliFac:nDto == 6 .and. ::oDbfCliFac:lMayorista
                  ::oDbfCliGst:nTarifa    := 5
               case ::oDbfCliFac:nDto == 6 .and. !::oDbfCliFac:lMayorista
                  ::oDbfCliGst:nTarifa    := 1
               otherwise
                  ::oDbfCliGst:nTarifa    := 3
            end case

            ::oDbfCliGst:nLabel     := ::oDbfCliFac:nEtiquetas
            ::oDbfCliGst:mComent    := ::oDbfCliFac:cObser2Bco  // -1para Arguelles
            ::oDbfCliGst:cCodGrp    := Padl( AllTrim( ::oDbfCliFac:cCodGrup), 4, "0" )
            ::oDbfCliGst:cCodRem    := ::oDbfCliFac:cCtaRem
            ::oDbfCliGst:cMeiInt    := ::oDbfCliFac:eMail
            ::oDbfCliGst:cUsrDef01  := ::oDbfCliFac:cContacto

            // Comentarios-----------------------------------------------------

            cNotas                  := ""

            if ::oDbfCliCom:Seek( cCodCli )
               while Rtrim( ::oDbfCliCom:cCodCli ) == Rtrim( cCodCli )
                  cNotas            += Rtrim( ::oDbfCliCom:Notas )
                  ::oDbfCliCom:Skip()
               end while
            end if

            if !Empty( cNotas )
               ::oDbfCliGst:mComent := cNotas
            end if

            ::oDbfCliGst:Save()

            ::aMtrIndices[ 5 ]:Set( ::oDbfCliFac:Recno() )

            ::oDbfCliFac:Skip()

         end while

         /*
         Trasbase de Obras-----------------------------------------------------
         */

         ::aMtrIndices[ 5 ]:SetTotal( ::oDbfObrFac:LastRec() )

         ::oDbfObrFac:GoTop()
         while !( ::oDbfObrFac:eof() )

            if ::oDbfObrGst:Seek( SpecialPadr( ::oDbfObrFac:cCodCli, "0", RetNumCodCliEmp() ) + ::oDbfObrFac:cIdenDir )
               ::oDbfObrGst:Delete( .f. )
            end if

            ::oDbfObrGst:Append()

            ::oDbfObrGst:cCodCli    := SpecialPadr( ::oDbfObrFac:cCodCli, "0", RetNumCodCliEmp() )
            ::oDbfObrGst:cCodObr    := ::oDbfObrFac:cIdenDir
            ::oDbfObrGst:cNomObr    := ::oDbfObrFac:cNomCom
            ::oDbfObrGst:cDirObr    := ::oDbfObrFac:cDirCli
            ::oDbfObrGst:cPobObr    := ::oDbfObrFac:cPobCli
            ::oDbfObrGst:cPrvObr    := ::oDbfObrFac:cCodProv
            ::oDbfObrGst:cPosObr    := ::oDbfObrFac:cPtlCli
            ::oDbfObrGst:cTelObr    := ::oDbfObrFac:cTfo1Cli

            ::oDbfObrGst:Save()

            ::aMtrIndices[ 5 ]:Set( ::oDbfObrFac:Recno() )

            ::oDbfObrFac:Skip()

         end while

         /*
         Trasbase de Atipicas--------------------------------------------------
         */

         ::oDbfAtpFac:GoTop()
         while !::oDbfAtpGst:Eof()
            ::oDbfAtpGst:Delete( .f. )
            ::oDbfAtpGst:Skip()
         end if

         ::aMtrIndices[ 5 ]:SetTotal( ::oDbfAtpFac:LastRec() )

         while !( ::oDbfAtpFac:eof() )

            ::oDbfAtpGst:Append()

            ::oDbfAtpGst:cCodCli    := SpecialPadr( ::oDbfAtpFac:cCodCli, "0", RetNumCodCliEmp() )

            if ::oDbfAtpFac:cClaveA == "P"
               ::oDbfAtpGst:cCodArt := ::oDbfAtpFac:cRef
               ::oDbfAtpGst:nTipAtp := 1
            else
               ::oDbfAtpGst:cCodFam := left( ::oDbfAtpFac:cRef, 8 )
               ::oDbfAtpGst:nTipAtp := 2
            end if

            ::oDbfAtpGst:dFecIni    := ::oDbfAtpFac:dFecIni
            ::oDbfAtpGst:dFecFin    := ::oDbfAtpFac:dFecFin
            ::oDbfAtpGst:nPrcArt    := ::oDbfAtpFac:nPrecio
            ::oDbfAtpGst:nPrcArt2   := ::oDbfAtpFac:nPrecio
            ::oDbfAtpGst:nPrcArt3   := ::oDbfAtpFac:nPrecio
            ::oDbfAtpGst:nPrcArt4   := ::oDbfAtpFac:nPrecio
            ::oDbfAtpGst:nPrcArt5   := ::oDbfAtpFac:nPrecio
            ::oDbfAtpGst:nPrcArt6   := ::oDbfAtpFac:nPrecio
            ::oDbfAtpGst:nDtoArt    := ::oDbfAtpFac:nDto
            ::oDbfAtpGst:lAplPre    := .t.
            ::oDbfAtpGst:lAplPed    := .t.
            ::oDbfAtpGst:lAplAlb    := .t.
            ::oDbfAtpGst:lAplFac    := .t.

            ::oDbfAtpGst:Save()

            ::aMtrIndices[ 5 ]:Set( ::oDbfAtpFac:Recno() )

            ::oDbfAtpFac:Skip()

         end while

      end if

      /*
      Trasbase de formas de pago-----------------------------------------------
      */

      if ::aLgcIndices[ 6 ]

         ::aMtrIndices[ 6 ]:SetTotal( ::oDbfFpgFac:LastRec() )

         ::oDbfFpgFac:GoTop()
         while !( ::oDbfFpgFac:eof() )

            while ::oDbfFpgGst:Seek( ::oDbfFpgFac:cCodPago )
               ::oDbfFpgGst:Delete( .f. )
            end if

            ::oDbfFpgGst:Append()

            ::oDbfFpgGst:cCodPago  := ::oDbfFpgFac:cCodPago
            ::oDbfFpgGst:cDesPago  := ::oDbfFpgFac:cDesPago
            ::oDbfFpgGst:nTipPgo   := 1
            ::oDbfFpgGst:nPctCom   := ::oDbfFpgFac:nComision
            ::oDbfFpgGst:lEmtRec   := .t.
            ::oDbfFpgGst:nCobRec   := if( ::oDbfFpgFac:lPagado, 1, 2 )
            ::oDbfFpgGst:cCtaCobro := ::oDbfFpgFac:cCtaCobro

            ::oDbfFpgGst:Save()

            ::aMtrIndices[ 6 ]:Set( ::oDbfFpgFac:Recno() )

            ::oDbfFpgFac:Skip()

         end while

      end if

      /*
      Trasbase de remesas recibos clientes-------------------------------------
      */

      if ::aLgcIndices[ 19 ]

         ::aMtrIndices[ 19 ]:SetTotal( ::oDbfRemFac:LastRec() )

         ::oDbfRemFac:GoTop()
         while !( ::oDbfRemFac:eof() )

            while ::oDbfRemGst:Seek( Str( ::oDbfRemFac:nNumRem, 9 ) )
               ::oDbfRemGst:Delete( .f. )
            end while

            ::oDbfRemGst:Append()

            ::oDbfRemGst:lConta     := ::oDbfRemFac:lContab
            ::oDbfRemGst:nNumRem    := ::oDbfRemFac:nNumRem
            ::oDbfRemGst:cSufRem    := Space( 2 )
            ::oDbfRemGst:cCodRem    := Padl( AllTrim( ::oDbfRemFac:cCtaRem ), 3, "0" )
            ::oDbfRemGst:dFecRem    := ::oDbfRemFac:dFecRem
            ::oDbfRemGst:nTipRem    := 1
            ::oDbfRemGst:cCodDiv    := ::oDbfRemFac:cCodDiv
            ::oDbfRemGst:nVdvDiv    := 1

            ::oDbfRemGst:Save()

            ::aMtrIndices[ 19 ]:Set( ::oDbfRemFac:Recno() )

            ::oDbfRemFac:Skip()

         end while

         /*
         Cuentas de remesas----------------------------------------------------
         */

         ::aMtrIndices[ 19 ]:SetTotal( ::oDbfCtaRemFac:LastRec() )

         ::oDbfCtaRemFac:GoTop()
         while !( ::oDbfCtaRemFac:eof() )

            while ::oDbfCtaRemGst:Seek( Padl( AllTrim( ::oDbfCtaRemFac:cCtaRem ), 3, "0" ) )
               ::oDbfCtaRemGst:Delete( .f. )
            end while

            ::oDbfCtaRemGst:Append()

            ::oDbfCtaRemGst:cCodCta    := Padl( AllTrim( ::oDbfCtaRemFac:cCtaRem ), 3, "0" )
            ::oDbfCtaRemGst:cNomCta    := ::oDbfCtaRemFac:cNomCta
            ::oDbfCtaRemGst:cDirCta    := ::oDbfCtaRemFac:cDirCta
            ::oDbfCtaRemGst:cEntBan    := ::oDbfCtaRemFac:cEntidad
            ::oDbfCtaRemGst:cAgcBan    := ::oDbfCtaRemFac:cAgencia
            ::oDbfCtaRemGst:cDgcBan    := cDgtControl( ::oDbfCtaRemFac:cEntidad, ::oDbfCtaRemFac:cAgencia, "", ::oDbfCtaRemFac:cCuenta )
            ::oDbfCtaRemGst:cCtaBan    := ::oDbfCtaRemFac:cCuenta
            ::oDbfCtaRemGst:cSufCta    := ::oDbfCtaRemFac:cSufijo
            ::oDbfCtaRemGst:cSufN58    := ::oDbfCtaRemFac:cSufijo58

            ::oDbfCtaRemGst:Save()

            ::aMtrIndices[ 19 ]:Set( ::oDbfCtaRemFac:Recno() )

            ::oDbfCtaRemFac:Skip()

         end while

      end if

      /*
      Trasbase de proveedores--------------------------------------------------
      */

      if ::aLgcIndices[ 7 ]

         ::aMtrIndices[ 7 ]:SetTotal( ::oDbfPrvFac:LastRec() )

         ::oDbfPrvFac:GoTop()
         while !( ::oDbfPrvFac:eof() )

            while ::oDbfPrvGst:Seek( SpecialPadr( ::oDbfPrvFac:cCodPro, "0", RetNumCodPrvEmp() ) )
               ::oDbfPrvGst:Delete( .f. )
            end if

            ::oDbfPrvGst:Append()

            ::oDbfPrvGst:Cod       := SpecialPadr( ::oDbfPrvFac:cCodPro, "0", RetNumCodPrvEmp() )
            ::oDbfPrvGst:Titulo    := ::oDbfPrvFac:cNomPro
            ::oDbfPrvGst:Nif       := ::oDbfPrvFac:cNifDni
            ::oDbfPrvGst:Domicilio := ::oDbfPrvFac:cDirPro
            ::oDbfPrvGst:Poblacion := ::oDbfPrvFac:cPobPro
            ::oDbfPrvGst:CodPostal := ::oDbfPrvFac:cPtlPro
            ::oDbfPrvGst:Telefono  := ::oDbfPrvFac:cTfo1Pro
            ::oDbfPrvGst:Fax       := ::oDbfPrvFac:cFax
            ::oDbfPrvGst:DtoPP     := ::oDbfPrvFac:nDto
            ::oDbfPrvGst:FPago     := ::oDbfPrvFac:cCodPago
            ::oDbfPrvGst:DiaPago   := ::oDbfPrvFac:nDiaPago
            ::oDbfPrvGst:SubCta    := ::oDbfPrvFac:cSubCta
            ::oDbfPrvGst:lLabel    := ::oDbfPrvFac:lSelect
            ::oDbfPrvGst:nLabel    := ::oDbfPrvFac:nEtiquetas

            ::oDbfPrvGst:Save()

            ::aMtrIndices[ 7 ]:Set( ::oDbfPrvFac:Recno() )

            ::oDbfPrvFac:Skip()

         end while

      end if

      /*
      Trasbase de agentes------------------------------------------------------
      */

      if ::aLgcIndices[ 11 ]

         ::aMtrIndices[ 11 ]:SetTotal( ::oDbfAgeFac:LastRec() )

         ::oDbfAgeFac:GoTop()
         while !( ::oDbfAgeFac:eof() )

            while ::oDbfAgeGst:Seek( SpecialPadr( ::oDbfAgeFac:cCodAge, '0' ) )
               ::oDbfAgeGst:Delete( .f. )
            end if

            ::oDbfAgeGst:Append()

            ::oDbfAgeGst:cCodAge   := SpecialPadr( ::oDbfAgeFac:cCodAge, '0' )
            ::oDbfAgeGst:cApeAge   := Left( ::oDbfAgeFac:cApeAge, 30 )
            ::oDbfAgeGst:cNbrAge   := Left( ::oDbfAgeFac:cNbrAge, 15 )
            ::oDbfAgeGst:cDniNif   := ::oDbfAgeFac:cDniNif
            ::oDbfAgeGst:cDirAge   := Left( ::oDbfAgeFac:cDirAge, 35 )
            ::oDbfAgeGst:cPobAge   := Left( ::oDbfAgeFac:cPobAge, 25 )
            ::oDbfAgeGst:cPtlAge   := Left( ::oDbfAgeFac:cPtlAge, 5 )
            ::oDbfAgeGst:cTfoAge   := Left( ::oDbfAgeFac:cTfoAge, 12 )
            ::oDbfAgeGst:cFaxAge   := Left( ::oDbfAgeFac:cFaxAge, 12 )
            ::oDbfAgeGst:nIrpFage   := ::oDbfAgeFac:nIrpFage
            ::oDbfAgeGst:nCom1     := ::oDbfAgeFac:nCom1

            ::oDbfAgeGst:Save()

            ::aMtrIndices[ 11 ]:Set( ::oDbfAgeFac:Recno() )

            ::oDbfAgeFac:Skip()

         end while

      end if

      /*
      Trasbase de Almacenes----------------------------------------------------
      */

      if ::aLgcIndices[ 12 ]

         ::aMtrIndices[ 12 ]:SetTotal( ::oDbfAlmFac:LastRec() )

         ::oDbfAlmFac:GoTop()
         while !( ::oDbfAlmFac:eof() )

            while ::oDbfAlmGst:Seek( ::oDbfAlmFac:cCodAlm )
               ::oDbfAlmGst:Delete( .f. )
            end if

            ::oDbfAlmGst:Append()

            ::oDbfAlmGst:cCodAlm   := RJust( ::oDbfAlmFac:cCodAlm, "0", 3 )
            ::oDbfAlmGst:cNomAlm   := Left( ::oDbfAlmFac:cNomBre, 20 )
            ::oDbfAlmGst:cDirAlm   := Left( ::oDbfAlmFac:cDirEcc, 50 )
            ::oDbfAlmGst:cPobAlm   := Left( ::oDbfAlmFac:cPobLac, 30 )
            ::oDbfAlmGst:cTfnAlm   := ::oDbfAlmFac:cTfno

            ::oDbfAlmGst:Save()

            ::aMtrIndices[ 12 ]:Set( ::oDbfAlmFac:Recno() )

            ::oDbfAlmFac:Skip()

         end while

      end if

      /*
      Trasbase de presupuestos de clientes-------------------------------------
      */

      if ::aLgcIndices[ 20 ]

         ::aMtrIndices[ 20 ]:SetTotal( ::oDbfPreTFac:LastRec() )

         ::oDbfPreTFac:GoTop()
         while !( ::oDbfPreTFac:eof() )

            while ::oDbfPreTGst:Seek( "A" + Str( ::oDbfPreTFac:nNumPre, 9 ) )
               ::oDbfPreTGst:Delete( .f. )
            end

            while ::oDbfPreLGst:Seek( "A" + Str( ::oDbfPreTFac:nNumPre, 9 ) )
               ::oDbfPreLGst:Delete( .f. )
            end

            ::oDbfPreTGst:Append()

            ::oDbfPreTGst:cSerPre      := "A"
            ::oDbfPreTGst:nNumPre      := ::oDbfPreTFac:nNumPre
            ::oDbfPreTGst:cSufPre      := Space( 2 )
            ::oDbfPreTGst:cTurPre      := cCurSesion()
            ::oDbfPreTGst:dFecPre      := ::oDbfPreTFac:dFecPre
            ::oDbfPreTGst:cCodAlm      := ::oDbfPreTFac:cCodAlm
            ::oDbfPreTGst:cCodCli      := SpecialPadr( ::oDbfPreTFac:cCodCli, "0", RetNumCodCliEmp() )
            ::oDbfPreTGst:cCodCaj      := "000"
            ::oDbfPreTGst:cCodPgo      := ::oDbfPreTFac:cCodPago
            ::oDbfPreTGst:mObsErv      := ::oDbfPreTFac:cObsErv
            ::oDbfPreTGst:nTarifa      := 1
            ::oDbfPreTGst:lEstado      := ( ::oDbfPreTFac:cEstado == "T" )
            
            if ::oDbfCliGst:Seek( SpecialPadr( ::oDbfPreTFac:cCodCli, "0", RetNumCodCliEmp() ) )
               ::oDbfPreTGst:cNomCli   := ::oDbfCliGst:Titulo
               ::oDbfPreTGst:cDirCli   := ::oDbfCliGst:Domicilio
               ::oDbfPreTGst:cPobCli   := ::oDbfCliGst:Poblacion
               ::oDbfPreTGst:cPrvCli   := ::oDbfCliGst:Provincia
               ::oDbfPreTGst:cPosCli   := ::oDbfCliGst:CodPostal
               ::oDbfPreTGst:cDniCli   := ::oDbfCliGst:Nif
               ::oDbfPreTGst:cTlfCli   := ::oDbfCliGst:Telefono
            end if

            ::oDbfPreTGst:cDpp         := "Descuento"
            ::oDbfPreTGst:cDtoEsp      := "Descuento"
            ::oDbfPreTGst:nDpp         := ::oDbfPreTFac:nDpp
            ::oDbfPreTGst:nDtoEsp      := ::oDbfPreTFac:nDtoEsp
            ::oDbfPreTGst:cDivPre      := ::oDbfPreTFac:cCodDiv
            ::oDbfPreTGst:nVdvPre      := 1
            ::oDbfPreTGst:nTotPre      := ::oDbfPreTFac:nTotPre 

            ::oDbfPreTGst:Save()

            ::aMtrIndices[ 20 ]:Set( ::oDbfPreTFac:Recno() )

            ::oDbfPreTFac:Skip()

         end while

         ::aMtrIndices[ 20 ]:SetTotal( ::oDbfPreLFac:LastRec() )

         ::oDbfPreLGst:OrdSetFocus( "nNumLin" )

         ::oDbfPreLFac:GoTop()

         while !( ::oDbfPreLFac:eof() )

            n := aScan( aTemporalLineas, {|o| o:nNumPre == ::oDbfPreLFac:nNumPre .and. o:nNumLin == ::oDbfPreLFac:nServicio } )

            if n == 0

               oTemporal               := SLineasPresupuestos()
               oTemporal:cSerPre       := "A"  
               oTemporal:nNumPre       := ::oDbfPreLFac:nNumPre
               oTemporal:cSufPre       := Space( 2 )
               oTemporal:cRef          := ::oDbfPreLFac:cRef
               if Empty( ::oDbfPreLFac:cRef )
                  oTemporal:mLngDes    := ::oDbfPreLFac:cDetalle
                  oTemporal:cDetalle   := Space( 250 )
               else
                  oTemporal:cDetalle   := ::oDbfPreLFac:cDetalle
               end if
               oTemporal:nIva          := ::oDbfPreLFac:nIva
               oTemporal:nUniCaja      := ::oDbfPreLFac:nCanPed
               oTemporal:nPreDiv       := ::oDbfPreLFac:nPreUnit
               oTemporal:nDto          := ::oDbfPreLFac:nDto
               oTemporal:cLote         := ::oDbfPreLFac:cLote
               oTemporal:nNumLin       := ::oDbfPreLFac:nServicio

               aAdd( aTemporalLineas, oTemporal )   

            else
            
               if Empty( aTemporalLineas[n]:mLngDes )
                  aTemporalLineas[n]:mLngDes := ::oDbfPreLFac:cDetalle   
               else
                  aTemporalLineas[n]:mLngDes += ::oDbfPreLFac:cDetalle
               end if

               if aTemporalLineas[n]:nUniCaja == 0
                  aTemporalLineas[n]:nUniCaja := ::oDbfPreLFac:nCanPed
               end if

               if aTemporalLineas[n]:nPreDiv == 0
                  aTemporalLineas[n]:nPreDiv := ::oDbfPreLFac:nPreUnit
               end if

               if aTemporalLineas[n]:nDto == 0
                  aTemporalLineas[n]:nDto := ::oDbfPreLFac:nDto
               end if

               if aTemporalLineas[n]:nIva == 0
                  aTemporalLineas[n]:nIva := ::oDbfPreLFac:nIva
               end if

            end if   

            ::aMtrIndices[ 20 ]:Set( ::oDbfPreLFac:Recno() )

            ::oDbfPreLFac:Skip()

         end while

         /*
         Pasamos los datos del array a la base de datos------------------------
         */

         for each aLinea in aTemporalLineas

            ::oDbfPreLGst:Append()

            ::oDbfPreLGst:cSerPre      := aLinea:cSerPre
            ::oDbfPreLGst:nNumPre      := aLinea:nNumPre
            ::oDbfPreLGst:cSufPre      := aLinea:cSufPre
            ::oDbfPreLGst:cRef         := aLinea:cRef
            ::oDbfPreLGst:mLngDes      := aLinea:mLngDes
            ::oDbfPreLGst:cDetalle     := aLinea:cDetalle
            ::oDbfPreLGst:nIva         := aLinea:nIva
            ::oDbfPreLGst:nUniCaja     := aLinea:nUniCaja
            ::oDbfPreLGst:nPreDiv      := aLinea:nPreDiv
            ::oDbfPreLGst:nDto         := aLinea:nDto
            ::oDbfPreLGst:cLote        := aLinea:cLote
            ::oDbfPreLGst:nNumLin      := aLinea:nNumLin

            ::oDbfPreLGst:Save()

         next

      end if

      /*
      Trasbase de predidos de clientes-----------------------------------------
      */

      if ::aLgcIndices[ 21 ]

         ::aMtrIndices[ 21 ]:SetTotal( ::oDbfPedTFac:LastRec() )

         ::oDbfPedTFac:GoTop()
         while !( ::oDbfPedTFac:eof() )

            while ::oDbfPedTGst:Seek( "A" + Str( ::oDbfPedTFac:nNumPed, 9 ) )
               ::oDbfPedTGst:Delete( .f. )
            end

            while ::oDbfPedLGst:Seek( "A" + Str( ::oDbfPedTFac:nNumPed, 9 ) )
               ::oDbfPedLGst:Delete( .f. )
            end

            ::oDbfPedTGst:Append()

            ::oDbfPedTGst:cSerPed      := "A"
            ::oDbfPedTGst:nNumPed      := ::oDbfPedTFac:nNumPed
            ::oDbfPedTGst:cSufPed      := Space( 2 )
            ::oDbfPedTGst:cTurPed      := cCurSesion()
            ::oDbfPedTGst:dFecPed      := ::oDbfPedTFac:dFecPed
            ::oDbfPedTGst:cCodAlm      := ::oDbfPedTFac:cCodAlm
            ::oDbfPedTGst:cCodCli      := SpecialPadr( ::oDbfPedTFac:cCodCli, "0", RetNumCodCliEmp() )
            ::oDbfPedTGst:cCodCaj      := "000"
            ::oDbfPedTGst:cCodPgo      := ::oDbfPedTFac:cCodPago
            ::oDbfPedTGst:mObsErv      := ::oDbfPedTFac:cObsErv
            ::oDbfPedTGst:nTarifa      := 1
            ::oDbfPedTGst:nEstado      := if( ::oDbfPedTFac:cEstado == "T", 3, 1 )
            
            if ::oDbfCliGst:Seek( SpecialPadr( ::oDbfPedTFac:cCodCli, "0", RetNumCodCliEmp() ) )
               ::oDbfPedTGst:cNomCli   := ::oDbfCliGst:Titulo
               ::oDbfPedTGst:cDirCli   := ::oDbfCliGst:Domicilio
               ::oDbfPedTGst:cPobCli   := ::oDbfCliGst:Poblacion
               ::oDbfPedTGst:cPrvCli   := ::oDbfCliGst:Provincia
               ::oDbfPedTGst:cPosCli   := ::oDbfCliGst:CodPostal
               ::oDbfPedTGst:cDniCli   := ::oDbfCliGst:Nif
               ::oDbfPedTGst:cTlfCli   := ::oDbfCliGst:Telefono
            end if

            ::oDbfPedTGst:cDpp         := "Descuento"
            ::oDbfPedTGst:cDtoEsp      := "Descuento"
            ::oDbfPedTGst:nDpp         := ::oDbfPedTFac:nDpp
            ::oDbfPedTGst:nDtoEsp      := ::oDbfPedTFac:nDtoEsp
            ::oDbfPedTGst:cDivPed      := ::oDbfPedTFac:cCodDiv
            ::oDbfPedTGst:nVdvPed      := 1
            ::oDbfPedTGst:nTotPed      := ::oDbfPedTFac:nTotPed 

            ::oDbfPedTGst:Save()

            ::aMtrIndices[ 21 ]:Set( ::oDbfPedTFac:Recno() )

            ::oDbfPedTFac:Skip()

         end while

         ::aMtrIndices[ 21 ]:SetTotal( ::oDbfPedLFac:LastRec() )

         ::oDbfPedLGst:OrdSetFocus( "nNumLin" )

         ::oDbfPedLFac:GoTop()

         while !( ::oDbfPedLFac:eof() )

            n := aScan( aTemporalLineas, {|o| o:nNumPed == ::oDbfPedLFac:nNumPed .and. o:nNumLin == ::oDbfPedLFac:nServicio } )

            if n == 0

               oTemporal               := SLineasPedidos()
               oTemporal:cSerPed       := "A"  
               oTemporal:nNumPed       := ::oDbfPedLFac:nNumPed   
               oTemporal:cSufPed       := Space( 2 )
               oTemporal:cRef          := ::oDbfPedLFac:cRef
               if Empty( ::oDbfPedLFac:cRef )
                  oTemporal:mLngDes    := ::oDbfPedLFac:cDetalle
                  oTemporal:cDetalle   := Space( 250 )
               else
                  oTemporal:cDetalle   := ::oDbfPedLFac:cDetalle
               end if
               oTemporal:nIva          := ::oDbfPedLFac:nIva
               oTemporal:nUniCaja      := ::oDbfPedLFac:nCanPed
               oTemporal:nPreDiv       := ::oDbfPedLFac:nPreUnit
               oTemporal:nDto          := ::oDbfPedLFac:nDto
               oTemporal:cLote         := ::oDbfPedLFac:cLote
               oTemporal:nNumLin       := ::oDbfPedLFac:nServicio

               aAdd( aTemporalLineas, oTemporal )   

            else
            
               if Empty( aTemporalLineas[n]:mLngDes )
                  aTemporalLineas[n]:mLngDes := ::oDbfPedLFac:cDetalle   
               else
                  aTemporalLineas[n]:mLngDes += ::oDbfPedLFac:cDetalle
               end if

               if aTemporalLineas[n]:nUniCaja == 0
                  aTemporalLineas[n]:nUniCaja := ::oDbfPedLFac:nCanPed
               end if

               if aTemporalLineas[n]:nPreDiv == 0
                  aTemporalLineas[n]:nPreDiv := ::oDbfPedLFac:nPreUnit
               end if

               if aTemporalLineas[n]:nDto == 0
                  aTemporalLineas[n]:nDto := ::oDbfPedLFac:nDto
               end if

               if aTemporalLineas[n]:nIva == 0
                  aTemporalLineas[n]:nIva := ::oDbfPedLFac:nIva
               end if

            end if   

            ::aMtrIndices[ 21 ]:Set( ::oDbfPedeLFac:Recno() )

            ::oDbfPedLFac:Skip()

         end while

         /*
         Pasamos los datos del array a la base de datos------------------------
         */

         for each aLinea in aTemporalLineas

            ::oDbfPedLGst:Append()

            ::oDbfPedLGst:cSerPed      := aLinea:cSerPed
            ::oDbfPedLGst:nNumPed      := aLinea:nNumPed
            ::oDbfPedLGst:cSufPed      := aLinea:cSufPed
            ::oDbfPedLGst:cRef         := aLinea:cRef
            ::oDbfPedLGst:mLngDes      := aLinea:mLngDes 
            ::oDbfPedLGst:cDetalle     := aLinea:cDetalle
            ::oDbfPedLGst:nIva         := aLinea:nIva
            ::oDbfPedLGst:nUniCaja     := aLinea:nUniCaja 
            ::oDbfPedLGst:nPreDiv      := aLinea:nPreDiv
            ::oDbfPedLGst:nDto         := aLinea:nDto
            ::oDbfPedLGst:cLote        := aLinea:cLote
            ::oDbfPedLGst:nNumLin      := aLinea:nNumLin

            ::oDbfPedLGst:Save()

         next

      end if

      /*
      Trasbase de Albaranes de Clientes---------------------------
      */

      if ::aLgcIndices[ 8 ]

         ::aMtrIndices[ 8 ]:SetTotal( ::oDbfAlbTFac:LastRec() )

         ::oDbfAlbTFac:GoTop()
         while !( ::oDbfAlbTFac:eof() )

            while ::oDbfAlbTGst:Seek( ::oDbfAlbTFac:cSerie + Str( ::oDbfAlbTFac:nNumAlb, 9 ) )
               ::oDbfAlbTGst:Delete( .f. )
            end

            while ::oDbfAlbLGst:Seek( ::oDbfAlbTFac:cSerie + Str( ::oDbfAlbTFac:nNumAlb, 9 ) )
               ::oDbfAlbLGst:Delete( .f. )
            end

            ::oDbfAlbTGst:Append()

            ::oDbfAlbTGst:cSerAlb      := ::oDbfAlbTFac:cSerie
            ::oDbfAlbTGst:nNumAlb      := ::oDbfAlbTFac:nNumAlb
            ::oDbfAlbTGst:cSufAlb      := Space( 2 )
            ::oDbfAlbTGst:cTurAlb      := cCurSesion()
            ::oDbfAlbTGst:dFecAlb      := ::oDbfAlbTFac:dFecAlb
            ::oDbfAlbTGst:cCodCli      := SpecialPadr( ::oDbfAlbTFac:cCodCli, "0", RetNumCodCliEmp() )
            ::oDbfAlbTGst:cCodAlm      := ::oDbfAlbTFac:cCodAlm
            ::oDbfAlbTGst:cCodCaj      := "000"

            if ::oDbfCliGst:Seek( SpecialPadr( ::oDbfAlbTFac:cCodCli, "0", RetNumCodCliEmp() ) )
               ::oDbfAlbTGst:cNomCli   := ::oDbfCliGst:Titulo
               ::oDbfAlbTGst:cDirCli   := ::oDbfCliGst:Domicilio
               ::oDbfAlbTGst:cPobCli   := ::oDbfCliGst:Poblacion
               ::oDbfAlbTGst:cPrvCli   := ::oDbfCliGst:Provincia
               ::oDbfAlbTGst:cPosCli   := ::oDbfCliGst:CodPostal
               ::oDbfAlbTGst:cDniCli   := ::oDbfCliGst:Nif
            end if

            ::oDbfAlbTGst:lFacturado   := ::oDbfAlbTFac:lFacturado
            ::oDbfAlbTGst:dFecEnt      := ::oDbfAlbTFac:dFecEnt
            ::oDbfAlbTGst:cCondEnt     := ::oDbfAlbTFac:cCondEnt
            ::oDbfAlbTGst:mObsErv      := ::oDbfAlbTFac:cObsErv
            ::oDbfAlbTGst:cCodPago     := ::oDbfAlbTFac:cCodPago
            ::oDbfAlbTGst:nBulTos      := ::oDbfAlbTFac:nBulTos
            ::oDbfAlbTGst:nPorTes      := ::oDbfAlbTFac:nPorTes
            ::oDbfAlbTGst:cCodAge      := SpecialPadr( ::oDbfAlbTFac:cCodAge, '0' )
            ::oDbfAlbTGst:nTipoAlb     := ::oDbfAlbTFac:nTipoAlb
            ::oDbfAlbTGst:nDtoEsp      := ::oDbfAlbTFac:nDtoEsp
            ::oDbfAlbTGst:nDpp         := ::oDbfAlbTFac:nDpp
            ::oDbfAlbTGst:nPctComAge   := ::oDbfAlbTFac:nComision
            ::oDbfAlbTGst:cDivAlb      := ::oDbfAlbTFac:cCodDiv
            ::oDbfAlbTGst:nVdvAlb      := 1
            ::oDbfAlbTGst:cSuPed       := Left( ::oDbfAlbTFac:cSuPed, 35 )
            ::oDbfAlbTGst:cCodTrn      := ::oDbfAlbTFac:cCodTran

            ::oDbfAlbTGst:Save()

            ::aMtrIndices[ 8 ]:Set( ::oDbfAlbTFac:Recno() )

            ::oDbfAlbTFac:Skip()

         end while

         ::aMtrIndices[ 8 ]:SetTotal( ::oDbfAlbLFac:LastRec() )

         ::oDbfAlbLFac:GoTop()
         while !( ::oDbfAlbLFac:eof() )

            ::oDbfAlbLGst:Append()

            /*Buscamos la serie del documento en la cabecera, la que factuplus
            no guarda la serie en las lineas de los albaranes*/

            ::oDbfAlbTGst:GoTop()

            while !::oDbfAlbTGst:Eof()

               if ::oDbfAlbTGst:nNumAlb == ::oDbfAlbLFac:nNumAlb
                  ::oDbfAlbLGst:cSerAlb  := ::oDbfAlbTGst:cSerAlb
               end if

               ::oDbfAlbTGst:Skip()

            end while

            ::oDbfAlbLGst:nNumAlb      := ::oDbfAlbLFac:nNumAlb
            ::oDbfAlbLGst:cSufAlb      := Space( 2 )
            ::oDbfAlbLGst:cRef         := ::oDbfAlbLFac:cRef
            if Empty( ::oDbfAlbLFac:cRef )
               ::oDbfAlbLGst:mLngDes   := ::oDbfAlbLFac:cDetalle
               ::oDbfAlbLGst:cDetalle  := Space( 250 )
            else
               ::oDbfAlbLGst:cDetalle  := ::oDbfAlbLFac:cDetalle
            end if
            ::oDbfAlbLGst:nPreUnit     := ::oDbfAlbLFac:nPreUnit
            ::oDbfAlbLGst:nDto         := ::oDbfAlbLFac:nDto
            ::oDbfAlbLGst:nDtoPrm      := ::oDbfAlbLFac:nDtoProm
            ::oDbfAlbLGst:nIva         := ::oDbfAlbLFac:nIva
            ::oDbfAlbLGst:lConTrol     := ::oDbfAlbLFac:lConTrol
            ::oDbfAlbLGst:nComAge      := ::oDbfAlbLFac:nComision
            ::oDbfAlbLGst:nUniCaja     := ::oDbfAlbLFac:nCanEnt
            ::oDbfAlbLGst:dFecha       := ::oDbfAlbLFac:dFecPed
            ::oDbfAlbLGst:cCodPr1      := ::oDbfAlbLFac:cProp1
            ::oDbfAlbLGst:cCodPr2      := ::oDbfAlbLFac:cProp2

            /*
            Solo importación ayamonte------------------------------------------
            */

            ::oDbfAlbLGst:lLote        := !Empty( ::oDbfAlbLFac:cProp2 )
            ::oDbfAlbLGst:cLote        := ::oDbfAlbLFac:cProp2
            ::oDbfAlbLGst:dFecCad      := cTod( SubStr( ::oDbfAlbLFac:cProp1, 8, 2 ) + "/" + SubStr( ::oDbfAlbLFac:cProp1, 6, 2 ) + "/" + SubStr( ::oDbfAlbLFac:cProp1, 1, 4 ) )

            ::oDbfAlbLGst:Save()

            ::aMtrIndices[ 8 ]:Set( ::oDbfAlbLFac:Recno() )

            ::oDbfAlbLFac:Skip()

         end while

      end if

      /*
      Trasbase de Facturas de Clientes----------------------------
      */

      if ::aLgcIndices[ 9 ]

         ::aMtrIndices[ 9 ]:SetTotal( ::oDbfFacTFac:LastRec() )

         ::oDbfFacTFac:GoTop()
         while !( ::oDbfFacTFac:eof() )

            if ::oDbfFacTFac:cSerie == "A" .or. ::oDbfFacTFac:cSerie == "B"

               while ::oDbfFacTGst:Seek( ::oDbfFacTFac:cSerie + Str( ::oDbfFacTFac:nNumFac, 9 ) )
                  ::oDbfFacTGst:Delete( .f. )
               end if

               while ::oDbfFacLGst:Seek( ::oDbfFacTFac:cSerie + Str( ::oDbfFacTFac:nNumFac, 9 ) )
                  ::oDbfFacLGst:Delete( .f. )
               end if

               while ::oDbfFacPGst:Seek( ::oDbfFacTFac:cSerie + Str( ::oDbfFacTFac:nNumFac, 9 ) )
                  ::oDbfFacPGst:Delete( .f. )
               end if

               ::oDbfFacTGst:Append()

               ::oDbfFacTGst:cSerie          := ::oDbfFacTFac:cSerie
               ::oDbfFacTGst:nNumFac         := ::oDbfFacTFac:nNumFac
               ::oDbfFacTGst:cSufFac         := Space( 2 )
               ::oDbfFacTGst:cTurFac         := cCurSesion()
               ::oDbfFacTGst:dFecFac         := ::oDbfFacTFac:dFecFac

               if !Empty( ::oDbfFacTFac:cCodCli )
                  ::oDbfFacTGst:cCodCli      := SpecialPadr( ::oDbfFacTFac:cCodCli, "0", RetNumCodCliEmp() )

                  if ::oDbfCliGst:Seek( SpecialPadr( ::oDbfFacTFac:cCodCli, "0", RetNumCodCliEmp() ) )
                     ::oDbfFacTGst:cNomCli   := ::oDbfCliGst:Titulo
                     ::oDbfFacTGst:cDirCli   := ::oDbfCliGst:Domicilio
                     ::oDbfFacTGst:cPobCli   := ::oDbfCliGst:Poblacion
                     ::oDbfFacTGst:cPrvCli   := ::oDbfCliGst:Provincia
                     ::oDbfFacTGst:cPosCli   := ::oDbfCliGst:CodPostal
                     ::oDbfFacTGst:cDniCli   := ::oDbfCliGst:Nif
                     ::oDbfFacTGst:nRegIva   := ::oDbfCliGst:nRegIva
                     nRegIva                 := ::oDbfCliGst:nRegIva
                  end if
               else
                  ::oDbfFacTGst:cCodCli      := Space( 12 )
                  if ::oDbfFacDFac:Seek( ::oDbfFacTFac:cSerie + Str( ::oDbfFacTFac:nNumFac ) )
                     ::oDbfFacTGst:cNomCli   := Left( ::oDbfFacDFac:cNomCli, 50 )
                     ::oDbfFacTGst:cDirCli   := ::oDbfFacDFac:cDirCli
                     ::oDbfFacTGst:cPobCli   := Left( ::oDbfFacDFac:cPobCli, 35 )
                     if ::oDbfProvFac:Seek( ::oDbfFacDFac:cCodProv )
                        ::oDbfFacTGst:cPrvCli  := ::oDbfProvFac:cNomProv
                     end if
                     ::oDbfFacTGst:cPosCli   := Left( ::oDbfFacDFac:cPtlCli, 7 )
                     ::oDbfFacTGst:cDniCli   := ::oDbfFacDFac:cDniCif
                  end if
                  nRegIva                    := 1
               end if

               ::oDbfFacTGst:cCodAlm         := ::oDbfFacTFac:cCodAlm
               ::oDbfFacTGst:cCodCaj         := "000"
               ::oDbfFacTGst:cCodAge         := SpecialPadr( ::oDbfFacTFac:cCodAge, '0' )
               ::oDbfFacTGst:nPctComAge      := ::oDbfFacTFac:nComision
               ::oDbfFacTGst:lLiquidada      := .f.
               ::oDbfFacTGst:lConTab         := ::oDbfFacTFac:lConTab
               ::oDbfFacTGst:dFecEnt         := ::oDbfFacTFac:dFecEnt
               ::oDbfFacTGst:cSuFac          := ::oDbfFacTFac:cSuPed
               ::oDbfFacTGst:cCondEnt        := Left( ::oDbfFacTFac:cCondEnt, 2 )
               ::oDbfFacTGst:mObserv         := Left( ::oDbfFacTFac:cObsErv, 10 )
               ::oDbfFacTGst:cCodPago        := ::oDbfFacTFac:cCodPago
               ::oDbfFacTGst:nBulTos         := ::oDbfFacTFac:nBulTos
               ::oDbfFacTGst:nPorTes         := ::oDbfFacTFac:nPorTes
               ::oDbfFacTGst:cNumAlb         := ::oDbfFacTFac:cSerie + Str( ::oDbfFacTFac:nNumAlb, 9 )
               ::oDbfFacTGst:nTipoFac        := ::oDbfFacTFac:nTipoFac
               ::oDbfFacTGst:nDtoEsp         := ::oDbfFacTFac:nDtoEsp
               ::oDbfFacTGst:nDpp            := ::oDbfFacTFac:nDpp
               ::oDbfFacTGst:lRecargo        := ::oDbfFacTFac:lRecargo
               ::oDbfFacTGst:lIvaInc         := ::oDbfFacTFac:lIvaIncl
               ::oDbfFacTGst:cDivFac         := ::oDbfFacTFac:cCodDiv
               ::oDbfFacTGst:nVdvFac         := 1
               ::oDbfFacTGst:cCodTrn         := ::oDbfFacTFac:cCodTran

               ::oDbfFacTGst:Save()

            end if

         ::aMtrIndices[ 9 ]:Set( ::oDbfFacTFac:Recno() )

         ::oDbfFacTFac:Skip()

         end while

         ::aMtrIndices[ 9 ]:SetTotal( ::oDbfRecFac:LastRec() )

         ::oDbfRecFac:GoTop()
         while !( ::oDbfRecFac:eof() )

            if ::oDbfRecFac:cSerie == "A" .or. ::oDbfRecFac:cSerie == "B"

               ::oDbfFacPGst:Append()

               ::oDbfFacPGst:cSerie         := ::oDbfRecFac:cSerie
               ::oDbfFacPGst:nNumFac        := ::oDbfRecFac:nNumFac
               ::oDbfFacPGst:cSufFac        := Space( 2 )
               ::oDbfFacPGst:nNumRec        := Val( ::oDbfRecFac:cContador )
               ::oDbfFacPGst:cCodCaj        := "000"
               ::oDbfFacPGst:cTurRec        := cCurSesion()
               if !Empty( ::oDbfRecFac:cCodCli )
                  ::oDbfFacPGst:cCodCli     := SpecialPadr( ::oDbfRecFac:cCodCli, "0", RetNumCodCliEmp() )
               else
                  ::oDbfFacPGst:cCodCli      := cDefCli()
               end if
               ::oDbfFacPGst:dEntrada       := ::oDbfRecFac:dFecEmis
               ::oDbfFacPGst:nImporte       := ::oDbfRecFac:nImporte
               ::oDbfFacPGst:dPreCob        := ::oDbfRecFac:dFecExped
               ::oDbfFacPGst:cDocPgo        := ::oDbfRecFac:cTipoDoc
               ::oDbfFacPGst:lCobrado       := ( ::oDbfRecFac:nEstado == 2 )
               ::oDbfFacPGst:cDivPgo        := ::oDbfRecFac:cCodDiv
               ::oDbfFacPGst:nVdvPgo        := 1
               ::oDbfFacPGst:lConPgo        := ::oDbfRecFac:lDocContab
               ::oDbfFacPGst:nImpEur        := ::oDbfRecFac:nImporte
               ::oDbfFacPGst:lImpEur        := .t.
               ::oDbfFacPGst:nNumRem        := ::oDbfRecFac:nNumRem
               ::oDbfFacPGst:cCtaRem        := ::oDbfRecFac:cCtaRem
               ::oDbfFacPGst:dFecVto        := ::oDbfRecFac:dFecVcto
               ::oDbfFacPGst:cTipRec        := Space(1)

               ::oDbfFacPGst:Save()

            end if

            ::aMtrIndices[ 9 ]:Set( ::oDbfRecFac:Recno() )

            ::oDbfRecFac:Skip()

         end while

         ::aMtrIndices[ 9 ]:SetTotal( ::oDbfFacLFac:LastRec() )

         ::oDbfFacLFac:GoTop()
         while !( ::oDbfFacLFac:eof() )

            if ::oDbfFacLFac:cSerie == "A" .or. ::oDbfFacLFac:cSerie == "B"

               ::oDbfFacLGst:Append()

               ::oDbfFacLGst:cSerie       := ::oDbfFacLFac:cSerie
               ::oDbfFacLGst:nNumFac      := ::oDbfFacLFac:nNumFac
               ::oDbfFacLGst:cSufFac      := Space( 2 )
               ::oDbfFacLGst:cRef         := ::oDbfFacLFac:cRef

               if Empty( ::oDbfFacLGst:cRef )
                  ::oDbfFacLGst:mLngDes   := ::oDbfFacLFac:cDetalle
                  ::oDbfFacLGst:cDetalle  := Space(250)
               else
                  ::oDbfFacLGst:cDetalle  := ::oDbfFacLFac:cDetalle
               end if
               ::oDbfFacLGst:nPreUnit     := ::oDbfFacLFac:nPreUnit
               ::oDbfFacLGst:nDto         := ::oDbfFacLFac:nDto
               if nRegIva <= 1
                  ::oDbfFacLGst:nIva      := ::oDbfFacLFac:nIva
               else
                  ::oDbfFacLGst:nIva      := 0
               end if
               ::oDbfFacLGst:lConTrol     := ::oDbfFacLFac:lConTrol
               ::oDbfFacLGst:nComAge      := ::oDbfFacLFac:nComision
               ::oDbfFacLGst:nUniCaja     := ::oDbfFacLFac:nCanEnt
               ::oDbfFacLGst:dFecAlb      := ::oDbfFacLFac:dFecAlb

               /*
               Solo importación ayamonte------------------------------------------
               */

               ::oDbfFacLGst:lLote        := !Empty( ::oDbfFacLFac:cProp2 )
               ::oDbfFacLGst:cLote        := ::oDbfFacLFac:cProp2
               ::oDbfFacLGst:dFecCad      := cTod( SubStr( ::oDbfFacLFac:cProp1, 8, 2 ) + "/" + SubStr( ::oDbfFacLFac:cProp1, 6, 2 ) + "/" + SubStr( ::oDbfFacLFac:cProp1, 1, 4 ) )

               ::oDbfFacLGst:Save()

            end if

            ::aMtrIndices[ 9 ]:Set( ::oDbfFacLFac:Recno() )

            ::oDbfFacLFac:Skip()

         end while

         /*
         Pasamos las incidencias-----------------------------------------------
         */
         
         ::aMtrIndices[ 9 ]:SetTotal( ::oDbfFacCFac:LastRec() )

         ::oDbfFacCFac:GoTop()
         while !( ::oDbfFacCFac:eof() )

            if ::oDbfFacCFac:cSerie == "A" .or. ::oDbfFacCFac:cSerie == "B"

               ::oDbfFacIGst:Append()

               ::oDbfFacIGst:cSerie       := ::oDbfFacCFac:cSerie
               ::oDbfFacIGst:nNumFac      := ::oDbfFacCFac:nNumFac
               ::oDbfFacIGst:mDesInc      := ::oDbfFacCFac:cComent

               ::oDbfFacIGst:Save()

            end if

            ::aMtrIndices[ 9 ]:Set( ::oDbfFacCFac:Recno() )

            ::oDbfFacCFac:Skip()

         end while

      end if

      /*
      Importamos facturas rectificativas---------------------------------------
      */

      if ::aLgcIndices[ 17 ]

         ::aMtrIndices[ 17 ]:SetTotal( ::oDbfFacTFac:LastRec() )

         ::oDbfFacTFac:GoTop()
         while !( ::oDbfFacTFac:eof() )

            if ::oDbfFacTFac:cSerie == "R"

               while ::oDbfFacRecTGst:Seek( ::oDbfFacTFac:cSerie + Str( ::oDbfFacTFac:nNumFac, 9 ) )
                  ::oDbfFacRecTGst:Delete( .f. )
               end if

               while ::oDbfFacRecLGst:Seek( ::oDbfFacTFac:cSerie + Str( ::oDbfFacTFac:nNumFac, 9 ) )
                  ::oDbfFacRecLGst:Delete( .f. )
               end if

               while ::oDbfFacPGst:Seek( ::oDbfFacTFac:cSerie + Str( ::oDbfFacTFac:nNumFac, 9 ) )
                  ::oDbfFacPGst:Delete( .f. )
               end if

               ::oDbfFacRecTGst:Append()

               ::oDbfFacRecTGst:cSerie          := ::oDbfFacTFac:cSerie
               ::oDbfFacRecTGst:nNumFac         := ::oDbfFacTFac:nNumFac
               ::oDbfFacRecTGst:cSufFac         := Space( 2 )
               ::oDbfFacRecTGst:cTurFac         := cCurSesion()
               ::oDbfFacRecTGst:dFecFac         := ::oDbfFacTFac:dFecFac

               if !Empty( ::oDbfFacTFac:cCodCli )
                  ::oDbfFacRecTGst:cCodCli      := SpecialPadr( ::oDbfFacTFac:cCodCli, "0", RetNumCodCliEmp() )

                  if ::oDbfCliGst:Seek( SpecialPadr( ::oDbfFacTFac:cCodCli, "0", RetNumCodCliEmp() ) )
                     ::oDbfFacRecTGst:cNomCli   := ::oDbfCliGst:Titulo
                     ::oDbfFacRecTGst:cDirCli   := ::oDbfCliGst:Domicilio
                     ::oDbfFacRecTGst:cPobCli   := ::oDbfCliGst:Poblacion
                     ::oDbfFacRecTGst:cPrvCli   := ::oDbfCliGst:Provincia
                     ::oDbfFacRecTGst:cPosCli   := ::oDbfCliGst:CodPostal
                     ::oDbfFacRecTGst:cDniCli   := ::oDbfCliGst:Nif
                  end if
               else
                  ::oDbfFacRecTGst:cCodCli      := Space( 12 )
                  if ::oDbfFacDFac:Seek( ::oDbfFacTFac:cSerie + Str( ::oDbfFacTFac:nNumFac ) )
                     ::oDbfFacRecTGst:cNomCli   := Left( ::oDbfFacDFac:cNomCli, 50 )
                     ::oDbfFacRecTGst:cDirCli   := ::oDbfFacDFac:cDirCli
                     ::oDbfFacRecTGst:cPobCli   := Left( ::oDbfFacDFac:cPobCli, 35 )
                     if ::oDbfProvFac:Seek( ::oDbfFacDFac:cCodProv )
                        ::oDbfFacRecTGst:cPrvCli  := ::oDbfProvFac:cNomProv
                     end if
                     ::oDbfFacRecTGst:cPosCli   := Left( ::oDbfFacDFac:cPtlCli, 7 )
                     ::oDbfFacRecTGst:cDniCli   := ::oDbfFacDFac:cDniCif
                  end if
               end if

               ::oDbfFacRecTGst:cCodAlm         := ::oDbfFacTFac:cCodAlm
               ::oDbfFacRecTGst:cCodCaj         := "000"
               ::oDbfFacRecTGst:cCodAge         := SpecialPadr( ::oDbfFacTFac:cCodAge, '0' )
               ::oDbfFacRecTGst:nPctComAge      := ::oDbfFacTFac:nComision
               ::oDbfFacRecTGst:lLiquidada      := .f.
               ::oDbfFacRecTGst:lConTab         := ::oDbfFacTFac:lConTab
               ::oDbfFacRecTGst:dFecEnt         := ::oDbfFacTFac:dFecEnt
               ::oDbfFacRecTGst:cSuFac          := ::oDbfFacTFac:cSuPed
               ::oDbfFacRecTGst:cCondEnt        := Left( ::oDbfFacTFac:cCondEnt, 2 )
               ::oDbfFacRecTGst:mObserv         := Left( ::oDbfFacTFac:cObsErv, 10 )
               ::oDbfFacRecTGst:cCodPago        := ::oDbfFacTFac:cCodPago
               ::oDbfFacRecTGst:nBulTos         := ::oDbfFacTFac:nBulTos
               ::oDbfFacRecTGst:nPorTes         := ::oDbfFacTFac:nPorTes
               ::oDbfFacRecTGst:nTipoFac        := ::oDbfFacTFac:nTipoFac
               ::oDbfFacRecTGst:nDtoEsp         := ::oDbfFacTFac:nDtoEsp
               ::oDbfFacRecTGst:nDpp            := ::oDbfFacTFac:nDpp
               ::oDbfFacRecTGst:nTipoIva        := ::oDbfFacTFac:nTipoIva
               ::oDbfFacRecTGst:nPorcIva        := ::oDbfFacTFac:nPorcIva
               ::oDbfFacRecTGst:lRecargo        := ::oDbfFacTFac:lRecargo
               ::oDbfFacRecTGst:lIvaInc         := ::oDbfFacTFac:lIvaIncl
               ::oDbfFacRecTGst:cDivFac         := ::oDbfFacTFac:cCodDiv
               ::oDbfFacRecTGst:nVdvFac         := 1
               ::oDbfFacRecTGst:cCodTrn         := ::oDbfFacTFac:cCodTran

               ::oDbfFacRecTGst:cNumFac         := SubStr( ::oDbfFacTFac:cNumFacRec, 1, 1 ) +  SubStr( ::oDbfFacTFac:cNumFacRec, 3, 9 )

               ::oDbfFacRecTGst:Save()

            end if

         ::aMtrIndices[ 17 ]:Set( ::oDbfFacTFac:Recno() )

         ::oDbfFacTFac:Skip()

         end while

         ::aMtrIndices[ 17 ]:SetTotal( ::oDbfRecFac:LastRec() )

         ::oDbfRecFac:GoTop()
         while !( ::oDbfRecFac:eof() )

            if ::oDbfRecFac:cSerie == "R"

               ::oDbfFacPGst:Append()

               ::oDbfFacPGst:cSerie         := ::oDbfRecFac:cSerie
               ::oDbfFacPGst:nNumFac        := ::oDbfRecFac:nNumFac
               ::oDbfFacPGst:cSufFac        := Space( 2 )
               ::oDbfFacPGst:nNumRec        := Val( ::oDbfRecFac:cContador )
               ::oDbfFacPGst:cCodCaj        := "000"
               ::oDbfFacPGst:cTurRec        := cCurSesion()
               if !Empty( ::oDbfRecFac:cCodCli )
                  ::oDbfFacPGst:cCodCli     := SpecialPadr( ::oDbfRecFac:cCodCli, "0", RetNumCodCliEmp() )
               else
                  ::oDbfFacPGst:cCodCli      := cDefCli()
               end if
               ::oDbfFacPGst:dEntrada       := ::oDbfRecFac:dFecEmis
               ::oDbfFacPGst:nImporte       := ::oDbfRecFac:nImporte
               ::oDbfFacPGst:dPreCob        := ::oDbfRecFac:dFecExped
               ::oDbfFacPGst:cDocPgo        := ::oDbfRecFac:cTipoDoc
               ::oDbfFacPGst:lCobrado       := ( ::oDbfRecFac:nEstado == 2 )
               ::oDbfFacPGst:cDivPgo        := ::oDbfRecFac:cCodDiv
               ::oDbfFacPGst:nVdvPgo        := 1
               ::oDbfFacPGst:lConPgo        := ::oDbfRecFac:lDocContab
               ::oDbfFacPGst:nImpEur        := ::oDbfRecFac:nImporte
               ::oDbfFacPGst:lImpEur        := .t.
               ::oDbfFacPGst:nNumRem        := ::oDbfRecFac:nNumRem
               ::oDbfFacPGst:cCtaRem        := ::oDbfRecFac:cCtaRem
               ::oDbfFacPGst:dFecVto        := ::oDbfRecFac:dFecVcto
               ::oDbfFacPGst:cTipRec        := "R"

               ::oDbfFacPGst:Save()

            end if

            ::aMtrIndices[ 17 ]:Set( ::oDbfRecFac:Recno() )

            ::oDbfRecFac:Skip()

         end while

         ::aMtrIndices[ 17 ]:SetTotal( ::oDbfFacLFac:LastRec() )

         ::oDbfFacLFac:GoTop()
         while !( ::oDbfFacLFac:eof() )

            if ::oDbfFacLFac:cSerie == "R"

               ::oDbfFacRecLGst:Append()

               ::oDbfFacRecLGst:cSerie       := ::oDbfFacLFac:cSerie
               ::oDbfFacRecLGst:nNumFac      := ::oDbfFacLFac:nNumFac
               ::oDbfFacRecLGst:cSufFac      := Space( 2 )
               ::oDbfFacRecLGst:cRef         := ::oDbfFacLFac:cRef
               if Empty( ::oDbfFacRecLGst:cRef )
                  ::oDbfFacRecLGst:mLngDes   := ::oDbfFacLFac:cDetalle
               else
                  ::oDbfFacRecLGst:cDetalle  := ::oDbfFacLFac:cDetalle
               end if
               ::oDbfFacRecLGst:nPreUnit     := ::oDbfFacLFac:nPreUnit
               ::oDbfFacRecLGst:nDto         := ::oDbfFacLFac:nDto
               ::oDbfFacRecLGst:nIva         := ::oDbfFacLFac:nIva
               ::oDbfFacRecLGst:lConTrol     := ::oDbfFacLFac:lConTrol
               ::oDbfFacRecLGst:nComAge      := ::oDbfFacLFac:nComision
               ::oDbfFacRecLGst:nUniCaja     := ::oDbfFacLFac:nCanEnt
               ::oDbfFacRecLGst:dFecAlb      := ::oDbfFacLFac:dFecAlb

               ::oDbfFacRecLGst:Save()

            end if

            ::aMtrIndices[ 17 ]:Set( ::oDbfFacLFac:Recno() )

            ::oDbfFacLFac:Skip()

         end while

         /*
         Trasbase de lineas de Clientes-------------------------------------------
         */

         /*::oDbfFacLGst:GoTop()
         while !( ::oDbfFacLGst:eof() )

            if ::oDbfFacTGst:Seek( ::oDbfFacLGst:cSerie + Str( ::oDbfFacLGst:nNumFac, 9 ) ) .and. ::oDbfFacTGst:nTipoIva != 1
               ::oDbfFacLGst:Load()
               ::oDbfFacLGst:nIva      := 0
               ::oDbfFacLGst:Save()
            end if

            ::oDbfFacLGst:Skip()

         end while*/

      end if

      /*
      Trasbase de Tikets de Clientes----------------------------
      */

      if ::aLgcIndices[ 10 ]

         //::oDbfTikTGst:Zap()

         while !::oDbfTikTGst:Eof()
            ::oDbfTikTGst:Delete( .f. )
            ::oDbfTikTGst:Skip()
         end if

         while !::oDbfTikLGst:Eof()
            ::oDbfTikLGst:Delete( .f. )
            ::oDbfTikLGst:Skip()
         end if

         while !::oDbfTikPGst:Eof()
            ::oDbfTikPGst:Delete( .f. )
            ::oDbfTikPGst:Skip()
         end if

         ::aMtrIndices[ 10 ]:SetTotal( ::oDbfTikTFac:LastRec() )

         ::oDbfTikTFac:GoTop()
         while !( ::oDbfTikTFac:eof() )

            if ::oDbfTikTFac:nEstado == 3

            ::oDbfTikTGst:Append()

            ::oDbfTikTGst:cSerTik      := "A"
            ::oDbfTikTGst:cNumTik      := Str( ::oDbfTikTFac:nNumTicket, 10 )
            ::oDbfTikTGst:cSufTik      := RetSufEmp()
            ::oDbfTikTGst:cTipTik      := SAVVAL
            ::oDbfTikTGst:cTurTik      := cCurSesion()
            ::oDbfTikTGst:dFecTik      := ::oDbfTikTFac:dFecha
            ::oDbfTikTGst:cHorTik      := ::oDbfTikTFac:cTime
            ::oDbfTikTGst:cNcjTik      := "000"
            ::oDbfTikTGst:cAlmTik      := ::oDbfTikTFac:cCodAlm
            ::oDbfTikTGst:cCliTik      := SpecialPadr( ::oDbfTikTFac:cCodCli, "0", RetNumCodCliEmp() )
            ::oDbfTikTGst:nTarifa      := 1
            if ::oDbfCliGst:Seek( SpecialPadr( ::oDbfTikTFac:cCodCli, "0", RetNumCodCliEmp() ) )
               ::oDbfTikTGst:cNomTik   := ::oDbfCliGst:Titulo
               ::oDbfTikTGst:cDirCli   := ::oDbfCliGst:Domicilio
               ::oDbfTikTGst:cPobCli   := ::oDbfCliGst:Poblacion
               ::oDbfTikTGst:cPrvCli   := ::oDbfCliGst:Provincia
               ::oDbfTikTGst:cPosCli   := ::oDbfCliGst:CodPostal
               ::oDbfTikTGst:cDniCli   := ::oDbfCliGst:Nif
            end if
            ::oDbfTikTGst:cFpgTik      := ::oDbfTikTFac:cCodPago
            ::oDbfTikTGst:cDivTik      := ::oDbfTikTFac:cCodDiv
            ::oDbfTikTGst:nVdvTik      := 1

            ::oDbfTikTGst:Save()

            ::oDbfTikLGst:Append()

            ::oDbfTikLGst:cSerTil      := "A"
            ::oDbfTikLGst:cNumTil      := Str( ::oDbfTikTFac:nNumTicket, 10 )
            ::oDbfTikLGst:cSufTil      := RetSufEmp()
            ::oDbfTikLGst:cCbaTil      := ""
            ::oDbfTikLGst:cNomTil      := "Vale"
            ::oDbfTikLGst:nPvpTil      := ::oDbfTikTFac:nTotal
            ::oDbfTikLGst:nUntTil      := 1
            ::oDbfTikLGst:nIvaTil      := 0

            ::oDbfTikLGst:Save()

            /*
            Pago automatico----------------------------------------------------
            */

            ::oDbfTikPGst:Append()

            ::oDbfTikPGst:cSerTik      := "A"
            ::oDbfTikPGst:cNumTik      := Str( ::oDbfTikTFac:nNumTicket, 10 )
            ::oDbfTikPGst:cSufTik      := RetSufEmp()
            ::oDbfTikPGst:nNumRec      := 1
            ::oDbfTikPGst:cCodCaj      := "000"
            ::oDbfTikPGst:dPgoTik      := ::oDbfTikTFac:dFecha
            ::oDbfTikPGst:nImpTik      := ::oDbfTikTFac:nTotal
            ::oDbfTikPGst:nDevTik      := 0
            ::oDbfTikPGst:cPgdPor      := Space( 50 )
            ::oDbfTikPGst:cDivPgo      := ::oDbfTikTFac:cCodDiv
            ::oDbfTikPGst:nVdvPgo      := 1
            ::oDbfTikPGst:lConPgo      := .t.
            ::oDbfTikPGst:cCtaPgo      := Space( 12 )
            ::oDbfTikPGst:lCloPgo      := .t.
            ::oDbfTikPGst:lSndPgo      := .f.
            ::oDbfTikPGst:cTurPgo      := cCurSesion()
            ::oDbfTikPGst:cCtaRec      := Space( 12 )

            ::oDbfTikPGst:Save()

            ::aMtrIndices[ 10 ]:Set( ::oDbfTikTFac:Recno() )

            end if

            ::oDbfTikTFac:Skip()

         end while

         /*
         Historico de tikets
         */

         ::aMtrIndices[ 10 ]:SetTotal( ::oDbfHisTFac:LastRec() )

         SysRefresh()

         ::oDbfHisTFac:GoTop()
         while !( ::oDbfHisTFac:eof() )

            ::oDbfTikTGst:Append()

            ::oDbfTikTGst:cSerTik      := ::oDbfHisTFac:cSerie
            ::oDbfTikTGst:cNumTik      := Str( ::oDbfHisTFac:nNumTicket, 10 )
            ::oDbfTikTGst:cSufTik      := RetSufEmp()
            ::oDbfTikTGst:cTipTik      := SAVTIK
            ::oDbfTikTGst:cTurTik      := cCurSesion()
            ::oDbfTikTGst:dFecTik      := ::oDbfHisTFac:dFecha
            ::oDbfTikTGst:cHorTik      := ::oDbfHisTFac:cTime
            ::oDbfTikTGst:cNcjTik      := "000"
            ::oDbfTikTGst:cAlmTik      := ::oDbfHisTFac:cCodAlm
            ::oDbfTikTGst:cCliTik      := SpecialPadr( ::oDbfHisTFac:cCodCli, "0", RetNumCodCliEmp() )
            ::oDbfTikTGst:nTarifa      := 1
            if ::oDbfCliGst:Seek( SpecialPadr( ::oDbfHisTFac:cCodCli, "0", RetNumCodCliEmp() ) )
               ::oDbfTikTGst:cNomTik   := ::oDbfCliGst:Titulo
               ::oDbfTikTGst:cDirCli   := ::oDbfCliGst:Domicilio
               ::oDbfTikTGst:cPobCli   := ::oDbfCliGst:Poblacion
               ::oDbfTikTGst:cPrvCli   := ::oDbfCliGst:Provincia
               ::oDbfTikTGst:cPosCli   := ::oDbfCliGst:CodPostal
               ::oDbfTikTGst:cDniCli   := ::oDbfCliGst:Nif
            end if
            ::oDbfTikTGst:cFpgTik      := ::oDbfHisTFac:cCodPago
            if ::oDbfHisTFac:FieldPos( "cCodDiv" ) != 0
               ::oDbfTikTGst:cDivTik   := ::oDbfHisTFac:cCodDiv
               ::oDbfTikTGst:nVdvTik   := 1
            else
               ::oDbfTikTGst:cDivTik   := cDivEmp()
               ::oDbfTikTGst:nVdvTik   := 1
            end if

            ::oDbfTikTGst:Save()

            /*
            Pago automatico----------------------------------------------------
            */

            ::oDbfTikPGst:Append()

            ::oDbfTikPGst:cSerTik      := ::oDbfHisTFac:cSerie
            ::oDbfTikPGst:cNumTik      := Str( ::oDbfHisTFac:nNumTicket, 10 )
            ::oDbfTikPGst:cSufTik      := RetSufEmp()
            ::oDbfTikPGst:nNumRec      := 1
            ::oDbfTikPGst:cCodCaj      := "000"
            ::oDbfTikPGst:dPgoTik      := ::oDbfHisTFac:dFecha
            ::oDbfTikPGst:nImpTik      := ::oDbfHisTFac:nEntrega
            ::oDbfTikPGst:nDevTik      := 0
            ::oDbfTikPGst:cPgdPor      := Space( 50 )

            if ::oDbfHisTFac:FieldPos( "cCodDiv" ) != 0
               ::oDbfTikPGst:cDivPgo   := ::oDbfHisTFac:cCodDiv
               ::oDbfTikPGst:nVdvPgo   := 1
            else
               ::oDbfTikPGst:cDivPgo   := cDivEmp()
               ::oDbfTikPGst:nVdvPgo   := 1
            end if

            ::oDbfTikPGst:lConPgo      := .t.
            ::oDbfTikPGst:cCtaPgo      := Space( 12 )
            ::oDbfTikPGst:lCloPgo      := .t.
            ::oDbfTikPGst:lSndPgo      := .f.
            ::oDbfTikPGst:cTurPgo      := cCurSesion()
            ::oDbfTikPGst:cCtaRec      := Space( 12 )

            ::oDbfTikPGst:Save()

            ::oDbfHisTFac:Skip()

            ::aMtrIndices[ 10 ]:Set( ::oDbfHisTFac:OrdKeyNo() )

         end while

         ::aMtrIndices[ 10 ]:SetTotal( ::oDbfHisLFac:LastRec() )

         SysRefresh()

         ::oDbfHisLFac:GoTop()
         while !( ::oDbfHisLFac:eof() )

            /*
            Lineas de detalle--------------------------------------------------
            */

            ::oDbfTikLGst:Append()

            ::oDbfTikLGst:cSerTil      := ::oDbfHisLFac:cSerie
            ::oDbfTikLGst:cNumTil      := Str( ::oDbfHisLFac:nNumTicket, 10 )
            ::oDbfTikLGst:cSufTil      := RetSufEmp()
            ::oDbfTikLGst:cCbaTil      := ::oDbfHisLFac:cRef
            ::oDbfTikLGst:cNomTil      := ::oDbfHisLFac:cDetalle
            ::oDbfTikLGst:nPvpTil      := ::oDbfHisLFac:nPreUnit
            ::oDbfTikLGst:nUntTil      := ::oDbfHisLFac:nCant
            ::oDbfTikLGst:nIvaTil      := ::oDbfHisLFac:nIva
            ::oDbfTikLGst:nDtoLin      := ::oDbfHisLFac:nDto
            ::oDbfTikLGst:nDtoDiv      := ::oDbfHisLFac:nDtoLin

            ::oDbfTikLGst:Save()

            ::oDbfHisLFac:Skip()

            ::aMtrIndices[ 10 ]:Set( ::oDbfHisLFac:OrdKeyNo() )

         end while

      end if

      // Transpaso de cabeceras y lineas de movimientos de almacenes solo para Allgüelles

      if ::aLgcIndices[ 14 ]

         ::aMtrIndices[ 14 ]:SetTotal( ::oDbfTrnFac:LastRec() )

         SysRefresh()

         ::oDbfTrnFac:GoTop()
         while !( ::oDbfTrnFac:Eof() )

            ::oDbfTrnGst:Append()

            ::oDbfTrnGst:cCodTrn    := ::oDbfTrnFac:cCodTran
            ::oDbfTrnGst:cNomTrn    := ::oDbfTrnFac:cNomTran
            ::oDbfTrnGst:cDirTrn    := ::oDbfTrnFac:cDirTran
            ::oDbfTrnGst:cLocTrn    := ::oDbfTrnFac:cPobTran
            ::oDbfTrnGst:cCdpTrn    := ::oDbfTrnFac:cPtlTran
            ::oDbfTrnGst:cTlfTrn    := ::oDbfTrnFac:cTlfTran
            ::oDbfTrnGst:cFaxTrn    := ::oDbfTrnFac:cFaxTran

            ::oDbfTrnGst:Save()

            ::oDbfTrnFac:Skip()

            ::aMtrIndices[ 14 ]:Set( ::oDbfTrnFac:OrdKeyNo() )

         end while

      end if

      // Transpaso de cabeceras y lineas de movimientos de almacenes solo para Allgüelles

      if .f. //::aLgcIndices[ 13 ] .and. ::oDbfMovTGst != nil .and. ::oDbfMovTFac != nil

         //::oDbfMovTGst:Zap()

         ::oDbfMovTFac:GoTop()
         while !( ::oDbfMovTFac:eof() )

            ::oDbfMovTGst:Append()

            nCounter                := Val( Left( ::oDbfMovTFac:cHora, 2 ) + Right( ::oDbfMovTFac:cHora, 2 ) )

            ::oDbfMovTGst:nNumRem   := nCounter
            //::oDbfMovTGst:cSufRem   :=
            //::oDbfMovTGst:cNumRem   :=
            ::oDbfMovTGst:nTipMov   := 1
            //::oDbfMovTGst:cTipMov   :=
            ::oDbfMovTGst:cCodUsr   := cCurUsr()
            //::oDbfMovTGst:cCodMov   :=
            ::oDbfMovTGst:dFecRem   := ::oDbfMovTFac:dFecha
            ::oDbfMovTGst:cAlmOrg   := ::oDbfMovTFac:cAlmOri
            ::oDbfMovTGst:cAlmDes   := ::oDbfMovTFac:cAlmDes
            ::oDbfMovTGst:cCodDiv   := cDivEmp()
            ::oDbfMovTGst:nVdvDiv   := 1
            ::oDbfMovTGst:cComMov   := ::oDbfMovTFac:cMotivo
            ::oDbfMovTGst:cCodAge   := ::oDbfMovTFac:cCodAge

               ::oDbfMovLFac:GoTop()
               while !::oDbfMovLFac:Eof()

                  if ::oDbfMovLFac:cHora + dtos( ::oDbfMovLFac:dFecha ) == ::oDbfMovTFac:cHora + dtos( ::oDbfMovTFac:dFecha )

                     ::oDbfMovLGst:Append()

                     ::oDbfMovLGst:dFecMov   := ::oDbfMovLFac:dFecha
                     ::oDbfMovLGst:nTipMov   := 1
                     ::oDbfMovLGst:cAliMov   := ::oDbfMovTFac:cAlmOri
                     ::oDbfMovLGst:cAloMov   := ::oDbfMovTFac:cAlmDes
                     ::oDbfMovLGst:cRefMov   := ::oDbfMovLFac:cRef
                     ::oDbfMovLGst:nUndMov   := ::oDbfMovLFac:nCanEnt
                     ::oDbfMovLGst:nPreDiv   := ::oDbfMovLFac:nPreUnit
                     ::oDbfMovLGst:cUsrMov   := cCurUsr()
                     ::oDbfMovLGst:nNumRem   := nCounter

                     ::oDbfMovLGst:Save()

                  end if

                  ::oDbfMovLFac:Skip()

            end while

            ::oDbfMovTGst:Save()

            ::oDbfMovTFac:Skip()

            SysRefresh()

         end while

      end if

      /*
      Trasbase de predidos a proveedor-----------------------------------------
      */

      if ::aLgcIndices[ 22 ]

         ::aMtrIndices[ 22 ]:SetTotal( ::oDbfPepTFac:LastRec() )

         ::oDbfPepTFac:GoTop()
         while !( ::oDbfPepTFac:eof() )

            while ::oDbfPepTGst:Seek( "A" + Str( ::oDbfPepTFac:nNumPed, 9 ) )
               ::oDbfPepTGst:Delete( .f. )
            end

            while ::oDbfPepLGst:Seek( "A" + Str( ::oDbfPepTFac:nNumPed, 9 ) )
               ::oDbfPepLGst:Delete( .f. )
            end

            ::oDbfPepTGst:Append()

            ::oDbfPepTGst:cSerPed      := "A"
            ::oDbfPepTGst:nNumPed      := ::oDbfPepTFac:nNumPed
            ::oDbfPepTGst:cSufPed      := Space( 2 )
            ::oDbfPepTGst:cTurPed      := cCurSesion()
            ::oDbfPepTGst:dFecPed      := ::oDbfPepTFac:dFecPed
            ::oDbfPepTGst:cCodAlm      := ::oDbfPepTFac:cCodAlm
            ::oDbfPepTGst:cCodPrv      := SpecialPadr( ::oDbfPepTFac:cCodPro, "0", RetNumCodPrvEmp() )
            ::oDbfPepTGst:cCodCaj      := "000"
            ::oDbfPepTGst:cCodPgo      := ::oDbfPepTFac:cCodPago
            ::oDbfPepTGst:cObsErv      := ::oDbfPepTFac:cObserv
            ::oDbfPepTGst:nEstado      := if( ::oDbfPepTFac:cEstado == "T", 3, 1 )
            
            if ::oDbfPrvGst:Seek( SpecialPadr( ::oDbfPepTFac:cCodPro, "0", RetNumCodPrvEmp() ) )
               ::oDbfPepTGst:cNomPrv   := ::oDbfPrvGst:Titulo
               ::oDbfPepTGst:cDirPrv   := ::oDbfPrvGst:Domicilio
               ::oDbfPepTGst:cPobPrv   := ::oDbfPrvGst:Poblacion
               ::oDbfPepTGst:cProPrv   := ::oDbfPrvGst:Provincia  
               ::oDbfPepTGst:cPosPrv   := ::oDbfPrvGst:CodPostal
               ::oDbfPepTGst:cDniPrv   := ::oDbfPrvGst:Nif
            end if

            ::oDbfPepTGst:cDpp         := "Descuento"
            ::oDbfPepTGst:cDtoEsp      := "Descuento"
            ::oDbfPepTGst:cDivPed      := ::oDbfPepTFac:cCodDiv
            ::oDbfPepTGst:nVdvPed      := 1

            ::oDbfPepTGst:Save()

            ::aMtrIndices[ 22 ]:Set( ::oDbfPepTFac:Recno() )

            ::oDbfPepTFac:Skip()

         end while

         ::aMtrIndices[ 22 ]:SetTotal( ::oDbfPepLFac:LastRec() )

         ::oDbfPepLGst:OrdSetFocus( "nNumLin" )

         ::oDbfPepLFac:GoTop()

         while !( ::oDbfPepLFac:eof() )

            n := aScan( aTemporalLineas, {|o| o:nNumPed == ::oDbfPepLFac:nNumPed .and. o:nNumLin == ::oDbfPepLFac:nServicio } )

            if n == 0

               oTemporal               := SLineasPedidos()
               oTemporal:cSerPed       := "A"  
               oTemporal:nNumPed       := ::oDbfPepLFac:nNumPed   
               oTemporal:cSufPed       := Space( 2 )
               oTemporal:cRef          := ::oDbfPepLFac:cRef
               if Empty( ::oDbfPepLFac:cRef )
                  oTemporal:mLngDes    := ::oDbfPepLFac:cDetalle
                  oTemporal:cDetalle   := Space( 250 )
               else
                  oTemporal:cDetalle   := ::oDbfPepLFac:cDetalle
               end if
               oTemporal:nUniCaja      := ::oDbfPepLFac:nCanPed
               oTemporal:nPreDiv       := ::oDbfPepLFac:nPreDiv
               oTemporal:cLote         := ::oDbfPepLFac:cLote
               oTemporal:nNumLin       := ::oDbfPepLFac:nServicio

               aAdd( aTemporalLineas, oTemporal )   

            else
            
               if Empty( aTemporalLineas[n]:mLngDes )
                  aTemporalLineas[n]:mLngDes := ::oDbfPepLFac:cDetalle   
               else
                  aTemporalLineas[n]:mLngDes += ::oDbfPepLFac:cDetalle
               end if

               if aTemporalLineas[n]:nUniCaja == 0
                  aTemporalLineas[n]:nUniCaja := ::oDbfPepLFac:nCanPed
               end if

               if aTemporalLineas[n]:nPreDiv == 0
                  aTemporalLineas[n]:nPreDiv := ::oDbfPepLFac:nPreDiv
               end if

            end if   

            ::aMtrIndices[ 22 ]:Set( ::oDbfPepLFac:Recno() )

            ::oDbfPepLFac:Skip()

         end while

         /*
         Pasamos los datos del array a la base de datos------------------------
         */

         for each aLinea in aTemporalLineas

            ::oDbfPepLGst:Append()

            ::oDbfPepLGst:cSerPed      := aLinea:cSerPed
            ::oDbfPepLGst:nNumPed      := aLinea:nNumPed
            ::oDbfPepLGst:cSufPed      := aLinea:cSufPed
            ::oDbfPepLGst:cRef         := aLinea:cRef
            ::oDbfPepLGst:mLngDes      := aLinea:mLngDes 
            ::oDbfPepLGst:cDetalle     := aLinea:cDetalle
            ::oDbfPepLGst:nUniCaja     := aLinea:nUniCaja 
            ::oDbfPepLGst:nPreDiv      := aLinea:nPreDiv
            ::oDbfPepLGst:cLote        := aLinea:cLote
            ::oDbfPepLGst:nNumLin      := aLinea:nNumLin

            ::oDbfPepLGst:Save()

         next

      end if

      /* Trasbase de albaranes de compras */

      if ::aLgcIndices[ 15 ]

         /* Trasbase de cabeceras de albaranes de compras */

         ::aMtrIndices[ 15 ]:SetTotal( ::oDbfAlpTFac:LastRec() )

         ::oDbfAlpTFac:GoTop()
         while !( ::oDbfAlpTFac:eof() )

            /*Limpiamos las tablas para que no se dupliquen*/

            while ::oDbfAlpTGst:Seek( ::oDbfAlpTFac:cSerie + Str( ::oDbfAlpTFac:nNumAlb, 9 ) )
               ::oDbfAlpTGst:Delete( .f. )
            end if

            while ::oDbfAlpLGst:Seek( ::oDbfAlpTFac:cSerie + Str( ::oDbfAlpTFac:nNumAlb, 9 ) )
               ::oDbfAlpLGst:Delete( .f. )
            end if

            ::oDbfAlpTGst:Append()

            ::oDbfAlpTGst:cSerAlb      := ::oDbfAlpTFac:cSerie
            ::oDbfAlpTGst:nNumAlb      := ::oDbfAlpTFac:nNumAlb
            ::oDbfAlpTGst:cSufAlb      := Space( 2 )
            ::oDbfAlpTGst:cTurAlb      := cCurSesion()
            ::oDbfAlpTGst:dFecAlb      := ::oDbfAlpTFac:dFecAlb
            ::oDbfAlpTGst:cCodAlm      := ::oDbfAlpTFac:cCodAlm
            ::oDbfAlpTGst:cCodCaj      := cDefCaj()
            ::oDbfAlpTGst:cCodPrv      := SpecialPadr( ::oDbfAlpTFac:cCodPro, "0", RetNumCodPrvEmp() )
            if ::oDbfPrvGst:Seek( SpecialPadr( ::oDbfAlpTFac:cCodPro, "0", RetNumCodPrvEmp() ) )
               ::oDbfAlpTGst:cNomPrv      := ::oDbfPrvGst:Titulo
               ::oDbfAlpTGst:cDirPrv      := ::oDbfPrvGst:Domicilio
               ::oDbfAlpTGst:cPobPrv      := ::oDbfPrvGst:Poblacion
               ::oDbfAlpTGst:cProPrv      := ::oDbfPrvGst:Provincia
               ::oDbfAlpTGst:cPosPrv      := ::oDbfPrvGst:CodPostal
               ::oDbfAlpTGst:cDniPrv      := ::oDbfPrvGst:Nif
            end if
            ::oDbfAlpTGst:dFecEnt      := ::oDbfAlpTFac:dFecEnt
            ::oDbfAlpTGst:cSuAlb       := ::oDbfAlpTFac:SuAlbaran
            ::oDbfAlpTGst:cCodPgo      := ::oDbfAlpTFac:cCodPago
            ::oDbfAlpTGst:nPortes      := ::oDbfAlpTFac:nPortes
            ::oDbfAlpTGst:lFacturado   := ::oDbfAlpTFac:lFacturado
            ::oDbfAlpTGst:cNumFac      := ::oDbfAlpTFac:cFactura
            ::oDbfAlpTGst:cDivAlb      := ::oDbfAlpTFac:cCodDiv
            ::oDbfAlpTGst:nVdvAlb      := ::oDbfAlpTFac:nValDiv
            ::oDbfAlpTGst:lSndDoc      := .f.
            ::oDbfAlpTGst:cCodUsr      := cCurUsr()
            ::oDbfAlpTGst:dFecChg      := GetSysDate()
            ::oDbfAlpTGst:cTimChg      := Time()

            ::oDbfAlpTGst:Save()

         ::aMtrIndices[ 15 ]:Set( ::oDbfAlpTFac:Recno() )

         ::oDbfAlpTFac:Skip()

         end while

         /* Trasbase de líneas de albaranes de compras */

         ::aMtrIndices[ 15 ]:SetTotal( ::oDbfAlpLFac:LastRec() )

         ::oDbfAlpLFac:GoTop()
         while !( ::oDbfAlpLFac:eof() )

            ::oDbfAlpLGst:Append()

            /*Buscamos la serie del documento en la cabecera, la que factuplus
            no guarda la serie en las lineas de los albaranes*/

            ::oDbfAlpTGst:GoTop()

            while !::oDbfAlpTGst:Eof()

               if ::oDbfAlpTGst:nNumAlb == ::oDbfAlpLFac:nNumAlb
                  ::oDbfAlpLGst:cSerAlb      := ::oDbfAlpTGst:cSerAlb
               end if

               ::oDbfAlpTGst:Skip()

            end while

            ::oDbfAlpLGst:nNumAlb      := ::oDbfAlpLFac:nNumAlb
            ::oDbfAlpLGst:cSufAlb      := Space( 2 )
            ::oDbfAlpLGst:cRef         := ::oDbfAlpLFac:cRef
            ::oDbfAlpLGst:cDetalle     := ::oDbfAlpLFac:cDetalle
            ::oDbfAlpLGst:nIva         := ::oDbfAlpLFac:nIvaServ
            ::oDbfAlpLGst:nUniCaja     := ::oDbfAlpLFac:nCanEnt
            ::oDbfAlpLGst:nCanEnt      := ::oDbfAlpLFac:nUnidades
            ::oDbfAlpLGst:nPreDiv      := ::oDbfAlpLFac:nPreDiv
            ::oDbfAlpLGst:nDtoLin      := ::oDbfAlpLFac:nDto
            ::oDbfAlpLGst:nNumLin      := ::oDbfAlpLFac:nLinea
            ::oDbfAlpLGst:lControl     := ::oDbfAlpLFac:lControl
            
            /*
            Solo importación ayamonte------------------------------------------
            */

            ::oDbfAlpLGst:lLote        := !Empty( ::oDbfAlpLFac:cProp2 )
            ::oDbfAlpLGst:cLote        := ::oDbfAlpLFac:cProp2
            ::oDbfAlpLGst:dFecCad      := cTod( SubStr( ::oDbfAlpLFac:cProp1, 8, 2 ) + "/" + SubStr( ::oDbfAlpLFac:cProp1, 6, 2 ) + "/" + SubStr( ::oDbfAlpLFac:cProp1, 1, 4 ) )

            ::oDbfAlpLGst:Save()

            ::aMtrIndices[ 15 ]:Set( ::oDbfAlpLFac:Recno() )

            ::oDbfAlpLFac:Skip()

         end while

         /*
         Hacemos para que pasen los totales------------------------------------
         */
         
         ::oDbfAlpTGst:GoTop()

         while !::oDbfAlpTGst:Eof()

            aTotAlb                 := aTotAlbPrv( ::oDbfAlpTGst:cSerAlb + Str( ::oDbfAlpTGst:nNumAlb ) + ::oDbfAlpTGst:cSufAlb, ::oDbfAlpTGst:cAlias, ::oDbfAlpLGst:cAlias, ::oDbfIvaGst:cAlias, ::oDbfDiv:cAlias, ::oDbfAlpTGst:cDivAlb )

            ::oDbfAlpTGst:Load()

            ::oDbfAlpTGst:nTotNet := aTotAlb[1]
            ::oDbfAlpTGst:nTotIva := aTotAlb[2]
            ::oDbfAlpTGst:nTotReq := aTotAlb[3]
            ::oDbfAlpTGst:nTotAlb := aTotAlb[4]

            ::oDbfAlpTGst:Save()            

            ::oDbfAlpTGst:Skip()

         end while

      end if

      /*
      Trasbase de Facturas de proveedores----------------------------
      */

      if ::aLgcIndices[ 16 ]

         /* Cabeceras de Facturas*/

         ::aMtrIndices[ 16 ]:SetTotal( ::oDbfFapTFac:LastRec() )

         ::oDbfFapTFac:GoTop()
         while !( ::oDbfFapTFac:eof() )

            /*Limpiamos las bases de datos para no dejar duplicados*/

            while ::oDbfFapTGst:Seek( ::oDbfFapTFac:cSerie + Str( ::oDbfFapTFac:nNumFac, 9 ) )
               ::oDbfFapTGst:Delete( .f. )
            end if

            while ::oDbfFapLGst:Seek( ::oDbfFapTFac:cSerie + Str( ::oDbfFapTFac:nNumFac, 9 ) )
               ::oDbfFapLGst:Delete( .f. )
            end if

            while ::oDbfFapPGst:Seek( ::oDbfFapTFac:cSerie + Str( ::oDbfFapTFac:nNumFac, 9 ) )
               ::oDbfFapPGst:Delete( .f. )
            end if

            ::oDbfFapTGst:Append()

            ::oDbfFapTGst:cSerFac    := ::oDbfFapTFac:cSerie
            ::oDbfFapTGst:nNumFac    := ::oDbfFapTFac:nNumFac
            ::oDbfFapTGst:cSufFac    := Space( 2 )
            ::oDbfFapTGst:cTurFac    := cCurSesion()
            ::oDbfFapTGst:dFecFac    := ::oDbfFapTFac:dFecFac
            ::oDbfFapTGst:cCodAlm    := ::oDbfFapTFac:cCodAlm
            ::oDbfFapTGst:cCodCaj    := cDefCaj()
            ::oDbfFapTGst:cCodPrv    := SpecialPadr( ::oDbfFapTFac:cCodPro, "0", RetNumCodPrvEmp() )
            if ::oDbfPrvGst:Seek( SpecialPadr( ::oDbfFapTFac:cCodPro, "0", RetNumCodPrvEmp() ) )
               ::oDbfFapTGst:cNomPrv      := ::oDbfPrvGst:Titulo
               ::oDbfFapTGst:cDirPrv      := ::oDbfPrvGst:Domicilio
               ::oDbfFapTGst:cPobPrv      := ::oDbfPrvGst:Poblacion
               ::oDbfFapTGst:cProvProv    := ::oDbfPrvGst:Provincia
               ::oDbfFapTGst:cPosPrv      := ::oDbfPrvGst:CodPostal
               ::oDbfFapTGst:cDniPrv      := ::oDbfPrvGst:Nif
            end if
            ::oDbfFapTGst:lConTab    := ::oDbfFapTFac:lContab
            ::oDbfFapTGst:dFecEnt    := ::oDbfFapTFac:dFecEnt
            ::oDbfFapTGst:cSuPed     := ::oDbfFapTFac:cSuPed
            ::oDbfFapTGst:cConDent   := ::oDbfFapTFac:cCondEnt
            ::oDbfFapTGst:cExPed     := ::oDbfFapTFac:cExPed
            ::oDbfFapTGst:cObserv    := ::oDbfFapTFac:cObserv
            ::oDbfFapTGst:cCodPago   := ::oDbfFapTFac:cCodPago
            ::oDbfFapTGst:nBultos    := ::oDbfFapTFac:nBultos
            ::oDbfFapTGst:nPortes    := ::oDbfFapTFac:nPortes
            ::oDbfFapTGst:lLiquidada := .f.
            ::oDbfFapTGst:cNumAlb    := ::oDbfFapTFac:cSerie + Str( ::oDbfFapTFac:nNumAlb, 9 )
            ::oDbfFapTGst:cSufAlb    := Space( 2 )
            ::oDbfFapTGst:cDtoEsp    := Padr( "General", 50 )
            ::oDbfFapTGst:nDtoEsp    := ::oDbfFapTFac:nDtoEsp
            ::oDbfFapTGst:cDpp       := Padr( "Pronto pago", 50 )
            ::oDbfFapTGst:nDpp       := ::oDbfFapTFac:nDpp
            ::oDbfFapTGst:lRecargo   := ::oDbfFapTFac:lRecargo
            ::oDbfFapTGst:nIrpf      := ::oDbfFapTFac:nIrpf
            ::oDbfFapTGst:cDivFac    := ::oDbfFapTFac:cCodDiv
            ::oDbfFapTGst:nVdvFac    := ::oDbfFapTFac:nValDiv
            ::oDbfFapTGst:lSndDoc    := .f.
            ::oDbfFapTGst:cCodUsr    := cCurUsr()
            ::oDbfFapTGst:dFecChg    := GetSysDate()
            ::oDbfFapTGst:cTimChg    := Time()

            ::oDbfFapTGst:Save()

         ::aMtrIndices[ 16 ]:Set( ::oDbfFapTFac:Recno() )

         ::oDbfFapTFac:Skip()

         end while

         /*Traspasamos recibos de proveedores*/

         ::oDbfFapPFac:GoTop()
         while !( ::oDbfFapPFac:eof() )

            ::oDbfFapPGst:Append()

            ::oDbfFapPGst:cSerFac   := ::oDbfFapPFac:cSerie
            ::oDbfFapPGst:nNumFac   := ::oDbfFapPFac:nNumFac
            ::oDbfFapPGst:cSufFac   := Space( 2 )
            ::oDbfFapPGst:nNumRec   := Val( ::oDbfFapPFac:cContador )
            ::oDbfFapPGst:cCodCaj   := cDefCaj()
            ::oDbfFapPGst:cCodPrv   := SpecialPadr( ::oDbfFapPFac:cCodPro, "0", RetNumCodPrvEmp() )
            ::oDbfFapPGst:dEntrada  := ::oDbfFapPFac:dFecExped
            ::oDbfFapPGst:nImporte  := ::oDbfFapPFac:nImporte
            ::oDbfFapPGst:dPreCob   := ::oDbfFapPFac:dFecVcto
            ::oDbfFapPGst:lCobrado  := ( ::oDbfFapPFac:nEstado == 2 )
            ::oDbfFapPGst:lConPgo   := ::oDbfFapPFac:lDocContab
            ::oDbfFapPGst:cDivPgo   := ::oDbfFapPFac:cCodDiv
            ::oDbfFapPGst:nVdvPgo   := ::oDbfFapPFac:nValDiv
            ::oDbfFapPGst:dFecVto   := ::oDbfFapPFac:dFecVcto
            ::oDbfFapPGst:cCodUsr   := cCurUsr()
            ::oDbfFapPGst:dFecChg   := GetSysDate()
            ::oDbfFapPGst:cTimChg   := Time()

            ::oDbfFapPGst:Save()

         ::aMtrIndices[ 16 ]:Set( ::oDbfFapPFac:Recno() )

         ::oDbfFapPFac:Skip()

         end while

         /*Lineas de facturas de proveedor*/

         ::aMtrIndices[ 16 ]:SetTotal( ::oDbfFapLFac:LastRec() )

         ::oDbfFapLFac:GoTop()
         while !( ::oDbfFapLFac:eof() )

            ::oDbfFapLGst:Append()

            if !Empty( ::oDbfFapLFac:cSerie )
               ::oDbfFapLGst:cSerFac := ::oDbfFapLFac:cSerie
            else
               ::oDbfFapLGst:cSerFac := "A"
            end if
            ::oDbfFapLGst:nNumFac    := ::oDbfFapLFac:nNumFac
            ::oDbfFapLGst:cSufFac    := Space( 2 )
            ::oDbfFapLGst:cRef       := ::oDbfFapLFac:cRef
            ::oDbfFapLGst:cDetalle   := ::oDbfFapLFac:cDetalle
            ::oDbfFapLGst:nPreUnit   := ::oDbfFapLFac:nPreUnit
            ::oDbfFapLGst:nIva       := ::oDbfFapLFac:nIva
            ::oDbfFapLGst:nCanEnt    := 1
            ::oDbfFapLGst:lControl   := ::oDbfFapLFac:lControl
            ::oDbfFapLGst:nUniCaja   := ::oDbfFapLFac:nCanEnt
            ::oDbfFapLGst:nDtoLin    := ::oDbfFapLFac:nDto

            /*
            Solo importación ayamonte------------------------------------------
            */

            ::oDbfFapLGst:lLote        := !Empty( ::oDbfFapLFac:cProp2 )
            ::oDbfFapLGst:cLote        := ::oDbfFapLFac:cProp2
            ::oDbfFapLGst:dFecCad      := cTod( SubStr( ::oDbfFapLFac:cProp1, 8, 2 ) + "/" + SubStr( ::oDbfFapLFac:cProp1, 6, 2 ) + "/" + SubStr( ::oDbfFapLFac:cProp1, 1, 4 ) )

            ::oDbfFapLGst:Save()

            ::aMtrIndices[ 16 ]:Set( ::oDbfFapLFac:Recno() )

            ::oDbfFapLFac:Skip()

         end while

         /*
         Hacemos para que pasen los totales------------------------------------
         */
         
         ::oDbfFapTGst:GoTop()

         while !::oDbfFapTGst:Eof()

            aTotFac                 := aTotFacPrv( ::oDbfFapTGst:cSerFac + Str( ::oDbfFapTGst:nNumFac ) + ::oDbfFapTGst:cSufFac, ::oDbfFapTGst:cAlias, ::oDbfFapLGst:cAlias, ::oDbfIvaGst:cAlias, ::oDbfDiv:cAlias, ::oDbfFapPGst:cAlias, ::oDbfFapTGst:cDivFac )

            ::oDbfFapTGst:Load()

            ::oDbfFapTGst:nTotNet := aTotFac[1]
            ::oDbfFapTGst:nTotIva := aTotFac[2]
            ::oDbfFapTGst:nTotReq := aTotFac[3]
            ::oDbfFapTGst:nTotFac := aTotFac[4]

            ::oDbfFapTGst:Save()            

            ::oDbfFapTGst:Skip()

         end while

         /*
         Pasamos las incidencias-----------------------------------------------
         */
         
         ::aMtrIndices[ 16 ]:SetTotal( ::oDbfFapCFac:LastRec() )

         ::oDbfFapCFac:GoTop()
         while !( ::oDbfFapCFac:eof() )

            if ::oDbfFapCFac:cSerie == "A" .or. ::oDbfFapCFac:cSerie == "B"

               ::oDbfFapIGst:Append()

               ::oDbfFapIGst:cSerie       := ::oDbfFapCFac:cSerie
               ::oDbfFapIGst:nNumFac      := ::oDbfFapCFac:nNumFac
               ::oDbfFapIGst:mDesInc      := ::oDbfFapCFac:cComent

               ::oDbfFapIGst:Save()

            end if

            ::aMtrIndices[ 16 ]:Set( ::oDbfFapCFac:Recno() )

            ::oDbfFapCFac:Skip()

         end while

      end if

      ::CloseFiles()

      SynFacCli( cPatEmp() )
      SynFacRec( cPatEmp() )
      SynRecCli( cPatEmp() )

      msgInfo( "Traspaso realizado con éxito.", "Bienvenido a " + __GSTROTOR__ + Space( 1 ) + __GSTVERSION__ )

      ::oDlg:end()
      ::oDlg:Enable()

   end if

   ::cPathFac  := Padr( ::cPathFac, 100 )

RETURN ( Self )

//---------------------------------------------------------------------------//

FUNCTION ImpFactu( oMenuItem, oWnd )

   local oImpFac
   local nLevel   := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return ( nil )
   end if

   oImpFac        := TImpFactu():New():Resource()

RETURN nil

//---------------------------------------------------------------------------//

METHOD SelectChk( lSet )

   local n

   for n := 1 to len( ::aLgcIndices )
      ::aLgcIndices[n] := lSet
      ::aChkIndices[n]:Refresh()
   next

RETURN ( Self )

//---------------------------------------------------------------------------//

Static Function SpecialPadr( cCadena, cChar, nLen )

Return( if( !Empty( cCadena ), Padr( RJust( cCadena, cChar, nLen ), 12, ' ' ), Space( 12 ) ) )


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SLineasPresupuestos

   DATA cSerPre
   DATA nNumPre
   DATA cSufPre
   DATA cRef
   DATA mLngDes
   DATA cDetalle
   DATA nIva
   DATA nUniCaja
   DATA nPreDiv
   DATA nDto
   DATA cLote
   DATA nNumLin

END CLASS

//---------------------------------------------------------------------------//

CLASS SLineasPedidos

   DATA cSerPed
   DATA nNumPed
   DATA cSufPed
   DATA cRef
   DATA mLngDes
   DATA cDetalle
   DATA nIva
   DATA nUniCaja
   DATA nPreDiv
   DATA nDto
   DATA cLote
   DATA nNumLin

END CLASS

//---------------------------------------------------------------------------//
