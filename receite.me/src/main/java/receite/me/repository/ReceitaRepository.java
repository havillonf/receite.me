package receite.me.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import receite.me.model.Ingrediente;
import receite.me.model.Receita;

import java.util.List;

public interface ReceitaRepository extends JpaRepository<Receita, Long> {
    List<Receita> findByNomeContainingIgnoreCase(String name);
}
