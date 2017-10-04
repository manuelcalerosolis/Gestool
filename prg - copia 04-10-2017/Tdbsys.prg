//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez   Soft 4U                              //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: TDbSys ( TDbf )                                               //
//  FECHA MOD.: 24/01/2002                                                    //
//  VERSION...: 11.00                                                         //
//  PROPOSITO.: Gesti¢n y control de objetos TDbf                             //
//----------------------------------------------------------------------------//

#include "Obj2Hb.ch"
#include "MesDbf.ch"

#define IDBS_ALIAS        1
#define IDBS_FILE         2
#define IDBS_PATH         3
#define IDBS_RDD          4
#define IDBS_RECYCLE      5
#define IDBS_SHARED       6
#define IDBS_READONLY     7
#define IDBS_PROTECT      8
#define IDBS_COMMENT      9

#define IFLS_ALIAS        1
#define IFLS_NAME         2
#define IFLS_TYPE         3
#define IFLS_LEN          4
#define IFLS_DEC          5
#define IFLS_PICT         6
#define IFLS_DEFAULT      7
#define IFLS_COMMENT      8

#define IIDS_ALIAS        1
#define IIDS_NAME         2
#define IIDS_FILE         3
#define IIDS_KEY          4
#define IIDS_FOR          5
#define IIDS_UNIQUE       6
#define IIDS_DES          7
#define IIDS_STEP         8
#define IIDS_COMMENT      9

