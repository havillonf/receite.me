package receite.me.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import receite.me.dto.PastaDto;
import receite.me.dto.ResponseDto;
import receite.me.mapper.PastaMapper;
import receite.me.mapper.ReceitaMapper;
import receite.me.model.Pasta;
import receite.me.service.PastaService;
import receite.me.service.ReceitaService;

import java.util.stream.Collectors;

@RestController
@RequestMapping("pastas")
@RequiredArgsConstructor
public class PastaController {
    private final PastaService pastaService;
    private final ReceitaService receitaService;
    private final PastaMapper pastaMapper;
    private final ReceitaMapper receitaMapper;

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
        return ResponseEntity.ok(pastaService.list().stream()
                .filter(pasta -> pasta.getUsuarioId().equals(idUsuario))
                .collect(Collectors.toList()));
    }

    @GetMapping("/favoritos/{idUsuario}")
    public ResponseEntity<?> getFavoritos(@PathVariable("idUsuario") Long idUsuario){
        return ResponseEntity.ok(pastaService.findPastaFavoritaByUsuario(idUsuario).getReceitas());
    }

    @PostMapping("/{idReceita}/{idUsuario}")
    public ResponseEntity<?> alterarFavorito(@PathVariable("idReceita") Long idReceita, @PathVariable("idUsuario") Long idUsuario){
        try{
            var body = true;
            PastaDto pastaDto = pastaService.findPastaFavoritaByUsuario(idUsuario);
            Pasta pasta = pastaMapper.toEntity(pastaDto);
            var receita = receitaMapper.toEntity(receitaService.findById(idReceita));

            if(pasta.getReceitas().stream().anyMatch(r -> r.getId().equals(idReceita))){
                pasta.getReceitas().removeIf(r -> r.getId().equals(idReceita));
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
    public ResponseEntity<?> createPasta(@PathVariable("idUsuario") Long idUsuario, @RequestBody PastaDto pastaDto){
        try{
            pastaDto.setUsuarioId(idUsuario);
            pastaDto.setFlagFavorito(false);
            return ResponseEntity.ok(pastaService.createPasta(pastaMapper.toEntity(pastaDto)));
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

    @PostMapping("/add-receita/{idPasta}/{idReceita}")
    public ResponseEntity<?> addReceitaById(@PathVariable("idPasta") Long idPasta, @PathVariable("idReceita") Long idReceita){
        try{
            Pasta pasta = pastaMapper.toEntity(pastaService.findById(idPasta));
            var receita = receitaMapper.toEntity(receitaService.findById(idReceita));
            pasta.getReceitas().add(receita);
            pastaService.updatePasta(pasta);
            return ResponseEntity.ok().build();
        }catch(Exception e){
            return ResponseEntity.badRequest().build();
        }
    }
}
