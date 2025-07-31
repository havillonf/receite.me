package receite.me.factory;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import receite.me.model.Problem;

import java.time.LocalDateTime;

@Component
public class ProblemFactory {
    public Problem createProblem(String description, HttpStatus status) {
        if(status.value() == HttpStatus.BAD_REQUEST.value()) {
                return Problem.builder()
                        .status(HttpStatus.BAD_REQUEST.value())
                        .exception("Requisição Inválida: " + description)
                        .ocurredAt(LocalDateTime.now())
                        .build();
        }else if (status.value() == HttpStatus.NOT_FOUND.value()) {
            return Problem.builder()
                    .status(HttpStatus.NOT_FOUND.value())
                    .exception("Recurso Não Encontrado: " + description)
                    .ocurredAt(LocalDateTime.now())
                    .build();
        }else {
            return null;
        }
    }
}
