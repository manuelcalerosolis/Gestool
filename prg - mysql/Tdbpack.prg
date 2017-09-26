//----------------------------------------------------------------------------//

Function DbPack( xAlias )

    local lRet   := .t.
    local cFPack := ""
    local nCount := 0
    local i      := 0
    local aFld   := {}
    local nFCount := 0
    local cType  := ValType( xAlias )
    local oDb

        DO CASE
            CASE cType == "O"   // Objeto TDbf
                oDb := xAlias
            CASE cType == "C"   // Alias
                oDb := DbfServer( xAlias ):Use( xAlias )
            CASE cType == "N"   // Area
                oDb := DbfServer( Alias( xAlias ) ):Use( Alias( xAlias ) )
        END CASE

    if lRet
        aFld := ::aField()
        nFCount := len( aFld )
        while file( cFPack := ::cPath + "Pck" + ;
            PadL( ++nCount, 4, "0" ) + ".DBF" )
        end
        DbCreate( cFPack, aFld, ::cRDD, .t., "Empa" )
        ::GoTop()
        while ( ::nArea )->( !Eof() )
            Empa->( DbAppend() )
            FOR i := 1 TO nFCount
                Empa->( FieldPut( i, ( ::nArea )->( FieldGet( i ) ) ) )
            NEXT
            ( ::nArea )->( DbSkip( 1 ) )
        end
        ::Close()
        ::IdxFDel()
        FErase( ::cFile )
        FRename( cFPack, ::cFile )
    else
        msgStop( "El fichero " + oDb:cFile + " no esta abierto en modo exclusivo" )
    endif

return( lRet )

//----------------------------------------------------------------------------//