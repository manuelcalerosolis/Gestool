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

   METHOD Resource()

   METHOD Importar()

   METHOD SelectChk( lSet )


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

   ::cPathFac     := Space( 100 )

   ::aLgcIndices  := Afill( Array( 6 ), .t. )
   ::aChkIndices  := Array( 6 )
   ::aMtrIndices  := Array( 6 )
   ::aNumIndices  := Afill( Array( 6 ), 0 )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*Monta los recursos*/

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

   DEFINE DIALOG ::oDlg RESOURCE "IMPFACCOM" TITLE "Importación desde factucont ®" OF oWnd()

      REDEFINE GET oGet VAR ::cPathFac ID 100 BITMAP "FOLDER" ON HELP ( oGet:cText( cGetDir32( "Seleccione destino" ) ) ) OF ::oDlg

      REDEFINE BITMAP oBmp RESOURCE "ImportarFactucont" ID 600 OF ::oDlg

      REDEFINE CHECKBOX ::aChkIndices[ 1 ]   VAR ::aLgcIndices[ 1 ]  ID 110 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 2 ]   VAR ::aLgcIndices[ 2 ]  ID 120 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 3 ]   VAR ::aLgcIndices[ 3 ]  ID 130 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 4 ]   VAR ::aLgcIndices[ 4 ]  ID 150 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 5 ]   VAR ::aLgcIndices[ 5 ]  ID 160 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 6 ]   VAR ::aLgcIndices[ 6 ]  ID 170 of ::oDlg 

      REDEFINE METER ::aMtrIndices[ 1 ]      VAR ::aNumIndices[ 1 ]  ID 111 OF ::oDlg
      REDEFINE METER ::aMtrIndices[ 2 ]      VAR ::aNumIndices[ 2 ]  ID 121 OF ::oDlg
      REDEFINE METER ::aMtrIndices[ 3 ]      VAR ::aNumIndices[ 3 ]  ID 131 OF ::oDlg
      REDEFINE METER ::aMtrIndices[ 4 ]      VAR ::aNumIndices[ 4 ]  ID 151 OF ::oDlg
      REDEFINE METER ::aMtrIndices[ 5 ]      VAR ::aNumIndices[ 5 ]  ID 161 OF ::oDlg
      REDEFINE METER ::aMtrIndices[ 6 ]      VAR ::aNumIndices[ 6 ]  ID 171 OF ::oDlg

      REDEFINE BUTTON ID 500        OF ::oDlg ACTION ( ::SelectChk( .t. ) )
      REDEFINE BUTTON ID 501        OF ::oDlg ACTION ( ::SelectChk( .f. ) )

      REDEFINE BUTTON ID IDOK       OF ::oDlg ACTION ( ::Importar() )
      REDEFINE BUTTON ID IDCANCEL   OF ::oDlg ACTION ( ::oDlg:end() )
      REDEFINE BUTTON ID 998        OF ::oDlg ACTION ( msginfo( "Ayuda no definida", "Información" ) )

   ::oDlg:AddFastKey( VK_F1, {|| msginfo( "Ayuda no definida", "Información" ) } )
   ::oDlg:AddFastKey( VK_F5, {|| ::Importar() } )

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*Selecciona o deselecciona los checks*/

METHOD SelectChk( lSet )

   local n

   for n := 1 to len( ::aLgcIndices )
      ::aLgcIndices[n] := lSet
      ::aChkIndices[n]:Refresh()
   next

RETURN ( Self )

//---------------------------------------------------------------------------//
/*Proceso de importación*/

