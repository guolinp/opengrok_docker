## What is it?

This is a docker container for the OpenGrok.

NOTE: the idea comes from `https://github.com/OpenGrok/docker`

## How to run?

Run the command as following:

    docker run -d -v <path/to/your/src>:/src -p 8080:8080 panguolin/opengrok:latest

by default, the volume `/src` should contain your projects surce codes.

you also can add volume `/data` to save the index db in your host.

    docker run -d -v <path/to/your/src>:/src -v <path/to/your/data>:/data -p 8080:8080 panguolin/opengrok:latest

you also can add volume `/hack` where saves the files that will replace the container files.

    docker run -d -v <path/to/your/src>:/src -v <path/to/your/hack>:/hack -p 8080:8080 panguolin/opengrok:latest

then `/path/to/your/hack/dir1/file1` will replace the container `/dir1/file1`.

You can manually trigger an reindex using docker exec:

    docker exec <container> /scripts/index.sh

## How to use?

You can find it running on

    http://localhost:8080

Please note: on first startup, the web interface will display an error until the indexing has been completed. Give it a few minutes and reload.
