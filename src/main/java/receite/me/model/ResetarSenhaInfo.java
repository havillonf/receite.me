package receite.me.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.Builder;

@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResetarSenhaInfo {
    private String email;
    private String codigo;
    private String novaSenha;
}
