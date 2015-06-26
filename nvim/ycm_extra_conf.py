import os
import ycm_core

flags = [
   '-Wall',
   '-Wextra',
   '-Wno-unused-result',
   '--pipe',
   '-std=c++11',
   '-x', 'c++',
   '-isystem', '/usr/include',
   '-isystem', '/usr/local/include',
   '-isystem', '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1',
   '-isystem', '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/6.0/include',
   '-isystem', '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include',
   '-isystem', '/System/Library/Frameworks',
   '-isystem', '/System/Library/Frameworks/Python.framework/Headers',
   '-I', '.',
   '-I', 'include',
   '-I', '~/include',
]


def IsHeaderFile(filename):
   extension = os.path.splitext(filename)[1]
   return extension in ['.hpp', '.hxx', '.hh', '.h', '.inl', '.impl']

def FlagsForFile(filename, **kwargs):
   return {
      'flags': flags,
      'do_cache': True
   }
