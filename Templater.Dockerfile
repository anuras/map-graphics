FROM anuras/mapnik:latest

RUN mkdir /wdir
COPY scripts/*.py /wdir/
COPY scripts/*.sh /wdir/
RUN chmod 755 /wdir/docker-create-templates.sh

ENTRYPOINT ["/wdir/docker-create-templates.sh"]
WORKDIR "/wdir"
CMD []