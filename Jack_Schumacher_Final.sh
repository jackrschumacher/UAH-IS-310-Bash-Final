#!/bin/bash

# Jack Schumacher Bash Final project
echo "Domain reconnisance tool"
if ping -c 1 -W 2 1.1.1.1 > /dev/null 2>&1; then
    echo "Checking network speed"
    speedtest-cli --secure
    read -p "Enter a domain to perform reconissance on: " domain

        echo "Listing domains owned by the same organization:"
        echo "Listing domains owned by the same organization:" >> domain_results.txt
        amass intel -d "$domain" -whois -v | tee -a domain_results.txt

        echo "Listing subdomains:"
        echo "Listing subdomains:" >> domain_results.txt
        amass enum -d "$domain" -active -src -v | tee -a domain_results.txt

    else
        echo "Network not connected"
    fi

