package receite.me.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import java.util.List;
import java.util.Set;

@Getter

@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "pastas", schema = "public")
public class Pasta {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private boolean flagFavorito;
    @Fetch(FetchMode.SELECT)
    @ManyToOne
    private Usuario usuario;
    @Fetch(FetchMode.SELECT)
    @ManyToMany(cascade = CascadeType.REFRESH)
    private Set<Receita> receitas;
}
