package JetLag.DatabaseAccess;

import java.util.ArrayList;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import com.azure.spring.data.cosmos.core.mapping.Container;
import com.azure.spring.data.cosmos.core.mapping.PartitionKey;
import org.springframework.data.annotation.Id;

@Container(containerName = "jlag-sos")
public class UserSettings {
    //Variables
    @Id
    @PartitionKey
    @JsonProperty("id")
    private String id = "";

    @JsonProperty("UserName")
    private String userName = "";
    
    @JsonProperty("Password")
    private String password;
    
    @JsonProperty("UserClasses")
    ArrayList<String> classNames = new ArrayList<String>();

    @JsonProperty("StudentType")
    String studentType = "";

    @JsonProperty("StudentAge")
    int studentAge = -1;





    //Constructors
    //Empty
    public UserSettings() {

    }

    //Full
    public UserSettings(String id, String userName, String password, ArrayList<String> classNames, String studentType, int studentAge){
        this.id = id;
        this.userName = userName;
        this.password = password;
        this.classNames = classNames;
        this.studentType = studentType;
        this.studentAge = studentAge;
    }


    //GETTERS & SETTERS
    //id
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }


    //userName
    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }


    //password
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


    //classNames
    public ArrayList<String> getClassNames() {
        return classNames;
    }

    public void setClassNames(ArrayList<String> classNames) {
        this.classNames = classNames;
    }

    public void addClassName(String name) {
        classNames.add(name);
    }

    //userName
    public String getStudentType() {
        return studentType;
    }

    public void setStudentType(String studentType) {
        this.studentType = studentType;
    }


    //studentAge
    public int getStudentAge() {
        return studentAge;
    }

    public void setStudentAge(int studentAge) {
        this.studentAge = studentAge;
    }



    //Returning As String
    @Override
    public String toString() {
        ObjectMapper mapper = new ObjectMapper();
        try {
            String json = mapper.writeValueAsString(this);
            return json;
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return null;
    }
}