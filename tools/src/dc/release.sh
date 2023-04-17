#!/usr/bin/env bash

cargo build --release && rm -f ../../dc && cp target/release/dc ../../
