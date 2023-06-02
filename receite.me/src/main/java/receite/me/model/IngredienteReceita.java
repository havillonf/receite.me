package receite.me.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class IngredienteReceita {
    Ingrediente ingrediente;
    Receita receita;
    double qtdIngrediente;
}