METHOD Importar()

   local nCount  := 0
   local nOrdAnt
   local cSerie := ""
   local nNumero := ""

   if ::OpenFiles()

      ::oDlg:Disable()

      /*Traspaso de Proveedor*/

      if ::aLgcIndices[ 1 ]

         /*
         Empezamos el trasbase de proveedores
         */

         ::aMtrIndices[ 1 ]:SetTotal( ::oDbfPrvFac:LastRec() )

         ::oDbfPrvFac:GoTop()
         while !( ::oDbfPrvFac:eof() )

            while ::oDbfPrvGst:Seek( ::oDbfPrvFac:Codigo )
               ::oDbfPrvGst:Delete( .f. )
            end while

            ::oDbfPrvGst:Append()

            ::oDbfPrvGst:Cod         := ::oDbfPrvFac:Codigo
            ::oDbfPrvGst:Titulo      := ::oDbfPrvFac:Nombre
            ::oDbfPrvGst:Nif         := ::oDbfPrvFac:Cif
            ::oDbfPrvGst:Domicilio   := ::oDbfPrvFac:Direccion
            ::oDbfPrvGst:Poblacion   := ::oDbfPrvFac:Ciudad
            ::oDbfPrvGst:cPerCto     := ::oDbfPrvFac:Contacto
            ::oDbfPrvGst:Telefono    := ::oDbfPrvFac:Telefono
            ::oDbfPrvGst:Fax         := ::oDbfPrvFac:Fax
            ::oDbfPrvGst:Movil       := ::oDbfPrvFac:Movil
            ::oDbfPrvGst:cMeiInt     := ::oDbfPrvFac:Correoe
            ::oDbfPrvGst:cWebInt     := ::oDbfPrvFac:Url
            ::oDbfPrvGst:nCopiasf    := 1
            ::oDbfPrvGst:cCodUsr     := cCurUsr()
            ::oDbfPrvGst:dFecChg     := GetSysDate()
            ::oDbfPrvGst:cTimChg     := Time()
            ::oDbfPrvGst:lBlqPrv     := .f.

            ::oDbfPrvGst:Save()

            ::aMtrIndices[ 1 ]:Set( ::oDbfPrvFac:Recno() )

            ::oDbfPrvFac:Skip()

         end while

      end if

      /*Traspaso de Clientes*/

      if ::aLgcIndices[ 2 ]

         /*
         Empezamos el trasbase de clientes
         */

         ::aMtrIndices[ 2 ]:SetTotal( ::oDbfCliFac:LastRec() )

         ::oDbfCliFac:GoTop()
         while !( ::oDbfCliFac:eof() )

            while ::oDbfCliGst:Seek( ::oDbfCliFac:Codigo )
               ::oDbfCliGst:Delete( .f. )
            end if

            ::oDbfCliGst:Append()
            ::oDbfCliGst:Blank()

            ::oDbfCliGst:Cod        := ::oDbfCliFac:Codigo
            ::oDbfCliGst:Titulo     := ::oDbfCliFac:Nombre
            ::oDbfCliGst:Nif        := ::oDbfCliFac:Cif
            ::oDbfCliGst:Domicilio  := ::oDbfCliFac:Direccion
            ::oDbfCliGst:Poblacion  := ::oDbfCliFac:Ciudad
            ::oDbfCliGst:Telefono   := ::oDbfCliFac:Telefono
            ::oDbfCliGst:Fax        := ::oDbfCliFac:Fax
            ::oDbfCliGst:Movil      := ::oDbfCliFac:Movil
            ::oDbfCliGst:nTipCli    := 1
            ::oDbfCliGst:CopiasF    := 1
            if ::oDbfCliFac:Exento
               ::oDbfCliGst:nRegIva := 3
            else
               ::oDbfCliGst:nRegIva := 1
            end if
            ::oDbfCliGst:lReq       := ::oDbfCliFac:Recargo
            ::oDbfCliGst:nTarifa    := ::oDbfCliFac:Tarifa
            ::oDbfCliGst:cMeiInt    := ::oDbfCliFac:Correoe
            ::oDbfCliGst:cWebInt    := ::oDbfCliFac:Url
            ::oDbfCliGst:cPerCto    := ::oDbfCliFac:Contacto
            ::oDbfCliGst:cCodAlm    := oUser():cAlmacen()
            ::oDbfCliGst:cCodUsr    := cCurUsr()
            ::oDbfCliGst:dFecChg    := GetSysDate()
            ::oDbfCliGst:cTimChg    := Time()
            ::oDbfCliGst:cDtoEsp    := Padr( "General", 50 )
            ::oDbfCliGst:cDpp       := Padr( "Pronto pago", 50 )
            ::oDbfCliGst:cDtoAtp    := Padr( "Atipico", 50 )
            ::oDbfCliGst:nDtoEsp    := ::oDbfCliFac:Descuento
            ::oDbfCliGst:lChgPre    := .t.

            //LLenamos la tabla de bancos de clientes

            if !Empty( ::oDbfCliFac:Ccc )


               ::oDbfCliGst:Banco   := ::oDbfCliFac:Domicilia
               ::oDbfCliGst:Cuenta  := ::oDbfCliFac:Ccc

               ::oDbfCliBnc:Append()

               ::oDbfCliBnc:cCodCli := ::oDbfCliFac:Codigo
               ::oDbfCliBnc:cCtaBnc := ::oDbfCliFac:Ccc
               ::oDbfCliBnc:lBncDef := .t.
               ::oDbfCliBnc:cCodBnc := ::oDbfCliFac:Domicilia

               ::oDbfCliBnc:Save()

            end if

            ::oDbfCliGst:Save()

            ::aMtrIndices[ 2 ]:Set( ::oDbfCliFac:Recno() )

            ::oDbfCliFac:Skip()

         end while

      end if

      /*Traspaso de artículos*/

      if ::aLgcIndices[ 3 ]

         /*Lo primero es meter las familias, ya que hay que crearles el código*/

         ::aMtrIndices[ 3 ]:SetTotal( ::oDbfArtFac:LastRec() )

         ::oDbfArtFac:GoTop()

         nCount := 1

         while !::oDbfArtFac:eof()

            if !Empty( ::oDbfArtFac:Familia ) .and. !::oDbfFamGst:Seek( UPPER( ::oDbfArtFac:Familia ) )

               ::oDbfFamGst:Append()

               ::oDbfFamGst:cCodFam    := StrZero( nCount, 3 )
               ::oDbfFamGst:cNomFam    := UPPER( ::oDbfArtFac:Familia )

               ::oDbfFamGst:Save()

               nCount ++

            end if

            ::aMtrIndices[ 3 ]:Set( ::oDbfArtFac:Recno() )

            ::oDbfArtFac:Skip()

         end while

         /*
         Empezamos el trasbase de artículos
         */

         ::aMtrIndices[ 3 ]:SetTotal( ::oDbfArtFac:LastRec() )

         ::oDbfFamGst:GoTop()
         ::oDbfArtFac:GoTop()
         while !( ::oDbfArtFac:eof() )

            while ::oDbfArtGst:Seek( ::oDbfArtFac:Codigo )
               ::oDbfArtGst:Delete( .f. )
            end while

            ::oDbfArtGst:Append()
            ::oDbfArtGst:Blank()

            ::oDbfArtGst:Codigo           := ::oDbfArtFac:Codigo
            ::oDbfArtGst:Nombre           := ::oDbfArtFac:Descripcio
            ::oDbfArtGst:pCosto           := ::oDbfArtFac:Compra
            ::oDbfArtGst:lBnf1            := .f.
            ::oDbfArtGst:lBnf2            := .f.
            ::oDbfArtGst:lBnf3            := .f.
            ::oDbfArtGst:Benef1           := ::oDbfArtFac:Margen1
            ::oDbfArtGst:Benef2           := ::oDbfArtFac:Margen2
            ::oDbfArtGst:Benef3           := ::oDbfArtFac:Margen3
            ::oDbfArtGst:nBnfSbr1         := 1
            ::oDbfArtGst:nBnfSbr2         := 1
            ::oDbfArtGst:nBnfSbr3         := 1
            ::oDbfArtGst:pVenta1          := ::oDbfArtFac:Venta1
            ::oDbfArtGst:pVenta2          := ::oDbfArtFac:Venta2
            ::oDbfArtGst:pVenta3          := ::oDbfArtFac:Venta3
            ::oDbfArtGst:lIvaInc          := ::oDbfArtFac:IvaIncl
            ::oDbfArtGst:nMinimo          := ::oDbfArtFac:StockMin
            ::oDbfArtGst:nMaximo          := ::oDbfArtFac:StockMin
            ::oDbfArtGst:nCajEnt          := 1
            ::oDbfArtGst:nUniCaja         := 1
            ::oDbfArtGst:LastChg          := GetSysDate()
            ::oDbfArtGst:cCodUsr          := cCurUsr()
            ::oDbfArtGst:cTimChg          := Time()
            ::oDbfArtGst:nCtlStock        := 1

            do case
               case ::oDbfArtFac:Iva  == 0
                  ::oDbfArtGst:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, 0 )
                  ::oDbfArtGst:pVtaIva1   := ::oDbfArtFac:Venta1 + ( ( ::oDbfArtFac:Venta1 * 0 ) / 100 )
                  ::oDbfArtGst:pVtaIva2   := ::oDbfArtFac:Venta2 + ( ( ::oDbfArtFac:Venta2 * 0 ) / 100 )
                  ::oDbfArtGst:pVtaIva3   := ::oDbfArtFac:Venta3 + ( ( ::oDbfArtFac:Venta3 * 0 ) / 100 )
               case ::oDbfArtFac:Iva  == 1
                  ::oDbfArtGst:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, 4 )
                  ::oDbfArtGst:pVtaIva1   := ::oDbfArtFac:Venta1 + ( ( ::oDbfArtFac:Venta1 * 4 ) / 100 )
                  ::oDbfArtGst:pVtaIva2   := ::oDbfArtFac:Venta2 + ( ( ::oDbfArtFac:Venta2 * 4 ) / 100 )
                  ::oDbfArtGst:pVtaIva3   := ::oDbfArtFac:Venta3 + ( ( ::oDbfArtFac:Venta3 * 4 ) / 100 )
               case ::oDbfArtFac:Iva  == 2
                  ::oDbfArtGst:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, 7 )
                  ::oDbfArtGst:pVtaIva1   := ::oDbfArtFac:Venta1 + ( ( ::oDbfArtFac:Venta1 * 7 ) / 100 )
                  ::oDbfArtGst:pVtaIva2   := ::oDbfArtFac:Venta2 + ( ( ::oDbfArtFac:Venta2 * 7 ) / 100 )
                  ::oDbfArtGst:pVtaIva3   := ::oDbfArtFac:Venta3 + ( ( ::oDbfArtFac:Venta3 * 7 ) / 100 )
               case ::oDbfArtFac:Iva  == 3
                  ::oDbfArtGst:TipoIva    := cCodigoIva( ::oDbfIva:cAlias, 16 )
                  ::oDbfArtGst:pVtaIva1   := ::oDbfArtFac:Venta1 + ( ( ::oDbfArtFac:Venta1 * 16 ) / 100 )
                  ::oDbfArtGst:pVtaIva2   := ::oDbfArtFac:Venta2 + ( ( ::oDbfArtFac:Venta2 * 16 ) / 100 )
                  ::oDbfArtGst:pVtaIva3   := ::oDbfArtFac:Venta3 + ( ( ::oDbfArtFac:Venta3 * 16 ) / 100 )
            end case

            if ::oDbfFamGst:Seek( UPPER( ::oDbfArtFac:Familia ) )
               ::oDbfArtGst:Familia       := ::oDbfFamGst:cCodFam
            end if

            //LLenamos la tabla de referencia a proveedor

            nOrdAnt := ::oDbfPrvGst:OrdSetFocus( "TITULO" )

            if !Empty( ::oDbfArtFac:Proveedor ) .and. ::oDbfPrvGst:Seek( UPPER( ::oDbfArtFac:Proveedor ) )

               ::oDbfArtGst:cPrvHab       := ::oDbfPrvGst:Cod

               ::oDbfArtPrv:Append()

               ::oDbfArtPrv:cCodArt       := ::oDbfArtFac:Codigo
               ::oDbfArtPrv:cCodPrv       := ::oDbfPrvGst:Cod
               ::oDbfArtPrv:cRefPrv       := ::oDbfArtFac:RfaProv
               ::oDbfArtPrv:lDefPrv       := .t.

               ::oDbfArtPrv:Save()

            end if

            ::oDbfPrvGst:OrdSetFocus( nOrdAnt )

            ::oDbfArtGst:Save()

            ::aMtrIndices[ 3 ]:Set( ::oDbfArtFac:Recno() )

            ::oDbfArtFac:Skip()

         end while

      end if

      /*Traspaso de albaranes de clientes*/

      if ::aLgcIndices[ 4 ]

         ::aMtrIndices[ 4 ]:SetTotal( ::oDbfAlbTFac:LastRec() )

         ::oDbfAlbTFac:GoTop()
         while !( ::oDbfAlbTFac:eof() )

            cSerie                        := SubStr( AllTrim( ::oDbfAlbTFac:Numero ), 1, 1 )
            nNumero                       := Val( SubStr( AllTrim( ::oDbfAlbTFac:Numero ), 2 ) )

            while ::oDbfAlbTGst:Seek( cSerie + str( nNumero, 9 ) + Space(2) )
               ::oDbfAlbTGst:Delete( .f. )
            end while

            while ::oDbfAlbLGst:Seek( cSerie + str( nNumero, 9 ) + Space(2) )

               ::oDbfAlbLGst:Delete( .f. )
            end while

            ::oDbfAlbTGst:Append()
            ::oDbfAlbTGst:Blank()

            ::oDbfAlbTGst:cSerAlb        := cSerie
            ::oDbfAlbTGst:nNumAlb        := nNumero
            ::oDbfAlbTGst:cSufAlb        := "00"
            ::oDbfAlbTGst:cTurAlb        := cCurSesion()
            ::oDbfAlbTGst:dFecAlb        := ::oDbfAlbTFac:Fecha
            ::oDbfAlbTGst:cCodAlm        := oUser():cAlmacen()
            ::oDbfAlbTGst:cCodCaj        := cDefCaj()
            ::oDbfAlbTGst:lFacturado     := .f.
            ::oDbfAlbTGst:lEntregado     := .f.
            ::oDbfAlbTGst:dFecEnt        := ::oDbfAlbTFac:Fecha
            ::oDbfAlbTGst:cCodPago       := cDefFpg()
            ::oDbfAlbTGst:nTarifa        := 1
            ::oDbfAlbTGst:cDivAlb        := cDivEmp()
            ::oDbfAlbTGst:lIvaInc        := ::oDbfAlbTFac:IvaIncl
            ::oDbfAlbTGst:cCodUsr        := cCurUsr()
            ::oDbfAlbTGst:dFecCre        := GetSysDate()
            ::oDbfAlbTGst:cTimCre        := Time()
            ::oDbfAlbTGst:dFecEnv        := Ctod( "" )

            nOrdAnt := ::oDbfCliGst:OrdSetFocus( "TITULO" )
            ::oDbfCliGst:GoTop()
            if !Empty( ::oDbfAlbTFac:NombreF ) .and. ::oDbfCliGst:Seek( UPPER( ::oDbfAlbTFac:NombreF ) )

               ::oDbfAlbTGst:cCodCli        := ::oDbfCliGst:Cod
               ::oDbfAlbTGst:cNomCli        := UPPER( ::oDbfAlbTFac:NombreF )
               if !Empty( ::oDbfAlbTFac:DireccionF )
                  ::oDbfAlbTGst:cDirCli     := ::oDbfAlbTFac:DireccionF
               else
                  ::oDbfAlbTGst:cDirCli     := ::oDbfCliGst:Domicilio
               end if
               if !Empty( ::oDbfAlbTFac:CiudadF )
                  ::oDbfAlbTGst:cPobCli     := ::oDbfAlbTFac:CiudadF
               else
                  ::oDbfAlbTGst:cPobCli     := ::oDbfCliGst:Poblacion
               end if
               if !Empty( ::oDbfAlbTFac:Cif )
                  ::oDbfAlbTGst:cDniCli     := ::oDbfAlbTFac:cif
               else
                  ::oDbfAlbTGst:cDniCli     := ::oDbfCliGst:Nif
               end if

               ::oDbfAlbTGst:cPrvCli        := ::oDbfCliGst:Provincia
               ::oDbfAlbTGst:cPosCli        := ::oDbfCliGst:CodPostal

               if !Empty( ::oDbfCliGst:cDtoEsp )
                  ::oDbfAlbTGst:cDtoEsp     := ::oDbfCliGst:cDtoEsp
               else
                  ::oDbfAlbTGst:cDtoEsp     := Padr( "General", 50 )
               end if

               if !Empty( ::oDbfCliGst:cDpp )
                  ::oDbfAlbTGst:cDpp        := ::oDbfCliGst:cDpp
               else
                  ::oDbfAlbTGst:cDpp        := Padr( "Pronto pago", 50 )
               end if

               ::oDbfAlbTGst:lRecargo       := ::oDbfCliGst:lReq
               ::oDbfAlbTGst:nRegIva        := ::oDbfCliGst:nRegIva

            else
               ::oDbfAlbTGst:cNomCli        := UPPER( ::oDbfAlbTFac:NombreF )
               ::oDbfAlbTGst:cDirCli        := ::oDbfAlbTFac:DireccionF
               ::oDbfAlbTGst:cPobCli        := ::oDbfAlbTFac:CiudadF
               ::oDbfAlbTGst:cDniCli        := ::oDbfAlbTFac:cif
            end if

            ::oDbfCliGst:OrdSetFocus( nOrdAnt )

            ::oDbfAlbTGst:Save()

            ::aMtrIndices[ 4 ]:Set( ::oDbfAlbTFac:Recno() )

            ::oDbfAlbTFac:Skip()

         end while

         ::aMtrIndices[ 4 ]:SetTotal( ::oDbfAlbLFac:LastRec() )

         ::oDbfAlbLFac:GoTop()
         while !( ::oDbfAlbLFac:eof() )



            if Left( ::oDbfAlbLFac:RfaLin, 1 ) == "A"

               cSerie                        := SubStr( AllTrim( ::oDbfAlbLFac:RfaLin ), 5, 1 )
               nNumero                       := Val( SubStr( AllTrim( ::oDbfAlbLFac:RfaLin ), 6, 6 ) )

               ::oDbfAlbLGst:Append()

               ::oDbfAlbLGst:cSerAlb     := cSerie
               ::oDbfAlbLGst:nNumAlb     := nNumero
               ::oDbfAlbLGst:cSufAlb     := "00"
               ::oDbfAlbLGst:cRef        := ::oDbfAlbLFac:Codigo
               ::oDbfAlbLGst:cDetalle    := ::oDbfAlbLFac:Concepto
               ::oDbfAlbLGst:nPreUnit    := ::oDbfAlbLFac:Precio
               ::oDbfAlbLGst:nDto        := ::oDbfAlbLFac:Descuento
               ::oDbfAlbLGst:nIva        := ::oDbfAlbLFac:Iva
               ::oDbfAlbLGst:nCanEnt     := 1
               ::oDbfAlbLGst:nUniCaja    := ::oDbfAlbLFac:Cantidad
               ::oDbfAlbLGst:dFecha      := ::oDbfAlbLFac:Fecha
               ::oDbfAlbLGst:cAlmLin     := oUser():cAlmacen()
               ::oDbfAlbLGst:nNumLin     := Val( SubStr( AllTrim( ::oDbfAlbLFac:RfaLin ), 12, 6 ) ) 

               ::oDbfArtGst:GoTop()
               if ::oDbfArtGst:Seek( ::oDbfAlbLFac:Codigo )
                  ::oDbfAlbLGst:nCtlStk  := ::oDbfArtGst:nCtlStock
                  ::oDbfAlbLGst:nCosDiv  := ::oDbfArtGst:pCosto
                  ::oDbfAlbLGst:lIvaLin  := ::oDbfArtGst:lIvaInc
               end if

               ::oDbfAlbLGst:Save()

            end if

            ::aMtrIndices[ 4 ]:Set( ::oDbfAlbLFac:Recno() )

            ::oDbfAlbLFac:Skip()

         end while

      end if

      /*Traspaso de facturas de clientes*/

      if ::aLgcIndices[ 5 ]

         ::aMtrIndices[ 5 ]:SetTotal( ::oDbfFacTFac:LastRec() )

         ::oDbfFacTFac:GoTop()
         while !( ::oDbfFacTFac:eof() )

               while ::oDbfFacTGst:Seek( "A" + Str( Val( ::oDbfFacTFac:Numero ), 9 ) + "00" )
                  ::oDbfFacTGst:Delete( .f. )
               end

               while ::oDbfFacLGst:Seek( "A" + Str( Val( ::oDbfFacTFac:Numero), 9 ) + "00" )
                  ::oDbfFacLGst:Delete( .f. )
               end

               while ::oDbfFacPGst:Seek( "A" + Str( Val( ::oDbfFacTFac:Numero), 9 ) + "00" )
                  ::oDbfFacPGst:Delete( .f. )
               end 

               ::oDbfFacTGst:Append()
               ::oDbfFacTGst:Blank()

               ::oDbfFacTGst:cSerie      := "A"
               ::oDbfFacTGst:nNumFac     := Val( ::oDbfFacTFac:Numero )
               ::oDbfFacTGst:cSufFac     := "00"
               ::oDbfFacTGst:cTurFac     := cCurSesion()
               ::oDbfFacTGst:dFecFac     := ::oDbfFacTFac:Fecha
               ::oDbfFacTGst:cCodAlm     := oUser():cAlmacen()
               ::oDbfFacTGst:cCodCaj     := cDefCaj()
               ::oDbfFacTGst:dFecEnt     := ::oDbfFacTFac:Fecha
               ::oDbfFacTGst:nTarifa     := 1
               ::oDbfFacTGst:lLiquidada  := .t.
               ::oDbfFacTGst:lContab     := .f.
               ::oDbfFacTGst:cCodPago    := cDefFpg()
               ::oDbfFacTGst:lIvaInc     := ::oDbfFacTFac:IvaIncl
               ::oDbfFacTGst:cDivFac     := cDivEmp()
               ::oDbfFacTGst:cCodUsr     := cCurUsr()
               ::oDbfFacTGst:dFecCre     := GetSysDate()
               ::oDbfFacTGst:cTimCre     := Time()

               nOrdAnt := ::oDbfCliGst:OrdSetFocus( "TITULO" )
               ::oDbfCliGst:GoTop()
               if !Empty( ::oDbfFacTFac:NombreF ) .and. ::oDbfCliGst:Seek( UPPER( ::oDbfFacTFac:NombreF ) )

                  ::oDbfFacTGst:cCodCli        := ::oDbfCliGst:Cod
                  ::oDbfFacTGst:cNomCli        := UPPER( ::oDbfFacTFac:NombreF )
                  if !Empty( ::oDbfFacTFac:DireccionF )
                     ::oDbfFacTGst:cDirCli     := ::oDbfFacTFac:DireccionF
                  else
                     ::oDbfFacTGst:cDirCli     := ::oDbfCliGst:Domicilio
                  end if
                  if !Empty( ::oDbfFacTFac:CiudadF )
                     ::oDbfFacTGst:cPobCli     := ::oDbfFacTFac:CiudadF
                  else
                     ::oDbfFacTGst:cPobCli     := ::oDbfCliGst:Poblacion
                  end if
                  if !Empty( ::oDbfFacTFac:Cif )
                     ::oDbfFacTGst:cDniCli     := ::oDbfFacTFac:cif
                  else
                     ::oDbfFacTGst:cDniCli     := ::oDbfCliGst:Nif
                  end if

                  ::oDbfFacTGst:cPrvCli        := ::oDbfCliGst:Provincia
                  ::oDbfFacTGst:cPosCli        := ::oDbfCliGst:CodPostal

                  if !Empty( ::oDbfCliGst:cDtoEsp )
                     ::oDbfFacTGst:cDtoEsp     := ::oDbfCliGst:cDtoEsp
                  else
                     ::oDbfFacTGst:cDtoEsp     := Padr( "General", 50 )
                  end if

                  if !Empty( ::oDbfCliGst:cDpp )
                     ::oDbfFacTGst:cDpp        := ::oDbfCliGst:cDpp
                  else
                     ::oDbfFacTGst:cDpp        := Padr( "Pronto pago", 50 )
                  end if

                  ::oDbfFacTGst:lRecargo       := ::oDbfCliGst:lReq
                  ::oDbfFacTGst:nRegIva        := ::oDbfCliGst:nRegIva

               else
                  ::oDbfFacTGst:cNomCli        := UPPER( ::oDbfFacTFac:NombreF )
                  ::oDbfFacTGst:cDirCli        := ::oDbfFacTFac:DireccionF
                  ::oDbfFacTGst:cPobCli        := ::oDbfFacTFac:CiudadF
                  ::oDbfFacTGst:cDniCli        := ::oDbfFacTFac:cif
                  ::oDbfFacTGst:cDtoEsp        := Padr( "General", 50 )
                  ::oDbfFacTGst:cDpp           := Padr( "Pronto pago", 50 )
               end if

            ::oDbfCliGst:OrdSetFocus( nOrdAnt )

            ::oDbfFacTGst:Save()

            ::aMtrIndices[ 5 ]:Set( ::oDbfFacTFac:Recno() )

            ::oDbfFacTFac:Skip()

         end while

         ::aMtrIndices[ 5 ]:SetTotal( ::oDbfAlbLFac:LastRec() )

         ::oDbfAlbLFac:GoTop()
         while !( ::oDbfAlbLFac:eof() )

            if Left( ::oDbfAlbLFac:RfaLin, 1 ) == "F"

               ::oDbfFacLGst:Append()

               ::oDbfFacLGst:cSerie      := "A"
               ::oDbfFacLGst:nNumFac     := Val( SubStr( ::oDbfAlbLFac:RfaLin, 5, 7 ) )
               ::oDbfFacLGst:cSufFac     := "00"
               ::oDbfFacLGst:cRef        := ::oDbfAlbLFac:Codigo
               ::oDbfFacLGst:cDetalle    := ::oDbfAlbLFac:Concepto
               ::oDbfFacLGst:nPreUnit    := ::oDbfAlbLFac:Precio
               ::oDbfFacLGst:nDto        := ::oDbfAlbLFac:Descuento
               ::oDbfFacLGst:nIva        := ::oDbfAlbLFac:Iva
               ::oDbfFacLGst:nCanEnt     := 1
               ::oDbfFacLGst:nUniCaja    := ::oDbfAlbLFac:Cantidad
               ::oDbfFacLGst:dFecha      := ::oDbfAlbLFac:Fecha
               ::oDbfFacLGst:cAlmLin     := oUser():cAlmacen()
               ::oDbfFacLGst:NNumLin     := Val( SubStr( AllTrim( ::oDbfAlbLFac:RfaLin ), 12, 6 ) )

               ::oDbfArtGst:GoTop()
               if ::oDbfArtGst:Seek( ::oDbfAlbLFac:Codigo )
                  ::oDbfFacLGst:nCtlStk  := ::oDbfArtGst:nCtlStock
                  ::oDbfFacLGst:nCosDiv  := ::oDbfArtGst:pCosto
                  ::oDbfFacLGst:lIvaLin  := ::oDbfArtGst:lIvaInc
               end if

               ::oDbfFacLGst:Save()

            end if

            ::aMtrIndices[ 5 ]:Set( ::oDbfAlbLFac:Recno() )

            ::oDbfAlbLFac:Skip()

         end while

         ::aMtrIndices[ 5 ]:SetTotal( ::oDbfFacTGst:LastRec() )

         ::oDbfFacTGst:GoTop()
         while !( ::oDbfFacTGst:eof() )

            GenPgoFacCli( ::oDbfFacTGst:cSerie + Str( ::oDbfFacTGst:nNumFac ) + ::oDbfFacTGst:cSufFac, ::oDbfFacTGst:cAlias, ::oDbfFacLGst:cAlias, ::oDbfFacPGst:cAlias, ::oDbfAntTGst:cAlias, ::oDbfCliGst:cAlias, ::oDbfPgo:cAlias, ::oDbfDiv:cAlias, ::oDbfIva:cAlias, ,.f. )

            ::aMtrIndices[ 5 ]:Set( ::oDbfFacTGst:Recno() )

            ::oDbfFacTGst:Skip()

         end while

      end if

      //Traspaso de facturas de proveedores------------------------------------

      if ::aLgcIndices[ 6 ]

         ::aMtrIndices[ 6 ]:SetTotal( ::oDbfFacPrvTFac:LastRec() )

         ::oDbfFacPrvTFac:GoTop()
         while !( ::oDbfFacPrvTFac:Eof() )

            while ::oDbfFacPrvTGst:Seek( "A" + Str( Val( ::oDbfFacPrvTFac:Numero ), 9 ) + "00" )
               ::oDbfFacPrvTGst:Delete( .f. )
            end while

            while ::oDbfFacPrvLGst:Seek( "A" + Str( Val( ::oDbfFacPrvTFac:Numero), 9 ) + "00" )
               ::oDbfFacPrvLGst:Delete( .f. )
            end while

            while ::oDbfFacPrvPGst:Seek( "A" + Str( Val( ::oDbfFacPrvTFac:Numero), 9 ) + "00" )
               ::oDbfFacPrvPGst:Delete( .f. )
            end while

            ::oDbfFacPrvTGst:Append()
            ::oDbfFacPrvTGst:Blank()

            ::oDbfFacPrvTGst:cSerFac     := "A"
            ::oDbfFacPrvTGst:nNumFac     := Val( ::oDbfFacPrvTFac:Numero )
            ::oDbfFacPrvTGst:cSufFac     := "00"
            ::oDbfFacPrvTGst:cTurFac     := cCurSesion()
            ::oDbfFacPrvTGst:dFecFac     := ::oDbfFacPrvTFac:Fecha
            ::oDbfFacPrvTGst:cCodAlm     := oUser():cAlmacen()
            ::oDbfFacPrvTGst:cCodCaj     := cDefCaj()
            ::oDbfFacPrvTGst:dFecEnt     := ::oDbfFacPrvTFac:Fecha
            ::oDbfFacPrvTGst:lLiquidada  := .t.
            ::oDbfFacPrvTGst:lContab     := .f.
            ::oDbfFacPrvTGst:cCodPago    := cDefFpg()
            ::oDbfFacPrvTGst:cDivFac     := cDivEmp()
            ::oDbfFacPrvTGst:cCodUsr     := cCurUsr()
            ::oDbfFacPrvTGst:dFecChg     := GetSysDate()
            ::oDbfFacPrvTGst:cTimChg     := Time()

            nOrdAnt := ::oDbfPrvGst:OrdSetFocus( "TITULO" )
            ::oDbfPrvGst:GoTop()

            if !Empty( ::oDbfFacPrvTFac:NombreF ) .and. ::oDbfPrvGst:Seek( UPPER( ::oDbfFacPrvTFac:NombreF ) )

               ::oDbfFacPrvTGst:cCodPrv      := ::oDbfPrvGst:Cod
               ::odbfFacPrvTGst:cNomPrv      := UPPER( ::oDbfFacPrvTFac:NombreF )
               ::oDbfFacPrvTGst:cDirPrv      := ::oDbfPrvGst:Domicilio
               ::odbfFacPrvTGst:cPobPrv      := ::oDbfPrvGst:Poblacion
               if !Empty( ::odbfFacPrvTFac:Cif )
                  ::oDbfFacPrvTGst:cDniPrv   := ::oDbfFacPrvTFac:Cif
               else
                  ::oDbfFacPrvTGst:cDniPrv   := ::oDbfPrvGst:Nif
               end if 
               ::oDbfFacPrvTGst:cProvProv    := ::oDbfPrvGst:Provincia
               ::oDbfFacPrvTGst:cPosPrv      := ::oDbfPrvGst:CodPostal
               ::oDbfFacPrvTGst:lRecargo     := ::oDbfPrvGst:lReq
               ::oDbffacPrvTGst:nRegIva      := ::odbfPrvGst:nRegIva

               if !Empty( ::oDbfPrvGst:cDtoEsp )
                  ::oDbfFacPrvTGst:cDtoEsp   := ::oDbfPrvGst:cDtoEsp
               else
                  ::oDbfFacPrvTGst:cDtoEsp   := Padr( "General", 50 )
               end if

               if !Empty( ::oDbfPrvGst:cDtoPp )
                  ::oDbfFacPrvTGst:cDpp        := ::oDbfPrvGst:cDtoPp
               else
                  ::oDbfFacPrvTGst:cDpp        := Padr( "Pronto pago", 50 )
               end if

            else

               ::odbfFacPrvTGst:cNomPrv      := UPPER( ::oDbfFacPrvTFac:NombreF )
               ::oDbfFacPrvTGst:cDniPrv      := ::oDbfPrvGst:Nif
               ::oDbfFacPrvTGst:cDtoEsp      := Padr( "General", 50 )
               ::oDbfFacPrvTGst:cDpp         := Padr( "Pronto pago", 50 )

            end if 

            ::oDbfPrvGst:OrdSetFocus( nOrdAnt )

            ::odbfFacPrvTGst:Save()

            ::aMtrIndices[ 6 ]:Set( ::oDbfFacPrvTFac:Recno() )

            ::oDbfFacPrvTFac:Skip()

         end while

         //   ::aMtrIndices[ 6 ]:SetTotal( ::oDbfAlbLFac:LastRec() ) //meter de las lineas 

         //   ::oDbfAlbLFac:GoTop()  //go top en la tabla de lineas conteni1.dbf

//empieza el while de las lineas de facturas de proveedores

         //end while

      end if 


      ::CloseFiles()

      msgInfo( "Traspaso realizado con éxito.", "Bienvenido a " + __GSTROTOR__ + Space( 1 ) + __GSTVERSION__ )

      ::oDlg:Enable()
      ::oDlg:end()

   else
      MsgStop( "Error al abrir los ficheros" )
   end if

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