#!/bin/python
import os, subprocess
import logging

from autotest.client import test
from autotest.client.shared import error

class xorg_x11_font_utils(test.test):

    """
    Autotest module for testing basic functionality
    of xorg_x11_font_utils

    @author Nilesh Borate, nilesh.borate@in.ibm.com
    """
    version = 1
    nfail = 0
    path = ''

    def initialize(self):
        """
        Sets the overall failure counter for the test.
        """
        self.nfail = 0
        logging.info('\n Test initialize successfully')

    def run_once(self, test_path=''):
        """
        Trigger test run
        """
        try:
            os.environ["LTPBIN"] = "%s/shared" %(test_path)
            ret_val = subprocess.call(test_path + '/xorg_x11_font_utils' + '/xorg-x11-font-utils.sh', shell=True)
            if ret_val != 0:
                self.nfail += 1

        except error.CmdError, e:
            self.nfail += 1
            logging.error("Test Failed: %s", e)

    def postprocess(self):
        if self.nfail != 0:
            logging.info('\n nfails is non-zero')
            raise error.TestError('\nTest failed')
        else:
            logging.info('\n Test completed successfully ')

