package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import receite.me.model.Ingrediente;
import receite.me.model.Receita;
import receite.me.service.IngredienteService;
import receite.me.service.ReceitaService;

import java.util.List;

@RestController
@RequestMapping("receitas")
@RequiredArgsConstructor
public class ReceitaController {
    private final ReceitaService receitaService;
    @GetMapping
    public ResponseEntity<List<Receita>> list(){
        return ResponseEntity.ok(receitaService.list());
    }
    @GetMapping("/{nome}")
    public ResponseEntity<List<Receita>> findByName(@PathVariable("nome") String nome){
        return ResponseEntity.ok(receitaService.findByNome(nome));
    }
    @GetMapping("/filtro")
    public ResponseEntity<List<Receita>> findByIngredientes(@RequestBody List<String> ingredientes){
        return ResponseEntity.ok(receitaService.findByIngredientes(ingredientes));
    }
}
