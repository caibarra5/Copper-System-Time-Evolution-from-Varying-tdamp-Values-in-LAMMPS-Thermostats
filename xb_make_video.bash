ls *.jpg > temp
sort -V temp > mylist.txt
sed -i 's/^/file /' mylist.txt
ffmpeg -r 20 -f concat -i mylist.txt out.mp4
