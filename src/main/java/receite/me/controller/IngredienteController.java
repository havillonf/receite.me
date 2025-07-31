package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import receite.me.service.IngredienteService;
import receite.me.factory.ProblemFactoryImpl;

@RestController
@RequestMapping("ingredientes")
@RequiredArgsConstructor
public class IngredienteController {
    private final IngredienteService ingredienteService;
    private final ProblemFactoryImpl problemFactoryImpl;

    @GetMapping
    public ResponseEntity<?> list(){
        try {
            return ResponseEntity.ok(ingredienteService.list());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    problemFactoryImpl.createProblem(e.getMessage(), HttpStatus.BAD_REQUEST));
        }
    }

    @GetMapping("/{nome}")
    public ResponseEntity<?> findByName(@PathVariable("nome") String nome){
        try {
            return ResponseEntity.ok(ingredienteService.findByNome(nome));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    problemFactoryImpl.createProblem(e.getMessage(), HttpStatus.BAD_REQUEST));
        }
    }

}
