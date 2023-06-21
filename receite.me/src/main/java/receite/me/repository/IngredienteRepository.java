package receite.me.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import receite.me.model.Ingrediente;

import java.util.List;

public interface IngredienteRepository extends JpaRepository<Ingrediente, Long> {
     List<Ingrediente> findByNomeContainingIgnoreCase(String name);
}
