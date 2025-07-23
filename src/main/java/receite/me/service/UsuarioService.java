package receite.me.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.security.crypto.password.PasswordEncoder;
import receite.me.dto.UsuarioDto;
import receite.me.mapper.UsuarioMapper;
import receite.me.model.ResetarSenhaInfo;
import receite.me.model.Usuario;
import receite.me.repository.UsuarioRepository;
import java.util.concurrent.ThreadLocalRandom;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UsuarioService {
    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final UsuarioMapper usuarioMapper;

    @Autowired
    private EmailSenderService emailSender;

    public Optional<UsuarioDto> findByEmail(String email){
        return usuarioRepository.findByEmail(email).map(usuarioMapper::toDto);
    }
    public Long create(Usuario usuario){
        return usuarioRepository.save(usuario).getId();
    }
    public Optional<UsuarioDto> findById(Long id){
        return usuarioRepository.findById(id).map(usuarioMapper::toDto);
    }
    public void update(Usuario usuario){
        usuarioRepository.save(usuario);
    }
    public void delete(Long id){
        usuarioRepository.delete(this.usuarioRepository.findById(id).orElseThrow());
    }

    public void requestPasswordReset(String email) {
        Usuario user = usuarioRepository.findByEmail(email).orElseThrow();
        user.setCodigoSenha(
                Integer.toString(ThreadLocalRandom.current().nextInt(100000, 999999 + 1))
        );
        usuarioRepository.save(user);
        emailSender.sendEmail(
                email,
                "Recuperação de senha Receite.me",
                "Código de recuperação: " + user.getCodigoSenha() + "\n\n"
        );
    }

    public void resetPassword(ResetarSenhaInfo newPasswordData, boolean needsCode) throws Exception {
        Usuario user = usuarioRepository.findByEmail(newPasswordData.getEmail()).orElseThrow();
        if (needsCode) {
            if (!newPasswordData.getCodigo().equals(user.getCodigoSenha()))
                throw new Exception();
        }
        
        user.setSenha(passwordEncoder.encode(newPasswordData.getNovaSenha()));
        usuarioRepository.save(user);
    }
}
