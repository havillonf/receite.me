package receite.me.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import receite.me.dto.IngredienteDto;
import receite.me.mapper.IngredienteMapper;
import receite.me.repository.IngredienteRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class IngredienteService {
    private final IngredienteRepository ingredienteRepository;
    private final IngredienteMapper ingredienteMapper;

    public List<IngredienteDto> list(){
        return ingredienteRepository.findAll().stream()
                .map(ingredienteMapper::toDto).collect(Collectors.toList());
    }

    public IngredienteDto findById(Long id){
        return ingredienteRepository.findById(id).map(ingredienteMapper::toDto)
                .orElseThrow(()-> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ingrediente não encontrado."));
    }

    public List<IngredienteDto> findByNome(String nome){
        return ingredienteRepository.findByNomeContainingIgnoreCase(nome).stream()
                .map(ingredienteMapper::toDto).collect(Collectors.toList());
    }

    public List<IngredienteDto> findByExactNome(String nome){
        return ingredienteRepository.findByNomeContainingIgnoreCase(nome).stream()
                .map(ingredienteMapper::toDto).collect(Collectors.toList());
    }
}
