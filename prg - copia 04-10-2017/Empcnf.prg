#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Empresa.ch"
#include "DbInfo.ch"

//---------------------------------------------------------------------------//
//Funciones del programa
//---------------------------------------------------------------------------//

FUNCTION RetPicCodPrvEmp()

RETURN Replicate( "9", RetNumCodPrvEmp() )

//---------------------------------------------------------------------------//

FUNCTION cProCnt( cSerie )

   DEFAULT cSerie := "A"

   do case
      case cSerie == "A"
         RETURN aEmp()[ _CCODPROA ]
      case cSerie == "B"
         RETURN aEmp()[ _CCODPROB ]
      case cSerie == "C"
         RETURN aEmp()[ _CCODPROC ]
      case cSerie == "D"
         RETURN aEmp()[ _CCODPROD ]
      case cSerie == "E"
         RETURN aEmp()[ _CCODPROE ]
      case cSerie == "F"
         RETURN aEmp()[ _CCODPROF ]
      case cSerie == "G"
         RETURN aEmp()[ _CCODPROG ]
      case cSerie == "H"
         RETURN aEmp()[ _CCODPROH ]
      case cSerie == "I"
         RETURN aEmp()[ _CCODPROI ]
      case cSerie == "J"
         RETURN aEmp()[ _CCODPROJ ]
      case cSerie == "K"
         RETURN aEmp()[ _CCODPROK ]
      case cSerie == "L"
         RETURN aEmp()[ _CCODPROL ]
      case cSerie == "M"
         RETURN aEmp()[ _CCODPROM ]
      case cSerie == "N"
         RETURN aEmp()[ _CCODPRON ]
      case cSerie == "0"
         RETURN aEmp()[ _CCODPROO ]
      case cSerie == "P"
         RETURN aEmp()[ _CCODPROP ]
      case cSerie == "Q"
         RETURN aEmp()[ _CCODPROQ ]
      case cSerie == "R"
         RETURN aEmp()[ _CCODPROR ]
      case cSerie == "S"
         RETURN aEmp()[ _CCODPROS ]
      case cSerie == "T"
         RETURN aEmp()[ _CCODPROT ]
      case cSerie == "U"
         RETURN aEmp()[ _CCODPROU ]
      case cSerie == "V"
         RETURN aEmp()[ _CCODPROV ]
      case cSerie == "W"
         RETURN aEmp()[ _CCODPROW ]
      case cSerie == "X"
         RETURN aEmp()[ _CCODPROX ]
      case cSerie == "Y"
         RETURN aEmp()[ _CCODPROY ]
      case cSerie == "Z"
         RETURN aEmp()[ _CCODPROZ ]
   end case

return ( aEmp()[ _CCODPROA ] )

//---------------------------------------------------------------------------//

