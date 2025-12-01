#!/usr/bin/env python3
import time
import json

def read_bytes(interface):
    with open(f"/sys/class/net/{interface}/statistics/rx_bytes") as f:
        rx = int(f.read())
    with open(f"/sys/class/net/{interface}/statistics/tx_bytes") as f:
        tx = int(f.read())
    return rx, tx

def format_speed(bytes_per_sec):
    if bytes_per_sec >= 1024 * 1024:
        return f"{bytes_per_sec / (1024*1024):.1f} MB/s"
    elif bytes_per_sec >= 1024:
        return f"{bytes_per_sec / 1024:.1f} KB/s"
    else:
        return f"{bytes_per_sec} B/s"

# Auto detect interface (ignore lo)
import os
interfaces = [i for i in os.listdir("/sys/class/net") if i != "lo"]
interface = interfaces[0] if interfaces else "eth0"

rx_prev, tx_prev = read_bytes(interface)
time_prev = time.time()

while True:
    time.sleep(1)
    rx, tx = read_bytes(interface)
    t = time.time()

    rx_speed = (rx - rx_prev) / (t - time_prev)
    tx_speed = (tx - tx_prev) / (t - time_prev)

    rx_prev, tx_prev = rx, tx
    time_prev = t

    output = {
        "text": f"↓ {format_speed(rx_speed)}  ↑ {format_speed(tx_speed)}",
        "tooltip": f"Interface: {interface}\nDownload: {format_speed(rx_speed)}\nUpload: {format_speed(tx_speed)}"
    }

    print(json.dumps(output), flush=True)

