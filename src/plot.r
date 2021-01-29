library(scales)
library(zoo)

# lighthouse, lodestar, nimbus, prysm, teku data
lh = read.csv("../dat/210128164829-lighthouse.csv", header = TRUE)
ld = read.csv("../dat/210128164829-lodestar.csv", header = TRUE)
nb = read.csv("../dat/210128164829-nimbus.csv", header = TRUE)
pr = read.csv("../dat/210128164829-prysm.csv", header = TRUE)
tk = read.csv("../dat/210128164829-teku.csv", header = TRUE)

# orange, black, blue, purple, green gradients
col_lh = c("#7f2704","#a63603","#d94801","#f16913","#fd8d3c","#fdae6b","#fdd0a2","#fee6ce","#fff5eb")
col_ld = c("#000000","#252525","#525252","#737373","#969696","#bdbdbd","#d9d9d9","#f0f0f0","#ffffff")
col_nb = c("#08306b","#08519c","#2171b5","#4292c6","#6baed6","#9ecae1","#c6dbef","#deebf7","#f7fbff")
col_pr = c("#3f007d","#54278f","#6a51a3","#807dba","#9e9ac8","#bcbddc","#dadaeb","#efedf5","#fcfbfd")
col_tk = c("#00441b","#006d2c","#238b45","#41ab5d","#74c476","#a1d99b","#c7e9c0","#e5f5e0","#f7fcf5")

# time, slot, slots per second, disk usage, memory usage, peer count, traffic out/in, cpu usage
pairs(lh[,c(2, 3, 12, 5, 6, 7, 8, 9, 10)], main="Lighthouse", pch=".", col=alpha(col_lh[4], 0.3))
pairs(ld[,c(2, 3, 12, 5, 6, 7, 8, 9, 10)], main="Lodestar", pch=".", col=alpha(col_ld[4], 0.3))
pairs(nb[,c(2, 3, 12, 5, 6, 7, 8, 9, 10)], main="Nimbus", pch=".", col=alpha(col_nb[4], 0.3))
pairs(pr[,c(2, 3, 12, 5, 6, 7, 8, 9, 10)], main="Prysm", pch=".", col=alpha(col_pr[4], 0.3))
pairs(tk[,c(2, 3, 12, 5, 6, 7, 8, 9, 10)], main="Teku", pch=".", col=alpha(col_tk[4], 0.3))

# slot over time
sync <- plot(lh$time, lh$slot, main="Synchronization Progress over Time", xlab="Time [s]", ylab="Slot [1]", pch=".", xlim=c(0, 30027+5000), ylim=c(0, 424334+10000), col=alpha(col_lh[5], 0.3))
sync <- lines(pr$time, pr$slot, type="p", pch=".", col=alpha(col_pr[5], 0.3))
sync <- lines(tk$time, tk$slot, type="p", pch=".", col=alpha(col_tk[5], 0.3))
sync <- lines(nb$time, nb$slot, type="p", pch=".", col=alpha(col_nb[5], 0.3))
sync <- lines(ld$time, ld$slot, type="p", pch=".", col=alpha(col_ld[5], 0.3))
sync <- lines(lh$time, rollmean(lh$slot, 600, fill=list(NA, NULL, NA)), col=alpha(col_lh[3], 0.5))
sync <- lines(pr$time, rollmean(pr$slot, 600, fill=list(NA, NULL, NA)), col=alpha(col_pr[3], 0.5))
sync <- lines(tk$time, rollmean(tk$slot, 600, fill=list(NA, NULL, NA)), col=alpha(col_tk[3], 0.5))
sync <- lines(nb$time, rollmean(nb$slot, 600, fill=list(NA, NULL, NA)), col=alpha(col_nb[3], 0.5))
sync <- lines(ld$time, rollmean(ld$slot, 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.5))
sync <- text(9029-1000, 419493+10000, "2h 30min", cex=0.8, pos=4, col=col_lh[2])
sync <- text(14759-1000, 419970+10000, "4h 5min", cex=0.8, pos=4, col=col_pr[2])
sync <- text(7739-0, 0+10000, "Prysm fetching genesis state (#8209)", cex=0.8, pos=4, col=col_pr[2])
sync <- text(18059-1500, 420243+10000, "5h 59sec", cex=0.8, pos=4, col=col_tk[2])
sync <- text(19213+0, 420341+10000, "5h 20min", cex=0.8, pos=4, col=col_nb[2])
sync <- text(30027-1000, 421243+10000, "8h 20min", cex=0.8, pos=4, col=col_ld[2])
sync <- text(24243+1000, 328097+0, "Lodestar JS-heap out-of-memory (#2005)", cex=0.8, pos=4, col=col_ld[2])
sync <- legend("bottomright", pch=19,
               legend = c("Lighthouse", "Prysm", "Teku", "Nimbus", "Lodestar"),
               col=c(col=col_lh[4],col=col_pr[4],col=col_tk[4],col=col_nb[4],col=col_ld[4]))

