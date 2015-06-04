# Implementation of Python binding to parameters.h
from libc.stdlib cimport malloc, free
import numpy
from __builtin__ import False
from optv.parameters import ShakingParams

cdef extern from "optv/parameters.h":
    shaking_par * c_read_shaking_par "read_shaking_par"(char * file_name)
    int c_compare_shaking_par "compare_shaking_par"(shaking_par * s1, shaking_par * s2)
    
cdef class MultimediaParams:
    
    def __init__(self, nlay, n1, n2, d, n3, lut):
        
        self._mm_np = < mm_np *> malloc(sizeof(mm_np))
        
        self.set_nlay(nlay)
        self.set_n1(n1)
        self.set_n2(n2)
        self.set_d(d)
        self.set_n3(n3)
        self.set_lut(lut)
    
    def get_nlay(self):
        return self._mm_np[0].nlay
    
    def set_nlay(self, nlay):
        self._mm_np[0].nlay = nlay
        
    def get_n1(self):
        return self._mm_np[0].n1
    
    def set_n1(self, n1):
        self._mm_np[0].n1 = n1
        
    def get_n2(self):  # TODO return numpy
        arr_size = sizeof(self._mm_np[0].n2) / sizeof(self._mm_np[0].n2[0])
        n2_np_arr = numpy.empty(arr_size)
        for i in range(len(n2_np_arr)):
            n2_np_arr[i] = self._mm_np[0].n2[i]
        return n2_np_arr
    
    def set_n2(self, n2):
        for i in range(len(n2)):
            self._mm_np[0].n2[i] = n2[i]
            
    def get_d(self):
        arr_size = sizeof(self._mm_np[0].d) / sizeof(self._mm_np[0].d[0])
        d_np_arr = numpy.empty(arr_size)
        
        for i in range(len(d_np_arr)):
            d_np_arr[i] = self._mm_np[0].d[i]
        return d_np_arr
        
    def set_d(self, d):
        for i in range(len(d)):
            self._mm_np[0].d[i] = d[i]
        
    def get_n3(self):
        return self._mm_np[0].n3
    
    def set_n3(self, n3):
        self._mm_np[0].n3 = n3
        
    def get_lut(self):
        return self._mm_np[0].lut
    
    def set_lut(self, lut):
        self._mm_np[0].lut = lut
        
    def __str__(self):
        n2_str = "{"
        for i in range(sizeof(self._mm_np[0].n2) / sizeof(self._mm_np[0].n2[0]) - 1):
            n2_str = n2_str + str(self._mm_np[0].n2[i]) + ", "
        n2_str += str(self._mm_np[0].n2[i + 1]) + "}"
        
        d_str = "{"
        for i in range(sizeof(self._mm_np[0].d) / sizeof(self._mm_np[0].d[0]) - 1) :
            d_str += str(self._mm_np[0].d[i]) + ", "
            
        d_str += str(self._mm_np[0].d[i + 1]) + "}"
        
        return "nlay=\t{} \nn1=\t{} \nn2=\t{} \nd=\t{} \nn3=\t{} \nlut=\t{} ".format(
                str(self._mm_np[0].nlay),
                str(self._mm_np[0].n1),
                n2_str,
                d_str,
                str(self._mm_np[0].n3),
                str(self._mm_np[0].lut))
        
    def __dealloc__(self):
        free(self._mm_np)
            
# Wrapping the shaking_par C struct for pythonic access
# Binding the read_shaking_par C function
# Objects of this type can be checked for equality using "==" and "!=" operators 
cdef class ShakingParams:
        
    def __init__(self, seq_first, seq_last, max_shaking_points, max_shaking_frames):
        self._shaking_par = < shaking_par *> malloc(sizeof(shaking_par))
        self.set_seq_first(seq_first)
        self.set_seq_last(seq_last)
        self.set_max_shaking_points(max_shaking_points)
        self.set_max_shaking_frames(max_shaking_frames)
        
    # Reads shaking parameters from specified full file path 
    def read_shaking_par(self, file_name):
        self._shaking_par = c_read_shaking_par(file_name)
    
    # Checks for equality between this and other ShakingParams objects
    # Gives the ability to use "==" and "!=" operators on two ShakingParams objects
    def __richcmp__(ShakingParams self, ShakingParams other, operator):
        if (operator==2): # "==" action was performed
            if (c_compare_shaking_par(self._shaking_par,
                                    other._shaking_par) != 0):
                return True
            else:
                return False
        else:
            if(operator==3): # "!=" action was performed
                return not self==other # change the operator to "==" and recursively check the opposite 
               
    # Getters and setters  
    def get_seq_first(self):
        return self._shaking_par[0].seq_first
    
    def set_seq_first(self, seq_first):
        self._shaking_par[0].seq_first = seq_first
        
    def get_seq_last(self):
        return self._shaking_par[0].seq_last
    
    def set_seq_last(self, seq_last):
        self._shaking_par[0].seq_last = seq_last
        
    def get_max_shaking_points(self):
        return self._shaking_par[0].max_shaking_points
    
    def set_max_shaking_points(self, max_shaking_points):
        self._shaking_par[0].max_shaking_points = max_shaking_points
        
    def get_max_shaking_frames(self):
        return self._shaking_par[0].max_shaking_frames
    
    def set_max_shaking_frames(self, max_shaking_frames):
        self._shaking_par[0].max_shaking_frames = max_shaking_frames
    
    # Memory freeing
    def __dealloc__(self):
        free(self._shaking_par)
