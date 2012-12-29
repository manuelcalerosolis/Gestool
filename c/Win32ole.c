#ifndef __STDC__
   #define __STDC__ 1
#endif

#ifndef CINTERFACE
   #define CINTERFACE 1
#endif

#ifndef __FLAT__
  #define __FLAT__ 1
#endif

#define NONAMELESSUNION

#include "Item.api"
#include "ClipDefs.h"
#include "Fm.api"
#include "Extend.api"
#include "Externs.api"

#include <cType.h>

#include <Windows.h>
#include <Ole2.h>
#include <OleAuto.h>

#include <ShlObj.h>

#ifdef __MINGW32__
   // Missing in oleauto.h
   WINOLEAUTAPI VarR8FromDec(DECIMAL *pdecIn, DOUBLE *pdblOut);
#endif

static HRESULT s_nOleError = 0;
static ITEM OleAuto;                // static HB_ITEM  OleAuto

static PHB_DYNS s_pSym_OleAuto = NULL;  // Estos son punteros a simbolos dinamicos en C3 no existen a
static PHB_DYNS s_pSym_hObj    = NULL;
static PHB_DYNS s_pSym_New     = NULL;

static char *s_OleRefFlags = NULL;

//---------------------------------------------------------------------------//

CLIPPER OLE_INITIALIZE( void )
   {
      s_nOleError = OleInitialize( NULL );

      s_pSym_OleAuto = _get_sym( "TOLEAUTO" ); //hb_dynsymFindName( "TOLEAUTO" );  // Estos buscan punteros a las funciones dinamicas
      s_pSym_New     = _get_sym( "NEW" ); //hb_dynsymFindName( "NEW" );
   }

//---------------------------------------------------------------------------//

CLIPPER OLE_UNINITIALIZE( void )
   {
      OleUninitialize();
   }

//---------------------------------------------------------------------------//

CLIPPER SETOLEREFFLAGS( void )
   {
      if( s_OleRefFlags )
      {
         _xfree( s_OleRefFlags ); // hb_xfree( s_OleRefFlags );
         s_OleRefFlags = NULL;
      }

      if( _parinfo(0) )                 // hb_pcount()
      {
         s_OleRefFlags = _vstrcold( ) // hb_strdup( hb_stackItemFromBase( 1 )->item.asString.value );
      }
   }

//---------------------------------------------------------------------------//

static VARIANTARG RetVal;

static EXCEPINFO excep;

static void *aPrgParams = NULL;

//---------------------------------------------------------------------------//

static double DateToDbl( LPSTR cDate )
  {
     double nDate;

     nDate = hb_dateEncStr( cDate ) - 0x0024d9abL;

     return ( nDate );
  }

//---------------------------------------------------------------------------//

static LPSTR DblToDate( double nDate )
  {
     static char *cDate = "00000000";

     hb_dateDecStr( cDate, (long) nDate + 0x0024d9abL );

     return ( cDate );
  }

//---------------------------------------------------------------------------//

static BSTR AnsiToWide( LPSTR cString )
  {
     UINT uLen;
     BSTR wString;

     uLen  = strlen( cString ) + 1;

     if( uLen > 1 )
     {
        wString = ( BSTR ) _xgrab( uLen * 2 );
        MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, cString, uLen, wString, uLen );
     }
     else
     {
        // *** This is a speculation about L"" - need to be verified.
        wString = (BSTR) _xgrab( 2 );
        wString[0] = L'\0';
     }

     //printf( "\nAnsi: '%s'\n", cString );
     //wprintf( L"\nWide: '%s'\n", wString );

     return wString;
  }

//---------------------------------------------------------------------------//

static LPSTR WideToAnsi( BSTR wString )
  {
     UINT uLen;
     char *cString;

     uLen = SysStringLen( wString ) + 1;

     if( uLen > 1 )
     {
        cString = (char *) _xgrab( uLen );
        WideCharToMultiByte( CP_ACP, 0, wString, uLen, cString, uLen, NULL, NULL );
     }
     else
     {
        cString = (char *) _xgrab( 1 );
        cString[0] = '\0';
     }

     //wprintf( L"\nWide: '%s'\n", wString );
     //printf( "\nAnsi: '%s'\n", cString );

     return cString;
  }

//---------------------------------------------------------------------------//

