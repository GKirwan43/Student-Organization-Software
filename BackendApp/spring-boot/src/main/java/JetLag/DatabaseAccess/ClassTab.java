package JetLag.DatabaseAccess;

import java.util.ArrayList;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;


import com.azure.spring.data.cosmos.core.mapping.Container;
import com.azure.spring.data.cosmos.core.mapping.PartitionKey;
import org.springframework.data.annotation.Id;

@Container(containerName = "jlag-sos")
public class ClassTab {
    //Variables
    @Id
    @PartitionKey
    @JsonProperty("id")
    private String id = "";

    @JsonProperty("NoteOwner")
    String noteOwner = "";

    @JsonProperty("Notes")
    ArrayList<classNotes> notes = new ArrayList<classNotes>();
    
    @JsonProperty("MeetingTime")
    ArrayList<ArrayList<Integer>> meetingTime = new ArrayList<ArrayList<Integer>>();
    
    @JsonProperty("StartDate")
    Date startDate = new Date();
    
    @JsonProperty("EndDate")
    Date endDate = new Date();
    
    @JsonProperty("ClassName")
    String className = "";
    
    @JsonProperty("InstructorName")
    String instructorName = "";

    //Constructors
    //Empty
    public ClassTab() {

    }
    //Full
    public ClassTab(String id, String noteOwner, ArrayList<ArrayList<Integer>> meetingTime, Date startDate, Date endDate, String className, String instructorName){
        this.id = id;
        this.noteOwner = noteOwner;
        this.meetingTime = meetingTime;
        this.startDate = startDate;
        this.endDate = endDate;
        this.className = className;
        this.instructorName = instructorName;
    }

    public void createNote(String Jsonstring) throws JsonMappingException, JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        classNotes note = mapper.readValue(Jsonstring, classNotes.class);
        notes.add(note);
    }

    //GETTERS & SETTERS
    //id
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }


    //noteOwner
    public String getNoteOwner() {
        return noteOwner;
    }

    public void setNoteOwner(String noteOwner) {
        this.noteOwner = noteOwner;
    }


    //notes
    public ArrayList<classNotes> getNotes() {
        return notes;
    }

    public void setNotes(ArrayList<classNotes> notes) {
        this.notes = notes;
    }


    //meetingTime
    public ArrayList<ArrayList<Integer>> getMeetingTime() {
        return meetingTime;
    }

    public void setMeetingTime(ArrayList<ArrayList<Integer>> meetingTime) {
        this.meetingTime = meetingTime;
    }


    //startDate
    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }


    //endDate
    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }


    //className
    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }
   

    //instructorName
    public String getInstructorName() {
        return instructorName;
    }

    public void setInstructorName(String instructorName) {
        this.instructorName = instructorName;
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

class classNotes {
    @JsonProperty("LastEdited")
    public Date lastEdited;
    @JsonProperty("Note")
    public String Notes;
    @JsonProperty("NoteName")
    public String NoteName;

}