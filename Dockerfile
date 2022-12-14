ARG KEYCLOAK_VERSION="1.0.4-kc20.0.2"
FROM ghcr.io/mangadex-pub/keycloak:${KEYCLOAK_VERSION} as keycloak-mangadex

USER root
COPY providers/theme/target/keycloak-mangadex-theme-*.jar /opt/keycloak/providers/
COPY providers/user/target/keycloak-mangadex-user-*.jar /opt/keycloak/providers/
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