static void GetParams(DISPPARAMS * dParams)
  {
     VARIANTARG * pArgs = NULL;
     PHB_ITEM uParam;
     int n, nArgs, nArg, nParam;
     BSTR wString;
     BOOL bByRef;

     nArgs = _parinfo( 0 ) - 2;

     if( nArgs > 0 )
     {
        pArgs = ( VARIANTARG * ) _xgrab( sizeof( VARIANTARG ) * nArgs );
        aPrgParams = ( void * ) _xgrab( 14 * nArgs );

        //printf( "Args: %i\n", nArgs );

        for( n = 0; n < nArgs; n++ )
        {
           // Pramateres processed in reveresed order.
           nArg = nArgs + 2 - n;
           nParam = nArgs - n;

           bByRef = s_OleRefFlags && s_OleRefFlags[ nParam - 1 ] == 'Y';

           //printf( "N: %i Arg: %i Type: %i ByRef: %i\n", n, nArg, hb_stackItemFromBase( nArg  )->type, bByRef );

           VariantInit( &( pArgs[ n ] ) );

           uParam = _param( nArg, S_ANYEXP ); //hb_param( nArg, HB_IT_ANY );

           aPrgParams[ n ] = uParam;

           switch( _itemType( uParam ) )
           {
              case S_UNDEF:           // No se como detectar q es nil
                pArgs[ n ].n1.n2.vt   = VT_EMPTY;  // No se de donde viene VT_EMPTY creo q es de C++
                break;

              case S_CHAR:
              case S_MEMO:
                if( bByRef )
                {
                   wString = AnsiToWide( _parc( nArg ) );
                   // hb_itemReleaseString( uParam );
                   _itemPutC( uParam, (char *) SysAllocString( wString ) )
                   //uParam->item.asString.value = (char *) SysAllocString( wString );
                   _xfree( wString );
                   pArgs[ n ].n1.n2.vt   = VT_BYREF | VT_BSTR;
                   pArgs[ n ].n1.n2.n3.pbstrVal = (BSTR *) _itemGetC( n ); //&( uParam->item.asString.value );
                }
                else
                {
                   pArgs[ n ].n1.n2.vt   = VT_BSTR;
                   wString = AnsiToWide( _parc( nArg ) );
                   pArgs[ n ].n1.n2.n3.bstrVal = SysAllocString( wString );
                   hb_xfree( wString );
                }
                break;

              case S_LOG:
                if( bByRef )
                {
                   pArgs[ n ].n1.n2.vt = VT_BYREF | VT_BOOL;
                   pArgs[ n ].n1.n2.n3.pboolVal = (short *) _itemGetL( n ); //&( uParam->item.asLogical.value ) ;
                   uParam->type = HB_IT_LONG;  // Esto no se como hacerlo necestio acceder a la estructura del item
                }
                else
                {
                   pArgs[ n ].n1.n2.vt   = VT_BOOL;
                   pArgs[ n ].n1.n2.n3.boolVal = _parl( nArg );
                }
                break;

              case HB_IT_INTEGER:       // No se si hay correspondecia de todas formas no hace nada
              case HB_IT_LONG:          // idem
              case S_LNUM:
                if( bByRef )
                {
                   pArgs[ n ].n1.n2.vt = VT_BYREF | VT_I4;
                   pArgs[ n ].n1.n2.n3.plVal = _itemGetNL( n ); //&( uParam->item.asLong.value ) ;
                   uParam->type = HB_IT_LONG;  // Esto no se como hacerlo
                }
                else
                {
                   pArgs[ n ].n1.n2.vt = VT_I4;
                   pArgs[ n ].n1.n2.n3.lVal = _parnl( nArg );
                }
                break;

              case S_DNUM:
                if( bByRef )
                {
                   pArgs[ n ].n1.n2.vt = VT_BYREF | VT_R8;
                   pArgs[ n ].n1.n2.n3.pdblVal = _itemGetND( n );//&( uParam->item.asDouble.value ) ;
                   uParam->type = HB_IT_DOUBLE;  // Ni idea
                }
                else
                {
                   pArgs[ n ].n1.n2.vt   = VT_R8;
                   pArgs[ n ].n1.n2.n3.dblVal = _parnd( nArg );
                }
                break;

              case S_LDATE:
                if( bByRef )
                {
                   pArgs[ n ].n1.n2.vt = VT_BYREF | VT_DATE;
                   uParam->item.asDouble.value = DateToDbl( _pards( nArg ) );
                   pArgs[ n ].n1.n2.n3.pdblVal = _itemGetND( n ); //&( uParam->item.asDouble.value ) ;
                   uParam->type = HB_IT_DOUBLE;  // No se
                }
                else
                {
                   pArgs[ n ].n1.n2.vt   = VT_DATE;
                   pArgs[ n ].n1.n2.n3.dblVal = DateToDbl( _pards( nArg ) );
                }
                break;

              case S_OBJECT:
              {
                 pArgs[ n ].n1.n2.vt = VT_EMPTY;

                 if( strcmp( hb_objGetClsName( uParam ), "TOLEAUTO" ) == 0 )
                 {
                    if( s_pSym_hObj == NULL )
                    {
                      s_pSym_hObj = _get_sym( "HOBJ" );//hb_dynsymFindName( "HOBJ" );
                    }

                    if( s_pSym_hObj )
                    {
                       hb_vmPushSymbol( s_pSym_hObj->pSymbol );  // Esto creo q coloca el simbolo en la pila
                       hb_vmPush( uParam );
                       hb_vmSend( 0 );  // lo ejecuta con parametros cero
                       //TraceLog( NULL, "\n#%i Dispatch: %ld\n", n, hb_parnl( -1 ) );
                       pArgs[ n ].n1.n2.vt = VT_DISPATCH;
                       pArgs[ n ].n1.n2.n3.pdispVal = ( IDispatch * ) _parnl( -1 );
                       //printf( "\nDispatch: %p\n", pArgs[ n ].n1.n2.n3.pdispVal );
                    }
                 }
                 else
                 {
                    TraceLog( NULL, "Class: '%s' not suported!\n", hb_objGetClsName( uParam ) );
                 }
              }
              break;
           }
        }
     }

     dParams->rgvarg            = pArgs;
     dParams->cArgs             = nArgs;
     dParams->rgdispidNamedArgs = 0;
     dParams->cNamedArgs        = 0;
  }

