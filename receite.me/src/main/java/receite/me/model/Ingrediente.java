package receite.me.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Ingrediente {
    String nome;
    double calorias;
    double proteinas;
    double carboidratos;
    double gorduras;
    String medida;
}
