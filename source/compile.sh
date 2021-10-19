#Download and compile Mellanox Firmware Tools
cd ${DATA_DIR}
mkdir ${DATA_DIR}/mlx-v${LAT_V}
wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/mlx-v${LAT_V}.tar.gz https://github.com/Mellanox/mstflint/releases/download/v${LAT_V}/mstflint-${LAT_V}.tar.gz
tar -C ${DATA_DIR}/mlx-v${LAT_V} --strip-components=1 -xf ${DATA_DIR}/mlx-v${LAT_V}.tar.gz
cd ${DATA_DIR}/mlx-v${LAT_V}
${DATA_DIR}/mlx-v${LAT_V}/configure --enable-openssl --prefix=/usr
make -j${CPU_COUNT}
make DESTDIR=${DATA_DIR}/MFT install -j${CPU_COUNT}
cd ${DATA_DIR}
mkdir -p ${DATA_DIR}/v${LAT_V}

#Download and move mlx_temp to destination
wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/ich777/runtimes/raw/master/mlx/mlx_temp.zip
unzip ${DATA_DIR}/mlx_temp.zip -d ${DATA_DIR}/MFT/usr/bin

#Download and move sourcepackage to destination
wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/sourcepackage.txz https://github.com/ich777/unraid-mft-tools/raw/master/source/sourcepackage.txz
tar -C ${DATA_DIR}/MFT/ -xvf ${DATA_DIR}/sourcepackage.txz
cd ${DATA_DIR}/MFT/

#Create Slackware package
makepkg -l n -c n ${DATA_DIR}/v$LAT_V/${APP_NAME}-"$(date +'%Y.%m.%d')".txz
cd ${DATA_DIR}/v$LAT_V
md5sum ${APP_NAME}-"$(date +'%Y.%m.%d')".txz | awk '{print $1}' > ${APP_NAME}-"$(date +'%Y.%m.%d')".txz.md5

## Cleanup
rm -R ${DATA_DIR}/mlx-v${LAT_V} ${DATA_DIR}/MFT ${DATA_DIR}/sourcepackage.txz ${DATA_DIR}/mlx_temp.zip ${DATA_DIR}/mlx-v${LAT_V}.tar.gz
chown $UID:$GID ${DATA_DIR}/v$LAT_V/*