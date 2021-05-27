#!/usr/bin/env python3
import os, sys, json, collections



def is_cov_anno(a):
    return 'class' in a and a['class'] == 'chiseltest.coverage.TestCoverage' and 'counts' in a

def load_cov(filename: str) -> list:
    with open(filename) as ff:
        annos = json.load(ff)
    return [a['counts'] for a in annos if is_cov_anno(a)]

def merge(counts: list):
    result = collections.defaultdict(int)
    for c in counts:
        for e in c:
            for k,v in e.items():
                result[k] += v

    return dict(result)

def to_anno(merged):
    counts = []
    for k,v in merged.items():
        counts.append({k: v})
    return {"class": "chiseltest.coverage.TestCoverage", "counts": counts}

def main():
    files = sys.argv[1:]
    if len(files) == 0:
        print("Please provide one or more cover.json files as arguments")
    else:
        counts = []
        for f in files:
            counts += load_cov(f)
        print(f"Loaded {len(counts)} coverage result(s) for {len(counts[0])} coverage counter(s).")
        merged = merge(counts)
        print(f"Merged into {len(merged)}")
        with open("merged.cover.json", "w") as f:
            json.dump([to_anno(merged)], f)
        print("saved to merged.cover.json")

if __name__ == '__main__':
    main()
