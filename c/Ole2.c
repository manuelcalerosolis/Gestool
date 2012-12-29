/************************************************************************\
*                                                                        *
*  Descripción: Funciones de acceso a OLE desde FW                       *
*                                                                        *
*  Autor: José F. Giménez (JFG) - jfgimenez@wanadoo.es                   *
*                                 tecnico.sireinsa@ctv.es                *
*  Fecha: 6-11-2000                                                      *
*                                                                        *
*  Nota: basado en las funciones de acceso a OLE de FW 2.1               *
*                                                                        *
*        Compilar via assembler para evitar unresolved external:         *
*        FIWRQQ, FIDRQQ, etc. en Clipper 5.2                             *
*                                                                        *
**************************************************************************
*                                                                        *
*  CreateOleObject( cOleName | cCLSID ) -> hOleObject                    *
*                                                                        *
*                                                                        *
*  OleInvoke( hOleObject, cMethodName, uParam1, ..., uParamN )           *
*          -> uResult                                                    *
*                                                                        *
*                                                                        *
*  OleSetProperty( hOleObject, cPropertyName, uParam1, ..., uParamN )    *
*          -> lOk                                                        *
*                                                                        *
*                                                                        *
*  OleGetProperty( hOleObject, cPropertyName, uParam1, ..., uParamN )    *
*          -> uResult                                                    *
*                                                                        *
*                                                                        *
*  OleIsObject() -> lIsObject                                            *
*                                                                        *
*                                                                        *
*  OleError() -> nError                                                  *
*                                                                        *
\************************************************************************/


#define _BC5

#include <WinTen.h>
#include <Windows.h>
#include <Ole2.h>
#include <dispatch.h>
#include <CoGuid.h>
#include <OleNls.h>
#include <ClipApi.h>


typedef LONG DISPIP;

static far VARIANTARG RetVal;

static HRESULT nOleError = 0;

static int nInitialized = 0;

//---------------------------------------------------------------------------//

extern long _dAlphaToDateDBF( LPSTR cDate );
extern void _dDateToAlphaDBF( LPSTR cDate, long nDate );
extern long _dvtol( double );
extern void _retds( LPSTR cDate );

//---------------------------------------------------------------------------//

static double DateToDbl( LPSTR cDate )
{
   double nDate;

   nDate = _dAlphaToDateDBF( cDate ) - 0x0024d9abL;   // 31-12-1899

   return ( nDate );
}

//---------------------------------------------------------------------------//

static LPSTR DblToDate( double nDate )
{
   static char *cDate = "00000000";
   long nlDate = _dvtol( nDate );

   _dDateToAlphaDBF( cDate, nlDate + 0x0024d9abL );

   return ( cDate );
}

//---------------------------------------------------------------------------//

static void GetParams(DISPPARAMS * dParams)
{
   VARIANTARG * pArgs = NULL;
   PCLIPVAR uParam;
   int n, nArgs, nArg;
   double date;

   nArgs = PCOUNT() - 2;
   if( nArgs > 0 )
   {
      pArgs = ( VARIANTARG * ) _xgrab( sizeof( VARIANTARG ) * nArgs );

      for( n = 0; n < nArgs; n++ )
      {
         // Los parametros en VARIANTARG[] hay que ponerlos en orden inverso
         nArg = nArgs + 2 - n;

         VariantInit( &( pArgs[ n ] ) );

         uParam = _param( n + 3, 0xFFFF );

         switch( uParam->wType )
         {
            case CHARACTER:
            case MEMO:
                 pArgs[ n ].vt   = VT_BSTR;
                 pArgs[ n ].u.bstrVal = SysAllocString( _parc( nArg ) );
                 break;

            case LOGICAL:
                 pArgs[ n ].vt   = VT_BOOL;
                 pArgs[ n ].u.bool = _parl( nArg );
                 break;

            case NUMERIC:
                 pArgs[ n ].vt   = VT_I4;
                 pArgs[ n ].u.lVal = _parnl( nArg );
                 break;

            case NUM_FLOAT:
                 pArgs[ n ].vt   = VT_R8;
                 uParam = _param( nArg, 0xFFFF);
                 _bcopy( ( LPVOID ) &pArgs[ n ].u.dblVal, ( LPVOID ) &uParam->pPointer1, 8 );
                 break;

            case DATE:
                 pArgs[ n ].vt   = VT_DATE;
                 pArgs[ n ].u.dblVal = DateToDbl( _pards (nArg ) );
                 break;
         }
      }
   }

   dParams->rgvarg = pArgs;
   dParams->cArgs  = nArgs;
   dParams->rgdispidNamedArgs = 0;
   dParams->cNamedArgs = 0;

}

//---------------------------------------------------------------------------//

static void FreeParams(DISPPARAMS * dParams)
{
   int n;

   if( dParams->cArgs > 0 )
   {
      for( n = 0; n < ( int ) dParams->cArgs; n++ )
         VariantClear( &(dParams->rgvarg[ n ]) );

      _xfree( ( LPVOID ) dParams->rgvarg );
   }
}

//---------------------------------------------------------------------------//

