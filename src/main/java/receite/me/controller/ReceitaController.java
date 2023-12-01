package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import receite.me.model.Ingrediente;
import receite.me.model.Problem;
import receite.me.model.Receita;
import receite.me.service.IngredienteService;
import receite.me.service.ReceitaService;

import java.time.LocalDateTime;
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
    public ResponseEntity<?> list(){
        try{
            return ResponseEntity.ok(receitaService.list());
        }catch (Exception e){
            return ResponseEntity.notFound().build();
        }
    }
    @GetMapping("/findById/{id}")
    public ResponseEntity<?> findById(@PathVariable("id") Long id){
        try{
            return ResponseEntity.ok(receitaService.findById(id));
        }catch (Exception e){
            return ResponseEntity.badRequest().body(
                    Problem.builder().status(400).exception(e.getMessage()).ocurredAt(LocalDateTime.now()).build());
        }
    }
    @GetMapping("/{nome}")
    public ResponseEntity<?> findByName(@PathVariable("nome") String nome){
        try {
            return ResponseEntity.ok(receitaService.findByNome(nome));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Problem.builder().status(400).exception(e.getMessage()).ocurredAt(LocalDateTime.now()).build());
        }
    }
    @PostMapping("/filtro")
    public ResponseEntity<?> findByIngredientes(@RequestBody List<String> ingredientes){
        try {
            return ResponseEntity.ok(receitaService.findByIngredientes(ingredientes));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Problem.builder().status(400).exception(e.getMessage()).ocurredAt(LocalDateTime.now()).build());
        }
    }
    @GetMapping("/filtro/{categoria}")
    public ResponseEntity<?> findByCategoria(@PathVariable("categoria") String categoria){
        try {
            return ResponseEntity.ok(receitaService.findByFlag(categoria));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Problem.builder().status(400).exception(e.getMessage()).ocurredAt(LocalDateTime.now()).build());
        }
    }
    @GetMapping("recomendacoes")
    public ResponseEntity<?> recomendacoes(){
        try {
            return ResponseEntity.ok(new HashSet<>(receitaService.list().subList(0,10)));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Problem.builder().status(400).exception(e.getMessage()).ocurredAt(LocalDateTime.now()).build());
        }
    }
}
