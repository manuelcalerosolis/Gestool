#include "Factu.ch"

#define _CSERSAT                   1      //   C      1     0
#define _NNUMSAT                   2      //   N      9     0
#define _CSUFSAT                   3      //   C      2     0
#define _CTURSAT                   4      //   C      2     0
#define _DFECSAT                   5      //   D      8     0
#define _CCODCLI                   6      //   C     10     0
#define _CNOMCLI                   7      //   C     35     0
#define _CDIRCLI                   8      //   C     35     0
#define _CPOBCLI                   9      //   C     25     0
#define _CPRVCLI                  10      //   C     20     0
#define _CPOSCLI                  11      //   C      5     0
#define _CDNICLI                  12      //   C     15     0
#define _LMODCLI                  13      //   L      1     0
#define _CCODAGE                  14      //   C      3     0
#define _CCODOBR                  15      //   C      3     0
#define _CCODTAR                  16      //   C      4     0
#define _CCODALM                  17      //   C      4     0
#define _CCODCAJ                  18      //   C      4     0
#define _CCODPGO                  19      //   C      2     0
#define _CCODRUT                  20      //   C      2     0
#define _DFECENT                  21      //   D      8     0
#define _LESTADO                  22      //   L      1     0
#define _CSUSAT                   23      //   C     10     0
#define _CCONDENT                 24      //   C     20     0
#define _MCOMENT                  25      //   M     10     0
#define _MOBSERV                  26      //   M     10     0
#define _LMAYOR                   27      //   L      1     0
#define _NTARIFA                  28      //   L      1     0
#define _CDTOESP                  29      //   N      4     1
#define _NDTOESP                  30      //   N      4     1
#define _CDPP                     31      //   N      4     1
#define _NDPP                     32      //   N      4     1
#define _CDTOUNO                  33      //   N      4     1
#define _NDTOUNO                  34      //   N      4     1
#define _CDTODOS                  35      //   N      4     1
#define _NDTODOS                  36      //   N      4     1
#define _NDTOCNT                  37      //   N      5     2
#define _NDTORAP                  38      //   N      5     2
#define _NDTOPUB                  39      //   N      5     2
#define _NDTOPGO                  40      //   N      5     2
#define _NDTOPTF                  41      //   N      5     2
#define _LRECARGO                 42      //   L      1     0
#define _NPCTCOMAGE               43      //   N      5     2
#define _NBULTOS                  44      //   N      3     0
#define _CNUMSat                  45      //   C     10     0
#define _CDIVSAT                  46      //   C      3     0
#define _NVDVSAT                  47      //   C     10     4
#define _LSNDDOC                  48      //   L      1     0
#define _CRETPOR                  49
#define _CRETMAT                  50
#define _NREGIVA                  51
#define _LIVAINC                  52      //   N
#define _NIVAMAN                  53
#define _NMANOBR                  54
#define _CCODTRN                  55
#define _NKGSTRN                  56
#define _LCLOSAT                  57
#define _CCODUSR                  58
#define _DFECCRE                  59
#define _CTIMCRE                  60
#define _CSITUAC                  61      //   C     20     0
#define _NDIAVAL                  62      //   C     20     0
#define _CCODGRP                  63
#define _LIMPRIMIDO               64      //   L      1     0
#define _DFECIMP                  65      //   D      8     0
#define _CHORIMP                  66      //   C      5     0
#define _CCODDLG                  67
#define _NDTOATP                  68      //   N      6     2
#define _NSBRATP                  69      //   N      1     0
#define _DFECENTR                 70      //   D      8     0
#define _DFECSAL                  71      //   D      8     0
#define _LALQUILER                72      //   L      1     0
#define _CMANOBR                  73      //   C    250     0
#define _CNUMTIK                  74      //   C     13     0
#define _CTLFCLI                  75      //   C     20     0
#define _NTOTNET                  76
#define _NTOTIVA                  77
#define _NTOTREQ                  78
#define _NTOTSAT                  79
#define _LOPERPV                  80
#define _CNUMALB                  81
#define _LGARANTIA                82
#define _CCODOPE                  83
#define _CCODCAT                  84
#define _CHORINI                  85
#define _CHORFIN                  86
#define _CCODEST                  87
#define _MFIRMA                   88

/*
Definici¢n de la base de datos de lineas de detalle
*/

