#!/bin/bash


wget https://d7uri8nf7uskq.cloudfront.net/tools/list-cloudfront-ips

cat list-cloudfront-ips | sed -n 1'p' | tr ',' '\n' | while read word; do     grep -oh "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*/[0-9]*"; done | sort | uniq > wl/cloudfront-ips.txt

rm list-cloudfront-ips*
git add wl/cloudfront-ips.txt
#git commit -a -m "update"
#git push

#Certificate authorities
./dns_probe.sh cas.txt 100 "one.digicert.com" "crl.one.digicert.com" "ocsp.one.digicert.com" "cacerts.one.digicert.com" "r11.i.lencr.org" "r10.i.lencr.org" "lencr.org" "crl.certum.pl" "x1.c.lencr.org" "ocsps.ssl.com" "ctldl.windowsupdate.com" "crl.verisign.com" "c.pki.goog" "pki.goog" "verisign.com" "ssl.com" "ocsp.pki.goog" "certum.pl"
git add wl/cas.txt
#git commit -a -m "update"
#git push

#Windows update
./dns_probe.sh windowsupdate.txt 100 "windowsupdate.microsoft.com" "update.microsoft.com" "windowsupdate.com" "download.windowsupdate.com" "download.microsoft.com" "wustat.windows.com" "ntservicepack.microsoft.com" "stats.microsoft.com"
git add wl/windowsupdate.txt
#git commit -a -m "update"
#git push

#smtp.gmail.com
./dns_probe.sh smtp.gmail.com.txt 100 "smtp.gmail.com"
git add wl/smtp.gmail.com.txt
#git commit -a -m "update"
#git push


# For sending gmail notifications
./dns_probe.sh google.txt 100 "googleapis.com"
echo "142.250.0.0/15" >> wl/google.txt
git add wl/google.txt
#git commit -a -m "update"
#git push


#Ips allowed outbound 443/89
./dns_probe.sh yts.mx.txt 100 "yts.mx" "updates.safing.io" "safing.io"
git add wl/yts.mx.txt
#git commit -a -m "update"
#git push


# For cloudflared service
./dns_probe.sh cloudflared.txt 100 "region1.v2.argotunnel.com" "region2.v2.argotunnel.com" "_v2-origintunneld._tcp.argotunnel.com" "cftunnel.com" "h2.cftunnel.com" "quic.cftunnel.com"
git add wl/cloudflared.txt
#git commit -a -m "update"
#git push

# All plex related
./dns_probe.sh plex.txt 100 "i0.wp.com" "i1.wp.com" "www.opensubtitles.com" "secure.gravatar.com" "tmdb.org" "images.plex.tv" "plex.tv" "metadata-static.plex.tv" "metadata.provider.plex.tv" "plex.bz" "tvthemes.plexapp.com.cdn.cloudflare.net" "plexapp.com" "plex.services.com" "thetvdb.com" "themoviedb.com" "lencr.org" "plex.tv" "www.plex.tv" "pubsub.plex.bz" "video.internetvideoarchive.net" "dlza6g8e6iucb.cloudfront.net" "m.media-amazon.com" "media-amazon.com" 
git add wl/plex.txt
#git commit -a -m "update"
#git push


./dns_probe.sh synology.txt 100 "global.download.synology.com" "global.synologydownload.com" "s3.us-west-002.backblazeb2.com" "update7.synology.com" "autoupdate7.synology.com" "payment.synology.com" "account.synology.com" "smtp.gmail.com" "download.synology.com" "www.synology.com" "pkgupdate7.synology.com" "pkgautoupdate.synologyupdate.com" "synoconf.synology.com" "synoconfkms.synology.com" "notification.synology.com" "sns.synology.com" "dataupdate.synology.com" "synology.com" "dataupdate7.synology.com" "dataautoupdate7.synology.com" "database.clamav.net" "myds.synology.com" "update.nai.com" "update.synology.com" "help.synology.com" "utyautoupdate.synology.com" "utyupdate.synology.com" "synosurveillance.synology.com" "us.c2.synology.com"
git add wl/synology.txt

# In case duplicates run iprange again to compact into smallest CIDR
mkdir -p wl_min
cd wl
for file in *; do
	iprange $file > ../wl_min/$file
done
cd ..
git add wl_min/*


git commit -a -m "update"
git push

wait


