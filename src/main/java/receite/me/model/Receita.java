package receite.me.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

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
    private String nome;
    @Fetch(FetchMode.SELECT)
    @ManyToMany
    private Set<Ingrediente> ingredientes;
    private double tempoDePreparo;
    private String modoDePreparo;
    private double caloriasTotais;
    private double proteinasTotais;
    private double carboidratosTotais;
    private double gordurasTotais;
    private boolean flagGluten;
    private boolean flagLactose;
    private boolean flagVegetariano;
    private boolean flagDoce;
    private boolean flagSalgado;
    private String pathImagem;
}