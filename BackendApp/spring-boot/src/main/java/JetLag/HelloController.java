package JetLag;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import JetLag.DatabaseAccess.ClassTab;
import JetLag.DatabaseAccess.DataBaseAccess;
import JetLag.DatabaseAccess.UserSettings;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.security.SecurityProperties.User;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.context.ApplicationContext;

@RestController
@CrossOrigin
public class HelloController {

    @Autowired
    private ApplicationContext applicationContext;

    //GENERAL API REQUESTS
    //GENERAL GETS
    /*
    * Expl: Default Extension
    * Get: /
    * param: None
    * return: Returns: "EECS 448 JetLag API"
    */
    @GetMapping("/")
    public String index() {
        return "EECS 448 JetLag API";
    }
    
    //GENERAL POSTS
    /*
    * Expl: Echoes String Passed In
    * Get: /testEcho
    * param: testData : The String To Echo
    * return: Returns: testData
    */
    @PostMapping("/testEcho")
    String testEcho(@RequestBody String testData) {
        return testData;

    }

    @PostMapping("/test")
    String testApp(@RequestBody String testData) {
        return "if you see this that means things are working";

    }

    //USER API REQUESTS
    //USERSETTINGS GETS
    /*
    * Expl: Gets User's Username
    * Get: /currentusername
    * param: Principal
    * return: Returns the Current User's Username
    */
    @GetMapping("/currentusername")
    public String currentUserName(Principal principal) {
        return principal.getName();
    }

    /*
    * Expl: Gets UserSettings
    * Get: /userSettings
    * param: Principal
    * return: Returns the Current User's UserSettings Class as a JSON String
    */
    @GetMapping("/userSettings")
    public String userSettings(Principal principal) throws Exception {
        DataBaseAccess accessor = applicationContext.getBean(DataBaseAccess.class);
        String username = principal.getName();
        UserSettings temp = new UserSettings();
        temp = accessor.returnUserByUsername(username);
        return temp.toString();
    }

