#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TCatalogo FROM TMANT

   DATA  cMru        INIT "gc_objects_16"
   DATA  DbfProv     AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  oBenef1     AS OBJECT
   DATA  oBenef2     AS OBJECT
   DATA  oBenef3     AS OBJECT
   DATA  oBenef4     AS OBJECT
   DATA  oBenef5     AS OBJECT
   DATA  oBenef6     AS OBJECT
   DATA  oBnfSbr1    AS OBJECT
   DATA  oBnfSbr2    AS OBJECT
   DATA  oBnfSbr3    AS OBJECT
   DATA  oBnfSbr4    AS OBJECT
   DATA  oBnfSbr5    AS OBJECT
   DATA  oBnfSbr6    AS OBJECT
   DATA  oValPnt     AS OBJECT
   DATA  oDtoPnt     AS OBJECT
   DATA  cPrvOld
   DATA  oBmpObs     AS OBJECT

   METHOD Create( cPath ) CONSTRUCTOR

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD OpenService( lExclusive )
   METHOD CloseService()

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD InvSelect( oBrw )   INLINE ( ::oDbf:Load(), ::oDbf:lSelect := !::oDbf:lSelect, ::oDbf:Save(), oBrw:Refresh() )

   METHOD SelectAll( lSel, oBrw )

   METHOD lValid( oGet, oSay )

   METHOD cNombre( cCodArt )

   METHOD lPreSave( oNomCatalogo, oCodProvee, oFecIni )

   METHOD ActualizaBeneficio( oBenef1, oBenef2, oBenef3, oBenef4, oBenef5, oBenef6, oBnfSbr1, oBnfSbr2, oBnfSbr3, oBnfSbr4, oBnfSbr5, oBnfSbr6 )

   METHOD lCambia()

END CLASS

