package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import receite.me.model.Ingrediente;
import receite.me.model.Problem;
import receite.me.service.IngredienteService;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("ingredientes")
@RequiredArgsConstructor
public class IngredienteController {
    private final IngredienteService ingredienteService;

    @GetMapping
    public ResponseEntity<?> list(){
        try {
            return ResponseEntity.ok(ingredienteService.list());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Problem.builder().status(400).exception(e.getMessage()).ocurredAt(LocalDateTime.now()).build());
        }
    }

    @GetMapping("/{nome}")
    public ResponseEntity<?> findByName(@PathVariable("nome") String nome){
        try {
            return ResponseEntity.ok(ingredienteService.findByNome(nome));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
            Problem.builder().status(400).exception(e.getMessage()).ocurredAt(LocalDateTime.now()).build());
        }
    }

}
