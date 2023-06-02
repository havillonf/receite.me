package receite.me.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;
@Getter
@Setter
@ToString
public class Pasta {
    String nome;
    boolean favorito;
    ArrayList<Usuario> usuarios;
}
