package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import receite.me.service.ReceitaService;
import receite.me.factory.ProblemFactory;

import java.util.HashSet;
import java.util.List;

@RestController
@RequestMapping("receitas")
@RequiredArgsConstructor
public class ReceitaController {
    private final ReceitaService receitaService;
    private final ProblemFactory problemFactory;

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
                    problemFactory.createBadRequest(e.getMessage()));
        }
    }
    @GetMapping("/{nome}")
    public ResponseEntity<?> findByName(@PathVariable("nome") String nome){
        try {
            return ResponseEntity.ok(receitaService.findByNome(nome));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    problemFactory.createBadRequest(e.getMessage()));
        }
    }
    @PostMapping("/filtro")
    public ResponseEntity<?> findByIngredientes(@RequestBody List<String> ingredientes){
        try {
            return ResponseEntity.ok(receitaService.findByIngredientes(ingredientes));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    problemFactory.createBadRequest(e.getMessage()));
        }
    }
    @GetMapping("/filtro/{categoria}")
    public ResponseEntity<?> findByCategoria(@PathVariable("categoria") String categoria){
        try {
            return ResponseEntity.ok(receitaService.findByFlag(categoria));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    problemFactory.createBadRequest(e.getMessage()));
        }
    }
    @GetMapping("recomendacoes")
    public ResponseEntity<?> recomendacoes(){
        try {
            return ResponseEntity.ok(new HashSet<>(receitaService.list().subList(0,10)));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    problemFactory.createBadRequest(e.getMessage()));
        }
    }
}
