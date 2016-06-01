from optv.calibration cimport Calibration, calibration
from optv.parameters cimport MultimediaParams, mm_np

cdef extern from "optv/parameters.h":
    void c_ray_tracing "ray_tracing"(double x
                                      , double y
                                      , calibration * cal
                                      , mm_np mm
                                      , double X[3]
                                      , double a[3])
