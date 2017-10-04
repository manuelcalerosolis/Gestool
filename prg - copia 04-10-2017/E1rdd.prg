//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: E1RDD                                                        //
//  FECHA MOD.: 25/04/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: RDD para Eagle1                                              //
//---------------------------------------------------------------------------//

#include "eagle1.ch"
#include "e1rdd.ch"
#include "rddsys.ch"
#include "dbinfo.ch"

//-----------------------------------------------------------------------------

ANNOUNCE E1RDD

//-----------------------------------------------------------------------------

static oConnection

//-----------------------------------------------------------------------------
// Asigna los objetos Connetion a E1RDD

procedure InitE1RDD( oCon )

    oConnection := oCon

return

//-----------------------------------------------------------------------------
// Devuelve el objeto Connection con el que esta trabajando E1RDD

function GetConnectObject( nWA )
return( USRRDD_RDDDATA( USRRDD_ID( nWA ) ) )

//-----------------------------------------------------------------------------
// Devuelve el objeto TTable con el que esta trabajando E1RDD

function GetTableObject( nWA )
return( USRRDD_AREADATA( nWA )[ WAD_OTB ] )

//-----------------------------------------------------------------------------
// Valores locales del RDD

static function E1RDD_INIT( nRDD )

    USRRDD_RDDDATA( nRDD )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Valores locales del Area de trabajo WA

static function E1RDD_NEW( nWA )

    local aWAData := Array( WAD_SIZE )

    // Asigna el array de variables particulares del WA
    aWADATA[ WAD_OTB ] := nil
    aWADATA[ WAD_RECLOAD ] := .t.
    aWADATA[ WAD_APPEND ] := .f.

    USRRDD_AREADATA( nWA, aWAData )

    // Asigna la variable particulares de E1RDD
    USRRDD_RDDDATA( USRRDD_ID( nWA ), oConnection )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Crea una tabla en la base de datos por defecto

static function E1RDD_CREATE( nWA, aOpenInfo )

    local oCon := USRRDD_RDDDATA( USRRDD_ID( nWA ) )
    local oTb := TMSTable():New( oCon, aOpenInfo[ UR_OI_NAME ] )

    oTb:CreateTable( ( nWA )->( DbStruct() ),,, .t. )

    USRRDD_AREADATA( nWA )[ WAD_OTB ] := oTb

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Abre la tabla

static function E1RDD_OPEN( nWA, aOpenInfo )

    local oCon := USRRDD_RDDDATA( USRRDD_ID( nWA ) )
    local oTb := TMSTable():New( oCon, aOpenInfo[ UR_OI_NAME ] )
    local aStruct, aField, aFieldStruct

    oTb:SetReadPADAll( .t. )

    if oTb:Open()

        USRRDD_AREADATA( nWA )[ WAD_OTB ] := oTb

        UR_SUPER_SETFIELDEXTENT( nWA, oTb:FCount() )

        aStruct := oTb:XStruct()

        FOR EACH aFieldStruct IN aStruct

            aField := Array( UR_FI_SIZE )

            aField[ UR_FI_NAME ] := aFieldStruct[ E1_DBS_NAME ]
            aField[ UR_FI_TYPE ] := aFieldStruct[ E1_DBS_UITYPE ]
            aField[ UR_FI_TYPEEXT ] := 0
            aField[ UR_FI_LEN ] := aFieldStruct[ E1_DBS_LEN ]
            aField[ UR_FI_DEC ] := aFieldStruct[ E1_DBS_DEC ]

            UR_SUPER_ADDFIELD( nWA, aField )

        NEXT
    else
        Alert( "Error... RDD OPEN " )
    endif

return( UR_SUPER_OPEN( nWA, aOpenInfo ) )

//-----------------------------------------------------------------------------
// Borra permanentemente las filas de la tabla
// Ojo!!! inserta un registro vacío

static function E1RDD_ZAP( nWA )

    local oTb := USRRDD_AREADATA( nWA )[ WAD_OTB ]

    oTb:oCmd:ExecDirect( "TRUNCATE TABLE " + oTb:cName )
    oTb:Blank()
    oTb:Insert( .t. )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Cierra la tabla

static function E1RDD_CLOSE( nWA )

    local aWAData := USRRDD_AREADATA( nWA )
    local oTb := aWAData[ WAD_OTB ]

    if !aWAData[ WAD_RECLOAD ]
        E1RDD_FLUSH( nWA )
    endif

    aWAData[ WAD_OTB ]:Free()

    USRRDD_AREADATA( nWA, nil )

return( UR_SUPER_CLOSE( nWA ) )

//-----------------------------------------------------------------------------
// Devuelve el valor de un campo

