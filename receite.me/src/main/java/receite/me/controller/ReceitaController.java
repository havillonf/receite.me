package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import receite.me.model.Ingrediente;
import receite.me.model.Receita;
import receite.me.service.IngredienteService;

import java.util.List;

@RestController
@RequestMapping("ingredientes")
@RequiredArgsConstructor
public class IngredienteController {
    private final IngredienteService ingredienteService;

    @GetMapping
    public ResponseEntity<List<Ingrediente>> list(){
        return ResponseEntity.ok(ingredienteService.list());
    }

    @GetMapping("/{nome}")
    public ResponseEntity<List<Ingrediente>> findByName(@PathVariable("nome") String nome){
        return ResponseEntity.ok(ingredienteService.findByNome(nome));
    }
}
