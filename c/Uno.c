#define TAM     5

void sumcon( int *, int, int )

//----------------------------------------------------------------------------//

void main()
{
    static int array[TAM] = {3,5,7,9,11};
    int konst = 10;
    int j;

    sumacon( array, TAM, konst );
    for ( j=0; j < TAM; j++ )
             printf( "%d ", *( array + j ) );
}

//----------------------------------------------------------------------------//

void sumacon( int *ptr, int num, int con )
{
    int k;
    for( k=0, k < num, k++ )
            *(ptr+k) = *(ptr+k) + con;
}

//----------------------------------------------------------------------------//