//---------------------------------------------------------------------------//

static void FreeParams(DISPPARAMS * dParams)
  {
     int n, nParam;
     char *sString;

     if( dParams->cArgs > 0 )
     {
        for( n = 0; n < ( int ) dParams->cArgs; n++ )
        {
           nParam = dParams->cArgs - n;

           //TraceLog( NULL, "*** N: %i, Param: %i Type: %i\n", n, nParam, dParams->rgvarg[ n ].n1.n2.vt );

           if( s_OleRefFlags && s_OleRefFlags[ nParam - 1 ] == 'Y' )
           {
              switch( dParams->rgvarg[ n ].n1.n2.vt )
              {
                 case VT_BYREF | VT_BSTR:
                   //printf( "String\n" );
                   sString = WideToAnsi( *( dParams->rgvarg[ n ].n1.n2.n3.pbstrVal ) );
                   SysFreeString( *( dParams->rgvarg[ n ].n1.n2.n3.pbstrVal ) );

                   // The item should NOT be cleared because we released the value above.
                   aPrgParams[ n ]->type = HB_IT_NIL;  // Pone a nil el item

                   // The Arg should NOT be cleared because we released the value above.
                   dParams->rgvarg[ n ].n1.n2.vt = VT_EMPTY;

                   _itemPutC( aPrgParams[ n ], sString, strlen( sString ) );//hb_itemPutCPtr( aPrgParams[ n ], sString, strlen( sString ) );
                   break;

                 // Already using the PHB_ITEM allocated value
                 /*
                 case VT_BYREF | VT_BOOL:
                   //printf( "Logical\n" );
                   ( aPrgParams[ n ] )->type = HB_IT_LOGICAL;
                   ( aPrgParams[ n ] )->item.asLogical.value = dParams->rgvarg[ n ].n1.n2.n3.boolVal ;
                   break;
                 */

                 case VT_DISPATCH:
                 case VT_BYREF | VT_DISPATCH:
                   //TraceLog( NULL, "Dispatch %p\n", dParams->rgvarg[ n ].n1.n2.n3.pdispVal );
                   if( dParams->rgvarg[ n ].n1.n2.n3.pdispVal == NULL )
                   {
                      _itemFreeC( aPrgParams[ n ] );//hb_itemClear( aPrgParams[ n ] );
                      break;
                   }

                   OleAuto.type = S_NIL; //HB_IT_NIL;

                   if( s_pSym_OleAuto )
                   {
                      _putsym( s_pSym_OleAuto->pSymbol ); //hb_vmPushSymbol( s_pSym_OleAuto->pSymbol );
                      _put(); //hb_vmPushNil();
                      _xdo( 0 );//hb_vmDo( 0 );

                      hb_itemForwardValue( &OleAuto, &hb_stack.Return );  // Esto no se q hace
                   }

                   if( s_pSym_New && OleAuto.type )
                   {
                      //TOleAuto():New( nDispatch )
                      _putsym( s_pSym_New->pSymbol );//hb_vmPushSymbol( s_pSym_New->pSymbol );
                      hb_itemPushForward( &OleAuto );// creo q coloca el simbolo pero no estoy seguro
                      _putln( ( LONG ) dParams->rgvarg[ n ].n1.n2.n3.pdispVal );//hb_vmPushLong( ( LONG ) dParams->rgvarg[ n ].n1.n2.n3.pdispVal );
                      _xsend( 1 ); //hb_vmSend( 1 );

                      hb_itemForwardValue( aPrgParams[ n ], &hb_stack.Return );  // Sin traducir
                   }
                   // Can't CLEAR this Variant
                   continue;

                 /*
                 case VT_BYREF | VT_I2:
                   //printf( "Int %i\n", dParams->rgvarg[ n ].n1.n2.n3.iVal );
                   hb_itemPutNI( aPrgParams[ n ], ( int ) dParams->rgvarg[ n ].n1.n2.n3.iVal );
                   break;

                 case VT_BYREF | VT_I4:
                   //printf( "Long %ld\n", dParams->rgvarg[ n ].n1.n2.n3.iVal );
                   hb_itemPutNL( aPrgParams[ n ], ( LONG ) dParams->rgvarg[ n ].n1.n2.n3.iVal );
                   break;

                 case VT_BYREF | VT_R8:
                   //printf( "Double\n" );
                   hb_itemPutND( aPrgParams[ n ],  dParams->rgvarg[ n ].n1.n2.n3.dblVal );
                   break;
                 */

                 case VT_BYREF | VT_DATE:
                   //printf( "Date\n" );
                   _itemPutDS( aPrgParams[ n ], DblToDate( *( dParams->rgvarg[ n ].n1.n2.n3.pdblVal ) ) );
                   break;

                 /*
                 case VT_BYREF | VT_EMPTY:
                   //printf( "Nil\n" );
                   hb_itemClear( aPrgParams[ n ] );
                   break;
                 */

                 default:
                   TraceLog( NULL, "*** Unexpected Type: %i [%p]***\n", dParams->rgvarg[ n ].n1.n2.vt, dParams->rgvarg[ n ].n1.n2.vt );
              }
           }
           else
           {
              switch( dParams->rgvarg[ n ].n1.n2.vt )
              {
                 case VT_DISPATCH:
                   //TraceLog( NULL, "***NOT REF*** Dispatch %p\n", dParams->rgvarg[ n ].n1.n2.n3.pdispVal );
                   // Can'r CLEAR this Variant.
                   continue;
              }
           }

           VariantClear( &(dParams->rgvarg[ n ] ) );
        }

        _xfree( ( LPVOID ) dParams->rgvarg );

        if( aPrgParams )
        {
           _xfree( ( LPVOID ) aPrgParams );
           aPrgParams = NULL;
        }
     }
  }

