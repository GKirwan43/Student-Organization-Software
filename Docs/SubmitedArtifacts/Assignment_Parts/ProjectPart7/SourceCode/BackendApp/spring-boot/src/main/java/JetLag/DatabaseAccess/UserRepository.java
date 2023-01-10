package JetLag.DatabaseAccess;

import com.azure.spring.data.cosmos.repository.Query;
import com.azure.spring.data.cosmos.repository.ReactiveCosmosRepository;

import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface UserRepository extends ReactiveCosmosRepository<UserSettings, String> {
    Mono<UserSettings> findById(String id);
    Flux<UserSettings> findByStudentType(String StudentType);
    @Query("select * from c where c.UserName = @username")
    Flux<UserSettings> findByUserName(@Param("username") String theUsername);
}
