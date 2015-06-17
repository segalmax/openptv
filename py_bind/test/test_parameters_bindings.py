import unittest
from optv.parameters import MultimediaParams, ShakingParams
import numpy

class Test_Parameters_binding(unittest.TestCase):
    def test_mm_np_instantiation(self):
        
        n2_np = numpy.array([11,22,33])
        d_np = numpy.array([55,66,77])
        
        m = MultimediaParams(nlay=3, n1=2, n2=n2_np, d=d_np, n3=4, lut=1)
        
        self.failUnlessEqual(m.get_nlay(), 3)
        self.failUnlessEqual(m.get_n1(), 2)
        self.failUnlessEqual(m.get_n3(), 4)
        self.failUnlessEqual(m.get_lut(), 1)
        
        numpy.testing.assert_array_equal(m.get_d(), d_np)
        numpy.testing.assert_array_equal(m.get_n2(), n2_np)
        
        self.failUnlessEqual(m.__str__(), "nlay=\t3 \nn1=\t2.0 \nn2=\t{11.0, 22.0, 33.0}"
                             + " \nd=\t{55.0, 66.0, 77.0} \nn3=\t4.0 \nlut=\t1 ")
    
    def test_shaking_par_instantiation(self):
        
        # manually assign values to ShakingParams object and check the assignments were made correctly
        sp1 = ShakingParams(222, 333, 444, 555)
        
        self.failUnlessEqual(sp1.get_seq_first(), 222)
        self.failUnlessEqual(sp1.get_seq_last(), 333)
        self.failUnlessEqual(sp1.get_max_shaking_points(), 444)
        self.failUnlessEqual(sp1.get_max_shaking_frames(), 555)
       
        # checking C read_shaking_par function
        # read shaking parameters from a file and
        # verify the parameters were read correctly according to contents of specified file 
        sp1.read_shaking_par("testing_fodder/parameters/shaking.par")
        self.failUnlessEqual(sp1.get_seq_first(), 410000)
        self.failUnlessEqual(sp1.get_seq_last(), 411055)
        self.failUnlessEqual(sp1.get_max_shaking_points(), 100)
        self.failUnlessEqual(sp1.get_max_shaking_frames(), 3)
        
        # manually assigning values exactly like in the shaking parameters testing file 
        # to another ShakingParams object 
        sp2 = ShakingParams(410000, 411055, 100, 3)
        
        self.failUnlessEqual(sp2.get_seq_first(), 410000)
        self.failUnlessEqual(sp2.get_seq_last(), 411055)
        self.failUnlessEqual(sp2.get_max_shaking_points(), 100)
        self.failUnlessEqual(sp2.get_max_shaking_frames(), 3)
        
        # now we have two identical ShakingParams objects (sp1 and sp2) for comparison
        # PLEASE NOTE that Python will perform the comparison through function defined in ShakingParams class:
        # def __richcmp__ (ShakingParams self, ShakingParams other, operator):  
        # The third parameter is an integer value to indicate the operation performed: 2 for '=' , 3 for '!=' (you must refer to them separately). 
        # For more info: http://docs.cython.org/src/userguide/special_methods.html#rich-comparisons
        # So in order to check the comparisons '==' as well as '!=' must be passed:
        self.assertTrue(sp1==sp2)
        self.assertFalse(sp1!=sp2)
        
        #change one attribute in sp2 and assert the results of equality comparison are now inverted
        sp2.set_max_shaking_frames(-999)
        self.assertFalse(sp1==sp2)
        self.assertTrue(sp1!=sp2)
        
        
if __name__ == "__main__":
    unittest.main()
