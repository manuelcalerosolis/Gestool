#include "FiveWin.Ch"

//--------------------------------------------------------------------------

#define SHFD_FORMAT_QUICK     0
#define SHFD_FORMAT_FULL      1
#define SHFD_FORMAT_SYSONLY   2  // No valido para NT

#define SHFMT_ERROR           0xFFFFFFFF
#define SHFMT_CANCEL          0xFFFFFFFE
#define SHFMT_NOFORMAT        0xFFFFFFFD

#define SHFMT_ID_DEFAULT      0xFFFF
#define SHFMT_ID_720          0x0005
#define SHFMT_ID_1440         0x0006

//--------------------------------------------------------------------------

CLASS TDlgFormat

   PROPERTY nFlags         INIT SHFD_FORMAT_QUICK

   PROPERTY oWnd
   PROPERTY cDrive         INIT "A"
   PROPERTY nError         INIT 0

   PROPERTY lQuickFormat   INLINE   nOr( ::nFlags, SHFD_FORMAT_QUICK )
   PROPERTY lFullFormat    INLINE   nOr( ::nFlags, SHFD_FORMAT_FULL )
   PROPERTY lSysOnly       INLINE   nOr( ::nFlags, SHFD_FORMAT_SYSONLY )

   METHOD New( oWnd )
   METHOD Activate()       EXTERN TDlgFormat_Activate()

ENDCLASS

//--------------------------------------------------------------------------

METHOD Nwe( oWnd ) CLASS TFormatDriveDlg

   DEFAULT oWnd   := GetWndDefault()

   ::oWnd         := oWnd

RETURN Self

//--------------------------------------------------------------------------