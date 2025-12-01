#!/bin/bash

# Jack Schumacher Bash Final project
echo "Domain reconnisance tool"
if ping -c 1 -W 2 1.1.1.1 > /dev/null 2>&1; then
    echo "Checking network speed"
    speedtest-cli --secure
    read -p "Enter a domain to perform reconissance on: " domain

        echo "Listing domains owned by the same organization:"
        amass intel -d "$domain" -whois -v

        echo "Listing subdomains:"
        amass enum -d "$domain" -active -src -v

    else
        echo "Network not connected"
    fi

