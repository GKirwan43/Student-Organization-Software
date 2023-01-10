package JetLag.security.providers;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import JetLag.DatabaseAccess.DataBaseAccess;

import JetLag.security.basicauth.service.CustomUserDetailsService;

@Component
public class CustomIdentityAuthenticationProvider
        implements AuthenticationProvider {


    @Autowired
    private ApplicationContext applicationContext;
    
    // TODO:
    // In this function we need to connect with identity provider
    // and validate the user
    // we are hardcoding for a single user for demo purposes
    UserDetails isValidUser(String username, String password) {

        DataBaseAccess accessor = (DataBaseAccess) applicationContext.getBean(DataBaseAccess.class);
        CustomUserDetailsService UserDao = new CustomUserDetailsService();
        UserDetails user = UserDao.loadUserByUsername(username, accessor);
        if (user != null && password.equals(user.getPassword())) {
            return user;
        }
        return null;
    }

    
    @Override
    public Authentication authenticate(Authentication authentication) {
        String username = authentication.getName();
        String password = authentication.getCredentials().toString();
        System.out.println("the password sent is: " + password);

        UserDetails userDetails = isValidUser(username, password);

        if (userDetails != null) {
            return new UsernamePasswordAuthenticationToken(
                    username,
                    password,
                    userDetails.getAuthorities());
        } else {
            throw new BadCredentialsException("Incorrect user credentials !!");
        }
    }

    @Override
    public boolean supports(Class<?> authenticationType) {
        return authenticationType
                .equals(UsernamePasswordAuthenticationToken.class);
    }
}