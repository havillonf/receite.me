package receite.me.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import receite.me.model.Ingrediente;
import receite.me.repository.IngredienteRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class IngredienteService {
    private final IngredienteRepository ingredienteRepository;
    public List<Ingrediente> list(){
        return ingredienteRepository.findAll();
    }

    public Ingrediente findById(Long id){
        return ingredienteRepository.findById(id)
                .orElseThrow(()-> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ingrediente não encontrado."));
    }

    public List<Ingrediente> findByNome(String nome){
        return ingredienteRepository.findByNomeContainingIgnoreCase(nome);
    }
}