//----------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := Auth():Level( "01013" )
   end if

   ::cPath              := cPatEmp()
   ::oWndParent         := oWndParent
   ::oDbf               := nil

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.
   ::oBmpObs            := LoadBitmap( GetResources(), "bStop" )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      DATABASE NEW ::DbfProv PATH ( cPatPrv() ) FILE "PROVEE.DBF"   VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

      DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de catalogos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de catalogos" )

      ::CloseService()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::DbfProv ) .and. ::DbfProv:Used()
      ::DbfProv:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

    ::oDbf      := nil
    ::DbfProv   := nil
    ::oDbfArt   := nil

    DeleteObject( ::oBmpObs  )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "Catalogo.Dbf" CLASS "Catalogo" ALIAS "Catalogo" PATH ( cPath ) VIA ( cDriver ) COMMENT "Catálogos de artículos"

      FIELD CALCULATE NAME "bmplObsCat"   LEN  1  DEC 0 COMMENT "O"  VAL ( if( ::oDbf:lObsCat, ::oBmpObs, "" ) )        COLSIZE  16 OF ::oDbf
      FIELD NAME "cCodCata"  TYPE "C"     LEN  4  DEC 0 COMMENT "Código"             PICTURE "@!"                       COLSIZE  60 OF ::oDbf
      FIELD NAME "cNomCata"  TYPE "C"     LEN 50  DEC 0 COMMENT "Nombre catalogo"    PICTURE "@!"                       COLSIZE 300 OF ::oDbf
      FIELD NAME "cCodProv"  TYPE "C"     LEN 12  DEC 0 COMMENT "Proveedor"          PICTURE "@!"         HIDE OF ::oDbf
      FIELD CALCULATE NAME "Proveedor"    LEN 92  DEC 0 COMMENT "Proveedor"  VAL ( AllTrim( ::oDbf:cCodProv ) + " - " + if( !Empty( ::DbfProv ), RetProvee( ::oDbf:cCodProv, ::DbfProv:cAlias ), "" ) )  COLSIZE  200  OF ::oDbf
      FIELD NAME "dFecIni"   TYPE "D"     LEN  8  DEC 0 COMMENT "Inicio"             PICTURE "@!"                       COLSIZE  75 OF ::oDbf
      FIELD NAME "dFecFin"   TYPE "D"     LEN  8  DEC 0 COMMENT "Fin"                PICTURE "@!"                       COLSIZE  75 OF ::oDbf
      FIELD NAME "nValPunt"  TYPE "N"     LEN 16  DEC 6 COMMENT "Valor del punto"    PICTURE cPouDiv()    ALIGN RIGHT   COLSIZE 100 OF ::oDbf
      FIELD NAME "nDtoPunt"  TYPE "N"     LEN  6  DEC 2 COMMENT "Descuento %"        PICTURE "@E 99.99"   ALIGN RIGHT   COLSIZE  75 OF ::oDbf
      FIELD NAME "Benef1"    TYPE "N"     LEN  6  DEC 2 COMMENT "Benef. 1"           PICTURE "@E 99.99"   HIDE OF ::oDbf
      FIELD NAME "Benef2"    TYPE "N"     LEN  6  DEC 2 COMMENT "Benef. 2"           PICTURE "@E 99.99"   HIDE OF ::oDbf
      FIELD NAME "Benef3"    TYPE "N"     LEN  6  DEC 2 COMMENT "Benef. 3"           PICTURE "@E 99.99"   HIDE OF ::oDbf
      FIELD NAME "Benef4"    TYPE "N"     LEN  6  DEC 2 COMMENT "Benef. 4"           PICTURE "@E 99.99"   HIDE OF ::oDbf
      FIELD NAME "Benef5"    TYPE "N"     LEN  6  DEC 2 COMMENT "Benef. 5"           PICTURE "@E 99.99"   HIDE OF ::oDbf
      FIELD NAME "Benef6"    TYPE "N"     LEN  6  DEC 2 COMMENT "Benef. 6"           PICTURE "@E 99.99"   HIDE OF ::oDbf
      FIELD NAME "nBnfSbr1"  TYPE "N"     LEN  1  DEC 0 COMMENT "Descuento"                               HIDE OF ::oDbf
      FIELD NAME "nBnfSbr2"  TYPE "N"     LEN  1  DEC 0 COMMENT "Descuento"                               HIDE OF ::oDbf
      FIELD NAME "nBnfSbr3"  TYPE "N"     LEN  1  DEC 0 COMMENT "Descuento"                               HIDE OF ::oDbf
      FIELD NAME "nBnfSbr4"  TYPE "N"     LEN  1  DEC 0 COMMENT "Descuento"                               HIDE OF ::oDbf
      FIELD NAME "nBnfSbr5"  TYPE "N"     LEN  1  DEC 0 COMMENT "Descuento"                               HIDE OF ::oDbf
      FIELD NAME "nBnfSbr6"  TYPE "N"     LEN  1  DEC 0 COMMENT "Descuento"                               HIDE OF ::oDbf
      FIELD NAME "lObsCat"   TYPE "L"     LEN  1  DEC 0 COMMENT "Catálogo obsoleto"                       HIDE OF ::oDbf

      INDEX TO "Catalogo.Cdx" TAG "cCodCata" ON "cCodCata" COMMENT "Código catálogo" NODELETED OF ::oDbf
      INDEX TO "Catalogo.Cdx" TAG "cNomCata" ON "cNomCata" COMMENT "Nombre catálogo" NODELETED OF ::oDbf
      INDEX TO "Catalogo.Cdx" TAG "cCodProv" ON "cCodProv" COMMENT "Proveedor"       NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oCodProvee
   local oNomProvee
   local cNomProvee
   local oNomCatalogo
   local oFecIni
   local oFecFin
   local aBnfSobre      := { "Costo", "Venta" }
   local oObsCat

   ::cPrvOld            := ::oDbf:cCodProv

   if nMode == DUPL_MODE
      ::oDbf:cCodCata   := NextKey( ::oDbf:cCodCata, ::oDbf )
   end if

   DEFINE DIALOG oDlg RESOURCE "Catalogo"  TITLE LblTitle( nMode ) + "catálogo"

      REDEFINE GET oGet ;
         VAR      ::oDbf:cCodCata ;
         UPDATE ;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
         BITMAP   "Bot" ;
         PICTURE  "@!" ;
			OF 		oDlg

      oGet:bHelp           := {|| oGet:cText( NextKey( ::oDbf:cCodCata, ::oDbf ) ) }

      REDEFINE GET oNomCatalogo VAR ::oDbf:cNomCata UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oCodProvee VAR ::oDbf:cCodProv ;
         ID       120 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      oCodProvee:bHelp     := {|| BrwProvee( oCodProvee ) }
      oCodProvee:bChange   := {|| ::ActualizaBeneficio() }
      oCodProvee:bValid    := {|| cProvee( oCodProvee, ::dbfProv:cAlias, oNomProvee ), ::ActualizaBeneficio() }

      REDEFINE GET oNomProvee VAR cNomProvee ;
         ID       130 ;
         PICTURE  "@!" ;
         WHEN     ( .F. ) ;
         OF       oDlg

      REDEFINE GET ::oDtoPnt VAR ::oDbf:nDtoPunt ;
         ID       170 ;
         SPINNER ;
         PICTURE  "@E 99.99" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET ::oBenef1 VAR ::oDbf:Benef1 ;
         ID       210 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX ::oBnfSbr1 VAR ::oDbf:nBnfSbr1 ;
         ITEMS    aBnfSobre ;
         ID       211 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oBenef2 VAR ::oDbf:Benef2 ;
         ID       220 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX ::oBnfSbr2 VAR ::oDbf:nBnfSbr2 ;
         ITEMS    aBnfSobre ;
         ID       221 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oBenef3 VAR ::oDbf:Benef3 ;
         ID       230 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX ::oBnfSbr3 VAR ::oDbf:nBnfSbr3 ;
         ITEMS    aBnfSobre ;
         ID       231 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oBenef4 VAR ::oDbf:Benef4 ;
         ID       240 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX ::oBnfSbr4 VAR ::oDbf:nBnfSbr4 ;
         ITEMS    aBnfSobre ;
         ID       241 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oBenef5 VAR ::oDbf:Benef5 ;
         ID       250 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX ::oBnfSbr5 VAR ::oDbf:nBnfSbr5 ;
         ITEMS    aBnfSobre ;
         ID       251 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oBenef6 VAR ::oDbf:Benef6 ;
         ID       260 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "@E 999.99" ;
         OF       oDlg

      REDEFINE COMBOBOX ::oBnfSbr6 VAR ::oDbf:nBnfSbr6 ;
         ITEMS    aBnfSobre ;
         ID       261 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oValPnt VAR ::oDbf:nValPunt ;
         ID       160 ;
         PICTURE ( cPinDiv() ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET oFecIni VAR ::oDbf:dFecIni ;
         ID       140 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE GET oFecFin VAR ::oDbf:dFecFin ;
         ID       150 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         COLOR    CLR_GET ;
         OF       oDlg

      //Catálogo obsoleto

      REDEFINE CHECKBOX oObsCat VAR ::oDbf:lObsCat ;
         ID       200 ;
         WHEN     ( oUser():lAdministrador() .and. nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( oNomCatalogo, oCodProvee, oFecIni ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( oNomCatalogo, oCodProvee, oFecIni ), oDlg:end( IDOK ), ) } )
   end if

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD SelectAll( lSel, oBrw )

   ::oDbf:GetStatus()

   DEFAULT lSel   := .f.

   ::oDbf:GoTop()
   while !( ::oDbf:eof() )
      ::oDbf:Load()
      ::oDbf:lSelect := lSel
      ::oDbf:Save()
      ::oDbf:Skip()
   end while

   ::oDbf:SetStatus()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD lValid( oGet, oSay )

   local cCodArt

   if Empty( oGet:VarGet() )
      return .t.
   end if

   cCodArt        := RJustObj( oGet, "0" )

   if ::oDbf:Seek( cCodArt )
      if ::oDbf:lObsCat
         msgStop( "Catálogo obsoleto, no se puede asignar a un artículo" )
         return .f.
      end if
      oGet:cText( cCodArt )
      if oSay != nil
         oSay:cText( ::oDbf:cNomCata )
      end if
   else
      msgStop( "Código de catálogo no encontrado" )
      return .f.
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD cNombre( cCodArt )

   local cNombre  := ""

   if ::oDbf:Seek( cCodArt )
      cNombre     := ::oDbf:cNomCata
   end if

