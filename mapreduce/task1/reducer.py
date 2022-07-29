#!/usr/bin/env python3
import random
import sys

random.seed(636)
length_left = random.randint(1, 5)
curr_out = ""

for line in sys.stdin:
        try:
                _, id = line.strip().split('.', 1)
        except ValueError as e:
                continue

        if length_left > 1:
                curr_out += id + ','
                length_left -= 1
        else:
                curr_out += id
                print(curr_out)
                curr_out = ""
                length_left = random.randint(1, 5)
print(curr_out.strip(','))

