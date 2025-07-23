package receite.me.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import receite.me.model.usuario.Cargo;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UsuarioDto {
    private Long id;
    private String email;
    private String nome;
    private String avatar;
    private String bio;
    private Cargo cargo;
}
