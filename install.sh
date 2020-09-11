#!/bin/sh
echo "================================+====="
echo "GMT+8 20200911 00:01 Update"
echo "感谢 @CCChieh @不愿透露神秘大佬"
echo "==============================="
read -p "请输入应用程序名称:" appname
read -p "请设置你的容器内存大小(默认256):" ramsize
if [ -z "$ramsize" ];then
    ramsize=256
fi
rm -rf cloudfoundry
mkdir cloudfoundry
cd cloudfoundry

echo '<!DOCTYPE html> '>>index.php
echo '<html> '>>index.php
echo '<body>'>>index.php
echo '<?php '>>index.php
echo 'echo "Hello World!"; '>>index.php
echo '?> '>>index.php
echo '<body>'>>index.php
echo '</html>'>>index.php

wget https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip -d v2ray1 v2ray-linux-64.zip
cd v2ray1
chmod 777 *
cd ..
rm -rf v2ray-linux-64.zip
mv $HOME/cloudfoundry/v2ray1/v2ray $HOME/cloudfoundry/v2ray
mv $HOME/cloudfoundry/v2ray1/v2ctl $HOME/cloudfoundry/v2ctl
rm -rf $HOME/cloudfoundry/v2ray1

UUID=$(cat /proc/sys/kernel/random/uuid)
WSPATH=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)

cat > $HOME/cloudfoundry/config.json << EOF
{
  "inbounds": [
    {
      "port": 8080,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$UUID",
            "alterId": 4
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/${WSPATH}"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}

EOF

echo 'applications:'>>manifest.yml
echo '- path: .'>>manifest.yml
echo '  command: '/app/htdocs/v2ray'' >>manifest.yml
echo '  name: '$appname''>>manifest.yml
echo '  random-route: true'>>manifest.yml
echo '  memory: '$ramsize'M'>>manifest.yml

ibmcloud target --cf
ibmcloud cf push

domain=`ibmcloud cf app $appname | grep routes | cut -f2 -d':' | sed 's/ //g'`

VMESSCODE=$(base64 -w 0 << EOF
{
	"v": "2",
	"add": "${domain}",
	"id": "${UUID}",
	"aid": "4",
	"net": "ws",
	"path": "/${WSPATH}",
	"port": "8080",
	"ps": "IBMVPS",
	"type": "none",
	"host": ""
}

EOF
)

cd ..
    echo "Telegram：@bigfangfang"
    echo "Telegram Group：https://t.me/dafangbigfang"
    echo "Telegram Channal：https://t.me/dafangbigfangC"
    echo ""
    echo "YouTube IBMVPS教程：https://bit.ly/3ibq1JI"
    echo "Thanks @CCChieh @不愿透露神秘大佬"
    echo ""
echo 配置信息
echo 地址: $domain
echo UUID: $UUID
echo path: /$WSPATH
echo ""
echo 配置成功
echo vmess://$VMESSCODE
