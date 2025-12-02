#!/bin/bash

# Jack Schumacher Bash Final project
echo "Domain reconnisance tool"
if ping -c 1 -W 2 1.1.1.1 > /dev/null 2>&1; then
    echo "Checking network speed to ensure stability when running tool. This test will take 30 seconds."
    iperf3 -c ping.online.net  -p 5200 -t 30
    read -p "Enter a domain to perform reconissance on: " domain
        echo "Checking domain legitimacy using openssl"
        echo "Domain legitimacy using openssl:" >> domain_results.txt
        whois "$domain" | tee -a domain_results.txt
        echo | openssl s_client -connect "$domain":443 2>/dev/null | openssl x509 -noout -dates -issuer| tee -a domain_results.txt

        echo "Listing domains owned by the same organization:"
        echo "Listing domains owned by the same organization:" >> domain_results.txt
        amass intel -d "$domain" -whois -v | tee -a domain_results.txt

        echo "Listing subdomains:"
        echo "Listing subdomains:" >> domain_results.txt
        amass enum -d "$domain" -active -src -v | tee -a domain_results.txt

    else
        echo "Network not connected"
    fi

