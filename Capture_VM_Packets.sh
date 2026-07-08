#!/usr/bin/env bash
#
# Capture_VM_Packets.sh in Proxmox 
# Starts a Proxmox VM and begins capturing on its tap interface the moment
# that interface appears, so you catch traffic from the earliest possible point.
#
# Usage: ./Capture_VM_Packets.sh <VMID> [output.pcap]
#   e.g. ./Capture_VM_Packets.sh 133 /root/test1.pcap

set -euo pipefail

VMID="${1:?Usage: $0 <VMID> [output.pcap]}"
OUTFILE="${2:-/root/gdid-clean-boot-${VMID}.pcap}"
TAP="tap${VMID}i0"
TIMEOUT=30   # seconds to wait for the tap to appear

# Make sure the VM is not already running (we want a clean boot).
if qm status "$VMID" | grep -q running; then
    echo "VM $VMID is already running. Stop it first for a clean-boot capture:"
    echo "    qm stop $VMID"
    exit 1
fi

echo "Starting VM $VMID..."
qm start "$VMID"

echo "Waiting for interface $TAP to appear (timeout ${TIMEOUT}s)..."
for ((i=0; i<TIMEOUT*10; i++)); do
    if ip link show "$TAP" &>/dev/null; then
        echo "Interface $TAP is up. Starting capture -> $OUTFILE"
        echo "Press Ctrl-C to stop the capture."
        exec tcpdump -i "$TAP" -w "$OUTFILE" -s 0 -U
    fi
    sleep 0.1
done

echo "ERROR: $TAP did not appear within ${TIMEOUT}s." >&2
echo "Check the NIC index (net0 -> i0, net1 -> i1) and that the VM started." >&2
exit 1
