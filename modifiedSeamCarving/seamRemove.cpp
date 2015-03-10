#include <string.h> /* Needed for memcpy() */
#include "mex.h"
#include "matrix.h"

#define MIN(a,b)  ((a)<(b) ? (a) : (b))

void seamRemove(char           *a,
                double         *x,
                char           *b,
                const int      *dim_array,
                int            ndim,
                int            elementSize)
{
    int rows = dim_array[0];
    int cols = dim_array[1];
    int nchannels;
    
    if( ndim==2 ) {
        nchannels = 1;
    } else {
        nchannels = dim_array[2];
    }
    
    for( int i=0; i<nchannels; i++ ) {
        for( int j=0; j<rows; j++ ) {
            if( (x[j]-1)<0 || (x[j]-1)>cols-1 ) {
                printf("x[%d]-1=%lf [0,%d]\n",j,x[j]-1,cols-1);
                mexErrMsgTxt("xpath outside bounds.");
            }            
            for( int k=0; k<(int)x[j]-1; k++ ) {
                memcpy( b+elementSize*(i*rows*(cols-1)+k*rows+j), 
                        a+elementSize*(i*rows*cols+k*rows+j), 
                        (size_t)elementSize );
            }
            for( int k=(int)x[j]-1; k<cols-1; k++ ) {            
                memcpy( b+elementSize*(i*rows*(cols-1)+k*rows+j), 
                        a+elementSize*(i*rows*cols+(k+1)*rows+j), 
                        (size_t)elementSize );
            }
        }
    }
}


/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  /* Declare variables. */ 
  int           ndim;  
  char          *a;
  double        *x;
  char          *b;
  const int     *in_dim_array; 
  int           *out_dim_array;
  int           elementSize;
 
  /* Check for proper number of input and output arguments. */    
  if (nrhs != 2) {
    mexErrMsgTxt("Two input argument required.");
  } 
  if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments.");
  }
  
  /* Get number of dimensions */
  ndim = mxGetNumberOfDimensions(prhs[0]);
  
  /* Get the number of dimensions in the input argument. */
  in_dim_array = mxGetDimensions(prhs[0]);
  
  /* Create output array. */
  out_dim_array = (int *)mxMalloc( ndim*sizeof(*in_dim_array) );
  memcpy(out_dim_array, in_dim_array, ndim*sizeof(*in_dim_array));
  out_dim_array[1]--;
  plhs[0] = mxCreateNumericArray(ndim,out_dim_array,mxGetClassID(prhs[0]),mxREAL);

  /* Get element size */
  elementSize = mxGetElementSize(prhs[0]);
   
  /* Get the data */
  a = (char*)mxGetData(prhs[0]);
  x = (double*)mxGetData(prhs[1]);
  b = (char*)mxGetData(plhs[0]);
  seamRemove( a, x, b, in_dim_array, ndim, elementSize );
  
  mxFree(out_dim_array);

}