FROM backplane/ghlatest AS downloader
RUN ghlatest download \
  --current-arch --current-os \
  --filter "hugo_extended_withdeploy" --filter "tar.gz" \
  gohugoio/hugo
RUN ghlatest download --filter "_checksums.txt" gohugoio/hugo
# validate the checksums or bomb-out
RUN grep -F -- *.tar.gz *sums.txt | sha256sum -w -s -c -
RUN ghlatest extract --keep hugo --rm *.tar.gz

FROM gcr.io/distroless/cc
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
COPY --from=downloader /work/hugo /bin/

ENV HUGO_BIND="0.0.0.0"
WORKDIR /work
ENTRYPOINT [ "/bin/hugo" ]
CMD [ "--help" ]
