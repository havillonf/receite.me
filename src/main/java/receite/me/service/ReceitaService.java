package receite.me.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import receite.me.dto.ReceitaDto;
import receite.me.mapper.ReceitaMapper;
import receite.me.model.Ingrediente;
import receite.me.repository.IngredienteRepository;
import receite.me.repository.ReceitaRepository;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReceitaService {
    private final IngredienteRepository ingredienteRepository;
    private final ReceitaRepository receitaRepository;
    private final ReceitaMapper receitaMapper;

    public List<ReceitaDto> list(){
        return receitaRepository.findAll().stream()
                .map(receitaMapper::toDto).collect(Collectors.toList());
    }

    public ReceitaDto findById(Long id){
        return receitaRepository.findById(id).map(receitaMapper::toDto)
                .orElseThrow(()-> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Receita não encontrada."));
    }

    public List<ReceitaDto> findByNome(String nome){
        return receitaRepository.findByNomeContainingIgnoreCase(nome).stream()
                .map(receitaMapper::toDto).collect(Collectors.toList());
    }

    public List<ReceitaDto> findByIngredientes(List<String> nomeIngredientes) {
        Set<Ingrediente> ingredientes = new HashSet<>();
        nomeIngredientes.forEach(ingrediente -> {
            ingredientes.add(ingredienteRepository.findByNome(ingrediente).get());
        });
        var receitas = receitaRepository.findAll().stream().filter(receita -> ingredientes.containsAll(receita.getIngredientes()));
        return receitas.map(receitaMapper::toDto).collect(Collectors.toList());
    }

    public List<ReceitaDto> findByFlag(String categoria){
        return switch (categoria) {
            case "gluten" -> this.findByFlagGluten(true);
            case "lactose" -> this.findByFlagLactose(false);
            case "vegetariano" -> this.findByFlagVegetariano(true);
            case "doce" -> this.findByFlagDoce(true);
            case "salgado" -> this.findByFlagSalgado(true);
            default -> null;
        };
    }

    private List<ReceitaDto> findByFlagSalgado(boolean b) {
        return receitaRepository.findReceitasByFlagSalgado(b).stream()
                .map(receitaMapper::toDto).collect(Collectors.toList());
    }
    private List<ReceitaDto> findByFlagDoce(boolean b) {
        return receitaRepository.findReceitasByFlagDoce(b).stream()
                .map(receitaMapper::toDto).collect(Collectors.toList());
    }

    public List<ReceitaDto> findByFlagGluten(boolean flagGluten){
        return receitaRepository.findReceitasByFlagGluten(flagGluten).stream()
                .map(receitaMapper::toDto).collect(Collectors.toList());
    }
    public List<ReceitaDto> findByFlagLactose(boolean flagLactose){
        return receitaRepository.findReceitasByFlagLactose(flagLactose).stream()
                .map(receitaMapper::toDto).collect(Collectors.toList());
    }
    public List<ReceitaDto> findByFlagVegetariano(boolean flagVegetariano){
        return receitaRepository.findReceitasByFlagVegetariano(flagVegetariano).stream()
                .map(receitaMapper::toDto).collect(Collectors.toList());
    }
}
