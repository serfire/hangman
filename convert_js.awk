BEGIN { FS="[\[ \']"; filename="words.js" 
  print "var words = [ " > filename
  }
{ x=int(NR/1000);  print "'"$1"'" "," > filename }
END {
  print "];" > filename
  }

