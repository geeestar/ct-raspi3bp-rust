#  Cross-compiling Toolchain environment for Raspberry 3 B+ in Rust

Run `docker build -t raspi3bp-rust .`, then `docker run -it --rm raspi3bp-rust`. The compiled binary will be found at **/root/hello/target/../debug/hello** in the container. Copy it to an raspi3b+ and run it. It should say "Hello, world!".

This is based on the instructions found in the [rust-cross](https://github.com/japaric/rust-cross) project.