#define _CREF                      4
#define _CDETALLE                  5
#define _NIVA                      6
#define _NCANSAT                   7
#define _NUNICAJA                  8
#define _LCONTROL                  9
#define _NUNDKIT                  10
#define _NPREDIV                  11
#define _NPNTVER                  12
#define _NIMPTRN                  13
#define _NDTO                     14
#define _NDTOPRM                  15
#define _NCOMAGE                  16
#define _NCANENT                  17
#define _CUNIDAD                  18
#define _NPESOKG                  19
#define _CPESOKG                  20
#define _DFECHA                   21
#define _MLNGDES                  22
#define _LTOTLIN                  23
#define _LIMPLIN                  24
#define _CCODPR1                  25
#define _CCODPR2                  26
#define _CVALPR1                  27
#define _CVALPR2                  28
#define _NFACCNV                  29
#define _NDTODIV                  30
#define _CTIPMOV                  31
#define _NNUMLIN                  32
#define _NCTLSTK                  33
#define _NCOSDIV                  34
#define _NPVSATC                  35
#define _CALMLIN                  36
#define _LIVALIN                  37
#define _CCODIMP                  38
#define _NVALIMP                  39
#define _LLOTE                    40
#define _NLOTE                    41
#define _CLOTE                    42
#define _LKITART                  43
#define _LKITCHL                  44
#define _LKITPRC                  45
#define _NMESGRT                  46
#define _LMSGVTA                  47
#define _LNOTVTA                  48
#define _MNUMSER                  49
#define _CCODTIP                  50      //   C     3      0
#define _CCODFAM                  51      //   C     8      0
#define _CGRPFAM                  52      //   C     3      0
#define _NREQ                     53      //   N    16      6
#define _MOBSLIN                  54      //   M    10      0
#define _CCODPRV                  55      //   C    12      0
#define _CNOMPRV                  56      //   C    30      0
#define _CIMAGEN                  57      //   C    30      0
#define _NPUNTOS                  58
#define _NVALPNT                  59
#define _NDTOPNT                  60
#define _NINCPNT                  61
#define _CREFPRV                  62
#define _NVOLUMEN                 63
#define _CVOLUMEN                 64
#define __DFECENT                 65
#define __DFECSAL                 66
#define _NPREALQ                  67
#define __LALQUILER               68
#define _NNUMMED                  69
#define _NMEDUNO                  70
#define _NMEDDOS                  71
#define _NMEDTRE                  72
#define _NTARLIN                  73      //   L      1     0
#define _LIMPFRA                  74
#define _CCODFRA                  75
#define _CTXTFRA                  76
#define _DESCRIP                  77
#define _LLINOFE                  78
#define _LVOLIMP                  79
#define __NBULTOS                 80
#define _CFORMATO                 81
#define __CCODCLI                 82
#define __DFECSAT                 83
#define _NCNTACT                  84
#define _CDESUBI                  85
#define _LLABEL                   86
#define _NLABEL                   87
#define _COBRLIN                  88
#define _CREFAUX                  89
#define _CREFAUX2                 90
#define _NPOSPRINT                91

static nView
static cCodigoMaquina

//---------------------------------------------------------------------------//

function InicioHRB( aGet, aTmp, nVista, dbfTmpLin, nMode )

   if nMode != 1
      return .t.
   end if

   nView             := nVista

   codigoMaquina( dbfTmpLin )

   if !CompruebaFecha( aGet )
      Return .f.
   end if

   if !CompruebaCliente( aGet, dbfTmpLin )
      Return .f.
   end if

return .t.

//---------------------------------------------------------------------------//

static function Compruebafecha( aGet )

   local nRec
   local nOrdAnt
   local cCodCli              := aGet[ _CCODCLI ]:VarGet()
   local dNewFecha            := aGet[ _DFECSAT ]:VarGet()
   local lSeek                := .f.

   nRec     := ( D():SatClientesLineas( nView ) )->( Recno() )
   nOrdAnt  := ( D():SatClientesLineas( nView ) )->( OrdSetFocus( "cCliArt" ) )

   if ( D():SatClientesLineas( nView ) )->( dbSeek( cCodCli + cCodigoMaquina ) )

      while ( D():SatClientesLineas( nView ) )->cCodCli + ( D():SatClientesLineas( nView ) )->cRef == cCodCli + cCodigoMaquina .and. !( D():SatClientesLineas( nView ) )->( Eof() )

         if ( D():SatClientesLineas( nView ) )->dFecSat == dNewFecha
            lSeek  := .t.
         end if

         ( D():SatClientesLineas( nView ) )->( dbSkip() )

      end while

   end if
   
   ( D():SatClientesLineas( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():SatClientesLineas( nView ) )->( dbGoTo( nRec ) )

   if lSeek
      MsgStop( "Existe un S.A.T. con la fecha seleccionada" )
      Return .f.
   end if

Return .t.

//---------------------------------------------------------------------------//

static function CompruebaCliente( aGet, dbfTmpLin )

   local nRec
   local nOrdAnt
   local cCodCli              := aGet[ _CCODCLI ]:VarGet()
   local dMayorFecha          := ctod( "" )
   local cClienteMayorFecha   := ""

   nRec     := ( D():SatClientesLineas( nView ) )->( Recno() )
   nOrdAnt  := ( D():SatClientesLineas( nView ) )->( OrdSetFocus( "cRef" ) )

   if ( D():SatClientesLineas( nView ) )->( dbSeek( cCodigoMaquina ) )

      while ( D():SatClientesLineas( nView ) )->cRef == cCodigoMaquina .and. !( D():SatClientesLineas( nView ) )->( Eof() )

         if ( D():SatClientesLineas( nView ) )->dFecSat > dMayorFecha
            cClienteMayorFecha   := ( D():SatClientesLineas( nView ) )->cCodCli
            dMayorFecha          := ( D():SatClientesLineas( nView ) )->dFecSat
         end if

         ( D():SatClientesLineas( nView ) )->( dbSkip() )

      end while

   end if
   
   ( D():SatClientesLineas( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():SatClientesLineas( nView ) )->( dbGoTo( nRec ) )

   if cClienteMayorFecha != "000000"

      if cClienteMayorFecha != cCodCli
         MsgStop( "Cliente distinto al anterior: Cliente anterior: " + cClienteMayorFecha +  " Nuevo cliente: " + cCodCli )
         Return .f.
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

static function codigoMaquina( dbfTmpLin )

   local nRec     := ( dbfTmpLin )->( recno() )
   
   cCodigoMaquina  := ""

   ( dbfTmpLin )->( dbGoTop() )

   while !( dbfTmpLin )->( Eof() )

      if ( dbfTmpLin )->NCTLSTK == 2
         cCodigoMaquina  := ( dbfTmpLin )->cRef
      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTo( nRec ) )

Return nil

//---------------------------------------------------------------------------//