# slot over vtime (adjusted)
vsync <- plot(lh$vtime, lh$slot, main="Synchronization Progress with Adjusted Start-Time", xlab="Time [s]", ylab="Slot [1]", pch=".", xlim=c(0, 30027+5000), ylim=c(0, 424334+10000), col=alpha(col_lh[5], 0.3))
vsync <- lines(pr$vtime, pr$slot, type="p", pch=".", col=alpha(col_pr[5], 0.3))
vsync <- lines(tk$vtime, tk$slot, type="p", pch=".", col=alpha(col_tk[5], 0.3))
vsync <- lines(nb$vtime, nb$slot, type="p", pch=".", col=alpha(col_nb[5], 0.3))
vsync <- lines(ld$vtime, ld$slot, type="p", pch=".", col=alpha(col_ld[5], 0.3))
vsync <- lines(lh$vtime, rollmean(lh$slot, 600, fill=list(NA, NULL, NA)), col=alpha(col_lh[3], 0.5))
vsync <- lines(pr$vtime, rollmean(pr$slot, 600, fill=list(NA, NULL, NA)), col=alpha(col_pr[3], 0.5))
vsync <- lines(tk$vtime, rollmean(tk$slot, 600, fill=list(NA, NULL, NA)), col=alpha(col_tk[3], 0.5))
vsync <- lines(nb$vtime, rollmean(nb$slot, 600, fill=list(NA, NULL, NA)), col=alpha(col_nb[3], 0.5))
vsync <- lines(ld$vtime, rollmean(ld$slot, 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.5))
vsync <- text(14759-7739-2000, 419970+10000, "1h 57min", cex=0.8, pos=4, col=col_pr[2])
vsync <- text(0+1000, 0+10000, "Start time at first slot synced (#8209)", cex=0.8, pos=4, col=col_pr[2])
vsync <- text(9029-0-1000, 419493+10000, "2h 30min", cex=0.8, pos=4, col=col_lh[2])
vsync <- text(18059-38-1500, 420243+10000, "5h 21sec", cex=0.8, pos=4, col=col_tk[2])
vsync <- text(19213-5+0, 420341+10000, "5h 20min", cex=0.8, pos=4, col=col_nb[2])
vsync <- text(30027-6-1000, 421243+10000, "8h 20min", cex=0.8, pos=4, col=col_ld[2])
vsync <- text(24243+1000, 328097+0, "Lodestar JS-heap out-of-memory (#2005)", cex=0.8, pos=4, col=col_ld[2])
vsync <- legend("bottomright", pch=19,
               legend = c("Prysm", "Lighthouse", "Teku", "Nimbus", "Lodestar"),
               col=c(col=col_pr[4],col=col_lh[4],col=col_tk[4],col=col_nb[4],col=col_ld[4]))

