package JetLag.security.basicauth.service;

import JetLag.DatabaseAccess.DataBaseAccess;
import JetLag.DatabaseAccess.UserSettings;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.ui.context.ThemeSource;

import java.util.Optional;

@Service
public class CustomUserDetailsService implements UserDetailsService {


    public UserDetails loadUserByUsername(String passedInUsername, DataBaseAccess theDatabase) throws UsernameNotFoundException {
        System.out.println(passedInUsername);
        if(!theDatabase.doesUserWithIdExist(passedInUsername)){
             throw new UsernameNotFoundException(String.format("Username: [%s] not found", passedInUsername));
        }
        UserSettings theUser = new UserSettings();
        theUser = theDatabase.returnUserById(passedInUsername);
        return User.withUsername(theUser.getUserName()).password(theUser.getPassword()).authorities("USER").build();
        //return User.withUsername("adminTestUser").password("thisIsAPassword").authorities("USER").build();
    
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // TODO Auto-generated method stub
        return null;
    }
}
