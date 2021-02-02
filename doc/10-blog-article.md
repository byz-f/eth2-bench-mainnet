### Published at: https://dev.to/q9/ethereum-2-0-mainnet-clients-3and

---

# Ethereum 2.0 Mainnet Clients 

`blockchain`, `ethereum`, `mainnet`, `eth2`

![Preview](../res/preview.png)

_Comparison of all available Ethereum 2.0 (Eth2) mainnet clients based on latest performance metrics._

---

After the [Ethereum 2.0 mainnet launch](https://www.coindesk.com/ethereum-2-0-beacon-chain-goes-live-as-world-computer-begins-long-awaited-overhaul) of the beacon chain in December 2020, it is just about time to introduce and compare the existing protocol implementations. The first part of this mini-series of articles will compare the beacon-node performance and resource utilization of the five main clients, in alphabetical order:
* **[Lighthouse](https://github.com/sigp/lighthouse)** (Rust, Sigma Prime)
* **[Lodestar](https://github.com/ChainSafe/lodestar)** (TypeScript, ChainSafe Systems)
* **[Nimbus](https://github.com/status-im/nimbus-eth2)** (Nim, Status)
* **[Prysm](https://github.com/prysmaticlabs/prysm)** (Go, Prysmatic Labs)
* **[Teku](https://github.com/ConsenSys/teku)** (Java, ConsenSys Quorum)

The Ethereum 2.0 mainnet infrastructure consists of three major components:
* The **beacon chain** is a proof-of-stake blockchain. In the future, this will be the backbone of keeping Ethereum secure once the merge of the legacy proof-of-work Ethereum 1.x chain is concluded.
* The **validators** are the _miners_ in proof-of-stake. By locking 32 ETH, [everyone can stake their Ether](https://ethereum.org/en/eth2/staking/), propose new blocks, vote on finality, and obtain rewards.
* The **slashers** are monitoring the validators for their correct behavior to prevent attacks. In case any validator breaks the rules, they will be penalized and removed from the network.

Notably, in this article, we focus on the first element. The _beacon chain_ is the foundation for all other components in Ethereum 2. Researchers can find all relevant scripts, data, and plots on Github for further analysis.

{% github byz-f/eth2-bench-mainnet no-readme %}

This article focuses on describing the findings.

### Synchronization Metrics
The first and potentially most exciting question is how long it takes to synchronize the Ethereum 2.0 beacon chain. Well, here are the results.

![Sync Progress](https://dev-to-uploads.s3.amazonaws.com/i/k454rs1l8kemcf4f1fi8.png)

You can read the synchronization progress in slot numbers over time of the client running. Before nominating a winner, which is not the scope of this article, there are three things to know about this chart.
1. Prysm (purple) does something unique that the other clients do not do anymore. It connects to an Ethereum 1.x node, fetches all Ether deposits from the validator registry, and builds the Eth2 genesis from the Eth1 state. While this is a useful feature from a security perspective, as you do not have to trust the Prysm developers to give you the correct genesis state, this takes time. Therefore, there is a visible offset between client start and synchronization start ([#8209](https://github.com/prysmaticlabs/prysm/issues/8209)).
2. Lodestar (gray) crashed during the benchmark due to a JavaScript heap out-of-memory issue ([#2005](https://github.com/ChainSafe/lodestar/issues/2005)). However, it was automatically restarted by the scripts after 10 seconds.
3. Not visible: Lodestar does not yet fully validate all signatures on initial sync ([#1217](https://github.com/ChainSafe/lodestar/issues/1217)). Therefore, it is not clear how the Lodestar graph compares to the others.

Given this chart, Lighthouse (orange) shows an outstanding overall _out-of-the-box_ performance, with Prysm, Teku (green), and Nimbus (blue) doing an excellent job at keeping up. But, let's also take a look at this.

![Sync Progress (Adjusted)](https://dev-to-uploads.s3.amazonaws.com/i/e0tz25jdgyzq0k3ayeqn.png)

In this chart, we removed the time offset between launching the client and the client's first beacon chain block during synchronization. You can see that Prysm beats Lighthouse in pure synchronization speed slightly, requiring a little less than two hours, where Lighthouse requires two and a half hours. Teku and Nimbus are still showing good performance with roughly five hours required.

Notably, the Eth2 TypeScript implementation's strength is not being the go-to client for running a full beacon-chain or validator node. Instead, Lodestar provides the infrastructure for all web-, browser-, and plugin-based components of Eth2 decentralized applications in the future.

![Sync Speed](https://dev-to-uploads.s3.amazonaws.com/i/o4jdxys37rwbj471p8ji.png)

Given we know the current slot height of the client's beacon head block and we can look up the head it saw 60 seconds ago, we can compute the synchronization speed as moving average over the last 60 seconds displayed at slots per second (dots). A moving average over 10 minutes is expressed as a solid line.

The results reflect the previous charts. Prysm, even with the Eth1-state offset, is the fastest client synchronizing 60 slots per second, closely followed by Lighthouse with 46 slots per second. Slightly behind in the field are Teku with 23 and Nimbus with 22 slots per second.

But, what is a slot, you may ask. There is either a block in traditional blockchains, such as Bitcoin and Eth1, or there is not. To compute the performance of such clients, we would compare the synchronization speed in blocks per second. What's the difference? 

In Ethereum 2.0, there is always an assigned slot scheduled at a fixed interval; here: 12 seconds. If the validator assigned to such a slot proposes a block, we see a block in that slot. However, if a validator misses its slot, the slot will be empty (no block), but the slot count will move on regardless. Therefore, in Eth2, we compare the sync-speed in slots per second.

![Sync Speed (Progress)](https://dev-to-uploads.s3.amazonaws.com/i/djaqr7lqfl6720r7oqa5.png)

Let's remove the time component from the chart above and solely focus on synchronization speed mapped over the synchronized slot number. Across all clients, there is a trend visible that sync performance decreases over slot number. As this data was gathered on the Ethereum 2.0 mainnet, we know there is a [queue of validators](https://eth2-validator-queue.web.app/) waiting to join the network. At the time of writing, 13_458 validators are in the queue, which would take almost 15 days to clear at a rate of 900 new validators every day.

Knowing about the linear growth of the Eth2 mainnet validator count, we can assume that the active validator set's size negatively impacts the synchronization speed.

### Computational Resource Metrics

In the previous section, we solely analyzed synchronization metrics to find the _fastest_ client. But which client is not only fast but also _efficient_ in their resource utilization?

![Disk Usage](https://dev-to-uploads.s3.amazonaws.com/i/zeonkv2pmcjfz1dem6f8.png)

Here, the size of the database is compared across the five clients to the synchronized slot number. Notably, Lodestar comes with the smallest footprint totaling only 1.49 GiB for the fully synchronized mainnet node (420_000 slots). Lighthouse (2.98 GiB) and Prysm (3.16 GiB) follow with good results.

We know that Eth1 nodes store the full block history. Still, they remove historical states to minimize the disk space required for their databases. Eth2 nodes are reasonably comparable to this concept. While keeping all blocks on disk, they remove finalized states. The main difference here is that it's worth keeping historical states on epoch boundaries for convenience. Currently, Nimbus keeps the state on every 32nd epoch boundary while Lodestar only writes the state of every 1024th epoch to disk. The differences are well visible in the plot.

![Memory Usage](https://dev-to-uploads.s3.amazonaws.com/i/lz86mlmyo93nzrzgfnm5.png)

This chart is the same but plotting the resident memory set size of each client during synchronization. Here, the Nimbus client is highly efficient, requiring only about 1 GiB of RAM during the entire processing of the beacon-chain mainnet. Nimbus is followed by Lighthouse and Lodestar, both operating at slightly less than 3 GiB.

One shall note that the off-heap memory that Java allocates for Teku is outside of the client developers' control. The JVM is greedy about available memory. The results of these metrics for Teku vary massively based on the total memory available.

![CPU Usage](https://dev-to-uploads.s3.amazonaws.com/i/xuwsncbsg85s86x8p04j.png)

Last but not least, let's take a look at the CPU utilization. Here, we can also see some interesting differences between the clients.

A blockchain is a highly hierarchical data-structure. Most of the task for synchronizing the chain, validating the blocks, and computing the latest states is a reasonably sequential job. So, the challenge for the clients is to parallelize this process as good as possible. The results above are comparable to the sync speed metrics, with Prysm and Lighthouse leading the field (higher is _more efficient_) and Teku keeping well up.

That's it for now! Any questions?

### FAQ

> _**Excellent article, but why didn't you compare traffic metrics?**_

I did; however, I didn't comment on them all. You can find all plots, including peering and traffic metrics unannotated on Github for a further deep dive: [eth2-bench-mainnet/doc/00-plots-uncommented.md](https://github.com/byz-f/eth2-bench-mainnet/blob/master/doc/00-plots-uncommented.md)

> _**Which client do you personally recommend?**_

That's a tough question. My gut feeling would be leaning towards Lighthouse with the best overall experience, good performance, and many features and tooling available. Still, I would also always run Prysm as it is the most mature and currently the fastest client. My overall experience with Teku is also very satisfying, and I would consider all of them production-ready. 

> _**While I have your attention, will the beacon chain ever be [more than 1 TiB](https://docs.ethhub.io/questions-about-ethereum/is-ethereum-over-1tb-in-size/)?**_

No, comparable to Eth1, the beacon chain in itself is relatively small. The primary factor that could be driving the database size is the beacon state. However, also comparable to Eth1, it's not required to save all states to disk as you would be able to always reconstruct any state from the blocks that you have locally.

In addition to that, proof-of-stake offers finality, which proof-of-work doesn't (reorgs, 51%-attacks). After a certain period, a block is declared final, which means it can never be changed again. The finality concept would allow clients in the future, instead of syncing the chain from genesis, to fetch the latest chain head since the last finalized epoch.

> _**Haven't you done that before, or anyone else?**_

Yes, on Medalla testnet last year:

{% github q9f/eth2-bench-2020-10 no-readme %}

Also, read the [Resource Analysis of Ethereum 2.0 Clients](https://arxiv.org/abs/2012.14718) conducted by the Barcelona Supercomputing Center.

Thank you for scrolling down!
