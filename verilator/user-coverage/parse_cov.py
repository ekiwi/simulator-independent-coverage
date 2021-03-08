#!/usr/bin/env python3

data = open('coverage.dat', 'rb').read()
lines = [l[4:-3] for l in data.split(b"\n") if l.startswith(b"C '")]
lines = [ {e[0]: e[1] for e in  (e.split(b"\x02") for e in l.split(b"\x01"))} for l in lines]
for l in lines:
  print(l)
