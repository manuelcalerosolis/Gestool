#include "FiveWin.Ch"
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TSysData

    DATA oDict

    METHOD New( cPath ) CONSTRUCTOR

    METHOD cDbfByName( cName )   INLINE   ::oDict:cDbfByName( cName )

    METHOD Activate( oDb )       INLINE   ::oDict:Activate( oDb )

    METHOD SyncAllDbf( cPathTmp )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPath )

   local aoDbf    := Array( 3 )

   DEFAULT cPath  := cPatEmp()

   DEFINE DICTIONARY ::oDict VIA ( cDriver() )PATH cPath COMMENT  "Diccionario de datos" SHARED NORECYCLE

      /*
      Base de datos de usuarios conf de pantallas---------------------------------

      DEFINE TABLE aoDbf[1] FILE "CfgUse.Dbf" CLASS "CfgUse" PATH ( cPatDat() ) VIA ( cDriver() )COMMENT "Configuracion de usuarios"

      FIELD NAME "cCodUse" TYPE "C" LEN  3  DEC 0 COMMENT "Código usuario"          OF aoDbf[1]
      FIELD NAME "cNomCfg" TYPE "C" LEN 30  DEC 0 COMMENT "Nombre ventana"          OF aoDbf[1]
      FIELD NAME "nRecCfg" TYPE "N" LEN 10  DEC 0 COMMENT "Recno de la ventana"     OF aoDbf[1]

      DEFINE INDEX TO "CfgUse.Cdx" TAG "cCodUse" ON "cCodUse + cNomCfg" COMMENT "Codigo" NODELETED OF aoDbf[1]

      ADD TABLE aoDbf[1] OF ::oDict
      */

      /*
      Base de datos de usuarios conf de columnas de pantallas---------------------

      DEFINE TABLE aoDbf[2] FILE "CfgCol.Dbf" CLASS "CfgCol"  PATH ( cPatDat() ) VIA ( cDriver() )COMMENT "Configuracion de columnas de usuarios"

      FIELD NAME "cCodUse"    TYPE "C" LEN  3  DEC 0 COMMENT "Código usuario"             OF aoDbf[2]
      FIELD NAME "cNomCfg"    TYPE "C" LEN 30  DEC 0 COMMENT "Nombre ventana"             OF aoDbf[2]
      FIELD NAME "nNumCol"    TYPE "N" LEN  2  DEC 0 COMMENT "Número de la columna"       OF aoDbf[2]
      FIELD NAME "lSelCol"    TYPE "L" LEN  1  DEC 0 COMMENT "Columna seleccionada"       OF aoDbf[2]
      FIELD NAME "nPosCol"    TYPE "N" LEN  2  DEC 0 COMMENT "Posicicion de la columna"   OF aoDbf[2]
      FIELD NAME "nSizCol"    TYPE "N" LEN  6  DEC 0 COMMENT "Tamaño de la columna"       OF aoDbf[2]
      FIELD NAME "lJusCol"    TYPE "L" LEN  1  DEC 0 COMMENT "Columna a la derecha"       OF aoDbf[2]

      DEFINE INDEX TO "CfgCol.Cdx" TAG "cCodUse" ON "cCodUse + cNomCfg + Str( nNumCol )" COMMENT "Codigo" NODELETED OF aoDbf[2]

      ADD TABLE aoDbf[2] OF ::oDict
      */

      /*
      Listin telefonico--------------------------------------------------------
      */

      DEFINE TABLE aoDbf[1] FILE "Agenda.Dbf" CLASS "AGENDA" PATH ( cPatDat() ) ALIAS "AGENDA" VIA ( cDriver() )COMMENT "Listin telefonico"

      FIELD NAME "CNIF"         TYPE "C" LEN  15  DEC 0 COMMENT "NIF"             DEFAULT "CIF"              OF aoDbf[1]
      FIELD NAME "CAPELLIDOS"   TYPE "C" LEN  40  DEC 0 COMMENT "Nombre completo" DEFAULT "Nombre completo"  OF aoDbf[1]
      FIELD NAME "CDOMICILIO"   TYPE "C" LEN  40  DEC 0 COMMENT "Domicilio"       DEFAULT "Domicilio"        OF aoDbf[1]
      FIELD NAME "CPOBLACION"   TYPE "C" LEN  30  DEC 0 COMMENT "Población"       DEFAULT "Población"        OF aoDbf[1]
      FIELD NAME "CPROVINCIA"   TYPE "C" LEN  30  DEC 0 COMMENT "Provincia"       DEFAULT "Provincia"        OF aoDbf[1]
      FIELD NAME "CCODPOSTAL"   TYPE "C" LEN   5  DEC 0 COMMENT "Codigo Postal"                              OF aoDbf[1]
      FIELD NAME "CTEL"         TYPE "C" LEN  12  DEC 0 COMMENT "Teléfono 1"                                 OF aoDbf[1]
      FIELD NAME "CMOV"         TYPE "C" LEN  12  DEC 0 COMMENT "Móvil"                                      OF aoDbf[1]
      FIELD NAME "CFAX"         TYPE "C" LEN  12  DEC 0 COMMENT "Fax"                                        OF aoDbf[1]
      FIELD NAME "CDESTEL"      TYPE "C" LEN  20  DEC 0 COMMENT "Nombre teléfono 1"                          OF aoDbf[1]
      FIELD NAME "CDESMOV"      TYPE "C" LEN  20  DEC 0 COMMENT "Nombre móvil"                               OF aoDbf[1]
      FIELD NAME "CDESFAX"      TYPE "C" LEN  20  DEC 0 COMMENT "Nombre fax"                                 OF aoDbf[1]
      FIELD NAME "COBSERVA"     TYPE "C" LEN 250  DEC 0 COMMENT "Observaciones"   DEFAULT "Observaciones"    OF aoDbf[1]
      FIELD NAME "LSELECT"      TYPE "L" LEN   1  DEC 0 COMMENT ""                                           OF aoDbf[1]

      INDEX TO "AGENDA.CDX" TAG "CAPELLIDOS" ON "UPPER( CAPELLIDOS )" OF aoDbf[1]
      INDEX TO "AGENDA.CDX" TAG "CNIF"       ON "CNIF"                OF aoDbf[1]

      ADD TABLE aoDbf[1] OF ::oDict

      /*
      Tanques de combustible---------------------------------------------------
      */

      DEFINE TABLE aoDbf[2] FILE "Tankes.Dbf" CLASS "TANKES" ALIAS "TANKES" PATH ( cPatEmp() ) VIA ( cDriver() )COMMENT "Tanques de combustible"

      FIELD NAME "CCODTNK"    TYPE "C" LEN  3  DEC 0                                COMMENT "Código"            DEFAULT "01"               OF aoDbf[2]
      FIELD NAME "CNOMTNK"    TYPE "C" LEN 35  DEC 0                                COMMENT "Nombre del tanque" DEFAULT "Nombre completo"  OF aoDbf[2]
      FIELD NAME "NLTRTNK"    TYPE "N" LEN 13  DEC 0 PICTURE "@EZ 999,999,999.999"  COMMENT "Capacidad"         DEFAULT 0                  OF aoDbf[2]
      FIELD NAME "LSELECT"    TYPE "L" LEN  1  DEC 0                                COMMENT ""                  HIDE                       OF aoDbf[2]

      INDEX TO "TANKES.CDX" TAG "CCODTNK" ON "CCODTNK" COMMENT "Código" NODELETED OF aoDbf[2]
      INDEX TO "TANKES.CDX" TAG "CNOMTNK" ON "CNOMTNK" COMMENT "Nombre" NODELETED OF aoDbf[2]

      ADD TABLE aoDbf[2] OF ::oDict

      /*
      Cuentas de remesas-------------------------------------------------------

      DEFINE TABLE aoDbf[3] FILE "CTAREM.DBF" CLASS "CTAREM" ALIAS "CTAREM" PATH ( cPatEmp() ) VIA ( cDriver() )COMMENT "Cuentas de remesas"

         FIELD NAME "cCodCta" TYPE "C" LEN  3  DEC 0 PICTURE "@!"                         COMMENT "Codigo"           COLSIZE 40        OF aoDbf[3]
         FIELD NAME "cNomCta" TYPE "C" LEN 40  DEC 0 PICTURE "@!"                         COMMENT "Nombre"           COLSIZE 140       OF aoDbf[3]
         FIELD NAME "cDirCta" TYPE "C" LEN 80  DEC 0                                      COMMENT "Dirección"        COLSIZE 200       OF aoDbf[3]
         FIELD NAME "cEntBan" TYPE "C" LEN  4  DEC 0 PICTURE "9999"                       COMMENT "Entidad"          COLSIZE 50        OF aoDbf[3]
         FIELD NAME "cAgcBan" TYPE "C" LEN  4  DEC 0 PICTURE "9999"                       COMMENT "Agencia"          COLSIZE 50        OF aoDbf[3]
         FIELD NAME "cDgcBan" TYPE "C" LEN  2  DEC 0 PICTURE "99"                         COMMENT "DC"               COLSIZE 40        OF aoDbf[3]
         FIELD NAME "cCtaBan" TYPE "C" LEN 10  DEC 0 PICTURE "9999999999"                 COMMENT "Cuenta"           COLSIZE 100       OF aoDbf[3]
         FIELD NAME "cSufCta" TYPE "C" LEN  3  DEC 0 PICTURE "@!"          DEFAULT "000"  COMMENT "Sufijo"                       HIDE  OF aoDbf[3]
         FIELD NAME "cSufN58" TYPE "C" LEN  3  DEC 0 PICTURE "@!"                         COMMENT "Sufijo Norma 58"              HIDE  OF aoDbf[3]
         FIELD NAME "cCodPre" TYPE "C" LEN  2  DEC 0 PICTURE "99"                         COMMENT ""                             HIDE  OF aoDbf[3]
         FIELD NAME "cNifPre" TYPE "C" LEN  9  DEC 0 PICTURE "@!"                         COMMENT ""                             HIDE  OF aoDbf[3]
         FIELD NAME "cNomPre" TYPE "C" LEN 40  DEC 0 PICTURE "@!"                         COMMENT ""                             HIDE  OF aoDbf[3]
         FIELD NAME "cEntPre" TYPE "C" LEN  4  DEC 0 PICTURE "9999"                       COMMENT ""                             HIDE  OF aoDbf[3]
         FIELD NAME "cAgcPre" TYPE "C" LEN  4  DEC 0 PICTURE "9999"                       COMMENT ""                             HIDE  OF aoDbf[3]
         FIELD NAME "cSubCta" TYPE "C" LEN 12  DEC 0                                      COMMENT ""                             HIDE  OF aoDbf[3]

         INDEX TO "CtaRem.Cdx" TAG "cCodCta" ON "cCodCta" COMMENT "Código" DELETED OF aoDbf[3]
         INDEX TO "CtaRem.Cdx" TAG "cNomCta" ON "cNomCta" COMMENT "Nombre" DELETED OF aoDbf[3]

      ADD TABLE aoDbf[3] OF ::oDict
      */

      /*
      Pais -------------------------------------------------------------------

      DEFINE DATABASE aoDbf[4] FILE "PAIS.DBF" CLASS "Pais" PATH ( cPatEmp() ) VIA ( cDriver() )COMMENT "Paises"

      FIELD NAME "CCODPAI"    TYPE "C" LEN  4  DEC 0  COMMENT "Código"  DEFAULT Space( 4 )      COLSIZE 80  OF aoDbf[4]
      FIELD NAME "CNOMPAI"    TYPE "C" LEN 35  DEC 0  COMMENT "Nombre"  DEFAULT Space( 35)      COLSIZE 200 OF aoDbf[4]
      FIELD NAME "CBNDPAI"    TYPE "C" LEN  4  DEC 0  COMMENT ""                           HIDE COLSIZE 0   OF aoDbf[4]
      FIELD NAME "CRESPAI"    TYPE "C" LEN  8  DEC 0  COMMENT ""                           HIDE COLSIZE 0   OF aoDbf[4]

      INDEX TO "Pais.CDX" TAG "CCODPAI" ON "CCODPAI" COMMENT "Codigo" DELETED OF aoDbf[4]
      INDEX TO "Pais.CDX" TAG "CNOMPAI" ON "CNOMPAI" COMMENT "Nombre" DELETED OF aoDbf[4]

      ADD TABLE aoDbf[4] OF ::oDict
      */

      /*
      Base de datos de usuarios conf de listados---------------------------------

      DEFINE TABLE aoDbf[5] FILE "CfgInf.Dbf" CLASS "CfgInf" PATH ( cPatDat() ) VIA ( cDriver() )COMMENT "Configuracion de usuarios"

      FIELD NAME "cCodUse" TYPE "C" LEN  3  DEC 0 COMMENT "Codigo usuario"          OF aoDbf[5]
      FIELD NAME "cNomInf" TYPE "C" LEN 100 DEC 0 COMMENT "Nombre del informe"      OF aoDbf[5]
      FIELD NAME "lSelInf" TYPE "L" LEN  1  DEC 0 COMMENT "Selección de columna"    OF aoDbf[5]
      FIELD NAME "cTitInf" TYPE "C" LEN 30  DEC 0 COMMENT "Titulo del informe"      OF aoDbf[5]
      FIELD NAME "nPosInf" TYPE "N" LEN 10  DEC 0 COMMENT "Posición de la columna"  OF aoDbf[5]
      FIELD NAME "nSizInf" TYPE "N" LEN 10  DEC 0 COMMENT "Tamaño de la columna"    OF aoDbf[5]
      FIELD NAME "lAlnInf" TYPE "L" LEN  1  DEC 0 COMMENT "Alineación columna"      OF aoDbf[5]
      FIELD NAME "lTotInf" TYPE "L" LEN  1  DEC 0 COMMENT "Columna totalizada"      OF aoDbf[5]
      FIELD NAME "lSomInf" TYPE "L" LEN  1  DEC 0 COMMENT "Columna sombreada"       OF aoDbf[5]
      FIELD NAME "lSepInf" TYPE "L" LEN  1  DEC 0 COMMENT "Separación del informe"  OF aoDbf[5]

      DEFINE INDEX TO "CfgInf.Cdx" TAG "cCodUse" ON "cCodUse + cNomInf" COMMENT "Codigo" OF aoDbf[5]

      ADD TABLE aoDbf[5] OF ::oDict

      DEFINE TABLE aoDbf[6] FILE "CfgFnt.Dbf" CLASS "CfgFnt" PATH ( cPatDat() ) VIA ( cDriver() )COMMENT "Configuracion de usuarios"

      FIELD NAME "cCodUse" TYPE "C" LEN  3  DEC 0 COMMENT "Codigo usuario"          OF aoDbf[6]
      FIELD NAME "cNomInf" TYPE "C" LEN 50  DEC 0 COMMENT "Nombre del informe"      OF aoDbf[6]
      FIELD NAME "cFntIn1" TYPE "C" LEN 20  DEC 0 COMMENT "Nombre de la fuente 1"   OF aoDbf[6]
      FIELD NAME "nSizIn1" TYPE "N" LEN  3  DEC 0 COMMENT "Tamaño del informe 1"    OF aoDbf[6]
      FIELD NAME "cStyIn1" TYPE "C" LEN 20  DEC 0 COMMENT "Estilo del informe 1"    OF aoDbf[6]
      FIELD NAME "cFntIn2" TYPE "C" LEN 20  DEC 0 COMMENT "Nombre de la fuente 2"   OF aoDbf[6]
      FIELD NAME "nSizIn2" TYPE "N" LEN  3  DEC 0 COMMENT "Tamaño del informe 2"    OF aoDbf[6]
      FIELD NAME "cStyIn2" TYPE "C" LEN 20  DEC 0 COMMENT "Estilo del informe 2"    OF aoDbf[6]
      FIELD NAME "cFntIn3" TYPE "C" LEN 30  DEC 0 COMMENT "Nombre de la fuente 3"   OF aoDbf[6]
      FIELD NAME "nSizIn3" TYPE "N" LEN  3  DEC 0 COMMENT "Tamaño del informe 3"    OF aoDbf[6]
      FIELD NAME "cStyIn3" TYPE "C" LEN 30  DEC 0 COMMENT "Estilo del informe 3"    OF aoDbf[6]
      FIELD NAME "lCelVie" TYPE "L" LEN  1  DEC 0 COMMENT "Visualizar en celdas"    OF aoDbf[6]

      DEFINE INDEX TO "CfgFnt.Cdx" TAG "cCodUse" ON "cCodUse + cNomInf" COMMENT "Codigo" OF aoDbf[6]

      ADD TABLE aoDbf[6] OF ::oDict
      */

RETURN ( Self )

//----------------------------------------------------------------//

METHOD SyncAllDbf( cPathTmp )

   local n

   FOR n := 1 TO ::oDict:nDbfCount
      lCheckDbf( ::oDict:aTDbf[ n ] )
   NEXT

RETURN ( Self )

//----------------------------------------------------------------//