# sps60 over time
sps <- plot(lh$time, lh$sps60, main="Synchronization Speed over Time", xlab="Time [s]", ylab="Slots per Second [1/s]", log="y", xlim=c(0, 30027+5000), ylim=c(1, 150), pch=".", col=alpha(col_lh[5], 0.3))
sps <- lines(pr$time, pr$sps60, type="p", pch=".", col=alpha(col_pr[5], 0.3))
sps <- lines(tk$time, tk$sps60, type="p", pch=".", col=alpha(col_tk[5], 0.3))
sps <- lines(nb$time, nb$sps60, type="p", pch=".", col=alpha(col_nb[5], 0.3))
sps <- lines(ld$time, ld$sps60, type="p", pch=".", col=alpha(col_ld[5], 0.3))
sps <- lines(lh$time[0:8954], rollmean(lh$sps60[0:8954], 600, fill=list(NA, NULL, NA)), col=alpha(col_lh[3], 0.5))
sps <- lines(pr$time[6902:13809], rollmean(pr$sps60[6902:13809], 600, fill=list(NA, NULL, NA)), col=alpha(col_pr[3], 0.5))
sps <- lines(tk$time[38:17955], rollmean(tk$sps60[38:17955], 600, fill=list(NA, NULL, NA)), col=alpha(col_tk[3], 0.5))
sps <- lines(nb$time[4:19113], rollmean(nb$sps60[4:19113], 600, fill=list(NA, NULL, NA)), col=alpha(col_nb[3], 0.5))
sps <- lines(ld$time[6:22501], rollmean(ld$sps60[6:22501], 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.2))
sps <- lines(ld$time[22614:28279], rollmean(ld$sps60[22614:28279], 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.2))
# > 419970/(14759-7739)
# [1] 59.82478632478632478632
sps <- text(14759-1500, 59.825, "59.825/s", cex=0.8, pos=4, col=col_pr[2])
# > 419493/(9029-0)
# [1] 46.46062686897773839849
sps <- text(9029-1500, 46.461, "46.461/s", cex=0.8, pos=4, col=col_lh[2])
# > 420243/(18059-38)
# [1] 23.31962710171466622274
sps <- text(18059-1500, 23.320, "23.320/s", cex=0.8, pos=4, col=col_tk[2])
# > 420341/(19213-5)
# [1] 21.88364223240316534777
sps <- text(19213-0, 21.884, "21.884/s", cex=0.8, pos=4, col=col_nb[2])
# > 357502/(24145-6)
# [1] 14.81014126517254235884
sps <- text(24145-1500, 14.810, "14.810/s", cex=0.8, pos=4, col=col_ld[2])
# > (421243-328097)/(30027-24243)
# [1] 16.10408022130013831259
sps <- text(30027-0, 16.104, "16.104/s (after restart)", cex=0.8, pos=4, col=col_ld[2])
sps <- legend("bottomright", pch=19,
                legend = c("Prysm", "Lighthouse", "Teku", "Nimbus", "Lodestar"),
                col=c(col=col_pr[4],col=col_lh[4],col=col_tk[4],col=col_nb[4],col=col_ld[4]))

# sps60 over slot
spsl <- plot(lh$slot, lh$sps60, main="Synchronization Speed over Sync Progress", xlab="Slot [1]", ylab="Slots per Second [1/s]", log="y", xlim=c(0, 424334+10000), ylim=c(1, 150), pch=".", col=alpha(col_lh[5], 0.3))
spsl <- lines(pr$slot, pr$sps60, type="p", pch=".", col=alpha(col_pr[5], 0.3))
spsl <- lines(tk$slot, tk$sps60, type="p", pch=".", col=alpha(col_tk[5], 0.3))
spsl <- lines(nb$slot, nb$sps60, type="p", pch=".", col=alpha(col_nb[5], 0.3))
spsl <- lines(ld$slot, ld$sps60, type="p", pch=".", col=alpha(col_ld[5], 0.3))
spsl <- lines(lh$slot[0:8954], rollmean(lh$sps60[0:8954], 600, fill=list(NA, NULL, NA)), col=alpha(col_lh[3], 0.5))
spsl <- lines(pr$slot[6902:13809], rollmean(pr$sps60[6902:13809], 600, fill=list(NA, NULL, NA)), col=alpha(col_pr[3], 0.5))
spsl <- lines(tk$slot[38:17955], rollmean(tk$sps60[38:17955], 600, fill=list(NA, NULL, NA)), col=alpha(col_tk[3], 0.5))
spsl <- lines(nb$slot[4:19113], rollmean(nb$sps60[4:19113], 600, fill=list(NA, NULL, NA)), col=alpha(col_nb[3], 0.5))
spsl <- lines(ld$slot[6:22501], rollmean(ld$sps60[6:22501], 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.1))
spsl <- lines(ld$slot[22614:28279], rollmean(ld$sps60[22614:28279], 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.1))
# > 419970/(14759-7739)
# [1] 59.82478632478632478632
spsl <- text(424334, 59.825, "59.825/s", cex=0.8, pos=4, col=col_pr[2])
# > 419493/(9029-0)
# [1] 46.46062686897773839849
spsl <- text(424334, 46.461, "46.461/s", cex=0.8, pos=4, col=col_lh[2])
# > 420243/(18059-38)
# [1] 23.31962710171466622274
spsl <- text(424334, 24, "23.320/s", cex=0.8, pos=4, col=col_tk[2])
# > 420341/(19213-5)
# [1] 21.88364223240316534777
spsl <- text(424334, 21, "21.884/s", cex=0.8, pos=4, col=col_nb[2])
# > 357502/(24145-6)
# [1] 14.81014126517254235884
spsl <- text(328097-10000, 14.810, "14.810/s", cex=0.8, pos=4, col=col_ld[2])
# > (421243-328097)/(30027-24243)
# [1] 16.10408022130013831259
spsl <- text(424334, 16.104, "16.104/s", cex=0.8, pos=4, col=col_ld[2])
spsl <- legend("bottomright", pch=19,
              legend = c("Prysm", "Lighthouse", "Teku", "Nimbus", "Lodestar"),
              col=c(col=col_pr[4],col=col_lh[4],col=col_tk[4],col=col_nb[4],col=col_ld[4]))

