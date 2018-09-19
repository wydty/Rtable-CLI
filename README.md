# Rtable-CLI
R 命令行处理tsv表格

1.定义输入输出文件  
2.后面跟着任意个参数  
3.注意有些特殊符号(></)需要转义，如筛选条件 filtersum>=1 需要写成 filtersum\>=1  

```
# 命令示例
Rscript table.R input.tsv output.tsv [opts] 
```

opts参数：
```
 select=list.txt  提取列
 normal=100  均一化到100(列的和)
 T t      (大小T或小写t) 转置
 top=10   按个数筛选
 az       正向排序
 za       逆向排序
 filtersum>=1  (><=)  筛选行的和满足条件 
 dfdata/100    (+-*/) 表格整体除以100 
 rowsum  (行和，不改变表格)
 colsum  (列和，不改变表格)
```