static function E1RDD_GETVALUE( nWA, nField, xValue )

    local aWAData := USRRDD_AREADATA( nWA )

    xValue := if( aWAData[ WAD_RECLOAD ], ;
                  aWAData[ WAD_OTB ]:FieldGet( nField ), ;
                  aWAData[ WAD_OTB ]:GetBuffer( nField ) )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Asigna un valor a un campo

static function E1RDD_PUTVALUE( nWA, nField, xValue )

    local aWAData := USRRDD_AREADATA( nWA )

    if aWAData[ WAD_RECLOAD ]
        aWAData[ WAD_OTB ]:Load()
        aWAData[ WAD_RECLOAD ] := .f.
    endif

    aWAData[ WAD_OTB ]:FieldPut( nField, xValue )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Salta nRecords en cualquier direccion

static function E1RDD_SKIPRAW( nWA, nRecords )

    local aWAData := USRRDD_AREADATA( nWA )

    if !aWAData[ WAD_RECLOAD ]
        E1RDD_FLUSH( nWA )
    endif

    aWAData[ WAD_OTB ]:Skip( nRecords )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Posiciona el cursor al principio de la tabla

static function E1RDD_GOTOP( nWA )

    local aWAData := USRRDD_AREADATA( nWA )

    if !aWAData[ WAD_RECLOAD ]
        E1RDD_FLUSH( nWA )
    endif

    aWAData[ WAD_OTB ]:GoTop()

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Posiciona el cursor al final de la tabla

static function E1RDD_GOBOTTOM( nWA )

    local aWAData := USRRDD_AREADATA( nWA )

    if !aWAData[ WAD_RECLOAD ]
        E1RDD_FLUSH( nWA )
    endif

    aWAData[ WAD_OTB ]:GoBottom()

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Posiciona el puntero en la posicion indicada de la tabla

static function E1RDD_GOTO( nWA, nRecord )

    local aWAData := USRRDD_AREADATA( nWA )

    if !aWAData[ WAD_RECLOAD ]
        E1RDD_FLUSH( nWA )
    endif

    aWAData[ WAD_OTB ]:GoTo(  nRecord )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Cuenta el numero de registros de la tabla

static function E1RDD_RECCOUNT( nWA, nRecords )

   nRecords := USRRDD_AREADATA( nWA )[ WAD_OTB ]:RecCount()

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Indica si estamos en el principio de la tabla

static function E1RDD_BOF( nWA, lBof )

    lBof := USRRDD_AREADATA( nWA )[ WAD_OTB ]:Bof()

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Indica si estamos en el final de la tabla

static function E1RDD_EOF( nWA, lEof )

    lEof := USRRDD_AREADATA( nWA )[ WAD_OTB ]:Eof()

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Devuelve el numero registro actual de la tabla

static function E1RDD_RECID( nWA, nRecNo )

   nRecNo := USRRDD_AREADATA( nWA )[ WAD_OTB ]:RecNo()

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Indica si el registro esta borrado (No necesario)

static function E1RDD_DELETED( nWA, lDeleted )

    HB_SYMBOL_UNUSED( nWA )
    lDeleted := .F.

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Actualiza la tabla con los valores del buffer

static function E1RDD_FLUSH( nWA )

    local aWAData := USRRDD_AREADATA( nWA )
    local nRec

    if aWADATA[ WAD_APPEND ]
        aWADATA[ WAD_APPEND ] := .f.
        aWAData[ WAD_OTB ]:Insert( .t. )
    else
        nRec := aWAData[ WAD_OTB ]:RecNo()
        aWAData[ WAD_OTB ]:Update( .t., 1 )
        aWAData[ WAD_OTB ]:GoTo( nRec )
    endif

    aWADATA[ WAD_RECLOAD ] := .t.

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Prepara el area de trabajo para añadir un registro

static function E1RDD_APPEND( nWA, nRecords )

    local aWAData := USRRDD_AREADATA( nWA )

    HB_SYMBOL_UNUSED( nRecords )

    aWAData[ WAD_OTB ]:Blank()
    aWADATA[ WAD_RECLOAD ] := .f.
    aWADATA[ WAD_APPEND ] := .t.

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Borra el registro actual

static function E1RDD_DELETE( nWA )

    local aWAData := USRRDD_AREADATA( nWA )

    aWAData[ WAD_OTB ]:Delete( .t., 1 )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------

