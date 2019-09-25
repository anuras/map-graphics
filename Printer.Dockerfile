FROM anuras/mapnik:latest

RUN mkdir /wdir
COPY scripts/*.py /wdir/
COPY scripts/*.sh /wdir/
RUN chmod 755 /wdir/docker-print-maps.sh

ENTRYPOINT ["/wdir/docker-print-maps.sh"]
WORKDIR "/wdir"
CMD []