RETURN ( cNombre )

//---------------------------------------------------------------------------//

METHOD lPreSave( oNomCatalogo, oCodProvee, oFecIni )

   if Empty( ::oDbf:cNomCata )
      MsgStop( "El nombre del catálogo no puede estar vacío." )
      oNomCatalogo:SetFocus()
      Return .f.
   end if

   if Empty( ::oDbf:cCodProv )
      MsgStop( "El código del proveedor no puede estar vacío." )
      oCodProvee:SetFocus()
      Return .f.
   end if

   if ::oDbf:dFecIni > ::oDbf:dFecFin
      MsgStop( "La fecha de fin no puede ser menor que la fecha de inicio." )
      oFecIni:SetFocus()
      Return .f.
   end if

   ::lCambia()

RETURN .t.

//---------------------------------------------------------------------------//

function nPunt2Euro( aTmp, dbfArticulo )

/*lo he cambiao pq no daba el valor exacto*/
//   local nValor   := aTmp[ ( dbfArticulo )->( fieldPos( "pCosto") ) ] * aTmp[ ( dbfArticulo )->( fieldPos( "nPuntos") ) ] / ( 1 + ( aTmp[ ( dbfArticulo )->( fieldPos( "nDtoPnt") ) ] / 100 ) )

   local nValor   := aTmp[ ( dbfArticulo )->( fieldPos( "pCosto") ) ] * aTmp[ ( dbfArticulo )->( fieldPos( "nPuntos") ) ]

   nValor         -= ( nValor * aTmp[ ( dbfArticulo )->( fieldPos( "nDtoPnt") ) ] ) / 100