static function E1RDD_INFO( nWA, uiIndex, xInfo )

    SWITCH uiIndex
        CASE DBI_ISDBF
            xInfo := .f.
            EXIT

        CASE DBI_CANPUTREC
            xInfo := .t.
            EXIT

        CASE DBI_GETHEADERSIZE
            xInfo := 0
            EXIT

        CASE DBI_LASTUPDATE
            xInfo := date()
            EXIT

        CASE DBI_GETRECSIZE
            xInfo := 100        // Hacer
            EXIT

        CASE DBI_GETLOCKARRAY
            xInfo := {}
            EXIT

        CASE DBI_TABLEEXT
            xInfo := "MySQL"
            EXIT

        CASE DBI_FULLPATH
            xInfo := ""
            EXIT

        CASE DBI_MEMOTYPE
            xInfo := 0
            EXIT

        CASE DBI_TABLETYPE
            xInfo := 0
            EXIT

        CASE DBI_FILEHANDLE
            xInfo := 0
            EXIT

        CASE DBI_MEMOHANDLE
            xInfo := 0
            EXIT

        CASE DBI_SHARED
            xInfo := .t.
            EXIT

        CASE DBI_ISFLOCK
            xInfo := .f.
            EXIT

        CASE DBI_ISREADONLY
            xInfo := .f.
            EXIT

        CASE DBI_ISTEMPORARY
            xInfo := .f.
            EXIT

        CASE DBI_VALIDBUFFER
            xInfo := .t.
            EXIT

        CASE DBI_POSITIONED
            xInfo := .t.
            EXIT

        CASE DBI_ISENCRYPTED
            xInfo := .f.
            EXIT

        CASE DBI_DECRYPT
            xInfo := .f.
            EXIT

        CASE DBI_ENCRYPT
            xInfo := .f.
            EXIT

        CASE DBI_LOCKCOUNT
            xInfo := 0
            EXIT

        CASE DBI_LOCKOFFSET
            xInfo := 0
            EXIT

        CASE DBI_LOCKSCHEME
            xInfo := 0
            EXIT

        CASE DBI_ROLLBACK
            xInfo := ""
            EXIT

        CASE DBI_PASSWORD
            xInfo := ""
            EXIT

        CASE DBI_TRIGGER
            xInfo := ""
            EXIT

        CASE DBI_OPENINFO
            xInfo := ""
            EXIT

        CASE DBI_DIRTYREAD
            xInfo := .t.
            EXIT

        CASE DBI_DB_VERSION
        CASE DBI_RDD_VERSION
            xInfo := "E1RDD 1.00"
            EXIT
    END

return( HB_SUCCESS )

//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
//  EN PRUEBA
//-----------------------------------------------------------------------------

static function E1RDD_GOCOLD( nWA )

    Alert( "E1RDD_GOCOLD en " + StrNum( nWA ) )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------

static function E1RDD_GOHOT( nWA )

    Alert( "E1RDD_GOHOT en " + StrNum( nWA ) )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------

static function E1RDD_LOCK( nWA, aLockInfo  )

    HB_SYMBOL_UNUSED( nWA )
    HB_SYMBOL_UNUSED( aLockInfo )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

static function E1RDD_UNSUPPORTED( nWA )

    Alert( "E1RDD Atencion;Esta funcion no esta implementada..." )

return( HB_SUCCESS )

//-----------------------------------------------------------------------------
// Obtiene la tabla de puntero a funciones

function E1RDD_GETFUNCTABLE( pFuncCount, pFuncTable, pSuperTable, nRddID )

    local cSuperRDD := nil     // Sin super RDD del que heredar
    local aE1FuncTable[ UR_METHODCOUNT ] // Tabla de punteros afunciones

    /* Funciones que no afectan al area de trabajo*/

    aE1FuncTable[ UR_INIT ]     := ( @E1RDD_INIT() )
//    aE1FuncTable[ UR_EXIT ] := ( @E1RDD_EXIT() )
//    aE1FuncTable[ UR_DROP ] := ( @E1RDD_DROP() )
//    aE1FuncTable[ UR_EXISTS ] := ( @E1RDD_EXISTS() )
//    aE1FuncTable[ UR_RENAME ] := ( @E1RDD_RENAME() )
//    aE1FuncTable[ UR_RDDINFO ] := ( @E1RDD_RDDINFO() )

    /* Manejado de areas de trabajo */

//    aE1FuncTable[ UR_ALIAS ] := ( @E1RDD_ALIAS() )                // Super
    aE1FuncTable[ UR_CLOSE ]    := ( @E1RDD_CLOSE() )
    aE1FuncTable[ UR_CREATE ]   := ( @E1RDD_CREATE() )
    aE1FuncTable[ UR_INFO ]     := ( @E1RDD_INFO() )
    aE1FuncTable[ UR_NEW ]      := ( @E1RDD_NEW() )
    aE1FuncTable[ UR_OPEN ]     := ( @E1RDD_OPEN() )