FUNCTION cCodEnvUsr() ; return ( aEmp()[ _CENVUSR ] )
FUNCTION nTipConInt() ; return ( aEmp()[ _NTIPCON ] )
FUNCTION cRutConInt() ; return ( Upper( cPath( AllTrim( aEmp()[ _CRUTCON ] ) ) ) )
FUNCTION cRutConFrq() ; return ( cRutConInt() + "FRQ\" )
FUNCTION cNomConInt() ; return ( aEmp()[ _CNOMCON ] )
FUNCTION cUsrConInt() ; return ( aEmp()[ _CUSRCON ] )
FUNCTION cPswConInt() ; return ( aEmp()[ _CPSWCON ] )

//--------------------------------------------------------------------------//

FUNCTION cUsrConUsr() ; return ( aEmp()[ _CUSRCON ] )

//--------------------------------------------------------------------------//

FUNCTION cSitFtp() ; return ( aEmp()[ _CSITFTP ] )
FUNCTION cUsrFtp() ; return ( aEmp()[ _CUSRFTP ] )
FUNCTION cPswFtp() ; return ( aEmp()[ _CPSWFTP ] )

//--------------------------------------------------------------------------//

FUNCTION cSitSql() ; return ( aEmp()[ _CSITSQL ] )
FUNCTION cUsrSql() ; return ( aEmp()[ _CUSRSQL ] )
FUNCTION cPswSql() ; return ( aEmp()[ _CPSWSQL ] )
FUNCTION nPrtSql() ; return ( aEmp()[ _NPRTSQL ] )
FUNCTION cDtbSql() ; return ( aEmp()[ _CDTBSQL ] )

//---------------------------------------------------------------------------//

FUNCTION nCurCob( nCurCob, dbfEmp )

   local oBlock
   local oError
   local lCloEmp  := .f.

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if nCurCob != nil

      if dbfEmp == nil
         USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
         SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE
         lCloEmp   := .t.
      end if

      if ( dbfEmp )->( dbSeek( cEmpUsr() ) )
         if ( dbfEmp )->( dbRLock() )
            aEmp()[ _NNUMCOB ]   := nCurCob
            ( dbfEmp )->nNumCob  := nCurCob
            ( dbfEmp )->( dbUnLock() )
         end if
      end if

      if lCloEmp
         ( dbfEmp )->( dbCloseArea() )
      end if

   else

      nCurCob              := if( aEmp()[ _NNUMCOB ] == 0, 1, aEmp()[ _NNUMCOB ] )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( nCurCob )

//---------------------------------------------------------------------------//

FUNCTION lActCos() ; RETURN ( aEmp()[ _LACTCOS ] )

//---------------------------------------------------------------------------//

FUNCTION lNumObr( lNumObr ) ; RETURN ( aEmp()[ _LNUMOBR ] )

//---------------------------------------------------------------------------//

FUNCTION cNumObr() ; RETURN ( aEmp()[ _CNUMOBR ] )

//---------------------------------------------------------------------------//

FUNCTION lNumPed( lNumPed )

   if lNumPed != Nil
      Return ( aEmp()[ _CNUMPED ] )
   end if

RETURN ( aEmp()[ _LNUMPED ] )

//---------------------------------------------------------------------------//

FUNCTION cNumPed() ; RETURN ( aEmp()[ _CNUMPED ] )

//---------------------------------------------------------------------------//

FUNCTION lNumAlb( lNumAlb )

   if lNumAlb != Nil
      Return ( aEmp()[ _CNUMALB ] )
   end if

RETURN ( aEmp()[ _LNUMALB ] )

//---------------------------------------------------------------------------//

FUNCTION cNumAlb() ; RETURN ( aEmp()[ _CNUMALB ] )

//---------------------------------------------------------------------------//

FUNCTION lSuAlb( lSuAlb )

   if lSuAlb != Nil
      Return ( aEmp()[ _CSUALB ] )
   end if

RETURN ( aEmp()[ _LSUALB ] )

//---------------------------------------------------------------------------//

FUNCTION cSuAlb() ; RETURN ( aEmp()[ _CSUALB ] )

//---------------------------------------------------------------------------//

FUNCTION SetDefAlm( cDefAlm )

   if !Empty( cDefAlm )
      aEmp()[ _CDEFALM ] := cDefAlm
   end if

RETURN ( aEmp()[ _CDEFALM ] )

//---------------------------------------------------------------------------//

FUNCTION cDefAlm() ; RETURN ( uFieldEmpresa( "CDEFALM" ) )

//---------------------------------------------------------------------------//

FUNCTION cDefCli() ; RETURN ( aEmp()[ _CDEFCLI ] )

//---------------------------------------------------------------------------//

FUNCTION cDefCaj() ; RETURN ( aEmp()[ _CDEFCAJ ] )

//---------------------------------------------------------------------------//

FUNCTION lImpuestosIncluidos() ; RETURN( aEmp()[ _LIVAINC ] )

//---------------------------------------------------------------------------//

FUNCTION lObras()     ; RETURN ( aEmp()[ _LGETCOB ] )

//---------------------------------------------------------------------------//

FUNCTION DecUnd() ; RETURN ( aEmp()[ _NDECUND ] )

//---------------------------------------------------------------------------//

FUNCTION cCtaCli() ; RETURN ( aEmp()[ _CCTACLI ] )

//----------------------------------------------------------------------------//

FUNCTION cCtaPrv() ; RETURN ( aEmp()[ _CCTAPRV ] )

//----------------------------------------------------------------------------//

FUNCTION cCtaVta() ; RETURN ( aEmp()[ _CCTAVTA ] )

//----------------------------------------------------------------------------//

FUNCTION cCtaCob() ; RETURN ( aEmp()[ _CCTACOB ] )

//----------------------------------------------------------------------------//

FUNCTION cCtaSin() ; RETURN ( aEmp()[ _CCTASIN ] )

//----------------------------------------------------------------------------//

FUNCTION cCtaAnt() ; RETURN ( aEmp()[ _CCTAANT ] )

//----------------------------------------------------------------------------//

FUNCTION cCtaRet() ; RETURN ( aEmp()[ _CCTARET ] )

//----------------------------------------------------------------------------//

FUNCTION cEmpCnt( cSerie )

   DEFAULT cSerie := "A"

   do case
      case cSerie == "A"
         RETURN Alltrim( aEmp()[ _CCODEMPA ] )
      case cSerie == "B"
         RETURN Alltrim( aEmp()[ _CCODEMPB ] )
      case cSerie == "C"
         RETURN Alltrim( aEmp()[ _CCODEMPC ] )
      case cSerie == "D"
         RETURN Alltrim( aEmp()[ _CCODEMPD ] )
      case cSerie == "E"
         RETURN Alltrim( aEmp()[ _CCODEMPE ] )
      case cSerie == "F"
         RETURN Alltrim( aEmp()[ _CCODEMPF ] )
      case cSerie == "G"
         RETURN Alltrim( aEmp()[ _CCODEMPG ] )
      case cSerie == "H"
         RETURN Alltrim( aEmp()[ _CCODEMPH ] )
      case cSerie == "I"
         RETURN Alltrim( aEmp()[ _CCODEMPI ] )
      case cSerie == "J"
         RETURN Alltrim( aEmp()[ _CCODEMPJ ] )
      case cSerie == "K"
         RETURN Alltrim( aEmp()[ _CCODEMPK ] )
      case cSerie == "L"
         RETURN Alltrim( aEmp()[ _CCODEMPL ] )
      case cSerie == "M"
         RETURN Alltrim( aEmp()[ _CCODEMPM ] )
      case cSerie == "N"
         RETURN Alltrim( aEmp()[ _CCODEMPN ] )
      case cSerie == "O"
         RETURN Alltrim( aEmp()[ _CCODEMPO ] )
      case cSerie == "P"
         RETURN Alltrim( aEmp()[ _CCODEMPP ] )
      case cSerie == "Q"
         RETURN Alltrim( aEmp()[ _CCODEMPQ ] )
      case cSerie == "R"
         RETURN Alltrim( aEmp()[ _CCODEMPR ] )
      case cSerie == "S"
         RETURN Alltrim( aEmp()[ _CCODEMPS ] )
      case cSerie == "T"
         RETURN Alltrim( aEmp()[ _CCODEMPT ] )
      case cSerie == "U"
         RETURN Alltrim( aEmp()[ _CCODEMPU ] )
      case cSerie == "V"
         RETURN Alltrim( aEmp()[ _CCODEMPV ] )
      case cSerie == "W"
         RETURN Alltrim( aEmp()[ _CCODEMPW ] )
      case cSerie == "X"
         RETURN Alltrim( aEmp()[ _CCODEMPX ] )
      case cSerie == "Y"
         RETURN Alltrim( aEmp()[ _CCODEMPY ] )
      case cSerie == "Z"
         RETURN Alltrim( aEmp()[ _CCODEMPZ ] )
   end case

RETURN ""

//---------------------------------------------------------------------------//

Function nDefBnf( nPct )

   DEFAULT nPct   := 1

   do case
      case nPct == 1
         return aEmp()[ _NDEFBNF1 ]
      case nPct == 2
         return aEmp()[ _NDEFBNF2 ]
      case nPct == 3
         return aEmp()[ _NDEFBNF3 ]
      case nPct == 4
         return aEmp()[ _NDEFBNF4 ]
      case nPct == 5
         return aEmp()[ _NDEFBNF5 ]
      case nPct == 6
         return aEmp()[ _NDEFBNF6 ]
   end case

return ( 0 )

//---------------------------------------------------------------------------//

FUNCTION nDefSbr( nPct )

   DEFAULT nPct   := 1

   do case
      case nPct == 1
         Return aEmp()[ _NDEFSBR1 ]
      case nPct == 2
         Return aEmp()[ _NDEFSBR2 ]
      case nPct == 3
         Return aEmp()[ _NDEFSBR3 ]
      case nPct == 4
         Return aEmp()[ _NDEFSBR4 ]
      case nPct == 5
         Return aEmp()[ _NDEFSBR5 ]
      case nPct == 6
         Return aEmp()[ _NDEFSBR6 ]
   end case

return ( 0 )

//---------------------------------------------------------------------------//

FUNCTION lLotes() ; RETURN ( aEmp()[ _LGETLOT ] )

//---------------------------------------------------------------------------//

FUNCTION lMostrarCostos() ; RETURN ( !( aEmp()[ _LSHWCOS ] .or. oUser():lNotCostos() ) )

//---------------------------------------------------------------------------//

FUNCTION lRecogerUsuario() ; RETURN ( uFieldEmpresa( "lGetUsr" ) )

//---------------------------------------------------------------------------//

FUNCTION lRecogerAgentes() ; RETURN ( uFieldEmpresa( "lGetAge" ) )

//---------------------------------------------------------------------------//

FUNCTION lRecogerUbicacion() ; RETURN ( uFieldEmpresa( "lGetUbi" ) )

//---------------------------------------------------------------------------//

FUNCTION lImporteExacto() ; RETURN ( aEmp()[ _LIMPEXA ] )

//---------------------------------------------------------------------------//

FUNCTION lShwKit( lShwKit )

   if IsLogic( lShwKit )
      SetFieldEmpresa( lShwKit, "lShwKit" )
   end if

RETURN ( uFieldEmpresa( "lShwKit" ) )

//---------------------------------------------------------------------------//

FUNCTION cNbrEmp() ; RETURN ( if( IsArray( aEmp() ), Rtrim( aEmp()[ _CNOMBRE    ] ), "" ) )
FUNCTION cNifEmp() ; RETURN ( if( IsArray( aEmp() ), Rtrim( aEmp()[ _CNIF       ] ), "" ) )
FUNCTION cAdmEmp() ; RETURN ( if( IsArray( aEmp() ), Rtrim( aEmp()[ _CADMINIS   ] ), "" ) )
FUNCTION cDomEmp() ; RETURN ( if( IsArray( aEmp() ), Rtrim( aEmp()[ _CDOMICILIO ] ), "" ) )
FUNCTION cPobEmp() ; RETURN ( if( IsArray( aEmp() ), Rtrim( aEmp()[ _CPOBLACION ] ), "" ) )
FUNCTION cPrvEmp() ; RETURN ( if( IsArray( aEmp() ), Rtrim( aEmp()[ _CPROVINCIA ] ), "" ) )
FUNCTION cCdpEmp() ; RETURN ( if( IsArray( aEmp() ), Rtrim( aEmp()[ _CCODPOS    ] ), "" ) )
FUNCTION cTlfEmp() ; RETURN ( if( IsArray( aEmp() ), Rtrim( aEmp()[ _CTLF       ] ), "" ) )
FUNCTION cFaxEmp() ; RETURN ( if( IsArray( aEmp() ), Rtrim( aEmp()[ _CFAX       ] ), "" ) )
FUNCTION cEmaEmp() ; RETURN ( if( IsArray( aEmp() ), Rtrim( aEmp()[ _EMAIL      ] ), "" ) )
FUNCTION cWebEmp() ; RETURN ( if( IsArray( aEmp() ), Rtrim( aEmp()[ _WEB        ] ), "" ) )

//---------------------------------------------------------------------------//

/*
Obtiene el nuevo numero de la factura
*/

FUNCTION cFormatoDocumento( cSerie, cTipDoc, dbfCount )

   local oBlock
   local oError
   local nPos
   local lClo        := .f.
   local cDoc        := ""

   DEFAULT cSerie    := "A"

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( dbfCount )
         USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
         SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE
         lClo        := .t.
      end if

      nPos           := ( dbfCount )->( fieldPos( "Doc" + cSerie ) )

      /*
      Hasta q no encuentre un numero valido se pone a dar vueltas
      */

      if ( dbfCount )->( dbSeek( Upper( cTipDoc ) ) )
         cDoc           := ( dbfCount )->( fieldGet( nPos ) )
      else
         msgStop( "No encuentro el tipo de documento " + cTipDoc )
      end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClo
      CLOSE ( dbfCount )
   end if

RETURN ( cDoc )

//---------------------------------------------------------------------------//

FUNCTION nCopiasDocumento( cSerie, cTipDoc, dbfCount )

   local oBlock
   local oError
   local nPos
   local lClo        := .f.
   local nCop        := 0

   DEFAULT cSerie    := "A"

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfCount )
      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE
      lClo           := .t.
   end if

   nPos              := ( dbfCount )->( fieldPos( "Copias" + cSerie ) )

   /*
   Hasta q no encuentre un numero valido se pone a dar vueltas
   */

   if ( dbfCount )->( dbSeek( Upper( cTipDoc ) ) )

      nCop           := ( dbfCount )->( fieldGet( nPos ) )

   else

      msgStop( "No encuentro el tipo de documento " + cTipDoc )

   end if

   /*
   Cerramos las bases de datos
   */

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClo
      CLOSE ( dbfCount )
   end if

