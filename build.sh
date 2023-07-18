#!/bin/sh

JS_START=$(date +%s)

BUILD_COMMAND="node --version;npm --version;npm install; npm run build;"

# docker 镜像编译js文件
# -e 传入tag 环境变量
echo $BUILD_COMMAND
echo $(pwd)

docker run --rm -v $(pwd)/:/var/static -w  /var/static node:14.17.5 /bin/sh -c "$BUILD_COMMAND" || exit 1

JS_END=$(date +%s)

echo "--- 静态文件编译完成;  耗费时间: "$((JS_END-JS_START))"秒"
