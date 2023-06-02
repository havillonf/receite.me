package receite.me.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Builder
public class Receita {
    String nome;
    String preparo;
    double caloriasTotais;
    double proteinasTotais;
    double carboidratosTotais;
    double gordurasTotais;
    double tempoPreparo;
    boolean gluten;
    boolean lactose;
    boolean vegetariano;
    boolean doce;
    boolean salgado;
    String pathImagem;
}