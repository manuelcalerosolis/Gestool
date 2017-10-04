//-----------------------------------------------------------------------------------------------
//Author: Reinaldo Crespo-Bazan; email:reinaldo.crespo@gmail.com  tel:1(954)744-0286
//
//The purpose of this code is to show how to use rddads for harbour programmers. 
//In order to keep things simple some "shady" or incomplete logic is allowed.  More complex 
//business logic would go beyond the scope of the intended purpose and audience. 
//Furthermore, By making this code GUI agnostic I understand a larger audience can be reached being 
//that xbase/Harbour programmers have many choices, versions and styles of GUI.
//
//On these samples we are showing how to manage data using ISAM style programming 
//and xbase syntax while also introducing SQL.  All of it using RDD ADS.
//
//I advise you download ACE SDK for the needed include files as well as .dlls needed 
//to crate an Advantage enabled application.  Also download arc32 (advantage data architect)
//These can be downloaded from www.devzone.advantagedatabase.com 
//
//To understand how to build and Advantage enabled application, to learn the differences 
//between the local server, remote server and internet server and to learn how to compile and 
//link rddads.lib for any version of Harbour, please read a document I wrote on the subject from:
//http://main.structuredsystems.com/adssamples/Building%20rddads%20lib%20blog%20post.pdf
//
//This sample code file as well as other samples and utilities can also be downloaded from my personal 
//server: www.main.structuredsystems.com/adssamples
//
//Basically ADS is a full featured and easily embedded RDBMS for Windows, Linux, and Netware.  
//SQL as well as ISAM is possible natively with ADS 2-tier client-server and mobile environments. 
//ADS provides flexibility that can't be matched by SQL-only databases � with both ISAM and SQL data access.
//It is easy scaleable from local to peer-to-peer to client-server environments with one set of source code.
//Finally, ADS installs and manages without the need for a database administrator.
//
//This sample code shows:
//(1) how to create and connect to an Advantage Data Dictionary (ADS DD)
//(2) how to construct and execute SQL sentances against our database and to query the DD 
//(3) how to use extended field types on VFP and ADT tables 
//(4) how to define field default values and constraints 
//(5) how to create and use Fast Text Search Indexes (FTS). 
//(6) how to create user-groups, users and manage permissions via groups 
//(7) how to create referential integrity rules to guarantee data integrity 
//(8) how to encrypt/decrypt data associated with the DD or as free tables 
//(9) enforce better data security via passwors, access rights, encryption 
//(10)how to use and create triggers to automate certain tasks as a result of some data transaction
//(11)how to create stored procedures and functions
//(12)using transactions to ensure data integrity
//(13)Show how to use database event notifications to update a remote screen displaying progress of work orders
//(14)AdsBackup from stored procedures, Arc32, or command line utility.
//
//if you need help with this sample code you may email me.  
//
//how to build rddads.lib 
//bcc32 -c -I\xharbour\include -Ipath_to_ads.h adsfunc.c 
//same with ads1.c and adsmgmnt.c 
//tlib rddads.lib +adsfunc.obj ...

//use implib to create ace32.lib from ace32.dll which is distributed with the SDK from devzone.advantagedatabase.com 
//optionaly compile ace32.c.
//c:\xharbour\contrib\rdd_ads>c:\bcc7\bin\bcc32 -c -Ic:\xharbour\include -Ipath_for_ads_headers ace32.c
//
//TO DO:
//1. Temporary tables
//2. Keep in Memory tables
//3. Views
//Interesting read:
//http://forums.fivetechsupport.com/viewtopic.php?f=3&t=9343&p=79429&hilit=adsrecordcount#p79429
//-----------------------------------------------------------------------------------------------

#include "ads.ch"
#include "fivewin.ch"
#include "hbclass.ch"

#define NBCKGRNDCOLOR      RGB( 204, 204, 255 )
#define NBCKGRNDCOLOR2     RGB( 224, 224, 255 )
#define COLOR_HIGHLIGHT         13

#define ADS_DD_FTS_DELIMITERS                115
#define ADS_DD_FTS_NOISE                     116
#define ADS_DD_FTS_DROP_CHARS                117
#define ADS_DD_FTS_CONDITIONAL_CHARS         118

#xcommand OVERRIDE METHOD <!Message!> [IN] CLASS <!Class!> WITH [METHOD] ;
                          <!Method!> [SCOPE <Scope>] => ;
          __clsModMsg( <Class>():classH, #<Message>, @<Method>(), ;
                       IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ) )
REQUEST ADS

STATIC cPath
STATIC aFiles
STATIC cUser, cPassword 
STATIC oBrw, oDlg
STATIC hConnection

*-----------------------------------------------------------------------------------------------------
//This sample shows how to create tables using SQL instead of api function calls.  We are also adding 
//the concept of data dictionaries.  The created tables will now be bound to the data dictionary and 
//we will no longer use tables freely but only through a data dictionary conection.
//
FUNCTION Main()
LOCAL cDDName, isIndexed, cAlias

   rddSetDefault( "ADS" )
   adsSetServerType( ADS_LOCAL_SERVER )
   AdsLocking( .T. )           //NON-compatible locking mode
    
   cPath   := hb_ArgV( 1 )
   cUser   := hb_ArgV( 2 )
   cPassword:= hb_ArgV( 3 ) 


   //---------------------------------------------------------------------------
   //sanatize cPath, cPassword, cUser sent parameters.  We set cPassword to 
   //"password" as that's how we create the demo DD for user adssys.
   DEFAULT cpath := ""
   DEFAULT cUser := ""
   DEFAULT cPassword := ""

   IF EMPTY( cPassword )   ; cPassword := "password"  ;ENDIF
   IF EMPTY( cUser )       ; cUser     := "adssys"    ;ENDIF    
   IF !EMPTY( cPath ) .AND. RIGHT( cPath, 1 ) != "\"    ;cPath += "\"  ;ENDIF

   cDDName := cPath + "test_dd.add" 
   
   //---------------------------------------------------------------------------
   //Statment below is completely unnecesary as all tables are DD bound.  
   //DD knows the path to each table which, in fact, could each be in a different directory.
   //SET PATH TO cPath 

   //---------------------------------------------------------------------------
   IF ( hConnection := CreateOrConnect2DD( cDDName ) ) == 0 //creates and/or connects to newly created dd.
      MsgStop( "Can't connect to data dictionary.  Aborting" )
      RETURN NIL 
   ENDIF


   CreateTablesUsingSQL() //New empty tables bound to newly created dd


   //----------------------------------------------------------------------------   
   //Show how to set default values and constraints on fields for DD bound tables.
   //This is one step towards moving our business logic out to the database.
   SetDefaultFieldValues()


   //----------------------------------------------------------------------------   
   //If tables already exist and we want to enhance our software by binding these tables 
   //to our newly created ADS DD, then look inside this function to learn how to.
   //AddExistingTablesToDD()

   InsertTestItems()
   InsertTestCustomers()
   InsertTestSales() //not checking for data integrity.

   CreateIndexesUsingSQL()

   //---------------------------------------------------------------------------
   //Fast Text Search (FTS) indexes imitate "google" searches on text/memo fields.
   //Note to self:
   //For demonstration show power of FTS using a filter on patients where lastname contains Ri* 
   //and first name contains Jos* or Juan.  Also use PathLabs data to find breast carcinoma
   CreateFTSIndexUsingACE()


   //----------------------------------------------------------------------------   
   //Note to self:
   //Show how to implement Referentail Integrity rules that enforce rejection of 
   //transactions that violate RI. RI rules helps move a lot of our business logic 
   //to the database making our work easier with less coding.
   //Show RI rules working with PrBill10 trying to delete a patient with encounters 
   //and claims.  Also try to delete a doctor referenced on an encounter.
   //CreateRIRules()


   //----------------------------------------------------------------------------   
   //Create groups and assign different access and permissions to each group.  
   //Also assign users to one or more groups.  This limits user's access to data and 
   //restricts certain operations on some users according to its groups permissions.
   //This also removes a lot of our business logic to the database.
   CreateUserGroups()
   AssignUsersToGroups()


   //----------------------------------------------------------------------------   
   //Function below would only be used if customers table was a free table.
   //For DD bound tables see function SetDefaultValues() where customers table is 
   //being encrypted via DD table property.
   //EncryptCustomersTable()  

   //----------------------------------------------------------------------------
   //Triggers are a way to execute certain code as a result of an INSERT, DELETE, UPDATE 
   //event on a table.  Sample code shows a rudimentary way to keep an audit trial
   //of sales table deletions.   I'd love to show how to maintain an audit-trial table that 
   //keeps all changes/deletions on any table so that it can be tracked.  It would probably be too 
   //complicated for the intended audience here but if interested, then please email me and 
   //I will share SQL code on a trigger that shows how to.
   //A trigger can also be used to validate/sanatize certain data before it is inserted.
   CreateTriggers()


   CreateSomeDDFunctions()
   
   //----------------------------------------------------------------------------   
   //let's now browse our data and make changes to customers and sales data to see automatic
   //changes happening on fields like totalsale, autoincrement, and modtime.
   BrowseTables()


   //----------------------------------------------------------------------------   
   //About Database notifications:
   //Event notifications are a mechanism that allows an action at the server to proactively notify clients 
   //that an event they are interested in has occurred.
   //Clients use the canned procedure sp_CreateEvent to register for event notifications. Once registered, the 
   //client can call sp_WaitForEvent or sp_WaitForAnyEvent to efficiently wait for the event to be signaled. 
   //Events are signaled using the sp_SignalEvent procedure.
   //
   //Advantage supports many-to-one event delivery. If an event is signaled X times between calls to one 
   //of the wait procedures, rather than receiving each signal individually, the wait function returns a 
   //count of how many times the event has been signaled since the last wait operation.
   //
   //Notifications will work with local server, however the efficiency will not be optimal because with 
   //no centralized server each client application will be sharing information via a physical "event table" 
   //on a file server and will be polling it for changes. The polling interval is configurable and is sent 
   //via a parameter to the wait procedures.
   //
   //In most cases we will need to create a new thread and a new connection to the database 
   //to execute the wait for event procedures. If the wait procedures are executed on an existing 
   //connection, keep in mind that the connection will not be able to process any other database requests 
   //until either the event is signaled or it times out. In some situations this may be appropriate, 
   //but in other cases you may want an individual thread dedicated to waiting for events.
   //
   //One other possibility -although not as efficient as spawning a new thread- is to poll for the 
   //event on a timer. On the sample function below we check for events on background inside an infinite loop.
   //
   //Note: Multiple local server users connecting to the same data dictionary must use the same connection path 
   //in order to share event notifications. Specifically if one user is connecting to the data dictionary 
   //on a local drive (e.g. C:\), then they must use the same path as any remote users to share event 
   //notifications (e.g. \\server\share). Our recommendation is to use UNC paths for all users.
   //
   //Step 1: Register to listen for the event.
   //sp_CreateEvent() informs the server that this current connection handle is interested on 
   //'TotalSalesChange' messages.  The actual message is fired by a trigger on sales table.
   ExecuteSql( "EXECUTE PROCEDURE sp_CreateEvent( 'TotalSalesChange', 2  );", ADS_ADT )

   //Start a new thread to listen for db event notifications and act accordingly.
   ShowRealTimeSalesTotal()

   //ADS online backups allows you to backup data even while in use or being modified. 
   //When executed ADS attempts to synchronize a snapshot of the database at that particular moment in time.
   //Advantage supports complete and differential backups.  Differential backups take less time 
   //to execute because it updates only those records that were changed, deleted, or inserted since last backup.
   //You must prepare differential backup before it can be performed.  
   //
   //read comments on fuction AdsBackup() to see how is done:
   
   
RETURN NIL 


