package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import receite.me.model.Ingrediente;
import receite.me.model.ResetarSenhaInfo;
import receite.me.model.Problem;
import receite.me.model.Usuario;
import receite.me.service.IngredienteService;
import receite.me.service.UsuarioService;

import java.time.LocalDateTime;
import java.util.List;

import static org.springframework.http.ResponseEntity.created;
import static org.springframework.web.servlet.support.ServletUriComponentsBuilder.fromCurrentRequest;

@RestController
@RequestMapping("usuarios")
@RequiredArgsConstructor
public class UsuarioController {
    @Autowired
    private final UsuarioService usuarioService;
    @GetMapping("/{id}")
    public ResponseEntity<?> findById(@PathVariable Long id){
        var usuarioOpt = usuarioService.findById(id);
        if(usuarioOpt.isPresent()){
            return ResponseEntity.ok(usuarioOpt.get());
        }
        return ResponseEntity.notFound().build();
    }
    @GetMapping("/findByEmail/{email}")
    public ResponseEntity<?> findByEmail(@PathVariable String email){
        var usuarioOpt = usuarioService.findByEmail(email);
        if(usuarioOpt.isPresent()){
            return ResponseEntity.ok(usuarioOpt.get());
        }
        return ResponseEntity.notFound().build();
    }
    @PostMapping
    public ResponseEntity<?> create(@RequestBody Usuario usuario){
        try {
            return created(fromCurrentRequest()
                    .path("/{id}")
                    .buildAndExpand(usuarioService.create(usuario)).toUri())
                    .build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Problem.builder().status(400).exception(e.getMessage()).ocurredAt(LocalDateTime.now()).build());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Usuario usuario){
        var usr = usuarioService.findByEmail(usuario.getEmail());
        if(usr.isPresent()){
            if(usr.get().getSenha().equals(usuario.getSenha())){
                return ResponseEntity.ok(usr);
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

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id){
        try{
            usuarioService.delete(id);
            return ResponseEntity.ok().build();
        }catch(Exception e){
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/request_reset/{email}")
    public ResponseEntity<?> requestPasswordReset(@PathVariable String email){
        try {
            usuarioService.requestPasswordReset(email);
            return ResponseEntity.ok().build();
        }catch(Exception e){
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/reset")
    public ResponseEntity<?> resetPassword(@RequestBody ResetarSenhaInfo newPasswordData) {
        try {
            usuarioService.resetPassword(newPasswordData);
            return ResponseEntity.ok().build();
        }catch(Exception e){
            return ResponseEntity.notFound().build();
        }
    }
}