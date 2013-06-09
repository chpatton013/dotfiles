#!/usr/bin/env python

import argparse
import fnmatch
import random
import subprocess
import sys
import time
import os

dfltImgDir = '~/Pictures'
dfltImgFmts = ('jpg', 'jpeg', 'gif', 'png')
dfltTimeMin = 10
dfltTimeMax = 15
dfltFileFilter = '*'

imgDir = dfltImgDir
imgFmts = dfltImgFmts
timeMin = dfltTimeMin
timeMax = dfltTimeMax
fileFilter = dfltFileFilter

def clParse():
   global imgDir
   global timeMin
   global timeMax
   global fileFilter

   parser = argparse.ArgumentParser(description=
    'Randomize desktop background.')
   parser.add_argument('-d', '--dir', action='store', default=dfltImgDir,
    type=str, help='Image directory. Default: \'{0}\'.'.format(dfltImgDir))
   parser.add_argument('-t', '--time', action='store', nargs=2,
    default=[dfltTimeMin, dfltTimeMax], type=int,
    help='Minimum and maximum time (in minutes) between wallpaper switches.' +
    ' Default: \'{0} {1}\'.'.format(dfltTimeMin, dfltTimeMax) +
    ' \'0 0\' prevents wallpaper switching.')
   parser.add_argument('-f', '--filter', action='store',
    default=dfltFileFilter, type=str, help='RegEx filter for filenames.' +
    ' Default: \'{0}\'.'.format(dfltFileFilter))

   args = parser.parse_args()

   imgDir = args.dir
   timeMin = args.time[0]
   timeMax = args.time[1]
   fileFilter = args.filter

   if (timeMin < 0 or timeMax < 0):
      sys.stderr.write('Times must be non-negative.\n')
      exit(1)
   if (timeMin > timeMax):
      sys.stderr.write('Minimum time cannot be greater than maximum time.\n')
      exit(1)

def getImages():
   images = []
   for folder, subs, files in os.walk(imgDir):
      for filename in files:
         fullFilePath = folder + '/' + filename
         if filename.endswith(imgFmts) and fnmatch.fnmatch(
          filename, fileFilter):
            images.append(fullFilePath)

   return images

def run():
   images = getImages()
   if len(images):
      image = random.choice(images)
      subprocess.call(['feh', '--bg-fill', image])
      sleepTime = random.uniform(timeMin, timeMax) * 60
      time.sleep(sleepTime)

clParse()
if (timeMin == 0 and timeMax == 0):
   run()
else:
   while os.getppid():
      run()
