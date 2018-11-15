#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"
#include "Factu.ch" 

#define _CCODUSE                 ( dbfUser )->( fieldpos( "cCodUse" ) )       //   C      3      0
#define _CNBRUSE                 ( dbfUser )->( fieldpos( "cNbrUse" ) )       //   C     30      0
#define _CCLVUSE                 ( dbfUser )->( fieldpos( "cClvUse" ) )       //   C     10      0
#define _LSNDINT                 ( dbfUser )->( fieldpos( "lSndInt" ) ) 
#define _NLEVUSE                 ( dbfUser )->( fieldpos( "nLevUse" ) )       //   N      1      0
#define _LUSEUSE                 ( dbfUser )->( fieldpos( "lUseUse" ) )       //   L      1      0
#define _CEMPUSE                 ( dbfUser )->( fieldpos( "cEmpUse" ) )       //   C      2      0
#define _CPCNUSE                 ( dbfUser )->( fieldpos( "cPcnUse" ) )       //   C     50      0
#define _CCAJUSE                 ( dbfUser )->( fieldpos( "cCajUse" ) ) 
#define _CCJRUSE                 ( dbfUser )->( fieldpos( "cCjrUse" ) ) 
#define _CALMUSE                 ( dbfUser )->( fieldpos( "cAlmUse" ) ) 
#define _CFPGUSE                 ( dbfUser )->( fieldpos( "cFpgUse" ) ) 
#define _NGRPUSE                 ( dbfUser )->( fieldpos( "nGrpUse" ) ) 
#define _CIMAGEN                 ( dbfUser )->( fieldpos( "cImaGen" ) ) 
#define _LCHGPRC                 ( dbfUser )->( fieldpos( "lChgPrc" ) )       //   L      1      0
#define _LSELFAM                 ( dbfUser )->( fieldpos( "lSelFam" ) )       //   L      1      0
#define _LNOTBMP                 ( dbfUser )->( fieldpos( "lNotBmp" ) )       //   L      1      0
#define _LNOTINI                 ( dbfUser )->( fieldpos( "lNotIni" ) )       //   L      1      0
#define _NSIZICO                 ( dbfUser )->( fieldpos( "nSizIco" ) )       //   L      1      0
#define _CCODEMP                 ( dbfUser )->( fieldpos( "cCodEmp" ) )       //   C      2      0
#define _CCODDLG                 ( dbfUser )->( fieldpos( "cCodDlg" ) )       //   C      2      0
#define _LNOTRNT                 ( dbfUser )->( fieldpos( "lNotRnt" ) )       //   L      1      0
#define _LNOTCOS                 ( dbfUser )->( fieldpos( "lNotCos" ) )       //   L      1      0
#define _LUSRZUR                 ( dbfUser )->( fieldpos( "lUsrZur" ) )       //   L      1      0
#define _LALERTA                 ( dbfUser )->( fieldpos( "lAleRta" ) )       //   L      1      0
#define _LGRUPO                  ( dbfUser )->( fieldpos( "lGruPo"  ) )       //   L      1      0     Lógico de grupo
#define _CCODGRP                 ( dbfUser )->( fieldpos( "cCodGrp"  ) )       //   C      3      0     Código de grupo
#define _LNOTDEL                 ( dbfUser )->( fieldpos( "lNotDel"  ) )       //   L      1      0     Lógico de pedir autorización al borrar registros
#define _CCODTRA                 ( dbfUser )->( fieldpos( "cCodTra"  ) )       //   C      3      0     Código de grupo
#define _LFILVTA                 ( dbfUser )->( fieldpos( "lFilVta"  ) )       //   L      1      0     Filtrar ventas por usuario
#define _LDOCAUT                 ( dbfUser )->( fieldpos( "lDocAut"  ) )       //   L      1      0     Documentos automáticos
#define _DULTAUT                 ( dbfUser )->( fieldpos( "dUltAut"  ) )       //   D      8      0     Último documento aautomático
#define _LNOOPCAJ                ( dbfUser )->( fieldpos( "lNooPcaj" ) )       //   L      1      0 
#define _LARQCIE                 ( dbfUser )->( fieldpos( "lArqCie"  ) )       //   L      1      0
#define _CCODSALA                ( dbfUser )->( fieldpos( "cCodSala" ) )       
#define _CSERDEF                 ( dbfUser )->( fieldpos( "cSerDef"  ) )       //   C      1      0
#define _LNOTUNI                 ( dbfUser )->( fieldpos( "lNotUni"  ) )       //   L      1      0
#define _LNOTCOB                 ( dbfUser )->( fieldpos( "lNotCob"  ) )       //   L      1      0
#define _LNOTNOT                 ( dbfUser )->( fieldpos( "lNotNot"  ) )       //   L      1      0
#define _LNOTCOM                 ( dbfUser )->( fieldpos( "lNotCom"  ) )       //   L      1      0
#define _UUID                    ( dbfUser )->( fieldpos( "Uuid"     ) )       //   C     40      0

