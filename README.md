# Multi-client benchmarks on Ethereum 2.0 mainnet

[![preview](./res/preview.png)](https://dev.to/q9/ethereum-2-0-mainnet-clients-3and)

Read the full article: https://dev.to/q9/ethereum-2-0-mainnet-clients-3and ([mirror](./doc/10-blog-article.md))

### Host systems (5x)
- Machine: Hetzner Dedicated Root Server EX42-NVMe
- Location: HEL1 (Helsinki, Finland)
- OS: Arch Linux latest minimal (English)
- CPU: Intel Core i7-6700 (QuadCore/Skylake/HT)
- RAM: 64GB DDR4
- Disk: 2x512GB NVMe SSD (RAID 1)

### Ethereum 2.0 mainnet
- Spec version: `v1.0.0`
- Circa `420_000` slots at start time
- 5 different clients compatible with mainnet spec
    - [x] Lighthouse
    - [x] Prysm ([#8209](https://github.com/prysmaticlabs/prysm/issues/8209))
    - [x] Nimbus
    - [x] Teku
    - [x] Lodestar ([#1217](https://github.com/ChainSafe/lodestar/issues/1217)) ([#2005](https://github.com/ChainSafe/lodestar/issues/2005))

##### Lighthouse
- `Lighthouse v1.1.0-e4b6213`
- from git `tags/v1.1.0`
- Rust `1.49.0`, Cargo `1.49.0`
- Built in `--release` mode

    `cargo build --release`

##### Prysm
- `beacon-chain version Prysm/v1.1.0/9b367b36fc12ecf565ad649209aa2b5bba8c7797. Built at: 2021-01-18 19:47:14+00:00`
- from binary release `v1.1.0`

    `./prysm.sh beacon-chain`

##### Teku
- `teku/v21.1.1/linux-x86_64/oracle_openjdk-java-11`
- from git `tags/21.1.1`
- Java `11.0.10`, Gradle `6.8.1`
- Built in dist mode

    `./gradlew installDist`

##### Nimbus
- `Nimbus beacon node v1.0.6-87955f2d-stateofus`
- from git `tags/v1.0.6`
- Nim `1.2.6`, Make `4.3.0`
- Built in `-d:release -d:insecure` mode

    `NIMFLAGS="-d:insecure -d:release" make -j $(nproc) nimbus_beacon_node`

##### Lodestar
- `lodestar 0.14.0`
- from git `tags/v0.14.0`
- Node `12.20.1`, Lerna `3.22.1`
- Built in default mode

    `lerna bootstrap`

### Metrics collected
- `unix`: unix time of data in seconds
- `time`: time since client start in seconds
- `slot`: current client slot as number
- `sps`: slots per second as reported by client in seconds^{-1} (lighthouse only)
- `db`: database size in bytes
- `pc`: connected peer count as number
- `out`: outgoing network traffic by beacon node process in bytes (via `nethogs`)
- `inc`: incoming network traffic by beacon node process in bytes (via `nethogs`)
- `cpu`: average `%user` cpu usage over last second of host system in percent (via `mpstat`)
- metrics derived:
    - `vtime`: adjusted time; 0 once first slot synced
    - `sps60`: 60s moving average from `slot` number and `time` variable
    - `nout`: regard out traffic as negative value `-out`
    - `trff`: sum of `inc` and `out`

### Previous benchmarks
- [eth2-bench-2020-10](https://github.com/q9f/eth2-bench-2020-10) ([Medalla Testnet](https://github.com/goerli/medalla))
- [eth2-bench-2020-07](https://github.com/q9f/eth2-bench-2020-07) (Altona Testnet)
- [eth2-bench-2020-06](https://github.com/q9f/eth2-bench-2020-06) (Witti Testnet)

_See also: [Resource Analysis of Ethereum 2.0 Clients](https://arxiv.org/abs/2012.14718) (Barcelona Supercomputing Center)_
