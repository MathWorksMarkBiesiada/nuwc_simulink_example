/*
 * File: _coder_main_entry_point_api.h
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 16-Oct-2017 14:21:28
 */

#ifndef _CODER_MAIN_ENTRY_POINT_API_H
#define _CODER_MAIN_ENTRY_POINT_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_main_entry_point_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern real_T main_entry_point(real_T u);
extern void main_entry_point_api(const mxArray * const prhs[1], const mxArray
  *plhs[1]);
extern void main_entry_point_atexit(void);
extern void main_entry_point_initialize(void);
extern void main_entry_point_terminate(void);
extern void main_entry_point_xil_terminate(void);

#endif

/*
 * File trailer for _coder_main_entry_point_api.h
 *
 * [EOF]
 */
