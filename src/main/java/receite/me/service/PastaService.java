package receite.me.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import receite.me.dto.PastaDto;
import receite.me.mapper.PastaMapper;
import receite.me.model.Pasta;
import receite.me.repository.PastaRepository;
import receite.me.repository.UsuarioRepository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PastaService {
    private final PastaRepository pastaRepository;
    private final UsuarioRepository usuarioRepository;
    private final PastaMapper pastaMapper;

    public PastaDto findPastaFavoritaByUsuario(Long idUsuario){
        return pastaMapper.toDto(pastaRepository.findPastaByFlagFavoritoAndUsuario(true, usuarioRepository.findById(idUsuario).get()));
    }
    public void updatePasta(Pasta pasta){
        pastaRepository.save(pasta);
    }
    public Long createPasta(Pasta pasta){
        return pastaRepository.save(pasta).getId();
    }
    public PastaDto findById(Long id){
        Optional<Pasta> pastaOptional = pastaRepository.findById(id);
        return pastaOptional.map(pastaMapper::toDto).orElse(null);
    }
    public List<PastaDto> list(){
        return pastaRepository.findAll().stream()
                .map(pastaMapper::toDto).collect(Collectors.toList());
    }
}
