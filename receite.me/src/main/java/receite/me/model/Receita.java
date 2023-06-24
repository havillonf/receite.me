package receite.me.model;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "receitas", schema = "public")
public class Receita {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    String nome;
    String modoDePreparo;
    double caloriasTotais;
    double proteinasTotais;
    double carboidratosTotais;
    double gordurasTotais;
    double tempoDePreparo;
    boolean flagGluten;
    boolean flagLactose;
    boolean flagVegetariano;
    boolean flagDoce;
    boolean flagSalgado;
    String pathImagem;
}