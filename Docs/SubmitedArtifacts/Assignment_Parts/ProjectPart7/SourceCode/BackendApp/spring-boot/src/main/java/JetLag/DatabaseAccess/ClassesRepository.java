package JetLag.DatabaseAccess;

import com.azure.spring.data.cosmos.repository.Query;
import com.azure.spring.data.cosmos.repository.ReactiveCosmosRepository;

import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface ClassesRepository extends ReactiveCosmosRepository<ClassTab, String> {
    Mono<ClassTab> findById(String id);
    //Flux<ClassTab> findBynoteOwner(String noteOwner);
    @Query("select * from c where c.NoteOwner = @noteOwner")
    Flux<ClassTab> findByNoteOwner(@Param("noteOwner") String theNoteOwner);
}