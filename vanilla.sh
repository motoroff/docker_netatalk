docker run --detach \
    --volume /share:/media/share \
    --net "host" \
    --name netatalk_krb5 \
   afpkrb5:3111
