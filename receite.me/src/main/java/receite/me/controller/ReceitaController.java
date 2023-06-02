package receite.me.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import receite.me.model.Receita;

import java.util.List;

@RestController
@RequestMapping("receita")
@CrossOrigin("*")
public class ReceitaController {
    @GetMapping("list")
    public List<Receita> list (){
        return List.of(Receita.builder()
                .nome("Guacamole")
                        .caloriasTotais(20)
                        .carboidratosTotais(10)
                        .doce(false)
                        .gluten(true)
                        .gordurasTotais(100)
                        .lactose(true)
                        .pathImagem("img/guacamole")
                        .preparo("Preparo da guacamole")
                        .proteinasTotais(10)
                        .salgado(true)
                        .tempoPreparo(1000)
                        .vegetariano(false)
                .build());
    }
}
