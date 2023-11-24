FROM ubuntu:18.04

COPY DISCUS_* /tmp/
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:hvr/ghc && \
    apt-get update && \
    apt-get install -y git ghc-8.6.3 gcc cabal-install-2.4 llvm locales && \
    locale-gen "en_US.UTF-8" && \
    update-locale LC_ALL="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
RUN export PATH=/opt/ghc/8.6.3/bin:/opt/cabal/2.4/bin:$PATH && \
    cd /opt && \
    git clone https://github.com/discus-lang/ddc && \
    cd ddc && \
    git reset --hard $(cat /tmp/DISCUS_COMMIT_HASH) && \
    make setup && \
    make && \
    rm -rf $(find . -mindepth 1 -maxdepth 1 '!' '(' -name bin -o -name src ')') && \
    apt-get remove -y software-properties-common git cabal-install-2.4 ghc-8.6.3 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /root/.cabal
