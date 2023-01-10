// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package JetLag.DatabaseAccess;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;

import io.netty.handler.codec.http.HttpContentEncoder.Result;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.ArrayList;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class DataBaseAccess {
   
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private ClassesRepository classesRepository;
    

    private static final Logger LOGGER = LoggerFactory.getLogger(DataBaseAccess.class);

    /*
    * Name: DataBaseAccess
    * Expl: Default Empty Constructor For DataBaseAccess Class
    * param: None
    * return: None
    */
    public DataBaseAccess(){

    }


    /*
    * Name: doesUserWithIdExist
    * Expl: Checks Database to see if an User with an Id Exists
    * param: String idToSearchFor : The String of the UserName / Id (Id and Username are Identical) That will be Searched for
    * return: Boolean: True If idToSearchFor Exists in Database, Else False
    */
    public Boolean doesUserWithIdExist(String idToSearchFor){
        final Optional<UserSettings> optionalUserResult = userRepository.findById(idToSearchFor).blockOptional();
        if(optionalUserResult.isPresent()){
            final UserSettings result = optionalUserResult.get();
            if(result.getUserName() != null && result.getUserName() != ""){
                return(true);
            }else{
                return(false);
            }
        }else{
            return(false);
        }
    }

    /*
    * Name: doesUserWithIdExist
    * Expl: Checks Database to see if an User with an Id Exists
    * param: String usernameToSearchFor : The String of the UserName / Id (Id and Username are Identical) That will be Searched for
    * return: Boolean: True If usernameToSearchFor Exists in Database, Else False
    */
    public Boolean doesUserWithUsernameExist(String usernameToSearchFor){
        final Flux<UserSettings> usersFluxxy = userRepository.findByUserName(usernameToSearchFor);
        return(usersFluxxy.hasElements().block());
    }

    /*
    * Name: doesClassTabWithIdExist
    * Expl: Checks Database to see if an User with an Id Exists
    * param: String idToSearchFor : The String of the UserName / Id (Id and Username are Identical) That will be Searched for
    * return: Boolean: True If idToSearchFor Exists in Database, Else False
    */
    public Boolean doesClassTabWithIdExist(String idToSearchFor){
        final Optional<ClassTab> optionalNoteResult = classesRepository.findById(idToSearchFor).blockOptional();
        if(optionalNoteResult.isPresent()){
            final ClassTab result = optionalNoteResult.get();
            if(result.getNoteOwner() != null && result.getNoteOwner() != ""){
                return(true);
            }else{
                return(false);
            }
        }else{
            return(false);
        }
    }

    /*
    * Name: idAlreadyInDatabase
    * Expl: Checks Database to make sure no object exists in database with the same id as one passed in
    * param: String idToSearchFor : The String of the Id That will be Searched for
    * return: Boolean: True If idToSearchFor Exists as an Id in Database, Else False
    */
    public Boolean idAlreadyInDatabase(String idToSearchFor){
        final Optional<ClassTab> optionalNoteResult = classesRepository.findById(idToSearchFor).blockOptional();
        final Optional<UserSettings> optionalUserResult = userRepository.findById(idToSearchFor).blockOptional();
        Boolean idAlreadyExists = (optionalNoteResult.isPresent() || optionalUserResult.isPresent());
        return(idAlreadyExists);
    }


    /*
    * Name: doUsernameAndPasswordMatch
    * Expl: Checks to see If a Username and Passsword Match a User's Usersettings In Database
    * param: String idToSearchFor , String passwordToMatch: The String of the UserName / Id (Id and Username are Identical) That will be Searched for, The Password to check against
    * return: Boolean: True If A UserSettings Record Exists in the Database with Both a Matching Username and Password, otherwise false
    */
    public Boolean doUsernameAndPasswordMatch(String idToSearchFor, String passwordToMatch){
        final Optional<UserSettings> optionalUserResult = userRepository.findById(idToSearchFor).blockOptional();
        if(optionalUserResult.isPresent()){
            final UserSettings result = optionalUserResult.get();
            if(result.getPassword().equals(passwordToMatch)){
                return(true);
            }
        }
        return(false);
    }

    /*
    * Name: returnUserById
    * Expl: Given a Username, It retrieves and Returns the UserSettings Object
    * param: String idToSearchFor: The String of the UserName / Id (Id and Username are Identical) That will be retrieved
    * return: UserSettings: the UserSettings Class that was retrieved from the Database
    */
    public UserSettings returnUserById(String idToSearchFor){
        final Optional<UserSettings> optionalUserResult = userRepository.findById(idToSearchFor).blockOptional();
        final UserSettings result = optionalUserResult.get();
        return(result);
    }

    /*
    * Name: returnUserByUsername
    * Expl: Given a Username, It retrieves and Returns the UserSettings Object
    * param: String usernameToSearchFor: The String of the UserName / Id (Id and Username are Identical) That will be retrieved
    * return: UserSettings: the UserSettings Class that was retrieved from the Database
    */
    public UserSettings returnUserByUsername(String usernameToSearchFor){
        final Flux<UserSettings> usersFluxxy = userRepository.findByUserName(usernameToSearchFor);
        final Optional<UserSettings> optionalUserResult = usersFluxxy.next().blockOptional();
        final UserSettings result = optionalUserResult.get();
        return(result);
    }


    /*
    * Name: createUser
    * Expl: Given a UserSettings Object, Creates User In Database If They Don't Alreadt Exist
    * param: UserSettings createUser: The User Object That will be stored In the Database
    * return: void
    */
    public void createUser(UserSettings userToCreate){
        System.out.println("HELLO");
        if (!idAlreadyInDatabase(userToCreate.getId())){
            System.out.println("Entered");
            final Mono<UserSettings> saveUserMono = userRepository.save(userToCreate);
            final UserSettings savedUser = saveUserMono.block();
        }
    }


    /*
    * Name: returnClasses
    * Expl: Given a Username, It retrieves and Returns all ClassTab objects stored in the database associated with the UserName
    * param: String userToSearchFor: The String of the UserName / Id (Id and Username are Identical) whose notes will be retrieved
    * return: ArrayList<ClassTab>: An ArrayList of all ClassTab Objects Associated With a User
    */
    public ArrayList<ClassTab> returnClasses(String userToSearchFor){
        final Flux<ClassTab> usersFluxxyClasses = classesRepository.findByNoteOwner(userToSearchFor);
        ArrayList<ClassTab> usersClasses = new ArrayList<ClassTab>();
        if(usersFluxxyClasses.hasElements().block()){
            long length = usersFluxxyClasses.count().block();
            for(int i = 0; i < length; i++){
                usersClasses.add(usersFluxxyClasses.elementAt(i).block());
            }
        }
        return(usersClasses);
    }


    /*
    * Name: createNote
    * Expl: Given a ClassTabObject, Creates Note
    * param: UserSettings createUser: The User Object That will be stored In the Database
    * return: void
    */
    public void createNote(ClassTab noteToCreate){
        //Checking If an Entry With ID already Exists
        Boolean idAlreadyExists = idAlreadyInDatabase(noteToCreate.getId());
        System.out.println("Im In Function And ID Exists is: " + idAlreadyExists);
        //If Id Doesn't Exist, Post Note Normally
        if(!idAlreadyExists){
            final Mono<ClassTab> saveNoteMono = classesRepository.save(noteToCreate);
            final ClassTab savedNote = saveNoteMono.block();
        }else{
            //Else If the ID already exists, check to see if that Id is an Existing Note
            System.out.println("I Didn't Initially Create Note Because That ID Existed");
            if(doesClassTabWithIdExist(noteToCreate.getId())){
                //If It Is An Existing Note, We Overwrite Note With New Note
                classesRepository.deleteById(noteToCreate.getId());
                final Mono<ClassTab> saveNoteMono = classesRepository.save(noteToCreate);
                final ClassTab savedNote = saveNoteMono.block();

            }else{
                //If it Wasn't a Note, then It was a User Record And
                //a User Record Takes Priority Over a Note Record, and We
                //Won't Save Note
            }
        }
    }




    /* Not Necessary Right Now
    public UserSettings getStudentsByType(String StudentType){
        System.out.println("Looking For A Student of Type: " + StudentType);
        final Flux<UserSettings> firstUserNameFlux = userRepository.findByStudentType(StudentType);
        final Optional<UserSettings> optionalUserResult = firstUserNameFlux.next().blockOptional();
        
    
        System.out.println("Checking If a User of Type: " + StudentType + " was found. Sending message if No Such Student Found");
        Assert.isTrue(optionalUserResult.isPresent(), "Cannot find user.");

        System.out.println("New Final User Settings");
        final UserSettings result = optionalUserResult.get();
        return(result);
    }

     */









    //Old Random Test
    /*
     * 
     * 
     * 
     * public void databaseAccessTest(UserRepository passedRepository) {
        this.userRepository = passedRepository;
        userRepository.deleteAll().block();
        LOGGER.info("Deleted all data in container.");
        System.out.println("Finished Deleting Data in Database");

        System.out.println("Creating Local Array Of Class Names");
        ArrayList<String> classNames = new ArrayList<String>();
        classNames.add("EECS: 368");
        classNames.add("EECS: 448");
        classNames.add("EECS: 639");
        final UserSettings testUser = new UserSettings("testUserName", "testUserName", "testPassword", classNames, "Junior", 21);
        System.out.println("Finished Creating a UserSettings Example");
        // Save the User class to Azure Cosmos DB database.
        final Mono<UserSettings> saveUserMono = userRepository.save(testUser);
        System.out.println("Finished Saved Test User to Database");

        final Mono<UserSettings> firstIDFlux = userRepository.findById("testId");
        System.out.println("Finished Looking For the testUser by ID in Database");

        System.out.println("Creating a local User example of what we got from Database");
        final UserSettings savedUser = saveUserMono.block();

        System.out.println("Making Sure Saved User Isnt Null");
        Assert.state(savedUser != null, "Saved user must not be null");

        System.out.println("Making Sure UserNames Match");
        try{
            Assert.state(savedUser.getUserName().equals(testUser.getUserName()), "Saved user first name doesn't match");
        }catch(Exception e){
            e.printStackTrace();
        }catch(Error e){
            e.printStackTrace();
        }

       // System.out.println("IDK Doing Weird Flux Blocking Stuff");
        //firstIDFlux.collectList().block();

        System.out.println("Trying To Find User By ID");
        final Optional<UserSettings> optionalUserResult = userRepository.findById(testUser.getId()).blockOptional();

        System.out.println("Checking If a User Was Found");
        Assert.isTrue(optionalUserResult.isPresent(), "Cannot find user.");

        System.out.println("New Final User Settings");
        final UserSettings result = optionalUserResult.get();

        System.out.println("Making Sure UserNames Match");
        Assert.state(result.getUserName().equals(testUser.getUserName()), "query result userName doesn't match!");

        System.out.println("Making Sure Passwords Match");
        Assert.state(result.getPassword().equals(testUser.getPassword()), "query result password doesn't match!");

        System.out.println("Printing Out UserSettings.toString");
        LOGGER.info("findOne in User collection get result: {}", result.toString());
    }
     * 
     * 
     */










}