//---------------------------------------------------------------------------//

static void RetValue( void )
  {
     LPSTR cString;

     /*
     printf( "Type: %i\n", RetVal.n1.n2.vt );
     fflush( stdout );
     getchar();
     */

     switch( RetVal.n1.n2.vt )
     {
        case VT_BSTR:
          //printf( "String\n" );
          cString = WideToAnsi( RetVal.n1.n2.n3.bstrVal );
          //printf( "cString %s\n", cString );
          hb_retcAdopt( cString );      // Ni idea
          //printf( "Adopted\n" );
          break;

        case VT_BOOL:
          _retl( RetVal.n1.n2.n3.boolVal );
          break;

        case VT_DISPATCH:
          if( RetVal.n1.n2.n3.pdispVal == NULL )
          {
             _ret();
             break;
          }

          OleAuto.type = S_NIL;

          if( s_pSym_OleAuto )
          {
             _ptusym( s_pSym_OleAuto->pSymbol );// hb_vmPushSymbol( s_pSym_OleAuto->pSymbol );
             _put();//hb_vmPushNil();
             _xdo(0);//hb_vmDo( 0 );

             hb_itemForwardValue( &OleAuto, &hb_stack.Return );  // Ni idea
          }

          if( s_pSym_New && OleAuto.type )
          {
             //TOleAuto():New( nDispatch )
             _ptusym( s_pSym_New->pSymbol );// hb_vmPushSymbol( s_pSym_New->pSymbol );
             hb_itemPushForward( &OleAuto );
             _putln( ( LONG ) RetVal.n1.n2.n3.pdispVal );//hb_vmPushLong( ( LONG ) RetVal.n1.n2.n3.pdispVal );
             _xsend( 1 );//hb_vmSend( 1 );
             //printf( "Dispatch: %ld %ld\n", ( LONG ) RetVal.n1.n2.n3.pdispVal, (LONG) hb_stack.Return.item.asArray.value );
          }
          break;

        case VT_I1:     // Byte
        case VT_UI1:
          _retni( ( short ) RetVal.n1.n2.n3.bVal );
          break;

        case VT_I2:     // Short (2 bytes)
        case VT_UI2:
          _retni( ( short ) RetVal.n1.n2.n3.iVal );
          break;

        case VT_I4:     // Long (4 bytes)
        case VT_UI4:
        case VT_INT:
        case VT_UINT:
          _retnl( ( LONG ) RetVal.n1.n2.n3.lVal );
          break;

        case VT_R4:     // Single
          _retnd( RetVal.n1.n2.n3.fltVal );
          break;

        case VT_R8:     // Double
          hb_retnd( RetVal.n1.n2.n3.dblVal );
          break;

        case VT_CY:     // Currency
        {
          double tmp = 0;
          VarR8FromCy( RetVal.n1.n2.n3.cyVal, &tmp );
          _retnd( tmp );
        }
          break;

        case VT_DECIMAL: // Decimal
          {
          double tmp = 0;
          VarR8FromDec( &RetVal.n1.decVal, &tmp );
          _retnd( tmp );
          }
          break;

        case VT_DATE:
          _retds( DblToDate( RetVal.n1.n2.n3.dblVal ) );
          break;

        case VT_EMPTY:
        case VT_NULL:
          _ret();
          break;

        default:
          //printf( "Default %i!\n", RetVal.n1.n2.vt );
          if( s_nOleError == S_OK )
          {
             s_nOleError = E_UNEXPECTED;
          }

          _ret();
          break;
     }

     if( RetVal.n1.n2.vt == VT_DISPATCH && RetVal.n1.n2.n3.pdispVal )
     {
        //printf( "Dispatch: %ld\n", ( LONG ) RetVal.n1.n2.n3.pdispVal );
     }
     else
     {
        VariantClear( &RetVal );
     }
  }