RETURN ( nCop )

//---------------------------------------------------------------------------//

FUNCTION cGetHtmlDocumento( cTipDoc, dbfCount )

   local oBlock
   local oError
   local lClo        := .f.
   local cDoc        := ""

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( dbfCount )
         USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "nCount", @dbfCount ) )
         SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE
         lClo        := .t.
      end if

      if ( dbfCount )->( dbSeek( Upper( cTipDoc ) ) )
         cDoc        := ( dbfCount )->cPltDfl
      else
         msgStop( "No encuentro el tipo de documento " + cTipDoc )
      end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClo
      CLOSE ( dbfCount )
   end if

RETURN ( cDoc )

//---------------------------------------------------------------------------//

FUNCTION setHtmlDocumento( cTipDoc, cHtmlDocumento, dbfCount )

   local oBlock
   local oError
   local lClo        := .f.
   local cDoc        := ""

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( dbfCount )
         USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "nCount", @dbfCount ) )
         SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE
         lClo        := .t.
      end if

      if ( dbfCount )->( dbSeek( Upper( cTipDoc ) ) )
         if ( dbfCount )->( dbRLock() )
            ( dbfCount )->cPltDfl   := cHtmlDocumento
            ( dbfCount )->( dbUnLock() )
         end if
      else
         msgStop( "No encuentro el tipo de documento " + cTipDoc )
      end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClo
      CLOSE ( dbfCount )
   end if

