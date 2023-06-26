package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import receite.me.model.Ingrediente;
import receite.me.model.Usuario;
import receite.me.service.IngredienteService;
import receite.me.service.UsuarioService;

import java.util.List;

import static org.springframework.http.ResponseEntity.created;
import static org.springframework.web.servlet.support.ServletUriComponentsBuilder.fromCurrentRequest;

@RestController
@RequestMapping("usuario")
@RequiredArgsConstructor
public class UsuarioController {
    private final UsuarioService usuarioService;
    @GetMapping("/{id}")
    public ResponseEntity<?> findById(Long id){
        var usuarioOpt = usuarioService.findById(id);
        if(usuarioOpt.isPresent()){
            return ResponseEntity.ok(usuarioOpt.get());
        }
        return ResponseEntity.notFound().build();
    }
    @GetMapping("/findByEmail/{email}")
    public ResponseEntity<?> findByEmail(String email){
        var usuarioOpt = usuarioService.findByEmail(email);
        if(usuarioOpt.isPresent()){
            return ResponseEntity.ok(usuarioOpt.get());
        }
        return ResponseEntity.notFound().build();
    }
    @PostMapping
    public ResponseEntity<Void> create(@RequestBody Usuario usuario){
        return created(fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(usuarioService.create(usuario)).toUri())
                .build();
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Usuario usuario){
        var usr = usuarioService.findByEmail(usuario.getEmail());
        if(usr.isPresent()){
            if(usr.get().getSenha().equals(usuario.getSenha())){
                return ResponseEntity.ok().build();
            }else{
                return ResponseEntity.badRequest().build();
            }
        }else{
            return ResponseEntity.notFound().build();
        }
    }

    @PatchMapping("/update")
    public ResponseEntity<?> update(@RequestBody Usuario usuario){
        if (usuarioService.findById(usuario.getId()).isPresent()){
            usuarioService.update(usuario);
            return ResponseEntity.ok().build();
        }else{
            return ResponseEntity.notFound().build();
        }
    }
}
