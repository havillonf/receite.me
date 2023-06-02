package receite.me.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Usuario {
    private String email;
    private String nome;
    private String senha;
    private String pathAvatar;
    private String bio;
}