return ( nValor )

//---------------------------------------------------------------------------//

function lOcultar( aTmp, aGet, dbfArticulo, oNom1, oValorPunto, oNom2, oValorDto, oNom3 )

if IsMuebles()
   if !aTmp[ ( dbfArticulo )->( fieldPos( "lKitArt") ) ]
      oNom1:Show()
      oValorPunto:Show()
      oNom2:Show()
      oValorDto:Show()
      oNom3:Show()
      aGet[ ( dbfArticulo )->( fieldpos( "PCOSTO" ) ) ]:Show()
   else
      oNom1:Hide()
      oValorPunto:Hide()
      oNom2:Hide()
      oValorDto:Hide()
      oNom3:Hide()
      aGet[ ( dbfArticulo )->( fieldpos( "PCOSTO" ) ) ]:Hide()
   end if
end if

return .t.

//---------------------------------------------------------------------------//

function nValorPunt( aTmp, dbfArticulo, dbfCatalogo, dbfProv )

   local nValor         := 0
   local cCodCatalogo   := aTmp[ ( dbfArticulo )->( fieldPos( "cCodCat") ) ]
   local cCodProveedor  := aTmp[ ( dbfArticulo )->( fieldPos( "cPrvHab") ) ]

   do case
      case !Empty( cCodCatalogo )
           if ( dbfCatalogo )->( dbSeek( cCodCatalogo ) )
               nValor   := ( dbfCatalogo )->nValPunt
               if dbLock( dbfArticulo )
                  ( dbfArticulo )->nPuntos := ( dbfCatalogo )->nValPunt
                  ( dbfArticulo )->( dbUnLock() )
               end if
           end if

      case Empty( cCodCatalogo ) .and. !Empty( cCodProveedor )
           if ( dbfProv )->( dbSeek( cCodProveedor ) )
               nValor   := ( dbfProv )->nValPunt
               if dbLock( dbfArticulo )
                  ( dbfArticulo )->nPuntos := ( dbfProv )->nValPunt
                  ( dbfArticulo )->( dbUnLock() )
               end if
           end if

   end case

return nValor

//---------------------------------------------------------------------------//

function nValorDto( aTmp, dbfArticulo, dbfCatalogo, dbfProv )

   local nValor         := 0
   local cCodCatalogo   := aTmp[ ( dbfArticulo )->( fieldPos( "cCodCat") ) ]
   local cCodProveedor  := aTmp[ ( dbfArticulo )->( fieldPos( "cPrvHab") ) ]

   do case
      case !Empty( cCodCatalogo )
           if ( dbfCatalogo )->( dbSeek( cCodCatalogo ) )
               nValor   := ( dbfCatalogo )->nDtoPunt
               if dbLock( dbfArticulo )
                  ( dbfArticulo )->nDtoPnt  := ( dbfCatalogo )->nDtoPunt
                  ( dbfArticulo )->( dbUnLock() )
               end if
           end if

      case Empty( cCodCatalogo ) .and. !Empty( cCodProveedor )
           if ( dbfProv )->( dbSeek( cCodProveedor ) )
               nValor   := ( dbfProv )->Dtopp
               if dbLock( dbfArticulo )
                  ( dbfArticulo )->nDtoPnt  := ( dbfProv )->Dtopp
                  ( dbfArticulo )->( dbUnLock() )
               end if
           end if

   end case

return nValor

//---------------------------------------------------------------------------//