# db over time
dbt <- plot(tk$time, tk$db, main="Disk Usage over Time", xlab="Time [s]", ylab="Database Size [B]", pch=".", log="y", xlim=c(0, 30027+5000), ylim=c(50000000, 7000000000), col=alpha(col_tk[5], 0.3))
dbt <- lines(pr$time, pr$db, type="p", pch=".", col=alpha(col_pr[5], 0.3))
dbt <- lines(lh$time, lh$db, type="p", pch=".", col=alpha(col_lh[5], 0.3))
dbt <- lines(nb$time, nb$db, type="p", pch=".", col=alpha(col_nb[5], 0.3))
dbt <- lines(ld$time, ld$db, type="p", pch=".", col=alpha(col_ld[5], 0.3))
dbt <- lines(lh$time, rollmean(lh$db, 600, fill=list(NA, NULL, NA)), col=alpha(col_lh[3], 0.5))
dbt <- lines(pr$time, rollmean(pr$db, 600, fill=list(NA, NULL, NA)), col=alpha(col_pr[3], 0.5))
dbt <- lines(tk$time, rollmean(tk$db, 600, fill=list(NA, NULL, NA)), col=alpha(col_tk[3], 0.5))
dbt <- lines(nb$time, rollmean(nb$db, 600, fill=list(NA, NULL, NA)), col=alpha(col_nb[3], 0.5))
dbt <- lines(ld$time, rollmean(ld$db, 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.5))
# > max(tk$db[0:30027])
# [1] 5001367200
# > max(tk$db[0:30027])/1024/1024/1024
# [1] 4.657886
dbt <- text(24000, 5001367200+200000000, "4.658 GiB", cex=0.8, pos=4, col=col_tk[2])
# > max(nb$db[0:30027])
# [1] 4822584504
# > max(nb$db[0:30027])/1024/1024/1024
# [1] 4.491382
dbt <- text(19000, 4822584504+300000000, "4.491 GiB", cex=0.8, pos=4, col=col_nb[2])
# > max(pr$db[0:30027])
# [1] 3393183744
# > max(pr$db[0:30027])/1024/1024/1024
# [1] 3.160149
dbt <- text(18000, 3393183744+200000000, "3.160 GiB", cex=0.8, pos=4, col=col_pr[2])
# > max(lh$db[0:30027])
# [1] 3194929693
# > max(lh$db[0:30027])/1024/1024/1024
# [1] 2.97551
dbt <- text(21000, 3194929693-50000000, "2.976 GiB", cex=0.8, pos=4, col=col_lh[2])
# > max(ld$db[0:30027])
# [1] 1599823563
# > max(ld$db[0:30027])/1024/1024/1024
# [1] 1.489952
dbt <- text(30000, 1599823563+50000000, "1.490 GiB", cex=0.8, pos=4, col=col_ld[2])
dbt <- legend("bottomright", pch=19,
             legend = c("Teku", "Nimbus", "Prysm", "Lighthouse", "Lodestar"),
             col=c(col=col_tk[4],col=col_nb[4],col=col_pr[4],col=col_lh[4],col=col_ld[4]))

