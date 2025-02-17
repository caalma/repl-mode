#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
expression = sys.stdin.read().strip()

try:
    result = eval(expression)
    print(result)
except Exception as e:
    print(f"Error: {e}")
