* ÚÄ Function ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
* ³         Name: gpInitADSDD()                                              ³
* ³  Description: Init Advantage Database Data Dictionary                    ³
* ³       Author: Doug Chaffee & Luis Krause                                 ³
* ³ Date Created: 24-11-2006                Date Updated: þ21-12-2010        ³
* ³ Time Created: 13:22:26                  Time Updated: þ17:33:51          ³
* ³    CopyRight: (c) 1999-2011 Custom Management Software                   ³
* ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
* ³    Arguments: None                                                       ³
* ³      Returns: lSuccess                                                   ³
* ³     See Also:                                                            ³
* ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Function gpInitADSDD()
Local lSuccess := .F.
Local cCurDir := wfGlobal( "cDrive" ) + StrTran( wfGlobal( "cNetPth" ), "\", "//" ) + "//"
Local cExt := OrdBagExt(), cErr, lNewDD
Local nI, nDbfs := iDBF_COUNT_STD, aOpen
Local aOffices := wfGlobal( "aOffices" )
Local nJ, nOffs := Len( aOffices ), cOff
Local lBookStore := wfGlobal( "lBookStore" )
Local lEventReg := wfGlobal( "lEventReg" )
Local lEventRegV2 := wfGlobal( "lEventRegV2" )
Local lHockey := wfGlobal( "lHockey" )
Local lSubscription := wfGlobal( "lSubscription" )
Local lSponsorship := wfGlobal( "lSponsorship" )
Local aFTW := { iDIC_DBF, iDIC_CDX, iDIC_STR, iUSER_USR, iUSER_ACC, iUSER_EML }, nFTW
Local bAddDD := {|aOpen,cOff| ;
   AdsDDAddTable( aOpen[iALIAS] + If( cOff # Nil, cOff, "" ), cCurDir + aOpen[iTNAME][iTNAME_DBF] + ".dbf", ;
      If( Len( aOpen[iTNAME] ) > 1, aOpen[iTNAME][iTNAME_CDX] + cExt, Nil ) ) }
Local aDDTables := {}  // , hFind, cStr

If lNewDD := ! File( cCurDir + "spw.add" )       // to avoid error 5128 AE_DICTIONARY_ALREADY_EXISTS
   lSuccess := AdsDDCreate( cCurDir + "spw.add", 0, "The Silent Partner Advantage Data Dictionary" )
Else
   lSuccess := AdsConnect60( cCurDir + "spw.add", wfGlobal( "nADSServerType" ), "ADSSYS", , /*ADS_DEFAULT*/ )
Endif

If lSuccess .and. lNewDD
   AdsDDSetDatabaseProperty( ADS_DD_VERSION_MAJOR, Val( Left( iSYS_VER, 1 ) ) )
   AdsDDSetDatabaseProperty( ADS_DD_VERSION_MINOR, Val( SubStr( iSYS_VER, 3, 2 ) ) )

   //hFind := AdsDDFindFirstObject( ADS_DD_TABLE_OBJECT, , @cStr )
   //If hFind > 0
   //   AAdd( aDDTables, Lower( StrTran( cStr, Chr(0), "" ) ) )
   //   //wfmsgdebug( { AdsGetLastError(), hFind, cStr } )
   //   Do While AdsDDFindNextObject( hFind, @cStr )
   //      AAdd( aDDTables, Lower( StrTran( cStr, Chr(0), "" ) ) )
   //      //wfmsgdebug( { AdsGetLastError(), hFind, cStr } )
   //   Enddo
   //   AdsDDFindClose( hFind )
   //   //wfmsgdebug( { AdsGetLastError() } )
   //  *AEval( aDDTables, {|cTable| wfmsgdebug( { lower( cTable ) }, .f. )  } )
   //Endif
   //aDDTables := AdsDirectory( cCurDir + "*.dbf" )  // this function wraps the above AdsDDFind*() functions that aren't accesible directly
      // but how can we determine if a table is already in the DD to avoid the 5132 ???
   // any object (Table, User, Trigger, etc.) already in the DD will return a 5132 AE_INVALID_OBJECT_NAME if attempt to add it again

   nFTW := Len( aFTW )
   For nI := 1 To nFTW
      If AScan( aDDTables, {|cTable| Lower( cTable ) == Lower( aFTW[nI] ) + ".dbf" } ) == 0
         AdsDDAddTable( aFTW[nI], cCurDir + aFTW[nI] + ".dbf", aFTW[nI] + cExt )
         If AdsGetLastError( @cErr ) > 0
            wfmsgdebug( { cErr, aFTW[nI] } )
         Endif
      Endif
   Next
   For nI := 0 To nDbfs
      If nI >= iDDONATIONS .and. nI <= iDREC_ADDRESS
         For nJ := 1 To nOffs
            cOff := StrZero( aOffices[nJ,1], 2 )
            aOpen := gpOpenDbf( nI, , cOff )
            If AScan( aDDTables, {|cTable| Lower( cTable ) == Lower( aOpen[iTNAME][iTNAME_DBF] ) + ".dbf" } ) == 0
               Eval( bAddDD, aOpen, cOff )
               If AdsGetLastError( @cErr ) > 0
                  wfmsgdebug( { cErr, aOpen[iTNAME][iTNAME_DBF] } )
               Endif
            Endif
         Next
      Else
         aOpen := gpOpenDbf( nI )
         If AScan( aDDTables, {|cTable| Lower( cTable ) == Lower( aOpen[iTNAME][iTNAME_DBF] ) + ".dbf" } ) == 0
            Eval( bAddDD, aOpen )
            If AdsGetLastError( @cErr ) > 0
               wfmsgdebug( { cErr, aOpen[iTNAME][iTNAME_DBF] } )
            Endif
         Endif
      Endif
   Next
   If lBookStore
      For nI := iKINVENTORY To iDPORDERS
         If nI == iDAR_SALES
            For nJ := 1 To nOffs
               aOpen := gpOpenDbf( nI, , cOff )
               If AScan( aDDTables, {|cTable| Lower( cTable ) == Lower( aOpen[iTNAME][iTNAME_DBF] ) + ".dbf" } ) == 0
                  Eval( bAddDD, aOpen, cOff )
                  If AdsGetLastError( @cErr ) > 0
                     wfmsgdebug( { cErr, aOpen[iTNAME][iTNAME_DBF] } )
                  Endif
               Endif
            Next
         Else
            aOpen := gpOpenDbf( nI )
            If AScan( aDDTables, {|cTable| Lower( cTable ) == Lower( aOpen[iTNAME][iTNAME_DBF] ) + ".dbf" } ) == 0
               Eval( bAddDD, aOpen )
               If AdsGetLastError( @cErr ) > 0
                  wfmsgdebug( { cErr, aOpen[iTNAME][iTNAME_DBF] } )
               Endif
            Endif
         Endif
      Next
   Endif
   If lEventReg
      For nI := iKEVENTS To iDREGISTRATION
         Eval( bAddDD, aOpen := gpOpenDbf( nI ) )
         If AdsGetLastError( @cErr ) > 0
            wfmsgdebug( { cErr, aOpen[iTNAME][iTNAME_DBF] } )
         Endif
      Next
   Endif
   If lEventRegV2
      For nI := iKEVENTSV2 To iDREGISTRATIONV2
         Eval( bAddDD, aOpen := gpOpenDbf( nI ) )
         If AdsGetLastError( @cErr ) > 0
            wfmsgdebug( { cErr, aOpen[iTNAME][iTNAME_DBF] } )
         Endif
      Next
   Endif
   If lHockey
      For nI := iKCAMPS To iDPAYMENT
         aOpen := gpOpenDbf( nI )
         If AScan( aDDTables, {|cTable| Lower( cTable ) == Lower( aOpen[iTNAME][iTNAME_DBF] ) + ".dbf" } ) == 0
            Eval( bAddDD, aOpen )
            If AdsGetLastError( @cErr ) > 0
               wfmsgdebug( { cErr, aOpen[iTNAME][iTNAME_DBF] } )
            Endif
         Endif
      Next
   Endif
   If lSubscription
      For nI := iMSUBSCRIPTION To iDSUBSCRIPTION
         aOpen := gpOpenDbf( nI )
         If AScan( aDDTables, {|cTable| Lower( cTable ) == Lower( aOpen[iTNAME][iTNAME_DBF] ) + ".dbf" } ) == 0
            Eval( bAddDD, aOpen )
            If AdsGetLastError( @cErr ) > 0
               wfmsgdebug( { cErr, aOpen[iTNAME][iTNAME_DBF] } )
            Endif
         Endif
      Next
   Endif
   If lSponsorship
      For nI := iKKIDS To iDKIDSHISTORY
         aOpen := gpOpenDbf( nI )
         If AScan( aDDTables, {|cTable| Lower( cTable ) == Lower( aOpen[iTNAME][iTNAME_DBF] ) + ".dbf" } ) == 0
            Eval( bAddDD, aOpen )
            If AdsGetLastError( @cErr ) > 0
               wfmsgdebug( { cErr, aOpen[iTNAME][iTNAME_DBF] } )
            Endif
         Endif
      Next
   Endif

   // Reopen so changes to spw.add are visible
   AdsDisconnect()
   lSuccess := AdsConnect60( cCurDir + "spw.add", wfGlobal( "nADSServerType" ), "ADSSYS", , /*ADS_DEFAULT*/ )
Endif

If lSuccess
/*
   wfmsgdebug( { AdsDDGetDatabaseProperty( ADS_DD_COMMENT ) } )
   wfmsgdebug( { AdsDDGetDatabaseProperty( ADS_DD_VERSION_MAJOR ) } )
   wfmsgdebug( { AdsDDGetDatabaseProperty( ADS_DD_VERSION_MINOR ) } )
   wfmsgdebug( { AdsDDGetDatabaseProperty( ADS_DD_DEFAULT_TABLE_PATH ) } )
   wfmsgdebug( { AdsDDGetDatabaseProperty( ADS_DD_LOG_IN_REQUIRED ) } )
   wfmsgdebug( { AdsDDGetDatabaseProperty( ADS_DD_VERIFY_ACCESS_RIGHTS ) } )
*/
   wfGlobal( "cAISPath", cCurDir )
Else
   wfGlobal( "cAISPath", "" )
   AdsGetLastError( @cErr )
   msgStop( "Unable to initialize the Advantage Data Dictionary:" + CRLF + CRLF + cErr, ;
      wfGlobal( "cSysName" ) )
Endif

Return lSuccess