function CargaPuntos( aTmp, aGet, dbfArticulo, dbfTmpKit )

   if ( dbfArticulo )->( dbSeek( aTmp[ ( dbfTmpKit )->( fieldpos( "CREFKIT" ) ) ] ) )
      aTmp[ ( dbfTmpKit )->( fieldpos( "NVALPNT" ) ) ] := ( dbfArticulo )->nPuntos
      aTmp[ ( dbfTmpKit )->( fieldpos( "NDTOPNT" ) ) ] := ( dbfArticulo )->nDtoPnt
   end if

   aGet[ ( dbfTmpKit )->( fieldpos( "NVALPNT" ) ) ]:Refresh()
   aGet[ ( dbfTmpKit )->( fieldpos( "NDTOPNT" ) ) ]:Refresh()

return .t.

//---------------------------------------------------------------------------//

function nPuntKit( aTmp, dbfTmpKit, nCos );

   local nValor         := 0

   nValor   := aTmp[ ( dbfTmpKit )->( fieldPos( "nUndKit") ) ] * nCos * ( aTmp[ ( dbfTmpKit )->( fieldpos( "NVALPNT" ) ) ] / ( 1 + ( aTmp[ ( dbfTmpKit )->( fieldpos( "NDTOPNT" ) ) ] /100 ) ) )

return nValor

//---------------------------------------------------------------------------//

function nTotLPunt( nUnidades, nPrePnt, nValPnt, nDtoPnt )

   local nValor  := nUnidades * nPrePnt * ( nValPnt / ( 1 + ( nDtoPnt / 100 ) ) )

return nValor

//---------------------------------------------------------------------------//

function nTotTPunt( dbfTmpKit )

   local nTotal := 0

   ( dbfTmpKit )->( dbGoTop() )
   while !( dbfTmpKit )->( eof() )

      nTotal += ( dbfTmpKit )->nUndKit * ( dbfTmpKit )->nPreKit * ( ( dbfTmpKit )->nValPnt / ( 1 + ( ( dbfTmpKit )->nDtoPnt ) /100 ) )
      ( dbfTmpKit )->( dbSkip() )
   end while

return nTotal

//---------------------------------------------------------------------------//

function nTotTPrp( aTmp, aTmpArt, dbfArticulo, dbfTmpCom, dbfCatalogo, dbfProv )

   local nTotal  := 0
   local nPrecio := aTmp[ ( dbfTmpCom )->( FieldPos( "NPRECOM" ) ) ]
   local nPuntos := nValorPunt( aTmpArt, dbfArticulo, dbfCatalogo, dbfProv )
   local nDto    := nValorDto( aTmpArt, dbfArticulo, dbfCatalogo, dbfProv )

   nTotal := nPrecio * ( nPuntos / ( 1 + ( nDto / 100 ) ) )

return nTotal

//---------------------------------------------------------------------------//

METHOD ActualizaBeneficio()

   if ::cPrvOld != ::oDbf:cCodProv

      if ::DbfProv:Seek( ::oDbf:cCodProv )

         ::oDbf:Benef1     := ::DbfProv:Benef1
         ::oDbf:Benef2     := ::DbfProv:Benef2
         ::oDbf:Benef3     := ::DbfProv:Benef3
         ::oDbf:Benef4     := ::DbfProv:Benef4
         ::oDbf:Benef5     := ::DbfProv:Benef5
         ::oDbf:Benef6     := ::DbfProv:Benef6
         ::oDbf:nBnfSbr1   := ::DbfProv:nBnfSbr1
         ::oDbf:nBnfSbr2   := ::DbfProv:nBnfSbr2
         ::oDbf:nBnfSbr3   := ::DbfProv:nBnfSbr3
         ::oDbf:nBnfSbr4   := ::DbfProv:nBnfSbr4
         ::oDbf:nBnfSbr5   := ::DbfProv:nBnfSbr5
         ::oDbf:nBnfSbr6   := ::DbfProv:nBnfSbr6
         ::oDbf:nValPunt   := ::DbfProv:nValPunt
         ::oDbf:nDtoPunt   := ::DbfProv:Dtopp

      end if

      ::oBenef1:Refresh()
      ::oBenef2:Refresh()
      ::oBenef3:Refresh()
      ::oBenef4:Refresh()
      ::oBenef5:Refresh()
      ::oBenef6:Refresh()
      ::oBnfSbr1:Refresh()
      ::oBnfSbr2:Refresh()
      ::oBnfSbr3:Refresh()
      ::oBnfSbr4:Refresh()
      ::oBnfSbr5:Refresh()
      ::oBnfSbr6:Refresh()
      ::oValPnt:Refresh()
      ::oDtoPnt:Refresh()

   end if

   ::cPrvOld := ::oDbf:cCodProv

return ( .t. )

