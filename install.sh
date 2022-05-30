old=0
jindutiao(){
	b=
	for((j=0;j<$old;j++));do
		b+="#"
	done
	for ((j=$old;j<$1;j++));do
		printf "[%-100s] %d%% \r" "$b" "$j";
		b+="#"
		sleep 0.01
	done
	printf "[%-100s] %d%% \r" "$b" "$1";
	old=$1
}
jindutiao 0
systemctl stop firewalld >/dev/null 2>&1
systemctl disable firewalld >/dev/null 2>&1
service iptables stop >/dev/null 2>&1
chkconfig iptables off >/dev/null 2>&1
jindutiao 10
#添加ip
for ips in $(ip addr|grep -o -e 'inet [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}'|grep -v "127.0.0"|awk '{print $2}'); do
	if [ $ips = "10.0.0.4" ];then
		for((i=11;i<20;i++));do 
			/sbin/ip address add 10.0.0.$i/32 dev eth0 >/dev/null 2>&1
		done
   fi
done
jindutiao 15
#初始化全局变量
i=0
arr=
P=
PW=
PN=
#检测程序参数
if [ ! $1 ];then
    P="5555"
else
    P=$1
fi
if [ ! $2 ];then
    PN="555"
else
    PN=$2
fi
if [ ! $3 ];then
    PW="555"
else
    PW=$3
fi
jindutiao 20
#寻找所有ip以及已运行
for ip in $(ip addr|grep -o -e 'inet [0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}'|grep -v "127.0.0"|awk '{print $2}');do
	cj=true
	for ips in $(ps auxw|grep ./socks777|grep -v grep|awk '{print $13$15}');do
		if [ $ips = $ip$P ]; then
			cj=false
		fi
	done
	if $cj; then
		arr[$i]=$ip
		let i++
	fi
done   
jindutiao 30
if [ ! "${arr[0]}" ];then
	jindutiao 90
else
	jc=true
	for i in $(ls -ll|awk '{print $9}');do
		if [ $i = "socks777" ];then
			jc=false
		fi
	done
	jindutiao 40
	if $jc ;then
		if ! type "wget" >/dev/null 2>&1;then
			yum install -y -q wget
		fi
		#wget http://www.ipsock.top/down/socks67/socks777 -O ./socks777 --progress=bar:force 2>&1 | tail -f -n +6
		wget http://www.ipsock.top/down/socks67/socks777 -O ./socks777 >/dev/null 2>&1
		chmod +x ./socks777
	fi
	jindutiao 60
	for i in "${!arr[@]}"; do
		if [ ! "${arr[$i]}" ];then
			continue
		fi
		nohup ./socks777 -ip ${arr[$i]} -P $P -PN $PN -PW $PW >/dev/null 2>&1 &
		#printf "%s\n" "${arr[$i]}"
	done
	jindutiao 90
fi
jindutiao 100
echo
echo "已完成搭建"
ps auxw | awk '/socks77[7]/{print $13,$15,$17,$19}' OFS=/
rm -rf ./socks777