# db over slot
dbs <- plot(tk$slot, tk$db, main="Disk Usage over Sync Progress", xlab="Slot [1]", ylab="Database Size [B]", pch=".", log="y", xlim=c(0, 424334+20000), ylim=c(50000000, 7000000000), col=alpha(col_tk[5], 0.3))
dbs <- lines(pr$slot, pr$db, type="p", pch=".", col=alpha(col_pr[5], 0.3))
dbs <- lines(lh$slot, lh$db, type="p", pch=".", col=alpha(col_lh[5], 0.3))
dbs <- lines(nb$slot, nb$db, type="p", pch=".", col=alpha(col_nb[5], 0.3))
dbs <- lines(ld$slot, ld$db, type="p", pch=".", col=alpha(col_ld[5], 0.3))
dbs <- lines(lh$slot, rollmean(lh$db, 600, fill=list(NA, NULL, NA)), col=alpha(col_lh[3], 0.5))
dbs <- lines(pr$slot, rollmean(pr$db, 600, fill=list(NA, NULL, NA)), col=alpha(col_pr[3], 0.5))
dbs <- lines(tk$slot, rollmean(tk$db, 600, fill=list(NA, NULL, NA)), col=alpha(col_tk[3], 0.5))
dbs <- lines(nb$slot, rollmean(nb$db, 600, fill=list(NA, NULL, NA)), col=alpha(col_nb[3], 0.5))
dbs <- lines(ld$slot, rollmean(ld$db, 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.1))
# > max(tk$db[0:30027])
# [1] 5001367200
# > max(tk$db[0:30027])/1024/1024/1024
# [1] 4.657886
dbs <- text(424334, 5001367200+300000000, "4.658 GiB", cex=0.8, pos=4, col=col_tk[2])
# > max(nb$db[0:30027])
# [1] 4822584504
# > max(nb$db[0:30027])/1024/1024/1024
# [1] 4.491382
dbs <- text(424334, 4822584504-100000000, "4.491 GiB", cex=0.8, pos=4, col=col_nb[2])
# > max(pr$db[0:30027])
# [1] 3393183744
# > max(pr$db[0:30027])/1024/1024/1024
# [1] 3.160149
dbs <- text(424334, 3393183744+100000000, "3.160 GiB", cex=0.8, pos=4, col=col_pr[2])
# > max(lh$db[0:30027])
# [1] 3194929693
# > max(lh$db[0:30027])/1024/1024/1024
# [1] 2.97551
dbs <- text(424334, 3194929693-50000000, "2.976 GiB", cex=0.8, pos=4, col=col_lh[2])
# > max(ld$db[0:30027])
# [1] 1599823563
# > max(ld$db[0:30027])/1024/1024/1024
# [1] 1.489952
dbs <- text(424334, 1599823563+0, "1.490 GiB", cex=0.8, pos=4, col=col_ld[2])
dbs <- legend("bottomright", pch=19,
             legend = c("Teku", "Nimbus", "Prysm", "Lighthouse", "Lodestar"),
             col=c(col=col_tk[4],col=col_nb[4],col=col_pr[4],col=col_lh[4],col=col_ld[4]))

