FROM nginx:alpine

COPY index.html notes.html /usr/share/nginx/html/

# Pre-compress the big HTML files so nginx can serve them via gzip_static,
# and expose the tree again under /presentation so the deck works both at
# root and under the path prefix.
RUN cd /usr/share/nginx/html && gzip -k9 index.html notes.html \
    && ln -s . presentation

COPY nginx-default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO /dev/null http://127.0.0.1/ || exit 1
