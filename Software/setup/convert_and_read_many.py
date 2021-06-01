#!/usr/bin/env python

import glob
import logging
import smbus
from MCP342x import MCP342x

import numpy as np


__author__ = 'Alan Childs'
__version__ = '0.0.1'
__license__ = 'MIT'


def get_smbus():
    candidates = []
    prefix = '/dev/i2c-'
    for bus in glob.glob(prefix + '*'):
        try:
            n = int(bus.replace(prefix, ''))
            candidates.append(n)
        except:
            pass
        
    if len(candidates) == 1:
        return smbus.SMBus(candidates[0])
    elif len(candidates) == 0:
        raise Exception("Could not find an I2C bus")
    else:
        raise Exception("Multiple I2C busses found")


#logging.basicConfig(level='DEBUG')

logger = logging.getLogger(__name__)

bus = get_smbus()

# Create objects for each signal to be sampled
addr68_ch0 = MCP342x(bus, 0x68, channel=0, resolution=12)
addr68_ch1 = MCP342x(bus, 0x68, channel=1, resolution=12)

# Create a list of all the objects. They will be sampled in this
# order, unless any later objects can be sampled can be moved earlier
# for simultaneous sampling.
adcs = [addr68_ch0, addr68_ch1]
r = MCP342x.convert_and_read_many(adcs, samples=2)
print('return values: ')
print(r)

print(addr68_ch1.convert_and_read( scale_factor=3.01942319011 ))
