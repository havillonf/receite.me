package receite.me.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import receite.me.model.Usuario;
import receite.me.repository.UsuarioRepository;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UsuarioService {
    private final UsuarioRepository usuarioRepository;
    public Optional<Usuario> findByEmail(String email){
        return usuarioRepository.findByEmail(email);
    }
    public Long create(Usuario usuario){
        return usuarioRepository.save(usuario).getId();
    }
    public Optional<Usuario> findById(Long id){
        return usuarioRepository.findById(id);
    }
    public void update(Usuario usuario){
        usuarioRepository.save(usuario);
    }
    public void delete(Long id){
        usuarioRepository.delete(this.findById(id).orElseThrow());
    }
}