//---------------------------------------------------------------------------//

CLIPPER CREATEOLEOBJECT( void ) // ( cOleName | cCLSID  [, cIID ] )
  {
     BSTR wCLSID;
     IID ClassID, iid;
     LPIID riid = (LPIID) &IID_IDispatch;
     IDispatch * pDisp = NULL;

     wCLSID = AnsiToWide( _parc( 1 ) );

     if ( _parc( 1 )[ 0 ] == '{' )
     {
        s_nOleError = CLSIDFromString( wCLSID, (LPCLSID) &ClassID );
     }
     else
     {
        s_nOleError = CLSIDFromProgID( wCLSID, (LPCLSID) &ClassID );
     }

     _xfree( wCLSID );

     //TraceLog( NULL, "Result: %i\n", s_nOleError );

     if ( _pcount() == 2 )
     {
        if ( _parc( 2 )[ 0 ] == '{' )
        {
           wCLSID = AnsiToWide( hb_parc( 2 ) );
           s_nOleError = CLSIDFromString( wCLSID, &iid );
           _xfree( wCLSID );
        }
        else
        {
           memcpy( ( LPVOID ) &iid, _parc( 2 ), sizeof( iid ) );
        }

        riid = &iid;
     }

     if ( s_nOleError == S_OK )
     {
        //TraceLog( NULL, "Class: %i\n", ClassID );
        s_nOleError = CoCreateInstance( (REFCLSID) &ClassID, NULL, CLSCTX_SERVER, riid, (void **) &pDisp );
        //TraceLog( NULL, "Result: %i\n", s_nOleError );
     }

     _retnl( ( LONG ) pDisp );
  }

//---------------------------------------------------------------------------//

CLIPPER GETOLEOBJECT( void ) // ( cOleName | cCLSID  [, cIID ] )
  {
     BSTR wCLSID;
     IID ClassID, iid;
     LPIID riid = (LPIID) &IID_IDispatch;
     IDispatch *pDisp = NULL;
     IUnknown *pUnk = NULL;
     //LPOLESTR pOleStr = NULL;

     s_nOleError = S_OK;

     if ( ( s_nOleError == S_OK ) || ( s_nOleError == (HRESULT) S_FALSE) )
     {
        wCLSID = AnsiToWide( _parc( 1 ) );

        if ( _parc( 1 )[ 0 ] == '{' )
        {
           s_nOleError = CLSIDFromString( wCLSID, (LPCLSID) &ClassID );
        }
        else
        {
           s_nOleError = CLSIDFromProgID( wCLSID, (LPCLSID) &ClassID );
        }

        //s_nOleError = ProgIDFromCLSID( &ClassID, &pOleStr );
        //wprintf( L"Result %i ProgID: '%s'\n", s_nOleError, pOleStr );

        _xfree( wCLSID );

        if ( _pcount() == 2 )
        {
           if ( _parc( 2 )[ 0 ] == '{' )
           {
              wCLSID = AnsiToWide( hb_parc( 2 ) );
              s_nOleError = CLSIDFromString( wCLSID, &iid );
              _xfree( wCLSID );
           }
           else
           {
              memcpy( ( LPVOID ) &iid, hb_parc( 2 ), sizeof( iid ) );
           }

           riid = &iid;
        }

        if ( s_nOleError == S_OK )
        {
           s_nOleError = GetActiveObject( &ClassID, NULL, &pUnk );

           if ( s_nOleError == S_OK )
           {
              s_nOleError = pUnk->lpVtbl->QueryInterface( pUnk, riid, (void **) &pDisp );
           }
        }
     }

     _retnl( ( LONG ) pDisp );
  }

//---------------------------------------------------------------------------//

CLIPPER OLESHOWEXCEPTION( void )
  {
     if( (LONG) s_nOleError == DISP_E_EXCEPTION )
     {
        LPSTR source, description;

        source = WideToAnsi( excep.bstrSource );
        description = WideToAnsi( excep.bstrDescription );
        MessageBox( NULL, description, source, MB_ICONHAND );
        _xfree( source );
        _xfree( description );
     }
  }

//---------------------------------------------------------------------------//

CLIPPER OLEEXCEPTIONSOURCE( void )
  {
     if( (LONG) s_nOleError == DISP_E_EXCEPTION )
     {
        LPSTR source;

        source = WideToAnsi( excep.bstrSource );
        hb_retcAdopt( source );         // ni idea
     }
  }

