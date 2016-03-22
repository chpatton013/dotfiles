import itertools
import os
import rospkg
rospack = rospkg.RosPack()

def getDefaultFlags():
    return [
        '-Wall',
        '-Wextra',
        '-Wno-unused-result',
        '-Weffc++',
        '--pipe',
        '-std=c++11',
        '-x', 'c++',
    ]

def getSystemIncludeFlags():
    return getIncludePaths('-isystem', [
        '/usr/include',
        '/usr/local/include',
        '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1',
        '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/6.0/include',
        '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include',
        '/System/Library/Frameworks',
        '/System/Library/Frameworks/Python.framework/Headers',
    ])

def getRosIncludeFlags():
    paths = []

    # Project workspace
    ros_workspace = os.environ.get('ROS_WORKSPACE')
    if ros_workspace:
        paths += [os.path.join(ros_workspace, 'devel', 'include')]

    # Project packages
    paths += [
        os.path.join(rospack.get_path(path), 'include')
        for path in rospack.list()
    ]

    # System workspace
    ros_system_workspace = '/opt/ros'
    if os.path.isdir(ros_system_workspace):
        paths += [
            os.path.join(path, 'include')
            for path in reversed(os.listdir(ros_system_workspace))
        ]

    return getIncludePaths('-isystem', paths)

def getBazelWorkspace(filename):
    while len(filename) > 0:
        filename = os.path.dirname(filename)
        if os.path.exists(os.path.join(filename, 'WORKSPACE')):
            return filename
    return None

def getBazelIncludePaths(filename):
    workspace = getBazelWorkspace(filename)
    if workspace is None:
        return []
    else:
        return getIncludePaths('-I', [workspace])

def getQtIncludeFlags():
    paths = [
        '/usr/include/qt4',
        '/usr/include/qt4/QtCore',
    ]
    return getIncludePaths('-isystem', paths)

def getLocalIncludeFlags():
    return getIncludePaths('-I', ['.', './include'])

def getIncludePaths(prefix, paths):
    paths = filter(lambda path: os.path.exists(path), set(paths))
    return list(itertools.chain.from_iterable(
     itertools.izip([prefix] * len(paths), paths)))

def IsHeaderFile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in ['.hpp', '.hxx', '.hh', '.h', '.inl', '.impl']

def FlagsForFile(filename, **kwargs):
    return {
        'flags': \
                getDefaultFlags() + \
                getSystemIncludeFlags() + \
                getRosIncludeFlags() + \
                getBazelIncludePaths(filename) + \
                getQtIncludeFlags() + \
                getLocalIncludeFlags(),
        'do_cache': True
    }
