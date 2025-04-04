FROM backplane/vueenv
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

USER root
RUN npm install --global \
    '@aws-amplify/cli' \
  ;
USER vue

WORKDIR /work
CMD [ "/bin/bash" ]
