ARG JDK_VERSION="11"
ARG KEYCLOAK_VERSION="1.0.4-kc20.0.2"

FROM ghcr.io/mangadex-pub/jdk-maven:${JDK_VERSION}-corretto as jdk-base
FROM ghcr.io/mangadex-pub/keycloak:${KEYCLOAK_VERSION} as keycloak-base

FROM jdk-base AS keycloak-provider-mangadex

USER root
COPY . /tmp/keycloak-provider-mangadex
WORKDIR /tmp/keycloak-provider-mangadex

ARG PROVIDER_VERSION="local-SNAPSHOT"
RUN mvn clean package -Drevision=${PROVIDER_VERSION}

FROM keycloak-base AS keycloak-mangadex

USER root
ARG PROVIDER_VERSION="local-SNAPSHOT"
COPY --from=keycloak-provider-mangadex /tmp/keycloak-provider-mangadex/target/keycloak-mangadex-${PROVIDER_VERSION}.jar /opt/keycloak/providers/keycloak-mangadex-${PROVIDER_VERSION}.jar
RUN chmod -v 0644 /opt/keycloak/providers/*.jar

USER 1000

ENV KC_DB=postgres
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Comma-separated
ENV KC_FEATURES="declarative-user-profile"

WORKDIR /opt/keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized"]

FROM keycloak-mangadex AS keycloak-pgsql

ENV KC_CACHE=local

RUN /opt/keycloak/bin/kc.sh build && \
    /opt/keycloak/bin/kc.sh show-config

FROM keycloak-mangadex AS keycloak-pgsql-k8s

ENV KC_CACHE=ispn
ENV KC_CACHE_STACK=kubernetes

RUN /opt/keycloak/bin/kc.sh build && \
    /opt/keycloak/bin/kc.sh show-config
