# Autoevillimiter.sh
This alters bandwith on all devices except those you exclude

## Why? [![start with why](https://img.shields.io/badge/start%20with-why%3F-brightgreen.svg?style=flat)](http://www.ted.com/talks/simon_sinek_how_great_leaders_inspire_action) <br>
Our internet is too slow for multiple users

## Use
| Parameter | Description |
| --- | --- |
| -s or --speed | Network bandwidth<br> <integer>bit-kbit-mbit, Example: 12mbit |
| -e or --exclude | Excluded ip or mac addresses, comma separated<br> Example: 192.168.1.90,AA:BB:CC:DD:EE:FF,192.168.1.91 |
| -i or --install | Download and install evillimiter which is required for this script to work |

<br>

<p align='center'>
  Examle: <code>./autoevillimiter.sh --exclude 192.168.1.90,AA:BB:CC:DD:EE:FF,192.168.1.91 --speed 12mbit</code><br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code>./autoevillimiter.sh --install</code>
</p>