RETURN ( cDoc )

//---------------------------------------------------------------------------//

Function lIvaReq() ; Return ( aEmp()[ _LIVAREQ ] )

//---------------------------------------------------------------------------//

Function lEnviarEntregados() ; Return ( aEmp()[ _LENVENT ] )

//---------------------------------------------------------------------------//

Function nDiasValidez() ; Return ( aEmp()[ _NDIAVAL ] )

//---------------------------------------------------------------------------//
//Funciones para el programa y para pda
//---------------------------------------------------------------------------//

FUNCTION MasUnd( lCeros )

   if Empty( aEmp() )
      RETURN RetPic( 8, 0, lCeros )
   end if

RETURN RetPic( aEmp()[ _NDGTUND ], aEmp()[ _NDECUND ], lCeros )

//---------------------------------------------------------------------------//

FUNCTION MasEsc( lCeros )

   if Empty( aEmp() )
      RETURN RetPic( 8, 0, lCeros )
   end if

RETURN RetPic( aEmp()[ _NDGTESC ], aEmp()[ _NDECESC ], lCeros )

//---------------------------------------------------------------------------//

FUNCTION cDivChg( cDiv )

   local cDivChg     := "PTS"

   if !Empty( aEmp() )

      if cDiv != nil
          aEmp()[ _CDIVCHG ]  := cDiv
          cDivChg             := cDiv
      else
          cDivChg             := aEmp()[ _CDIVCHG ]
      end if

   end if

