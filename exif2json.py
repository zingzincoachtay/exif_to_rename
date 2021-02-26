#!/usr/bin/python

import sys,json,re
### Available only through Python 2.7
import exifread

txt = [];
exif = {};
#with open(sys.argv[1],encoding='utf8') as txt2exif:
with open(sys.argv[1]) as txt2exif:
  for t2e in txt2exif:
    txt.append( t2e.strip() )
  for t in txt:
    with open(t,'rb') as F:
      data = exifread.process_file(F)
    #for tag in data.keys():
    #  if not re.search('JPEGThumbnail|TIFFThumbnail|MakerNote',tag):
    #    print "%s#\t#%s" % (tag,data[tag])
    try:
      timestamp = str( data['EXIF DateTimeOriginal'] )
      #if re.search('dng$',t,re.IGNORECASE) : print ("Warning: '%s' may have EXIF." % (t))
    except:
      #if not re.search('jpg$',t,re.IGNORECASE) : print ("Warning: '%s' may not have EXIF." % (t))
      continue
    try:
      modTS = timestamp.replace(':','-',2)
    except:
      print ("Warning: could not recognize the timestamp (date) from %s." % (timestamp) )
      continue
    try:
      prefix = modTS.replace(':','.',2)
    except:
      print ("Warning: could not recognize the timestamp (time) from %s." % (timestamp) )
      continue
    if t.find(prefix)<0 :
      print( '%s\t%s' % (t,prefix) )
    #exif.update( {t:prefix} )
#print json.dumps( exif )

