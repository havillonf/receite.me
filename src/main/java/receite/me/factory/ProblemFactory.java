package receite.me.factory;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import receite.me.model.Problem;

import java.time.LocalDateTime;

@Component
public class ProblemFactory {

    public Problem createNotFound(String detail) {
        return Problem.builder()
            .status(HttpStatus.NOT_FOUND.value())
            .exception("Recurso Não Encontrado " + detail)
            .ocurredAt(LocalDateTime.now())
            .build();
    }

    public Problem createBadRequest(String detail) {
        return Problem.builder()
            .status(HttpStatus.BAD_REQUEST.value())
            .exception("Requisição Inválida" + detail)
            .ocurredAt(LocalDateTime.now())
            .build();
    }

}
