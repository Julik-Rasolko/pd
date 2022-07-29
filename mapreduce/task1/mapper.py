#!/usr/bin/env python3

import sys
import random

random.seed(666)

for id in sys.stdin:
        print ("{}.{}".format(random.randint(1, 100), id.strip()))

