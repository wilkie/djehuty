module core.util;

// Contains many templates and other magical functions

template eval( A... )
{
    const typeof(A[0]) eval = A[0];
}