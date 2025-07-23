package receite.me.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.Builder;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.GenerationType;
import jakarta.persistence.ManyToMany;

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