//--------------------------------------------------------------------------------------------------
PROCEDURE RddInit()

   REQUEST HB_LANG_EN
   REQUEST DBFCDX, DBFFPT
   REQUEST OrdKeyCount, OrdKeyNo, OrdKeyGoto
   REQUEST ADSKeyNo, ADSKeyCount, AdsGetRelKeyPos
   REQUEST ADS

return



//--------------------------------------------------------------------------------------------------------
//function CreateTablesUsingSQL() shows table creation using sql.  A few extended field types are being 
//used also to demonstrate other advantages of ADS.
STATIC FUNCTION CreateTablesUsingSQL()
LOCAL e AS OBJECT
LOCAL cSql AS CHARACTER

    cSql := ;
      "TRY                                   \n" +;
      "  CREATE TABLE customers (            \n" +;
      "           CUST_ID Char( 10 ) CONSTRAINT NOT NULL PRIMARY KEY, \n" +;
      "           SEQUENCE AutoInc,          \n" +;  //EFT
      "           CUSTOMER_NAME Char( 25 ),  \n" +;
      ;//"           [Last Name] ciCharacter( 30 ), \n"+; case insensitive
      ;//"           [First Name] ciCharacter( 20 ),\n"+; case insensitive
      "           [Date Account Opened] TimeStamp,\n"+;  //EFT
      "           [Row Version] ROWVersion,  \n" +;//EFT
      "           [Last Modification] ModTime,\n"+;//EFT
      "           UniqueId CHAR( 24 ),       \n" +;//especially placed here to show default field values later
      "           Image BLOB,                \n" +;//EFT
      ;//"           [Raw Data] Raw(512),            \n" +;//like blob but fixed length stored inside table instead of external memo file.
      "           NOTES Memo) IN DATABASE;   \n" +;
      "CATCH ADS_SCRIPT_EXCEPTION            \n" +;
      "END TRY \n"

   ExecuteSQL( cSql, ADS_ADT )

    cSql := ;
      "TRY                                   \n"+;
      "  CREATE TABLE sales (                 \n"+;
      "           CUST_ID Char( 10 ),         \n"+;
      "           INVOICE Char( 24 ),         \n"+;
      "           S_DATE TimeStamp,           \n"+;
      "           ITEM_ID Char( 15 ),         \n"+;
      "           UNITS Numeric( 3 ,0 ),      \n"+;
      "           PRICE MONEY ,               \n"+;
      "           TotalSale MONEY,            \n"+;
      "           NOTES Memo) IN DATABASE;    \n"+;
      "CATCH ADS_SCRIPT_EXCEPTION            \n"+;
      "END TRY \n"

   ExecuteSQL( cSql, ADS_VFP )


   cSql := ;
      "TRY                                   \n"+;
      "  CREATE TABLE items (                \n"+;
      "           item_id Char( 15 ),        \n"+;
      "           [Desc] Char( 50 ),         \n"+;
      "           Price Numeric( 9, 2 ) ) IN DATABASE;\n"+;
      "CATCH ADS_SCRIPT_EXCEPTION            \n"+;
      "END TRY \n"

   ExecuteSQL( cSql, ADS_CDX )

   //-----------------------------------------------------------------------
   //create another table to be used later when working with Triggers
   //table will be used to store deleted sales records. It has the same 
   //fields plus an extra two fields to store user and time stamp of event.
   //-----------------------------------------------------------------------
   cSql := ;   
      "TRY \n"+;
      "  CREATE TABLE sales_Auditlog (\n"+;
      "           CUST_ID Char( 10 ),         \n"+;
      "           INVOICE Char( 24 ),         \n"+;
      "           S_DATE TimeStamp,           \n"+;
      "           ITEM_ID Char( 15 ),         \n"+;
      "           UNITS Numeric( 3 ,0 ),      \n"+;
      "           PRICE MONEY,      \n"+;
      "           TotalSale MONEY,  \n"+;
      "           NOTES Memo,                 \n"+;
      "           EventName Char( 15 ),       \n"+;
      "           ActionTimeStamp TimeStamp,  \n"+; 
      "           Operator Char(20) ) IN DATABASE;\n"+;
      "CATCH ADS_SCRIPT_EXCEPTION            \n"+;
      "END TRY \n"
   ExecuteSQL( cSql, ADS_VFP )  
   
    

    //TRY
      //if tables are already present on data dictionary then, we won't execute 
      //SQL script to create the table.  Look inside function isInDictionary()
      //further below to see how we can query the DD for a table's existance.
      //IF !isInDictionary( "customers" )   ;ExecuteSQL( cSql_1, ADS_ADT )   ;ENDIF
      //IF !isInDictionary( "sales" )       ;ExecuteSQL( cSql_2, ADS_VFP )   ;ENDIF
      //IF !isInDictionary( "items" )       ;ExecuteSQL( cSql_3, ADS_CDX )   ;ENDIF 

    //CATCH e
    //    ShowError( e )  
    //END

RETURN NIL 



/*--------------------------------------------------------------------------------------------------------
CreateDictionary creates an Advantage Data Dictionary based on already existing tables 
--------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION CreateOrConnect2DD( cDDName )
LOCAL isNew := .F.
LOCAL hConnect

   IF !ADSConnect60( cDDName, ADS_LOCAL_SERVER, cUser, cPassword,, @hConnect ) .AND. ;
      !( isNew := ADSDDCREATE( cDDName, /*non-encrypted DD*/, "Sample data dictinoary" ) )

        Alert( "AdsCreate() of " + cDDName + " failed. Error:" + Str( AdsGetLastError() ) )
        RETURN .F. 

   ENDIF 

   IF !isNew   ;RETURN hConnect ;ENDIF 

   hConnect :=  adsConnection()

   //See documentation for choices on database properties that can be set 
   //using AdsDDSetDatabaseProperty() ACE function 
    AdsDDSetDatabaseProperty( ADS_DD_ENABLE_INTERNET, .T. ) 
    
   //Level 0: This level provides no authentication or encryption. This might be the choice if Advantage Internet Server 
   //were being used in an intranet environment. Users are not prompted to enter a user ID and password on the database 
   //application startup.

   //Level 1: Level 1 requires users to authenticate but no encryption is used. Users are prompted on database application 
   //startup to enter a user ID and password. User access to database files is limited according to the user rights in the 
   //Advantage Data Dictionary.

   //Level 2: Level 2 requires users to authenticate and encrypts all data during the session. Users are prompted on database 
   //application startup to enter a user ID and password. The encryption algorithm is an industry-standard stream cipher that 
   //uses 160-bit keys.  Security level 2 might be the best choice when using Internet connections so data is not transferred 
   //in the "clear" over the Internet.
   AdsDDSetDatabaseProperty( ADS_DD_INTERNET_SECURITY_LEVEL, ADS_DD_LEVEL_2 )

   //set other table defaults such as encryption password 
   AdsDDSetDatabaseProperty( ADS_DD_ENCRYPT_TABLE_PASSWORD, "TableEncryptPasswordGoesHere" )

   //add more db security by encrypting indexes and client-server communication and maximum login attempts
   //AdsDDSetDatabaseProperty( ADS_DD_ENCRYPT_INDEXES, .T. )
   //AdsDDSetDatabaseProperty( ADS_DD_ENCRYPT_COMMUNICATION, .T. )
   AdsDDSetDatabaseProperty( ADS_DD_MAX_FAILED_ATTEMPTS, 5 ) 
   
   //Fast Text Search Index defaults
   AdsDDSetDatabaseProperty( ADS_DD_FTS_DELIMITERS, chr(32)+chr(8)+chr(9)+chr(10)+chr(11)+chr(12)+chr(13) )
   AdsDDSetDatabaseProperty( ADS_DD_FTS_NOISE, ;
    "about after all also an and another any are as at be because been before being "+;
      "between both but by came can come could did do does each else for from get got had has "+;
      "have he her here him himself his how if in into is it its just like make many me "+;
      "might more most much must my never now of on only or other our out over re said same see "+;
      "should since so some still such take than that the their them then there these they this "+;
      "those through to too under up use very want was way we well were what when where which while "+;
      "who will with would you your" )
   AdsDDSetDatabaseProperty( ADS_DD_FTS_DROP_CHARS,"'" + '"' )
   AdsDDSetDatabaseProperty( ADS_DD_FTS_CONDITIONAL_CHARS, ",.?!;:@#$%^&()-_" )


   AdsDDSetDatabaseProperty( ADS_DD_DEFAULT_TABLE_PATH, cPath )

   //add some db security by not allowing connections without logging into DD.
   AdsDDSetDatabaseProperty( ADS_DD_LOG_IN_REQUIRED, .T. )

   // set ADS_DD_VERIFY_ACCESS_RIGHTS to .f. to allow all users to
   // have all access rights.  Set to .t. to enforce group and user rights.
   AdsDDSetDatabaseProperty( ADS_DD_VERIFY_ACCESS_RIGHTS, .T. )
   
   AdsDDSetDatabaseProperty( ADS_DD_ADMIN_PASSWORD, "password" )

   AdsDDCreateUser( , "user1", "password1", "User named userd1 with password password1" )
   AdsDDCreateUser( , "user2", "password2", "Description of user2" )
   AdsDDCreateUser( , "user3", "password3", "Optional description of user3" )

RETURN .T.


//------------------------------------------------------------------
//Create Test Tables and populates with data
STATIC FUNCTION InsertTestCustomers()
   LOCAL i
   LOCAL cAlias := "Customers"
                        
   AdsSetFileType( ADS_ADT )   
   dbUseArea( .T., "ADS", "customers", cAlias, .T. )

   IF ( cAlias )->( lastrec() ) < 5000

      FOR i := 1 TO 5000 

         ( cAlias )->( dbappend() )
         ( cAlias )->cust_id := STRZERO( i, 10 )
         ( cAlias )->Customer_name := "Customer Name -" + STR( i )

      NEXT 

   ENDIF 
   
   ( cAlias )->( dbclosearea() )

RETURN NIL


//--------------------------------------------------------------------
STATIC FUNCTION InsertTestSales() 
   LOCAL cAlias := "sales"
   LOCAL i, nItems, nCusts
   LOCAL dToday := date()
   LOCAL cItem, cCust
   
   AdsSetFileType( ADS_VFP ) 
   dbUseArea( .T., "ADS", "sales", cAlias, .T. )
   
   IF sales->( lastrec() ) < 5000

      AdsSetFileType( ADS_CDX )
      dbUseArea( .T., "ADS", "items", "items", .T. )
      nItems := Items->( recCount() )

      AdsSetFileType( ADS_ADT )
      dbUseArea( .T., "ADS", "customers", "customers", .T. )
      nCusts := customers->( recCount() )

      FOR i := 1 TO 5000

         items->( dbGoto( hb_RandomInt( 1, nItems ) ) ) //place f.pointer on a random item
         customers->( dbGoto( hb_RandomInt( 1, nCusts ) ) )//place f.pointer on a random customer

         cItem := items->ITEM_ID
         cCust := customers->cust_id 

         ( cAlias )->( dbAppend() )
         ( cAlias )->cust_id     := cCust
         ( cAlias )->Item_id     := cItem
         ( cAlias )->Units       := hb_RandomInt( 1, 10 )
         ( cAlias )->Price       := Items->Price
         ( cAlias )->TotalSale   := Items->Price * ( cAlias )->Units
         ( cAlias )->s_date      := DateTime()

      NEXT 

      items->( dbclosearea() )
      customers->( dbclosearea() )
   ENDIF 

   ( cAlias )->( dbclosearea() )

RETURN NIL 

