package receite.me.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import receite.me.model.ResetPasswordData;
import receite.me.model.Usuario;
import receite.me.repository.UsuarioRepository;
import java.util.concurrent.ThreadLocalRandom;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UsuarioService {
    private final UsuarioRepository usuarioRepository;

    @Autowired
    private EmailSenderService emailSender;

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

    public void requestPasswordReset(String email) {
        Usuario user = findByEmail(email).orElseThrow();
        user.setCodigoSenha(
                Integer.toString(ThreadLocalRandom.current().nextInt(100000, 999999 + 1))
        );
        emailSender.sendEmail(
                email,
                "Recuperação de senha Receite.me",
                "Código de recuperação: " + user.getCodigoSenha() + "\n\n"
        );
    }

    public void resetPassword(ResetPasswordData newPasswordData) throws Exception {
        Usuario user = usuarioRepository.findByEmail(newPasswordData.getEmail()).orElseThrow();
        if (!newPasswordData.getCodigo().equals(user.getCodigoSenha()))
            throw new Exception();

        user.setSenha(newPasswordData.getPassword());
        usuarioRepository.save(user);
    }
}
