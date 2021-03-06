
cdef extern from "optv/calibration.h":
    ctypedef double Dmatrix [3][3]

    ctypedef struct Exterior:    
        double  x0, y0, z0
        double  omega, phi, kappa
        Dmatrix dm

    ctypedef struct Interior:
        double xh, yh
        double cc
    
    ctypedef struct Glass:
        double vec_x, vec_y, vec_z
        
    ctypedef struct ap_52:
        double k1, k2, k3, p1, p2, scx, she
        
    ctypedef struct calibration "Calibration":
        Exterior ext_par
        Interior int_par
        Glass glass_par
        ap_52 added_par
        
cdef class Calibration:
    cdef calibration * _calibration