# mem over time
memt <- plot(tk$time, tk$mem, main="Memory Usage over Time", xlab="Time [s]", ylab="Resident Memory [B]", pch=".", log="y", xlim=c(0, 30027+5000), ylim=c(100000000, 13000000000), col=alpha(col_tk[5], 0.3))
memt <- lines(pr$time, pr$mem, type="p", pch=".", col=alpha(col_pr[5], 0.3))
memt <- lines(lh$time, lh$mem, type="p", pch=".", col=alpha(col_lh[5], 0.3))
memt <- lines(nb$time, nb$mem, type="p", pch=".", col=alpha(col_nb[5], 0.3))
memt <- lines(ld$time, ld$mem, type="p", pch=".", col=alpha(col_ld[5], 0.3))
memt <- lines(lh$time, rollmean(lh$mem, 600, fill=list(NA, NULL, NA)), col=alpha(col_lh[3], 0.5))
memt <- lines(pr$time, rollmean(pr$mem, 600, fill=list(NA, NULL, NA)), col=alpha(col_pr[3], 0.5))
memt <- lines(tk$time, rollmean(tk$mem, 600, fill=list(NA, NULL, NA)), col=alpha(col_tk[3], 0.5))
memt <- lines(nb$time, rollmean(nb$mem, 600, fill=list(NA, NULL, NA)), col=alpha(col_nb[3], 0.5))
memt <- lines(ld$time, rollmean(ld$mem, 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.5))
# > max(tk$mem[0:30027])
# [1] 12298780672
# > max(tk$mem[0:30027])/1024/1024/1024
# [1] 11.45413
memt <- text(30027, 12298780672+500000000, "11.454 GiB", cex=0.8, pos=4, col=col_tk[2])
# > max(pr$mem[0:30027])
# [1] 6228918272
# > max(pr$mem[0:30027])/1024/1024/1024
# [1] 5.801132
memt <- text(30027, 6228918272+300000000, "5.801 GiB", cex=0.8, pos=4, col=col_pr[2])
# > max(ld$mem[0:22501])
# [1] 3126464512
# > max(ld$mem[0:22501])/1024/1024/1024
# [1] 2.911747
memt <- text(24145, 3126464512+300000000, "2.912 GiB", cex=0.8, pos=4, col=col_ld[2])
# > max(ld$mem[22614:28279])
# [1] 2311073792
# > max(ld$mem[22614:28279])/1024/1024/1024
# [1] 2.152355
memt <- text(30027, 2311073792+0, "2.152 GiB", cex=0.8, pos=4, col=col_ld[2])
# > max(lh$mem[0:30027])
# [1] 2900750336
# > max(lh$mem[0:30027])/1024/1024/1024
# [1] 2.701534
memt <- text(30027, 2900750336+200000000, "2.702 GiB", cex=0.8, pos=4, col=col_lh[2])
# > max(nb$mem[0:30027])
# [1] 1092087808
# > max(nb$mem[0:30027])/1024/1024/1024
# [1] 1.017086
memt <- text(30027, 1092087808+100000000, "1.017 GiB", cex=0.8, pos=4, col=col_nb[2])
memt <- legend("bottomright", pch=19,
             legend = c("Teku", "Prysm", "Lodestar", "Lighthouse", "Nimbus"),
             col=c(col=col_tk[4],col=col_pr[4],col=col_ld[4],col=col_lh[4],col=col_nb[4]))

# mem over slot
mems <- plot(tk$slot, tk$mem, main="Memory Usage over Sync Progress", xlab="Slot [1]", ylab="Resident Memory [B]", pch=".", log="y", xlim=c(0, 424334+20000), ylim=c(100000000, 13000000000), col=alpha(col_tk[5], 0.3))
mems <- lines(pr$slot, pr$mem, type="p", pch=".", col=alpha(col_pr[5], 0.3))
mems <- lines(lh$slot, lh$mem, type="p", pch=".", col=alpha(col_lh[5], 0.3))
mems <- lines(nb$slot, nb$mem, type="p", pch=".", col=alpha(col_nb[5], 0.3))
mems <- lines(ld$slot, ld$mem, type="p", pch=".", col=alpha(col_ld[5], 0.3))
mems <- lines(lh$slot, rollmean(lh$mem, 600, fill=list(NA, NULL, NA)), col=alpha(col_lh[3], 0.5))
mems <- lines(pr$slot, rollmean(pr$mem, 600, fill=list(NA, NULL, NA)), col=alpha(col_pr[3], 0.5))
mems <- lines(tk$slot, rollmean(tk$mem, 600, fill=list(NA, NULL, NA)), col=alpha(col_tk[3], 0.5))
mems <- lines(nb$slot, rollmean(nb$mem, 600, fill=list(NA, NULL, NA)), col=alpha(col_nb[3], 0.5))
mems <- lines(ld$slot, rollmean(ld$mem, 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.1))
# > max(tk$mem[0:30027])
# [1] 12298780672
# > max(tk$mem[0:30027])/1024/1024/1024
# [1] 11.45413
mems <- text(424334, 12298780672, "11.454 GiB", cex=0.8, pos=4, col=col_tk[2])
# > max(pr$mem[0:30027])
# [1] 6228918272
# > max(pr$mem[0:30027])/1024/1024/1024
# [1] 5.801132
mems <- text(424334, 6228918272, "5.801 GiB", cex=0.8, pos=4, col=col_pr[2])
# > max(ld$mem[0:22501])
# [1] 3126464512
# > max(ld$mem[0:22501])/1024/1024/1024
# [1] 2.911747
mems <- text(357502, 3126464512, "2.912 GiB", cex=0.8, pos=4, col=col_ld[2])
# > max(ld$mem[22614:28279])
# [1] 2311073792
# > max(ld$mem[22614:28279])/1024/1024/1024
# [1] 2.152355
mems <- text(424334, 2311073792, "2.152 GiB", cex=0.8, pos=4, col=col_ld[2])
# > max(lh$mem[0:30027])
# [1] 2900750336
# > max(lh$mem[0:30027])/1024/1024/1024
# [1] 2.701534
mems <- text(424334, 2900750336, "2.702 GiB", cex=0.8, pos=4, col=col_lh[2])
# > max(nb$mem[0:30027])
# [1] 1092087808
# > max(nb$mem[0:30027])/1024/1024/1024
# [1] 1.017086
mems <- text(424334, 1092087808, "1.017 GiB", cex=0.8, pos=4, col=col_nb[2])
mems <- legend("bottomright", pch=19,
             legend = c("Teku", "Prysm", "Lodestar", "Lighthouse", "Nimbus"),
             col=c(col=col_tk[4],col=col_pr[4],col=col_ld[4],col=col_lh[4],col=col_nb[4]))

