package receite.me.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import receite.me.model.Pasta;
import receite.me.model.Usuario;

public interface PastaRepository extends JpaRepository<Pasta, Long> {
    Pasta findPastaByFlagFavoritoAndUsuario(boolean flagFavorito, Usuario usuario);
    void update
}
