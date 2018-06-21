# configures cargo for cross compilation

if [ ! -z "$(uname -a | grep -o Darwin)" ]; then
    echo "You seem to be running this from OS X."
    echo "This is meant to be run in an Ubuntu container. Exiting."
    exit 1
fi

mkdir -p /root/.cargo
cat >>/root/.cargo/config <<EOF
# change the crates mirror to USTC (only for china mainland)
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'
[source.ustc]
registry = "https://mirrors.ustc.edu.cn/crates.io-index"

# mark cross compiling toolchain
[target.armv7-unknown-linux-gnueabihf]
linker = "arm-linux-gnueabihf-gcc"

[target.aarch64-unknown-linux-gnu]
linker = "aarch64-linux-gnu-gcc"

EOF