RETURN ( cDivChg )

//---------------------------------------------------------------------------//

FUNCTION cDivEmp( cDiv )

   local cDivEmp  := "EUR"

   if !Empty( aEmp() )

      if cDiv != nil
          aEmp()[ _CDIVEMP ]  := cDiv
          cDivEmp             := cDiv
      else
          cDivEmp             := aEmp()[ _CDIVEMP ]
      end if

   end if

RETURN ( cDivEmp )

//---------------------------------------------------------------------------//

FUNCTION lCalCaj()

   local lCalCaj  := .f.

   if !Empty( aEmp() )
      lCalCaj     := aEmp()[ _LCALCAJ ]
   end if

RETURN ( lCalCaj )

//---------------------------------------------------------------------------//

FUNCTION cCodEmp() ; RETURN ( if( IsArray( aEmp() ), aEmp()[ _CODEMP ], "" ) )

//---------------------------------------------------------------------------//

//
// Devuelve si una empresa esta convertida
//

Function lEmpCnv()

   if Empty( aEmp() )
      Return ( .t. )
   end if

Return ( aEmp()[ _CDIVEMP ] != "PTS" )

//---------------------------------------------------------------------------//

Function lRECCEmpresa( dFecha )

   local nAnyo    

   DEFAULT dFecha := GetSysDate()

   nAnyo          := Year( dFecha )

   if ( nAnyo < 2014 )
      Return .f.
   end if

   if uFieldEmpresa( "lRECC" ) .and. ( nAnyo >= uFieldEmpresa( "nIniRECC" ) ) .and. ( nAnyo <= uFieldEmpresa( "nFinRECC" ) .or. uFieldEmpresa( "nFinRECC" ) == 0 )
      Return .t.
   end if 

Return .f.

//---------------------------------------------------------------------------//

Function uFieldEmpresa( cField, uDefault )

   local uField
   local nField

   nField         := aScan( aItmEmp(), {|x| Upper( x[1] ) == Upper( cField ) } )

   if nField != 0 .and. !Empty( aEmp() )

      uField      := aEmp()[ nField ]

      if Valtype( uField ) == "C"
         uField   := Alltrim( uField )
      end if

   end if

   if Empty( uField ) .and. !IsNil( uDefault )
      uField      := uDefault
   end if

Return ( uField )

//---------------------------------------------------------------------------//

