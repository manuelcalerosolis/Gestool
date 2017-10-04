//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSUtil                                                      //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Funciones de apoyo en PRG                                    //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//
// Asigna los codeblock de movimiento a un Browse

function MySetBrowse( oBrw, oDataSource )

    local lRet := .t.
    local bGoTop, bGoBottom, bSkipper
    local cClsName

    if !( ValType( oBrw ) == "O" ) .or. !( ValType( oDataSource ) == "O" )
        lRet := .f.
    else
        bGoTop := { || oDataSource:GoTop() }
        bGoBottom := { || oDataSource:GoBottom() }
        bSkipper := { | n | oDataSource:Skipper( n ) }

        cClsName := upper( oBrw:ClassName() )

        if cClsName == "TBROWSE" // El nativo de Harbour y xHarbour
            oBrw:goTopBlock := bGoTop
            oBrw:goBottomBlock := bGoBottom
            oBrw:SkipBlock := bSkipper
        elseif cClsName $ "TWBROWSE TCBROWSE TSBROWSE TGRID TXBROWSE" // Para windows
            oBrw:bGoTop := bGoTop
            oBrw:bGoBottom := bGoBottom
            oBrw:bSkip := bSkipper
            if cClsName == "TXBROWSE"
                oBrw:bBof := { || oDataSource:Bof() }
                oBrw:bEof := { || oDataSource:Eof() }
                oBrw:bBookMark :={ | n | if( n == nil, oDataSource:RecNo(), ;
                                                       oDataSource:GoTo( n ) ) }
                oBrw:bKeyNo :=  { || oDataSource:RecNo() }
                oBrw:bKeyCount := { || oDataSource:RecCount() }
                oBRw:nDataType := 4096 // DATATYPE_USER // 64  DATATYPE_MYSQL
            else
                oBrw:bLogicLen := { || oDataSource:RecCount() }
            endif
            if !( oBrw:oVScroll() == nil )
                oBrw:oVscroll():SetRange( 1, oDataSource:RecCount() )
            endif
            oBrw:Refresh()
        else
            oDataSource:oError:Say( "Browse no implementado en SetBrowse", .f. )
        endif
    endif

return( lRet )

//----------------------------------------------------------------------------//
// Para ver un array unimesional con valores de cualquier tipo

procedure Muestra( a, cTitle )

    local cTxt, i
    local n := len( a )

    cTitle := if( empty( cTitle ), "Atencion", cTitle )

    if n > 0
        cTxt := ""
        FOR i := 1 TO n
            cTxt += Chr(13) + Chr(10) + ;
                    if( a[ i ] == nil, "NULO", transform( a[ i ], "@" ) )
        NEXT
    else
        cTxt := "Array vacio"
    endif

    MyMsgInfo( cTxt, cTitle )

return

//---------------------------------------------------------------------------//
// Destruye un objeto y llama al recolecto de basura de (x)Harbour

procedure MyFreeObject( oObj )

    if ValType( oObj ) == "O"
        oObj:Free()
    endif

    oObj := NIL
    hb_gcAll( .t. )

return

//---------------------------------------------------------------------------//
//  MyGenError( cOperation )
//

procedure _MsGenError( cOperation )

   local oError := ErrorNew()

   oError:SubSystem := "EAGLE1_LIB"
   oError:Operation := cOperation
   oError:CanDefault := .t.

   eval( ErrorBlock(), oError )

return

//---------------------------------------------------------------------------//

