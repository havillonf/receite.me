package receite.me.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.server.ResponseStatusException;
import receite.me.model.Ingrediente;
import receite.me.model.Pasta;
import receite.me.repository.IngredienteRepository;
import receite.me.repository.PastaRepository;
import receite.me.repository.UsuarioRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class PastaService {
    private final PastaRepository pastaRepository;
    private final UsuarioRepository usuarioRepository;
    public Pasta findPastaFavoritaByUsuario(Long idUsuario){
        return pastaRepository.findPastaByFlagFavoritoAndUsuario(true, usuarioRepository.findById(idUsuario).get());
    }
    public void updatePasta(Pasta pasta){
        pastaRepository.save(pasta);
    }
    public Long createPasta(Pasta pasta){
        return pastaRepository.save(pasta).getId();
    }
    public Pasta findById(Long id){
        Optional<Pasta> pastaOptional = pastaRepository.findById(id);
        return pastaOptional.orElse(null);
    }
    public List<Pasta> list(){
        return pastaRepository.findAll();
    }
}