CLASS TDbSys

    DATA cName, cPath, cComment AS STRING
    DATA oDBS, oFLS, oIDS       AS OBJECT

    METHOD New( cName, cPath, cComment ) CONSTRUCTOR
    METHOD Activate()
    METHOD Close()  INLINE  ::oDBS:Close(), ::oFLS:Close(), ::oIDS:Close()
    METHOD End()    INLINE  ::oDBS:End(), ::oFLS:End(), ::oIDS:End()

    METHOD ReadDbf( cAlias )
    METHOD ReadFld( cAlias )
    METHOD ReadIdx( cAlias )

    METHOD GetDbf( cAlias )

    METHOD Destroy()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cName, cPath, cComment ) CLASS TDbSys

    local nDbAct := 0

    if ValType( cName ) != "C"
        nDbAct := Select()
        DbSelectArea( 0 )
        ::cName := "DBSM" + PadL( Select(), 4, "0" )
        DbSelectArea( nDbAct )
    else
        ::cName := cName
    endif

    DEFAULT cPath := Set( _SET_DEFAULT )
    ::cPath := if( right( cPath, 1 ) != "\", cPath + "", cPath )

    BYNAME cComment DEFAULT "Data Base Systen Manager"

return( Self )

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TDbSys

    //---------------------- DATA BASE SYSTEM -------------------------------

    ::oDBS := DbfServer( ::cName + ".DBS", "DBS" ):New( ::cName + ".DBS",,, ;
                                                        ::cComment, ::cPath )

        ::oDBS:AddField( "CALIAS",    "C", 08 )
        ::oDBS:AddField( "CFILE",     "C", 12 )
        ::oDBS:AddField( "CPATH",     "C", 48 )
        ::oDBS:AddField( "CRDD",      "C", 10 )
        ::oDBS:AddField( "LRECYCLE",  "L", 01 )
        ::oDBS:AddField( "LSHARED",   "L", 01 )
        ::oDBS:AddField( "LREADONLY", "L", 01 )
        ::oDBS:AddField( "LPROTECT",  "L", 01 )
        ::oDBS:AddField( "CCOMMENT",  "C", 64 )

        ::oDBS:AddIndex(, "I1DBS", "upper( cAlias )" )

    ::oDBS:Activate( .f., .f., .T., .F., .F. )

    //---------------------- DATA BASE FIELD SYSTEM -------------------------

    ::oFLS := DbfServer( ::cName + ".FLS", "FLS" ):New( ::cName + ".FLS",,, ;
                                                        ::cComment, ::cPath )

        ::oFLS:AddField( "CALIAS",   "C", 08 )
        ::oFLS:AddField( "CNAME",    "C", 10 )
        ::oFLS:AddField( "CTYPE",    "C", 01 )
        ::oFLS:AddField( "NLEN",     "N", 03 )
        ::oFLS:AddField( "NDEC",     "N", 03 )
        ::oFLS:AddField( "CPICT",    "C", 10 )
        ::oFLS:AddField( "XDEFAULT", "C", 64 )
        ::oFLS:AddField( "CCOMMENT", "C", 64 )

        ::oFLS:AddIndex(, "I1FLS", "upper( cAlias )" )

    ::oFLS:Activate(.f., .f., .T., .F., .F. )

    //---------------------- DATA BASE INDEX SYSTEM -------------------------

    ::oIDS := DbfServer( ::cName + ".IDS", "IDS" ):New( ::cName + ".IDS",,, ;
                                                        ::cComment, ::cPath )

        ::oIDS:AddField( "CALIAS",   "C", 08 )
        ::oIDS:AddField( "CNAME",    "C", 10 )
        ::oIDS:AddField( "CFILE",    "C", 12 )
        ::oIDS:AddField( "CKEY",     "C", 64 )
        ::oIDS:AddField( "CFOR",     "C", 64 )
        ::oIDS:AddField( "LUNIQUE",  "L", 01 )
        ::oIDS:AddField( "LDES",     "L", 01 )
        ::oIDS:AddField( "NSTEP",    "N", 10 )
        ::oIDS:AddField( "CCOMMENT", "C", 64 )

        ::oIDS:AddIndex(, "I1IDS", "upper( cAlias )" )

    ::oIDS:Activate( .f., .f., .t., .f., .f. )

return( Self )

//----------------------------------------------------------------------------//
// Devuelve un array con la estructura ampliada de la DBF

METHOD ReadDbf( cAlias ) CLASS TDbSys

    local aDbf := {}
    local i    := 0

    if ::oDBS:Seek( upper( cAlias ) )
        FOR i := 1 TO ::oDBS:nFieldCount
            AADD( aDbf, ( ::oDBS:nArea )->( ::oDBS:aTField[ i ]:Load() ) )
        NEXT
    endif

return( aDbf )

//----------------------------------------------------------------------------//
// Devuelve un array con la estructura ampliada de campos de la DBF

METHOD ReadFld( cAlias ) CLASS TDbSys

    local aFld := {}
    local aFls := {}
    local i    := 0

    ::oFLS:SetScope( upper( cAlias ) )

    if ::oFLS:Count() > 0
        while !::oFLS:Eof()
            aFld := {}
            FOR i := 1 TO ::oFLS:nFieldCount
                AADD( aFld, ( ::oFLS:nArea )->( ::oFLS:aTField[ i ]:Load() ) )
            NEXT
            AADD( aFls, aFld )
            ::oFLS:Skip()
        end
    endif

    ::oFLS:ClearScope()

return( aFls )

//----------------------------------------------------------------------------//
// Devuelve un array con la estructura ampliada de indices de la DBF

METHOD ReadIdx( cAlias ) CLASS TDbSys

    local aIdx := {}
    local aIds := {}
    local i    := 0

    ::oIDS:SetScope( upper( cAlias ) )

    if ::oIDS:Count() > 0
        while !::oIDS:Eof()
            aIdx := {}
            FOR i := 1 TO ::oIDS:nFieldCount
                AADD( aIdx, ( ::oIDS:nArea )->( ::oIDS:aTField[ i ]:Load() ) )
            NEXT
            AADD( aIds, aIdx )
            ::oIDS:Skip()
        end
    endif

    ::oIDS:ClearScope()

return( aIds )

//----------------------------------------------------------------------------//

METHOD GetDbf( cAlias ) CLASS TDbSys

    local aDbf := {}
    local oDbf := TDbf()
    local oFld := TField()
    local oIdx := TIndex()
    local i := 0
    local n := 0
    local aFld := {}
    local aIdx := {}

    aDbf := ::ReadDbf( upper( cAlias ) )

    if len( aDbf ) > 0
        oDbf := DbfServer( aDbf[ IDBS_FILE ] ):New( aDbf[ IDBS_ALIAS ], ;
                           aDbf[ IDBS_ALIAS ],   aDbf[ IDBS_RDD ], ;
                           aDbf[ IDBS_COMMENT ], aDbf[ IDBS_PATH ] )
        if ( n := len( aFld := ::ReadFld( cAlias ) ) ) > 0
            FOR i := 1 TO n
                oDbf:AddField( aFld[ i, IFLS_NAME ], aFld[ i, IFLS_TYPE ], ;
                               aFld[ i, IFLS_LEN ],  aFld[ i, IFLS_DEC ], ;
                               aFld[ i, IFLS_PICT ], aFld[ i, IFLS_DEFAULT ],,,;
                               aFld[ i, IFLS_COMMENT ] )
            NEXT
        endif
        if ( n := len( aIdx := ::ReadIdx( cAlias ) ) ) > 0
            FOR i := 1 TO n
                oDbf:AddIndex( aIdx[ i, IIDS_NAME ],     aIdx[ i, IIDS_FILE ], ;
                               aIdx[ i, IIDS_KEY ],      aIdx[ i, IIDS_FOR ],, ;
                               aIdx[ i, IIDS_UNIQUE ],   aIdx[ i, IIDS_DES ], ;
                               aIdx[ i, IIDS_COMMENT ],, aIdx[ i, IIDS_STEP ] )
            NEXT
        endif
        oDbf:Activate( aDbf[ IDBS_RECYCLE ], ;
                       aDbf[ IDBS_SHARED ],  aDbf[ IDBS_READONLY ], ;
                       aDbf[ IDBS_PROTECT ] )
    endif

return( oDbf )

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TDbSys

    oDBS := nil
    oFLS := nil
    oIDS := nil
    Self := nil

return( .t. )

//----------------------------------------------------------------------------//
