#!/usr/bin/env python

import glob
import subprocess

from setuptools import Extension, setup


def get_pkg_config(package):
    try:
        cflags = subprocess.check_output(
            ["pkg-config", "--cflags-only-I", package]
        ).decode("utf-8")
        include_dirs = [flag[2:].strip() for flag in cflags.split()]

        libs = subprocess.check_output(["pkg-config", "--libs-only-l", package]).decode(
            "utf-8"
        )
        libraries = [lib[2:].strip() for lib in libs.split()]

        lib_dirs = subprocess.check_output(
            ["pkg-config", "--libs-only-L", package]
        ).decode("utf-8")
        library_dirs = [lib[2:].strip() for lib in lib_dirs.split()]

        return {
            "include_dirs": include_dirs,
            "libraries": libraries,
            "library_dirs": library_dirs,
        }
    except subprocess.CalledProcessError, FileNotFoundError:
        return {
            "include_dirs": ["/usr/include/libxml2"],
            "libraries": ["xml2"],
            "library_dirs": [],
        }


xml_flags = get_pkg_config("libxml-2.0")

setup(
    ext_modules=[
        Extension(
            name="ovirtsdk4.xml",
            sources=sorted(glob.glob("ext/*.c")),
            **xml_flags,  # type: ignore
        ),
    ]
)
