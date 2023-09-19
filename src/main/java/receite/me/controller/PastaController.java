package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import receite.me.dto.ResponseDto;
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
    @GetMapping("/favoritos/{idUsuario}")
    public ResponseEntity<?> getFavoritos(@PathVariable("idUsuario") Long idUsuario){
        return ResponseEntity.ok(pastaService.findPastaFavoritaByUsuario(idUsuario).getReceitas());
    }
    @PostMapping("/{idReceita}/{idUsuario}")
    public ResponseEntity<?> alterarFavorito(@PathVariable("idReceita") Long idReceita, @PathVariable("idUsuario") Long idUsuario){
        try{
            var body = true;
            var pasta = pastaService.findPastaFavoritaByUsuario(idUsuario);
            var receita = receitaService.findById(idReceita);
            if(pasta.getReceitas().contains(receita)){
                pasta.getReceitas().remove(receita);
                body = false;
            }else {
                pasta.getReceitas().add(receita);
            }
            pastaService.updatePasta(pasta);
            return ResponseEntity.ok(ResponseDto.builder().message(body).build());
        }catch (Exception e){
            return ResponseEntity.notFound().build();
        }
    }
}