//-----------------------------------------------------------------------------------
STATIC FUNCTION InsertTestItems()
   LOCAL i, e 
   LOCAL cItem
   LOCAL nLastErr, cLastErr

   FIELD item_id 
   
   AdsSetFileType( ADS_CDX ) 
   dbUseArea( .T., "ADS", "items", "items", .T. )

   IF items->( RecCount() ) > 0  
      items->( dbclosearea() )
      RETURN NIL 
   ENDIF
   
   TRY
      FOR i := 1 TO 5000 
      
         cItem := STRZERO( i, 15 )

         TRY
               items->( dbAppend() )
               items->item_id := cItem
               items->desc := "Description for item " + cItem
               items->price := hb_Random( 1000 )
         CATCH
         END
         
      NEXT 

   CATCH e
      IF ( nLastErr := ADSGetLastError( @cLastErr ) ) > 0   ;MsgStop( cLastErr ) ;ENDIF 
   END 

   TRY
      items->( OrdCreate( "items","item_id", "item_id", { || item_id .AND. !deleted() }, .T.  ) )
      items->( OrdCreate( "items","Desc", "Desc" ) ) 
   CATCH
   END


   items->( dbclosearea() )

RETURN NIL 


//--------------------------------------------------------------------------------------
//use of ADS stored procedure sp_CreateIndex90() to create indexes
//sp_CreateIndex90( TableName,CHARACTER,515, 
//                 FileName,CHARACTER,515, 
//                 TagName,CHARACTER,128, 
//                 Expression,CHARACTER,510, 
//                 Condition,CHARACTER,510, 
//                 Options,INTEGER, 
//                 PageSize,INTEGER, 
//                 Collation,CHARACTER,50 ); 
//Options: A bit field for defining the options for index creation. The options can be ORed together into 
//the bit field. For example ADS_COMPOUND | ADS_UNIQUE. The options (with the constants defined in ace.h) are:
// ADS_DEFAULT (0): If no options are needed, this constant can be used.
// ADS_UNIQUE (1): Create a unique index order.
// ADS_COMPOUND (2): Create an index order (tag) within a compound index file. Note that this option is always set when the 
//                   table type is ADS_ADT.
// ADS_CUSTOM (4): Create an empty index order. The user can add and remove keys via AdsAddCustomKey and AdsDeleteCustomKey.
// ADS_DESCENDING (8): Create a descending index order.
// ADS_CANDIDATE (2048): This creates a unique index order that prevents duplicate data. On ADT tables, 
//                   it is the same as the ADS_UNIQUE option. This can be used with Visual FoxPro tables (ADS_VFP) to create 
//                   an index that can be used as a primary key and in referential integrity relationships.
//ADS_BINARY_INDEX (4096): Create a binary index. The index expression must have a logical result. This option cannot be 
//                   combined with other options except for ADS_COMPOUND.
//If you are not using a parametrized statement, you can pass the numeric values for these options in the statement directly. 
//Two combine options, add the values together. For example, to create a binary compound index, pass the value 4098 (2+4096).

//Collation:
// this parameter can be used to specify the name of a dynamic collation that differs from the collation currently associated 
//with the SQL statement.

//Alternatively we could have chosen to use CREATE INDEX SQL statement.  
//Use of regular RDD functions can be used as well, such as OrdCreate().  
//Stored procedures and even SQL syntax CREATE INDEX statements are ultimately translated into 
//ACE API calls.  In this case AdsCreateIndex().  Keep in mind that most ACE API functions have not been 
//ported to Harbour's rddads.lib and this is why the use stored procedures is very safe.
//
STATIC FUNCTION CreateIndexesUsingSQL()
LOCAL cSql, cCursor

   cSql := "SELECT index_file_name AS [IndxName] FROM system.indexes WHERE index_file_name = 'customers.adi' "
   cCursor := ExecuteSQL( cSql, ADS_ADT )
   
   IF EMPTY( (cCursor)->IndxName ) 

      cSql := ;
         "  EXECUTE PROCEDURE sp_CreateIndex90( \n"+;
         "                    'customers',                \n"+; //tablename 
         "                    'customers.adi',            \n"+; //filename
         "                    'CUST_ID',                  \n"+; //TagName
         "                    'CUST_ID',                  \n"+; //expression
         "                    '',                         \n"+; //condition
         "                    2051,                       \n"+; //options = Table Primary Key + ADS_UNIQUE + ADS_COMPOUND
         "                    512,                        \n"+; //PageSize
         "                    '' );                       \n"+; //Collation -using default
         ;
         "  EXECUTE PROCEDURE sp_CreateIndex90( \n"+;
         "                    'customers',                \n"+;
         "                    'customers.adi',            \n"+;
         "                    'Date Account Opened',           \n"+;
         "                    'Date Account Opened',           \n"+;
         "                    '',                         \n"+;
         "                    2,                          \n"+; //ADS_COMPOUND
         "                    512,                        \n"+;
         "                    '' );                       \n"+;
         ;
         "  EXECUTE PROCEDURE sp_ModifyTableProperty( 'customers', \n"+;
         "                    'Table_Auto_Create',        \n"+;
         "                    'False', 'APPEND_FAIL', 'customersfail'); \n"+;
         ;
         "  EXECUTE PROCEDURE sp_ModifyTableProperty( 'customers', \n"+;
         "                    'Table_Permission_Level', \n"+;
         "                    '2', 'APPEND_FAIL', 'customersfail'); \n"+;
         ;
         "  EXECUTE PROCEDURE sp_ModifyTableProperty( 'customers', \n"+;
         "                    'Triggers_Disabled', \n"+;
         "                    'False', 'APPEND_FAIL', 'customersfail'); \n" +;
         ;
         "  EXECUTE PROCEDURE sp_ModifyTableProperty( 'customers', \n"+;
         "                    'TABLE_ENCRYPTION', 'TRUE', NULL, NULL );"

      ExecuteSQL( cSql, ADS_ADT )

   ENDIF

   cSql := "SELECT index_file_name AS [IndxName] FROM system.indexes WHERE index_file_name = 'sales.cdx' "
   cCursor := ExecuteSQL( cSql, ADS_ADT )
   
   IF EMPTY( (cCursor)->IndxName ) 
   
      cSql := ;
         "  EXECUTE PROCEDURE sp_CreateIndex90( \n"+;
         "                    'sales',                    \n"+;
         "                    'sales.cdx',                \n"+;
         "                    'INVOICE',                  \n"+;
         "                    'invoice',                  \n"+;
         "                    '!deleted()',               \n"+;
         "                    3,                          \n"+; //ADS_COMPOUND + ADS_UNIQUE
         "                    512,                        \n"+;
         "                    '' );                       \n"+;
         ;
         "  EXECUTE PROCEDURE sp_CreateIndex90( \n"+;
         "                    'sales',                    \n"+;
         "                    'sales.cdx',                \n"+;
         "                    'item_id',                  \n"+;
         "                    'item_id',                  \n"+;
         "                    '!deleted()',               \n"+;
         "                    2,                          \n"+; //ADS_COMPOUND + ADS_UNIQUE
         "                    512,                        \n"+;
         "                    '' );                       \n"+;
         ;
         "  EXECUTE PROCEDURE sp_CreateIndex90( \n"+;
         "                    'sales',                    \n"+;
         "                    'sales.cdx',                \n"+;
         "                    'CUST_ID',                  \n"+;
         "                    'cust_id',                  \n"+; 
         "                    '!deleted()',               \n"+; //condition necessary as VFP tables don't really delete records.
         "                    2,                          \n"+; //ADS_COMPOUND
         "                    512,                        \n"+;
         "                    '' );                       \n"
                
      ExecuteSQL( cSql, ADS_VFP )

   ENDIF

RETURN NIL 


*-------------------------------------------------------------------------------------------------------------------------------
//just a few default field values that demonstrate how to set default values
//field default values may set using stored procedure sp_ModifyFieldProperty() or 
//via ACE API AdsDDSetFieldProperty().  Harbour adsfunc.c hasn't implemented a wrapper
//for all ACE.  AdsDDSetFieldProperty() is one of the unimplemented functions.
//I have a wrapper written for it on my adsfunc.c source available from 
//www.main.structuredsystems.com/adssamples
//However, such ace wrapper is really unnecessary as there is a way executing 
//the stored procedure as shown below.

STATIC FUNCTION SetDefaultFieldValues() 
LOCAL cSql 

   //AdsDDSetFieldProperty( 'Customers', 'UniqueId', 'ADS_DD_FIELD_CAN_NULL', 'FALSE' )
   //AdsDDSetFieldProperty( 'Customers', 'UniqueId', 'ADS_DD_FIELD_DEFAULT_VALUE', "'NewIdString(" + '"M"' + ")'" )
   //AdsDDSetFieldProperty( 'Customers', 'Date Account Opened', 'ADS_DD_FIELD_DEFAULT_VALUE', "'Now()'" )
   //AdsDDSetFieldProperty( 'items', 'price', 'ADS_DD_FIELD_MIN_VALUE', 0.01 )
   //AdsDDSetFieldProperty( 'items', 'price', 'ADS_DD_FIELD_MAX_VALUE', 1000.00 )
   //AdsDDSetFieldProperty( 'items', 'price', 'ADS_DD_FIELD_VALIDATION_MSG', "Price amount is out of allowed range of 0.01 and 1,000.00." )

   cSql := "EXECUTE PROCEDURE sp_ModifyFieldProperty( \n" +;
                        "                  '$1$', '$2$', '$3$', '$4$', \n" +;
                        "                  'APPEND_FAIL', '$1$_fail' )\n"

   ExecuteSQL( SubstituteValuesIntoSQL( cSql, { "customers", ;
                                                "UniqueId", ;
                                                "FIELD_DEFAULT_VALUE",;
                                                "NewIdString(" + '"M"' + ")" } ), ADS_ADT )

   ExecuteSQL( SubstituteValuesIntoSQL( cSql, { "sales", ;
                                                "invoice", ;
                                                "FIELD_DEFAULT_VALUE",;
                                                "NewIdString(" + '"M"' + ")" } ), ADS_ADT )

   ExecuteSQL( SubstituteValuesIntoSQL( cSql, { "sales", ;
                                                "s_date", ;
                                                "FIELD_DEFAULT_VALUE",;
                                                "Now()" } ), ADS_ADT )


   ExecuteSQL( SubstituteValuesIntoSQL( cSql, { "customers", ;
                                                "Date Account Opened", ;
                                                "FIELD_DEFAULT_VALUE",;
                                                "Now()" } ), ADS_ADT )

   ExecuteSQL( SubstituteValuesIntoSQL( cSql, { "items", ;
                                                "price", ;
                                                "FIELD_MIN_VALUE",;
                                                "0.01" } ), ADS_ADT )

   ExecuteSQL( SubstituteValuesIntoSQL( cSql, { "items", ;
                                                "price", ;
                                                "FIELD_MAX_VALUE",;
                                                "1000.00" } ), ADS_ADT )

   ExecuteSQL( SubstituteValuesIntoSQL( cSql, { "items", ;
                                                "price", ;
                                                "FIELD_VALIDATION_MSG",;
                                                "Price is out of allowed range of 0.01 and 1,000.00" } ), ADS_ADT )


   //ExecuteSQL( SubstituteValuesIntoSQL( cSql, { "customers", "UniqueId", "Table_Primary_Key" } ), ADS_ADT )

RETURN NIL 


