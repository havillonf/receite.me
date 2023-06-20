package receite.me.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import receite.me.model.Ingrediente;

public interface IngredienteRepository extends JpaRepository<Ingrediente, Long> {
}