//---------------------------------------------------------------------------//

METHOD lCambia()

   if ApoloMsgNoYes(  "¿ Desea actualizar los artículos que tienen este proveedor por defecto ?", "Elija una opción" )

      ::oDbfArt:GoTop()

      while !::oDbfArt:eof()

         if ::oDbfArt:cCodCat == ::oDbf:cCodCata

            ::oDbfArt:Load()
            ::oDbfArt:nPunTos     := ::oDbf:nValPunt
            ::oDbfArt:nDtoPnt     := ::oDbf:nDtoPunt
            ::oDbfArt:cPrvHab     := ::oDbf:cCodProv

            if ::oDbfArt:lBnf1
               ::oDbfArt:Benef1   := ::oDbf:Benef1
               ::oDbfArt:nBnfSbr1 := ::oDbf:nBnfSbr1
            end if
            if ::oDbfArt:lBnf2
               ::oDbfArt:Benef2   := ::oDbf:Benef2
               ::oDbfArt:nBnfSbr2 := ::oDbf:nBnfSbr2
            end if
            if ::oDbfArt:lBnf3
               ::oDbfArt:Benef3   := ::oDbf:Benef3
               ::oDbfArt:nBnfSbr3 := ::oDbf:nBnfSbr3
            end if
            if ::oDbfArt:lBnf4
               ::oDbfArt:Benef4   := ::oDbf:Benef4
               ::oDbfArt:nBnfSbr4 := ::oDbf:nBnfSbr4
            end if
            if ::oDbfArt:lBnf5
               ::oDbfArt:Benef5   := ::oDbf:Benef5
               ::oDbfArt:nBnfSbr5 := ::oDbf:nBnfSbr5
            end if
            if ::oDbfArt:lBnf6
               ::oDbfArt:Benef6   := ::oDbf:Benef6
               ::oDbfArt:nBnfSbr6 := ::oDbf:nBnfSbr6
            end if

            ::oDbfArt:Save()

         end if

        ::oDbfArt:Skip()

      end while

   end if

RETURN .T.

//---------------------------------------------------------------------------//

/*Function lObsoleto( cCodCat, dbfCatalogo )

   local lObs     := .t.
   local nOrdAnt  := ( dbfCatalogo )->( OrdSetFocus( "cCodCata" ) )
   local nRec     := ( dbfCatalogo )->( recno() )

   ( dbfCatalogo )->( dbSeek( cCodCat ) )

   if ( dbfCatalogo )->lObsCat
      msgStop( "Catálogo obsoleto, no se puede asignar a un artículo" )
      return .f.
   end if

   ( dbfCatalogo )->( dbGoTo( nRec ) )
   ( dbfCatalogo )->( ordSetFocus( nOrdAnt ) )

return lObs*/

//---------------------------------------------------------------------------//

function nTotalPuntosEuros( nPuntos, nValorPnt, nDtoPnt )

   local nValor   := nPuntos * nValorPnt

   nValor         -= ( nValor * nDtoPnt ) / 100

return ( nValor )

//---------------------------------------------------------------------------//
//Function que calcula el precio de los artículos y los informa en la variables que les pasemos

Function aCalPrePnt( lSobreCoste, nCosto, lBnf, nBnf, uTipIva, nDecDiv, cCodImp, oNewImp, dbfIva )

	local nIvaPct
	local nNewPre
   local nNewIva  := 0

   /*
   El beneficio sobre la venta no puede ser major que el 100%----------------------
   */

   if !lSobreCoste .and. nBnf >= 100
      Return .f.
   end if

   if lBnf .and. nCosto != 0

      if ValType( uTipIva ) == "C"
         nIvaPct  := nIva( dbfIva, uTipIva )
      else
         nIvaPct  := uTipIva
      end if

      if lSobreCoste
         nNewPre  := Round( ( nCosto * nBnf / 100 ) + nCosto, nDecDiv )
      else
         nNewPre  := Round( ( nCosto / ( 1 - ( nBnf / 100 ) ) ), nDecDiv )
      end if

      /*
      Calculo del impuestos
      */

      nNewIva     := nNewPre

      /*
      Si tiene impuesto especial añadirlo
      */

      if !Empty( cCodImp )
         nNewIva  += oNewImp:nValImp( cCodImp, .t., nIvaPct )
      end if

      nNewIva     += Round( ( nNewIva * nIvaPct / 100 ), nDecDiv )

   end if

Return { nNewPre, nNewIva }

//---------------------------------------------------------------------------//