*-------------------------------------------------------------------------------------------------------------------------------
STATIC FUNCTION ExecuteSQL( cScript, cTblType )
LOCAL cArea, e
LOCAL isGood := .f.
LOCAL cErr, nLastErr

   IF !EMPTY( cScript )

      IF SELECT ( "sqlarea" ) > 0 ;SQLArea -> ( DBCLOSEAREA() ) ;ENDIF
   
      cScript := STRTRAN( cScript, "\n", CRLF )    
      AdsCacheOpenCursors( 0 )
      dbSelectArea(0)
         
      IF !ADSCreateSQLStatement("SQLarea", cTblType ) //.or. !ADSVerifySQL( cScript )
        
         TRY
            SQLArea->( DBCLOSEAREA() )
         CATCH e
         END
        
        nLastErr := ADSGetLastError( @cErr )
         MsgStop( cErr + " AdsCreateSqlStatement() failed with error Num:" + Str( nLastErr  ) )
         Logfile( "SqlTrace.log", cScript )
            
      ELSEIF !( isGood := AdsExecuteSQLDirect( cScript ) )

        nLastErr := ADSGetLastError( @cErr )
         MsgStop( "Error #" + cValToChar( nlastErr ) + " " + cErr )
         Logfile( "SqlTrace.log", cScript )

      ENDIF
        
   ENDIF      
            
   AdsCacheOpenCursors( 0 )

RETURN "SQLArea"



*-------------------------------------------------------------------------------------------------------------------------------
/*STATIC FUNCTION ShowError( oErr )
LOCAL cErr := Str( AdsGetLastError() )
    
    Alert( "Error : " + alltrim( cErr ) + " " + ;
            oErr:Subsystem + " " +  str( oErr:subCode ) + " " + ;
            oErr:operation + " " + oErr:description )

    dbcloseall()
    
RETURN NIL*/



//----------------------------------------------------------------------------------------------------------------
STATIC FUNCTION SubstituteValuesIntoSQL( cSql, aSubstitutes, isDebug ) 
LOCAL i
LOCAL cNewSql := cSql 

   DEFAULT isDebug := .F. 

   FOR i := 1 TO LEN( aSubstitutes )
   
      cNewSql := STRTRAN( cNewSql, "$"+ALLTRIM( STR( i ) ) + "$", cValToChar( aSubstitutes[ i ] ) )
      
   NEXT 

   IF isDebug ;LogFile( "SqlTrace.log", { cNewSql } ) ;ENDIF 

RETURN cNewSql 


//--------------------------------------------------------------------------------------
STATIC FUNCTION BrowseTables() 

   SET DELETED ON 

   OVERRIDE METHOD SaveXBR IN CLASS TDataRow WITH SaveItems 
   AdsSetFileType( ADS_CDX ) 
   USE "items" SHARED INDEX "items"
   XBROWSER "items" TITLE "browsing CDX items table" FASTEDIT SETUP SetupItemsBrw( oBrw )
   items->( dbCloseArea() )
      
   OVERRIDE METHOD SaveXBR IN CLASS TDataRow WITH SaveCustomers
   AdsSetFileType( ADS_ADT )   
   USE "customers" SHARED INDEX "customers"
   XBROWSER "customers" FASTEDIT TITLE "Customers ADT table" SETUP SetupCustomersBrw( oBrw )
   customers->( dbCloseArea() ) 
   
   OVERRIDE METHOD SaveXBR IN CLASS TDataRow WITH SaveSales
   AdsSetFileType( ADS_VFP ) 
   USE "sales" SHARED INDEX "sales"
   XBROWSER "sales" FASTEDIT TITLE "Sales VFP table" SETUP SetupSalesBrw( oBrw )
   sales->( dbCloseArea() )

   /*browsing Views.
   AdsSetFileType( ADS_ADT )   
   USE "custview" SHARED
   XBROWSER "custview" FASTEDIT TITLE "Customers Special View" 
   ( Select() )->( dbCloseArea() ) 

   USE "custsalesview" SHARED 
   XBROWSER "custsalesview" ;
   FASTEDIT ;
      TITLE "Customers Sales Special View" ;
      SETUP ( oBrw:cust_id:lMergeVert := .T., oBrw:customer_name:lMergeVert := .T. )

   ( Select() )->( dbCloseArea() )  */


RETURN NIL


//----------------------------------------------------------------------------------------------------------------
STATIC FUNCTION SetupItemsBrw( oBrw ) 

   WITH OBJECT oBrw 
      :lAutoAppend := .F. 
      :Item_id:bLClickHeader := {|nR, nC, nF, o| SelectOrder( o , "item_id" ) }
      :bDelete := ;
         < || 
               LOCAL e
               LOCAL oQ := TAdsQuery():New()
               TRY 
                  oQ:nTblType := ADS_CDX
                  oQ:cSql := "DELETE FROM items WHERE item_id = '$1$';"
                  //oQ:lShowErrors := .T.
                  oQ:aSubstitutes := { oBrw:item_id:Value() }
                  oQ:Run()
               CATCH e 
               FINALLY 
                  oQ:End()
               END 
               RETURN .T. 
          >
   END 
   
RETURN NIL 

//----------------------------------------------------------------------------------------------------------------
STATIC FUNCTION SetupSalesBrw( oBrw ) 

   WITH OBJECT oBrw 
      :lAutoAppend := .F. 
      :Invoice:bLClickHeader := {|nR, nC, nF, o| SelectOrder( o , "invoice" ) }
      :cust_id:bLClickHeader := {|nR, nC, nF, o| SelectOrder( o , "cust_id" ) }
      :Item_id:bLClickHeader := {|nR, nC, nF, o| SelectOrder( o , "item_id" ) }
      :bDelete := ;
         < || 
               LOCAL e
               LOCAL oQ := TAdsQuery():New()
               TRY 
                  oQ:nTblType := ADS_CDX
                  oQ:cSql := "DELETE FROM sales WHERE invoice = '$1$';"
                  //oQ:lShowErrors := .T.
                  oQ:aSubstitutes := { oBrw:Invoice:Value() }
                  oQ:Run()
               CATCH e 
               FINALLY 
                  oQ:End()
               END 
               RETURN .T. 
          >
   END 
   
RETURN NIL 

//----------------------------------------------------------------------------------------------------------------
STATIC FUNCTION SetupCustomersBrw( oBrw ) 

   WITH OBJECT oBrw 
      :lAutoAppend := .F. 
      :Cust_id:bLClickHeader := {|nR, nC, nF, o| SelectOrder( o , "Cust_id" ) }
      :bDelete := ;
         < || 
               LOCAL e
               LOCAL oQ := TAdsQuery():New()
               TRY 
                  oQ:cSql := "DELETE FROM customers WHERE cust_id = '$1$';"
                  //oQ:lShowErrors := .T.
                  oQ:aSubstitutes := { oBrw:cust_id:Value() }
                  oQ:Run()
               CATCH e 
               FINALLY 
                  oQ:End()
               END 
               RETURN .T. 
          >
      
      //bEdit := { ||EditItem( oBrw ) }
   END 
   
RETURN NIL 

FUNCTION selectOrder( oCol, cOrd )
//------------------------------------------------------------------------------

   AEVAL( oCol:oBrw:aCols, {|o| o:bClrHeader := {|| { CLR_BLUE, } } } )
   oCol:bClrHeader      := {|| {CLR_HRED, } }
   (oCol:oBrw:cAlias) -> ( OrdSetFocus( cOrd ) )

   oCol:oBrw:refresh()

   RETURN( NIL )


//----------------------------------------------------------------------------------------------------------------
//Use AdsDirectory() ACE API call to get an array of tables in the DD.
//Not sure if table name coms back as a null terminated string, thus sanitation
//is implemented by removing null from end of string.
//
/*STATIC FUNCTION IsInDictionary( cFileName )

   IF EMPTY( aFiles )
      afiles := AdsDirectory()   //ACE API
      AEVAL( aFiles, { |e,n| aFiles[ n ] := STRTRAN( ALLTRIM( LOWER( e ) ), CHR( 0 ), "" ) } )
   ENDIF

RETURN ASCAN( aFiles, LOWER( cFileName ) ) > 0 
      
//We could also query the DD using SQL like this:
//SELECT name FROM system.tables WHERE name = 'tablename'
STATIC FUNCTION IsInDictionaryUsingSQL( cFileName ) 
LOCAL cSql, cCursor

   cSql := "SELECT name FROM system.tables WHERE name = '$1$';"
   cCursor := ExecuteSQL( SubstituteValuesIntoSQL( cSql, cFileName ), ADS_ADT )
   
RETURN !EMPTY( ( cCursor )->name )
*/

//----------------------------------------------------------------------------------------------------------------
//This code shows a way to add existing tables into a newly created ADS DD.
//notice I'm simply using ACE API function AdsDDAddTable()
//Syntax:
//AdsDDAddTable( cAliasForTableOnDD, fileName, [TableIndexFileName] )
//cAliasForTableOnDD is the name that will be used to refer to this table 
//inside the data dictionary. 
//This code hasn't been tested and it is only being offered to help and show 
//how to add tables to an exisiting or newly created DD in order to take advantage 
//of the enhancements an ADS DD offers. 
//
/*STATIC FUNCTION AddExistingTablesToDD()
LOCAL aDir := Directory( cPath ) 
LOCAL aFileInfo, cFile, cExt
LOCAL nFileType := ADS_ADT

   FOR EACH aFileInfo IN aDir
   
      hb_FNameSplit( LOWER( aFileInfo[ 1 ] ),, @cfile, @cExt )

      nFileType := IIF( "cdx" $ cExt, ADS_CDX, ;
                     IIF( "adt" $ cExt, ADS_ADT, ;
                        IIF( "vfp" $ cExt, ADS_VFP, ADS_NTX  ) ) )

      AdsSetFileType( nFileType )

      AdsDDAddTable( cfile, aFileInfo[ 1 ], "" )
      
   NEXT 

RETURN NIL 
*/

//---------------------------------------------------------------------------------------------------------------
//An FTS index allows us to search very quickly for text on memo or character fields anywhere on the 
//field.  Special SQL and AOF scalar function Contains() can be used to set an optimized advantage filter 
//(AOF) and it can also be use on the WHERE clause of SQL sentences. 
//here is how to use Contains() scalar function with FTS indexes:
//
//The CONTAINS() function takes two parameters. The first is either a field name or an asterisk (*). 
//The asterisk indicates that the search will be applied to all fields that have FTS indexes. 
//The second parameter is the search condition inside quotes.
//CONTAINS( fieldname, �search condition� )
//CONTAINS( *, �search condition� )
//Use of the * as the first parameter causes the search to include all fields that have FTS indexes matching 
//the current active collation. For example, if a search is for two words, it will succeed even if the words 
//are in different fields. For example, the following search will succeed if 'dog' is in one field and 'cat' 
//is in another field in the same record (assuming both fields have FTS indexes that use same collation as the table's collation):
//
//CONTAINS(*, �dog and cat�)
//
//Another potential limitation with the wild card search is that if there are FTS indexes on both ANSI fields 
//and Unicode fields, then problem may arise if the ANSI FTS indexes and Unicode indexes were built using different 
//index options. For example, if �dog� is a noise word in the ANSI FTS indexes but not in the Unicode FTS indexes, 
//then an error will be returned when trying to perform the above search.
//
//Note that the NEAR operator requires that the related search words be in the same field. For example, the following 
//search will only succeed if both words are in the same field.
//
//CONTAINS(*, �dog NEAR cat�)
//
//In SQL statements, the field name or asterisk must be qualified with a table name if multiple tables are involved and 
//the field names are not unique. For example:
//
//         SELECT apdd.word, apdd.definition, ths.synomyms 
//           FROM apdd 
//LEFT OUTER JOIN ths on apdd.id=ths.idd
//          WHERE contains( apdd.definition, �superior� )
//
//The CONTAINS() scalar function can be used on fields that do not have FTS indexes, but the search will not be optimized.
//
//Scalar functions SCORE() AND SCOREDISTINCT() can be use to emulate a "google" search:
//The scoring functions SCORE() and SCOREDISTINCT() accept the same parameters as the CONTAINS() function. 
//SCORE() returns the total count of all instances of words in the search condition that are in the text for a 
//given record. SCOREDISTINCT() returns the number of search words that are in text. So the count for a given search 
//word will be zero if it does not appear in the text and one if it appears one or more times. For example, if the search 
//string is "word1 or word2" and the text is "word1 word1 word3", then SCORE() will return 2 and SCOREDISTINCT() will return 1.
//
//In addition to accepting the same parameters as CONTAINS(), the score functions also have a second form: 
//SCORE(n) and SCOREDISTINCT(n). In these versions, "n" refers to the nth instance of CONTAINS() in the statement. 
//The following two SQL statements are equivalent.
//
//  SELECT * 
//    FROM apdd 
//   WHERE CONTAINS( definition, �science or history� )
//ORDER BY SCORE( definition, �science or history� ) DESC
//
//  SELECT * 
//    FROM apdd 
//   WHERE CONTAINS ( definition, �science or history� )
//ORDER BY SCORE( 1 ) DESC 
//

