package receite.me.factory;

import org.springframework.http.HttpStatus;
import receite.me.model.Problem;

public interface ProblemFactory {
    Problem createProblem(String description, HttpStatus status);
}
