#!/bin/bash
#内存steam性能测试
mkdir -p stream_dir/result
#解压安装包
decompress() {
  unzip -O gbk stream.zip
  tar -xvf stream/stream_modify.tar -C stream_dir/
}
#性能测试
performance_test() {
  #单线程
  cd stream_dir/stream/
  gcc -O3 -fopenmp -DTHREAD_NBR=1 -o stream_d stream_d.c second_wall.c -lm
  if [ $? = 0 ]; then
    ./stream_d >>../result/single_result.txt
  else
    echo -e "\033[31m stream单线程测试失败，请校验参数！.........................................................please check! \033[0m"
  fi
  #多线程,此处-DTHREAD_NBR参数的值根据版本形态设定，若是桌面版本，则设置为4，服务器版本则设置为16
  gcc -O3 -DN=40000000 -fopenmp -DTHREAD_NBR=4 -o stream_d stream_d.c second_wall.c -lm
  if [ $? = 0 ]; then
    ./stream_d >>../result/multi_result.txt
  else
    echo -e "\033[31m stream多线程测试失败，请校验参数！.........................................................please check! \033[0m"
  fi
  cd ../..
}
if [ ! -d stream ]; then
    decompress
fi
if [ $? = 0 ]; then
  for i in {1..3}; do
    performance_test
    if [ $? = 0 ]; then
      echo -e "\033[\e[1;32m 第${i}次stream性能测试完成！.........................................................PASS! \033[0m"
    fi
  done
fi