//    aE1FuncTable[ UR_RELEASE ] := ( @E1RDD_RELEASE() )            // Super ?
//    aE1FuncTable[ UR_STRUCTSIZE ] := ( @E1RDD_STRUCTSIZE() )      // Super ?
//    aE1FuncTable[ UR_SYSNAME ] := ( @E1RDD_SYSNAME() )            // Super
//    aE1FuncTable[ UR_DBEVAL ] := ( @E1RDD_DBEVAL() )
//    aE1FuncTable[ UR_PACK ] := ( @E1RDD_PACK() )
//    aE1FuncTable[ UR_PACKREC ] := ( @E1RDD_PACKREC() )
//    aE1FuncTable[ UR_SORT ] := ( @E1RDD_SORT() )
//    aE1FuncTable[ UR_TRANS ] := ( @E1RDD_TRANS() )
//    aE1FuncTable[ UR_TRANSREC ] := ( @E1RDD_TRANSREC() )
    aE1FuncTable[ UR_ZAP ]      := ( @E1RDD_ZAP() )


   /* Metodos de posicionamiento y movimiento */

    aE1FuncTable[ UR_BOF ]      := ( @E1RDD_BOF() )
    aE1FuncTable[ UR_EOF ]      := ( @E1RDD_EOF() )
//    aE1FuncTable[ UR_FOUND ] := ( @E1RDD_FOUND() )
    aE1FuncTable[ UR_GOBOTTOM ] := ( @E1RDD_GOBOTTOM() )
    aE1FuncTable[ UR_GOTO ]     := ( @E1RDD_GOTO() )
    aE1FuncTable[ UR_GOTOID ]   := ( @E1RDD_GOTO() )
    aE1FuncTable[ UR_GOTOP ]    := ( @E1RDD_GOTOP() )
//    aE1FuncTable[ UR_SEEK ] := ( @E1RDD_SEEK() )
//    aE1FuncTable[ UR_SKIP ]     := ( @E1RDD_SKIP() )
//    aE1FuncTable[ UR_SKIPFILTER ] := ( @E1RDD_SKIPFILTER() )
    aE1FuncTable[ UR_SKIPRAW ] := ( @E1RDD_SKIPRAW() )

   /* Manejador de datos */

//    aE1FuncTable[ UR_ADDFIELD ] := ( @E1RDD_ADDFIELD() )          // Super
    aE1FuncTable[ UR_APPEND ]   := ( @E1RDD_APPEND() )
//    aE1FuncTable[ UR_CREATEFIELDS ] := ( @E1RDD_CREATEFIELDS() )  // Super
    aE1FuncTable[ UR_DELETE ]   := ( @E1RDD_DELETE() )
    aE1FuncTable[ UR_DELETED ]  := ( @E1RDD_DELETED() )
//    aE1FuncTable[ UR_FIELDCOUNT ] := ( @E1RDD_FIELDCOUNT() )      // Super
//    aE1FuncTable[ UR_FIELDDISPLAY ] := ( @E1RDD_FIELDDISPLAY() )
//    aE1FuncTable[ UR_FIELDINFO ] := ( @E1RDD_FIELDINFO() )        // Super
//    aE1FuncTable[ UR_FIELDNAME ] := ( @E1RDD_FIELDNAME() )        // Super
    aE1FuncTable[ UR_FLUSH ]    := ( @E1RDD_FLUSH() )
//    aE1FuncTable[ UR_GETREC ] := ( @E1RDD_GETREC() )
    aE1FuncTable[ UR_GETVALUE ] := ( @E1RDD_GETVALUE() )
//    aE1FuncTable[ UR_GETVARLEN ] := ( @E1RDD_GETVARLEN() )
    aE1FuncTable[ UR_GOCOLD ]   := ( @E1RDD_GOCOLD() )
    aE1FuncTable[ UR_GOHOT ]    := ( @E1RDD_GOHOT() )
//    aE1FuncTable[ UR_PUTREC ] := ( @E1RDD_PUTREC() )
    aE1FuncTable[ UR_PUTVALUE ] := ( @E1RDD_PUTVALUE() )
//    aE1FuncTable[ UR_RECALL ] := ( @E1RDD_RECALL() )
    aE1FuncTable[ UR_RECCOUNT ] := ( @E1RDD_RECCOUNT() )
//    aE1FuncTable[ UR_RECINFO ] := ( @E1RDD_RECINFO() )
    aE1FuncTable[ UR_RECNO ]    := ( @E1RDD_RECID() )
    aE1FuncTable[ UR_RECID ]    := ( @E1RDD_RECID() )
//    aE1FuncTable[ UR_SETFIELDEXTENT ] := ( @E1RDD_SETFIELDEXTENT() )

    aE1FuncTable[ UR_LOCK ]     := ( @E1RDD_LOCK() )

return( USRRDD_GETFUNCTABLE( pFuncCount, pFuncTable, ;
                             pSuperTable, nRddID, cSuperRDD, aE1FuncTable ) )

//-----------------------------------------------------------------------------
// Inicia y registra la RDD

init procedure EAGLE1RDD_INIT()

   rddRegister( "E1RDD", RDT_FULL )

return

//-----------------------------------------------------------------------------