FUNCTION SetFieldEmpresa( nVal, cField )

   local nField
   local oBlock
   local oError
   local dbfEmp
   local cCodEmp  := cCodigoEmpresaEnUso() // GetCodEmp()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

      nField      := ( dbfEmp )->( FieldPos( cField ) )

      if nField != 0

         if ( dbfEmp )->( dbSeek( cCodEmp ) )

            if ( dbfEmp )->( dbRLock() )
               ( dbfEmp )->( FieldPut( nField, nVal ) )
               ( dbfEmp )->( dbUnLock() )
            end if

            SetEmp( nVal, nField )

         end if

      end if

      ( dbfEmp )->( dbCloseArea() )

   RECOVER USING oError

      msgStop( "Imposible abrir las bases de datos de empresas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( nVal )

//---------------------------------------------------------------------------//
/*
Devuelve el numero de digitos de clientes de la empresa activa
*/

Function RetNumCodCliEmp()

   local nNumCod  := 7
   local dbfEmp

   if !Empty( aEmp() )

      if Empty( aEmp()[ _CCODGRP ] )

         nNumCod     := aEmp()[ _NCODCLI ]

      else

         if !aEmp()[ _LGRPCLI ]

            nNumCod  := aEmp()[ _NCODCLI ]

         else

            USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
            SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

            if ( dbfEmp )->( dbSeek( aEmp()[ _CCODGRP ] ) )
               nNumCod     := ( dbfEmp )->nCodCli
            else
               nNumCod     := aEmp()[ _NCODCLI ]
            end if

            ( dbfEmp )->( dbCloseArea() )

         end if

      end if

   end if

return ( nNumCod )

//---------------------------------------------------------------------------//

FUNCTION RetSufEmp()

return ( oUser():cDelegacion() )

//--------------------------------------------------------------------------//

FUNCTION cDefFpg() ;

   local cDefFpg  := Space( 2 )

   if !Empty( aEmp() )
      cDefFpg     := aEmp()[ _CDEFFPG ]
   end if

RETURN ( cDefFpg )

//---------------------------------------------------------------------------//

/*
Obtiene el nuevo numero de la factura
*/

FUNCTION nNewDoc( cSerie, dbf, cTipDoc, nLen, dbfCount )

   local oBlock
   local oError
   local nPos
   local nDoc        := 0
   local nRetry      := 0
   local cOldFlt     
   local nRecAnt     := ( dbf )->( recno() )
   local nOrdAnt     := ( dbf )->( ordsetfocus( 1 ) )
   local cSufEmp     := retSufEmp()
   local lNotSerie   := .f.

   if Empty( cSerie )
      lNotSerie      := .t.
   end if
   
   DEFAULT nLen      := 9
   DEFAULT cSerie    := "A"
   
   // Chequea q exista la base de datos-------------------------------------------
   
   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   cOldFlt           := ( dbf )->( dbinfo( DBI_DBFILTER ) )
   
   if !empty( cOldFlt )
      ( dbf )->( dbsetfilter() )
   end if 
   
   nPos              := ( dbfCount )->( fieldPos( cSerie ) )
   
   // Hasta q no encuentre un numero valido se pone a dar vueltas-----------------
   
   if dbSeekInOrd( Upper( cTipDoc ), "Doc", dbfCount, nil, nil, .t. )

      nDoc           := ( dbfCount )->( fieldGet( nPos ) )
      if !IsNum( nDoc )
         nDoc        := 0
      end if
   
      // buscamos un par de veces para q no se repita el numero----------------

      while nRetry < 2

         if lNotSerie
            while ( dbf )->( dbSeek( Str( nDoc, nLen ) + cSufEmp ) )
               ++nDoc
            end while
         else
            while ( dbf )->( dbSeek( cSerie + Str( nDoc, nLen ) + cSufEmp ) )
               ++nDoc
            end while
         end if

         ++nRetry

      end while
   
      if dbLock( dbfCount )
         ( dbfCount )->( fieldPut( nPos, nDoc + 1 ) )
         ( dbfCount )->( dbUnLock() )
      end if
   
   else
   
      msgStop( "No encuentro el tipo de documento " + cTipDoc )
   
   end if

   if !empty( cOldFlt )
      ( dbf )->( dbsetfilter( c2Block( cOldFlt ), cOldFlt ) )
   end if 
   
   RECOVER USING oError
      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )
   END SEQUENCE
   ErrorBlock( oBlock )
   
   ( dbf )->( ordsetfocus( nOrdAnt ) )
   ( dbf )->( dbgoto( nRecAnt ) )
   
   if ( nDoc == 0 )
      msgStop( "No puedo obtener el número de nuevo documento" )
   end if

RETURN ( nDoc )

//---------------------------------------------------------------------------//
/*
Pone en el contador la factura eliminada---------------------------------------
*/

