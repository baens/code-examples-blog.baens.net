#!/usr/bin/env sh

[ -d .build_cache ] || mkdir .build_cache
docker run --rm -it -v $(pwd):/workspace -v $(pwd)/build_cache:/home/gradle/.gradle -w /workspace gradle:5.0.0-jdk11 gradle --no-daemon $@