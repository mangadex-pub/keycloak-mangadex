package org.mangadex.keycloak.models.jpa;

import javax.persistence.EntityManager;

import org.keycloak.Config;
import org.keycloak.connections.jpa.JpaConnectionProvider;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;
import org.keycloak.models.UserProviderFactory;
import org.keycloak.models.jpa.JpaRealmProviderFactory;

public class UsernameCaseAwareJpaUserProviderFactory implements UserProviderFactory<UsernameCaseAwareJpaUserProvider> {

    public static final String PROVIDER_ID = "case-aware-jpa";

    @Override
    public void init(Config.Scope config) {

    }

    @Override
    public void postInit(KeycloakSessionFactory factory) {

    }

    @Override
    public String getId() {
        return PROVIDER_ID;
    }

    @Override
    public UsernameCaseAwareJpaUserProvider create(KeycloakSession session) {
        EntityManager em = session.getProvider(JpaConnectionProvider.class).getEntityManager();
        return new UsernameCaseAwareJpaUserProvider(session, em);
    }

    @Override
    public void close() {
    }

    @Override
    public int order() {
        return JpaRealmProviderFactory.PROVIDER_PRIORITY;
    }

}
