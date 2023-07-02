package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import receite.me.model.Ingrediente;
import receite.me.model.Receita;
import receite.me.service.IngredienteService;
import receite.me.service.ReceitaService;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("receitas")
@RequiredArgsConstructor
public class ReceitaController {
    private final ReceitaService receitaService;
    @GetMapping
    public ResponseEntity<List<Receita>> list(){
        return ResponseEntity.ok(receitaService.list());
    }
    @GetMapping("/findById/{id}")
    public ResponseEntity<?> findById(@PathVariable("id") Long id){
        try{
            return ResponseEntity.ok(receitaService.findById(id));
        }catch (Exception e){
            return ResponseEntity.notFound().build();
        }
    }
    @GetMapping("/{nome}")
    public ResponseEntity<List<Receita>> findByName(@PathVariable("nome") String nome){
        return ResponseEntity.ok(receitaService.findByNome(nome));
    }
    @PostMapping("/filtro")
    public ResponseEntity<List<Receita>> findByIngredientes(@RequestBody List<String> ingredientes){
        return ResponseEntity.ok(receitaService.findByIngredientes(ingredientes));
    }
    @GetMapping("/filtro/{categoria}")
    public ResponseEntity<?> findByCategoria(@PathVariable("categoria") String categoria){
        return ResponseEntity.ok(receitaService.findByFlag(categoria));
    }
    @GetMapping("recomendacoes")
    public ResponseEntity<?> recomendacoes(){
        return ResponseEntity.ok(new HashSet<>(receitaService.list().subList(0,10)));
    }
}
