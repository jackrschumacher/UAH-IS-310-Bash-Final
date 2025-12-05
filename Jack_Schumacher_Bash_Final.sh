#!/bin/bash

# Installing all tools
echo "Install whois, amass and dnstwist"
sudo apt install whois
sudo snap install amass
sudo apt install dnstwist


# File vairables
mkdir -p results
subdomain_file=results/subdomain_results.txt
domain_file=results/domain_results.txt
phising_prevention_file=results/phising_prevention_results.txt


# Jack Schumacher Bash Final project
echo "Domain reconnisance tool"
if ping -c 1 -W 2 1.1.1.1 > /dev/null 2>&1; then
    echo "Checking network speed to ensure stability when running tool. This test will take 30 seconds."
    iperf3 -c ping.online.net  -p 5200 -t 30
    read -p "Enter a domain to perform reconissance on: " domain
        echo "Checking domain legitimacy using openssl"

        whois_results=$(whois "$domain")
        if [ -z "$whois_results" ]; then #Check if there are any domain results
            echo "No domain results have been found"
            echo "No domain results have been found" >> "$domain_file"
        else
            echo "$whois_results"
            echo "$whois_results" | tee -a "$domain_file"
        fi
        echo "Domain legitimacy using openssl:" >> "$domain_file"

        ssl_results=$(echo | openssl s_client -connect "$domain":443 2>/dev/null | openssl x509 -noout -dates -issuer)
        if [ -z "$ssl_results" ]; then
            echo "No openssl results found"
            echo "No openssl results found" >> "$domain_file"
        else
            echo "$ssl_results"
            echo "$ssl_results" | tee -a "$domain_file"
        fi


        echo "Listing domains owned by the same organization:"
        echo "Listing domains owned by the same organization:" >> "$domain_file"
        domains_by_same_org=$(amass intel -d "$domain" -whois)
        if [ -v "$domains_by_same_org" ];then
            echo "No domains from the same organization found"
            echo "No domains from the same organization found" >> "$domain_file"
        else
            echo "$domains_by_same_org" >> "$domain_file"
        fi

        echo "Listing subdomains:"
        echo "Listing subdomains:" >> "$subdomain_file"
        subdomains=$(amass enum -d "$domain" -active -src -v)
        if [ -v "$subdomains" ];then
            echo "No subdomains found"
            echo "No subdomains found" >> "$subdomain_file"
        else
            echo "$subdomains" | tee -a "$subdomain_file"
        fi

        echo "Checking for similar domains that may be used for phising"
        echo "Checking for similar domains that may be used for phising" >> "$phising_prevention_file"
        phising_domains=$(dnstwist "$domain")
        if [ -v "$phising_domains" ]; then
            echo "No possible phising domains found"
            echo "No possible phising domains found" >> "$phising_prevention_file"
        else
            echo "$phising_domains"
            echo "phising_domains" >> "$phising_prevention_file"
        fi
    else
        echo "Network not connected"
    fi