//----------------------------------------------------------------------------//
//Comenzamos la parte de código que se compila para el ejecutable normal

//----------------------------------------------------------------------------//

#ifndef __PDA__

//----------------------------------------------------------------------------//

FUNCTION BrwBigUser()

Return ( msgInfo( "Funcion en desuso" ) )

//---------------------------------------------------------------------------//

Function InitBrwBigUser()

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION mkUsuario( cPath, oMeter )

   DEFAULT cPath     := cPatDat()

	IF oMeter != NIL
		oMeter:cText	:= "Generando bases"
      SysRefresh()
	END IF

   if !lExistTable( cPath + "USERS.DBF" )
      dbCreate( cPath + "USERS.DBF", aSqlStruct( aItmUsuario() ), cDriver() )
   end if

   if !lExistTable( cPath + "MAPAS.DBF" )
      dbCreate( cPath + "MAPAS.DBF", aSqlStruct( aItmMapaUsuario() ), cDriver() )
   end if

   rxUsuario( cPath, oMeter )

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxUsuario( cPath, oMeter )

	local dbfUser

   DEFAULT cPath     := cPatDat()

   if lExistIndex( cPath + "Users.Cdx" )
      fEraseIndex( cPath + "Users.Cdx" )
   end if

   if lExistIndex( cPath + "Mapas.CDX" )
      fEraseIndex( cPath + "Mapas.CDX" )
   end if

   dbUseArea( .t., cDriver(), cPatDat() + "Users.Dbf", cCheckArea( "Users", @dbfUser ), .f. )

   if !( dbfUser )->( neterr() )
      ( dbfUser )->( __dbPack() )

      ( dbfUser )->( ordCondSet( "!Deleted()", {|| !Deleted()}  ) )
      ( dbfUser )->( ordCreate( cPath + "Users.Cdx", "CCODUSE", "Field->cCodUse", {|| Field->cCodUse } ) )

      ( dbfUser )->( ordCondSet( "!Deleted()", {|| !Deleted()}  ) )
      ( dbfUser )->( ordCreate( cPath + "Users.Cdx", "CNBRUSE", "Upper( Field->cNbrUse )", {|| Upper( Field->cNbrUse ) } ) )

      ( dbfUser )->( ordCondSet( "!Deleted()", {|| !Deleted()}  ) )
      ( dbfUser )->( ordCreate( cPath + "Users.Cdx", "CPCNUSE", "Field->cPcnUse + Field->cCodUse", {|| Field->cPcnUse + Field->cCodUse } ) )

      ( dbfUser )->( ordCondSet( "!Deleted()", {|| !Deleted()}  ) )
      ( dbfUser )->( ordCreate( cPath + "Users.Cdx", "CCODGRP", "Field->cCodGrp", {|| Field->cCodGrp } ) )

      ( dbfUser )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de usuarios" )
   end if

   /*
   Mapas de usuarios-----------------------------------------------------------
   */

   dbUseArea( .t., cDriver(), cPath + "Mapas.DBF", cCheckArea( "Mapas", @dbfUser ), .f. )

   if !( dbfUser )->( neterr() )
      ( dbfUser )->( __dbPack() )

      ( dbfUser )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfUser )->( ordCreate( cPath + "Mapas.CDX", "CCODUSE", "Field->CCODUSE + Field->CNOMOPC", {|| Field->CCODUSE + Field->CNOMOPC } ) )

      ( dbfUser )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de mapas de usuarios" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