/*STATIC FUNCTION CreateFTSIndexUsingSQL()
LOCAL cSql := "CREATE INDEX NOTES ON " +;
      "customers ( NOTES ) CONTENT MIN WORD 3 MAX WORD 30 "+ ;
      "NOISE 'about after all also an and another any are as at be because been before being "+;
      "between both but by came can come could did do does each else for from get got had has "+;
      "have he her here him himself his how if in into is it its just like make many me "+;
      "might more most much must my never now of on only or other our out over re said same see "+;
      "should since so some still such take than that the their them then there these they this "+;
      "those through to too under up use very want was way we well were what when where which while "+;
      "who will with would you your'"+;
      "DELIMITERS "+ chr(32)+chr(8)+chr(9)+chr(10)+chr(11)+chr(12)+chr(13)+;
      "DROPCHARS '`" + '"' + ;
      "CONDITIONALS ',.?!;:@#$%^&()-_' PAGESIZE 512 IN FILE "+ '"customers.adi";' + "'' );  "

   ExecuteSQL( cSql, ADS_ADT )
   
RETURN NIL */

//---------------------------------------------------------------------------------------------------------------
// ACE API function AdsCreateFTSIndex() receives:
//1. fileName
//2. tag 
//3. field 
//4. min word length defaults to 3
//5. max word length defaults to 30 
//6. use default delimiters defaults to true 
//7. delimiters 
//8. use default noise words defaults to true 
//9. noise words 
//10.use default drop chars defaults to true 
//11.drop chars 
//12.use default conditionals defaults to true
//13.conditionals 
//14.reserved 
//15.reserved 2 
//16.options.
STATIC FUNCTION CreateFTSIndexUsingACE()
LOCAL cAlias := "customers"

   AdsSetFileType( ADS_ADT )   
   dbUseArea( .T., "ADS", "customers", cAlias, .T. )

   ( cAlias )->( AdsCreateFTSIndex( 'customers.adi', 'notes', 'notes' ) )
   ( cAlias )->( dbCloseArea() )
   
RETURN NIL 


//---------------------------------------------------------------------------------------------------------------
//AdsEnableEncryption() ACE function is only applicable with free tables. 
//Free tables is the term used to describe .dbfs/.adts that are not associated
//or bound to an ADS data dictionary.  Whenever you are connecting to a directory
//of tables or simply opening tables without a connection is when tables are 
//considered as "free".
//The encryption process is done automatically with ADS DD bound tables.  For 
//example on how to encrypt DD bound tables look above on this sample code inside 
//function CreateIndexesUsingSQL() where table customers is encrypted using the 
//stored procedure sp_ModifyTableProperty().  Also look at function CreateOrConnect2DD() 
//where a DD wide password for encryption is set. 
//
//ALTER permissions on the table are required to encrypt or decrypt database tables. 
//
/*STATIC FUNCTION EncryptCustomersTable()
LOCAL cAlias := "Customers"
LOCAL nErr

   AdsSetFileType( ADS_ADT )   
   dbUseArea( .T., "ADS", "customers", "customers", .T. )

   ( cAlias )->( AdsEnableEncryption( "TableEncryptPasswordGoesHere" ) )

   IF ( nErr := ( cAlias )->( AdsEncryptTable() ) ) > 0
      MsgStop( "Error trying to encrypt table customers.  Error #" + cValToChar( nErr ) ) 
   ENDIF 
   
   ( cAlias )->( dbCloseArea() )
   
RETURN NIL 
*/


//---------------------------------------------------------------------------------------------------------------
//Referential integrity rules ensure we won't have orphan records.  Orphan records happen 
//when the sales table contains references to a customer that no longer exists 
//or whose customer_id has changed and therefore the "relationship" between parent-child
//records is lost.
//
//Referential Integrity (RI) is the means by which primary/foreign key relationships are enforced 
//in a database. By specifying RI rules you can have the database guarantee, for example, that every 
//sales representative is assigned to a valid office. Through the use of RI constraints, many business 
//rules can be enforced by the database server, instead of your application.
//
//Referential integrity restricts your ability to delete and change parent table records, 
//as well as prohibiting the insertion of child records for which there is no parent. 
//
//The terms "primary key" and "foreign key" are used on the samples rules shown on here.
//Primary Key - A unique identifier for a table. A column or column combination with the property that, 
//at any given time, no two rows of the table contain the same value in that column or column combination. 
//Foreign Key - A foreign key is a column or combination of columns whose values match the primary key 
//of some other table. A foreign key does not have to be unique; in fact, foreign keys are often in a 
//many-to-one relationship to a primary key. Foreign key values should be copies of the primary key values; 
//no value in the foreign key except NULL should ever exist unless the same value exists in the primary key. 
//A foreign key may be NULL; if any part of a composite foreign key is NULL, the entire foreign key is NULL. 
//
//Please keep in mind that Referential Integrity rules are stored in an Advantage Data Dictionary.
//Also, Referential Integrity is only supported with the Advantage proprietary tables and Visual FoxPro (VFP) tables. 
//This is because only ADT and VFP tables can guarantee unique indexes.
//
//When using RI with VFP tables, you should add "!DELETED()" conditions to your primary and foreign keys. 
//This will make sure that cascades are triggered when records are deleted. Without the !DELETED() clause, 
//the key value will not change when the record is deleted, and RI operation will not be triggered.

//Delete Rules
// RESTRICT - Prevents deletion of a row from a parent table if children of the row still exist in a child table. 
//    If applied to our example above, this would make it illegal to delete an office if any sales representatives were 
//    still assigned to the office. 
// CASCADE - When a parent row is deleted, automatically delete all child rows. If applied to our example above, deleting 
//    an office would automatically delete every sales representative assigned to the office. 
// SET_NULL - When a parent row is deleted, automatically set all foreign key values to NULL. If applied to our example 
//    above, this would make deleting an office set every sales representative�s office assignment to an unknown office. 
//    When using Visual FoxPro (VFP) tables, you should probably make sure that the foreign key field(s) can be NULL. 
//    If it does not have the NULL option, then the field(s) will be set to empty and the RI enforcement check will fail 
//    unless there is an empty parent key. 
// SET_DEFAULT - When a parent row is deleted, automatically set all foreign key values to their default values. 
//    If applied to our example above, this rule would assign sales representatives to some default office if their 
//    office were ever removed. The default office is stored within the data dictionary and is the default field value 
//    for the office field. 
//
//Update Rules
// RESTRICT - Prevents updating a primary key if foreign key values still exist in a child table. If applied to our example above, 
//    this would make it illegal to change an office number if sales representatives were still assigned to the office. 
// CASCADE - When a primary key is updated, automatically update all foreign key values. If applied to our example above, 
//    updating an office number would also update the REP_OFFICE field for each sales representative currently assigned to the office. 
// SET_NULL - When a primary key is updated, automatically set all foreign key values to NULL. If applied to our example above, 
//    this would make updates to the office number set every sales representative�s office assignment to an unknown office. 
//    When using Visual FoxPro (VFP) tables, you should probably make sure that the foreign key field(s) can be NULL. 
//    If it does not have the NULL option, then the field(s) will be set to empty and the RI enforcement check will fail 
//    unless there is an empty parent key. 
// SET_DEFAULT - When a primary key is updated, automatically set all foreign key values to their default values. 
//    If applied to our example above, this rule would assign sales representatives to some default office if their office 
//    number were ever updated. The default office is stored within the data dictionary and is the default field value 
//    for the office field. 
//
//Most importantly ADS DD referntial integrity rules can "restrict" a transaction where this relationship 
//is broken or it can "cascade" any changes on the parent record to all of its child records. 
//
//RI rule can be created using ACE API function AdsDDCreateRefIntegrity() or with SQL 
//stored procedure sp_CreateReferentialIntegrity().  I show how to use both below:
//
STATIC FUNCTION CreateRIRules()

   //IF !AdsDDCreateRefIntegrity( "Avoid Customer Orphan Sales Records",;//rule/object name on DD
   //                        "failedRIcustomersFromSales", ;        //table where failed transactions are saved to
   //                        "customers", ;                         //parent table
   //                        "cust_id", ;                           //parent relationship index tag 
   //                        "sales", ;                             //child table
   //                        "cust_id",;                            //child relationship index tag
   //                        ADS_DD_RI_CASCADE,;                    //delete rule 
   //                        ADS_DD_RI_RESTRICT )                   //update rule 
   //                        
   //   MsgStop( "Can't create referential integrity rule" )
   //   
   //ENDIF 
   
   //being that on our sample code table items is dbf/cdx table this rule can't be created.
   //AdsDDCreateRefIntegrity( "Avoid Item Orphan Sales Records",;
   //                        "failedRIcustomersFromItems",;
   //                        "items",;
   //                        "item_id",;
   //                        "sales",;
   //                        "item_id",;
   //                        ADS_DD_RI_CASCADE,;
   //                        ADS_DD_RI_RESTRICT )

   ExecuteSql( "EXECUTE PROCEDURE sp_CreateReferentialIntegrity (  "+;
       "'Avoid Customer Orphan Sales Records', "+;
       "'customers',  "+;
       "'sales',  "+;
       "'CUST_ID',  "+;
       "1,  "+;
       "2,  "+;
       "NULL, "+;
       "'',  "+;
       "'');  " )

               
RETURN NIL

