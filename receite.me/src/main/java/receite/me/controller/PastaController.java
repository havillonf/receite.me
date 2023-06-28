package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import receite.me.model.Receita;
import receite.me.service.PastaService;
import receite.me.service.ReceitaService;

import java.util.List;

@RestController
@RequestMapping("pastas")
@RequiredArgsConstructor
public class PastaController {
    private final PastaService pastaService;
    private final ReceitaService receitaService;
    @PostMapping("/{idReceita}/{idUsuario}")
    public ResponseEntity<Void> alterarFavorito(@PathVariable("idReceita") Long idReceita, @PathVariable("idUsuario") Long idUsuario){
        try{
            var pasta = pastaService.findPastaFavoritaByUsuario(idUsuario);
            var receita = receitaService.findById(idReceita);
            if(pasta.getReceitas().contains(receita)){
                pasta.getReceitas().remove(receita);
            }else {
                pasta.getReceitas().add(receita);
            }
            pastaService.updatePasta(pasta);
            return ResponseEntity.ok().build();
        }catch (Exception e){
            System.out.printf("erro: "+e.getMessage());
            return ResponseEntity.notFound().build();
        }
    }
}