static void RetValue( void )
{
   switch( RetVal.vt )
   {
      case VT_BSTR:
           _retc( RetVal.u.bstrVal );
           break;

      case VT_BOOL:
           _retl( RetVal.u.bool );
           break;

      case VT_DISPATCH:
           _retnl( ( LONG ) RetVal.u.pdispVal );
           break;

      case VT_I4:
           _retnl( ( LONG ) RetVal.u.iVal );
           break;

      case VT_R8:
           _bcopy( ( LPVOID ) &_eval->pPointer1, ( LPVOID ) &RetVal.u.dblVal, 8 );
           _eval->wType = 8;
           break;

      case VT_DATE:
           _retds( DblToDate( RetVal.u.dblVal ) );
           break;

      case VT_EMPTY:
           _ret();
           break;

      default:
           if ( nOleError == S_OK )
              (LONG) nOleError = -1;
           _ret();
           break;
   }

   if( RetVal.vt != VT_DISPATCH )
      VariantClear( &RetVal );

}

//---------------------------------------------------------------------------//

CLIPPER CreateOleO( PARAMS ) // BJECT( [ cOleName | cCLSID ] )
{
   GUID ClassID;
   IDispatch * pDisp = NULL;

   nOleError = S_OK;

   if ( nInitialized == 0 )
      nOleError = OleInitialize( NULL );

   if ( (nOleError == S_OK) || (nOleError == (HRESULT) S_FALSE) )
      {
      nInitialized++;

      if ( _parc(1)[0]=='{' )
         nOleError = CLSIDFromString( ( LPOLESTR ) _parc(1), &ClassID );
      else
         nOleError = CLSIDFromProgID( ( LPCOLESTR ) _parc(1), &ClassID );

      if ( nOleError == S_OK )
         nOleError = CoCreateInstance( &ClassID, NULL, CLSCTX_SERVER,
                                       &IID_IDispatch, (LPVOID) &pDisp );
      }

   _retnl( ( LONG ) pDisp );

}

//---------------------------------------------------------------------------//

CLIPPER OLEINVOKE( PARAMS ) // (hOleObject, szMethodName, uParams...)
{
   IDispatch * pDisp = ( IDispatch * ) _parnl( 1 );
   LPSTR szMethodName = _parc( 2 );
   DISPIP lDispID;
   DISPPARAMS dParams;
   EXCEPINFO excep;
   UINT uArgErr;

   VariantInit( &RetVal );

   nOleError = pDisp->lpVtbl->GetIDsOfNames( pDisp, &IID_NULL, &szMethodName, 1,
                                             LOCALE_USER_DEFAULT, &lDispID );

   if ( nOleError == S_OK )
      {
      GetParams( &dParams );
      nOleError = pDisp->lpVtbl->Invoke( pDisp,
                                         lDispID,
                                  &IID_NULL,
                                       LOCALE_USER_DEFAULT,
                                  DISPATCH_METHOD,
                                  &dParams,
                                  &RetVal,
                                  &excep,
                                  &uArgErr ) ;
      FreeParams( &dParams );
      }

   RetValue();
}

//---------------------------------------------------------------------------//

CLIPPER OLESETPROP( PARAMS ) // ERTY(hOleObject, cPropName, uValue, uParams...)
{
   IDispatch * pDisp = ( IDispatch * ) _parnl( 1 );
   LPSTR szPropName = _parc( 2 );
   DISPID lDispID, lPropPut = DISPID_PROPERTYPUT;
   DISPPARAMS dParams;
   EXCEPINFO excep;
   UINT uArgErr;

   VariantInit( &RetVal );

   nOleError = pDisp->lpVtbl->GetIDsOfNames( pDisp, &IID_NULL, &szPropName, 1,
                                             LOCALE_USER_DEFAULT, &lDispID );

   if ( nOleError == S_OK )
      {
      GetParams( &dParams );
      dParams.rgdispidNamedArgs = &lPropPut;
      dParams.cNamedArgs = 1;

      nOleError = pDisp->lpVtbl->Invoke( pDisp,
                                    lDispID,
                                         &IID_NULL,
                                         LOCALE_USER_DEFAULT,
                                         DISPATCH_PROPERTYPUT,
                                         &dParams,
                                         NULL,    // No return value
                                         &excep,
                                         &uArgErr );

      FreeParams( &dParams );
      }

   _ret();
}

//---------------------------------------------------------------------------//

CLIPPER OLEGETPROP( PARAMS )  // ERTY(hOleObject, cPropName, uParams...)
{
   IDispatch * pDisp = ( IDispatch * ) _parnl( 1 );
   LPSTR szPropName = _parc( 2 );
   DISPID lDispID;
   DISPPARAMS dParams;
   EXCEPINFO excep;
   UINT uArgErr;

   VariantInit( &RetVal );

   nOleError = pDisp->lpVtbl->GetIDsOfNames( pDisp, &IID_NULL, &szPropName, 1,
                                             LOCALE_USER_DEFAULT, &lDispID );

   if ( nOleError == S_OK )
      {
      GetParams( &dParams );

      nOleError = pDisp->lpVtbl->Invoke( pDisp,
                                         lDispID,
                                         &IID_NULL,
                                         LOCALE_USER_DEFAULT,
                                         DISPATCH_PROPERTYGET,
                                         &dParams,
                                         &RetVal,
                                         &excep,
                                         &uArgErr );

      FreeParams( &dParams );
      }

   RetValue();

}

//---------------------------------------------------------------------------//

CLIPPER OLEERROR()
{
   _retnl( (LONG) nOleError );
}

//---------------------------------------------------------------------------//

CLIPPER OLEISOBJEC()  // T()
{
   _retl( RetVal.vt == VT_DISPATCH );
}

//---------------------------------------------------------------------------//

CLIPPER OLEUNINITI()  // ALIZE()
{
   if ( nInitialized > 0 )
      {
      nInitialized--;
      if ( nInitialized == 0 )
         OleUninitialize();
      }
}

//---------------------------------------------------------------------------//

