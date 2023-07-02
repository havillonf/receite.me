package receite.me.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import receite.me.model.Ingrediente;
import receite.me.model.Usuario;

import java.util.List;
import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    Optional<Usuario> findByEmail(String email);
}