    //USERSETTINGS POSTS
    /*
    * Expl: If A User Doesn't Already Exist, Post Said New User To The Database
    * Post: /NewUser
    * param: user - JSON String Of A UserSettings Object
    * return: Either a Success or Error Message
    */
    @PostMapping("/NewUser")
    String newUser(@RequestBody String user) {
        DataBaseAccess accessor = applicationContext.getBean(DataBaseAccess.class);
        UserSettings newUser = new UserSettings();
        ObjectMapper mapper = new ObjectMapper();
        try {
            newUser = mapper.readValue(user, UserSettings.class);
            if(!accessor.idAlreadyInDatabase(newUser.getId())){
                accessor.createUser(newUser);
            }
            return "success";
        } catch (JsonMappingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "error making user";

    }



    //CLASSTAB API REQUESTS
    //CLASSTAB GETS
    /*
    * Expl: Retrieves All Notes Associated With The Principal User
    * Get: /classNotes
    * param: Principal
    * return: Returns A JSON String of All of a User's ClassTabs Associated with their UserName
    */
    @GetMapping("/classNotes")
    public String classNotes(Principal principal) throws Exception {
        String username = principal.getName();
        ArrayList<ClassTab> data = new ArrayList<ClassTab>();
        
        DataBaseAccess accessor = applicationContext.getBean(DataBaseAccess.class);

        ClassTab temp = new ClassTab();
        try {
            data = accessor.returnClasses(username);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data.toString();
    }
    
    //CLASSTAB POSTS
    /*
    * Expl: Retrieves All Notes Associated With The Principal User
    * Get: /classNotes
    * param: Principal
    * return: Returns A JSON String of All of a User's ClassTabs Associated with their UserName
    */
    //NOT YET FINISHED, NEED TOO DELETE A NOTE IF ONE ALREADY EXISTS
    @PostMapping("/saveNote")
    String SaveNote(@RequestBody String note) {
        DataBaseAccess accessor = applicationContext.getBean(DataBaseAccess.class);
        // User user = (User)
        // SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        // String username = user.getName();
        ObjectMapper mapper = new ObjectMapper();
        ClassTab Data = new ClassTab();
        try {
            Data = mapper.readValue(note, ClassTab.class);
            accessor.createNote(Data);

        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Data.toString();
    }


    //TEST METHODS
    
    /*
    @GetMapping("/test")
    public String test() {

        DataBaseAccess accessor = applicationContext.getBean(DataBaseAccess.class);
        
        try { 
            System.out.println("Starting Test 1: Checking if a User Exists");
            System.out.println(accessor.doesUserExist("testUserName"));
            System.out.println("Starting Test 2: Checking if a Username and Password Match");
            if(accessor.doesUserExist("testUserName")){
                System.out.println("Username exists so we check password matches");
                System.out.println(accessor.doUsernameAndPasswordMatch("testUserName", "testPassword"));
            }else{
                System.out.println("Username doesn't exists not checking password");
            }


            ArrayList<ClassTab> usersClasses = accessor.returnClasses("testUser");
            
        } catch (Exception e) {
            System.out.println("Exception");
            e.printStackTrace();
        }catch (Error e) {
            System.out.println("Error");
            e.printStackTrace();
        }
        System.out.println("Finished Test");
        return("Done");
    }

    
    @GetMapping("/test2")
    public String test2() {
        UserSettings test = new UserSettings();
        test.setId("adminTestUser");
        ArrayList<String> testInner = new ArrayList<String>();
        test.addClassName("class1");
        test.addClassName("class2");
        return test.toString();
    }
    
    
    @GetMapping("/testClass")
    public String classtest(Principal principal) throws Exception {
        String username = principal.getName();
        ArrayList<ClassTab> test = new ArrayList<ClassTab>();

        // andrews mods
        ArrayList<ArrayList<Integer>> course1 = new ArrayList<ArrayList<Integer>>();
        ArrayList<ArrayList<Integer>> course2 = new ArrayList<ArrayList<Integer>>();
        ArrayList<ArrayList<Integer>> course3 = new ArrayList<ArrayList<Integer>>();
        ArrayList<Integer> meet1 = new ArrayList<Integer>(5);
        ArrayList<Integer> meet2 = new ArrayList<Integer>(5);
        ArrayList<Integer> meet3 = new ArrayList<Integer>(5);
        ArrayList<Integer> meet4 = new ArrayList<Integer>(5);
        ArrayList<Integer> meet5 = new ArrayList<Integer>(5);
        ArrayList<Integer> meet6 = new ArrayList<Integer>(5);
        ArrayList<Integer> meet7 = new ArrayList<Integer>(5);
        ArrayList<Integer> meet8 = new ArrayList<Integer>(5);
        meet1.add(1);
        meet1.add(11);
        meet1.add(0);
        meet1.add(12);
        meet1.add(0);

        meet2.add(3);
        meet2.add(12);
        meet2.add(0);
        meet2.add(13);
        meet2.add(0);

        meet3.add(5);
        meet3.add(13);
        meet3.add(0);
        meet3.add(14);
        meet3.add(0);

        course1.add(meet1);
        course1.add(meet2);
        course1.add(meet3);

        meet4.add(1);
        meet4.add(10);
        meet4.add(0);
        meet4.add(11);
        meet4.add(0);

        meet5.add(3);
        meet5.add(11);
        meet5.add(0);
        meet5.add(12);
        meet5.add(0);

        meet6.add(5);
        meet6.add(12);
        meet6.add(0);
        meet6.add(13);
        meet6.add(0);

        course2.add(meet4);
        course2.add(meet5);
        course2.add(meet6);

        meet7.add(2);
        meet7.add(10);
        meet7.add(0);
        meet7.add(11);
        meet7.add(0);

        meet8.add(4);
        meet8.add(11);
        meet8.add(0);
        meet8.add(12);
        meet8.add(0);

        course3.add(meet7);
        course3.add(meet8);
        // end andrews mods
        

        ClassTab temp1 = new ClassTab();
        ClassTab temp2 = new ClassTab();
        ClassTab temp3 = new ClassTab();
        temp1.setClassName("eecs101");
        temp2.setClassName("eecs202");
        temp3.setClassName("eecs303");
        temp1.setId("testUser");
        temp1.setNoteOwner("testUser");
        temp2.setId("testUser");
        temp2.setNoteOwner("testUser");
        temp3.setId("testUser");
        temp3.setNoteOwner("testUser");
        long startdate = 1669995051637L;
        long enddate = 1670595051637L;
        temp1.setStartDate(new Date(startdate));
        temp1.setEndDate(new Date(enddate));
        temp2.setStartDate(new Date(startdate));
        temp2.setEndDate(new Date(enddate));
        temp3.setStartDate(new Date(startdate));
        temp3.setEndDate(new Date(enddate));

        // andrews mods
        temp1.setMeetingTime(new ArrayList<ArrayList<Integer>>(course1));
        temp2.setMeetingTime(new ArrayList<ArrayList<Integer>>(course2));
        temp3.setMeetingTime(new ArrayList<ArrayList<Integer>>(course3));
        // end andrews mods

        try {
            temp1.createNote(
                    "{\"LastEdited\":\"2022-11-09T00:24:44.312626\", \"Note\":\"blah\",\"NoteName\":\"blah\"}");
            temp1.createNote(
                    "{\"LastEdited\":\"2022-11-15T00:24:44.312626\", \"Note\":\"blah2\",\"NoteName\":\"blah2\"}");
            temp2.createNote(
                    "{\"LastEdited\":\"2022-11-09T00:24:44.312626\", \"Note\":\"blah\",\"NoteName\":\"blah\"}");
            temp2.createNote(
                    "{\"LastEdited\":\"2022-11-15T00:24:44.312626\", \"Note\":\"blah2\",\"NoteName\":\"blah2\"}");
            temp3.createNote(
                    "{\"LastEdited\":\"2022-11-09T00:24:44.312626\", \"Note\":\"blah\",\"NoteName\":\"blah\"}");
            temp3.createNote(
                    "{\"LastEdited\":\"2022-11-15T00:24:44.312626\", \"Note\":\"blah2\",\"NoteName\":\"blah2\"}");
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        test.add(temp1);
        test.add(temp2);
        test.add(temp3);
        return test.toString();
    }
    */
}
