package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import receite.me.dto.UsuarioDto;
import receite.me.mapper.UsuarioMapper;
import receite.me.model.ResetarSenhaInfo;
import receite.me.service.UsuarioService;
import receite.me.factory.ProblemFactory;

import static org.springframework.http.ResponseEntity.created;
import static org.springframework.web.servlet.support.ServletUriComponentsBuilder.fromCurrentRequest;

@RestController
@RequestMapping("usuarios")
@RequiredArgsConstructor
public class UsuarioController {
    @Autowired
    private final UsuarioService usuarioService;
    private final UsuarioMapper usuarioMapper;
    private final ProblemFactory problemFactory;

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
    public ResponseEntity<?> create(@RequestBody UsuarioDto usuarioDto){
        try {
            return created(fromCurrentRequest()
                    .path("/{id}")
                    .buildAndExpand(usuarioService.create(usuarioMapper.toEntity(usuarioDto))).toUri())
                    .build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    problemFactory.createProblem(e.getMessage(), HttpStatus.BAD_REQUEST));
        }
    }

    @PatchMapping("/update")
    public ResponseEntity<?> update(@RequestBody UsuarioDto usuarioDto){
        if (usuarioService.findById(usuarioDto.getId()).isPresent()){
            usuarioService.update(usuarioMapper.toEntity(usuarioDto));
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
            usuarioService.resetPassword(newPasswordData, true);
            return ResponseEntity.ok().build();
        }catch(Exception e){
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/resetWithoutCode")
    public ResponseEntity<?> resetPasswordWithoutCode(@RequestBody ResetarSenhaInfo newPasswordData) {
        try {
            usuarioService.resetPassword(newPasswordData, false);
            return ResponseEntity.ok().build();
        }catch(Exception e){
            return ResponseEntity.notFound().build();
        }
    }
}
