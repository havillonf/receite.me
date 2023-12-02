package receite.me.service;

import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import receite.me.auth.AuthenticationRequest;
import receite.me.auth.AuthenticationResponse;
import receite.me.auth.RegisterRequest;
import receite.me.config.JwtService;
import receite.me.model.Usuario;
import receite.me.model.usuario.Cargo;
import receite.me.repository.UsuarioRepository;

@Service
@RequiredArgsConstructor
public class AuthenticationService {
    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    public AuthenticationResponse register(RegisterRequest request){
        Usuario usuario = Usuario.builder()
                .email(request.getEmail())
                .nome(request.getNome())
                .senha(passwordEncoder.encode(request.getSenha()))
                .avatar(request.getAvatar())
                .bio(request.getBio())
                .cargo(Cargo.USER)
                .build();
        usuarioRepository.save(usuario).getId();
        var jwt = jwtService.generateToken(usuario);
        return AuthenticationResponse.builder().token(jwt).build();
    }

    public AuthenticationResponse authenticate(AuthenticationRequest request) throws UsernameNotFoundException {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getSenha()
                )
        );
        var usuario = usuarioRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new UsernameNotFoundException(""));
        var jwt = jwtService.generateToken(usuario);
        return AuthenticationResponse.builder().token(jwt).user(usuario).build();
    }

}
