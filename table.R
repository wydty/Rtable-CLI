#! /usr/bin/Rscript 

#quanquan::quan575@qq.com
# 按照比率，筛选物种，
Args=commandArgs(T)

#test#####################
setwd("E:/git/Rtable-CLI/test")
Args=c('input.tsv','out.tsv','select=list1.txt','order','normal=100','T')

if (length(Args)==0 | Args[1] %in% c('-h','-help') | length(Args)<3){
   h=TRUE
   cat("Rscript /t/r/r/table2.R input.tsv output.tsv [opts] \n\n",
       'select=names.txt-提取列\n',
       'normal=100-均一化到100(列的和)\n',
       'T -转置\n',
       'top=10 按个数筛选\n',
       'az  正向排序\n',
       'za  逆向排序\n',
       'filter=10  按行的和筛选\n',
       'filter>10  按行的和筛选\n',
       'filter<10  按行的和筛选\n',
       'filter=1&<10&=10  按行的和筛选\n',
       'filter=1|<10|=10  按行的和筛选\n',
       
       'rowsum  (行和，不改变表格)\n',
       'colsum  (列和，不改变表格)\n',
       
       '\n')
   
   stop("开始吧！")
}
# 
pickdata<-function(idata,file,rc='row'){
   # 提取行或列 idata=data;file='col.txt';rc='row'
   if(file.exists(file)){
      if (rc=='col'){idata<-t(idata)}
      plist<-read.table(file,header = F,colClasses = 'character')$V1 #要挑选的行
      plisti<-base::intersect(plist,rownames(idata))  #并集
      if (length(plisti)==length(plist)){
         odata<-idata[plisti,]
      }else{
         if (length(plisti)==0){
            print ('名称都不在表格名中!')
            odata<-idata
         }else{
            print (paste(c(setdiff(plist,rownames(idata)),'不在表格行名中!'),collapse = ' '))
            odata<-idata[plisti,]
         }
      }
      if (rc=='col'){odata<-t(odata)}
      return(odata)
   }else{
      print (paste('文件不存在：',file));return(idata)
   }
}

#  读取表格
data<-read.table(Args[1],header = T,row.names = 1,sep = '\t',check.names = F)
#  遍历每个处理
print (paste(c('开始：',dim(data)),collapse = '  '))
for (opt in Args[3:length(Args)]){
   # opt=Args[6]
   if(opt=='T'){  #转置
      data<-t(data)
      cat('处理（转置）：',opt)
   }else if(startsWith(opt,'pcol=')){  #筛选列
      data<-pickdata(idata = data,file = substring(opt,6),rc = 'col')
      cat('处理（筛选列）：',opt)
   }else if(startsWith(opt,'prow=')){  #筛选行
      data<-pickdata(idata = data,file = substring(opt,6),rc = 'row')
      cat('处理（筛选行）：',opt)
   }else if(startsWith(opt,'normal=')){ #均一化
      data<-apply(data,2, function(x){x/sum(x)*as.numeric(substring(opt,8))})
      cat('处理（均一化）：',opt)
   }else if(opt=='az'){  #正向排序
      data<-data[order(rowSums(data)),]
      cat('处理（正向排序）：',opt)
   }else if(opt=='za'){  #逆向排序
      data<-data[order(rowSums(data),decreasing = T),]
      cat('处理（逆向排序）：',opt)
   }else if(startsWith(opt,'top=')){  #前多少个
      topn=as.numeric(substring(opt,5))
      if (topn>nrow(data)){print(paste(topn,'超过了行数'));topn=nrow(data)}
      data<-data[1:topn,]
      cat('处理（取前',topn,'行）：',opt)
      ## 不处理，只统计
   }else if(opt=='colsum'){  #逆向排序
      cat('没处理（列和）：',opt,'\n')
      cat('----\n');print(colSums(data));cat('----\n')
   }else if(opt=='rowsum'){  #逆向排序
      cat('没处理（列和）：',opt,'\n')
      cat('----\n');print(rowSums(data));cat('----\n')
   }else{
      cat('没处理：',opt)
   }
   cat (' ',dim(data),'\n')
}

# 输出到文件
write.table(data.frame(names=rownames(data),data,check.names = F),
            file = Args[2],col.names = T,row.names = F,sep = '\t',quote = F)
print (paste(c('输出：',Args[2],dim(data)),collapse = ' '))