//----------------------------------------------------------------------------------------------
//A group is like a user template for access rights. You begin by creating a group. You then grant to that 
//group all rights required by the group's members. You then assign individual users to the group. By default, 
//a user inherits all rights associated with the groups to which they belong.
//
//Groups are especially valuable when you have multiple users and want to easily administer their rights. Imagine, 
//for example, that you have created a group and granted all of its members read and write 
//(update, insert, and delete) access to all objects in a data dictionary. Later, we add a new object�a view, 
//for example�to the data dictionary. By granting rights for the view to the group, all that group's members 
//immediately gain rights to the view also. Without the group, you would have to modify the rights of each individual 
//user needing access to the view.
//
//The benefits of using groups increase even further when you have two or more types of users of your database. 
//For example, some applications have three levels of users: those who can only view data, those who can view 
//and add data, and those who have full access (including create, grant alter, and drop privileges, where create 
//is a dictionary-level privilege).
//
//To accommodate this scenario, you begin by creating three groups, with each group being granted the rights 
//associated with the type of users who will be members. Then, for each user you add to the data dictionary, 
//you assign them to whichever group they belong.  A given user can belong to two or more groups. A user's rights 
//are equal to the sum of the rights conveyed to the groups to which they belong.
//
//on sample code below we create two groups and assign permission to select from all tables and only insert into 
//customers and sales tables to group generalusers.  Another group named supervisors is created with 
//rights to select, insert, update and delete to all tables.
//
STATIC FUNCTION CreateUserGroups()
LOCAL cSql     := "Select * from system.usergroups;"
LOCAL cCursor  := ExecuteSql( cSql, ADS_ADT )
LOCAL aExistingGrps := {}

   ( cCursor )->( dbGoTop() )
   WHILE !(cCursor)->( eof() )
   
      AADD( aExistingGrps, ALLTRIM( LOWER( ( cCursor )->Name ) ) )
      (cCursor)->( dbSkip() )

   END 

   //create group generalusers and grant access to select from all tables 
   //but only to insert into customers and sales table.
   IF ASCAN( aExistingGrps, 'generalusers' ) == 0 
   
      cSql := "EXECUTE PROCEDURE sp_CreateGroup( "+;
               "'generalusers'," +;    //group name
               "'Granted select rights to all tables and insert into customers and sales table.' );" //comment

      ExecuteSql( cSql, ADS_ADT )
      
   ENDIF

   //create group supervisors and grant access to select, insert, update and delete from all tables 
   IF ASCAN( aExistingGrps, 'supervisors' ) == 0 
   
      cSql := "EXECUTE PROCEDURE sp_CreateGroup( "+;
               "'supervisors'," +;    //group name
               "'Granted select, insert, update, and delete rights to all tables.' );" //comment

      ExecuteSql( cSql, ADS_ADT )

   ENDIF

   //grant rights to groups
   cSql := ;
      "REVOKE SELECT, INSERT, UPDATE, DELETE ON [customers] FROM [generalusers]; \n" +;
      "REVOKE SELECT, INSERT, UPDATE, DELETE ON [sales] FROM [generalusers];\n"+;
      "REVOKE SELECT, INSERT, UPDATE, DELETE ON [items] FROM [generalusers];\n"+;
      "GRANT SELECT, INSERT ON [customers] TO [generalusers]; \n"  +;
      "GRANT SELECT, INSERT ON [sales] TO [generalusers]; \n"  +;
      "GRANT SELECT ON [items] TO [generalusers]; \n" +;
      "GRANT INSERT, UPDATE, DELETE ON [customers] TO [supervisors];\n" +;
      "GRANT INSERT, UPDATE, DELETE ON [sales] TO [supervisors];\n" +;
      "GRANT INSERT, UPDATE, DELETE ON [items] TO [supervisors];\n"

   ExecuteSql( cSql, ADS_ADT )


RETURN NIL 



//----------------------------------------------------------------------------------------------
//using stored procedure sp_addUserToGroup() to add a user to a group.  There is also 
//another related stored procedure named sp_RemoveUserFromGroup()
//
STATIC FUNCTION AssignUsersToGroups()
   LOCAL cSql := "SELECT Group_Name FROM system.usergroupmembers WHERE user_name ='$1$' AND Group_Name = '$2$'; "
   LOCAL cCursor 
   
   //add user user1 to group general users only if he is not already a member
   cCursor := ExecuteSql( SubstituteValuesIntoSQL( cSql, {"user1", "generalusers" } ), ADS_ADT )
   IF EMPTY( ( cCursor )->Group_Name )
      ExecuteSql( "EXECUTE PROCEDURE sp_addUserToGroup( 'user1', 'generalusers' );", ADS_ADT )
   ENDIF 

   cCursor := ExecuteSql( SubstituteValuesIntoSQL( cSql, {"user2", "generalusers" } ), ADS_ADT )
   IF EMPTY( ( cCursor )->Group_Name )
      ExecuteSql( "EXECUTE PROCEDURE sp_addUserToGroup( 'user2', 'generalusers' );", ADS_ADT )
   ENDIF 
   
   cCursor := ExecuteSql( SubstituteValuesIntoSQL( cSql, {"user3", "generalusers" } ), ADS_ADT )
   IF EMPTY( ( cCursor )->Group_Name )
      ExecuteSql( "EXECUTE PROCEDURE sp_addUserToGroup( 'user3', 'generalusers' );", ADS_ADT )
   ENDIF 

   cCursor := ExecuteSql( SubstituteValuesIntoSQL( cSql, {"user3", "supervisors" } ), ADS_ADT )
   IF EMPTY( ( cCursor )->Group_Name )
      ExecuteSql( "EXECUTE PROCEDURE sp_addUserToGroup( 'user3', 'supervisors' );", ADS_ADT )
   ENDIF 

RETURN NIL 

//------------------------------------------------------------------
//Triggers can be written using any development environment that can create Windows DLLs 
//(dynamic link libraries), Linux so (shared object) libraries, in-process COM (component object model) 
//objects, or .NET class libraries (.NET managed assemblies). Because each of these libraries can 
//have one or more triggers, they are referred to as trigger libraries or trigger containers.
//For the sake of simplicity our triggers here are SQL triggers.
//
//Advantage supports triggers on four types of events. These are record insertions (INSERT), 
//record updates (UPDATE), record deletions (DELETE), and replication conflicts (ON CONFLICT).
//For the first three trigger types, Advantage provides three event types. These are BEFORE triggers, 
//INSTEAD OF triggers, and AFTER triggers. 
//
//
STATIC FUNCTION CreateTriggers()
LOCAL cSql 

   DeleteExistingTriggers( "sales" ) 
   
   //Now Create Sales Table Triggers   
   cSql := ;
      "CREATE TRIGGER SaveDeletedSalesData ON sales BEFORE DELETE BEGIN \n"+;
      "                                               \n"+;
      "  DECLARE nTotalSale MONEY;                    \n"+;
      "  SET nTotalSale = ( SELECT totalsale FROM __old );\n"+;
      "  //record deleted information into auditlog table\n"+;
      "  INSERT INTO sales_Auditlog                   \n"+;
      "              SELECT o.*, 'Delete', Now(), User() \n"+;
      "                FROM __old o;                  \n"+;
      "                                               \n"+;
      ;//statement below used to generate a db notification to anyone listening
      ;//for the event.  It will be used to demonstrate event notificaitons with ADS
      ;//sp_SignalEvent() receives up to 4 parameters. (1) event name being fired
      ;//(2)wait for transaction commit? true or false 
      ;//(3)reserved for future use
      ;//(4)data to be sent to any listening connection about the event 
      "  EXECUTE PROCEDURE sp_SignalEvent( 'TotalSalesChange', false, 0, 'DELETE,'+ \n"+;
      "                                   CAST( now() AS SQL_CHAR ) + ',' + \n"+;
      "                                   CAST( ntotalsale AS SQL_CHAR ) );\n"+;
      "                                               \n"+;
      "END                                            \n"+;
      "PRIORITY 1 \n"

   ExecuteSql( cSql, ADS_ADT )


   cSql := ;
      "CREATE TRIGGER SaveUpdatedSalesData ON sales INSTEAD OF UPDATE BEGIN \n"+;
      "                                               \n"+;
      "  DECLARE nNewTotal MONEY;                     \n"+;
      "  DECLARE nOldTotal MONEY;                     \n"+;
      "                                               \n"+;
      "  DECLARE cCurCusts CURSOR AS                  \n"+;
      "  SELECT cust_id                               \n"+;
      "    FROM customers                             \n"+;
      "   WHERE cust_id = (SELECT cust_id FROM __new ); \n"+;
      "                                               \n"+;
      "  DECLARE cCurItems CURSOR AS                  \n"+;
      "  SELECT item_id                               \n"+;
      "    FROM items                                 \n"+;
      "   WHERE item_id = (SELECT item_id FROM __new ); \n"+;
      "                                               \n"+;
      "  OPEN cCurCusts;                              \n"+;
      "  OPEN cCurItems;                              \n"+;
      "                                               \n"+;
      "  IF NOT FETCH cCurCusts THEN                  \n"+;
      "     INSERT INTO __error VALUES ( 5177, 'Invalid Customer Id.' ) ;\n"+;
      "  ELSE                                         \n"+;
      "     IF NOT FETCH cCurItems THEN               \n"+;
      "         INSERT INTO __error VALUES ( 5177, 'Invalid Item Id.' ) ;\n"+;
      "     ELSE                                      \n"+;
      "         SET nNewTotal = ( SELECT IFNULL( units * price, 0.00 ) FROM __new );\n"+;
      "         SET nOldTotal = ( SELECT totalsale FROM __old );\n"+;
      "                                               \n"+;      
      "         //record update transaction into auditlog table \n"+;
      "         INSERT INTO sales_Auditlog                   \n"+;
      "              SELECT n.*, 'Update', Now(), User() \n"+;
      "                FROM __new n;                  \n"+;
      "                                               \n"+;
      "         UPDATE sales SET TotalSale =  nNewTotal,     \n"+;
      "             cust_id =(SELECT cust_id FROM __new ),\n"+;
      "             item_id = (SELECT item_id FROM __new),\n"+;
      "             units = (SELECT units FROM __new ),\n"+;
      "             notes = (SELECT notes FROM __new ),\n"+;
      "             price = (SELECT price FROM __new )\n"+;
      "         WHERE sales.invoice = ( SELECT invoice FROM __new );\n"+;
      "                                               \n"+;
      ;         //statement below used to generate a db notification to anyone listening
      ;         //for the event.  It will be used to demonstrate event notificaitons with ADS
      ;         //sp_SignalEvent() receives up to 4 parameters. (1) event name being fired
      ;         //(2)wait for transaction commit? true or false 
      ;         //(3)reserved for future use
      ;         //(4)data to be sent to any listening connection about the event 
      "         EXECUTE PROCEDURE sp_SignalEvent( 'TotalSalesChange', false, 0, 'UPDATE,' +\n"+;
      "                                   CAST( now() AS SQL_CHAR ) + ',' + \n"+;
      "                                   CAST( nNewTotal AS SQL_CHAR ) + ',' + \n"+;
      "                                   CAST( nOldTotal AS SQL_CHAR ) );\n"+;
      "                                               \n"+;
      "     END IF ;                                     \n"+;
      "  END IF ;                                     \n"+;
      "  CLOSE cCurItems ;                              \n"+;
      "  CLOSE cCurCusts ;                              \n"+;
      "END                                            \n"+;
      "PRIORITY 1 \n"

   ExecuteSql( cSql, ADS_ADT )

   cSql := ;
      "CREATE TRIGGER SaveInsertedDataAfterCalc ON sales INSTEAD OF INSERT BEGIN \n"+;
      "                                               \n"+;
      "  DECLARE nNewTotal MONEY ;                    \n"+;
      "  DECLARE cItemCur CURSOR AS                   \n"+;
      "                      SELECT item_id \n"+;
      "                        FROM items  \n"+;
      "                       WHERE item_id = (SELECT item_id FROM __new );\n"+;
      "  DECLARE cCustCur CURSOR AS                   \n"+;
      "                      SELECT cust_id \n"+;
      "                        FROM customers \n"+;
      "                       WHERE cust_id = (SELECT cust_id FROM __new );\n"+;
      "                                               \n"+;
      "  OPEN cCustCur ;                              \n"+;
      "  OPEN cItemCur ;                              \n"+;
      "                                               \n"+;
      "  IF NOT FETCH cCustCur THEN \n"+;
      "     INSERT INTO __error VALUES ( 5177, 'Invalid Customer Id.' ) ;\n"+;
      "  ELSE       \n"+;
      "     IF NOT FETCH cItemCur THEN \n"+;
      "         INSERT INTO __error VALUES ( 5177, 'Invalid Item Id.' ) ;\n"+;
      "     ELSE                                      \n"+;
      "         UPDATE __new                          \n"+;
      "            SET TotalSale = ( SELECT IFNULL( units * Price, 0.00 ) FROM __new ) ;  \n"+;
      "            SET nNewTotal = ( SELECT TotalSale FROM __new );\n"+;
      "                                               \n"+;
      "         //record insert transaction into auditlog table\n"+;
      "         INSERT INTO sales_Auditlog            \n"+;
      "             SELECT n.*, 'Insert', Now(), User() \n"+;
      "               FROM __new n;                   \n"+;
      "                                               \n"+;
      "         INSERT INTO sales SELECT * FROM __New ;   \n"+;
      "                                               \n"+;
      ;         //statement below used to generate a db notification to anyone listening
      ;         //for the event.  It will be used to demonstrate event notificaitons with ADS
      ;         //sp_SignalEvent() receives up to 4 parameters. (1) event name being fired
      ;         //(2)wait for transaction commit? true or false 
      ;         //(3)reserved for future use
      ;         //(4)data to be sent to any listening connection about the event 
      "         EXECUTE PROCEDURE sp_SignalEvent( 'TotalSalesChange', false, 0, 'INSERT,'+ \n"+;
      "                                   CAST( now() AS SQL_CHAR ) + ',' + \n"+;
      "                                   CAST( nNewTotal AS SQL_CHAR ) );\n"+;
      "                                               \n"+;
      "     END;                                      \n"+;
      "  END;                                         \n"+;
      "  CLOSE cCustCur ;                             \n"+;
      "  CLOSE cItemCur ;                             \n"+;
      "END                                            \n"+;
      "PRIORITY 1 \n"

   ExecuteSql( cSql, ADS_ADT )

   //-------------------------------------
   //Now Create items Table Triggers   
   DeleteExistingTriggers( "items" ) 

   cSql := ;
      "CREATE TRIGGER AvoidItemsOrphanSalesRecords ON items INSTEAD OF DELETE BEGIN \n"+;
      "                                               \n"+;
      "  DECLARE cCur CURSOR AS                       \n"+;
      "                  SELECT item_id               \n"+;
      "                    FROM sales                 \n"+;
      "                   WHERE item_id = (SELECT item_id FROM __old ) ;\n"+;
      "                                               \n"+;
      "  OPEN cCur ;                                  \n"+;
      "  TRY \n"+;
      "  //don't allow an item with sales to be deleted \n"+;
      "  IF FETCH cCur THEN                       \n"+;
      "     INSERT INTO __error VALUES ( 5177, 'Invalid delete operation.  Item has sales records.' ) ;\n"+;
      "  ELSE                                      \n"+;
      "     DELETE FROM items WHERE item_id = ( SELECT item_id FROM __old ); \n"+;
      "  END;                                         \n"+;
      "  CATCH ALL                                    \n" +;
      "  END;                                         \n"+;
      "  CLOSE cCur ;                                 \n"+;
      "END                                            \n"+;
      "PRIORITY 1                                     \n"

   ExecuteSql( cSql, ADS_ADT )

   //-------------------------------------
   //Now Create customers Table Triggers   
   DeleteExistingTriggers( "customers" ) 

   cSql := ;
      "CREATE TRIGGER AvoidCustomerOrphanSalesRecords ON customers INSTEAD OF DELETE BEGIN \n"+;
      "                                               \n"+;
      "  DECLARE cCur CURSOR AS                       \n"+;
      "                  SELECT cust_id               \n"+;
      "                    FROM sales                 \n"+;
      "                   WHERE cust_id = ( SELECT cust_id FROM __old );\n"+;
      "                                               \n"+;
      "  OPEN cCur ;                                  \n"+;
      "  //don't allow an customer with sales to be deleted \n"+;
      "  IF FETCH cCur THEN                       \n"+;
      "     INSERT INTO __error VALUES ( 5177, 'Invalid delete operation.  Customer has sales records.' ) ;\n"+;
      "  ELSE                                      \n"+;
      "     DELETE FROM customers WHERE Cust_id = (SELECT cust_id FROM __old );\n"+;
      "  END;                                         \n"+;
      "  CLOSE cCur ;                             \n"+;
      "END                                            \n"+;
      "PRIORITY 1 \n"

   ExecuteSql( cSql, ADS_ADT )