Function aItmUsuario()

   local aBase := {  { "cCodUse",   "C",  3,  0, "Código de usuario" },;
                     { "cNbrUse",   "C", 30,  0, "Nombre de usuario" },;
                     { "cClvUse",   "C", 10,  0, "" },;
                     { "lSndInt",   "L",  1,  0, "" },;
                     { "nLevUse",   "N",  1,  0, "" },;
                     { "lUseUse",   "L",  1,  0, "" },;
                     { "cEmpUse",   "C",  4,  0, "" },;
                     { "cPcnUse",   "C", 50,  0, "" },;
                     { "cCajUse",   "C",  3,  0, "Código de caja de usuario" },;
                     { "cCjrUse",   "C",  3,  0, "" },;
                     { "cAlmUse",   "C", 16,  0, "Código de almacén de usuario" },;
                     { "cFpgUse",   "C",  3,  0, "" },;
                     { "nGrpUse",   "N",  1,  0, "Tipo de usuario ( 1 Administradores - 2 Usuario )" },;
                     { "cImagen",   "C",128,  0, "" },;
                     { "lChgPrc",   "L",  1,  0, "" },;
                     { "lSelFam",   "L",  1,  0, "Lógico de selector por familias" },;
                     { "lNotBmp",   "L",  1,  0, "Lógico no mostrar imagen de fondo" },;
                     { "lNotIni",   "L",  1,  0, "Lógico no mostrar página de inicio" },;
                     { "nSizIco",   "N",  1,  0, "" },;
                     { "cCodEmp",   "C",  4,  0, "Código de empresa de usuario" },;
                     { "cCodDlg",   "C",  2,  0, "Código de delegación de usuario" },;
                     { "lNotRnt",   "L",  1,  0, "Lógico no ver la rentabilidad por operación" },;
                     { "lNotCos",   "L",  1,  0, "Lógico no ver los precios de costo" },;
                     { "lUsrZur",   "L",  1,  0, "Lógico tpv tactil para zurdos" },;
                     { "lAlerta",   "L",  1,  0, "Lógico mostrar alertas" },;
                     { "lGrupo",    "L",  1,  0, "Lógico de grupo" },;
                     { "cCodGrp",   "C",  3,  0, "Código de grupo" },;
                     { "lNotDel",   "L",  1,  0, "Lógico de pedir autorización al borrar registros" },;
                     { "cCodTra",   "C",  5,  0, "Código del operario" },;
                     { "lFilVta",   "L",  1,  0, "Filtrar ventas del usuario" },;
                     { "lDocAut",   "L",  1,  0, "Lógico documentos automáticos" },;
                     { "dUltAut",   "D",  8,  0, "Fecha último documento automático" },;
                     { "lNoOpCaj",  "L",  1,  0, "Lógico abrir cajón portamonedas" },;
                     { "lArqCie",   "L",  1,  0, "Lógico arqueo ciego para este usuario" },;
                     { "cCodSala",  "C",  3,  0, "Código de sala por defecto para este usuario" },;
                     { "cSerDef",   "C",  1,  0, "Serie de facturación por defecto" },;
                     { "lNotUni",   "L",  1,  0, "Lógico para no modificar las unidades" },;
                     { "lNotCob",   "L",  1,  0, "Lógico no permitir cobros" },;
                     { "lNotNot",   "L",  1,  0, "Lógico no permitir entregar notas" },;
                     { "lNotCom",   "L",  1,  0, "Lógico no permitir imprimir comandas" },;
                     { "Uuid",      "C", 40,  0, "Uuid" } }

Return ( aBase )

//--------------------------------------------------------------------------//

Function aItmMapaUsuario()

   local aMapa := {  { "cCodUse",   "C",  3,  0, "Código del usuario" },;
                     { "cNomOpc",   "C", 20,  0, "Opción de programa" },;
                     { "nLevOpc",   "N",  8,  0, "Nivel de acceso" } }

Return ( aMapa )

//--------------------------------------------------------------------------//

Function lGetUsuario( oGetUsuario )

Return ( .t. )

//---------------------------------------------------------------------------//

FUNCTION SynUsuario()

   local oBlock
   local oError
   local dbfUser

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "Users.Dbf" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "USERS", @dbfUser ) )
   SET ADSINDEX TO ( cPatDat() + "Users.Cdx" ) ADDITIVE

   ( dbfUser )->( dbgotop() )

   while !( dbfUser )->( eof() )

      if empty( ( dbfUser )->Uuid )
         ( dbfUser )->Uuid        := win_uuidcreatestring()
      end if 

      ( dbfUser )->( dbSkip() )

      SysRefresh()

   end while


   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de articulos." )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfUser )

RETURN NIL

//---------------------------------------------------------------------------//
