#include "windows.h"
#include "hbapi.h"

#include "Image2PDF-BCC.h"

#ifdef __XHARBOUR__
   #define hb_parvc        hb_parc
   #define hb_parvni       hb_parni
   #define hb_storvc       hb_storc
   #define hb_storvni      hb_storni 
#endif

/*
#define PRINTER_STATUS_OK                       0
#define PRINTER_STATUS_PAUSED                   1
#define PRINTER_STATUS_ERROR                    2
#define PRINTER_STATUS_PENDING_DELETION         4
#define PRINTER_STATUS_PAPER_JAM                8
#define PRINTER_STATUS_PAPER_OUT               16
#define PRINTER_STATUS_MANUAL_FEED             32
#define PRINTER_STATUS_PAPER_PROBLEM           64
#define PRINTER_STATUS_OFFLINE                128
#define PRINTER_STATUS_IO_ACTIVE              256
#define PRINTER_STATUS_BUSY                   512
#define PRINTER_STATUS_PRINTING              1024
#define PRINTER_STATUS_OUTPUT_BIN_FULL       2048
#define PRINTER_STATUS_NOT_AVAILABLE         4096
#define PRINTER_STATUS_WAITING               8192
#define PRINTER_STATUS_PROCESSING           16384
#define PRINTER_STATUS_INITIALIZING         32768
#define PRINTER_STATUS_WARMING_UP           65536
#define PRINTER_STATUS_TONER_LOW           131072
#define PRINTER_STATUS_NO_TONER            262144
#define PRINTER_STATUS_PAGE_PUNT           524288
#define PRINTER_STATUS_USER_INTERVENTION  1048576
#define PRINTER_STATUS_OUT_OF_MEMORY      2097152
#define PRINTER_STATUS_DOOR_OPEN          4194304
#define PRINTER_STATUS_SERVER_UNKNOWN     8388608
#define PRINTER_STATUS_POWER_SAVE        16777216
*/

//---------------------------------------------------------------------------//

UINT ShowError(char *which, UINT iErr)
{
	char message[200];

	wsprintf(message, "%s returned error %d", which, iErr);

	MessageBox(NULL, message, "Error Returned From Image2PDF DLL", MB_OK | MB_ICONERROR);

	return iErr;
}

//---------------------------------------------------------------------------//

HB_FUNC(I2PDF_ADDIMAGE_XH)
{

    UINT iErr;

    LPSTR lpImage   = hb_parvc( 1 );

    iErr            = I2PDF_AddImage( lpImage );

    hb_retnl( iErr );

}

//---------------------------------------------------------------------------//

HB_FUNC(I2PDF_SETDPI_XH)
{

    UINT iErr;

    LONG lDpi       = hb_parnl( 1 );

    iErr            = I2PDF_SetDPI( lDpi );

    hb_retnl( iErr );

}

//---------------------------------------------------------------------------//

HB_FUNC(I2PDF_MAKEPDF_XH)
{

    UINT iErr;

    char errorText[1024];

    LPSTR lpOutput  = hb_parc( 1 );

    iErr            = I2PDF_MakePDF( lpOutput, OPTION_OPEN_PDF, errorText, sizeof( errorText ) );

    if (iErr)
    {
		if (iErr == 3)
			ShowError(errorText, iErr);
		else
			ShowError("I2PDF_MakePDF", iErr);
    }

    hb_retnl( iErr );

}

//---------------------------------------------------------------------------//

HB_FUNC(I2PDF_LICENSE_XH)
{

    I2PDF_License( "IPD-TBFZ-1OTB4-5B0T8K-28VD0WC" );

}

//---------------------------------------------------------------------------//

HB_FUNC(PRNSTATUS) // cPrinter or cPrinterServer --> nStatus
{
    HANDLE hPrinter = NULL;
    DWORD cBytesNeeded = 0, cBytesUsed = 0;
    PRINTER_INFO_2 * pPrinterInfo = NULL;

    if( OpenPrinter( hb_parvc( 1 ), &hPrinter, NULL ) )
    {
        GetPrinter( hPrinter, 2, NULL, 0, &cBytesNeeded );
        pPrinterInfo = ( PRINTER_INFO_2 * ) hb_xgrab( cBytesNeeded );
        GetPrinter( hPrinter, 2, ( unsigned char * ) pPrinterInfo, cBytesNeeded, &cBytesUsed );
        hb_retnl( pPrinterInfo->Status );
        hb_xfree( pPrinterInfo );
        ClosePrinter( hPrinter );
    }
    else
        hb_retnl( PRINTER_STATUS_NOT_AVAILABLE );
}

//---------------------------------------------------------------------------//

