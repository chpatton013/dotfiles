import os
import ycm_core

DATABASE_FILE = "compile_commands.json"

PATH_FLAGS = ["-I", "-iquote", "-isystem", "--sysroot="]

HEADER_DIRECTORIES = [
    "hdr",
    "header",
    "include",
    "public",
    "Public",
]

SYSTEM_PATHS = [
    "/usr/include",
    "/usr/include/c++/4.8",
    "/usr/include/c++/4.8/backward",
    "/usr/include/x86_64-linux-gnu",
    "/usr/include/x86_64-linux-gnu/c++/44.8",
    "/usr/local/include",
    "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include",
    "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1",
    "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/6.0/include",
    "/System/Library/Frameworks",
    "/System/Library/Frameworks/Python.framework/Headers",
]

COMMON_FLAGS = [
    "-Wall",
    "-Werror",
    "-Wextra",
    "-Weffc++",
    "--pipe",
    "-std=c++14",
    "-x", "c++",
    # This flag is only needed for YCM.
    "-DUSE_CLANG_COMPLETER",
]

def _interleave(prefix, elements):
    """
    Interleave the prefix before each element in the given list.
    """
    result = []
    for el in elements:
        if os.path.exists(el):
            result.append(prefix)
            result.append(el)
    return result

def _find_parent_dir_with_file(directory, filename, root=None):
    """
    Recursively search in parent directory until filename is found.
    Returns the path to the first directory where filename was found.
    """
    if not root:
        root = "/"

    non_trivial_directory = lambda d: d and d != root
    file_exists_in_dir = \
        lambda d, f: os.path.exists(os.path.join(directory, filename))
    while non_trivial_directory(directory) and \
            not file_exists_in_dir(directory, filename):
        directory = os.path.dirname(directory)
    return directory if file_exists_in_dir(directory, filename) else None

def _find_uncle_dir(filename, uncle, root=None):
    """
    Recursively search in parent directory until a sibling directory with the
    given name is found.
    Returns the path to the parent's sibling directory, or None.
    """
    directory = _find_parent_dir_with_file(
            os.path.dirname(filename),
            uncle,
            root=root)
    if directory:
        return os.path.join(directory, uncle)
    else:
        return None

def default_flags(filename):
    """
    Get a set of default flags without using a compile-commands database for
    accurate information. This is a best-guess heuristic based on common project
    directory structures.
    """
    # Use a default set of system-include paths.
    system_paths = SYSTEM_PATHS[:]
    # Put the dirname of the file first on the local include pathlist.
    local_paths = [os.path.dirname(filename)]

    # Search for an include directory in parent directories of this file.
    # Put this last on the local and system include pathlists.
    directory = _find_uncle_dir(filename, "include")
    if directory:
        local_paths.append(directory)
        system_paths.append(directory)

    system_include_paths = _interleave("-isystem", system_paths)
    local_include_paths = _interleave("-iquote", local_paths)

    return COMMON_FLAGS + system_include_paths + local_include_paths

def compilation_info(filename):
    """
    Lookup file-specific compilation information from a compile-commands
    database.
    """
    database_dir = _find_parent_dir_with_file(os.path.dirname(filename),
                                              DATABASE_FILE)
    if not database_dir:
        return None

    database = ycm_core.CompilationDatabase(database_dir)
    return database.GetCompilationInfoForFile(filename)

def flags_and_directory(filename):
    """
    Lookup compilation information for the given file.
    Prefer to use flags from a compile-commands database.
    If that is not available, fallback to a default set of flags.
    """
    info = compilation_info(filename)
    if info:
        return info.compiler_flags_, info.compiler_working_dir_

    flags = default_flags(filename)
    include_dir = _find_uncle_dir(filename, "include")
    if include_dir:
        return flags, include_dir
    else:
        return flags, os.path.dirname(filename)

def flags_relative_to_absolute(flags, directory):
    """
    Find all flags that start with (or are preceeded by) path-indicators and
    transform them to workspace-relative paths.
    """
    relative_to_absolute = \
            lambda path: os.path.join(os.path.abspath(directory), path)

    absolute_flags = []
    # flags is neither iterable nor indexible by standard means. It must be
    # iterated over using a for loop. Therefore, we must carry state across
    # iterations of this loop to apply transformations to future tokens.
    make_next_absolute = False
    for flag in flags:
        # If we found the previous flag within our PATH_FLAGS list, we will have
        # assumed that this flag was meant to be transfomed.
        if make_next_absolute:
            absolute_flags.append(relative_to_absolute(flag))
            make_next_absolute = False
            continue

        # If a flag is exactly equal to something in our PATH_FLAGS list, we can
        # assume that the following flag is the relevant path for the flag.
        if flag in PATH_FLAGS:
            absolute_flags.append(flag)
            make_next_absolute = True
            continue

        # If a flag starts with something in PATH_FLAGS list, we can can
        # partition the string into the path-flag portion, and the path that is
        # relevant to the flag.
        for path_flag in PATH_FLAGS:
            if flag.startswith(path_flag):
                _, _, path = flag.partition(path_flag)
                absolute_flags.append(path_flag + relative_to_absolute(path))
                break
        # Otherwise this flag was not related to a path at all, so we can add it
        # to our new list without modification.
        else:
            absolute_flags.append(flag)
    return absolute_flags

def FlagsForFile(filename, **kwargs):
    filename = os.path.expanduser(filename)
    flags, directory = flags_and_directory(filename)
    return {
        "flags": flags_relative_to_absolute(flags, directory),
        "do_cache": True,
    }
