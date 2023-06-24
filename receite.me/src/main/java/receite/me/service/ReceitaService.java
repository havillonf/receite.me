package receite.me.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import receite.me.model.Ingrediente;
import receite.me.model.Receita;
import receite.me.repository.IngredienteRepository;
import receite.me.repository.ReceitaRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReceitaService {
    private final ReceitaRepository receitaRepository;
    public List<Receita> list(){
        return receitaRepository.findAll();
    }

    public Receita findById(Long id){
        return receitaRepository.findById(id)
                .orElseThrow(()-> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Receita não encontrada."));
    }

    public List<Receita> findByNome(String nome){
        return receitaRepository.findByNomeContainingIgnoreCase(nome);
    }
}
