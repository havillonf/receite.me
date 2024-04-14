package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import receite.me.dto.ResponseDto;
import receite.me.model.Pasta;
import receite.me.model.Receita;
import receite.me.service.PastaService;
import receite.me.service.ReceitaService;
import receite.me.service.UsuarioService;

import java.util.List;

@RestController
@RequestMapping("pastas")
@RequiredArgsConstructor
public class PastaController {
    private final PastaService pastaService;
    private final ReceitaService receitaService;
    private final UsuarioService usuarioService;
    @GetMapping("/list/{id}")
    public ResponseEntity<?> listPastas(){
        return ResponseEntity.ok(pastaService.list());
    }
    @GetMapping("/{idPasta}")
    public ResponseEntity<?> getPasta(@PathVariable("idPasta") Long idPasta){
        try{
            return ResponseEntity.ok(pastaService.findById(idPasta));
        }catch (Exception e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    @GetMapping("/list-usuario/{idUsuario}")
    public ResponseEntity<?> getPastasOfUser(@PathVariable("idUsuario") Long idUsuario){
        List<Pasta> pastas = pastaService.list()
                .stream()
                .filter(pasta -> pasta.getUsuario().getId().equals(idUsuario))
                .toList();
        return ResponseEntity.ok(pastas);
    }
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

    @PostMapping("/create/{idUsuario}")
    public ResponseEntity<?> createPasta(@PathVariable("idUsuario") Long idUsuario, @RequestBody Pasta pasta){
        try{
            pasta.setUsuario(usuarioService.findById(idUsuario).get());
            pasta.setFlagFavorito(false);
            return ResponseEntity.ok(pastaService.createPasta(pasta));
        }catch (Exception e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/{idPasta}/receitas")
    public ResponseEntity<?> getReceitasByPasta(@PathVariable("idPasta") Long idPasta){
        try{
            return ResponseEntity.ok(pastaService.findById(idPasta).getReceitas());
        }catch (Exception e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
