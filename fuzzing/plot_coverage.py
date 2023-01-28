#!/usr/bin/python

import argparse
import json
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import os
from scipy.interpolate import interp1d
from matplotlib.lines import Line2D

# Code for manually adding labels modeled from following:
# https://stackoverflow.com/questions/39500265/manually-add-legend-items-python-matplotlib

"""Plot data found at each path in JSON_PATHS"""
def plot_json(do_average, json_paths, csv, plt_file):

    data_per_path = load_json(json_paths)
    plot_data = []
    for i, (data, json_files) in enumerate(data_per_path):
        plot_data += get_plot_data(do_average, data, json_files, json_paths[i])
    for x, y, lbl in plot_data:
        plt.step(x, y, where='post', label=lbl)

    if csv is not None:
        write_csv(plot_data, csv)

    # Configure and show plot
    plt.title("Coverage Over Time")
    plt.ylabel("Cumulative coverage %")
    plt.yticks([x for x in range(0, 110, 10)])
    plt.xlabel("Seconds")

    colors = ['darkorange', 'royalblue', 'green']
    lines = [Line2D([0], [0], color=c, linewidth=2, linestyle='-') for c in colors]
    labels = ['Zeros Seed', 'Relevant Seed', 'Zeros Seed -- Only Valid']
    manual_legend = False
    if manual_legend:
        plt.legend(lines, labels)
    else:
        plt.legend()

    if plt_file is None:
        plt.show()
    else:
        plt.savefig(plt_file)


# translate directory name to CSV headers
_headers = {
    "i2c-line-cov": ["line-x", "line"],
    "i2c-mux-toggle": ["mux-x", "mux"],
    "i2c-mux-and-line-cov": ["mux-line-x", "mux + line"],
}

def write_csv(plot_data, csv):
    # write header
    labels = [e[2].split()[-1] for e in plot_data]
    header = []
    for lbl in labels:
        header += _headers[lbl]
    print(", ".join(header), file=csv)

    # write data
    max_len = max(len(e[0]) for e in plot_data)
    for ii in range(max_len):
        row = []
        for e in plot_data:
            if len(e[0]) <= ii:
                row += ["", ""]
            else:
                row += [f"{e[0][ii]}", f"{e[1][ii]}",]
        print(", ".join(row), file=csv)


"""Gets plotting data from JSON files found recursively at each path in JSON_PATHS.
   Return: List of tuples (INPUT_DATA, JSON_FILENAMES) for each path"""
def load_json(json_paths):
    json_files_per_path = [recursive_locate_json([json_path]) for json_path in json_paths]

    for i, names in enumerate(json_files_per_path):
        assert names, "Path contains no JSON files: {}".format(json_paths[i])

    data_per_path = []
    for json_files in json_files_per_path:
        files = [open(file, 'r') for file in json_files]
        data = [json.load(file) for file in files]
        [file.close() for file in files]
        data_per_path.append((data, json_files))
    return data_per_path


"""Locates all paths to JSON files. Searches recursively within folders.
   Input (JSON_PATHS): List of files and folders that contain JSON files. 
   Return: List of all JSON files at JSON_PATHS."""
def recursive_locate_json(json_paths):
    json_files = []

    for path in json_paths:
        if os.path.isfile(path) and path.split(".")[-1].lower() == "json":
            json_files.append(path)
        elif os.path.isdir(path):
            subpaths = [os.path.join(path, subpath) for subpath in os.listdir(path)]
            json_files.extend(recursive_locate_json(subpaths))

    return json_files



def get_plot_data(do_average, json_data, json_files, json_path):
    plotting_data = [extract_plotting_data(input) for input in json_data]

    # Plot data (Averaging code modeled from RFUZZ analysis.py script: https://github.com/ekiwi/rfuzz)
    if do_average:
        # Collects all times seen across passed in JSON files
        all_times = []
        [all_times.extend(creation_times) for (creation_times, _) in plotting_data]
        all_times = sorted(set(all_times))

        all_coverage = np.zeros((len(plotting_data), len(all_times)))
        for i, (creation_times, cumulative_coverage) in enumerate(plotting_data):
            # Returns function which interpolates y-value(s) when passed x-value(s). Obeys step function, using previous value when interpolating.
            interp_function = interp1d(creation_times, cumulative_coverage, kind='previous', bounds_error=False, assume_sorted=True)
            # Interpolates coverage value for each time in all_times. Saved to all_coverage matrix
            all_coverage[i] = interp_function(all_times)
        means = np.mean(all_coverage, axis=0)
        return [(all_times, means, "Averaged: " + json_path)]

    else:
        out = []
        for i in range(len(plotting_data)):
            (creation_time, cumulative_coverage) = plotting_data[i]
            out.append((creation_time, cumulative_coverage, json_files[i]))


"""Extract plotting data from a single JSON file's data"""
def extract_plotting_data(input_data):
    creation_times = []
    cumulative_coverage = []
    for input in input_data['coverage_data']:
        creation_times.append((input['creation_time']))
        cumulative_coverage.append(input["cumulative_coverage"] * 100)

    # Extract end time from JSON file and add it to plotting data
    creation_times.append(input_data['end_time'])
    cumulative_coverage.append(cumulative_coverage[-1])

    assert len(creation_times) == len(cumulative_coverage), "NUMBER OF TIMES SHOULD EQUAL NUMBER OF COVERAGE READINGS"

    return creation_times, cumulative_coverage


def find_fuzzer_dirs(path: Path):
    if not path.is_dir():
        return []
    if (path / "queue").is_dir():
        return [path]
    subfolders = [Path(f) for f in os.scandir(path) if f.is_dir()]
    res = []
    for p in subfolders:
        res += find_fuzzer_dirs(p)
    return res

def main():
    parser = argparse.ArgumentParser(description='Script to plot fuzzing results', formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--do-average', action="store_true", help='Average plotting data per path')
    parser.add_argument('--plot-file', help='png file to save plot to instead of showing the plot in a window')
    parser.add_argument('--csv', type=argparse.FileType('w', encoding='UTF-8'), help='csv file to store results to')
    parser.add_argument('fuzzer_paths', metavar='PATH', nargs='+', help='Output paths from the fuzzer.\nAdd multiple paths to plot against each other')
    args = parser.parse_args()

    do_average = args.do_average

    for path in args.fuzzer_paths:
        if not Path(path).exists():
            raise argparse.ArgumentTypeError("PATH DOES NOT EXIST: {}".format(path))

    plot_json(do_average, args.fuzzer_paths, args.csv, args.plot_file)
    if args.csv: args.csv.close()

if __name__ == "__main__":
    main()
