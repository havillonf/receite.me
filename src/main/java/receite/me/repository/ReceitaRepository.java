package receite.me.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import receite.me.model.Receita;

import java.util.List;

public interface ReceitaRepository extends JpaRepository<Receita, Long> {
    List<Receita> findByNomeContainingIgnoreCase(String name);
    List<Receita> findReceitasByFlagGluten(boolean flagGluten);
    List<Receita> findReceitasByFlagLactose(boolean flagLactose);
    List<Receita> findReceitasByFlagVegetariano(boolean flagVegetariano);
    List<Receita> findReceitasByFlagDoce(boolean flagDoce);
    List<Receita> findReceitasByFlagSalgado(boolean flagSalgado);
}
