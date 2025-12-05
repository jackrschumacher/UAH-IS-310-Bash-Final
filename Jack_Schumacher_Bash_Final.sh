#!/bin/bash

# Installing all tools - whois, amass, iperf3 and dnstwist
echo "Install whois, amass, iperf3 and dnstwist"
sudo apt install whois
sudo snap install amass
sudo apt install dnstwist
sudo apt install iperf3
clear


# File vairables
# Create a directory and files variables since they are used multiple times
mkdir -p results
subdomain_file=results/subdomain_results.txt
phising_prevention_file=results/phising_prevention_results.txt


# Jack Schumacher Bash Final project
echo "Domain reconnisance tool"
# Ping cloudflare to check if network, if not quit the script as there is nothing that can be done
if ping -c 1 -W 2 1.1.1.1 > /dev/null 2>&1; then
    echo "Checking network speed to ensure stability when running tool. This test will take 30 seconds. Press ctrl+c to cancel the test" #Run a speedtest since this program requires a stable internet connection
    iperf3 -c ping.online.net  -p 5200 -t 30
    pkill iperf3 #Kill iperf3 after the test is completed
    read -p "Enter a domain to perform reconissance on: " domain
        # Return the whois records of the domain
        echo "Checking domain legitimacy"
        whois_results=$(whois "$domain")
        if [ -z "$whois_results" ]; then #Check if there are any domain results
            echo "No domain results have been found"
            echo "No domain results have been found" >> "$domain_file"
        else
            echo "$whois_results"
            echo "$whois_results" | tee -a "$domain_file"
        fi

        echo "Domain legitimacy using openssl:" >> "$domain_file"

        # Check openssl results for a domain recording issuer and dates- easily able to add more
        ssl_results=$(echo | openssl s_client -connect "$domain":443 2>/dev/null | openssl x509 -noout -dates -issuer)
        if [ -z "$ssl_results" ]; then #Check if there are any openssl results for the domain
            echo "No openssl results found"
            echo "No openssl results found" >> "$domain_file"
        else
            echo "$ssl_results"
            echo "$ssl_results" | tee -a "$domain_file"
        fi

        # List subdomains
        echo "Listing subdomains:"
        echo "Listing subdomains:" >> "$subdomain_file"
        amass enum -d "$domain" -active -src -v | tee -a "$subdomain_file"
        if [ ! -s "$subdomain_file" ];then
            echo "No subdomains found"
            echo "No subdomains found" >> "$subdomain_file"
        fi
        # Checking if there are similar domains registered that may be used in order to phish users
        echo "Checking for similar domains that may be used for phising:"
        echo "Please wait"
        echo "Checking for similar domains that may be used for phising:" >> "$phising_prevention_file"
        phising_domains=$(dnstwist --registered "$domain")

        if [ -z "$phising_domains" ]; then
            echo "No possible phising domains found"
            echo "No possible phising domains found" >> "$phising_prevention_file"
        else
            echo "$phising_domains"
            echo "$phising_domains" >> "$phising_prevention_file"
        fi
    else # Returns message if no network is connected
        echo "Network not connected"
    fi

