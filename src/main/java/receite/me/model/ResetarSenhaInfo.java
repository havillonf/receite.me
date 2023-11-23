package receite.me.model;

import lombok.*;

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
