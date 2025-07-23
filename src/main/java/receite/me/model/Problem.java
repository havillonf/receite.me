package receite.me.model;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class Problem {
    int status;
    String exception;
    LocalDateTime ocurredAt;
}
