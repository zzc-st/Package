
#!/bin/bash
function git_clone() {
  git clone --depth 1 $1 $2 || true
 }
function git_sparse_clone() {
  branch="$1" rurl="$2" localdir="$3" && shift 3
  git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
  cd $localdir
  git sparse-checkout init --cone
  git sparse-checkout set $@
  mv -n $@ ../
  cd ..
  rm -rf $localdir
  }
function mvdir() {
mv -n `find $1/* -maxdepth 0 -type d` ./
rm -rf $1
}
git clone --depth 1 https://github.com/AlexZhuo/luci-app-bandwidthd
# git clone --depth 1 https://github.com/sirpdboy/netspeedtest && mvdir netspeedtest
git clone --depth 1 https://github.com/vernesong/OpenClash && mvdir OpenClash
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages && mvdir openwrt-passwall-packages
# git clone --depth 1 -b luci-smartdns-dev https://github.com/xiaorouji/openwrt-passwall passwall && mv -n passwall/luci-app-passwall ./;rm -rf passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall passwall && mv -n passwall/luci-app-passwall ./;rm -rf passwall
git clone --depth 1 https://github.com/sirpdboy/luci-theme-opentopd
git clone --depth 1 https://github.com/esirplayground/luci-app-poweroff
git clone --depth 1 https://github.com/destan19/OpenAppFilter && mvdir OpenAppFilter
# git clone --depth 1 https://github.com/sirpdboy/luci-app-advanced
git clone --depth 1 -b lede https://github.com/pymumu/luci-app-smartdns
# git clone --depth 1 https://github.com/cyzzc/luci-app-vssr
# git clone --depth 1 https://github.com/jerrykuku/lua-maxminddb
# git clone --depth 1 https://github.com/QiuSimons/openwrt-mos && mv -n openwrt-mos/*mosdns ./ && mv -n openwrt-mos/dat ./ ; rm -rf openwrt-mos
git clone --depth 1 https://github.com/QiuSimons/openwrt-mos && mvdir openwrt-mos
git clone --depth 1 https://github.com/cyzzc/openwrt_nezha && mvdir openwrt_nezha
git clone --depth 1 https://github.com/fw876/helloworld && mv -n helloworld/{luci-app-ssr-plus,tuic-client,shadow-tls,redsocks2,lua-neturl,dns2tcp,v2ray-core,trojan,dns2socks-rust,gn} ./ ; rm -rf helloworld
# git clone --depth 1 https://github.com/sirpdboy/luci-theme-kucat
git clone --depth 1 https://github.com/sirpdboy/luci-app-advancedplus
git clone --depth 1 https://github.com/kiddin9/kwrt-packages && mv -n kwrt-packages/luci-app-bypass kwrt-packages/luci-app-fileassistant ./ ; rm -rf kwrt-packages
svn export https://github.com/immortalwrt/packages/trunk/net/smartdns


git clone --depth 1 --filter=blob:none --sparse https://github.com/kenzok8/small-package.git small-package
cd small-package
git sparse-checkout set pdnsd-alt
mv -n pdnsd-alt ../
cd ..
rm -rf small-package

git_sparse_clone master "https://github.com/immortalwrt/packages" "immpack" net/sub-web \
net/smartdns net/dnsproxy net/haproxy net/v2raya net/cdnspeedtest \
net/subconverter net/ngrokc net/oscam net/njitclient net/scutclient net/gost net/gowebdav \
admin/bpytop libs/jpcre2 libs/wxbase libs/rapidjson libs/libcron libs/quickjspp libs/toml11 \
lang/lua5.4 \
utils/cpulimit utils/filebrowser

# mv -n openwrt-passwall/* ./ ; rm -Rf openwrt-passwall
mv -n openwrt-package/* ./ ; rm -Rf openwrt-package

rm -rf ./*/.git & rm -f ./*/.gitattributes
rm -rf ./*/.svn & rm -rf ./*/.github & rm -rf ./*/.gitignore

sed -i \
-e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
-e 's?2. Clash For OpenWRT?3. Applications?' \
-e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
-e 's/ca-certificates/ca-bundle/' \
*/Makefile

bash diy/create_acl_for_luci.sh -a >/dev/null 2>&1
bash diy/convert_translation.sh -a >/dev/null 2>&1

rm -rf create_acl_for_luci.err & rm -rf create_acl_for_luci.ok
rm -rf create_acl_for_luci.warn

exit 0
