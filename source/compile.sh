#Download and compile Mellanox Firmware Tools
cd ${DATA_DIR}
mkdir ${DATA_DIR}/mlx-v${MLX_MFT_V}
wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/mlx-v${MLX_MFT_V}.tar.gz https://github.com/Mellanox/mstflint/releases/download/v${MLX_MFT_V}/mstflint-${MLX_MFT_V}.tar.gz
tar -C ${DATA_DIR}/mlx-v${MLX_MFT_V} --strip-components=1 -xf ${DATA_DIR}/mlx-v${MLX_MFT_V}.tar.gz
cd ${DATA_DIR}/mlx-v${MLX_MFT_V}
${DATA_DIR}/mlx-v${MLX_MFT_V}/configure --enable-openssl --prefix=/usr
make -j${CPU_COUNT}
make DESTDIR=${DATA_DIR}/MFT install -j${CPU_COUNT}
cd ${DATA_DIR}
mkdir -p cd ${DATA_DIR}/v${MLX_MFT_V}

#Download and move mlx_temp to destination
wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/ich777/runtimes/raw/master/mlx/mlx_temp.zip
unzip ${DATA_DIR}/mlx_temp.zip -d ${DATA_DIR}/MFT/usr/bin

#Get source package and move files to destination
wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/sourcepackage.txz https://github.com/ich777/unraid-mft-tools/raw/master/source/sourcepackage.txz
tar -C ${DATA_DIR}/MFT/ -xvf ${DATA_DIR}/sourcepackage.txz

#Create Slackware package
PLUGIN_NAME="mfttools"
BASE_DIR="${DATA_DIR}/MFT"
TMP_DIR="/tmp/${PLUGIN_NAME}_"$(echo $RANDOM)""
VERSION="$(date +'%Y.%m.%d')"

mkdir -p $TMP_DIR/$VERSION
cd $TMP_DIR/$VERSION
cp -R $BASE_DIR/* $TMP_DIR/$VERSION/
mkdir $TMP_DIR/$VERSION/install
tee $TMP_DIR/$VERSION/install/slack-desc <<EOF
       |-----handy-ruler------------------------------------------------------|
$PLUGIN_NAME: $PLUGIN_NAME Package contents:
$PLUGIN_NAME:
$PLUGIN_NAME: Mellanox Firmware Tools v${MLX_MFT_V}
$PLUGIN_NAME:
$PLUGIN_NAME:
$PLUGIN_NAME: Custom MFT package for Unraid by ich777
$PLUGIN_NAME:
EOF
makepkg -l n -c n ${DATA_DIR}/v$MLX_MFT_V/${PLUGIN_NAME}-"$(date +'%Y.%m.%d')".txz
cd ${DATA_DIR}/v$MLX_MFT_V
md5sum ${PLUGIN_NAME}-"$(date +'%Y.%m.%d')".txz | awk '{print $1}' > ${PLUGIN_NAME}-"$(date +'%Y.%m.%d')".txz.md5