FUNCTION nPutDoc( cSerDoc, nNumDoc, cSufDoc, dbf, cTipDoc, nLen, dbfCount )

   local oBlock
   local oError
   local nPos
   local aStaAnt     := aGetStatus( dbf )

   ( dbf )->( ordSetFocus( 1 ) )

   DEFAULT nLen      := 9

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      nPos           := ( dbfCount )->( fieldPos( cSerDoc ) )

      if ( dbfCount )->( dbSeek( upper( cTipDoc ) ) ) .and. dbLock( dbfCount )
         ( dbfCount )->( fieldPut( nPos, nNumDoc ) )
      end if

   RECOVER USING oError

      msgStop( "Imposible establecer contadores " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   SetStatus( dbf, aStaAnt )

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION nNewNFC( cSerie, dbf, cTipDoc, dbfCount )

   local oBlock
   local oError
   local nPosPrefijo
   local nPosNumero
   local nLenNumero
   local cDocPrefijo
   local cDocNumero
   local lClo        := .f.
   local nRecAnt     := ( dbf )->( Recno() )
   local nOrdAnt     := ( dbf )->( OrdSetFocus( "cNfc" ) )

   DEFAULT cSerie    := "A"

   /*
   Chequea q exista la base de datos-------------------------------------------
   */

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfCount )
      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE
      lClo           := .t.
   end if

   nPosPrefijo       := ( dbfCount )->( fieldPos( "cNFC" + cSerie ) )
   nPosNumero        := ( dbfCount )->( fieldPos( "nNFC" + cSerie ) )

   /*
   Hasta q no encuentre un numero valido se pone a dar vueltas
   */

   if dbSeekInOrd( Upper( cTipDoc ), "Doc", dbfCount, nil, nil, .t. )

      cDocPrefijo    := Alltrim( ( dbfCount )->( fieldGet( nPosPrefijo ) ) )
      cDocNumero     := Alltrim( ( dbfCount )->( fieldGet( nPosNumero ) ) )
      nLenNumero     := Len( cDocNumero )

      while ( dbf )->( dbSeek( cDocPrefijo + cDocNumero ) )
         cDocNumero  := StrZero( Val( cDocNumero ) + 1, nLenNumero )
      end while

      if dbLock( dbfCount )
         ( dbfCount )->( fieldPut( nPosNumero, StrZero( Val( cDocNumero ) + 1, nLenNumero ) ) )
         ( dbfCount )->( dbUnLock() )
      end if

   else

      msgStop( "No encuentro el tipo de documento " + cTipDoc )

   end if

   /*
   Cerramos las bases de datos
   */

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClo
      CLOSE ( dbfCount )
   end if

   ( dbf )->( OrdSetFocus( nOrdAnt ) )
   ( dbf )->( dbGoTo( nRecAnt ) )

RETURN ( cDocPrefijo + cDocNumero )

//---------------------------------------------------------------------------//

/*
Devuelve el numero de digitos de clientes de la empresa activa
*/

FUNCTION RetPicCodCliEmp()

RETURN Replicate( "9", RetNumCodCliEmp() )

//---------------------------------------------------------------------------//

/*
Obtiene la serie del documentos
*/

FUNCTION cNewSer( cTipDoc, dbfCount )

   local oBlock
   local oError
   local lClo        := .f.
   local cSerie

   cSerie            := cDefSer()

   /*
   Chequea q exista la base de datos
   */

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfCount )

      mkCount( cPatEmp() )

      while .t.

         USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
         SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE

         if !netErr()
            exit
         else
            loop
         end if

      end while

      lClo           := .t.

   end if

   if ( dbfCount )->( dbSeek( Upper( cTipDoc ) ) ) .and. !Empty( ( dbfCount )->cSerie )
      cSerie         := ( dbfCount )->cSerie
   end if

   if !Empty( oUser():SerieDefecto() )
      cSerie         := oUser():SerieDefecto()
   end if

   /*
   Cerramos las bases de datos
   */

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClo
      CLOSE ( dbfCount )
   end if

   if Empty( cSerie )
      cSerie         := "A"
   end if

RETURN ( cSerie )

//-------------------------------------------------------------------------//

FUNCTION cDefSer()

   local cDefSer  := "A"

   if !Empty( oUser():SerieDefecto() )

      cDefSer     := oUser():SerieDefecto()

   else
      
      if !Empty( aEmp() ) // !Empty( aEmp()[ _CDEFSER ] )

         cDefSer     := Upper( aEmp()[ _CDEFSER ] )

      end if

   end if   

RETURN ( cDefSer )

//---------------------------------------------------------------------------//

FUNCTION lEntCon()

   local lEntCon  := .t.

   if !Empty( aEmp() )

      lEntCon     := aEmp()[ _LENTCON ]

   end if

 RETURN ( lEntCon )

//---------------------------------------------------------------------------//

FUNCTION lBuscaImportes()

   local lBuscaImportes := .t.

   if !Empty( aEmp() )

      lBuscaImportes    := aEmp()[ _LBUSIMP ]

   end if

 RETURN ( lBuscaImportes )

