package receite.me.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import receite.me.model.Ingrediente;

import java.util.List;
import java.util.Optional;

public interface IngredienteRepository extends JpaRepository<Ingrediente, Long> {
     List<Ingrediente> findByNomeContainingIgnoreCase(String name);
     Optional<Ingrediente> findByNome(String name);
}
