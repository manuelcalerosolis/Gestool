#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "SixNsx2.ch"
#include "MachSix.ch"

#define _CSERIE                  aTemp[  1 ]     //   C      1     0
#define _NNUMFAC                 aTemp[  2 ]     //   N      7     0
#define _DFECFAC                 aTemp[  3 ]     //   D      8     0
#define _CCODCLI                 aTemp[  4 ]     //   C      6     0
#define _CNOMCLI                 aTemp[  5 ]     //   C     35     0
#define _CDIRCLI                 aTemp[  6 ]     //   C     35     0
#define _CPOBCLI                 aTemp[  7 ]     //   C     25     0
#define _CPROVCLI                aTemp[  8 ]     //   C     20     0
#define _NCODPROV                aTemp[  9 ]     //   N      2     0
#define _CPOSCLI                 aTemp[ 10 ]     //   C      5     0
#define _CDNICLI                 aTemp[ 11 ]     //   C     15     0
#define _LLIQUIDADA              aTemp[ 12 ]     //   L      1     0
#define _LCONTAB                 aTemp[ 13 ]     //   L      1     0
#define _DFECENT                 aTemp[ 14 ]     //   D      8     0
#define _CSUPED                  aTemp[ 15 ]     //   C     10     0
#define _CCONDENT                aTemp[ 16 ]     //   C     20     0
#define _CEXPED                  aTemp[ 17 ]     //   C     20     0
#define _COBSERV                 aTemp[ 18 ]     //   C     20     0
#define _CCODPAGO                aTemp[ 19 ]     //   C      2     0
#define _NBULTOS                 aTemp[ 20 ]     //   N      3     0
#define _NPORTES                 aTemp[ 21 ]     //   N      6     0
#define _NNUMALB                 aTemp[ 22 ]     //   N      7     0
#define _NTIPOFAC                aTemp[ 23 ]     //   N      1     0
#define _NDTOESP                 aTemp[ 24 ]     //   N      4     1
#define _NDPP                    aTemp[ 25 ]     //   N      4     1
#define _NTIPOIVA                aTemp[ 26 ]     //   N      1     0
#define _NPORCIVA                aTemp[ 27 ]     //   N      4     1
#define _LRECARGO                aTemp[ 28 ]     //   L      1     0
#define _NIRPF                   aTemp[ 29 ]     //   N      4     1

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _dCSERIE                 aTemp[  1 ]     //   C      1     0
#define _dNNUMFAC                aTemp[  2 ]     //   N      7     0
#define _CREF                    aTemp[  3 ]     //   C     18     0
#define _CDETALLE                aTemp[  4 ]     //   C     35     0
#define _NPREUNIT                aTemp[  5 ]     //   N     13     3
#define _NDTO                    aTemp[  6 ]     //   N      5     1
#define _NIVA                    aTemp[  7 ]     //   N      4     1
#define _NCANENT                 aTemp[  8 ]     //   N     13     3
#define _LCONTROL                aTemp[  9 ]     //   L      1     0
#define _CUNIDAD                 aTemp[ 10 ]     //   C      2     0
#define _NUNICAJA                aTemp[ 11 ]     //   N      5     0

/*
Definici¢n de Array para impuestos
*/
#define _NBASEIVA1					aIva[ 1, 1 ]
#define _NPCTIVA1						aIva[ 1, 2 ]
#define _NIMPIVA1						aIva[ 1, 3 ]
#define _NBASEIVA2					aIva[ 2, 1 ]
#define _NPCTIVA2						aIva[ 2, 2 ]
#define _NIMPIVA2						aIva[ 2, 3 ]
#define _NBASEIVA3					aIva[ 3, 1 ]
#define _NPCTIVA3						aIva[ 3, 2 ]
#define _NIMPIVA3						aIva[ 3, 3 ]

/*
Definici¢n de Array para objetos impuestos
*/
#define _OBASEIVA1					aoIva[ 1, 1 ]
#define _OPCTIVA1						aoIva[ 1, 2 ]
#define _OIMPIVA1						aoIva[ 1, 3 ]
#define _OBASEIVA2					aoIva[ 2, 1 ]
#define _OPCTIVA2						aoIva[ 2, 2 ]
#define _OIMPIVA2						aoIva[ 2, 3 ]
#define _OBASEIVA3					aoIva[ 3, 1 ]
#define _OPCTIVA3						aoIva[ 3, 2 ]
#define _OIMPIVA3						aoIva[ 3, 3 ]

//-------------------------------------------------------------------------//

FUNCTION GenFactura( cAlias, aTemp, cAliasAnt )

	LOCAL oInf
	LOCAL oFont1, oFont2
	LOCAL nOldRecno := (cAlias)->(RECNO())

	/*
	Reposicionamos al primer Registro
	*/

	(cAlias)->(DBGOTOP())

	/*
	Tipos de Letras
	*/

   DEFINE FONT oFont1 NAME "Arial" SIZE 0,-12 BOLD
   DEFINE FONT oFont2 NAME "Courier New" SIZE 0,-10

	REPORT oInf ;
		FONT   oFont1, oFont2 ;
		TITLE Space(100) + "Factura N§ " + str( (cAlias)->NNUMALB, 0) ,;
				"",;
				Space(100) + "Fecha : " + Dtoc( (cAliasAnt)->DFECALB ) ,;
				"",;
				Space(100) + "Cliente " ,;
				Space(100) + cClient( (cAliasAnt)->CCODCLI ) ,;
				Space(100) + "N.I.F. : " + cClient( (cAliasAnt)->CCODCLI, {|cAlias| (cAlias)->NIF } ) ,;
				Space(100) + cClient( (cAliasAnt)->CCODCLI, {|cAlias| (cAlias)->DOMICILIO } ) ,;
				Space(100) + cClient( (cAliasAnt)->CCODCLI, {|cAlias| (cAlias)->POBLACION } ) ,;
				Space(100) + cClient( (cAliasAnt)->CCODCLI, {|cAlias| (cAlias)->CODPOSTAL } ) + cClient( (cAliasAnt)->CCODCLI, {|cAlias| (cAlias)->PROVINCIA } ) ,;
				"",;
				"" LEFT ;
		FOOTER OemtoAnsi("P gina : ") + str(oInf:nPage, 3) CENTERED;
		CAPTION "Imprimiendo Albaran";
		PREVIEW

      COLUMN TITLE "Codigo" ;
		DATA (cAlias)->CREF ;
		FONT 2

		COLUMN TITLE "Detalle" ;
		DATA (cAlias)->CDETALLE ;
		FONT 2

		COLUMN TITLE "U. Recibidas" ;
		DATA (cAlias)->NCANENT ;
		PICTURE "@E 999,999.99" ;
		FONT 2

		COLUMN TITLE "Precio" ;
		DATA (cAlias)->NPREUNIT ;
		PICTURE "@E 999,999,999.99" ;
		FONT 2

		COLUMN TITLE "Dto." ;
		DATA (cAlias)->NDTO ;
		PICTURE "@E 999.99" ;
		FONT 2

		COLUMN TITLE "Total" ;
		DATA ( (cAlias)->NCANENT * (cAlias)->NPREUNIT ) * ( (cAlias)->NDTO / 100 );
		PICTURE "@E 9,999,999,999.99" ;
		TOTAL ;
		FONT 2

	END REPORT

	oInf:bSkip := {|| (cAlias)->(DbSkip()) }

	ACTIVATE REPORT oInf WHILE ( (cAlias)->NNUMALB == _NNUMALB )

	(cAlias)->(DBGOTO(nOldRecno))

RETURN NIL