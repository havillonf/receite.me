package receite.me.model;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
@Builder
public class Problem {
    int status;
    String exception;
    LocalDateTime ocurredAt;
}
