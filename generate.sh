#!/bin/bash

./dns_probe.sh plex.txt 1000 "i0.wp.com" "i1.wp.com" "www.opensubtitles.com" "secure.gravatar.com" "tmdb.org" "images.plex.tv" "plex.tv" "metadata-static.plex.tv" "metadata.provider.plex.tv" "plex.bz" "tvthemes.plexapp.com.cdn.cloudflare.net" "plexapp.com" "plex.services.com" "thetvdb.com" "themoviedb.com" "lencr.org" "plex.tv" "www.plex.tv" "pubsub.plex.bz" "video.internetvideoarchive.net" 

git add wl/plex.txt

./dns_probe.sh yts.mx.txt 25000 "yts.mx"
git add wl/yts.mx.txt


./dns_probe.sh cloudflared.txt 25000 "region1.v2.argotunnel.com" "region2.v2.argotunnel.com" "_v2-origintunneld._tcp.argotunnel.com" "cftunnel.com" "h2.cftunnel.com" "quic.cftunnel.com"
git add wl/cloudflared.txt


./dns_probe.sh synology.txt 25000 "global.download.synology.com" "global.synologydownload.com" "s3.us-west-002.backblazeb2.com" "update7.synology.com" "autoupdate7.synology.com" "payment.synology.com" "account.synology.com" "smtp.gmail.com" "download.synology.com" "www.synology.com" "pkgupdate7.synology.com" "pkgautoupdate.synologyupdate.com" "synoconf.synology.com" "synoconfkms.synology.com" "notification.synology.com" "sns.synology.com" "dataupdate.synology.com" "synology.com" "dataupdate7.synology.com" "dataautoupdate7.synology.com" "database.clamav.net" "myds.synology.com" "update.nai.com" "update.synology.com" "help.synology.com"
git add wl/synology.txt

git commit -a -m "update"

