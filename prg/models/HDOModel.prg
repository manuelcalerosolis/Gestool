CLASS HDOModel
   METHOD new( table ) COSNTRUCTOR          
   METHOD setTable( cTabla )
   METHOD getTable()  
   METHOD setPrimaryKey( cPrimaryKey )
   METHOD getPrimaryKey()
   METHOD setTimeStamps( cTimeStamps )
   METHOD getTimeStamps()
   METHOD setColumns( aColumnsName )

   // $flight = App\Flight::find(1);
   // $flights = App\Flight::find([1, 2, 3]);
   METHOD find( aPrimaryKey )

   // $model = App\Flight::findOrFail(1);
   METHOD findOrFail( aPrimaryKey )

   // $model = App\Flight::where('legs', '>', 100)->firstOrFail();
   METHOD firstOrFail( aPrimaryKey )

   // $count = App\Flight::where('active', 1)->count();
   METHOD Count()

   // $max = App\Flight::where('active', 1)->max('price');
   METHOD Max( cField )

   // Inserting & Updating Models----------------------------------------------
   // $flight = new Flight;
   // $flight->name = 'Boing';
   // $flight->save();
   METHOD store( model )

   // $flight = App\Flight::find(1);
   // $flight->name = 'New Flight Name';
   // $flight->save();
   METHOD save( model )

   // App\Flight::where('active', 1)
   //        ->where('destination', 'San Diego')
   //        ->update(['delayed' => 1]);
   METHOD update( hashTable )

   // Retrieve flight by name, or create it if it doesn't exist...
   // $flight = App\Flight::firstOrCreate(['name' => 'Flight 10']);
   // Retrieve flight by name, or create it with the name and delayed attributes...
   //$flight = App\Flight::firstOrCreate(
   //    ['name' => 'Flight 10'], ['delayed' => 1]
   //);
   METHOD firstOrCreate( hashTable )

   // Retrieve by name, or instantiate...
   // $flight = App\Flight::firstOrNew(['name' => 'Flight 10']);
   // Retrieve by name, or instantiate with the name and delayed attributes...
   // $flight = App\Flight::firstOrNew(
   //     ['name' => 'Flight 10'], ['delayed' => 1]
   // );
   METHOD firstOrNew( hashTable )

   // If there's a flight from Oakland to San Diego, set the price to $99.
   // If no matching model exists, create one.
   //$flight = App\Flight::updateOrCreate(
   //    ['departure' => 'Oakland', 'destination' => 'San Diego'],
   //    ['price' => 99]
   //);
   METHOD updateOrCreate( hashTable )

   // $flight = App\Flight::find(1);
   // $flight->delete();
   // $deletedRows = App\Flight::where('active', 0)->delete();
   METHOD delete()

   // App\Flight::destroy(1);
   // App\Flight::destroy([1, 2, 3]);
   // App\Flight::destroy(1, 2, 3);
   METHOD destroy()

   METHOD where( cWhere )              
   METHOD orderBy( uOrder )
   METHOD take( nRec )
   METHOD get( nType ) // hashtable o array   
   METHOD getAsArray()
   METHOD getAsHash()
END CLASS   