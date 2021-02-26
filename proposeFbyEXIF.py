#!/usr/bin/python

import sys,json,re

txt = [];
exif = {};
#with open(sys.argv[1],encoding='utf8') as txt2exif:
with open(sys.argv[1]) as json2propose:
  names = json.load(json2propose)
  for name in names:
    u,v = name,names[name]
    try:
      o = re.search('^(.+\/)([^\/]+)(\.\w{3,4})$',u,re.IGNORECASE).groups()
    except:
      o = ['','','']
    if ! re.search('\d{4}\-\d{2}\-\d{2} ',u,re.IGNORECASE) :
      print( 'mv --backup=numbered "%s" "%s%s %s%s"' % (u,o[0],v,o[1],o[2]) )