//---------------------------------------------------------------------------//

CLIPPER OLEEXCEPTIONDESCRIPTION( void )
  {
     if( (LONG) s_nOleError == DISP_E_EXCEPTION )
     {
        LPSTR description;

        description = WideToAnsi( excep.bstrDescription );
        hb_retcAdopt( description );
     }
  }

//---------------------------------------------------------------------------//

CLIPPER OLEINVOKE( void ) // (hOleObject, szMethodName, uParams...)
  {
     IDispatch * pDisp = ( IDispatch * ) hb_parnl( 1 );
     BSTR wMember;
     DISPID lDispID;
     DISPPARAMS dParams;
     UINT uArgErr;

     VariantInit( &RetVal );
     memset( (LPBYTE) &excep, 0, sizeof( excep ) );

     //printf( "1\n" );

     wMember = AnsiToWide( hb_parc( 2 ) );
     s_nOleError = pDisp->lpVtbl->GetIDsOfNames( pDisp, &IID_NULL, (wchar_t **) &wMember, 1, LOCALE_USER_DEFAULT, &lDispID );
     _xfree( wMember );

     //printf( "2\n" );

     if( s_nOleError == S_OK )
     {
        GetParams( &dParams );

        s_nOleError = pDisp->lpVtbl->Invoke( pDisp,
                                             lDispID,
                                             &IID_NULL,
                                             LOCALE_USER_DEFAULT,
                                             DISPATCH_METHOD,
                                             &dParams,
                                             &RetVal,
                                             &excep,
                                             &uArgErr ) ;

        //TraceLog( NULL, "Invoke '%s' Result: %p\n", hb_parc(2), s_nOleError );

        FreeParams( &dParams );

        RetValue();
     }
     else
     {
        //TraceLog( NULL, "Invoke GetIDsOfNames '%s' Error: %p\n", hb_parc(2), s_nOleError );
     }
  }

//---------------------------------------------------------------------------//

CLIPPER OLESETPROPERTY( void ) // (hOleObject, cPropName, uParams...)
  {
     IDispatch * pDisp = ( IDispatch * ) hb_parnl( 1 );
     BSTR wMember;
     DISPID lDispID, lPropPut = DISPID_PROPERTYPUT;
     WORD wFlags;
     DISPPARAMS dParams;
     UINT uArgErr;

     memset( (LPBYTE) &excep, 0, sizeof( excep ) );

     wMember = AnsiToWide( hb_parc( 2 ) );
     s_nOleError = pDisp->lpVtbl->GetIDsOfNames( pDisp, &IID_NULL, (wchar_t **) &wMember, 1, LOCALE_USER_DEFAULT, &lDispID );
     _xfree( wMember );

     if( s_nOleError == S_OK )
     {
        GetParams( &dParams );
        dParams.rgdispidNamedArgs = &lPropPut;
        dParams.cNamedArgs = 1;

        if( dParams.rgvarg[0].n1.n2.vt == VT_DISPATCH )
        {
           wFlags = DISPATCH_PROPERTYPUTREF | DISPATCH_METHOD;
           //TraceLog( NULL, "SetProperty '%s' BYREF\n", hb_parc(2) );
        }
        else
        {
           wFlags = DISPATCH_PROPERTYPUT | DISPATCH_METHOD;
        }

        //TraceLog( NULL, "SetProperty '%s' Args: %i\n", hb_parc(2), dParams.cArgs );

        s_nOleError = pDisp->lpVtbl->Invoke( pDisp,
                                           lDispID,
                                           &IID_NULL,
                                           LOCALE_USER_DEFAULT,
                                           wFlags,
                                           &dParams,
                                           NULL,    // No return value
                                           &excep,
                                           &uArgErr );

        //TraceLog( NULL, "SetProperty '%s' Result: %p\n", hb_parc(2), s_nOleError );

        FreeParams( &dParams );

        _ret();
     }
     else
     {
        //TraceLog( NULL, "SetProperty GetIDsOfNames '%s' Error: %p\n", hb_parc(2), s_nOleError );
     }
  }

//---------------------------------------------------------------------------//

CLIPPER OLEGETPROPERTY( void )  // (hOleObject, cPropName, uParams...)
  {
     IDispatch * pDisp = ( IDispatch * ) hb_parnl( 1 );
     BSTR wMember;
     DISPID lDispID;
     DISPPARAMS dParams;
     UINT uArgErr;

     VariantInit( &RetVal );

     memset( (LPBYTE) &excep, 0, sizeof( excep ) );

     wMember = AnsiToWide( hb_parc( 2 ) );
     s_nOleError = pDisp->lpVtbl->GetIDsOfNames( pDisp, &IID_NULL, (wchar_t **) &wMember, 1, LOCALE_USER_DEFAULT, &lDispID );
     _xfree( wMember );

     if( s_nOleError == S_OK )
     {
        GetParams( &dParams );

        s_nOleError = pDisp->lpVtbl->Invoke( pDisp,
                                           lDispID,
                                           &IID_NULL,
                                           LOCALE_USER_DEFAULT,
                                           DISPATCH_PROPERTYGET,
                                           &dParams,
                                           &RetVal,
                                           &excep,
                                           &uArgErr );

        //TraceLog( NULL, "GetProperty '%s' Result: %p\n", hb_parc(2), s_nOleError );

        FreeParams( &dParams );

        RetValue();
     }
     else
     {
        //TraceLog( NULL, "GetProperty GetIDsOfNames '%s' Error: %p\n", hb_parc(2), s_nOleError );
     }
  }

