
export PicDir=$1
if [ -z "$PicDir" ]; then
  PicDir=/media/pi/JUKE/Pictures/
fi

if [ -e Pictures.txt ]; then
  rm Pictures.txt
fi
if [ -e Pictures.sh ]; then
  rm Pictures.sh
fi

export safemv='mv --backup=numbered'
export dupF1=01_simpledfiles.sh
export dupF2=02_simpledincrements.sh
export dupF3=03_simpledextension_LC2UC.sh
export dupF4=04_simpledsuffix.sh
find $PicDir -type f -name "._*" -exec rm "{}" +
find $PicDir -type f -name ".DS_Store" 

export cmdreq1fdupes='fdupes'
if ! [ $( command -v $cmdreq1fdupes ) ]; then
  echo Needs $cmdreq1fdupes. sudo apt install $cmdreq1fdupes  && exit
else
  if [ -s $dupF1 ]; then
    fdupes -r $PicDir > $dupF1
    echo Verify $dupF1 && exit
  fi
fi
find $PicDir -type f | grep -P "( copy| \(\d{1,2}\)| \d{1,2})\.[A-z0-9]{3,4}" > $dupF2 
if [ -s $dupF2 ] && false ; then
  export rmdup2="s/^((.+)(?: copy| \(\d{1,2}\)| \d{1,2})(\.[A-z0-9]{3,4}))/${safemv} \"\\\1\" \"\\\2\\\U\\\3\"/"
  echo Verify $dupF2, then: perl -i -pe \'$rmdup2\' $dupF2  && exit
fi
find $PicDir -type f | grep -P "\.[a-z0-9]{3,4}\~?" > $dupF3
perl -i -ne 'print if !/zip$|pdf$|ppt.?$/i' $dupF3
if [ -s $dupF3 ] ; then
  export rmdup3="s/^((.+)(\.[a-z0-9]{3,4})(?:\.\~\w{1,2}\~)?)$/$safemv \"\\\1\" \"\\\2\\\U\\\3\"/"
  echo Verify $dupF3, then: perl -i -pe \'$rmdup3\' $dupF3  && exit
fi
find $PicDir -type f | grep -P "\~\w{1,2}\~$" > $dupF4
if [ -s $dupF4 ]; then
  export rmdup4="s/^((.+)\.\~\w{1,2}\~)$/$safemv \"\\\1\" \"\\\2\"/"
  echo Verify $dupF4, but this non-empty file is okay for now.
  echo Then, perl -i -pe \'$rmdup4\' $dupF4 
fi

echo Show the increment suffix that ends with a dash and a integer.
find $PicDir -type f | grep -P "\-\d{1,2}\."

find $PicDir -type f > Pictures.txt
if ! [ -s Pictures.txt ]; then
  #perl -i -ne 'print if /jpg$|dng$/i' Pictures.txt
  perl -i -ne 'print if !/gif$|png$|zip$|mov$|m4v$|mp4$|avi$|mod$|pdf$|ppt.?$/i' Pictures.txt
  perl -i -ne 'print if !/\d{4}\-\d{2}\-\d{2} \d{2}\.\d{2}\.\d{2}/' Pictures.txt
fi

export cmdreq1exif='xml2json'
if ! [ $( command -v $cmdreq1exif ) ]; then
  echo Needs $cmdreq1exif. sudo apt install $cmdreq1exif
  exit
fi
if ! [ -e Pictures.json ]; then
  echo Skipped EXIFinXML2JSON approach
  #sed 's/^\(.\+\)$/exif -x "\1"/' Pictures.txt > Pictures.sh
  #sh Pictures.sh > Pictures.xml
  #sed -i '1 i\<xml>' Pictures.xml && sed -i '$ a\</xml>' Pictures.xml
  ### https://github.com/hay/xml2json/blob/master/README.md
  # xml2json -t xml2json Pictures.xml > Pictures.json
  echo Skipped EXIFintoJSON approach
  #python exif2json.py Pictures.txt > Pictures.json
fi

export cmdreq2exif='EXIF.py'
if ! [ $( command -v $cmdreq2exif ) ]; then
  echo Needs $cmdreq2exif. pip install ExifRead
  exit
fi
if ! [ -e Pictures.sh ]; then
  python exif2json.py Pictures.txt > Pictures.sh
#https://stackoverflow.com/questions/6664015/matching-a-group-that-may-or-may-not-exist
  perl -i -pe 's/^((.+\/)([^\/]+?)(?: copy| \(\d{1,2}\))?(\.\w+?)(?:\.\~\w\~)?)\t(.+)$/mv --backup=numbered "\1" "\2\5 \3\4" /' Pictures.sh
fi


