BEGIN { FS="[\[ \']" }
{ x=int(NR/1000);  print $1 > x".txt"; print $1 > "words-converted.txt" }
