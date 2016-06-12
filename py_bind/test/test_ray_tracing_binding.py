import unittest
from optv.parameters import MultimediaParams, ControlParams
from optv.calibration import Calibration

from optv.ray_tracing import ray_tracing
import numpy as np, os, filecmp, shutil

class Test_ray_tracing(unittest.TestCase):
    def setUp(self):
        self.rows = 2
        self.input = np.full((self.rows, 2), 100)
        
        # create and initialize Calibration instance for testing 
        self.cal = Calibration()
        
        self.cal.set_pos(np.array([0., 0., 100.])) 
        self.cal.set_angles(np.array([0., 0., 0.]))
        self.cal.set_primary_point(np.array([0., 0., 100.]))
        self.cal.set_glass_vec(np.array([0.0001, 0.00001, 1.]))
        self.cal.set_radial_distortion(np.array([0., 0., 0.]))
        self.cal.set_decentering(np.array([0, 0]))
        self.cal.set_affine_trans(np.array([1, 0]))
        
        self.mult = MultimediaParams(n1=1.,
                                     n2=np.array([1.49, 0., 0.]),
                                     n3=1.33,
                                     d=np.array([5., 0., 0.]))
        
    def test_dimensions_check(self):
        with self.assertRaises(TypeError):
            ray_tracing(self.input,
                        self.cal,
                        self.mult,
                        verts_out=np.full((self.rows + 1, 3), 99),  # wrong number of rows
                        directs_out=np.full((self.rows, 3), 88))
        with self.assertRaises(TypeError):
            ray_tracing(self.input,
                        self.cal,
                        self.mult,
                        verts_out=np.full((self.rows, 3), 99),
                        directs_out=np.full((self.rows, 2), 88))  # wrong number of columns
        
    def test_ray_tracing_function(self):
        
        correct_verts_out = np.array([[ 96.32625809, 96.32649965, 0.98940412],
                                      [ 96.32625809, 96.32649965, 0.98940412]])
        correct_directs_out = np.array([[ 0.43406242, 0.43409439, -0.78939969],
                                        [ 0.43406242, 0.43409439, -0.78939969]])
        
        out_tuple = ray_tracing(self.input,
                                self.cal,
                                self.mult,
                                verts_out=np.full((self.rows, 3), 99),
                                directs_out=np.full((self.rows, 3), 88))
        
        np.testing.assert_array_almost_equal(out_tuple[0], correct_verts_out, decimal=7)
        np.testing.assert_array_almost_equal(out_tuple[1], correct_directs_out, decimal=7)
        
    def tearDown(self):
        pass

if __name__ == "__main__":
    unittest.main()
