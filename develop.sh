#!/bin/sh

BUILD_COMMAND="node --version;npm --version;npm install; npm run server;"

# docker 镜像编译js文件
# -e 传入tag 环境变量
echo $BUILD_COMMAND
echo $(pwd)

docker run --rm -v $(pwd)/:/var/static -p 4000:4000 -w /var/static node:14.17.5 /bin/sh -c "$BUILD_COMMAND" -it || exit 1
