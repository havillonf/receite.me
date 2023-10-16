package receite.me.model;

import jakarta.persistence.Entity;
import lombok.*;

@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResetPasswordData {
    private String email;
    private String codigo;
    private String password;
}