# pc over time
pert <- plot(nb$time, nb$pc, main="P2P Connections over Time", xlab="Time [s]", ylab="Peers [1]", pch=".", ylim=c(-20,170), xlim=c(0, 30027+5000), col=alpha(col_nb[5], 0.3))
pert <- lines(pr$time, pr$pc, type="p", pch=".", col=alpha(col_pr[5], 0.3))
pert <- lines(lh$time, lh$pc, type="p", pch=".", col=alpha(col_lh[5], 0.3))
pert <- lines(tk$time, tk$pc, type="p", pch=".", col=alpha(col_tk[5], 0.3))
pert <- lines(ld$time, ld$pc, type="p", pch=".", col=alpha(col_ld[5], 0.3))
pert <- lines(lh$time, rollmean(lh$pc, 600, fill=list(NA, NULL, NA)), col=alpha(col_lh[3], 0.5))
pert <- lines(pr$time, rollmean(pr$pc, 600, fill=list(NA, NULL, NA)), col=alpha(col_pr[3], 0.5))
pert <- lines(tk$time, rollmean(tk$pc, 600, fill=list(NA, NULL, NA)), col=alpha(col_tk[3], 0.5))
pert <- lines(nb$time, rollmean(nb$pc, 600, fill=list(NA, NULL, NA)), col=alpha(col_nb[3], 0.5))
pert <- lines(ld$time, rollmean(ld$pc, 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.5))
pert <- legend("bottomright", pch=19,
               legend = c("Nimbus", "Teku", "Lighthouse", "Prysm", "Lodestar"),
               col=c(col=col_nb[4],col=col_tk[4],col=col_lh[4],col=col_pr[4],col=col_ld[4]))

# pc over slot
pers <- plot(nb$slot, nb$pc, main="P2P Connections over Sync Progress", xlab="Slot [1]", ylab="Peers [1]", pch=".", ylim=c(-20,170), xlim=c(0, 424334+20000), col=alpha(col_nb[5], 0.3))
pers <- lines(pr$slot, pr$pc, type="p", pch=".", col=alpha(col_pr[5], 0.3))
pers <- lines(lh$slot, lh$pc, type="p", pch=".", col=alpha(col_lh[5], 0.3))
pers <- lines(tk$slot, tk$pc, type="p", pch=".", col=alpha(col_tk[5], 0.3))
pers <- lines(ld$slot, ld$pc, type="p", pch=".", col=alpha(col_ld[5], 0.3))
pers <- lines(lh$slot, rollmean(lh$pc, 600, fill=list(NA, NULL, NA)), col=alpha(col_lh[3], 0.5))
pers <- lines(pr$slot, rollmean(pr$pc, 600, fill=list(NA, NULL, NA)), col=alpha(col_pr[3], 0.5))
pers <- lines(tk$slot, rollmean(tk$pc, 600, fill=list(NA, NULL, NA)), col=alpha(col_tk[3], 0.5))
pers <- lines(nb$slot, rollmean(nb$pc, 600, fill=list(NA, NULL, NA)), col=alpha(col_nb[3], 0.5))
pers <- lines(ld$slot, rollmean(ld$pc, 600, fill=list(NA, NULL, NA)), col=alpha(col_ld[3], 0.1))
pers <- legend("bottomright", pch=19,
               legend = c("Nimbus", "Teku", "Lighthouse", "Prysm", "Lodestar"),
               col=c(col=col_nb[4],col=col_tk[4],col=col_lh[4],col=col_pr[4],col=col_ld[4]))


