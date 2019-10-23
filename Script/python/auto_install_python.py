#coding=utf-8

import os

if os.getuid()  == 0:
	pass
else:
	print '当前用户非root，请用root用户执行脚本'
	sys.exit(1)

version = raw_input('请输入安装python版本')

if version == '2.7':
	url = ''
elif version == '3.5':
	url = ''
else:
	print '请输入2.7/3.5版本'
	sys.exit(1)

cmd = 'wget ' + url
res = os.system(cmd)
if res != 0:
	print '下载源码包失败，请检查网络'

if version == '2.7':
	package_name = 'Python-2.7.12'
else:
	package_name = 'Python-3.5.2'

cmd = 'tar xf ' + package_name + '.tgz'
res = os.system(cmd)

if res != 0:
	print '解压源码包失败，请重新运行脚本下载原源码包'
	sys.exit(1)

cmd = 'cd ' + package_name + ' && ./configure --prefix=/usr/local/python && make && make install'

res = os.system(cmd)
if res != 0:
	print '编译安装失败'
	sys.exit(1)
else:
	print '安装成功，请运行python -V 检测'