RETURN NIL 


//------------------------------------------------------------------
STATIC FUNCTION DeleteExistingTriggers( cTable ) 
   LOCAL cSql := "SELECT name FROM system.triggers WHERE Trig_Tablename = '$1$'"
   LOCAL cCursor
   LOCAL aTriggers := {}
   LOCAL cTrigger

   //let us first delete any exisiting triggers:
   cCursor := ExecuteSql( SubstituteValuesIntoSQL( cSql, { cTable } ), ADS_ADT )
   WHILE !( cCursor )->( eof() )
      AADD( aTriggers, (cCursor)->name )
      (cCursor)->( dbSkip() )
   END
   
   FOR EACH cTrigger IN aTriggers

      cSql := "DROP TRIGGER " + cTable + ".[" + alltrim( cTrigger ) + "]"
      ExecuteSql( cSql, ADS_ADT)

   NEXT

RETURN NIL 


//--------------------------------------------------------------------------------------
//centralize and export certain system wide functions out to the dd.  They will then 
//work from any client including mobile.
STATIC FUNCTION CreateSomeDDFunctions()
LOCAL cSql
LOCAL aExistingFuncs := {}
LOCAL oQ := TAdsQuery():New()


   //oQ:cSql := "Select CAST( name AS SQL_CHAR ) from system.functions"
   //oQ:run() 
   oQ:End()

   
   cSql := ;
      "DECLARE i INTEGER ; \n"+;
      "TRY \n"+;
      "  CREATE FUNCTION FullName( Last CHAR( 25 ), First CHAR( 25) ) \n"+;
      "  RETURNS CHAR( 80 )              \n"+;
      "  BEGIN                           \n"+;
      "     RETURN( Trim( Last ) + ', ' + Trim( First ) );\n"+;
      "  END;                             \n"+;
      "CATCH ADS_SCRIPT_EXCEPTION         \n"+;
      "END TRY                            \n"

   ExecuteSql( cSql, ADS_ADT)
      

   cSql := ;
      "DECLARE i INTEGER ;                                                    \n"+;
      "TRY                                                                    \n"+;
      "  CREATE FUNCTION recno( s_rowid CHAR ( 18 ) )                         \n" +;
      "  RETURNS INTEGER                                                      \n"+;
      "  DESCRIPTION 'Convert string row_id to isam recno() integer value'    \n"+ ;
      "  BEGIN                                                                \n"+ ;
      "  RETURN ( position( substring( s_rowid, 13, 1 ) in \n"+;
      "           'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')-1)*1073741824 + \n"+;
      "        (position(substring(s_rowid, 14, 1) in \n" + ;
      "           'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')-1)*16777216 + \n"+;
      "        (position(substring(s_rowid, 15, 1) in \n" + ;
      "           'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')-1)*262144 + \n"+;
      "        (position(substring(s_rowid, 16, 1) in \n"+ ;
      "           'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')-1)*4096 + \n"+;
      "        (position(substring(s_rowid, 17, 1) in \n"+;
      "           'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')-1)*64 + \n"+;
      "        (position(substring(s_rowid, 18, 1) in \n"+;
      "           'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')-1); \n" + ;
      "  END; \n"+;
      "CATCH ADS_SCRIPT_EXCEPTION         \n"+;
      "END TRY                            \n"

   ExecuteSql( cSql, ADS_ADT)

   cSql := ;
      "//-----------------------------------------------------------------------\n"+;
      "//Days in a month:                                                        \n"+;
      "DECLARE i INTEGER ;                                                    \n"+;
      "TRY                                                                    \n"+;
      "CREATE FUNCTION DaysInMonth( month INTEGER, year INTEGER )                \n"+;
      "RETURNS INTEGER                          \n"+;
      "BEGIN                                    \n"+;
      "    DECLARE @date1 TIMESTAMP;            \n"+;
      "    DECLARE @date2 TIMESTAMP;            \n"+;
      "    DECLARE @s STRING;                   \n"+;
      "    DECLARE @dtstring STRING;            \n"+;
      "                                         \n"+;
      "     @dtstring = '';                     \n"+;
      "                                         \n"+;
      "     //year 4 digits!                    \n"+;
      "     @s = trim( CONVERT( year, SQL_CHAR ) );   \n"+;
      "     @dtstring = REPEAT( '0', 4-length( @s ) ) + @s ; \n"+;
      "                                         \n"+;
      "     //month 2 digits                    \n"+;
      "     @s = TRIM( CONVERT( month, SQL_CHAR ) ); \n"+;
      "     @dtstring = @dtstring + '-' + REPEAT( '0', 2 - LENGTH( @s ) ) + @s; \n"+;
      "                                         \n"+;
      "     //day+time                          \n"+;
      "     @dtstring = @dtstring + '-01 00:00:00' ; \n"+;
      "     @date1 = convert( @dtstring, SQL_TIMESTAMP ); \n"+;
      "     @date2 = TimeStampAdd( SQL_TSI_MONTH, 1 , @date1 ) ;\n"+;
      "                                         \n"+;
      "     //returns Year-month-01 minus 1 day.\n"+;
      "     RETURN ( TimeStampDiff( SQL_TSI_DAY, @date1, @date2 ) ) ;\n"+;
      "                                         \n"+;
      "END; \n"+;
      "CATCH ADS_SCRIPT_EXCEPTION         \n"+;
      "END TRY                            \n"

   ExecuteSql( cSql, ADS_ADT)
      

   cSql := ;
      "//------------------------------------------------------------\n"+;
      "//End Of Month Function.  Send Month, Year                    \n"+;
      "DECLARE i INTEGER ;                                                    \n"+;
      "TRY                                                                    \n"+;
      "CREATE FUNCTION EoM( nMonth INTEGER, nYear INTEGER )          \n"+;
      "RETURNS TIMESTAMP                                             \n"+;
      "BEGIN                                                         \n"+;
      "                                                              \n"+;
      "    DECLARE nDays INTEGER ;                                   \n"+;
      "                                                              \n"+;
      "    nDays = DaysInMonth( nMonth, nYear );                     \n"+;
      "                                                              \n"+;
      "    RETURN CREATETIMESTAMP( nYear, nMonth, nDays, 23, 59, 59, 9 ) ;\n"+;
      "END;                                                          \n"+;
      "//------------------------------------------------------------\n"+;
      "CATCH ADS_SCRIPT_EXCEPTION         \n"+;
      "END TRY                            \n"

   ExecuteSql( cSql, ADS_ADT)


RETURN NIL 

//--------------------------------------------------------------------------------------
//Using Fw GUI here for convenience
STATIC FUNCTION ShowRealTimeSalesTotal()
LOCAL cCursor  := ExecuteSql( "SELECT Now() AS [Now], SUM( TotalSale ) AS [Total] FROM sales", ADS_ADT ) 
LOCAL aBrwInfo := { { "None    ", cValToChar( (cCursor)->Now ), 0.00, ( cCursor )->Total } }
LOCAL pThread
//LOCAL nTask    := HB_BackGroundAdd( {|| UpdateSalesDataBrw() }, 0, .F. )   //add to background tasks.

   //SET( _SET_BACKGROUNDTASKS, .T. )
   //HB_IdleWaitNoCPU( .T. )
   
   DEFINE DIALOG oDlg SIZE 600,300 PIXEL TITLE "Real time sales"

   @0,0 XBROWSE oBrw  ;
       AUTOCOLS ;
          ARRAY aBrwInfo ;
         HEADER "Event", "LastUpdate", "Changed", "TotalSales" ;
        JUSTIFY 3, 3, 1, 1 ;
           PICS Nil,Nil,"$9,999.99", "$99,999,999.99" ;
             OF oDlg 

   WITH OBJECT oBrw 

      :lRecordSelector     := .F.
      :nRowHeight          := 21
      :Changed:bClrStd  := { || IF( oBrw:Changed:Value == 0.00, {CLR_GREEN, CLR_WHITE}, ;
                                    IIF( oBrw:Changed:Value > 0, {CLR_BLACK, CLR_WHITE }, { CLR_HRED, CLR_WHITE } ) ) }
      :CreateFromCode()

   END 
   oDlg:oClient := oBrw

   ACTIVATE DIALOG oDlg ;
           ;//ON INIT ( HB_BackGroundActive( nTask, .T. ), HB_BackGroundRun( nTask ), oBrw:SetFocus() ) ;
           ;//  VALID ( HB_BackGroundDel( nTask ), .T. )
           ON INIT ( pThread := StartThread( {|| UpdateSalesDataBrw() } ), oBrw:SetFocus() );
             VALID ( StopThread( pThread ), .T. )


