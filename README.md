# prpl Router CI Demo

This project demonstrates a Jenkins CI pipeline for an embedded router.

## Build
Run ci/build.sh.

## DUT test
Configure DUT_HOST, SSH_USER and SSH_KEY, then run ci/test_dut.sh.

## Safety
Use an isolated test router. This demo does not flash firmware
or reboot the DUT.