//---------------------------------------------------------------------------//

CLIPPER OLEQUERYINTERFACE( void )  // (hOleObject, cIID ) -> ppvObject
  {
     IUnknown * pUnk = ( IUnknown * ) _parnl( 1 );
     IUnknown * ppvObject = NULL;
     GUID iid;
     BSTR wiid;

     s_nOleError = S_OK;

     if( _parc( 2 )[ 0 ] == '{' )
     {
        wiid = AnsiToWide( hb_parc( 2 ) );
        s_nOleError = CLSIDFromString( wiid, &iid );
        _xfree( wiid );
     }
     else
     {
        memcpy( ( LPVOID ) &iid, hb_parc( 2 ), sizeof( iid ) );
     }

     if( s_nOleError == S_OK )
     {
        s_nOleError = pUnk ->lpVtbl->QueryInterface( pUnk, (const struct _GUID *const) &iid, (void **) &ppvObject );
     }

     _retnl( ( LONG ) ppvObject );
  }

//---------------------------------------------------------------------------//

CLIPPER OLEADDREF( void )  // ( hOleObject )
  {
     IUnknown * pUnk = ( IUnknown * ) _parnl( 1 );

     hb_retnl( pUnk -> lpVtbl -> AddRef( pUnk ) );
  }

//---------------------------------------------------------------------------//

CLIPPER OLERELEASE( void )  // ( hOleObject )
  {
     IUnknown * pUnk = ( IUnknown * ) hb_parnl( 1 );

     hb_retnl( pUnk -> lpVtbl -> Release( pUnk ) );
  }

//---------------------------------------------------------------------------//

#if 0
CLIPPER COMFUNCTION( void )  // ( hOleObject, nFunc, uParams... )
  {
     typedef HRESULT ( STDMETHODCALLTYPE * COMFunc ) ( IUnknown * pUnk );

     IUnknown * pUnk = ( IUnknown * ) _parnl( 1 );
     COMFunc pFunc;
     COMFunc *vTbl;
     int i, iParams = _pcount();
     double doubles[16];
     LPVOID ptros[16];

     vTbl = ( COMFunc * ) &( pUnk -> lpVtbl -> QueryInterface );
     vTbl += hb_parni( 2 ) + 2;
     pFunc = *vTbl;

     for( i = iParams; i > 2; i-- )
     {
        char *sString;
        int iInt;
        double dDouble;

        switch ( ( _parinfo( i ) & ~HB_IT_BYREF) )  // Ni idea de q es esto
        {
           case S_CHAR:
           case S_MEMO:
             sString = _parc( i );
             __asm push sString
             break;

           case S_LOG:
             if ( ISBYREF( i ) )        // Ni idea
             {
                ptros[ i ] = (LPVOID) _parl( i );
                sString = ( char * ) &ptros[ i ];
                __asm push sString
             }
             else
             {
                iInt = _parl( i );
                __asm push iInt
             }
             break;

           case HB_IT_INTEGER:          // No se como se traduce
           case S_LNUM:
             if ( ISBYREF( i ) )
             {
                ptros[ i ] = (LPVOID) _parnl( i );
                sString = ( char * ) &ptros[ i ];
                __asm push sString
             }
             else
             {
                iInt = _parnl( i );
                __asm push iInt
             }
             break;

           case S_DNUM:
             if ( ISBYREF( i ) )
             {
                doubles[ i ] = _parnd( i );
                sString = ( char * ) &doubles[ i ];
                __asm push sString
             }
             else
             {
                dDouble = _parl( i );
                __asm push dDouble
             }
             break;

           case S_LDATE:
             if ( ISBYREF( i ) )
             {
                doubles[ i ] = DateToDbl( _pards( i ) );
                sString = ( char * ) &doubles[ i ];
                __asm push sString
             }
             else
             {
                dDouble = DateToDbl( _pards( i ) );
                __asm push dDouble
             }
             break;

           default:
             sString = ( char * ) NULL;
             __asm push sString
             break;
        }
     }

     s_nOleError = pFunc( pUnk );

     for ( i = 3; i <= iParams; i++ )
     {
        if ( ISBYREF( i ) )
        {
           switch ( (_parinfo( i ) & ~HB_IT_BYREF) )
           {
              case S_CHAR:
              case S_MEMO:
                _storc( (char *) _parc( i ), i );
                break;

              case S_LOG:
                _storl( (long) ptros[ i ], i );
                break;

              case HB_IT_INTEGER:       // SIN TRADUCIR
              case S_LNUM:
                _stornl( (long) ptros[ i ], i );
                break;

              case S_DNUM:
                _stornd( doubles[ i ], i );
                break;

              case S_LDATE:
                _stords( DblToDate( doubles[ i ] ), i );
                break;
           }
        }
     }

     _ret();
  }
  #endif

