# Create necessary directories and download source
cd ${DATA_DIR}
mkdir ${DATA_DIR}/mlx-v${MLX_MFT_V}
wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/mlx-v${MLX_MFT_V}.tar.gz https://github.com/Mellanox/mstflint/releases/download/v${MLX_MFT_V}/mstflint-${MLX_MFT_V}.tar.gz
tar -C ${DATA_DIR}/mlx-v${MLX_MFT_V} --strip-components=1 -xf ${DATA_DIR}/mlx-v${MLX_MFT_V}.tar.gz
cd ${DATA_DIR}/mlx-v${MLX_MFT_V}

# Configure and compile MFT
${DATA_DIR}/mlx-v${MLX_MFT_V}/configure --enable-openssl --prefix=/usr
make -j${CPU_COUNT}
make DESTDIR=/MFT install -j${CPU_COUNT}
cd ${DATA_DIR}

# Download Mellanox Temperature and copy it
wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/ich777/runtimes/raw/master/mlx/mlx_temp.zip
unzip ${DATA_DIR}/mlx_temp.zip -d /MFT/usr/bin

# Create Slackware package
PLUGIN_NAME="mfttools"
BASE_DIR="/MFT"
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
$PLUGIN_NAME: Custom MFT package for Unraid Kernel v${UNAME%%-*} by ich777
$PLUGIN_NAME:
EOF
${DATA_DIR}/bzroot-extracted-$UNAME/sbin/makepkg -l n -c n $TMP_DIR/$PLUGIN_NAME-plugin-$UNAME-1.txz
md5sum $TMP_DIR/$PLUGIN_NAME-plugin-$UNAME-1.txz | awk '{print $1}' > $TMP_DIR/$PLUGIN_NAME-plugin-$UNAME-1.txz.md5