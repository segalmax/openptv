from optv.calibration cimport Calibration, calibration
from optv.parameters cimport MultimediaParams, mm_np

import numpy as np
cimport numpy as np

def ray_tracing(np.ndarray[ndim=2, dtype=np.float_t] input,
               Calibration cal,
               MultimediaParams mult_params,
               np.ndarray[ndim=2, dtype=np.float_t] verts_out=None,
               np.ndarray[ndim=2, dtype=np.float_t] directs_out=None):
    
    # check arrays dimensions
    if input.shape[1] != 2:
        raise TypeError("Input matrix must have two columns "
                        "(each row for a 2d coordinate).")
   
    output_arrs = [verts_out, directs_out]
    for i in range(len(output_arrs)): 
        if output_arrs[i] != None:
            if output_arrs[i].shape[1] != 3:
                raise TypeError("Output matrix for directs and/or vertexes must "
                                "have three columns (each row for a 3d coordinate).")
            elif input.shape[0] != output_arrs[i].shape[0]:
                raise TypeError("Unmatching number of rows in input and output arrays: " 
                                + str(input.shape[0]) + " != " + str(output_arrs[i].shape[0])) 
        else:
            # if no array passed for output - create it
            output_arrs[i] = np.empty(shape=(input.shape[0], 3), dtype=float)
        # make output arrays contiguous for efficient manipulation on C side
        output_arrs[i] = np.ascontiguousarray(output_arrs[i])
        
    verts_out = output_arrs[0]
    directs_out = output_arrs[1]

    for i in range(len(input)):
        c_ray_tracing(  input[i, 0],
                        input[i, 1],
                        cal._calibration,
                        mult_params._mm_np[0],
                        < double *> np.PyArray_GETPTR2(verts_out, i, 0),
                        < double *> np.PyArray_GETPTR2(directs_out, i, 0))
     
    return (verts_out, directs_out)

  
