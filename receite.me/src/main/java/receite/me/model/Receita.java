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
@Table(name = "receita", schema = "public")
public class Receita {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
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