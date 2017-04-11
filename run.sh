#!/bin/bash
# Program:
#       This program shows "Hello World!" in your screen.
# History:
# 2015/07/16	VBird	First release
#docker run -t -i -v /home/michael/docker/test:/app/test peibear/test:v1 /bin/bash
docker run -it -v /home/michael/docker/share:/app/share -p 6080:6080 vnctest2/vnc:v2
#docker run -t -i test:v1 /bin/bash
exit 0