RETURN NIL 


//---------------------------------------------------------------------------------------
//using harbour's multi-treading capabilities to spawn a new thread.
//The new thread runs an infinite loop listening for db notificaitons.
STATIC FUNCTION UpdateSalesDataBrw()
LOCAL oQuery := TAdsQuery():New()
LOCAL cOper, nNewAmt, cWhen, nOldAmt
LOCAL nTmp, nDiff
LOCAL aRecord, a

   oQuery:cSql := "EXECUTE PROCEDURE sp_WaitForEvent('TotalSalesChange', 0, 0, 0 );"
   
   WHILE .T. 
   
      oQuery:Run() 
   
      IF oQuery:nRows > 0 

         FOR EACH aRecord IN oQuery:aResultSet

            //3 columns on each row: (1)Event, (2)Times it's been issued since last checked, (3)Data
            IF LEN( aRecord ) > 1 .AND. aRecord[ 2 ] == 0  ;LOOP ;ENDIF   

            //breake data sent on event into an array
            a := HB_ATOKENS( aRecord[ 3 ], "," )

            //Process notification only if number of times issued is > 0
            IF LEN( IFNIL( a, {} ) ) > 2 .AND. aRecord[ 2 ] > 0 

               cOper   := a[ 1 ]   //INSERT, UPDATE, OR DELETE transaction
               cWhen   := a[ 2 ]   //TimeStamp when operation took place
               nNewAmt := VAL( ALLTRIM( a[ 3 ] ) ) //total on transaction
               nOldAmt := IIF( LEN( a ) > 3, VAL( ALLTRIM( a[ 4 ] ) ), 0.00 ) //old total when Updating

               EVAL( oBrw:bGoBottom ) 
               nTmp := oBrw:TotalSales:Value()

               IIF( cOper == "DELETE", ( nNewAmt *= -1, nTmp += nNewAmt ),;
                  IIF( cOper == "INSERT", nTmp += nNewAmt, ;
                     ( nTmp := ( nTmp + nNewAmt - nOldAmt ), nNewAmt := nNewAmt - nOldAmt ) ) )   //reuse nNewAmt to save difference 
                  
               AADD( oBrw:aArrayData, { cOper, cWhen, nNewAmt, nTmp } )

               oBrw:Refresh()

            ENDIF

         NEXT 

      ENDIF 

      ThreadSleep( 2000 )
      
   END
    
   oQuery:End() 

RETURN NIL 

//---------------------------------------------------------------------------------------------------------------------
//STATIC FUNCTION adsbackup()
//Backups can be performed in various ways:
//1. Command line utility  c:\adsbackup.exe -pYourpasswordGoesHere "c:\AdsSourceData\DD.add" "c:\AdsTargetBackupDir\"
//2. Via SQL using stored procedure sp_BackupDatabase()
//    EXECUTE PROCEDURE sp_BackupDatabase( 'c:\AdsTargetBackupDir', 'c:\AdsSourceData' ); //complete
//    EXECUTE PROCEDURE sp_BackupDatabase( 'c:\AdsTargetBackupDir', 'PrepareDiff' ); //prepare for diff backup
//    EXECUTE PROCEDURE sp_BackupDatabase( 'c:\AdsTargetBackupDir', 'Diff' );       //execute diff backup
//    EXECUTE PROCEDURE sp_BackupFreeTables( 'c:\AdsSourceData', '*.dbf', 'c:\AdsTargetBackupDir', 'include=cust.adt', NULL );
//3. Via Arc32.  Right-click on dd connection and choose menu option backup.
/*  Using AdsBackup.exe command line utility:
Advantage Database Server Backup Utility
Usage:
       Free Table Backup
          adsbackup [options] <src path> <file mask> <dest path>
       Data Dictionary Backup
          adsbackup [options] <src database> <dest path>
Valid options include:
   -a  Prepare a database for a differential backup
   -c[ANSI|OEM|<dynamic collation>]  Character type (default ANSI)
       The dynamic collations include the VFP-compatible collations that are
       loaded at runtime.  Refer to the help file for the collation names.
   -d  Don't overwrite existing backup tables
   -e<file1, .. ,filen>  Exclude file list
   -f  Differential backup
   -h[ON|OFF]  Rights checking (default ON)
   -i<file1, .. ,filen>  Include file list
   -m  Backup metadata only
   -n<path>  Path to store the backup output table
   -o<filepath>  Path and filename to the backup output table
   -p  Password(s): Database user password if source path is a database
                    List of free table passwords if source path is a directory
                    Free table usage can pass a single password for all
                    encrypted tables, or a name/value pair for each table, for
                    example, "table1=pass1;table2=pass2"
   -q[PROP|COMPAT]  Locking mode, proprietary or compatible (default PROP)
   -r  Restore database or free table files
   -s<server path|connection string>
                    Connection path of ADS server to perform backup or restore or
                    a connection string
   -u[ADT|CDX|VFP|NTX]  Table type of backup output table (default ADT)
   -v[1-10]  Lowest level of error severity to return (default 1)
   -w  Table Type Map used to perform a free table backup or restore with
       mixed table types. Used to provide the table type for each table
       extension. For example, -wadt=ADS_ADT,dbf=ADS_CDX
   -x  Don't create the output table if no errors are logged
   -y  Database user name (if using a non-AdsSys user)

For the options that require values, the space between the option and the value
is not required.  For example, -pPassword and -p Password are equivalent.

Examples:
   adsbackup -pPass \\server\share\mydata.add \\server\share\backup
   adsbackup -pTablePass \\server\share *.adt \\server\share\backup
   adsbackup -r -pPass \\server\share\backup\mydata.add \\server\share\backup\mydata.add
   adsbackup -r -pTablePass \\server\share\backup \\server\share

   The following example (entered as a single command) shows how to use the
   -s option to provide a connection string specifying FIPS mode and a TLS
   connection.
   adsbackup -s "Data Source=\\server\share\;CommType=TLS; \
             FIPS=TRUE;TLSCertificate=c:\path\clientcert.pem; \
             TLSCommonName=www.myserver.com;DDPassword=dictionarypass;" \
             \\server\share\mydata.add \\server\share\backup

-------------------------------------------------------------------------------------------------------------*/

STATIC FUNCTION SaveItems()
LOCAL Self     := HB_QSelf()
LOCAL oBrw     := ::uSource
LOCAL lAppend  := ( Empty( ::RecNo ) .or. oBrw:nLen < 1 )
LOCAL cKey     := iif( lAppend, ::aData[ 1, 2 ], oBrw:item_id:value() )
LOCAL fld  
LOCAL oQ       := TadsQuery():New() 

   if ::lReadOnly .or. ! ::Modified()
      return .f.
   endif

   cKey := PADL( ALLTRIM( cKey ), 15, "0" ) 
   
   oQ:lShowErrors := .T. 
   oQ:cSql := ;
      "MERGE INTO items ON item_id = '$1$' \n"+;
      "WHEN MATCHED THEN UPDATE SET [Desc] = :Desc, Price = :Price \n"+;
      "WHEN NOT MATCHED THEN INSERT ( item_id, [Desc], Price ) \n"+;
      "                       VALUES( '$1$',  :Desc, :Price )\n"

   oQ:aSubstitutes := { cKey } //, ::aData[ 2, 2 ] , cValToChar( ::aData[ 3, 2 ] )  }

   oQ:AdsPrepareSQL()
   oQ:SetParameters( { { "Desc", ::aData[ 2, 2 ], "C" },;
                     { "Price", ::aData[ 3, 2 ], "N" } } )
   oQ:RunAdsPreparedSql() 
   oQ:End() 

   //avoid pesky "discarted changes" message from TDataRow class.
   FOR fld := 1 TO LEN( ::aData )
      ::aOrg[ fld, 2 ] := ::aData[ fld, 2  ]
   NEXt 

   oBrw:Refresh()

RETURN .T.


//-------------------------------------------------------------------------------------------------------------
STATIC FUNCTION SaveCustomers()
LOCAL Self     := HB_QSelf()
LOCAL oBrw     := ::uSource
LOCAL lAppend  := ( ::RecNo == 0 .or. ( bof() .and. eof() ) )
LOCAL uSaveBm  := oBrw:BookMark
LOCAL cKey     := iif(  lAppend, ::aData[ 1, 2 ], oBrw:cust_id:Value() )
LOCAL oQ       := TadsQuery():New() 
LOCAL fld  

   IF ::lReadOnly .or. ! ::Modified()
      return .f.
   ENDIF

   oQ:lShowErrors := .t. 
   oQ:cSql := ;
      "MERGE INTO customers ON cust_id = '$1$' \n"+;
      "WHEN MATCHED THEN UPDATE SET Customer_name = :Name, Notes= :Notes \n"+;
      "WHEN NOT MATCHED THEN INSERT ( cust_id, Customer_name, Notes) \n"+;
      "                       VALUES( '$1$', :Name, :Notes)\n"

   oQ:aSubstitutes := { cKey } 
   oQ:AdsPrepareSQL()
   oQ:SetParameters( { { "Name", ::aData[ 3, 2 ], "C" },;
                     { "Notes", ::aData[ 9, 2 ], "C" } } )
   oQ:RunAdsPreparedSql() 
   oQ:End() 

   //avoid pesky "discarted changes" message from TDataRow class.
   FOR fld := 1 TO LEN( ::aData )
      ::aOrg[ fld, 2 ] := ::aData[ fld, 2  ]
   NEXt 


RETURN .T.

//-------------------------------------------------------------------------------------------------------------
STATIC FUNCTION SaveSales()
LOCAL Self     := HB_QSelf()
LOCAL oBrw     := ::uSource
LOCAL lAppend  := ( ::RecNo == 0 .or. ( bof() .and. eof() ) )
LOCAL cKey     := iif(  lAppend, ::aData[ ::fieldPos( "invoice" ), 2 ], oBrw:Invoice:Value()  )
LOCAL oQ       := TadsQuery():New() 
LOCAL fld 

   if ::lReadOnly .or. ! ::Modified()
      return .f.
   endif

   oQ:lShowErrors := .t. 
   oQ:cSql := ;
      "MERGE INTO sales ON invoice = '$1$' \n"+;
      "WHEN MATCHED THEN UPDATE SET cust_id= :Cust, Item_id= :Item, Price = :price, units = :units \n"+;
      "WHEN NOT MATCHED THEN INSERT ( cust_id, item_id, Price, units ) \n"+;
      "                       VALUES( :cust, :Item, :Price, :Units )\n"

   oQ:aSubstitutes := { cKey } 
   oQ:AdsPrepareSQL()
   oQ:SetParameters( { { "cust", PADL( ALLTRIM( ::aData[ ::FieldPos( "cust_id" ), 2 ] ), 10, "0" ), "C" },;
                     { "item", PADL( ALLTRIM( ::aData[ ::FieldPos( "item_id" ), 2 ] ), 15, "0" ), "C" },;
                     { "units", ::aData[ ::FieldPos( "units" ), 2 ], "I" },;
                     { "price", ::aData[ ::FieldPos( "price" ), 2 ], "N" } } )
   oQ:RunAdsPreparedSql() 
   oQ:End() 

   //avoid pesky "discarted changes" message from TDataRow class.
   FOR fld := 1 TO LEN( ::aData )
      ::aOrg[ fld, 2 ] := ::aData[ fld, 2  ]
   NEXt 

RETURN .T.