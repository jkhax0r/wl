#!/bin/bash

./dns_probe.sh plex.txt 1500 "i0.wp.com" "i1.wp.com" "www.opensubtitles.com" "secure.gravatar.com" "tmdb.org" "images.plex.tv" "plex.tv" "metadata-static.plex.tv" "metadata.provider.plex.tv" "plex.bz" "tvthemes.plexapp.com.cdn.cloudflare.net" "plexapp.com" "plex.services.com" "thetvdb.com" "themoviedb.com" "lencr.org" "plex.tv" "www.plex.tv" "pubsub.plex.bz"
git add wl/plex.txt

./dns_probe.sh yts.mx.txt 1500 "yts.mx"
git add wl/yts.mx.txt


./dns_probe.sh cloudflared.txt 1500 "region1.v2.argotunnel.com" "region2.v2.argotunnel.com" "_v2-origintunneld._tcp.argotunnel.com" "cftunnel.com" "h2.cftunnel.com" "quic.cftunnel.com"
git add wl/cloudflared.txt

git commit -a -m "update"

