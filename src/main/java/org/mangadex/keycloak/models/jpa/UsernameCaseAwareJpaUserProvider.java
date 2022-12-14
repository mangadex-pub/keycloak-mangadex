package org.mangadex.keycloak.models.jpa;

import javax.persistence.EntityManager;

import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.keycloak.models.jpa.JpaUserProvider;
import org.keycloak.models.utils.KeycloakModelUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UsernameCaseAwareJpaUserProvider extends JpaUserProvider {

    private static final Logger LOGGER = LoggerFactory.getLogger(UsernameCaseAwareJpaUserProvider.class);

    public UsernameCaseAwareJpaUserProvider(KeycloakSession session, EntityManager em) {
        super(session, em);
    }

    @Override
    public UserModel addUser(RealmModel realm, String id, String username, boolean addDefaultRoles, boolean addDefaultRequiredActions) {
        UserModel userModel = super.addUser(realm, id, username, addDefaultRoles, addDefaultRequiredActions);

        // ensure the non-prelowercased username is always stored as displayname custom attribute
        LOGGER.info("Ensuring displayname {} for user {}/{}", username, id, username.toLowerCase());
        userModel.setSingleAttribute("displayname", username);

        return userModel;
    }

    @Override
    public UserModel addUser(RealmModel realm, String username) {
        return addUser(realm, KeycloakModelUtils.generateId(), username, true, true);
    }

}