//---------------------------------------------------------------------------//

CLIPPER OLEERROR( void )
  {
     _retnl( (LONG) s_nOleError );
  }

//---------------------------------------------------------------------------//

CLIPPER OLE2TXTERROR( void )
  {
     switch( (LONG) s_nOleError )
     {
        case S_OK:
           _retc( "S_OK" );
           break;

        case CO_E_CLASSSTRING:
           _retc( "CO_E_CLASSSTRING" );
           break;

        case OLE_E_WRONGCOMPOBJ:
           _retc( "OLE_E_WRONGCOMPOBJ" );
           break;

        case REGDB_E_CLASSNOTREG:
           _retc( "REGDB_E_CLASSNOTREG" );
           break;

        case REGDB_E_WRITEREGDB:
           _retc( "REGDB_E_WRITEREGDB" );
           break;

        case E_OUTOFMEMORY:
           _retc( "E_OUTOFMEMORY" );
           break;

        case E_NOTIMPL:
           _retc( "E_NOTIMPL" );
           break;

        case E_INVALIDARG:
           _retc( "E_INVALIDARG" );
           break;

        case E_UNEXPECTED:
           _retc( "E_UNEXPECTED" );
           break;

        case DISP_E_UNKNOWNNAME:
           _retc( "DISP_E_UNKNOWNNAME" );
           break;

        case DISP_E_UNKNOWNLCID:
           _retc( "DISP_E_UNKNOWNLCID" );
           break;

        case DISP_E_BADPARAMCOUNT:
           _retc( "DISP_E_BADPARAMCOUNT" );
           break;

        case DISP_E_BADVARTYPE:
           _retc( "DISP_E_BADVARTYPE" );
           break;

        case DISP_E_EXCEPTION:
           _retc( "DISP_E_EXCEPTION" );
           break;

        case DISP_E_MEMBERNOTFOUND:
           _retc( "DISP_E_MEMBERNOTFOUND" );
           break;

        case DISP_E_NONAMEDARGS:
           _retc( "DISP_E_NONAMEDARGS" );
           break;

        case DISP_E_OVERFLOW:
           _retc( "DISP_E_OVERFLOW" );
           break;

        case DISP_E_PARAMNOTFOUND:
           _retc( "DISP_E_PARAMNOTFOUND" );
           break;

        case DISP_E_TYPEMISMATCH:
           _retc( "DISP_E_TYPEMISMATCH" );
           break;

        case DISP_E_UNKNOWNINTERFACE:
           _retc( "DISP_E_UNKNOWNINTERFACE" );
           break;

        case DISP_E_PARAMNOTOPTIONAL:
           _retc( "DISP_E_PARAMNOTOPTIONAL" );
           break;

          case MK_E_UNAVAILABLE:
           _retc( "MK_E_UNAVAILABLE" );
           break;

        default:
           TraceLog( NULL, "TOleAuto Error %p\n", s_nOleError );
           _retc( "Unknown error" );
           break;
     };
  }

//---------------------------------------------------------------------------//

CLIPPER ANSITOWIDE( void )  // ( cAnsiStr ) -> cWideStr
  {
     UINT uLen;
     BSTR wString;
     char *cString = _parc( 1 );

     if( cString == NULL )
     {
        _ret();
        return;
     }

     uLen = strlen( cString ) + 1;

     wString = ( BSTR ) _xgrab( uLen * 2 );
     MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, cString, uLen, wString, uLen );

     hb_retclenAdopt( (char *) wString, uLen * 2 - 1 );
  }

//---------------------------------------------------------------------------//

CLIPPER WIDETOANSI( void )  // ( cWideStr, nLen ) -> cAnsiStr
  {
     UINT uLen;
     BSTR wString = ( BSTR ) _parc( 1 );
     char *cString;

     uLen = SysStringLen( wString ) + 1;

     cString = ( char * ) _xgrab( uLen );

     WideCharToMultiByte( CP_ACP, WC_COMPOSITECHECK, wString, uLen, cString, uLen, NULL, NULL );

     hb_retclenAdopt( cString, uLen - 1 );
  }

//---------------------------------------------------------------------------//

CLIPPER MESSAGEBOX( void )
  {
     hb_retni( MessageBox( ( HWND ) hb_parnl( 1 ), hb_parc( 2 ), hb_parc( 3 ), hb_parni( 4 ) ) );
  }

//---------------------------------------------------------------------------//