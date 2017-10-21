#!/usr/bin/env python3

import argparse
import os
import sys

def _config_dir():
    return os.path.join(
        os.path.dirname(os.path.realpath(__file__)),
        "config")

def _platform():
    return "macos" if sys.platform == "darwin" else "linux"

def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--config_dir", default=_config_dir())
    parser.add_argument("-o", "--output_file", default="-")
    parser.add_argument(
        "-p",
        "--platform",
        choices=["linux", "macos"],
        default=_platform())
    return parser.parse_args(argv)

def main(argv=None):
    args = parse_args(argv=argv)

    paths = [
        os.path.join(args.config_dir, "alacritty.1.yml"),
        os.path.join(
            args.config_dir,
            "alacritty.2.{platform}.yml".format(platform=args.platform),
        ),
    ]
    files = [open(p).read() for p in paths]

    if args.output_file == "-":
        output_file = sys.stdout
    else:
        output_file = open(args.output_file, "w")

    output_file.write("\n".join(files))

if __name__ == "__main__":
    main(argv=sys.argv[1:])
