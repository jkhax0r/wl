#!/bin/bash
 
# All cloudflare IPs
curl -s https://www.cloudflare.com/ips-v4/ | iprange - --except exclude-ips.txt > wl/cloudflare-ips.txt

# Akamai CDN 
curl -s https://techdocs.akamai.com/property-manager/pdfs/akamai_ipv4_CIDRs.txt | iprange - --except exclude-ips.txt > wl/akamai_cdn.txt

# Github and gitlab git access
./dns_probe.sh git.txt 1000 "gitlab.com"
echo ""
echo "#github git list (https://api.github.com/meta)" >> wl/git.txt
curl -s https://api.github.com/meta | jq '.git' | egrep -o "([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(\/[0-9]{1,2})?)" >> wl/git.txt

echo "#github web servers list (https://api.github.com/meta)" >> wl/github_web.txt
curl -s https://api.github.com/meta | jq '.web' | egrep -o "([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(\/[0-9]{1,2})?)" >> wl/github_web.txt

# All cloudfront ips
curl -s https://d7uri8nf7uskq.cloudfront.net/tools/list-cloudfront-ips | jq '.CLOUDFRONT_GLOBAL_IP_LIST' | egrep -o "([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(\/[0-9]{1,2})?)" | iprange - --except exclude-ips.txt

#Certificate authorities
./dns_probe.sh cas.txt 1000 "one.digicert.com" "crl.one.digicert.com" "ocsp.one.digicert.com" "cacerts.one.digicert.com" "r11.o.lencr.org" "r11.i.lencr.org" "r10.i.lencr.org" "e5.o.lencr.org" "lencr.org" "crl.certum.pl" "x1.c.lencr.org" "ocsps.ssl.com" "ctldl.windowsupdate.com" "crl.verisign.com" "c.pki.goog" "pki.goog" "verisign.com" "ssl.com" "ocsp.pki.goog" "certum.pl" "crt.buypass.no" "buypass.no" "ocsp-certum.com" "subca.ocsp-certum.com" "crl.entrust.net" "entrust.net" "usertrust.com" "ocsp.usertrust.com" "crl3.digicert.com" "ocsp.digicert.com" "crl4.digicert.com" "comodoca.com"

# Docker
./dns_probe.sh docker.txt 1000 "index.docker.io" "registry-1.docker.io" "docker.io"

# linuxserver.io
./dns_probe.sh linuxserver.io.txt 1000 "lscr.io" "pkgs.tailscale.com" "tailscale.com"

#Windows store - general things windows store hits
./dns_probe.sh windowsstore.txt 1000 "store-images.s-microsoft.com" "images-eds-ssl.xboxlive.com" "xboxlive.com" "da.xboxservices.com" "storeedgefd.dsx.mp.microsoft.com" "store-images.microsoft.com" "displaycatalog.mp.microsoft.com" "licensing.mp.microsoft.com" "mp.microsoft.com"

#Windows update
./dns_probe.sh windowsupdate.txt 1000 "windowsupdate.microsoft.com" "update.microsoft.com" "windowsupdate.com" "download.windowsupdate.com" "download.microsoft.com" "wustat.windows.com" "ntservicepack.microsoft.com" "stats.microsoft.com"

#smtp.gmail.com
./dns_probe.sh smtp.gmail.com.txt 1000 "smtp.gmail.com"

# For sending gmail notifications
./dns_probe.sh google.txt 1000 "googleapis.com"
echo "142.250.0.0/15" >> wl/google.txt

#Ips allowed outbound 443/89
./dns_probe.sh yts.mx.txt 1000 "yts.mx" "updates.safing.io" "safing.io"

# For cloudflared service
./dns_probe.sh cloudflared.txt 1000 "region1.v2.argotunnel.com" "region2.v2.argotunnel.com" "_v2-origintunneld._tcp.argotunnel.com" "cftunnel.com" "h2.cftunnel.com" "quic.cftunnel.com"

# All plex related
./dns_probe.sh plex.txt 1000 "i0.wp.com" "i1.wp.com" "www.opensubtitles.com" "secure.gravatar.com" "images.plex.tv" "plex.tv" "metadata-static.plex.tv" "metadata.provider.plex.tv" "plex.bz" "tvthemes.plexapp.com.cdn.cloudflare.net" "plexapp.com" "plex.services.com" "themoviedb.com" "plex.tv" "www.plex.tv" "pubsub.plex.bz" "video.internetvideoarchive.net" 
# Removed these 2, think it's mostly cloudfront... "m.media-amazon.com" "media-amazon.com" 


./dns_probe.sh synology.txt 1000 "global.download.synology.com" "global.synologydownload.com" "s3.us-west-002.backblazeb2.com" "update7.synology.com" "autoupdate7.synology.com" "payment.synology.com" "account.synology.com" "smtp.gmail.com" "download.synology.com" "www.synology.com" "pkgupdate7.synology.com" "pkgautoupdate.synologyupdate.com" "synoconf.synology.com" "synoconfkms.synology.com" "notification.synology.com" "sns.synology.com" "dataupdate.synology.com" "synology.com" "dataupdate7.synology.com" "dataautoupdate7.synology.com" "database.clamav.net" "myds.synology.com" "update.nai.com" "update.synology.com" "help.synology.com" "utyautoupdate.synology.com" "utyupdate.synology.com" "synosurveillance.synology.com" "us.c2.synology.com" "checkip.synology.com" "checkip.dyndns.org"

# In case duplicates run iprange again to compact into smallest CIDR
mkdir -p wl_min
cd wl
for file in *; do
	iprange $file --except exclude-ips.txt > ../wl_min/$file
done
cd ..
git add wl_min/*
git add wl/*

git commit -a -m "update"
git push

wait


