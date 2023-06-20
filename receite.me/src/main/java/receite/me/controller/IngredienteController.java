package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import receite.me.model.Ingrediente;
import receite.me.service.IngredienteService;

import java.util.List;

@RestController
@RequestMapping("Ingredientes")
@RequiredArgsConstructor
public class IngredienteController {
    private final IngredienteService ingredienteService;

    @GetMapping
    public ResponseEntity<List<Ingrediente>> list(){
        return ResponseEntity.ok(ingredienteService.list());
    }
}