//---------------------------------------------------------------------------//

 FUNCTION lTipMov()

   local lTipMov := .t.

   if !Empty( aEmp() )

      lTipMov    := aEmp()[ _LTIPMOV ]

   end if

 RETURN ( lTipMov )

//---------------------------------------------------------------------------//

 FUNCTION lModDes()

   local lModDes := .t.

   if !Empty( aEmp() )

      lModDes    := aEmp()[ _LMODDES ]

   end if

 RETURN ( lModDes )

//---------------------------------------------------------------------------//

 FUNCTION lModIva()

   local lModIva  := .t.

   if !Empty( aEmp() )

      lModIva     := aEmp()[ _LMODIVA ]

   end if

 RETURN ( lModIva )

//---------------------------------------------------------------------------//

 FUNCTION lUseCaj()

   local lUseCaj     := .t.

   if !Empty( aEmp() )
      lUseCaj        := aEmp()[ _LUSECAJ ]
   end if

 RETURN ( lUseCaj )

//---------------------------------------------------------------------------//

FUNCTION cDefVta()

RETURN ( "00" )

//---------------------------------------------------------------------------//

FUNCTION cRutCnt()

   local cRutCnt  := Space( 1 )

   if !Empty( aEmp() )
      cRutCnt     := Rtrim( aEmp()[ _CRUTCNT ] )
   end if

RETURN ( cRutCnt )

//----------------------------------------------------------------------------//

 FUNCTION cPatImg( cPath )

   local cPatImg  := Rtrim( aEmp()[ _CDIRIMG ] )

   if !Empty( cPatImg )
      if Right( cPatImg, 1 ) != "\"
         cPatImg  := cPatImg += "\"
      end if
   end if

RETURN ( cPatImg )

//---------------------------------------------------------------------------//

/*
Devuelve el numero de digitos de proveedores de la empresa activa
*/

FUNCTION RetNumCodPrvEmp()

   local RetNumCodPrvEmp  := Space( 7 )
   local dbfEmp

   if !Empty( aEmp() )

      if Empty( aEmp()[ _CCODGRP ] )

         RetNumCodPrvEmp     := aEmp()[ _NCODPRV ]

      else

         if !aEmp()[ _LGRPPRV ]

            RetNumCodPrvEmp     := aEmp()[ _NCODPRV ]

         else

            USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
            SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

            if ( dbfEmp )->( dbSeek( aEmp()[ _CCODGRP ] ) )
               RetNumCodPrvEmp  := ( dbfEmp )->nCodPrv
            else
               RetNumCodPrvEmp  := aEmp()[ _NCODPRV ]
            end if

            ( dbfEmp )->( dbCloseArea() )

         end if

      end if

   end if

return ( RetNumCodPrvEmp )

//---------------------------------------------------------------------------//

FUNCTION lRetCodArt()

   local lRetCodArt  := .f.

   if !Empty( aEmp() )

      lRetCodArt     := aEmp()[ _LCODART ]

   end if

return ( lRetCodArt )

//--------------------------------------------------------------------------//
// Devuelve si en la ficha de artículos hay que usar uno o varios códigos de barras

FUNCTION lMultipleCodeBar()

   local lMultipleCodeBar  := .t.

   if !Empty( aEmp() )
      lMultipleCodeBar     := aEmp()[ _LCODEBAR ]
   end if

return ( lMultipleCodeBar )

//---------------------------------------------------------------------------//

FUNCTION cDefIva()

   local cDefIva  := Space( 1 )

   if !Empty( aEmp() )
      cDefIva     := aEmp()[ _CDEFIVA ]
   end if

RETURN ( cDefIva )

//---------------------------------------------------------------------------//

FUNCTION lPasNil() ; //RETURN ( aEmp()[ _LPASNIL ] )

   local lPasNil  := .t.

   if !Empty( aEmp() )
      lPasNil     := aEmp()[ _LPASNIL ]
   end if

return ( lPasNil )

//---------------------------------------------------------------------------//

Function cCuentaVentaIVARepercutidoUE()

Return ( uFieldEmpresa( "cCtaCeeSpt" ) )

//---------------------------------------------------------------------------//

Function cCuentaVentaIVARepercutidoFueraUE()

Return ( uFieldEmpresa( "cCtaCeeRpt" ) )

//---------------------------------------------------------------------------//

Function cCuentaCompraIVASoportadoUE()

Return ( uFieldEmpresa( "cCeeSptCom" ) )

//---------------------------------------------------------------------------//

Function cCuentaCompraIVARepercutidoUE()

Return ( uFieldEmpresa( "cCeeRptCom" ) )

//---------------------------------------------------------------------------//


