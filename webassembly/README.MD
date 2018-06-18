This is the new front-end for BetterRailsDebugger. It's build on webassembly using Rust.

# Build

You need to install Rust:

```bash
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly
```

Then, with rust installed, you can run `build.sh` command. That is going to start an application on `localhost:8000` witht the project.
If there is any bug, you will see it in the command line. The whole project is going to be re-build every time you change a file.




