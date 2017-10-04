#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TCtaRem FROM TMant

   DATA  cMru                       INIT "gc_portfolio_folder_16"

   DATA  cBitmap                    INIT clrTopArchivos

   DATA  oBanco

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD OpenService( lExclusive )

   METHOD Resource( nMode )

   METHOD lGetCtaRem( cCodCta, oSay )

   METHOD cRetCtaRem( cCodCta, oSay )

   METHOD cRetCtaCon( cCodCta )

   METHOD cRetCtaDto( cCodCta )

   METHOD dFechaFirma( cCodCta )    INLINE ( if( ::oDbf:SeekInOrd( cCodCta, "cCodCta" ), ::oDbf:dFirPre, ctod("") ) )

   METHOD lValidResource( nMode, oDlg )

   METHOD lCargaBanco()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles()
      end if

      ::oBanco          := TBancos():Create()
      ::oBanco:OpenFiles()

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::cFirstKey       := ::oDbf:cCodCta

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos de cuentas de remesas." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock
   local oError

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos de cuentas de remesas." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TCtaRem

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if !Empty( ::oBanco )
      ::oBanco:End()
   end if

   ::oDbf      := nil
   ::oBanco    := nil

RETURN .t.

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE oDbf FILE "CTAREM.DBF" CLASS "CTAREM" ALIAS "CTAREM" PATH ( cPath ) VIA ( cDriver ) COMMENT "Cuentas de remesas"

      FIELD NAME "cCodCta"    TYPE "C" LEN  3  DEC 0 PICTURE "@!"                         COMMENT "Código"           COLSIZE 40        OF oDbf
      FIELD NAME "cNomCta"    TYPE "C" LEN 40  DEC 0 PICTURE "@!"                         COMMENT "Nombre"           COLSIZE 240       OF oDbf
      FIELD NAME "cDirCta"    TYPE "C" LEN 80  DEC 0                                      COMMENT "Domicilio"        COLSIZE 340       OF oDbf
      
      FIELD NAME "cPaisIBAN"  TYPE "C" LEN  2  DEC 0 PICTURE "@!"                         COMMENT "País IBAN"                    HIDE  OF oDbf
      FIELD NAME "cCtrlIBAN"  TYPE "C" LEN  2  DEC 0 PICTURE "99"                         COMMENT "Dígito de control IBAN"       HIDE  OF oDbf
      
      FIELD NAME "cEntBan"    TYPE "C" LEN  4  DEC 0 PICTURE "9999"                       COMMENT "Entidad"                      HIDE  OF oDbf
      FIELD NAME "cAgcBan"    TYPE "C" LEN  4  DEC 0 PICTURE "9999"                       COMMENT "Agencia"                      HIDE  OF oDbf
      FIELD NAME "cDgcBan"    TYPE "C" LEN  2  DEC 0 PICTURE "99"                         COMMENT "DC"                           HIDE  OF oDbf
      FIELD NAME "cCtaBan"    TYPE "C" LEN 10  DEC 0 PICTURE "9999999999"                 COMMENT "Cuenta"                       HIDE  OF oDbf

      FIELD CALCULATE NAME "bCtaBnc"   LEN 24  DEC 0                                      COMMENT "Cuenta bancaria" ;
         VAL {|| oDbf:FieldGetByName( "cPaisIBAN" ) + oDbf:FieldGetByName( "cCtrlIBAN" ) + "-" + oDbf:FieldGetByName( "cEntBan" ) + "-" + oDbf:FieldGetByName( "cAgcBan" ) + "-" + oDbf:FieldGetByName( "cDgcBan" ) + "-" + oDbf:FieldGetByName( "cCtaBan" ) };
                                                                                          COLSIZE 200                                  OF oDbf

      FIELD NAME "cSufCta"    TYPE "C" LEN  3  DEC 0 PICTURE "@!"          DEFAULT "000"  COMMENT "Sufijo"                       HIDE  OF oDbf
      FIELD NAME "cSufN58"    TYPE "C" LEN  3  DEC 0 PICTURE "@!"                         COMMENT "Sufijo Norma 58"              HIDE  OF oDbf

      FIELD NAME "cCodPre"    TYPE "C" LEN  2  DEC 0 PICTURE "99"                         COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cNifPre"    TYPE "C" LEN  9  DEC 0 PICTURE "@!"                         COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cNomPre"    TYPE "C" LEN 40  DEC 0 PICTURE "@!"                         COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cEntPre"    TYPE "C" LEN  4  DEC 0 PICTURE "9999"                       COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cAgcPre"    TYPE "C" LEN  4  DEC 0 PICTURE "9999"                       COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cPaiPre"    TYPE "C" LEN  2  DEC 0 PICTURE "@!"                         COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "dFirPre"    TYPE "D" LEN  8  DEC 0 PICTURE ""                           COMMENT ""                             HIDE  OF oDbf

      FIELD NAME "cCodAcr"    TYPE "C" LEN  2  DEC 0 PICTURE "99"                         COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cPaiAcr"    TYPE "C" LEN  2  DEC 0 PICTURE "@!"                         COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cNifAcr"    TYPE "C" LEN  9  DEC 0 PICTURE "@!"                         COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cNomAcr"    TYPE "C" LEN 40  DEC 0 PICTURE "@!"                         COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cDirAcr"    TYPE "C" LEN 60  DEC 0                                      COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cPosAcr"    TYPE "C" LEN 15  DEC 0                                      COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cPobAcr"    TYPE "C" LEN 40  DEC 0                                      COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cProAcr"    TYPE "C" LEN 40  DEC 0                                      COMMENT ""                             HIDE  OF oDbf

      FIELD NAME "cSubCta"    TYPE "C" LEN 12  DEC 0                                      COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cCtaDto"    TYPE "C" LEN 12  DEC 0                                      COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cCodIne"    TYPE "C" LEN  6  DEC 0                                      COMMENT ""                             HIDE  OF oDbf
      FIELD NAME "cBanco"     TYPE "C" LEN 50  DEC 0                                      COMMENT ""                             HIDE  OF oDbf

      INDEX TO "CtaRem.Cdx" TAG "cCodCta" ON "cCodCta" COMMENT "Código" NODELETED OF oDbf
      INDEX TO "CtaRem.Cdx" TAG "cNomCta" ON "cNomCta" COMMENT "Nombre" NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oGetCta
   local oGetDto
   local cGetSubCta  := ""
   local oGetSubCta
   local cGetCtaDto  := ""
   local oGetCtaDto
   local oGetDgtBan
   local oBanco
   local oPaisIBAN
   local oCtrlIBAN
   local oEntBnc
   local oSucBnc
   local oCtaBnc
   local oEntPre
   local oAgcPre

   DEFINE DIALOG oDlg RESOURCE "CtaRem" TITLE LblTitle( nMode ) + "cuentas de remesas"

      REDEFINE GET oGet VAR ::oDbf:cCodCta ;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
         PICTURE  ::oDbf:FieldByName( "cCodCta" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oDbf:cNomCta ;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oDbf:FieldByName( "cNomCta" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oDbf:cDirCta ;
         ID       120 ;
         PICTURE  ::oDbf:FieldByName( "cDirCta" ):cPict ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET oBanco VAR ::oDbf:cBanco ;
         ID       300 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      oBanco:bHelp   := {|| ::lCargaBanco( oBanco, oEntBnc, oSucBnc, oGetDgtBan, oCtaBnc, oEntPre, oAgcPre ) }

      REDEFINE GET oPaisIBAN VAR ::oDbf:cPaisIBAN ;
         ID       130 ;
         PICTURE  ::oDbf:FieldByName( "cPaisIBAN" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( lIbanDigit( ::oDbf:cPaisIBAN, ::oDbf:cEntBan, ::oDbf:cAgcBan, ::oDbf:cDgcBan, ::oDbf:cCtaBan, oCtrlIBAN ) ) ;
         OF       oDlg

      REDEFINE GET oCtrlIBAN VAR ::oDbf:cCtrlIBAN ;
         ID       131 ;
         PICTURE  ::oDbf:FieldByName( "cAgcBan" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( oPaisIBAN:lValid() ) ;
         OF       oDlg

      REDEFINE GET oEntBnc VAR ::oDbf:cEntBan ;
         ID       132 ;
         PICTURE  ::oDbf:FieldByName( "cEntBan" ):cPict ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( ::oDbf:cEntBan, ::oDbf:cAgcBan, ::oDbf:cDgcBan, ::oDbf:cCtaBan, oGetDgtBan ), oPaisIBAN:lValid() ) ;
			OF 		oDlg

      REDEFINE GET oSucBnc VAR ::oDbf:cAgcBan ;
         ID       133 ;
         PICTURE  ::oDbf:FieldByName( "cAgcBan" ):cPict ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( ::oDbf:cEntBan, ::oDbf:cAgcBan, ::oDbf:cDgcBan, ::oDbf:cCtaBan, oGetDgtBan ), oPaisIBAN:lValid() ) ;
			OF 		oDlg

      REDEFINE GET oGetDgtBan VAR ::oDbf:cDgcBan ;
         ID       134 ;
         PICTURE  ::oDbf:FieldByName( "cDgcBan" ):cPict ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( ::oDbf:cEntBan, ::oDbf:cAgcBan, ::oDbf:cDgcBan, ::oDbf:cCtaBan, oGetDgtBan ), oPaisIBAN:lValid() ) ;
			OF 		oDlg

      REDEFINE GET oCtaBnc VAR ::oDbf:cCtaBan ;
         ID       135 ;
         PICTURE  ::oDbf:FieldByName( "cCtaBan" ):cPict ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         VALID    ( lCalcDC( ::oDbf:cEntBan, ::oDbf:cAgcBan, ::oDbf:cDgcBan, ::oDbf:cCtaBan, oGetDgtBan ), oPaisIBAN:lValid() ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cSufCta ;
         ID       170 ;
         PICTURE  ::oDbf:FieldByName( "cSufCta" ):cPict ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGetCta VAR ::oDbf:cSubCta ;
         ID       240 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( oGetCta, oGetSubCta ) ) ;
         VALID    ( MkSubcuenta( oGetCta,;
                              {  ::oDbf:cSubCta,;
                                 ::oDbf:cNomCta,;
                                 "",;
                                 ::oDbf:cDirCta,;
                                 "",;
                                 "",;
                                 "" },;
                              oGetSubCta ) );
         OF       oDlg

		REDEFINE GET oGetSubCta VAR cGetSubCta ;
         ID       241 ;
			WHEN 		.F. ;
         OF       oDlg

      /*
      Subcuenta de descuento---------------------------------------------------
      */

      REDEFINE GET oGetDto VAR ::oDbf:cCtaDto ;
         ID       250 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( nLenCuentaContaplus() != 0 .AND. nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( oGetDto, oGetCtaDto ) ) ;
         VALID    ( MkSubcuenta( oGetDto,;
                              {  ::oDbf:cSubCta,;
                                 ::oDbf:cNomCta,;
                                 "",;
                                 ::oDbf:cDirCta,;
                                 "",;
                                 "",;
                                 "" },;
                              oGetCtaDto ) );
         OF       oDlg

      REDEFINE GET oGetCtaDto VAR cGetCtaDto ;
         ID       251 ;
			WHEN 		.F. ;
         OF       oDlg

      /*
      Datos del presentador---------------------------------------------------
      */

      REDEFINE GET ::oDbf:cCodPre ;
         ID       190 ;
         PICTURE  ::oDbf:FieldByName( "cCodPre" ):cPict ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cPaiPre ;
         ID       270 ;
         PICTURE  ::oDbf:FieldByName( "cPaiPre" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cNomPre ;
         ID       200 ;
         PICTURE  ::oDbf:FieldByName( "cNomPre" ):cPict ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cNifPre ;
         ID       210 ;
         PICTURE  ::oDbf:FieldByName( "cNifPre" ):cPict ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET oEntPre VAR ::oDbf:cEntPre ;
         ID       220 ;
         PICTURE  ::oDbf:FieldByName( "cEntPre" ):cPict ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET oAgcPre VAR ::oDbf:cAgcPre ;
         ID       230 ;
         PICTURE  ::oDbf:FieldByName( "cAgcPre" ):cPict ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cCodIne UPDATE ;
         ID       260 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:dFirPre ;
         ID       280 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Acreeedor----------------------------------------------------------------
      */

      REDEFINE GET ::oDbf:cCodAcr ;
         ID       400 ;
         PICTURE  ::oDbf:FieldByName( "cCodAcr" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cPaiAcr ;
         ID       410 ;
         PICTURE  ::oDbf:FieldByName( "cPaiAcr" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cNomAcr ;
         ID       420 ;
         PICTURE  ::oDbf:FieldByName( "cNomAcr" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cNifAcr ;
         ID       430 ;
         PICTURE  ::oDbf:FieldByName( "cNifAcr" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cDirAcr ;
         ID       440 ;
         PICTURE  ::oDbf:FieldByName( "cDirAcr" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cPosAcr ;
         ID       450 ;
         PICTURE  ::oDbf:FieldByName( "cPosAcr" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cPobAcr ;
         ID       460 ;
         PICTURE  ::oDbf:FieldByName( "cPobAcr" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cProAcr ;
         ID       470 ;
         PICTURE  ::oDbf:FieldByName( "cProAcr" ):cPict ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Botones------------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lValidResource( nMode, oGet, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ::lValidResource( nMode, oGet, oDlg ) } )
   end if

   oDlg:bStart    := { || oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lCargaBanco( oBnc, oEnt, oSuc, oDig, oCta, oEntPre, oAgcPre )

   local cBanco   := ::oBanco:Buscar( , "cCodBnc" )

   if !Empty( cBanco )

      oBnc:cText( oRetFld( cBanco, ::oBanco:oDbf, "cNomBnc" ) )
      oEnt:cText( oRetFld( cBanco, ::oBanco:oDbf, "cEntBnc" ) )
      oSuc:cText( oRetFld( cBanco, ::oBanco:oDbf, "cOfiBnc" ) )
      oDig:cText( Space( 2 ) )
      oCta:cText( Space( 10 ) )

      oEntPre:cText( oRetFld( cBanco, ::oBanco:oDbf, "cEntBnc" ) )
      oAgcPre:cText( oRetFld( cBanco, ::oBanco:oDbf, "cOfiBnc" ) )

   end if

Return .t.

//---------------------------------------------------------------------------//

Method lValidResource( nMode, oGet, oDlg )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ::oDbf:SeekInOrd( ::oDbf:cCodCta, "cCodCta" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodCta ) )
         return nil
      end if

   end if

   if Empty( ::oDbf:cNomCta )
      MsgStop( "El nombre de la cuenta de remesa no puede estar vacío." )
      Return nil
   end if

Return ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD lGetCtaRem( oCodCta, oSay )

   local lRet     := .f.
   local xValor   := oCodCta:VarGet()

   if Empty( xValor )
      if( oSay != nil, oSay:cText( "" ), )
      return .t.
   else
      xValor      := RJustObj( oCodCta, "0" )
   end if

   if ::oDbf:SeekInOrd( xValor, "cCodCta" )
      oSay:cText( ::oDbf:cNomCta )
      lRet        := .t.
   else
      msgStop( "Cuenta de remesa no encontrada" )
   end if

RETURN ( lRet )

//--------------------------------------------------------------------------//

METHOD cRetCtaRem( cCodCta )

   local cRet  := ""

   if !Empty( ::oDbf )
      if ::oDbf:SeekInOrd( cCodCta, "cCodCta" )
         cRet  := ::oDbf:cNomCta
      end if
   end if

RETURN ( cRet )

//--------------------------------------------------------------------------//

METHOD cRetCtaCon( cCodCta )

   local cRet  := ""

   if ::oDbf:SeekInOrd( cCodCta, "cCodCta" )
      cRet     := ::oDbf:cSubCta
   end if

RETURN ( cRet )

//--------------------------------------------------------------------------//

METHOD cRetCtaDto( cCodCta )

   local cRet  := ""

   if ::oDbf:SeekInOrd( cCodCta, "cCodCta" )
      cRet     := ::oDbf:cCtaDto
   end if

RETURN ( cRet )

//--------------------------------------------------------------------------//